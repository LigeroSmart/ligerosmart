# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package var::packagesetup::QRCode;

use strict;

use Kernel::Output::Template::Provider;
use Data::Dumper;

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
    my $Self = {};
    bless( $Self, $Type );
    return $Self;
}

sub CodeInstall {
    my ( $Self, %Param ) = @_;
    $Self->_CreatePortalServiceQRCodeClass();
    $Self->_CreateDynamicFields();
    return 1;
}

sub CodeUpgrade {
    my ( $Self, %Param ) = @_;
    $Self->_CreatePortalServiceQRCodeClass();
    $Self->_CreateDynamicFields();
    return 1;
}

sub _CreatePortalServiceQRCodeClass {

    my $GeneralCatalogObject              = $Kernel::OM->Get('Kernel::System::GeneralCatalog');
    my $ConfigItemObject                  = $Kernel::OM->Get('Kernel::System::ITSMConfigItem');

    my $HashRef = $GeneralCatalogObject->ItemList( Class => 'ITSM::ConfigItem::Class', Valid => 1 );
    my $itemObj = undef;
    foreach my $ItemID ( keys %{ $HashRef }) {
        if ( $HashRef->{$ItemID} eq "PortalServiceQRCode" ) {
            $itemObj = { ItemID => $ItemID };
        }
    }
    if (!defined($itemObj)) {
        $GeneralCatalogObject->ItemAdd(
            Class      => 'ITSM::ConfigItem::Class',
            Name       => 'PortalServiceQRCode',
            ValidID    => 1,
            UserID     => 1
        );
        $itemObj  = $GeneralCatalogObject->ItemGet( Class => 'ITSM::ConfigItem::Class', Name => 'PortalServiceQRCode' );
        $GeneralCatalogObject->GeneralCatalogPreferencesSet(
            ItemID => $itemObj->{ItemID},
            Key    => 'Permission',
            Value  => 7, # itsm-configitem
        );
    }
    my $DefinitionListRef = $ConfigItemObject->DefinitionList( ClassID => $itemObj->{ItemID} );
    if (scalar @{$DefinitionListRef} == 0) {
        $ConfigItemObject->DefinitionAdd(
            ClassID    => $itemObj->{ItemID},
            UserID     => 1,
            #Definition => "[{ Key => 'Icon', Name => Translatable('Icon'), Searchable => 0, Input => { Type => 'Text', Size => 50, MaxLength => 50, Required => 1 } }]"
            Definition => "---
- Key: Observation
  Name: Observation
  Searchable: 1
  Input:
    Type: Text
    Size: 50
    MaxLength: 50"
        );
    }

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
            Name       => 'QRCodeItem',
            Label      => 'QRCode Item',
            FieldType  => 'ITSMConfigItemReference',
            ObjectType => 'Ticket',
            Config     => {
                AgentLink => '',
                Constrictions => '',
                CustomerLink => '',
                DefaultValues => [],
                DeploymentStates => ['32'],
                DisplayPattern => '<CI_Name>',
                ITSMConfigItemClasses => ['22',],
                ItemSeparator => ', ',
                MaxArraySize => '1',
                MaxQueryResult => '10',
                MinQueryLength => '3',
                QueryDelay => '300',
            },
        },
    );

    return @DynamicFields;
}
