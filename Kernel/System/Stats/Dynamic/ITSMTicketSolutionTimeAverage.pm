# --
# Kernel/System/Stats/Dynamic/ITSMTicketSolutionTimeAverage.pm - stats functions for the solution time average
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: ITSMTicketSolutionTimeAverage.pm,v 1.1 2008-07-02 22:02:01 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::Stats::Dynamic::ITSMTicketSolutionTimeAverage;

use strict;
use warnings;

use Kernel::System::Queue;
use Kernel::System::Service;
use Kernel::System::SLA;
use Kernel::System::State;
use Kernel::System::Ticket;
use Kernel::System::Type;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(DBObject ConfigObject LogObject UserObject TimeObject MainObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }
    $Self->{StateObject}    = Kernel::System::State->new( %{$Self} );
    $Self->{QueueObject}    = Kernel::System::Queue->new( %{$Self} );
    $Self->{TicketObject}   = Kernel::System::Ticket->new( %{$Self} );
    $Self->{PriorityObject} = Kernel::System::Priority->new( %{$Self} );
    $Self->{CustomerUser}   = Kernel::System::CustomerUser->new( %{$Self} );
    $Self->{ServiceObject}  = Kernel::System::Service->new( %{$Self} );
    $Self->{SLAObject}      = Kernel::System::SLA->new( %{$Self} );
    $Self->{TypeObject}     = Kernel::System::Type->new( %{$Self} );

    return $Self;
}

sub GetObjectName {
    my $Self = shift;

    return 'ITSMTicketSolutionTimeAverage';
}

