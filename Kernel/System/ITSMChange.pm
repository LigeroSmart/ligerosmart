# --
# Kernel/System/ITSMChange.pm - all change functions
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: ITSMChange.pm,v 1.109 2009-10-26 15:45:49 bes Exp $
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
use Kernel::System::User;
use Kernel::System::CustomerUser;
use Kernel::System::ITSMChange::WorkOrder;

use base qw(Kernel::System::EventHandler);

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.109 $) [1];

=head1 NAME

Kernel::System::ITSMChange - change lib

=head1 SYNOPSIS

All functions for changes in ITSMChangeManagement.

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

    # set default debug flag
    $Self->{Debug} ||= 0;

    # create additional objects
    $Self->{ValidObject}          = Kernel::System::Valid->new( %{$Self} );
    $Self->{GeneralCatalogObject} = Kernel::System::GeneralCatalog->new( %{$Self} );
    $Self->{LinkObject}           = Kernel::System::LinkObject->new( %{$Self} );
    $Self->{UserObject}           = Kernel::System::User->new( %{$Self} );
    $Self->{CustomerUserObject}   = Kernel::System::CustomerUser->new( %{$Self} );
    $Self->{WorkOrderObject}      = Kernel::System::ITSMChange::WorkOrder->new( %{$Self} );

    # init of event handler
    $Self->EventHandlerInit(
        Config     => 'ITSMChange::EventModule',
        BaseObject => 'ChangeObject',
        Objects    => {
            %{$Self},
        },
    );

    return $Self;
}

=item ChangeAdd()

add a new change

    my $ChangeID = $ChangeObject->ChangeAdd(
        UserID => 1,
    );
or
    my $ChangeID = $ChangeObject->ChangeAdd(
        ChangeTitle     => 'Replacement of mail server',       # (optional)
        Description     => 'New mail server is faster',        # (optional)
        Justification   => 'Old mail server too slow',         # (optional)
        ChangeStateID   => 4,                                  # (optional) or ChangeState => 'accepted'
        ChangeState     => 'accepted',                         # (optional) or ChangeStateID => 4
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
            Message  => 'Need UserID!',
        );
        return;
    }

    # check change parameters
    return if !$Self->_CheckChangeParams(%Param);

    # trigger ChangeAddPre-Event
    $Self->EventHandler(
        Event => 'ChangeAddPre',
        Data  => {
            %Param,
        },
        UserID => $Param{UserID},
    );

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
    my $ChangeID = $Self->ChangeLookup(
        UserID       => $Param{UserID},
        ChangeNumber => $ChangeNumber,
    );

    return if !$ChangeID;

    # trigger ChangeAddPost-Event
    # (yes, we want do do this before the ChangeUpdate!)
    $Self->EventHandler(
        Event => 'ChangeAddPost',
        Data  => {
            ChangeID => $ChangeID,
            %Param,
        },
        UserID => $Param{UserID},
    );

    # update change with remaining parameters
    my $UpdateSuccess = $Self->ChangeUpdate(
        ChangeID => $ChangeID,
        %Param,
    );

    # check update error
    if ( !$UpdateSuccess ) {

        # delete change if it could not be updated
        $Self->ChangeDelete(
            ChangeID => $ChangeID,
            UserID   => $Param{UserID},
        );

        return;
    }

    return $ChangeID;
}

=item ChangeUpdate()

