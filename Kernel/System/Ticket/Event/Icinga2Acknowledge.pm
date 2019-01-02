# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Ticket::Event::Icinga2Acknowledge;

use strict;
use warnings;
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::Ticket',
    'Kernel::System::User',
    'Kernel::System::JSON',
);

use LWP::UserAgent;
use IO::Socket::SSL;
use URI::Escape qw();

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {};
    bless( $Self, $Type );

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # Get correct FreeFields.
    $Self->{Fhost}    = $ConfigObject->Get('Icinga2::Acknowledge::FreeField::Host');
    $Self->{Fservice} = $ConfigObject->Get('Icinga2::Acknowledge::FreeField::Service');

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Data Event Config)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    if ( !$Param{Data}->{TicketID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Data->{TicketID}!',
        );

        return;
    }

    # Check if acknowledge is active.
    my $Enabled = $Kernel::OM->Get('Kernel::Config')->Get('Icinga2::Acknowledge::Enabled');

    return 1 if !$Enabled;

    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # Check if it's a Icinga2 related ticket.
    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Param{Data}->{TicketID},
        DynamicFields => 1,
    );
    if ( !$Ticket{ $Self->{Fhost} } ) {

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'debug',
            Message  => 'No Icinga2 Ticket!',
        );

        return 1;
    }

    # Check if it's an acknowledge.
    return 1 if $Ticket{Lock} ne 'lock';

    # Agent lookup.
    my %User = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
        UserID => $Param{UserID},
        Cached => 1,
    );

    my $Return = $Self->_HTTP(
        Ticket => \%Ticket,
        User   => \%User,
    );

    if ($Return) {

        $TicketObject->HistoryAdd(
            TicketID     => $Param{Data}->{TicketID},
            HistoryType  => 'Misc',
            Name         => 'Sent Acknowledge to Icinga2.',
            CreateUserID => $Param{UserID},
        );

        return 1;
    }
    else {

        $TicketObject->HistoryAdd(
            TicketID     => $Param{Data}->{TicketID},
            HistoryType  => 'Misc',
            Name         => 'Was not able to send Acknowledge to Icinga2.',
            CreateUserID => $Param{UserID},
        );

        return;
    }
}

sub _HTTP {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Ticket User)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }
    my %Ticket   = %{ $Param{Ticket} };
    my %UserData = %{ $Param{User} };

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $URL     = $ConfigObject->Get('Icinga2::Acknowledge::HTTP::URL');
    my $User    = $ConfigObject->Get('Icinga2::Acknowledge::HTTP::User');
    my $Pw      = $ConfigObject->Get('Icinga2::Acknowledge::HTTP::Password');
    my $Author  = $ConfigObject->Get('Icinga2::Acknowledge::Author');
    my $Comment = $ConfigObject->Get('Icinga2::Acknowledge::Comment');
    my $Sticky  = $ConfigObject->Get('Icinga2::Acknowledge::Sticky');
    my $Notify  = $ConfigObject->Get('Icinga2::Acknowledge::Notify');
    my $Expiry;

    if ( $Ticket{ $Self->{Fservice} } !~ /^host$/i ) {

        my $Filter = sprintf(
            'match("%s",host.name)&&match("%s",service.name)',
            $Ticket{ $Self->{Fhost} },
            $Ticket{ $Self->{Fservice} }
        );
        $URL .= sprintf( "?type=Service&filter=%s", URI::Escape::uri_escape($Filter) );
    }
    else {

        my $Filter = sprintf( 'match("%s",host.name)', $Ticket{ $Self->{Fhost} } );
        $URL .= sprintf( "?type=Host&filter=%s", URI::Escape::uri_escape($Filter) );
    }

    if ( !IsStringWithData($Author) ) {

        $Author = $UserData{UserFullname};
    }

    # Replace ticket tags.
    TICKET:
    for my $Key ( sort keys %Ticket ) {
        next TICKET if !defined $Ticket{$Key};

        # URLencode values.
        $Ticket{$Key} = URI::Escape::uri_escape_utf8( $Ticket{$Key} );
        $Comment =~ s/<$Key>/$Ticket{$Key}/g;
    }

    # replace config tags
    $Comment =~ s{<CONFIG_(.+?)>}{$Kernel::OM->Get('Kernel::Config')->Get($1)}egx;

    # get json object
    my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');

    my %Icinga2Param = (
        'author'  => $Author,
        'comment' => "$Comment",
        'sticky'  => $Sticky == 1 ? $JSONObject->True() : $JSONObject->False(),
        'notify'  => $Notify == 1 ? $JSONObject->True() : $JSONObject->False(),
    );
    if ($Expiry) {

        $Icinga2Param{'expiry'} = $Expiry;
    }
    my $Json = $JSONObject->Encode( Data => \%Icinga2Param );

    my $UserAgent = LWP::UserAgent->new(
        timeout  => 30,
        ssl_opts => {
            verify_hostname => 0,
            SSL_verify_mode => IO::Socket::SSL::SSL_VERIFY_NONE,
        }
    );
    my $Request = HTTP::Request->new( POST => $URL );
    $Request->authorization_basic( $User, $Pw );
    $Request->header( 'Accept' => 'application/json' );
    $Request->content($Json);
    my $Response = $UserAgent->request($Request);
    if ( !$Response->is_success() ) {

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't request $URL: " . $Response->status_line(),
        );

        return;
    }
    else {

        my $ResponseString = $Response->decoded_content();
        if ($ResponseString) {

            my $ResponseJSON = $JSONObject->Decode(
                Data => $ResponseString
            );

            if ( !IsHashRefWithData($ResponseJSON) ) {

                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => sprintf(
                        "Error sending ack to Icinga2. Fail to decode json (http %s): %s",
                        $Response->status_line(),
                        $ResponseString
                    ),
                );
                return;
            }

            my $Results = $ResponseJSON->{results};
            if (
                $ResponseJSON
                && IsArrayRefWithData($Results)
                && IsHashRefWithData( $Results->[0] )
                && $Results->[0]->{status}
                && $Results->[0]->{code} > 299
                )
            {

                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => sprintf(
                        "Error sending ack to Icinga2: %s (%s)",
                        $Response->status_line(),
                        $Results->[0]->{status}
                    ),
                );
            }
        }
    }

    return 1;
}
1;
