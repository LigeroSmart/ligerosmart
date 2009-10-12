# --
# Kernel/System/ITSMChange.pm - all change functions
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: ITSMChange.pm,v 1.23 2009-10-12 20:36:30 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange;

use strict;
use warnings;

use Kernel::System::Valid;
use Kernel::System::GeneralCatalog;
use Kernel::System::LinkObject;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.23 $) [1];

=head1 NAME

Kernel::System::ITSMChange - change lib

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
    use Kernel::System::Time;
    use Kernel::System::ITSMChange;

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
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $ChangeObject = Kernel::System::ITSMChange->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        TimeObject   => $TimeObject,
        MainObject   => $MainObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(DBObject ConfigObject EncodeObject LogObject MainObject TimeObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    $Self->{ValidObject}          = Kernel::System::Valid->new( %{$Self} );
    $Self->{GeneralCatalogObject} = Kernel::System::GeneralCatalog->new( %{$Self} );
    $Self->{LinkObject}           = Kernel::System::LinkObject->new( %{$Self} );
    $Self->{UserObject}           = Kernel::System::User->new( %{$Self} );
    $Self->{CustomerUserObject}   = Kernel::System::CustomerUser->new( %{$Self} );

    return $Self;
}

=item ChangeAdd()

add a new change

    my $ChangeID = $ChangeObject->ChangeAdd(
        UserID => 1,
    );
or
    my $ChangeID = $ChangeObject->ChangeAdd(
        Title           => 'Replacement of mail server',       # (optional)
        Description     => 'New mail server is faster',        # (optional)
        Justification   => 'Old mail server too slow',         # (optional)
        ChangeStateID   => 4,                                  # (optional)
        ChangeManagerID => 5,                                  # (optional)
        ChangeBuilderID => 6,                                  # (optional)
        CABAgents       => [ 1, 2, 4 ],     # UserIDs          # (optional)
        CABCustomers    => [ 'tt', 'mm' ],  # CustomerUserIDs  # (optional)
        UserID          => 1,
    );

=cut

sub ChangeAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need UserID!",
        );
        return;
    }

    # check change parameters
    return if !$Self->_CheckChangeParams(%Param);

    # create a new change number
    my $ChangeNumber = $Self->_ChangeNumberCreate();

    # TODO: replace this later with State-Condition-Action logic
    # get initial change state id
    my $ItemDataRef = $Self->{GeneralCatalogObject}->ItemGet(
        Class => 'ITSM::ChangeManagement::Change::State',
        Name  => 'requested',
    );

    my $ChangeStateID = $ItemDataRef->{ItemID};

    # add change to database
    return if !$Self->{DBObject}->Do(
        SQL => 'INSERT INTO change_item '
            . '(change_number, change_state_id, change_builder_id, '
            . ' create_time, create_by, change_time, change_by) '
            . 'VALUES (?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$ChangeNumber, \$ChangeStateID, \$Param{UserID},
            \$Param{UserID}, \$Param{UserID},
        ],
    );

    # get change id
    return if !$Self->{DBObject}->Prepare(
        SQL   => 'SELECT id FROM change_item WHERE change_number = ?',
        Bind  => [ \$ChangeNumber ],
        Limit => 1,
    );
    my $ChangeID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $ChangeID = $Row[0];
    }
    return if !$ChangeID;

    # TODO: trigger ChangeAdd-Event

    # update change with remaining parameters
    return if !$Self->ChangeUpdate(
        ChangeID => $ChangeID,
        %Param,
    );

    return $ChangeID;
}

=item ChangeUpdate()

update a change

    my $Success = $ChangeObject->ChangeUpdate(
        ChangeID        => 123,
        Title           => 'Replacement of slow mail server',  # (optional)
        Description     => 'New mail server is faster',        # (optional)
        Justification   => 'Old mail server too slow',         # (optional)
        ChangeStateID   => 4,                                  # (optional)
        ChangeManagerID => 5,                                  # (optional)
        ChangeBuilderID => 6,                                  # (optional)
        CABAgents       => [ 1, 2, 4 ],     # UserIDs          # (optional)
        CABCustomers    => [ 'tt', 'mm' ],  # CustomerUserIDs  # (optional)
        UserID          => 1,
    );

