# --
# Kernel/System/ITSMChange/ITSMWorkOrder.pm - all workorder functions
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange::ITSMWorkOrder;

use strict;
use warnings;

use Kernel::System::EventHandler;
use Kernel::System::GeneralCatalog;
use Kernel::System::LinkObject;
use Kernel::System::ITSMChange::ITSMStateMachine;
use Kernel::System::ITSMChange::ITSMCondition;
use Kernel::System::VirtualFS;
use Kernel::System::HTMLUtils;
use Kernel::System::Cache;

use vars qw(@ISA);

@ISA = (
    'Kernel::System::EventHandler',
);

=head1 NAME

Kernel::System::ITSMChange::ITSMWorkOrder - workorder lib

=head1 SYNOPSIS

All functions for workorders in ITSMChangeManagement.

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
    use Kernel::System::Group;
    use Kernel::System::User;
    use Kernel::System::ITSMChange::ITSMWorkOrder;

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
    my $GroupObject = Kernel::System::Group->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        MainObject   => $MainObject,
    );
    my $UserObject = Kernel::System::User->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        TimeObject   => $TimeObject,
        MainObject   => $MainObject,
    );
    my $WorkOrderObject = Kernel::System::ITSMChange::ITSMWorkOrder->new(
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
    for my $Object (
        qw(DBObject ConfigObject EncodeObject LogObject UserObject GroupObject MainObject TimeObject)
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    # set the debug flag
    $Self->{Debug} = $Param{Debug} || 0;

    # create additional objects
    $Self->{CacheObject}          = Kernel::System::Cache->new( %{$Self} );
    $Self->{GeneralCatalogObject} = Kernel::System::GeneralCatalog->new( %{$Self} );
    $Self->{LinkObject}           = Kernel::System::LinkObject->new( %{$Self} );
    $Self->{StateMachineObject}   = Kernel::System::ITSMChange::ITSMStateMachine->new( %{$Self} );
    $Self->{ConditionObject}      = Kernel::System::ITSMChange::ITSMCondition->new( %{$Self} );
    $Self->{HTMLUtilsObject}      = Kernel::System::HTMLUtils->new( %{$Self} );
    $Self->{VirtualFSObject}      = Kernel::System::VirtualFS->new( %{$Self} );

    # get the cache TTL (in seconds)
    $Self->{CacheTTL} = $Self->{ConfigObject}->Get('ITSMChange::CacheTTL') * 60;

    # init of event handler
    $Self->EventHandlerInit(
        Config     => 'ITSMWorkOrder::EventModule',
        BaseObject => 'WorkOrderObject',
        Objects    => {
            %{$Self},
        },
    );

    # get database type
    $Self->{DBType} = $Self->{DBObject}->{'DB::Type'} || '';
    $Self->{DBType} = lc $Self->{DBType};

    return $Self;
}

=item WorkOrderAdd()

Add a new workorder.
Internally first a minimal workorder is created,
then WorkOrderUpdate() is called for setting the remaining arguments.

    my $WorkOrderID = $WorkOrderObject->WorkOrderAdd(
        ChangeID => 123,
        UserID   => 1,
    );

or

    my $WorkOrderID = $WorkOrderObject->WorkOrderAdd(
        ChangeID           => 123,
        WorkOrderTitle     => 'Replacement of mail server',              # (optional)
        Instruction        => 'Install the the new server',              # (optional)
        Report             => 'Installed new server without problems',   # (optional)
        WorkOrderStateID   => 157,                                       # (optional) or WorkOrderState => 'ready'
        WorkOrderState     => 'ready',                                   # (optional) or WorkOrderStateID => 157
        WorkOrderTypeID    => 161,                                       # (optional) or WorkOrderType => 'pir'
        WorkOrderType      => 'ready',                                   # (optional) or WorkOrderTypeID => 161
        WorkOrderAgentID   => 8,                                         # (optional)
        PlannedStartTime   => '2009-10-12 00:00:01',                     # (optional)
        PlannedEndTime     => '2009-10-15 15:00:00',                     # (optional)
        ActualStartTime    => '2009-10-14 00:00:01',                     # (optional)
        ActualEndTime      => '2009-01-20 00:00:01',                     # (optional)
        PlannedEffort      => 123,                                       # (optional)
        WorkOrderFreeKey1  => 'Sun',                                     # (optional) workorder freekey fields from 1 to ITSMWorkOrder::FreeText::MaxNumber
        WorkOrderFreeText1 => 'Earth',                                   # (optional) workorder freetext fields from 1 to ITSMWorkOrder::FreeText::MaxNumber
        UserID             => 1,
    );

=cut

sub WorkOrderAdd {
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

    # check that not both WorkOrderState and WorkOrderStateID are given
    if ( $Param{WorkOrderState} && $Param{WorkOrderStateID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need either WorkOrderState OR WorkOrderStateID - not both!',
        );
        return;
    }

    # if a State is given, then look up the ID
    if ( $Param{WorkOrderState} ) {
        $Param{WorkOrderStateID} = $Self->WorkOrderStateLookup(
            WorkOrderState => $Param{WorkOrderState},
        );

        # delete the workorder state otherwise the update fails
        # as both WorkOrderState and WorkOrderStateID exists then
        delete $Param{WorkOrderState};
    }

    # check that not both WorkOrderType and WorkOrderTypeID are given
    if ( $Param{WorkOrderType} && $Param{WorkOrderTypeID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need either WorkOrderType OR WorkOrderTypeID - not both!',
        );
        return;
    }

    # if Type is given, then look up the ID
    if ( $Param{WorkOrderType} ) {
        $Param{WorkOrderTypeID} = $Self->WorkOrderTypeLookup(
            WorkOrderType => $Param{WorkOrderType},
        );

        # delete the workorder type otherwise the update fails
        # as both WorkOrderType and WorkOrderTypeID exists then
        delete $Param{WorkOrderType};
    }

    # get a plain text version of arguments which might contain HTML markup
    ARGUMENT:
    for my $Argument (qw(Instruction Report)) {

        next ARGUMENT if !exists $Param{$Argument};

        $Param{"${Argument}Plain"} = $Self->{HTMLUtilsObject}->ToAscii(
            String => $Param{$Argument},
        );

        # Even when passed a plain ASCII string,
        # ToAscii() can return a non-utf8 string with chars in the extended range.
        # Upgrade to utf-8 in order to comply to the OTRS-convention.
        if ( $Self->{EncodeObject}->CharsetInternal() ) {
            utf8::upgrade( $Param{"${Argument}Plain"} );
        }
    }

    # check the parameters
    return if !$Self->_CheckWorkOrderParams(%Param);

    # trigger WorkOrderAddPre-Event
    $Self->EventHandler(
        Event => 'WorkOrderAddPre',
        Data  => {
            %Param,
        },
        UserID => $Param{UserID},
    );

    # set initial WorkOrderStateID, use default if not passed
    my $WorkOrderStateID = delete $Param{WorkOrderStateID};
    if ( !$WorkOrderStateID ) {

        # get initial workorder state id
        my $NextStateIDs = $Self->{StateMachineObject}->StateTransitionGet(
            StateID => 0,
            Class   => 'ITSM::ChangeManagement::WorkOrder::State',
        );
        $WorkOrderStateID = $NextStateIDs->[0];
    }

    # set default WorkOrderTypeID, use default if not passed
    my $WorkOrderTypeID = delete $Param{WorkOrderTypeID};
    if ( !$WorkOrderTypeID ) {

        # set config option
        my $ConfigOption = 'ITSMWorkOrder::Type::Default';

        # get default workorder type from config
        my $DefaultType = $Self->{ConfigObject}->Get($ConfigOption);

        # check if default type exists in general catalog
        my $ItemDataRef = $Self->{GeneralCatalogObject}->ItemGet(
            Class => 'ITSM::ChangeManagement::WorkOrder::Type',
            Name  => $DefaultType,
        );

        # error handling because of invalid config setting
        if ( !$ItemDataRef || ref $ItemDataRef ne 'HASH' || !%{$ItemDataRef} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "The default WorkOrderType '$DefaultType' "
                    . "in sysconfig option '$ConfigOption' is invalid! Check the general catalog!",
            );
            return;
        }

        # set default
        $WorkOrderTypeID = $ItemDataRef->{ItemID};
    }

    # get a unique workorder number
    my $WorkOrderNumber = $Self->_GetWorkOrderNumber(%Param);

    # add WorkOrder to database
    return if !$Self->{DBObject}->Do(
        SQL => 'INSERT INTO change_workorder '
            . '(change_id, workorder_number, workorder_state_id, workorder_type_id, '
            . 'create_time, create_by, change_time, change_by) '
            . 'VALUES (?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{ChangeID}, \$WorkOrderNumber, \$WorkOrderStateID, \$WorkOrderTypeID,
            \$Param{UserID}, \$Param{UserID},
        ],
    );

    # get WorkOrderID
    return if !$Self->{DBObject}->Prepare(
        SQL   => 'SELECT id FROM change_workorder WHERE change_id = ? AND workorder_number = ?',
        Bind  => [ \$Param{ChangeID}, \$WorkOrderNumber ],
        Limit => 1,
    );

    # fetch the result
    my $WorkOrderID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $WorkOrderID = $Row[0];
    }

    # check error
    if ( !$WorkOrderID ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "WorkOrderAdd() failed!",
        );
        return;
    }

    # delete cache
    for my $Key (
        'WorkOrderGet::ID::' . $WorkOrderID,
        'WorkOrderList::ChangeID::' . $Param{ChangeID},
        'WorkOrderChangeEffortsGet::ChangeID::' . $Param{ChangeID},
        'WorkOrderChangeTimeGet::ChangeID::' . $Param{ChangeID},
        'ChangeGet::ID::' . $Param{ChangeID},
        )
    {

        $Self->{CacheObject}->Delete(
            Type => 'ITSMChangeManagement',
            Key  => $Key,
        );
    }

    # trigger WorkOrderAddPost-Event
    # (yes, we want do do this before the WorkOrderUpdate!)
    $Self->EventHandler(
        Event => 'WorkOrderAddPost',
        Data  => {
            %Param,
            WorkOrderID      => $WorkOrderID,
            WorkOrderNumber  => $WorkOrderNumber,
            WorkOrderStateID => $WorkOrderStateID,
            WorkOrderTypeID  => $WorkOrderTypeID,
        },
        UserID => $Param{UserID},
    );

    # update WorkOrder with remaining parameters,
    # the already handles params have been deleted from %Param
    my $UpdateSuccess = $Self->WorkOrderUpdate(
        %Param,
        WorkOrderID => $WorkOrderID,
    );

    # check update error
    if ( !$UpdateSuccess ) {

        # delete workorder if it could not be updated
        $Self->WorkOrderDelete(
            WorkOrderID => $WorkOrderID,
            UserID      => $Param{UserID},
        );

        return;
    }

    return $WorkOrderID;
}

=item WorkOrderUpdate()

Update a workorder.
Leading and trailing whitespace is removed from C<WorkOrderTitle>.
Passing undefined values is generally not allowed. An exception
are the parameters C<PlannedStartTime>, C<PlannedEndTime>, C<ActualStartTime>, and C<ActualEndTime>.
There passing C<undef> indicates that the workorder time should be cleared.
Another exception is the WorkOrderAgentID. Pass undef for removing the workorder agent.

    my $Success = $WorkOrderObject->WorkOrderUpdate(
        WorkOrderID        => 4,
        WorkOrderNumber    => 5,                                         # (optional)
        WorkOrderTitle     => 'Replacement of mail server',              # (optional)
        Instruction        => 'Install the the new server',              # (optional)
        Report             => 'Installed new server without problems',   # (optional)
        WorkOrderStateID   => 157,                                       # (optional) or WorkOrderState => 'ready'
        WorkOrderState     => 'ready',                                   # (optional) or WorkOrderStateID => 157
        WorkOrderTypeID    => 161,                                       # (optional) or WorkOrderType => 'pir'
        WorkOrderType      => 'pir',                                     # (optional) or WorkOrderStateID => 161
        WorkOrderAgentID   => 8,                                         # (optional) can be undef for removing the workorder agent
        PlannedStartTime   => '2009-10-12 00:00:01',                     # (optional) 'undef' indicates clearing
        PlannedEndTime     => '2009-10-15 15:00:00',                     # (optional) 'undef' indicates clearing
        ActualStartTime    => '2009-10-14 00:00:01',                     # (optional) 'undef' indicates clearing
        ActualEndTime      => '2009-01-20 00:00:01',                     # (optional) 'undef' indicates clearing
        PlannedEffort      => 123,                                       # (optional)
        AccountedTime      => 13,                                        # (optional) the value is added to the value in the database
        WorkOrderFreeKey1  => 'Sun',                                     # (optional) workorder freekey fields from 1 to ITSMWorkOrder::FreeText::MaxNumber
        WorkOrderFreeText1 => 'Earth',                                   # (optional) workorder freetext fields from 1 to ITSMWorkOrder::FreeText::MaxNumber
        NoNumberCalc       => 1,                                         # (optional) default 0, if 1 it prevents a recalculation of the workorder numbers
        BypassStateMachine => 1,                                         # (optional) default 0, if 1 the state machine will be bypassed
        UserID             => 1,
    );

