# --
# Kernel/System/ITSMLocation.pm - all itsm location function
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: ITSMLocation.pm,v 1.1 2008-06-18 17:27:04 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::ITSMLocation;

use strict;
use warnings;

use Kernel::System::Valid;
use Kernel::System::CheckItem;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

=head1 NAME

Kernel::System::ITSMLocation - itsm location lib

=head1 SYNOPSIS

All itsm location functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::ITSMLocation;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $LocationObject = Kernel::System::ITSMLocation->new(
        ConfigObject => $ConfigObject,
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
    for my $Object (qw(DBObject ConfigObject LogObject MainObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }
    $Self->{ValidObject} = Kernel::System::Valid->new( %{$Self} );
    $Self->{CheckItemObject} = Kernel::System::CheckItem->new( %{$Self} );

    return $Self;
}

=item LocationList()

return a hash list of locations

    my %LocationList = $LocationObject->LocationList(
        Valid  => 0,  # (optional) default 1 (0|1)
        UserID => 1,
    );

=cut

sub LocationList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need UserID!'
        );
        return;
    }

    # check valid param
    if ( !defined $Param{Valid} ) {
        $Param{Valid} = 1;
    }

    # quote
    $Param{UserID} = $Self->{DBObject}->Quote( $Param{UserID}, 'Integer' );

    # ask database
    $Self->{DBObject}->Prepare(
        SQL => 'SELECT id, name, valid_id FROM location',
    );

    # fetch the result
    my %LocationList;
    my %LocationValidList;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $LocationList{ $Row[0] }      = $Row[1];
        $LocationValidList{ $Row[0] } = $Row[2];
    }

    return %LocationList if !$Param{Valid};

    # duplicate location list
    my %LocationListTmp = %LocationList;

    # add suffix for correct sorting
    for my $Location ( values %LocationListTmp ) {
        $Location .= '::';
    }

    # get valid ids
    my @ValidIDs = $Self->{ValidObject}->ValidIDsGet();

    my %LocationInvalidList;
    LOCATIONID:
    for my $LocationID (
        sort { $LocationListTmp{$a} cmp $LocationListTmp{$b} }
        keys %LocationListTmp
        )
    {
        my $Invalid = 1;
        for my $ValidID (@ValidIDs) {
            if ( $LocationValidList{$LocationID} eq $ValidID ) {
                $Invalid = 0;
                last LOCATIONID;
            }
        }
        if ($Invalid) {
            $LocationInvalidList{ $LocationList{$LocationID} } = 1;
            delete $LocationList{$LocationID};
        }
    }

    # delete invalid locations an childs
    LOCATIONID:
    for my $LocationID ( keys %LocationList ) {
        INVALIDID:
        for my $InvalidName ( keys %LocationInvalidList ) {
            if ( $LocationList{$LocationID} =~ m{ \A $InvalidName :: }xms ) {
                delete $LocationList{$LocationID};

                last LOCATIONID;
            }
        }
    }

    return %LocationList;
}

=item LocationGet()

return a location as hash

Return
    $LocationData{LocationID}
    $LocationData{ParentID}
    $LocationData{Name}
    $LocationData{NameShort}
    $LocationData{TypeID}
    $LocationData{Phone1}
    $LocationData{Phone2}
    $LocationData{Fax}
    $LocationData{Email}
    $LocationData{Address}
    $LocationData{ValidID}
    $LocationData{Comment}
    $LocationData{CreateTime}
    $LocationData{CreateBy}
    $LocationData{ChangeTime}
    $LocationData{ChangeBy}

    my %LocationData = $LocationObject->LocationGet(
        LocationID => 123,
        UserID     => 1,
    );

=cut

