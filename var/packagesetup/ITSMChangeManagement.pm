# --
# ITSMChangeManagement.pm - code to excecute during package installation
# Copyright (C) 2003-2010 OTRS AG, http://otrs.com/
# --
# $Id: ITSMChangeManagement.pm,v 1.31 2010-01-25 10:09:09 bes Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package var::packagesetup::ITSMChangeManagement;

use strict;
use warnings;

use Kernel::Config;
use Kernel::System::Config;
use Kernel::System::CSV;
use Kernel::System::GeneralCatalog;
use Kernel::System::Group;
use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::History;
use Kernel::System::ITSMChange::ITSMChangeCIPAllocate;
use Kernel::System::ITSMChange::ITSMStateMachine;
use Kernel::System::ITSMChange::ITSMWorkOrder;
use Kernel::System::ITSMChange::Notification;
use Kernel::System::LinkObject;
use Kernel::System::State;
use Kernel::System::Stats;
use Kernel::System::Type;
use Kernel::System::User;
use Kernel::System::Valid;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.31 $) [1];

=head1 NAME

ITSMChangeManagement.pm - code to excecute during package installation

=head1 SYNOPSIS

All functions

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::Time;
    use Kernel::System::DB;
    use Kernel::System::XML;
    use var::packagesetup::ITSMChangeManagement;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject    = Kernel::System::Log->new(
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
    my $XMLObject = Kernel::System::XML->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        MainObject   => $MainObject,
    );
    my $CodeObject = var::packagesetup::ITSMChangeManagement->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
        TimeObject   => $TimeObject,
        DBObject     => $DBObject,
        XMLObject    => $XMLObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (
        qw(ConfigObject EncodeObject LogObject MainObject TimeObject DBObject XMLObject)
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    # create needed sysconfig object
    $Self->{SysConfigObject} = Kernel::System::Config->new( %{$Self} );

    # rebuild ZZZ* files
    $Self->{SysConfigObject}->WriteDefault();

    # define the ZZZ files
    my @ZZZFiles = (
        'ZZZAAuto.pm',
        'ZZZAuto.pm',
    );

    # reload the ZZZ files (mod_perl workaround)
    for my $ZZZFile (@ZZZFiles) {

        PREFIX:
        for my $Prefix (@INC) {
            my $File = $Prefix . '/Kernel/Config/Files/' . $ZZZFile;
            next PREFIX if !-f $File;
            do $File;
            last PREFIX;
        }
    }

    # create needed objects
    $Self->{ConfigObject}      = Kernel::Config->new();
    $Self->{CSVObject}         = Kernel::System::CSV->new( %{$Self} );
    $Self->{GroupObject}       = Kernel::System::Group->new( %{$Self} );
    $Self->{UserObject}        = Kernel::System::User->new( %{$Self} );
    $Self->{StateObject}       = Kernel::System::State->new( %{$Self} );
    $Self->{TypeObject}        = Kernel::System::Type->new( %{$Self} );
    $Self->{ValidObject}       = Kernel::System::Valid->new( %{$Self} );
    $Self->{LinkObject}        = Kernel::System::LinkObject->new( %{$Self} );
    $Self->{ChangeObject}      = Kernel::System::ITSMChange->new( %{$Self} );
    $Self->{CIPAllocateObject} = Kernel::System::ITSMChange::ITSMChangeCIPAllocate->new( %{$Self} );
    $Self->{StateMachineObject}   = Kernel::System::ITSMChange::ITSMStateMachine->new( %{$Self} );
    $Self->{GeneralCatalogObject} = Kernel::System::GeneralCatalog->new( %{$Self} );
    $Self->{WorkOrderObject}      = Kernel::System::ITSMChange::ITSMWorkOrder->new( %{$Self} );
    $Self->{HistoryObject}        = Kernel::System::ITSMChange::History->new( %{$Self} );
    $Self->{NotificationObject}   = Kernel::System::ITSMChange::Notification->new( %{$Self} );
    $Self->{StatsObject}          = Kernel::System::Stats->new(
        %{$Self},
        UserID => 1,
    );

    # define file prefix for stats
    $Self->{FilePrefix} = 'ITSMStats';

    return $Self;
}

=item CodeInstall()

run the code install part

    my $Result = $CodeObject->CodeInstall();

=cut

sub CodeInstall {
    my ( $Self, %Param ) = @_;

    # add the group itsm-change
    $Self->_GroupAdd(
        Name        => 'itsm-change',
        Description => 'Group for ITSM Change mask access in the agent interface.',
    );

    # add the group itsm-change-builder
    $Self->_GroupAdd(
        Name        => 'itsm-change-builder',
        Description => 'Group for ITSM Change Builders.',
    );

    # add the group itsm-change-manager
    $Self->_GroupAdd(
        Name        => 'itsm-change-manager',
        Description => 'Group for ITSM Change Managers.',
    );

    # install stats
    $Self->{StatsObject}->StatsInstall(
        FilePrefix => $Self->{FilePrefix},
    );

    # set default CIP matrix
    $Self->_CIPDefaultMatrixSet();

    # set default StateMachine settings
    $Self->_StateMachineDefaultSet();

    # add notifications
    $Self->_AddNotifications();

    # add system notifications
    $Self->_AddSystemNotifications();

    return 1;
}

=item CodeReinstall()

run the code reinstall part

    my $Result = $CodeObject->CodeReinstall();

=cut

sub CodeReinstall {
    my ( $Self, %Param ) = @_;

    # add the group itsm-change
    $Self->_GroupAdd(
        Name        => 'itsm-change',
        Description => 'Group for ITSM Change mask access in the agent interface.',
    );

    # add the group itsm-change-builder
    $Self->_GroupAdd(
        Name        => 'itsm-change-builder',
        Description => 'Group for ITSM Change Builders.',
    );

    # add the group itsm-change-manager
    $Self->_GroupAdd(
        Name        => 'itsm-change-manager',
        Description => 'Group for ITSM Change Managers.',
    );

    # install stats
    $Self->{StatsObject}->StatsInstall(
        FilePrefix => $Self->{FilePrefix},
    );

    # set default CIP matrix
    $Self->_CIPDefaultMatrixSet();

    # set default StateMachine settings
    $Self->_StateMachineDefaultSet();

    return 1;
}

