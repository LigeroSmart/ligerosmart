# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::sw_ITSMCore;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAITSMCore
    $Self->{Translation}->{'Alternative to'} = 'Badala ya ';
    $Self->{Translation}->{'Availability'} = 'Upatikanaji';
    $Self->{Translation}->{'Back End'} = 'Mazingira ya nyuma';
    $Self->{Translation}->{'Connected to'} = 'Imeunganishwa na';
    $Self->{Translation}->{'Current State'} = 'Hali ya sasa';
    $Self->{Translation}->{'Demonstration'} = 'Maonyesho';
    $Self->{Translation}->{'Depends on'} = 'Inategemeana na ';
    $Self->{Translation}->{'End User Service'} = 'Huduma ya mtumiaji wa mwihso';
    $Self->{Translation}->{'Errors'} = 'Makosa';
    $Self->{Translation}->{'Front End'} = 'Mazingira ya mbele';
    $Self->{Translation}->{'IT Management'} = 'Usimamizi wa IT';
    $Self->{Translation}->{'IT Operational'} = 'Uendeshaji wa IT';
    $Self->{Translation}->{'Impact'} = 'Madhara';
    $Self->{Translation}->{'Incident State'} = 'Hali ya tukio';
    $Self->{Translation}->{'Includes'} = 'Inahusisha';
    $Self->{Translation}->{'Other'} = 'Engine';
    $Self->{Translation}->{'Part of'} = 'Sehemu ya';
    $Self->{Translation}->{'Project'} = 'Mradi';
    $Self->{Translation}->{'Recovery Time'} = 'Muda wa kupona';
    $Self->{Translation}->{'Relevant to'} = 'Husiana na';
    $Self->{Translation}->{'Reporting'} = 'Uarifu';
    $Self->{Translation}->{'Required for'} = 'Inahitajika kwa';
    $Self->{Translation}->{'Resolution Rate'} = 'Kiwango cha muonekano';
    $Self->{Translation}->{'Response Time'} = 'Muda wa majibu';
    $Self->{Translation}->{'SLA Overview'} = 'Marejeo ya SLA';
    $Self->{Translation}->{'Service Overview'} = 'Marejeo ya huduma';
    $Self->{Translation}->{'Service-Area'} = 'Eneo la huduma';
    $Self->{Translation}->{'Training'} = 'Mafunzo';
    $Self->{Translation}->{'Transactions'} = 'Miamala';
    $Self->{Translation}->{'Underpinning Contract'} = 'Mkataba wa kuimarisha';
    $Self->{Translation}->{'allocation'} = 'Ugawaji';

    # Template: AdminITSMCIPAllocate
    $Self->{Translation}->{'Criticality <-> Impact <-> Priority'} = 'Umuhimu <-> Madhara <-> Kipaumbele';
    $Self->{Translation}->{'Manage the priority result of combinating Criticality <-> Impact.'} =
        'Simamia matokeo ya kipaumbele ya kuunganisha Umuhimu ';
    $Self->{Translation}->{'Priority allocation'} = 'Kuweka kipaumbele';

    # Template: AdminSLA
    $Self->{Translation}->{'Minimum Time Between Incidents'} = 'Kima cha chini cha muda kati ya matukio';

    # Template: AdminService
    $Self->{Translation}->{'Criticality'} = 'Umuhimu';

    # Template: AgentITSMSLAZoom
    $Self->{Translation}->{'SLA Information'} = 'Taarifa za SLA';
    $Self->{Translation}->{'Last changed'} = 'Mwisho kubadilishwa';
    $Self->{Translation}->{'Last changed by'} = 'Mwsho kubadilishwa na';
    $Self->{Translation}->{'Associated Services'} = 'Huduma zinazohusika';

    # Template: AgentITSMServiceZoom
    $Self->{Translation}->{'Service Information'} = 'Taarifa za huduma';
    $Self->{Translation}->{'Current incident state'} = 'Hali ya tukio la sasa';
    $Self->{Translation}->{'Associated SLAs'} = 'SLA zinazohusika';

    # Perl Module: Kernel/Modules/AgentITSMServicePrint.pm
    $Self->{Translation}->{'Current Incident State'} = 'Hali ya tukio la sasa';

}

1;