Constraints:

C<xxxStartTime> has to be before C<xxxEndTime>. If just one of the parameter pair is passed
the other time is retrieved from database.
The C<WorkOrderStateID> is checked against the state machine.

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

    # check that not both WorkOrderState and WorkOrderStateID are given
    if ( $Param{WorkOrderState} && $Param{WorkOrderStateID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need either WorkOrderState OR WorkOrderStateID - not both!',
        );
        return;
    }

    # when the State is given, then look up the ID
    if ( $Param{WorkOrderState} ) {
        $Param{WorkOrderStateID} = $Self->WorkOrderStateLookup(
            WorkOrderState => $Param{WorkOrderState},
        );
    }

    # check that not both Type and TypeID are given
    if ( $Param{WorkOrderType} && $Param{WorkOrderTypeID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need either WorkOrderType OR WorkOrderTypeID - not both!',
        );
        return;
    }

    # if Type is given, then look up the ID
    if ( $Param{WorkOrderType} ) {
        $Param{WorkOrderTypeID} = $Self->WorkOrderTypeLookup(
            WorkOrderType => $Param{WorkOrderType},
        );
    }

    # normalize the Title, when it is given
    if ( $Param{WorkOrderTitle} && !ref $Param{WorkOrderTitle} ) {

        # remove leading whitespace
        $Param{WorkOrderTitle} =~ s{ \A \s+ }{}xms;

        # remove trailing whitespace
        $Param{WorkOrderTitle} =~ s{ \s+ \z }{}xms;
    }

    # get a plain text version of arguments which might contain HTML markup
    ARGUMENT:
    for my $Argument (qw(Instruction Report)) {

        next ARGUMENT if !exists $Param{$Argument};

        $Param{"${Argument}Plain"} = $Self->{HTMLUtilsObject}->ToAscii(
            String => $Param{$Argument},
        );

        # Even when passed a plain ASCII string,
        # ToAscii() can return a non-utf8 string with chars in the extended range.
        # Upgrade to utf-8 in order to comply to the OTRS-convention.
        if ( $Self->{EncodeObject}->CharsetInternal() ) {
            utf8::upgrade( $Param{"${Argument}Plain"} );
        }
    }

    # default values for planned effort and accounted time
    # this avoids superflous history entries
    ARGUMENT:
    for my $Argument (qw(PlannedEffort AccountedTime)) {

        next ARGUMENT if !exists $Param{$Argument};

        $Param{$Argument} ||= 0;
    }

    # check the given parameters
    return if !$Self->_CheckWorkOrderParams(%Param);

    # check sanity of the new state with the state machine
    if ( $Param{WorkOrderStateID} ) {

        # get workorder id
        my $WorkOrderID = $Param{WorkOrderID};

        # do not give WorkOrderPossibleStatesGet() the WorkOrderID
        # if the statemachine should be bypassed.
        # WorkOrderPossibleStatesGet() will then return all workorder states
        if ( $Param{BypassStateMachine} ) {
            $WorkOrderID = undef;
        }

        # get the list of possible next states
        my $StateList = $Self->WorkOrderPossibleStatesGet(
            WorkOrderID => $WorkOrderID,
            UserID      => $Param{UserID},
        );
        if ( !grep { $_->{Key} == $Param{WorkOrderStateID} } @{$StateList} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "The state $Param{WorkOrderStateID} is not a possible next state!",
            );
            return;
        }
    }

    # get old data to be given to _CheckWorkOrderParams() and the post event handler
    my $WorkOrderData = $Self->WorkOrderGet(
        WorkOrderID => $Param{WorkOrderID},
        UserID      => $Param{UserID},
    );

    # check if the timestamps are correct
    return if !$Self->_CheckTimestamps(
        %Param,
        WorkOrderData => $WorkOrderData,
    );

    # trigger WorkOrderUpdatePre-Event
    $Self->EventHandler(
        Event => 'WorkOrderUpdatePre',
        Data  => {
            %Param,
        },
        UserID => $Param{UserID},
    );

    # update workorder freekey and freetext fields
    return if !$Self->_WorkOrderFreeTextUpdate(%Param);

    # map update attributes to column names
    my %Attribute = (
        WorkOrderTitle   => 'title',
        WorkOrderNumber  => 'workorder_number',
        Instruction      => 'instruction',
        Report           => 'report',
        WorkOrderStateID => 'workorder_state_id',
        WorkOrderTypeID  => 'workorder_type_id',
        WorkOrderAgentID => 'workorder_agent_id',
        PlannedStartTime => 'planned_start_time',
        PlannedEndTime   => 'planned_end_time',
        ActualStartTime  => 'actual_start_time',
        ActualEndTime    => 'actual_end_time',
        InstructionPlain => 'instruction_plain',
        ReportPlain      => 'report_plain',
    );

    # build SQL to update workorder
    my $SQL = 'UPDATE change_workorder SET ';
    my @Bind;

    # define the DefaultTimeStamp
    my $DefaultTimeStamp = '9999-01-01 00:00:00';

    ATTRIBUTE:
    for my $Attribute ( sort keys %Attribute ) {

        # preserve the old value, when the column isn't in function parameters
        next ATTRIBUTE if !exists $Param{$Attribute};

        # attribute is defined
        if ( defined $Param{$Attribute} ) {
            $SQL .= "$Attribute{$Attribute} = ?, ";
            push @Bind, \$Param{$Attribute};
        }

        # it's ok if the WorkOrderAgentID is not defined
        elsif ( $Attribute eq 'WorkOrderAgentID' ) {
            $SQL .= "$Attribute{$Attribute} = NULL, ";
        }

        # attribute is not defined and is one of the time parameters
        elsif ( $Attribute =~ m{ \A ( Actual | Planned ) ( Start | End ) Time \z }xms ) {
            $SQL .= "$Attribute{$Attribute} = ?, ";
            push @Bind, \$DefaultTimeStamp;
        }
    }

    # addition of accounted time
    if ( $Param{AccountedTime} ) {

        # get current accounted time
        my $CurrentAccountedTime = $WorkOrderData->{AccountedTime} || 0;

        # add new accouted time to current accounted time
        my $AccountedTime = $CurrentAccountedTime + $Param{AccountedTime};

        # db quote
        $AccountedTime = $Self->{DBObject}->Quote( $AccountedTime, 'Number' );

        # build SQL (without binds)
        $SQL .= "accounted_time = $AccountedTime, ";
    }

    # setting of planned effort
    if ( $Param{PlannedEffort} ) {

        # db quote
        $Param{PlannedEffort} = $Self->{DBObject}->Quote( $Param{PlannedEffort}, 'Number' );

        # build SQL (without binds)
        $SQL .= "planned_effort = $Param{PlannedEffort}, ";
    }

    $SQL .= 'change_time = current_timestamp, change_by = ? ';
    push @Bind, \$Param{UserID};
    $SQL .= 'WHERE id = ?';
    push @Bind, \$Param{WorkOrderID};

    # update workorder
    return if !$Self->{DBObject}->Do(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    # delete cache
    for my $Key (
        'WorkOrderGet::ID::' . $Param{WorkOrderID},
        'WorkOrderList::ChangeID::' . $WorkOrderData->{ChangeID},
        'WorkOrderChangeEffortsGet::ChangeID::' . $WorkOrderData->{ChangeID},
        'WorkOrderChangeTimeGet::ChangeID::' . $WorkOrderData->{ChangeID},
        'ChangeGet::ID::' . $WorkOrderData->{ChangeID},
        )
    {

        $Self->{CacheObject}->Delete(
            Type => 'ITSMChangeManagement',
            Key  => $Key,
        );
    }

    # trigger WorkOrderUpdatePost-Event
    $Self->EventHandler(
        Event => 'WorkOrderUpdatePost',
        Data  => {
            OldWorkOrderData => $WorkOrderData,
            %Param,
        },
        UserID => $Param{UserID},
    );

    return 1;
}

=item WorkOrderGet()

Return a WorkOrder as hash reference.
When the workorder does not exist, a false value is returned.
The optional option C<LogNo> turns off logging when the workorder does not exist.

    my $WorkOrderRef = $WorkOrderObject->WorkOrderGet(
        WorkOrderID => 123,
        UserID      => 1,
        LogNo       => 1,      # optional, turns off logging when the workorder does not exist
    );

The returned hash reference contains following elements:

    $WorkOrder{WorkOrderID}
    $WorkOrder{ChangeID}
    $WorkOrder{WorkOrderNumber}
    $WorkOrder{WorkOrderTitle}
    $WorkOrder{Instruction}
    $WorkOrder{InstructionPlain}
    $WorkOrder{Report}
    $WorkOrder{ReportPlain}
    $WorkOrder{WorkOrderStateID}
    $WorkOrder{WorkOrderState}              # fetched from the general catalog
    $WorkOrder{WorkOrderStateSignal}        # fetched from SysConfig
    $WorkOrder{WorkOrderTypeID}
    $WorkOrder{WorkOrderType}               # fetched from the general catalog
    $WorkOrder{WorkOrderAgentID}
    $WorkOrder{PlannedStartTime}
    $WorkOrder{PlannedEndTime}
    $WorkOrder{ActualStartTime}
    $WorkOrder{ActualEndTime}
    $WorkOrder{AccountedTime}
    $WorkOrder{PlannedEffort}
    $WorkOrder{WorkOrderFreeKey1}           # workorder freekey fields from 1 to ITSMWorkOrder::FreeText::MaxNumber
    $WorkOrder{WorkOrderFreeText1}          # workorder freetext fields from 1 to ITSMWorkOrder::FreeText::MaxNumber
    $WorkOrder{CreateTime}
    $WorkOrder{CreateBy}
    $WorkOrder{ChangeTime}
    $WorkOrder{ChangeBy}

=cut

sub WorkOrderGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Attribute (qw(WorkOrderID UserID)) {
        if ( !$Param{$Attribute} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Attribute!",
            );
            return;
        }
    }

    my %WorkOrderData;

    # check cache
    my $CacheKey = 'WorkOrderGet::ID::' . $Param{WorkOrderID};
    my $Cache    = $Self->{CacheObject}->Get(
        Type => 'ITSMChangeManagement',
        Key  => $CacheKey,
    );

    if ($Cache) {

        # get data from cache
        %WorkOrderData = %{$Cache};
    }

    else {

        # get data from database
        return if !$Self->{DBObject}->Prepare(
            SQL => 'SELECT id, change_id, workorder_number, title, '
                . 'instruction, instruction_plain, '
                . 'report, report_plain, '
                . 'workorder_state_id, workorder_type_id, workorder_agent_id, '
                . 'planned_start_time, planned_end_time, actual_start_time, actual_end_time, '
                . 'create_time, create_by, '
                . 'change_time, change_by, '
                . 'planned_effort, accounted_time '
                . 'FROM change_workorder '
                . 'WHERE id = ?',
            Bind  => [ \$Param{WorkOrderID} ],
            Limit => 1,
        );

        # fetch the result
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            $WorkOrderData{WorkOrderID}      = $Row[0];
            $WorkOrderData{ChangeID}         = $Row[1];
            $WorkOrderData{WorkOrderNumber}  = $Row[2];
            $WorkOrderData{WorkOrderTitle}   = defined $Row[3] ? $Row[3] : '';
            $WorkOrderData{Instruction}      = defined $Row[4] ? $Row[4] : '';
            $WorkOrderData{InstructionPlain} = defined $Row[5] ? $Row[5] : '';
            $WorkOrderData{Report}           = defined $Row[6] ? $Row[6] : '';
            $WorkOrderData{ReportPlain}      = defined $Row[7] ? $Row[7] : '';
            $WorkOrderData{WorkOrderStateID} = $Row[8];
            $WorkOrderData{WorkOrderTypeID}  = $Row[9];
            $WorkOrderData{WorkOrderAgentID} = $Row[10];
            $WorkOrderData{PlannedStartTime} = $Row[11];
            $WorkOrderData{PlannedEndTime}   = $Row[12];
            $WorkOrderData{ActualStartTime}  = $Row[13];
            $WorkOrderData{ActualEndTime}    = $Row[14];
            $WorkOrderData{CreateTime}       = $Row[15];
            $WorkOrderData{CreateBy}         = $Row[16];
            $WorkOrderData{ChangeTime}       = $Row[17];
            $WorkOrderData{ChangeBy}         = $Row[18];
            $WorkOrderData{PlannedEffort}    = $Row[19];
            $WorkOrderData{AccountedTime}    = $Row[20];
        }

        # check error
        if ( !%WorkOrderData ) {
            if ( !$Param{LogNo} ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "WorkOrderID $Param{WorkOrderID} does not exist!",
                );
            }
            return;
        }

        TIMEFIELD:
        for my $Time (qw(PlannedStartTime PlannedEndTime ActualStartTime ActualEndTime)) {

            next TIMEFIELD if !$WorkOrderData{$Time};

            # cleanup time stamps (some databases are using e. g. 2008-02-25 22:03:00.000000)
            $WorkOrderData{$Time}
                =~ s{ \A ( \d\d\d\d - \d\d - \d\d \s \d\d:\d\d:\d\d ) \. .+? \z }{$1}xms;

            # replace default time values with empty string
            if ( $WorkOrderData{$Time} eq '9999-01-01 00:00:00' ) {
                $WorkOrderData{$Time} = '';
            }
        }

        ATTRIBUTE:
        for my $Attribute (qw(PlannedEffort AccountedTime)) {

            next ATTRIBUTE if !$WorkOrderData{$Attribute};

            # do not show zero values
            if ( $WorkOrderData{$Attribute} eq 0 ) {
                $WorkOrderData{$Attribute} = '';
                next ATTRIBUTE;
            }

            # convert decimal character from ',' to '.' if neccessary
            $WorkOrderData{$Attribute} =~ s{,}{.}xmsg;

            # format as decimal number
            $WorkOrderData{$Attribute} = sprintf '%.2f', $WorkOrderData{$Attribute};
        }

        # get workorder freekey and freetext data
        my $WorkOrderFreeText = $Self->_WorkOrderFreeTextGet(
            WorkOrderID => $Param{WorkOrderID},
            UserID      => $Param{UserID},
        );

        # add result to workorder data
        %WorkOrderData = ( %WorkOrderData, %{$WorkOrderFreeText} );

        # set cache (workorder data exists at this point, it was checked before)
        $Self->{CacheObject}->Set(
            Type  => 'ITSMChangeManagement',
            Key   => $CacheKey,
            Value => \%WorkOrderData,
            TTL   => $Self->{CacheTTL},
        );
    }

    # add the name of the workorder state
    if ( $WorkOrderData{WorkOrderStateID} ) {
        $WorkOrderData{WorkOrderState} = $Self->WorkOrderStateLookup(
            WorkOrderStateID => $WorkOrderData{WorkOrderStateID},
        );
    }

    # add the workorder state signal
    if ( $WorkOrderData{WorkOrderState} ) {

        # get all workorder state signals
        my $StateSignal = $Self->{ConfigObject}->Get('ITSMWorkOrder::State::Signal');

        $WorkOrderData{WorkOrderStateSignal} = $StateSignal->{ $WorkOrderData{WorkOrderState} };
    }

    # add the name of the workorder type
    if ( $WorkOrderData{WorkOrderTypeID} ) {
        $WorkOrderData{WorkOrderType} = $Self->WorkOrderTypeLookup(
            WorkOrderTypeID => $WorkOrderData{WorkOrderTypeID},
        );
    }

    return \%WorkOrderData;
}

