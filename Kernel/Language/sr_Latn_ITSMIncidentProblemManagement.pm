# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::sr_Latn_ITSMIncidentProblemManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentTicketOverviewMedium
    $Self->{Translation}->{'Criticality'} = 'Značaj';
    $Self->{Translation}->{'Impact'} = 'Uticaj';

    # JS Template: ServiceIncidentState
    $Self->{Translation}->{'Service Incident State'} = 'Stanje incidenta servisa';

    # Perl Module: Kernel/Output/HTML/FilterElementPost/ITSMIncidentProblemManagement.pm
    $Self->{Translation}->{'Link ticket'} = 'Poveži tiket';
    $Self->{Translation}->{'Change Decision of %s%s%s'} = 'Izmena odluke za %s%s%s';
    $Self->{Translation}->{'Change ITSM fields of %s%s%s'} = 'Izmena ITSM polja za %s%s%s';

    # Perl Module: var/packagesetup/ITSMIncidentProblemManagement.pm
    $Self->{Translation}->{'Review Required'} = 'Obavezna recenzija';
    $Self->{Translation}->{'Decision Result'} = 'Rezultat odluke';
    $Self->{Translation}->{'Approved'} = 'Odobreno';
    $Self->{Translation}->{'Postponed'} = 'Odloženo';
    $Self->{Translation}->{'Pre-approved'} = 'Unapred odobreno';
    $Self->{Translation}->{'Rejected'} = 'Odbijeno';
    $Self->{Translation}->{'Repair Start Time'} = 'Vreme početka popravke';
    $Self->{Translation}->{'Recovery Start Time'} = 'Vreme početka oporavka';
    $Self->{Translation}->{'Decision Date'} = 'Datum Odluke';
    $Self->{Translation}->{'Due Date'} = 'Rok';

    # Database XML Definition: ITSMIncidentProblemManagement.sopm
    $Self->{Translation}->{'closed with workaround'} = 'zatvoreno sa alternativnim rešenjem';

    # SysConfig
    $Self->{Translation}->{'Add a decision!'} = 'Dodaj odluku!';
    $Self->{Translation}->{'Additional ITSM Fields'} = 'Dodatna ITSM polja';
    $Self->{Translation}->{'Additional ITSM ticket fields.'} = 'Dodatna ITSM polja tiketa.';
    $Self->{Translation}->{'Allows adding notes in the additional ITSM field screen of the agent interface.'} =
        'Dozvoljava dodavanje napomena na ekranu dodatnih ITSM polja u interfejsu operatera.';
    $Self->{Translation}->{'Allows adding notes in the decision screen of the agent interface.'} =
        'Dozvoljava dodavanje napomena na ekranu odluke interfejsa operatera.';
    $Self->{Translation}->{'Allows defining new types for ticket (if ticket type feature is enabled).'} =
        'Dozvoljava definisanje novog tipa tiketa (ako je opcija tipa tiketa aktivirana).';
    $Self->{Translation}->{'Change the ITSM fields!'} = 'Izmenite ITSM polja!';
    $Self->{Translation}->{'Decision'} = 'Odluka';
    $Self->{Translation}->{'Defines if a ticket lock is required in the additional ITSM field screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        'Određuje da li je neophodno zaključavanje tiketa na ekranu dodatnih ITSM polja u interfejsu operatera (ako tiket još uvek nije zaključan, tiket će dobiti status zaključan i trenutni operater će biti automatski postavljen kao vlasnik).';
    $Self->{Translation}->{'Defines if a ticket lock is required in the decision screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        'Određuje da li je neophodno zaključavanje tiketa na ekranu odluke u interfejsu operatera (ako tiket još uvek nije zaključan, tiket će dobiti status zaključan i trenutni operater će biti automatski postavljen kao vlasnik).';
    $Self->{Translation}->{'Defines if the service incident state should be shown during service selection in the agent interface.'} =
        'Određuje da li će status incidenta servisa biti prikazan tokom izbora servisa u interfejsu operatera.';
    $Self->{Translation}->{'Defines the default body of a note in the additional ITSM field screen of the agent interface.'} =
        'Određuje podrazumevani sadržaj napomene na ekranu dodatnih ITSM polja u interfejsu operatera.';
    $Self->{Translation}->{'Defines the default body of a note in the decision screen of the agent interface.'} =
        'Određuje podrazumevani sadržaj napomene na ekranu odluke u interfejsu operatera.';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the additional ITSM field screen of the agent interface.'} =
        'Određuje podrazumevani naredni status tiketa posle dodavanja napomene, na ekranu dodatnih ITSM polja u interfejsu operatera.';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the decision screen of the agent interface.'} =
        'Određuje podrazumevani naredni status tiketa posle dodavanja napomene, na ekranu odluke u interfejsu operatera.';
    $Self->{Translation}->{'Defines the default subject of a note in the additional ITSM field screen of the agent interface.'} =
        'Određuje podrazumevani predmet napomene, na ekranu dodatnih ITSM polja u interfejsu operatera.';
    $Self->{Translation}->{'Defines the default subject of a note in the decision screen of the agent interface.'} =
        'Određuje podrazumevani predmet napomene, na ekranu odluke u interfejsu operatera.';
    $Self->{Translation}->{'Defines the default ticket priority in the additional ITSM field screen of the agent interface.'} =
        'Određuje podrazumevani prioritet tiketa, na ekranu dodatnih ITSM polja u interfejsu operatera.';
    $Self->{Translation}->{'Defines the default ticket priority in the decision screen of the agent interface.'} =
        'Određuje podrazumevani prioritet tiketa na ekranu odluke u interfejsu operatera.';
    $Self->{Translation}->{'Defines the history comment for the additional ITSM field screen action, which gets used for ticket history.'} =
        'Određuje komentar za istorijat za akciju na ekranu dodatnih ITSM polja koje će se koristiti za istorijat tiketa.';
    $Self->{Translation}->{'Defines the history comment for the decision screen action, which gets used for ticket history.'} =
        'Određuje komentar za istorijat na ekranu odluke koji će se koristiti za istorijat tiketa.';
    $Self->{Translation}->{'Defines the history type for the additional ITSM field screen action, which gets used for ticket history.'} =
        'Određuje tip istorijata za akciju na ekranu dodatnih ITSM polja koje će se koristiti za istorijat tiketa.';
    $Self->{Translation}->{'Defines the history type for the decision screen action, which gets used for ticket history.'} =
        'Određuje tip istorijata na akciju na ekranu odluke koji će se koristiti za istorijat tiketa.';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the additional ITSM field screen of the agent interface.'} =
        'Definiše sledeći status tiketa nakon dodavanja napomene na ekranu dodatnih ITSM polja u interfejsu operatera';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the decision screen of the agent interface.'} =
        'Definiše sledeći status tiketa nakon dodavanja napomene na ekranu odluke u interfejsu operatera.';
    $Self->{Translation}->{'Dynamic fields shown in the additional ITSM field screen of the agent interface.'} =
        'Dinamička polja prikazana u ekranu dodatnih ITSM polja u interfejsu operatera.';
    $Self->{Translation}->{'Dynamic fields shown in the decision screen of the agent interface.'} =
        'Dinamička polja prikazana u ekranu odluke u interfejsu operatera.';
    $Self->{Translation}->{'Dynamic fields shown in the ticket zoom screen of the agent interface.'} =
        'Dinamička polja prikazana u detaljnom pregledu tiketa u interfejsu operatera.';
    $Self->{Translation}->{'Enables the stats module to generate statistics about the average of ITSM ticket first level solution rate.'} =
        'Aktivira statistički modul za generisanje statistike o proseku rešavanja ITSM tiketa na prvom nivou.';
    $Self->{Translation}->{'Enables the stats module to generate statistics about the average of ITSM ticket solution.'} =
        'Aktivira statistički modul za generisanje statistike o proseku rešavanja ITSM tiketa.';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of a ticket in the additional ITSM field screen of the agent interface.'} =
        'Ako je operater dodao napomenu, podešava status tiketa na ekranu dodatnih ITSM polja u interfejsu operatera.';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of a ticket in the decision screen of the agent interface.'} =
        'Ako je operater dodao napomenu, podešava status tiketa na ekranu odluke u interfejsu operatera.';
    $Self->{Translation}->{'Modifies the display order of the dynamic field ITSMImpact and other things.'} =
        'Menja redosled prikaza dinamičkog polja ITSMImpact i druge stvari.';
    $Self->{Translation}->{'Module to dynamically show the service incident state and to calculate the priority.'} =
        'Modul za dinamički prikaz stanja incidenta servisa i izračunavanje prioriteta.';
    $Self->{Translation}->{'Required permissions to use the additional ITSM field screen in the agent interface.'} =
        'Potrebne dozvole za upotrebu ekrana dodatnih ITSM polja u interfejsu operatera.';
    $Self->{Translation}->{'Required permissions to use the decision screen in the agent interface.'} =
        'Potrebne dozvole za upotrebu ekrana odluke u interfejsu operatera.';
    $Self->{Translation}->{'Service Incident State and Priority Calculation'} = 'Proračun prioriteta i stanja incidenta servisa';
    $Self->{Translation}->{'Sets the service in the additional ITSM field screen of the agent interface (Ticket::Service needs to be activated).'} =
        'Podešava servis na ekranu dodatnih ITSM polja u interfejsu operatera (Ticket::Service mora biti aktiviran).';
    $Self->{Translation}->{'Sets the service in the decision screen of the agent interface (Ticket::Service needs to be activated).'} =
        'Podešava servis na ekranu odluke u interfejsu operatera (Ticket::Service mora biti aktiviran).';
    $Self->{Translation}->{'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).'} =
        'Podešava servis na ekranu prioriteta tiketa u interfejsu operatera (neophodno je uključiti Ticket::Service).';
    $Self->{Translation}->{'Sets the ticket owner in the additional ITSM field screen of the agent interface.'} =
        'Određuje vlasnika tiketa na ekranu dodatnih ITSM polja u interfejsu operatera.';
    $Self->{Translation}->{'Sets the ticket owner in the decision screen of the agent interface.'} =
        'Određuje vlasnika tiketa na ekranu odluke u interfejsu operatera.';
    $Self->{Translation}->{'Sets the ticket responsible in the additional ITSM field screen of the agent interface.'} =
        'Određuje odgovornog za tiket na ekranu dodatnih ITSM polja u interfejsu operatera.';
    $Self->{Translation}->{'Sets the ticket responsible in the decision screen of the agent interface.'} =
        'Određuje odgovornog za tiket na ekranu odluke u interfejsu operatera.';
    $Self->{Translation}->{'Sets the ticket type in the additional ITSM field screen of the agent interface (Ticket::Type needs to be activated).'} =
        'Podešava tip tiketa na ekranu dodatnih ITSM polja u interfejsu operatera (Ticket::Type mora biti aktiviran).';
    $Self->{Translation}->{'Sets the ticket type in the decision screen of the agent interface (Ticket::Type needs to be activated).'} =
        'Podešava tip tiketa na ekranu odluke u interfejsu operatera (Ticket::Type mora biti aktiviran).';
    $Self->{Translation}->{'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).'} =
        'Određuje tip tiketa na ekranu prioriteta tiketa u interfejsu operatera (Ticket::Type treba da bude uključeno).';
    $Self->{Translation}->{'Shows a link in the menu to change the decision of a ticket in its zoom view of the agent interface.'} =
        'U meniju prikazuje vezu za promenu odluke tiketa na detaljnom prikazu u interfejsu operatera.';
    $Self->{Translation}->{'Shows a link in the menu to modify additional ITSM fields in the ticket zoom view of the agent interface.'} =
        'U meniju prikazuje vezu za promenu dodatnih ITSM polja na detaljnom prikazu u interfejsu operatera.';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the additional ITSM field screen of the agent interface.'} =
        'Prikazuje listu svih uključenih operatera na ovaj tiket na ekranu dodatnih ITSM polja u interfejsu operatera.';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the decision screen of the agent interface.'} =
        'Prikazuje listu svih uključenih operatera na ovaj tiket na ekranu odluke u interfejsu operatera.';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the additional ITSM field screen of the agent interface.'} =
        'Prikazuje listu svih mogućih operatera (svi operateri sa dozvolom za napomenu za red/tiket) radi utvrđivanja ko treba da bude informisan o ovoj napomeni, na ekranu dodatnih ITSM polja tiketa u interfejsu operatera.';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the decision screen of the agent interface.'} =
        'Prikazuje listu svih mogućih operatera (svi operateri sa dozvolom za napomenu za red/tiket) radi utvrđivanja ko treba da bude informisan o ovoj napomeni, na ekranu odluke tiketa u interfejsu operatera.';
    $Self->{Translation}->{'Shows the ticket priority options in the additional ITSM field screen of the agent interface.'} =
        'Prikazuje opcije prioriteta za tiket na ekranu dodatnih ITSM polja u interfejsu operatera.';
    $Self->{Translation}->{'Shows the ticket priority options in the decision screen of the agent interface.'} =
        'Prikazuje opcije prioriteta za tiket na ekranu odluke u interfejsu operatera.';
    $Self->{Translation}->{'Shows the title fields in the additional ITSM field screen of the agent interface.'} =
        'Prikazuje polja naslova na ekranu dodatnih ITSM polja u interfejsu operatera.';
    $Self->{Translation}->{'Shows the title fields in the decision screen of the agent interface.'} =
        'Prikazuje polja naslova na ekranu odluke u interfejsu operatera.';
    $Self->{Translation}->{'Ticket decision.'} = 'Odluka tiketa.';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Service Incident State',
    );

}

1;
