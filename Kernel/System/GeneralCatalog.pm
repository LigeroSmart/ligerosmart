# --
# Kernel/System/GeneralCatalog.pm - all general catalog functions
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::GeneralCatalog;

use strict;
use warnings;

use Kernel::System::Valid;
use Kernel::System::CheckItem;
use Kernel::System::CacheInternal;

=head1 NAME

Kernel::System::GeneralCatalog - general catalog lib

=head1 SYNOPSIS

All general catalog functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::GeneralCatalog;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $GeneralCatalogObject = Kernel::System::GeneralCatalog->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        MainObject   => $MainObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(DBObject ConfigObject EncodeObject LogObject MainObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }
    $Self->{ValidObject}     = Kernel::System::Valid->new( %{$Self} );
    $Self->{CheckItemObject} = Kernel::System::CheckItem->new( %{$Self} );

    # load generator preferences module
    my $GeneratorModule = $Self->{ConfigObject}->Get('GeneralCatalog::PreferencesModule')
        || 'Kernel::System::GeneralCatalog::PreferencesDB';
    if ( $Self->{MainObject}->Require($GeneratorModule) ) {
        $Self->{PreferencesObject} = $GeneratorModule->new(%Param);
    }

    # create CacheInternal object
    $Self->{CacheInternalObject} = Kernel::System::CacheInternal->new(
        %{$Self},
        Type => 'GeneralCatalog',
        TTL  => 60 * 60 * 3,
    );

    return $Self;
}

=item ClassList()

return an array reference of all general catalog classes

    my $ArrayRef = $GeneralCatalogObject->ClassList();

=cut

sub ClassList {
    my ( $Self, %Param ) = @_;

    # ask database
    $Self->{DBObject}->Prepare(
        SQL => 'SELECT DISTINCT(general_catalog_class) '
            . 'FROM general_catalog ORDER BY general_catalog_class',
    );

    # fetch the result
    my @ClassList;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @ClassList, $Row[0];
    }

    # cache the result
    my $CacheKey = 'ClassList';
    $Self->{CacheInternalObject}->Set(
        Key   => $CacheKey,
        Value => \@ClassList,
    );

    return \@ClassList;
}

=item ClassRename()

rename a general catalog class

    my $True = $GeneralCatalogObject->ClassRename(
        ClassOld => 'ITSM::ConfigItem::State',
        ClassNew => 'ITSM::ConfigItem::DeploymentState',
    );

=cut

sub ClassRename {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(ClassOld ClassNew)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # cleanup given params
    for my $Argument (qw(ClassOld ClassNew)) {
        $Self->{CheckItemObject}->StringClean(
            StringRef         => \$Param{$Argument},
            RemoveAllNewlines => 1,
            RemoveAllTabs     => 1,
            RemoveAllSpaces   => 1,
        );
    }

    return 1 if $Param{ClassNew} eq $Param{ClassOld};

    # check if new class name already exists
    $Self->{DBObject}->Prepare(
        SQL   => 'SELECT id FROM general_catalog WHERE general_catalog_class = ?',
        Bind  => [ \$Param{ClassNew} ],
        Limit => 1,
    );

    # fetch the result
    my $AlreadyExists = 0;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $AlreadyExists = 1;
    }

    if ($AlreadyExists) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't rename class $Param{ClassOld}! New classname already exists."
        );
        return;
    }

    # reset cache
    $Self->{CacheInternalObject}->CleanUp();

    # rename general catalog class
    return $Self->{DBObject}->Do(
        SQL => 'UPDATE general_catalog SET general_catalog_class = ? '
            . 'WHERE general_catalog_class = ?',
        Bind => [ \$Param{ClassNew}, \$Param{ClassOld} ],
    );
}

=item ItemList()

returns a list as a hash reference of one general catalog class

    my $HashRef = $GeneralCatalogObject->ItemList(
        Class         => 'ITSM::Service::Type',
        Valid         => 0,                      # (optional) default 1
        Preferences   => {                       # (optional) default {}
            Permission => 2,                     # or whatever preferences can be used
        },
    );

=cut

