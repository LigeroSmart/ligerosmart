# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package var::packagesetup::ITSMIncidentProblemManagement;    ## no critic

use strict;
use warnings;

use Kernel::Language qw(Translatable);
use Kernel::Output::Template::Provider;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::DynamicField',
    'Kernel::System::Log',
    'Kernel::System::State',
    'Kernel::System::Stats',
    'Kernel::System::SysConfig',
    'Kernel::System::Type',
    'Kernel::System::Valid',
);

=head1 NAME

var::packagesetup::ITSMIncidentProblemManagement - code to execute during package installation

=head1 DESCRIPTION

All functions

=head1 PUBLIC INTERFACE

=cut

=head2 new()

create an object

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $CodeObject = $Kernel::OM->Get('var::packagesetup::ITSMIncidentProblemManagement');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # Force a reload of ZZZAuto.pm and ZZZAAuto.pm to get the fresh configuration values.
    for my $Module ( sort keys %INC ) {
        if ( $Module =~ m/ZZZAA?uto\.pm$/ ) {
            delete $INC{$Module};
        }
    }

    # Create common objects with fresh default config.
    $Kernel::OM->ObjectsDiscard();

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

=head2 CodeInstall()

run the code install part

    my $Result = $CodeObject->CodeInstall();

=cut

sub CodeInstall {
    my ( $Self, %Param ) = @_;

    # set new ticket states to valid
    {
        my @StateNames = (
            'closed with workaround',
        );

        # set states to valid
        $Self->_SetStateValid(
            StateNames => \@StateNames,
            Valid      => 1,
        );
    }

    # set new ticket types to valid
    {
        my @TypeNames = (
            'Incident',
            'Incident::Major',
            'ServiceRequest',
            'Problem',
        );

        # set types to valid
        $Self->_SetTypeValid(
            TypeNames => \@TypeNames,
            Valid     => 1,
        );
    }

    # create dynamic fields for ITSM
    $Self->_CreateITSMDynamicFields();

    # install stats
    $Kernel::OM->Get('Kernel::System::Stats')->StatsInstall(
        FilePrefix => $Self->{FilePrefix},
        UserID     => 1,
    );

    return 1;
}

=head2 CodeReinstall()

run the code reinstall part

    my $Result = $CodeObject->CodeReinstall();

=cut

sub CodeReinstall {
    my ( $Self, %Param ) = @_;

    # install stats
    $Kernel::OM->Get('Kernel::System::Stats')->StatsInstall(
        FilePrefix => $Self->{FilePrefix},
        UserID     => 1,
    );

    return 1;
}

=head2 CodeUpgradeFromLowerThan_3_2_91()

This function is only executed if the installed module version is smaller than 3.2.91 (3.3.0 Beta 1).

my $Result = $CodeObject->CodeUpgradeFromLowerThan_3_2_91();

=cut

sub CodeUpgradeFromLowerThan_3_2_91 {    ## no critic
    my ( $Self, %Param ) = @_;

    # rename the dynamic fields for ITSMIncidentProblemManagement
    $Self->_RenameDynamicFields();

    # set the screen dynamic field config
    $Self->_SetScreenDynamicFieldConfig();

    return 1;
}

=head2 CodeUpgradeFromLowerThan_4_0_2()

This function is only executed if the installed module version is smaller than 4.0.2.

my $Result = $CodeObject->CodeUpgradeFromLowerThan_4_0_2();

=cut

sub CodeUpgradeFromLowerThan_4_0_2 {    ## no critic
    my ( $Self, %Param ) = @_;

    # migrate the DTL Content in the SysConfig
    $Self->_MigrateDTLInSysConfig();

    return 1;
}

=head2 CodeUpgrade()

run the code upgrade part

    my $Result = $CodeObject->CodeUpgrade();

=cut

sub CodeUpgrade {
    my ( $Self, %Param ) = @_;

    # make dynamic fields internal
    $Self->_MakeDynamicFieldsInternal();

    # install stats
    $Kernel::OM->Get('Kernel::System::Stats')->StatsInstall(
        FilePrefix => $Self->{FilePrefix},
        UserID     => 1,
    );

    return 1;
}

=head2 CodeUninstall()

run the code uninstall part

    my $Result = $CodeObject->CodeUninstall();

=cut

