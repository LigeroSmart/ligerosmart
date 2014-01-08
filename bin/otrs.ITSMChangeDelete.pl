#!/usr/bin/perl
# --
# bin/otrs.ITSMChangeDelete.pl - to delete changes
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

use Getopt::Long;
use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::Time;
use Kernel::System::DB;
use Kernel::System::User;
use Kernel::System::Group;
use Kernel::System::ITSMChange;
use Kernel::System::GeneralCatalog;

# common objects
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'OTRS-ITSMChangeDelete.pl',
    %CommonObject,
);
$CommonObject{MainObject}   = Kernel::System::Main->new(%CommonObject);
$CommonObject{TimeObject}   = Kernel::System::Time->new(%CommonObject);
$CommonObject{DBObject}     = Kernel::System::DB->new(%CommonObject);
$CommonObject{UserObject}   = Kernel::System::User->new(%CommonObject);
$CommonObject{GroupObject}  = Kernel::System::Group->new(%CommonObject);
$CommonObject{ChangeObject} = Kernel::System::ITSMChange->new(%CommonObject);

print "otrs.ITSMChangeDelete.pl - ";
print "delete changes (all or by number).\n";
print "Copyright (C) 2001-2014 OTRS AG, http://otrs.com/\n";

my $Help          = '';
my $All           = '';
my @ChangeNumbers = ();

GetOptions(
    'help'              => \$Help,
    'all'               => \$All,
    'ChangeNumber=s{,}' => \@ChangeNumbers,
);

# delete all changes
if ($All) {

    # get all change ids
    my @ChangesIDs = @{ $CommonObject{ChangeObject}->ChangeList( UserID => 1 ) };

    # get number of changes
    my $ChangeCount = scalar @ChangesIDs;

    # if there are any changes to delete
    if ($ChangeCount) {

        print "Are you sure that you want to delete ALL $ChangeCount changes? ";
        print "This is irrevocable. [y/n] ";
        chomp( my $Confirmation = lc <STDIN> );

        # if the user confirms the deletion
        if ( $Confirmation eq 'y' ) {

            # delete changes
            print "Deleting all changes...\n";
            DeleteChanges( %CommonObject, ChangesIDs => \@ChangesIDs );
        }
        else {
            exit 1;
        }
    }
    else {
        print "There are NO changes to delete.\n";
    }
}

# delete listed changes
elsif (@ChangeNumbers) {

    my @ChangesIDs;

    for my $ChangeNumber (@ChangeNumbers) {

        # checks the validity of the change id
        my $ID = $CommonObject{ChangeObject}->ChangeLookup(
            ChangeNumber => $ChangeNumber,
        );

        if ($ID) {
            push @ChangesIDs, $ID;
        }
        else {
            print "Unable to find change $ChangeNumber.\n";
        }
    }

    # delete changes (if any valid number was given)
    if (@ChangesIDs) {
        print "Deleting specified changes...\n";
        DeleteChanges( %CommonObject, ChangesIDs => \@ChangesIDs );
    }
}

# show usage
else {
    print "Usage: $0 [options] \n";
    print "  Options are as follows:\n";
    print "  --help                         display this option help\n";
    print "  --all                          delete all changes\n";
    print "  --ChangeNumber no1 no2 no3     delete listed changes\n";
    exit 1;
}

1;

sub DeleteChanges {

    # get parameters
    my (%CommonObject) = @_;

    my $DeletedChanges = 0;

    # delete specified changes
    for my $ChangeID ( @{ $CommonObject{ChangesIDs} } ) {
        my $True = $CommonObject{ChangeObject}->ChangeDelete(
            ChangeID => $ChangeID,
            UserID   => 1,
        );
        if ( !$True ) {
            print "Unable to delete change with id $ChangeID\n";
        }
        else {
            $DeletedChanges++;
        }
    }
    print "$DeletedChanges changes have been deleted.\n\n";

    return 1;
}
