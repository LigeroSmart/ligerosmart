# --
# Kernel/System/GeneralCatalog.pm - all general catalog functions
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: GeneralCatalog.pm,v 1.5 2007-05-16 11:27:29 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::GeneralCatalog;

use strict;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.5 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

=head1 NAME

Kernel::System::GeneralCatalog - general catalog lib

=head1 SYNOPSIS

All general catalog functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::DB;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
    );
    my $GeneralCatalogObject = Kernel::System::GeneralCatalog->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
        DBObject => $DBObject,
    );

=cut

sub new {
    my $Type = shift;
    my %Param = @_;
    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);
    # check needed objects
    foreach (qw(DBObject ConfigObject LogObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

=item ClassList()

return an array reference of all general catalog classes

    my $ListRef = $GeneralCatalogObject->ClassList();

=cut

sub ClassList {
    my $Self = shift;
    my %Param = @_;
    my @ClassList;
    # ask database
    $Self->{DBObject}->Prepare(
        SQL => "SELECT DISTINCT(class) FROM general_catalog ORDER BY class",
    );
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        push(@ClassList, $Row[0]);
    }
    return \@ClassList;
}

=item ItemList()

return a list as hash reference of one general catalog class

    my $ListRef = $GeneralCatalogObject->ItemList(
        Class => 'ITSM::Service::Type',
        Valid => 0,
    );

=cut

sub ItemList {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Class)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    if (!defined($Param{Valid})) {
        $Param{Valid} = 1;
    }

    # ask database
    my %Data = ();
    my $SQL = "SELECT id, name FROM general_catalog WHERE class = '$Param{Class}' ";
    if ($Param{Valid}) {
        $SQL .= "AND valid_id = 1";
    }
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Data{$Row[0]} = $Row[1];
    }
    return \%Data;
}

=item FunctionalityList()

return an hash reference of all functionalities of a general catalog class

    my $ListRef = $GeneralCatalogObject->FunctionalityList(
        Class => 'ITSM::Service::Type',
    );

=cut

sub FunctionalityList {
    my $Self = shift;
    my %Param = @_;
    my %FunctionalityList;
    # check needed stuff
    foreach (qw(Class)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # ask database
    $Self->{DBObject}->Prepare(
        SQL => "SELECT DISTINCT(functionality) FROM general_catalog WHERE class = '$Param{Class}' ORDER BY functionality",
    );
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $FunctionalityList{$Row[0]} = $Row[0];
    }
    delete($FunctionalityList{''});

    return \%FunctionalityList;
}

=item ItemGet()

get a general catalog item

Return
    $ItemData{ItemID}
    $ItemData{Class}
    $ItemData{Name}
    $ItemData{Functionality}
    $ItemData{ValidID}
    $ItemData{Comment}
    $ItemData{CreateTime}
    $ItemData{CreateBy}
    $ItemData{ChangeTime}
    $ItemData{ChangeBy}

    my $ItemDataRef = $GeneralCatalogObject->ItemGet(
        ItemID => 3,
    );

    or

    my $ItemDataRef = $GeneralCatalogObject->ItemGet(
        Class => 'ITSM::Service::Type',
        Name => 'Item Name',
    );

=cut

sub ItemGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{ItemID} && (!$Param{Class} || !$Param{Name})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need ItemID OR Class and Name!");
        return;
    }
    my $SQL = "SELECT id, class, name, functionality, valid_id, comments, ".
        "create_time, create_by, change_time, change_by FROM general_catalog WHERE ";
    if ($Param{Class} && $Param{Name}) {
        $SQL .= "class = '$Param{Class}' AND name = '$Param{Name}'";
    }
    else {
        $SQL .= "id = $Param{ItemID}";
    }

    # ask database
    my %ItemData = ();
    $Self->{DBObject}->Prepare(
        SQL => $SQL,
        Limit => 1,
    );
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $ItemData{ItemID} = $Row[0];
        $ItemData{Class} = $Row[1];
        $ItemData{Name} = $Row[2];
        $ItemData{Functionality} = $Row[3] || '';
        $ItemData{ValidID} = $Row[4];
        $ItemData{Comment} = $Row[5] || '';
        $ItemData{CreateTime} = $Row[6];
        $ItemData{CreateBy} = $Row[7];
        $ItemData{ChangeTime} = $Row[8];
        $ItemData{ChangeBy} = $Row[9];
    }
    return \%ItemData;
}

=item ItemAdd()

add a new general catalog item

    my $True = $GeneralCatalogObject->ItemAdd(
        Class => 'ITSM::Service::Type',
        Name => 'Item Name',
        Functionality => 'Func3',       # (optional)
        ValidID => 1,
        Comment => 'Comment',           # (optional)
        UserID => 1,
    );

=cut