sub CodeUninstall {
    my ( $Self, %Param ) = @_;

    # set new ticket states to invalid
    {
        my @StateNames = (
            'closed with workaround',
        );

        # set states to invalid
        $Self->_SetStateValid(
            StateNames => \@StateNames,
            Valid      => 0,
        );
    }

    # set new ticket types to invalid
    {
        my @TypeNames = (
            'Incident',
            'Incident::Major',
            'ServiceRequest',
            'Problem',

            # old types from ITSM before version 3.2.91
            'Incident::ServiceRequest',
            'Incident::Disaster',
            'Problem::KnownError',
            'Problem::PendingRfC',
        );

        # set types to invalid
        $Self->_SetTypeValid(
            TypeNames => \@TypeNames,
            Valid     => 0,
        );
    }

    return 1;
}

=head1 PRIVATE INTERFACE

=head2 _SetScreenDynamicFieldConfig()

This function sets the screen dynamic screen config

my $Result = $CodeObject->_SetScreenDynamicFieldConfig();

=cut

sub _SetScreenDynamicFieldConfig {
    my ( $Self, %Param ) = @_;

    # mapping old name to new name of dynamic fields
    my %Old2New = (
        TicketFreeText13 => 'ITSMCriticality',
        TicketFreeText14 => 'ITSMImpact',
        TicketFreeText15 => 'ITSMReviewRequired',
        TicketFreeText16 => 'ITSMDecisionResult',
        TicketFreeTime3  => 'ITSMRepairStartTime',
        TicketFreeTime4  => 'ITSMRecoveryStartTime',
        TicketFreeTime5  => 'ITSMDecisionDate',
        TicketFreeTime6  => 'ITSMDueDate',
    );

    # define the enabled dynamic fields for each screen
    # (taken from sysconfig of ITSMIncidentProblemManagement)
    my %ScreenDynamicFieldConfig = (
        AgentTicketAddtlITSMField => {
            ITSMRepairStartTime   => 1,
            ITSMRecoveryStartTime => 1,
            ITSMDueDate           => 1,
        },
        AgentTicketDecision => {
            ITSMDecisionResult => 1,
            ITSMDecisionDate   => 1,
        },
        AgentTicketPhone => {
            ITSMImpact  => 1,
            ITSMDueDate => 1,
        },
        AgentTicketEmail => {
            ITSMImpact  => 1,
            ITSMDueDate => 1,
        },
        AgentTicketSearch => {
            ITSMImpact            => 1,
            ITSMReviewRequired    => 1,
            ITSMDecisionResult    => 1,
            ITSMRepairStartTime   => 1,
            ITSMRecoveryStartTime => 1,
            ITSMDecisionDate      => 1,
            ITSMDueDate           => 1,
        },
        AgentTicketZoom => {
            ITSMImpact            => 1,
            ITSMCriticality       => 1,
            ITSMReviewRequired    => 1,
            ITSMDecisionResult    => 1,
            ITSMRepairStartTime   => 1,
            ITSMRecoveryStartTime => 1,
            ITSMDecisionDate      => 1,
            ITSMDueDate           => 1,
        },
        AgentTicketPriority => {
            ITSMImpact => 1,
        },
        AgentTicketClose => {
            ITSMReviewRequired => 1,
        },
        AgentTicketCompose => {
            ITSMReviewRequired => 1,
        },
    );

    my $ConfigObject    = $Kernel::OM->Get('Kernel::Config');
    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    my @NewSettings;

    for my $Screen ( sort keys %ScreenDynamicFieldConfig ) {

        # get existing config for each screen
        my $Config = $ConfigObject->Get("Ticket::Frontend::$Screen");

        # get existing dynamic field config
        my %ExistingSetting = %{ $Config->{DynamicField} || {} };

        # add the new settings
        my %NewSetting = ( %ExistingSetting, %{ $ScreenDynamicFieldConfig{$Screen} } );

        # delete no longer used dynamic field names from each config
        for my $OldDynamicField ( sort keys %Old2New ) {

            # an old setting exists
            if ( exists $NewSetting{$OldDynamicField} ) {

                # copy the old setting to the new setting
                $NewSetting{ $Old2New{$OldDynamicField} } = $NewSetting{$OldDynamicField};

                # delete the old setting
                delete $NewSetting{$OldDynamicField};
            }
        }

        my $SettingName = 'Ticket::Frontend::' . $Screen . '###DynamicField';

        # Build new setting.
        push @NewSettings, {
            Name           => $SettingName,
            EffectiveValue => \%NewSetting,
        };
    }

    return 1 if !@NewSettings;

    # Write new setting.
    $SysConfigObject->SettingsSet(
        UserID   => 1,
        Comments => 'ITSMIncidentProblemManagement - package setup function: _SetScreenDynamicFieldConfig',
        Settings => \@NewSettings,
    );

    return 1;
}

=head2 _SetStateValid()

