#!/usr/bin/perl
# --
# bin/otrs.ITSMChangesCheck.pl - check itsm changes
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU AFFERO General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
# or see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';

use vars qw(@ISA);

use Getopt::Std;
use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Time;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::DB;
use Kernel::System::User;
use Kernel::System::Group;
use Kernel::System::PID;
use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::History;
use Kernel::System::ITSMChange::ITSMWorkOrder;

{

    package OTRSMockObject;

    use Kernel::System::EventHandler;
    use vars qw(@ISA);

    @ISA = (
        'Kernel::System::EventHandler',
    );

    sub new {
        my ( $Class, %Objects ) = @_;

        my $Self = bless {}, $Class;

        for my $Object ( sort keys %Objects ) {
            $Self->{$Object} = $Objects{$Object};
        }

        # init of event handler
        $Self->EventHandlerInit(
            Config     => 'ITSMChangeCronjob::EventModule',
            BaseObject => 'ChangeObject',
            Objects    => {
                %{$Self},
            },
        );

        return $Self;
    }
}

# common objects
my %CommonObject;
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'OTRS-ITSMChangesCheck',
    %CommonObject,
);
$CommonObject{MainObject}      = Kernel::System::Main->new(%CommonObject);
$CommonObject{TimeObject}      = Kernel::System::Time->new(%CommonObject);
$CommonObject{DBObject}        = Kernel::System::DB->new(%CommonObject);
$CommonObject{UserObject}      = Kernel::System::User->new(%CommonObject);
$CommonObject{GroupObject}     = Kernel::System::Group->new(%CommonObject);
$CommonObject{PIDObject}       = Kernel::System::PID->new(%CommonObject);
$CommonObject{ChangeObject}    = Kernel::System::ITSMChange->new(%CommonObject);
$CommonObject{WorkOrderObject} = Kernel::System::ITSMChange::ITSMWorkOrder->new(%CommonObject);
$CommonObject{HistoryObject}   = Kernel::System::ITSMChange::History->new(%CommonObject);

my $MockedObject = OTRSMockObject->new(%CommonObject);

# get options
my %Opts = ();
getopt( 'hf', \%Opts );

# show help
if ( exists $Opts{h} ) {
    print "otrs.ITSMChangesCheck.pl - check itsm changes\n";
    print "Copyright (C) 2001-2014 OTRS AG, http://otrs.com/\n";
    print "usage: otrs.ITSMChangesCheck.pl [-f force]\n\n";
    exit 1;
}

# if sysconfig option is disabled -> exit
my $SysConfig = $CommonObject{ConfigObject}->Get('ITSMChange::TimeReachedNotifications');
if ( !$SysConfig->{Frequency} ) {
    exit(0);
}

# create pid lock
my $PIDLockName = 'ITSMChangesCheck';
if ( !$Opts{f} && !$CommonObject{PIDObject}->PIDCreate( Name => $PIDLockName ) ) {
    print
        "NOTICE: otrs.ITSMChangesCheck.pl is already running (use '-f 1' if you want to start it forced)!\n";
    exit 1;
}
elsif ( $Opts{f} && !$CommonObject{PIDObject}->PIDCreate( Name => $PIDLockName ) ) {
    print "NOTICE: otrs.ITSMChangesCheck.pl is already running but is starting again!\n";
}

# set new PID
$CommonObject{PIDObject}->PIDCreate(
    Name  => $PIDLockName,
    Force => 1,
    TTL   => 60 * 60 * 2,    # 2 hours
);

# do change/workorder reminder notification jobs

my $SystemTime = $CommonObject{TimeObject}->SystemTime();
my $Now        = $CommonObject{TimeObject}->SystemTime2TimeStamp(
    SystemTime => $SystemTime,
);

