# --
# --
package Kernel::System::Ticket::Event::NotificationEvent::Transport::SmsNotifyGateways::IurdKaizala;

use utf8;
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

    $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'info',
                Message  => "IURD KAIZALA REQUEST: 2",
            );

	# get sms data
	my %Gateway = %{ $Param{Gateway} };
	
	my $ua   = LWP::UserAgent->new;

	my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
	my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Param{TicketID},
        DynamicFields => 1,
        UserID        => 1,
    );

	for my $Needed (qw(TicketNumber DynamicField_KaizalaID DynamicField_KaizalaPhone)){
        if(!$Ticket{$Needed}) {
			
            return;
        } 
		
    }

	my @ArticleIDs = $TicketObject->ArticleIndex(
        TicketID => $Param{TicketID},
    );

    my %Article = $TicketObject->ArticleGet(
        ArticleID     => @ArticleIDs[scalar(@ArticleIDs)-1],
        UserID        => 1,
    );

	my %Data;
	$Data{idKaizala} = $Ticket{DynamicField_KaizalaID};
	$Data{idObjeto}   = $Ticket{TicketNumber};
	$Data{telefoneKaizala}  = $Ticket{DynamicField_KaizalaPhone};
	$Data{Mensagem}  = encode('UTF8', $Article{Body});
	$Data{Usuario}  = $Gateway{user};
	$Data{Senha}  = $Gateway{password};
	
	my $jsonData = $Kernel::OM->Get('Kernel::System::JSON')->Encode(
        Data => \%Data,
    );

    $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'info',
                Message  => "IURD KAIZALA REQUEST: ".$jsonData,
            );

	$ua->default_header("Content-Type" => "application/json");
	$ua->default_header("Accept" => "application/json");

	my $response = $ua->post($Gateway{URL}, Content_Type => 'application/json', Content => $jsonData);

    $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'info',
                Message  => "IURD KAIZALA RESPONSE: ".$response->{_content},
            );

	my $ResponseData = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
        Data => $response->{_content},
    );

	if($ResponseData->{error} && $ResponseData->{error}->{code} ne ""){
		$Kernel::OM->Get('Kernel::System::Log')->Log(
			 Priority => 'error',
			 Message  => "Error on sending message: $ResponseData->{error}->{message}. Code: $ResponseData->{error}->{code} ",
		);
		return 0;
	} else {
		return 1;
	}

}

1;