sets states to valid|invalid

    my $Result = $CodeObject->_SetStateValid(
        StateNames => [ 'new', 'open' ],
        Valid      => 1,
    );

=cut

sub _SetStateValid {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{StateNames} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need StateNames!',
        );
        return;
    }

    # lookup valid id
    my %ValidList = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();
    %ValidList = reverse %ValidList;
    my $ValidID = $Param{Valid} ? $ValidList{valid} : $ValidList{invalid};

    STATENAME:
    for my $StateName ( @{ $Param{StateNames} } ) {

        # get state
        my %State = $Kernel::OM->Get('Kernel::System::State')->StateGet(
            Name => $StateName,
        );

        next STATENAME if !%State;

        # set state
        $Kernel::OM->Get('Kernel::System::State')->StateUpdate(
            %State,
            ValidID => $ValidID,
            UserID  => 1,
        );
    }

    return 1;
}

=head2 _SetTypeValid()

sets types to valid|invalid

    my $Result = $CodeObject->_SetTypeValid(
        TypeNames => [ 'Incident', 'Problem' ],
        Valid     => 1,
    );

=cut

sub _SetTypeValid {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{TypeNames} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need TypeNames!',
        );
        return;
    }

    # lookup valid id
    my %ValidList = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();
    %ValidList = reverse %ValidList;
    my $ValidID = $Param{Valid} ? $ValidList{valid} : $ValidList{invalid};

    # get list of all types
    my %TypeList = $Kernel::OM->Get('Kernel::System::Type')->TypeList(
        Valid => 0,
    );

    # reverse the type list for easier lookup
    my %TypeListReverse = reverse %TypeList;

    TYPENAME:
    for my $TypeName ( @{ $Param{TypeNames} } ) {

        # lookup type id
        my $TypeID = $TypeListReverse{$TypeName};

        next TYPENAME if !$TypeID;

        # get type
        my %Type = $Kernel::OM->Get('Kernel::System::Type')->TypeGet(
            ID => $TypeID,
        );

        # set type
        $Kernel::OM->Get('Kernel::System::Type')->TypeUpdate(
            %Type,
            ValidID => $ValidID,
            UserID  => 1,
        );
    }

    return 1;
}

=head2 _CreateITSMDynamicFields()

creates all dynamic fields that are necessary for ITSM

    my $Result = $CodeObject->_CreateITSMDynamicFields();

=cut

sub _CreateITSMDynamicFields {
    my ( $Self, %Param ) = @_;

    my $ValidID = $Kernel::OM->Get('Kernel::System::Valid')->ValidLookup(
        Valid => 'valid',
    );

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

    # get the definition for all dynamic fields for ITSM
    my @DynamicFields = $Self->_GetITSMDynamicFieldsDefinition();

    # create a dynamic fields lookup table
    my %DynamicFieldLookup;
    DYNAMICFIELD:
    for my $DynamicField ( @{$DynamicFieldList} ) {
        next DYNAMICFIELD if ref $DynamicField ne 'HASH';
        $DynamicFieldLookup{ $DynamicField->{Name} } = $DynamicField;
    }

    # create or update dynamic fields
    DYNAMICFIELD:
    for my $DynamicField (@DynamicFields) {

        my $CreateDynamicField;

        # check if the dynamic field already exists
        if ( ref $DynamicFieldLookup{ $DynamicField->{Name} } ne 'HASH' ) {
            $CreateDynamicField = 1;
        }

        # if the field exists check if the type match with the needed type
        elsif (
            $DynamicFieldLookup{ $DynamicField->{Name} }->{FieldType}
            ne $DynamicField->{FieldType}
            )
        {

            # rename the field and create a new one
            my $Success = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldUpdate(
                %{ $DynamicFieldLookup{ $DynamicField->{Name} } },
                Name   => $DynamicFieldLookup{ $DynamicField->{Name} }->{Name} . 'Old',
                UserID => 1,
            );

            $CreateDynamicField = 1;
        }

        # otherwise if the field exists and the type match, update it to the ITSM definition
        else {

            my $Success = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldUpdate(
                %{$DynamicField},
                ID         => $DynamicFieldLookup{ $DynamicField->{Name} }->{ID},
                FieldOrder => $DynamicFieldLookup{ $DynamicField->{Name} }->{FieldOrder},
                ValidID    => $ValidID,
                Reorder    => 0,
                UserID     => 1,
            );
        }

        # check if new field has to be created
        if ($CreateDynamicField) {

            # create a new field
            my $FieldID = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldAdd(
                InternalField => 1,
                Name          => $DynamicField->{Name},
                Label         => $DynamicField->{Label},
                FieldOrder    => $NextOrderNumber,
                FieldType     => $DynamicField->{FieldType},
                ObjectType    => $DynamicField->{ObjectType},
                Config        => $DynamicField->{Config},
                ValidID       => $ValidID,
                UserID        => 1,
            );
            next DYNAMICFIELD if !$FieldID;

            # increase the order number
            $NextOrderNumber++;
        }
    }

    # make dynamic fields internal
    $Self->_MakeDynamicFieldsInternal();

    return 1;
}

