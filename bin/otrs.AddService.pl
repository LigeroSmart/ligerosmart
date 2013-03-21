#!/usr/bin/perl
# --
# bin/otrs.AddService.pl - add new Services
# Copyright (C) 2001-2013 OTRS AG, http://otrs.org/
# --
# $Id: otrs.AddService.pl,v 1.7 2013-03-21 11:46:40 ub Exp $
# $OldId: otrs.AddService.pl,v 1.7 2013/01/22 10:14:09 mg Exp $
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

use vars qw($VERSION);
$VERSION = qw($Revision: 1.7 $) [1];

use Getopt::Std;

use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Log;
use Kernel::System::DB;
use Kernel::System::Main;
use Kernel::System::Service;
# ---
# ITSM
# ---
use Kernel::System::GeneralCatalog;
# ---

my %Param;
my %CommonObject;

# create common objects
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{LogObject}
    = Kernel::System::Log->new( %CommonObject, LogPrefix => 'OTRS-otrs.AddService' );
$CommonObject{MainObject}    = Kernel::System::Main->new(%CommonObject);
$CommonObject{DBObject}      = Kernel::System::DB->new(%CommonObject);
$CommonObject{ServiceObject} = Kernel::System::Service->new(%CommonObject);

# ---
# ITSM
# ---
$CommonObject{CatalogObject} = Kernel::System::GeneralCatalog->new(%CommonObject);
# ---
my $NoOptions = $ARGV[0] ? 0 : 1;

# get options
my %Opts;
# ---
# ITSM
# ---
#getopts( 'hn:p:c:', \%Opts );
getopts( 'hn:p:c:C:t:', \%Opts );
# ---

if ( $Opts{h} || $NoOptions ) {
    print STDERR "Usage: $FindBin::Script -n <Name> -p <Parent> -c <Comment>\n";
# ---
# ITSM
# ---
    print STDERR "-C Criticality -t <Type>\n";
# ---
    exit;
}

if ( !$Opts{n} ) {
    print STDERR "ERROR: Need -n <Name>\n";
    exit 1;
}

my $ServiceName;

# lookup parent service if given
if ( $Opts{p} ) {
    $Param{ParentID} = $CommonObject{ServiceObject}->ServiceLookup(
        Name   => $Opts{p},
        UserID => 1,
    );
    if ( !$Param{ParentID} ) {
        print STDERR "ERROR: Can't add Service: Parent '$Opts{p}' does not exist!\n";
        exit 1;
    }
    $ServiceName = $Opts{p} . '::';
}

$ServiceName .= $Opts{n};

# check if service already exists
my %ServiceList = $CommonObject{ServiceObject}->ServiceList(
    Valid  => 0,
    UserID => 1,
);
my %Reverse = reverse %ServiceList;
if ( $Reverse{$ServiceName} ) {
    print STDERR "ERROR: Can't add Service: Service '$ServiceName' already exists!\n";
    exit 1;
}
# ---
# ITSM
# ---

# get criticality list
my $CriticalityList = $CommonObject{CatalogObject}->ItemList(
    Class => 'ITSM::Core::Criticality',
);
my %Criticality = reverse %{$CriticalityList};
$Param{CriticalityID} = $Criticality{ $Opts{C} || '' };
if ( !defined $Param{CriticalityID} ) {
    if ( !$Opts{C} ) {
        print STDERR "Error: Can't add Service: No criticality given via -C option!\n";
    }
    elsif ( !defined $Param{CriticalityID} ) {
        print STDERR "Error: Can't add Service: Criticality '$Opts{C}' unknown!\n";
    }
    print "\nAvailable options are:\n\n";
    for my $Criticality ( sort keys %Criticality ) {
        print "\t'$Criticality'\n";
    }
    exit 1;
}

# get service type list
my $ServiceTypeList = $CommonObject{CatalogObject}->ItemList(
    Class => 'ITSM::Service::Type',
);

my %ServiceType = reverse %{$ServiceTypeList};
$Param{TypeID} = $ServiceType{ $Opts{t} || '' };
if ( !defined $Param{TypeID} ) {
    if ( !$Opts{t} ) {
        print STDERR "Error: Can't add Service: No service type given via -t option!\n";
    }
    elsif ( !defined $Param{TypeID} ) {
        print STDERR "Error: Can't add Service: Service type '$Opts{t}' unknown!\n";
    }
    print "\nAvailable options are:\n\n";
    for my $ServiceType ( sort keys %ServiceType ) {
        print "\t'$ServiceType'\n";
    }
    exit 1;
}

# ---

# user id of the person adding the record
$Param{UserID} = '1';

# Validrecord
$Param{ValidID} = '1';
$Param{Name}    = $Opts{n} || '';
$Param{Comment} = $Opts{c};

if ( my $ID = $CommonObject{ServiceObject}->ServiceAdd(%Param) ) {
    print "Service '$ServiceName' added. ID is '$ID'\n";
}
else {
    print STDERR "ERROR: Can't add Service\n";
    exit 1;
}

exit(0);
