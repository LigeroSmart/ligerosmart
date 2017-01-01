# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pl_TimeAccounting;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentTimeAccountingDelete
    $Self->{Translation}->{'Do you really want to delete the Time Accounting of this day?'} =
        'Czy na pewno chcesz usunąć rozliczenie czasu pracy tego dnia?';

    # Template: AgentTimeAccountingEdit
    $Self->{Translation}->{'Edit Time Record'} = 'Edycja ewidencji czasu pracy';
    $Self->{Translation}->{'Go to settings'} = 'Przejdź do ustawień';
    $Self->{Translation}->{'Date Navigation'} = 'Nawigacja po dacie';
    $Self->{Translation}->{'Previous day'} = 'Poprzedni dzień';
    $Self->{Translation}->{'Next day'} = 'Kolejny dzień';
    $Self->{Translation}->{'Go to this date'} = 'Przejdź do tego dnia';
    $Self->{Translation}->{'Days without entries'} = 'Dni bez wpisów';
    $Self->{Translation}->{'Select all days'} = 'Zaznacz wszystkie dni';
    $Self->{Translation}->{'Mass entry'} = 'Masowe wpisywanie';
    $Self->{Translation}->{'Please choose the reason for your absence for the selected days'} =
        'Proszę wybrać przyczynę nieobecności dla wybranych dni';
    $Self->{Translation}->{'On vacation'} = 'Urlop';
    $Self->{Translation}->{'On sick leave'} = 'Zwolnienie lekarskie';
    $Self->{Translation}->{'On overtime leave'} = 'Wolne za godziny nadliczbowe';
    $Self->{Translation}->{'Please choose at least one day!'} = 'Proszę wybrać co najmniej jeden dzień!';
    $Self->{Translation}->{'Please choose a reason for absence!'} = 'Proszę wybrać przyczynę nieobecności!';
    $Self->{Translation}->{'Mass Entry'} = 'Masowe wpisywanie';
    $Self->{Translation}->{'Required fields are marked with a "*".'} = 'Pola wymagane oznaczone są "*".';
    $Self->{Translation}->{'You have to fill in start and end time or a time period.'} = 'Musisz wprowadzić czas początku i zakończenia lub określ czas trwania cylku.';
    $Self->{Translation}->{'Project'} = 'Projekt';
    $Self->{Translation}->{'Task'} = 'Zadanie';
    $Self->{Translation}->{'Remark'} = 'Uwaga';
    $Self->{Translation}->{'Please add a remark with more than 8 characters!'} = '';
    $Self->{Translation}->{'Start Time'} = 'Czas rozpoczęcia';
    $Self->{Translation}->{'Negative times are not allowed.'} = 'Ujemne czasy są niedozwolone.';
    $Self->{Translation}->{'Repeated hours are not allowed. Start time matches another interval.'} =
        'Pokrywające się godziny nie są dozwolone. Czas rozpoczęcia pasuje do innego przedziału.';
    $Self->{Translation}->{'Invalid format! Please enter a time with the format HH:MM.'} = 'Nieprawidłowy format! Proszę podać czas w formacie GG:MM.';
    $Self->{Translation}->{'24:00 is only permitted as end time.'} = '24:00 jest dozwolona jedynie jako czas zakończenia.';
    $Self->{Translation}->{'Invalid time! A day has only 24 hours.'} = 'Nieprawidłowy czas! Dzień ma tylko 24 godziny.';
    $Self->{Translation}->{'End Time'} = 'Czas zakończenia';
    $Self->{Translation}->{'End time must be after start time.'} = 'Czas zakończenia musi być po czasie rozpoczęcia.';
    $Self->{Translation}->{'Repeated hours are not allowed. End time matches another interval.'} =
        'Pokrywające się godziny nie są dozwolone. Czas zakończenia pasuje do innego przedziału.';
    $Self->{Translation}->{'Invalid period! A day has only 24 hours.'} = 'Nieprawidłowy czas cyklu! Dzień ma tylko 24 godziny.';
    $Self->{Translation}->{'A valid period must be greater than zero.'} = 'Prawidłowy czas cyklu musi być większy od zera.';
    $Self->{Translation}->{'Invalid period! Negative periods are not allowed.'} = 'Nieprawidłowy cykl! Ujemny czas cyklu nie jest dozwolony.';
    $Self->{Translation}->{'Add one row'} = 'Dodaj wiersz';
    $Self->{Translation}->{'Total'} = 'Suma';
    $Self->{Translation}->{'You can only select one checkbox element!'} = 'Możesz zaznaczyć tylko jeden element!';
    $Self->{Translation}->{'Show all items'} = 'Pokaż całą zawartość';
    $Self->{Translation}->{'Delete Time Accounting Entry'} = 'Usuń rozliczenie czasu pracy';
    $Self->{Translation}->{'Confirm insert'} = 'Potwierdź wpis';
    $Self->{Translation}->{'Are you sure that you worked while you were on sick leave?'} = 'Czy jesteś pewien, że pracowałeś w trakcie zwolnienia lekarskiego?';
    $Self->{Translation}->{'Are you sure that you worked while you were on vacation?'} = 'Czy jesteś pewien, że pracowałeś w trakcie urlopu?';
    $Self->{Translation}->{'Are you sure that you worked while you were on overtime leave?'} =
        'Czy jesteś pewien, że pracowałeś w trakcie wolnego za nadgodziny?';
    $Self->{Translation}->{'Are you sure that you worked more than 16 hours?'} = 'Czy jesteś pewien, że pracowałeś więcej niż 16 godzin?';

    # Template: AgentTimeAccountingOverview
    $Self->{Translation}->{'Time reporting monthly overview'} = 'Miesięczny raport czasu pracy';
    $Self->{Translation}->{'Overtime (Hours)'} = 'Godziny nadliczbowe';
    $Self->{Translation}->{'Overtime (this month)'} = 'Godziny nadliczbowe (bieżący miesiąc)';
    $Self->{Translation}->{'Overtime (total)'} = 'Godziny nadliczbowe (łącznie)';
    $Self->{Translation}->{'Remaining overtime leave'} = 'Pozostałe godziny nadliczbowe do wybrania';
    $Self->{Translation}->{'Vacation (Days)'} = 'Urlop (dni)';
    $Self->{Translation}->{'Vacation taken (this month)'} = 'Wykorzystany urlop (bieżący miesiąc)';
    $Self->{Translation}->{'Vacation taken (total)'} = 'Wykorzystany urlop (łącznie)';
    $Self->{Translation}->{'Remaining vacation'} = 'Urlop pozostały do wykorzystania';
    $Self->{Translation}->{'Sick Leave (Days)'} = 'Zwolnienie lekarskie (dni)';
    $Self->{Translation}->{'Sick leave taken (this month)'} = 'Dni zwolnienia lekarskiego (bieżący miesiąc)';
    $Self->{Translation}->{'Sick leave taken (total)'} = 'Dni zwolnienia lekarskiego (łącznie)';
    $Self->{Translation}->{'Previous month'} = 'Poprzedni miesiąc';
    $Self->{Translation}->{'Next month'} = 'Następny miesiąc';
    $Self->{Translation}->{'Weekday'} = 'Dzień roboczy';
    $Self->{Translation}->{'Working Hours'} = 'Godziny pracy';
    $Self->{Translation}->{'Total worked hours'} = 'Łączna ilość przepracowanych godzin';
    $Self->{Translation}->{'User\'s project overview'} = 'Opis projektu użytkownika';
    $Self->{Translation}->{'Hours (monthly)'} = 'Godziny (miesięcznie)';
    $Self->{Translation}->{'Hours (Lifetime)'} = 'Godziny (łącznie)';
    $Self->{Translation}->{'Grand total'} = 'Ogółem';

    # Template: AgentTimeAccountingReporting
    $Self->{Translation}->{'Time reporting'} = 'Raortowanie czasu';
    $Self->{Translation}->{'Month Navigation'} = 'Nawigacja miesięczna';
    $Self->{Translation}->{'Go to date'} = 'Przejdź do daty';
    $Self->{Translation}->{'User reports'} = 'Raporty użytkownika';
    $Self->{Translation}->{'Monthly total'} = 'Łącznie - miesięcznie';
    $Self->{Translation}->{'Lifetime total'} = 'Łącznie - ogółem';
    $Self->{Translation}->{'Overtime leave'} = 'Wolne za godziny nadliczbowe';
    $Self->{Translation}->{'Vacation'} = 'Urlop';
    $Self->{Translation}->{'Sick leave'} = 'Zwolnienie lekarskie';
    $Self->{Translation}->{'Vacation remaining'} = 'Urlop pozostały do wykorzystania';
    $Self->{Translation}->{'Project reports'} = 'Raporty projektu';

    # Template: AgentTimeAccountingReportingProject
    $Self->{Translation}->{'Project report'} = 'Raport projektu';
    $Self->{Translation}->{'Go to reporting overview'} = 'Przejdź do przeglądu raportowania';
    $Self->{Translation}->{'Currently only active users in this project are shown. To change this behavior, please update setting:'} =
        'Aktualnie widoczni są jedynie użytkownicy z tego projektu. Tutaj można to zmienić:';
    $Self->{Translation}->{'Currently all time accounting users are shown. To change this behavior, please update setting:'} =
        'Aktualnie widoczni są wszyscy użytkownicy rozliczający czas pracy. Tutaj można to zmienić:';

    # Template: AgentTimeAccountingSetting
    $Self->{Translation}->{'Edit Time Accounting Project Settings'} = 'Edytuj ustawienia rozliczania czasu pracy w projekcie';
    $Self->{Translation}->{'Add project'} = 'Dodaj projekt';
    $Self->{Translation}->{'Go to settings overview'} = 'Przejdź do opisu ustawień';
    $Self->{Translation}->{'Add Project'} = 'Dodaj projekt';
    $Self->{Translation}->{'Edit Project Settings'} = 'Edytuj ustawienia projektu';
    $Self->{Translation}->{'There is already a project with this name. Please, choose a different one.'} =
        'Inny projekt używa już tej nazwy. Użyj innej nazwy.';
    $Self->{Translation}->{'Edit Time Accounting Settings'} = 'Edytuj ustawienia rozliczania czasu pracy';
    $Self->{Translation}->{'Add task'} = 'Dodaj zadanie';
    $Self->{Translation}->{'New user'} = 'Nowy użytkownik';
    $Self->{Translation}->{'Filter for Projects'} = 'Filtruj projekty';
    $Self->{Translation}->{'Filter for Tasks'} = 'Filtruj zadania';
    $Self->{Translation}->{'Filter for Users'} = 'Filtruj Użytkowników';
    $Self->{Translation}->{'Time periods can not be deleted.'} = 'Cykle czasu nie mogą zostać usunięte.';
    $Self->{Translation}->{'Project List'} = 'Lista projektów';
    $Self->{Translation}->{'Task List'} = 'Lista zadań';
    $Self->{Translation}->{'Add Task'} = 'Dodaj zadanie';
    $Self->{Translation}->{'Edit Task Settings'} = 'Edytuj ustawienia zadania';
    $Self->{Translation}->{'There is already a task with this name. Please, choose a different one.'} =
        'Inne zadanie używa już tej nazwy. Użyj innej nazwy.';
    $Self->{Translation}->{'User List'} = 'Lista Użytkowników';
    $Self->{Translation}->{'New User Settings'} = 'Ustawienia Nowego Użytkownika';
    $Self->{Translation}->{'Edit User Settings'} = 'Edytuj Ustawienia Użytkownika';
    $Self->{Translation}->{'Comments'} = 'Komentarze';
    $Self->{Translation}->{'Show Overtime'} = 'Pokaż godziny nadliczbowe';
    $Self->{Translation}->{'Allow project creation'} = 'Zezwalaj na tworzenie projektów';
    $Self->{Translation}->{'Period Begin'} = 'Początek cyklu';
    $Self->{Translation}->{'Period End'} = 'Koniec cyklu';
    $Self->{Translation}->{'Days of Vacation'} = 'Dni urlopu';
    $Self->{Translation}->{'Hours per Week'} = 'Ilość godzin w tygodniu';
    $Self->{Translation}->{'Authorized Overtime'} = 'Zezwól na godziny nadliczbowe';
    $Self->{Translation}->{'Start Date'} = 'Data rozpoczęcia';
    $Self->{Translation}->{'Please insert a valid date.'} = 'Proszę wprowadzić prawidłową datę.';
    $Self->{Translation}->{'End Date'} = 'Data zakończenia';
    $Self->{Translation}->{'Period end must be after period begin.'} = 'Koniec okresu musi być po jego początku.';
    $Self->{Translation}->{'Leave Days'} = 'Dni opuczone';
    $Self->{Translation}->{'Weekly Hours'} = 'Tygodniowy czas pracy';
    $Self->{Translation}->{'Overtime'} = 'Godziny nadliczbowe';
    $Self->{Translation}->{'No time periods found.'} = 'Nie znaleziono żadnego cyklu.';
    $Self->{Translation}->{'Add time period'} = 'Dodaj cykl';

    # Template: AgentTimeAccountingView
    $Self->{Translation}->{'View Time Record'} = 'Pokaż ewidencję czasu pracy';
    $Self->{Translation}->{'View of '} = 'Widok ';
    $Self->{Translation}->{'No data found for this day.'} = 'Brak danych dotyczących wybranego dnia.';

    # Perl Module: Kernel/Modules/AgentTimeAccountingEdit.pm
    $Self->{Translation}->{'Can\'t insert Working Units!'} = '';
    $Self->{Translation}->{'Last Projects'} = 'Ostatnie projekty';
    $Self->{Translation}->{'Can\'t save settings, because a day has only 24 hours!'} = '';
    $Self->{Translation}->{'Can\'t delete Working Units!'} = '';
    $Self->{Translation}->{'This Date is out of limit, but you haven\'t insert this day yet, so you get one(!) chance to insert'} =
        '';
    $Self->{Translation}->{'Incomplete Working Days'} = 'Niepełne dni pracy';
    $Self->{Translation}->{'Please insert your working hours!'} = 'Proszę wprowadzić swój czas pracy!';
    $Self->{Translation}->{'Successful insert!'} = 'Wprowadanie powiodło się!';
    $Self->{Translation}->{'Error while inserting multiple dates!'} = 'Wystąpił błąd podczas wprowadzania wielu dat jednocześnie!';
    $Self->{Translation}->{'Successfully inserted entries for several dates!'} = 'Pomyślnie wprowadzono wiele dat jednocześnie!';
    $Self->{Translation}->{'Entered date was invalid! Date was changed to today.'} = 'Wprowadzono nieprawidłową datę! Została ona zmieniona na bieżącą.';
    $Self->{Translation}->{'No time period configured, or the specified date is outside of the defined time periods. Please contact the time accounting admin to update your time periods!'} =
        '';
    $Self->{Translation}->{'Last Selected Projects'} = 'Ostatnio wybrane projekty';
    $Self->{Translation}->{'All Projects'} = 'Wszystkie projekty';

    # Perl Module: Kernel/Modules/AgentTimeAccountingReporting.pm
    $Self->{Translation}->{'ReportingProject: Need ProjectID'} = '';
    $Self->{Translation}->{'Reporting Project'} = '';
    $Self->{Translation}->{'Reporting'} = 'Raportowanie';

    # Perl Module: Kernel/Modules/AgentTimeAccountingSetting.pm
    $Self->{Translation}->{'Unable to update user settings!'} = '';
    $Self->{Translation}->{'Please contact your administrator.'} = 'Prosimy, o kontakt z twoim administratorem.';
    $Self->{Translation}->{'Project added!'} = '';
    $Self->{Translation}->{'Project updated!'} = '';
    $Self->{Translation}->{'Task added!'} = '';
    $Self->{Translation}->{'Task updated!'} = '';
    $Self->{Translation}->{'The UserID is not valid!'} = '';
    $Self->{Translation}->{'Can\'t insert user data!'} = '';
    $Self->{Translation}->{'Unable to add time period!'} = '';
    $Self->{Translation}->{'User updated!'} = '';
    $Self->{Translation}->{'User added!'} = '';
    $Self->{Translation}->{'New User'} = 'Nowy Użytkownik';
    $Self->{Translation}->{'Period Status'} = 'Stan cyklu';

    # Perl Module: Kernel/Modules/AgentTimeAccountingView.pm
    $Self->{Translation}->{'View: Need %s!'} = '';

    # Perl Module: Kernel/Output/HTML/ToolBar/IncompleteWorkingDays.pm
    $Self->{Translation}->{'Incomplete working days'} = 'Niepełne dni pracy';

    # SysConfig
    $Self->{Translation}->{'Agent interface notification module to see the number of incomplete working days for the user.'} =
        'Moduł powiadamiania Agenta o liczbie dni z niekompletnym raportowaniem czasu pracy.';
    $Self->{Translation}->{'Default name for new actions.'} = 'Domyślna nazwa nowych czynności.';
    $Self->{Translation}->{'Default name for new projects.'} = 'Domyślna nazwa nowych projektów.';
    $Self->{Translation}->{'Default setting for date end.'} = 'Domyślna data zakończenia.';
    $Self->{Translation}->{'Default setting for date start.'} = 'Domyślna data rozpoczęcia.';
    $Self->{Translation}->{'Default setting for description.'} = 'Domyślne ustawienie opisu.';
    $Self->{Translation}->{'Default setting for leave days.'} = 'Domyślne konfiguracja urlopu.';
    $Self->{Translation}->{'Default setting for overtime.'} = 'Domyślne konfiguracja godzin nadliczbowych.';
    $Self->{Translation}->{'Default setting for the standard weekly hours.'} = 'Domyślna konfiguracja tygodniowego czasu pracy.';
    $Self->{Translation}->{'Default status for new actions.'} = 'Domyślny stan nowych czynności.';
    $Self->{Translation}->{'Default status for new projects.'} = 'Domyślny stan nowych projektów.';
    $Self->{Translation}->{'Default status for new users.'} = 'Domyślny stan nowych użytkowników.';
    $Self->{Translation}->{'Defines the projects for which a remark is required. If the RegExp matches on the project, you have to insert a remark too. The RegExp use the smx parameter.'} =
        'Określa projekty, które wymagają dodawania komentarzy. Jeżeli wyrażenie regularne pasuje do projektu, trzeba dodać komentarz. Wyrażenia regularne korzystają z parametrów serwera makr (SMX).';
    $Self->{Translation}->{'Determines if the statistics module may generate time accounting information.'} =
        'Określa, czy moduł statystyczny może generować informacje o rozliczeniach czasu pracy.';
    $Self->{Translation}->{'Edit time accounting settings.'} = '';
    $Self->{Translation}->{'Edit time record.'} = '';
    $Self->{Translation}->{'For how many days ago you can insert working units.'} = 'Liczba dni wstecz, dla których można rozliczać czas pracy.';
    $Self->{Translation}->{'If enabled, only users that has added working time to the selected project are shown.'} =
        'Jeśli aktywne, widoczni są tylko użytkownicy, którzy rozliczyli czas pracy w wybranym projekcie.';
    $Self->{Translation}->{'If enabled, the dropdown elements in the edit screen are changed to modernized autocompletion fields.'} =
        'Przy włączonej opcji, elementy rozwijane w oknie edycji będą zastąpione polami z automatycznym uzupełnianiem.';
    $Self->{Translation}->{'If enabled, the filter for the previous projects can be used instead two list of projects (last and all ones). It could be used only if TimeAccounting::EnableAutoCompletion is enabled.'} =
        'Przy włączonej opcji, można użyć filtrów, użytych w poprzednich projektach, zamiast stosować dwie listy projektów (ostatniego i wszystkich). Niezbędne jest uruchomienie opcji TimeAccounting::EnableAutoCompletion.';
    $Self->{Translation}->{'If enabled, the filter for the previous projects is active by default if there are the previous projects. It could be used only if EnableAutoCompletion and TimeAccounting::UseFilter are enabled.'} =
        'Jeśli aktywne, filtry użyte w poprzednich projektach są domyślnie aktywne (jeśli takie projekty istnieją). Niezbędne jest uruchomienie opcji EnableAutoCompletion oraz TimeAccounting::UseFilter.';
    $Self->{Translation}->{'If enabled, the user is allowed to enter "on vacation leave", "on sick leave" and "on overtime leave" to multiple dates at once.'} =
        'Jeśli aktywne, użytkownik może ustawić "urlop", "zwolnienie lekarskie" oraz "wolne za nadgodziny" dla wielu dni jednocześnie.';
    $Self->{Translation}->{'Maximum number of working days after which the working units have to be inserted.'} =
        'Maksymalna liczba dni roboczych, w ciągu których należy uzupełnić czas pracy.';
    $Self->{Translation}->{'Maximum number of working days without working units entry after which a warning will be shown.'} =
        'Maksymalna liczba dni roboczych, bez uzupełniania czasu pracy, po których pokazane zostanie ostrzeżenie.';
    $Self->{Translation}->{'Overview.'} = '';
    $Self->{Translation}->{'Project time reporting.'} = '';
    $Self->{Translation}->{'Regular expressions for constraining action list according to selected project. Key contains regular expression for project(s), content contains regular expressions for action(s).'} =
        'Wyrażenia regularne do ograniczenia listy zadań wybranych projektów. Klucz zawiera wyrażenie regularne dla projektu(ów), zawartość określa wyrażenie regularne dla akcji.';
    $Self->{Translation}->{'Regular expressions for constraining project list according to user groups. Key contains regular expression for project(s), content contains comma separated list of groups.'} =
        'Wyrażenia regularne do ograniczenia listy projektów wybranych grup użytkowników. Klucz zawiera wyrażenie regularne dla projektu(ów), zawartość zawiera listę grup rozdzielonych przecinkami.';
    $Self->{Translation}->{'Specifies if working hours can be inserted without start and end times.'} =
        'Określa, czy czas pracy może zostać wprowadzony bez podawania czasu rozpoczęcia oraz zakończenia.';
    $Self->{Translation}->{'This module forces inserts in TimeAccounting.'} = 'Ten moduł wymusza uzupełnianie rozliczeń czasu pracy.';
    $Self->{Translation}->{'This notification module gives a warning if there are too many incomplete working days.'} =
        'Moduł ten ostrzega o zbyt dużej liczbie nierozliczonych dni roboczych.';
    $Self->{Translation}->{'Time accounting edit.'} = 'Edycja rozliczeń czasu pracy.';
    $Self->{Translation}->{'Time accounting overview.'} = 'Opis rozliczania czasu pracy.';
    $Self->{Translation}->{'Time accounting reporting.'} = 'Raportowanie rozliczeń czasu pracy.';
    $Self->{Translation}->{'Time accounting settings.'} = 'Konfiguracja rozliczeń czasu pracy.';
    $Self->{Translation}->{'Time accounting view.'} = 'Przegląd rozliczeń czasu pracy.';
    $Self->{Translation}->{'Time accounting.'} = 'Rozliczanie czasu pracy.';
    $Self->{Translation}->{'To use if some actions reduced the working hours (for example, if only half of the traveling time is paid Key => traveling; Content => 50).'} =
        'Wykorzystywane jeżeli któreś zadania redukują godziny pracy (np. jeśli za czasu dojazdu liczona jest tylko połowa czasy; Klucz => dojazd; Wartość => 50).';

}

1;