=head2 _RenameDynamicFields()

This function renames the dynamic fields for ITSMIncidentProblemManagement.

my $Result = $CodeObject->_RenameDynamicFields();

=cut

sub _RenameDynamicFields {
    my ( $Self, %Param ) = @_;

    # get the definition for the dynamic fields for ITSMIncidentProblemManagement
    my @DynamicFields = $Self->_GetITSMDynamicFieldsDefinition();

    my $DynamicFieldCounter;
    my $SuccessCounter;

    # rename the dynamic fields for ITSMIncidentProblemManagement
    DYNAMICFIELD:
    for my $DynamicFieldNew (@DynamicFields) {

        # get existing dynamic field data
        my $DynamicFieldOld = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
            Name => $DynamicFieldNew->{OldName},
        );

        next DYNAMICFIELD if !%{$DynamicFieldOld};

        $DynamicFieldCounter++;

        # update the dynamic field
        my $Success = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldUpdate(
            ID         => $DynamicFieldOld->{ID},
            FieldOrder => $DynamicFieldOld->{FieldOrder},
            Name       => $DynamicFieldNew->{Name},
            Label      => $DynamicFieldNew->{Label},
            FieldType  => $DynamicFieldNew->{FieldType},
            ObjectType => $DynamicFieldNew->{ObjectType},
            Config     => $DynamicFieldOld->{Config},       # use the old config settings
            ValidID    => 1,
            Reorder    => 0,
            UserID     => 1,
        );

        if ($Success) {
            $SuccessCounter++;
        }
    }

    # error handling if not all dynamic fields could be updated successfully
    if ( $DynamicFieldCounter != $SuccessCounter ) {

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not rename all dynamic fields for ITSMIncidentProblemManagement!",
        );
        return;
    }

    return 1;
}

=head2 _GetITSMDynamicFieldsDefinition()

returns the definition for ITSM related dynamic fields

    my $Result = $CodeObject->_GetITSMDynamicFieldsDefinition();

=cut

sub _GetITSMDynamicFieldsDefinition {
    my ( $Self, %Param ) = @_;

    # define all dynamic fields for ITSM
    my @DynamicFields = (
        {
            OldName    => 'TicketFreeText15',
            Name       => 'ITSMReviewRequired',
            Label      => Translatable('Review Required'),
            FieldType  => 'Dropdown',
            ObjectType => 'Ticket',
            Config     => {
                DefaultValue   => 'No',
                Link           => '',
                PossibleNone   => 0,
                PossibleValues => {
                    No  => Translatable('No'),
                    Yes => Translatable('Yes'),
                },
                TranslatableValues => 1,
            },
        },
        {
            OldName    => 'TicketFreeText16',
            Name       => 'ITSMDecisionResult',
            Label      => Translatable('Decision Result'),
            FieldType  => 'Dropdown',
            ObjectType => 'Ticket',
            Config     => {
                DefaultValue       => 'Pending',
                Link               => '',
                TranslatableValues => 1,
                PossibleNone       => 1,
                PossibleValues     => {
                    'Approved'     => Translatable('Approved'),
                    'Pending'      => Translatable('Pending'),
                    'Postponed'    => Translatable('Postponed'),
                    'Pre-approved' => Translatable('Pre-approved'),
                    'Rejected'     => Translatable('Rejected'),
                },
            },
        },
        {
            OldName    => 'TicketFreeTime3',
            Name       => 'ITSMRepairStartTime',
            Label      => Translatable('Repair Start Time'),
            FieldType  => 'DateTime',
            ObjectType => 'Ticket',
            Config     => {
                DefaultValue  => 0,
                Link          => '',
                YearsInFuture => 5,
                YearsInPast   => 5,
                YearsPeriod   => 1,
            },
        },
        {
            OldName    => 'TicketFreeTime4',
            Name       => 'ITSMRecoveryStartTime',
            Label      => Translatable('Recovery Start Time'),
            FieldType  => 'DateTime',
            ObjectType => 'Ticket',
            Config     => {
                DefaultValue  => 0,
                Link          => '',
                YearsInFuture => 5,
                YearsInPast   => 5,
                YearsPeriod   => 1,
            },
        },
        {
            OldName    => 'TicketFreeTime5',
            Name       => 'ITSMDecisionDate',
            Label      => Translatable('Decision Date'),
            FieldType  => 'DateTime',
            ObjectType => 'Ticket',
            Config     => {
                DefaultValue  => 0,
                Link          => '',
                YearsInFuture => 5,
                YearsInPast   => 5,
                YearsPeriod   => 1,
            },
        },
        {
            OldName    => 'TicketFreeTime6',
            Name       => 'ITSMDueDate',
            Label      => Translatable('Due Date'),
            FieldType  => 'DateTime',
            ObjectType => 'Ticket',
            Config     => {
                DefaultValue  => 259200,
                Link          => '',
                YearsInFuture => 1,
                YearsInPast   => 9,
                YearsPeriod   => 1,
            },
        },
    );

    return @DynamicFields;
}

