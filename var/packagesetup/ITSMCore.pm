# --
# ITSMCore.pm - code to excecute during package installation
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package var::packagesetup::ITSMCore;    ## no critic

use strict;
use warnings;

use Kernel::System::Cache;
use Kernel::System::GeneralCatalog;
use Kernel::System::Group;
use Kernel::System::ITSMCIPAllocate;
use Kernel::System::Priority;
use Kernel::System::Valid;
use Kernel::System::DynamicField;
use Kernel::System::VariableCheck qw(:all);

=head1 NAME

ITSMCore.pm - code to excecute during package installation

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
    use var::packagesetup::ITSMCore;

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
    my $CodeObject = var::packagesetup::ITSMCore->new(
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
        qw(ConfigObject LogObject EncodeObject MainObject TimeObject DBObject XMLObject)
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }
    $Self->{GeneralCatalogObject} = Kernel::System::GeneralCatalog->new( %{$Self} );
    $Self->{GroupObject}          = Kernel::System::Group->new( %{$Self} );
    $Self->{CIPAllocateObject}    = Kernel::System::ITSMCIPAllocate->new( %{$Self} );
    $Self->{PriorityObject}       = Kernel::System::Priority->new( %{$Self} );
    $Self->{ValidObject}          = Kernel::System::Valid->new( %{$Self} );
    $Self->{DynamicFieldObject}   = Kernel::System::DynamicField->new( %{$Self} );
    $Self->{CacheObject}          = Kernel::System::Cache->new( %{$Self} );

    return $Self;
}

=item CodeInstall()

run the code install part

    my $Result = $CodeObject->CodeInstall();

=cut

sub CodeInstall {
    my ( $Self, %Param ) = @_;

    # delete cache
    $Self->{CacheObject}->CleanUp();

    # create dynamic fields for ITSMCore
    $Self->_CreateITSMDynamicFields();

    # set default CIP matrix
    $Self->_CIPDefaultMatrixSet();

    # add the group itsm-service
    $Self->_GroupAdd(
        Name        => 'itsm-service',
        Description => 'Group for ITSM Service mask access in the agent interface.',
    );

    # fillup empty type_id rows in service table
    $Self->_FillupEmptyServiceTypeID();

    # fillup empty criticality rows in service table
    $Self->_FillupEmptyServiceCriticality();

    # fillup empty type_id rows in sla table
    $Self->_FillupEmptySLATypeID();

    # set preferences for some GeneralCatalog entries
    # this is only necessary in CodeInstall
    # (For Upgrades this is done already in the GeneralCatalog package)
    $Self->_SetPreferences();

    return 1;
}

=item CodeReinstall()

run the code reinstall part

    my $Result = $CodeObject->CodeReinstall();

=cut

sub CodeReinstall {
    my ( $Self, %Param ) = @_;

    # delete cache
    $Self->{CacheObject}->CleanUp();

    # set default CIP matrix
    $Self->_CIPDefaultMatrixSet();

    # add the group itsm-service
    $Self->_GroupAdd(
        Name        => 'itsm-service',
        Description => 'Group for ITSM Service mask access in the agent interface.',
    );

    # fillup empty type_id rows in service table
    $Self->_FillupEmptyServiceTypeID();

    # fillup empty criticality rows in service table
    $Self->_FillupEmptyServiceCriticality();

    # fillup empty type_id rows in sla table
    $Self->_FillupEmptySLATypeID();

    return 1;
}

=item CodeUpgradeFromLowerThan_3_2_91()

This function is only executed if the installed module version is smaller than 3.2.91 (3.3.0 Beta 1).

my $Result = $CodeObject->CodeUpgradeFromLowerThan_3_2_91();

=cut

sub CodeUpgradeFromLowerThan_3_2_91 {    ## no critic
    my ( $Self, %Param ) = @_;

    # migrate the values for Criticality and the Impact from GeneralCatalog to DynamicFields
    $Self->_MigrateCriticalityAndImpactToDynamicFields();

    return 1;
}

=item CodeUpgrade()

run the code upgrade part

    my $Result = $CodeObject->CodeUpgrade();

=cut