update a change

    my $Success = $ChangeObject->ChangeUpdate(
        ChangeID        => 123,
        ChangeTitle     => 'Replacement of slow mail server',  # (optional)
        Description     => 'New mail server is faster',        # (optional)
        Justification   => 'Old mail server too slow',         # (optional)
        ChangeStateID   => 4,                                  # (optional) or Change => 'accepted'
        ChangeState     => 'accepted',                         # (optional) or ChangeStateID => 4
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
    for my $Argument (qw(UserID ChangeID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # check that not both State and StateID are given
    if ( $Param{State} && $Param{StateID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need either State OR StateID - not both!',
        );
        return;
    }

    # if State is given "translate" it
    if ( $Param{State} ) {
        $Param{StateID} = $Self->ChangeStateLookup(
            State => $Param{State},
        );
    }

    # check change parameters
    return if !$Self->_CheckChangeParams(%Param);

    # trigger ChangeUpdatePre-Event
    $Self->EventHandler(
        Event => 'ChangeUpdatePre',
        Data  => {
            %Param,
        },
        UserID => $Param{UserID},
    );

    # get old change data to be given to post event handler
    my $ChangeData = $Self->ChangeGet(
        ChangeID => $Param{ChangeID},
        UserID   => $Param{UserID},
    );

    # update CAB
    if ( exists $Param{CABAgents} || exists $Param{CABCustomers} ) {
        return if !$Self->ChangeCABUpdate(%Param);
    }

    # map update attributes to column names
    my %Attribute = (
        ChangeTitle     => 'title',
        Description     => 'description',
        Justification   => 'justification',
        ChangeStateID   => 'change_state_id',
        ChangeManagerID => 'change_manager_id',
        ChangeBuilderID => 'change_builder_id',
    );

    # build SQL to update change
    my $SQL = 'UPDATE change_item SET ';
    my @Bind;

    CHANGEATTRIBUTE:
    for my $ChangeAttribute ( keys %Attribute ) {

        # do not use column if not in function parameters
        next CHANGEATTRIBUTE if !exists $Param{$ChangeAttribute};

        $SQL .= "$Attribute{$ChangeAttribute} = ?, ";
        push @Bind, \$Param{$ChangeAttribute};
    }

    push @Bind, \$Param{UserID}, \$Param{ChangeID};
    $SQL .= 'change_time = current_timestamp, change_by = ? ';
    $SQL .= 'WHERE id = ?';

    # add change to database
    return if !$Self->{DBObject}->Do(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    # trigger ChangeUpdatePost-Event
    $Self->EventHandler(
        Event => 'ChangeUpdatePost',
        Data  => {
            OldChangeData => $ChangeData,
            %Param,
        },
        UserID => $Param{UserID},
    );

    return 1;
}

=item ChangeGet()

return a change as a hash reference

The returned hash reference contains following elements:

    $Change{ChangeID}
    $Change{ChangeNumber}
    $Change{ChangeStateID}
    $Change{ChangeState}
    $Change{ChangeTitle}
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
        UserID   => 1,
    );

=cut

sub ChangeGet {
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

    # build SQL
    my $SQL = 'SELECT id, change_number, title, description, justification, '
        . 'change_state_id, change_manager_id, change_builder_id, '
        . 'create_time, create_by, change_time, change_by '
        . 'FROM change_item '
        . 'WHERE id = ? ';

    # get change data from database
    return if !$Self->{DBObject}->Prepare(
        SQL   => $SQL,
        Bind  => [ \$Param{ChangeID} ],
        Limit => 1,
    );

    # fetch the result
    my %ChangeData;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $ChangeData{ChangeID}        = $Row[0];
        $ChangeData{ChangeNumber}    = $Row[1];
        $ChangeData{ChangeTitle}     = defined( $Row[2] ) ? $Row[2] : '';
        $ChangeData{Description}     = defined( $Row[3] ) ? $Row[3] : '';
        $ChangeData{Justification}   = defined( $Row[4] ) ? $Row[4] : '';
        $ChangeData{ChangeStateID}   = $Row[5];
        $ChangeData{ChangeManagerID} = $Row[6];
        $ChangeData{ChangeBuilderID} = $Row[7];
        $ChangeData{CreateTime}      = $Row[8];
        $ChangeData{CreateBy}        = $Row[9];
        $ChangeData{ChangeTime}      = $Row[10];
        $ChangeData{ChangeBy}        = $Row[11];
    }

    # check error
    if ( !%ChangeData ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Change with ID $Param{ChangeID} does not exist.",
        );
        return;
    }

    # get name of change state
    if ( $ChangeData{ChangeStateID} ) {
        $ChangeData{ChangeState} = $Self->ChangeStateLookup(
            StateID => $ChangeData{ChangeStateID},
        );
    }

    # get CAB data
    my $CAB = $Self->ChangeCABGet(
        ChangeID => $Param{ChangeID},
        UserID   => $Param{UserID},
    ) || {};

    # add result to change data
    %ChangeData = ( %ChangeData, %{$CAB} );

    # get all workorder ids for this change
    my $WorkOrderIDsRef = $Self->{WorkOrderObject}->WorkOrderList(
        ChangeID => $Param{ChangeID},
        UserID   => $Param{UserID},
    );

    # add result to change data
    $ChangeData{WorkOrderIDs} = $WorkOrderIDsRef || [];

    # get timestamps for the change
    my $ChangeTime = $Self->{WorkOrderObject}->WorkOrderChangeTimeGet(
        ChangeID => $Param{ChangeID},
        UserID   => $Param{UserID},
    );

    # merge time hash with change hash
    if (
        $ChangeTime
        && ref $ChangeTime eq 'HASH'
        && %{$ChangeTime}
        )
    {
        %ChangeData = ( %ChangeData, %{$ChangeTime} );
    }

    return \%ChangeData;
}

=item ChangeCABUpdate()

Add or update the CAB of a change.
One of CABAgents and CABCustomers must be passed.
Passing a reference to an empty array deletes the part of the CAB (CABAgents or CABCustomers)
When agents or customers are passed multiple times, they will be inserted only once.

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

    # either CABAgents of CABCustomers or both must be passed
    if ( !$Param{CABAgents} && !$Param{CABCustomers} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need parameter CABAgents or CABCustomers!",
        );
        return;
    }

    # CABAgents and CABCustomers must be array references
    for my $Attribute (qw(CABAgents CABCustomers)) {
        if ( $Param{$Attribute} && ref $Param{$Attribute} ne 'ARRAY' ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "The parameter $Attribute is not an arrray reference!",
            );
            return;
        }
    }

    # check if CABAgents and CABCustomers exist in the agents and customer databases
    return if !$Self->_CheckChangeParams(%Param);

    # trigger ChangeCABUpdatePre-Event
    $Self->EventHandler(
        Event => 'ChangeCABUpdatePre',
        Data  => {
            %Param,
        },
        UserID => $Param{UserID},
    );

    # get old CAB data to be given to post event handler
    my $ChangeCABData = $Self->ChangeCABGet(
        ChangeID => $Param{ChangeID},
        UserID   => $Param{UserID},
    );

    # enter the CAB Agents
    if ( $Param{CABAgents} ) {

        # remove all current users from cab table
        return if !$Self->{DBObject}->Do(
            SQL => 'DELETE FROM change_cab '
                . 'WHERE change_id = ? '
                . 'AND user_id IS NOT NULL',
            Bind => [ \$Param{ChangeID} ],
        );

        # filter out unique users
        my %UniqueUsers = map { $_ => 1 } @{ $Param{CABAgents} };

        # add user to cab table
        for my $UserID ( keys %UniqueUsers ) {
            return if !$Self->{DBObject}->Do(
                SQL => 'INSERT INTO change_cab ( change_id, user_id ) VALUES ( ?, ? )',
                Bind => [ \$Param{ChangeID}, \$UserID ],
            );
        }
    }

    # enter the CAB Customers
    if ( $Param{CABCustomers} ) {

        # remove all current customer users from cab table
        return if !$Self->{DBObject}->Do(
            SQL => 'DELETE FROM change_cab '
                . 'WHERE change_id = ? '
                . 'AND customer_user_id IS NOT NULL',
            Bind => [ \$Param{ChangeID} ],
        );

        # filter out unique customer users
        my %UniqueCustomerUsers = map { $_ => 1 } @{ $Param{CABCustomers} };

        # add user to cab table
        for my $CustomerUserID ( keys %UniqueCustomerUsers ) {
            return if !$Self->{DBObject}->Do(
                SQL => 'INSERT INTO change_cab ( change_id, customer_user_id ) VALUES ( ?, ? )',
                Bind => [ \$Param{ChangeID}, \$CustomerUserID ],
            );
        }
    }

    # trigger ChangeCABUpdatePost-Event
    $Self->EventHandler(
        Event => 'ChangeCABUpdatePost',
        Data  => {
            OldChangeCABData => $ChangeCABData,
            %Param,
        },
        UserID => $Param{UserID},
    );

    return 1;
}

