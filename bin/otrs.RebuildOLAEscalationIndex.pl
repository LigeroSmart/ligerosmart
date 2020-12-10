#!/usr/bin/perl
# --
# otrs.RebuildOLAEscalationIndex.pl - rebuild escalation index
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

use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';
use lib dirname($RealBin) . '/Custom';

use Getopt::Std;
use Time::HiRes qw(usleep);

use Kernel::System::ObjectManager;

# get options
my %Opts;
getopt( 'bo', \%Opts );
if ( $Opts{h} ) {
    print "otrs.RebuildOLAEscalationIndex.pl - rebuild escalation index\n";
    print "usage: otrs.RebuildOLAEscalationIndex.pl [-b sleeptime per ticket in microseconds] [-o yes]\n";
    print "       -o yes = executes only on open tickets\n";
    exit 1;
}

# create object manager
local $Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'OTRS-otrs.RebuildEscalationIndex.pl',
    },
);

# disable cache
$Kernel::OM->Get('Kernel::System::Cache')->Configure(
    CacheInMemory  => 0,
    CacheInBackend => 1,
);

# disable ticket events
$Kernel::OM->Get('Kernel::Config')->{'Ticket::EventModulePost'} = {};

my %OpenStates;

if (defined $Opts{o} && $Opts{o} eq 'yes') 
{
    $OpenStates{StateType} = ['open','new','pending reminder','pending auto'];
}

# get all tickets
my @TicketIDs = $Kernel::OM->Get('Kernel::System::Ticket')->TicketSearch(
    # Only on Open
    %OpenStates,

    # result (required)
    Result => 'ARRAY',

    # result limit
    Limit      => 100_000_000,
    UserID     => 1,
    Permission => 'ro',


);

my $Count = 0;
TICKETID:
for my $TicketID (@TicketIDs) {
    print $TicketID."\n";
    $Count++;

    $Kernel::OM->Get('Kernel::System::Ticket::Event::OLA')->Run(
        Data =>{
            TicketID => $TicketID,
        },
        Event => 'RebuildIndex', # Just to not be empty
        Config => '1',
        UserID   => 1,
    );

    if ( $Count % 2000 == 0 ) {
        my $Percent = int( $Count / ( $#TicketIDs / 100 ) );
        print "NOTICE: $Count of $#TicketIDs processed ($Percent% done).\n";
    }

    next TICKETID if !$Opts{b};

    Time::HiRes::usleep( $Opts{b} );
}

print "NOTICE: Index creation done.\n";

exit 0;