sub CodeUpgrade {
    my ( $Self, %Param ) = @_;

    # delete cache
    $Self->{CacheObject}->CleanUp();

    # set default CIP matrix
    $Self->_CIPDefaultMatrixSet();

    # fillup empty type_id rows in service table
    $Self->_FillupEmptyServiceTypeID();

    # fillup empty criticality rows in service table
    $Self->_FillupEmptyServiceCriticality();

    # fillup empty type_id rows in sla table
    $Self->_FillupEmptySLATypeID();

    # make dynamic fields internal
    $Self->_MakeDynamicFieldsInternal();

    return 1;
}

=item CodeUninstall()

run the code uninstall part

    my $Result = $CodeObject->CodeUninstall();

=cut

sub CodeUninstall {
    my ( $Self, %Param ) = @_;

    # deactivate the group itsm-service
    $Self->_GroupDeactivate(
        Name => 'itsm-service',
    );

    return 1;
}

=item _GetITSMDynamicFieldsDefinition()

returns the definition for ITSMCore related dynamic fields

    my $Result = $CodeObject->_GetITSMDynamicFieldsDefinition();

=cut

sub _GetITSMDynamicFieldsDefinition {
    my ( $Self, %Param ) = @_;

    # define all dynamic fields for ITSMCore
    my @DynamicFields = (
        {
            OldName    => 'TicketFreeText13',
            Name       => 'ITSMCriticality',
            Label      => 'Criticality',
            FieldType  => 'Dropdown',
            ObjectType => 'Ticket',
            Config     => {
                DefaultValue       => '',
                Link               => '',
                TranslatableValues => 1,
                PossibleNone       => 1,
                PossibleValues     => {
                    '1 very low'  => '1 very low',
                    '2 low'       => '2 low',
                    '3 normal'    => '3 normal',
                    '4 high'      => '4 high',
                    '5 very high' => '5 very high',
                },
            },
        },
        {
            OldName    => 'TicketFreeText14',
            Name       => 'ITSMImpact',
            Label      => 'Impact',
            FieldType  => 'Dropdown',
            ObjectType => 'Ticket',
            Config     => {
                DefaultValue       => '3 normal',
                Link               => '',
                TranslatableValues => 1,
                PossibleNone       => 1,
                PossibleValues     => {
                    '1 very low'  => '1 very low',
                    '2 low'       => '2 low',
                    '3 normal'    => '3 normal',
                    '4 high'      => '4 high',
                    '5 very high' => '5 very high',
                },
            },
        },
    );

    return @DynamicFields;
}

=item _CreateITSMDynamicFields()

creates all dynamic fields that are necessary for ITSMCore

    my $Result = $CodeObject->_CreateITSMDynamicFields();

=cut