=item ChangeCABGet()

return the CAB of a change as hasharray reference, the returned array references are sorted

Return
    $ChangeCAB = {
        CABAgents    => [ 1, 2, 4 ],
        CABCustomers => [ 'aa', 'bb' ],
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
        my $CABID          = $Row[0];
        my $ChangeID       = $Row[1];
        my $UserID         = $Row[2];
        my $CustomerUserID = $Row[3];

        # error check if both columns are filled
        if ( $UserID && $CustomerUserID ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message =>
                    "CAB table entry with ID $CABID contains UserID and CustomerUserID! "
                    . 'Only one at a time is allowed!',
            );
            return;
        }

        # add data to CAB
        if ($UserID) {
            push @{ $CAB{CABAgents} }, $UserID;
        }
        elsif ($CustomerUserID) {
            push @{ $CAB{CABCustomers} }, $CustomerUserID;
        }
    }

    # sort the results
    @{ $CAB{CABAgents} }    = sort @{ $CAB{CABAgents} };
    @{ $CAB{CABCustomers} } = sort @{ $CAB{CABCustomers} };

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

    # trigger ChangeCABDeletePre-Event
    $Self->EventHandler(
        Event => 'ChangeCABDeletePre',
        Data  => {
            %Param,
        },
        UserID => $Param{UserID},
    );

    # get old CAB data to be given to post event handler
    my $ChangeCABData = $Self->ChangeCABGet(
        ChangeID => $Param{ChangeID},
        UserID   => $Param{UserID},
    );

    # delete CAB
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM change_cab WHERE change_id = ?',
        Bind => [ \$Param{ChangeID} ],
    );

    # trigger ChangeCABDeletePost-Event
    $Self->EventHandler(
        Event => 'ChangeCABDeletePost',
        Data  => {
            OldChangeCABData => $ChangeCABData,
            %Param,
        },
        UserID => $Param{UserID},
    );

    return 1;
}

=item ChangeLookup()

Return the change id when the change number is passed.
Return the change number when the change id is passed.
When no change id or change number is found, the undefined value is returned.

    my $ChangeID = $ChangeObject->ChangeLookup(
        ChangeNumber => '2009091742000465',
        UserID => 1,
    );

    my $ChangeNumber = $ChangeObject->ChangeLookup(
        ChangeID => 42,
        UserID => 1,
    );

=cut

sub ChangeLookup {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );
        return;
    }

    # the change id or the change number must be passed
    if ( !$Param{ChangeID} && !$Param{ChangeNumber} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need the ChangeID or the ChangeNumber!',
        );
        return;
    }

    # only one of change id and change number can be passed
    if ( $Param{ChangeID} && $Param{ChangeNummber} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need either the ChangeID or the ChangeNumber, not both!',
        );
        return;
    }

    # get change id
    if ( $Param{ChangeNumber} ) {
        return if !$Self->{DBObject}->Prepare(
            SQL   => 'SELECT id FROM change_item WHERE change_number = ?',
            Bind  => [ \$Param{ChangeNumber} ],
            Limit => 1,
        );

        my $ChangeID;
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            $ChangeID = $Row[0];
        }

        return $ChangeID;
    }

    # get change number
    elsif ( $Param{ChangeID} ) {

        return if !$Self->{DBObject}->Prepare(
            SQL   => 'SELECT change_number FROM change_item WHERE id = ?',
            Bind  => [ \$Param{ChangeID} ],
            Limit => 1,
        );

        my $ChangeNumber;
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            $ChangeNumber = $Row[0];
        }

        return $ChangeNumber;
    }

    return;
}

=item ChangeList()

return a change id list of all changes as array reference

    my $ChangeIDsRef = $ChangeObject->ChangeList(
        UserID => 1,
    );

=cut

sub ChangeList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );
        return;
    }

    # get change id
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id FROM change_item',
    );

    my @ChangeIDs;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @ChangeIDs, $Row[0];
    }

    return \@ChangeIDs;
}

=item ChangeSearch()