# notifications for changes' plannedXXXtime events
for my $Type (qw(StartTime EndTime)) {

    # get changes with PlannedStartTime older than now
    my $PlannedChangeIDs = $CommonObject{ChangeObject}->ChangeSearch(
        "Planned${Type}OlderDate" => $Now,
        MirrorDB                  => 1,
        UserID                    => 1,
    ) || [];

    CHANGEID:
    for my $ChangeID ( @{$PlannedChangeIDs} ) {

        # get change data
        my $Change = $CommonObject{ChangeObject}->ChangeGet(
            ChangeID => $ChangeID,
            UserID   => 1,
        );

        # skip change if there is already an actualXXXtime set or notification was sent
        next CHANGEID if $Change->{"Actual$Type"};

        my $LastNotificationSentDate = ChangeNotificationSent(
            %CommonObject,
            ChangeID => $ChangeID,
            Type     => "Planned${Type}",
        );

        my $AlreadySentWithinPeriod = SentWithinPeriod(
            %CommonObject,
            LastNotificationSentDate => $LastNotificationSentDate,
        );

        next CHANGEID if $AlreadySentWithinPeriod;

        # trigger ChangePlannedStartTimeReachedPost-Event
        $MockedObject->EventHandler(
            Event => "ChangePlanned${Type}ReachedPost",
            Data  => {
                ChangeID => $ChangeID,
            },
            UserID => 1,
        );
    }

    # get changes with actualxxxtime
    my $ActualChangeIDs = $CommonObject{ChangeObject}->ChangeSearch(
        "Actual${Type}OlderDate" => $Now,
        MirrorDB                 => 1,
        UserID                   => 1,
    ) || [];

    ACTUALCHANGEID:
    for my $ChangeID ( @{$ActualChangeIDs} ) {

        # get change data
        my $Change = $CommonObject{ChangeObject}->ChangeGet(
            ChangeID => $ChangeID,
            UserID   => 1,
        );

        my $LastNotificationSentDate = ChangeNotificationSent(
            %CommonObject,
            ChangeID => $ChangeID,
            Type     => "Actual${Type}",
        );

        next ACTUALCHANGEID if $LastNotificationSentDate;

        # trigger Event
        $MockedObject->EventHandler(
            Event => "ChangeActual${Type}ReachedPost",
            Data  => {
                ChangeID => $ChangeID,
            },
            UserID => 1,
        );
    }
}

# get changes with actualxxxtime
my $RequestedTimeChangeIDs = $CommonObject{ChangeObject}->ChangeSearch(
    RequestedTimeOlderDate => $Now,
    MirrorDB               => 1,
    UserID                 => 1,
) || [];

CHANGEID:
for my $ChangeID ( @{$RequestedTimeChangeIDs} ) {

    # get change data
    my $Change = $CommonObject{ChangeObject}->ChangeGet(
        ChangeID => $ChangeID,
        UserID   => 1,
    );

    my $LastNotificationSentDate = ChangeNotificationSent(
        %CommonObject,
        ChangeID => $ChangeID,
        Type     => "RequestedTime",
    );

    next CHANGEID if $LastNotificationSentDate;

    # trigger Event
    $MockedObject->EventHandler(
        Event => "ChangeRequestedTimeReachedPost",
        Data  => {
            ChangeID => $ChangeID,
        },
        UserID => 1,
    );
}