sub _CreateITSMDynamicFields {
    my ( $Self, %Param ) = @_;

    my $ValidID = $Self->{ValidObject}->ValidLookup(
        Valid => 'valid',
    );

    # get all current dynamic fields
    my $DynamicFieldList = $Self->{DynamicFieldObject}->DynamicFieldListGet(
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
    for my $DynamicField ( @{$DynamicFieldList} ) {
        next if ref $DynamicField ne 'HASH';
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
            my $Success = $Self->{DynamicFieldObject}->DynamicFieldUpdate(
                %{ $DynamicFieldLookup{ $DynamicField->{Name} } },
                Name   => $DynamicFieldLookup{ $DynamicField->{Name} }->{Name} . 'Old',
                UserID => 1,
            );

            $CreateDynamicField = 1;
        }

        # otherwise if the field exists and the type match, update it to the ITSM definition
        else {
            my $Success = $Self->{DynamicFieldObject}->DynamicFieldUpdate(
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
            my $FieldID = $Self->{DynamicFieldObject}->DynamicFieldAdd(
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

=item _MigrateCriticalityAndImpactToDynamicFields()

This function migrates the values for Criticality and the Impact from GeneralCatalog to DynamicFields.

my $Result = $CodeObject->_MigrateCriticalityAndImpactToDynamicFields();

=cut

sub _MigrateCriticalityAndImpactToDynamicFields {
    my ( $Self, %Param ) = @_;

    # get criticality list (only valid items)
    my $CriticalityList = $Self->{GeneralCatalogObject}->ItemList(
        Class => 'ITSM::Core::Criticality',
        Valid => 1,
    );

    # get impact list (only valid items)
    my $ImpactList = $Self->{GeneralCatalogObject}->ItemList(
        Class => 'ITSM::Core::Impact',
        Valid => 1,
    );

    # convert in a hash reference where key is the same as the value
    $CriticalityList = { map { $_ => $_ } sort values %{$CriticalityList} };
    $ImpactList      = { map { $_ => $_ } sort values %{$ImpactList} };

    # get the definition for all dynamic fields for ITSMCore
    # (this is only ITSMCriticality and ITSMImpact)
    my @DynamicFields = $Self->_GetITSMDynamicFieldsDefinition();

    my $SuccessCounter;
    my %DynamicFieldName2ID;

    # rename the dynamic fields for Criticality and Impact and add possible value configuration
    DYNAMICFIELD:
    for my $DynamicFieldNew (@DynamicFields) {

        # replace the possible values with already existing values from General Catalog
        if ( $DynamicFieldNew->{Name} eq 'ITSMCriticality' ) {
            $DynamicFieldNew->{Config}->{PossibleValues} = $CriticalityList;
        }
        elsif ( $DynamicFieldNew->{Name} eq 'ITSMImpact' ) {
            $DynamicFieldNew->{Config}->{PossibleValues} = $ImpactList;
        }

        # get existing dynamic field data
        my $DynamicFieldOld = $Self->{DynamicFieldObject}->DynamicFieldGet(
            Name => $DynamicFieldNew->{OldName},
        );

        # store the internal id of each dynamic field in a lookup hash
        $DynamicFieldName2ID{ $DynamicFieldNew->{Name} } = $DynamicFieldOld->{ID};

        # update the dynamic field
        my $Success = $Self->{DynamicFieldObject}->DynamicFieldUpdate(
            ID         => $DynamicFieldOld->{ID},
            FieldOrder => $DynamicFieldOld->{FieldOrder},
            Name       => $DynamicFieldNew->{Name},
            Label      => $DynamicFieldNew->{Label},
            FieldType  => $DynamicFieldNew->{FieldType},
            ObjectType => $DynamicFieldNew->{ObjectType},
            Config     => $DynamicFieldNew->{Config},
            ValidID    => 1,
            Reorder    => 0,
            UserID     => 1,
        );

        if ($Success) {
            $SuccessCounter++;
        }
    }

    # error handling if not all dynamic fields could be updated successfully
    if ( scalar @DynamicFields != $SuccessCounter ) {

        $Self->{LogObject}->Log(
            Priority => 'error',
            Message =>
                "Could not migrate Criticality and Impact from General Catalog to Dynamic Fields!",
        );
        return;
    }

    my %GeneralCatalogList;

    # get criticality list (valid and invalid items)
    $GeneralCatalogList{ITSMCriticality} = $Self->{GeneralCatalogObject}->ItemList(
        Class => 'ITSM::Core::Criticality',
        Valid => 0,
    );

    # get impact list (valid and invalid items)
    $GeneralCatalogList{ITSMImpact} = $Self->{GeneralCatalogObject}->ItemList(
        Class => 'ITSM::Core::Impact',
        Valid => 0,
    );

    # find existing dynamic field values for criticality and impact
    # which have been stored as ids and replace them with values
    for my $DynamicFieldName ( sort keys %GeneralCatalogList ) {

        for my $ID ( sort keys %{ $GeneralCatalogList{$DynamicFieldName} } ) {

            $Self->{DBObject}->Do(
                SQL => 'UPDATE dynamic_field_value
                    SET value_text = ?
                    WHERE field_id = ?
                    AND value_text = ?',
                Bind => [
                    \$GeneralCatalogList{$DynamicFieldName}->{$ID},
                    \$DynamicFieldName2ID{$DynamicFieldName},
                    \$ID,
                ],
            );
        }
    }

    # delete the entries for criticality and impact from general catalog
    for my $Class (qw(ITSM::Core::Criticality ITSM::Core::Impact)) {
        $Self->{DBObject}->Do(
            SQL  => 'DELETE FROM general_catalog WHERE general_catalog_class = ?',
            Bind => [ \$Class ],
        );
    }

    # migrate service table from criticality_id to criticality
    for my $CriticalityID ( sort keys %{ $GeneralCatalogList{ITSMCriticality} } ) {

        $Self->{DBObject}->Do(
            SQL => 'UPDATE service
                SET criticality = ?
                WHERE criticality_id = ?',
            Bind => [
                \$GeneralCatalogList{ITSMCriticality}->{$CriticalityID},
                \$CriticalityID,
            ],
        );
    }

    # migrate cip_allocate table from criticality_id to criticality
    for my $CriticalityID ( sort keys %{ $GeneralCatalogList{ITSMCriticality} } ) {

        $Self->{DBObject}->Do(
            SQL => 'UPDATE cip_allocate
                SET criticality = ?
                WHERE criticality_id = ?',
            Bind => [
                \$GeneralCatalogList{ITSMCriticality}->{$CriticalityID},
                \$CriticalityID,
            ],
        );
    }

    # migrate cip_allocate table from impact_id to impact
    for my $ImpactID ( sort keys %{ $GeneralCatalogList{ITSMImpact} } ) {

        $Self->{DBObject}->Do(
            SQL => 'UPDATE cip_allocate
                SET impact = ?
                WHERE impact_id = ?',
            Bind => [
                \$GeneralCatalogList{ITSMImpact}->{$ImpactID},
                \$ImpactID,
            ],
        );
    }

    # drop migrated columns
    my @Drop = $Self->{DBObject}->SQLProcessor(
        Database => [

            # drop column criticality_id from service table
            {
                Tag     => 'TableAlter',
                Name    => 'service',
                TagType => 'Start',
            },
            {
                Tag     => 'ColumnDrop',
                Name    => 'criticality_id',
                TagType => 'Start',
            },
            {
                Tag     => 'TableAlter',
                TagType => 'End',
            },

            # drop column criticality_id from cip_allocate table
            {
                Tag     => 'TableAlter',
                Name    => 'cip_allocate',
                TagType => 'Start',
            },
            {
                Tag     => 'ColumnDrop',
                Name    => 'criticality_id',
                TagType => 'Start',
            },
            {
                Tag     => 'TableAlter',
                TagType => 'End',
            },

            # drop column impact_id from cip_allocate table
            {
                Tag     => 'TableAlter',
                Name    => 'cip_allocate',
                TagType => 'Start',
            },
            {
                Tag     => 'ColumnDrop',
                Name    => 'impact_id',
                TagType => 'Start',
            },
            {
                Tag     => 'TableAlter',
                TagType => 'End',
            },
        ],
    );

    for my $SQL (@Drop) {
        $Self->{DBObject}->Do(
            SQL => $SQL,
        );
    }

    return 1;
}

=item _SetPreferences()

    my $Result = $CodeObject->_SetPreferences()

=cut

sub _SetPreferences {
    my $Self = shift;

    my %Map = (
        Operational => 'operational',
        Warning     => 'warning',
        Incident    => 'incident',
    );

    NAME:
    for my $Name ( sort keys %Map ) {

        my $Item = $Self->{GeneralCatalogObject}->ItemGet(
            Name  => $Name,
            Class => 'ITSM::Core::IncidentState',
        );

        next NAME if !$Item;

        $Self->{GeneralCatalogObject}->GeneralCatalogPreferencesSet(
            ItemID => $Item->{ItemID},
            Key    => 'Functionality',
            Value  => $Map{$Name},
        );
    }
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

    # get the dynamic fields for ITSMCriticality and ITSMImpact
    my $DynamicFieldConfigArrayRef = $Self->{DynamicFieldObject}->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => ['Ticket'],
        FieldFilter => {
            ITSMCriticality => 1,
            ITSMImpact      => 1,
        },
    );

    # get the dynamic field value for ITSMCriticality and ITSMImpact
    my %PossibleValues;
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{$DynamicFieldConfigArrayRef} ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        # get PossibleValues
        $PossibleValues{ $DynamicFieldConfig->{Name} }
            = $DynamicFieldConfig->{Config}->{PossibleValues} || {};
    }

    # get the criticality list
    my %CriticalityList = %{ $PossibleValues{ITSMCriticality} };

    # get the impact list
    my %ImpactList = %{ $PossibleValues{ITSMImpact} };

    # get priority list
    my %PriorityList = $Self->{PriorityObject}->PriorityList(
        UserID => 1,
    );
    my %PriorityListReverse = reverse %PriorityList;

    # create the allocation matrix
    my %AllocationMatrix;
    IMPACT:
    for my $Impact ( sort keys %Allocation ) {

        next IMPACT if !$ImpactList{$Impact};

        CRITICALITY:
        for my $Criticality ( sort keys %{ $Allocation{$Impact} } ) {

            next CRITICALITY if !$CriticalityList{$Criticality};

            # extract priority
            my $Priority = $Allocation{$Impact}->{$Criticality};

            next CRITICALITY if !$PriorityListReverse{$Priority};

            # extract priority id
            my $PriorityID = $PriorityListReverse{$Priority};

            $AllocationMatrix{$Impact}->{$Criticality} = $PriorityID;
        }
    }

    # save the matrix
    $Self->{CIPAllocateObject}->AllocateUpdate(
        AllocateData => \%AllocationMatrix,
        UserID       => 1,
    );

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

=item _FillupEmptyServiceTypeID()

fillup empty entries in the type_id column of the service table

    my $Result = $CodeObject->_FillupEmptyServiceTypeID();

=cut

sub _FillupEmptyServiceTypeID {
    my ( $Self, %Param ) = @_;

    # get service type list
    my $ServiceTypeList = $Self->{GeneralCatalogObject}->ItemList(
        Class => 'ITSM::Service::Type',
    );

    # error handling
    if ( !$ServiceTypeList || ref $ServiceTypeList ne 'HASH' || !%{$ServiceTypeList} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't find any item in general catalog class ITSM::Service::Type!",
        );
        return;
    }

    # sort ids
    my @ServiceTypeKeyList = sort keys %{$ServiceTypeList};

    # update type_id
    return $Self->{DBObject}->Do(
        SQL => "UPDATE service
            SET type_id = ?
            WHERE type_id = 0
            OR type_id IS NULL",
        Bind => [ \$ServiceTypeKeyList[0] ],
    );
}

=item _FillupEmptyServiceCriticality()

fillup empty entries in the criticality column of the service table

    my $Result = $CodeObject->_FillupEmptyServiceCriticality();

=cut

sub _FillupEmptyServiceCriticality {
    my ( $Self, %Param ) = @_;

    # get the dynamic fields for ITSMCriticality
    my $DynamicFieldConfigArrayRef = $Self->{DynamicFieldObject}->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => ['Ticket'],
        FieldFilter => {
            ITSMCriticality => 1,
        },
    );

    # get the dynamic field value for ITSMCriticality and ITSMImpact
    my %PossibleValues;
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{$DynamicFieldConfigArrayRef} ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        # get PossibleValues
        $PossibleValues{ $DynamicFieldConfig->{Name} }
            = $DynamicFieldConfig->{Config}->{PossibleValues} || {};
    }

    # get the criticality list
    my @CriticalityKeyList = sort keys %{ $PossibleValues{ITSMCriticality} };

    # error handling
    if ( !@CriticalityKeyList ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message =>
                "Can't find any possible values for ITSMCriticality in dynamic field configuration!",
        );
        return;
    }

    # update criticality with the first criticality entry
    return $Self->{DBObject}->Do(
        SQL => "UPDATE service
            SET criticality = ?
            WHERE criticality = ''
            OR criticality IS NULL",
        Bind => [ \$CriticalityKeyList[0] ],
    );
}

