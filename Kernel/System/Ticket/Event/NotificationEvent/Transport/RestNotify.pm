# --
# Copyright (C) 2001-2025 Complemento, http://complemento.net.br/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::Event::NotificationEvent::Transport::RestNotify;

use strict;
use warnings;

use HTTP::Request;
use LWP::UserAgent;
use JSON::PP;
use Kernel::System::VariableCheck qw(:all);

use base qw(Kernel::System::Ticket::Event::NotificationEvent::Transport::Email);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Ticket',
    'Kernel::System::User',
    'Kernel::System::CustomerUser',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::Web::Request',
    'Kernel::System::Scheduler',
);

sub SendNotification {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(TicketID UserID Notification Recipient)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # cleanup event data
    $Self->{EventData} = undef;

    my %Notification = %{ $Param{Notification} };

    return if !$Param{Notification}->{Data}->{RecipientEndpoint};

    # send notification
    my $Sent = $Self->_ScheduleMessage(
        Subject          => $Notification{Subject},
        Body            => $Notification{Body},
        Endpoint        => $Param{Notification}->{Data}->{RecipientEndpoint}->[0],
        Headers         => $Param{Notification}->{Data}->{RecipientHeaders}->[0] || '{}',
        Payload         => $Param{Notification}->{Data}->{RecipientPayload}->[0] || '{}',
        Method         => $Param{Notification}->{Data}->{RecipientMethod}->[0] || 'POST',
        TicketID       => $Param{TicketID},
    );

    if ( !$Sent ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "'$Notification{Name}' notification could not be sent via REST API",
        );
        return;
    }

    # log event
    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'info',
        Message  => "Sent '$Notification{Name}' notification via REST API.",
    );

    return 1;
}

sub _ScheduleMessage {
    my ( $Self, %Param ) = @_;

    # For Asynchronous sending
    my $TaskName = substr "RestNotify".rand().$Param{Endpoint}, 0, 255;

    # create a new task
    my $TaskID = $Kernel::OM->Get('Kernel::System::Scheduler')->TaskAdd(
        Type                     => 'AsynchronousExecutor',
        Name                     => $TaskName,
        Attempts                 => 1,
        MaximumParallelInstances => 0,
        Data                     => {
            Object   => 'Kernel::System::Ticket::Event::NotificationEvent::Transport::RestNotify',
            Function => 'SendRestMessage',
            Params   => {
                Endpoint        => $Param{Endpoint},
                Headers         => $Param{Headers},
                Payload         => $Param{Payload},
                Method         => $Param{Method},
                Subject         => $Param{Subject},
                Body           => $Param{Body},
                TicketID       => $Param{TicketID},
            },
        },
    );

    return $TaskID;
}

sub SendRestMessage {
    my ( $Self, %Param ) = @_;

    # Get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # Get ticket data for tag replacement
    my %Ticket = $TicketObject->TicketGet(
        TicketID => $Param{TicketID},
        UserID   => 1,
    );

    # Replace OTRS tags in endpoint
    my $Endpoint = $Self->_ReplaceTicketAttributes(
        Ticket => \%Ticket,
        Field  => $Param{Endpoint},
    );

    # Process headers
    my $HeadersRef;
    eval {
        $HeadersRef = decode_json($Param{Headers});
    };
    if ($@) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Invalid JSON in headers configuration: $@",
        );
        return;
    }

    # Replace OTRS tags in headers
    for my $Key (keys %$HeadersRef) {
        $HeadersRef->{$Key} = $Self->_ReplaceTicketAttributes(
            Ticket => \%Ticket,
            Field  => $HeadersRef->{$Key},
        );
    }

    # Process payload
    my $PayloadRef;
    eval {
        $PayloadRef = decode_json($Param{Payload});
    };
    if ($@) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Invalid JSON in payload configuration: $@",
        );
        return;
    }

    # Replace OTRS tags in payload
    $Self->_ReplacePayloadAttributes(
        Ticket  => \%Ticket,
        Payload => $PayloadRef,
    );

    # Convert payload to JSON string
    my $JsonPayload = encode_json($PayloadRef);

    # Create HTTP request
    my $UserAgent = LWP::UserAgent->new();
    my $Request = HTTP::Request->new($Param{Method}, $Endpoint);

    # Set headers
    $Request->header('Content-Type' => 'application/json');
    for my $Key (keys %$HeadersRef) {
        $Request->header($Key => $HeadersRef->{$Key});
    }

    # Set payload as scalar reference
    $Request->content($JsonPayload);

    # Send request
    my $Response = $UserAgent->request($Request);

    if (!$Response->is_success) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Failed to send REST notification: " . $Response->status_line . " - " . $Response->content,
        );
        return;
    }

    return 1;
}

sub _ReplacePayloadAttributes {
    my ( $Self, %Param ) = @_;

    return if !IsHashRefWithData($Param{Payload});

    for my $Key (keys %{$Param{Payload}}) {
        if (IsHashRefWithData($Param{Payload}->{$Key})) {
            $Self->_ReplacePayloadAttributes(
                Ticket  => $Param{Ticket},
                Payload => $Param{Payload}->{$Key},
            );
        }
        elsif (IsArrayRefWithData($Param{Payload}->{$Key})) {
            for my $Item (@{$Param{Payload}->{$Key}}) {
                if (IsHashRefWithData($Item)) {
                    $Self->_ReplacePayloadAttributes(
                        Ticket  => $Param{Ticket},
                        Payload => $Item,
                    );
                }
                elsif (!ref $Item) {
                    $Item = $Self->_ReplaceTicketAttributes(
                        Ticket => $Param{Ticket},
                        Field  => $Item,
                    );
                }
            }
        }
        elsif (!ref $Param{Payload}->{$Key}) {
            $Param{Payload}->{$Key} = $Self->_ReplaceTicketAttributes(
                Ticket => $Param{Ticket},
                Field  => $Param{Payload}->{$Key},
            );
        }
    }

    return;
}

sub TransportSettingsDisplayGet {
    my ( $Self, %Param ) = @_;

    # Process the fields we want to show
    for my $Key (qw(RecipientEndpoint RecipientMethod RecipientHeaders RecipientPayload)) {
        next if !$Param{Data}->{$Key};
        next if !defined $Param{Data}->{$Key}->[0];
        $Param{$Key} = $Param{Data}->{$Key}->[0];
    }

    # Set default method if not set
    $Param{RecipientMethod} //= 'POST';

    # Get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # Generate HTML
    my $Output = $LayoutObject->Output(
        TemplateFile => 'AdminNotificationEventTransportRestNotify',
        Data         => \%Param,
    );

    return $Output;
}

sub TransportParamSettingsGet {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(GetParam)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed",
            );
        }
    }

    # Get param object
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    PARAMETER:
    for my $Parameter (qw(RecipientEndpoint RecipientMethod RecipientHeaders RecipientPayload)) {
        my @Data = $ParamObject->GetArray( Param => $Parameter );
        next PARAMETER if !@Data;
        $Param{GetParam}->{Data}->{$Parameter} = \@Data;
    }

    return 1;
}

sub GetTransportRecipients {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Notification)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed",
            );
        }
    }

    my @Recipients;

    # For REST notifications, we only need one recipient to trigger the notification
    my %Recipient;
    $Recipient{Type} = 'System';
    push @Recipients, \%Recipient;

    return @Recipients;
}

1;

