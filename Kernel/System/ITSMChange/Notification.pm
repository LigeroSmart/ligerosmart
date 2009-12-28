# --
# Kernel/System/ITSMChange/Notification.pm - lib for notifications in change management
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: Notification.pm,v 1.2 2009-12-28 13:48:43 reb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange::Notification;

use strict;
use warnings;

use Kernel::System::CustomerUser;
use Kernel::System::Email;
use Kernel::System::HTMLUtils;
use Kernel::System::Notification;
use Kernel::System::User;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

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
    for my $Object (qw(DBObject ConfigObject EncodeObject LogObject MainObject TimeObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    # set the debug flag
    $Self->{Debug} = $Param{Debug} || 0;

    # create additional objects
    $Self->{NotificationObject} = Kernel::System::Notification->new( %{$Self} );
    $Self->{UserObject}         = Kernel::System::User->new( %{$Self} );
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new( %{$Self} );
    $Self->{HTMLUtilsObject}    = Kernel::System::HTMLUtils->new( %{$Self} );
    $Self->{SendmailObject}     = Kernel::System::Email->new( %{$Self} );

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
    for my $IDKey (qw(AgentIDs CustomerIDs)) {
        if ( defined $Param{$IDKey} && ref $Param{$IDKey} ne 'ARRAY' ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "$IDKey has to be an array reference!",
            );
            return;
        }
    }

    my %NotificationCache;

    for my $AgentID ( @{ $Param{AgentIDs} } ) {

        # get preferred language
        my %User = $Self->{UserObject}->GetUserData(
            UserID => $AgentID,
        );

        # get preferred language
        my $PreferredLanguage = $Self->{ConfigObject}->Get('DefaultLanguage') || 'en';
        if ( $User{UserLanguage} ) {
            $PreferredLanguage = $User{UserLanguage};
        }

        my $NotificationKey = $PreferredLanguage . '::' . $Param{Type} . '::' . $Param{Event};

        # get notification (cache || database)
        my $Notification = $NotificationCache{$NotificationKey};

        if ( !$Notification ) {

            # get from database
            my %NotificationData = $Self->{NotificationObject}->NotificationGet(
                Name => $NotificationKey
            );

            # no notification found
            if ( !%NotificationData ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "Could not find notification for $NotificationKey",
                );

                return;
            }

            $NotificationCache{$NotificationKey} = {%NotificationData};
            $Notification = {%NotificationData};
        }

        # replace otrs macros
        $Notification->{Body} = $Self->_NotificationReplaceMacros(
            Type      => $Param{Type},
            Text      => $Notification->{Body},
            Recipient => {%User},
            RichText  => $Self->{RichText},
            UserID    => $Param{UserID},
            Data      => $Param{Data},
        );

        $Notification->{Subject} = $Self->_NotificationReplaceMacros(
            Type      => $Param{Type},
            Text      => $Notification->{Subject},
            Recipient => {%User},
            UserID    => $Param{UserID},
            Data      => $Param{Data},
        );

        # send notification
        $Self->{SendmailObject}->Send(
            From => $Self->{ConfigObject}->Get('NotificationSenderName') . ' <'
                . $Self->{ConfigObject}->Get('NotificationSenderEmail') . '>',
            To       => $User{UserEmail},
            Subject  => $Notification->{Subject},
            MimeType => $Notification->{ContentType} || 'text/plain',
            Charset  => $Notification->{Charset},
            Body     => $Notification->{Body},
            Loop     => 1,
        );
    }

    for my $CustomerID ( @{ $Param{CustomerIDs} } ) {

        # get preferred language
        my %CustomerUser = $Self->{CustomerUserObject}->CustomerUserDataGet(
            User => $CustomerID,
        );

        # get preferred language
        my $PreferredLanguage = $Self->{ConfigObject}->Get('DefaultLanguage') || 'en';
        if ( $CustomerUser{UserLanguage} ) {
            $PreferredLanguage = $CustomerUser{UserLanguage};
        }

        my $NotificationKey = $PreferredLanguage . '::' . $Param{Type} . '::' . $Param{Event};

        # get notification (cache || database)
        my $Notification = $NotificationCache{$NotificationKey};

        if ( !$Notification ) {

            # get from database
            my %NotificationData = $Self->{NotificationObject}->NotificationGet(
                Name => $NotificationKey
            );

            # no notification found
            if ( !%NotificationData ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "Could not find notification for $NotificationKey",
                );

                return;
            }

            $NotificationCache{$NotificationKey} = {%NotificationData};
            $Notification = {%NotificationData};
        }

        # replace otrs macros
        $Notification->{Body} = $Self->_NotificationReplaceMacros(
            Type      => $Param{Type},
            Text      => $Notification->{Body},
            Recipient => {%CustomerUser},
            RichText  => $Self->{RichText},
            UserID    => $Param{UserID},
            Data      => $Param{Data},
        );

        $Notification->{Subject} = $Self->_NotificationReplaceMacros(
            Type      => $Param{Type},
            Text      => $Notification->{Subject},
            Recipient => {%CustomerUser},
            UserID    => $Param{UserID},
            Data      => $Param{Data},
        );

        # send notification
        $Self->{SendmailObject}->Send(
            From => $Self->{ConfigObject}->Get('NotificationSenderName') . ' <'
                . $Self->{ConfigObject}->Get('NotificationSenderEmail') . '>',
            To       => $CustomerUser{UserEmail},
            Subject  => $Notification->{Subject},
            MimeType => $Notification->{ContentType} || 'text/plain',
            Charset  => $Notification->{Charset},
            Body     => $Notification->{Body},
            Loop     => 1,
        );
    }
}

