#!/usr/bin/perl -w
# --
# otrs.NagiosCheck.pl - OTRS Nagios checker
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: otrs.NagiosCheck.pl,v 1.2 2008-09-11 18:34:15 martin Exp $
# --
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
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
getopt( 'c', \%opts );
if ( $opts{h} ) {
    print "Usage: $FindBin::Script [-N (runs as Nagioschecker)] [-v (verbose)] [-c /path/to/config_file]\n";
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
open (my $IN, '<', $opts{c} ) || die "ERROR: Can't open $opts{c}: $!\n";
my $Content = '';
while (<$IN>) {
    $Content .= $_;
}
if ( !eval $Content ) {
    print STDERR "ERROR: Invalid config file $opts{c}: $@\n";
    exit 1;
}

use Kernel::Config;
use Kernel::System::Log;
use Kernel::System::Time;
use Kernel::System::Main;
use Kernel::System::DB;
use Kernel::System::Ticket;

# create common objects
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new(%CommonObject);
$CommonObject{LogObject}    = Kernel::System::Log->new( %CommonObject, LogPrefix => 'otrs.NagiosCheck' );
$CommonObject{TimeObject}   = Kernel::System::Time->new(%CommonObject);
$CommonObject{MainObject}   = Kernel::System::Main->new(%CommonObject);
$CommonObject{DBObject}     = Kernel::System::DB->new(%CommonObject);
$CommonObject{TicketObject} = Kernel::System::Ticket->new(%CommonObject);

# search tickets
my @TicketIDs = $CommonObject{TicketObject}->TicketSearch(
    %{ $Config{Search} },
    Limit  => 100_000,
    Result => 'ARRAY',
    UserID => 1,
);
my $TicketCount = scalar @TicketIDs;

# verbose mode
if ( $opts{v} ) {
    for my $TicketID (@TicketIDs) {
        my %Ticket = $CommonObject{TicketObject}->TicketGet( TicketID => $TicketID );
        print STDERR "$Ticket{TicketID}:$Ticket{TicketNumber}\n";
    }
}

# no checker mode
if ( !$opts{N} ) {
    print "$TicketCount\n";
    exit 0;
}

# do critical and warning check
for my $Type (qw(crit_treshhold warn_treshhold)) {
    if ( defined $Config{ 'min_' . $Type } ) {
        if ( $Config{ 'min_' . $Type } >= $TicketCount ) {
            if ( $Type =~ /^crit_/ ) {
                print "$Config{checkname} CRITICAL $Config{CRIT_TXT} $TicketCount\n";
                exit 2;
            }
            elsif ( $Type =~ /^warn_/ ) {
                print "$Config{checkname} WARNING $Config{WARN_TXT} $TicketCount\n";
                exit 1;
            }
        }
    }
    if ( defined $Config{ 'max_' . $Type } ) {
        if ( $Config{ 'max_' . $Type } <= $TicketCount ) {
            if ( $Type =~ /^crit_/ ) {
                print "$Config{checkname} CRITICAL $Config{CRIT_TXT} $TicketCount\n";
                exit 2;
            }
            elsif ( $Type =~ /^warn_/ ) {
                print "$Config{checkname} WARNING $Config{WARN_TXT} $TicketCount\n";
                exit 1;
            }
        }
    }
}

# return ok
print "$Config{checkname} OK $Config{OK_TXT} $TicketCount|tickets=$TicketCount\n";
exit 0;
