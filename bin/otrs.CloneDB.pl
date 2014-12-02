#!/usr/bin/perl
# --
# bin/otrs.CloneDB.pl - migrate OTRS databases
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

use Getopt::Std;

$| = 1;    # auto-flush console output

use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::DB;
use Kernel::System::CloneDB::Backend;

# create common objects
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{LogObject}    = Kernel::System::Log->new(
    %CommonObject,
    LogPrefix => 'OTRS-otrs.CloneDB.pl',
);
$CommonObject{MainObject}     = Kernel::System::Main->new(%CommonObject);
$CommonObject{SourceDBObject} = Kernel::System::DB->new(%CommonObject)
    || die "Could not connect to source DB";

# create CloneDB backend object
$CommonObject{CloneDBBackendObject} = Kernel::System::CloneDB::Backend->new(%CommonObject)
    || die "Could not create clone db object.";

# get the target DB settings
my $TargetDBSettings = $CommonObject{ConfigObject}->Get('CloneDB::TargetDBSettings');

# create DB connections
my $TargetDBObject = $CommonObject{CloneDBBackendObject}->CreateTargetDBConnection(
    TargetDBSettings => $TargetDBSettings,
);
die "Could not create target DB connection." if !$TargetDBObject;

my %Options = ();
getopt( 'h', \%Options );

if ( exists $Options{h} ) {
    _Help();
    exit 0;
}

if ( exists $Options{r} || exists $Options{n} ) {
    if ( !exists $Options{n} ) {
        $CommonObject{CloneDBBackendObject}->PopulateTargetStructuresPre(
            TargetDBObject => $TargetDBObject,
        );
    }

    my $SanityResult = $CommonObject{CloneDBBackendObject}->SanityChecks(
        TargetDBObject => $TargetDBObject,
        DryRun         => $Options{n} || '',
    );
    if ($SanityResult) {
        my $DataTransferResult = $CommonObject{CloneDBBackendObject}->DataTransfer(
            TargetDBObject => $TargetDBObject,
            DryRun         => $Options{n} || '',
            Force          => $Options{f} || '',
        );

        die "Was not possible to complete the data transfer. \n" if !$DataTransferResult;

        if ( $DataTransferResult eq 2 ) {
            print STDERR "Dry run succesfully finished.\n";
        }
    }

    if ( !exists $Options{n} ) {
        $CommonObject{CloneDBBackendObject}->PopulateTargetStructuresPost(
            TargetDBObject => $TargetDBObject,
        );
    }

    exit 0;
}

_Help();
exit 0;

sub _Help {
    print <<EOF;
$0 migrate OTRS databases
Copyright (C) 2001-2011 OTRS AG, http://otrs.org/

This script clones an OTRS database into an empty target database, even
on another database platform. It will dynamically get the list of tables in the
source DB, and copy the data of each table to the target DB.
Please note that you first need to configure the target database via SysConfig.

Usage: $0 [-r] [-f] [-n]

    -r  Clone the data into the target database.
    -f  Continue even if there are errors while writint the data.
    -n  Dry run mode, only read and verify, but don't write to the target database.

EOF
}