=item WorkOrderList()

Return a list of all workorder ids of the given change as array reference.
The workorder ids are ordered by workorder number.

    my $WorkOrderIDsRef = $WorkOrderObject->WorkOrderList(
        ChangeID => 5,
        UserID   => 1,
    );

=cut

sub WorkOrderList {
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

    my @WorkOrderIDs;

    # check cache
    my $CacheKey = 'WorkOrderList::ChangeID::' . $Param{ChangeID};
    my $Cache    = $Self->{CacheObject}->Get(
        Type => 'ITSMChangeManagement',
        Key  => $CacheKey,
    );

    if ($Cache) {

        # get data from cache
        @WorkOrderIDs = @{$Cache};
    }

    # get data from database
    else {

        # get workorder ids
        return if !$Self->{DBObject}->Prepare(
            SQL =>
                'SELECT id FROM change_workorder '
                . 'WHERE change_id = ? '
                . 'ORDER BY workorder_number, id',
            Bind => [ \$Param{ChangeID} ],
        );

        # fetch the result
        while ( my ($ID) = $Self->{DBObject}->FetchrowArray() ) {
            push @WorkOrderIDs, $ID;
        }

        # set cache
        $Self->{CacheObject}->Set(
            Type  => 'ITSMChangeManagement',
            Key   => $CacheKey,
            Value => \@WorkOrderIDs,
            TTL   => $Self->{CacheTTL},
        );
    }

    return \@WorkOrderIDs;
}

=item WorkOrderSearch()

Returns either a list, as an arrayref, or a count of found workorder ids.
The count of results is returned when the parameter C<Result => 'COUNT'> is passed.

The search criteria are logically AND connected.
When a list is passed as criterium, the individual members are OR connected.
When an undef or a reference to an empty array is passed, then the search criterium
is ignored.

    my $WorkOrderIDsRef = $WorkOrderObject->WorkOrderSearch(
        ChangeIDs         => [ 123, 122 ]                              # (optional)
        WorkOrderNumber   => 12,                                       # (optional)

        WorkOrderTitle    => 'Replacement of mail server',             # (optional)
        Instruction       => 'Install the the new server',             # (optional)
        Report            => 'Installed new server without problems',  # (optional)

        # search in workorder freetext and freekey fields
        WorkOrderFreeKey1  => 'Sun',                                   # (optional) workorder freekey fields from 1 to ITSMWorkOrder::FreeText::MaxNumber
        WorkOrderFreeText1 => 'Earth',                                 # (optional) workorder freetext fields from 1 to ITSMWorkOrder::FreeText::MaxNumber

        WorkOrderStateIDs => [ 11, 12 ],                               # (optional)
        WorkOrderStates   => [ 'closed', 'canceled' ],                 # (optional)

        WorkOrderTypeIDs  => [ 21, 22 ],                               # (optional)
        WorkOrderTypes    => [ 'approval', 'workorder' ],              # (optional)

        WorkOrderAgentIDs => [ 1, 2, 3 ],                              # (optional)
        CreateBy          => [ 5, 2, 3 ],                              # (optional)
        ChangeBy          => [ 3, 2, 1 ],                              # (optional)

        # search in text fields of change object
        ChangeNumber        => 'Number of change',                     # (optional)
        ChangeTitle         => 'Title of change',                      # (optional)
        ChangeDescription   => 'Description of change',                # (optional)
        ChangeJustification => 'Justification of change',              # (optional)

        # workorders with planned start time after ...
        PlannedStartTimeNewerDate => '2006-01-09 00:00:01',            # (optional)
        # workorders with planned start time before then ....
        PlannedStartTimeOlderDate => '2006-01-19 23:59:59',            # (optional)

        # workorders with planned end time after ...
        PlannedEndTimeNewerDate   => '2006-01-09 00:00:01',            # (optional)
        # workorders with planned end time before then ....
        PlannedEndTimeOlderDate   => '2006-01-19 23:59:59',            # (optional)

        # workorders with actual start time after ...
        ActualStartTimeNewerDate  => '2006-01-09 00:00:01',            # (optional)
        # workorders with actual start time before then ....
        ActualStartTimeOlderDate  => '2006-01-19 23:59:59',            # (optional)

        # workorders with actual end time after ...
        ActualEndTimeNewerDate    => '2006-01-09 00:00:01',            # (optional)
        # workorders with actual end time before then ....
        ActualEndTimeOlderDate    => '2006-01-19 23:59:59',            # (optional)

        # workorders with created time after ...
        CreateTimeNewerDate       => '2006-01-09 00:00:01',            # (optional)
        # workorders with created time before then ....
        CreateTimeOlderDate       => '2006-01-19 23:59:59',            # (optional)

        # workorders with changed time after ...
        ChangeTimeNewerDate       => '2006-01-09 00:00:01',            # (optional)
        # workorders with changed time before then ....
        ChangeTimeOlderDate       => '2006-01-19 23:59:59',            # (optional)

        OrderBy => [ 'ChangeID', 'WorkOrderNumber' ],                  # (optional)
        # ignored when the result type is 'COUNT'
        # default: [ 'WorkOrderID' ],
        # (WorkOrderID, ChangeID, WorkOrderNumber, WorkOrderTitle
        # WorkOrderStateID, WorkOrderTypeID, WorkOrderAgentID,
        # PlannedStartTime, PlannedEndTime,
        # ActualStartTime, ActualEndTime,
        # CreateTime, CreateBy, ChangeTime, ChangeBy)

        # Additional information for OrderBy:
        # The OrderByDirection can be specified for each OrderBy attribute.
        # The pairing is made by the array indices.

        OrderByDirection => [ 'Down', 'Up' ],                          # (optional)
        # ignored when the result type is 'COUNT'
        # default: [ 'Down' ]
        # (Down | Up)

        UsingWildcards => 1,                                           # (optional)
        # (0 | 1) default 1

        Result => 'ARRAY' || 'COUNT',                                  # (optional)
        # default: ARRAY, returns an array of workorder ids
        # COUNT returns a scalar with the number of found workorders

        Limit => 100,                                                  # (optional)
        # ignored when the result type is 'COUNT'

        MirrorDB => 1,                                                 # (optional)
        # (0 | 1) default 0
        # if set to 1 and ITSMChange::ChangeSearch::MirrorDB
        # is activated and a mirror db is configured in
        # Core::MirrorDB::DSN the workorder search will then use
        # the mirror db

        UserID => 1,
    );

=cut

