# --
# Copyright (C) 2011 - 2017 Complemento - Liberdade e Tecnologia http://www.complemento.net.br
# --
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::OutputFilterCustomFields::OutputFilterCustomFields;

use strict;
use warnings;
use utf8;

use List::Util qw(first);
use HTTP::Status qw(:constants :is status_message);
use Kernel::System::Encode;
use Kernel::System::DB;
use Kernel::System::CustomerUser;
use Kernel::System::CustomerCompany;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects

    $Self->{UserID} = $Param{UserID};
	$Self->{DynamicFieldBackend} =  $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
	$Self->{DynamicField} =  $Kernel::OM->Get('Kernel::System::DynamicField');
	$Self->{CustomerUserObject}  = $Kernel::OM->Get('Kernel::System::CustomerUser');
	$Self->{CustomerCompanyObject} = $Kernel::OM->Get('Kernel::System::CustomerCompany');

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;
	my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout'); 
	if(${ $Param{Data}} !~ /id=\"ArticleItems\"/ ){
		return;
	}
	my $StringStart = $LayoutObject->{LanguageObject}->Translate('Start');
	my $StringEnd = $LayoutObject->{LanguageObject}->Translate('End');
	${ $Param{Data}} =~ s/<i class=\"fa fa-paperclip\"><\/i>\s*<\/a>\s*<\/th>\s*<\/tr>/<i class=\"fa fa-paperclip\"><\/i><\/a><\/th><th class=\"Start Sortable\"><a href=\"#\">$StringStart <\/a><\/th> <th class=\"End Sortable\"><a href=\"#\">$StringEnd <\/a><\/th> <\/tr>/g;
	my %Data = ();
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
   
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
   # Mostra widget central com iframe da pagina
	my $iFrame = $LayoutObject->Output(
   		TemplateFile => 'ShowCustomFields',
	        Data         => \%Data,
    	);
	   ${ $Param{Data} } .= $iFrame ;
 
}
1;

