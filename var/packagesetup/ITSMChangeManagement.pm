# --
# ITSMChangeManagement.pm - code to excecute during package installation
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package var::packagesetup::ITSMChangeManagement;    ## no critic

use strict;
use warnings;

use Kernel::Config;
use Kernel::System::SysConfig;
use Kernel::System::CSV;
use Kernel::System::Cache;
use Kernel::System::CacheInternal;
use Kernel::System::GeneralCatalog;
use Kernel::System::Group;
use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::History;
use Kernel::System::ITSMChange::ITSMChangeCIPAllocate;
use Kernel::System::ITSMChange::ITSMStateMachine;
use Kernel::System::ITSMChange::ITSMWorkOrder;
use Kernel::System::ITSMChange::Notification;
use Kernel::System::ITSMChange::Template;
use Kernel::System::LinkObject;
use Kernel::System::State;
use Kernel::System::Stats;
use Kernel::System::Type;
use Kernel::System::User;
use Kernel::System::Valid;

=head1 NAME

ITSMChangeManagement.pm - code to excecute during package installation

=head1 SYNOPSIS

Functions for installing the ITSMChangeManagement package.

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
    $Self->{SysConfigObject} = Kernel::System::SysConfig->new( %{$Self} );

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

    # create additional objects
    $Self->{ConfigObject} = Kernel::Config->new();
    $Self->{CSVObject}    = Kernel::System::CSV->new( %{$Self} );
    $Self->{GroupObject}  = Kernel::System::Group->new( %{$Self} );
    $Self->{UserObject}   = Kernel::System::User->new( %{$Self} );
    $Self->{StateObject}  = Kernel::System::State->new( %{$Self} );
    $Self->{TypeObject}   = Kernel::System::Type->new( %{$Self} );
    $Self->{ValidObject}  = Kernel::System::Valid->new( %{$Self} );
    $Self->{LinkObject}   = Kernel::System::LinkObject->new( %{$Self} );
    $Self->{ChangeObject} = Kernel::System::ITSMChange->new( %{$Self} );
    $Self->{CIPAllocateObject}
        = Kernel::System::ITSMChange::ITSMChangeCIPAllocate->new( %{$Self} );
    $Self->{StateMachineObject}   = Kernel::System::ITSMChange::ITSMStateMachine->new( %{$Self} );
    $Self->{GeneralCatalogObject} = Kernel::System::GeneralCatalog->new( %{$Self} );
    $Self->{WorkOrderObject}      = Kernel::System::ITSMChange::ITSMWorkOrder->new( %{$Self} );
    $Self->{HistoryObject}        = Kernel::System::ITSMChange::History->new( %{$Self} );
    $Self->{NotificationObject}   = Kernel::System::ITSMChange::Notification->new( %{$Self} );
    $Self->{TemplateObject}       = Kernel::System::ITSMChange::Template->new( %{$Self} );
    $Self->{StatsObject}          = Kernel::System::Stats->new(
        %{$Self},
        UserID => 1,
    );
    $Self->{CacheObject}         = Kernel::System::Cache->new( %{$Self} );
    $Self->{CacheInternalObject} = Kernel::System::CacheInternal->new(
        %{$Self},
        Type => 'Group',
        TTL  => 60 * 60 * 3,
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

    # delete the group cache to avoid permission problems
    $Self->{CacheInternalObject}->CleanUp( OtherType => 'Group' );

    # cleanup cache
    $Self->{CacheObject}->CleanUp(
        Type => 'ITSMChangeManagement',
    );

    # cleanup cache internal
    $Self->{CacheInternalObject}->CleanUp( OtherType => 'ITSMChangeManagement' );
    $Self->{CacheInternalObject}->CleanUp( OtherType => 'ITSMStateMachine' );

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

    # delete the group cache to avoid permission problems
    $Self->{CacheInternalObject}->CleanUp( OtherType => 'Group' );

    # cleanup cache
    $Self->{CacheObject}->CleanUp(
        Type => 'ITSMChangeManagement',
    );

    # cleanup cache internal
    $Self->{CacheInternalObject}->CleanUp( OtherType => 'ITSMChangeManagement' );
    $Self->{CacheInternalObject}->CleanUp( OtherType => 'ITSMStateMachine' );

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

    # set default CIP matrix (this is only done if no matrix exists)
    $Self->_CIPDefaultMatrixSet();

    # delete the group cache to avoid problems with CI permissions
    $Self->{CacheInternalObject}->CleanUp( OtherType => 'Group' );

    # cleanup cache
    $Self->{CacheObject}->CleanUp(
        Type => 'ITSMChangeManagement',
    );

    # cleanup cache internal
    $Self->{CacheInternalObject}->CleanUp( OtherType => 'ITSMChangeManagement' );
    $Self->{CacheInternalObject}->CleanUp( OtherType => 'ITSMStateMachine' );

    return 1;
}

=item CodeUpgradeFromLowerThan_3_2_91()

This function is only executed if the installed module version is smaller than 3.2.91 (3.3.0 Beta 1).

my $Result = $CodeObject->CodeUpgradeFromLowerThan_3_2_91();

=cut

sub CodeUpgradeFromLowerThan_3_2_91 {    ## no critic
    my ( $Self, %Param ) = @_;

    # add new notifications that were added in version 3.2.91
    $Self->_AddSystemNotificationsNewIn_3_2_91();

    return 1;
}

=item CodeUpgradeFromLowerThan_2_0_3()

This function is only executed if the installed module version is smaller than 2.0.3.

my $Result = $CodeObject->CodeUpgradeFromLowerThan_2_0_3();

=cut

sub CodeUpgradeFromLowerThan_2_0_3 {    ## no critic
    my ( $Self, %Param ) = @_;

    # add new notifications that were added in version 2.0.3
    $Self->_AddNotificationsNewIn_2_0_3();

    # add new system notifications that were added in version 2.0.3
    $Self->_AddSystemNotificationsNewIn_2_0_3();

    return 1;
}

=item CodeUpgradeFromBeta1()

This function is only executed if the installed module version is smaller than 1.3.92 (beta2).

Also the template structure changed from (beta1) to 1.3.92 (beta2),
so the old templates must be deleted.

    my $Result = $CodeObject->CodeUpgradeFromBeta1();

=cut

sub CodeUpgradeFromBeta1 {
    my ( $Self, %Param ) = @_;

    # Delete all templates, as the template structure has changed prior to Beta 1.
    $Self->_DeleteTemplates();

    return 1;
}

=item CodeUpgradeFromBeta2()

This function is only executed if the installed module version is smaller than 1.3.93 (beta3).

There have been many changes in the sytem notification texts
from 1.3.91 (beta1) to 1.3.92 (beta2) so we need to delete
the old notifications and add the new ones.

Furthermore, in the installation and upgrade process for 1.3.92 (Beta 2) there has been an error in
the creation of the notification messages. The English message for 'WorkOrderActualEndTimeReached'
ended up in the slot of the English message for 'WorkOrderPlannedStartTimeReached'.
This is rectified by reinserting the notifications for upgrades from Beta 2 or earlier.

=cut