sub WorkOrderSearch {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );
        return;
    }

    # verify that all passed array parameters contain an arrayref
    ARGUMENT:
    for my $Argument (
        qw(
        OrderBy
        OrderByDirection
        WorkOrderStateIDs
        WorkOrderStates
        WorkOrderTypes
        WorkOrderTypeIDs
        ChangeIDs
        WorkOrderAgentIDs
        CreateBy
        ChangeBy
        )
        )
    {
        if ( !defined $Param{$Argument} ) {
            $Param{$Argument} ||= [];

            next ARGUMENT;
        }

        if ( ref $Param{$Argument} ne 'ARRAY' ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "$Argument must be an array reference!",
            );
            return;
        }
    }

    # define a local database object
    my $DBObject = $Self->{DBObject};

    # if we need to do a workorder search on an external mirror database
    if (
        $Param{MirrorDB}
        && $Self->{ConfigObject}->Get('ITSMChange::ChangeSearch::MirrorDB')
        && $Self->{ConfigObject}->Get('Core::MirrorDB::DSN')
        && $Self->{ConfigObject}->Get('Core::MirrorDB::User')
        && $Self->{ConfigObject}->Get('Core::MirrorDB::Password')
        )
    {

        # create an extra database object for the mirror db
        my $ExtraDatabaseObject = Kernel::System::DB->new(
            LogObject    => $Self->{LogObject},
            ConfigObject => $Self->{ConfigObject},
            MainObject   => $Self->{MainObject},
            EncodeObject => $Self->{EncodeObject},
            DatabaseDSN  => $Self->{ConfigObject}->Get('Core::MirrorDB::DSN'),
            DatabaseUser => $Self->{ConfigObject}->Get('Core::MirrorDB::User'),
            DatabasePw   => $Self->{ConfigObject}->Get('Core::MirrorDB::Password'),
        );

        # check error
        if ( !$ExtraDatabaseObject ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Could not create database object for MirrorDB!',
            );
            return;
        }
        $DBObject = $ExtraDatabaseObject;
    }

    my @SQLWhere;           # assemble the conditions used in the WHERE clause
    my @InnerJoinTables;    # keep track of the tables that need to be inner joined

    # keep track of the tables that need to be inner joined for workorder freetext fields
    my @InnerJoinTablesWorkOrderFreeText;

    # define order table
    my %OrderByTable = (

        # workorder attributes
        ChangeID         => 'wo.change_id',
        WorkOrderID      => 'wo.id',
        WorkOrderNumber  => 'wo.workorder_number',
        WorkOrderTitle   => 'wo.title',
        WorkOrderStateID => 'wo.workorder_state_id',
        WorkOrderTypeID  => 'wo.workorder_type_id',
        WorkOrderAgentID => 'wo.workorder_agent_id',
        PlannedStartTime => 'wo.planned_start_time',
        PlannedEndTime   => 'wo.planned_end_time',
        ActualStartTime  => 'wo.actual_start_time',
        ActualEndTime    => 'wo.actual_end_time',
        CreateTime       => 'wo.create_time',
        CreateBy         => 'wo.create_by',
        ChangeTime       => 'wo.change_time',
        ChangeBy         => 'wo.change_by',

        # change attributes
        ChangeNumber    => 'c.change_number',
        ChangeTitle     => 'c.title',
        ChangeStateID   => 'c.change_state_id',
        ChangeManagerID => 'c.change_manager_id',
        ChangeBuilderID => 'c.change_builder_id',
        CategoryID      => 'c.category_id',
        ImpactID        => 'c.impact_id',
        PriorityID      => 'c.priority_id',
        RequestedTime   => 'c.requested_time',
    );

    # check if OrderBy contains only unique valid values
    my %OrderBySeen;
    for my $OrderBy ( @{ $Param{OrderBy} } ) {

        if ( !$OrderBy || !$OrderByTable{$OrderBy} || $OrderBySeen{$OrderBy} ) {

            # found an error
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "OrderBy contains invalid value '$OrderBy' "
                    . 'or the value is used more than once!',
            );
            return;
        }

        # remember the value to check if it appears more than once
        $OrderBySeen{$OrderBy} = 1;

        # join the change table, when it is needed for the OrderBy-clause
        if ( $OrderByTable{$OrderBy} =~ m{ \A c[.] }xms ) {
            push @InnerJoinTables, 'c';
        }
    }

    # check if OrderByDirection array contains only 'Up' or 'Down'
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

    # set default values
    if ( !defined $Param{UsingWildcards} ) {
        $Param{UsingWildcards} = 1;
    }

    # set the default behaviour for the return type
    my $Result = $Param{Result} || 'ARRAY';

    # check whether all of the given WorkOrderStateIDs are valid
    return if !$Self->WorkOrderStateIDsCheck( WorkOrderStateIDs => $Param{WorkOrderStateIDs} );

    # look up and thus check the States
    for my $WorkOrderState ( @{ $Param{WorkOrderStates} } ) {

        # look up the ID for the name
        my $WorkOrderStateID = $Self->WorkOrderStateLookup(
            WorkOrderState => $WorkOrderState,
        );

        # check whether the ID was found, whether the name exists
        if ( !$WorkOrderStateID ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "The workorder state $WorkOrderState is not known!",
            );

            return;
        }

        push @{ $Param{WorkOrderStateIDs} }, $WorkOrderStateID;
    }

    # check whether the given WorkOrderTypeIDs are all valid
    return if !$Self->_CheckWorkOrderTypeIDs( WorkOrderTypeIDs => $Param{WorkOrderTypeIDs} );

    # look up and thus check the WorkOrderTypes
    for my $Type ( @{ $Param{WorkOrderTypes} } ) {

        # get the ID for the name
        my $TypeID = $Self->WorkOrderTypeLookup(
            WorkOrderType => $Type,
        );

        # check whether the ID was found, whether the name exists
        if ( !$TypeID ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "The workorder type '$Type' is not known!",
            );
            return;
        }

        push @{ $Param{WorkOrderTypeIDs} }, $TypeID;
    }

    # add string params to the WHERE clause
    my %StringParams = (

        # in workorder table
        WorkOrderNumber => 'wo.workorder_number',
        WorkOrderTitle  => 'wo.title',
        Instruction     => 'wo.instruction_plain',
        Report          => 'wo.report_plain',

        # in change table
        ChangeNumber        => 'c.change_number',
        ChangeTitle         => 'c.title',
        ChangeDescription   => 'c.description_plain',
        ChangeJustification => 'c.justification_plain',
    );

    # add workorder freetext fields to %StringParams
    ARGUMENT:
    for my $Argument ( sort keys %Param ) {

        next ARGUMENT if $Argument !~ m{ \A WorkOrderFree ( Text | Key ) ( \d+ ) \z }xms;

        my $Type   = $1;
        my $Number = $2;

        # set the table alias and column
        if ( $Type eq 'Text' ) {

            # workorder freetext field
            $StringParams{$Argument} = 'wft' . $Number . '.field_value';
        }
        elsif ( $Type eq 'Key' ) {

            # workorder freekey field
            $StringParams{$Argument} = 'wfk' . $Number . '.field_value';
        }
    }

    # add string params to sql-where-array
    STRINGPARAM:
    for my $StringParam ( sort keys %StringParams ) {

        # check string params for useful values, the string '0' is allowed
        next STRINGPARAM if !exists $Param{$StringParam};
        next STRINGPARAM if !defined $Param{$StringParam};
        next STRINGPARAM if $Param{$StringParam} eq '';

        # quote
        $Param{$StringParam} = $DBObject->Quote( $Param{$StringParam} );

        # check if a CLOB field is used in oracle
        # Fix/Workaround for ORA-00932: inconsistent datatypes: expected - got CLOB
        my $ForceLikeSearchForSpecialFields;
        if (
            $Self->{DBType} eq 'oracle'
            && (
                $StringParam eq 'Instruction'
                || $StringParam eq 'Report'
                || $StringParam eq 'ChangeDescription'
                || $StringParam eq 'ChangeJustification'
            )
            )
        {
            my $ForceLikeSearchForSpecialFields = 1;
        }

        # wildcards are used (or LIKE search is forced for some special fields on oracle)
        if ( $Param{UsingWildcards} || $ForceLikeSearchForSpecialFields ) {

            # get like escape string needed for some databases (e.g. oracle)
            my $LikeEscapeString = $DBObject->GetDatabaseFunction('LikeEscapeString');

            # Quote
            $Param{$StringParam} = $DBObject->Quote( $Param{$StringParam}, 'Like' );

            # replace * with %
            $Param{$StringParam} =~ s{ \*+ }{%}xmsg;

            # do not use string params which contain only %
            next STRINGPARAM if $Param{$StringParam} =~ m{ \A %* \z }xms;

            push @SQLWhere,
                "LOWER($StringParams{$StringParam}) LIKE LOWER('$Param{$StringParam}') $LikeEscapeString";
        }

        # no wildcards are used
        else {
            push @SQLWhere,
                "LOWER($StringParams{$StringParam}) = LOWER('$Param{$StringParam}')";
        }

        # join the change table, when it is needed in the WHERE clause
        if ( $StringParams{$StringParam} =~ m{ \A c[.] }xms ) {
            push @InnerJoinTables, 'c';
        }

        # add field_id to where clause for workorder freetext fields
        if ( $StringParams{$StringParam} =~ m{ \A ( ( wft | wfk ) ( \d+ ) ) }xms ) {

            my $TableAlias = $1;
            my $Number     = $3;

            # add the field id to the where clause
            push @SQLWhere, $TableAlias . '.field_id = ' . $Number;

            # the change_wo_freetext and change_wo_freekey tables need to be joined,
            # when they occur in the WHERE clause
            push @InnerJoinTablesWorkOrderFreeText, $TableAlias;
        }
    }

    # set array params
    my %ArrayParams = (
        ChangeIDs         => 'wo.change_id',
        WorkOrderStateIDs => 'wo.workorder_state_id',
        WorkOrderTypeIDs  => 'wo.workorder_type_id',
        WorkOrderAgentIDs => 'wo.workorder_agent_id',
        CreateBy          => 'wo.create_by',
        ChangeBy          => 'wo.change_by',
    );

    # add array params to sql-where-array
    ARRAYPARAM:
    for my $ArrayParam ( sort keys %ArrayParams ) {

        # ignore empty lists
        next ARRAYPARAM if !@{ $Param{$ArrayParam} };

        # quote as integer
        for my $OneParam ( @{ $Param{$ArrayParam} } ) {
            $OneParam = $DBObject->Quote( $OneParam, 'Integer' );
        }

        # create string
        my $InString = join ', ', @{ $Param{$ArrayParam} };

        push @SQLWhere, "$ArrayParams{$ArrayParam} IN ($InString)";
    }

    # check the time params and add them to the WHERE clause of the SELECT-Statement
    my %TimeParams = (
        CreateTimeNewerDate       => 'wo.create_time >=',
        CreateTimeOlderDate       => 'wo.create_time <=',
        ChangeTimeNewerDate       => 'wo.change_time >=',
        ChangeTimeOlderDate       => 'wo.change_time <=',
        PlannedStartTimeNewerDate => 'wo.planned_start_time >=',
        PlannedStartTimeOlderDate => 'wo.planned_start_time <=',
        PlannedEndTimeNewerDate   => 'wo.planned_end_time >=',
        PlannedEndTimeOlderDate   => 'wo.planned_end_time <=',
        ActualStartTimeNewerDate  => 'wo.actual_start_time >=',
        ActualStartTimeOlderDate  => 'wo.actual_start_time <=',
        ActualEndTimeNewerDate    => 'wo.actual_end_time >=',
        ActualEndTimeOlderDate    => 'wo.actual_end_time <=',
    );
    TIMEPARAM:
    for my $TimeParam ( sort keys %TimeParams ) {

        next TIMEPARAM if !$Param{$TimeParam};

        if ( $Param{$TimeParam} !~ m{ \A \d\d\d\d-\d\d-\d\d \s \d\d:\d\d:\d\d \z }xms ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "The parameter $TimeParam has an invalid date format!",
            );
            return;
        }

        # quote
        $Param{$TimeParam} = $DBObject->Quote( $Param{$TimeParam} );

        push @SQLWhere, "$TimeParams{$TimeParam} '$Param{$TimeParam}'";
    }

    # delete the OrderBy parameter when the result type is 'COUNT'
    if ( $Result eq 'COUNT' ) {
        $Param{OrderBy} = [];
    }

    # assemble the ORDER BY clause
    my @SQLOrderBy;
    my $Count = 0;
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
        push @SQLOrderBy, "$OrderByTable{$OrderBy} $Direction";
    }
    continue {
        $Count++;
    }

    # if there is a possibility that the ordering is not determined
    # we add an descending ordering by id
    if ( !grep { $_ eq 'WorkOrderID' } ( @{ $Param{OrderBy} } ) ) {
        push @SQLOrderBy, "$OrderByTable{WorkOrderID} DESC";
    }

    # assemble the SQL query
    my $SQL = 'SELECT wo.id FROM change_workorder wo ';

    # modify SQL when the result type is 'COUNT'.
    # There is no 'GROUP BY' SQL-clause, therefore COUNT(c.id) always give the wanted count
    if ( $Result eq 'COUNT' ) {
        $SQL        = 'SELECT COUNT(wo.id) FROM change_workorder wo ';
        @SQLOrderBy = ();
    }

    # add the joins
    my %LongTableName = (
        c => 'change_item',
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

        $SQL .= "INNER JOIN $LongTableName{$Table} $Table ON $Table.id = wo.change_id ";
    }

    INNER_JOIN_TABLE_WORKORDER_FREETEXT:
    for my $Table (@InnerJoinTablesWorkOrderFreeText) {

        # workorder freetext
        if ( $Table =~ m{ \A wft }xms ) {
            $SQL .= "INNER JOIN change_wo_freetext $Table ON $Table.workorder_id = wo.id ";
        }

        # workorder freekey
        elsif ( $Table =~ m{ \A wfk }xms ) {
            $SQL .= "INNER JOIN change_wo_freekey $Table ON $Table.workorder_id = wo.id ";
        }
    }

    # add the WHERE clause
    if (@SQLWhere) {
        $SQL .= 'WHERE ';
        $SQL .= join ' AND ', map {"( $_ )"} @SQLWhere;
        $SQL .= ' ';
    }

    # add the ORDER BY clause
    if (@SQLOrderBy) {
        $SQL .= 'ORDER BY ';
        $SQL .= join ', ', @SQLOrderBy;
        $SQL .= ' ';
    }

    # ignore the parameter 'Limit' when result type is 'COUNT'
    if ( $Result eq 'COUNT' ) {
        $Param{Limit} = 1;
    }

    # ask database
    return if !$DBObject->Prepare(
        SQL   => $SQL,
        Limit => $Param{Limit},
    );

    # fetch the result
    my @IDs;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @IDs, $Row[0];
    }

    # return the count as scalar
    return $IDs[0] if $Result eq 'COUNT';

    return \@IDs;
}

=item WorkOrderDelete()

Delete a workorder.

This function removes all links and attachments to the workorder
with the passed workorder id.
After that the workorder is removed.

    my $Success = $WorkOrderObject->WorkOrderDelete(
        WorkOrderID  => 123,
        NoNumberCalc => 1, # (optional) default 0, if 1 it prevents a recalculation of the workorder numbers
        UserID       => 1,
    );

=cut

