# --
# Kernel/Language/da_ITSMCore.pm - provides da (Danish) language translation
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: da_ITSMCore.pm,v 1.2 2010-08-12 21:08:43 en Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::da_ITSMCore;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Criticality'}                         = 'Kritikalitet';
    $Lang->{'Impact'}                              = 'Påvirkning';
    $Lang->{'Criticality <-> Impact <-> Priority'} = 'Kritikalitet <-> Påvirkning <-> Prioritet';
    $Lang->{'allocate'}                            = 'tildele';
    $Lang->{'Relevant to'}                         = 'Relevant for';
    $Lang->{'Includes'}                            = 'Indkludere';
    $Lang->{'Part of'}                             = 'Del af';
    $Lang->{'Depends on'}                          = 'Afhænger af';
    $Lang->{'Required for'}                        = 'Kræves for';
    $Lang->{'Connected to'}                        = 'Forbundet til';
    $Lang->{'Alternative to'}                      = 'Alternativ til';
    $Lang->{'Incident State'}                      = 'Incident tilstand';
    $Lang->{'Current Incident State'}              = 'Nuværende Incident tilstand';
    $Lang->{'Current State'}                       = 'Nuværende tilstand';
    $Lang->{'Service-Area'}                        = 'Service område';
    $Lang->{'Minimum Time Between Incidents'}      = 'Minimumstid mellem Incidents';
    $Lang->{'Service Overview'}                    = 'Service oversigt';
    $Lang->{'SLA Overview'}                        = 'SLA oversigt';
    $Lang->{'Associated Services'}                 = 'Tilknyttede services';
    $Lang->{'Associated SLAs'}                     = 'Tilknyttede SLAs';
    $Lang->{'Back End'}                            = 'Backend';
    $Lang->{'Demonstration'}                       = 'Demonstration';
    $Lang->{'End User Service'}                    = 'Kundeservice';
    $Lang->{'Front End'}                           = 'Frontend';
    $Lang->{'IT Management'}                       = 'IT Management';
    $Lang->{'IT Operational'}                      = 'IT operationel';
    $Lang->{'Other'}                               = 'Andre';
    $Lang->{'Project'}                             = 'Projekt';
    $Lang->{'Reporting'}                           = 'Reportering';
    $Lang->{'Training'}                            = 'Træning';
    $Lang->{'Underpinning Contract'}               = 'Underliggende kontrakt';
    $Lang->{'Availability'}                        = 'Tilgængelighed';
    $Lang->{'Errors'}                              = 'Fejl';
    $Lang->{'Other'}                               = 'Andre';
    $Lang->{'Recovery Time'}                       = 'Genetableringstid';
    $Lang->{'Resolution Rate'}                     = 'Løsningsrate';
    $Lang->{'Response Time'}                       = 'Reaktionstid';
    $Lang->{'Transactions'}                        = 'Transaktioner';
    $Lang->{'This setting controls the name of the application as is shown in the web interface as well as the tabs and title bar of your web browser.'} = '';
    $Lang->{'Determines the way the linked objects are displayed in each zoom mask.'} = '';
    $Lang->{'List of online repositories (for example you also can use other installations as repositoriy by using Key="http://example.com/otrs/public.pl?Action=PublicRepository&File=" and Content="Some Name").'} = '';

    return 1;
}

1;
