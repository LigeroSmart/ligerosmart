# --
# Kernel/System/PostMaster/Filter/NewTicketOnlyFromKnowEmail.pm - sub part of PostMaster.pm
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::PostMaster::Filter::NewTicketOnlyFromKnowEmail;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Email',   
    'Kernel::System::EmailParser',   
    'Kernel::System::Log',
    'Kernel::System::CustomerUser',
    'Kernel::System::Ticket',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );
	
	# get parser object
    $Self->{ParserObject} = $Param{ParserObject} || die "Got no ParserObject!";

    $Self->{Debug} = $Param{Debug} || 0;

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(JobConfig GetParam)) {
        if ( !$Param{$_} ) {
             $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }
	
    # get config options
    my %Config;
    my %Match;
    my %Set;
    if ( $Param{JobConfig} && ref $Param{JobConfig} eq 'HASH' ) {
        %Config = %{ $Param{JobConfig} };
        if ( $Config{Match} ) {
            %Match = %{ $Config{Match} };
        }
        if ( $Config{Set} ) {
            %Set = %{ $Config{Set} };			
        }
    }    
	
    # get sender email
    my @EmailAddresses = $Self->{ParserObject}->SplitAddressLine( Line => $Param{GetParam}->{From}, );
	
    for (@EmailAddresses) {
        $Param{GetParam}->{SenderEmailAddress} = $Self->{ParserObject}->GetEmailAddress( Email => $_, );
    }

    my %List = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerSearch(
        PostMasterSearch => lc( $Param{GetParam}->{SenderEmailAddress} ),
    );
    my %CustomerData;
    for ( keys %List ) {
        %CustomerData = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
            User => $_,
        );
    }

    # if there is no customer id found!
    if ( !$CustomerData{UserLogin} ) {
	# RETURN IF NO CUSTOMER ID
	$Kernel::OM->Get('Kernel::System::Log')->Log( Priority => 'info', Message => "$_ not in database ". $Param{GetParam}->{SenderEmailAddress} );

		# get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');		
		
        # check if new ticket
        my $Tn = $TicketObject->GetTNByString( $Param{GetParam}->{Subject} );
		
        return 1 if $Tn && $TicketObject->TicketCheckNumber( Tn => $Tn );

        # set attributes if ticket is created
        for ( keys %Set ) {
            $Param{GetParam}->{$_} = $Set{$_};
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'notice',
                Message =>
                    "Set param '$_' to '$Set{$_}' (Message-ID: $Param{GetParam}->{'Message-ID'}) ",
            );
        }
		
		 # get config object
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # send bounce mail
        my $Subject = $ConfigObject->Get(
            'PostMaster::PreFilterModule::NewTicketOnlyFromKnowEmail::Subject'
        );
        my $Body = $ConfigObject->Get(
            'PostMaster::PreFilterModule::NewTicketOnlyFromKnowEmail::Body'
        );
        my $Sender = $ConfigObject->Get(
            'PostMaster::PreFilterModule::NewTicketOnlyFromKnowEmail::Sender'
        ) || '';
        $Kernel::OM->Get('Kernel::System::Email')->Send(
            From       => $Sender,
            To         => $Param{GetParam}->{From},
            Subject    => $Subject,
            Body       => $Body,
            Charset    => 'utf-8',
            MimeType   => 'text/plain',
            Loop       => 1,
            Attachment => [
                {
                    Filename    => 'email.txt',
                    Content     => $Param{GetParam}->{Body},
                    ContentType => 'application/octet-stream',
                }
            ],
        );
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "Send reject mail to '$Param{GetParam}->{From}'!",
        );

    }
    return 1;
}

1;