=item CodeUpgrade()

run the code upgrade part

    my $Result = $CodeObject->CodeUpgrade();

=cut

sub CodeUpgrade {
    my ( $Self, %Param ) = @_;

    # install stats
    $Self->{StatsObject}->StatsInstall(
        FilePrefix => $Self->{FilePrefix},
    );

    # set default CIP matrix
    $Self->_CIPDefaultMatrixSet();

    # set default StateMachine settings
    $Self->_StateMachineDefaultSet();

    return 1;
}

=item CodeUninstall()

run the code uninstall part

    my $Result = $CodeObject->CodeUninstall();

=cut

sub CodeUninstall {
    my ( $Self, %Param ) = @_;

    # delete all links with change and workorder objects
    $Self->_LinkDelete();

    # deactivate the group itsm-change
    $Self->_GroupDeactivate(
        Name => 'itsm-change',
    );

    # deactivate the group itsm-change-builder
    $Self->_GroupDeactivate(
        Name => 'itsm-change-builder',
    );

    # deactivate the group itsm-change-manager
    $Self->_GroupDeactivate(
        Name => 'itsm-change-manager',
    );

    # delete system notifications
    $Self->_DeleteSystemNotifications();

    return 1;
}

=begin Internal:

=item _GroupAdd()

add a group

    my $Result = $CodeObject->_GroupAdd(
        Name        => 'the-group-name',
        Description => 'The group description.',
    );

=cut

sub _GroupAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Name Description)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get valid list
    my %ValidList = $Self->{ValidObject}->ValidList(
        UserID => 1,
    );
    my %ValidListReverse = reverse %ValidList;

    # check if group already exists
    my $GroupID = $Self->{GroupObject}->GroupLookup(
        Group  => $Param{Name},
        UserID => 1,
    );

    # reactivate the group
    if ($GroupID) {

        # get current group data
        my %GroupData = $Self->{GroupObject}->GroupGet(
            ID     => $GroupID,
            UserID => 1,
        );

        # reactivate group
        $Self->{GroupObject}->GroupUpdate(
            %GroupData,
            ValidID => $ValidListReverse{valid},
            UserID  => 1,
        );

        return 1;
    }

    # add the group
    else {
        return if !$Self->{GroupObject}->GroupAdd(
            Name    => $Param{Name},
            Comment => $Param{Description},
            ValidID => $ValidListReverse{valid},
            UserID  => 1,
        );
    }

    # lookup the new group id
    my $NewGroupID = $Self->{GroupObject}->GroupLookup(
        Group  => $Param{Name},
        UserID => 1,
    );

    # add user root to the group
    $Self->{GroupObject}->GroupMemberAdd(
        GID        => $NewGroupID,
        UID        => 1,
        Permission => {
            ro        => 1,
            move_into => 1,
            create    => 1,
            owner     => 1,
            priority  => 1,
            rw        => 1,
        },
        UserID => 1,
    );

    return 1;
}

=item _GroupDeactivate()

deactivate a group

    my $Result = $CodeObject->_GroupDeactivate(
        Name => 'the-group-name',
    );

=cut

sub _GroupDeactivate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Name} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Name!',
        );
        return;
    }

    # lookup group id
    my $GroupID = $Self->{GroupObject}->GroupLookup(
        Group => $Param{Name},
    );

    return if !$GroupID;

    # get valid list
    my %ValidList = $Self->{ValidObject}->ValidList(
        UserID => 1,
    );
    my %ValidListReverse = reverse %ValidList;

    # get current group data
    my %GroupData = $Self->{GroupObject}->GroupGet(
        ID     => $GroupID,
        UserID => 1,
    );

    # deactivate group
    $Self->{GroupObject}->GroupUpdate(
        %GroupData,
        ValidID => $ValidListReverse{invalid},
        UserID  => 1,
    );

    return 1;
}

=item _CIPDefaultMatrixSet()

set the default CIP matrix

    my $Result = $CodeObject->_CIPDefaultMatrixSet();

=cut

