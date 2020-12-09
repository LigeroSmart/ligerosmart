# --
# --
package Kernel::System::Ticket::Event::NotificationEvent::Transport::SmsNotifyGateways::PitchWink;


use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::CustomerUser',
    'Kernel::System::DB',
    'Kernel::System::HTMLUtils',
    'Kernel::System::JSON',
    'Kernel::System::Log',
    'Kernel::System::NotificationEvent',
    'Kernel::System::Queue',
    'Kernel::System::SystemAddress',
    'Kernel::System::TemplateGenerator',
    'Kernel::System::Ticket',
    'Kernel::System::Time',
    'Kernel::System::User',
);

use LWP;
use HTTP::Request;
use XML::Simple;
use Encode qw(decode encode);
use MIME::Base64;
use Data::Dumper;
use utf8;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

# 
sub SendSms {
	my ( $Self, %Param ) = @_;

	# get sms data
	my %Gateway = %{ $Param{Gateway} };

	# Clean MobileNumber
	my @S = ($Param{To} =~ m/(\d+)/g);
	$Param{To}=join("", @S);

	# Convert Body to pure text
	$Param{Body} = $Kernel::OM->Get('Kernel::System::HTMLUtils')->ToAscii( String => $Param{Body} );

	# Contruct the url
	# Contruct the url
	my $url=$Gateway{URL}."?";
	$url.="Credencial=$Gateway{Credencial}&Token=$Gateway{Token}&Principal_User=$Gateway{Principal_User}&";
	$url.="Aux_User=$Gateway{Aux_User}&Mobile=$Param{To}&Send_Project=$Gateway{Send_Project}&Message=$Param{Body}";

	# Send the sms
	my $ua = LWP::UserAgent->new();
	my $req = new HTTP::Request GET => $url;
	my $res = $ua->request($req);

	# Error codes from PitchWink
	# https://pitchwink.com/sms-mt-api-web-service-v3-00/#h3-2
	my %ErrorCodes = (
		"001" => "Invalid Credencial",
		"005" => "Wrong Mobile number format",
		"008" => "Message is bigger than 160 characters",
		"009" => "Insuficient credits",
		"010" => "Your SMS Gateway is not enabled. Get in touch with PitchWinky Support to enable it",
		"013" => "Invalid or empty content",
		"016" => "Invalid Mobile area code",
		"018" => "Mobile is in a Black List",
		"019" => "Invalid Token"
	);

	if ($res->content ne "000") {
		my $ErrorMessage = "Error on sending sms. Code: ".$res->content;
		if($ErrorCodes{$res->content}){
			$ErrorMessage .= " ".$ErrorCodes{$res->content};
		}
		
		$Kernel::OM->Get('Kernel::System::Log')->Log(
			Priority => 'error',
			Message  => $ErrorMessage,
		);
		
		return 0;
	} else {
		return 1;
	}
}


1;