sub WorkOrderDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Attribute (qw(WorkOrderID UserID)) {
        if ( !$Param{$Attribute} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Attribute!",
            );
            return;
        }
    }

    # trigger WorkOrderDeletePre-Event
    $Self->EventHandler(
        Event => 'WorkOrderDeletePre',
        Data  => {
            %Param,
        },
        UserID => $Param{UserID},
    );

    # get old workorder data to be given to post event handler
    my $WorkOrderData = $Self->WorkOrderGet(
        WorkOrderID => $Param{WorkOrderID},
        UserID      => $Param{UserID},
    );

    # delete all links to this workorder
    return if !$Self->{LinkObject}->LinkDeleteAll(
        Object => 'ITSMWorkOrder',
        Key    => $Param{WorkOrderID},
        UserID => 1,
    );

    # get the list of workorder attachments and delete them
    my @Attachments = $Self->WorkOrderAttachmentList(
        WorkOrderID => $Param{WorkOrderID},
    );
    for my $Filename (@Attachments) {
        return if !$Self->WorkOrderAttachmentDelete(
            ChangeID       => $WorkOrderData->{ChangeID},
            WorkOrderID    => $Param{WorkOrderID},
            Filename       => $Filename,
            AttachmentType => 'WorkOrder',
            UserID         => $Param{UserID},
        );
    }

    # get the list of report attachments and delete them
    my @ReportAttachments = $Self->WorkOrderReportAttachmentList(
        WorkOrderID => $Param{WorkOrderID},
    );
    for my $Filename (@ReportAttachments) {
        return if !$Self->WorkOrderAttachmentDelete(
            ChangeID       => $WorkOrderData->{ChangeID},
            WorkOrderID    => $Param{WorkOrderID},
            Filename       => $Filename,
            AttachmentType => 'WorkOrderReport',
            UserID         => $Param{UserID},
        );
    }

    # delete the workorder freetext fields
    return if !$Self->_WorkOrderFreeTextDelete(
        WorkOrderID => $Param{WorkOrderID},
        UserID      => $Param{UserID},
    );

    # delete the workorder
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM change_workorder WHERE id = ? ',
        Bind => [ \$Param{WorkOrderID} ],
    );

    # delete cache
    for my $Key (
        'WorkOrderGet::ID::' . $Param{WorkOrderID},
        'WorkOrderList::ChangeID::' . $WorkOrderData->{ChangeID},
        'WorkOrderChangeEffortsGet::ChangeID::' . $WorkOrderData->{ChangeID},
        'WorkOrderChangeTimeGet::ChangeID::' . $WorkOrderData->{ChangeID},
        'ChangeGet::ID::' . $WorkOrderData->{ChangeID},
        )
    {

        $Self->{CacheObject}->Delete(
            Type => 'ITSMChangeManagement',
            Key  => $Key,
        );
    }

    # trigger WorkOrderDeletePost-Event
    $Self->EventHandler(
        Event => 'WorkOrderDeletePost',
        Data  => {
            OldWorkOrderData => $WorkOrderData,
            %Param,
        },
        UserID => $Param{UserID},
    );

    return 1;
}

=item WorkOrderChangeTimeGet()

Returns a list of PlannedStartTime | PlannedEndTime | ActualStartTime | ActualEndTime
of a change, which would be the respective time of the earliest starting
workorder (for start times) or the latest ending workorder (for end times).

For PlannedStartTime | PlannedEndTime | ActualEndTime an empty string is returned
if any of the workorders of a change has the respective time not defined.

The ActualStartTime is defined when any of the workorders of a change has
a defined ActualStartTime.

Return

    $Time{PlannedStartTime}
    $Time{PlannedEndTime}
    $Time{ActualStartTime}
    $Time{ActualEndTime}

    my $TimeRef = $WorkOrderObject->WorkOrderChangeTimeGet(
        ChangeID => 123,
        UserID   => 1,

        # ---------------------------------------------------- #

        # TODO: (decide this later!)
        Maybe add this new attribute:

        # These are WorkOrderTypes (Types, not States!)
        # which would be excluded from the calculation
        # of the change start time.

        ExcludeWorkOrderTypes => [ 'approval', 'pir' ],   # (optional)

        # ---------------------------------------------------- #
    );

=cut

sub WorkOrderChangeTimeGet {
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

    # initialize the return time hash
    my %TimeReturn;

    # check cache
    my $CacheKey = 'WorkOrderChangeTimeGet::ChangeID::' . $Param{ChangeID};
    my $Cache    = $Self->{CacheObject}->Get(
        Type => 'ITSMChangeManagement',
        Key  => $CacheKey,
    );

    if ($Cache) {

        # get data from cache
        %TimeReturn = %{$Cache};
    }
    else {

        # build sql, using min and max functions
        my $SQL = 'SELECT '
            . 'MIN( planned_start_time ), '
            . 'MAX( planned_end_time ), '
            . 'MIN( actual_start_time ), '
            . 'MAX( actual_end_time ) '
            . 'FROM change_workorder '
            . 'WHERE change_id = ?';

        # retrieve the requested time
        return if !$Self->{DBObject}->Prepare(
            SQL   => $SQL,
            Bind  => [ \$Param{ChangeID} ],
            Limit => 1,
        );

        # fetch the result
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            $TimeReturn{PlannedStartTime} = $Row[0] || '';
            $TimeReturn{PlannedEndTime}   = $Row[1] || '';
            $TimeReturn{ActualStartTime}  = $Row[2] || '';
            $TimeReturn{ActualEndTime}    = $Row[3] || '';
        }

        TIMEFIELD:
        for my $Time ( sort keys %TimeReturn ) {

            next TIMEFIELD if !$TimeReturn{$Time};

            # cleanup time stamps (some databases are using e. g. 2008-02-25 22:03:00.000000)
            $TimeReturn{$Time}
                =~ s{ \A ( \d\d\d\d - \d\d - \d\d \s \d\d:\d\d:\d\d ) \. .+? \z }{$1}xms;

            # set empty string if the default time was found
            if ( $TimeReturn{$Time} eq '9999-01-01 00:00:00' ) {
                $TimeReturn{$Time} = '';
            }
        }

        # check if change has workorders with not yet defined planned_start_time entries
        if ( $TimeReturn{PlannedStartTime} ) {

            # build SQL
            my $SQL = 'SELECT count(*) '
                . 'FROM change_workorder '
                . "WHERE planned_start_time = '9999-01-01 00:00:00' "
                . 'AND change_id = ?';

            # retrieve number of not defined entries
            return if !$Self->{DBObject}->Prepare(
                SQL   => $SQL,
                Bind  => [ \$Param{ChangeID} ],
                Limit => 1,
            );

            # fetch the result
            my $Count;
            while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
                $Count = $Row[0];
            }

            # reset PlannedStartTime
            if ($Count) {
                $TimeReturn{PlannedStartTime} = '';
            }
        }

        # set cache
        $Self->{CacheObject}->Set(
            Type  => 'ITSMChangeManagement',
            Key   => $CacheKey,
            Value => \%TimeReturn,
            TTL   => $Self->{CacheTTL},
        );
    }

    return \%TimeReturn;
}

=item WorkOrderStateLookup()

This method does a lookup for a workorder state. If a workorder state id is given,
it returns the name of the workorder state. If a workorder state name is given,
the appropriate id is returned.

    my $WorkOrderState = $WorkOrderObject->WorkOrderStateLookup(
        WorkOrderStateID => 157,
    );

    my $WorkOrderStateID = $WorkOrderObject->WorkOrderStateLookup(
        WorkOrderState => 'ready',
    );

=cut

sub WorkOrderStateLookup {
    my ( $Self, %Param ) = @_;

    # either WorkOrderStateID or WorkOrderState must be passed
    if ( !$Param{WorkOrderStateID} && !$Param{WorkOrderState} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need WorkOrderStateID or WorkOrderState!',
        );
        return;
    }

    if ( $Param{WorkOrderStateID} && $Param{WorkOrderState} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need WorkOrderStateID OR WorkOrderState - not both!',
        );
        return;
    }

    # get the workorder states from the general catalog
    my $StateList = $Self->{GeneralCatalogObject}->ItemList(
        Class => 'ITSM::ChangeManagement::WorkOrder::State',
    );

    # convert state list into a lookup hash
    my %StateID2Name;
    if ( $StateList && ref $StateList eq 'HASH' && %{$StateList} ) {
        %StateID2Name = %{$StateList};
    }

    # check the state hash
    if ( !%StateID2Name ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Could not retrieve workorder states from the general catalog.',
        );

        return;
    }

    if ( $Param{WorkOrderStateID} ) {
        return $StateID2Name{ $Param{WorkOrderStateID} };
    }
    else {

        # reverse key - value pairs to have the name as keys
        my %StateName2ID = reverse %StateID2Name;

        return $StateName2ID{ $Param{WorkOrderState} };
    }
}

=item WorkOrderPossibleStatesGet()

This method returns a list of possible workorder states.
If C<WorkOrderID> is omitted, the complete list of workorder states is returned.
If C<WorkOrderID> is given, the list of possible states for the given
workorder is returned.

    my $WorkOrderStateList = $WorkOrderObject->WorkOrderPossibleStatesGet(
        WorkOrderID => 123,  # (optional)
        UserID      => 1,
    );

The return value is a reference to an array of hashrefs. The element 'Key' is then
the StateID and the element 'Value' is the name of the state. The array elements
are sorted by state id.

    my $WorkOrderStateList = [
        {
            Key   => 156,
            Value => 'accepted',
        },
        {
            Key   => 157,
            Value => 'in progress',
        },
    ];

=cut

sub WorkOrderPossibleStatesGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Attribute (qw(UserID)) {
        if ( !$Param{$Attribute} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Attribute!",
            );
            return;
        }
    }

    # get workorder state list
    my $StateList = $Self->{GeneralCatalogObject}->ItemList(
        Class => 'ITSM::ChangeManagement::WorkOrder::State',
    ) || {};

    # to store an array of hash refs
    my @ArrayHashRef;

    # if WorkOrderID is given, only use possible next states as defined in state machine
    if ( $Param{WorkOrderID} ) {

        # get workorder data
        my $WorkOrder = $Self->WorkOrderGet(
            WorkOrderID => $Param{WorkOrderID},
            UserID      => $Param{UserID},
        );

        # check for state lock
        my $StateLock = $Self->{ConditionObject}->ConditionMatchStateLock(
            ObjectName => 'ITSMWorkOrder',
            Selector   => $Param{WorkOrderID},
            StateID    => $WorkOrder->{WorkOrderStateID},
            UserID     => $Param{UserID},
        );

        # set as default state current workorder state
        my @NextStateIDs = ( $WorkOrder->{WorkOrderStateID} );

        # check if reachable workorder end states should be allowed for locked workorder states
        my $WorkOrderEndStatesAllowed
            = $Self->{ConfigObject}->Get('ITSMWorkOrder::StateLock::AllowEndStates');

        if ($WorkOrderEndStatesAllowed) {

            # set as default state current state and all possible end states
            my $EndStateIDsRef = $Self->{StateMachineObject}->StateTransitionGetEndStates(
                StateID => $WorkOrder->{WorkOrderStateID},
                Class   => 'ITSM::ChangeManagement::WorkOrder::State',
            ) || [];
            @NextStateIDs = sort ( @{$EndStateIDsRef}, $WorkOrder->{WorkOrderStateID} );
        }

        # get possible next states if no state lock
        if ( !$StateLock ) {

            # get the possible next state ids
            my $NextStateIDsRef = $Self->{StateMachineObject}->StateTransitionGet(
                StateID => $WorkOrder->{WorkOrderStateID},
                Class   => 'ITSM::ChangeManagement::WorkOrder::State',
            ) || [];

            # add current workorder state id to list
            @NextStateIDs = sort ( @{$NextStateIDsRef}, $WorkOrder->{WorkOrderStateID} );
        }

        # assemble the array of hash refs with only possible next states
        STATEID:
        for my $StateID (@NextStateIDs) {

            # check state id
            next STATEID if !$StateID;

            # store id and name in the array
            push @ArrayHashRef, {
                Key   => $StateID,
                Value => $StateList->{$StateID},
            };
        }

        return \@ArrayHashRef
    }

    # assemble the array of hash refs with all next states
    for my $StateID ( sort keys %{$StateList} ) {
        push @ArrayHashRef, {
            Key   => $StateID,
            Value => $StateList->{$StateID},
        };
    }

    return \@ArrayHashRef;
}

=item WorkOrderTypeLookup()

This method does a lookup for a workorder type. If a workorder type id is given,
it returns the name of the workorder type. If a workorder type name is given,
the appropriate id is returned.

    my $WorkOrderType = $WorkOrderObject->WorkOrderTypeLookup(
        WorkOrderTypeID => 157,
    );

    my $WorkOrderTypeID = $WorkOrderObject->WorkOrderTypeLookup(
        WorkOrderType => 'ready',
    );

=cut

sub WorkOrderTypeLookup {
    my ( $Self, %Param ) = @_;

    # either WorkOrderTypeID or WorkOrderType must be passed
    if ( !$Param{WorkOrderTypeID} && !$Param{WorkOrderType} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need WorkOrderTypeID or WorkOrderType!',
        );
        return;
    }

    if ( $Param{WorkOrderTypeID} && $Param{WorkOrderType} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need WorkOrderTypeID OR WorkOrderType - not both!',
        );
        return;
    }

    # get workorder type from general catalog
    # mapping of the id to the name
    my %WorkOrderType = %{
        $Self->{GeneralCatalogObject}->ItemList(
            Class => 'ITSM::ChangeManagement::WorkOrder::Type',
            )
    };

    # check the workorder types hash
    if ( !%WorkOrderType ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Could not retrieve workorder types from the general catalog.',
        );

        return;
    }

    if ( $Param{WorkOrderTypeID} ) {
        return $WorkOrderType{ $Param{WorkOrderTypeID} };
    }
    else {

        # reverse key - value pairs to have the name as keys
        my %ReversedWorkOrderType = reverse %WorkOrderType;

        return $ReversedWorkOrderType{ $Param{WorkOrderType} };
    }
}

=item WorkOrderTypeList()

