# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::da_ITSMCore;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAITSMCore
    $Self->{Translation}->{'Alternative to'} = 'Alternativ til';
    $Self->{Translation}->{'Availability'} = 'Tilgængelighed';
    $Self->{Translation}->{'Back End'} = 'Backend';
    $Self->{Translation}->{'Connected to'} = 'Forbundet til';
    $Self->{Translation}->{'Current State'} = 'Nuværende tilstand';
    $Self->{Translation}->{'Demonstration'} = 'Demonstration';
    $Self->{Translation}->{'Depends on'} = 'Afhænger af';
    $Self->{Translation}->{'End User Service'} = 'Kundeservice';
    $Self->{Translation}->{'Errors'} = 'Fejl';
    $Self->{Translation}->{'Front End'} = 'Frontend';
    $Self->{Translation}->{'IT Management'} = 'IT Management';
    $Self->{Translation}->{'IT Operational'} = 'IT operationel';
    $Self->{Translation}->{'Impact'} = 'Påvirkning';
    $Self->{Translation}->{'Incident State'} = 'Incident tilstand';
    $Self->{Translation}->{'Includes'} = 'Indkludere';
    $Self->{Translation}->{'Other'} = 'Andre';
    $Self->{Translation}->{'Part of'} = 'Del af';
    $Self->{Translation}->{'Project'} = 'Projekt';
    $Self->{Translation}->{'Recovery Time'} = 'Genetableringstid';
    $Self->{Translation}->{'Relevant to'} = 'Relevant for';
    $Self->{Translation}->{'Reporting'} = 'Reportering';
    $Self->{Translation}->{'Required for'} = 'Kræves for';
    $Self->{Translation}->{'Resolution Rate'} = 'Løsningsrate';
    $Self->{Translation}->{'Response Time'} = 'Reaktionstid';
    $Self->{Translation}->{'SLA Overview'} = 'SLA oversigt';
    $Self->{Translation}->{'Service Overview'} = 'Service oversigt';
    $Self->{Translation}->{'Service-Area'} = 'Service område';
    $Self->{Translation}->{'Training'} = 'Træning';
    $Self->{Translation}->{'Transactions'} = 'Transaktioner';
    $Self->{Translation}->{'Underpinning Contract'} = 'Underliggende kontrakt';
    $Self->{Translation}->{'allocation'} = '';

    # Template: AdminITSMCIPAllocate
    $Self->{Translation}->{'Criticality <-> Impact <-> Priority'} = 'Kritikalitet <-> Påvirkning <-> Prioritet';
    $Self->{Translation}->{'Manage the priority result of combinating Criticality <-> Impact.'} =
        '';
    $Self->{Translation}->{'Priority allocation'} = '';

    # Template: AdminSLA
    $Self->{Translation}->{'Minimum Time Between Incidents'} = 'Minimumstid mellem Incidents';

    # Template: AdminService
    $Self->{Translation}->{'Criticality'} = 'Kritikalitet';

    # Template: AgentITSMSLAZoom
    $Self->{Translation}->{'SLA Information'} = '';
    $Self->{Translation}->{'Last changed'} = 'Sidst ændret';
    $Self->{Translation}->{'Last changed by'} = 'Sidst ændret af';
    $Self->{Translation}->{'Associated Services'} = 'Tilknyttede services';

    # Template: AgentITSMServiceZoom
    $Self->{Translation}->{'Service Information'} = '';
    $Self->{Translation}->{'Current incident state'} = '';
    $Self->{Translation}->{'Associated SLAs'} = 'Tilknyttede SLAs';

    # Perl Module: Kernel/Modules/AgentITSMServicePrint.pm
    $Self->{Translation}->{'Current Incident State'} = 'Nuværende Incident tilstand';

}

1;