sub LocationGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(LocationID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!"
            );
            return;
        }
    }

    # quote
    for my $Argument (qw(LocationID UserID)) {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument}, 'Integer' );
    }

    # get location from database
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id, name, type_id, phone1, phone2, fax, email, address, "
            . "valid_id, comments, create_time, create_by, change_time, change_by "
            . "FROM location WHERE id = $Param{LocationID}",
        Limit => 1,
    );

    # fetch the result
    my %LocationData;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $LocationData{LocationID} = $Row[0];
        $LocationData{Name}       = $Row[1];
        $LocationData{TypeID}     = $Row[2];
        $LocationData{Phone1}     = $Row[3] || '';
        $LocationData{Phone2}     = $Row[4] || '';
        $LocationData{Fax}        = $Row[5] || '';
        $LocationData{Email}      = $Row[6] || '';
        $LocationData{Address}    = $Row[7] || '';
        $LocationData{ValidID}    = $Row[8];
        $LocationData{Comment}    = $Row[9] || '';
        $LocationData{CreateTime} = $Row[10];
        $LocationData{CreateBy}   = $Row[11];
        $LocationData{ChangeTime} = $Row[12];
        $LocationData{ChangeBy}   = $Row[13];
    }

    # check location
    if ( !$LocationData{LocationID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "No such LocationID ($Param{LocationID})!",
        );
        return;
    }

    # create short name and parentid
    $LocationData{NameShort} = $LocationData{Name};
    if ( $LocationData{Name} =~ /^(.*)::(.+?)$/ ) {
        $LocationData{NameShort} = $2;

        # lookup parent
        my $LocationID = $Self->LocationLookup( Name => $1 );
        $LocationData{ParentID} = $LocationID;
    }

    return %LocationData;
}

=item LocationLookup()

return a location name and id

    my $LocationName = $LocationObject->LocationLookup(
        LocationID => 123,
    );

    or

    my $LocationID = $LocationObject->LocationLookup(
        Name => 'Location::SubLocation',
    );

=cut

sub LocationLookup {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{LocationID} && !$Param{Name} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need LocationID or Name!' );
        return;
    }

    if ( $Param{LocationID} ) {

        # quote
        $Param{LocationID} = $Self->{DBObject}->Quote( $Param{LocationID}, 'Integer' );

        # lookup
        $Self->{DBObject}->Prepare(
            SQL   => "SELECT name FROM location WHERE id = $Param{LocationID}",
            Limit => 1,
        );

        # fetch the result
        my $LocationName;
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            $LocationName = $Row[0];
        }

        return $LocationName;
    }
    else {

        # quote
        $Param{Name} = $Self->{DBObject}->Quote( $Param{Name} );

        # lookup
        $Self->{DBObject}->Prepare(
            SQL   => "SELECT id FROM location WHERE name = '$Param{Name}'",
            Limit => 1,
        );

        # fetch the result
        my $LocationID;
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            $LocationID = $Row[0];
        }

        return $LocationID;
    }
}

=item LocationAdd()

add a location

    my $True = $LocationObject->LocationAdd(
        Name     => 'Location Name',
        ParentID => 1,                # (optional)
        TypeID   => 123,
        Phone1   => '01010101',       # (optional)
        Phone2   => '01010101',       # (optional)
        Fax      => '1111122222',     # (optional)
        Email    => 'my@email.de',    # (optional)
        Address  => 'The Address',    # (optional)
        ValidID  => 1,
        Comment  => 'Comment',        # (optional)
        UserID   => 1,
    );

=cut

sub LocationAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Name TypeID ValidID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!"
            );
            return;
        }
    }

    # set default values
    for my $Argument (qw(Phone1 Phone2 Fax Email Address Comment)) {
        $Param{$Argument} = $Param{$Argument} || '';
    }

    # quote
    for my $Argument (qw(Name Phone1 Phone2 Fax Email Address Comment)) {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument} );
    }
    for my $Argument (qw(TypeID ValidID UserID)) {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument}, 'Integer' );
    }

    # cleanup given params
    for my $Argument (qw(Name Phone1 Phone2 Fax Comment)) {
        $Self->{CheckItemObject}->StringClean(
            StringRef         => \$Param{$Argument},
            RemoveAllNewlines => 1,
            RemoveAllTabs     => 1,
        );
    }
    $Self->{CheckItemObject}->StringClean(
        StringRef         => \$Param{Email},
        RemoveAllNewlines => 1,
        RemoveAllTabs     => 1,
        RemoveAllSpaces   => 1,
    );
    $Self->{CheckItemObject}->StringClean(
        StringRef => \$Param{Address},
    );

    # check location name
    if ( $Param{Name} =~ /::/ ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't add location! Invalid Location name '$Param{Name}'!",
        );
        return;
    }

    # create full name
    $Param{FullName} = $Param{Name};

    # get parent name
    if ( $Param{ParentID} ) {
        my $ParentName = $Self->LocationLookup( LocationID => $Param{ParentID} );
        if ($ParentName) {
            $Param{FullName} = $Self->{DBObject}->Quote($ParentName) . '::' . $Param{Name};
        }

        # quote
        $Param{ParentID} = $Self->{DBObject}->Quote( $Param{ParentID}, 'Integer' );
    }

    # find existing location
    $Self->{DBObject}->Prepare(
        SQL   => "SELECT id FROM location WHERE name = '$Param{FullName}'",
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
            Message  => "Can't add location! Location with same name and parent already exists."
        );
        return;
    }

    # insert new location
    my $Success = $Self->{DBObject}->Do(
        SQL => "INSERT INTO location "
            . "(name, type_id, phone1, phone2, fax, email, address, valid_id, "
            . "comments, create_time, create_by, change_time, change_by) VALUES "
            . "('$Param{FullName}', $Param{TypeID}, '$Param{Phone1}', "
            . "'$Param{Phone2}', '$Param{Fax}', "
            . "'$Param{Email}', '$Param{Address}', $Param{ValidID}, '$Param{Comment}', "
            . "current_timestamp, $Param{UserID}, current_timestamp, $Param{UserID})"
    );

    return if !$Success;

    # ask database
    $Self->{DBObject}->Prepare(
        SQL   => "SELECT id FROM location WHERE name = '$Param{FullName}'",
        Limit => 1,
    );

    # fetch the result
    my $LocationID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $LocationID = $Row[0];
    }

    return $LocationID;
}