sub _CIPDefaultMatrixSet {
    my ( $Self, %Param ) = @_;

    # get current allocation list
    my $List = $Self->{CIPAllocateObject}->AllocateList(
        UserID => 1,
    );

    return if !$List;
    return if ref $List ne 'HASH';

    # set no matrix if already defined
    return if %{$List};

    # define the allocations
    # $Allocation{Impact}->{Category} = Priority
    my %Allocation;
    $Allocation{'1 very low'}->{'1 very low'}   = '1 very low';
    $Allocation{'1 very low'}->{'2 low'}        = '1 very low';
    $Allocation{'1 very low'}->{'3 normal'}     = '2 low';
    $Allocation{'1 very low'}->{'4 high'}       = '2 low';
    $Allocation{'1 very low'}->{'5 very high'}  = '3 normal';
    $Allocation{'2 low'}->{'1 very low'}        = '1 very low';
    $Allocation{'2 low'}->{'2 low'}             = '2 low';
    $Allocation{'2 low'}->{'3 normal'}          = '2 low';
    $Allocation{'2 low'}->{'4 high'}            = '3 normal';
    $Allocation{'2 low'}->{'5 very high'}       = '4 high';
    $Allocation{'3 normal'}->{'1 very low'}     = '2 low';
    $Allocation{'3 normal'}->{'2 low'}          = '2 low';
    $Allocation{'3 normal'}->{'3 normal'}       = '3 normal';
    $Allocation{'3 normal'}->{'4 high'}         = '4 high';
    $Allocation{'3 normal'}->{'5 very high'}    = '4 high';
    $Allocation{'4 high'}->{'1 very low'}       = '2 low';
    $Allocation{'4 high'}->{'2 low'}            = '3 normal';
    $Allocation{'4 high'}->{'3 normal'}         = '4 high';
    $Allocation{'4 high'}->{'4 high'}           = '4 high';
    $Allocation{'4 high'}->{'5 very high'}      = '5 very high';
    $Allocation{'5 very high'}->{'1 very low'}  = '3 normal';
    $Allocation{'5 very high'}->{'2 low'}       = '4 high';
    $Allocation{'5 very high'}->{'3 normal'}    = '4 high';
    $Allocation{'5 very high'}->{'4 high'}      = '5 very high';
    $Allocation{'5 very high'}->{'5 very high'} = '5 very high';

    # get impact list
    my $ImpactList = $Self->{GeneralCatalogObject}->ItemList(
        Class => 'ITSM::ChangeManagement::Impact',
    );
    my %ImpactListReverse = reverse %{$ImpactList};

    # get category list
    my $CategoryList = $Self->{GeneralCatalogObject}->ItemList(
        Class => 'ITSM::ChangeManagement::Category',
    );
    my %CategoryListReverse = reverse %{$CategoryList};

    # get priority list
    my $PriorityList = $Self->{GeneralCatalogObject}->ItemList(
        Class => 'ITSM::ChangeManagement::Priority',
    );
    my %PriorityListReverse = reverse %{$PriorityList};

    # create the allocation matrix
    my %AllocationMatrix;
    IMPACT:
    for my $Impact ( keys %Allocation ) {

        next IMPACT if !$ImpactListReverse{$Impact};

        # extract impact id
        my $ImpactID = $ImpactListReverse{$Impact};

        CATEGORY:
        for my $Category ( keys %{ $Allocation{$Impact} } ) {

            next CATEGORY if !$CategoryListReverse{$Category};

            # extract priority
            my $Priority = $Allocation{$Impact}->{$Category};

            next CATEGORY if !$PriorityListReverse{$Priority};

            # extract criticality id and priority id
            my $CategoryID = $CategoryListReverse{$Category};
            my $PriorityID = $PriorityListReverse{$Priority};

            $AllocationMatrix{$ImpactID}->{$CategoryID} = $PriorityID;
        }
    }

    # save the matrix
    $Self->{CIPAllocateObject}->AllocateUpdate(
        AllocateData => \%AllocationMatrix,
        UserID       => 1,
    );

    return 1;
}

=item _StateMachineDefaultSet()

set the default state machine

    my $Result = $CodeObject->_StateMachineDefaultSet();

=cut

sub _StateMachineDefaultSet {
    my ( $Self, %Param ) = @_;

    # get the change states from the general catalog
    my %Name2ChangeStateID = reverse %{
        $Self->{GeneralCatalogObject}->ItemList(
            Class => 'ITSM::ChangeManagement::Change::State',
            )
        };

    # get the workorder states from the general catalog
    my %Name2WorkOrderStateID = reverse %{
        $Self->{GeneralCatalogObject}->ItemList(
            Class => 'ITSM::ChangeManagement::WorkOrder::State',
            )
        };

    # define ChangeState transitions
    my %ChangeStateTransitions = (
        0 => ['requested'],
        'requested' => [ 'rejected', 'retracted', 'pending approval' ],
        'pending approval' => [ 'retracted', 'approved' ],
        'approved'         => [ 'retracted', 'in progress' ],
        'in progress'      => [ 'retracted', 'failed', 'successful', 'canceled' ],
        'rejected'   => [0],
        'retracted'  => [0],
        'failed'     => [0],
        'successful' => [0],
        'canceled'   => [0],
    );

    # define WorkOrderState transitions
    my %WorkOrderStateTransitions = (
        0             => ['created'],
        'created'     => [ 'accepted', 'canceled' ],
        'accepted'    => [ 'ready', 'canceled' ],
        'ready'       => [ 'in progress', 'canceled' ],
        'in progress' => [ 'closed', 'canceled' ],
        'canceled'    => [0],
        'closed'      => [0],
    );

    # insert ChangeState transitions into database
    for my $State ( sort keys %ChangeStateTransitions ) {

        for my $NextState ( @{ $ChangeStateTransitions{$State} } ) {

            # add state transition
            my $TransitionID = $Self->{StateMachineObject}->StateTransitionAdd(
                StateID     => $Name2ChangeStateID{$State}     || 0,
                NextStateID => $Name2ChangeStateID{$NextState} || 0,
                Class       => 'ITSM::ChangeManagement::Change::State',
            );
        }
    }

    # insert WorkOrderState transitions into database
    for my $State ( sort keys %WorkOrderStateTransitions ) {

        for my $NextState ( @{ $WorkOrderStateTransitions{$State} } ) {

            # add state transition
            my $TransitionID = $Self->{StateMachineObject}->StateTransitionAdd(
                StateID     => $Name2WorkOrderStateID{$State}     || 0,
                NextStateID => $Name2WorkOrderStateID{$NextState} || 0,
                Class       => 'ITSM::ChangeManagement::WorkOrder::State',
            );
        }
    }

    return 1;
}

=item _LinkDelete()

delete all existing links with change and workorder objects

    my $Result = $CodeObject->_LinkDelete();

=cut

