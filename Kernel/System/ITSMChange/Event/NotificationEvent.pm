# --
# Kernel/System/ITSMChange/Event/NotificationEvent.pm - a event module to send notifications
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: NotificationEvent.pm,v 1.2 2009-12-28 12:37:12 bes Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange::Event::NotificationEvent;

use strict;
use warnings;

# TODO: enable when Kernel::System::ITSMChange::Notification compiles
#use Kernel::System::ITSMChange::Notification;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

=head1 NAME

Kernel::System::ITSMChange::Event::NotificationEvent - ITSMChange notification lib

=head1 SYNOPSIS

Event handler module for notifications for Changes.

=head1 PUBLIC INTERFACE

=over 4

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::Main;
    use Kernel::System::Time;
    use Kernel::System::ITSMChange;
    use Kernel::System::ITSMChange::Event::NotificationEvent;

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
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $ChangeObject = Kernel::System::ITSMChange->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        TimeObject   => $TimeObject,
        MainObject   => $MainObject,
    );
    my $ChangeNotificationObject = Kernel::System::ITSMChange::Event::NotificationEvent->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        TimeObject   => $TimeObject,
        MainObject   => $MainObject,
        ChangeObject => $ChangeObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for my $Object (
        qw(DBObject ConfigObject EncodeObject LogObject MainObject TimeObject ChangeObject)
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    # create additional objects
    # TODO: enable when Kernel::System::ITSMChange::Notification compiles
    #$Self->{ChangeNotificationObject} = Kernel::System::ITSMChange::Notification->new( %{$Self} );

    return $Self;
}

=item Run()

The C<Run()> method handles the events and sends notifications about
the given change object.

It returns 1 on success, C<undef> otherwise.

    my $Success = $NotificationEventObject->Run(
        Event => 'ChangeUpdatePost',
        Data => {
            ChangeID    => 123,
            ChangeTitle => 'test',
        },
        Config => {
            Event       => '(ChangeAddPost|ChangeUpdatePost|ChangeCABUpdatePost|ChangeCABDeletePost|ChangeDeletePost)',
            Module      => 'Kernel::System::ITSMChange::Event::NotificationEvent',
            Transaction => '0',
        },
        UserID => 1,
    );

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Data Event Config UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!"
            );
            return;
        }
    }

    # in notification event handling we use Event name without 'Post'
    my $Event = $Param{Event};
    $Event =~ s{ Post \z }{}xms;

    # TODO: determine list of agents and customers from SysConfig and ChangeObject
    my @AgentIDs;
    my @CustomerIDs;

    # TODO: enable when Kernel::System::ITSMChange::Notification compiles
    if (0) {
        $Self->{ChangeNotificationObject}->NotificationSend(
            AgentIDs    => \@AgentIDs,
            CustomerIDs => \@CustomerIDs,
            Type        => 'Change',
            Event       => $Event,
            UserID      => $Param{UserID},
            Data        => $Param{Data},
        );
    }

    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see http://www.gnu.org/licenses/agpl.txt.

=cut

=head1 VERSION

$Revision: 1.2 $ $Date: 2009-12-28 12:37:12 $

=cut
