# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::nl_ITSMCore;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAITSMCore
    $Self->{Translation}->{'Alternative to'} = 'Alternatief voor';
    $Self->{Translation}->{'Availability'} = 'Beschikbaarheid';
    $Self->{Translation}->{'Back End'} = 'Backend';
    $Self->{Translation}->{'Connected to'} = 'Verbonden met';
    $Self->{Translation}->{'Current State'} = 'Huidige status';
    $Self->{Translation}->{'Demonstration'} = 'Demonstration';
    $Self->{Translation}->{'Depends on'} = 'Afhankelijk van';
    $Self->{Translation}->{'End User Service'} = 'Eindgebruiker service';
    $Self->{Translation}->{'Errors'} = 'Fouten';
    $Self->{Translation}->{'Front End'} = 'Frontend';
    $Self->{Translation}->{'IT Management'} = 'IT Management';
    $Self->{Translation}->{'IT Operational'} = 'IT Operations';
    $Self->{Translation}->{'Impact'} = 'Impact';
    $Self->{Translation}->{'Incident State'} = 'Incident status';
    $Self->{Translation}->{'Includes'} = 'Bevat';
    $Self->{Translation}->{'Other'} = 'Overig';
    $Self->{Translation}->{'Part of'} = 'Onderdeel van';
    $Self->{Translation}->{'Project'} = 'Project';
    $Self->{Translation}->{'Recovery Time'} = 'Hersteltijd';
    $Self->{Translation}->{'Relevant to'} = 'Van belang voor';
    $Self->{Translation}->{'Reporting'} = 'Rapportage';
    $Self->{Translation}->{'Required for'} = 'Benodigd voor';
    $Self->{Translation}->{'Resolution Rate'} = 'Oplostijd';
    $Self->{Translation}->{'Response Time'} = 'Responsietijd';
    $Self->{Translation}->{'SLA Overview'} = 'SLA-overzicht';
    $Self->{Translation}->{'Service Overview'} = 'Service-overzicht';
    $Self->{Translation}->{'Service-Area'} = 'Service-Area';
    $Self->{Translation}->{'Training'} = 'Training';
    $Self->{Translation}->{'Transactions'} = 'Transacties';
    $Self->{Translation}->{'Underpinning Contract'} = 'Underpinning Contract';
    $Self->{Translation}->{'allocation'} = 'toekennen';

    # Template: AdminITSMCIPAllocate
    $Self->{Translation}->{'Criticality <-> Impact <-> Priority'} = 'Urgentie <-> Impact <-> Prioriteit';
    $Self->{Translation}->{'Manage the priority result of combinating Criticality <-> Impact.'} =
        '';
    $Self->{Translation}->{'Priority allocation'} = 'Prioriteit toekennen';

    # Template: AdminSLA
    $Self->{Translation}->{'Minimum Time Between Incidents'} = 'Minimumtijd tussen incidenten';

    # Template: AdminService
    $Self->{Translation}->{'Criticality'} = 'Urgentie';

    # Template: AgentITSMSLAZoom
    $Self->{Translation}->{'SLA Information'} = 'SLA Informatie';
    $Self->{Translation}->{'Last changed'} = 'Laatst aangepast op';
    $Self->{Translation}->{'Last changed by'} = 'Laatst aangepast door';
    $Self->{Translation}->{'Associated Services'} = 'Bijbehorende Services';

    # Template: AgentITSMServiceZoom
    $Self->{Translation}->{'Service Information'} = 'Service Informatie';
    $Self->{Translation}->{'Current incident state'} = 'Huidige incident-status';
    $Self->{Translation}->{'Associated SLAs'} = 'Bijbehorende SLAs';

    # Perl Module: Kernel/Modules/AgentITSMServicePrint.pm
    $Self->{Translation}->{'Current Incident State'} = 'Huidige incident status';

}

1;
