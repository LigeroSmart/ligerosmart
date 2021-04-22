# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::nl_ITSMIncidentProblemManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentTicketOverviewMedium
    $Self->{Translation}->{'Criticality'} = 'Urgentie';
    $Self->{Translation}->{'Impact'} = 'Impact';

    # JS Template: ServiceIncidentState
    $Self->{Translation}->{'Service Incident State'} = 'Service Incident Status';

    # Perl Module: Kernel/Output/HTML/FilterElementPost/ITSMIncidentProblemManagement.pm
    $Self->{Translation}->{'Link ticket'} = 'Link ticket';
    $Self->{Translation}->{'Change Decision of %s%s%s'} = 'Wijzig de beslissing van %s%s%s';
    $Self->{Translation}->{'Change ITSM fields of %s%s%s'} = 'Wijzig ITSM-velden van %s%s%s';

    # Perl Module: var/packagesetup/ITSMIncidentProblemManagement.pm
    $Self->{Translation}->{'Review Required'} = 'Beoordeling vereist';
    $Self->{Translation}->{'Decision Result'} = 'Beslissingsresultaat';
    $Self->{Translation}->{'Approved'} = 'Goedgekeurd';
    $Self->{Translation}->{'Postponed'} = 'Uitgesteld';
    $Self->{Translation}->{'Pre-approved'} = 'Vooraf goedgekeurd';
    $Self->{Translation}->{'Rejected'} = 'Afgewezen';
    $Self->{Translation}->{'Repair Start Time'} = 'Reparatiestarttijd';
    $Self->{Translation}->{'Recovery Start Time'} = 'Herstel starttijd';
    $Self->{Translation}->{'Decision Date'} = 'Beslissingsdatum';
    $Self->{Translation}->{'Due Date'} = 'Vervaldatum';

    # Database XML / SOPM Definition: ITSMIncidentProblemManagement.sopm
    $Self->{Translation}->{'closed with workaround'} = 'gesloten met tijdelijke oplossing';

    # SysConfig
    $Self->{Translation}->{'Add a decision!'} = 'Voeg een beslissing toe!';
    $Self->{Translation}->{'Additional ITSM Fields'} = 'Aanvullende ITSM-velden';
    $Self->{Translation}->{'Additional ITSM ticket fields.'} = 'Aanvullende ITSM-ticketvelden.';
    $Self->{Translation}->{'Allows adding notes in the additional ITSM field screen of the agent interface.'} =
        'Hiermee kunnen opmerkingen worden toegevoegd in het aanvullende ITSM-veldscherm van de agentinterface.';
    $Self->{Translation}->{'Allows adding notes in the decision screen of the agent interface.'} =
        'Hiermee kunnen opmerkingen worden toegevoegd in het beslissingsscherm van de agentinterface.';
    $Self->{Translation}->{'Allows defining new types for ticket (if ticket type feature is enabled).'} =
        'Hiermee kunnen nieuwe typen voor tickets worden gedefinieerd (als de tickettype-functie is ingeschakeld).';
    $Self->{Translation}->{'Change the ITSM fields!'} = 'Wijzig de ITSM-velden!';
    $Self->{Translation}->{'Decision'} = 'Beslissing';
    $Self->{Translation}->{'Defines if a ticket lock is required in the additional ITSM field screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        'Bepaalt of een ticketvergrendeling vereist is in het extra ITSM-veldscherm van de agentinterface (als het ticket nog niet is vergrendeld, wordt het ticket vergrendeld en wordt de huidige agent automatisch ingesteld als eigenaar).';
    $Self->{Translation}->{'Defines if a ticket lock is required in the decision screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        'Bepaalt of een ticketvergrendeling vereist is in het beslissingsscherm van de agentinterface (als het ticket nog niet is vergrendeld, wordt het ticket vergrendeld en wordt de huidige agent automatisch ingesteld als de eigenaar).';
    $Self->{Translation}->{'Defines if the service incident state should be shown during service selection in the agent interface.'} =
        'Bepaalt of de service incident status moet worden weergegeven tijdens de serviceselectie in de agentinterface.';
    $Self->{Translation}->{'Defines the default body of a note in the additional ITSM field screen of the agent interface.'} =
        'Definieert de standaardtekst van een notitie in het aanvullende ITSM-veldscherm van de agentinterface.';
    $Self->{Translation}->{'Defines the default body of a note in the decision screen of the agent interface.'} =
        'Definieert de standaardtekst van een notitie in het beslissingsscherm van de agentinterface.';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the additional ITSM field screen of the agent interface.'} =
        'Definieert de standaard volgende status van een ticket na het toevoegen van een notitie in het aanvullende ITSM-veldscherm van de agentinterface.';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the decision screen of the agent interface.'} =
        'Definieert de standaard volgende status van een ticket na het toevoegen van een notitie in het beslissingsscherm van de agentinterface.';
    $Self->{Translation}->{'Defines the default subject of a note in the additional ITSM field screen of the agent interface.'} =
        'Definieert het standaardonderwerp van een notitie in het aanvullende ITSM-veldscherm van de agentinterface.';
    $Self->{Translation}->{'Defines the default subject of a note in the decision screen of the agent interface.'} =
        'Definieert het standaardonderwerp van een notitie in het beslissingsscherm van de agentinterface.';
    $Self->{Translation}->{'Defines the default ticket priority in the additional ITSM field screen of the agent interface.'} =
        'Definieert de standaard ticketprioriteit in het aanvullende ITSM-veldscherm van de agentinterface.';
    $Self->{Translation}->{'Defines the default ticket priority in the decision screen of the agent interface.'} =
        'Definieert de standaard ticketprioriteit in het beslissingsscherm van de agentinterface.';
    $Self->{Translation}->{'Defines the history comment for the additional ITSM field screen action, which gets used for ticket history.'} =
        'Definieert de geschiedeniscommentaar voor de aanvullende ITSM-veldschermactie, die wordt gebruikt voor ticketgeschiedenis.';
    $Self->{Translation}->{'Defines the history comment for the decision screen action, which gets used for ticket history.'} =
        'Definieert de geschiedeniscommentaar voor de actie op het beslissingsscherm, die wordt gebruikt voor ticketgeschiedenis.';
    $Self->{Translation}->{'Defines the history type for the additional ITSM field screen action, which gets used for ticket history.'} =
        'Definieert het type geschiedenis voor de aanvullende ITSM-veldschermactie, die wordt gebruikt voor ticketgeschiedenis.';
    $Self->{Translation}->{'Defines the history type for the decision screen action, which gets used for ticket history.'} =
        'Definieert het type geschiedenis voor de actie op het beslissingsscherm, die wordt gebruikt voor ticketgeschiedenis.';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the additional ITSM field screen of the agent interface.'} =
        'Definieert de volgende status van een ticket na het toevoegen van een notitie in het aanvullende ITSM-veldscherm van de agentinterface.';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the decision screen of the agent interface.'} =
        'Definieert de volgende status van een ticket na het toevoegen van een notitie in het beslissingsscherm van de agentinterface.';
    $Self->{Translation}->{'Dynamic fields shown in the additional ITSM field screen of the agent interface.'} =
        'Dynamische velden weergegeven in het aanvullende ITSM-veldscherm van de agentinterface.';
    $Self->{Translation}->{'Dynamic fields shown in the decision screen of the agent interface.'} =
        'Dynamische velden weergegeven in het beslissingsscherm van de agentinterface.';
    $Self->{Translation}->{'Dynamic fields shown in the ticket zoom screen of the agent interface.'} =
        'Dynamische velden weergegeven in het ticketdetailscherm van de agentinterface.';
    $Self->{Translation}->{'Enables the stats module to generate statistics about the average of ITSM ticket first level solution rate.'} =
        'Hiermee kan de statistiekenmodule statistieken genereren over het gemiddelde oplossingspercentage van het ITSM-ticket op het eerste niveau.';
    $Self->{Translation}->{'Enables the stats module to generate statistics about the average of ITSM ticket solution.'} =
        'Hiermee kan de statistiekenmodule statistieken genereren over het gemiddelde van de ITSM-ticketoplossing.';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of a ticket in the additional ITSM field screen of the agent interface.'} =
        'Als een notitie wordt toegevoegd door een agent, wordt de status van een ticket ingesteld in het aanvullende ITSM-veldscherm van de agentinterface.';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of a ticket in the decision screen of the agent interface.'} =
        'Als een notitie wordt toegevoegd door een agent, wordt de status van een ticket ingesteld in het beslissingsscherm van de agentinterface.';
    $Self->{Translation}->{'Modifies the display order of the dynamic field ITSMImpact and other things.'} =
        'Wijzigt de weergavevolgorde van het dynamische veld ITSMImpact en andere dingen.';
    $Self->{Translation}->{'Module to dynamically show the service incident state and to calculate the priority.'} =
        'Module om de service incident status dynamisch weer te geven en de prioriteit te berekenen.';
    $Self->{Translation}->{'Required permissions to use the additional ITSM field screen in the agent interface.'} =
        'Vereiste rechten om het aanvullende ITSM-veldscherm in de agentinterface te gebruiken.';
    $Self->{Translation}->{'Required permissions to use the decision screen in the agent interface.'} =
        'Vereiste rechten om het beslissingsscherm in de agentinterface te gebruiken.';
    $Self->{Translation}->{'Service Incident State and Priority Calculation'} = 'Berekening van service incident status en prioriteit';
    $Self->{Translation}->{'Sets the service in the additional ITSM field screen of the agent interface (Ticket::Service needs to be activated).'} =
        'Stelt de service in op het extra ITSM-veldscherm van de agentinterface (Ticket::Service moet geactiveerd zijn).';
    $Self->{Translation}->{'Sets the service in the decision screen of the agent interface (Ticket::Service needs to be activated).'} =
        'Stelt de service in het beslissingsscherm van de agentinterface in (Ticket::Service moet geactiveerd zijn).';
    $Self->{Translation}->{'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).'} =
        'Stelt de service in op het ticketprioriteitsscherm van een ingezoomd ticket in de agentinterface (Ticket::Service moet geactiveerd zijn).';
    $Self->{Translation}->{'Sets the ticket owner in the additional ITSM field screen of the agent interface.'} =
        'Stelt de ticketeigenaar in op het extra ITSM-veldscherm van de agentinterface.';
    $Self->{Translation}->{'Sets the ticket owner in the decision screen of the agent interface.'} =
        'Stelt de ticketeigenaar in het beslissingsscherm van de agentinterface in.';
    $Self->{Translation}->{'Sets the ticket responsible in the additional ITSM field screen of the agent interface.'} =
        'Stelt het ticketverantwoordelijke in het aanvullende ITSM-veldscherm in van de agentinterface.';
    $Self->{Translation}->{'Sets the ticket responsible in the decision screen of the agent interface.'} =
        'Stelt het ticketverantwoordelijke in het beslissingsscherm van de agentinterface in.';
    $Self->{Translation}->{'Sets the ticket type in the additional ITSM field screen of the agent interface (Ticket::Type needs to be activated).'} =
        'Stelt het tickettype in het extra ITSM-veldscherm in van de agentinterface (Ticket::Type moet geactiveerd zijn).';
    $Self->{Translation}->{'Sets the ticket type in the decision screen of the agent interface (Ticket::Type needs to be activated).'} =
        'Stelt het tickettype in het beslissingsscherm van de agentinterface in (Ticket::Type moet geactiveerd zijn).';
    $Self->{Translation}->{'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).'} =
        'Stelt het tickettype in op het ticketprioriteitsscherm van een ingezoomd ticket in de agentinterface (Ticket::Type moet geactiveerd zijn).';
    $Self->{Translation}->{'Shows a link in the menu to change the decision of a ticket in its zoom view of the agent interface.'} =
        'Toont een link in het menu om de beslissing van een ticket te wijzigen in de zoomweergave van de agentinterface.';
    $Self->{Translation}->{'Shows a link in the menu to modify additional ITSM fields in the ticket zoom view of the agent interface.'} =
        'Toont een link in het menu om extra ITSM-velden te wijzigen in de ticketzoomweergave van de agentinterface.';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the additional ITSM field screen of the agent interface.'} =
        'Toont een lijst van alle betrokken agenten op dit ticket, in het extra ITSM-veldscherm van de agentinterface.';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the decision screen of the agent interface.'} =
        'Toont een lijst van alle betrokken agenten op dit ticket, in het beslissingsscherm van de agentinterface.';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the additional ITSM field screen of the agent interface.'} =
        'Toont een lijst van alle mogelijke agenten (alle agenten met notitiemachtigingen voor de wachtrij/ticket) om te bepalen wie op de hoogte moet worden gehouden van deze notitie, in het extra ITSM-veldscherm van de agentinterface.';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the decision screen of the agent interface.'} =
        'Toont een lijst van alle mogelijke agenten (alle agenten met notitiemachtigingen voor de wachtrij/ticket) om te bepalen wie op de hoogte moet worden gehouden van deze notitie, in het beslissingsscherm van de agentinterface.';
    $Self->{Translation}->{'Shows the ticket priority options in the additional ITSM field screen of the agent interface.'} =
        'Toont de ticketprioriteitsopties in het extra ITSM-veldscherm van de agentinterface.';
    $Self->{Translation}->{'Shows the ticket priority options in the decision screen of the agent interface.'} =
        'Toont de ticketprioriteitsopties in het beslissingsscherm van de agentinterface.';
    $Self->{Translation}->{'Shows the title fields in the additional ITSM field screen of the agent interface.'} =
        'Toont de titelvelden in het extra ITSM-veldscherm van de agentinterface.';
    $Self->{Translation}->{'Shows the title fields in the decision screen of the agent interface.'} =
        'Toont de titelvelden in het beslissingsscherm van de agentinterface.';
    $Self->{Translation}->{'Ticket decision.'} = 'Ticket beslissing.';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Service Incident State',
    );

}

1;
