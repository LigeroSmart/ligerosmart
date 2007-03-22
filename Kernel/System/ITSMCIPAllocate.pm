# --
# Kernel/System/ITSMCIPAllocate.pm - all criticality, impact and priority allocation functions
# Copyright (C) 2003-2007 OTRS GmbH, http://otrs.com/
# --
# $Id: ITSMCIPAllocate.pm,v 1.2 2007-03-22 13:27:10 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::ITSMCIPAllocate;

use strict;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.2 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

=head1 NAME

Kernel::System::CIPAllocate - criticality, impact and priority allocation lib

=head1 SYNOPSIS

All criticality, impact and priority allocation functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::Priority;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
    );
    my $CIPAllocateObject = Kernel::System::CIPAllocate->new(
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

=item AllocateList()

return a 2d hash reference of allocations

    my $ListRef = $CIPAllocateObject->AllocateList(
        UserID => 1,
    );

=cut

sub AllocateList {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(UserID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # ask database
    my %AllocateData = ();
    if ($Self->{DBObject}->Prepare(SQL => 'SELECT criticality_id, impact_id, priority_id FROM cip_allocate')) {
        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            $AllocateData{$Row[1]}{$Row[0]} = $Row[2];
        }
    }

    return \%AllocateData;
}

=item AllocateUpdate()

update the allocation of criticality, impact and priority

    my $True = $CIPAllocateObject->AllocateUpdate(
        AllocateData => $DataRef,  # 2D hash reference
        UserID => 1,
    );

=cut

sub AllocateUpdate {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(AllocateData UserID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    if (!ref($Param{AllocateData}) eq 'HASH') {
        $Self->{LogObject}->Log(Priority => 'error', Message => "AllocateData must be a 2D hash reference!");
        return;
    }
    # quote
    foreach (qw(UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # delete old allocations
    my $SQL = "DELETE FROM cip_allocate";
    my $Delete = $Self->{DBObject}->Do(SQL => $SQL);
    my $Return = 0;

    # insert new allocations
    if ($Delete) {
        foreach my $ImpactID (keys %{$Param{AllocateData}}) {
            # abort insert, if no 2d hash reference was found
            if (ref($Param{AllocateData}->{$ImpactID}) ne 'HASH') {
                $Self->{LogObject}->Log(Priority => 'error', Message => "AllocateData must be a 2D hash reference!");
                next;
            }
            foreach my $CriticalityID (keys %{$Param{AllocateData}->{$ImpactID}}) {
                my $PriorityID = $Param{AllocateData}->{$ImpactID}->{$CriticalityID};
                # quote
                $CriticalityID = $Self->{DBObject}->Quote($CriticalityID, 'Integer');
                $ImpactID = $Self->{DBObject}->Quote($ImpactID, 'Integer');
                $PriorityID = $Self->{DBObject}->Quote($PriorityID, 'Integer');

                # insert new allocation
                my $SQL = "INSERT INTO cip_allocate (criticality_id, impact_id, priority_id, ".
                    "create_time, create_by, change_time, change_by) VALUES ".
                    "($CriticalityID, $ImpactID, $PriorityID, ".
                    "current_timestamp, $Param{UserID}, current_timestamp, $Param{UserID})";
                $Self->{DBObject}->Do(SQL => $SQL);
            }
        }
        $Return = 1;
    }
    return $Return;
}

=item PriorityAllocationGet()

return the priority id of a criticality and an impact

    my $PriorityID = $CIPAllocateObject->PriorityAllocationGet(
        CriticalityID => 321,
        ImpactID => 123,
    );

=cut

sub PriorityAllocationGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(CriticalityID ImpactID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(CriticalityID ImpactID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # get priority id from db
    my $PriorityID;
    $Self->{DBObject}->Prepare(
        SQL => "SELECT priority_id FROM cip_allocate ".
            "WHERE criticality_id = $Param{CriticalityID} AND impact_id = $Param{ImpactID}",
        Limit => 1,
    );
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $PriorityID = $Row[0];
    }
    return $PriorityID;
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

$Revision: 1.2 $ $Date: 2007-03-22 13:27:10 $

=cut