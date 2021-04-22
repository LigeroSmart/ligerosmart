# --
# Copyright (C) 2001-2016 Complemento - Liberdade e Tecnologia http://www.complemento.net.br
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::Ligero::ServiceCatalog::SidebarWidget::FaqAlerts;

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
	
	my $ServiceID = $Param{GetParam}->{ServiceID}||'';
	my $DefaultServiceID = $Param{GetParam}->{DefaultServiceID}||'';
	
	# Se não tiver Service ID (ou seja, não é pagina principal do catalogo), retorna)
	if($ServiceID && ($ServiceID ne $DefaultServiceID)){
		return '';
	}
	
	my $ParamConfig = $Param{ConfigItem};
	my $Category = $ParamConfig->{Category};
    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $FAQObject = $Kernel::OM->Get("Kernel::System::FAQ");

	# Get all Languages from Config
    my %FaqLanguages = reverse $FAQObject->LanguageList(
        UserID => 1,
    );

    my $CategoryIDArrayRef = $FAQObject->CategorySearch(
        Name        => $Category,
        UserID      => $Param{UserID},
    );

	return if ! scalar @{$CategoryIDArrayRef};

	my $CategoryID = @{$CategoryIDArrayRef}[0];
	
	my @IDs = $FAQObject->FAQSearch(
		CategoryIDs => ["$CategoryID"],
        UserID    => 1,
        LanguageIDs => [$FaqLanguages{$ENV{UserLanguage}}],
		States => {
			2 => 'external',
			3 => 'public',
		},
	);
	
	# Se não encontrou nada, retorna
	if(!(scalar @IDs>0)){
		return '';
	}

	my $Output='';
	foreach my $FaqID (@IDs){
		my %FAQ = $FAQObject->FAQGet(
			ItemID => $FaqID,
			UserID	=> $Param{UserID},
		);
		$LayoutObject->Block(
			Name => "Alert",
			Data  => \%FAQ
		);
	}
	
    $Output = $LayoutObject->Output(
        TemplateFile => 'Ligero/ServiceCatalog/Sidebar/FaqAlerts',
    );
    return $Output;
}

1;