return list of change ids as an array reference

    my $ChangeIDsRef = $ChangeObject->ChangeSearch(
        ChangeNumber      => '2009100112345778',                 # (optional)

        ChangeTitle       => 'Replacement of slow mail server',  # (optional)
        Description       => 'New mail server is faster',        # (optional)
        Justification     => 'Old mail server too slow',         # (optional)

        # array parameters are used with logical OR operator
        ChangeStateIDs    => [ 11, 12, 13 ],                     # (optional)
        ChangeManagerIDs  => [ 1, 2, 3 ],                        # (optional)
        ChangeBuilderIDs  => [ 5, 7, 4 ],                        # (optional)
        CreateBy          => [ 5, 2, 3 ],                        # (optional)
        ChangeBy          => [ 3, 2, 1 ],                        # (optional)
        WorkOrderAgentIDs => [ 6, 2 ],                           # (optional)
        CABAgents         => [ 9, 13 ],                          # (optional)
        CABCustomers      => [ 'tt', 'xx' ],                     # (optional)

        # search in text fields of workorder object
        WorkOrderTitle            => 'Boot Mailserver',
        WorkOrderInstruction      => 'Press the button.',
        WorkOrderReport           => 'Mailserver has booted.',

        # changes with planned start time after ...
        PlannedStartTimeNewerDate => '2006-01-09 00:00:01',      # (optional)
        # changes with planned start time before then ....
        PlannedStartTimeOlderDate => '2006-01-19 23:59:59',      # (optional)

        # changes with planned end time after ...
        PlannedEndTimeNewerDate   => '2006-01-09 00:00:01',      # (optional)
        # changes with planned end time before then ....
        PlannedEndTimeOlderDate   => '2006-01-19 23:59:59',      # (optional)

        # changes with actual start time after ...
        ActualStartTimeNewerDate  => '2006-01-09 00:00:01',      # (optional)
        # changes with actual start time before then ....
        ActualStartTimeOlderDate  => '2006-01-19 23:59:59',      # (optional)

        # changes with actual end time after ...
        ActualEndTimeNewerDate    => '2006-01-09 00:00:01',      # (optional)
        # changes with actual end time before then ....
        ActualEndTimeOlderDate    => '2006-01-19 23:59:59',      # (optional)

        # changes with created time after ...
        CreateTimeNewerDate       => '2006-01-09 00:00:01',      # (optional)
        # changes with created time before then ....
        CreateTimeOlderDate       => '2006-01-19 23:59:59',      # (optional)

        # changes with changed time after ...
        ChangeTimeNewerDate       => '2006-01-09 00:00:01',      # (optional)
        # changes with changed time before then ....
        ChangeTimeOlderDate       => '2006-01-19 23:59:59',      # (optional)

        OrderBy => [ 'ChangeID', 'ChangeManagerID' ],            # (optional)
        # default: [ 'ChangeID' ]
        # (ChangeID, ChangeNumber, ChangeStateID,
        # ChangeManagerID, ChangeBuilderID,
        # PlannedStartTime, PlannedEndTime,
        # ActualStartTime, ActualEndTime,
        # CreateTime, CreateBy, ChangeTime, ChangeBy)

        # Additional information for OrderBy:
        # The OrderByDirection can be specified for each OrderBy attribute.
        # The pairing is made by the array indices.

        OrderByDirection => [ 'Down', 'Up' ],                    # (optional)
        # default: [ 'Down' ]
        # (Down | Up)

        UsingWildcards => 0,                                     # (optional)
        # default 1

        Limit => 100,                                            # (optional)

        UserID => 1,
    );

=cut

