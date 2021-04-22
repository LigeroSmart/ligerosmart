# --
# --
package Kernel::System::Ticket::Event::NotificationEvent::Transport::SmsNotifyGateways::SmsGatewayUltimate;

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
use Encode;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub SendSms {
	my ( $Self, %Param ) = @_;
	
	# get sms data
	my %Gateway = %{ $Param{Gateway} };

	# Convert Body to pure text
	$Param{Body} = $Kernel::OM->Get('Kernel::System::HTMLUtils')->ToAscii( String => $Param{Body} );

	# Contruct the url
	my $url=$Gateway{protocol}."://";
	$url.="$Gateway{user}:$Gateway{password}".'@';
	$url.=$Gateway{Host}.":".$Gateway{Port}."/send.html?";
	$url.="smsto=$Param{To}&smsbody=$Param{Body}&smstype=sms";
        
	# Send the sms
	my $ua = LWP::UserAgent->new();
	my $req;
	
	$req = new HTTP::Request GET => $url;
	
	my $res = $ua->request($req);

	if ($res->content =~ m/^ERR:/) {
		$Kernel::OM->Get('Kernel::System::Log')->Log(
			 Priority => 'error',
			 Message  => "Error on sending sms. Code: ".$res->content,
		);
		return 0;
	} else {
		return 1;
	}
}

1;