sub _LinkDelete {
    my ( $Self, %Param ) = @_;

    # get all change object ids
    my $ChangeIDs = $Self->{ChangeObject}->ChangeList(
        UserID => 1,
    );

    # delete all change links
    if ( $ChangeIDs && ref $ChangeIDs eq 'ARRAY' ) {

        CHANGEID:
        for my $ChangeID ( @{$ChangeIDs} ) {

            # delete all links to this change
            $Self->{LinkObject}->LinkDeleteAll(
                Object => 'ITSMChange',
                Key    => $ChangeID,
                UserID => 1,
            );

            # get all workorder ids for this change
            my $WorkOrderIDs = $Self->{WorkOrderObject}->WorkOrderList(
                ChangeID => $ChangeID,
                UserID   => 1,
            );

            next CHANGEID if !$WorkOrderIDs;
            next CHANGEID if ref $WorkOrderIDs ne 'ARRAY';

            # delete all workorder links
            for my $WorkOrderID ( @{$WorkOrderIDs} ) {
                $Self->{LinkObject}->LinkDeleteAll(
                    Object => 'ITSMWorkOrder',
                    Key    => $WorkOrderID,
                    UserID => 1,
                );
            }
        }
    }

    return 1;
}

=item _AddNotifications()

Add ChangeManagement specific notifications.

    my $Success = $SetupObject->_AddNotifications;

=cut

sub _AddNotifications {
    my ($Self) = @_;

    # define notifications and recipients
    my @Notifications = (
        {
            Name       => 'requested changes',
            Attribute  => '',
            Event      => 'ChangeAdd',
            ValidID    => 1,
            Comment    => 'inform recipients that a change was requested',
            Rule       => '',
            Recipients => [ 'ChangeInitiators', 'ChangeManager', 'ChangeBuilder' ],
        },
        {
            Name       => 'pending approval changes',
            Attribute  => 'ChangeState',
            Event      => 'ChangeUpdate',
            ValidID    => 1,
            Comment    => 'inform recipients that a change waits for approval',
            Rule       => 'pending approval',
            Recipients => [ 'ChangeManager', 'CABCustomers', 'CABAgents' ],
        },
        {
            Name       => 'pending PIR changes',
            Attribute  => 'ChangeState',
            Event      => 'ChangeUpdate',
            ValidID    => 1,
            Comment    => 'inform recipients that a change waits for PIR',
            Rule       => 'pending PIR',
            Recipients => ['ChangeManager'],
        },
        {
            Name       => 'rejected changes',
            Attribute  => 'ChangeState',
            Event      => 'ChangeUpdate',
            ValidID    => 1,
            Comment    => 'inform recipients that a change was rejected',
            Rule       => 'rejected',
            Recipients => [
                'ChangeBuilder', 'ChangeInitiators', 'CABCustomers', 'CABAgents', 'WorkOrderAgents',
            ],
        },
        {
            Name       => 'approved changes',
            Attribute  => 'ChangeState',
            Event      => 'ChangeUpdate',
            ValidID    => 1,
            Comment    => 'inform recipients that a change was approved',
            Rule       => 'approved',
            Recipients => [
                'ChangeBuilder', 'ChangeInitiators', 'ChangeCABCustomers', 'ChangeCABAgents',
                'WorkOrderAgents',
            ],
        },
        {
            Name       => 'changes in progress',
            Attribute  => 'ChangeState',
            Event      => 'ChangeUpdate',
            ValidID    => 1,
            Comment    => 'inform recipients that a change is in progress',
            Rule       => 'in progress',
            Recipients => [ 'ChangeManager', 'WorkOrderAgents' ],
        },
        {
            Name       => 'successful changes',
            Attribute  => 'ChangeState',
            Event      => 'ChangeUpdate',
            ValidID    => 1,
            Comment    => 'inform recipients that a change was successful',
            Rule       => 'successful',
            Recipients => [
                'ChangeBuilder', 'ChangeInitiators', 'CABCustomers', 'CABAgents', 'WorkOrderAgents',
            ],
        },
        {
            Name       => 'failed changes',
            Attribute  => 'ChangeState',
            Event      => 'ChangeUpdate',
            ValidID    => 1,
            Comment    => 'inform recipients that a change failed',
            Rule       => 'failed',
            Recipients => [
                'ChangeBuilder', 'ChangeInitiators', 'CABCustomers', 'CABAgents', 'WorkOrderAgents',
            ],
        },
        {
            Name       => 'canceled changes',
            Attribute  => 'ChangeState',
            Event      => 'ChangeUpdate',
            ValidID    => 1,
            Comment    => 'inform recipients that a change was canceled',
            Rule       => 'canceled',
            Recipients => [ 'ChangeBuilder', 'ChangeManager' ],
        },
        {
            Name       => 'retracted changes',
            Attribute  => 'ChangeState',
            Event      => 'ChangeUpdate',
            ValidID    => 1,
            Comment    => 'inform recipients that a change was retracted',
            Rule       => 'retracted',
            Recipients => [
                'ChangeBuilder', 'ChangeInitiators', 'CABCustomers', 'CABAgents', 'WorkOrderAgents',
            ],
        },
        {
            Name       => 'ChangeManager update',
            Attribute  => 'ChangeManagerID',
            Event      => 'ChangeUpdate',
            ValidID    => 1,
            Comment    => 'inform recipients that the changemanager was replaced',
            Rule       => '.*',
            Recipients => [
                'ChangeManager', 'OldChangeManager',
            ],
        },
        {
            Name       => 'ChangeBuilder update',
            Attribute  => 'ChangeBuilderID',
            Event      => 'ChangeUpdate',
            ValidID    => 1,
            Comment    => 'inform recipients that the changebuilder was replaced',
            Rule       => '.*',
            Recipients => [
                'ChangeManager', 'ChangeBuilder', 'OldChangeBuilder',
            ],
        },
        {
            Name       => 'new workorder',
            Attribute  => '',
            Event      => 'WorkOrderAdd',
            ValidID    => 1,
            Comment    => 'inform recipients that a workorder was added',
            Rule       => '',
            Recipients => [
                'ChangeBuilder', 'WorkOrderAgent',
            ],
        },
        {
            Name       => 'updated state for workorder',
            Attribute  => 'WorkOrderState',
            Event      => 'WorkOrderUpdate',
            ValidID    => 1,
            Comment    => 'inform recipients that a the state of a workorder was changed',
            Rule       => '.*',
            Recipients => [
                'ChangeBuilder', 'WorkOrderAgents',
            ],
        },
        {
            Name       => 'updated workorder agent for workorder',
            Attribute  => 'WorkOrderAgentID',
            Event      => 'WorkOrderUpdate',
            ValidID    => 1,
            Comment    => 'inform recipients that the workorder agent was replaced',
            Rule       => '.*',
            Recipients => [
                'ChangeBuilder', 'WorkOrderAgent', 'OldWorkOrderAgent',
            ],
        },
        {
            Name       => 'ticket linked to change',
            Attribute  => '',
            Event      => 'ChangeLinkAdd',
            ValidID    => 1,
            Comment    => 'inform recipients that a ticket was linked to the change',
            Rule       => '',
            Recipients => [
                'ChangeBuilder', 'ChangeInitiators',
            ],
        },
    );

    # cache for lookup results
    my %HistoryTypes;

    # add notifications
    NOTIFICATION:
    for my $Notification (@Notifications) {

        # find recipients
        my @RecipientIDs;
        for my $Recipient ( @{ $Notification->{Recipients} } ) {
            my $RecipientID = $Self->{NotificationObject}->RecipientLookup(
                Name => $Recipient,
            );

            if ($RecipientID) {
                push @RecipientIDs, $RecipientID;
            }
        }

        # get event id
        my $EventID =
            $HistoryTypes{ $Notification->{Event} }
            || $Self->{HistoryObject}->HistoryTypeLookup( HistoryType => $Notification->{Event} );

        # insert notification
        my $RuleID = $Self->{NotificationObject}->NotificationRuleAdd(
            %{$Notification},
            EventID      => $EventID,
            RecipientIDs => \@RecipientIDs,
        );
    }

    return 1;
}