=begin Internal:

=cut

sub _NotificationReplaceMacros {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Type Text Data UserID)) {
        if ( !defined $Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $Text = $Param{Text};

    # determine what "macro" delimiters are used
    my $Start = '<';
    my $End   = '>';

    # with richtext enabled, the delimiters change
    if ( $Param{RichText} ) {
        $Start = '&lt;';
        $End   = '&gt;';
        $Text =~ s/(\n|\r)//g;
    }

    # replace config options
    my $Tag = $Start . 'OTRS_CONFIG_';
    $Text =~ s{ $Tag (.+?) $End }{$Self->{ConfigObject}->Get($1)}egx;

    # cleanup
    $Text =~ s{ $Tag .+? $End }{-}gi;

    # get recipient data and replace it with <OTRS_...
    $Tag = $Start . 'OTRS_';
    if ( $Param{Recipient} ) {

        # html quoting of content
        if ( $Param{RichText} ) {
            for ( keys %{ $Param{Recipient} } ) {
                next if !$Param{Recipient}->{$_};
                $Param{Recipient}->{$_} = $Self->{HTMLUtilsObject}->ToHTML(
                    String => $Param{Recipient}->{$_},
                );
            }
        }

        # replace it
        for ( keys %{ $Param{Recipient} } ) {
            next if !defined $Param{Recipient}->{$_};
            my $Value = $Param{Recipient}->{$_};
            $Text =~ s{ $Tag $_ $End }{$Value}gxmsi;
        }
    }

    # cleanup
    $Text =~ s{ $Tag .+? $End}{-}gxmsi;

    $Tag = $Start . 'OTRS_Agent_';
    my $Tag2 = $Start . 'OTRS_CURRENT_';
    my %CurrentUser = $Self->{UserObject}->GetUserData( UserID => $Param{UserID} );

    # html quoting of content
    if ( $Param{RichText} ) {
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
        $Text =~ s{ $Tag $_ $End }{$CurrentUser{$_}}gxmsi;
        $Text =~ s{ $Tag2 $_ $End }{$CurrentUser{$_}}gxmsi;
    }

    # replace other needed stuff
    $Text =~ s{ $Start OTRS_FIRST_NAME $End }{$CurrentUser{UserFirstname}}gxms;
    $Text =~ s{ $Start OTRS_LAST_NAME $End }{$CurrentUser{UserLastname}}gxms;

    # cleanup
    $Text =~ s/$Tag.+?$End/-/gi;
    $Text =~ s/$Tag2.+?$End/-/gi;

    # get customer params and replace it with <OTRS_CUSTOMER_...
    my %Data = %{ $Param{Data} };

    # html quoting of content
    if ( $Param{RichText} ) {
        for ( keys %Data ) {
            next if !$Data{$_};
            $Data{$_} = $Self->{HTMLUtilsObject}->ToHTML(
                String => $Data{$_},
            );
        }
    }

    # get and prepare realname
    $Tag = $Start . 'OTRS_CUSTOMER_REALNAME';
    $Text =~ s/$Tag$End/-/g;

    # get customer data and replace it with <OTRS_CUSTOMER_DATA_...
    $Tag  = $Start . 'OTRS_CUSTOMER_';
    $Tag2 = $Start . 'OTRS_CUSTOMER_DATA_';

    # cleanup all not needed <OTRS_CUSTOMER_DATA_ tags
    $Text =~ s/$Tag.+?$End/-/gi;
    $Text =~ s/$Tag2.+?$End/-/gi;

    # replace <OTRS_CHANGE_... tags

    # replace <OTRS_WORKORDER_...

    return $Text;
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

$Revision: 1.2 $ $Date: 2009-12-28 13:48:43 $

=cut
