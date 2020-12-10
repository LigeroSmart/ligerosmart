# --
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::OutputFilterDynamicFieldByService;

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
	my %Data = ();
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
   
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    # get template name
    my $userID = $Self->{UserID};
	my %InformationCustomer =	 $Self->{CustomerUserObject}->CustomerUserDataGet(
       User => $userID,
    );
	my $FieldName = $ConfigObject->Get( 'AT::FieldName');
    my $TextTemplate = $ConfigObject->Get( 'AT::TextTemplate');
 	

	 $Data{FieldName} = $FieldName;
	 $Data{TextTemplate} = $TextTemplate;
	   # Mostra widget central com iframe da pagina
		my $iFrame = $LayoutObject->Output(
    	    TemplateFile => 'ShowDynamicFieldByService',
	        Data         => \%Data,
    	);
	   ${ $Param{Data} } .= $iFrame ;
 
}
1;

