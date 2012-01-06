#!/usr/bin/perl -w
# --
# bin/otrs.CloneDB.pl - migrate OTRS databases
# Copyright (C) 2003-2012 OTRS AG, http://otrs.com/
# --
# $Id: otrs.CloneDB.pl,v 1.2 2012-01-06 10:42:09 mg Exp $
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

use Getopt::Std;
use MIME::Base64;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::DB;

#
# Target DB settings
#
my $TargetDatabaseHost = 'localhost';
my $TargetDatabase     = 'otrs31_dev';
my $TargetDatabaseUser = 'otrs31_dev';
my $TargetDatabasePw   = 'otrs31_dev';
my $TargetDatabaseDSN  = "DBI:mysql:database=$TargetDatabase;host=$TargetDatabaseHost;";
my $TargetDatabaseType = "mysql";

#
# OTRS stores binary data in some columns. On some database systems,
#   these are handled differently (data is converted to base64-encoding before
#   it is stored. Here is the list of these columns which need special treatment.
#
my %BlobColumns = (
    'article_plain.body'          => 1,
    'article_attachment.content'  => 1,
    'virtual_fs_db.content'       => 1,
    'web_upload_cache.content'    => 1,
    'standard_attachment.content' => 1,
);

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
$CommonObject{TargetDBObject} = Kernel::System::DB->new(
    %CommonObject,
    DatabaseDSN  => $TargetDatabaseDSN,
    DatabaseUser => $TargetDatabaseUser,
    DatabasePw   => $TargetDatabasePw,
    Type         => $TargetDatabaseType,
) || die "Could not connect to target DB";

my %Options = ();
getopt( 'rh', \%Options );

if ( exists $Options{h} ) {
    _Help();
    exit 1;
}

if ( exists $Options{r} ) {
    if ( SanityChecks() ) {
        DataTransfer();
        exit 0;
    }
    exit 1;
}

_Help();
exit 1;

sub _Help {
    print STDERR <<EOF;
$0 <Revision $VERSION> - migrate OTRS databases
Copyright (C) 2001-2011 OTRS AG, http://otrs.org/

Usage: $0 -r

This little script clones an OTRS database into a target database, even
on another database platform. It will dynamically get the list of tables in the
source DB, and copy the data of each table to the target DB.

Currently, only PostgreSQL is supported as a source platform, but this will
be extended in future.

Instructions:
    - Configure target database settings in this script.
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

#
# Some up-front sanity checks
#
sub SanityChecks {
    if ( $CommonObject{ConfigObject}->{DatabaseDSN} eq $TargetDatabaseDSN ) {
        die "Error: Source and target database DSN are the same!";
    }

    my @Tables = _TablesList(
        DBObject => $CommonObject{SourceDBObject},
    );

    for my $Table (@Tables) {
        my $Target_RowCount = _RowCount(
            DBObject => $CommonObject{TargetDBObject},
            Table    => $Table,
        );

        if ( !defined $Target_RowCount ) {
            die "Error: required table '$Table' does not seem to exist in the target database!";
        }

        if ( $Target_RowCount > 0 ) {
            die "Error: table '$Table' in the target database already contains data!";
        }
    }

    return 1;
}

#
# Transfer the actual table data
#

sub DataTransfer {
    my @Tables = _TablesList(
        DBObject => $CommonObject{SourceDBObject},
    );

    for my $Table (@Tables) {
        print "Converting table $Table...\n";

        # Get the list of columns of this table to be able to
        #   generate correct INSERT statements.
        my @Columns = _ColumnsList(
            Table    => $Table,
            DBObject => $CommonObject{SourceDBObject},
        );
        my $ColumnsString = join( ', ', @Columns );
        my $BindString = join ', ', map {'?'} @Columns;
        my $SQL = "INSERT INTO $Table ($ColumnsString) VALUES ($BindString)";

        my $_RowCount = _RowCount(
            DBObject => $CommonObject{SourceDBObject},
            Table    => $Table,
        );
        my $Counter = 1;

        # Now fetch all the data and insert it to the target DB.
        $CommonObject{SourceDBObject}->Prepare(
            SQL => "
                SELECT *
                FROM $Table",
            Limit => 4_000_000_000,
        ) || die @!;

        while ( my @Row = $CommonObject{SourceDBObject}->FetchrowArray() ) {

            # If the two databases have different blob handling (base64), convert
            #   columns that need it.
            if (
                $CommonObject{SourceDBObject}->GetDatabaseFunction('DirectBlob')
                != $CommonObject{TargetDBObject}->GetDatabaseFunction('DirectBlob')
                )
            {
                for my $ColumnCounter ( 1 .. $#Columns ) {
                    my $Column = $Columns[$ColumnCounter];

                    next if ( !$BlobColumns{"$Table.$Column"} );

                    if ( !$CommonObject{SourceDBObject}->GetDatabaseFunction('DirectBlob') ) {
                        $Row[$ColumnCounter] = decode_base64( $Row[$ColumnCounter] );
                    }

                    if ( !$CommonObject{TargetDBObject}->GetDatabaseFunction('DirectBlob') ) {
                        $CommonObject{EncodeObject}->EncodeOutput( \$Row[$ColumnCounter] );
                        $Row[$ColumnCounter] = encode_base64( $Row[$ColumnCounter] );
                    }

                }

            }
            my @Bind = map { \$_ } @Row;

            print "    Inserting $Counter of $_RowCount\n" if $Counter % 1000 == 0;

            $CommonObject{TargetDBObject}->Do(
                SQL  => $SQL,
                Bind => \@Bind,
            ) || die @!;

            $Counter++;
        }

        print "Finished converting table $Table.\n";
    }
}

#
# List all tables in the source database in alphabetical order.
#
sub _TablesList {
    my %Param = @_;

    if ( $Param{DBObject}->{'DB::Type'} eq 'postgresql' ) {

        $Param{DBObject}->Prepare(
            SQL => "
                SELECT table_name
                FROM information_schema.tables
                WHERE table_name !~ '^pg_+'
                    AND table_schema != 'information_schema'
                ORDER BY table_name ASC"
        ) || die @!;
    }
    else {
        die
            "_TablesList() is not yet implemented for database type $Param{DBObject}->{'DB::Type'}!";
    }

    my @Result;
    while ( my @Row = $Param{DBObject}->FetchrowArray() ) {
        push @Result, $Row[0];
    }
    return @Result;
}

#
# List all columns of a table in the order of their position.
#
sub _ColumnsList {
    my %Param = @_;

    if ( $Param{DBObject}->{'DB::Type'} eq 'postgresql' ) {

        $Param{DBObject}->Prepare(
            SQL => "
                SELECT column_name
                FROM information_schema.columns
                WHERE table_name = ?
                ORDER BY ordinal_position ASC",
            Bind => [
                \$Param{Table},
            ],
        ) || die @!;

    }
    else {
        die
            "_ColumnsList() is not yet implemented for database type $Param{DBObject}->{'DB::Type'}!";
    }

    my @Result;
    while ( my @Row = $Param{DBObject}->FetchrowArray() ) {
        push @Result, $Row[0];
    }
    return @Result;
}

#
# Get row count of a table.
#
sub _RowCount {
    my %Param = @_;

    $Param{DBObject}->Prepare(
        SQL => "
            SELECT COUNT(*)
            FROM $Param{Table}",
    ) || die @!;
    my $Result;
    while ( my @Row = $Param{DBObject}->FetchrowArray() ) {
        $Result = $Row[0];
    }
    return $Result;
}
