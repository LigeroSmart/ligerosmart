#!/usr/bin/perl -w
# --
# bin/otrs.SurveyTriggerSendRequests.pl - trigger sending delayed survey requests
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: otrs.SurveyTriggerSendRequests.pl,v 1.3 2012-11-20 19:12:44 mh Exp $
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

use vars qw($VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

use Kernel::Config;
use Kernel::System::SysConfig;
use Kernel::System::Time;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::DB;
use Kernel::System::State;
use Kernel::System::Ticket;
use Kernel::System::User;
use Kernel::System::Survey;
use Getopt::Std;

my %opts;
getopts( 'afhdev', \%opts );

my $OptsCount = scalar( keys %opts );

if (
    $opts{h}
    || ( $OptsCount < 1 )
    || ( $opts{v} && $OptsCount != 2 )
    )
{
    print STDERR "Usage: bin/$0 [-h] [-d] [-e]\n";
    print STDERR "$0 <Revision $VERSION>\n";
    print STDERR "Trigger sending delayed survey requests.\n";
    print STDERR "Usage: $0 -h (Display this help text)\n";
    print STDERR "Usage: $0 -d (Do a dry run, implies -v)\n";
    print STDERR "Usage: $0 -e (Do a real run)\n";
    print STDERR "Usage: $0 -v (Be more verbose)\n";
    print STDERR "Configuration is done using SysConfig (Survey->Core)\n";
    print STDERR "Short explanation:\n";
    print STDERR "1. Go to your SysConfig and\n";
    print STDERR "   - configure, Survey::SendInHoursAfterClose to a higher value than 0\n";
    print STDERR "2. Create a survey, make it master\n";
    print STDERR "3. Create a ticket, close it\n";
    print STDERR "4. Wait the necessary amount of hours you've configured\n";
    print STDERR "5. You can do a dry run to get a list of surveys that would be sent (-d)\n";
    print STDERR "6. If you're fine with it, activate var/cron/generic_agent_survey.dist\n";
    print STDERR "Copyright (C) 2001-2012 OTRS AG, http://otrs.com/\n";
    exit;
}

# a dry run implies verbosity
if ( $opts{d} ) {
    $opts{v} = 1;
}

# common objects
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'OTRS-otrs.SurveyTriggerSendRequest',
    %CommonObject,
);
$CommonObject{TimeObject}      = Kernel::System::Time->new(%CommonObject);
$CommonObject{MainObject}      = Kernel::System::Main->new(%CommonObject);
$CommonObject{DBObject}        = Kernel::System::DB->new(%CommonObject);
$CommonObject{SysConfigObject} = Kernel::System::SysConfig->new(%CommonObject);
$CommonObject{TicketObject}    = Kernel::System::Ticket->new(%CommonObject);
$CommonObject{UserObject}      = Kernel::System::User->new(%CommonObject);
$CommonObject{StateObject}     = Kernel::System::State->new(%CommonObject);
$CommonObject{SurveyObject}    = Kernel::System::Survey->new(%CommonObject);

my $SendInHoursAfterClose = $CommonObject{ConfigObject}->Get('Survey::SendInHoursAfterClose');
if ( !$SendInHoursAfterClose ) {
    if ( $opts{v} ) {
        print "No days configured in Survey::SendInHoursAfterClose.\n";
    }
    exit 1;
}

# Find survey_requests that haven't been sent yet
$CommonObject{DBObject}->Prepare(
    SQL => "SELECT id, ticket_id, create_time FROM survey_request WHERE "
        . "(send_time IS NULL OR send_time = '0000-00-00 00:00:00') ORDER BY create_time DESC",
);

# fetch the result
my @Rows;
while ( my @Row = $CommonObject{DBObject}->FetchrowArray() ) {
    push @Rows, {
        ID         => $Row[0],
        TicketID   => $Row[1],
        CreateTime => $Row[2],
    };
}

# Get SystemTime in UnixTime
my $Now = $CommonObject{TimeObject}->SystemTime();

SURVEYREQUEST:
for my $Line (@Rows) {
    for my $Val (qw(ID TicketID CreateTime)) {
        if ( !$Line->{$Val} ) {
            if ( $opts{v} ) {
                print "$Val missing in service_request row.\n";
            }
            next SURVEYREQUEST;
        }
    }

    # Convert create_time to unixtime
    my $CreateTime
        = $CommonObject{TimeObject}->TimeStamp2SystemTime( String => $Line->{CreateTime} );

    # don't send for survey_requests that are younger than CreateTime + $SendINHoursAfterClose
    if ( $SendInHoursAfterClose * 3600 + $CreateTime > $Now ) {
        if ( $opts{v} ) {
            print
                "Did not send for survey_request with id $Line->{ID} becaue send time was't reached yet.\n";
        }
        next SURVEYREQUEST;
    }

    if ( $opts{v} ) {
        print
            "Sending survey for survey_request with id $Line->{ID} that belongs to TicketID $Line->{TicketID}.\n";
    }
    if ( !$opts{d} && $Line->{ID} && $Line->{TicketID} ) {
        $CommonObject{SurveyObject}->RequestSend(
            TriggerSendRequests => 1,
            SurveyRequestID     => $Line->{ID},
            TicketID            => $Line->{TicketID},
        );
    }
}

exit 1;

1;
