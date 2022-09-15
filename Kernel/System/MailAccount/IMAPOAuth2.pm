# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019–2021 Efflux GmbH, https://efflux.de/
# Copyright (C) 2019-2021 Rother OSS GmbH, https://otobo.de/
# --
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
# --

package Kernel::System::MailAccount::IMAPOAuth2;

use strict;
use warnings;

use Mail::IMAPClient;
use MIME::Base64;

use Kernel::System::PostMaster;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::CommunicationLog',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::OAuth2::MailAccount',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Connect {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ID Login Password Host Timeout Debug)) {
        if ( !defined $Param{$_} ) {
            return (
                Successful => 0,
                Message    => "Need $_!",
            );
        }
    }

    my $AccessToken = $Kernel::OM->Get('Kernel::System::OAuth2::MailAccount')->GetAccessToken(
        MailAccountID => $Param{ID}
    );

    if ( !$AccessToken ) {
        return (
            Successful => 0,
            Message    => "IMAPOAuth2: Could not request access token for $Param{Login}/$Param{Host}'. The refresh token could be expired or invalid."
        );
    }

    # connect to host
    my $IMAPObject = Mail::IMAPClient->new(
        Server   => $Param{Host},
        Starttls => [ SSL_verify_mode => 0 ],
        Debug    => $Param{Debug},
        Uid      => 1,

        # see bug#8791: needed for some Microsoft Exchange backends
        Ignoresizeerrors => 1,
    );

    # Auth via SASL XOAUTH2.
    my $SASLXOAUTH2 = encode_base64( 'user=' . $Param{Login} . "\x01auth=Bearer " . $AccessToken . "\x01\x01" );
    $IMAPObject->authenticate( 'XOAUTH2', sub { return $SASLXOAUTH2 } );

    if ( !$IMAPObject || !$IMAPObject->IsAuthenticated() ) {
        return (
            Successful => 0,
            Message    => "IMAPOAuth2: Can't connect to $Param{Host}: $@\n"
        );
    }

    return (
        Successful => 1,
        IMAPObject => $IMAPObject,
    );
}

sub Fetch {
    my ( $Self, %Param ) = @_;

    # start a new incoming communication
    my $CommunicationLogObject = $Kernel::OM->Create(
        'Kernel::System::CommunicationLog',
        ObjectParams => {
            Transport   => 'Email',
            Direction   => 'Incoming',
            AccountType => $Param{Type},
            AccountID   => $Param{ID},
        },
    );

    # fetch again if still messages on the account
    my $CommunicationLogStatus = 'Successful';
    COUNT:
    for ( 1 .. 200 ) {
        my $Fetch = $Self->_Fetch(
            %Param,
            CommunicationLogObject => $CommunicationLogObject,
        );
        if ( !$Fetch ) {
            $CommunicationLogStatus = 'Failed';
        }

        last COUNT if !$Self->{Reconnect};
    }

    $CommunicationLogObject->CommunicationStop(
        Status => $CommunicationLogStatus,
    );

    return 1;
}

