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
    LogPrefix    => 'OTRS-otrs.CheckDB.pl',
    ConfigObject => $CommonObject{ConfigObject},
);
$CommonObject{MainObject}     = Kernel::System::Main->new(%CommonObject);
$CommonObject{SourceDBObject} = Kernel::System::DB->new(%CommonObject)
    || die "Could not connect to source DB";

# create CloneDB backend object
$CommonObject{CloneDBBackendObject} = Kernel::System::CloneDB::Backend->new(%CommonObject)
    || die "Could not create clone db object.";

# get the target DB settings
my $TargetDBSettings
    = $CommonObject{ConfigObject}->Get('CloneDB::TargetDBSettings');

# create DB connections
my $TargetDBObject = $CommonObject{CloneDBBackendObject}->CreateTargetDBConnection(
    TargetDBSettings => $TargetDBSettings,
);
die "Could not create target DB connection." if !$TargetDBObject;

my %Options = ();
getopt( 'rh', \%Options );

if ( exists $Options{h} ) {
    _Help();
    exit 1;
}

if ( exists $Options{r} ) {
    my $SanityResult = $CommonObject{CloneDBBackendObject}->SanityChecks(
        TargetDBObject => $TargetDBObject,
    );
    if ($SanityResult) {
        my $DataTransferResult = $CommonObject{CloneDBBackendObject}->DataTransfer(
            TargetDBObject => $TargetDBObject,
        );
        die "Was not possible to complete the data transfer." if !$DataTransferResult;
    }
    exit 1;
}

_Help();
exit 1;

sub _Help {
    print STDERR <<EOF;
$0 migrate OTRS databases
Copyright (C) 2001-2011 OTRS AG, http://otrs.org/

Usage: $0 -r

This script clones an OTRS database into a target database, even
on another database platform. It will dynamically get the list of tables in the
source DB, and copy the data of each table to the target DB.

Currently, only MySQL, PostgreSQL, Oracle and MSSQL are supported as a source platform, but this will
be extended in future.

Instructions:
    - Configure target database settings on SysConfig for this package (OTRSCloneDB).
    - Create the needed data structures of OTRS (first part) and installed packages in the target database.
        - Only the the otrs-schema.\$DB.sql files should be used, not the otrs-schema-post.\$DB.sql files.
        - Also for installed packages, the SQL (first part only) must be generated and executed.
    - Run this script.
    - Apply the second part of the data structure definitions (foreign key constraints etc.).
        - Now the otrs-schema-post.\$DB.sql files should be used.
        - Also for the installed packages
    - Verify the result.

EOF
    exit 1;
}