=item LocationUpdate()

update a existing location

    my $True = $LocationObject->LocationUpdate(
        LocationID => 123,
        ParentID   => 1,                # (optional)
        Name       => 'Location Name',
        TypeID     => 123,
        Phone1     => '01010101',       # (optional)
        Phone2     => '01010101',       # (optional)
        Fax        => '1111122222',     # (optional)
        Email      => 'my@email.de',    # (optional)
        Address    => 'The Address',    # (optional)
        ValidID    => 1,
        Comment    => 'Comment',        # (optional)
        UserID     => 1,
    );

=cut

sub LocationUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(LocationID Name TypeID ValidID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!"
            );
            return;
        }
    }

    # set default values
    for my $Argument (qw(Phone1 Phone2 Fax Email Address Comment)) {
        $Param{$Argument} = $Param{$Argument} || '';
    }

    # quote
    for my $Argument (qw(Name Phone1 Phone2 Fax Email Address Comment)) {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument} );
    }
    for my $Argument (qw(LocationID TypeID ValidID UserID)) {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument}, 'Integer' );
    }

    # cleanup given params
    for my $Argument (qw(Name Phone1 Phone2 Fax Comment)) {
        $Self->{CheckItemObject}->StringClean(
            StringRef         => \$Param{$Argument},
            RemoveAllNewlines => 1,
            RemoveAllTabs     => 1,
        );
    }
    $Self->{CheckItemObject}->StringClean(
        StringRef         => \$Param{Email},
        RemoveAllNewlines => 1,
        RemoveAllTabs     => 1,
        RemoveAllSpaces   => 1,
    );
    $Self->{CheckItemObject}->StringClean(
        StringRef => \$Param{Address},
    );

    # check location name
    if ( $Param{Name} =~ /::/ ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't update location! Invalid Location name '$Param{Name}'!",
        );
        return;
    }

    # get old name of location
    my $OldLocationName = $Self->LocationLookup(
        LocationID => $Param{LocationID},
    );

    # create full name
    $Param{FullName} = $Param{Name};

    # get parent name
    if ( $Param{ParentID} ) {
        my $ParentName = $Self->LocationLookup(
            LocationID => $Param{ParentID},
        );

        if ($ParentName) {
            $Param{FullName} = $Self->{DBObject}->Quote($ParentName) . '::' . $Param{Name};
        }

        # check, if selected parent was a child of this location
        if ( $Param{FullName} =~ /^($OldLocationName)::/ ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Can't update location! Invalid parent was selected."
            );
            return;
        }

        # quote
        $Param{ParentID} = $Self->{DBObject}->Quote( $Param{ParentID}, 'Integer' );
    }

    # find existing location
    $Self->{DBObject}->Prepare(
        SQL   => "SELECT id FROM location WHERE name = '$Param{FullName}'",
        Limit => 1,
    );

    # fetch the result
    my $Update = 1;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        if ( $Param{LocationID} ne $Row[0] ) {
            $Update = 0;
        }
    }

    if ( !$Update ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't update location! Location with same name and parent already exists."
        );
        return;
    }

    # update location
    $Self->{DBObject}->Do(
        SQL => "UPDATE location SET name = '$Param{FullName}', type_id = $Param{TypeID}, "
            . "phone1 = '$Param{Phone1}', phone2 = '$Param{Phone2}', fax = '$Param{Fax}', "
            . "email = '$Param{Email}', address = '$Param{Address}', valid_id = $Param{ValidID}, "
            . "comments = '$Param{Comment}', "
            . "change_time = current_timestamp, change_by = $Param{UserID} "
            . "WHERE id = $Param{LocationID}"
    );

    # find all childs
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id, name FROM location WHERE name LIKE '"
            . $Self->{DBObject}->Quote($OldLocationName)
            . "::%'"
    );

    # fetch the result
    my @Childs;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        my %Child;
        $Child{LocationID} = $Row[0];
        $Child{Name}       = $Row[1];
        push( @Childs, \%Child );
    }

    # update childs
    for my $Child (@Childs) {
        $Child->{Name} =~ s/^($OldLocationName)::/$Param{FullName}::/;
        $Self->{DBObject}->Do(
            SQL => "UPDATE location SET name = '$Child->{Name}' WHERE id = $Child->{LocationID}"
        );
    }

    return 1;
}