sub ChangeSearch {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );
        return;
    }

    # check parameters, OrderBy and OrderByDirection are array references
    ARGUMENT:
    for my $Argument (qw(OrderBy OrderByDirection)) {
        if ( !defined $Param{$Argument} ) {
            $Param{$Argument} ||= [];
        }
        else {
            if ( ref $Param{$Argument} ne 'ARRAY' ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "$Argument must be an array reference!",
                );
                return;
            }
        }
    }

    # define order table
    my %OrderByTable = (
        ChangeID         => 'c.id',
        ChangeNumber     => 'c.change_number',
        ChangeStateID    => 'c.change_state_id',
        ChangeManagerID  => 'c.change_manager_id',
        ChangeBuilderID  => 'c.change_builder_id',
        CreateTime       => 'c.create_time',
        CreateBy         => 'c.create_by',
        ChangeTime       => 'c.change_time',
        ChangeBy         => 'c.change_by',
        PlannedStartTime => 'MIN(wo1.planned_start_time)',
        PlannedEndTime   => 'MAX(wo1.planned_end_time)',
        ActualStartTime  => 'MIN(wo1.actual_start_time)',
        ActualEndTime    => 'MAX(wo1.actual_end_time)',
    );

    # check if OrderBy contains only unique valid values
    if ( @{ $Param{OrderBy} } ) {
        my %OrderBySeen;
        ORDERBY:
        for my $OrderBy ( @{ $Param{OrderBy} } ) {

            if ( !$OrderBy || !$OrderByTable{$OrderBy} || $OrderBySeen{$OrderBy} ) {

                # found an error
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "OrderByDirection contains invalid value '$OrderBy' "
                        . " or the value is used more than once!",
                );
                return;
            }

            # remember the value to check if it appears more than once
            $OrderBySeen{$OrderBy} = 1;
        }
    }

    # check if OrderByDirection array contains only 'Up' or 'Down'
    if ( @{ $Param{OrderByDirection} } ) {
        DIRECTION:
        for my $Direction ( @{ $Param{OrderByDirection} } ) {

            # only 'Up' or 'Down' allowed
            next DIRECTION if $Direction eq 'Up';
            next DIRECTION if $Direction eq 'Down';

            # found an error
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "OrderByDirection can only contain 'Up' or 'Down'!",
            );
            return;
        }
    }

    # set default values
    if ( !defined $Param{UsingWildcards} ) {
        $Param{UsingWildcards} = 1;
    }

    my @SQLWhere;           # assemble the conditions used in the WHERE clause
    my @SQLHaving;          # assemble the conditions used in the HAVING clause
    my @InnerJoinTables;    # keep track of the tables that need to be inner joined
    my @OuterJoinTables;    # keep track of the tables that need to be outer joined

    # set string params
    my %StringParams = (
        ChangeNumber  => 'c.change_number',
        ChangeTitle   => 'c.title',
        Description   => 'c.description',
        Justification => 'c.justification',
    );

    # add string params to sql-where-array
    STRINGPARAM:
    for my $StringParam ( keys %StringParams ) {

        # check string params for useful values, the string q{0} is allowed
        next STRINGPARAM if !exists $Param{$StringParam};
        next STRINGPARAM if !defined $Param{$StringParam};
        next STRINGPARAM if $Param{$StringParam} eq '';

        # quote
        $Param{$StringParam} = $Self->{DBObject}->Quote( $Param{$StringParam} );

        # wildcards are used
        if ( $Param{UsingWildcards} ) {

            # Quote
            $Param{$StringParam} = $Self->{DBObject}->Quote( $Param{$StringParam}, 'Like' );

            # replace * with %
            $Param{$StringParam} =~ s{ \*+ }{%}xmsg;

            # do not use string params which contain only %
            next STRINGPARAM if $Param{$StringParam} =~ m{ \A %* \z }xms;

            push @SQLWhere,
                "LOWER($StringParams{$StringParam}) LIKE LOWER('$Param{$StringParam}')";
        }

        # no wildcards are used
        else {
            push @SQLWhere,
                "LOWER($StringParams{$StringParam}) = LOWER('$Param{$StringParam}')";
        }
    }

    # set array params
    my %ArrayParams = (
        ChangeStateIDs   => 'c.change_state_id',
        ChangeManagerIDs => 'c.change_manager_id',
        ChangeBuilderIDs => 'c.change_builder_id',
        CreateBy         => 'c.create_by',
        ChangeBy         => 'c.change_by',
    );

    # add array params to sql-where-array
    ARRAYPARAM:
    for my $ArrayParam ( keys %ArrayParams ) {

        next ARRAYPARAM if !$Param{$ArrayParam};

        if ( ref $Param{$ArrayParam} ne 'ARRAY' ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "$ArrayParam must be an array reference!",
            );
            return;
        }

        next ARRAYPARAM if !@{ $Param{$ArrayParam} };

        # quote
        for my $OneParam ( @{ $Param{$ArrayParam} } ) {
            $OneParam = $Self->{DBObject}->Quote($OneParam);
        }

        # create string
        my $InString = join q{, }, @{ $Param{$ArrayParam} };

        next ARRAYPARAM if !$InString;

        push @SQLWhere, "$ArrayParams{$ArrayParam} IN ($InString)";
    }

    # set time params
    my %TimeParams = (
        CreateTimeNewerDate => 'c.create_time >=',
        CreateTimeOlderDate => 'c.create_time <=',
        ChangeTimeNewerDate => 'c.change_time >=',
        ChangeTimeOlderDate => 'c.change_time <=',
    );

    # add change time params to sql-where-array
    TIMEPARAM:
    for my $TimeParam ( keys %TimeParams ) {

        next TIMEPARAM if !$Param{$TimeParam};

        if ( $Param{$TimeParam} !~ m{ \A \d\d\d\d-\d\d-\d\d \s \d\d:\d\d:\d\d \z }xms ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Invalid date format found!',
            );
            return;
        }

        # quote
        $Param{$TimeParam} = $Self->{DBObject}->Quote( $Param{$TimeParam} );

        push @SQLWhere, "$TimeParams{$TimeParam} '$Param{$TimeParam}'";
    }

    # set time params in workorder table
    my %WorkOrderTimeParams = (
        PlannedStartTimeNewerDate => 'min(wo1.planned_start_time) >=',
        PlannedStartTimeOlderDate => 'min(wo1.planned_start_time) <=',
        PlannedEndTimeNewerDate   => 'max(wo1.planned_end_time) >=',
        PlannedEndTimeOlderDate   => 'max(wo1.planned_end_time) <=',
        ActualStartTimeNewerDate  => 'min(wo1.actual_start_time) >=',
        ActualStartTimeOlderDate  => 'min(wo1.actual_start_time) <=',
        ActualEndTimeNewerDate    => 'max(wo1.actual_end_time) >=',
        ActualEndTimeOlderDate    => 'max(wo1.actual_end_time) <=',
    );

    # add work order time params to sql-having-array
    TIMEPARAM:
    for my $TimeParam ( keys %WorkOrderTimeParams ) {

        next TIMEPARAM if !$Param{$TimeParam};

        if ( $Param{$TimeParam} !~ m{ \A \d\d\d\d-\d\d-\d\d \s \d\d:\d\d:\d\d \z }xms ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Invalid date format found!',
            );
            return;
        }

        # quote
        $Param{$TimeParam} = $Self->{DBObject}->Quote( $Param{$TimeParam} );

        push @SQLHaving,       "$WorkOrderTimeParams{$TimeParam} '$Param{$TimeParam}'";
        push @OuterJoinTables, 'wo1';
    }

    # conditions for CAB searches
    my %CABParams = (
        CABAgents    => 'cab1.user_id',
        CABCustomers => 'cab2.customer_user_id',
    );

    # add cab params to sql-where-array
    CABPARAM:
    for my $CABParam ( keys %CABParams ) {
        next CABPARAM if !$Param{$CABParam};

        if ( ref $Param{$CABParam} ne 'ARRAY' ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "$CABParam must be an array reference!",
            );
            return;
        }

        next CAPPARAM if !@{ $Param{$CABParam} };

        # quote
        for my $OneParam ( @{ $Param{$CABParam} } ) {
            $OneParam = $Self->{DBObject}->Quote($OneParam);
        }

        if ( $CABParam eq 'CABAgents' ) {

            # CABAgent is a integer, so no quotes are needed
            my $InString = join q{, }, @{ $Param{$CABParam} };
            push @SQLWhere,        "$CABParams{$CABParam} IN ($InString)";
            push @InnerJoinTables, 'cab1';
        }
        elsif ( $CABParam eq 'CABCustomers' ) {

            # CABCustomer is a string, so the single quotes are needed
            my $InString = join q{, }, map {"'$_'"} @{ $Param{$CABParam} };
            push @SQLWhere,        "$CABParams{$CABParam} IN ($InString)";
            push @InnerJoinTables, 'cab2';
        }
    }

    # conditions for workorder string searches
    my %WOStringParams = (
        WorkOrderTitle       => 'wo2.title',
        WorkOrderInstruction => 'wo2.instruction',
        WorkOrderReport      => 'wo2.report',
    );

    # add workorder string params to sql-where-array
    WOSTRINGPARAM:
    for my $WOStringParam ( keys %WOStringParams ) {

        # check string params for useful values, the string q{0} is allowed
        next WOSTRINGPARAM if !exists $Param{$WOStringParam};
        next WOSTRINGPARAM if !defined $Param{$WOStringParam};
        next WOSTRINGPARAM if $Param{$WOStringParam} eq '';

        # quote
        $Param{$WOStringParam} = $Self->{DBObject}->Quote( $Param{$WOStringParam} );

        # wildcards are used
        if ( $Param{UsingWildcards} ) {

            # Quote
            $Param{$WOStringParam} = $Self->{DBObject}->Quote( $Param{$WOStringParam}, 'Like' );

            # replace * with %
            $Param{$WOStringParam} =~ s{ \*+ }{%}xmsg;

            # do not use string params which contain only %
            next WOSTRINGPARAM if $Param{$WOStringParam} =~ m{ \A %* \z }xms;

            push @SQLWhere,
                "LOWER($WOStringParams{$WOStringParam}) LIKE LOWER('$Param{$WOStringParam}')";
        }

        # no wildcards are used
        else {
            push @SQLWhere,
                "LOWER($WOStringParams{$WOStringParam}) = LOWER('$Param{$WOStringParam}')";
        }

        push @InnerJoinTables, 'wo2';
    }

    # add work order agent id params to sql-where-array
    if ( $Param{WorkOrderAgentIDs} ) {
        if ( ref $Param{WorkOrderAgentIDs} ne 'ARRAY' ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "WorkOrderAgentID must be an array reference!",
            );
            return;
        }

        if ( @{ $Param{WorkOrderAgentIDs} } ) {

            # quote
            for my $OneParam ( @{ $Param{WorkOrderAgentIDs} } ) {
                $OneParam = $Self->{DBObject}->Quote($OneParam);
            }

            # create string
            my $InString = join q{, }, @{ $Param{WorkOrderAgentIDs} };

            push @SQLWhere,        "wo2.workorder_agent_id IN ( $InString )";
            push @InnerJoinTables, 'wo2';
        }
    }

    # define which parameter require a join with work order table
    my %TableRequiresJoin = (
        PlannedStartTime => 1,
        PlannedEndTime   => 1,
        ActualStartTime  => 1,
        ActualEndTime    => 1,
    );

    # assemble the ORDER BY clause
    my @SQLOrderBy;
    my @SQLAliases;    # order by aliases, be on the save side with MySQL
    my $Count = 0;
    ORDERBY:
    for my $OrderBy ( @{ $Param{OrderBy} } ) {

        # set the default order direction
        my $Direction = 'DESC';

        # add the given order direction
        if ( $Param{OrderByDirection}->[$Count] ) {
            if ( $Param{OrderByDirection}->[$Count] eq 'Up' ) {
                $Direction = 'ASC';
            }
            elsif ( $Param{OrderByDirection}->[$Count] eq 'Down' ) {
                $Direction = 'DESC';
            }
        }

        # add SQL
        if ( $OrderByTable{$OrderBy} =~ m{ wo1 }xms ) {
            push @SQLAliases, "$OrderByTable{$OrderBy} as alias_$OrderBy";
            push @SQLOrderBy, "alias_$OrderBy $Direction";
        }
        else {
            push @SQLOrderBy, "$OrderByTable{$OrderBy} $Direction";
        }

        # for some order fields, we need to make sure, that the wo1 table is joined
        if ( $TableRequiresJoin{$OrderBy} ) {
            push @OuterJoinTables, 'wo1';
        }
    }
    continue {
        $Count++;
    }

    # if there is a possibility that the ordering is not determined
    # we add an descending orderung by id
    if ( !grep { $_ eq 'ChangeID' } ( @{ $Param{OrderBy} } ) ) {
        push @SQLOrderBy, "$OrderByTable{ChangeID} DESC";
    }

    # assemble the SQL query
    my $SQL = 'SELECT ' . join( ', ', ( 'c.id', @SQLAliases ) ) . ' FROM change_item c ';

    # add the joins
    my %LongTableName = (
        wo1  => 'change_workorder',
        wo2  => 'change_workorder',
        cab1 => 'change_cab',
        cab2 => 'change_cab',
    );
    my %TableSeen;

    INNER_JOIN_TABLE:
    for my $Table (@InnerJoinTables) {

        # do not join a table twice
        next INNER_JOIN_TABLE if $TableSeen{$Table};

        $TableSeen{$Table} = 1;

        if ( !$LongTableName{$Table} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Encountered invalid inner join table '$Table'!",
            );
            return;
        }

        $SQL .= "INNER JOIN $LongTableName{$Table} $Table ON $Table.change_id = c.id ";
    }

    OUTER_JOIN_TABLE:
    for my $Table (@OuterJoinTables) {

        # do not join a table twice, when a table has been inner joined, no outer join is necessary
        next OUTER_JOIN_TABLE if $TableSeen{$Table};

        # remember that this table is joined already
        $TableSeen{$Table} = 1;

        # check error
        if ( !$LongTableName{$Table} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Encountered invalid outer join table '$Table'!",
            );
            return;
        }

        $SQL .= "LEFT OUTER JOIN $LongTableName{$Table} $Table ON $Table.change_id = c.id ";
    }

    # add the WHERE clause
    if (@SQLWhere) {
        $SQL .= 'WHERE ';
        $SQL .= join ' AND ', map {"( $_ )"} @SQLWhere;
        $SQL .= ' ';
    }

    # we need to group whenever there is a join
    if ( scalar @InnerJoinTables || scalar @OuterJoinTables ) {
        $SQL .= 'GROUP BY c.id ';
    }

    # add the HAVING clause
    if (@SQLHaving) {
        $SQL .= 'HAVING ';
        $SQL .= join ' AND ', map {"( $_ )"} @SQLHaving;
        $SQL .= ' ';
    }

    # add the ORDER BY clause
    if (@SQLOrderBy) {
        $SQL .= 'ORDER BY ';
        $SQL .= join q{, }, @SQLOrderBy;
        $SQL .= ' ';
    }

    # ask database
    return if !$Self->{DBObject}->Prepare(
        SQL   => $SQL,
        Limit => $Param{Limit},
    );

    # fetch the result
    my @ChangeIDList;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @ChangeIDList, $Row[0];
    }

    return \@ChangeIDList;
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

    # trigger ChangeDeletePre-Event
    $Self->EventHandler(
        Event => 'ChangeDeletePre',
        Data  => {
            %Param,
        },
        UserID => $Param{UserID},
    );

    # lookup if change exists
    return if !$Self->ChangeLookup(
        ChangeID => $Param{ChangeID},
        UserID   => $Param{UserID},
    );

    # delete all links to this change
    return if !$Self->{LinkObject}->LinkDeleteAll(
        Object => 'ITSMChange',
        Key    => $Param{ChangeID},
        UserID => 1,
    );

    # TODO: delete the history

    # get change data to get the work order ids,
    # and to be given to post event handler
    my $ChangeData = $Self->ChangeGet(
        ChangeID => $Param{ChangeID},
        UserID   => $Param{UserID},
    );

    # check if change contains work orders
    if (
        $ChangeData
        && ref $ChangeData eq 'HASH'
        && $ChangeData->{WorkOrderIDs}
        && ref $ChangeData->{WorkOrderIDs} eq 'ARRAY'
        )
    {

        # delete the work orders
        for my $WorkOrderID ( @{ $ChangeData->{WorkOrderIDs} } ) {
            return if !$Self->{WorkOrderObject}->WorkOrderDelete(
                WorkOrderID => $WorkOrderID,
                UserID      => $Param{UserID},
            );
        }
    }

    # delete the CAB
    return if !$Self->ChangeCABDelete(
        ChangeID => $Param{ChangeID},
        UserID   => $Param{UserID},
    );

    # delete the change
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM change_item WHERE id = ? ',
        Bind => [ \$Param{ChangeID} ],
    );

    # trigger ChangeDeletePost-Event
    $Self->EventHandler(
        Event => 'ChangeDeletePost',
        Data  => {
            OldChangeData => $ChangeData,
            %Param,
        },
        UserID => $Param{UserID},
    );

    return 1;
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

    return;
}

