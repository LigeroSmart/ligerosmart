# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package var::packagesetup::AccountedTime2;

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

# sub CodeUninstall {
#     my ( $Self, %Param ) = @_;

#     # get the definition for all dynamic fields for ITSM
#     my @DynamicFields = $Self->_GetITSMDynamicFieldsDefinition();
#     # create a dynamic fields lookup table
#     my %DynamicFieldLookup;
#     DYNAMICFIELD:
#     for my $DynamicField ( @{$DynamicFieldList} ) {
#         next DYNAMICFIELD if ref $DynamicField ne 'HASH';
#         my $DynamicFieldSys = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
#             Name => $DynamicField->{Name},
#         );
#         $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldDelete(
#             ID      => $DynamicFieldSys->{ID},
#             UserID  => 1,
#             Reorder => 1,               # or 0, to trigger reorder function, default 1
#         );
#     }

#     return 1;
# }


sub _GetITSMDynamicFieldsDefinition {
    my ( $Self, %Param ) = @_;

    # define all dynamic fields for ITSM
    my @DynamicFields = (
        {
            Name       => 'TaskStartTime',
            Label      => 'Task Start Time',
            FieldType  => 'DateTime',
            ObjectType => 'Article',
            Config     => {
                DateRestriction => '',
                DefaultValue => 0,
                Link => '',
                LinkPreview => '',
                YearsInFuture => '5',
                YearsInPast => '5',
                YearsPeriod => '0'
            },
        },
        {
            Name       => 'TaskStopTime',
            Label      => 'Task Stop Time',
            FieldType  => 'DateTime',
            ObjectType => 'Article',
            Config     => {
                DateRestriction => '',
                DefaultValue => 0,
                Link => '',
                LinkPreview => '',
                YearsInFuture => '5',
                YearsInPast => '5',
                YearsPeriod => '0'
            },
        },
        {
            Name       => 'TaskType',
            Label      => 'Task Type',
            FieldType  => 'Dropdown',
            ObjectType => 'Article',
            Config     => {
                DefaultValue => '',
                PossibleNone => 1,
                TranslatableValues => 1,
                PossibleValues => {
                    'Follow Up' => 'Follow Up',
                    'Face-to-face Support' => 'Face-to-face Support',
                    'Remote Support' => 'Remote Support',
                    'Development' => 'Development',
                    'Travel Time' => 'Travel Time',
                    'Internal Activities' => 'Internal Activities',
                }
            },
        },
        {
            Name       => 'AccreditTime',
            Label      => 'Accredit Time',
            FieldType  => 'DateTime',
            ObjectType => 'Article',
            Config     => {
            },
        },
    );

    return @DynamicFields;
}