=cut

sub ChangeUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(ChangeID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # check change parameters
    return if !$Self->_CheckChangeParams(%Param);

    # map update attributes to column names
    my %Attribute = (
        Title           => 'title',
        Description     => 'description',
        Justification   => 'justification',
        ChangeStateID   => 'change_state_id',
        ChangeManagerID => 'change_manager_id',
        ChangeBuilderID => 'change_builder_id',
    );

    # update CAB
    if ( exists $Param{CABAgents} || exists $Param{CABCustomers} ) {
        return if !$Self->ChangeCABUpdate(%Param);
    }

    # build SQL to update change
    my $SQL = 'UPDATE change_item SET ';
    my @Bind;
    ATTRIBUTE:
    for my $Key ( keys %Attribute ) {

        # do not use column if not in function parameters
        next ATTRIBUTE if !exists $Param{$Key};

        $SQL .= "$Attribute{$Key} = ?, ";
        push @Bind, \$Param{$Key};
    }
    push @Bind, \$Param{UserID}, \$Param{ChangeID};
    $SQL .= 'change_time = current_timestamp, change_by = ? ';
    $SQL .= 'WHERE id = ? ';

    # add change to database
    return if !$Self->{DBObject}->Do(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    # TODO: trigger ChangeUpdate-Event

    return 1;
}

=item ChangeGet()

return a change as hash reference

Return
    $Change{ChangeID}
    $Change{ChangeNumber}
    $Change{Title}
    $Change{Description}
    $Change{Justification}
    $Change{ChangeManagerID}
    $Change{ChangeBuilderID}
    $Change{WorkOrderIDs}     # array reference with WorkOrderIDs
    $Change{CABAgents}        # array reference with CAB Agent UserIDs
    $Change{CABCustomers}     # array reference with CAB CustomerUserIDs
    $Change{PlannedStartTime}
    $Change{PlannedEndTime}
    $Change{ActualStartTime}
    $Change{ActualEndTime}
    $Change{CreateTime}
    $Change{CreateBy}
    $Change{ChangeTime}
    $Change{ChangeBy}

    my $ChangeRef = $ChangeObject->ChangeGet(
        ChangeID => 123,
    );

=cut

sub ChangeGet {
    my ( $Self, %Param ) = @_;

    return;
}

=item ChangeCABUpdate()

add or update the CAB of a change

    my $Success = $ChangeObject->ChangeCABUpdate(
        ChangeID     => 123,
        CABAgents    => [ 1, 2, 4 ],     # UserIDs          (optional)
        CABCustomers => [ 'tt', 'mm' ],  # CustomerUserIDs  (optional)
        UserID       => 1,
    );

=cut

sub ChangeCABUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Attribute (qw(ChangeID UserID)) {
        if ( !$Param{$Attribute} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Attribute!",
            );
            return;
        }
    }

    # TODO:
    # add filter to filter out entries that appear more than once

    # TODO: add comment
    if ( !$Param{CABAgents} && !$Param{CABCustomers} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need parameter CABAgents or CABCustomers!",
        );
        return;
    }

    # TODO: add comment
    for my $Attribute (qw(CABAgents CABCustomers)) {
        if ( $Param{$Attribute} && ref $Param{$Attribute} ne 'ARRAY' ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "The parameter $Attribute is not an arrray reference!",
            );
            return;
        }
    }

    # TODO: add comment
    if ( $Param{CABAgents} ) {
        return if !$Self->{DBObject}->Do(
            SQL => 'DELETE FROM change_cab '
                . 'WHERE change_id = ? '
                . 'AND user_id IS NOT NULL',
            Bind => [ \$Param{ChangeID} ],
        );
        for my $UserID ( @{ $Param{CABAgents} } ) {
            return if !$Self->{DBObject}->Do(
                SQL => 'INSERT INTO change_cab ( change_id, user_id ) VALUES ( ?, ? )',
                Bind => [ \$Param{ChangeID}, \$UserID ],
            );
        }
    }

    # TODO: add comment
    if ( $Param{CABCustomers} ) {
        return if !$Self->{DBObject}->Do(
            SQL => 'DELETE FROM change_cab '
                . 'WHERE change_id = ? '
                . 'AND customer_user_id IS NOT NULL',
            Bind => [ \$Param{ChangeID} ],
        );
        for my $CustomerUserID ( @{ $Param{CABCustomers} } ) {
            return if !$Self->{DBObject}->Do(
                SQL => 'INSERT INTO change_cab ( change_id, customer_user_id ) VALUES ( ?, ? )',
                Bind => [ \$Param{ChangeID}, \$CustomerUserID ],
            );
        }
    }

    # TODO: trigger ChangeCABUpdate-Event

    return 1;
}

