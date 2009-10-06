# --
# Kernel/System/ITSMChange/WorkOrder.pm - all work order functions
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: WorkOrder.pm,v 1.2 2009-10-06 22:24:42 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange::WorkOrder;

use strict;
use warnings;

use Kernel::System::Valid;
use Kernel::System::GeneralCatalog;
use Kernel::System::LinkObject;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

=head1 NAME

Kernel::System::ITSMChange::WorkOrder - work order lib

=head1 SYNOPSIS

All config item functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::Main;
    use Kernel::System::ITSMChange::WorkOrder;

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
    my $WorkOrderObject = Kernel::System::ITSMChange::WorkOrder->new(
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

    $Self->{ValidObject}          = Kernel::System::Valid->new( %{$Self} );
    $Self->{GeneralCatalogObject} = Kernel::System::GeneralCatalog->new( %{$Self} );
    $Self->{LinkObject}           = Kernel::System::LinkObject->new( %{$Self} );

    return $Self;
}

=item WorkOrderAdd()

add a new workorder

    my $WorkOrderID = $WorkOrderObject->WorkOrderAdd(
        UserID => 1,
    );
or
    my $WorkOrderID = $WorkOrderObject->WorkOrderAdd(
        ChangeID         => 123,                                       # (optional)
        WorkOrderNumber  => 5,                                         # (optional)
        Title            => 'Replacement of mail server',              # (optional)
        Instruction      => 'Install the the new server',              # (optional)
        Report           => 'Installed new server without problems',   # (optional)
        WorkOrderStateID => 4,                                         # (optional)
        WorkOrderAgentID => 8,                                         # (optional)

        NOTE:
        * Setting of ACTUAL times here and in WorkOrderUpdate()
        and/or in a separate set function? (Planned times should stay here)

        PlannedStartTime => '2009-10-12 00:00:01',                     # (optional)
        PlannedEndTime   => '2009-10-15 15:00:00',                     # (optional)
        ActualStartTime  => '2009-10-14 00:00:01',                     # (optional)
        ActualEndTime    => '2009-01-20 00:00:01',                     # (optional)
        UserID           => 1,
    );

=cut

sub WorkOrderAdd {
    my ( $Self, %Param ) = @_;

    # check if given WorkOrderStateID is valid
    return if $Param{WorkOrderStateID} && !$Self->_CheckWorkOrderStateID(
        WorkOrderStateID => $Param{WorkOrderStateID},
    );

    return $WorkOrderID;
}

=item WorkOrderUpdate()

update a WorkOrder

    my $Success = $WorkOrderObject->WorkOrderUpdate(
        WorkOrderID      => 4,
        ChangeID         => 123,                                       # (optional)
        WorkOrderNumber  => 5,                                         # (optional)
        Title            => 'Replacement of mail server',              # (optional)
        Instruction      => 'Install the the new server',              # (optional)
        Report           => 'Installed new server without problems',   # (optional)
        WorkOrderStateID => 4,                                         # (optional)
        WorkOrderAgentID => 8,                                         # (optional)
        PlannedStartTime => '2009-10-12 00:00:01',                     # (optional)
        PlannedEndTime   => '2009-10-15 15:00:00',                     # (optional)
        ActualStartTime  => '2009-10-14 00:00:01',                     # (optional)
        ActualEndTime    => '2009-01-20 00:00:01',                     # (optional)
        UserID           => 1,
    );

=cut

sub WorkOrderUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(WorkOrderID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # check if given WorkOrderStateID is valid
    return if $Param{WorkOrderStateID} && !$Self->_CheckWorkOrderStateID(
        WorkOrderStateID => $Param{WorkOrderStateID},
    );

    return 1;
}

=item WorkOrderGet()

return a WorkOrder as hash reference

Return
    $WorkOrder{WorkOrderID}
    $WorkOrder{ChangeID}
    $WorkOrder{WorkOrderNumber}
    $WorkOrder{Title}
    $WorkOrder{Instruction}
    $WorkOrder{Report}
    $WorkOrder{WorkOrderStateID}
    $WorkOrder{WorkOrderAgentID}
    $WorkOrder{PlannedStartTime}
    $WorkOrder{PlannedEndTime}
    $WorkOrder{ActualStartTime}
    $WorkOrder{ActualEndTime}
    $WorkOrder{CreateTime}
    $WorkOrder{CreateBy}
    $WorkOrder{ChangeTime}
    $WorkOrder{ChangeBy}

    my $WorkOrderRef = $WorkOrderObject->WorkOrderGet(
        WorkOrderID => 123,
    );

