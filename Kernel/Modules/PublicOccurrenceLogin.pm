# --
# Kernel/Modules/PublicOccurrenceLogin.pm - public OccurrenceLogin
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::PublicOccurrenceLogin;

use strict;
use warnings;
use utf8;

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
	
	# output header
	my $Output 		=   $LayoutObject->CustomerHeader();

	$Output .= $Self->_Overview(
		%Param,
	);

	#--------------------------------------------#
	# add footer
	$Output .= $LayoutObject->CustomerFooter();

	return $Output;
	
}
sub _Overview{
	my ( $Self, %Param) = @_;

	my $ParamObject = $Kernel::OM->Get("Kernel::System::Web::Request");
	my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
	
	my $Output;
	if($Param{SubAction} eq "OccurrenceLogin"){
		$LayoutObject->Block(
			Name => 'Login',
			Data => \%Param,
		);

		# prepare errors!
		$Output .= $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Output(
			TemplateFile => 'OccurrenceLogin',
			Data         => \%Param,
		);
		return $Output;

	}
}

1;