This method returns a list of all workorder types.

    my $WorkOrderTypeList = $WorkOrderObject->WorkOrderTypeList(
        UserID      => 1,
        Default     => 1,   # optional - the default type is selected type (default: 0)
        SelectedID  => 123, # optional - this id is selected
    );

The return value is a reference to an array of hashrefs. The Element 'Key' is then
the TypeID and die Element 'Value' is the name of the type. The array elements
are sorted by type id.

    my $WorkOrderTypeList = [
        {
            Key   => 171,
            Value => 'workorder',
        },
        {
            Key   => 172,
            Value => 'backout',
        },
    ];

=cut

sub WorkOrderTypeList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Attribute (qw(UserID)) {
        if ( !$Param{$Attribute} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Attribute!",
            );
            return;
        }
    }

    # what type is selected
    my $SelectedID = $Param{Selected} || 0;

    if ( $Param{Default} ) {

        # set config option
        my $ConfigOption = 'ITSMWorkOrder::Type::Default';

        # get default workorder type from config
        my $DefaultType = $Self->{ConfigObject}->Get($ConfigOption);

        # check if default type exists in general catalog
        my $ItemDataRef = $Self->{GeneralCatalogObject}->ItemGet(
            Class => 'ITSM::ChangeManagement::WorkOrder::Type',
            Name  => $DefaultType,
        );

        # error handling because of invalid config setting
        if ( !$ItemDataRef || ref $ItemDataRef ne 'HASH' || !%{$ItemDataRef} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "The default WorkOrderType '$DefaultType' "
                    . "in sysconfig option '$ConfigOption' is invalid! Check the general catalog!",
            );
            return;
        }

        # set default
        $SelectedID = $ItemDataRef->{ItemID};
    }

    # get workorder type list
    my $WorkOrderTypeList = $Self->{GeneralCatalogObject}->ItemList(
        Class => 'ITSM::ChangeManagement::WorkOrder::Type',
    ) || {};

    # assemble a an array of hash refs
    my @ArrayHashRef;
    for my $TypeID ( sort keys %{$WorkOrderTypeList} ) {
        my %SelectedInfo;

        if ( $SelectedID && $SelectedID == $TypeID ) {
            $SelectedInfo{Selected} = 1;
        }

        push @ArrayHashRef, {
            Key   => $TypeID,
            Value => $WorkOrderTypeList->{$TypeID},
            %SelectedInfo,
        };
    }

    return \@ArrayHashRef;
}

=item Permission()

Returns whether the agent C<UserID> has permissions of the type C<Type>
on the workorder C<WorkOrderID>. The parameters are passed on to
the permission modules that were registered in the permission registry.
The standard permission registry is B<ITSMWorkOrder::Permission>, but
that can be overridden with the parameter C<PermissionRegistry>.

The registered permission modules are run in the alphabetical order of
their registry keys.
Overall permission is granted when a permission module, which has the attribute 'Granted' set,
grants permission. Overall permission is denied when a permission module, which has the attribute 'Required'
set, denies permission. Overall permission is also denied when when all permission module were asked
without coming to an conclusion.

Approval is indicated by the return value 1. Denial is indicated by returning an empty list.

The optional option C<LogNo> turns off logging when access was denied.
This is useful when the method is used for checking whether a link or an action should be shown.

    my $Access = $WorkOrderObject->Permission(
        UserID             => 123,
        Type               => 'ro',                         # 'ro' and 'rw' are supported
        Action             => 'AgentITSMWorkOrderReport',   # optional
        WorkOrderID        => 4444,
        PermissionRegistry => 'ITSMWorkOrder::TakePermission',
                                      # optional with default 'ITSMWorkOrder::Permission'
        LogNo              => 1,      # optional, turns off logging when access is denied
    );

=cut

sub Permission {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Type UserID WorkOrderID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # the place where the permission modules are registerd can be overridden by a parameter
    my $Registry = $Param{PermissionRegistry} || 'ITSMWorkOrder::Permission';

    # run the relevant permission modules
    if ( ref $Self->{ConfigObject}->Get($Registry) eq 'HASH' ) {
        my %Modules = %{ $Self->{ConfigObject}->Get($Registry) };
        for my $Module ( sort keys %Modules ) {

            # log try of load module
            if ( $Self->{Debug} > 1 ) {
                $Self->{LogObject}->Log(
                    Priority => 'debug',
                    Message  => "Try to load module: $Modules{$Module}->{Module}!",
                );
            }

            # load module
            next if !$Self->{MainObject}->Require( $Modules{$Module}->{Module} );

            # create object
            my $ModuleObject = $Modules{$Module}->{Module}->new(
                ConfigObject    => $Self->{ConfigObject},
                EncodeObject    => $Self->{EncodeObject},
                LogObject       => $Self->{LogObject},
                MainObject      => $Self->{MainObject},
                TimeObject      => $Self->{TimeObject},
                DBObject        => $Self->{DBObject},
                UserObject      => $Self->{UserObject},
                GroupObject     => $Self->{GroupObject},
                WorkOrderObject => $Self,
                Debug           => $Self->{Debug},
            );

            # ask for the opinion of the Permission module
            my $Access = $ModuleObject->Run(%Param);

            # Grant overall permission,
            # when the module granted a sufficient permission.
            if ( $Access && $Modules{$Module}->{Granted} ) {
                if ( $Self->{Debug} > 0 ) {
                    $Self->{LogObject}->Log(
                        Priority => 'debug',
                        Message  => "Granted '$Param{Type}' access for "
                            . "UserID: $Param{UserID} on "
                            . "WorkOrderID '$Param{WorkOrderID}' "
                            . "through $Modules{$Module}->{Module} (no more checks)!",
                    );
                }

                # grant permission
                return 1;
            }

            # Deny overall permission,
            # when the module denied a required permission.
            if ( !$Access && $Modules{$Module}->{Required} ) {
                if ( !$Param{LogNo} ) {
                    $Self->{LogObject}->Log(
                        Priority => 'notice',
                        Message  => "Denied '$Param{Type}' access for "
                            . "UserID: $Param{UserID} on "
                            . "WorkOrderID '$Param{WorkOrderID}' "
                            . "because $Modules{$Module}->{Module} is required!",
                    );
                }

                # deny permission
                return;
            }
        }
    }

    # Deny access when neither a 'Granted'-Check nor a 'Required'-Check has reached a conclusion.
    if ( !$Param{LogNo} ) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "Permission denied (UserID: $Param{UserID} '$Param{Type}' "
                . "on WorkOrderID: $Param{WorkOrderID})!",
        );
    }

    return;
}

=item WorkOrderStateIDsCheck()

Check whether all of the given workorder state ids are valid.
The method is public as it is used in L<Kernel::System::ITSMChange::ChangeSearch>.

    my $Ok = $WorkOrderObject->WorkOrderStateIDsCheck(
        WorkOrderStateIDs => [ 25 ],
    );

=cut

sub WorkOrderStateIDsCheck {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{WorkOrderStateIDs} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need WorkOrderStateID!',
        );
        return;
    }

    if ( ref $Param{WorkOrderStateIDs} ne 'ARRAY' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'The param WorkOrderStateIDs must be an ARRAY reference!',
        );
        return;
    }

    # check if WorkOrderStateIDs belongs to correct general catalog class
    for my $StateID ( @{ $Param{WorkOrderStateIDs} } ) {
        my $State = $Self->WorkOrderStateLookup(
            WorkOrderStateID => $StateID,
        );

        if ( !$State ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "The state id $StateID is not valid!",
            );

            return;
        }
    }

    return 1;
}

=item WorkOrderAttachmentAdd()

Add an attachment to the given workorder.

    my $Success = $WorkOrderObject->WorkOrderAttachmentAdd(
        ChangeID       => 123,
        WorkOrderID    => 456,            # the WorkOrderID becomes part of the file path
        AttachmentType => 'WorkOrder',    # ( 'WorkOrder' || 'WorkOrderReport')  (optional, default 'WorkOrder' )
        Filename       => 'filename',
        Content        => 'content',
        ContentType    => 'text/plain',
        UserID         => 1,
    );

=cut

sub WorkOrderAttachmentAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(ChangeID WorkOrderID Filename Content ContentType UserID )) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    # Set attachment type to distinguish between attachments of workorders
    # and those from reports of workorders
    my $AttachmentType = $Param{AttachmentType} || 'WorkOrder';

    # set event name based on the attachment type
    my $Event;
    if ( $AttachmentType eq 'WorkOrder' ) {
        $Event = 'WorkOrderAttachmentAddPost';
    }
    elsif ( $AttachmentType eq 'WorkOrderReport' ) {
        $Event = 'WorkOrderReportAttachmentAddPost';
    }

    # write to virtual fs
    my $Success = $Self->{VirtualFSObject}->Write(
        Filename    => "$AttachmentType/$Param{WorkOrderID}/$Param{Filename}",
        Mode        => 'binary',
        Content     => \$Param{Content},
        Preferences => {
            ContentID   => $Param{ContentID},
            ContentType => $Param{ContentType},
            WorkOrderID => $Param{WorkOrderID},
            UserID      => $Param{UserID},
        },
    );

    # check for error
    if ($Success) {

        # trigger AttachmentAdd-Event
        $Self->EventHandler(
            Event => $Event,
            Data  => {
                %Param,
            },
            UserID => $Param{UserID},
        );
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Cannot add attachment for workorder $Param{WorkOrderID}",
        );

        return;
    }

    return 1;
}

=item WorkOrderAttachmentDelete()

Delete the given file from the virtual filesystem.

    my $Success = $WorkOrderObject->WorkOrderAttachmentDelete(
        ChangeID       => 12345,
        WorkOrderID    => 5123,
        AttachmentType => 'WorkOrder',           # ( 'WorkOrder' || 'WorkOrderReport')  (optional, default 'WorkOrder' )
        Filename       => 'Projectplan.pdf',     # identifies the attachment (together with the WorkOrderID)
        UserID         => 1,
    );

=cut

sub WorkOrderAttachmentDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(ChangeID WorkOrderID Filename UserID)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # Set attachment type to distinguish between attachments of workorders
    # and those from reports of workorders
    my $AttachmentType = $Param{AttachmentType} || 'WorkOrder';

    # set event name based on the attachment type
    my $Event;
    if ( $AttachmentType eq 'WorkOrder' ) {
        $Event = 'WorkOrderAttachmentDeletePost';
    }
    elsif ( $AttachmentType eq 'WorkOrderReport' ) {
        $Event = 'WorkOrderReportAttachmentDeletePost';
    }

    # add prefix
    my $Filename = "$AttachmentType/$Param{WorkOrderID}/$Param{Filename}";

    # delete file
    my $Success = $Self->{VirtualFSObject}->Delete(
        Filename => $Filename,
    );

    # check for error
    if ($Success) {

        # trigger AttachmentDeletePost-Event
        $Self->EventHandler(
            Event => $Event,
            Data  => {
                %Param,
            },
            UserID => $Param{UserID},
        );
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Cannot delete attachment $Filename!",
        );

        return;
    }

    return $Success;
}

=item WorkOrderAttachmentGet()

This method returns information about one specific attachment.

    my $Attachment = $WorkOrderObject->WorkOrderAttachmentGet(
        WorkOrderID    => 4,
        AttachmentType => 'WorkOrder',    # ( 'WorkOrder' || 'WorkOrderReport')  (optional, default 'WorkOrder' )
        Filename       => 'test.txt',
    );

returns

    $Attachment = {
        Preferences => {
            AllPreferences => 'test',
        },
        Filename       => 'test.txt',
        Content        => 'hallo',
        ContentType    => 'text/plain',
        Filesize       => '123 KBytes',
        Type           => 'attachment',
        AttachmentType => 'WorkOrder',
    };

=cut

sub WorkOrderAttachmentGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(WorkOrderID Filename)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # Set attachment type to distinguish between attachments of workorders
    # and those from reports of workorders
    my $AttachmentType = $Param{AttachmentType} || 'WorkOrder';

    # add prefix
    my $Filename = $AttachmentType . '/' . $Param{WorkOrderID} . '/' . $Param{Filename};

    # find all attachments of this workorder
    my @Attachments = $Self->{VirtualFSObject}->Find(
        Filename    => $Filename,
        Preferences => {
            WorkOrderID => $Param{WorkOrderID},
        },
    );

    # return error if file does not exist
    if ( !@Attachments ) {
        $Self->{LogObject}->Log(
            Message  => "No such attachment ($Filename)! May be an attack!!!",
            Priority => 'error',
        );
        return;
    }

    # get data for attachment
    my %AttachmentData = $Self->{VirtualFSObject}->Read(
        Filename => $Filename,
        Mode     => 'binary',
    );

    my $AttachmentInfo = {
        %AttachmentData,
        Filename       => $Param{Filename},
        Content        => ${ $AttachmentData{Content} },
        ContentType    => $AttachmentData{Preferences}->{ContentType},
        Type           => 'attachment',
        Filesize       => $AttachmentData{Preferences}->{Filesize},
        AttachmentType => $AttachmentType,
    };

    return $AttachmentInfo;
}

