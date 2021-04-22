# --
# --
package Kernel::System::Ticket::Event::NotificationEvent::Transport::SmsNotifyGateways::Zenvia;

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

sub SendSms {
	my ( $Self, %Param ) = @_;

	# get sms data
	my %Gateway = %{ $Param{Gateway} };

	# Clean MobileNumber
	my @S = ($Param{To} =~ m/(\d+)/g);
	$Param{To}=join("", @S);

	# Convert Body to pure text
	$Param{Body} = $Kernel::OM->Get('Kernel::System::HTMLUtils')->ToAscii( String => $Param{Body} );
	
	$Param{Body} = encode("utf8", $Param{Body});

	# Prepare authentication
	my $auth = encode_base64($Gateway{user}.":".$Gateway{password});
	
	my $ua   = LWP::UserAgent->new;

	my %Data;
	$Data{sendSmsRequest}->{from} = $Gateway{Sender};
	$Data{sendSmsRequest}->{to}   = $Param{To};
	$Data{sendSmsRequest}->{msg}  = $Param{Body};
	
	my $jsonData = $Kernel::OM->Get('Kernel::System::JSON')->Encode(
        Data => \%Data,
    );

	$ua->default_header("Content-Type" => "application/json");
	$ua->default_header("Authorization" => "Basic $auth");
	$ua->default_header("Accept" => "application/json");

	my $response = $ua->post($Gateway{URL}, Content_Type => 'application/json', Content => $jsonData);

	my $ResponseData = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
        Data => $response->decoded_content,
    );

	if($ResponseData->{sendSmsResponse}->{statusCode} ne "00"){
		$Kernel::OM->Get('Kernel::System::Log')->Log(
			 Priority => 'error',
			 Message  => "Error on sending sms: $ResponseData->{sendSmsResponse}->{detailDescription}",
		);
		return 0;
	} else {
		return 1;
	}

}

1;
