# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package var::packagesetup::LinkedTicketsCount;

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

    $Self->_CreateDynamicFields();
	# $Self->_UpdateConfig();
    # $Self->_CreateACLs();

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

    # my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
    #
    # # define the enabled dynamic fields for each screen
    # my %ScreenDynamicFieldConfig = (
    #     AgentTicketEmail => {
    #         ArticleAttachmentPermissions   => 1,
    #     },
    #     AgentTicketPhone => {
    #         ArticleAttachmentPermissions   => 1,
    #     },
    #     AgentTicketNote => {
    #         ArticleAttachmentPermissions   => 1,
    #     },
    # );
    #
    # for my $Screen ( sort keys %ScreenDynamicFieldConfig ) {
    #
    #     # get existing config for each screen
    #     my $Config = $Kernel::OM->Get('Kernel::Config')->Get("Ticket::Frontend::$Screen");
    #
    #     # get existing dynamic field config
    #     my %ExistingSetting = %{ $Config->{DynamicField} || {} };
    #
    #     # add the new settings
    #     my %NewSetting = ( %ExistingSetting, %{ $ScreenDynamicFieldConfig{$Screen} } );
    #
    #     # update the sysconfig
    #     my $Success = $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemUpdate(
    #         Valid => 1,
    #         Key   => 'Ticket::Frontend::' . $Screen . '###DynamicField',
    #         Value => \%NewSetting,
    #     );
    # }

    return 1;
}

sub _CreateACLs {
    # my $ACLObject = $Kernel::OM->Get('Kernel::System::ACL::DB::ACL');
    #
    # my $ID = $ACLObject->ACLAdd(
    #       Name           => 'A00200 - Attachment Permission Disabled',           # mandatory
    #       Comment        => '',            # optional
    #       Description    => '',        # optional
    #       StopAfterMatch => 0,                    # optional
    #       ConfigMatch    => {
    #           Properties => {}
    #       },  # optional
    #       ConfigChange   => {
    #           PossibleNot => {
    #               Ticket => {
    #                   DynamicField_ArticleAttachmentPermissions => [
    #                     '[RegExp]^'
    #                   ]
    #               }
    #           }
    #       }, # optional
    #       ValidID        => 1,                    # mandatory
    #       UserID         => 1,                  # mandatory
    #   );
    #
    #   $ID = $ACLObject->ACLAdd(
    #         Name           => 'A00210 - Enables attachment permission',           # mandatory
    #         Comment        => '',            # optional
    #         Description    => '',        # optional
    #         StopAfterMatch => 0,                    # optional
    #         ConfigMatch    => {
    #             Properties => {
    #                 Frontend => {
    #                     Action => ['AgentTicketPhone']
    #                 },
    #                 Ticket => {
    #                     Type => ['Incident']
    #                 }
    #             }
    #         },  # optional
    #         ConfigChange   => {
    #             PossibleAdd => {
    #                 Ticket => {
    #                     DynamicField_ArticleAttachmentPermissions => [
    #                       '[RegExp]^'
    #                     ]
    #                 }
    #             }
    #         }, # optional
    #         ValidID        => 2,                    # mandatory
    #         UserID         => 1,                  # mandatory
    #     );

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
            Name       => 'LinkedTicketsCount',
            Label      => 'Linked Tickets Count',
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            Config     => {
                Link               => '',
            },
        },
        {
            Name       => 'LinkedTicketsList',
            Label      => 'Linked Tickets',
            FieldType  => 'TextArea',
            ObjectType => 'Ticket',
            Config     => {
                Link               => '',
            },
        },
    );

    return @DynamicFields;
}