sub ItemList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Class} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Class!'
        );
        return;
    }

    # set default value
    if ( !defined $Param{Valid} ) {
        $Param{Valid} = 1;
    }

    my $PreferencesCacheKey = '';
    my $PreferencesTable    = '';
    my $PreferencesWhere    = '';
    my @PreferencesBind;

    # handle given preferences
    if ( exists $Param{Preferences} && ref $Param{Preferences} eq 'HASH' ) {

        $PreferencesTable = ', general_catalog_preferences';
        my @Wheres;

        # add all preferences given to where-clause
        for my $Key ( sort keys %{ $Param{Preferences} } ) {

            if ( ref( $Param{Preferences}->{$Key} ) ne 'ARRAY' ) {
                $Param{Preferences}->{$Key} = [ $Param{Preferences}->{$Key} ];
            }

            push @Wheres, '(pref_key = ? AND pref_value IN ('
                . join( ', ', map {'?'} @{ $Param{Preferences}->{$Key} } )
                . '))';

            push @PreferencesBind, \$Key, map { \$_ } @{ $Param{Preferences}->{$Key} };

            # add functionality list to cache key
            $PreferencesCacheKey .= '####' if $PreferencesCacheKey;
            $PreferencesCacheKey .= join q{####}, $Key, map {$_} @{ $Param{Preferences}->{$Key} };
        }

        $PreferencesWhere
            = 'AND general_catalog.id = general_catalog_preferences.general_catalog_id';
        $PreferencesWhere .= ' AND ' . join ' AND ', @Wheres;
    }

    # create sql string
    my $SQL = "SELECT id, name FROM general_catalog $PreferencesTable "
        . "WHERE general_catalog_class = ? $PreferencesWhere ";
    my @BIND = ( \$Param{Class}, @PreferencesBind );

    # add valid string to sql string
    if ( $Param{Valid} ) {
        $SQL .= 'AND valid_id = 1 ';
    }

    # create cache key
    my $CacheKey
        = 'ItemList::' . $Param{Class} . '####' . $Param{Valid} . '####' . $PreferencesCacheKey;

    # check if result is already cached
    my $Cache = $Self->{CacheInternalObject}->Get( Key => $CacheKey );
    return $Cache if $Cache;

    # ask database
    $Self->{DBObject}->Prepare(
        SQL  => $SQL,
        Bind => \@BIND,
    );

    # fetch the result
    my %Data;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Data{ $Row[0] } = $Row[1];
    }

    # check item
    if ( !%Data ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Class $Param{Class} not found in database!",
        );
        return;
    }

    # cache the result
    $Self->{CacheInternalObject}->Set(
        Key   => $CacheKey,
        Value => \%Data,
    );

    return \%Data;
}

=item ItemGet()

get item attributes

    my $ItemDataRef = $GeneralCatalogObject->ItemGet(
        ItemID => 3,
    );

    or

    my $ItemDataRef = $GeneralCatalogObject->ItemGet(
        Class => 'ITSM::Service::Type',
        Name  => 'Underpinning Contract',
    );

returns

    my $Item = {
        'ItemID'     => '23',
        'Class'      => 'ITSM::Service::Type',
        'Name'       => 'Underpinning Contract'
        'Comment'    => 'Some Comment',
        'ValidID'    => '1',
        'CreateTime' => '2012-01-12 09:36:24',
        'CreateBy'   => '1',
        'ChangeTime' => '2012-01-12 09:36:24',
        'ChangeBy'   => '1',
    };

=cut