# notifications for workorders' plannedXXXtime events
for my $Type (qw(StartTime EndTime)) {

    # get workorders with PlannedStartTime older than now
    my $PlannedWorkOrderIDs = $CommonObject{WorkOrderObject}->WorkOrderSearch(
        "Planned${Type}OlderDate" => $Now,
        MirrorDB                  => 1,
        UserID                    => 1,
    ) || [];

    WORKORDERID:
    for my $WorkOrderID ( @{$PlannedWorkOrderIDs} ) {

        # get workorder data
        my $WorkOrder = $CommonObject{WorkOrderObject}->WorkOrderGet(
            WorkOrderID => $WorkOrderID,
            UserID      => 1,
        );

        # skip workorder if there is already an actualXXXtime set or notification was sent
        next WORKORDERID if $WorkOrder->{"Actual$Type"};

        my $LastNotificationSentDate = WorkOrderNotificationSent(
            %CommonObject,
            WorkOrderID => $WorkOrderID,
            Type        => "Planned${Type}",
        );

        my $AlreadySentWithinPeriod = SentWithinPeriod(
            %CommonObject,
            LastNotificationSentDate => $LastNotificationSentDate,
        );

        next WORKORDERID if $AlreadySentWithinPeriod;

        # trigger WorkOrderPlannedStartTimeReachedPost-Event
        $MockedObject->EventHandler(
            Event => "WorkOrderPlanned${Type}ReachedPost",
            Data  => {
                WorkOrderID => $WorkOrderID,
                ChangeID    => $WorkOrder->{ChangeID},
            },
            UserID => 1,
        );
    }

    # get workorders with actualxxxtime
    my $ActualWorkOrderIDs = $CommonObject{WorkOrderObject}->WorkOrderSearch(
        "Actual${Type}OlderDate" => $Now,
        MirrorDB                 => 1,
        UserID                   => 1,
    ) || [];

    WORKORDERID:
    for my $WorkOrderID ( @{$ActualWorkOrderIDs} ) {

        # get workorder data
        my $WorkOrder = $CommonObject{WorkOrderObject}->WorkOrderGet(
            WorkOrderID => $WorkOrderID,
            UserID      => 1,
        );

        my $LastNotificationSentDate = WorkOrderNotificationSent(
            %CommonObject,
            WorkOrderID => $WorkOrderID,
            Type        => "Actual${Type}",
        );

        next WORKORDERID if $LastNotificationSentDate;

        # trigger Event
        $MockedObject->EventHandler(
            Event => "WorkOrderActual${Type}ReachedPost",
            Data  => {
                WorkOrderID => $WorkOrderID,
                ChangeID    => $WorkOrder->{ChangeID},
            },
            UserID => 1,
        );
    }
}

# delete pid lock
$CommonObject{PIDObject}->PIDDelete( Name => $PIDLockName );

# check if a notification was already sent for the given change
sub ChangeNotificationSent {
    my (%CommonObject) = @_;

    # check needed stuff
    for my $Needed (qw(ChangeID Type)) {
        return if !$CommonObject{$Needed};
    }

    # get history entries
    my $History = $CommonObject{HistoryObject}->ChangeHistoryGet(
        ChangeID => $CommonObject{ChangeID},
        UserID   => 1,
    );

    # search for notifications sent earlier
    for my $HistoryEntry ( reverse @{$History} ) {
        if (
            $HistoryEntry->{HistoryType} eq 'Change' . $CommonObject{Type} . 'Reached'
            && $HistoryEntry->{ContentNew} =~ m{ Notification \s Sent $ }xms
            )
        {
            return $HistoryEntry->{CreateTime};
        }
    }

    return;
}

# check if a notification was already sent for the given workorder
sub WorkOrderNotificationSent {
    my (%CommonObject) = @_;

    # check needed stuff
    for my $Needed (qw(WorkOrderID Type)) {
        return if !$CommonObject{$Needed};
    }

    # get history entries
    my $History = $CommonObject{HistoryObject}->WorkOrderHistoryGet(
        WorkOrderID => $CommonObject{WorkOrderID},
        UserID      => 1,
    );

    # search for notifications sent earlier
    for my $HistoryEntry ( reverse @{$History} ) {
        if (
            $HistoryEntry->{HistoryType} eq 'WorkOrder' . $CommonObject{Type} . 'Reached'
            && $HistoryEntry->{ContentNew} =~ m{ Notification \s Sent }xms
            )
        {
            return $HistoryEntry->{CreateTime};
        }
    }

    return;
}

sub SentWithinPeriod {

    my (%CommonObject) = @_;

    return if !$CommonObject{LastNotificationSentDate};

    # get SysConfig option
    my $Config = $CommonObject{ConfigObject}->Get('ITSMChange::TimeReachedNotifications');

    # if notifications should be sent only once
    return 1 if $Config->{Frequency} eq 'once';

    # get epoche seconds of send time
    my $SentEpoche = $CommonObject{TimeObject}->TimeStamp2SystemTime(
        String => $CommonObject{LastNotificationSentDate},
    );

    # calc diff
    my $EpocheSinceSent = $SystemTime - $SentEpoche;
    my $HoursSinceSent = int( $EpocheSinceSent / ( 60 * 60 ) );

    if ( $HoursSinceSent >= $Config->{Hours} ) {
        return;
    }

    return 1;
}

exit(0);