=item WorkOrderAttachmentList()

Returns an array with all workorder attachments (not the report attachments) of the given workorder.

    my @Attachments = $WorkOrderObject->WorkOrderAttachmentList(
        WorkOrderID => 123,
    );

returns

    @Attachments = (
        'filename.txt',
        'other_file.pdf',
    );

=cut

sub WorkOrderAttachmentList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{WorkOrderID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need WorkOrderID!',
        );

        return;
    }

    # find all attachments of this workorder
    my @Attachments = $Self->{VirtualFSObject}->Find(
        Preferences => {
            WorkOrderID => $Param{WorkOrderID},
        },
    );

    # extract only the workorder attachments
    my @WorkOrderAttachments;
    FILENAME:
    for my $Filename (@Attachments) {

        next FILENAME if $Filename !~ m{ \A WorkOrder / \d+ / }xms;

        # remove extra information from filename
        $Filename =~ s{ \A WorkOrder / \d+ / }{}xms;

        push @WorkOrderAttachments, $Filename;
    }

    return @WorkOrderAttachments;
}

=item WorkOrderReportAttachmentList()

Returns an array with all report attachments of the given workorder.

    my @Attachments = $WorkOrderObject->WorkOrderReportAttachmentList(
        WorkOrderID => 123,
    );

returns

    @Attachments = (
        'filename.txt',
        'other_file.pdf',
    );

=cut

sub WorkOrderReportAttachmentList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{WorkOrderID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need WorkOrderID!',
        );

        return;
    }

    # find all attachments of this workorder
    my @Attachments = $Self->{VirtualFSObject}->Find(
        Preferences => {
            WorkOrderID => $Param{WorkOrderID},
        },
    );

    # extract only the report attachments
    my @ReportAttachments;
    FILENAME:
    for my $Filename (@Attachments) {

        next FILENAME if $Filename !~ m{ \A WorkOrderReport / \d+ / }xms;

        # remove extra information from filename
        $Filename =~ s{ \A WorkOrderReport / \d+ / }{}xms;

        push @ReportAttachments, $Filename;

    }

    return @ReportAttachments;
}

=item WorkOrderAttachmentExists()

Checks if a file with a given filename exists.

    my $Exists = $WorkOrderObject->WorkOrderAttachmentExists(
        Filename       => 'test.txt',
        WorkOrderID    => 123,
        AttachmentType => 'WorkOrder',    # ( 'WorkOrder' || 'WorkOrderReport')  (optional, default 'WorkOrder' )
        UserID         => 1,
    );

=cut

sub WorkOrderAttachmentExists {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Filename WorkOrderID UserID)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    # Set attachment type to distinguish between attachments of workorders
    # and those from reports of workorders
    my $AttachmentType = $Param{AttachmentType} || 'WorkOrder';

    return if !$Self->{VirtualFSObject}->Find(
        Filename => $AttachmentType . '/' . $Param{WorkOrderID} . '/' . $Param{Filename},
    );

    return 1;
}

=item WorkOrderChangeEffortsGet()

returns the combined efforts of the workorders for the given change

    my $ChangeEfforts = $WorkOrderObject->WorkOrderChangeEffortsGet(
        ChangeID => 123,
        UserID   => 1,
    );

=cut

sub WorkOrderChangeEffortsGet {
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

    # initialize the return time hash
    my %ChangeEfforts;

    # check cache
    my $CacheKey = 'WorkOrderChangeEffortsGet::ChangeID::' . $Param{ChangeID};
    my $Cache    = $Self->{CacheObject}->Get(
        Type => 'ITSMChangeManagement',
        Key  => $CacheKey,
    );

    if ($Cache) {

        # get data from cache
        %ChangeEfforts = %{$Cache};

    }
    else {

        # build sql, using min and max functions
        my $SQL = 'SELECT '
            . 'SUM( planned_effort ), SUM( accounted_time ) '
            . 'FROM change_workorder '
            . 'WHERE change_id = ?';

        # retrieve the requested time
        return if !$Self->{DBObject}->Prepare(
            SQL   => $SQL,
            Bind  => [ \$Param{ChangeID} ],
            Limit => 1,
        );

        # fetch the result
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            $ChangeEfforts{PlannedEffort} = $Row[0] || '';
            $ChangeEfforts{AccountedTime} = $Row[1] || '';
        }

        ATTRIBUTE:
        for my $Attribute (qw(PlannedEffort AccountedTime)) {

            next ATTRIBUTE if !$ChangeEfforts{$Attribute};

            # do not show zero values
            if ( $ChangeEfforts{$Attribute} eq 0 ) {
                $ChangeEfforts{$Attribute} = '';
                next ATTRIBUTE;
            }

            # convert decimal character from ',' to '.' if neccessary
            $ChangeEfforts{$Attribute} =~ s{,}{.}xmsg;

            # format as decimal number
            $ChangeEfforts{$Attribute} = sprintf '%.2f', $ChangeEfforts{$Attribute};
        }

        # set cache
        $Self->{CacheObject}->Set(
            Type  => 'ITSMChangeManagement',
            Key   => $CacheKey,
            Value => \%ChangeEfforts,
            TTL   => $Self->{CacheTTL},
        );
    }

    return \%ChangeEfforts;
}

=item WorkOrderGetConfiguredFreeTextFields()

Returns an array with the numbers of all configured workorder freekey and freetext fields

    my @ConfiguredWorkOrderFreeTextFields = $WorkOrderObject->WorkOrderGetConfiguredFreeTextFields();

=cut

sub WorkOrderGetConfiguredFreeTextFields {
    my ( $Self, %Param ) = @_;

    # lookup cached result
    if (
        $Self->{ConfiguredWorkOrderFreeTextFields}
        && ref $Self->{ConfiguredWorkOrderFreeTextFields} eq 'ARRAY'
        && @{ $Self->{ConfiguredWorkOrderFreeTextFields} }
        )
    {
        return @{ $Self->{ConfiguredWorkOrderFreeTextFields} };
    }

    # get maximum number of workorder freetext fields
    my $MaxNumber = $Self->{ConfigObject}->Get('ITSMWorkOrder::FreeText::MaxNumber');

    # get all configured workorder freekey and freetext numbers
    my @ConfiguredWorkOrderFreeTextFields = ();
    FREETEXTNUMBER:
    for my $Number ( 1 .. $MaxNumber ) {

        # check workorder freekey config
        if ( $Self->{ConfigObject}->Get( 'WorkOrderFreeKey' . $Number ) ) {
            push @ConfiguredWorkOrderFreeTextFields, $Number;
            next FREETEXTNUMBER;
        }

        # check workorder freetext config
        if ( $Self->{ConfigObject}->Get( 'WorkOrderFreeText' . $Number ) ) {
            push @ConfiguredWorkOrderFreeTextFields, $Number;
            next FREETEXTNUMBER;
        }
    }

    # cache result
    $Self->{ConfiguredWorkOrderFreeTextFields} = \@ConfiguredWorkOrderFreeTextFields;

    return @ConfiguredWorkOrderFreeTextFields;
}

sub DESTROY {
    my $Self = shift;

    # execute all transaction events
    $Self->EventHandlerTransaction();

    return 1;
}

=begin Internal:

=item _CheckWorkOrderTypeIDs()

check whether the given workorder type ids are all valid

    my $Ok = $WorkOrderObject->_CheckWorkOrderTypeIDs(
        WorkOrderTypeIDs => [ 2, 500 ],
    );

=cut

sub _CheckWorkOrderTypeIDs {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{WorkOrderTypeIDs} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need WorkOrderTypeIDs!',
        );

        return;
    }

    if ( ref $Param{WorkOrderTypeIDs} ne 'ARRAY' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'The param WorkOrderTypeIDs must be an ARRAY reference!',
        );

        return;
    }

    # check if WorkOrderTypeIDs belongs to correct general catalog class
    for my $TypeID ( @{ $Param{WorkOrderTypeIDs} } ) {
        my $Type = $Self->WorkOrderTypeLookup(
            WorkOrderTypeID => $TypeID,
        );

        if ( !$Type ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "The type id $TypeID is not valid!",
            );

            return;
        }
    }

    return 1;
}

=item _GetWorkOrderNumber()

Get a new unused workorder number for the given change.
The highest current workorder number for the given change is
looked up and incremented by one.

    my $WorkOrderNumber = $WorkOrderObject->_GetWorkOrderNumber(
        ChangeID => 2,
    );

=cut

sub _GetWorkOrderNumber {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ChangeID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need ChangeID!',
        );
        return;
    }

    # get the largest workorder number
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT MAX(workorder_number) '
            . 'FROM change_workorder '
            . 'WHERE change_id = ?',
        Bind  => [ \$Param{ChangeID} ],
        Limit => 1,
    );

    # fetch the result, default to 0 when there are no workorders yet
    my $WorkOrderNumber;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $WorkOrderNumber = $Row[0];
    }
    $WorkOrderNumber ||= 0;

    # increment number to get a non-existent workorder number
    $WorkOrderNumber++;

    return $WorkOrderNumber;
}

=item _CheckWorkOrderParams()

Checks the params to WorkOrderAdd() and WorkOrderUpdate().
There are no required parameters.
The value for C<WorkOrderAgentID> can be undefined.

    my $Ok = $WorkOrderObject->_CheckWorkOrderParams(
        ChangeID           => 123,                                             # (optional)
        WorkOrderNumber    => 5,                                               # (optional)
        WorkOrderTitle     => 'Replacement of mail server',                    # (optional)
        Instruction        => 'Install the <b>new</b> server',                 # (optional)
        InstructionPlain   => 'Install the new server',                        # (optional)
        Report             => 'Installed new server <b>without</b> problems',  # (optional)
        ReportPlain        => 'Installed new server without problems',         # (optional)
        WorkOrderStateID   => 4,                                               # (optional)
        WorkOrderTypeID    => 12,                                              # (optional)
        WorkOrderAgentID   => 8,                                               # (optional) undef is allowed
        PlannedStartTime   => '2009-10-01 10:33:00',                           # (optional)
        ActualStartTime    => '2009-10-01 10:33:00',                           # (optional)
        PlannedEndTime     => '2009-10-01 10:33:00',                           # (optional)
        ActualEndTime      => '2009-10-01 10:33:00',                           # (optional)
        WorkOrderFreeKey1  => 'Sun',                                           # (optional) workorder freekey fields from 1 to ITSMWorkOrder::FreeText::MaxNumber
        WorkOrderFreeText1 => 'Earth',                                         # (optional) workorder freetext fields from 1 to ITSMWorkOrder::FreeText::MaxNumber

    );

These string parameters have length constraints:

    Parameter        | max. length
    -----------------+-----------------
    WorkOrderTitle      |  250 characters
    Instruction         | 1800000 characters
    InstructionPlain    | 1800000 characters
    Report              | 1800000 characters
    ReportPlain         | 1800000 characters
    WorkOrderFreeKeyXX  |  250 characters
    WorkOrderFreeTextXX |  250 characters

=cut

sub _CheckWorkOrderParams {
    my ( $Self, %Param ) = @_;

    # check the string and id parameters
    ARGUMENT:
    for my $Argument (
        qw(
        WorkOrderTitle
        Instruction
        InstructionPlain
        Report
        ReportPlain
        WorkOrderAgentID
        WorkOrderStateID
        WorkOrderTypeID
        WorkOrderNumber
        ChangeID
        )
        )
    {

        # params are not required
        next ARGUMENT if !exists $Param{$Argument};

        # check if param is not defined
        if ( $Argument eq 'WorkOrderAgentID' && !defined $Param{$Argument} ) {

            # WorkOrderAgentID can be undefined
        }
        elsif ( !defined $Param{$Argument} ) {
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
        if ( $Argument eq 'WorkOrderTitle' && length( $Param{$Argument} ) > 250 ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "The parameter '$Argument' must be shorter than 250 characters!",
            );
            return;
        }

        # check the maximum length of description and justification
        if (
            $Argument eq 'Instruction'
            || $Argument eq 'InstructionPlain'
            || $Argument eq 'Report'
            || $Argument eq 'ReportPlain'
            )
        {
            if ( length( $Param{$Argument} ) > 1800000 ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message => "The parameter '$Argument' must be shorter than 1800000 characters!",
                );
                return;
            }
        }
    }

    # check time formats
    OPTION:
    for my $Option (qw(PlannedStartTime PlannedEndTime ActualStartTime ActualEndTime)) {
        next OPTION if !$Param{$Option};

        return if $Param{$Option} !~ m{ \A \d\d\d\d-\d\d-\d\d \s \d\d:\d\d:\d\d \z }xms;
    }

    # check workorder agent
    if ( exists $Param{WorkOrderAgentID} && defined $Param{WorkOrderAgentID} ) {

        # WorkOrderAgent must be an agent
        my %UserData = $Self->{UserObject}->GetUserData(
            UserID => $Param{WorkOrderAgentID},
            Valid  => 1,
        );

        if ( !$UserData{UserID} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "The WorkOrderAgent $Param{WorkOrderAgentID} is not a valid user id!",
            );
            return;
        }
    }

    # check the freekey and freetext parameters
    for my $Type ( 'WorkOrderFreeKey', 'WorkOrderFreeText' ) {

        # check all possible freetext fields
        NUMBER:
        for my $Number ( 1 .. $Self->{ConfigObject}->Get('ITSMWorkOrder::FreeText::MaxNumber') ) {

            # build argument, e.g. WorkOrderFreeKey1
            my $Argument = $Type . $Number;

            # params are not required
            next NUMBER if !exists $Param{$Argument};

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

            # check the maximum length of freetext fields
            if ( length( $Param{$Argument} ) > 250 ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "The parameter '$Argument' must be shorter than 250 characters!",
                );
                return;
            }
        }
    }

    # check if given WorkOrderStateID is valid
    if ( exists $Param{WorkOrderStateID} ) {
        return if !$Self->WorkOrderStateIDsCheck(
            WorkOrderStateIDs => [ $Param{WorkOrderStateID} ],
        );
    }

    # check if given WorkOrderTypeID is valid
    if ( exists $Param{WorkOrderTypeID} ) {
        return if !$Self->_CheckWorkOrderTypeIDs(
            WorkOrderTypeIDs => [ $Param{WorkOrderTypeID} ],
        );
    }

    return 1;
}

