# --
# Kernel/Language/fr_ITSMCore.pm - the french translation of ITSMCore
# Copyright (C) 2001-2009 Olivier Sallou <olivier.sallou at irisa.fr>
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: fr_ITSMCore.pm,v 1.4 2010-06-01 19:25:22 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::fr_ITSMCore;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.4 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Criticality'}                         = 'Criticité';
    $Lang->{'Impact'}                              = 'Impact';
    $Lang->{'Criticality <-> Impact <-> Priority'} = 'Criticité <-> Impact <-> Priorité';
    $Lang->{'allocation'}                          = 'alloue';
    $Lang->{'Priority allocation'}                 = '';
    $Lang->{'Relevant to'}                         = 'Correspond à';
    $Lang->{'Includes'}                            = 'Inclus';
    $Lang->{'Part of'}                             = 'Part de';
    $Lang->{'Depends on'}                          = 'Dépend de';
    $Lang->{'Required for'}                        = 'Requis pour';
    $Lang->{'Connected to'}                        = 'Lié à';
    $Lang->{'Alternative to'}                      = 'Alternative à';
    $Lang->{'Incident State'}                      = 'Etat d\'incident';
    $Lang->{'Current Incident State'}              = 'Etat actuel d\'incident';
    $Lang->{'Current State'}                       = 'Etat actuel';
    $Lang->{'Service-Area'}                        = 'Zone de service';
    $Lang->{'Minimum Time Between Incidents'}      = 'Temps minimal entre les incidents';
    $Lang->{'Service Overview'}                    = 'Aperçu des services';
    $Lang->{'SLA Overview'}                        = 'Aperçu des SLA';
    $Lang->{'Associated Services'}                 = 'Services associés';
    $Lang->{'Associated SLAs'}                     = 'SLAs associées';
    $Lang->{'Back End'}                            = 'Backend';
    $Lang->{'Demonstration'}                       = 'Démonstration';
    $Lang->{'End User Service'}                    = 'Service utilisateur';
    $Lang->{'Front End'}                           = 'Frontend';
    $Lang->{'IT Management'}                       = 'Gestion IT';
    $Lang->{'IT Operational'}                      = 'Opérations IT';
    $Lang->{'Other'}                               = 'Autre';
    $Lang->{'Project'}                             = 'Projet';
    $Lang->{'Reporting'}                           = 'Rapport';
    $Lang->{'Training'}                            = 'Formation';
    $Lang->{'Underpinning Contract'}               = 'Contrat externe';
    $Lang->{'Availability'}                        = 'Disponibilité';
    $Lang->{'Errors'}                              = 'Erreurs';
    $Lang->{'Other'}                               = 'Autre';
    $Lang->{'Recovery Time'}                       = 'Temps de réparation';
    $Lang->{'Resolution Rate'}                     = 'Taux de résolution';
    $Lang->{'Response Time'}                       = 'Temps de réponse';
    $Lang->{'Transactions'}                        = 'Transactions';

    return 1;
}

1;
