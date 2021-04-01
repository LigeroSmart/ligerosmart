# --
# Kernel/Modules/Sac.pm - public Sac
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::PublicChannel;

use strict;
use warnings;
use utf8;
use MIME::Base64 qw();

sub new{
	my ($Type, %Param) = @_;
	
	my $Self = {%Param};
	bless  ($Self, $Type);

	return $Self;	

}

sub Run {
	my ( $Self, %Param ) = @_;
	my $ParamObject = $Kernel::OM->Get("Kernel::System::Web::Request");
	my $ConfigObject = $Kernel::OM->Get("Kernel::Config");
	my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
	$Param{SubAction} = $ParamObject->GetParam(Param => "SubAction") || "";

	$Param{embed} = $ParamObject->GetParam(Param => "embed") || "";
	#Verifica se os requirementos mínimos para o módulo funcionar corretamente estão sendo atendidos, caso não, Pede para que o usuário configure nas config do Sistema
	my $ConfigItens = $ConfigObject->Get("PublicFrontend::PublicCreateTicketOccurrence");
	
	if($Param{SubAction} eq "Agreements"){
		# output header
		my $Output 		=   $LayoutObject->CustomerHeader();

		$Output .= $Self->_Overview(
			%Param,
			SubAction	=> "Agreements",
		
		);

		#--------------------------------------------#
		# add footer
		$Output .= $LayoutObject->CustomerFooter();
	
		return $Output;
	}

	elsif ( $Param{SubAction} eq 'STEP3' ) {
		# output header
		my $Output 		=   $LayoutObject->CustomerHeader();
		$Output .= $Self->_Overview(
      %Param,
			SubAction	=> "STEP3",
		);

		#--------------------------------------------#
		# add footer
		$Output .= $LayoutObject->CustomerFooter();
	
		return $Output;
	}else{
		# output header
		my $Output 		=   $LayoutObject->CustomerHeader();

		my $ConfigItens = $ConfigObject->Get("PublicFrontend::PublicCreateTicketOccurrence");
		$Output .= $Self->_Overview(
      %Param,
			SubAction	=> "Termos",
		);

		#--------------------------------------------#
		# add footer
		$Output .= $LayoutObject->CustomerFooter();
	
		return $Output;
	}
	
}
sub _Overview{
	my ( $Self, %Param) = @_;

	my $ParamObject = $Kernel::OM->Get("Kernel::System::Web::Request");
	my $ConfigObject = $Kernel::OM->Get("Kernel::Config");
	my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
	
	my $Output;

  my $CommonConfigItens = $ConfigObject->Get("PublicFrontend::Channel::Common");
  $Param{DefaultUrlReturn}  =  $CommonConfigItens->{'DefaultUrlReturn'} 	|| 'http://localhost/otrs/public.pl';

	if($Param{SubAction} eq "Termos"){

    my $ConfigItens = $ConfigObject->Get("PublicFrontend::Channel::Terms");
    $Param{Title}  =  $ConfigItens->{'Title'} 	|| '';
    $Param{Message}  =  $ConfigItens->{'Message'} 	|| '';

		$LayoutObject->Block(
			Name => 'Terms',
			Data => \%Param,
		);
		if($Param{Message}){
			$LayoutObject->Block(
				Name => "Information",
				Data => \%Param,
			);

		}

		$Output .= $LayoutObject->Output(
			TemplateFile => 'Channel',
			Data         => {
				%Param,
			},
		);

		
		return $Output;
	
	}elsif($Param{SubAction} eq "Agreements"){

    my $ConfigItens = $ConfigObject->Get("PublicFrontend::Channel::AgreementTerms");
    $Param{Message}  =  $ConfigItens->{'Message'} 	|| ''; 

		$LayoutObject->Block(
			Name => 'AgreementTerms',
			Data => \%Param,
		);
		$Output .= $LayoutObject->Output(
			TemplateFile => 'Channel',
			Data         => {
				%Param,
			},
		);
	
		return $Output;

	}else{
		$LayoutObject->Block(
			Name => 'Login',
			Data => \%Param,
		);
		
		if($Param{Message}){
			$LayoutObject->Block(
				Name => "Information",
				Data => \%Param,
			);

		}

		# prepare errors!
		if ( $Param{Errors} ) {
			for my $KeyError ( sort keys %{ $Param{Errors} } ) {
				$Param{$KeyError} = '* ' . $LayoutObject->Ascii2Html( Text => $Param{Errors}->{$KeyError} );
			}
		}
		$Output .= $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Output(
			TemplateFile => 'OccurrenceLogin',
			Data         => \%Param,
		);
		return $Output;

	}
}

1;