=item _CheckTimestamps()

Checks the constraints of timestamps: xxxStartTime must be before xxxEndTime

    my $Ok = $WorkOrderObject->_CheckTimestamps(
        WorkOrderData    => $WorkOrderData,
        PlannedStartTime => '2009-10-12 00:00:01',     # (optional) or undef
        PlannedEndTime   => '2009-10-15 15:00:00',     # (optional) or undef
        ActualStartTime  => '2009-10-14 00:00:01',     # (optional) or undef
        ActualEndTime    => '2009-01-20 00:00:01',     # (optional) or undef
    );

If PlannedStartTime is given, PlannedEndTime has to be given, too - and vice versa.
If ActualStartTime is given ActualEndTime is optional.
But if ActualEndTime is given then ActualStartTime has to be given, too.
WorkOrderData is only passed for improving the performance.

=cut

sub _CheckTimestamps {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(WorkOrderData)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    my $DefaultTimeStamp = '9999-01-01 00:00:00';

    # check times
    TYPE:
    for my $Type (qw(Actual Planned)) {

        # check only when a start or a end time is given
        if ( !exists $Param{ $Type . 'StartTime' } && !exists $Param{ $Type . 'EndTime' } ) {
            next TYPE;
        }

        # for the log messages
        my $TypeLc = lc $Type;

        my $StartTime = '';
        if ( !exists $Param{ $Type . 'StartTime' } ) {

            # if a time is not given, get it from the workorder
            $StartTime = $Param{WorkOrderData}->{ $Type . 'StartTime' };
        }
        elsif ( !defined $Param{ $Type . 'StartTime' } ) {

            # special case for clearing the time
            $StartTime = $DefaultTimeStamp;
        }
        elsif ( !$Param{ $Type . 'StartTime' } ) {

            # if a time is not given, get it from the workorder
            $StartTime = $Param{WorkOrderData}->{ $Type . 'StartTime' };
        }
        elsif ( $Param{ $Type . 'StartTime' } eq $DefaultTimeStamp ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "The value $StartTime is invalid for the $TypeLc start time!",
            );
            return;
        }
        else {
            $StartTime = $Param{ $Type . 'StartTime' };
        }

        my $EndTime = '';
        if ( !exists $Param{ $Type . 'EndTime' } ) {

            # if a time is not given, get it from the workorder
            $EndTime = $Param{WorkOrderData}->{ $Type . 'EndTime' };
        }
        elsif ( !defined $Param{ $Type . 'EndTime' } ) {

            # special case for clearing the time
            $EndTime = $DefaultTimeStamp;
        }
        elsif ( !$Param{ $Type . 'EndTime' } ) {

            # if a time is not given, get it from the workorder
            $EndTime = $Param{WorkOrderData}->{ $Type . 'EndTime' };
        }
        elsif ( $Param{ $Type . 'EndTime' } eq $DefaultTimeStamp ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "The value $EndTime is invalid for the $TypeLc end time!",
            );
            return;
        }
        else {
            $EndTime = $Param{ $Type . 'EndTime' };
        }

        # don't check actual start time when the workorder has not ended yet
        if ( $Type eq 'Actual' && $StartTime && !$EndTime ) {
            next TYPE;
        }

        # the check fails if not both (start and end) times are present
        if ( !$StartTime || !$EndTime ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "$Type start time and $TypeLc end time must be given!",
            );
            return;
        }

        # check the ordering of the times, only in the non-default-case
        if ( $StartTime ne $DefaultTimeStamp && $EndTime ne $DefaultTimeStamp ) {

            # remove all non-digit characters
            $StartTime =~ s{ \D }{}xmsg;
            $EndTime =~ s{ \D }{}xmsg;

            # start time must be smaller than end time
            if ( $StartTime >= $EndTime ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message =>
                        "The $TypeLc start time '$StartTime' must be before the $TypeLc end time '$EndTime'!",
                );
                return;
            }
        }
    }

    return 1;
}

=item _WorkOrderFreeTextGet()

Gets the freetext and freekey fields of a workorder as a hash reference.

    my $WorkOrderFreeText = $WorkOrderObject->_WorkOrderFreeTextGet(
        WorkOrderID => 123,
        UserID      => 1,
    );

Returns:

    $WorkOrderFreeText = {
        WorkOrderFreeKey1  => 'Sun',   # workorder freekey fields from 1 to ITSMWorkOrder::FreeText::MaxNumber
        WorkOrderFreeText1 => 'Earth', # workorder freetext fields from 1 to ITSMWorkOrder::FreeText::MaxNumber
    }

=cut

sub _WorkOrderFreeTextGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Attribute (qw(WorkOrderID UserID)) {
        if ( !$Param{$Attribute} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Attribute!",
            );
            return;
        }
    }

    # to store workorder freekey and freetext data
    my %Data;

    # get workorder freekey and freetext data
    for my $Type ( 'WorkOrderFreeKey', 'WorkOrderFreeText' ) {

        # preset every freetext field with empty string
        for my $Number ( 1 .. $Self->{ConfigObject}->Get('ITSMWorkOrder::FreeText::MaxNumber') ) {
            $Data{ $Type . $Number } = '';
        }

        # set table name
        my $TableName = '';
        if ( $Type eq 'WorkOrderFreeText' ) {
            $TableName = 'change_wo_freetext';
        }
        elsif ( $Type eq 'WorkOrderFreeKey' ) {
            $TableName = 'change_wo_freekey';
        }

        # get workorder freetext fields
        return if !$Self->{DBObject}->Prepare(
            SQL => 'SELECT field_id, field_value'
                . ' FROM ' . $TableName
                . ' WHERE workorder_id = ?',
            Bind => [ \$Param{WorkOrderID} ],
        );
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            my $Field = $Type . $Row[0];
            my $Value = $Row[1];
            $Data{$Field} = defined $Value ? $Value : '';
        }
    }

    return \%Data;
}

=item _WorkOrderFreeTextUpdate()

Updates the freetext and freekey fields of a workorder.
Passing an empty string deletes the freetext field.

    my $Success = $WorkOrderObject->_WorkOrderFreeTextUpdate(
        WorkOrderID        => 123,
        WorkOrderFreeKey1  => 'Sun',   # (optional) workorder freekey fields from 1 to ITSMWorkOrder::FreeText::MaxNumber
        WorkOrderFreeText1 => 'Earth', # (optional) workorder freetext fields from 1 to ITSMWorkOrder::FreeText::MaxNumber
        UserID             => 1,
    );

=cut

sub _WorkOrderFreeTextUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Attribute (qw(WorkOrderID UserID)) {
        if ( !$Param{$Attribute} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Attribute!",
            );
            return;
        }
    }

    # check the given parameters
    return if !$Self->_CheckWorkOrderParams(%Param);

    # store the given freekey and freetext ids
    my @FreeKeyFieldIDs;
    my @FreeTextFieldIDs;
    for my $Type ( 'WorkOrderFreeKey', 'WorkOrderFreeText' ) {

        # check all possible freetext fields
        NUMBER:
        for my $Number ( 1 .. $Self->{ConfigObject}->Get('ITSMWorkOrder::FreeText::MaxNumber') ) {

            # build argument, e.g. WorkOrderFreeKey1
            my $Argument = $Type . $Number;

            # params are not required
            next NUMBER if !exists $Param{$Argument};

            # all checks were done before, so here we are safe and store the ids
            if ( $Type eq 'WorkOrderFreeKey' ) {
                push @FreeKeyFieldIDs, $Number;
            }
            elsif ( $Type eq 'WorkOrderFreeText' ) {
                push @FreeTextFieldIDs, $Number;
            }
        }
    }

    for my $Type ( 'WorkOrderFreeKey', 'WorkOrderFreeText' ) {

        # set table name and arrays of field ids
        my $TableName;
        my @FieldIDs;
        if ( $Type eq 'WorkOrderFreeKey' ) {
            $TableName = 'change_wo_freekey';
            @FieldIDs  = @FreeKeyFieldIDs;
        }
        elsif ( $Type eq 'WorkOrderFreeText' ) {
            $TableName = 'change_wo_freetext';
            @FieldIDs  = @FreeTextFieldIDs;
        }

        # get all existing entries for this workorder_id
        # and type (WorkOrderFreeKey or WorkOrderFreeText)
        $Self->{DBObject}->Prepare(
            SQL => 'SELECT id, field_id '
                . 'FROM ' . $TableName
                . ' WHERE workorder_id = ?',
            Bind => [ \$Param{WorkOrderID} ],
        );
        my %FieldData;
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            my $ID      = $Row[0];
            my $FieldID = $Row[1];

            $FieldData{$FieldID} = {
                ID => $ID,
            };
        }

        # update all given workorder freekey and freetext fields
        for my $FieldID (@FieldIDs) {

            # get new value from parameter
            my $Value = $Param{ $Type . $FieldID };

            # freetext/freekey field exists in database
            if ( $FieldData{$FieldID} ) {

                # new value is not en empty string, the field needs an update
                if ( $Value ne '' ) {
                    return if !$Self->{DBObject}->Do(
                        SQL => 'UPDATE ' . $TableName
                            . ' SET field_value = ?'
                            . ' WHERE id = ?',
                        Bind => [ \$Value, \$FieldData{$FieldID}->{ID} ],
                    );
                }

                # new value is an empty string, the field must be deleted
                else {
                    return if !$Self->{DBObject}->Do(
                        SQL => 'DELETE FROM ' . $TableName
                            . ' WHERE id = ?',
                        Bind => [ \$FieldData{$FieldID}->{ID} ],
                    );
                }
            }

            # freetext/freekey field does not exist in database
            # and new value is not an empty string
            elsif ( $Value ne '' ) {
                return if !$Self->{DBObject}->Do(
                    SQL => 'INSERT INTO ' . $TableName
                        . ' (workorder_id, field_id, field_value)'
                        . ' VALUES (?, ?, ?)',
                    Bind => [ \$Param{WorkOrderID}, \$FieldID, \$Value ],
                );
            }
        }
    }

    # delete cache
    $Self->{CacheObject}->Delete(
        Type => 'ITSMChangeManagement',
        Key  => 'WorkOrderGet::ID::' . $Param{WorkOrderID},
    );

    return 1;
}

=item _WorkOrderFreeTextDelete()

Deletes all freetext and freekey fields of a workorder.

    my $Success = $WorkOrderObject->_WorkOrderFreeTextDelete(
        WorkOrderID => 123,
        UserID      => 1,
    );

=cut

sub _WorkOrderFreeTextDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Attribute (qw(WorkOrderID UserID)) {
        if ( !$Param{$Attribute} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Attribute!",
            );
            return;
        }
    }

    for my $Type ( 'WorkOrderFreeKey', 'WorkOrderFreeText' ) {

        # set table name
        my $TableName;
        if ( $Type eq 'WorkOrderFreeKey' ) {
            $TableName = 'change_wo_freekey';
        }
        elsif ( $Type eq 'WorkOrderFreeText' ) {
            $TableName = 'change_wo_freetext';
        }

        # delete entries from database
        return if !$Self->{DBObject}->Do(
            SQL => 'DELETE FROM ' . $TableName
                . ' WHERE workorder_id = ?',
            Bind => [ \$Param{WorkOrderID} ],
        );
    }

    # delete cache
    $Self->{CacheObject}->Delete(
        Type => 'ITSMChangeManagement',
        Key  => 'WorkOrderGet::ID::' . $Param{WorkOrderID},
    );

    return 1;
}

1;

=end Internal:

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