sub CodeUpgradeFromBeta2 {
    my ( $Self, %Param ) = @_;

    # delete system notifications
    $Self->_DeleteSystemNotifications();

    # add system notifications
    $Self->_AddSystemNotifications();

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

    # delete all existing attachments for changes and workorders
    $Self->_AttachmentDelete();

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

    # delete the group cache to avoid permission problems
    $Self->{CacheInternalObject}->CleanUp( OtherType => 'Group' );

    # cleanup cache
    $Self->{CacheObject}->CleanUp(
        Type => 'ITSMChangeManagement',
    );

    # cleanup cache internal
    $Self->{CacheInternalObject}->CleanUp( OtherType => 'ITSMChangeManagement' );
    $Self->{CacheInternalObject}->CleanUp( OtherType => 'ITSMStateMachine' );

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

    # get list of all groups
    my %GroupList = $Self->{GroupObject}->GroupList();

    # reverse the group list for easier lookup
    my %GroupListReverse = reverse %GroupList;

    # check if group already exists
    my $GroupID = $GroupListReverse{ $Param{Name} };

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
    for my $Impact ( sort keys %Allocation ) {

        next IMPACT if !$ImpactListReverse{$Impact};

        # extract impact id
        my $ImpactID = $ImpactListReverse{$Impact};

        CATEGORY:
        for my $Category ( sort keys %{ $Allocation{$Impact} } ) {

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
        'requested' => [ 'rejected', 'retracted', 'pending approval', 'in progress' ],
        'pending approval' => [ 'rejected', 'retracted', 'approved' ],
        'approved'    => [ 'retracted',   'in progress' ],
        'in progress' => [ 'pending pir', 'retracted', 'failed', 'successful', 'canceled' ],
        'pending pir' => [ 'failed',      'successful' ],
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

=item _AttachmentDelete()

delete all existing attachments for changes and workorders

    my $Result = $CodeObject->_AttachmentDelete();

=cut

sub _AttachmentDelete {
    my ( $Self, %Param ) = @_;

    # get all change object ids
    my $ChangeIDs = $Self->{ChangeObject}->ChangeList(
        UserID => 1,
    );

    for my $ChangeID ( @{$ChangeIDs} ) {

        # get the list of all change attachments
        my @ChangeAttachments = $Self->{ChangeObject}->ChangeAttachmentList(
            ChangeID => $ChangeID,
        );

        # delete all change attachments
        for my $Filename (@ChangeAttachments) {

            $Self->{ChangeObject}->ChangeAttachmentDelete(
                ChangeID => $ChangeID,
                Filename => $Filename,
                UserID   => 1,
            );
        }

        # get all workorder ids for this change
        my $WorkOrderIDs = $Self->{WorkOrderObject}->WorkOrderList(
            ChangeID => $ChangeID,
            UserID   => 1,
        );

        for my $WorkOrderID ( @{$WorkOrderIDs} ) {

            # get the list of all workorder attachments
            my @WorkOrderAttachments = $Self->{WorkOrderObject}->WorkOrderAttachmentList(
                WorkOrderID => $WorkOrderID,
            );

            # delete all workorder attachments
            for my $Filename (@WorkOrderAttachments) {

                $Self->{WorkOrderObject}->WorkOrderAttachmentDelete(
                    ChangeID       => $ChangeID,
                    WorkOrderID    => $WorkOrderID,
                    Filename       => $Filename,
                    AttachmentType => 'WorkOrder',
                    UserID         => 1,
                );
            }

            # get the list of all workorder report attachments
            my @ReportAttachments = $Self->{WorkOrderObject}->WorkOrderReportAttachmentList(
                WorkOrderID => $WorkOrderID,
            );

            # delete all workorder report attachments
            for my $Filename (@ReportAttachments) {

                $Self->{WorkOrderObject}->WorkOrderAttachmentDelete(
                    ChangeID       => $ChangeID,
                    WorkOrderID    => $WorkOrderID,
                    Filename       => $Filename,
                    AttachmentType => 'WorkOrderReport',
                    UserID         => 1,
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
            Recipients => [ 'ChangeManager', 'ChangeBuilder' ],
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
            Rule       => 'pending pir',
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
                'ChangeBuilder', 'ChangeInitiators', 'CABCustomers', 'CABAgents',
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
        {
            Name       => 'planned start time of change reached',
            Attribute  => '',
            Event      => 'ChangePlannedStartTimeReached',
            ValidID    => 1,
            Comment    => 'inform recipients that a change has reached the planned start time',
            Rule       => '',
            Recipients => [
                'ChangeBuilder', 'ChangeManager',
            ],
        },
        {
            Name       => 'planned end time of change reached',
            Attribute  => '',
            Event      => 'ChangePlannedEndTimeReached',
            ValidID    => 1,
            Comment    => 'inform recipients that a change has reached the planned end time',
            Rule       => '',
            Recipients => [
                'ChangeBuilder', 'ChangeManager',
            ],
        },
        {
            Name       => 'actual start time of change reached',
            Attribute  => '',
            Event      => 'ChangeActualStartTimeReached',
            ValidID    => 1,
            Comment    => 'inform recipients that a change has reached the actual start time',
            Rule       => '',
            Recipients => [
                'ChangeBuilder', 'ChangeManager',
            ],
        },
        {
            Name       => 'actual end time of change reached',
            Attribute  => '',
            Event      => 'ChangeActualEndTimeReached',
            ValidID    => 1,
            Comment    => 'inform recipients that a change has reached the actual end time',
            Rule       => '',
            Recipients => [
                'ChangeBuilder', 'ChangeManager',
            ],
        },
        {
            Name       => 'requested time of change reached',
            Attribute  => '',
            Event      => 'ChangeRequestedTimeReached',
            ValidID    => 1,
            Comment    => 'inform recipients that a change has reached the requested time',
            Rule       => '',
            Recipients => [
                'ChangeBuilder', 'ChangeManager',
            ],
        },
        {
            Name       => 'planned start time of workorder reached',
            Attribute  => '',
            Event      => 'WorkOrderPlannedStartTimeReached',
            ValidID    => 1,
            Comment    => 'inform recipients that a workorder has reached the planned start time',
            Rule       => '',
            Recipients => [
                'WorkOrderAgent',
            ],
        },
        {
            Name       => 'planned end time of workorder reached',
            Attribute  => '',
            Event      => 'WorkOrderPlannedEndTimeReached',
            ValidID    => 1,
            Comment    => 'inform recipients that a workorder has reached the planned end time',
            Rule       => '',
            Recipients => [
                'WorkOrderAgent',
            ],
        },
        {
            Name       => 'actual start time of workorder reached',
            Attribute  => '',
            Event      => 'WorkOrderActualStartTimeReached',
            ValidID    => 1,
            Comment    => 'inform recipients that a workorder has reached the actual start time',
            Rule       => '',
            Recipients => [
                'WorkOrderAgent',
            ],
        },
        {
            Name       => 'actual end time of workorder reached',
            Attribute  => '',
            Event      => 'WorkOrderActualEndTimeReached',
            ValidID    => 1,
            Comment    => 'inform recipients that a workorder has reached the actual end time',
            Rule       => '',
            Recipients => [
                'WorkOrderAgent',
            ],
        },
        {
            Name       => 'action execution successfully',
            Attribute  => 'ActionResult',
            Event      => 'ActionExecute',
            ValidID    => 1,
            Comment    => 'inform recipients that an action was executed successfully',
            Rule       => 'successfully',
            Recipients => [
                'ChangeBuilder',
            ],
        },
        {
            Name       => 'action execution unsuccessfully',
            Attribute  => 'ActionResult',
            Event      => 'ActionExecute',
            ValidID    => 1,
            Comment    => 'inform recipients that an action was executed unsuccessfully',
            Rule       => 'unsuccessfully',
            Recipients => [
                'ChangeBuilder',
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

=item _AddNotificationsNewIn_2_0_3()

Add ChangeManagement specific notifications that were added in version 2.0.3.

    my $Success = $SetupObject->_AddNotificationsNewIn_2_0_3;

=cut

sub _AddNotificationsNewIn_2_0_3 {    ## no critic
    my ($Self) = @_;

    # define notifications and recipients
    my @Notifications = (
        {
            Name       => 'action execution successfully',
            Attribute  => 'ActionResult',
            Event      => 'ActionExecute',
            ValidID    => 1,
            Comment    => 'inform recipients that an action was executed successfully',
            Rule       => 'successfully',
            Recipients => [
                'ChangeBuilder',
            ],
        },
        {
            Name       => 'action execution unsuccessfully',
            Attribute  => 'ActionResult',
            Event      => 'ActionExecute',
            ValidID    => 1,
            Comment    => 'inform recipients that an action was executed unsuccessfully',
            Rule       => 'unsuccessfully',
            Recipients => [
                'ChangeBuilder',
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
There is no check whether a notification already exists.
so usually _DeleteSystemNotifications should be called before.

    my $Success = $PackageSetup->_AddSystemNotifications();

=cut

sub _AddSystemNotifications {
    my ($Self) = @_;

# Set up some standard texts for English, German, and Dutch, Change and WorkOrder, agent and customer
# The customer texts provide no link.

    # Change info for agents (en)
    my $ChangeInfoAgentEn = "\n"
        . "\n"
        . "Change title: <OTRS_CHANGE_ChangeTitle>\n"
        . "Change builder: <OTRS_CHANGE_ChangeBuilder>\n"
        . "Change manager: <OTRS_CHANGE_ChangeManager>\n"
        . "Current change state: <OTRS_CHANGE_ChangeState>\n"
        . "\n"
        . "<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentITSMChangeZoom;ChangeID=<OTRS_CHANGE_ChangeID>\n"
        . "\n"
        . "Your OTRS Notification Master\n";

    # Change info for Customers (en)
    my $ChangeInfoCustomerEn = "\n"
        . "\n"
        . "Change title: <OTRS_CHANGE_ChangeTitle>\n"
        . "Current change state: <OTRS_CHANGE_ChangeState>\n"
        . "\n"
        . "Your OTRS Notification Master\n";

    # Change info for agents (de)
    my $ChangeInfoAgentDe = "\n"
        . "\n"
        . "Change Titel: <OTRS_CHANGE_ChangeTitle>\n"
        . "Change-Builder: <OTRS_CHANGE_ChangeBuilder>\n"
        . "Change-Manager: <OTRS_CHANGE_ChangeManager>\n"
        . "Aktueller Change Status: <OTRS_CHANGE_ChangeState>\n"
        . "\n"
        . "<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentITSMChangeZoom;ChangeID=<OTRS_CHANGE_ChangeID>\n"
        . "\n"
        . "Ihr OTRS Notification Master\n";

    # Change info for Customers (de)
    my $ChangeInfoCustomerDe = "\n"
        . "\n"
        . "Change Titel: <OTRS_CHANGE_ChangeTitle>\n"
        . "Aktueller Change Status: <OTRS_CHANGE_ChangeState>\n"
        . "\n"
        . "Ihr OTRS Notification Master\n";

    # Change info for agents (nl)
    my $ChangeInfoAgentNl = "\n"
        . "\n"
        . "Change-titel: <OTRS_CHANGE_ChangeTitle>\n"
        . "Change-Builder: <OTRS_CHANGE_ChangeBuilder>\n"
        . "Change-Manager: <OTRS_CHANGE_ChangeManager>\n"
        . "Actuele change-status: <OTRS_CHANGE_ChangeState>\n"
        . "\n"
        . "<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentITSMChangeZoom;ChangeID=<OTRS_CHANGE_ChangeID>\n"
        . "\n";

    # Change info for Customers (nl)
    my $ChangeInfoCustomerNl = "\n"
        . "\n"
        . "Change-titel: <OTRS_CHANGE_ChangeTitle>\n"
        . "Actuele change-status: <OTRS_CHANGE_ChangeState>\n"
        . "\n";

    # Workorder info for customers (en)
    my $WorkOrderInfoCustomerEn = "\n"
        . "\n"
        . "Change title: <OTRS_CHANGE_ChangeTitle>\n"
        . "Current change state: <OTRS_CHANGE_ChangeState>\n"
        . "\n"
        . "Workorder title: <OTRS_WORKORDER_WorkOrderTitle>\n"
        . "Workorder type: <OTRS_WORKORDER_WorkOrderType>\n"
        . "Workorder agent: <OTRS_WORKORDER_WorkOrderAgent>\n"
        . "Current workorder state: <OTRS_WORKORDER_WorkOrderState>\n"
        . "\n"
        . "Your OTRS Notification Master\n";

    # Workorder info for agents (en)
    my $WorkOrderInfoAgentEn = "\n"
        . "\n"
        . "Change title: <OTRS_CHANGE_ChangeTitle>\n"
        . "Current change state: <OTRS_CHANGE_ChangeState>\n"
        . "\n"
        . "Workorder title: <OTRS_WORKORDER_WorkOrderTitle>\n"
        . "Workorder type: <OTRS_WORKORDER_WorkOrderType>\n"
        . "Current workorder state: <OTRS_WORKORDER_WorkOrderState>\n"
        . "\n"
        . "<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentITSMWorkOrderZoom;WorkOrderID=<OTRS_WORKORDER_WorkOrderID>\n"
        . "\n"
        . "Your OTRS Notification Master\n";

    # Workorder info for agents (de)
    my $WorkOrderInfoAgentDe = "\n"
        . "\n"
        . "Change Titel: <OTRS_CHANGE_ChangeTitle>\n"
        . "Aktueller Change Status: <OTRS_CHANGE_ChangeState>\n"
        . "\n"
        . "Workorder Titel: <OTRS_WORKORDER_WorkOrderTitle>\n"
        . "Workorder Typ: <OTRS_WORKORDER_WorkOrderType>\n"
        . "Workorder Agent: <OTRS_WORKORDER_WorkOrderAgent>\n"
        . "Aktueller Workorder Status: <OTRS_WORKORDER_WorkOrderState>\n"
        . "\n"
        . "<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentITSMWorkOrderZoom;WorkOrderID=<OTRS_WORKORDER_WorkOrderID>\n"
        . "\n"
        . "Ihr OTRS Notification Master\n";

    # Workorder info for customers (de)
    my $WorkOrderInfoCustomerDe = "\n"
        . "\n"
        . "Change Titel: <OTRS_CHANGE_ChangeTitle>\n"
        . "Aktueller Change Status: <OTRS_CHANGE_ChangeState>\n"
        . "\n"
        . "Workorder Titel: <OTRS_WORKORDER_WorkOrderTitle>\n"
        . "Workorder Typ: <OTRS_WORKORDER_WorkOrderType>\n"
        . "Aktueller Workorder Status: <OTRS_WORKORDER_WorkOrderState>\n"
        . "\n"
        . "Ihr OTRS Notification Master\n";

    # Workorder info for agents (nl)
    my $WorkOrderInfoAgentNl = "\n"
        . "\n"
        . "Change-titel: <OTRS_CHANGE_ChangeTitle>\n"
        . "Actuele change-status: <OTRS_CHANGE_ChangeState>\n"
        . "\n"
        . "Work Order-titel: <OTRS_WORKORDER_WorkOrderTitle>\n"
        . "Work Order-type: <OTRS_WORKORDER_WorkOrderType>\n"
        . "Work Order-agent: <OTRS_WORKORDER_WorkOrderAgent>\n"
        . "Actuele Work Order-status: <OTRS_WORKORDER_WorkOrderState>\n"
        . "\n"
        . "<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentITSMWorkOrderZoom;WorkOrderID=<OTRS_WORKORDER_WorkOrderID>\n"
        . "\n";

    # Workorder info for customers (nl)
    my $WorkOrderInfoCustomerNl = "\n"
        . "\n"
        . "Change-titel: <OTRS_CHANGE_ChangeTitle>\n"
        . "Actuele change-status: <OTRS_CHANGE_ChangeState>\n"
        . "\n"
        . "Work Order-titel: <OTRS_WORKORDER_WorkOrderTitle>\n"
        . "Work Order-type: <OTRS_WORKORDER_WorkOrderType>\n"
        . "Actuele Work Order-status: <OTRS_WORKORDER_WorkOrderState>\n"
        . "\n";

    # define agent notifications
    my @AgentNotifications = (

        [
            'Agent::Change::ChangeAdd',
            'de',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] neu erstellt',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> wurde neu erstellt.'
                . $ChangeInfoAgentDe,
        ],
        [
            'Agent::Change::ChangeAdd',
            'en',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] created',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> was created.'
                . $ChangeInfoAgentEn,
        ],
        [
            'Agent::Change::ChangeAdd',
            'nl',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] aangemaakt',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> is aangemaakt.'
                . $ChangeInfoAgentDe,
        ],

        [
            'Agent::Change::ChangeUpdate',
            'de',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] aktualisiert',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> wurde aktualisiert.'
                . $ChangeInfoAgentDe,
        ],
        [
            'Agent::Change::ChangeUpdate',
            'en',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] updated',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> was updated.'
                . $ChangeInfoAgentEn,
        ],
        [
            'Agent::Change::ChangeUpdate',
            'nl',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] bijgewerkt',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> is bijgewerkt.'
                . $ChangeInfoAgentNl,
        ],

        [
            'Agent::Change::ChangeCABUpdate',
            'de',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] CAB aktualisiert',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> mit aktualisiertem CAB.'
                . $ChangeInfoAgentDe,
        ],
        [
            'Agent::Change::ChangeCABUpdate',
            'en',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] CAB updated',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> with updated CAB.'
                . $ChangeInfoAgentEn,
        ],
        [
            'Agent::Change::ChangeCABUpdate',
            'nl',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] CAB bijgewerkt',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> heeft een bijgewerkt CAB.'
                . $ChangeInfoAgentNl,
        ],

        [
            'Agent::Change::ChangeCABDelete',
            'de',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] CAB gelöscht',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> mit gelöschtem CAB.'
                . $ChangeInfoAgentDe,
        ],
        [
            'Agent::Change::ChangeCABDelete',
            'en',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] CAB deleted',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> with deleted CAB.'
                . $ChangeInfoAgentEn,
        ],
        [
            'Agent::Change::ChangeCABDelete',
            'nl',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] CAB verwijderd',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> CAB is verwijderd.'
                . $ChangeInfoAgentNl,
        ],

        [
            'Agent::Change::ChangeLinkAdd',
            'de',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] <OTRS_LINK_Object> verknüpft',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> wurde mit einem <OTRS_LINK_Object> verknüpft.'
                . $ChangeInfoAgentDe,
        ],
        [
            'Agent::Change::ChangeLinkAdd',
            'en',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] <OTRS_LINK_Object> linked',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> was linked to a <OTRS_LINK_Object> .'
                . $ChangeInfoAgentEn,
        ],
        [
            'Agent::Change::ChangeLinkAdd',
            'nl',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] <OTRS_LINK_Object> linked',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> is gekoppeld aan een <OTRS_LINK_Object> .'
                . $ChangeInfoAgentNl,
        ],

        [
            'Agent::Change::ChangeLinkDelete',
            'de',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] <OTRS_LINK_Object> entfernt',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> ist mit einem <OTRS_LINK_Object> nicht mehr verknüpft.'
                . $ChangeInfoAgentDe,
        ],
        [
            'Agent::Change::ChangeLinkDelete',
            'en',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] <OTRS_LINK_Object> removed',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> is no longer linked to a <OTRS_LINK_Object> .'
                . $ChangeInfoAgentEn,
        ],
        [
            'Agent::Change::ChangeLinkDelete',
            'nl',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] <OTRS_LINK_Object> verwijderd',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> is niet langer gekoppeld aan een <OTRS_LINK_Object> .'
                . $ChangeInfoAgentNl,
        ],

        [
            'Agent::Change::ChangeDelete',
            'de',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] gelöscht',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> wurde gelöscht.',
        ],
        [
            'Agent::Change::ChangeDelete',
            'en',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] deleted',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> was deleted.',
        ],
        [
            'Agent::Change::ChangeDelete',
            'nl',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] verwijderd',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> is verwijderd.',
        ],

        [
            'Agent::WorkOrder::WorkOrderAdd',
            'de',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] neu erstellt',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> wurde neu erstellt.'
                . $WorkOrderInfoAgentDe,
        ],
        [
            'Agent::WorkOrder::WorkOrderAdd',
            'en',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] created',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> was created.'
                . $WorkOrderInfoAgentEn,
        ],
        [
            'Agent::WorkOrder::WorkOrderAdd',
            'nl',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] aangemaakt',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> is aangemaakt.'
                . $WorkOrderInfoAgentNl,
        ],

        [
            'Agent::WorkOrder::WorkOrderUpdate',
            'de',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] aktualisiert',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> wurde aktualisiert.'
                . $WorkOrderInfoAgentDe,
        ],
        [
            'Agent::WorkOrder::WorkOrderUpdate',
            'en',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] updated',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> was updated.'
                . $WorkOrderInfoAgentEn,
        ],
        [
            'Agent::WorkOrder::WorkOrderUpdate',
            'nl',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] bijgewerkt',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> is bijgewerkt.'
                . $WorkOrderInfoAgentNl,
        ],

        [
            'Agent::WorkOrder::WorkOrderDelete',
            'de',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] gelöscht',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> wurde gelöscht.',
        ],
        [
            'Agent::WorkOrder::WorkOrderDelete',
            'en',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] deleted',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> was deleted.',
        ],
        [
            'Agent::WorkOrder::WorkOrderDelete',
            'nl',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] verwijderd',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> is verwijderd.',
        ],

        [
            'Agent::WorkOrder::WorkOrderLinkAdd',
            'de',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] <OTRS_LINK_Object> verknüpft',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> wurde mit einem <OTRS_LINK_Object> verknüpft.'
                . $WorkOrderInfoAgentDe,
        ],
        [
            'Agent::WorkOrder::WorkOrderLinkAdd',
            'en',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] <OTRS_LINK_Object> linked',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> was linked to a <OTRS_LINK_Object>.'
                . $WorkOrderInfoAgentEn,
        ],
        [
            'Agent::WorkOrder::WorkOrderLinkAdd',
            'nl',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] <OTRS_LINK_Object> gekoppeld',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> is gekoppeld aan een <OTRS_LINK_Object>.'
                . $WorkOrderInfoAgentNl,
        ],

        [
            'Agent::WorkOrder::WorkOrderLinkDelete',
            'de',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] <OTRS_LINK_Object> entfernt',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> ist mit einem <OTRS_LINK_Object> nicht mehr verknüpft.'
                . $WorkOrderInfoAgentDe,
        ],
        [
            'Agent::WorkOrder::WorkOrderLinkDelete',
            'en',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] <OTRS_LINK_Object> removed',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> is no longer linked to a <OTRS_LINK_Object>.'
                . $WorkOrderInfoAgentEn,
        ],
        [
            'Agent::WorkOrder::WorkOrderLinkDelete',
            'nl',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] <OTRS_LINK_Object> verwijderd',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> is niet langer gekoppeld aan een <OTRS_LINK_Object>.'
                . $WorkOrderInfoAgentNl,
        ],

        [
            'Agent::Change::ChangeAttachmentAdd',
            'de',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] neuer Anhang',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> hat einen neuen Anhang.'
                . $ChangeInfoAgentDe,
        ],
        [
            'Agent::Change::ChangeAttachmentAdd',
            'en',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] new attachment',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> has a new attachment.'
                . $ChangeInfoAgentEn,
        ],
        [
            'Agent::Change::ChangeAttachmentAdd',
            'nl',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] nieuwe bijlage',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> heeft een nieuwe bijlage.'
                . $ChangeInfoAgentNl,
        ],

        [
            'Agent::Change::ChangeAttachmentDelete',
            'de',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] Anhang gelöscht',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> mit gelöschtem Anhang.'
                . $ChangeInfoAgentDe,
        ],
        [
            'Agent::Change::ChangeAttachmentDelete',
            'en',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] attachment deleted',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> with deleted attachment.'
                . $ChangeInfoAgentEn,
        ],
        [
            'Agent::Change::ChangeAttachmentDelete',
            'nl',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] bijlage verwijderd',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> bijlage is verwijderd.'
                . $ChangeInfoAgentNl,
        ],

        [
            'Agent::WorkOrder::WorkOrderAttachmentAdd',
            'de',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] neuer Anhang',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> hat einen neuen Anhang.'
                . $WorkOrderInfoAgentDe,
        ],
        [
            'Agent::WorkOrder::WorkOrderAttachmentAdd',
            'en',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] new attachment',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> has a new attachment.'
                . $WorkOrderInfoAgentEn,
        ],
        [
            'Agent::WorkOrder::WorkOrderAttachmentAdd',
            'nl',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] nieuwe bijlage',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> heeft een nieuwe bijlage.'
                . $WorkOrderInfoAgentNl,
        ],

        [
            'Agent::WorkOrder::WorkOrderAttachmentDelete',
            'de',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] Anhang gelöscht',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> mit gelöschtem Anhang.'
                . $WorkOrderInfoAgentDe,
        ],
        [
            'Agent::WorkOrder::WorkOrderAttachmentDelete',
            'en',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] attachment deleted',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> with deleted attachment.'
                . $WorkOrderInfoAgentEn,
        ],
        [
            'Agent::WorkOrder::WorkOrderAttachmentDelete',
            'nl',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] bijlage verwijderd',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> bijlage is verwijderd.'
                . $WorkOrderInfoAgentNl,
        ],

        [
            'Agent::WorkOrder::WorkOrderReportAttachmentAdd',
            'de',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] neuer Report-Anhang',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> hat einen neuen Report-Anhang.'
                . $WorkOrderInfoAgentDe,
        ],
        [
            'Agent::WorkOrder::WorkOrderReportAttachmentAdd',
            'en',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] new report attachment',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> has a new report attachment.'
                . $WorkOrderInfoAgentEn,
        ],
        [
            'Agent::WorkOrder::WorkOrderReportAttachmentAdd',
            'nl',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] nieuwe bericht bijlage',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> heeft een nieuwe bericht bijlage.'
                . $WorkOrderInfoAgentNl,
        ],

        [
            'Agent::WorkOrder::WorkOrderReportAttachmentDelete',
            'de',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] Report-Anhang gelöscht',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> mit gelöschtem Report-Anhang.'
                . $WorkOrderInfoAgentDe,
        ],
        [
            'Agent::WorkOrder::WorkOrderReportAttachmentDelete',
            'en',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] report attachment deleted',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> with deleted report attachment.'
                . $WorkOrderInfoAgentEn,
        ],
        [
            'Agent::WorkOrder::WorkOrderReportAttachmentDelete',
            'nl',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] bericht bijlage verwijderd',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> bericht bijlage is verwijderd.'
                . $WorkOrderInfoAgentNl,
        ],

        [
            'Agent::Change::ChangePlannedStartTimeReached',
            'de',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] geplante Startzeit erreicht',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> hat die geplante Startzeit erreicht.'
                . $ChangeInfoAgentDe,
        ],
        [
            'Agent::Change::ChangePlannedStartTimeReached',
            'en',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] Planned Start Time reached',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> has reached its Planned Start Time.'
                . $ChangeInfoAgentEn,
        ],
        [
            'Agent::Change::ChangePlannedStartTimeReached',
            'nl',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] geplande starttijd bereikt',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> heeft de geplande starttijd bereikt.'
                . $ChangeInfoAgentNl,
        ],

        [
            'Agent::Change::ChangePlannedEndTimeReached',
            'de',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] geplante Endzeit erreicht',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> hat die geplante Endzeit erreicht.'
                . $ChangeInfoAgentDe,
        ],
        [
            'Agent::Change::ChangePlannedEndTimeReached',
            'en',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] Planned End Time reached',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> has reached its Planned End Time.'
                . $ChangeInfoAgentEn,
        ],
        [
            'Agent::Change::ChangePlannedEndTimeReached',
            'nl',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] geplande eindttijd bereikt',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> heeft de geplande eindtijd bereikt.'
                . $ChangeInfoAgentNl,
        ],

        [
            'Agent::Change::ChangeActualStartTimeReached',
            'de',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] begonnen',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> wurde begonnen.'
                . $ChangeInfoAgentDe,
        ],
        [
            'Agent::Change::ChangeActualStartTimeReached',
            'en',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] started',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> has started.'
                . $ChangeInfoAgentEn,
        ],
        [
            'Agent::Change::ChangeActualStartTimeReached',
            'nl',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] gestart',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> is gestart.'
                . $ChangeInfoAgentNl,
        ],

        [
            'Agent::Change::ChangeActualEndTimeReached',
            'de',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] abgeschlossen',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> wurde abgeschlossen.'
                . $ChangeInfoAgentDe,
        ],
        [
            'Agent::Change::ChangeActualEndTimeReached',
            'en',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] finished',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> was finished.'
                . $ChangeInfoAgentEn,
        ],
        [
            'Agent::Change::ChangeActualEndTimeReached',
            'nl',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] afgerond',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> is afgerond.'
                . $ChangeInfoAgentNl,
        ],

        [
            'Agent::Change::ChangeRequestedTimeReached',
            'de',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] Gewünschte Fertigstellungszeit erreicht',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> hat die gewünschte Fertigstellungszeit erreicht.'
                . $ChangeInfoAgentDe,
        ],
        [
            'Agent::Change::ChangeRequestedTimeReached',
            'en',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] requested time reached',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> has reached its requested time.'
                . $ChangeInfoAgentEn,
        ],
        [
            'Agent::Change::ChangeRequestedTimeReached',
            'nl',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] aangevraagd tijdstip bereikt',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> heeft het aangevraagde tijdstip bereikt.'
                . $ChangeInfoAgentNl,
        ],

        [
            'Agent::Change::ActionExecute',
            'de',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] Aktions-Ausführung <OTRS_CONDITION_ActionResult>',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> Aktions-Ausführung <OTRS_CONDITION_ActionResult>.'
                . "\n"
                . "\n"
                . "Change Titel: <OTRS_CHANGE_ChangeTitle>\n"
                . "Aktueller Change Status: <OTRS_CHANGE_ChangeState>\n"
                . "\n"
                . "Condition ID: <OTRS_CONDITION_ConditionID>\n"
                . "Condition Name: <OTRS_CONDITION_ConditionName>\n"
                . "\n"
                . "Action ID: <OTRS_CONDITION_ActionID>\n"
                . "Aktions-Ausführung: <OTRS_CONDITION_ActionResult>\n"
                . "\n"
                . "<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentITSMChangeZoom;ChangeID=<OTRS_CHANGE_ChangeID>\n"
                . "\n"
                . "Ihr OTRS Notification Master\n",
        ],
        [
            'Agent::Change::ActionExecute',
            'en',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] Action execution <OTRS_CONDITION_ActionResult>',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> Action execution <OTRS_CONDITION_ActionResult>.'
                . "\n"
                . "\n"
                . "Change title: <OTRS_CHANGE_ChangeTitle>\n"
                . "Current change state: <OTRS_CHANGE_ChangeState>\n"
                . "\n"
                . "Condition ID: <OTRS_CONDITION_ConditionID>\n"
                . "Condition name: <OTRS_CONDITION_ConditionName>\n"
                . "\n"
                . "Action ID: <OTRS_CONDITION_ActionID>\n"
                . "Action execution: <OTRS_CONDITION_ActionResult>\n"
                . "\n"
                . "<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentITSMChangeZoom;ChangeID=<OTRS_CHANGE_ChangeID>\n"
                . "\n"
                . "Your OTRS Notification Master\n",
        ],
        [
            'Agent::Change::ActionExecute',
            'nl',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] Actie uitgevoerd <OTRS_CONDITION_ActionResult>',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> Actie uitgevoerd <OTRS_CONDITION_ActionResult>.'
                . "\n"
                . "\n"
                . "Change-titel: <OTRS_CHANGE_ChangeTitle>\n"
                . "Actuele change-status: <OTRS_CHANGE_ChangeState>\n"
                . "\n"
                . "Conditie-ID: <OTRS_CONDITION_ConditionID>\n"
                . "Conditie naam: <OTRS_CONDITION_ConditionName>\n"
                . "\n"
                . "Actie-ID: <OTRS_CONDITION_ActionID>\n"
                . "Actie resultaat: <OTRS_CONDITION_ActionResult>\n"
                . "\n"
                . "<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentITSMChangeZoom;ChangeID=<OTRS_CHANGE_ChangeID>\n"
                . "\n",
        ],

        [
            'Agent::WorkOrder::WorkOrderPlannedStartTimeReached',
            'de',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] geplante Startzeit erreicht',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> hat die geplante Startzeit erreicht.'
                . $WorkOrderInfoAgentDe,
        ],
        [
            'Agent::WorkOrder::WorkOrderPlannedStartTimeReached',
            'en',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] Planned Start Time reached',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> has reached the Planned Start Time.'
                . $WorkOrderInfoAgentEn,
        ],
        [
            'Agent::WorkOrder::WorkOrderPlannedStartTimeReached',
            'nl',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] geplande starttijd bereikt',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> heeft de geplande starttijd bereikt.'
                . $WorkOrderInfoAgentNl,
        ],

        [
            'Agent::WorkOrder::WorkOrderPlannedEndTimeReached',
            'de',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] geplante Endzeit erreicht',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> hat die geplante Endzeit erreicht.'
                . $WorkOrderInfoAgentDe,
        ],
        [
            'Agent::WorkOrder::WorkOrderPlannedEndTimeReached',
            'en',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] Planned End Time reached.',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> has reached the Planned End Time.'
                . $WorkOrderInfoAgentEn,
        ],
        [
            'Agent::WorkOrder::WorkOrderPlannedEndTimeReached',
            'nl',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] geplande eindttijd bereikt.',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> heeft de geplande eindtijd bereikt.'
                . $WorkOrderInfoAgentNl,
        ],

        [
            'Agent::WorkOrder::WorkOrderActualStartTimeReached',
            'de',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] begonnen',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> wurde begonnen.'
                . $WorkOrderInfoAgentDe,
        ],
        [
            'Agent::WorkOrder::WorkOrderActualStartTimeReached',
            'en',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] started',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> has started.'
                . $WorkOrderInfoAgentEn,
        ],
        [
            'Agent::WorkOrder::WorkOrderActualStartTimeReached',
            'nl',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] gestart',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> is gestart.'
                . $WorkOrderInfoAgentNl,
        ],

        [
            'Agent::WorkOrder::WorkOrderActualEndTimeReached',
            'de',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] abgeschlossen',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> wurde abgeschlossen.'
                . $WorkOrderInfoAgentDe,
        ],
        [
            'Agent::WorkOrder::WorkOrderActualEndTimeReached',
            'en',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] finished',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> was finished.'
                . $WorkOrderInfoAgentEn,
        ],
        [
            'Agent::WorkOrder::WorkOrderActualEndTimeReached',
            'nl',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] afgerond',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> is afgerond.'
                . $WorkOrderInfoAgentNl,
        ],

    );

    # define customer notifications
    my @CustomerNotifications = (

        [
            'Customer::Change::ChangeAdd',
            'de',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] neu erstellt',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> wurde neu erstellt.'
                . $ChangeInfoCustomerDe,
        ],
        [
            'Customer::Change::ChangeAdd',
            'en',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] created',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> was created.'
                . $ChangeInfoCustomerEn,
        ],
        [
            'Customer::Change::ChangeAdd',
            'nl',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] aangemaakt',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> is aangemaakt.'
                . $ChangeInfoCustomerNl,
        ],

        [
            'Customer::Change::ChangeUpdate',
            'de',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] aktualisiert',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> wurde aktualisiert.'
                . $ChangeInfoCustomerDe,
        ],
        [
            'Customer::Change::ChangeUpdate',
            'en',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] updated',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> was updated.'
                . $ChangeInfoCustomerEn,
        ],
        [
            'Customer::Change::ChangeUpdate',
            'nl',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] bijgewerkt',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> is bijgewerkt.'
                . $ChangeInfoCustomerNl,
        ],

        [
            'Customer::Change::ChangeCABUpdate',
            'de',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] CAB aktualisiert',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> mit aktualisiertem CAB.'
                . $ChangeInfoCustomerDe,
        ],
        [
            'Customer::Change::ChangeCABUpdate',
            'en',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] CAB updated',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> with updated CAB.'
                . $ChangeInfoCustomerEn,
        ],
        [
            'Customer::Change::ChangeCABUpdate',
            'nl',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] CAB bijgewerkt',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> heeft een bijgewerkt CAB.'
                . $ChangeInfoCustomerNl,
        ],

        [
            'Customer::Change::ChangeCABDelete',
            'de',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] CAB gelöscht',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> mit gelöschtem CAB.'
                . $ChangeInfoCustomerDe,
        ],
        [
            'Customer::Change::ChangeCABDelete',
            'en',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] CAB deleted',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> with deleted CAB.'
                . $ChangeInfoCustomerEn,
        ],
        [
            'Customer::Change::ChangeCABDelete',
            'nl',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] CAB verwijderd',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> CAB verwijderd.'
                . $ChangeInfoCustomerNl,
        ],

        [
            'Customer::Change::ChangeLinkAdd',
            'de',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] <OTRS_LINK_Object> verknüpft',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> wurde mit einem <OTRS_LINK_Object> verknüpft.'
                . $ChangeInfoCustomerDe,
        ],
        [
            'Customer::Change::ChangeLinkAdd',
            'en',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] <OTRS_LINK_Object> linked',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> was linked to a <OTRS_LINK_Object> .'
                . $ChangeInfoCustomerEn,
        ],
        [
            'Customer::Change::ChangeLinkAdd',
            'nl',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] <OTRS_LINK_Object> gekoppeld',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> is gekoppeld aan een <OTRS_LINK_Object> .'
                . $ChangeInfoCustomerNl,
        ],

        [
            'Customer::Change::ChangeLinkDelete',
            'de',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] <OTRS_LINK_Object> entfernt',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> ist mit einem <OTRS_LINK_Object> nicht mehr verknüpft.'
                . $ChangeInfoCustomerDe,
        ],
        [
            'Customer::Change::ChangeLinkDelete',
            'en',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] <OTRS_LINK_Object> removed',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> is no longer linked to a <OTRS_LINK_Object> .'
                . $ChangeInfoCustomerEn,
        ],
        [
            'Customer::Change::ChangeLinkDelete',
            'nl',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] <OTRS_LINK_Object> verwijderd',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> is niet langer gekoppeld aan een <OTRS_LINK_Object> .'
                . $ChangeInfoCustomerNl,
        ],

        [
            'Customer::Change::ChangeDelete',
            'de',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] gelöscht',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> wurde gelöscht.',
        ],
        [
            'Customer::Change::ChangeDelete',
            'en',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] deleted',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> was deleted.',
        ],
        [
            'Customer::Change::ChangeDelete',
            'nl',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] verwijderd',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> is verwijderd.',
        ],

        [
            'Customer::WorkOrder::WorkOrderAdd',
            'de',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] neu erstellt',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> wurde neu erstellt.'
                . $WorkOrderInfoCustomerDe,
        ],
        [
            'Customer::WorkOrder::WorkOrderAdd',
            'en',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] created',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> was created.'
                . $WorkOrderInfoCustomerEn,
        ],
        [
            'Customer::WorkOrder::WorkOrderAdd',
            'nl',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] aangemaakt',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> is aangemaakt.'
                . $WorkOrderInfoCustomerNl,
        ],

        [
            'Customer::WorkOrder::WorkOrderUpdate',
            'de',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] aktualisiert',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> wurde aktualisiert.'
                . $WorkOrderInfoCustomerDe,
        ],
        [
            'Customer::WorkOrder::WorkOrderUpdate',
            'en',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] updated',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> was updated.'
                . $WorkOrderInfoCustomerEn,
        ],
        [
            'Customer::WorkOrder::WorkOrderUpdate',
            'nl',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] bijgewerkt',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> is bijgewerkt.'
                . $WorkOrderInfoCustomerNl,
        ],

        [
            'Customer::WorkOrder::WorkOrderDelete',
            'de',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] gelöscht',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> wurde gelöscht.',
        ],
        [
            'Customer::WorkOrder::WorkOrderDelete',
            'en',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] deleted',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> was deleted.',
        ],
        [
            'Customer::WorkOrder::WorkOrderDelete',
            'nl',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] verwijderd',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> is verwijderd.',
        ],

        [
            'Customer::WorkOrder::WorkOrderLinkAdd',
            'de',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] <OTRS_LINK_Object> verknüpft',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> wurde mit einem <OTRS_LINK_Object> verknüpft.'
                . $WorkOrderInfoCustomerDe,
        ],
        [
            'Customer::WorkOrder::WorkOrderLinkAdd',
            'en',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] <OTRS_LINK_Object> linked',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> was linked to a <OTRS_LINK_Object>.'
                . $WorkOrderInfoCustomerEn,
        ],
        [
            'Customer::WorkOrder::WorkOrderLinkAdd',
            'nl',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] <OTRS_LINK_Object> gekoppeld',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> is gekoppeld aan een <OTRS_LINK_Object>.'
                . $WorkOrderInfoCustomerNl,
        ],

        [
            'Customer::WorkOrder::WorkOrderLinkDelete',
            'de',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] <OTRS_LINK_Object> entfernt',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> ist mit einem <OTRS_LINK_Object> nicht mehr verknüpft.'
                . $WorkOrderInfoCustomerDe,
        ],
        [
            'Customer::WorkOrder::WorkOrderLinkDelete',
            'en',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] <OTRS_LINK_Object> removed',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> is no longer linked to a <OTRS_LINK_Object>.'
                . $WorkOrderInfoCustomerEn,
        ],
        [
            'Customer::WorkOrder::WorkOrderLinkDelete',
            'nl',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] <OTRS_LINK_Object> verwijderd',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> is niet langer gekoppeld aan een <OTRS_LINK_Object>.'
                . $WorkOrderInfoCustomerNl,
        ],

        [
            'Customer::Change::ChangeAttachmentAdd',
            'de',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] neuer Anhang',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> hat einen neuen Anhang.'
                . $ChangeInfoCustomerDe,
        ],
        [
            'Customer::Change::ChangeAttachmentAdd',
            'en',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] new attachment',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> has a new attachment.'
                . $ChangeInfoCustomerEn,
        ],
        [
            'Customer::Change::ChangeAttachmentAdd',
            'nl',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] bijlage toegevoegd',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> heeft een nieuwe bijlage.'
                . $ChangeInfoCustomerNl,
        ],

        [
            'Customer::Change::ChangeAttachmentDelete',
            'de',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] Anhang gelöscht',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> mit gelöschtem Anhang.'
                . $ChangeInfoCustomerDe,
        ],
        [
            'Customer::Change::ChangeAttachmentDelete',
            'en',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] attachment deleted',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> with deleted attachment.'
                . $ChangeInfoCustomerEn,
        ],
        [
            'Customer::Change::ChangeAttachmentDelete',
            'nl',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] bijlage verwijderd',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> met een verwijderde bijlage.'
                . $ChangeInfoCustomerNl,
        ],

        [
            'Customer::WorkOrder::WorkOrderAttachmentAdd',
            'de',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] neuer Anhang',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> hat einen neuen Anhang.'
                . $WorkOrderInfoCustomerDe,
        ],
        [
            'Customer::WorkOrder::WorkOrderAttachmentAdd',
            'en',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] new attachment',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> has a new attachment.'
                . $WorkOrderInfoCustomerEn,
        ],
        [
            'Customer::WorkOrder::WorkOrderAttachmentAdd',
            'nl',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] bijlage toegevoegd',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> heeft een nieuwe bijlage.'
                . $WorkOrderInfoCustomerNl,
        ],

        [
            'Customer::WorkOrder::WorkOrderAttachmentDelete',
            'de',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] Anhang gelöscht',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> mit gelöschtem Anhang.'
                . $WorkOrderInfoCustomerDe,
        ],
        [
            'Customer::WorkOrder::WorkOrderAttachmentDelete',
            'en',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] attachment deleted',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> with deleted attachment.'
                . $WorkOrderInfoCustomerEn,
        ],
        [
            'Customer::WorkOrder::WorkOrderAttachmentDelete',
            'nl',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] bijlage verwijderd',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> met een verwijderde bijlage.'
                . $WorkOrderInfoCustomerNl,
        ],

        [
            'Customer::WorkOrder::WorkOrderReportAttachmentAdd',
            'de',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] neuer Report-Anhang',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> hat einen neuen Report-Anhang.'
                . $WorkOrderInfoCustomerDe,
        ],
        [
            'Customer::WorkOrder::WorkOrderReportAttachmentAdd',
            'en',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] new report attachment',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> has a new report attachment.'
                . $WorkOrderInfoCustomerEn,
        ],
        [
            'Customer::WorkOrder::WorkOrderReportAttachmentAdd',
            'nl',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] bericht bijlage toegevoegd',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> heeft een nieuwe bericht bijlage.'
                . $WorkOrderInfoCustomerNl,
        ],

        [
            'Customer::WorkOrder::WorkOrderReportAttachmentDelete',
            'de',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] Report-Anhang gelöscht',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> mit gelöschtem Report-Anhang.'
                . $WorkOrderInfoCustomerDe,
        ],
        [
            'Customer::WorkOrder::WorkOrderReportAttachmentDelete',
            'en',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] report attachment deleted',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> with deleted report attachment.'
                . $WorkOrderInfoCustomerEn,
        ],
        [
            'Customer::WorkOrder::WorkOrderReportAttachmentDelete',
            'nl',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] bericht bijlage verwijderd',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> met een verwijderde bericht bijlage.'
                . $WorkOrderInfoCustomerNl,
        ],

        [
            'Customer::Change::ChangePlannedStartTimeReached',
            'de',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] geplante Startzeit erreicht',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> hat die geplante Startzeit erreicht.'
                . $ChangeInfoCustomerDe,
        ],
        [
            'Customer::Change::ChangePlannedStartTimeReached',
            'en',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] Planned Start Time reached',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> has reached its Planned Start Time.'
                . $ChangeInfoCustomerEn,
        ],
        [
            'Customer::Change::ChangePlannedStartTimeReached',
            'nl',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] geplande starttijd bereikt',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> heeft de geplande starttijd bereikt.'
                . $ChangeInfoCustomerNl,
        ],

        [
            'Customer::Change::ChangePlannedEndTimeReached',
            'de',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] geplante Endzeit erreicht',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> hat die geplante Endzeit erreicht.'
                . $ChangeInfoCustomerDe,
        ],
        [
            'Customer::Change::ChangePlannedEndTimeReached',
            'en',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] Planned End Time reached',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> has reached its Planned End Time.'
                . $ChangeInfoCustomerEn,
        ],
        [
            'Customer::Change::ChangePlannedEndTimeReached',
            'nl',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] geplande eindtijd bereikt',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> heeft de geplande eindtijd bereikt.'
                . $ChangeInfoCustomerNl,
        ],

        [
            'Customer::Change::ChangeActualStartTimeReached',
            'de',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] begonnen',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> wurde begonnen.'
                . $ChangeInfoCustomerDe,
        ],
        [
            'Customer::Change::ChangeActualStartTimeReached',
            'en',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] started',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> has started.'
                . $ChangeInfoCustomerEn,
        ],
        [
            'Customer::Change::ChangeActualStartTimeReached',
            'nl',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] gestart',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> is gestart.'
                . $ChangeInfoCustomerNl,
        ],

        [
            'Customer::Change::ChangeActualEndTimeReached',
            'de',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] abgeschlossen',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> wurde abgeschlossen.'
                . $ChangeInfoCustomerDe,
        ],
        [
            'Customer::Change::ChangeActualEndTimeReached',
            'en',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] finished',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> was finished.'
                . $ChangeInfoCustomerEn,
        ],
        [
            'Customer::Change::ChangeActualEndTimeReached',
            'nl',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] afgerond',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> is afgerond.'
                . $ChangeInfoCustomerNl,
        ],

        [
            'Customer::Change::ChangeRequestedTimeReached',
            'de',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] Gewünschte Fertigstellungszeit erreicht',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> hat die gewünschte Fertigstellungszeit erreicht.'
                . $ChangeInfoCustomerDe,
        ],
        [
            'Customer::Change::ChangeRequestedTimeReached',
            'en',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] requested time reached',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> has reached its requested time.'
                . $ChangeInfoCustomerEn,
        ],
        [
            'Customer::Change::ChangeRequestedTimeReached',
            'nl',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] aangevraagd tijdstip bereikt',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> heeft het aangevraagde tijdstip bereikt.'
                . $ChangeInfoCustomerNl,
        ],

        [
            'Customer::WorkOrder::WorkOrderPlannedStartTimeReached',
            'de',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] geplante Startzeit erreicht',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> hat die geplante Startzeit erreicht.'
                . $WorkOrderInfoCustomerDe,
        ],
        [
            'Customer::WorkOrder::WorkOrderPlannedStartTimeReached',
            'en',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] Planned Start Time reached',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> has reached the Planned Start Time.'
                . $WorkOrderInfoCustomerEn,
        ],
        [
            'Customer::WorkOrder::WorkOrderPlannedStartTimeReached',
            'nl',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] geplande starttijd bereikt',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> heeft de geplande starttijd bereikt.'
                . $WorkOrderInfoCustomerNl,
        ],

        [
            'Customer::WorkOrder::WorkOrderPlannedEndTimeReached',
            'de',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] geplante Endzeit erreicht',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> hat die geplante Endzeit erreicht.'
                . $WorkOrderInfoCustomerDe,
        ],
        [
            'Customer::WorkOrder::WorkOrderPlannedEndTimeReached',
            'en',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] Planned End Time reached',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> has reached the Planned End Time.'
                . $WorkOrderInfoCustomerEn,
        ],
        [
            'Customer::WorkOrder::WorkOrderPlannedEndTimeReached',
            'nl',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] geplande eindtijd bereikt',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> heeft de geplande eindtijd bereikt.'
                . $WorkOrderInfoCustomerNl,
        ],

        [
            'Customer::WorkOrder::WorkOrderActualStartTimeReached',
            'de',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] begonnen',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> wurde begonnen.'
                . $WorkOrderInfoCustomerDe,
        ],
        [
            'Customer::WorkOrder::WorkOrderActualStartTimeReached',
            'en',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] started',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> has started.'
                . $WorkOrderInfoCustomerEn,
        ],
        [
            'Customer::WorkOrder::WorkOrderActualStartTimeReached',
            'nl',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] gestart',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> is gestart.'
                . $WorkOrderInfoCustomerNl,
        ],

        [
            'Customer::WorkOrder::WorkOrderActualEndTimeReached',
            'de',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] abgeschlossen',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> wurde abgeschlossen.'
                . $WorkOrderInfoCustomerDe,
        ],
        [
            'Customer::WorkOrder::WorkOrderActualEndTimeReached',
            'en',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] finished',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> was finished.'
                . $WorkOrderInfoCustomerEn,
        ],
        [
            'Customer::WorkOrder::WorkOrderActualEndTimeReached',
            'nl',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] afgerond',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> is afgerond.'
                . $WorkOrderInfoCustomerNl,
        ],

    );

    my $NotificationCharset = 'utf-8';

    # insert the entries
    for my $Notification ( @AgentNotifications, @CustomerNotifications ) {
        my @Binds;

        for my $Value ( @{$Notification} ) {

            # Bind requires scalar references
            push @Binds, \$Value;
        }

        # do the insertion
        $Self->{DBObject}->Do(
            SQL => 'INSERT INTO notifications (notification_type, notification_language, '
                . 'subject, text, notification_charset, content_type, '
                . 'create_time, create_by, change_time, change_by) '
                . 'VALUES( ?, ?, ?, ?, ?, \'text/plain\', '
                . 'current_timestamp, 1, current_timestamp, 1 )',
            Bind => [ @Binds, \$NotificationCharset ],
        );
    }

    return 1;
}