=head2 _MakeDynamicFieldsInternal()

Converts the dynamic fields to internal fields, which means that they can not be deleted in the admin interface.

    my $Result = $CodeObject->_MakeDynamicFieldsInternal();

=cut

sub _MakeDynamicFieldsInternal {
    my ( $Self, %Param ) = @_;

    # get the definition for all dynamic fields for ITSM
    my @DynamicFields = $Self->_GetITSMDynamicFieldsDefinition();

    for my $DynamicField (@DynamicFields) {

        # set as internal field
        $Kernel::OM->Get('Kernel::System::DB')->Do(
            SQL => 'UPDATE dynamic_field
                SET internal_field = 1
                WHERE name = ?',
            Bind => [
                \$DynamicField->{Name},
            ],
        );
    }
    return 1;
}

=head2 _MigrateDTLInSysConfig()

Converts C<DTL> settings in sysconfig to C<TT>.

    my $Result = $CodeObject->_MigrateDTLInSysConfig();

=cut

sub _MigrateDTLInSysConfig {

    # create needed objects
    my $ConfigObject    = $Kernel::OM->Get('Kernel::Config');
    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
    my $ProviderObject  = Kernel::Output::Template::Provider->new();

    my @NewSettings;

    # handle hash settings
    NAME:
    for my $Name (qw(Ticket::Frontend::MenuModule)) {

        # get setting's content
        my $Setting = $ConfigObject->Get($Name);
        next NAME if !$Setting;

        MENUMODULE:
        for my $MenuModule ( sort keys %{$Setting} ) {

            # setting is a hash
            SETTINGITEM:
            for my $SettingItem ( sort keys %{ $Setting->{$MenuModule} } ) {

                my $SettingContent = $Setting->{$MenuModule}->{$SettingItem};

                # do nothing if there is no value for migrating
                next SETTINGITEM if !$SettingContent;

                my $TTContent;
                eval {
                    $TTContent = $ProviderObject->MigrateDTLtoTT( Content => $SettingContent );
                };
                if ($@) {
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'error',
                        Message  => "$MenuModule->$SettingItem : $@!",
                    );
                }
                else {
                    $Setting->{$MenuModule}->{$SettingItem} = $TTContent;
                }
            }

            # Build new setting.
            push @NewSettings, {
                Name           => $Name . '###' . $MenuModule,
                EffectiveValue => $Setting->{$MenuModule},
            };
        }
    }

    # handle scalar settings
    NAME:
    for my $Name (
        qw(
        Ticket::Frontend::AgentTicketAddtlITSMField
        Ticket::Frontend::AgentTicketDecision
        )
        )
    {

        # get setting's content
        my $Setting = $ConfigObject->Get($Name);
        next NAME if !$Setting;

        SETTINGITEM:
        for my $SettingItem (qw(Subject Body)) {

            my $SettingContent = $Setting->{$SettingItem};

            # do nothing if there is no value for migrating
            next SETTINGITEM if !$SettingContent;

            my $TTContent;
            eval {
                $TTContent = $ProviderObject->MigrateDTLtoTT( Content => $SettingContent );
            };
            if ($@) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "$Name->$SettingItem : $@!",
                );
            }
            else {
                $Setting->{$SettingItem} = $TTContent;
            }

            # Build new setting.
            push @NewSettings, {
                Name           => $Name . '###' . $SettingItem,
                EffectiveValue => $Setting->{$SettingItem},
            };
        }
    }

    return 1 if !@NewSettings;

    # Write new setting.
    $SysConfigObject->SettingsSet(
        UserID   => 1,
        Comments => 'ITSMIncidentProblemManagement - package setup function: _MigrateDTLInSysConfig',
        Settings => \@NewSettings,
    );

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
