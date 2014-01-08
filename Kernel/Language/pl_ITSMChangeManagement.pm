# --
# Kernel/Language/pl_ITSMChangeManagement.pm - translation file
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pl_ITSMChangeManagement;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # Template: AAAITSMChangeManagement
    $Self->{Translation}->{'ITSMChange'} = 'Zmiana';
    $Self->{Translation}->{'ITSMChanges'} = 'Zmiany';
    $Self->{Translation}->{'ITSM Changes'} = 'Zmiany';
    $Self->{Translation}->{'workorder'} = 'zadanie';
    $Self->{Translation}->{'A change must have a title!'} = 'Zmiana musi posiadać tytuł!';
    $Self->{Translation}->{'A condition must have a name!'} = 'Warunek musi posiadań nazwę!';
    $Self->{Translation}->{'A template must have a name!'} = 'Szablon musi posiadać nazwę!';
    $Self->{Translation}->{'A workorder must have a title!'} = 'Zadanie musi posiadać tytuł!';
    $Self->{Translation}->{'ActionExecute::successfully'} = 'pomyślnie';
    $Self->{Translation}->{'ActionExecute::unsuccessfully'} = 'niepomyślnie';
    $Self->{Translation}->{'Add CAB Template'} = 'Dodaj szablon CAB';
    $Self->{Translation}->{'Add Workorder'} = 'Dodaj zadanie';
    $Self->{Translation}->{'Add a workorder to the change'} = 'Dodaj zadanie do zmiany';
    $Self->{Translation}->{'Add new condition and action pair'} = 'Dodaj nową parę warunek-akcja';
    $Self->{Translation}->{'Agent interface module to show the ChangeManager overview icon.'} =
        'Moduł interfejsu agenta do wyświetlania ikony przeglądu Manager zmiany.';
    $Self->{Translation}->{'Agent interface module to show the MyCAB overview icon.'} = 'Moduł interfejsu agenta do wyświetlania ikony przeglądu Moje CAB.';
    $Self->{Translation}->{'Agent interface module to show the MyChanges overview icon.'} = 'Moduł interfejsu agenta do wyświetlania ikony przeglądu Moje zmiany.';
    $Self->{Translation}->{'Agent interface module to show the MyWorkOrders overview icon.'} =
        'Moduł interfejsu agenta do wyświetlania ikony przeglądu Moje zadania.';
    $Self->{Translation}->{'CABAgents'} = 'CAB Agenci';
    $Self->{Translation}->{'CABCustomers'} = 'CAB Klienci';
    $Self->{Translation}->{'Change Overview'} = 'Przegląd zmiany';
    $Self->{Translation}->{'Change Schedule'} = 'Harmonogram zmiany';
    $Self->{Translation}->{'Change involved persons of the change'} = 'Zmień osoby zaangażowane w zmianę';
    $Self->{Translation}->{'ChangeHistory::ActionAdd'} = '%s: %s';
    $Self->{Translation}->{'ChangeHistory::ActionAddID'} = 'Nowa akcja (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ActionDelete'} = 'Akcja (ID=%s) usunięta';
    $Self->{Translation}->{'ChangeHistory::ActionDeleteAll'} = 'Wszystkie akcje warunku (ID=%s) usunięte';
    $Self->{Translation}->{'ChangeHistory::ActionExecute'} = 'Akcja (ID=%s) wykonana: %s';
    $Self->{Translation}->{'ChangeHistory::ActionUpdate'} = '%s (Akcja ID=%s): Nowe: %s <- Stare: %s';
    $Self->{Translation}->{'ChangeHistory::ChangeActualEndTimeReached'} = 'Zmiana (ID=%s) osiągnęła rzeczywisty czas końca.';
    $Self->{Translation}->{'ChangeHistory::ChangeActualStartTimeReached'} = 'Zmiana (ID=%s) osiągnęła rzeczywisty czas startu.';
    $Self->{Translation}->{'ChangeHistory::ChangeAdd'} = 'Nowa zmiana (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ChangeAttachmentAdd'} = 'Nowy załącznik: %s';
    $Self->{Translation}->{'ChangeHistory::ChangeAttachmentDelete'} = 'Usunięty załącznik %s';
    $Self->{Translation}->{'ChangeHistory::ChangeCABDelete'} = 'CAB usunięto %s';
    $Self->{Translation}->{'ChangeHistory::ChangeCABUpdate'} = '%s: Nowe: %s <- Stare: %s';
    $Self->{Translation}->{'ChangeHistory::ChangeLinkAdd'} = 'Utworzony odnośnik do %s (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ChangeLinkDelete'} = 'Usunięty odnośnik do %s (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ChangeNotificationSent'} = 'Powiadomienie wysłane do %s (Zdarzenie: %s)';
    $Self->{Translation}->{'ChangeHistory::ChangePlannedEndTimeReached'} = 'Zmiana (ID=%s) osiągnęła planowany czas końca.';
    $Self->{Translation}->{'ChangeHistory::ChangePlannedStartTimeReached'} = 'Zmiana (ID=%s) osiągnęła planowany czas startu.';
    $Self->{Translation}->{'ChangeHistory::ChangeRequestedTimeReached'} = 'Zmiana (ID=%s) osiągnęła żądany czas.';
    $Self->{Translation}->{'ChangeHistory::ChangeUpdate'} = '%s: Nowe: %s <- Stare: %s';
    $Self->{Translation}->{'ChangeHistory::ConditionAdd'} = '%s: %s';
    $Self->{Translation}->{'ChangeHistory::ConditionAddID'} = 'Nowy warunek (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ConditionDelete'} = 'Warunek (ID=%s) usunięty';
    $Self->{Translation}->{'ChangeHistory::ConditionDeleteAll'} = 'Wszsytkie warunki w zmianie (ID=%s) usunięte';
    $Self->{Translation}->{'ChangeHistory::ConditionUpdate'} = '%s (Warunek ID=%s): Nowe: %s <- Stare: %s';
    $Self->{Translation}->{'ChangeHistory::ExpressionAdd'} = '%s: %s';
    $Self->{Translation}->{'ChangeHistory::ExpressionAddID'} = 'Nowe wyrażenie (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ExpressionDelete'} = 'Wyrażenie (ID=%s) usunięte';
    $Self->{Translation}->{'ChangeHistory::ExpressionDeleteAll'} = 'Wszystkie wyrażenia w warunku (ID=%s) usunięte';
    $Self->{Translation}->{'ChangeHistory::ExpressionUpdate'} = '%s (Wyrażenie ID=%s): Nowe: %s <- Stare: %s';
    $Self->{Translation}->{'ChangeNumber'} = 'Numer zmiany';
    $Self->{Translation}->{'Condition Edit'} = 'Edycja warunku';
    $Self->{Translation}->{'Create Change'} = 'Utwórz zmianę';
    $Self->{Translation}->{'Create a change from this ticket!'} = 'Utwórz zmianę z tego zgłoszenia!';
    $Self->{Translation}->{'Delete Workorder'} = 'Usuń zadanie';
    $Self->{Translation}->{'Edit the change'} = 'Edytuj zmianę';
    $Self->{Translation}->{'Edit the conditions of the change'} = 'Edytuj warunki w zmianie';
    $Self->{Translation}->{'Edit the workorder'} = 'Edytuj zadanie';
    $Self->{Translation}->{'Expression'} = 'Wyrażenie';
    $Self->{Translation}->{'Full-Text Search in Change and Workorder'} = 'Wyszukiwanie pełnotekstowe w zmianie i zadaniach';
    $Self->{Translation}->{'ITSMCondition'} = 'Warunek';
    $Self->{Translation}->{'ITSMWorkOrder'} = 'Zadanie';
    $Self->{Translation}->{'Link another object to the change'} = 'Połącz zmianę z innym obiektem';
    $Self->{Translation}->{'Link another object to the workorder'} = 'Połącz zadanie z innym obiektem';
    $Self->{Translation}->{'Move all workorders in time'} = 'Przesuń wszystkie zadania w czasie';
    $Self->{Translation}->{'My CABs'} = 'Moje CABy';
    $Self->{Translation}->{'My Changes'} = 'Moje zmiany';
    $Self->{Translation}->{'My Workorders'} = 'Moje zadania';
    $Self->{Translation}->{'No XXX settings'} = 'Brak ustawień \'%s\'';
    $Self->{Translation}->{'PIR (Post Implementation Review)'} = 'PIR (Post Implementation Review)';
    $Self->{Translation}->{'PSA (Projected Service Availability)'} = 'PSA (Projected Service Availability)';
    $Self->{Translation}->{'Please select first a catalog class!'} = 'Zaznacz najpierw proszę klasę z katalogu!';
    $Self->{Translation}->{'Print the change'} = 'Wydrukuj zmianę';
    $Self->{Translation}->{'Print the workorder'} = 'Wydrukuj zadanie';
    $Self->{Translation}->{'RequestedTime'} = 'Żądany czas';
    $Self->{Translation}->{'Save Change CAB as Template'} = 'Zapisz CAB jako szablon';
    $Self->{Translation}->{'Save change as a template'} = 'Zapisz zmianę jako szablon';
    $Self->{Translation}->{'Save workorder as a template'} = 'Zapisz zadanie jako szablon';
    $Self->{Translation}->{'Search Changes'} = 'Wyszukiwanie zmian';
    $Self->{Translation}->{'Set the agent for the workorder'} = 'Przypisz agenta do zadania';
    $Self->{Translation}->{'Take Workorder'} = 'Weź zadanie';
    $Self->{Translation}->{'Take the workorder'} = 'Weź zadanie';
    $Self->{Translation}->{'Template Overview'} = 'Przegląd szablonu';
    $Self->{Translation}->{'The planned end time is invalid!'} = 'Planowany czas końca jest niepoprawny!';
    $Self->{Translation}->{'The planned start time is invalid!'} = 'Planowany czas rozpoczęcia jest niepoprawny!';
    $Self->{Translation}->{'The planned time is invalid!'} = 'Planowany czas jest niepoprawny!';
    $Self->{Translation}->{'The requested time is invalid!'} = 'Żądany czas jest niepoprawny!';
    $Self->{Translation}->{'New (from template)'} = '';
    $Self->{Translation}->{'Add from template'} = '';
    $Self->{Translation}->{'Add Workorder (from template)'} = '';
    $Self->{Translation}->{'Add a workorder (from template) to the change'} = '';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualEndTimeReached'} = 'Zadanie (ID=%s) osiągnęło rzeczywisty czas końca.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualEndTimeReachedWithWorkOrderID'} =
        'Zadanie (ID=%s) osiągnęło rzeczywisty czas końca.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualStartTimeReached'} = 'Zadanie (ID=%s) osiągnęło rzeczywisty czas startu.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualStartTimeReachedWithWorkOrderID'} =
        'Zadanie (ID=%s) osiągnęło rzeczywisty czas startu.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAdd'} = 'Nowe zadanie (ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAddWithWorkOrderID'} = 'Nowe zadanie (ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentAdd'} = '(ID=%s) Nowy załącznik do zadania: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentAddWithWorkOrderID'} = '(ID=%s) Nowy załącznik do zadania: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentDelete'} = 'Usunięty załącznik z zadania: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentDeleteWithWorkOrderID'} = '(ID=%s) Usunięty załącznik z zadania: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentAdd'} = '';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentAddWithWorkOrderID'} =
        '';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentDelete'} = '';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentDeleteWithWorkOrderID'} =
        '';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderDelete'} = 'Zadanie (ID=%s) usunięte';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderDeleteWithWorkOrderID'} = 'Zadanie (ID=%s) usunięte';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkAdd'} = 'Utworzony odnośnik do %s (ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkAddWithWorkOrderID'} = '(ID=%s) Utworzony odnośnik do %s (ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkDelete'} = 'Usynięty odnośnik do %s (ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkDeleteWithWorkOrderID'} = '(ID=%s) Usunięty odnośnik do %s (ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderNotificationSent'} = 'Powiadomienie wysłane do %s (Zdarzenie: %s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderNotificationSentWithWorkOrderID'} = '(ID=%s) Powiadomienie wysłane do %s (Zdarzenie: %s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedEndTimeReached'} = 'Zadanie (ID=%s) osiągnęło planowany czas końca.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedEndTimeReachedWithWorkOrderID'} =
        'Zadanie (ID=%s) osiągnęło planowany czas końca.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedStartTimeReached'} = 'Zadanie (ID=%s) osiągnęło planowany czas startu.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedStartTimeReachedWithWorkOrderID'} =
        'Zadanie (ID=%s) osiągnęło planowany czas startu.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderUpdate'} = '%s: Nowe: %s <- Stare: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderUpdateWithWorkOrderID'} = '(ID=%s) %s: Nowe: %s <- Stare: %s';
    $Self->{Translation}->{'WorkOrderNumber'} = 'Numer zadania';
    $Self->{Translation}->{'accepted'} = 'zaakceptowane';
    $Self->{Translation}->{'any'} = 'dowolne';
    $Self->{Translation}->{'approval'} = 'zatwierdzanie';
    $Self->{Translation}->{'approved'} = 'zatwierdzone';
    $Self->{Translation}->{'backout'} = 'wycofanie';
    $Self->{Translation}->{'begins with'} = 'zaczyna się od';
    $Self->{Translation}->{'canceled'} = 'anulowane';
    $Self->{Translation}->{'contains'} = 'zawiera';
    $Self->{Translation}->{'created'} = 'utworzone';
    $Self->{Translation}->{'decision'} = 'decyzja';
    $Self->{Translation}->{'ends with'} = 'kończy się na';
    $Self->{Translation}->{'failed'} = 'zakończone niepomyślnie';
    $Self->{Translation}->{'in progress'} = 'w toku';
    $Self->{Translation}->{'is'} = 'jest';
    $Self->{Translation}->{'is after'} = 'po';
    $Self->{Translation}->{'is before'} = 'przed';
    $Self->{Translation}->{'is empty'} = 'puste';
    $Self->{Translation}->{'is greater than'} = 'jest większe od';
    $Self->{Translation}->{'is less than'} = 'jest mniejsze od';
    $Self->{Translation}->{'is not'} = 'nie jest';
    $Self->{Translation}->{'is not empty'} = 'niepuste';
    $Self->{Translation}->{'not contains'} = 'nie zawiera';
    $Self->{Translation}->{'pending approval'} = 'czeka na zgodę';
    $Self->{Translation}->{'pending pir'} = 'czeka na recenzję (PIR)';
    $Self->{Translation}->{'pir'} = 'recenzja (PIR)';
    $Self->{Translation}->{'ready'} = 'gotowe';
    $Self->{Translation}->{'rejected'} = 'odrzucone';
    $Self->{Translation}->{'requested'} = 'żądanie';
    $Self->{Translation}->{'retracted'} = 'wycofane';
    $Self->{Translation}->{'set'} = 'ustaw';
    $Self->{Translation}->{'successful'} = 'zakończone pomyślnie';

    # Template: AdminITSMChangeCIPAllocate
    $Self->{Translation}->{'Category <-> Impact <-> Priority'} = 'Kategoria <-> Wpływ <-> Priorytet';
    $Self->{Translation}->{'Manage the priority result of combinating Category <-> Impact.'} =
        'Zarządzanie priorytetem dla kombinacji Kategoria <-> Wpływ.';
    $Self->{Translation}->{'Priority allocation'} = 'Alokacja priorytetu';

    # Template: AdminITSMChangeNotification
    $Self->{Translation}->{'ITSM ChangeManagement Notification Management'} = 'Zarządzanie powiadomieniami zmian ITSM';
    $Self->{Translation}->{'Add Notification Rule'} = 'Dodaj regułę powiadamiania';
    $Self->{Translation}->{'Attribute'} = '';
    $Self->{Translation}->{'Rule'} = 'Reguła';
    $Self->{Translation}->{'Recipients'} = '';
    $Self->{Translation}->{'A notification should have a name!'} = 'Powiadomiene powinno mieć nazwę!';
    $Self->{Translation}->{'Name is required.'} = 'Nazwa jest wymagana.';

    # Template: AdminITSMStateMachine
    $Self->{Translation}->{'Admin State Machine'} = 'Zarządaj maszyną stanów';
    $Self->{Translation}->{'Select a catalog class!'} = 'Zaznacz klasę katalogu!';
    $Self->{Translation}->{'A catalog class is required!'} = 'Klasa katalogu jest wymagana!';
    $Self->{Translation}->{'Add a state transition'} = 'Dodaj przejście między stanami';
    $Self->{Translation}->{'Catalog Class'} = 'Klasa katalogu';
    $Self->{Translation}->{'Object Name'} = 'Nazwa obiektu';
    $Self->{Translation}->{'Overview over state transitions for'} = 'Przegląd przejść stanów dla';
    $Self->{Translation}->{'Delete this state transition'} = '';
    $Self->{Translation}->{'Add a new state transition for'} = 'Dodaj nowe przejście stanu dla';
    $Self->{Translation}->{'Please select a state!'} = 'Zaznacz stan!';
    $Self->{Translation}->{'Please select a next state!'} = 'Zaznacz następny stan!';
    $Self->{Translation}->{'Edit a state transition for'} = 'Edytuj przejście stanu dla';
    $Self->{Translation}->{'Do you really want to delete the state transition'} = 'Czy na pewno chcesz usunąć przejście stanu';
    $Self->{Translation}->{'from'} = 'od';

    # Template: AgentITSMCABMemberSearch

    # Template: AgentITSMChangeAdd
    $Self->{Translation}->{'Add Change'} = 'Dodaj zmianę';
    $Self->{Translation}->{'ITSM Change'} = 'Zmiana';
    $Self->{Translation}->{'Justification'} = 'Uzasadnienie';
    $Self->{Translation}->{'Input invalid.'} = 'Niepoprawne dane wejściowe.';
    $Self->{Translation}->{'Impact'} = 'Wpływ';
    $Self->{Translation}->{'Requested Date'} = 'Żądana data';

    # Template: AgentITSMChangeAddFromTemplate
    $Self->{Translation}->{'Select Change Template'} = 'Wybierz szablon zmiany';
    $Self->{Translation}->{'Time type'} = 'Typ czasu';
    $Self->{Translation}->{'Invalid time type.'} = 'Niepoprawny typ czasu.';
    $Self->{Translation}->{'New time'} = 'Nowy czas';

    # Template: AgentITSMChangeCABTemplate
    $Self->{Translation}->{'Save Change CAB as template'} = 'Zapisz CAB zmiany jako szablon';
    $Self->{Translation}->{'go to involved persons screen'} = 'idź do ekranu z osobami zaangażowanymi';
    $Self->{Translation}->{'This field is required'} = 'To pole jest wymagane';
    $Self->{Translation}->{'Invalid Name'} = 'Niepoprawna nazwa';

    # Template: AgentITSMChangeCondition
    $Self->{Translation}->{'Conditions and Actions'} = 'Warunki i akcje';
    $Self->{Translation}->{'Delete Condition'} = 'Usuń warunek';
    $Self->{Translation}->{'Add new condition'} = 'Dodaj nowy warunek';

    # Template: AgentITSMChangeConditionEdit
    $Self->{Translation}->{'Need a valid name.'} = 'Potrzeba poprawna nazwa.';
    $Self->{Translation}->{'A a valid name is needed.'} = 'Potrzeba poprawna nazwa.';
    $Self->{Translation}->{'Matching'} = 'Pasuje';
    $Self->{Translation}->{'Any expression (OR)'} = 'Dowolne wyrażenie (OR)';
    $Self->{Translation}->{'All expressions (AND)'} = 'Wszystkie wyrażenia (AND)';
    $Self->{Translation}->{'Expressions'} = 'Wyrażenia';
    $Self->{Translation}->{'Selector'} = 'Selektor';
    $Self->{Translation}->{'Operator'} = 'Operator';
    $Self->{Translation}->{'Delete Expression'} = '';
    $Self->{Translation}->{'No Expressions found.'} = 'Nie znaleziono wyrażeń.';
    $Self->{Translation}->{'Add new expression'} = 'Dodaj nowe wyrażenie';
    $Self->{Translation}->{'Delete Action'} = '';
    $Self->{Translation}->{'No Actions found.'} = 'Nie znaleziono akcji.';
    $Self->{Translation}->{'Add new action'} = 'Dodaj nową akcję';

    # Template: AgentITSMChangeDelete
    $Self->{Translation}->{'Do you really want to delete this change?'} = '';

    # Template: AgentITSMChangeEdit

    # Template: AgentITSMChangeHistory
    $Self->{Translation}->{'Workorder'} = 'Zadanie';
    $Self->{Translation}->{'Show details'} = 'Pokaż szczegóły';
    $Self->{Translation}->{'Show workorder'} = 'Pokaż zadanie';

    # Template: AgentITSMChangeHistoryZoom
    $Self->{Translation}->{'Detailed history information of'} = 'Szczegółowe informacji o historii';
    $Self->{Translation}->{'Modified'} = '';
    $Self->{Translation}->{'Old Value'} = 'Stara wartość';
    $Self->{Translation}->{'New Value'} = 'Nowa wartość';

    # Template: AgentITSMChangeInvolvedPersons
    $Self->{Translation}->{'Involved Persons'} = 'Zaangażowane osoby';
    $Self->{Translation}->{'ChangeManager'} = 'Manager zmiany';
    $Self->{Translation}->{'User invalid.'} = 'Niepoprawny użytkownik.';
    $Self->{Translation}->{'ChangeBuilder'} = 'Konstruktor zmiany';
    $Self->{Translation}->{'Change Advisory Board'} = 'Change Advisory Board';
    $Self->{Translation}->{'CAB Template'} = 'Szablon CAB';
    $Self->{Translation}->{'Apply Template'} = 'Dodaj szablon';
    $Self->{Translation}->{'NewTemplate'} = 'Nowy szablon';
    $Self->{Translation}->{'Save this CAB as template'} = 'Zapisz ten CAB jako szablon';
    $Self->{Translation}->{'Add to CAB'} = 'Dodaj do CAB';
    $Self->{Translation}->{'Invalid User'} = 'Niepoprawny użytkownik';
    $Self->{Translation}->{'Current CAB'} = 'Aktualny CAB';

    # Template: AgentITSMChangeOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = 'Ustawienia kontekstu';
    $Self->{Translation}->{'Changes per page'} = 'Zmiany na stronę';

    # Template: AgentITSMChangeOverviewSmall
    $Self->{Translation}->{'WorkOrderTitle'} = 'Tytuł zadania';
    $Self->{Translation}->{'ChangeTitle'} = 'Tytuł zmiany';
    $Self->{Translation}->{'WorkOrderAgent'} = 'Agent zadania';
    $Self->{Translation}->{'Workorders'} = 'Zadania';
    $Self->{Translation}->{'ChangeState'} = 'Stan zmiany';
    $Self->{Translation}->{'WorkOrderState'} = 'Stan zadania';
    $Self->{Translation}->{'WorkOrderType'} = 'Typ zadania';
    $Self->{Translation}->{'Requested Time'} = 'Żądany czas';
    $Self->{Translation}->{'PlannedStartTime'} = 'Planowany start';
    $Self->{Translation}->{'PlannedEndTime'} = 'Planowany koniec';
    $Self->{Translation}->{'ActualStartTime'} = 'Rzeczywisty start';
    $Self->{Translation}->{'ActualEndTime'} = 'Rzeczywisty koniec';

    # Template: AgentITSMChangePrint
    $Self->{Translation}->{'ITSM Workorder'} = 'Zadanie';

    # Template: AgentITSMChangeReset
    $Self->{Translation}->{'Do you really want to reset this change?'} = '';

    # Template: AgentITSMChangeSearch
    $Self->{Translation}->{'(e.g. 10*5155 or 105658*)'} = '(np. 10*5155 or 105658*)';
    $Self->{Translation}->{'CABAgent'} = 'CAB Agent';
    $Self->{Translation}->{'e.g.'} = 'np.';
    $Self->{Translation}->{'CABCustomer'} = 'CAB Klient';
    $Self->{Translation}->{'Instruction'} = 'Instrukcja';
    $Self->{Translation}->{'Report'} = 'Raport';
    $Self->{Translation}->{'Change Category'} = 'Kategoria zmiany';
    $Self->{Translation}->{'(before/after)'} = '(przed/po)';
    $Self->{Translation}->{'(between)'} = '(pomiędzy)';
    $Self->{Translation}->{'Run Search'} = 'Szukaj';

    # Template: AgentITSMChangeSearchResultPrint
    $Self->{Translation}->{'WorkOrders'} = 'Zadania';

    # Template: AgentITSMChangeTemplate
    $Self->{Translation}->{'Save Change as Template'} = 'Zapisz zmianę jako szablon';
    $Self->{Translation}->{'A template should have a name!'} = 'Szablon powinien mieć nazwę!';
    $Self->{Translation}->{'The template name is required.'} = 'Nazwa szablonu jest wymagana.';
    $Self->{Translation}->{'Reset States'} = 'Resetuj stan';

    # Template: AgentITSMChangeTimeSlot
    $Self->{Translation}->{'Move Time Slot'} = 'Przesuń przedział czasu';

    # Template: AgentITSMChangeZoom
    $Self->{Translation}->{'Change Information'} = 'Informacje o zmianie';
    $Self->{Translation}->{'PlannedEffort'} = 'Planowany wysiłek';
    $Self->{Translation}->{'Change Initiator(s)'} = 'Inicjatorzy zmiany';
    $Self->{Translation}->{'Change Manager'} = 'Manager zmiany';
    $Self->{Translation}->{'Change Builder'} = 'Konstruktor zmiany';
    $Self->{Translation}->{'CAB'} = 'CAB';
    $Self->{Translation}->{'Last changed'} = 'Ostatnia zmiana';
    $Self->{Translation}->{'Last changed by'} = 'Ostatnio zmienione przez';
    $Self->{Translation}->{'Ok'} = 'Ok';
    $Self->{Translation}->{'Download Attachment'} = 'Pobierz załącznik';

    # Template: AgentITSMTemplateDelete
    $Self->{Translation}->{'Do you really want to delete this template?'} = 'Czy na pewno chcesz usunąć ten szablon?';

    # Template: AgentITSMTemplateEdit

    # Template: AgentITSMTemplateOverviewNavBar

    # Template: AgentITSMTemplateOverviewSmall
    $Self->{Translation}->{'TemplateID'} = 'Szablon-ID';
    $Self->{Translation}->{'CreateBy'} = 'Utworzone przez';
    $Self->{Translation}->{'CreateTime'} = 'Czas utworzenia';
    $Self->{Translation}->{'ChangeBy'} = 'Zmienione przez';
    $Self->{Translation}->{'ChangeTime'} = 'Czas zmiany';
    $Self->{Translation}->{'Delete: '} = 'Usunięcie: ';
    $Self->{Translation}->{'Delete Template'} = 'Usuń szablon';

    # Template: AgentITSMUserSearch

    # Template: AgentITSMWorkOrderAdd
    $Self->{Translation}->{'Add Workorder to'} = 'Dodaj zadanie do';
    $Self->{Translation}->{'Invalid workorder type.'} = 'Nieprawidłowy typ zadania.';
    $Self->{Translation}->{'The planned start time must be before the planned end time!'} = 'Planowany czas startu musi być przed planowanym czasem końca!';
    $Self->{Translation}->{'Invalid format.'} = 'Nieprawidłowy format.';

    # Template: AgentITSMWorkOrderAddFromTemplate
    $Self->{Translation}->{'Select Workorder Template'} = 'Wskaż szablon zadania';

    # Template: AgentITSMWorkOrderAgent

    # Template: AgentITSMWorkOrderDelete
    $Self->{Translation}->{'Do you really want to delete this workorder?'} = 'Czy na pewno chcesz usunąć to zadanie?';
    $Self->{Translation}->{'You can not delete this Workorder. It is used in at least one Condition!'} =
        'Nie możesz usunąć tego zadania. Jest ono używane w przynajmniej jednym warunku!';
    $Self->{Translation}->{'This Workorder is used in the following Condition(s)'} = 'To zadanie jest używane w następujących warunkach';

    # Template: AgentITSMWorkOrderEdit
    $Self->{Translation}->{'Move following workorders accordingly'} = '';
    $Self->{Translation}->{'If the planned end time of this workorder is changed, the planned start times of all following workorders will be changed accordingly'} =
        '';

    # Template: AgentITSMWorkOrderHistory

    # Template: AgentITSMWorkOrderHistoryZoom

    # Template: AgentITSMWorkOrderReport
    $Self->{Translation}->{'The actual start time must be before the actual end time!'} = 'Rzeczywisty czas startu musi być przed rzecztwistym czasem końca!';
    $Self->{Translation}->{'The actual start time must be set, when the actual end time is set!'} =
        'Rzeczywisty czas startu musi być ustawiony gdy ustawiony jest rzeczywisty czas końca!';
    $Self->{Translation}->{'Existing attachments'} = '';

    # Template: AgentITSMWorkOrderTake
    $Self->{Translation}->{'Current Agent'} = 'Aktualny agent';
    $Self->{Translation}->{'Do you really want to take this workorder?'} = 'Czy na pewno chcesz wziąć to zadanie?';

    # Template: AgentITSMWorkOrderTemplate
    $Self->{Translation}->{'Save Workorder as Template'} = 'Zapisz zadanie jako szablon';

    # Template: AgentITSMWorkOrderZoom
    $Self->{Translation}->{'Workorder Information'} = 'Zadanie-informacje';

    # Template: CustomerITSMChangeOverview

    # Template: ITSMChange

    # SysConfig
    $Self->{Translation}->{'A list of the agents who have permission to take workorders. Key is a login name. Content is 0 or 1.'} =
        '';
    $Self->{Translation}->{'A list of workorder states, at which the ActualStartTime of a workorder will be set if it was empty at this point.'} =
        '';
    $Self->{Translation}->{'Admin of notification rules.'} = 'Administracja regułami powiadomień';
    $Self->{Translation}->{'Admin of the CIP matrix.'} = 'Zarządzanie macierzą KWP';
    $Self->{Translation}->{'Admin of the state machine.'} = 'Zarządzanie maszyną stanów';
    $Self->{Translation}->{'Agent interface notification module to see the number of change advisory boards.'} =
        '';
    $Self->{Translation}->{'Agent interface notification module to see the number of changes managed by the user.'} =
        '';
    $Self->{Translation}->{'Agent interface notification module to see the number of changes.'} =
        '';
    $Self->{Translation}->{'Agent interface notification module to see the number of work orders.'} =
        '';
    $Self->{Translation}->{'Cache time in minutes for the change management toolbars. Default: 3 hours (180 minutes).'} =
        '';
    $Self->{Translation}->{'Cache time in minutes for the change management. Default: 5 days (7200 minutes).'} =
        '';
    $Self->{Translation}->{'Change Overview "Small" Limit'} = 'Limit przeglądu zmian "Małe"';
    $Self->{Translation}->{'Change free text options shown in the change add of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';
    $Self->{Translation}->{'Change free text options shown in the change edit of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';
    $Self->{Translation}->{'Change free text options shown in the change search of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        '';
    $Self->{Translation}->{'Change limit per page for Change Overview "Small"'} = 'Limit zmian na stronie dla przeglądu zmian "Małe"';
    $Self->{Translation}->{'Change search backend router of the agent interface.'} = '';
    $Self->{Translation}->{'Configures how often the notifications are sent when planned the start time or other time values have been reached/passed.'} =
        '';
    $Self->{Translation}->{'Default type for a workorder. This entry must exist in general catalog class \'ITSM::ChangeManagement::WorkOrder::Type\'.'} =
        '';
    $Self->{Translation}->{'Define the signals for each workorder state.'} = '';
    $Self->{Translation}->{'Defines an overview module to show the small view of a change list.'} =
        '';
    $Self->{Translation}->{'Defines an overview module to show the small view of a template list.'} =
        '';
    $Self->{Translation}->{'Defines if it will be possible to print the accounted time.'} = '';
    $Self->{Translation}->{'Defines if it will be possible to print the planned effort.'} = '';
    $Self->{Translation}->{'Defines if reachable (as defined by the state machine) change end states should be allowed if a change is in a locked state.'} =
        '';
    $Self->{Translation}->{'Defines if reachable (as defined by the state machine) workorder end states should be allowed if a workorder is in a locked state.'} =
        '';
    $Self->{Translation}->{'Defines if the accounted time should be shown.'} = '';
    $Self->{Translation}->{'Defines if the actual start and end times should be set.'} = '';
    $Self->{Translation}->{'Defines if the change search and the workorder search functions could use the mirror DB.'} =
        '';
    $Self->{Translation}->{'Defines if the change state can be set in AgentITSMChangeEdit.'} =
        '';
    $Self->{Translation}->{'Defines if the planned effort should be shown.'} = '';
    $Self->{Translation}->{'Defines if the requested date should be print by customer.'} = '';
    $Self->{Translation}->{'Defines if the requested date should be searched by customer.'} =
        '';
    $Self->{Translation}->{'Defines if the requested date should be set by customer.'} = '';
    $Self->{Translation}->{'Defines if the requested date should be shown by customer.'} = '';
    $Self->{Translation}->{'Defines if the workorder state should be shown.'} = '';
    $Self->{Translation}->{'Defines if the workorder title should be shown.'} = '';
    $Self->{Translation}->{'Defines shown graph attributes.'} = '';
    $Self->{Translation}->{'Defines that only changes containing Workorders linked with services, which the customer user has permission to use will be shown. Any other changes will not be displayed.'} =
        '';
    $Self->{Translation}->{'Defines the change states that will be allowed to delete.'} = '';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the Change PSA overview.'} =
        '';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the Change Schedule overview.'} =
        '';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the MyCAB overview.'} =
        '';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the MyChanges overview.'} =
        '';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the change manager overview.'} =
        '';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the change overview.'} =
        '';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the customer change schedule overview.'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 1 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 1 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 10 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 10 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 11 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 11 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 12 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 12 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 13 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 13 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 14 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 14 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 15 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 15 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 16 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 16 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 17 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 17 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 18 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 18 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 19 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 19 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 2 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 2 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 20 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 20 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 21 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 21 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 22 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 22 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 23 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 23 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 24 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 24 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 25 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 25 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 26 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 26 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 27 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 27 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 28 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 28 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 29 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 29 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 3 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 3 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 30 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 30 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 31 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 31 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 32 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 32 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 33 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 33 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 34 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 34 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 35 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 35 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 36 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 36 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 37 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 37 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 38 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 38 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 39 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 39 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 4 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 4 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 40 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 40 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 41 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 41 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 42 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 42 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 43 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 43 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 44 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 44 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 45 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 45 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 46 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 46 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 47 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 47 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 48 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 48 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 49 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 49 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 5 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 5 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 50 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 50 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 6 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 6 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 7 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 7 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 8 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 8 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 9 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 9 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 1 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 1 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 10 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 10 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 11 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 11 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 12 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 12 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 13 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 13 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 14 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 14 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 15 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 15 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 16 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 16 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 17 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 17 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 18 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 18 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 19 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 19 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 2 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 2 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 20 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 20 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 21 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 21 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 22 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 22 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 23 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 23 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 24 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 24 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 25 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 25 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 26 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 26 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 27 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 27 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 28 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 28 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 29 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 29 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 3 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 3 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 30 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 30 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 31 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 31 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 32 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 32 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 33 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 33 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 34 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 34 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 35 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 35 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 36 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 36 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 37 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 37 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 38 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 38 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 39 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 39 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 4 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 4 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 40 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 40 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 41 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 41 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 42 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 42 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 43 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 43 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 44 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 44 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 45 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 45 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 46 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 46 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 47 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 47 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 48 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 48 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 49 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 49 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 5 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 5 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 50 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 50 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 6 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 6 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 7 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 7 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 8 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 8 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 9 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 9 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default sort criteria in the change PSA overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort criteria in the change manager overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort criteria in the change overview.'} = '';
    $Self->{Translation}->{'Defines the default sort criteria in the change schedule overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the MyCAB overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the MyChanges overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the MyWorkorders overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the PIR overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the customer change schedule overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the template overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort order in the MyCAB overview.'} = '';
    $Self->{Translation}->{'Defines the default sort order in the MyChanges overview.'} = '';
    $Self->{Translation}->{'Defines the default sort order in the MyWorkorders overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort order in the PIR overview.'} = '';
    $Self->{Translation}->{'Defines the default sort order in the change PSA overview.'} = '';
    $Self->{Translation}->{'Defines the default sort order in the change manager overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort order in the change overview.'} = '';
    $Self->{Translation}->{'Defines the default sort order in the change schedule overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort order in the customer change schedule overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort order in the template overview.'} = '';
    $Self->{Translation}->{'Defines the default value for the category of a change.'} = '';
    $Self->{Translation}->{'Defines the default value for the impact of a change.'} = '';
    $Self->{Translation}->{'Defines the field type of CompareValue fields for change attributes used in AgentITSMChangeConditionEdit. Valid values are Selection, Text and Date. If a type is not defined, the field will not be shown.'} =
        '';
    $Self->{Translation}->{'Defines the field type of CompareValue fields for workorder attributes used in AgentITSMChangeConditionEdit. Valid values are Selection, Text and Date. If a type is not defined, the field will not be shown.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 1 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 1 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 10 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 10 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 11 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 11 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 12 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 12 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 13 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 13 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 14 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 14 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 15 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 15 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 16 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 16 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 17 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 17 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 18 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 18 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 19 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 19 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 2 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 2 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 20 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 20 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 21 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 21 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 22 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 22 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 23 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 23 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 24 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 24 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 25 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 25 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 26 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 26 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 27 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 27 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 28 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 28 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 29 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 29 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 3 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 3 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 30 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 30 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 31 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 31 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 32 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 32 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 33 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 33 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 34 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 34 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 35 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 35 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 36 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 36 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 37 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 37 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 38 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 38 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 39 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 39 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 4 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 4 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 40 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 40 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 41 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 41 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 42 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 42 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 43 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 43 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 44 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 44 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 45 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 45 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 46 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 46 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 47 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 47 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 48 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 48 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 49 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 49 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 5 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 5 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 50 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 50 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 6 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 6 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 7 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 7 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 8 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 8 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 9 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 9 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 1 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 1 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 10 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 10 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 11 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 11 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 12 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 13 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 13 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 14 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 14 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 15 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 15 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 16 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 16 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 17 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 17 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 18 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 18 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 19 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 19 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 2 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 2 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 20 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 20 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 21 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 21 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 22 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 22 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 23 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 23 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 24 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 24 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 25 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 25 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 26 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 26 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 27 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 27 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 28 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 28 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 29 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 29 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 3 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 3 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 30 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 30 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 31 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 31 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 32 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 32 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 33 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 33 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 34 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 34 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 35 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 35 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 36 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 36 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 37 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 37 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 38 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 38 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 39 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 39 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 4 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 4 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 40 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 40 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 41 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 41 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 42 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 42 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 43 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 43 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 44 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 44 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 45 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 45 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 46 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 46 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 47 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 47 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 48 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 48 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 49 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 49 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 5 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 5 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 50 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 50 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 6 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 6 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 7 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 7 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 8 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 8 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 9 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 9 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 1 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 1 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 10 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 10 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 11 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 11 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 12 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 12 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 13 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 13 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 14 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 14 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 15 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 15 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 16 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 16 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 17 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 17 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 18 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 18 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 19 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 19 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 2 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 2 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 20 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 20 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 21 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 21 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 22 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 22 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 23 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 23 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 24 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 24 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 25 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 25 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 26 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 26 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 27 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 27 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 28 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 28 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 29 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 29 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 3 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 3 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 30 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 30 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 31 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 31 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 32 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 32 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 33 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 33 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 34 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 34 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 35 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 35 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 36 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 36 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 37 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 37 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 38 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 38 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 39 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 39 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 4 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 4 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 40 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 40 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 41 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 41 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 42 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 42 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 43 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 43 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 44 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 44 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 45 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 45 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 46 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 46 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 47 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 47 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 48 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 48 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 49 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 49 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 5 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 5 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 50 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 50 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 6 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 6 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 7 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 7 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 8 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 8 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 9 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 9 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the maximum number of change freetext fields.'} = '';
    $Self->{Translation}->{'Defines the maximum number of workorder freetext fields.'} = '';
    $Self->{Translation}->{'Defines the object attributes that are selectable for change objects in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the object attributes that are selectable for workorder objects in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute AccountedTime in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ActualEndTime in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ActualStartTime in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute CategoryID in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeBuilderID in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeFreeKey in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeFreeText in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeManagerID in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeStateID in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeTitle in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ImpactID in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PlannedEffort in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PlannedEndTime in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PlannedStartTime in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PriorityID in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute RequestedTime in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderAgentID in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderFreeKey in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderFreeText in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderNumber in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderStateID in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderTitle in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderTypeID in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the period (in years), in which start and end times can be selected.'} =
        '';
    $Self->{Translation}->{'Defines the shown attributes of a workorder in the tooltip of the workorder graph in the change zoom.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the Change PSA overview. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the Change Schedule overview. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the MyCAB overview. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the MyChanges overview. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the MyWorkorders overview. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the PIR overview. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the change manager overview. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the change overview. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the change search. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the customer change schedule overview. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the template overview. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the signals for each ITSMChange state.'} = '';
    $Self->{Translation}->{'Defines the template types that will be used as filters in the template overview.'} =
        '';
    $Self->{Translation}->{'Defines the workorder states that will be used as filters in the MyWorkorders overview.'} =
        '';
    $Self->{Translation}->{'Defines the workorder states that will be used as filters in the PIR overview.'} =
        '';
    $Self->{Translation}->{'Defines the workorder types that will be used to show the PIR overview.'} =
        '';
    $Self->{Translation}->{'Defines whether notifications should be sent.'} = '';
    $Self->{Translation}->{'Determines if an agent can exchange the X-axis of a stat if he generates one.'} =
        '';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes done for config item classes.'} =
        '';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes regarding change state updates within a timeperiod.'} =
        '';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes regarding the relation between changes and incident tickets.'} =
        '';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes.'} =
        '';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about the number of Rfc tickets a requester created.'} =
        '';
    $Self->{Translation}->{'Event list to be displayed on GUI to trigger generic interface invokers.'} =
        '';
    $Self->{Translation}->{'ITSM event module deletes the history of changes.'} = '';
    $Self->{Translation}->{'ITSM event module that cleans up conditions.'} = '';
    $Self->{Translation}->{'ITSM event module that deletes the cache for a toolbar.'} = '';
    $Self->{Translation}->{'ITSM event module that matches conditions and executes actions.'} =
        '';
    $Self->{Translation}->{'ITSM event module that sends notifications.'} = '';
    $Self->{Translation}->{'ITSM event module that updates the history of changes.'} = '';
    $Self->{Translation}->{'ITSM event module to recalculate the workorder numbers.'} = '';
    $Self->{Translation}->{'ITSM event module to set the actual start and end times of workorders.'} =
        '';
    $Self->{Translation}->{'ITSM event module updates the history of changes.'} = '';
    $Self->{Translation}->{'ITSM event module updates the history of conditions.'} = '';
    $Self->{Translation}->{'ITSM event module updates the history of workorders.'} = '';
    $Self->{Translation}->{'If frequency is \'regularly\', you can configure how often the notications are sent (every X hours).'} =
        '';
    $Self->{Translation}->{'If this option is enabled, then the decrypted data will be stored in the database if they are displayed in AgentTicketZoom.'} =
        '';
    $Self->{Translation}->{'Logfile for the ITSM change counter. This file is used for creating the change numbers.'} =
        '';
    $Self->{Translation}->{'Module to check the CAB members.'} = '';
    $Self->{Translation}->{'Module to check the agent.'} = '';
    $Self->{Translation}->{'Module to check the change builder.'} = '';
    $Self->{Translation}->{'Module to check the change manager.'} = '';
    $Self->{Translation}->{'Module to check the workorder agent.'} = '';
    $Self->{Translation}->{'Module to check whether no workorder agent is set.'} = '';
    $Self->{Translation}->{'Module to check whether the agent is contained in the configured list.'} =
        '';
    $Self->{Translation}->{'Module to show a link to create a change from this ticket. The ticket will be automatically linked with the new change.'} =
        '';
    $Self->{Translation}->{'Notification (ITSM Change Management)'} = 'Powiadomienia zmian ITSM';
    $Self->{Translation}->{'Only users of these groups have the permission to use the ticket types as defined in "ITSMChange::AddChangeLinkTicketTypes" if the feature "Ticket::Acl::Module###200-Ticket::Acl::Module" is enabled.'} =
        '';
    $Self->{Translation}->{'Parameters for the pages (in which the changes are shown) of the small change overview.'} =
        '';
    $Self->{Translation}->{'Presents a link in the menu to show the involved persons in a change, in the zoom view of such change in the agent interface.'} =
        '';
    $Self->{Translation}->{'Required privileges in order for an agent to take a workorder.'} =
        '';
    $Self->{Translation}->{'Required privileges to access the overview of all changes.'} = '';
    $Self->{Translation}->{'Required privileges to add a workorder.'} = '';
    $Self->{Translation}->{'Required privileges to change the workorder agent.'} = '';
    $Self->{Translation}->{'Required privileges to create a template from a change.'} = '';
    $Self->{Translation}->{'Required privileges to create a template from a changes\' CAB.'} =
        '';
    $Self->{Translation}->{'Required privileges to create a template from a workorder.'} = '';
    $Self->{Translation}->{'Required privileges to create changes from templates.'} = '';
    $Self->{Translation}->{'Required privileges to create changes.'} = '';
    $Self->{Translation}->{'Required privileges to delete a template.'} = '';
    $Self->{Translation}->{'Required privileges to delete a workorder.'} = '';
    $Self->{Translation}->{'Required privileges to delete changes.'} = '';
    $Self->{Translation}->{'Required privileges to edit a template.'} = '';
    $Self->{Translation}->{'Required privileges to edit a workorder.'} = '';
    $Self->{Translation}->{'Required privileges to edit changes.'} = '';
    $Self->{Translation}->{'Required privileges to edit the conditions of changes.'} = '';
    $Self->{Translation}->{'Required privileges to edit the involved persons of a change.'} =
        '';
    $Self->{Translation}->{'Required privileges to move changes in time.'} = '';
    $Self->{Translation}->{'Required privileges to print a change.'} = '';
    $Self->{Translation}->{'Required privileges to reset changes.'} = '';
    $Self->{Translation}->{'Required privileges to view a workorder.'} = '';
    $Self->{Translation}->{'Required privileges to view changes.'} = '';
    $Self->{Translation}->{'Required privileges to view list of changes where the user is a CAB member.'} =
        '';
    $Self->{Translation}->{'Required privileges to view list of changes where the user is the change manager.'} =
        '';
    $Self->{Translation}->{'Required privileges to view overview over all templates.'} = '';
    $Self->{Translation}->{'Required privileges to view the conditions of changes.'} = '';
    $Self->{Translation}->{'Required privileges to view the history of a change.'} = '';
    $Self->{Translation}->{'Required privileges to view the history of a workorder.'} = '';
    $Self->{Translation}->{'Required privileges to view the history zoom of a change.'} = '';
    $Self->{Translation}->{'Required privileges to view the history zoom of a workorder.'} =
        '';
    $Self->{Translation}->{'Required privileges to view the list of Change Schedule.'} = '';
    $Self->{Translation}->{'Required privileges to view the list of change PSA.'} = '';
    $Self->{Translation}->{'Required privileges to view the list of changes with an upcoming PIR (Post Implementation Review).'} =
        '';
    $Self->{Translation}->{'Required privileges to view the list of own changes.'} = '';
    $Self->{Translation}->{'Required privileges to view the list of own workorders.'} = '';
    $Self->{Translation}->{'Required privileges to write a report for the workorder.'} = '';
    $Self->{Translation}->{'Selects the change number generator module. "AutoIncrement" increments the change number, the SystemID and the counter are used with SystemID.counter format (e.g. 100118, 100119). With "Date", the change numbers will be generated by the current date and a counter; this format looks like Year.Month.Day.counter, e.g. 2010062400001, 2010062400002. With "DateChecksum", the counter will be appended as checksum to the string of date plus the SystemID. The checksum will be rotated on a daily basis. This format looks like Year.Month.Day.SystemID.Counter.CheckSum, e.g. 2010062410000017, 2010062410000026.'} =
        '';
    $Self->{Translation}->{'Sets the minimal change counter size (if "AutoIncrement" was selected as ITSMChange::NumberGenerator). Default is 5, this means the counter starts from 10000.'} =
        '';
    $Self->{Translation}->{'Sets up the state machine for changes.'} = '';
    $Self->{Translation}->{'Sets up the state machine for workorders.'} = '';
    $Self->{Translation}->{'Shows a checkbox in the AgentITSMWorkOrderEdit screen that defines if the the following workorders should also be moved if a workorder is modified and the planned end time has changed.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows changing the work order agent, in the zoom view of such work order of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows defining a change as a template in the zoom view of the change, in the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows defining a work order as a template in the zoom view of the work order, in the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows editing the report of a workd order, in the zoom view of such work order of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows linking a change with another object in the change zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows linking a work order with another object in the zoom view of such work order of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows moving the time slot of a change in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows taking a work order in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to access the conditions of a change in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to access the history of a change in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to access the history of a work order in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to add a work order in the change zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to delete a change in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to delete a work order in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to edit a change in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to edit a work order in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to go back in the change zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to go back in the work order zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to print a change in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to print a work order in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to reset a change and its workorders in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows the change history (reverse ordered) in the agent interface.'} =
        '';
    $Self->{Translation}->{'State Machine'} = 'Maszyna stanów';
    $Self->{Translation}->{'The identifier for a change, e.g. Change#, MyChange#. The default is Change#.'} =
        '';
    $Self->{Translation}->{'The identifier for a workorder, e.g. Workorder#, MyWorkorder#. The default is Workorder#.'} =
        '';
    $Self->{Translation}->{'This ACL module restricts the usuage of the ticket types that are defined in the sysconfig option \'ITSMChange::AddChangeLinkTicketTypes\', to users of the groups as defined in "ITSMChange::RestrictTicketTypes::Groups". As this ACL could collide with other ACLs which are also related to the ticket type, this sysconfig option is disabled by default and should only be activated if needed.'} =
        '';
    $Self->{Translation}->{'Types of tickets, where in the ticket zoom view a link to add a change will be displayed.'} =
        '';
    $Self->{Translation}->{'Workorder free text options shown in the change search of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        '';
    $Self->{Translation}->{'Workorder free text options shown in the workorder add of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';
    $Self->{Translation}->{'Workorder free text options shown in the workorder edit of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';
    $Self->{Translation}->{'Workorder free text options shown in the workorder report of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #
    $Self->{Translation}->{'CAB Agent'} = 'CAB agent';
    $Self->{Translation}->{'CAB Customer'} = 'CAB klient';
    $Self->{Translation}->{'Cache time in minutes for the change management.'} = 'Czas zachowywania zmian w pamięci podręcznej w minutach.';
    $Self->{Translation}->{'Change Description'} = 'Opis zmiany';
    $Self->{Translation}->{'Change Impact'} = 'Wpływ zmiany';
    $Self->{Translation}->{'Change Justification'} = 'Uzasadnienie zmiany';
    $Self->{Translation}->{'Change Number'} = 'Numer zmiany';
    $Self->{Translation}->{'Change Priority'} = 'Priorytet zmiany';
    $Self->{Translation}->{'Change State'} = 'Stan zmiany';
    $Self->{Translation}->{'Change Title'} = 'Tytuł zmiany';
    $Self->{Translation}->{'Impact \ Category'} = 'Wpływ \ Kategoria';
    $Self->{Translation}->{'My Work Orders'} = 'Moje zadania';
    $Self->{Translation}->{'Projected Service Availability'} = 'PSA';
    $Self->{Translation}->{'Schedule'} = 'Harmonogram';
    $Self->{Translation}->{'Search Agent'} = 'Szukaj agenta';
    $Self->{Translation}->{'Work Order Title'} = 'Tytuł zadania';
    $Self->{Translation}->{'WorkOrder Agent'} = 'Agent zadania';
    $Self->{Translation}->{'WorkOrder Instruction'} = 'Instrukcja zadania';
    $Self->{Translation}->{'WorkOrder Report'} = 'Raport zadania';
    $Self->{Translation}->{'WorkOrder State'} = 'Stan zadania';
    $Self->{Translation}->{'pending decision'} = 'czeka na decyzję';

}

1;
