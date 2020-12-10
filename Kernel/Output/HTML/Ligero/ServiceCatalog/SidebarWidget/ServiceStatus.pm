# --
# Copyright (C) 2001-2016 Complemento - Liberdade e Tecnologia http://www.complemento.net.br
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::Ligero::ServiceCatalog::SidebarWidget::ServiceStatus;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::Output::HTML::Layout',
    'Kernel::Language',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );
    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject         = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
    my $GeneralCatalogObject = $Kernel::OM->Get('Kernel::System::GeneralCatalog');
    my $ConfigItemObject     = $Kernel::OM->Get('Kernel::System::ITSMConfigItem');
	
    my $ServiceID = $Param{GetParam}->{ServiceID}||'';
    my $DefaultServiceID = $Param{GetParam}->{DefaultServiceID}||'';

    # Se não tiver Service ID (ou seja, não é pagina principal do catalogo), retorna)
    if($ServiceID && ($ServiceID ne $DefaultServiceID)){
        return '';
    }
	
    my $ParamConfig = $Param{ConfigItem};
    my $Limit = $ParamConfig->{Limit};

    my $itemObj           = $GeneralCatalogObject->ItemGet( Class => 'ITSM::ConfigItem::Class', Name => 'PortalService' );
    my $ConfigItemListRef = $ConfigItemObject->ConfigItemResultList(
        ClassID => $itemObj->{ItemID}
    );
    if (!(scalar @{$ConfigItemListRef})) {
        return '';
    }
    foreach my $ci (@{$ConfigItemListRef} ) {
        my %Preferences = $GeneralCatalogObject->GeneralCatalogPreferencesGet( ItemID => $ci->{CurDeplStateID} );
        #my $VersionRef = $ConfigItemObject->VersionGet( VersionID => $ci->{LastVersionID} );
        $LayoutObject->Block(
            Name => "Service",
            Data  => {
                Name      => $ci->{Name},
                DelpState => $ci->{CurDeplState},
                Color     => $Preferences{Color} || 'FFFFFF',
                Icon      => $Preferences{Icon} || 'fa-cogs'
            }
        );
    }
    my $Output = $LayoutObject->Output(
        TemplateFile => 'Ligero/ServiceCatalog/Sidebar/ServiceStatus',
    );
    return $Output;
}

1;
