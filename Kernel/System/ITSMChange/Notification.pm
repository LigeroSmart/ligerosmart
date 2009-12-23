# --
# Kernel/System/ITSMChange/Notification.pm - lib for notifications in change management
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: Notification.pm,v 1.1 2009-12-23 18:00:19 reb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange::Notification;

use strict;
use warnings;

use Kernel::System::Notification;
use Kernel::System::Sendmail;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

=head1 NAME

Kernel::System::ITSMChange::Notification - notification functions for change management

=head1 SYNOPSIS

This module is managing notifications.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a notification object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::ITSMChange::Notification;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $NotificationObject = Kernel::System::ITSMChange::Notification->new(
        EncodeObject => $EncodeObject,
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
        DBObject     => $DBObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(DBObject ConfigObject EncodeObject LogObject MainObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    # set the debug flag
    $Self->{Debug} = $Param{Debug} || 0;

    # create additional objects
    $Self->{NotificationObject} = Kernel::System::Notification->new( %{$Self} );
    $Self->{UserObject}         = Kernel::System::User->new( %{$Self} );
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new( %{$Self} );

    # do we use richtext
    $Self->{RichText} = $Self->{ConfigObject}->Get('Frontend::RichText');

    return $Self;
}

=item NotificationSend()

Send the notification to customers and/or agents.

    my $Success = $NotificationObject->NotificationSend(
        AgentIDs    => [ 1, 2, 3, ]
        CustomerIDs => [ 1, 2, 3, ],
        Type        => 'Change',          # Change|WorkOrder
        Event       => 'ChangeUpdate',
        Data        => { %ChangeData },   # Change|WorkOrder data
        UserID      => 123,
    );

=cut

sub NotificationSend {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Type Event UserID Data)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # need at least AgentIDs or CustomerIDs
    if ( !$Param{AgentIDs} && !$Param{CustomerIDs} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need at least AgentIDs or CustomerIDs!',
        );
        return;
    }

    # AgentIDs and CustomerIDs have to be array references

    my %NotificationCache;

    for my $CustomerID ( @{ $Param{CustomerIDs} } ) {

        # get preferred language
        my %CustomerUser = $Self->{CustomerUserObject}->CustomerUserDataGet(
            User => $Article{CustomerUserID},
        );
        if ( $CustomerUser{UserEmail} ) {
            $Article{From} = $CustomerUser{UserEmail};
        }

        # get preferred language
        my $PreferredLanguage = $Self->{ConfigObject}->Get('DefaultLanguage') || 'en';
        if ( $CustomerUser{UserLanguage} ) {
            $Language = $CustomerUser{UserLanguage};
        }

        my $NotificationKey = $PreferredLanguage . '::' . $Param{Type} . '::' . $Param{Event};

        # get notification (cache || database)
        my $Notification = $NotificationCache{$NotificationKey};

        if ( !$Notification ) {

            # get from database
            $Notification = $Self->{NotificationObject}->NotificationGet(
                Name => $NotificationKey
            );

            # no notification found
            if ( !$Notification ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "Could not find notification for $NotificationKey",
                );

                return;
            }

            $NotificationCache{$NotificationKey} = $Notification;
        }

        # replace otrs macros
        $Notification = $Self->_NotificationReplaceMacros(
            Type         => $Param{Type},
            Notification => $Notification,
            Recipient    => {%CustomerUser},
        );

        # send notification
        $Self->{SendmailObject}->Send(
            From => $Self->{ConfigObject}->Get('NotificationSenderName') . ' <'
                . $Self->{ConfigObject}->Get('NotificationSenderEmail') . '>',
            To       => $CustomerUser{UserEmail},
            Subject  => $Notification{Subject},
            MimeType => $Notification{ContentType} || 'text/plain',
            Charset  => $Notification{Charset},
            Body     => $Notification{Body},
            Loop     => 1,
        );
    }
}

=begin Internal:

=cut

