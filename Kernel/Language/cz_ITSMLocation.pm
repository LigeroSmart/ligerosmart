# --
# Kernel/Language/cz_ITSMLocation.pm - the czech translation of ITSMLocation
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: cz_ITSMLocation.pm,v 1.1 2008-06-21 12:45:18 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::cz_ITSMLocation;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Location'}            = 'Lokalita';
    $Lang->{'Location-Area'}       = '';
    $Lang->{'Location Management'} = 'Řízení lokality - míst';
    $Lang->{'Add Location'}        = 'Dodat lokalitu';
    $Lang->{'Add a new Location.'} = 'Můžete dodat novou lokalitu';
    $Lang->{'Sub-Location of'}     = 'Sublokalita - čeho';
    $Lang->{'Address'}             = 'Adresa';
    $Lang->{'Building'}            = 'Budova';
    $Lang->{'Floor'}               = 'Patro';
    $Lang->{'IT Facility'}         = 'IT zařízení /prostor';
    $Lang->{'Office'}              = 'Kancelář';
    $Lang->{'Other'}               = 'Ostatní';
    $Lang->{'Outlet'}              = 'Výstup';
    $Lang->{'Rack'}                = 'Skříň = rack';
    $Lang->{'Room'}                = 'Místnost';
    $Lang->{'Workplace'}           = 'Pracoviště';

    return 1;
}

1;
