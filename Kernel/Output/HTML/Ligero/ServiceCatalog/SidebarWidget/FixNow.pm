# --
# Copyright (C) 2001-2016 Complemento - Liberdade e Tecnologia http://www.complemento.net.br
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::Ligero::ServiceCatalog::SidebarWidget::FixNow;

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
	

	my $ServiceID = $Param{GetParam}->{ServiceID}||'';
	my $DefaultServiceID = $Param{GetParam}->{DefaultServiceID}||'';
	
	# Se não tiver Service ID (ou seja, não é pagina principal do catalogo), retorna)
	if(!$ServiceID || ($ServiceID eq $DefaultServiceID)){
		return '';
	}

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $FAQObject = $Kernel::OM->Get("Kernel::System::FAQ");

    # link tickets
    my $Links = $Kernel::OM->Get('Kernel::System::LinkObject')->LinkList(
        Object => 'Service',
        Object2 => 'FAQ',
        Key    => $Param{GetParam}->{ServiceID},
        State  => 'Valid',
        Type   => 'FixNow',
        UserID => 1,
    );

	# Se não encontrar, retorna
    if (!$Links->{FAQ}){
		return '';
    }
	
	my $Output='';

        return '' if (ref(@{$Links->{FAQ}->{FixNow}->{Source}}) ne 'ARRAY');
	my @FaqIDs = keys @{$Links->{FAQ}->{FixNow}->{Source}} || return '';
	foreach my $FaqID (@FaqIDs){
		my %FAQ = $FAQObject->FAQGet(
			ItemID => $FaqID,
			UserID	=> $Param{UserID},
		);
		
		next if($FAQ{Language} ne $ENV{UserLanguage});
        next if($FAQ{Valid} ne 'valid');
        
		$LayoutObject->Block(
			Name => "Alert",
			Data  => \%FAQ
		);
	}
	
    $Output = $LayoutObject->Output(
        TemplateFile => 'Ligero/ServiceCatalog/Sidebar/FixNow',
    );
    return $Output;
}

1;