=item _AddSystemNotificationsNewIn_2_0_3()

Adds the new notifications to systems notification table that were added in version 2.0.3.

    my $Success = $PackageSetup->_AddSystemNotificationsNewIn_2_0_3();

=cut

sub _AddSystemNotificationsNewIn_2_0_3 {    ## no critic
    my ($Self) = @_;

    # define agent notifications
    my @AgentNotifications = (
        [
            'Agent::Change::ActionExecute',
            'de',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] Aktions-Ausführung <OTRS_CONDITION_ActionResult>',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> Aktions-Ausführung <OTRS_CONDITION_ActionResult>.'
                . "\n"
                . "\n"
                . "Change Titel: <OTRS_CHANGE_ChangeTitle>\n"
                . "Aktueller Change Status: <OTRS_CHANGE_ChangeState>\n"
                . "\n"
                . "Condition ID: <OTRS_CONDITION_ConditionID>\n"
                . "Condition Name: <OTRS_CONDITION_ConditionName>\n"
                . "\n"
                . "Action ID: <OTRS_CONDITION_ActionID>\n"
                . "Aktions-Ausführung: <OTRS_CONDITION_ActionResult>\n"
                . "\n"
                . "<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentITSMChangeZoom;ChangeID=<OTRS_CHANGE_ChangeID>\n"
                . "\n"
                . "Ihr OTRS Notification Master\n",
        ],
        [
            'Agent::Change::ActionExecute',
            'en',
            '[<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber>] Action execution <OTRS_CONDITION_ActionResult>',
            '<OTRS_CONFIG_ITSMChange::Hook><OTRS_CHANGE_ChangeNumber> Action execution <OTRS_CONDITION_ActionResult>.'
                . "\n"
                . "\n"
                . "Change title: <OTRS_CHANGE_ChangeTitle>\n"
                . "Current change state: <OTRS_CHANGE_ChangeState>\n"
                . "\n"
                . "Condition ID: <OTRS_CONDITION_ConditionID>\n"
                . "Condition name: <OTRS_CONDITION_ConditionName>\n"
                . "\n"
                . "Action ID: <OTRS_CONDITION_ActionID>\n"
                . "Action execution: <OTRS_CONDITION_ActionResult>\n"
                . "\n"
                . "<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentITSMChangeZoom;ChangeID=<OTRS_CHANGE_ChangeID>\n"
                . "\n"
                . "Your OTRS Notification Master\n",
        ],
    );

    my $NotificationCharset = 'utf-8';

    # insert the entries
    for my $Notification (@AgentNotifications) {
        my @Binds;

        for my $Value ( @{$Notification} ) {

            # Bind requires scalar references
            push @Binds, \$Value;
        }

        # do the insertion
        $Self->{DBObject}->Do(
            SQL => 'INSERT INTO notifications (notification_type, notification_language, '
                . 'subject, text, notification_charset, content_type, '
                . 'create_time, create_by, change_time, change_by) '
                . 'VALUES( ?, ?, ?, ?, ?, \'text/plain\', '
                . 'current_timestamp, 1, current_timestamp, 1 )',
            Bind => [ @Binds, \$NotificationCharset ],
        );
    }

    return 1;
}