=item _FillupEmptySLATypeID()

fillup empty entries in the type_id column of the sla table

    my $Result = $CodeObject->_FillupEmptySLATypeID();

=cut

sub _FillupEmptySLATypeID {
    my ( $Self, %Param ) = @_;

    # get sla type list
    my $SLATypeList = $Self->{GeneralCatalogObject}->ItemList(
        Class => 'ITSM::SLA::Type',
    );

    # error handling
    if ( !$SLATypeList || ref $SLATypeList ne 'HASH' || !%{$SLATypeList} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't find any item in general catalog class ITSM::SLA::Type!",
        );
        return;
    }

    # sort ids
    my @SLATypeKeyList = sort keys %{$SLATypeList};

    # update type_id
    return $Self->{DBObject}->Do(
        SQL => "UPDATE sla
            SET type_id = ?
            WHERE type_id = 0
            OR type_id IS NULL",
        Bind => [ \$SLATypeKeyList[0] ],
    );
}

=item _MakeDynamicFieldsInternal()

Converts the dynamic fields to internal fields, which means that they can not be deleted in the admin interface.

    my $Result = $CodeObject->_MakeDynamicFieldsInternal();

=cut

sub _MakeDynamicFieldsInternal {
    my ( $Self, %Param ) = @_;

    # get the definition for all dynamic fields for ITSM
    my @DynamicFields = $Self->_GetITSMDynamicFieldsDefinition();

    for my $DynamicField (@DynamicFields) {

        # set as internal field
        $Self->{DBObject}->Do(
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

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
