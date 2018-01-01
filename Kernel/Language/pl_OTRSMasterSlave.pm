# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pl_OTRSMasterSlave;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminDynamicFieldMasterSlave
    $Self->{Translation}->{'Field'} = 'Pole';

    # Template: AgentTicketMasterSlave
    $Self->{Translation}->{'Manage Master/Slave status for %s%s%s'} = 'Ustaw stan Nadrzędny/Podrzędny dla %s%s%s';

    # Perl Module: Kernel/Modules/AgentTicketMasterSlave.pm
    $Self->{Translation}->{'New Master Ticket'} = 'Nowe zgłoszenie nadrzędne';
    $Self->{Translation}->{'Unset Master Ticket'} = 'Wyłącz wartość Nadrzędny';
    $Self->{Translation}->{'Unset Slave Ticket'} = 'Wyłącz wartość Podrzędny';
    $Self->{Translation}->{'Slave of %s%s%s: %s'} = 'Podrzędne do %s%s%s: %s';

    # Perl Module: Kernel/Output/HTML/TicketBulk/MasterSlave.pm
    $Self->{Translation}->{'Unset Master Tickets'} = 'Wyczyść wartość Nadrzędny';
    $Self->{Translation}->{'Unset Slave Tickets'} = 'Wyczyść wartość Podrzędny';

    # Perl Module: Kernel/System/DynamicField/Driver/MasterSlave.pm
    $Self->{Translation}->{'Master Ticket'} = 'Zgłoszenie nadrzędne';

    # SysConfig
    $Self->{Translation}->{'All master tickets'} = 'Wszystkie zgłoszenia nadrzędne';
    $Self->{Translation}->{'All slave tickets'} = 'Wszystkie zgłoszenia podrzędne';
    $Self->{Translation}->{'Allows adding notes in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Pozwala na dodanie notatki na ekranie Nadrzędny/Podrzędny, wywołanym z przybliżonego widoku zgłoszenia w interfejsie agenta.';
    $Self->{Translation}->{'Change the MasterSlave state of the ticket.'} = 'Zmień stan zgłoszenia dla Nadrzędny/Podrzędny.';
    $Self->{Translation}->{'Defines dynamic field name for master ticket feature.'} = 'Określa nazwę pola dynamicznego dla funkcjonalności zgłoszenia nadrzędnego.';
    $Self->{Translation}->{'Defines if a ticket lock is required in the ticket MasterSlave screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        'Określa, czy wymagana jest zablokowanie zgłoszenia na ekranie Nadrzędny/Podrzędny w oknie szczegółów zgłoszenia interfejsu agenta (jeśli zgłoszenie nie jest jeszcze zablokowane, staje się zablokowane, a bieżący agent staje się jego właścicielem).';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Określa domyślny następny stan zgłoszenia po dodaniu notatki na ekranie Nadrzędny/Podrzędny w oknie szczegółów zgłoszenia interfejsu agenta.';
    $Self->{Translation}->{'Defines the default ticket priority in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Określa domyślny priorytet zgłoszenia na ekranie Nadrzędny/Podrzędny w oknie szczegółów zgłoszenia interfejsu agenta.';
    $Self->{Translation}->{'Defines the default type of the note in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Określa domyślny typ notatki notatki na ekranie Nadrzędny/Podrzędny w oknie szczegółów zgłoszenia interfejsu agenta.';
    $Self->{Translation}->{'Defines the history comment for the ticket MasterSlave screen action, which gets used for ticket history in the agent interface.'} =
        'Określa komentarz historii dla akcji zgłoszenia na ekranie Nadrzędny/Podrzędny który zostanie użyty w historii zgłoszenia interfejsu agenta.';
    $Self->{Translation}->{'Defines the history type for the ticket MasterSlave screen action, which gets used for ticket history in the agent interface.'} =
        'Określa typ historii dla akcji zgłoszenia na ekranie Nadrzędny/Podrzędny który zostanie użyty w historii zgłoszenia interfejsu agenta.';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Określa następny stan zgłoszenia po dodaniu notatki na ekranie Nadrzędny/Podrzędny w oknie szczegółów zgłoszenia interfejsu agenta.';
    $Self->{Translation}->{'Enables the advanced MasterSlave part of the feature.'} = 'Włącza zaawansowaną część funkcjonalności Nadrzędny/Podrzędny.';
    $Self->{Translation}->{'Enables the feature that slave tickets follow the master ticket to a new master in the advanced MasterSlave mode.'} =
        'Włącza funkcjonalność trybu zaawansowanego Nadrzędny/Podrzędny, w której zgłoszenia podrzędne podążają za zgłoszeniem nadrzędnym do nowego zgłoszenia nadrzędnego.';
    $Self->{Translation}->{'Enables the feature to change the MasterSlave state of a ticket in the advanced MasterSlave mode.'} =
        'Włącza funkcjonalność trybu zaawansowanego Nadrzędny/Podrzędny umożliwiającą zmianę stanu Nadrzędny/Podrzędny w zgłoszeniu.';
    $Self->{Translation}->{'Enables the feature to forward articles from type \'forward\' of a master ticket to the customers of the slave tickets. By default (disabled) it will not forward articles from type \'forward\' to the slave tickets.'} =
        'Włącza funkcjonalność przesyłania artykułów typu "przekaż" ze zgłoszenia nadrzędnego do klientów zgłoszeń podrzędnych. Domyślnie (wyłączone) artykuły typu "przekaż" nie są przekazywane do zgłoszeń podrzędnych.';
    $Self->{Translation}->{'Enables the feature to keep parent-child link after change of the MasterSlave state in the advanced MasterSlave mode.'} =
        'Włącza funkcjonalność trybu zaawansowanego Nadrzędny/Podrzędny, polegającą na utrzymaniu połączenia rodzic-dziecko po zmianie zależności Nadrzędny/Podrzędny.';
    $Self->{Translation}->{'Enables the feature to keep parent-child link after unset of the MasterSlave state in the advanced MasterSlave mode.'} =
        'Włącza funkcjonalność trybu zaawansowanego Nadrzędny/Podrzędny, polegającą na utrzymaniu połączenia rodzic-dziecko po usunięciu zależności Nadrzędny/Podrzędny.';
    $Self->{Translation}->{'Enables the feature to unset the MasterSlave state of a ticket in the advanced MasterSlave mode.'} =
        'Włącza funkcjonalność trybu zaawansowanego Nadrzędny/Podrzędny, usuwania stanu Nadrzędny/Podrzędny ze zgłoszenia.';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of the ticket in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Jeśli agent doda notatkę, to ustawiany jest stan zgłoszenia na ekranie Nadrzędny/Podrzędny okna szczegółów zgłoszenia interfejsu agenta.';
    $Self->{Translation}->{'Master / Slave'} = 'Nadrzędny / Podrzędny';
    $Self->{Translation}->{'Master Tickets'} = 'Zgłoszenia nadrzędne';
    $Self->{Translation}->{'MasterSlave'} = 'Nadrzędny/Podrzędny';
    $Self->{Translation}->{'MasterSlave module for Ticket Bulk feature.'} = 'Moduł Nadrzędnych/Podrzędnych dla funkcji grupowych zgłoszeń.';
    $Self->{Translation}->{'Parameters for the dashboard backend of the master tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.'} =
        'Parametr okna pulpitu zgłoszeń nadrzędnych interfejsu agenta. "Limit" jest liczbą wierszy pokazywaną domyślnie. "Group" jest używana do ograniczenia dostępu do wtyczki (np.: Group: admin;group1;group2;). "Default" określa czy wtyczka jest domyślnie włączona lub czy użytkownik może włączyć ją ręcznie. "CacheTTLLocal" jest czasem podanym w minutach określającym czas cache\'owania wtyczki.';
    $Self->{Translation}->{'Parameters for the dashboard backend of the slave tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.'} =
        'Parametr okna pulpitu zgłoszeń podrzędnych interfejsu agenta. "Limit" jest liczbą wierszy pokazywaną domyślnie. "Group" jest używana do ograniczenia dostępu do wtyczki (np.: Group: admin;group1;group2;). "Default" określa czy wtyczka jest domyślnie włączona lub czy użytkownik może włączyć ją ręcznie. "CacheTTLLocal" jest czasem podanym w minutach określającym czas cache\'owania wtyczki.';
    $Self->{Translation}->{'Registration of the ticket event module.'} = 'Rejestracja modułu zdarzeń zgłoszenia,';
    $Self->{Translation}->{'Required permissions to use the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Uprawnienia wymagane do używania ekranu Nadrzędny/Podrzędny w oknie szczegółów zgłoszenia interfejsu agenta.';
    $Self->{Translation}->{'Sets the default body text for notes added in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Ustawia domyślną treść notatki dodawanej do zgłoszenia na ekranie Nadrzędny/Podrzędny w oknie szczegółów zgłoszenia interfejsu agenta.';
    $Self->{Translation}->{'Sets the default subject for notes added in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Ustawia domyślny temat dla notatek dodawanych do zgłoszenia na ekranie Nadrzędny/Podrzędny w oknie szczegółów zgłoszenia interfejsu agenta.';
    $Self->{Translation}->{'Sets the responsible agent of the ticket in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Ustawia odpowiedzialnego za zgłoszenie agenta na ekranie Nadrzędny/Podrzędny w oknie szczegółów zgłoszenia interfejsu agenta.';
    $Self->{Translation}->{'Sets the service in the ticket MasterSlave screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).'} =
        'Ustawia usługę w zgłoszeniu na ekranie Nadrzędny/Podrzędny w oknie szczegółów zgłoszenia interfejsu agenta (Ticket::Service musi być aktywowane).';
    $Self->{Translation}->{'Sets the ticket owner in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Ustawia właściciela zgłoszenia na ekranie Nadrzędny/Podrzędny w oknie szczegółów zgłoszenia interfejsu agenta.';
    $Self->{Translation}->{'Sets the ticket type in the ticket MasterSlave screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).'} =
        'Ustawia typ zgłoszenia na ekranie Nadrzędny/Podrzędny, wywołanym z przybliżonego widoku zgłoszenia w interfejsie agent (Ticket::Type musi być aktywowany).';
    $Self->{Translation}->{'Shows a link in the menu to change the MasterSlave status of a ticket in the ticket zoom view of the agent interface.'} =
        'Na ekranie przybliżonego widoku zgłoszenia w interfejsie agenta, pokazuje link w menu do zmiany stanu Nadrzędny/Podrzędny.';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Na ekranie Nadrzędny/Podrzędny, wywołanym z przybliżonego widoku zgłoszenia w interfejsie agenta, pokazuje listę wszystkich agentów zaangażowanych w zgłoszenie.';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Na ekranie Nadrzędny/Podrzędny, wywołanym z przybliżonego widoku zgłoszenia w interfejsie agenta, pokazuje listę wszystkich możliwych agentów (wszystkich agentów z uprawnieniami do notatek w kolejce/zgłoszeniu), w celu określenia kto powinien być poinformowany o tej notatce.';
    $Self->{Translation}->{'Shows the ticket priority options in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Pokazuje opcje priorytetu zgłoszenia na ekranie Nadrzędny/Podrzędny, wywołanym z przybliżonego widoku zgłoszenia w interfejsie agenta';
    $Self->{Translation}->{'Shows the title field in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '';
    $Self->{Translation}->{'Slave Tickets'} = 'Zgłoszenia podrzędne';
    $Self->{Translation}->{'Specifies the different article types where the real name from Master ticket will be replaced with the one in the Slave ticket.'} =
        'Określa różne rodzaje typów wiadomości i w jaki sposób właściwa nazwa ze zgłoszenia nadrzędnego zostanie zastąpiona w zgłoszeniu podrzędnym.';
    $Self->{Translation}->{'Specifies the different note types that will be used in the system.'} =
        'Wskazuje różne rodzaje notatek które będą używane w systemie.';
    $Self->{Translation}->{'This module activates Master/Slave field in new email and phone ticket screens.'} =
        'Ten moduł aktywuje pole Nadrzędny/Podrzędny w oknie nowego zgłoszenia e-mail i telefonicznego';
    $Self->{Translation}->{'Ticket MasterSlave.'} = 'Zgłoszenie Nadrzędne/Podrzędne';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
