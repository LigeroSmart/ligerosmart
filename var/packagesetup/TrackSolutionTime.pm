# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package var::packagesetup::TrackSolutionTime;

use strict;
use warnings;

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

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}


sub CodeInstall {
    my ( $Self, %Param ) = @_;

	$Self->_UpdateConfig();
    $Self->_CreateDynamicFields();

    return 1;
}

sub CodeUpgrade {
    my ( $Self, %Param ) = @_;

	$Self->_UpdateConfig();
    $Self->_CreateDynamicFields();

    return 1;
}

sub _UpdateConfig {
    my ( $Self, %Param ) = @_;

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    return 1;
}

sub _CreateDynamicFields {
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

    return 1;
}


sub _GetITSMDynamicFieldsDefinition {
    my ( $Self, %Param ) = @_;

    # define all dynamic fields for ITSM
    my @DynamicFields = (
        {
            Name       => 'SolutionTime',
            Label      => 'Solution Time',
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            Config     => {
                DefaultValue   => '',
            },
        },
        {
            Name       => 'DeltaResponseTime',
            Label      => 'Delta Response Time',
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            Config     => {
                DefaultValue   => '',
            },
        },
        {
            Name       => 'IsSolutionTimeSLAStoppedCalculated',
            Label      => 'Is Solution Time SLA Stopped Calculated',
            FieldType  => 'Checkbox',
            ObjectType => 'Ticket',
            Config     => {
                DefaultValue   => '',
            },
        },
        {
            Name       => 'TotalTime',
            Label      => 'Total Time',
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            Config     => {
                DefaultValue   => '',
            },
        },
        {
            Name       => 'TotalResponseTime',
            Label      => 'Total Response Time',
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            Config     => {
                DefaultValue   => '',
            },
        },
        {
            Name       => 'PercentualScaleSLA',
            Label      => 'Percentual Scale SLA',
            FieldType  => 'Dropdown',
            ObjectType => 'Ticket',
            Config     => {
                DefaultValue   => '',
                Translatable   => 1,
                PossibleValues => {
                    '0-10' => '0 a 10%',
                    '10-20'  => '10 a 20%',
                    '20-30'  => '20 a 30%',
                    '30-40'  => '30 a 40%',
                    '40-50'  => '40 a 50%',
                    '50-60'  => '50 a 60%',
                    '60-70'  => '60 a 70%',
                    '70-80'  => '70 a 80%',
                    '80-90'  => '80 a 90%',
                    '90-101'  => '90 a 100%',
                    '>100'  => '> 100%',
                }
            },
        },
        {
            Name       => 'PercentualScaleResponseTime',
            Label      => 'Percentual Scale Response Time',
            FieldType  => 'Dropdown',
            ObjectType => 'Ticket',
            Config     => {
                DefaultValue   => '',
                Translatable   => 1,
                PossibleValues => {
                    '0-10' => '0 a 10%',
                    '10-20'  => '10 a 20%',
                    '20-30'  => '20 a 30%',
                    '30-40'  => '30 a 40%',
                    '40-50'  => '40 a 50%',
                    '50-60'  => '50 a 60%',
                    '60-70'  => '60 a 70%',
                    '70-80'  => '70 a 80%',
                    '80-90'  => '80 a 90%',
                    '90-101'  => '90 a 100%',
                    '>100'  => '> 100%',
                }
            },
        },
    );

    return @DynamicFields;
}