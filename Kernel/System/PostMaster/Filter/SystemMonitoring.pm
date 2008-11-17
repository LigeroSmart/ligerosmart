# --
# Kernel/System/PostMaster/Filter/SystemMonitoring.pm - Basic System Monitoring Interface
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: SystemMonitoring.pm,v 1.5 2008-11-17 16:44:15 jb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --
package Kernel::System::PostMaster::Filter::SystemMonitoring;
use strict;
use warnings;
use vars qw($VERSION);

$VERSION = qw($Revision: 1.5 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );
    $Self->{Debug} = $Param{Debug} || 0;

    # get needed objects
    foreach (qw(ConfigObject LogObject TicketObject TimeObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # Default Settings
    $Self->{Config} = {
        StateRegExp       => '\s*State:\s+(\S+)',
        FromAddressRegExp => 'sysmon@example.com',
        NewTicketRegExp   => 'CRITICAL|DOWN',
        CloseTicketRegExp => 'OK|UP',
        CloseActionState  => 'closed successful',
        ClosePendingTime  => 60 * 60 * 24 * 2,                        # 2 days
        HostRegExp        => '\s*Address:\s+(\d+\.\d+\.\d+\.\d+)\s*',
        FreeTextHost      => '1',
        ServiceRegExp     => '\s*Service:\s+(.*)\s*',
        DefaultService    => 'Host',
        FreeTextService   => '2',
        SenderType        => 'system',
        ArticleType       => 'note-report',
        FreeTextState     => '1',
    };
    return $Self;
}

sub Run {
    my $Self       = shift;
    my %Param      = @_;
    my $LogMessage = undef;

    # get config options, use defaults unless value specified
    if ( $Param{JobConfig} && ref( $Param{JobConfig} ) eq 'HASH' ) {
        foreach ( keys( %{ $Param{JobConfig} } ) ) {
            $Self->{Config}{$_}
                && ( $Self->{Config}{$_} = $Param{JobConfig}->{$_} );
        }
    }

    # check if sender is of interest
    if (   $Param{GetParam}->{From}
        && $Param{GetParam}->{From} =~ /$Self->{Config}{FromAddressRegExp}/ )
    {

        # Try to get State, Host and Service
        for my $line ( split /\n/, $Param{GetParam}->{Subject} ) {
            for (qw ( State Host Service )) {
                $line =~ /$Self->{Config}{$_.'RegExp'}/
                    && ( $Self->{$_} = $1 );
            }
    }
    for my $line ( split /\n/, $Param{GetParam}->{Body} ) {
            for (qw ( State Host Service )) {
                $line =~ /$Self->{Config}{$_.'RegExp'}/
                    && ( $Self->{$_} = $1 );
            }
    }

        # We need State and Host to proceed
        if ( $Self->{State} && $Self->{Host} ) {

            # Check for Service
            $Self->{Service}
                || ( $Self->{Service} = $Self->{Config}{DefaultService} );
            $LogMessage
                = " - Host: $Self->{Host}, State: $Self->{State}, Service: $Self->{Service}";

            # Is there a ticket for this Host/Service pair?
            my %query = (
                Result    => 'ARRAY',
                Limit     => 1,
                UserID    => 1,
                StateType => 'Open'
            );
            for (qw ( Host Service )) {
                $query{ 'TicketFreeKey' . $Self->{Config}{ 'FreeText' . $_ } }
                    = $_;
                $query{ 'TicketFreeText'
                        . $Self->{Config}{ 'FreeText' . $_ } } = $Self->{$_};
            }

            if ( my $TicketID
                = ( $Self->{TicketObject}->TicketSearch(%query) )[0] )
            {

                # Always use first result, there should be only one...
                # OK, found ticket to deal with
                $Param{GetParam}->{Subject}
                    = $Self->{TicketObject}->TicketSubjectBuild(
                    TicketNumber => $Self->{TicketObject}->TicketNumberLookup(
                        TicketID => $TicketID,
                        UserID   => 1
                    ),
                    Subject => $Param{GetParam}->{Subject},
                    );
                $Param{GetParam}->{'X-OTRS-FollowUp-SenderType'}
                    = $Self->{Config}{SenderType};
                $Param{GetParam}->{'X-OTRS-FollowUp-ArticleType'}
                    = $Self->{Config}{ArticleType};

                # Set Article Free Field for State
                $Param{GetParam}->{'X-OTRS-FollowUp-ArticleKey'
                        . $Self->{Config}{ 'FreeTextState' } } = 'State';
                $Param{GetParam}->{'X-OTRS-FollowUp-ArticleValue'
                        . $Self->{Config}{ 'FreeTextState' } } = $Self->{State};

                if ( $Self->{State} =~ /$Self->{Config}{CloseTicketRegExp}/ )
                {

                    # Close Ticket Condition -> Take Close Action
                    if ( $Self->{Config}{CloseActionState} ne 'OLD' ) {
                        $Param{GetParam}->{'X-OTRS-FollowUp-State'}
                            = $Self->{Config}{CloseActionState};
                        $Param{GetParam}->{'X-OTRS-State-PendingTime'}
                            = $Self->{TimeObject}->SystemTime2TimeStamp(
                            SystemTime => $Self->{TimeObject}->SystemTime()
                                + $Self->{Config}{ClosePendingTime} );
                    }
                    $LogMessage = 'Recovered' . $LogMessage;
                }
                else {

                    # Attach note to existing ticket
                    $LogMessage = 'New Notice' . $LogMessage;
                }
            }
            elsif ( $Self->{State} =~ /$Self->{Config}{NewTicketRegExp}/ ) {

                # Create Ticket Condition -> Create new Ticket and record Host and Service
                for (qw ( Host Service )) {
                    $Param{GetParam}->{ 'X-OTRS-TicketKey'
                            . $Self->{Config}{ 'FreeText' . $_ } } = $_;
                    $Param{GetParam}->{ 'X-OTRS-TicketValue'
                            . $Self->{Config}{ 'FreeText' . $_ } }
                        = $Self->{$_};
                }

                # Set Article Free Field for State
                $Param{GetParam}->{'X-OTRS-ArticleKey'
                        . $Self->{Config}{ 'FreeTextState' } } = 'State';
                $Param{GetParam}->{'X-OTRS-ArticleValue'
                        . $Self->{Config}{ 'FreeTextState' } } = $Self->{State};

                $Param{GetParam}->{'X-OTRS-SenderType'}
                    = $Self->{Config}{SenderType};
                $Param{GetParam}->{'X-OTRS-ArticleType'}
                    = $Self->{Config}{ArticleType};
                $LogMessage = 'New Ticket' . $LogMessage;
            }
            else {

                # No existing ticket and no open condition -> drop silently
                $Param{GetParam}->{'X-OTRS-Ignore'} = 'yes';
                $LogMessage
                    = 'Mail Dropped, no matching ticket found, no open on this state'
                    . $LogMessage;
            }
        }
        else {
            $LogMessage
                = 'SystemMonitoring: Could not find host address and/or state in mail => Ignoring';
        }
        if ($LogMessage) {
            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message  => 'SystemMonitoring Mail: ' . $LogMessage,
            );
        }

    }
    return 1;
}

1;