sub ItemGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ItemID} && ( !$Param{Class} || $Param{Name} eq '' ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need ItemID OR Class and Name!'
        );
        return;
    }

    # create sql string
    my $SQL = 'SELECT id, general_catalog_class, name, valid_id, comments, '
        . 'create_time, create_by, change_time, change_by FROM general_catalog WHERE ';
    my @BIND;

    # add options to sql string
    if ( $Param{Class} && $Param{Name} ne '' ) {

        # check if result is already cached
        my $CacheKey = 'ItemGet::Class::' . $Param{Class} . '::' . $Param{Name};
        my $Cache = $Self->{CacheInternalObject}->Get( Key => $CacheKey );
        return $Cache if $Cache;

        # add class and name to sql string
        $SQL .= 'general_catalog_class = ? AND name = ?';
        push @BIND, ( \$Param{Class}, \$Param{Name} );
    }
    else {

        # check if result is already cached
        my $CacheKey = 'ItemGet::ItemID::' . $Param{ItemID};
        my $Cache = $Self->{CacheInternalObject}->Get( Key => $CacheKey );
        return $Cache if $Cache;

        # add item id to sql string
        $SQL .= 'id = ?';
        push @BIND, \$Param{ItemID};
    }

    # ask database
    $Self->{DBObject}->Prepare(
        SQL   => $SQL,
        Bind  => \@BIND,
        Limit => 1,
    );

    # fetch the result
    my %ItemData;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $ItemData{ItemID}     = $Row[0];
        $ItemData{Class}      = $Row[1];
        $ItemData{Name}       = $Row[2];
        $ItemData{ValidID}    = $Row[3];
        $ItemData{Comment}    = $Row[4] || '';
        $ItemData{CreateTime} = $Row[5];
        $ItemData{CreateBy}   = $Row[6];
        $ItemData{ChangeTime} = $Row[7];
        $ItemData{ChangeBy}   = $Row[8];
    }

    # check item
    if ( !$ItemData{ItemID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Item not found in database!',
        );
        return;
    }

    # get general catalog preferences
    my %Preferences = $Self->GeneralCatalogPreferencesGet( ItemID => $ItemData{ItemID} );

    # merge hash
    if (%Preferences) {
        %ItemData = ( %ItemData, %Preferences );
    }

    # cache the result
    $Self->{CacheInternalObject}->Set(
        Key   => 'ItemGet::Class::' . $ItemData{Class} . '::' . $ItemData{Name},
        Value => \%ItemData,
    );
    $Self->{CacheInternalObject}->Set(
        Key   => 'ItemGet::ItemID::' . $ItemData{ItemID},
        Value => \%ItemData,
    );

    return \%ItemData;
}

=item ItemAdd()

add a new general catalog item

    my $ItemID = $GeneralCatalogObject->ItemAdd(
        Class         => 'ITSM::Service::Type',
        Name          => 'Item Name',
        ValidID       => 1,
        Comment       => 'Comment',              # (optional)
        UserID        => 1,
    );

=cut

sub ItemAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Class ValidID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # name must be not empty, but number zero (0) is allowed
    if ( $Param{Name} eq '' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need Name!",
        );
        return;
    }

    # set default values
    for my $Argument (qw(Comment)) {
        $Param{$Argument} ||= '';
    }

    # cleanup given params
    for my $Argument (qw(Class)) {
        $Self->{CheckItemObject}->StringClean(
            StringRef         => \$Param{$Argument},
            RemoveAllNewlines => 1,
            RemoveAllTabs     => 1,
            RemoveAllSpaces   => 1,
        );
    }
    for my $Argument (qw(Name Comment)) {
        $Self->{CheckItemObject}->StringClean(
            StringRef         => \$Param{$Argument},
            RemoveAllNewlines => 1,
            RemoveAllTabs     => 1,
        );
    }

    # find exiting item with same name
    $Self->{DBObject}->Prepare(
        SQL => 'SELECT id FROM general_catalog '
            . 'WHERE general_catalog_class = ? AND name = ?',
        Bind => [ \$Param{Class}, \$Param{Name} ],
        Limit => 1,
    );

    # fetch the result
    my $NoAdd;
    while ( $Self->{DBObject}->FetchrowArray() ) {
        $NoAdd = 1;
    }

    # abort insert of new item, if item name already exists
    if ($NoAdd) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message =>
                "Can't add new item! General catalog item with same name already exists in this class.",
        );
        return;
    }

    # reset cache
    $Self->{CacheInternalObject}->CleanUp();

    # insert new item
    return if !$Self->{DBObject}->Do(
        SQL => 'INSERT INTO general_catalog '
            . '(general_catalog_class, name, valid_id, comments, '
            . 'create_time, create_by, change_time, change_by) VALUES '
            . '(?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{Class}, \$Param{Name},
            \$Param{ValidID},
            \$Param{Comment}, \$Param{UserID},
            \$Param{UserID},
        ],
    );

    # find id of new item
    $Self->{DBObject}->Prepare(
        SQL => 'SELECT id FROM general_catalog '
            . 'WHERE general_catalog_class = ? AND name = ?',
        Bind => [ \$Param{Class}, \$Param{Name} ],
        Limit => 1,
    );

    # fetch the result
    my $ItemID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $ItemID = $Row[0];
    }

    return $ItemID;
}

