# --
# Kernel/Language/de_ITSMLocation.pm - the german translation of ITSMLocation
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: de_ITSMLocation.pm,v 1.1 2008-06-21 12:45:18 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::de_ITSMLocation;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Location'}            = 'Lokation';
    $Lang->{'Location-Area'}       = 'Lokation-Bereich';
    $Lang->{'Location Management'} = 'Lokation Verwaltung';
    $Lang->{'Add Location'}        = 'Lokation hinzufügen';
    $Lang->{'Add a new Location.'} = 'Eine neue Lokation hinzufügen.';
    $Lang->{'Sub-Location of'}     = 'Unterlokation von';
    $Lang->{'Address'}             = 'Adresse';
    $Lang->{'Building'}            = 'Gebäude';
    $Lang->{'Floor'}               = 'Etage';
    $Lang->{'IT Facility'}         = 'IT Einrichtung';
    $Lang->{'Office'}              = 'Büro';
    $Lang->{'Other'}               = 'Sonstiges';
    $Lang->{'Outlet'}              = 'Anschlussdose';
    $Lang->{'Rack'}                = 'Rack';
    $Lang->{'Room'}                = 'Raum';
    $Lang->{'Workplace'}           = 'Arbeitsplatz';

    return 1;
}

1;
