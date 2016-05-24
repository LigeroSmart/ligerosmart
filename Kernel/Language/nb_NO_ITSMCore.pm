# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::nb_NO_ITSMCore;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAITSMCore
    $Self->{Translation}->{'Alternative to'} = 'Alternativ til';
    $Self->{Translation}->{'Availability'} = 'Tilgjengelighet';
    $Self->{Translation}->{'Back End'} = 'Backend';
    $Self->{Translation}->{'Connected to'} = 'Koblet til';
    $Self->{Translation}->{'Current State'} = 'Nåværende tilstand';
    $Self->{Translation}->{'Demonstration'} = 'Demonstrasjon';
    $Self->{Translation}->{'Depends on'} = 'Avhenger av';
    $Self->{Translation}->{'End User Service'} = 'Sluttbruker-tjeneste';
    $Self->{Translation}->{'Errors'} = 'Feil';
    $Self->{Translation}->{'Front End'} = 'Frontend';
    $Self->{Translation}->{'IT Management'} = 'IT-ledelse';
    $Self->{Translation}->{'IT Operational'} = 'IT-drift';
    $Self->{Translation}->{'Impact'} = 'Omfang';
    $Self->{Translation}->{'Incident State'} = 'Hendelsestilstand';
    $Self->{Translation}->{'Includes'} = 'Inkluderer';
    $Self->{Translation}->{'Other'} = 'Andre';
    $Self->{Translation}->{'Part of'} = 'Del av';
    $Self->{Translation}->{'Project'} = 'Prosjekt';
    $Self->{Translation}->{'Recovery Time'} = 'Gjenoppretningstid';
    $Self->{Translation}->{'Relevant to'} = 'Relevant for';
    $Self->{Translation}->{'Reporting'} = 'Rapportering';
    $Self->{Translation}->{'Required for'} = 'Påkrevd for';
    $Self->{Translation}->{'Resolution Rate'} = 'Opprettingsratio';
    $Self->{Translation}->{'Response Time'} = 'Responstid';
    $Self->{Translation}->{'SLA Overview'} = 'SLA-oversikt';
    $Self->{Translation}->{'Service Overview'} = 'Tjeneste-oversikt';
    $Self->{Translation}->{'Service-Area'} = 'Tjenesteområde';
    $Self->{Translation}->{'Training'} = 'Trening';
    $Self->{Translation}->{'Transactions'} = 'Transaksjoner';
    $Self->{Translation}->{'Underpinning Contract'} = 'Underliggende kontrakt';
    $Self->{Translation}->{'allocation'} = 'tildeling';

    # Template: AdminITSMCIPAllocate
    $Self->{Translation}->{'Criticality <-> Impact <-> Priority'} = 'Kritikalitet <-> Omfang <-> Prioritet';
    $Self->{Translation}->{'Manage the priority result of combinating Criticality <-> Impact.'} =
        'Administrer prioritetsresultat ved å kombinere Kritikalitet <-> Omfang';
    $Self->{Translation}->{'Priority allocation'} = 'Tildeling av prioritet';

    # Template: AdminSLA
    $Self->{Translation}->{'Minimum Time Between Incidents'} = 'Minimumstid mellom Hendelser';

    # Template: AdminService
    $Self->{Translation}->{'Criticality'} = 'Kritikalitet';

    # Template: AgentITSMSLAZoom
    $Self->{Translation}->{'SLA Information'} = 'Informasjon om SLA';
    $Self->{Translation}->{'Last changed'} = 'Sist endret';
    $Self->{Translation}->{'Last changed by'} = 'Sist endret av';
    $Self->{Translation}->{'Associated Services'} = 'Tilknyttede tjenester';

    # Template: AgentITSMServiceZoom
    $Self->{Translation}->{'Service Information'} = 'Informasjon om Tjeneste';
    $Self->{Translation}->{'Current incident state'} = 'Tilstand på nåværende hendelse';
    $Self->{Translation}->{'Associated SLAs'} = 'Tilknyttede SLAer';

    # Perl Module: Kernel/Modules/AgentITSMServicePrint.pm
    $Self->{Translation}->{'Current Incident State'} = 'Tilstand på nåværende hendelse';

}

1;
