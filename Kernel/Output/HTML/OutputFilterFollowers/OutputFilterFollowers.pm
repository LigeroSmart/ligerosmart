# --
# Copyright (C) 2011 - 2015 Complemento - Liberdade e Tecnologia http://www.complemento.net.br
# --
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::OutputFilterFollowers::OutputFilterFollowers;

use strict;
use warnings;
require LWP::UserAgent;
use List::Util qw(first);
# COMPLEMENTO
use URI::Escape qw(uri_escape);
use Digest::MD5 qw(md5_hex);

#----------------------------------------
our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::Config',
    'Kernel::System::Ticket',
    'Kernel::System::Main',
    'Kernel::Output::HTML::Layout',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
    $Self->{UserID} = $ParamObject->GetParam( Param => 'UserID' ) ;

   

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;
	my $CustomerIDPage;
	my $ServicePage;
	my $TicketPage;
	my %Data = ();
    # get template name
    my $Templatename = $Param{TemplateFile} || '';
 
	return 1 if !$Templatename;
    # get param object
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
	my $TicketObject = $Kernel::OM->Get("Kernel::System::Ticket");
	my $LogObject = $Kernel::OM->Get("Kernel::System::Log");
	my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');
	my $UserObject = $Kernel::OM->Get('Kernel::System::User');
	my $ConfigObject = $Kernel::OM->Get("Kernel::Config");
    # Mostra widget lateral
	my	$TicketID =  $ParamObject->GetParam( Param => 'TicketID' ) ;
	my  $DynamicField = ""; 
	#Define a class 
	#
	my $ClassCollapsed = "Expanded";
	if(uc $ConfigObject->Get("Followers::Collapsed") eq "NO"){
		$ClassCollapsed = "Collapsed";
	}
	#

	$Kernel::OM->Get('Kernel::Output::HTML::Layout')->Block(
		Name => 'BeginsFollowers',
    	Data => {
			Class_collapsed => $ClassCollapsed,
	    }
  	);

	my @Watch = $TicketObject->TicketWatchGet(
    	TicketID => $TicketID,
	    Result   => 'ARRAY',
    );
	#Parametros
    my %DataRight = ();
	
	my %DataUser;
	foreach my $id (@Watch){
		my %User = $UserObject->GetUserData(
	    	UserID => $id,
		);
		$DataUser{Name} =  $User{UserFirstname}. " " . $User{UserLastname};	
		my $Email = $User{UserEmail};
		my $Size = 20;
		my $Grav_url = "http://www.gravatar.com/avatar/".md5_hex(lc $Email)."?&s=".$Size;
		$DataUser{grav_url} = $Grav_url;			
		$Kernel::OM->Get('Kernel::Output::HTML::Layout')->Block(
       		Name => 'Followers',
	        Data => {
	           	FollowerName => $DataUser{Name},
	            FollowerID => $User{UserID},
				TicketID	=> $TicketID,
				grav_url 	=> $Grav_url,
		    }
	   	);
	}
	if(${ $Param{Data}} =~ /id=\"ArticleTree\"/  or  ${ $Param{Data}} =~ /id=\"KIXSidebarLinkedConfigItemDialog\"/){
	   	$Kernel::OM->Get('Kernel::Output::HTML::Layout')->Block(
    		Name => 'JSAJAX',
	        Data => {},
   	 	);

	}
    my  $Snippet = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Output(
	    TemplateFile => 'ShowFollowersSideBar',
        Data         => \%DataRight,
    ); 
    #scan html output and generate new html input
    my $Position = $Kernel::OM->Get('Kernel::Config')->Get( 'Followers::Position' ) || 'top';
    if ( $Position eq 'bottom' ) {
	    ${ $Param{Data} } =~ s{(</div> \s+ <div \s+ class="ContentColumn)}{ $Snippet $1 }xms;
    }
    else {
    	${ $Param{Data} } =~ s{(<div \s+ class="SidebarColumn">)}{$1 $Snippet}xsm;
    }


 #   # END Show right Widget
	#----------------------------------------------------------------------------------------------------------------------#



}

1;