=item ItemUpdate()

update an existing general catalog item

    my $True = $GeneralCatalogObject->ItemUpdate(
        ItemID        => 123,
        Name          => 'Item Name',
        ValidID       => 1,
        Comment       => 'Comment',    # (optional)
        UserID        => 1,
    );

=cut

sub ItemUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(ItemID ValidID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # name must be not empty, but number zero (0) is allowed
    if ( $Param{Name} eq '' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need Name!",
        );
        return;
    }

    # set default values
    for my $Argument (qw(Comment)) {
        $Param{$Argument} ||= '';
    }

    # cleanup given params
    for my $Argument (qw(Class)) {
        $Self->{CheckItemObject}->StringClean(
            StringRef         => \$Param{$Argument},
            RemoveAllNewlines => 1,
            RemoveAllTabs     => 1,
            RemoveAllSpaces   => 1,
        );
    }
    for my $Argument (qw(Name Comment)) {
        $Self->{CheckItemObject}->StringClean(
            StringRef         => \$Param{$Argument},
            RemoveAllNewlines => 1,
            RemoveAllTabs     => 1,
        );
    }

    # get class of item
    $Self->{DBObject}->Prepare(
        SQL   => 'SELECT general_catalog_class FROM general_catalog WHERE id = ?',
        Bind  => [ \$Param{ItemID} ],
        Limit => 1,
    );

    # fetch the result
    my $Class;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Class = $Row[0];
    }

    if ( !$Class ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't update item! General catalog item not found in this class.",
        );
        return;
    }

    # find exiting item with same name
    $Self->{DBObject}->Prepare(
        SQL   => 'SELECT id FROM general_catalog WHERE general_catalog_class = ? AND name = ?',
        Bind  => [ \$Class, \$Param{Name} ],
        Limit => 1,
    );

    # fetch the result
    my $Update = 1;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        if ( $Param{ItemID} ne $Row[0] ) {
            $Update = 0;
        }
    }

    if ( !$Update ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message =>
                "Can't update item! General catalog item with same name already exists in this class.",
        );
        return;
    }

    # reset cache
    $Self->{CacheInternalObject}->CleanUp();

    return $Self->{DBObject}->Do(
        SQL => 'UPDATE general_catalog SET '
            . 'name = ?, valid_id = ?, comments = ?, '
            . 'change_time = current_timestamp, change_by = ? '
            . 'WHERE id = ?',
        Bind => [
            \$Param{Name},
            \$Param{ValidID}, \$Param{Comment},
            \$Param{UserID},  \$Param{ItemID},
        ],
    );
}

=item GeneralCatalogPreferencesSet()

set GeneralCatalog preferences

    $GeneralCatalogObject->GeneralCatalogPreferencesSet(
        ItemID => 123,
        Key    => 'UserComment',
        Value  => 'some comment',
    );

=cut

sub GeneralCatalogPreferencesSet {
    my $Self = shift;

    # delete cache
    $Self->{CacheInternalObject}->CleanUp();

    return $Self->{PreferencesObject}->GeneralCatalogPreferencesSet(@_);
}

=item GeneralCatalogPreferencesGet()

get GeneralCatalog preferences

    my %Preferences = $QueueObject->GeneralCatalogPreferencesGet(
        ItemID => 123,
    );

=cut

sub GeneralCatalogPreferencesGet {
    my $Self = shift;

    return $Self->{PreferencesObject}->GeneralCatalogPreferencesGet(@_);
}

1;

=back

=head1 TERMS AND CONDITIONS

This Software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
