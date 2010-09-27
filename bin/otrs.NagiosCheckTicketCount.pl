#!/usr/bin/perl -w
# --
# otrs.NagiosCheckTicketCount.pl - OTRS Nagios checker
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: otrs.NagiosCheckTicketCount.pl,v 1.2 2010-09-27 21:39:54 jb Exp $
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

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';

use Getopt::Std;
my %opts;
getopts( 'hNc:', \%opts );
if ( $opts{h} ) {
    print
        "Usage: $FindBin::Script [-N (runs as Nagioschecker)] [-c /path/to/config_file]\n";
    print "\n";
    exit;
}

if ( !$opts{c} ) {
    print STDERR "ERROR: Need -c CONFIGFILE\n";
    exit 1;
}
elsif ( !-e $opts{c} ) {
    print STDERR "ERROR: No such file $opts{c}\n";
    exit 1;
}

# read config file
my %Config;
open( my $IN, '<', $opts{c} ) || die "ERROR: Can't open $opts{c}: $!\n";
my $Content = '';
while (<$IN>) {
    $Content .= $_;
}
if ( !eval $Content ) {
    print STDERR "ERROR: Invalid config file $opts{c}: $@\n";
    exit 1;
}

use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Log;
use Kernel::System::Time;
use Kernel::System::Main;
use Kernel::System::DB;
use Kernel::System::Ticket;

# create common objects
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new(%CommonObject);
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{LogObject}    = Kernel::System::Log->new(
    %CommonObject,
    LogPrefix => 'otrs.NagiosCheckTicketCount'
);
$CommonObject{TimeObject}   = Kernel::System::Time->new(%CommonObject);
$CommonObject{MainObject}   = Kernel::System::Main->new(%CommonObject);
$CommonObject{DBObject}     = Kernel::System::DB->new(%CommonObject);
$CommonObject{TicketObject} = Kernel::System::Ticket->new(%CommonObject);

# search tickets
my $TicketCount = $CommonObject{TicketObject}->TicketSearch(
    %{ $Config{Search} },
    Limit  => 100_000,
    Result => 'COUNT',
    UserID => 1,
);

# no checker mode
if ( !$opts{N} ) {
    print "$TicketCount\n";
    exit 0;
}

# cleanup config file
my %Map = (
    max_crit_treshhold => 'max_crit_treshold',
    max_warn_treshhold => 'max_warn_treshold',
    min_crit_treshhold => 'min_crit_treshold',
    min_warn_treshhold => 'min_warn_treshold',
);
for my $Type ( keys %Map ) {
    if ( defined $Config{$Type} ) {
        print STDERR "NOTICE: Typo in config name, use $Map{$Type} instead of $Type\n";
        $Config{ $Map{$Type} } = $Config{$Type};
        delete $Config{$Type};
    }
}

# do critical and warning check
for my $Type (qw(crit_treshold warn_treshold)) {
    if ( defined $Config{ 'min_' . $Type } ) {
        if ( $Config{ 'min_' . $Type } >= $TicketCount ) {
            if ( $Type =~ /^crit_/ ) {
                print
                    "$Config{checkname} CRITICAL $Config{CRIT_TXT} $TicketCount|tickets=$TicketCount;$Config{min_warn_treshold}:$Config{max_warn_treshold};$Config{min_crit_treshold}:$Config{max_crit_treshold}\n";
                exit 2;
            }
            elsif ( $Type =~ /^warn_/ ) {
                print
                    "$Config{checkname} WARNING $Config{WARN_TXT} $TicketCount|tickets=$TicketCount;$Config{min_warn_treshold}:$Config{max_warn_treshold};$Config{min_crit_treshold}:$Config{max_crit_treshold}\n";
                exit 1;
            }
        }
    }
    if ( defined $Config{ 'max_' . $Type } ) {
        if ( $Config{ 'max_' . $Type } <= $TicketCount ) {
            if ( $Type =~ /^crit_/ ) {
                print
                    "$Config{checkname} CRITICAL $Config{CRIT_TXT} $TicketCount|tickets=$TicketCount;$Config{min_warn_treshold}:$Config{max_warn_treshold};$Config{min_crit_treshold}:$Config{max_crit_treshold}\n";
                exit 2;
            }
            elsif ( $Type =~ /^warn_/ ) {
                print
                    "$Config{checkname} WARNING $Config{WARN_TXT} $TicketCount|tickets=$TicketCount;$Config{min_warn_treshold}:$Config{max_warn_treshold};$Config{min_crit_treshold}:$Config{max_crit_treshold}\n";
                exit 1;
            }
        }
    }
}

# return ok
print
    "$Config{checkname} OK $Config{OK_TXT} $TicketCount|tickets=$TicketCount;$Config{min_warn_treshold}:$Config{max_warn_treshold};$Config{min_crit_treshold}:$Config{max_crit_treshold}\n";
exit 0;
