# --
# Kernel/Language/de_ITSMCore.pm - the german translation of ITSMCore
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: de_ITSMCore.pm,v 1.10 2008-03-19 15:19:40 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::de_ITSMCore;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.10 $) [1];

sub Data {
    my ($Self) = @_;
    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Priority Management'}                 = 'Priorität Verwaltung';
    $Lang->{'Add a new Priority.'}                 = 'Eine neue Priorität hinzufügen.';
    $Lang->{'Add Priority'}                        = 'Priorität hinzufügen';
    $Lang->{'Criticality'}                         = 'Kritikalität';
    $Lang->{'Impact'}                              = 'Auswirkung';
    $Lang->{'Criticality <-> Impact <-> Priority'} = 'Kritikalität <-> Auswirkung <-> Priorität';
    $Lang->{'allocate'}                            = 'zuordnen';
    $Lang->{'Relevant to'}                         = 'Relevant für';
    $Lang->{'Includes'}                            = 'Beinhaltet';
    $Lang->{'Part of'}                             = 'Teil von';
    $Lang->{'Depends on'}                          = 'Hängt ab von';
    $Lang->{'Required for'}                        = 'Benötigt für';
    $Lang->{'Connected to'}                        = 'Verbunden mit';
    $Lang->{'Alternative to'}                      = 'Alternativ zu';

    return 1;
}

1;
