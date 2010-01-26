#!/usr/bin/perl -w
# --
# bin/otrs.ITSMChangesCheck.pl - check pending tickets
# Copyright (C) 2003-2010 OTRS AG, http://otrs.com/
# --
# $Id: otrs.ITSMChangesCheck.pl,v 1.1 2010-01-26 15:55:31 reb Exp $
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
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
# or see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

use Date::Pcalc qw(Day_of_Week Day_of_Week_Abbreviation);
use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Time;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::DB;
use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::ITSMWorkOrder;

use base 'Kernel::System::Event';

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
$CommonObject{ChangeObject}    = Kernel::System::ITSMChange->new(%CommonObject);
$CommonObject{WorkOrderObject} = Kernel::System::ITSMChange::ITSMWorkOrder->new(%CommonObject);
$CommonObject{HistoryObject}   = Kernel::System::ITSMChange::History->new(%CommonObject);

# check args
my $Command = shift || '--help';
print "otrs.ITSMChangesCheck.pl <Revision $VERSION> - check itsm changes\n";
print "Copyright (C) 2003-2010 OTRS AG, http://otrs.com/\n";

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

        my $LastNotificationSentDate = NotificationSent($ChangeID);

        next CHANGEID if SentWithinPeriod($LastNotificationSentDate);

        # trigger ChangePlannedStartTimeReachedPost-Event
        $Self->EventHandler(
            Event => "ChangePlanned${Type}ReachedPost",
            Data  => {
                ChangeID => $ChangeID,
            },
            UserID => $Param{UserID},
        );
    }

    # get changes with actualxxxtime
    my $ActualChangeIDs = $CommonObject{ChangeObject}->ChangeSearch(
        "Actual${Type}OlderDate" => $Now,
    ) || [];

    CHANGEID:
    for my $ChangeID ( @{$ActualChangeIDs} ) {

        # get change data
        my $Change = $CommonObject{ChangeObject}->ChangeGet(
            ChangeID => $ChangeID,
            UserID   => 1,
        );

        my $LastNotificationSentDate = NotificationSent($ChangeID);

        next CHANGEID if $LastNotificationSentDate;

        # trigger ChangePlannedStartTimeReachedPost-Event
        $Self->EventHandler(
            Event => "ChangePlanned${Type}ReachedPost",
            Data  => {
                ChangeID => $ChangeID,
            },
            UserID => $Param{UserID},
        );
    }
}

# check if a notification was already sent for the given change
sub NotificationSent {
    my ($ChangeID) = @_;

    my $History = $CommonObject{HistoryObject}->ChangeHistoryGet(
        ChangeID => $ChangeID,
        UserID   => 1,
    );

    for my $HistoryEntry ( @{$History} ) {
        if (
            $HistoryEntry->{HistoryType}   eq 'ChangePlannedStartTimeReached'
            && $HistoryEntry->{ContentNew} eq 'Notification Sent'
            )
        {
            return 1;
        }
    }

    return 0;
}

sub SentWithinPeriod {
    return 0;
}

exit(0);
