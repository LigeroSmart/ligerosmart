# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pl_ITSMChangeManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAITSMChangeManagement
    $Self->{Translation}->{'ITSMChange'} = 'ZmianaITSM';
    $Self->{Translation}->{'ITSMChanges'} = 'ZmianyITSM';
    $Self->{Translation}->{'ITSM Changes'} = 'Zmiany ITSM';
    $Self->{Translation}->{'workorder'} = 'zadanie';
    $Self->{Translation}->{'A change must have a title!'} = 'Zmiana musi posiadać tytuł!';
    $Self->{Translation}->{'A condition must have a name!'} = 'Warunek musi posiadań nazwę!';
    $Self->{Translation}->{'A template must have a name!'} = 'Szablon musi posiadać nazwę!';
    $Self->{Translation}->{'A workorder must have a title!'} = 'Zadanie musi posiadać tytuł!';
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
    $Self->{Translation}->{'ChangeHistory::ActionAddID'} = 'ChangeHistory::ActionAddID';
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
    $Self->{Translation}->{'ChangeHistory::ConditionAddID'} = 'ChangeHistory::ConditionAddID';
    $Self->{Translation}->{'ChangeHistory::ConditionDelete'} = 'Warunek (ID=%s) usunięty';
    $Self->{Translation}->{'ChangeHistory::ConditionDeleteAll'} = 'Wszsytkie warunki w zmianie (ID=%s) usunięte';
    $Self->{Translation}->{'ChangeHistory::ConditionUpdate'} = '%s (Warunek ID=%s): Nowe: %s <- Stare: %s';
    $Self->{Translation}->{'ChangeHistory::ExpressionAdd'} = '%s: %s';
    $Self->{Translation}->{'ChangeHistory::ExpressionAddID'} = 'ChangeHistory::ExpressionAddID';
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
    $Self->{Translation}->{'New (from template)'} = 'Nowy (z szablonu)';
    $Self->{Translation}->{'Add from template'} = '';
    $Self->{Translation}->{'Add Workorder (from template)'} = '';
    $Self->{Translation}->{'Add a workorder (from template) to the change'} = '';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualEndTimeReached'} = 'Zadanie (ID=%s) osiągnęło rzeczywisty czas końca.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualEndTimeReachedWithWorkOrderID'} =
        'WorkOrderHistory::WorkOrderActualEndTimeReachedWithWorkOrderID';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualStartTimeReached'} = 'Zadanie (ID=%s) osiągnęło rzeczywisty czas startu.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualStartTimeReachedWithWorkOrderID'} =
        'WorkOrderHistory::WorkOrderActualStartTimeReachedWithWorkOrderID';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAdd'} = 'Nowe zadanie (ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAddWithWorkOrderID'} = 'WorkOrderHistory::WorkOrderAddWithWorkOrderID';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentAdd'} = '(ID=%s) Nowy załącznik do zadania: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentAddWithWorkOrderID'} = 'WorkOrderHistory::WorkOrderAttachmentAddWithWorkOrderID';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentDelete'} = 'Usunięty załącznik z zadania: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentDeleteWithWorkOrderID'} = 'WorkOrderHistory::WorkOrderAttachmentDeleteWithWorkOrderID';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentAdd'} = '';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentAddWithWorkOrderID'} =
        'WorkOrderHistory::WorkOrderReportAttachmentAddWithWorkOrderID';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentDelete'} = '';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentDeleteWithWorkOrderID'} =
        'WorkOrderHistory::WorkOrderReportAttachmentDeleteWithWorkOrderID';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderDelete'} = 'Zadanie (ID=%s) usunięte';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderDeleteWithWorkOrderID'} = 'WorkOrderHistory::WorkOrderDeleteWithWorkOrderID';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkAdd'} = 'Utworzony odnośnik do %s (ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkAddWithWorkOrderID'} = 'WorkOrderHistory::WorkOrderLinkAddWithWorkOrderID';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkDelete'} = 'Usynięty odnośnik do %s (ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkDeleteWithWorkOrderID'} = 'WorkOrderHistory::WorkOrderLinkDeleteWithWorkOrderID';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderNotificationSent'} = 'Powiadomienie wysłane do %s (Zdarzenie: %s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderNotificationSentWithWorkOrderID'} = 'WorkOrderHistory::WorkOrderNotificationSentWithWorkOrderID';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedEndTimeReached'} = 'Zadanie (ID=%s) osiągnęło planowany czas końca.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedEndTimeReachedWithWorkOrderID'} =
        'Zadanie (ID=%s) osiągnęło planowany czas końca.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedStartTimeReached'} = 'Zadanie (ID=%s) osiągnęło planowany czas startu.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedStartTimeReachedWithWorkOrderID'} =
        'Zadanie (ID=%s) osiągnęło planowany czas startu.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderUpdate'} = '%s: Nowe: %s <- Stare: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderUpdateWithWorkOrderID'} = 'WorkOrderHistory::WorkOrderUpdateWithWorkOrderID';
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
    $Self->{Translation}->{'Rule'} = 'Reguła';
    $Self->{Translation}->{'A notification should have a name!'} = 'Powiadomiene powinno mieć nazwę!';
    $Self->{Translation}->{'Name is required.'} = 'Imię i nazwisko są wymagane.';

    # Template: AdminITSMStateMachine
    $Self->{Translation}->{'Admin State Machine'} = 'Zarządaj maszyną stanów';
    $Self->{Translation}->{'Select a catalog class!'} = 'Zaznacz klasę katalogu!';
    $Self->{Translation}->{'A catalog class is required!'} = 'Klasa katalogu jest wymagana!';
    $Self->{Translation}->{'Add a state transition'} = 'Dodaj przejście między stanami';
    $Self->{Translation}->{'Catalog Class'} = 'Klasa katalogu';
    $Self->{Translation}->{'Object Name'} = 'Nazwa obiektu';
    $Self->{Translation}->{'Overview over state transitions for'} = 'Przegląd przejść stanów dla';
    $Self->{Translation}->{'Delete this state transition'} = 'Usuń to przejście między stanami';
    $Self->{Translation}->{'Add a new state transition for'} = 'Dodaj nowe przejście stanu dla';
    $Self->{Translation}->{'Please select a state!'} = 'Zaznacz stan!';
    $Self->{Translation}->{'Please select a next state!'} = 'Zaznacz następny stan!';
    $Self->{Translation}->{'Edit a state transition for'} = 'Edytuj przejście stanu dla';
    $Self->{Translation}->{'Do you really want to delete the state transition'} = 'Czy na pewno chcesz usunąć przejście stanu';
    $Self->{Translation}->{'from'} = 'od';
    $Self->{Translation}->{'to'} = 'do';

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
    $Self->{Translation}->{'Invalid Name'} = 'Niepoprawna nazwa';

    # Template: AgentITSMChangeCondition
    $Self->{Translation}->{'Conditions and Actions'} = 'Warunki i akcje';
    $Self->{Translation}->{'Delete Condition'} = 'Usuń warunek';
    $Self->{Translation}->{'Add new condition'} = 'Dodaj nowy warunek';

    # Template: AgentITSMChangeConditionEdit
    $Self->{Translation}->{'Need a valid name.'} = 'Potrzeba poprawna nazwa.';
    $Self->{Translation}->{'A valid name is needed.'} = '';
    $Self->{Translation}->{'Duplicate name:'} = '';
    $Self->{Translation}->{'This name is already used by another condition.'} = '';
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

    # Template: AgentITSMChangeHistory
    $Self->{Translation}->{'History of'} = 'Historia';
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

    # Template: AgentITSMChangeReset
    $Self->{Translation}->{'Do you really want to reset this change?'} = '';

    # Template: AgentITSMChangeSearch
    $Self->{Translation}->{'(e.g. 10*5155 or 105658*)'} = '(np. 10*5155 or 105658*)';
    $Self->{Translation}->{'CABAgent'} = 'CAB Agent';
    $Self->{Translation}->{'e.g.'} = 'np.';
    $Self->{Translation}->{'CABCustomer'} = 'CAB Klient';
    $Self->{Translation}->{'ITSM Workorder'} = 'Zadanie';
    $Self->{Translation}->{'Instruction'} = 'Instrukcja';
    $Self->{Translation}->{'Report'} = 'Raport';
    $Self->{Translation}->{'Change Category'} = 'Kategoria zmiany';
    $Self->{Translation}->{'(before/after)'} = '(przed/po)';
    $Self->{Translation}->{'(between)'} = '(pomiędzy)';

    # Template: AgentITSMChangeTemplate
    $Self->{Translation}->{'Save Change as Template'} = 'Zapisz zmianę jako szablon';
    $Self->{Translation}->{'A template should have a name!'} = 'Szablon powinien mieć nazwę!';
    $Self->{Translation}->{'The template name is required.'} = 'Nazwa szablonu jest wymagana.';
    $Self->{Translation}->{'Reset States'} = 'Resetuj stan';
    $Self->{Translation}->{'Overwrite original template'} = '';
    $Self->{Translation}->{'Delete original change'} = '';

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
    $Self->{Translation}->{'To open links in the following description blocks, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).'} =
        '';
    $Self->{Translation}->{'Download Attachment'} = 'Pobierz załącznik';

    # Template: AgentITSMTemplateDelete
    $Self->{Translation}->{'Do you really want to delete this template?'} = 'Czy na pewno chcesz usunąć ten szablon?';

    # Template: AgentITSMTemplateEditCAB
    $Self->{Translation}->{'Edit CAB Template'} = 'Edytuj szablon CAB';

    # Template: AgentITSMTemplateEditContent
    $Self->{Translation}->{'This will create a new change from this template, so you can edit and save it.'} =
        '';
    $Self->{Translation}->{'The new change will be deleted automatically after it has been saved as template.'} =
        '';
    $Self->{Translation}->{'This will create a new workorder from this template, so you can edit and save it.'} =
        '';
    $Self->{Translation}->{'A temporary change will be created which contains the workorder.'} =
        '';
    $Self->{Translation}->{'The temporary change and new workorder will be deleted automatically after the workorder has been saved as template.'} =
        '';
    $Self->{Translation}->{'Do you want to proceed?'} = '';

    # Template: AgentITSMTemplateOverviewSmall
    $Self->{Translation}->{'TemplateID'} = 'Szablon-ID';
    $Self->{Translation}->{'Edit Content'} = '';
    $Self->{Translation}->{'CreateBy'} = 'Utworzone przez';
    $Self->{Translation}->{'CreateTime'} = 'Czas utworzenia';
    $Self->{Translation}->{'ChangeBy'} = 'Zmienione przez';
    $Self->{Translation}->{'ChangeTime'} = 'Czas zmiany';
    $Self->{Translation}->{'Edit Template Content'} = '';
    $Self->{Translation}->{'Delete Template'} = 'Usuń szablon';

    # Template: AgentITSMWorkOrderAdd
    $Self->{Translation}->{'Add Workorder to'} = 'Dodaj zadanie do';
    $Self->{Translation}->{'Invalid workorder type.'} = 'Nieprawidłowy typ zadania.';
    $Self->{Translation}->{'The planned start time must be before the planned end time!'} = 'Planowany czas startu musi być przed planowanym czasem końca!';
    $Self->{Translation}->{'Invalid format.'} = 'Nieprawidłowy format.';

    # Template: AgentITSMWorkOrderAddFromTemplate
    $Self->{Translation}->{'Select Workorder Template'} = 'Wskaż szablon zadania';

    # Template: AgentITSMWorkOrderDelete
    $Self->{Translation}->{'Do you really want to delete this workorder?'} = 'Czy na pewno chcesz usunąć to zadanie?';
    $Self->{Translation}->{'You can not delete this Workorder. It is used in at least one Condition!'} =
        'Nie możesz usunąć tego zadania. Jest ono używane w przynajmniej jednym warunku!';
    $Self->{Translation}->{'This Workorder is used in the following Condition(s)'} = 'To zadanie jest używane w następujących warunkach';

    # Template: AgentITSMWorkOrderEdit
    $Self->{Translation}->{'Move following workorders accordingly'} = '';
    $Self->{Translation}->{'If the planned end time of this workorder is changed, the planned start times of all following workorders will be changed accordingly'} =
        '';

    # Template: AgentITSMWorkOrderReport
    $Self->{Translation}->{'The actual start time must be before the actual end time!'} = 'Rzeczywisty czas startu musi być przed rzecztwistym czasem końca!';
    $Self->{Translation}->{'The actual start time must be set, when the actual end time is set!'} =
        'Rzeczywisty czas startu musi być ustawiony gdy ustawiony jest rzeczywisty czas końca!';

    # Template: AgentITSMWorkOrderTake
    $Self->{Translation}->{'Current Agent'} = 'Aktualny agent';
    $Self->{Translation}->{'Do you really want to take this workorder?'} = 'Czy na pewno chcesz wziąć to zadanie?';

    # Template: AgentITSMWorkOrderTemplate
    $Self->{Translation}->{'Save Workorder as Template'} = 'Zapisz zadanie jako szablon';
    $Self->{Translation}->{'Delete original workorder (and surrounding change)'} = '';

    # Template: AgentITSMWorkOrderZoom
    $Self->{Translation}->{'Workorder Information'} = 'Zadanie-informacje';

    # Perl Module: Kernel/Modules/AdminITSMChangeNotification.pm
    $Self->{Translation}->{'Unknown notification %s!'} = '';
    $Self->{Translation}->{'There was an error creating the notification.'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChange.pm
    $Self->{Translation}->{'Overview: ITSM Changes'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeAdd.pm
    $Self->{Translation}->{'Ticket with TicketID %s does not exist!'} = '';
    $Self->{Translation}->{'Missing sysconfig option "ITSMChange::AddChangeLinkTicketTypes"!'} =
        '';
    $Self->{Translation}->{'Was not able to add change!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeAddFromTemplate.pm
    $Self->{Translation}->{'Was not able to create change from template!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeCABTemplate.pm
    $Self->{Translation}->{'No ChangeID is given!'} = '';
    $Self->{Translation}->{'No change found for changeID %s.'} = '';
    $Self->{Translation}->{'The CAB of change "%s" could not be serialized.'} = '';
    $Self->{Translation}->{'Could not add the template.'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeCondition.pm
    $Self->{Translation}->{'Change "%s" not found in database!'} = '';
    $Self->{Translation}->{'Could not delete ConditionID %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeConditionEdit.pm
    $Self->{Translation}->{'No %s is given!'} = '';
    $Self->{Translation}->{'Could not create new condition!'} = '';
    $Self->{Translation}->{'Could not update ConditionID %s!'} = '';
    $Self->{Translation}->{'Could not update ExpressionID %s!'} = '';
    $Self->{Translation}->{'Could not add new Expression!'} = '';
    $Self->{Translation}->{'Could not update ActionID %s!'} = '';
    $Self->{Translation}->{'Could not add new Action!'} = '';
    $Self->{Translation}->{'Could not delete ExpressionID %s!'} = '';
    $Self->{Translation}->{'Could not delete ActionID %s!'} = '';
    $Self->{Translation}->{'Error: Unknown field type "%s"!'} = '';
    $Self->{Translation}->{'ConditionID %s does not belong to the given ChangeID %s!'} = '';
    $Self->{Translation}->{'Please contact the administrator.'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeDelete.pm
    $Self->{Translation}->{'Change "%s" does not have an allowed change state to be deleted!'} =
        '';
    $Self->{Translation}->{'Was not able to delete the changeID %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeEdit.pm
    $Self->{Translation}->{'Was not able to update Change!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeHistory.pm
    $Self->{Translation}->{'Can\'t show history, as no ChangeID is given!'} = '';
    $Self->{Translation}->{'Change "%s" not found in the database!'} = '';
    $Self->{Translation}->{'Unknown type "%s" encountered!'} = '';
    $Self->{Translation}->{'Change History'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeHistoryZoom.pm
    $Self->{Translation}->{'Can\'t show history zoom, no HistoryEntryID is given!'} = '';
    $Self->{Translation}->{'HistoryEntry "%s" not found in database!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeInvolvedPersons.pm
    $Self->{Translation}->{'Was not able to update Change CAB for Change %s!'} = '';
    $Self->{Translation}->{'Was not able to update Change %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeManager.pm
    $Self->{Translation}->{'Overview: ChangeManager'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeMyCAB.pm
    $Self->{Translation}->{'Overview: My CAB'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeMyChanges.pm
    $Self->{Translation}->{'Overview: My Changes'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeMyWorkOrders.pm
    $Self->{Translation}->{'Overview: My Workorders'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangePIR.pm
    $Self->{Translation}->{'Overview: PIR'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangePSA.pm
    $Self->{Translation}->{'Overview: PSA'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangePrint.pm
    $Self->{Translation}->{'WorkOrder "%s" not found in database!'} = '';
    $Self->{Translation}->{'Can\'t create output, as the workorder is not attached to a change!'} =
        '';
    $Self->{Translation}->{'Can\'t create output, as no ChangeID is given!'} = '';
    $Self->{Translation}->{'unknown change title'} = '';
    $Self->{Translation}->{'unknown workorder title'} = '';
    $Self->{Translation}->{'ITSM Workorder Overview (%s)'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeReset.pm
    $Self->{Translation}->{'Was not able to reset WorkOrder %s of Change %s!'} = '';
    $Self->{Translation}->{'Was not able to reset Change %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeSchedule.pm
    $Self->{Translation}->{'Overview: Change Schedule'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeSearch.pm
    $Self->{Translation}->{'Change Search'} = '';
    $Self->{Translation}->{'WorkOrders'} = 'Zadania';
    $Self->{Translation}->{'Change Search Result'} = '';
    $Self->{Translation}->{'Change Number'} = '';
    $Self->{Translation}->{'Change Title'} = '';
    $Self->{Translation}->{'Work Order Title'} = '';
    $Self->{Translation}->{'CAB Agent'} = '';
    $Self->{Translation}->{'CAB Customer'} = '';
    $Self->{Translation}->{'Change Description'} = '';
    $Self->{Translation}->{'Change Justification'} = '';
    $Self->{Translation}->{'WorkOrder Instruction'} = '';
    $Self->{Translation}->{'WorkOrder Report'} = '';
    $Self->{Translation}->{'Change Priority'} = '';
    $Self->{Translation}->{'Change Impact'} = '';
    $Self->{Translation}->{'Change State'} = '';
    $Self->{Translation}->{'Created By'} = '';
    $Self->{Translation}->{'WorkOrder State'} = '';
    $Self->{Translation}->{'WorkOrder Type'} = '';
    $Self->{Translation}->{'WorkOrder Agent'} = '';
    $Self->{Translation}->{'Planned Start Time'} = '';
    $Self->{Translation}->{'Planned End Time'} = '';
    $Self->{Translation}->{'Actual Start Time'} = '';
    $Self->{Translation}->{'Actual End Time'} = '';
    $Self->{Translation}->{'Change Time'} = '';
    $Self->{Translation}->{'before'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeTemplate.pm
    $Self->{Translation}->{'The change "%s" could not be serialized.'} = '';
    $Self->{Translation}->{'Could not update the template "%s".'} = '';
    $Self->{Translation}->{'Could not delete change "%s".'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeTimeSlot.pm
    $Self->{Translation}->{'The change can\'t be moved, as it has no workorders.'} = '';
    $Self->{Translation}->{'Add a workorder first.'} = '';
    $Self->{Translation}->{'Can\'t move a change which already has started!'} = '';
    $Self->{Translation}->{'Please move the individual workorders instead.'} = '';
    $Self->{Translation}->{'The current %s could not be determined.'} = '';
    $Self->{Translation}->{'The %s of all workorders has to be defined.'} = '';
    $Self->{Translation}->{'Was not able to move time slot for workorder #%s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMTemplateDelete.pm
    $Self->{Translation}->{'You need %s permission!'} = '';
    $Self->{Translation}->{'No TemplateID is given!'} = '';
    $Self->{Translation}->{'Template "%s" not found in database!'} = '';
    $Self->{Translation}->{'Was not able to delete the template %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMTemplateEdit.pm
    $Self->{Translation}->{'Was not able to update Template %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMTemplateEditCAB.pm
    $Self->{Translation}->{'Was not able to update Template "%s"!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMTemplateEditContent.pm
    $Self->{Translation}->{'Was not able to create change!'} = '';
    $Self->{Translation}->{'Was not able to create workorder from template!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMTemplateOverview.pm
    $Self->{Translation}->{'Overview: Template'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderAdd.pm
    $Self->{Translation}->{'You need %s permissions on the change!'} = '';
    $Self->{Translation}->{'Was not able to add workorder!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderAgent.pm
    $Self->{Translation}->{'No WorkOrderID is given!'} = '';
    $Self->{Translation}->{'Was not able to set the workorder agent of the workorder "%s" to empty!'} =
        '';
    $Self->{Translation}->{'Was not able to update the workorder "%s"!'} = '';
    $Self->{Translation}->{'Could not find Change for WorkOrder %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderDelete.pm
    $Self->{Translation}->{'Was not able to delete the workorder %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderEdit.pm
    $Self->{Translation}->{'Was not able to update WorkOrder %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderHistory.pm
    $Self->{Translation}->{'Can\'t show history, as no WorkOrderID is given!'} = '';
    $Self->{Translation}->{'WorkOrder "%s" not found in the database!'} = '';
    $Self->{Translation}->{'WorkOrderHistory::'} = '';
    $Self->{Translation}->{'WorkOrder History'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderHistoryZoom.pm
    $Self->{Translation}->{'History entry "%s" not found in the database!'} = '';
    $Self->{Translation}->{'WorkOrder History Zoom'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderTake.pm
    $Self->{Translation}->{'Was not able to take the workorder %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderTemplate.pm
    $Self->{Translation}->{'The workorder "%s" could not be serialized.'} = '';

    # Perl Module: Kernel/Output/HTML/ToolBar/MyWorkOrders.pm
    $Self->{Translation}->{'My Work Orders'} = '';

}

1;
