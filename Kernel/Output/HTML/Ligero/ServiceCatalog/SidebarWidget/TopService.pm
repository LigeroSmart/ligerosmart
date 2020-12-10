# --
# Copyright (C) 2001-2016 Complemento - Liberdade e Tecnologia http://www.complemento.net.br
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::Ligero::ServiceCatalog::SidebarWidget::TopService;

use strict;
use warnings;
use Data::Dumper;
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::LinkObject',
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

	my $ConfigObject	   = $Kernel::OM->Get("Kernel::Config");

	my $ServiceID = $Param{GetParam}->{ServiceID}||'';
	my $DefaultServiceID = $Param{GetParam}->{DefaultServiceID}||'';
	
	# Se não tiver Service ID (ou seja, não é pagina principal do catalogo), retorna)
	if(!$ServiceID || ($ServiceID eq $DefaultServiceID)){
#		return '';
	}

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
	my $Output='';
	my $TopNumber = $ConfigObject->Get("DisplayNumberOfIitems") || 5;
	$LayoutObject->Block(
		Name => "Alert",
		Data => {},
	);
		$LayoutObject->Block(
			Name => "JSAJAX",
			Data  => { DisplayTopNumber => $TopNumber, },
);	
    $Output = $LayoutObject->Output(
        TemplateFile => 'Ligero/ServiceCatalog/Sidebar/TopService',
    );
    return $Output;
}

1;
