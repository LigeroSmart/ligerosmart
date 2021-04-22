# --
# Kernel/Output/HTML/OutputFilterMediaWiki.pm
# Copyright (C) 2011 - 2015 Complemento - Liberdade e Tecnologia http://www.complemento.net.br
# --
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::OutputFilterArticleEdit;

use strict;
use warnings;
use Kernel::System::Encode;
use Kernel::System::DB;
sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );


    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;
	if(${ $Param{Data}} !~ /id=\"ArticleItems\"/ ){
		return;
	}

	my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
	
	my %Data = ();

	$Data{TicketID} = $ParamObject->GetParam( Param => 'TicketID' );
	
    # get template name
    #~ my $userID = $Self->{UserID};

	#~ $Data{HTML} = $userID;
	#~ $Data{HTML} = $userID;

	my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

	my $iFrame = $LayoutObject->Output(
		TemplateFile => 'ShowArticleEditOption',
		Data         => \%Data,
	);

	${ $Param{Data} } .= $iFrame ;
	
}
1;
