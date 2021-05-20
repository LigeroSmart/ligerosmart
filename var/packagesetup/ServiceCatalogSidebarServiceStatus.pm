# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package var::packagesetup::ServiceCatalogSidebarServiceStatus;

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
    $Self->_CreatePortalServiceClass();
    return 1;
}

sub CodeUpgrade {
    my ( $Self, %Param ) = @_;
    $Self->_CreatePortalServiceClass();
    return 1;
}

sub _CreatePortalServiceClass {

    my $GeneralCatalogObject              = $Kernel::OM->Get('Kernel::System::GeneralCatalog');
    my $ConfigItemObject                  = $Kernel::OM->Get('Kernel::System::ITSMConfigItem');
    my $itemObj  = $GeneralCatalogObject->ItemGet( Class => 'ITSM::ConfigItem::Class', Name => 'PortalService' );
    if (!defined($itemObj)) {
        $GeneralCatalogObject->ItemAdd(
            Class      => 'ITSM::ConfigItem::Class',
            Name       => 'PortalService',
            ValidID    => 1,
            UserID     => 1
        );
        $itemObj  = $GeneralCatalogObject->ItemGet( Class => 'ITSM::ConfigItem::Class', Name => 'PortalService' );
        $GeneralCatalogObject->GeneralCatalogPreferencesSet(
            ItemID => $itemObj->{ItemID},
            Key    => 'Permission',
            Value  => 7, # itsm-configitem
        );
    }
    my $DefinitionListRef = $ConfigItemObject->DefinitionList( ClassID => $itemObj->{ItemID} );
    #if (scalar @{$DefinitionListRef} == 0) {
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
    #}

}