=item _AddSystemNotifications()

Adds the Change:: and WorkOrder:: notifications to systems notification table.

    my $Success = $PackageSetup->_AddSystemNotifications();

=cut

sub _AddSystemNotifications {
    my ($Self) = @_;

    # set up some standard texts
    my $BasicChangeInfoEn = "\n"
        . "\n"
        . "Change title: <OTRS_CHANGE_ChangeTitle>\n"
        . "Current change state: <OTRS_CHANGE_ChangeState>\n"
        . "\n"
        . "<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentITSMChangeZoom&ChangeID=<OTRS_CHANGE_ChangeID>\n"
        . "\n"
        . "Your OTRS Notification Master\n";

    my $BasicChangeInfoDe = "\n"
        . "\n"
        . "Change Titel: <OTRS_CHANGE_ChangeTitle>\n"
        . "Aktueller Change Status: <OTRS_CHANGE_ChangeState>\n"
        . "\n"
        . "<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentITSMChangeZoom&ChangeID=<OTRS_CHANGE_ChangeID>\n"
        . "\n"
        . "Ihr OTRS Notification Master\n";

    my $BasicWorkOrderInfoEn = "\n"
        . "\n"
        . "Change title: <OTRS_CHANGE_ChangeTitle>\n"
        . "Current change state: <OTRS_CHANGE_ChangeState>\n"
        . "\n"
        . "Workorder title: <OTRS_WORKORDER_WorkOrderTitle>\n"
        . "Workorder type: <OTRS_WORKORDER_WorkOrderType>\n"
        . "Current workorder state: <OTRS_WORKORDER_WorkOrderState>\n"
        . "\n"
        . "Your OTRS Notification Master\n";

    my $BasicWorkOrderInfoDe = "\n"
        . "\n"
        . "Change Titel: <OTRS_CHANGE_ChangeTitle>\n"
        . "Aktueller Change Status: <OTRS_CHANGE_ChangeState>\n"
        . "\n"
        . "Workorder Titel: <OTRS_WORKORDER_WorkOrderTitle>\n"
        . "Workorder Typ: <OTRS_WORKORDER_WorkOrderType>\n"
        . "Aktueller Workorder Status: <OTRS_WORKORDER_WorkOrderState>\n"
        . "\n"
        . "Ihr OTRS Notification Master\n";

    # define notifications
    my @AgentNotifications = (
        [
            'Agent::Change::ChangeAdd',
            'de',
            '[Change #<OTRS_CHANGE_ChangeNumber>] neu erstellt',
            'Der Change #<OTRS_CHANGE_ChangeNumber> wurde neu erstellt.' . $BasicChangeInfoDe,
        ],
        [
            'Agent::Change::ChangeAdd',
            'en',
            '[Change #<OTRS_CHANGE_ChangeNumber>] added',
            'Change #<OTRS_CHANGE_ChangeNumber> was added.' . $BasicChangeInfoEn,
        ],
        [
            'Agent::Change::ChangeUpdate',
            'de',
            '[Change #<OTRS_CHANGE_ChangeNumber>] aktualisiert',
            'Der Change #<OTRS_CHANGE_ChangeNumber> wurde aktualisiert.' . $BasicChangeInfoDe,
        ],
        [
            'Agent::Change::ChangeUpdate',
            'en',
            '[Change #<OTRS_CHANGE_ChangeNumber>] updated',
            'Change #<OTRS_CHANGE_ChangeNumber> was updated.' . $BasicChangeInfoEn,
        ],
        [
            'Agent::Change::ChangeCABUpdate',
            'de',
            '[Change #<OTRS_CHANGE_ChangeNumber>] CAB aktualisiert',
            'Change #<OTRS_CHANGE_ChangeNumber> mit aktualisierten CAB.' . $BasicChangeInfoEn,
        ],
        [
            'Agent::Change::ChangeCABUpdate',
            'en',
            '[Change #<OTRS_CHANGE_ChangeNumber>] CAB updated',
            'Change #<OTRS_CHANGE_ChangeNumber> with updated CAB.' . $BasicChangeInfoEn,
        ],
        [
            'Agent::Change::ChangeCABDelete',
            'de',
            '[Change #<OTRS_CHANGE_ChangeNumber>] CAB gelöscht',
            'Change #<OTRS_CHANGE_ChangeNumber> mit gelöschtem CAB.' . $BasicChangeInfoEn,
        ],
        [
            'Agent::Change::ChangeCABDelete',
            'en',
            '[Change #<OTRS_CHANGE_ChangeNumber>] CAB deleted',
            'Change #<OTRS_CHANGE_ChangeNumber> with deleted CAB.' . $BasicChangeInfoEn,
        ],
        [
            'Agent::Change::ChangeLinkAdd',
            'de',
            '[Change #<OTRS_CHANGE_ChangeNumber>] RfC verknüpft',
            'Change #<OTRS_CHANGE_ChangeNumber> mit verknüpftem RfC.' . $BasicChangeInfoDe,
        ],
        [
            'Agent::Change::ChangeLinkAdd',
            'en',
            '[Change #<OTRS_CHANGE_ChangeNumber>] RfC linked',
            'Change #<OTRS_CHANGE_ChangeNumber> with linked RfC.' . $BasicChangeInfoEn,
        ],
        [
            'Agent::Change::ChangeLinkDelete',
            'de',
            '[Change #<OTRS_CHANGE_ChangeNumber>] RfC entfernt',
            'Change #<OTRS_CHANGE_ChangeNumber> mit entferntem RfC.' . $BasicChangeInfoDe,
        ],
        [
            'Agent::Change::ChangeLinkDelete',
            'en',
            '[Change #<OTRS_CHANGE_ChangeNumber>] RfC unlinked',
            'Change #<OTRS_CHANGE_ChangeNumber> with unlinked RfC.' . $BasicChangeInfoEn,
        ],
        [
            'Agent::Change::ChangeDelete',
            'de',
            '[Change #<OTRS_CHANGE_ChangeNumber>] gelöscht',
            'Der Change #<OTRS_CHANGE_ChangeNumber> wurde gelöscht.',
        ],
        [
            'Agent::Change::ChangeDelete',
            'en',
            '[Change #<OTRS_CHANGE_ChangeNumber>] deleted',
            'Change #<OTRS_CHANGE_ChangeNumber> was deleted.',
        ],
        [
            'Agent::WorkOrder::WorkOrderAdd',
            'de',
            '[Workorder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] neu erstellt',
            'Die Workorder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> wurde neu erstellt.'
                . $BasicWorkOrderInfoDe,
        ],
        [
            'Agent::WorkOrder::WorkOrderAdd',
            'en',
            '[Workorder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] added',
            'The Workorder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> was added.'
                . $BasicWorkOrderInfoEn,
        ],
        [
            'Agent::WorkOrder::WorkOrderUpdate',
            'de',
            '[Workorder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] aktualisiert',
            'Die Workorder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> wurde aktualisiert.'
                . $BasicWorkOrderInfoDe,
        ],
        [
            'Agent::WorkOrder::WorkOrderUpdate',
            'en',
            '[Workorder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] updated',
            'The Workorder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> was updated.'
                . $BasicWorkOrderInfoEn,
        ],
        [
            'Agent::WorkOrder::WorkOrderDelete',
            'de',
            '[Workorder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] gelöscht',
            'Die Workorder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> wurde gelöscht.',
        ],
        [
            'Agent::WorkOrder::WorkOrderDelete',
            'en',
            '[Workorder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] deleted',
            'The Workorder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> was deleted.',
        ],
        [
            'Agent::WorkOrder::WorkOrderLinkAdd',
            'de',
            '[Workorder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] Ticket verknüpft',
            'Die Workorder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> wurde mit einem Ticket verknüpft.'
                . $BasicWorkOrderInfoDe,
        ],
        [
            'Agent::WorkOrder::WorkOrderLinkAdd',
            'en',
            '[Workorder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] Ticket linked',
            'The Workorder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> was linked to a ticket.'
                . $BasicWorkOrderInfoDe,
        ],
        [
            'Agent::WorkOrder::WorkOrderLinkDelete',
            'de',
            '[Workorder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] Ticket entfernt',
            'Die Workorder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> ist mit einem Ticket nicht mehr verknüpft.'
                . $BasicWorkOrderInfoDe,
        ],
        [
            'Agent::WorkOrder::WorkOrderLinkDelete',
            'en',
            '[Workorder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] Ticket removed',
            'The Workorder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> in no linker linked to a ticket.'
                . $BasicWorkOrderInfoDe,
        ],
        [
            'Agent::Change::ChangeAttachmentAdd',
            'de',
            '[Change #<OTRS_CHANGE_ChangeNumber>] neuer Anhang',
            'Change #<OTRS_CHANGE_ChangeNumber> hat einen neuen Anhang.' . $BasicChangeInfoDe,
        ],
        [
            'Agent::Change::ChangeAttachmentAdd',
            'en',
            '[Change #<OTRS_CHANGE_ChangeNumber>] new attachment.',
            'Change #<OTRS_CHANGE_ChangeNumber> with new attachment.' . $BasicChangeInfoEn,
        ],
        [
            'Agent::Change::ChangeAttachmentDelete',
            'de',
            '[Change #<OTRS_CHANGE_ChangeNumber>] Anhang gelöscht',
            'Change #<OTRS_CHANGE_ChangeNumber> mit gelöschtem Anhang.' . $BasicChangeInfoDe,
        ],
        [
            'Agent::Change::ChangeAttachmentDelete',
            'en',
            '[Change #<OTRS_CHANGE_ChangeNumber>] attachment deleted.',
            'Change #<OTRS_CHANGE_ChangeNumber> with deleted attachment.' . $BasicChangeInfoEn,
        ],
        [
            'Agent::WorkOrder::WorkOrderAttachmentAdd',
            'de',
            '[WorkOrder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] neuer Anhang',
            'WorkOrder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> hat einen neuen Anhang.'
                . $BasicWorkOrderInfoDe,
        ],
        [
            'Agent::WorkOrder::WorkOrderAttachmentAdd',
            'en',
            '[WorkOrder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] new attachment.',
            'WorkOrder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> with new attachment.'
                . $BasicWorkOrderInfoEn,
        ],
        [
            'Agent::WorkOrder::WorkOrderAttachmentDelete',
            'de',
            '[WorkOrder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] Anhang gelöscht',
            'WorkOrder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> mit gelöschtem Anhang.'
                . $BasicWorkOrderInfoDe,
        ],
        [
            'Agent::WorkOrder::WorkOrderAttachmentDelete',
            'en',
            '[WorkOrder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] attachment deleted.',
            'WorkOrder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> with deleted attachment.'
                . $BasicWorkOrderInfoEn,
        ],
    );

    my @CustomerNotifications = (
        [
            'Customer::Change::ChangeAdd',
            'de',
            '[Change #<OTRS_CHANGE_ChangeNumber>] neu erstellt',
            'Der Change #<OTRS_CHANGE_ChangeNumber> wurde neu erstellt.' . $BasicChangeInfoDe,
        ],
        [
            'Customer::Change::ChangeAdd',
            'en',
            '[Change #<OTRS_CHANGE_ChangeNumber>] added',
            'Change #<OTRS_CHANGE_ChangeNumber> was added.' . $BasicChangeInfoEn,
        ],
        [
            'Customer::Change::ChangeUpdate',
            'de',
            '[Change #<OTRS_CHANGE_ChangeNumber>] aktualisiert',
            'Der Change #<OTRS_CHANGE_ChangeNumber> wurde aktualisiert.' . $BasicChangeInfoDe,
        ],
        [
            'Customer::Change::ChangeUpdate',
            'en',
            '[Change #<OTRS_CHANGE_ChangeNumber>] updated',
            'Change #<OTRS_CHANGE_ChangeNumber> was updated.' . $BasicChangeInfoEn,
        ],
        [
            'Customer::Change::ChangeCABUpdate',
            'de',
            '[Change #<OTRS_CHANGE_ChangeNumber>] CAB aktualisiert',
            'Change #<OTRS_CHANGE_ChangeNumber> mit aktualisierten CAB.' . $BasicChangeInfoEn,
        ],
        [
            'Customer::Change::ChangeCABUpdate',
            'en',
            '[Change #<OTRS_CHANGE_ChangeNumber>] CAB updated',
            'Change #<OTRS_CHANGE_ChangeNumber> with updated CAB.' . $BasicChangeInfoEn,
        ],
        [
            'Customer::Change::ChangeCABDelete',
            'de',
            '[Change #<OTRS_CHANGE_ChangeNumber>] CAB gelöscht',
            'Change #<OTRS_CHANGE_ChangeNumber> mit gelöschtem CAB.' . $BasicChangeInfoEn,
        ],
        [
            'Customer::Change::ChangeCABDelete',
            'en',
            '[Change #<OTRS_CHANGE_ChangeNumber>] CAB deleted',
            'Change #<OTRS_CHANGE_ChangeNumber> with deleted CAB.' . $BasicChangeInfoEn,
        ],
        [
            'Customer::Change::ChangeLinkAdd',
            'de',
            '[Change #<OTRS_CHANGE_ChangeNumber>] RfC verknüpft',
            'Change #<OTRS_CHANGE_ChangeNumber> mit verknüpftem RfC.' . $BasicChangeInfoDe,
        ],
        [
            'Customer::Change::ChangeLinkAdd',
            'en',
            '[Change #<OTRS_CHANGE_ChangeNumber>] RfC linked',
            'Change #<OTRS_CHANGE_ChangeNumber> with linked RfC.' . $BasicChangeInfoEn,
        ],
        [
            'Customer::Change::ChangeLinkDelete',
            'de',
            '[Change #<OTRS_CHANGE_ChangeNumber>] RfC entfernt',
            'Change #<OTRS_CHANGE_ChangeNumber> mit entferntem RfC.' . $BasicChangeInfoDe,
        ],
        [
            'Customer::Change::ChangeLinkDelete',
            'en',
            '[Change #<OTRS_CHANGE_ChangeNumber>] RfC unlinked',
            'Change #<OTRS_CHANGE_ChangeNumber> with unlinked RfC.' . $BasicChangeInfoEn,
        ],
        [
            'Customer::Change::ChangeDelete',
            'de',
            '[Change #<OTRS_CHANGE_ChangeNumber>] gelöscht',
            'Der Change #<OTRS_CHANGE_ChangeNumber> wurde gelöscht.',
        ],
        [
            'Customer::Change::ChangeDelete',
            'en',
            '[Change #<OTRS_CHANGE_ChangeNumber>] deleted',
            'Change #<OTRS_CHANGE_ChangeNumber> was deleted.',
        ],
        [
            'Customer::WorkOrder::WorkOrderAdd',
            'de',
            '[Workorder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] neu erstellt',
            'Die Workorder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> wurde neu erstellt.'
                . $BasicWorkOrderInfoDe,
        ],
        [
            'Customer::WorkOrder::WorkOrderAdd',
            'en',
            '[Workorder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] added',
            'The Workorder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> was added.'
                . $BasicWorkOrderInfoEn,
        ],
        [
            'Customer::WorkOrder::WorkOrderUpdate',
            'de',
            '[Workorder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] aktualisiert',
            'Die Workorder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> wurde aktualisiert.'
                . $BasicWorkOrderInfoDe,
        ],
        [
            'Customer::WorkOrder::WorkOrderUpdate',
            'en',
            '[Workorder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] updated',
            'The Workorder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> was updated.'
                . $BasicWorkOrderInfoEn,
        ],
        [
            'Customer::WorkOrder::WorkOrderDelete',
            'de',
            '[Workorder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] gelöscht',
            'Die Workorder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> wurde gelöscht.',
        ],
        [
            'Customer::WorkOrder::WorkOrderDelete',
            'en',
            '[Workorder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] deleted',
            'The Workorder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> was deleted.',
        ],
        [
            'Customer::WorkOrder::WorkOrderLinkAdd',
            'de',
            '[Workorder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] Ticket verknüpft',
            'Die Workorder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> wurde mit einem Ticket verknüpft.'
                . $BasicWorkOrderInfoDe,
        ],
        [
            'Customer::WorkOrder::WorkOrderLinkAdd',
            'en',
            '[Workorder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] Ticket linked',
            'The Workorder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> was linked to a ticket.'
                . $BasicWorkOrderInfoDe,
        ],
        [
            'Customer::WorkOrder::WorkOrderLinkDelete',
            'de',
            '[Workorder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] Ticket entfernt',
            'Die Workorder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> ist mit einem Ticket nicht mehr verknüpft.'
                . $BasicWorkOrderInfoDe,
        ],
        [
            'Customer::WorkOrder::WorkOrderLinkDelete',
            'en',
            '[Workorder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] Ticket removed',
            'The Workorder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> in no linker linked to a ticket.'
                . $BasicWorkOrderInfoDe,
        ],
        [
            'Customer::Change::ChangeAttachmentAdd',
            'de',
            '[Change #<OTRS_CHANGE_ChangeNumber>] neuer Anhang',
            'Change #<OTRS_CHANGE_ChangeNumber> hat einen neuen Anhang.' . $BasicChangeInfoDe,
        ],
        [
            'Customer::Change::ChangeAttachmentAdd',
            'en',
            '[Change #<OTRS_CHANGE_ChangeNumber>] new attachment.',
            'Change #<OTRS_CHANGE_ChangeNumber> with new attachment.' . $BasicChangeInfoEn,
        ],
        [
            'Customer::Change::ChangeAttachmentDelete',
            'de',
            '[Change #<OTRS_CHANGE_ChangeNumber>] Anhang gelöscht',
            'Change #<OTRS_CHANGE_ChangeNumber> mit gelöschtem Anhang.' . $BasicChangeInfoDe,
        ],
        [
            'Customer::Change::ChangeAttachmentDelete',
            'en',
            '[Change #<OTRS_CHANGE_ChangeNumber>] attachment deleted.',
            'Change #<OTRS_CHANGE_ChangeNumber> with deleted attachment.' . $BasicChangeInfoEn,
        ],
        [
            'Customer::WorkOrder::WorkOrderAttachmentAdd',
            'de',
            '[WorkOrder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] neuer Anhang',
            'WorkOrder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> hat einen neuen Anhang.'
                . $BasicWorkOrderInfoDe,
        ],
        [
            'Customer::WorkOrder::WorkOrderAttachmentAdd',
            'en',
            '[WorkOrder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] new attachment.',
            'WorkOrder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> with new attachment.'
                . $BasicWorkOrderInfoEn,
        ],
        [
            'Customer::WorkOrder::WorkOrderAttachmentDelete',
            'de',
            '[WorkOrder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] Anhang gelöscht',
            'WorkOrder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> mit gelöschtem Anhang.'
                . $BasicWorkOrderInfoDe,
        ],
        [
            'Customer::WorkOrder::WorkOrderAttachmentDelete',
            'en',
            '[WorkOrder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] attachment deleted.',
            'WorkOrder #<OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> with deleted attachment.'
                . $BasicWorkOrderInfoEn,
        ],
    );

    # insert the entries
    for my $Notification ( @AgentNotifications, @CustomerNotifications ) {
        my @Binds;

        # Bind requires scalar references
        for my $Value ( @{$Notification} ) {
            push @Binds, \$Value;
        }

        # do the insertion
        $Self->{DBObject}->Do(
            SQL => 'INSERT INTO notifications (notification_type, notification_language, '
                . 'subject, text, notification_charset, content_type, '
                . 'create_time, create_by, change_time, change_by) '
                . 'VALUES( ?, ?, ?, ?, \'iso-8859-1\', \'text/plain\', '
                . 'current_timestamp, 1, current_timestamp, 1 )',
            Bind => [@Binds],
        );
    }

    return 1;
}