sub ItemAdd {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Class Name ValidID UserID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(Class Name Functionality Comment)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach (qw(ValidID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # find exiting item with same name
    my $NoAdd;
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id FROM general_catalog WHERE name = '$Param{Name}' AND class = '$Param{Class}'",
        Limit => 1,
    );
    while ($Self->{DBObject}->FetchrowArray()) {
        $NoAdd = 1;
    }
    # add item
    my $Return;
    if (!$NoAdd) {
        $Self->{DBObject}->Do(
            SQL =>"INSERT INTO general_catalog ".
                "(class, name, functionality, valid_id, comments, ".
                "create_time, create_by, change_time, change_by) VALUES ".
                "('$Param{Class}', '$Param{Name}', '$Param{Functionality}', $Param{ValidID}, '$Param{Comment}', ".
                "current_timestamp, $Param{UserID}, current_timestamp, $Param{UserID})",
        );
        $Return = 1;
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Can't add new item! General catalog item with same name already exists in this class.",
        );
    }
    return $Return;
}

=item ItemUpdate()

update a existing general catalog item

    my $True = $GeneralCatalogObject->ItemUpdate(
        ItemID => 123,
        Name => 'Item Name',
        Functionality => 'Func3',  # (optional)
        ValidID => 1,
        Comment => 'Comment',      # (optional)
        UserID => 1,
    );

=cut

sub ItemUpdate {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ItemID Name ValidID UserID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(Name Functionality Comment)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach (qw(ItemID ValidID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # get class of item
    my $Class;
    my $OldFunctionality;
    $Self->{DBObject}->Prepare(
        SQL => "SELECT class, functionality FROM general_catalog WHERE id = $Param{ItemID}",
        Limit => 1,
    );
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Class = $Row[0] || '';
        $OldFunctionality = $Row[1] || '';
    }
    # find exiting item with same name
    my $Update = 1;
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id FROM general_catalog WHERE name = '$Param{Name}' AND class = '$Class'",
        Limit => 1,
    );
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        if ($Param{ItemID} ne $Row[0]) {
            $Update = 0;
        }
    }
    # count functionality
    if ($OldFunctionality) {
        $Self->{DBObject}->Prepare(
            SQL => "SELECT COUNT(functionality) FROM general_catalog ".
                "WHERE class = '$Class' AND functionality = '$OldFunctionality'",
            Limit => 1,
        );
        my $LastFunctionality = 1;
        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            if ($Row[0] > 1 || $Param{Functionality} eq $OldFunctionality) {
                $LastFunctionality = 0;
            }
        }
        if ($LastFunctionality) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message => "Can't update item! The functionality of this item is the last in this class.",
            );
            return;
        }
    }
    # update item
    if ($Update && $Class) {
        $Self->{DBObject}->Do(
            SQL => "UPDATE general_catalog SET name = '$Param{Name}', functionality = '$Param{Functionality}',".
                "valid_id = $Param{ValidID}, comments = '$Param{Comment}', ".
                "change_time = current_timestamp, change_by = $Param{UserID} WHERE id = $Param{ItemID}",
        );
        return 1;
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Can't update item! General catalog item with same name already exists in this class.",
        );
        return;
    }
}

=item ValidLookup()

return a hash reference of all general catalog availabilities

Return
    $Valid{ValidID}
    $Valid{Name}

    my $ValidRef = $GeneralCatalogObject->ValidLookup(
        ValidID => 1,
    );

    or

    my $ValidRef = $GeneralCatalogObject->ValidLookup(
        Name => 'valid',
    );

=cut

sub ValidLookup {
    my $Self = shift;
    my %Param = @_;
    my %Valid;
    if (!$Param{ValidID} && !$Param{Name}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need ValidID or Name!");
        return;
    }
    # get valid list
    my $ValidListRef = $Self->ValidList();
    if ($Param{ValidID}) {
        $Valid{ValidID} = $Param{ValidID};
        $Valid{Name} = $ValidListRef->{ValidID};
    }
    elsif ($Param{Name}) {
        my %ValidReverse = reverse(%{$ValidListRef});
        $Valid{ValidID} = $ValidReverse{$Param{Name}};
        $Valid{Name} = $Param{Name};
    }
    return \%Valid;
}

=item ValidList()

return a hash reference of all general catalog availabilities

    my $ListRef = $GeneralCatalogObject->ValidList();

=cut

sub ValidList {
    my $Self = shift;
    my %Param = @_;
    my %ValidList;

    $ValidList{'1'} = 'valid';
    $ValidList{'2'} = 'invalid';
    $ValidList{'3'} = 'invalid-temporarily';

    return \%ValidList;
}

1;

=back

=head1 TERMS AND CONDITIONS

This Software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=cut

=head1 VERSION

$Revision: 1.5 $ $Date: 2007-05-16 11:27:29 $

=cut