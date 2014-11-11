#!/usr/bin/perl
# --
# bin/otrs.SurveyTriggerSendRequests.pl - trigger sending delayed survey requests
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
use lib dirname($RealBin) . "/Kernel/cpan-lib";

use Getopt::Std;

use Kernel::System::ObjectManager;

# create common objects
local $Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'OTRS-otrs.SurveyTriggerSendRequest',
    },
);

my %Opts;
getopts( 'afhdev', \%Opts );

my $OptsCount = scalar( keys %Opts );

if (
    $Opts{h}
    || ( $OptsCount < 1 )
    || ( $Opts{v} && $OptsCount != 2 )
    )
{
    print <<EOF;
otrs.SurveyTriggerSendRequests.pl - Trigger sending delayed survey requests
Copyright (C) 2001-2014 OTRS AG, http://otrs.org/

Usage:

    bin/$0 [-h] [-d] [-e]

    bin/$0 -h   # (Display this help text)
    bin/$0 -d   # (Do a dry run, implies -v)
    bin/$0 -e   # (Do a real run)
    bin/$0 -v   # (Be more verbose)

    # Configuration is done using SysConfig (Survey->Core)
    # Short explanation:
    #     1. Go to your SysConfig and
    #        - configure, Survey::SendInHoursAfterClose to a higher value than 0
    #     2. Create a survey, make it master
    #     3. Create a ticket, close it
    #     4. Wait the necessary amount of hours you've configured
    #     5. You can do a dry run to get a list of surveys that would be sent (-d)
    #     6. If you're fine with it, activate var/cron/generic_agent_survey.dist
EOF
    exit 0;
}

# a dry run implies verbosity
if ( $Opts{d} ) {
    $Opts{v} = 1;
}

my $SendInHoursAfterClose = $Kernel::OM->Get('Kernel::Config')->Get('Survey::SendInHoursAfterClose');
if ( !$SendInHoursAfterClose ) {
    if ( $Opts{v} ) {
        print "No days configured in Survey::SendInHoursAfterClose.\n";
    }

    exit 1;
}

# get database object
my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

# Find survey_requests that haven't been sent yet
exit 1 if !$DBObject->Prepare(
    SQL => '
        SELECT id, ticket_id, create_time, public_survey_key
        FROM survey_request
        WHERE send_time IS NULL
        ORDER BY create_time DESC',
);

# fetch the result
my @Rows;
while ( my @Row = $DBObject->FetchrowArray() ) {
    push @Rows, {
        ID              => $Row[0],
        TicketID        => $Row[1],
        CreateTime      => $Row[2],
        PublicSurveyKey => $Row[3],
    };
}

# get time object
my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

# Get SystemTime in UnixTime
my $Now = $TimeObject->SystemTime();

SURVEYREQUEST:
for my $Line (@Rows) {
    for my $Val (qw(ID TicketID CreateTime)) {
        if ( !$Line->{$Val} ) {
            if ( $Opts{v} ) {
                print "$Val missing in service_request row.\n";
            }
            next SURVEYREQUEST;
        }
    }

    # Convert create_time to unixtime
    my $CreateTime = $TimeObject->TimeStamp2SystemTime(
        String => $Line->{CreateTime},
    );

    # don't send for survey_requests that are younger than CreateTime + $SendINHoursAfterClose
    if ( $SendInHoursAfterClose * 3600 + $CreateTime > $Now ) {
        if ( $Opts{v} ) {
            print
                "Did not send for survey_request with id $Line->{ID} because send time wasn't reached yet.\n";
        }
        next SURVEYREQUEST;
    }

    if ( $Opts{v} ) {
        print
            "Sending survey for survey_request with id $Line->{ID} that belongs to TicketID $Line->{TicketID}.\n";
    }
    if ( !$Opts{d} && $Line->{ID} && $Line->{TicketID} ) {
        $Kernel::OM->Get('Kernel::System::Survey')->RequestSend(
            TriggerSendRequests => 1,
            SurveyRequestID     => $Line->{ID},
            TicketID            => $Line->{TicketID},
            PublicSurveyKey     => $Line->{PublicSurveyKey},
        );
    }
}

exit 1;