=item LocationSearch()

return a location ids as an array

    my @LocationList = $LocationObject->LocationSearch(
        Name    => 'Location Name',  # (optional)
        TypeIDs => [123, 111],       # (optional)
        Phone1  => '01010101',       # (optional)
        Phone2  => '01010101',       # (optional)
        Fax     => '1111122222',     # (optional)
        Email   => 'my@email.de',    # (optional)
        Address => 'The Address',    # (optional)
        Limit   => 122,              # (optional) default 10.000
        Valid   => 0,                # (optional) default 1 (0|1)
        UserID  => 1,
    );

=cut

sub LocationSearch {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need UserID!'
        );
        return;
    }

    $Param{Limit} ||= 10_000;

    # check valid param
    if ( !defined $Param{Valid} ) {
        $Param{Valid} = 1;
    }

    # quote
    $Param{UserID} = $Self->{DBObject}->Quote( $Param{UserID}, 'Integer' );

    my $SQL = "SELECT id FROM location WHERE 1 = 1 ";

    if ( $Param{Valid} ) {

        # get valid ids
        my @ValidIDs = $Self->{ValidObject}->ValidIDsGet();
        my $ValidIDString = join q{, }, @ValidIDs;

        $SQL .= "AND valid_id IN ($ValidIDString) ";
    }

    # define the element hash
    my %Elements = (
        Name    => 'name',
        Phone1  => 'phone1',
        Phone2  => 'phone2',
        Fax     => 'fax',
        Email   => 'email',
        Address => 'address',
    );

    # add elements to the sql string
    ELEMENT:
    for my $Element ( keys %Elements ) {

        next ELEMENT if !$Param{$Element};

        # prepare like string
        $Self->_PrepareLikeString( \$Param{$Element} );

        $SQL .= "AND LOWER($Elements{$Element}) LIKE LOWER('$Param{$Element}') ";
    }

    # add type ids
    if ( $Param{TypeIDs} && ref $Param{TypeIDs} eq 'ARRAY' && @{ $Param{TypeIDs} } ) {
        $SQL .= "AND type_id IN (" . join( ', ', @{ $Param{TypeIDs} } ) . ") ";
    }

    # search locations in db
    $Self->{DBObject}->Prepare( SQL => $SQL );

    # fetch the result
    my @LocationList;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @LocationList, $Row[0];
    }

    return @LocationList;
}

=item _PrepareLikeString()

internal function to prepare like strings

    $ConfigItemObject->_PrepareLikeString( $StringRef );

=cut

sub _PrepareLikeString {
    my ( $Self, $Value ) = @_;

    return if !$Value;
    return if ref $Value ne 'SCALAR';

    # replace * with %
    ${$Value} =~ s{ \*+ }{%}xmsg;

    # Hotfix for MSSQL bug# 2227
    return if $Self->{DBObject}->GetDatabaseFunction('Type') ne 'mssql';

    ${$Value} =~ s{ \[ }{[[]}xmsg;

    return;
}

1;

=back

=head1 TERMS AND CONDITIONS

This Software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.

=cut

=head1 VERSION

$Revision: 1.1 $ $Date: 2008-06-18 17:27:04 $

=cut
