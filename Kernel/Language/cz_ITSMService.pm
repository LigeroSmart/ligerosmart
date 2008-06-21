# --
# Kernel/Language/cz_ITSMService.pm - the czech translation of ITSMService
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: cz_ITSMService.pm,v 1.1 2008-06-21 12:45:18 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::cz_ITSMService;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Current State'}                  = '';
    $Lang->{'Service-Area'}                   = '';
    $Lang->{'Minimum Time Between Incidents'} = 'Minimální čas mezi incidenty';
    $Lang->{'Associated SLAs'}                = 'Přidružené SLA smliuvy';
    $Lang->{'Back End'}                       = 'Základní schéma/BackEnd';
    $Lang->{'Demonstration'}                  = 'Demonstrace';
    $Lang->{'End User Service'}               = 'Služby koncových uživatelů';
    $Lang->{'Front End'}                      = 'Zákaznický systém/FrontEnd';
    $Lang->{'IT Management'}                  = 'Řízení IT';
    $Lang->{'IT Operational'}                 = 'IT Operace';
    $Lang->{'Other'}                          = 'Další';
    $Lang->{'Project'}                        = 'Projekt';
    $Lang->{'Reporting'}                      = 'Zpravodajství';
    $Lang->{'Training'}                       = 'Školení';
    $Lang->{'Underpinning Contract'}          = 'Základní smlouva';
    $Lang->{'Availability'}                   = 'Dostupnost';
    $Lang->{'Errors'}                         = 'Chyby';
    $Lang->{'Other'}                          = 'Další';
    $Lang->{'Recovery Time'}                  = 'Doba obnovení';
    $Lang->{'Resolution Rate'}                = 'Doba řešení';
    $Lang->{'Response Time'}                  = 'Doba odpovědi';
    $Lang->{'Transactions'}                   = 'Obchody/transakce';

    return 1;
}

1;