=item ChangeCABGet()

return the CAB of a change as hasharray reference

Return
    $ChangeCAB = {
        CABAgents    => [ 1, 2, 4 ],
        CABCustomers => [ 'tt', 'mm' ],
    }

    my $ChangeCAB = $ChangeObject->ChangeCABGet(
        ChangeID => 123,
        UserID   => 1,
    );

=cut

sub ChangeCABGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(ChangeID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # cab data
    my %CAB = (
        CABAgents    => [],
        CABCustomers => [],
    );

    # get data
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id, change_id, user_id, customer_user_id '
            . 'FROM change_cab WHERE change_id = ?',
        Bind => [ \$Param{ChangeID} ],
    );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        my %Data;
        $Data{CABID}          = $Row[0];
        $Data{ChangeID}       = $Row[1];
        $Data{UserID}         = $Row[2];
        $Data{CustomerUserID} = $Row[3];

        if ( $Data{UserID} ) {
            push @{ $Data{CABAgents} }, $Data{UserID};
        }
        elsif ( $Data{CustomerUserID} ) {
            push @{ $Data{CABCustomers} }, $Data{CustomerUserID};
        }
    }

    return \%CAB;
}

=item ChangeCABDelete()

delete the CAB of a change

    my $Success = $ChangeObject->ChangeCABDelete(
        ChangeID => 123,
        UserID   => 1,
    );

=cut

sub ChangeCABDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Attribute (qw(ChangeID UserID)) {
        if ( !$Param{$Attribute} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Attribute!",
            );
            return;
        }
    }

    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM change_cab WHERE change_id = ? ',
        Bind => [ \$Param{ChangeID} ],
    );

    return 1;
}

=item ChangeList()

return a change id list of all changes as array reference

    my $ChangeIDsRef = $ChangeObject->ChangeList();

=cut

sub ChangeList {
    my ( $Self, %Param ) = @_;

    return;
}

=item ChangeSearch()

return list of change ids as an array reference

    my $ChangeIDsRef = $ChangeObject->ChangeSearch(
        ChangeNumber     => '2009100112345778',                 # (optional)
        Title            => 'Replacement of slow mail server',  # (optional)
        Description      => 'New mail server is faster',        # (optional)
        Justification    => 'Old mail server too slow',         # (optional)
        ChangeStateID    => 4,                                  # (optional)

        ChangeManagerID  => 5,                                  # (optional)
        ChangeBuilderID  => 6,                                  # (optional)
        WorkOrderAgentID => 7,                                  # (optional)
        CABAgent         => 9,                                  # (optional)
        CABCustomer      => 'tt',                               # (optional)

        # changes with planned start time after ...
        PlannedStartTimeNewerDate => '2006-01-09 00:00:01',     # (optional)
        # changes with planned start time before then ....
        PlannedStartTimeOlderDate => '2006-01-19 23:59:59',     # (optional)

        # changes with planned end time after ...
        PlannedEndTimeNewerDate => '2006-01-09 00:00:01',       # (optional)
        # changes with planned end time before then ....
        PlannedEndTimeOlderDate => '2006-01-19 23:59:59',       # (optional)

        # changes with actual start time after ...
        ActualStartTimeNewerDate => '2006-01-09 00:00:01',      # (optional)
        # changes with actual start time before then ....
        ActualStartTimeOlderDate => '2006-01-19 23:59:59',      # (optional)

        # changes with actual end time after ...
        ActualEndTimeNewerDate => '2006-01-09 00:00:01',        # (optional)
        # changes with actual end time before then ....
        ActualEndTimeOlderDate => '2006-01-19 23:59:59',        # (optional)

        # changes with created time after ...
        CreateTimeNewerDate => '2006-01-09 00:00:01',           # (optional)
        # changes with created time before then ....
        CreateTimeOlderDate => '2006-01-19 23:59:59',           # (optional)

        # changes with changed time after ...
        ChangeTimeNewerDate => '2006-01-09 00:00:01',           # (optional)
        # changes with changed time before then ....
        ChangeTimeOlderDate => '2006-01-19 23:59:59',           # (optional)

        OrderBy => 'ChangeID',  # default                       # (optional)
        # (ChangeID, ChangeNumber, ChangeStateID,
        # ChangeManagerID, ChangeBuilderID,
        # PlannedStartTime, PlannedEndTime,
        # ActualStartTime, ActualEndTime,
        # CreateTime, CreateBy, ChangeTime, ChangeBy)

        Limit => 100,                                           # (optional)
    );

