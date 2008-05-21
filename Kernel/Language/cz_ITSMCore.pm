# --
# Kernel/Language/cz_ITSMCore.pm - the czech translation of ITSMCore
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: cz_ITSMCore.pm,v 1.6 2008-05-21 08:39:26 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::cz_ITSMCore;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.6 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Priority Management'}                 = 'Řízení priorit';
    $Lang->{'Add a new Priority.'}                 = 'Dodat novou prioritou';
    $Lang->{'Add Priority'}                        = 'Dodat prioritou';
    $Lang->{'Criticality'}                         = 'Kritičnost';
    $Lang->{'Impact'}                              = 'Vliv';
    $Lang->{'Criticality <-> Impact <-> Priority'} = 'Kritičnost<->Vliv<->Priorita';
    $Lang->{'allocate'}                            = 'Určen';
    $Lang->{'Relevant to'}                         = 'Relevantní';
    $Lang->{'Includes'}                            = 'zahrnuté';
    $Lang->{'Part of'}                             = 'část';
    $Lang->{'Depends on'}                          = 'Zaleží';
    $Lang->{'Required for'}                        = ' Požadovaný';
    $Lang->{'Connected to'}                        = 'Spojen s';
    $Lang->{'Alternative to'}                      = 'Alternativní';

    return 1;
}

1;
