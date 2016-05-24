# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pl_ITSMCore;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAITSMCore
    $Self->{Translation}->{'Alternative to'} = 'Alternatywa dla';
    $Self->{Translation}->{'Availability'} = 'Dostępność';
    $Self->{Translation}->{'Back End'} = 'Zaplecze';
    $Self->{Translation}->{'Connected to'} = 'Połączone z';
    $Self->{Translation}->{'Current State'} = 'Bieżący Stan';
    $Self->{Translation}->{'Demonstration'} = 'Demonstracja';
    $Self->{Translation}->{'Depends on'} = 'Zależne od';
    $Self->{Translation}->{'End User Service'} = 'Usługa Użytkownika Końcowego';
    $Self->{Translation}->{'Errors'} = 'Błędy';
    $Self->{Translation}->{'Front End'} = 'Frontend';
    $Self->{Translation}->{'IT Management'} = 'IT zarządzanie';
    $Self->{Translation}->{'IT Operational'} = 'IT operacyjne';
    $Self->{Translation}->{'Impact'} = 'Wpływ';
    $Self->{Translation}->{'Incident State'} = 'Stan zdarzenia';
    $Self->{Translation}->{'Includes'} = 'Zawiera';
    $Self->{Translation}->{'Other'} = 'Inne';
    $Self->{Translation}->{'Part of'} = 'Część';
    $Self->{Translation}->{'Project'} = 'Projekt';
    $Self->{Translation}->{'Recovery Time'} = 'Czas odzyskania';
    $Self->{Translation}->{'Relevant to'} = 'Odpowiednie do';
    $Self->{Translation}->{'Reporting'} = 'Raportowanie';
    $Self->{Translation}->{'Required for'} = 'Potrzebne do';
    $Self->{Translation}->{'Resolution Rate'} = 'Czas rozwiązania';
    $Self->{Translation}->{'Response Time'} = 'Czas odpowiedzi';
    $Self->{Translation}->{'SLA Overview'} = 'Przegląd SLA';
    $Self->{Translation}->{'Service Overview'} = 'Przegląd usług';
    $Self->{Translation}->{'Service-Area'} = 'Sekcja serwisowa';
    $Self->{Translation}->{'Training'} = 'Trening';
    $Self->{Translation}->{'Transactions'} = 'Transakcje';
    $Self->{Translation}->{'Underpinning Contract'} = 'Podstawy Umowy';
    $Self->{Translation}->{'allocation'} = 'alokacja';

    # Template: AdminITSMCIPAllocate
    $Self->{Translation}->{'Criticality <-> Impact <-> Priority'} = 'Krytyczność <-> Wpływ <-> Priorytet';
    $Self->{Translation}->{'Manage the priority result of combinating Criticality <-> Impact.'} =
        'Zarządzanie wartością priorytetu dla kombinacji Krytyczność <-> Wpływ.';
    $Self->{Translation}->{'Priority allocation'} = 'Alokacja priorytetu';

    # Template: AdminSLA
    $Self->{Translation}->{'Minimum Time Between Incidents'} = 'Minimalny czas między zdarzeniami';

    # Template: AdminService
    $Self->{Translation}->{'Criticality'} = 'Krytyczność';

    # Template: AgentITSMSLAZoom
    $Self->{Translation}->{'SLA Information'} = 'Informacje SLA';
    $Self->{Translation}->{'Last changed'} = 'Ostatnia zmiana';
    $Self->{Translation}->{'Last changed by'} = 'Ostatnio zmienione przez';
    $Self->{Translation}->{'Associated Services'} = 'Połączone usługi';

    # Template: AgentITSMServiceZoom
    $Self->{Translation}->{'Service Information'} = 'Informacje o usłudze';
    $Self->{Translation}->{'Current incident state'} = 'Aktualny stan incydentu';
    $Self->{Translation}->{'Associated SLAs'} = 'Połączone SLA';

    # Perl Module: Kernel/Modules/AgentITSMServicePrint.pm
    $Self->{Translation}->{'Current Incident State'} = 'Aktualny stan incydentu';

}

1;