sub _NotificationReplaceMacros {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Type Notification Data UserID)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my $Notification = $Param{Notification};

    # determine what "macro" delimiters are used
    my $Start = '<';
    my $End   = '>';

    # with richtext enabled, the delimiters change
    if ( $Self->{RichText} ) {
        $Start = '&lt;';
        $End   = '&gt;';
        $Notification{Body} =~ s/(\n|\r)//g;
    }

    # replace config options
    my $Tag = $Start . 'OTRS_CONFIG_';
    $Notification{Body} =~ s{ $Tag (.+?) $End }{$Self->{ConfigObject}->Get($1)}egx;

    # cleanup
    $Notification{Body} =~ s{ $Tag .+? $End }{-}gi;

    # get recipient data and replace it with <OTRS_...
    $Tag = $Start . 'OTRS_';
    if ( $Param{Recipient} ) {

        # html quoting of content
        if ( $Self->{RichText} ) {
            for ( keys %{ $Param{Recipient} } ) {
                next if !$Param{Recipient}->{$_};
                $Recipient{$_} = $Self->{HTMLUtilsObject}->ToHTML(
                    String => $Param{Recipient}->{$_},
                );
            }
        }

        # replace it
        for ( keys %{ $Param{Recipient} } ) {
            next if !defined $Param{Recipient}->{$_};
            my $Value = $Param{Recipient}->{$_};
            $Notification{Body} =~ s{ $Tag $_ $End }{$Value}gxmsi;
        }
    }

    # cleanup
    $Notification{Body} =~ s{ $Tag .+? $End}{-}gxmsi;

    $Tag = $Start . 'OTRS_Agent_';
    my $Tag2 = $Start . 'OTRS_CURRENT_';
    my %CurrentUser = $Self->{UserObject}->GetUserData( UserID => $Param{UserID} );

    # html quoting of content
    if ( $Self->{RichText} ) {
        for ( keys %CurrentUser ) {
            next if !$CurrentUser{$_};
            $CurrentUser{$_} = $Self->{HTMLUtilsObject}->ToHTML(
                String => $CurrentUser{$_},
            );
        }
    }

    # replace it
    for ( keys %CurrentUser ) {
        next if !defined $CurrentUser{$_};
        $Notification{Body} =~ s{ $Tag $_ $End }{$CurrentUser{$_}}gxmsi;
        $Notification{Body} =~ s{ $Tag2 $_ $End }{$CurrentUser{$_}}gxmsi;
    }

    # replace other needed stuff
    $Notification{Body} =~ s{ $Start OTRS_FIRST_NAME $End }{$CurrentUser{UserFirstname}}gxms;
    $Notification{Body} =~ s{ $Start OTRS_LAST_NAME $End }{$CurrentUser{UserLastname}}gxms;

    # cleanup
    $Notification{Body} =~ s/$Tag.+?$End/-/gi;
    $Notification{Body} =~ s/$Tag2.+?$End/-/gi;

    # get customer params and replace it with <OTRS_CUSTOMER_...
    my %Data = %{ $Param{Data} };

    # html quoteing of content
    if ( $Param{RichText} ) {
        for ( keys %Data ) {
            next if !$Data{$_};
            $Data{$_} = $Self->{HTMLUtilsObject}->ToHTML(
                String => $Data{$_},
            );
        }
    }
    if (%Data) {

        # check if original content isn't text/plain, don't use it
        if ( $Data{'Content-Type'} && $Data{'Content-Type'} !~ /(text\/plain|\btext\b)/i ) {
            $Data{Body} = '-> no quotable message <-';
        }

        # replace <OTRS_CUSTOMER_*> tags
        $Tag = $Start . 'OTRS_CUSTOMER_';
        for ( keys %Data ) {
            next if !defined $Data{$_};
            $Param{Text} =~ s/$Tag$_$End/$Data{$_}/gi;
        }

        # replace <OTRS_CUSTOMER_BODY> and <OTRS_COMMENT> tags
        for my $Key (qw(OTRS_CUSTOMER_BODY OTRS_COMMENT)) {

            $Tag = $Start . $Key;
            if ( $Param{Text} =~ /$Tag$End(\n|\r|)/g ) {
                my $Line       = 2500;
                my @Body       = split( /\n/, $Data{Body} );
                my $NewOldBody = '';
                for ( my $i = 0; $i < $Line; $i++ ) {
                    if ( $#Body >= $i ) {

                        # add no quote char, do it later by using DocumentStyleCleanup()
                        if ( $Param{RichText} ) {
                            $NewOldBody .= $Body[$i];
                        }

                        # add "> " as quote char
                        else {
                            $NewOldBody .= "> $Body[$i]";
                        }

                        # add new line
                        if ( $i < ( $Line - 1 ) ) {
                            $NewOldBody .= "\n";
                        }
                    }
                    else {
                        last;
                    }
                }
                chomp $NewOldBody;

                # html quoteing of content
                if ( $Param{RichText} && $NewOldBody ) {

                    # remove tailing new lines
                    for ( 1 .. 10 ) {
                        $NewOldBody =~ s/(<br\/>)\s{0,20}$//gs;
                    }

                    # add quote
                    $NewOldBody = "<blockquote type=\"cite\">$NewOldBody</blockquote>";
                    $NewOldBody = $Self->{HTMLUtilsObject}->DocumentStyleCleanup(
                        String => $NewOldBody,
                    );
                }

                # replace tag
                $Param{Text} =~ s/$Tag$End/$NewOldBody/g;
            }
        }

        # replace <OTRS_CUSTOMER_EMAIL[]> tags
        $Tag = $Start . 'OTRS_CUSTOMER_EMAIL';
        if ( $Param{Text} =~ /$Tag\[(.+?)\]$End/g ) {
            my $Line       = $1;
            my @Body       = split( /\n/, $Data{Body} );
            my $NewOldBody = '';
            for ( my $i = 0; $i < $Line; $i++ ) {

                # 2002-06-14 patch of Pablo Ruiz Garcia
                # http://lists.otrs.org/pipermail/dev/2002-June/000012.html
                if ( $#Body >= $i ) {

                    # add no quote char, do it later by using DocumentStyleCleanup()
                    if ( $Self->{RichText} ) {
                        $NewOldBody .= $Body[$i];
                    }

                    # add "> " as quote char
                    else {
                        $NewOldBody .= "> $Body[$i]";
                    }

                    # add new line
                    if ( $i < ( $Line - 1 ) ) {
                        $NewOldBody .= "\n";
                    }
                }
            }
            chomp $NewOldBody;

            # html quoteing of content
            if ( $Self->{RichText} && $NewOldBody ) {

                # remove tailing new lines
                for ( 1 .. 10 ) {
                    $NewOldBody =~ s/(<br\/>)\s{0,20}$//gs;
                }

                # add quote
                $NewOldBody = "<blockquote type=\"cite\">$NewOldBody</blockquote>";
                $NewOldBody = $Self->{HTMLUtilsObject}->DocumentStyleCleanup(
                    String => $NewOldBody,
                );
            }

            # replace tag
            $Notification{Body} =~ s/$Tag\[.+?\]$End/$NewOldBody/g;
        }

        # replace <OTRS_CUSTOMER_SUBJECT[]> tags
        $Tag = $Start . 'OTRS_CUSTOMER_SUBJECT';
        $Notification{Body} =~ s/$Tag\[.+?\]$End//g;

        # Arnold Ligtvoet - otrs@ligtvoet.org
        # get <OTRS_EMAIL_DATE[]> from body and replace with received date
        use POSIX qw(strftime);
        $Tag = $Start . 'OTRS_EMAIL_DATE';
        if ( $Notification{Body} =~ /$Tag\[(.+?)\]$End/g ) {
            my $TimeZone = $1;
            my $EmailDate = strftime( '%A, %B %e, %Y at %T ', localtime );
            $EmailDate .= "($TimeZone)";
            $Notification{Body} =~ s/$Tag\[.+?\]$End/$EmailDate/g;
        }
    }

    # get and prepare realname
    $Tag = $Start . 'OTRS_CUSTOMER_REALNAME';
    $Notification{Body} =~ s/$Tag$End/$From/g;

    # get customer data and replace it with <OTRS_CUSTOMER_DATA_...
    $Tag  = $Start . 'OTRS_CUSTOMER_';
    $Tag2 = $Start . 'OTRS_CUSTOMER_DATA_';

    # cleanup all not needed <OTRS_CUSTOMER_DATA_ tags
    $Notification{Body} =~ s/$Tag.+?$End/-/gi;
    $Notification{Body} =~ s/$Tag2.+?$End/-/gi;

    # replace <OTRS_CHANGE_... tags

    # replace <OTRS_WORKORDER_...

    return $Notification{Body};
}

1;

=end Internal:

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see http://www.gnu.org/licenses/agpl.txt.

=cut

=head1 VERSION

$Revision: 1.1 $ $Date: 2009-12-23 18:00:19 $

=cut