=item _AddSystemNotificationsNewIn_3_2_91()

Adds the new notifications to systems notification table that were added in version 3.2.91. (3.3.0 Beta 1)

    my $Success = $PackageSetup->_AddSystemNotificationsNewIn_3_2_91();

=cut

sub _AddSystemNotificationsNewIn_3_2_91 {    ## no critic
    my ($Self) = @_;

    # Workorder info for customers (en)
    my $WorkOrderInfoCustomerEn = "\n"
        . "\n"
        . "Change title: <OTRS_CHANGE_ChangeTitle>\n"
        . "Current change state: <OTRS_CHANGE_ChangeState>\n"
        . "\n"
        . "Workorder title: <OTRS_WORKORDER_WorkOrderTitle>\n"
        . "Workorder type: <OTRS_WORKORDER_WorkOrderType>\n"
        . "Workorder agent: <OTRS_WORKORDER_WorkOrderAgent>\n"
        . "Current workorder state: <OTRS_WORKORDER_WorkOrderState>\n"
        . "\n"
        . "Your OTRS Notification Master\n";

    # Workorder info for agents (en)
    my $WorkOrderInfoAgentEn = "\n"
        . "\n"
        . "Change title: <OTRS_CHANGE_ChangeTitle>\n"
        . "Current change state: <OTRS_CHANGE_ChangeState>\n"
        . "\n"
        . "Workorder title: <OTRS_WORKORDER_WorkOrderTitle>\n"
        . "Workorder type: <OTRS_WORKORDER_WorkOrderType>\n"
        . "Current workorder state: <OTRS_WORKORDER_WorkOrderState>\n"
        . "\n"
        . "<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentITSMWorkOrderZoom;WorkOrderID=<OTRS_WORKORDER_WorkOrderID>\n"
        . "\n"
        . "Your OTRS Notification Master\n";

    # Workorder info for agents (de)
    my $WorkOrderInfoAgentDe = "\n"
        . "\n"
        . "Change Titel: <OTRS_CHANGE_ChangeTitle>\n"
        . "Aktueller Change Status: <OTRS_CHANGE_ChangeState>\n"
        . "\n"
        . "Workorder Titel: <OTRS_WORKORDER_WorkOrderTitle>\n"
        . "Workorder Typ: <OTRS_WORKORDER_WorkOrderType>\n"
        . "Workorder Agent: <OTRS_WORKORDER_WorkOrderAgent>\n"
        . "Aktueller Workorder Status: <OTRS_WORKORDER_WorkOrderState>\n"
        . "\n"
        . "<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentITSMWorkOrderZoom;WorkOrderID=<OTRS_WORKORDER_WorkOrderID>\n"
        . "\n"
        . "Ihr OTRS Notification Master\n";

    # Workorder info for customers (de)
    my $WorkOrderInfoCustomerDe = "\n"
        . "\n"
        . "Change Titel: <OTRS_CHANGE_ChangeTitle>\n"
        . "Aktueller Change Status: <OTRS_CHANGE_ChangeState>\n"
        . "\n"
        . "Workorder Titel: <OTRS_WORKORDER_WorkOrderTitle>\n"
        . "Workorder Typ: <OTRS_WORKORDER_WorkOrderType>\n"
        . "Aktueller Workorder Status: <OTRS_WORKORDER_WorkOrderState>\n"
        . "\n"
        . "Ihr OTRS Notification Master\n";

    # Workorder info for agents (nl)
    my $WorkOrderInfoAgentNl = "\n"
        . "\n"
        . "Change-titel: <OTRS_CHANGE_ChangeTitle>\n"
        . "Actuele change-status: <OTRS_CHANGE_ChangeState>\n"
        . "\n"
        . "Work Order-titel: <OTRS_WORKORDER_WorkOrderTitle>\n"
        . "Work Order-type: <OTRS_WORKORDER_WorkOrderType>\n"
        . "Work Order-agent: <OTRS_WORKORDER_WorkOrderAgent>\n"
        . "Actuele Work Order-status: <OTRS_WORKORDER_WorkOrderState>\n"
        . "\n"
        . "<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentITSMWorkOrderZoom;WorkOrderID=<OTRS_WORKORDER_WorkOrderID>\n"
        . "\n";

    # Workorder info for customers (nl)
    my $WorkOrderInfoCustomerNl = "\n"
        . "\n"
        . "Change-titel: <OTRS_CHANGE_ChangeTitle>\n"
        . "Actuele change-status: <OTRS_CHANGE_ChangeState>\n"
        . "\n"
        . "Work Order-titel: <OTRS_WORKORDER_WorkOrderTitle>\n"
        . "Work Order-type: <OTRS_WORKORDER_WorkOrderType>\n"
        . "Actuele Work Order-status: <OTRS_WORKORDER_WorkOrderState>\n"
        . "\n";

    # define agent notifications
    my @AgentNotifications = (

        [
            'Agent::WorkOrder::WorkOrderReportAttachmentAdd',
            'de',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] neuer Report-Anhang',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> hat einen neuen Report-Anhang.'
                . $WorkOrderInfoAgentDe,
        ],
        [
            'Agent::WorkOrder::WorkOrderReportAttachmentAdd',
            'en',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] new report attachment',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> has a new report attachment.'
                . $WorkOrderInfoAgentEn,
        ],
        [
            'Agent::WorkOrder::WorkOrderReportAttachmentAdd',
            'nl',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] nieuwe bericht bijlage',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> heeft een nieuwe bericht bijlage.'
                . $WorkOrderInfoAgentNl,
        ],

        [
            'Agent::WorkOrder::WorkOrderReportAttachmentDelete',
            'de',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] Report-Anhang gelöscht',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> mit gelöschtem Report-Anhang.'
                . $WorkOrderInfoAgentDe,
        ],
        [
            'Agent::WorkOrder::WorkOrderReportAttachmentDelete',
            'en',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] report attachment deleted',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> with deleted report attachment.'
                . $WorkOrderInfoAgentEn,
        ],
        [
            'Agent::WorkOrder::WorkOrderReportAttachmentDelete',
            'nl',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] bericht bijlage verwijderd',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> bericht bijlage is verwijderd.'
                . $WorkOrderInfoAgentNl,
        ],

        [
            'Customer::WorkOrder::WorkOrderReportAttachmentAdd',
            'de',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] neuer Report-Anhang',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> hat einen neuen Report-Anhang.'
                . $WorkOrderInfoCustomerDe,
        ],
        [
            'Customer::WorkOrder::WorkOrderReportAttachmentAdd',
            'en',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] new report attachment',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> has a new report attachment.'
                . $WorkOrderInfoCustomerEn,
        ],
        [
            'Customer::WorkOrder::WorkOrderReportAttachmentAdd',
            'nl',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] bericht bijlage toegevoegd',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> heeft een nieuwe bericht bijlage.'
                . $WorkOrderInfoCustomerNl,
        ],

        [
            'Customer::WorkOrder::WorkOrderReportAttachmentDelete',
            'de',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] Report-Anhang gelöscht',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> mit gelöschtem Report-Anhang.'
                . $WorkOrderInfoCustomerDe,
        ],
        [
            'Customer::WorkOrder::WorkOrderReportAttachmentDelete',
            'en',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] report attachment deleted',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> with deleted report attachment.'
                . $WorkOrderInfoCustomerEn,
        ],
        [
            'Customer::WorkOrder::WorkOrderReportAttachmentDelete',
            'nl',
            '[<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber>] bericht bijlage verwijderd',
            '<OTRS_CONFIG_ITSMWorkOrder::Hook><OTRS_CHANGE_ChangeNumber>-<OTRS_WORKORDER_WorkOrderNumber> met een verwijderde bericht bijlage.'
                . $WorkOrderInfoCustomerNl,
        ],
    );

    my $NotificationCharset = 'utf-8';

    # insert the entries
    for my $Notification (@AgentNotifications) {
        my @Binds;

        for my $Value ( @{$Notification} ) {

            # Bind requires scalar references
            push @Binds, \$Value;
        }

        # do the insertion
        $Self->{DBObject}->Do(
            SQL => 'INSERT INTO notifications (notification_type, notification_language, '
                . 'subject, text, notification_charset, content_type, '
                . 'create_time, create_by, change_time, change_by) '
                . 'VALUES( ?, ?, ?, ?, ?, \'text/plain\', '
                . 'current_timestamp, 1, current_timestamp, 1 )',
            Bind => [ @Binds, \$NotificationCharset ],
        );
    }

    return 1;
}

=item _DeleteTemplates()

deletes all templates

    my $Result = $CodeObject->_DeleteTemplates();

=cut

sub _DeleteTemplates {
    my ( $Self, %Param ) = @_;

    # get all templates, also invalid ones
    my $Templates = $Self->{TemplateObject}->TemplateList(
        Valid  => 0,
        UserID => 1,
    );

    # delete all templates
    for my $TemplateID ( sort keys %{$Templates} ) {

        my $Success = $Self->{TemplateObject}->TemplateDelete(
            TemplateID => $TemplateID,
            UserID     => 1,
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

    # there are notification for agents and customers
    $Self->{DBObject}->Do(
        SQL => 'DELETE FROM notifications '
            . 'WHERE notification_type LIKE "Agent::Change::%" '
            . 'OR notification_type LIKE "Agent::WorkOrder::%" '
            . 'OR notification_type LIKE "Customer::Change::%" '
            . 'OR notification_type LIKE "Customer::WorkOrder::%"',
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