=item ChangeWorkflowList()

list the workflow of a change

NOTE: To be defined in more detail!

    my $ChangeWorkflow = $ChangeObject->ChangeWorkflowList(
        ChangeID => 123,
        UserID   => 1,
    );

=cut

sub ChangeWorkflowList {
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
            Message  => 'Need ChangeStateID!',
        );
        return;
    }

    # get change state list
    my $ChangeStateList = $Self->{GeneralCatalogObject}->ItemList(
        Class => 'ITSM::ChangeManagement::Change::State',
    );

    # check the change state id
    if (
        !$ChangeStateList
        || ref $ChangeStateList ne 'HASH'
        || !$ChangeStateList->{ $Param{ChangeStateID} }
        )
    {

        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "ChangeStateID $Param{ChangeStateID} is not a valid change state id!",
        );
        return;
    }

    return 1;
}

=item _ChangeNumberCreate()

create a new change number

    my $ChangeNumber = $ChangeObject->_ChangeNumberCreate();

=cut

sub _ChangeNumberCreate {
    my ( $Self, %Param ) = @_;

    # get needed config options
    my $CounterLog = $Self->{ConfigObject}->Get('ITSMChange::CounterLog');
    my $SystemID   = $Self->{ConfigObject}->Get('SystemID');

    # define number of maximum loops if created change number exists
    my $MaxRetryNumber        = 16000;
    my $LoopProtectionCounter = 0;

    # try to create a unique change number for up to $MaxRetryNumber times
    while ( $LoopProtectionCounter <= $MaxRetryNumber ) {

        # get current time
        my ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = $Self->{TimeObject}->SystemTime2Date(
            SystemTime => $Self->{TimeObject}->SystemTime(),
        );

        # read count
        my $Count      = 0;
        my $LastModify = '';
        if ( -f $CounterLog ) {
            my $ContentSCALARRef = $Self->{MainObject}->FileRead(
                Location => $CounterLog,
            );
            if ( $ContentSCALARRef && ${$ContentSCALARRef} ) {
                ( $Count, $LastModify ) = split( /;/, ${$ContentSCALARRef} );

                # just debug
                if ( $Self->{Debug} > 0 ) {
                    $Self->{LogObject}->Log(
                        Priority => 'debug',
                        Message  => "Read counter from $CounterLog: $Count",
                    );
                }
            }
        }

        # check if we need to reset the counter
        if ( !$LastModify || $LastModify ne "$Year-$Month-$Day" ) {
            $Count = 0;
        }

        # count auto increment
        $Count++;

        # increase the the counter faster if we are in loop pretection mode
        $Count += $LoopProtectionCounter;

        my $Content = $Count . ";$Year-$Month-$Day;";

        # write new count
        my $Write = $Self->{MainObject}->FileWrite(
            Location => $CounterLog,
            Content  => \$Content,
        );
        if ($Write) {
            if ( $Self->{Debug} > 0 ) {
                $Self->{LogObject}->Log(
                    Priority => 'debug',
                    Message  => "Write counter: $Count",
                );
            }
        }

        # pad ticket number with leading '0' to length 5
        $Count = sprintf "%05d", $Count;

        # create new change number
        my $ChangeNumber = $Year . $Month . $Day . $SystemID . $Count;

        # calculate a checksum
        my $ChkSum = 0;
        my $Mult   = 1;
        for ( my $i = 0; $i < length($ChangeNumber); ++$i ) {
            my $Digit = substr( $ChangeNumber, $i, 1 );
            $ChkSum = $ChkSum + ( $Mult * $Digit );
            $Mult += 1;
            if ( $Mult == 3 ) {
                $Mult = 1;
            }
        }
        $ChkSum %= 10;
        $ChkSum = 10 - $ChkSum;
        if ( $ChkSum == 10 ) {
            $ChkSum = 1;
        }

        # add checksum to change number
        $ChangeNumber .= $ChkSum;

        # lookup if change number exists already
        my $ChangeID = $Self->ChangeLookup(
            ChangeNumber => $ChangeNumber,
            UserID       => 1,
        );

        # now we have a new unused change number and return it
        return $ChangeNumber if !$ChangeID;

        # start loop protection mode
        $LoopProtectionCounter++;

        # create new change number again
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "ChangeNumber ($ChangeNumber) exists! Creating a new one.",
        );
    }

    # loop was running too long
    $Self->{LogObject}->Log(
        Priority => 'error',
        Message  => "LoopProtectionCounter is now $LoopProtectionCounter!"
            . " Stopped ChangeNumberCreate()!",
    );
    return;
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
        ChangeTitle     => 'Replacement of mail server',       # (optional)
        Description     => 'New mail server is faster',        # (optional)
        Justification   => 'Old mail server too slow',         # (optional)
        ChangeStateID   => 4,                                  # (optional)
        ChangeManagerID => 5,                                  # (optional)
        ChangeBuilderID => 6,                                  # (optional)
        CABAgents       => [ 1, 2, 4 ],     # UserIDs          # (optional)
        CABCustomers    => [ 'tt', 'mm' ],  # CustomerUserIDs  # (optional)
    );

