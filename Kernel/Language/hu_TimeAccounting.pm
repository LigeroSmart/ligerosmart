# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::hu_TimeAccounting;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentTimeAccountingDelete
    $Self->{Translation}->{'Do you really want to delete the Time Accounting of this day?'} =
        'Valóban törölni szeretné ennek a napnak az időelszámolását?';

    # Template: AgentTimeAccountingEdit
    $Self->{Translation}->{'Edit Time Record'} = 'Időfeljegyzés szerkesztése';
    $Self->{Translation}->{'Go to settings'} = 'Ugrás a beállításokhoz';
    $Self->{Translation}->{'Date Navigation'} = 'Dátum navigáció';
    $Self->{Translation}->{'Days without entries'} = 'Bejegyzések nélküli napok';
    $Self->{Translation}->{'Select all days'} = 'Minden nap kijelölése';
    $Self->{Translation}->{'Mass entry'} = 'Tömeges bejegyzés';
    $Self->{Translation}->{'Please choose the reason for your absence for the selected days'} =
        'Válassza ki a távolléte okát a kijelölt napokra';
    $Self->{Translation}->{'On vacation'} = 'Szabadságon';
    $Self->{Translation}->{'On sick leave'} = 'Betegszabadságon';
    $Self->{Translation}->{'On overtime leave'} = 'Csúsztatáson túlóra miatt';
    $Self->{Translation}->{'Required fields are marked with a "*".'} = 'A kötelező mezők „*” jellel vannak megjelölve.';
    $Self->{Translation}->{'You have to fill in start and end time or a time period.'} = 'Ki kell töltenie a kezdő és befejező időt vagy egy időszakot.';
    $Self->{Translation}->{'Project'} = 'Projekt';
    $Self->{Translation}->{'Task'} = 'Feladat';
    $Self->{Translation}->{'Remark'} = 'Észrevétel';
    $Self->{Translation}->{'Please add a remark with more than 8 characters!'} = 'Adjon hozzá egy 8 karakternél hosszabb észrevételt!';
    $Self->{Translation}->{'Negative times are not allowed.'} = 'Negatív időpontok nem engedélyezettek.';
    $Self->{Translation}->{'Repeated hours are not allowed. Start time matches another interval.'} =
        'Az ismétlődő órák nem engedélyezettek. A kezdési idő egy másik időközre illeszkedik.';
    $Self->{Translation}->{'Invalid format! Please enter a time with the format HH:MM.'} = 'Érvénytelen formátum! ÓÓ:PP formátumú időt adjon meg.';
    $Self->{Translation}->{'24:00 is only permitted as end time.'} = 'A 24:00 csak befejezési időként engedélyezett.';
    $Self->{Translation}->{'Invalid time! A day has only 24 hours.'} = 'Érvénytelen időpont! Egy napnak csak 24 órája van.';
    $Self->{Translation}->{'End time must be after start time.'} = 'A befejezési időnek a kezdési idő után kell lennie.';
    $Self->{Translation}->{'Repeated hours are not allowed. End time matches another interval.'} =
        'Az ismétlődő órák nem engedélyezettek. A befejezési idő egy másik időközre illeszkedik.';
    $Self->{Translation}->{'Invalid period! A day has only 24 hours.'} = 'Érvénytelen időszak! Egy napnak csak 24 órája van.';
    $Self->{Translation}->{'A valid period must be greater than zero.'} = 'Egy érvényes időszaknak nagyobbnak kell lennie nullánál.';
    $Self->{Translation}->{'Invalid period! Negative periods are not allowed.'} = 'Érvénytelen időszak! Negatív időszakok nem engedélyezettek.';
    $Self->{Translation}->{'Add one row'} = 'Egy sor hozzáadása';
    $Self->{Translation}->{'You can only select one checkbox element!'} = 'Csak egy jelölőnégyzet elemet választhat ki!';
    $Self->{Translation}->{'Are you sure that you worked while you were on sick leave?'} = 'Biztos benne, hogy dolgozott, mialatt betegszabadságon volt?';
    $Self->{Translation}->{'Are you sure that you worked while you were on vacation?'} = 'Biztos benne, hogy dolgozott, mialatt szabadságon volt?';
    $Self->{Translation}->{'Are you sure that you worked while you were on overtime leave?'} =
        'Biztos benne, hogy dolgozott, mialatt csúsztatott?';
    $Self->{Translation}->{'Are you sure that you worked more than 16 hours?'} = 'Biztos benne, hogy több mint 16 órát dolgozott?';

    # Template: AgentTimeAccountingOverview
    $Self->{Translation}->{'Time reporting monthly overview'} = 'Időjelentés havi áttekintése';
    $Self->{Translation}->{'Overtime (Hours)'} = 'Túlóra (óra)';
    $Self->{Translation}->{'Overtime (this month)'} = 'Túlóra (ez a hónap)';
    $Self->{Translation}->{'Overtime (total)'} = 'Túlóra (összesen)';
    $Self->{Translation}->{'Remaining overtime leave'} = 'Megmaradt csúsztatás';
    $Self->{Translation}->{'Vacation (Days)'} = 'Szabadság (nap)';
    $Self->{Translation}->{'Vacation taken (this month)'} = 'Kivett szabadság (ez a hónap)';
    $Self->{Translation}->{'Vacation taken (total)'} = 'Kivett szabadság (összesen)';
    $Self->{Translation}->{'Remaining vacation'} = 'Megmaradt szabadság';
    $Self->{Translation}->{'Sick Leave (Days)'} = 'Betegszabadság (nap)';
    $Self->{Translation}->{'Sick leave taken (this month)'} = 'Kivett betegszabadság (ez a hónap)';
    $Self->{Translation}->{'Sick leave taken (total)'} = 'Kivett betegszabadság (összesen)';
    $Self->{Translation}->{'Previous month'} = 'Előző hónap';
    $Self->{Translation}->{'Next month'} = 'Következő hónap';
    $Self->{Translation}->{'Weekday'} = 'Hétköznap';
    $Self->{Translation}->{'Working Hours'} = 'Munkaidő';
    $Self->{Translation}->{'Total worked hours'} = 'Ledolgozott órák összesen';
    $Self->{Translation}->{'User\'s project overview'} = 'A felhasználó projektjének áttekintője';
    $Self->{Translation}->{'Hours (monthly)'} = 'Órák (havonta)';
    $Self->{Translation}->{'Hours (Lifetime)'} = 'Órák (élettartam)';
    $Self->{Translation}->{'Grand total'} = 'Mindösszesen';

    # Template: AgentTimeAccountingReporting
    $Self->{Translation}->{'Time reporting'} = 'Időjelentés';
    $Self->{Translation}->{'Month Navigation'} = 'Hónap navigáció';
    $Self->{Translation}->{'Go to date'} = 'Ugrás dátumra';
    $Self->{Translation}->{'User reports'} = 'Felhasználói jelentések';
    $Self->{Translation}->{'Monthly total'} = 'Havi összesítő';
    $Self->{Translation}->{'Lifetime total'} = 'Élettartam összesen';
    $Self->{Translation}->{'Overtime leave'} = 'Csúsztatás';
    $Self->{Translation}->{'Vacation'} = 'Szabadság';
    $Self->{Translation}->{'Sick leave'} = 'Betegszabadság';
    $Self->{Translation}->{'Vacation remaining'} = 'Hátralévő szabadság';
    $Self->{Translation}->{'Project reports'} = 'Projekt jelentések';

    # Template: AgentTimeAccountingReportingProject
    $Self->{Translation}->{'Project report'} = 'Projekt jelentés';
    $Self->{Translation}->{'Go to reporting overview'} = 'Ugrás a jelentés áttekintőhöz';
    $Self->{Translation}->{'Currently only active users in this project are shown. To change this behavior, please update setting:'} =
        'Jelenleg csak az aktív felhasználók vannak megjelenítve ebben a projektben. A működés módosításához frissítse a beállítást:';
    $Self->{Translation}->{'Currently all time accounting users are shown. To change this behavior, please update setting:'} =
        'Jelenleg minden időelszámoló felhasználó meg van jelenítve. A működés módosításához frissítse a beállítást:';

    # Template: AgentTimeAccountingSetting
    $Self->{Translation}->{'Edit Time Accounting Project Settings'} = 'Időelszámolás projektbeállítások szerkesztése';
    $Self->{Translation}->{'Add project'} = 'Projekt hozzáadása';
    $Self->{Translation}->{'Go to settings overview'} = 'Ugrás a beállítások áttekintőhöz';
    $Self->{Translation}->{'Add Project'} = 'Projekt hozzáadása';
    $Self->{Translation}->{'Edit Project Settings'} = 'Projektbeállítások szerkesztése';
    $Self->{Translation}->{'There is already a project with this name. Please, choose a different one.'} =
        'Már létezik egy ilyen nevű projekt. Válasszon egy másik nevet.';
    $Self->{Translation}->{'Edit Time Accounting Settings'} = 'Időelszámolási beállítások szerkesztése';
    $Self->{Translation}->{'Add task'} = 'Feladat hozzáadása';
    $Self->{Translation}->{'Filter for projects, tasks or users'} = 'Szűrő a projektkehez, feladatokhoz vagy felhasználókhoz';
    $Self->{Translation}->{'Time periods can not be deleted.'} = 'Az időszakok nem törölhetők.';
    $Self->{Translation}->{'Project List'} = 'Projektlista';
    $Self->{Translation}->{'Task List'} = 'Feladatlista';
    $Self->{Translation}->{'Add Task'} = 'Feladat hozzáadása';
    $Self->{Translation}->{'Edit Task Settings'} = 'Feladatbeállítások szerkesztése';
    $Self->{Translation}->{'There is already a task with this name. Please, choose a different one.'} =
        'Már létezik egy ilyen nevű feladat. Válasszon egy másik nevet.';
    $Self->{Translation}->{'User List'} = 'Felhasználólista';
    $Self->{Translation}->{'User Settings'} = 'Felhasználói beállítások';
    $Self->{Translation}->{'User is allowed to see overtimes'} = 'A felhasználó megtekintheti a túlórákat';
    $Self->{Translation}->{'Show Overtime'} = 'Túlóra megjelenítése';
    $Self->{Translation}->{'User is allowed to create projects'} = 'A felhasználó létrehozhat projekteket';
    $Self->{Translation}->{'Allow project creation'} = 'Projektlétrehozás engedélyezése';
    $Self->{Translation}->{'User is allowed to skip time accounting'} = 'A felhasználónak lehetősége van kihagyni az időelszámolást';
    $Self->{Translation}->{'Allow time accounting skipping'} = 'Időelszámolás kihagyásának lehetővé tétele';
    $Self->{Translation}->{'If this option is selected, time accounting is effectively optional for the user.'} =
        'Ha ez a lehetőség van kiválasztva, akkor az időelszámolás ténylegesen választható a felhasználónak.';
    $Self->{Translation}->{'There will be no warnings about missing entries and no entry enforcement.'} =
        'Nem lesznek figyelmeztetések a hiányzó bejegyzésekről és nem lesz beírási kényszerítés.';
    $Self->{Translation}->{'Time Spans'} = 'Időtartamok';
    $Self->{Translation}->{'Period Begin'} = 'Időszak kezdete';
    $Self->{Translation}->{'Period End'} = 'Időszak vége';
    $Self->{Translation}->{'Days of Vacation'} = 'Szabadság napjai';
    $Self->{Translation}->{'Hours per Week'} = 'Órák hetente';
    $Self->{Translation}->{'Authorized Overtime'} = 'Jogosult túlóra';
    $Self->{Translation}->{'Start Date'} = 'Kezdési dátum';
    $Self->{Translation}->{'Please insert a valid date.'} = 'Érvényes dátumot illesszen be.';
    $Self->{Translation}->{'End Date'} = 'Befejezési dátum';
    $Self->{Translation}->{'Period end must be after period begin.'} = 'Az időszak végének az időszak kezdete után kell lennie.';
    $Self->{Translation}->{'Leave Days'} = 'Szabadság napjai';
    $Self->{Translation}->{'Weekly Hours'} = 'Heti órák';
    $Self->{Translation}->{'Overtime'} = 'Túlóra';
    $Self->{Translation}->{'No time periods found.'} = 'Nem találhatók időszakok.';
    $Self->{Translation}->{'Add time period'} = 'Időszak hozzáadása';

    # Template: AgentTimeAccountingView
    $Self->{Translation}->{'View Time Record'} = 'Időfeljegyzés megtekintése';
    $Self->{Translation}->{'View of '} = 'A következő megtekintése: ';
    $Self->{Translation}->{'Previous day'} = 'Előző nap';
    $Self->{Translation}->{'Next day'} = 'Következő nap';
    $Self->{Translation}->{'No data found for this day.'} = 'Nem található adat erre a napra.';

    # Perl Module: Kernel/Modules/AgentTimeAccountingEdit.pm
    $Self->{Translation}->{'Can\'t insert Working Units!'} = 'Nem lehet beilleszteni a munkaegységeket!';
    $Self->{Translation}->{'Last Projects'} = 'Legutóbbi projektek';
    $Self->{Translation}->{'Can\'t save settings, because a day has only 24 hours!'} = 'Nem lehet elmenteni a beállításokat, mert egy napnak csak 24 órája van!';
    $Self->{Translation}->{'Can\'t delete Working Units!'} = 'Nem lehet törölni a munkaegységeket!';
    $Self->{Translation}->{'This Date is out of limit, but you haven\'t insert this day yet, so you get one(!) chance to insert'} =
        'Ez a dátum a határon kívül van, de még nem illesztette be ez a napot, így kap még egy(!) esélyt a beillesztésre';
    $Self->{Translation}->{'Incomplete Working Days'} = 'Befejezetlen munkanapok';
    $Self->{Translation}->{'Successful insert!'} = 'Sikeres beillesztés!';
    $Self->{Translation}->{'Error while inserting multiple dates!'} = 'Hiba történt több dátum beillesztése közben!';
    $Self->{Translation}->{'Successfully inserted entries for several dates!'} = 'A bejegyzések sikeresen beillesztve a különböző dátumokhoz!';
    $Self->{Translation}->{'Entered date was invalid! Date was changed to today.'} = 'A megadott dátum érvénytelen volt! A dátum a mai napra lett módosítva.';
    $Self->{Translation}->{'No time period configured, or the specified date is outside of the defined time periods.'} =
        'Nincs időszak beállítva, vagy a megadott dátum a meghatározott időszakokon kívül van.';
    $Self->{Translation}->{'Please contact the time accounting administrator to update your time periods!'} =
        'Vegye fel a kapcsolatot az időelszámolás adminisztrátorával, hogy frissítse az időszakait!';
    $Self->{Translation}->{'Last Selected Projects'} = 'Legutóbb kiválasztott projektek';
    $Self->{Translation}->{'All Projects'} = 'Minden projekt';

    # Perl Module: Kernel/Modules/AgentTimeAccountingReporting.pm
    $Self->{Translation}->{'ReportingProject: Need ProjectID'} = 'Jelentés projekt: projektazonosító szükséges';
    $Self->{Translation}->{'Reporting Project'} = 'Jelentés projekt';
    $Self->{Translation}->{'Reporting'} = 'Jelentés';

    # Perl Module: Kernel/Modules/AgentTimeAccountingSetting.pm
    $Self->{Translation}->{'Unable to update user settings!'} = 'Nem lehet frissíteni a felhasználói beállításokat!';
    $Self->{Translation}->{'Project added!'} = 'Projekt hozzáadva!';
    $Self->{Translation}->{'Project updated!'} = 'Projekt frissítve!';
    $Self->{Translation}->{'Task added!'} = 'Feladat hozzáadva!';
    $Self->{Translation}->{'Task updated!'} = 'Feladat frissítve!';
    $Self->{Translation}->{'The UserID is not valid!'} = 'A felhasználó-azonosító nem érvényes!';
    $Self->{Translation}->{'Can\'t insert user data!'} = 'Nem lehet beilleszteni a felhasználóadatokat!';
    $Self->{Translation}->{'Unable to add time period!'} = 'Nem lehet hozzáadni időszakot!';
    $Self->{Translation}->{'Setting'} = 'Beállítás';
    $Self->{Translation}->{'User updated!'} = 'Felhasználó frissítve!';
    $Self->{Translation}->{'User added!'} = 'Felhasználó hozzáadva!';
    $Self->{Translation}->{'Add a user to time accounting...'} = 'Felhasználó hozzáadása az időelszámoláshoz…';
    $Self->{Translation}->{'New User'} = 'Új felhasználó';
    $Self->{Translation}->{'Period Status'} = 'Időszak állapot';

    # Perl Module: Kernel/Modules/AgentTimeAccountingView.pm
    $Self->{Translation}->{'View: Need %s!'} = 'Nézet: %s szükséges!';

    # Perl Module: Kernel/Output/HTML/Notification/TimeAccounting.pm
    $Self->{Translation}->{'Please insert your working hours!'} = 'Illessze be a munkaidejét!';

    # Perl Module: Kernel/Output/HTML/ToolBar/IncompleteWorkingDays.pm
    $Self->{Translation}->{'Incomplete working days'} = 'Befejezetlen munkanapok';

    # JS File: TimeAccounting.Agent.EditTimeRecords
    $Self->{Translation}->{'Please choose at least one day!'} = 'Legalább egy napot válasszon ki!';
    $Self->{Translation}->{'Mass Entry'} = 'Tömeges bejegyzés';
    $Self->{Translation}->{'Please choose a reason for absence!'} = 'Válassza ki a távollét okát!';

    # JS File: TimeAccounting.Agent
    $Self->{Translation}->{'Delete Time Accounting Entry'} = 'Időelszámolás bejegyzés törlése';
    $Self->{Translation}->{'Confirm insert'} = 'Beillesztés megerősítése';

    # SysConfig
    $Self->{Translation}->{'Agent interface notification module to see the number of incomplete working days for the user.'} =
        'Ügyintézői felület értesítési modul a felhasználó befejezetlen munkanapjai számának megtekintéséhez.';
    $Self->{Translation}->{'Default name for new actions.'} = 'Alapértelmezett név az új műveletekhez.';
    $Self->{Translation}->{'Default name for new projects.'} = 'Alapértelmezett név az új projektekhez.';
    $Self->{Translation}->{'Default setting for date end.'} = 'Alapértelmezett beállítás a befejezési dátumhoz.';
    $Self->{Translation}->{'Default setting for date start.'} = 'Alapértelmezett beállítás a kezdési dátumhoz.';
    $Self->{Translation}->{'Default setting for description.'} = 'Alapértelmezett beállítás a leíráshoz.';
    $Self->{Translation}->{'Default setting for leave days.'} = 'Alapértelmezett beállítás a szabadság napjaihoz.';
    $Self->{Translation}->{'Default setting for overtime.'} = 'Alapértelmezett beállítás a túlórához.';
    $Self->{Translation}->{'Default setting for the standard weekly hours.'} = 'Alapértelmezett beállítás a szabványos heti munkaórákhoz.';
    $Self->{Translation}->{'Default status for new actions.'} = 'Alapértelmezett állapot az új műveletekhez.';
    $Self->{Translation}->{'Default status for new projects.'} = 'Alapértelmezett állapot az új projektekhez.';
    $Self->{Translation}->{'Default status for new users.'} = 'Alapértelmezett állapot az új felhasználókhoz.';
    $Self->{Translation}->{'Defines the projects for which a remark is required. If the RegExp matches on the project, you have to insert a remark too. The RegExp use the smx parameter.'} =
        'Meghatározza azokat a projekteket, amelyekhez észrevétel szükséges. Ha a reguláris kifejezés illeszkedik a projektre, akkor be kell illesztenie egy észrevételt is. A reguláris kifejezés az smx paramétert használja.';
    $Self->{Translation}->{'Determines if the statistics module may generate time accounting information.'} =
        'Meghatározza, hogy a statisztika modul előállíthat-e időelszámolási információkat.';
    $Self->{Translation}->{'Edit time accounting settings.'} = 'Időelszámolás beállításainak szerkesztése.';
    $Self->{Translation}->{'Edit time record.'} = 'Időfeljegyzés szerkesztése.';
    $Self->{Translation}->{'For how many days ago you can insert working units.'} = 'Hány nappal ezelőtthöz illeszthet be munkaegységeket.';
    $Self->{Translation}->{'If enabled, only users that has added working time to the selected project are shown.'} =
        'Ha engedélyezve van, akkor csak azok a felhasználók lesznek megjelenítve, akik munkaidőt adtak hozzá a kijelölt projekthez.';
    $Self->{Translation}->{'If enabled, the dropdown elements in the edit screen are changed to modernized autocompletion fields.'} =
        'Ha engedélyezve van, akkor a szerkesztési képernyőn lévő lenyíló elemek korszerűsített automatikusan kiegészített mezőkre lesznek megváltoztatva.';
    $Self->{Translation}->{'If enabled, the filter for the previous projects can be used instead two list of projects (last and all ones). It could be used only if TimeAccounting::EnableAutoCompletion is enabled.'} =
        'Ha engedélyezve van, akkor az előző projektek szűrője használható a projektek két listája helyett (legutóbbi és összes). Csak akkor használható, ha a TimeAccounting::EnableAutoCompletion engedélyezve van.';
    $Self->{Translation}->{'If enabled, the filter for the previous projects is active by default if there are the previous projects. It could be used only if EnableAutoCompletion and TimeAccounting::UseFilter are enabled.'} =
        'Ha engedélyezve van, akkor az előző projektek szűrője alapértelmezetten be van kapcsolva, ha vannak előző projektek. Csak akkor használható, ha az EnableAutoCompletion és a TimeAccounting::UseFilter engedélyezve van.';
    $Self->{Translation}->{'If enabled, the user is allowed to enter "on vacation leave", "on sick leave" and "on overtime leave" to multiple dates at once.'} =
        'Ha engedélyezve van, akkor a felhasználónak megengedett egyszerre több dátumhoz „szabadságon”, „betegszabadságon” és „csúsztatáson” érték megadása.';
    $Self->{Translation}->{'Maximum number of working days after which the working units have to be inserted.'} =
        'A munkanapok legnagyobb száma, amelyek után a munkaegységeket be kell szúrni.';
    $Self->{Translation}->{'Maximum number of working days without working units entry after which a warning will be shown.'} =
        'A munkaegységek bejegyzés nélküli munkanapok legnagyobb száma, amelyek után egy figyelmeztetés lesz megjelenítve.';
    $Self->{Translation}->{'Overview.'} = 'Áttekintés.';
    $Self->{Translation}->{'Project time reporting.'} = 'Projektidő jelentés.';
    $Self->{Translation}->{'Regular expressions for constraining action list according to selected project. Key contains regular expression for project(s), content contains regular expressions for action(s).'} =
        'Reguláris kifejezések a kijelölt projekt szerinti korlátozó művelet listájához. A kulcs a projektekhez tartalmaz reguláris kifejezést, a tartalom pedig a műveletekhez.';
    $Self->{Translation}->{'Regular expressions for constraining project list according to user groups. Key contains regular expression for project(s), content contains comma separated list of groups.'} =
        'Reguláris kifejezések a felhasználócsoportok szerinti korlátozó projekt listájához. A kulcs a projektekhez tartalmaz reguláris kifejezést, a tartalom pedig csoportok vesszővel elválasztott listáját tartalmazza.';
    $Self->{Translation}->{'Specifies if working hours can be inserted without start and end times.'} =
        'Megadja, hogy a munkaidő beszúrható-e kezdési és befejezési idők nélkül.';
    $Self->{Translation}->{'This module forces inserts in TimeAccounting.'} = 'Ez a modul kikényszeríti a beszúrásokat az időelszámolásban.';
    $Self->{Translation}->{'This notification module gives a warning if there are too many incomplete working days.'} =
        'Ez az értesítési modul egy figyelmeztetést ad, ha túl sok befejezetlen munkanap található.';
    $Self->{Translation}->{'Time Accounting'} = 'Időelszámolás';
    $Self->{Translation}->{'Time accounting edit.'} = 'Időelszámolás szerkesztés.';
    $Self->{Translation}->{'Time accounting overview.'} = 'Időelszámolás áttekintő.';
    $Self->{Translation}->{'Time accounting reporting.'} = 'Időelszámolás jelentés.';
    $Self->{Translation}->{'Time accounting settings.'} = 'Időelszámolás beállítások.';
    $Self->{Translation}->{'Time accounting view.'} = 'Időelszámolás nézet.';
    $Self->{Translation}->{'Time accounting.'} = 'Időelszámolás.';
    $Self->{Translation}->{'To use if some actions reduced the working hours (for example, if only half of the traveling time is paid Key => traveling; Content => 50).'} =
        'Akkor kell használni, ha néhány művelet csökkentette a munkaidőt (például ha csak az utazási idő fele van kifizetve: Kulcs => utazás; Tartalom => 50).';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Cancel',
    'Confirm insert',
    'Delete Time Accounting Entry',
    'Mass Entry',
    'No',
    'Please choose a reason for absence!',
    'Please choose at least one day!',
    'Submit',
    'Yes',
    );

}

1;