=item _DeleteSystemNotifications()

Deletes the Change:: and WorkOrder:: notifications from systems notification table.

    my $Success = $PackageSetup->_DeleteSystemNotifications();

=cut

sub _DeleteSystemNotifications {
    my ($Self) = @_;

    # define the notification types to be deleted
    my @NotificationTypes = (
        'Change::ChangeAdd',
        'Change::ChangeUpdate',
        'Change::ChangeCABUpdate',
        'Change::ChangeCABDelete',
        'Change::ChangeLinkAdd',
        'Change::ChangeLinkDelete',
        'Change::ChangeAttachmentAdd',
        'Change::ChangeAttachmentDelete',
        'Change::ChangeDelete',
        'WorkOrder::WorkOrderAdd',
        'WorkOrder::WorkOrderUpdate',
        'WorkOrder::WorkOrderLinkAdd',
        'WorkOrder::WorkOrderLinkDelete',
        'WorkOrder::WorkOrderAttachmentAdd',
        'WorkOrder::WorkOrderAttachmentDelete',
        'WorkOrder::WorkOrderDelete',
    );

    # delete the entries
    for my $Type (@NotificationTypes) {

        # the default notification are defined for English and German
        # there are notification for agents and customers
        $Self->{DBObject}->Do(
            SQL => 'DELETE FROM notifications '
                . 'WHERE notification_language IN ("en", "de" ) '
                . 'AND ( notification_type = ? OR notification_type = ? )',
            Bind => [ \"Agent::${Type}", \"Customer::${Type}", ],
        );
    }

    return 1;
}

1;

=end Internal:

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see http://www.gnu.org/licenses/agpl.txt.

=cut

=head1 VERSION

$Revision: 1.31 $ $Date: 2010-01-25 10:09:09 $

=cut