sub GetObjectAttributes {
    my ( $Self, %Param ) = @_;

    # get user list
    my %UserList = $Self->{UserObject}->UserList(
        Type  => 'Long',
        Valid => 0,
    );

    # get state list
    my %StateList = $Self->{StateObject}->StateGetStatesByType(
        StateType => ['closed'],
        Result    => 'HASH',
        UserID    => 1,
    );

    # get queue list
    my %QueueList = $Self->{QueueObject}->GetAllQueues();

    # get priority list
    my %PriorityList = $Self->{PriorityObject}->PriorityList(
        UserID => 1,
    );

    my @ObjectAttributes = (
        {
            Name                => 'Queue',
            UseAsXvalue         => 1,
            UseAsValueSeries    => 1,
            UseAsRestriction    => 1,
            Element             => 'QueueIDs',
            Block               => 'MultiSelectField',
            LanguageTranslation => 0,
            Values              => \%QueueList,
        },
        {
            Name             => 'State',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'StateIDs',
            Block            => 'MultiSelectField',
            Values           => \%StateList,
        },
        {
            Name             => 'Priority',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'PriorityIDs',
            Block            => 'MultiSelectField',
            Values           => \%PriorityList,
        },
        {
            Name                => 'Created in Queue',
            UseAsXvalue         => 1,
            UseAsValueSeries    => 1,
            UseAsRestriction    => 1,
            Element             => 'CreatedQueueIDs',
            Block               => 'MultiSelectField',
            LanguageTranslation => 0,
            Values              => \%QueueList,
        },
        {
            Name             => 'Created Priority',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'CreatedPriorityIDs',
            Block            => 'MultiSelectField',
            Values           => \%PriorityList,
        },
        {
            Name             => 'Created State',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'CreatedStateIDs',
            Block            => 'MultiSelectField',
            Values           => \%StateList,
        },
        {
            Name             => 'Title',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'Title',
            Block            => 'InputField',
        },
        {
            Name             => 'CustomerUserLogin',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'CustomerUserLogin',
            Block            => 'InputField',
        },
        {
            Name             => 'From',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'From',
            Block            => 'InputField',
        },
        {
            Name             => 'To',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'To',
            Block            => 'InputField',
        },
        {
            Name             => 'Cc',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'Cc',
            Block            => 'InputField',
        },
        {
            Name             => 'Subject',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'Subject',
            Block            => 'InputField',
        },
        {
            Name             => 'Text',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'Body',
            Block            => 'InputField',
        },
        {
            Name             => 'Create Time',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'CreateTime',
            TimePeriodFormat => 'DateInputFormat',    # 'DateInputFormatLong',
            Block            => 'Time',
            Values           => {
                TimeStart => 'TicketCreateTimeNewerDate',
                TimeStop  => 'TicketCreateTimeOlderDate',
            },
        },
    );

    if ( $Self->{ConfigObject}->Get('Ticket::Service') ) {

        # get service list
        my %Service = $Self->{ServiceObject}->ServiceList(
            UserID => 1,
        );

        # get sla list
        my %SLA = $Self->{SLAObject}->SLAList(
            UserID => 1,
        );

        my @ObjectAttributeAdd = (
            {
                Name                => 'Service',
                UseAsXvalue         => 1,
                UseAsValueSeries    => 1,
                UseAsRestriction    => 1,
                Element             => 'ServiceIDs',
                Block               => 'MultiSelectField',
                LanguageTranslation => 0,
                Values              => \%Service,
            },
            {
                Name                => 'SLA',
                UseAsXvalue         => 1,
                UseAsValueSeries    => 1,
                UseAsRestriction    => 1,
                Element             => 'SLAIDs',
                Block               => 'MultiSelectField',
                LanguageTranslation => 0,
                Values              => \%SLA,
            },
        );

        unshift @ObjectAttributes, @ObjectAttributeAdd;
    }

    if ( $Self->{ConfigObject}->Get('Ticket::Type') ) {

        # get ticket type list
        my %Type = $Self->{TypeObject}->TypeList(
            UserID => 1,
        );

        my %ObjectAttribute1 = (
            Name                => 'Type',
            UseAsXvalue         => 1,
            UseAsValueSeries    => 1,
            UseAsRestriction    => 1,
            Element             => 'TypeIDs',
            Block               => 'MultiSelectField',
            LanguageTranslation => 0,
            Values              => \%Type,
        );

        unshift @ObjectAttributes, \%ObjectAttribute1;
    }

    if ( $Self->{ConfigObject}->Get('Stats::UseAgentElementInStats') ) {

        my @ObjectAttributeAdd = (
            {
                Name                => 'Agent/Owner',
                UseAsXvalue         => 1,
                UseAsValueSeries    => 1,
                UseAsRestriction    => 1,
                Element             => 'OwnerIDs',
                Block               => 'MultiSelectField',
                LanguageTranslation => 0,
                Values              => \%UserList,
            },
            {
                Name                => 'Created by Agent/Owner',
                UseAsXvalue         => 1,
                UseAsValueSeries    => 1,
                UseAsRestriction    => 1,
                Element             => 'CreatedUserIDs',
                Block               => 'MultiSelectField',
                LanguageTranslation => 0,
                Values              => \%UserList,
            },
            {
                Name                => 'Responsible',
                UseAsXvalue         => 1,
                UseAsValueSeries    => 1,
                UseAsRestriction    => 1,
                Element             => 'ResponsibleIDs',
                Block               => 'MultiSelectField',
                LanguageTranslation => 0,
                Values              => \%UserList,
            },
        );

        push @ObjectAttributes, @ObjectAttributeAdd;
    }

    if ( $Self->{ConfigObject}->Get('Stats::CustomerIDAsMultiSelect') ) {

        # Get CustomerID
        # (This way also can be the solution for the CustomerUserID)
        $Self->{DBObject}->Prepare(
            SQL => "SELECT DISTINCT customer_id FROM ticket",
        );

        # fetch the result
        my %CustomerID;
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            if ( $Row[0] ) {
                $CustomerID{ $Row[0] } = $Row[0];
            }
        }

        my %ObjectAttribute = (
            Name             => 'CustomerID',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'CustomerID',
            Block            => 'MultiSelectField',
            Values           => \%CustomerID,
        );

        push @ObjectAttributes, \%ObjectAttribute;
    }
    else {

        my %ObjectAttribute = (
            Name             => 'CustomerID',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'CustomerID',
            Block            => 'InputField',
        );

        push @ObjectAttributes, \%ObjectAttribute;
    }

    FREEKEY:
    for my $FreeKey ( 1 .. 16 ) {

        # get ticket free key config
        my $TicketFreeKey = $Self->{ConfigObject}->Get( 'TicketFreeKey' . $FreeKey );

        next FREEKEY if ref $TicketFreeKey ne 'HASH';

        my @FreeKey = keys %{$TicketFreeKey};
        my $Name    = '';

        if ( scalar @FreeKey == 1 ) {
            $Name = $TicketFreeKey->{ $FreeKey[0] };
        }
        else {
            $Name = 'TicketFreeText' . $FreeKey;

            my %ObjectAttribute = (
                Name                => 'TicketFreeKey' . $FreeKey,
                UseAsXvalue         => 1,
                UseAsValueSeries    => 1,
                UseAsRestriction    => 1,
                Element             => 'TicketFreeKey' . $FreeKey,
                Block               => 'MultiSelectField',
                Values              => $TicketFreeKey,
                LanguageTranslation => 0,
            );

            push @ObjectAttributes, \%ObjectAttribute;
        }

        # get ticket free text
        my $TicketFreeText = $Self->{TicketObject}->TicketFreeTextGet(
            Type   => 'TicketFreeText' . $FreeKey,
            UserID => 1,
        );

        if ($TicketFreeText) {

            my %ObjectAttribute = (
                Name                => $Name,
                UseAsXvalue         => 1,
                UseAsValueSeries    => 1,
                UseAsRestriction    => 1,
                Element             => 'TicketFreeText' . $FreeKey,
                Block               => 'MultiSelectField',
                Values              => $TicketFreeText,
                LanguageTranslation => 0,
            );

            push @ObjectAttributes, \%ObjectAttribute;
        }
        else {

            my %ObjectAttribute = (
                Name             => $Name,
                UseAsXvalue      => 0,
                UseAsValueSeries => 0,
                UseAsRestriction => 1,
                Element          => 'TicketFreeText' . $FreeKey,,
                Block            => 'InputField',
            );

            push @ObjectAttributes, \%ObjectAttribute;
        }
    }

    return @ObjectAttributes;
}