=cut

sub WorkOrderGet {
    my ( $Self, %Param ) = @_;

    return;
}

=item WorkOrderList()

return a list of all workorder ids of a given change id as array reference

    my $WorkOrderIDsRef = $WorkOrderObject->WorkOrderList(
        ChangeID = 5,
    );

=cut

sub WorkOrderList {
    my ( $Self, %Param ) = @_;

    return;
}

=item WorkOrderSearch()

return a list of workorder ids as an array reference

    my $WorkOrderIDsRef = $WorkOrderObject->WorkOrderSearch(
        ChangeID         => 123,                                       # (optional)
        WorkOrderNumber  => 12,                                        # (optional)
        Title            => 'Replacement of mail server',              # (optional)
        Instruction      => 'Install the the new server',              # (optional)
        Report           => 'Installed new server without problems',   # (optional)
        WorkOrderStateID => 4,                                         # (optional)
        WorkOrderAgentID => 7,                                         # (optional)

        # changes with planned start time after ...
        PlannedStartTimeNewerDate => '2006-01-09 00:00:01',            # (optional)
        # changes with planned start time before then ....
        PlannedStartTimeOlderDate => '2006-01-19 23:59:59',            # (optional)

        # changes with planned end time after ...
        PlannedEndTimeNewerDate => '2006-01-09 00:00:01',              # (optional)
        # changes with planned end time before then ....
        PlannedEndTimeOlderDate => '2006-01-19 23:59:59',              # (optional)

        # changes with actual start time after ...
        ActualStartTimeNewerDate => '2006-01-09 00:00:01',             # (optional)
        # changes with actual start time before then ....
        ActualStartTimeOlderDate => '2006-01-19 23:59:59',             # (optional)

        # changes with actual end time after ...
        ActualEndTimeNewerDate => '2006-01-09 00:00:01',               # (optional)
        # changes with actual end time before then ....
        ActualEndTimeOlderDate => '2006-01-19 23:59:59',               # (optional)

        # changes with created time after ...
        CreateTimeNewerDate => '2006-01-09 00:00:01',                  # (optional)
        # changes with created time before then ....
        CreateTimeOlderDate => '2006-01-19 23:59:59',                  # (optional)

        # changes with changed time after ...
        ChangeTimeNewerDate => '2006-01-09 00:00:01',                  # (optional)
        # changes with changed time before then ....
        ChangeTimeOlderDate => '2006-01-19 23:59:59',                  # (optional)

        OrderBy => 'WorkOrderID',  # default                           # (optional)
        # (WorkOrderID, ChangeID,
        # WorkOrderStateID, WorkOrderAgentID,
        # PlannedStartTime, PlannedEndTime,
        # ActualStartTime, ActualEndTime,
        # CreateTime, CreateBy, ChangeTime, ChangeBy)

        Limit => 100,                                                  # (optional)
    );

=cut

sub WorkOrderSearch {
    my ( $Self, %Param ) = @_;

    return;
}

=item WorkOrderDelete()

delete a workorder

NOTE: This function must first remove all links to this WorkOrderObject,

    my $Success = $WorkOrderObject->WorkOrderDelete(
        WorkOrderID => 123,
    );

=cut

sub WorkOrderDelete {
    my ( $Self, %Param ) = @_;

    return;
}

=item _CheckWorkOrderStateID()

check if a given work order state id is valid

    my $Ok = $WorkOrderObject->_CheckWorkOrderStateID(
        WorkOrderStateID => 25,
    );

=cut

sub _CheckWorkOrderStateID {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{WorkOrderStateID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need $Argument!",
        );
        return;
    }

    # get work order state list
    my $WorkOrderStateList = $Self->{GeneralCatalogObject}->ItemList(
        Class => 'ITSM::ChangeManagement::WorkOrder::State',
    );

    if (
        !$WorkOrderStateList
        || ref $WorkOrderStateList ne 'HASH'
        || !$WorkOrderStateList->{ $Param{WorkOrderStateID} }
        )
    {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "No valid work order state id given!",
        );
        return;
    }

    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see http://www.gnu.org/licenses/agpl.txt.

=cut

=head1 VERSION

$Revision: 1.2 $ $Date: 2009-10-06 22:24:42 $

=cut