sub _Fetch {
    my ( $Self, %Param ) = @_;

    my $CommunicationLogObject = $Param{CommunicationLogObject};

    $CommunicationLogObject->ObjectLogStart(
        ObjectLogType => 'Connection',
    );

    # check needed stuff
    for (qw(Login Password Host Trusted QueueID)) {
        if ( !defined $Param{$_} ) {
            $CommunicationLogObject->ObjectLog(
                ObjectLogType => 'Connection',
                Priority      => 'Error',
                Key           => 'Kernel::System::MailAccount::IMAPOAuth2',
                Value         => "$_ not defined!",
            );

            $CommunicationLogObject->ObjectLogStop(
                ObjectLogType => 'Connection',
                Status        => 'Failed',
            );
            $CommunicationLogObject->CommunicationStop( Status => 'Failed' );

            return;
        }
    }
    for (qw(Login Password Host)) {
        if ( !$Param{$_} ) {
            $CommunicationLogObject->ObjectLog(
                ObjectLogType => 'Connection',
                Priority      => 'Error',
                Key           => 'Kernel::System::MailAccount::IMAPOAuth2',
                Value         => "Need $_!",
            );

            $CommunicationLogObject->ObjectLogStop(
                ObjectLogType => 'Connection',
                Status        => 'Failed',
            );

            $CommunicationLogObject->CommunicationStop( Status => 'Failed' );

            return;
        }
    }

    my $Debug = $Param{Debug} || 0;
    my $Limit = $Param{Limit} || 5000;
    my $CMD   = $Param{CMD}   || 0;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # MaxEmailSize is in kB in SysConfig
    my $MaxEmailSize = $ConfigObject->Get('PostMasterMaxEmailSize') || 1024 * 6;

    # MaxPopEmailSession
    my $MaxPopEmailSession = $ConfigObject->Get('PostMasterReconnectMessage') || 20;

    my $Timeout      = 60;
    my $FetchCounter = 0;
    my $AuthType     = 'IMAPOAuth2';

    $Self->{Reconnect} = 0;

    $CommunicationLogObject->ObjectLog(
        ObjectLogType => 'Connection',
        Priority      => 'Debug',
        Key           => 'Kernel::System::MailAccount::IMAPOAuth2',
        Value         => "Open connection to '$Param{Host}' ($Param{Login}).",
    );

    my %Connect = ();
    eval {
        %Connect = $Self->Connect(
            ID       => $Param{ID},
            Host     => $Param{Host},
            Login    => $Param{Login},
            Password => $Param{Password},
            Timeout  => $Timeout,
            Debug    => $Debug
        );
    } || do {
        my $Error = $@;
        %Connect = (
            Successful => 0,
            Message    =>
                "Something went wrong while trying to connect to 'IMAPOAuth2 => $Param{Login}/$Param{Host}': ${ Error }",
        );
    };

    if ( !$Connect{Successful} ) {
        $CommunicationLogObject->ObjectLog(
            ObjectLogType => 'Connection',
            Priority      => 'Error',
            Key           => 'Kernel::System::MailAccount::IMAPOAuth2',
            Value         => $Connect{Message},
        );

        $CommunicationLogObject->ObjectLogStop(
            ObjectLogType => 'Connection',
            Status        => 'Failed',
        );

        $CommunicationLogObject->CommunicationStop( Status => 'Failed' );

        return;
    }

    my $IMAPOperation = sub {
        my $Operation = shift;
        my @Params    = @_;

        my $IMAPObject = $Connect{IMAPObject};
        my $ScalarResult;
        my @ArrayResult = ();
        my $Wantarray   = wantarray;

        eval {
            if ($Wantarray) {
                @ArrayResult = $IMAPObject->$Operation( @Params, );
            }
            else {
                $ScalarResult = $IMAPObject->$Operation( @Params, );
            }

            return 1;
        } || do {
            my $Error = $@;
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => sprintf(
                    "Error while executing 'IMAPOAuth2->%s(%s)': %s",
                    $Operation,
                    join( ',', @Params ),
                    $Error,
                ),
            );
        };

        return @ArrayResult if $Wantarray;
        return $ScalarResult;
    };

    my $ConnectionWithErrors = 0;
    my $MessagesWithError    = 0;

    # read folder from MailAccount configuration
    my $IMAPFolder       = $Param{IMAPFolder} || 'INBOX';
    my $NumberOfMessages = 0;
    my $Messages;

    eval {
        $IMAPOperation->( 'select', $IMAPFolder, ) || die "Could not select: $@\n";
        $Messages         = $IMAPOperation->( 'messages', ) || die "Could not retrieve messages : $@\n";
        $NumberOfMessages = scalar @{$Messages};

        if ($CMD) {
            print "$AuthType: I found $NumberOfMessages messages on $Param{Login}/$Param{Host}. ";
        }

        return 1;
    } || do {
        my $Error = $@;
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => sprintf(
                "Error while retrieving the messages 'IMAPOAuth2': %s",
                $Error,
            ),
        );

        $ConnectionWithErrors = 1;
    };

    # fetch messages
    if ( $Messages && !$NumberOfMessages ) {
        if ($CMD) {
            print "$AuthType: No messages on $Param{Login}/$Param{Host}\n";
        }
    }
    elsif ($NumberOfMessages) {
        MESSAGE_NO:
        for my $Messageno ( @{$Messages} ) {

            # check if reconnect is needed
            $FetchCounter++;
            if ( ($FetchCounter) > $MaxPopEmailSession ) {
                $Self->{Reconnect} = 1;
                if ($CMD) {
                    print "$AuthType: Reconnect Session after $MaxPopEmailSession messages...\n";
                }
                last MESSAGE_NO;
            }
            if ($CMD) {
                print
                    "$AuthType: Message $FetchCounter/$NumberOfMessages ($Param{Login}/$Param{Host})\n";
            }

            # check message size
            my $MessageSize = $IMAPOperation->( 'size', $Messageno, );
            if ( !( defined $MessageSize ) ) {
                my $ErrorMessage
                    = "$AuthType: Can't determine the size of email '$Messageno/$NumberOfMessages' from $Param{Login}/$Param{Host}!";

                $CommunicationLogObject->ObjectLog(
                    ObjectLogType => 'Connection',
                    Priority      => 'Error',
                    Key           => 'Kernel::System::MailAccount::IMAPOAuth2',
                    Value         => $ErrorMessage,
                );

                $ConnectionWithErrors = 1;

                if ($CMD) {
                    print "\n";
                }

                next MESSAGE_NO;
            }

            $MessageSize = int( $MessageSize / 1024 );
            if ( $MessageSize > $MaxEmailSize ) {

                my $ErrorMessage = "$AuthType: Can't fetch email $Messageno from $Param{Login}/$Param{Host}. "
                    . "Email too big ($MessageSize KB - max $MaxEmailSize KB)!";

                $CommunicationLogObject->ObjectLog(
                    ObjectLogType => 'Connection',
                    Priority      => 'Error',
                    Key           => 'Kernel::System::MailAccount::IMAPOAuth2',
                    Value         => $ErrorMessage,
                );

                $ConnectionWithErrors = 1;
            }
            else {

                # safety protection
                my $FetchDelay = ( $FetchCounter % 20 == 0 ? 1 : 0 );
                if ( $FetchDelay && $CMD ) {
                    print "$AuthType: Safety protection: waiting 1 second before processing next mail...\n";
                    sleep 1;
                }

                # get message (header and body)
                my $Message = $IMAPOperation->( 'message_string', $Messageno, );
                if ( !$Message ) {

                    my $ErrorMessage = "$AuthType: Can't process mail, email no $Messageno is empty!";

                    $CommunicationLogObject->ObjectLog(
                        ObjectLogType => 'Connection',
                        Priority      => 'Error',
                        Key           => 'Kernel::System::MailAccount::IMAPOAuth2',
                        Value         => $ErrorMessage,
                    );

                    $ConnectionWithErrors = 1;
                }
                else {
                    $CommunicationLogObject->ObjectLog(
                        ObjectLogType => 'Connection',
                        Priority      => 'Debug',
                        Key           => 'Kernel::System::MailAccount::IMAPOAuth2',
                        Value         => "Message '$Messageno' successfully received from server.",
                    );

                    $CommunicationLogObject->ObjectLogStart( ObjectLogType => 'Message' );
                    my $MessageStatus = 'Successful';

                    my $PostMasterObject = Kernel::System::PostMaster->new(
                        %{$Self},
                        Email                  => \$Message,
                        Trusted                => $Param{Trusted} || 0,
                        Debug                  => $Debug,
                        CommunicationLogObject => $CommunicationLogObject,
                    );

                    my @Return = eval {
                        return $PostMasterObject->Run( QueueID => $Param{QueueID} || 0 );
                    };
                    my $Exception = $@ || undef;

                    if ( !$Return[0] ) {
                        $MessagesWithError += 1;

                        if ($Exception) {
                            $Kernel::OM->Get('Kernel::System::Log')->Log(
                                Priority => 'error',
                                Message  => 'Exception while processing mail: ' . $Exception,
                            );
                        }

                        my $Lines = $IMAPOperation->( 'get', $Messageno, );
                        my $File  = $Self->_ProcessFailed( Email => $Message );

                        my $ErrorMessage = "$AuthType: Can't process mail, see log sub system ("
                            . "$File, report it on http://bugs.otrs.org/)!";

                        $CommunicationLogObject->ObjectLog(
                            ObjectLogType => 'Connection',
                            Priority      => 'Error',
                            Key           => 'Kernel::System::MailAccount::IMAPOAuth2',
                            Value         => $ErrorMessage,
                        );

                        $MessageStatus = 'Failed';
                    }

                    # mark email to delete once it was processed
                    $IMAPOperation->( 'delete_message', $Messageno, );
                    undef $PostMasterObject;

                    $CommunicationLogObject->ObjectLogStop(
                        ObjectLogType => 'Message',
                        Status        => $MessageStatus,
                    );
                }

                # check limit
                $Self->{Limit}++;
                if ( $Self->{Limit} >= $Limit ) {
                    $Self->{Reconnect} = 0;
                    last MESSAGE_NO;
                }
            }
            if ($CMD) {
                print "\n";
            }
        }
    }

    # log status
    if ( $Debug > 0 || $FetchCounter ) {
        $CommunicationLogObject->ObjectLog(
            ObjectLogType => 'Connection',
            Priority      => 'Info',
            Key           => 'Kernel::System::MailAccount::IMAPOAuth2',
            Value         => "$AuthType: Fetched $FetchCounter email(s) from $Param{Login}/$Param{Host}.",
        );
    }
    $IMAPOperation->( 'close', );
    if ($CMD) {
        print "$AuthType: Connection to $Param{Host} closed.\n\n";
    }

    if ($ConnectionWithErrors) {
        $CommunicationLogObject->ObjectLogStop(
            ObjectLogType => 'Connection',
            Status        => 'Failed',
        );

        return;
    }

    $CommunicationLogObject->ObjectLogStop(
        ObjectLogType => 'Connection',
        Status        => 'Successful',
    );
    $CommunicationLogObject->CommunicationStop( Status => 'Successful' );

    return if $MessagesWithError;
    return 1;
}

sub _ProcessFailed {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !defined $Param{Email} ) {

        my $ErrorMessage = "'Email' not defined!";

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $ErrorMessage,
        );
        return;
    }

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/var/spool/';
    my $MD5  = $MainObject->MD5sum(
        String => \$Param{Email},
    );
    my $Location = $Home . 'problem-email-' . $MD5;

    return $MainObject->FileWrite(
        Location   => $Location,
        Content    => \$Param{Email},
        Mode       => 'binmode',
        Type       => 'Local',
        Permission => '640',
    );
}

1;
