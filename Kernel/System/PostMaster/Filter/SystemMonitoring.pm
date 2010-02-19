# --
# Kernel/System/PostMaster/Filter/SystemMonitoring.pm - Basic System Monitoring Interface
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: SystemMonitoring.pm,v 1.9 2010-02-19 21:59:50 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::PostMaster::Filter::SystemMonitoring;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.9 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{Debug} = $Param{Debug} || 0;

    # get needed objects
    for my $Object (qw(ConfigObject LogObject TicketObject TimeObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    # Default Settings
    $Self->{Config} = {
        StateRegExp       => '\s*State:\s+(\S+)',
        FromAddressRegExp => 'sysmon@example.com',
        NewTicketRegExp   => 'CRITICAL|DOWN',
        CloseTicketRegExp => 'OK|UP',
        CloseActionState  => 'closed successful',
        ClosePendingTime  => 60 * 60 * 24 * 2,                          # 2 days
        HostRegExp        => '\s*Address:\s+(\d+\.\d+\.\d+\.\d+)\s*',
        FreeTextHost      => '1',
        FreeTextService   => '2',
        FreeTextState     => '1',
        ServiceRegExp     => '\s*Service:\s+(.*)\s*',
        DefaultService    => 'Host',
        SenderType        => 'system',
        ArticleType       => 'note-report',
    };

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # to store the log message
    my $LogMessage;

    # get config options, use defaults unless value specified
    if ( $Param{JobConfig} && ref $Param{JobConfig} eq 'HASH' ) {
        KEY:
        for my $Key ( keys( %{ $Param{JobConfig} } ) ) {
            next KEY if !$Self->{Config}->{$Key};
            $Self->{Config}->{$Key} = $Param{JobConfig}->{$Key};
        }
    }

    # check if sender is of interest
    return 1 if !$Param{GetParam}->{From};
    return 1 if $Param{GetParam}->{From} !~ /$Self->{Config}->{FromAddressRegExp}/i;

    # Try to get State, Host and Service from email subject
    my @SubjectLines = split /\n/, $Param{GetParam}->{Subject};
    for my $Line (@SubjectLines) {
        for (qw(State Host Service)) {
            if ( $Line =~ /$Self->{Config}->{ $_ . 'RegExp' }/ ) {
                $Self->{$_} = $1;
            }
        }
    }

    # Try to get State, Host and Service from email body
    my @BodyLines = split /\n/, $Param{GetParam}->{Body};
    for my $Line (@BodyLines) {
        for (qw(State Host Service)) {
            if ( $Line =~ /$Self->{Config}->{ $_ . 'RegExp' }/ ) {
                $Self->{$_} = $1;
            }
        }
    }

    # we need State and Host to proceed
    if ( !$Self->{State} || !$Self->{Host} ) {

        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => 'SystemMonitoring Mail: '
                . 'SystemMonitoring: Could not find host address '
                . 'and/or state in mail => Ignoring',
        );
        return 1;
    }

    # Check for Service
    $Self->{Service} ||= $Self->{Config}->{DefaultService};

    # define log message
    $LogMessage = " - "
        . "Host: $Self->{Host}, "
        . "State: $Self->{State}, "
        . "Service: $Self->{Service}";

    # Is there a ticket for this Host/Service pair?
    my %Query = (
        Result    => 'ARRAY',
        Limit     => 1,
        UserID    => 1,
        StateType => 'Open',
    );
    for my $Type (qw(Host Service)) {
        $Query{ 'TicketFreeKey' . $Self->{Config}->{ 'FreeText' . $Type } } = $Type;
        $Query{ 'TicketFreeText' . $Self->{Config}->{ 'FreeText' . $Type } }
            = $Self->{$Type};
    }

    # search tickets
    my @TicketIDs = $Self->{TicketObject}->TicketSearch(%Query);

    # get the first and only ticket id
    my $TicketID = shift @TicketIDs;

    # OK, found ticket to deal with
    if ($TicketID) {

        # get ticket number
        my $TicketNumber = $Self->{TicketObject}->TicketNumberLookup(
            TicketID => $TicketID,
            UserID   => 1,
        );

        # build subject
        $Param{GetParam}->{Subject} = $Self->{TicketObject}->TicketSubjectBuild(
            TicketNumber => $TicketNumber,
            Subject      => $Param{GetParam}->{Subject},
        );

        # set sender type and article type
        $Param{GetParam}->{'X-OTRS-FollowUp-SenderType'}  = $Self->{Config}->{SenderType};
        $Param{GetParam}->{'X-OTRS-FollowUp-ArticleType'} = $Self->{Config}->{ArticleType};

        # Set Article Free Field for State
        my $ArticleFreeTextNumber = $Self->{Config}->{'FreeTextState'};
        $Param{GetParam}->{ 'X-OTRS-FollowUp-ArticleKey' . $ArticleFreeTextNumber }
            = 'State';
        $Param{GetParam}->{ 'X-OTRS-FollowUp-ArticleValue' . $ArticleFreeTextNumber }
            = $Self->{State};

        if ( $Self->{State} =~ /$Self->{Config}->{CloseTicketRegExp}/ ) {

            # Close Ticket Condition -> Take Close Action
            if ( $Self->{Config}->{CloseActionState} ne 'OLD' ) {
                $Param{GetParam}->{'X-OTRS-FollowUp-State'} = $Self->{Config}->{CloseActionState};

                my $TimeStamp = $Self->{TimeObject}->SystemTime2TimeStamp(
                    SystemTime => $Self->{TimeObject}->SystemTime()
                        + $Self->{Config}->{ClosePendingTime},
                );
                $Param{GetParam}->{'X-OTRS-State-PendingTime'} = $TimeStamp;
            }
            $LogMessage = 'Recovered' . $LogMessage;
        }
        else {

            # Attach note to existing ticket
            $LogMessage = 'New Notice' . $LogMessage;
        }
    }
    elsif ( $Self->{State} =~ /$Self->{Config}->{NewTicketRegExp}/ ) {

        # Create Ticket Condition -> Create new Ticket and record Host and Service
        for (qw(Host Service)) {

            my $TicketFreeTextNumber = $Self->{Config}->{ 'FreeText' . $_ };

            $Param{GetParam}->{ 'X-OTRS-TicketKey' . $TicketFreeTextNumber }   = $_;
            $Param{GetParam}->{ 'X-OTRS-TicketValue' . $TicketFreeTextNumber } = $Self->{$_};
        }

        # Set Article Free Field for State
        my $ArticleFreeTextNumber = $Self->{Config}->{'FreeTextState'};
        $Param{GetParam}->{ 'X-OTRS-ArticleKey' . $ArticleFreeTextNumber }   = 'State';
        $Param{GetParam}->{ 'X-OTRS-ArticleValue' . $ArticleFreeTextNumber } = $Self->{State};

        # set sender type and article type
        $Param{GetParam}->{'X-OTRS-SenderType'}  = $Self->{Config}->{SenderType};
        $Param{GetParam}->{'X-OTRS-ArticleType'} = $Self->{Config}->{ArticleType};

        $LogMessage = 'New Ticket' . $LogMessage;
    }
    else {

        # No existing ticket and no open condition -> drop silently
        $Param{GetParam}->{'X-OTRS-Ignore'} = 'yes';
        $LogMessage = 'Mail Dropped, no matching ticket found,'
            . ' no open on this state ' . $LogMessage;
    }

    # logging
    if ($LogMessage) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => 'SystemMonitoring Mail: ' . $LogMessage,
        );
    }

    return 1;
}

1;