sub GetStatElement {
    my ( $Self, %Param ) = @_;

    # use all closed stats if no states are given
    if ( !$Param{StateIDs} ) {
        $Param{StateType} = ['closed'];
    }

    # start ticket search
    my @TicketSearchIDs = $Self->{TicketObject}->TicketSearch(
        %Param,
        Result     => 'ARRAY',
        Limit      => 100_000_000,
        UserID     => 1,
        Permission => 'ro',
    );

    return '-' if !@TicketSearchIDs;

    my $Time = 0;

    TICKETID:
    for my $TicketID (@TicketSearchIDs) {

        # get ticket data
        my $TicketData = $Self->_TicketDataGet(
            TicketID => $TicketID,
        );

        return 'ERROR' if !%{$TicketData};

        # get relevant ticket history
        my $HistoryData = $Self->_TicketHistoryDataGet(
            TicketID => $TicketID,
        );

        return 'ERROR' if !$HistoryData;

        # if ticket is closed in the ticket create mask
        if ( @{$HistoryData} == 1 ) {
            $Time += ( 3 * 60 );
            next TICKETID;
        }

        my %Timespans;
        my $Counter = 0;

        ENTRY:
        for my $Entry ( @{$HistoryData} ) {

            if ( $Timespans{$Counter} ) {

                next ENTRY if $Entry->{Viewable};

                # set stop time
                $Timespans{$Counter}->{StopTime} = $Self->{TimeObject}->TimeStamp2SystemTime(
                    String => $Entry->{CreateTime},
                );

                $Counter++;
            }
            else {

                next ENTRY if !$Entry->{Viewable};

                # set start time
                $Timespans{$Counter}->{StartTime} = $Self->{TimeObject}->TimeStamp2SystemTime(
                    String => $Entry->{CreateTime},
                );
            }
        }

        # get calendar
        my $Calendar = $Self->_CalendarGet(
            TicketData => $TicketData,
        );

        for my $Count ( sort keys %Timespans ) {

            # extract timestamp
            my $Timespan = $Timespans{$Count};

            $Timespan->{StopTime} ||= $Timespan->{StartTime} + ( 3 * 60 );

            # calculate working time
            my $WorkingTimePart = $Self->{TimeObject}->WorkingTime(
                %{$Timespan},
                Calendar => $Calendar,
            );

            $Time += $WorkingTimePart;
        }
    }

    my $TicketCount = @TicketSearchIDs;
    my $AverageTime = $Time / $TicketCount;

    # translate seconds in a readable format
    my $Value = $Self->_SecondeToString(
        Seconds => int $AverageTime,
    );

    return $Value;
}