=cut

sub ChangeSearch {
    my ( $Self, %Param ) = @_;

    return;
}

=item ChangeDelete()

delete a change

NOTE: This function must first remove all links to this ChangeObject,
      delete the history of this ChangeObject, delete the CAB,
      then get a list of all WorkOrderObjects of this change and
      call WorkorderDelete for each WorkOrder (which will itself delete
      all links to the WorkOrder).

    my $Success = $ChangeObject->ChangeDelete(
        ChangeID => 123,
        UserID   => 1,
    );

=cut

sub ChangeDelete {
    my ( $Self, %Param ) = @_;

    return;
}

=item ChangeWorkflowEdit()

edit the workflow of a change

NOTE: To be defined in more detail!

    my $Success = $ChangeObject->ChangeWorkflowEdit(
        ChangeID  => 123,
        UserID    => 1,
    );

=cut

sub ChangeWorkflowEdit {
    my ( $Self, %Param ) = @_;

    return;
}

=item ChangeWorkflowList()

list the workflow of a change

NOTE: To be defined in more detail!

    my $ChangeWorkflow = $ChangeObject->ChangeWorkflowList(
        ChangeID  => 123,
    );

=cut

sub ChangeWorkflowList {
    my ( $Self, %Param ) = @_;

    return;
}

=item _ChangeStartGet()

get the start date of a change, calculated from the start of the first work order

    my $ChangeStartTime = $ChangeObject->_ChangeStartGet(
        ChangeID => 123,
        Type     => 'planned' || 'actual',
    );

=cut

sub _ChangeStartGet {
    my ( $Self, %Param ) = @_;

    return;
}

=item _ChangeEndGet()

get the end date of a change, calculated from the start of the first work order

    my $ChangeEndTime = $ChangeObject->_ChangeEndGet(
        ChangeID => 123,
        Type     => 'planned' || 'actual',
    );

=cut

sub _ChangeEndGet {
    my ( $Self, %Param ) = @_;

    return;
}

=item _CheckChangeStateID()

check if a given change state id is valid

    my $Ok = $ChangeObject->_CheckChangeStateID(
        ChangeStateID => 25,
    );

=cut

sub _CheckChangeStateID {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ChangeStateID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need ChangeStateID!",
        );
        return;
    }

    # get change state list
    my $ChangeStateList = $Self->{GeneralCatalogObject}->ItemList(
        Class => 'ITSM::ChangeManagement::Change::State',
    );

    if (
        !$ChangeStateList
        || ref $ChangeStateList ne 'HASH'
        || !$ChangeStateList->{ $Param{ChangeStateID} }
        )
    {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "No valid change state id given!",
        );
        return;
    }

    return 1;
}

=item _ChangeNumberCreate()

create a new change number

    my $ChangeNumber= $ChangeObject->_ChangeNumberCreate();

=cut