These string parameters have length constraints:

    Parameter      | max. length
    ---------------+-----------------
    ChangeTitle    |  250 characters
    Description    | 3800 characters
    Justification  | 3800 characters

=cut

sub _CheckChangeParams {
    my ( $Self, %Param ) = @_;

    # check the string and id parameters
    ARGUMENT:
    for my $Argument (
        qw(
        ChangeTitle
        Description
        Justification
        ChangeManagerID
        ChangeBuilderID
        ChangeStateID
        )
        )
    {

        # params are not required
        next ARGUMENT if !exists $Param{$Argument};

        # check if param is not defined
        if ( !defined $Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "The parameter '$Argument' must be defined!",
            );
            return;
        }

        # check if param is not a reference
        if ( ref $Param{$Argument} ne '' ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "The parameter '$Argument' mustn't be a reference!",
            );
            return;
        }

        # check the maximum length of title
        if ( $Argument eq 'ChangeTitle' && length( $Param{$Argument} ) > 250 ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "The parameter '$Argument' must be shorter than 250 characters!",
            );
            return;
        }

        # check the maximum length of description and justification
        if ( $Argument eq 'Description' || $Argument eq 'Justification' ) {
            if ( length( $Param{$Argument} ) > 3800 ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "The parameter '$Argument' must be shorter than 3800 characters!",
                );
                return;
            }
        }
    }

    # check if given ChangeStateID is valid
    if ( $Param{ChangeStateID} ) {
        return if !$Self->_CheckChangeStateID(
            ChangeStateID => $Param{ChangeStateID},
        );
    }

    # change manager and change builder must be agents
    ARGUMENT:
    for my $Argument (qw( ChangeManagerID ChangeBuilderID )) {

        # params are not required
        next ARGUMENT if !exists $Param{$Argument};

        # get user data
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
                Message  => 'The parameter CABAgents is not an ARRAY reference!',
            );
            return;
        }

        # check users
        for my $UserID ( @{ $Param{CABAgents} } ) {

            # get user data
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
                Message  => 'The parameter CABCustomers is not an ARRAY reference!',
            );
            return;
        }

        # check customer users
        for my $CustomerUser ( @{ $Param{CABCustomers} } ) {

            # get customer user data
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

=item ChangeStateLookup()

This method does a lookup for a change state. If a change state id is given,
it returns the name of the change state. If a change state name is given,
the appropriate id is returned.

    my $Name = $ChangeObject->ChangeStateLookup(
        StateID => 1234,
    );

    my $ID = $ChangeObject->ChangeStateLookup(
        State => 'accepted',
    );

=cut

sub ChangeStateLookup {
    my ( $Self, %Param ) = @_;

    # get the key
    my ($Key) = grep { $Param{$_} } qw(StateID State);

    # check for needed stuff
    if ( !$Key ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need StateID or State!',
        );
        return;
    }

    if ( $Param{StateID} && $Param{State} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need StateID OR State - not both!',
        );
        return;
    }

    # get change state from general catalog
    my $ChangeStates = $Self->{GeneralCatalogObject}->ItemList(
        Class => 'ITSM::ChangeManagement::Change::State',
    ) || {};

    my %List = %{$ChangeStates};

    # reverse key - value pairs to have the name as keys
    if ( $Key eq 'State' ) {
        %List = reverse %List;
    }

    return $List{ $Param{$Key} };
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

$Revision: 1.109 $ $Date: 2009-10-26 15:45:49 $

=cut