sub _TicketDataGet {
    my ( $Self, %Param ) = @_;

    return {} if !$Param{TicketID};

    # ask database
    $Self->{DBObject}->Prepare(
        SQL => "SELECT queue_id, sla_id, create_time_unix "
            . "FROM ticket WHERE id = $Param{TicketID}",
        Limit => 1,
    );

    # fetch the result
    my %TicketData;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $TicketData{QueueID}    = $Row[0];
        $TicketData{SLAID}      = $Row[1];
        $TicketData{CreateTime} = $Row[2];
    }

    return \%TicketData;
}

sub _CalendarGet {
    my ( $Self, %Param ) = @_;

    # get config option
    $Self->{TicketServiceFeature} ||= $Self->{ConfigObject}->Get('Ticket::Service');

    my %EscalationData;
    if ( $Self->{TicketServiceFeature} && $Param{TicketData}->{SLAID} ) {
        %EscalationData = $Self->{SLAObject}->SLAGet(
            SLAID  => $Param{TicketData}->{SLAID},
            UserID => 1,
            Cache  => 1,
        );
    }
    else {
        %EscalationData = $Self->{QueueObject}->QueueGet(
            ID     => $Param{TicketData}->{QueueID},
            UserID => 1,
            Cache  => 1,
        );
    }

    return $EscalationData{Calendar} || undef;
}

sub _TicketHistoryDataGet {
    my ( $Self, %Param ) = @_;

    return if !$Param{TicketID};

    # get id of histoy type StateUpdate
    if ( !$Self->{StateUpdateID} ) {
        $Self->{StateUpdateID} = $Self->{TicketObject}->HistoryTypeLookup(
            Type => 'StateUpdate',
        );
    }

    # get id of histoy type NewTicket
    if ( !$Self->{NewTicketID} ) {
        $Self->{NewTicketID} = $Self->{TicketObject}->HistoryTypeLookup(
            Type => 'NewTicket',
        );
    }

    # get viewable state ids
    if ( !$Self->{ViewableStateIDs} ) {
        my @ViewableStateIDs = $Self->{StateObject}->StateGetStatesByType(
            Type   => 'Viewable',
            Result => 'ID',
        );

        my %ViewableStateIDList;
        for my $StateID (@ViewableStateIDs) {
            $ViewableStateIDList{$StateID} = 1;
        }

        $Self->{ViewableStateIDs} = \%ViewableStateIDList;
    }

    # ask database
    $Self->{DBObject}->Prepare(
        SQL => "SELECT state_id, create_time "
            . "FROM ticket_history "
            . "WHERE ticket_id = $Param{TicketID} AND "
            . "history_type_id IN ( $Self->{StateUpdateID}, $Self->{NewTicketID} ) "
            . "ORDER BY create_time",
    );

    # fetch the result
    my @TicketHistoryList;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {

        my %HistoryData;
        $HistoryData{StateID}    = $Row[0];
        $HistoryData{CreateTime} = $Row[1];

        push @TicketHistoryList, \%HistoryData;
    }

    ENTRY:
    for my $Entry (@TicketHistoryList) {

        $Entry->{Viewable} = 0;
        next ENTRY if !$Self->{ViewableStateIDs}->{ $Entry->{StateID} };
        $Entry->{Viewable} = 1;
    }

    return \@TicketHistoryList;
}

sub _SecondeToString {
    my ( $Self, %Param ) = @_;

    return '' if !defined $Param{Seconds};

    # calculate the seconds
    my $Seconds = $Param{Seconds} % 60;
    $Param{Seconds} = ( $Param{Seconds} - $Seconds ) / 60;

    # calculate the minutes
    my $Minutes = $Param{Seconds} % 60;

    # calculate the hours
    my $Hours = ( $Param{Seconds} - $Minutes ) / 60;

    # set default value
    $Hours   ||= 0;
    $Minutes ||= 0;
    $Seconds ||= 0;

    if ( $Seconds >= 30 ) {
        $Minutes++;
    }

    $Minutes = sprintf "%02d", $Minutes;

    my $HoursString   = 'Hours';
    my $MinutesString = 'Minutes';

    return "$Hours $HoursString $Minutes $MinutesString";
}

sub ExportWrapper {
    my ( $Self, %Param ) = @_;

    return \%Param;
}

sub ImportWrapper {
    my ( $Self, %Param ) = @_;

    return \%Param;
}

1;
