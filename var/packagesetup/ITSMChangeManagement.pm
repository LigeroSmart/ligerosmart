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

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::DynamicField',
    'Kernel::System::GeneralCatalog',
    'Kernel::System::Group',
    'Kernel::System::ITSMChange',
    'Kernel::System::ITSMChange::History',
    'Kernel::System::ITSMChange::ITSMChangeCIPAllocate',
    'Kernel::System::ITSMChange::ITSMCondition',
    'Kernel::System::ITSMChange::ITSMStateMachine',
    'Kernel::System::ITSMChange::ITSMWorkOrder',
    'Kernel::System::ITSMChange::Notification',
    'Kernel::System::ITSMChange::Template',
    'Kernel::System::LinkObject',
    'Kernel::System::Log',
    'Kernel::System::Stats',
    'Kernel::System::SysConfig',
    'Kernel::System::Valid',
);

=head1 NAME

ITSMChangeManagement.pm - code to excecute during package installation

=head1 SYNOPSIS

Functions for installing the ITSMChangeManagement package.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $CodeObject = $Kernel::OM->Get('var::packagesetup::ITSMChangeManagement');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # rebuild ZZZ* files
    $Kernel::OM->Get('Kernel::System::SysConfig')->WriteDefault();

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

    # the stats object needs a UserID parameter for the constructor
    # we need to discard any existing stats object before
    $Kernel::OM->ObjectsDiscard(
        Objects => ['Kernel::System::Stats', 'Kernel::Config' ],
    );

    # define UserID parameter for the constructor of the stats object
    $Kernel::OM->ObjectParamAdd(
        'Kernel::System::Stats' => {
            UserID => 1,
        },
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
    $Kernel::OM->Get('Kernel::System::Stats')->StatsInstall(
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
    $Kernel::OM->Get('Kernel::System::Stats')->StatsInstall(
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
    $Kernel::OM->Get('Kernel::System::Stats')->StatsInstall(
        FilePrefix => $Self->{FilePrefix},
    );

    # set default CIP matrix (this is only done if no matrix exists)
    $Self->_CIPDefaultMatrixSet();

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

=item CodeUpgradeFromLowerThan_3_3_91()

This function is only executed if the installed module version is smaller than 3.3.91 (4.0.0 Beta 1).

my $Result = $CodeObject->CodeUpgradeFromLowerThan_3_3_91();

=cut

sub CodeUpgradeFromLowerThan_3_3_91 {    ## no critic
    my ( $Self, %Param ) = @_;

    # Migrate change and workorder freetext fields to dynamic fields.
    $Self->_MigrateFreeTextToDynamicFields();

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

    # delete all dynamic fields for changes and workorders
    $Self->_DynamicFieldsDelete();

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

=item _MigrateFreeTextToDynamicFields()

Migrates the change and workorder freetext fields to dynamic fields.

    my $Success = $PackageSetup->_MigrateFreeTextToDynamicFields();

=cut

sub _MigrateFreeTextToDynamicFields {
    my ($Self) = @_;

    # ---------------------------------------------------------------------------------------------
    # Migrate freekey and freetext fields to dynamic fields (just the fields, the data comes later)
    # ---------------------------------------------------------------------------------------------

    # get all configured change and workorder freekey and freetext numbers from sysconfig
    my @DynamicFields;
    for my $Type (qw(Change WorkOrder)) {

        FREETEXTNUMBER:
        for my $Number ( 1 .. 500 ) {

            # get freekey and freetext config
            my $FreeKeyConfig  = $Kernel::OM->Get('Kernel::Config')->Get( $Type . 'FreeKey' . $Number );
            my $FreeTextConfig = $Kernel::OM->Get('Kernel::Config')->Get( $Type . 'FreeText' . $Number );

            # only if a KEY config exists
            next FREETEXTNUMBER if !$FreeKeyConfig;

            # default label, same like the name
            my $Label = $Type . 'FreeText' . $Number;

            # the freekey has more than one entry, then we want to create
            # it as it's own dynamic field
            if ( ref $FreeKeyConfig eq 'HASH' && scalar keys %{$FreeKeyConfig} > 1 ) {

                # find out if possible none must be set or not
                my $PossibleNone = 0;
                if ( $FreeKeyConfig->{''} && $FreeKeyConfig->{''} eq '-' ) {
                    delete $FreeKeyConfig->{''};
                    $PossibleNone = 1;
                }

                push @DynamicFields, {
                    Name       => $Type . 'FreeKey' . $Number,
                    Label      => $Type . 'FreeKey' . $Number,
                    FieldType  => 'Dropdown',
                    ObjectType => 'ITSM' . $Type,
                    Config     => {
                        DefaultValue => $Kernel::OM->Get('Kernel::Config')
                            ->Get( $Type . 'FreeKey' . $Number . '::DefaultSelection' ) || '',
                        Link               => '',
                        PossibleNone       => $PossibleNone,
                        PossibleValues     => $FreeKeyConfig,
                        TranslatableValues => 1,
                    },
                };
            }

            # if the key has only one possible value for this entry we use it as the label
            # and we do NOT create an own FreeKEY field, only the FreeTEXT field!
            elsif ( ref $FreeKeyConfig eq 'HASH' && scalar keys %{$FreeKeyConfig} == 1 ) {

                # but we try to take the only entry of the KEY as label!
                for my $Key ( sort keys %{$FreeKeyConfig} ) {
                    if ( $FreeKeyConfig->{$Key} ) {
                        $Label = $FreeKeyConfig->{$Key};
                    }
                }
            }

            # freetext config is a hash -> we need a dropdown
            if ( $FreeTextConfig && ref $FreeTextConfig eq 'HASH' && %{$FreeTextConfig} ) {

                # find out if possible none must be set or not
                my $PossibleNone = 0;
                if ( $FreeTextConfig->{''} && $FreeTextConfig->{''} eq '-' ) {
                    delete $FreeTextConfig->{''};
                    $PossibleNone = 1;
                }

                push @DynamicFields, {
                    Name       => $Type . 'FreeText' . $Number,
                    Label      => $Label,
                    FieldType  => 'Dropdown',
                    ObjectType => 'ITSM' . $Type,
                    Config     => {
                        DefaultValue => $Kernel::OM->Get('Kernel::Config')
                            ->Get( $Type . 'FreeText' . $Number . '::DefaultSelection' ) || '',
                        Link =>
                            $Kernel::OM->Get('Kernel::Config')->Get( $Type . 'FreeText' . $Number . '::Link' )
                            || '',
                        PossibleNone       => $PossibleNone,
                        PossibleValues     => $FreeTextConfig,
                        TranslatableValues => 1,
                    },
                };
            }

            # no freetext config -> we need a text field
            else {

                push @DynamicFields, {
                    Name       => $Type . 'FreeText' . $Number,
                    Label      => $Label,
                    FieldType  => 'Text',
                    ObjectType => 'ITSM' . $Type,
                    Config     => {
                        DefaultValue => $Kernel::OM->Get('Kernel::Config')
                            ->Get( $Type . 'FreeText' . $Number . '::DefaultSelection' ) || '',
                        Link =>
                            $Kernel::OM->Get('Kernel::Config')->Get( $Type . 'FreeText' . $Number . '::Link' )
                            || '',
                    },
                };
            }
        }
    }

    # get all current dynamic fields
    my $DynamicFieldList = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid => 0,
    );

    # get the list of order numbers (is already sorted).
    my @DynamicfieldOrderList;
    for my $Dynamicfield ( @{$DynamicFieldList} ) {
        push @DynamicfieldOrderList, $Dynamicfield->{FieldOrder};
    }

    # get the last element from the order list and add 1
    my $NextOrderNumber = 1;
    if (@DynamicfieldOrderList) {
        $NextOrderNumber = $DynamicfieldOrderList[-1] + 1;
    }

    # get the valid id for "valid"
    my $ValidID = $Kernel::OM->Get('Kernel::System::Valid')->ValidLookup(
        Valid => 'valid',
    );

    # set the name for the sysconfig setting for the event module
    my $EventModuleSysconfigSetting
        = 'DynamicField::EventModulePost###100-UpdateITSMChangeConditions';

    # get the original sysconfig setting for the event module registration
    my %EventModuleConfig = $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemGet(
        Name => $EventModuleSysconfigSetting,
    );

    # deactivate the sysconfig setting to prevent event module to react on
    # adding of dynamic fields during the migration
    $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemUpdate(
        Valid => 0,
        Key   => $EventModuleSysconfigSetting,
        Value => \%EventModuleConfig,
    );

    DYNAMICFIELD:
    for my $DynamicField (@DynamicFields) {

        # create a new field
        my $FieldID = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldAdd(
            Name       => $DynamicField->{Name},
            Label      => $DynamicField->{Label},
            FieldOrder => $NextOrderNumber,
            FieldType  => $DynamicField->{FieldType},
            ObjectType => $DynamicField->{ObjectType},
            Config     => $DynamicField->{Config},
            ValidID    => $ValidID,
            UserID     => 1,
        );
        next DYNAMICFIELD if !$FieldID;

        # increase the order number
        $NextOrderNumber++;
    }

    # re-activate the sysconfig setting again
    $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemUpdate(
        Valid => 1,
        Key   => $EventModuleSysconfigSetting,
        Value => \%EventModuleConfig,
    );

    # ---------------------------------------------------------------------------------------------
    # Migrate the change and workorder data from freekey and freetext fields to dynamic fields
    # ---------------------------------------------------------------------------------------------

    # get the list of change and workorder dynamic fields
    $DynamicFieldList = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid => 1,
        ObjectType => [ 'ITSMChange', 'ITSMWorkOrder' ],
    );

    # migrate the freekey and freetext data
    DYNAMICFIELD:
    for my $DynamicField ( @{$DynamicFieldList} ) {

        # get the table prefix and column name based on change or workorder
        my $TablePrefix;
        my $ColumnName;
        if ( $DynamicField->{ObjectType} eq 'ITSMChange' ) {
            $TablePrefix = 'change_free';
            $ColumnName  = 'change_id';
        }
        elsif ( $DynamicField->{ObjectType} eq 'ITSMWorkOrder' ) {
            $TablePrefix = 'change_wo_free';
            $ColumnName  = 'workorder_id';
        }

        # get the type (key or text) and the number from the name
        my $Number;
        my $TableName;
        if ( $DynamicField->{Name} =~ m{ \A (Change|WorkOrder)Free(Key|Text)(\d+) \z }xms ) {
            $TableName = $TablePrefix . lc($2);
            $Number    = $3;
        }
        else {
            next DYNAMICFIELD;
        }

        # get the old data
        next DYNAMICFIELD if !$Kernel::OM->Get('Kernel::System::DB')->Prepare(
            SQL => "SELECT $ColumnName, field_value
                    FROM $TableName
                    WHERE field_id = ?",
            Bind => [ \$Number ],
        );

        # fetch the result
        my @Data;
        while ( my @Row = $Kernel::OM->Get('Kernel::System::DB')->FetchrowArray() ) {
            push @Data, {
                ObjectID => $Row[0],
                Value    => $Row[1],
            };
        }

        # insert data into dynamic_field_value table
        RECORD:
        for my $Record (@Data) {

            next RECORD if !$Kernel::OM->Get('Kernel::System::DB')->Do(
                SQL => 'INSERT INTO dynamic_field_value
                        (field_id, object_id, value_text)
                        VALUES (?, ?, ?)',
                Bind => [
                    \$DynamicField->{ID},
                    \$Record->{ObjectID},
                    \$Record->{Value},
                ],
            );
        }
    }

    # ---------------------------------------------------------------------------------------------
    # Delete obsolete freekey and freetext field attributes from conditions
    # ---------------------------------------------------------------------------------------------

    # build a lookup hash for all new created change and workorder dynamic fields
    my %DynamicFieldName;
    for my $DynamicField (@DynamicFields) {
        $DynamicFieldName{ $DynamicField->{Name} } = 1;
    }

    # get all condition attributes
    my $ConditionAttributes = $Kernel::OM->Get('Kernel::System::ITSMChange::ITSMCondition')->AttributeList(
        UserID => 1,
    );

    # reverse the list to lookup attribute names
    my %Attribute2ID = reverse %{$ConditionAttributes};

    ATTRIBUTE:
    for my $Attribute ( sort keys %Attribute2ID ) {

        # we are only interested in old change and workorder freekey and freetext attributes
        next ATTRIBUTE if $Attribute !~ m{ \A (Change|WorkOrder)Free(Key|Text)(\d+) \z }xms;

        # rename the attribute (add a prefix to the attribute)
        if ( $DynamicFieldName{$Attribute} ) {

            my $Success = $Kernel::OM->Get('Kernel::System::ITSMChange::ITSMCondition')->AttributeUpdate(
                AttributeID => $Attribute2ID{$Attribute},
                Name        => 'DynamicField_' . $Attribute,
                UserID      => 1,
            );
        }

        # this attribute does not exist as dynamic field
        else {

            # delete this attribute from expression table
            next ATTRIBUTE if !$Kernel::OM->Get('Kernel::System::DB')->Do(
                SQL => 'DELETE FROM condition_expression
                        WHERE attribute_id = ?',
                Bind => [
                    \$Attribute2ID{$Attribute},
                ],
            );

            # delete this attribute from action table
            next ATTRIBUTE if !$Kernel::OM->Get('Kernel::System::DB')->Do(
                SQL => 'DELETE FROM condition_action
                        WHERE attribute_id = ?',
                Bind => [
                    \$Attribute2ID{$Attribute},
                ],
            );

            # delete this attribute from attribute table
            next ATTRIBUTE if !$Kernel::OM->Get('Kernel::System::DB')->Do(
                SQL => 'DELETE FROM condition_attribute
                        WHERE id = ?',
                Bind => [
                    \$Attribute2ID{$Attribute},
                ],
            );
        }
    }

    # ---------------------------------------------------------------------------------------------
    # Migrate freetext screen config
    # ---------------------------------------------------------------------------------------------

    # migrate change freetext frontend config
    CONFIGNAME:
    for my $ConfigName (
        qw(
        ITSMChange::Frontend::AgentITSMChangeAdd
        ITSMChange::Frontend::AgentITSMChangeEdit
        ITSMChange::Frontend::AgentITSMChangeSearch
        ITSMChange::Frontend::AgentITSMWorkOrderAdd
        ITSMWorkOrder::Frontend::AgentITSMWorkOrderEdit
        ITSMWorkOrder::Frontend::AgentITSMWorkOrderReport
        )
        )
    {

        my $FieldType;
        my $Config = $Kernel::OM->Get('Kernel::Config')->Get($ConfigName);
        if ( $ConfigName =~ m{ AgentITSMWorkOrder }xms ) {
            $FieldType = 'WorkOrderFreeText';
        }
        else {
            $FieldType = 'ChangeFreeText';
        }
        $Config = $Config->{$FieldType};

        my %NewSetting;
        NUMBER:
        for my $Number ( sort keys %{$Config} ) {

            my $Value = $Config->{$Number};

            next NUMBER if !$Value;

            $NewSetting{ $FieldType . $Number } = $Value;
        }

        next CONFIGNAME if !%NewSetting;

        # update the sysconfig
        my $Success = $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemUpdate(
            Valid => 1,
            Key   => $ConfigName . '###DynamicField',
            Value => \%NewSetting,
        );
    }

    my %ChangeDynamicFieldConfig;
    my %WorkorderDynamicFieldConfig;

    DYNAMICFIELD:
    for my $DynamicField ( @{$DynamicFieldList} ) {

        if ( $DynamicField->{ObjectType} eq 'ITSMChange' ) {
            $ChangeDynamicFieldConfig{ $DynamicField->{Name} } = 1;
        }
        elsif ( $DynamicField->{ObjectType} eq 'ITSMWorkOrder' ) {
            $WorkorderDynamicFieldConfig{ $DynamicField->{Name} } = 1;
        }
    }

    # show all change dynamic fields in the change zoom
    $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemUpdate(
        Valid => 1,
        Key   => 'ITSMChange::Frontend::AgentITSMChangeZoom###DynamicField',
        Value => \%ChangeDynamicFieldConfig,
    );

    # show all workorder dynamic fields in the workorder zoom
    $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemUpdate(
        Valid => 1,
        Key   => 'ITSMWorkOrder::Frontend::AgentITSMWorkOrderZoom###DynamicField',
        Value => \%WorkorderDynamicFieldConfig,
    );

    # ---------------------------------------------------------------------------------------------
    # Delete change and workorder freekey and freetext tables
    # ---------------------------------------------------------------------------------------------
    my @Drop = $Kernel::OM->Get('Kernel::System::DB')->SQLProcessor(
        Database => [

            # drop table change_freekey
            {
                Tag     => 'TableDrop',
                Name    => 'change_freekey',
                TagType => 'Start',
            },
            {
                Tag     => 'TableDrop',
                TagType => 'End',
            },

            # drop table change_freetext
            {
                Tag     => 'TableDrop',
                Name    => 'change_freetext',
                TagType => 'Start',
            },
            {
                Tag     => 'TableDrop',
                TagType => 'End',
            },

            # drop table change_wo_freekey
            {
                Tag     => 'TableDrop',
                Name    => 'change_wo_freekey',
                TagType => 'Start',
            },
            {
                Tag     => 'TableDrop',
                TagType => 'End',
            },

            # drop table change_wo_freetext
            {
                Tag     => 'TableDrop',
                Name    => 'change_wo_freetext',
                TagType => 'Start',
            },
            {
                Tag     => 'TableDrop',
                TagType => 'End',
            },
        ],
    );

    for my $SQL (@Drop) {
        $Kernel::OM->Get('Kernel::System::DB')->Do(
            SQL => $SQL,
        );
    }

    return 1;
}

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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get valid list
    my %ValidList = $Kernel::OM->Get('Kernel::System::Valid')->ValidList(
        UserID => 1,
    );
    my %ValidListReverse = reverse %ValidList;

    # get list of all groups
    my %GroupList = $Kernel::OM->Get('Kernel::System::Group')->GroupList();

    # reverse the group list for easier lookup
    my %GroupListReverse = reverse %GroupList;

    # check if group already exists
    my $GroupID = $GroupListReverse{ $Param{Name} };

    # reactivate the group
    if ($GroupID) {

        # get current group data
        my %GroupData = $Kernel::OM->Get('Kernel::System::Group')->GroupGet(
            ID     => $GroupID,
            UserID => 1,
        );

        # reactivate group
        $Kernel::OM->Get('Kernel::System::Group')->GroupUpdate(
            %GroupData,
            ValidID => $ValidListReverse{valid},
            UserID  => 1,
        );

        return 1;
    }

    # add the group
    else {
        return if !$Kernel::OM->Get('Kernel::System::Group')->GroupAdd(
            Name    => $Param{Name},
            Comment => $Param{Description},
            ValidID => $ValidListReverse{valid},
            UserID  => 1,
        );
    }

    # lookup the new group id
    my $NewGroupID = $Kernel::OM->Get('Kernel::System::Group')->GroupLookup(
        Group  => $Param{Name},
        UserID => 1,
    );

    # add user root to the group
    $Kernel::OM->Get('Kernel::System::Group')->GroupMemberAdd(
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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Name!',
        );
        return;
    }

    # lookup group id
    my $GroupID = $Kernel::OM->Get('Kernel::System::Group')->GroupLookup(
        Group => $Param{Name},
    );

    return if !$GroupID;

    # get valid list
    my %ValidList = $Kernel::OM->Get('Kernel::System::Valid')->ValidList(
        UserID => 1,
    );
    my %ValidListReverse = reverse %ValidList;

    # get current group data
    my %GroupData = $Kernel::OM->Get('Kernel::System::Group')->GroupGet(
        ID     => $GroupID,
        UserID => 1,
    );

    # deactivate group
    $Kernel::OM->Get('Kernel::System::Group')->GroupUpdate(
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
    my $List = $Kernel::OM->Get('Kernel::System::ITSMChange::ITSMChangeCIPAllocate')->AllocateList(
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
    my $ImpactList = $Kernel::OM->Get('Kernel::System::GeneralCatalog')->ItemList(
        Class => 'ITSM::ChangeManagement::Impact',
    );
    my %ImpactListReverse = reverse %{$ImpactList};

    # get category list
    my $CategoryList = $Kernel::OM->Get('Kernel::System::GeneralCatalog')->ItemList(
        Class => 'ITSM::ChangeManagement::Category',
    );
    my %CategoryListReverse = reverse %{$CategoryList};

    # get priority list
    my $PriorityList = $Kernel::OM->Get('Kernel::System::GeneralCatalog')->ItemList(
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
    $Kernel::OM->Get('Kernel::System::ITSMChange::ITSMChangeCIPAllocate')->AllocateUpdate(
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
        $Kernel::OM->Get('Kernel::System::GeneralCatalog')->ItemList(
            Class => 'ITSM::ChangeManagement::Change::State',
            )
    };

    # get the workorder states from the general catalog
    my %Name2WorkOrderStateID = reverse %{
        $Kernel::OM->Get('Kernel::System::GeneralCatalog')->ItemList(
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
            my $TransitionID = $Kernel::OM->Get('Kernel::System::ITSMChange::ITSMStateMachine')->StateTransitionAdd(
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
            my $TransitionID = $Kernel::OM->Get('Kernel::System::ITSMChange::ITSMStateMachine')->StateTransitionAdd(
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
    my $ChangeIDs = $Kernel::OM->Get('Kernel::System::ITSMChange')->ChangeList(
        UserID => 1,
    );

    # delete all change links
    if ( $ChangeIDs && ref $ChangeIDs eq 'ARRAY' ) {

        CHANGEID:
        for my $ChangeID ( @{$ChangeIDs} ) {

            # delete all links to this change
            $Kernel::OM->Get('Kernel::System::LinkObject')->LinkDeleteAll(
                Object => 'ITSMChange',
                Key    => $ChangeID,
                UserID => 1,
            );

            # get all workorder ids for this change
            my $WorkOrderIDs = $Kernel::OM->Get('Kernel::System::ITSMChange::ITSMWorkOrder')->WorkOrderList(
                ChangeID => $ChangeID,
                UserID   => 1,
            );

            next CHANGEID if !$WorkOrderIDs;
            next CHANGEID if ref $WorkOrderIDs ne 'ARRAY';

            # delete all workorder links
            for my $WorkOrderID ( @{$WorkOrderIDs} ) {
                $Kernel::OM->Get('Kernel::System::LinkObject')->LinkDeleteAll(
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
    my $ChangeIDs = $Kernel::OM->Get('Kernel::System::ITSMChange')->ChangeList(
        UserID => 1,
    );

    for my $ChangeID ( @{$ChangeIDs} ) {

        # get the list of all change attachments
        my @ChangeAttachments = $Kernel::OM->Get('Kernel::System::ITSMChange')->ChangeAttachmentList(
            ChangeID => $ChangeID,
        );

        # delete all change attachments
        for my $Filename (@ChangeAttachments) {

            $Kernel::OM->Get('Kernel::System::ITSMChange')->ChangeAttachmentDelete(
                ChangeID => $ChangeID,
                Filename => $Filename,
                UserID   => 1,
            );
        }

        # get all workorder ids for this change
        my $WorkOrderIDs = $Kernel::OM->Get('Kernel::System::ITSMChange::ITSMWorkOrder')->WorkOrderList(
            ChangeID => $ChangeID,
            UserID   => 1,
        );

        for my $WorkOrderID ( @{$WorkOrderIDs} ) {

            # get the list of all workorder attachments
            my @WorkOrderAttachments = $Kernel::OM->Get('Kernel::System::ITSMChange::ITSMWorkOrder')->WorkOrderAttachmentList(
                WorkOrderID => $WorkOrderID,
            );

            # delete all workorder attachments
            for my $Filename (@WorkOrderAttachments) {

                $Kernel::OM->Get('Kernel::System::ITSMChange::ITSMWorkOrder')->WorkOrderAttachmentDelete(
                    ChangeID       => $ChangeID,
                    WorkOrderID    => $WorkOrderID,
                    Filename       => $Filename,
                    AttachmentType => 'WorkOrder',
                    UserID         => 1,
                );
            }

            # get the list of all workorder report attachments
            my @ReportAttachments = $Kernel::OM->Get('Kernel::System::ITSMChange::ITSMWorkOrder')->WorkOrderReportAttachmentList(
                WorkOrderID => $WorkOrderID,
            );

            # delete all workorder report attachments
            for my $Filename (@ReportAttachments) {

                $Kernel::OM->Get('Kernel::System::ITSMChange::ITSMWorkOrder')->WorkOrderAttachmentDelete(
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

=item _DynamicFieldsDelete()

delete all existing dynamic fields for changes and workorders

    my $Result = $CodeObject->_DynamicFieldsDelete();

=cut

sub _DynamicFieldsDelete {
    my ( $Self, %Param ) = @_;

    # get the list of change and workorder dynamic fields (valid an invalid ones)
    my $DynamicFieldList = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid => 0,
        ObjectType => [ 'ITSMChange', 'ITSMWorkOrder' ],
    );

    # delete the dynamic fields
    DYNAMICFIELD:
    for my $DynamicField ( @{$DynamicFieldList} ) {

        $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldDelete(
            ID     => $DynamicField->{ID},
            UserID => 1,
        );
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
            my $RecipientID = $Kernel::OM->Get('Kernel::System::ITSMChange::Notification')->RecipientLookup(
                Name => $Recipient,
            );

            if ($RecipientID) {
                push @RecipientIDs, $RecipientID;
            }
        }

        # get event id
        my $EventID =
            $HistoryTypes{ $Notification->{Event} }
            || $Kernel::OM->Get('Kernel::System::ITSMChange::History')->HistoryTypeLookup( HistoryType => $Notification->{Event} );

        # insert notification
        my $RuleID = $Kernel::OM->Get('Kernel::System::ITSMChange::Notification')->NotificationRuleAdd(
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
            my $RecipientID = $Kernel::OM->Get('Kernel::System::ITSMChange::Notification')->RecipientLookup(
                Name => $Recipient,
            );

            if ($RecipientID) {
                push @RecipientIDs, $RecipientID;
            }
        }

        # get event id
        my $EventID =
            $HistoryTypes{ $Notification->{Event} }
            || $Kernel::OM->Get('Kernel::System::ITSMChange::History')->HistoryTypeLookup( HistoryType => $Notification->{Event} );

        # insert notification
        my $RuleID = $Kernel::OM->Get('Kernel::System::ITSMChange::Notification')->NotificationRuleAdd(
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
        $Kernel::OM->Get('Kernel::System::DB')->Do(
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
        $Kernel::OM->Get('Kernel::System::DB')->Do(
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
        $Kernel::OM->Get('Kernel::System::DB')->Do(
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
    my $Templates = $Kernel::OM->Get('Kernel::System::ITSMChange::Template')->TemplateList(
        Valid  => 0,
        UserID => 1,
    );

    # delete all templates
    for my $TemplateID ( sort keys %{$Templates} ) {

        my $Success = $Kernel::OM->Get('Kernel::System::ITSMChange::Template')->TemplateDelete(
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
    $Kernel::OM->Get('Kernel::System::DB')->Do(
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