sub _ChangeNumberCreate {
    my ($Self) = @_;

    # TODO : Replace this function with the similar code as in DateChecksum in OTRS!!!!

    # get needed config options
    my $SystemID = $Self->{ConfigObject}->Get('SystemID');

    # get current time
    my ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = $Self->{TimeObject}->SystemTime2Date(
        SystemTime => $Self->{TimeObject}->SystemTime(),
    );

    # create random number
    my $RandomNumber = int( rand(100000) );

    # create new change number
    my $ChangeNumber = $Year . $Month . $Day . $SystemID . $RandomNumber;

    return $ChangeNumber;
}

=item _ChangeTicksGet()

NOTE: Maybe this function better belongs to Kernel/Output/HTML/LayoutITSMChange.pm

short description of _ChangeTicksGet

    my $Result = $ChangeObject->_ChangeTicksGet(
        ChangeID => 123,
    );

=cut

sub _ChangeTicksGet {
    my ( $Self, %Param ) = @_;

    return;
}

=item _CheckChangeParams()

checks the params to ChangeAdd() and ChangeUpdate().
There are no required parameters.

    my $Ok = $ChangeObject->_CheckChangeParams(
        Title           => 'Replacement of mail server',       # (optional)
        Description     => 'New mail server is faster',        # (optional)
        Justification   => 'Old mail server too slow',         # (optional)
        ChangeStateID   => 4,                                  # (optional)
        ChangeManagerID => 5,                                  # (optional)
        ChangeBuilderID => 6,                                  # (optional)
        CABAgents       => [ 1, 2, 4 ],     # UserIDs          # (optional)
        CABCustomers    => [ 'tt', 'mm' ],  # CustomerUserIDs  # (optional)
    );

=cut

sub _CheckChangeParams {
    my ( $Self, %Param ) = @_;

    # check the string and id parameters
    ARGUMENT:
    for my $Argument (
        qw( Title Description Justification ChangeManagerID ChangeBuilderID ChangeStateID )
        )
    {

        next ARGUMENT if !exists $Param{$Argument};    # params are not required

        if ( !defined $Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "The parameter $Argument must be defined!",
            );
            return;
        }

        if ( ref $Param{$Argument} ne '' ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "The parameter $Argument mustn't be a reference!",
            );
            return;
        }
    }

    # check if given ChangeStateID is valid
    return if $Param{ChangeStateID} && !$Self->_CheckChangeStateID(
        ChangeStateID => $Param{ChangeStateID},
    );

    # change manager and change builder must be agents
    ARGUMENT:
    for my $Argument (qw( ChangeManagerID ChangeBuilderID )) {

        next ARGUMENT if !exists $Param{$Argument};    # params are not required

        my %UserData = $Self->{UserObject}->GetUserData(
            UserID => $Param{$Argument},
            Valid  => 1,
        );

        if ( !$UserData{UserID} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "The $Argument $Param{$Argument} is not a valid user id!",
            );
            return;
        }
    }

    # CAB agents must be agents
    if ( exists $Param{CABAgents} ) {
        if ( ref $Param{CABAgents} ne 'ARRAY' ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "The parameter CABAgents is not an ARRAY reference!",
            );
            return;
        }
        for my $UserID ( @{ $Param{CABAgents} } ) {
            my %UserData = $Self->{UserObject}->GetUserData(
                UserID => $UserID,
                Valid  => 1,
            );
            if ( !$UserData{UserID} ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "The CABAgent $UserID is not a valid user id!",
                );
                return;
            }
        }
    }

    # CAB customers must be customers
    if ( exists $Param{CABCustomers} ) {
        if ( ref $Param{CABCustomers} ne 'ARRAY' ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "The parameter CABCustomers is not an ARRAY reference!",
            );
            return;
        }
        for my $CustomerUser ( @{ $Param{CABCustomers} } ) {
            my %CustomerUserData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                User  => $CustomerUser,
                Valid => 1,
            );
            if ( !%CustomerUserData ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "The CABCustomer $CustomerUser is not a valid customer!",
                );
                return;
            }
        }
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

$Revision: 1.23 $ $Date: 2009-10-12 20:36:30 $

=cut
