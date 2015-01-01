# --
# Kernel/Language/hu_TimeAccounting.pm - translation file
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::hu_TimeAccounting;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAATimeAccounting
    $Self->{Translation}->{'Time Accounting'} = '';
    $Self->{Translation}->{'Show valid projects'} = '';
    $Self->{Translation}->{'Show all projects'} = '';
    $Self->{Translation}->{'TimeAccounting'} = '';
    $Self->{Translation}->{'Reporting'} = '';
    $Self->{Translation}->{'Please insert your working hours!'} = '';
    $Self->{Translation}->{'Successful insert!'} = '';
    $Self->{Translation}->{'Error while inserting multiple dates!'} = '';
    $Self->{Translation}->{'Successfully inserted entries for several dates!'} = '';
    $Self->{Translation}->{'Entered date was invalid! Date was changed to today.'} = '';

    # Template: AgentTimeAccountingDelete
    $Self->{Translation}->{'Do you really want to delete the Time Accounting of this day?'} =
        'Biztosan törölni akarja a mai nap IdõElszámolását?';

    # Template: AgentTimeAccountingEdit
    $Self->{Translation}->{'Edit Time Record'} = 'Idõ bejegyzés szerkesztése';
    $Self->{Translation}->{'Go to settings'} = '';
    $Self->{Translation}->{'Date Navigation'} = 'Dátum navigáció';
    $Self->{Translation}->{'Previous day'} = 'Elõzõ nap';
    $Self->{Translation}->{'Next day'} = 'Következõ nap';
    $Self->{Translation}->{'Go to this date'} = '';
    $Self->{Translation}->{'Days without entries'} = 'Bejegyzés nélküli napok';
    $Self->{Translation}->{'Select all days'} = '';
    $Self->{Translation}->{'Mass entry'} = '';
    $Self->{Translation}->{'Please choose the reason for your absence for the selected days'} =
        '';
    $Self->{Translation}->{'On vacation'} = 'Szabadságon';
    $Self->{Translation}->{'On sick leave'} = 'Betegszabadságon';
    $Self->{Translation}->{'On overtime leave'} = 'Túlóra letöltése';
    $Self->{Translation}->{'Please choose at least one day!'} = '';
    $Self->{Translation}->{'Please choose a reason for absence!'} = '';
    $Self->{Translation}->{'Mass Entry'} = '';
    $Self->{Translation}->{'Required fields are marked with a "*".'} = 'A "*"-al jelölt mezõk kitöltése kötelezõ.';
    $Self->{Translation}->{'You have to fill in start and end time or a time period.'} = 'Ki kell töltenie a kezdõ és befejezõ idõpontot vagy az idõtartamot.';
    $Self->{Translation}->{'Project'} = 'Projekt';
    $Self->{Translation}->{'Task'} = 'Feladat';
    $Self->{Translation}->{'Remark'} = 'Megjegyzés';
    $Self->{Translation}->{'Please add a remark with more than 8 characters!.'} = 'Kérem adjon meg egy 8 karakternél hosszabb megjegyzést!';
    $Self->{Translation}->{'Start Time'} = '';
    $Self->{Translation}->{'Negative times are not allowed.'} = 'Negatív idõk nem megengedettek.';
    $Self->{Translation}->{'Repeated hours are not allowed. Start time matches another interval.'} =
        'Ismétlõdõ órák megadása nem megengedett. A kezdõ idõpont egyezik egy másik intervalummal.';
    $Self->{Translation}->{'Invalid format! Please enter a time with the format HH:MM.'} = '';
    $Self->{Translation}->{'24:00 is only permitted as end time.'} = '';
    $Self->{Translation}->{'Invalid time! A day has only 24 hours.'} = '';
    $Self->{Translation}->{'End Time'} = '';
    $Self->{Translation}->{'End time must be after start time.'} = 'A befejezõ idõpont késõbbi kell legyen, mint a kezdõ idõpont.';
    $Self->{Translation}->{'Repeated hours are not allowed. End time matches another interval.'} =
        'Ismétlõdõ órák megadása nem lehetséges. A befejezõ idõpont egyezik más idõszakkal.';
    $Self->{Translation}->{'Invalid period! A day has only 24 hours.'} = 'Érvénytelen idõtartam! A nap csak 24 órából áll!';
    $Self->{Translation}->{'A valid period must be greater than zero.'} = 'Az érvényes idõtartamnak nagyobbnak kell lennie nullánál.';
    $Self->{Translation}->{'Invalid period! Negative periods are not allowed.'} = 'Érvénytelen idõtartam! Negatív idõtartam nem megengedett.';
    $Self->{Translation}->{'Add one row'} = 'Sor hozzáadása';
    $Self->{Translation}->{'Total'} = 'Összesen';
    $Self->{Translation}->{'You can only select one checkbox element!'} = 'Csak egy jelölõnégyzetet választhat!';
    $Self->{Translation}->{'Show all items'} = 'Összes bejegyzés megjelenítése';
    $Self->{Translation}->{'Delete Time Accounting Entry'} = 'IdõElszámolás bejegyzés törlése';
    $Self->{Translation}->{'Confirm insert'} = 'Beszúrás jóváhagyása';
    $Self->{Translation}->{'Are you sure that you worked while you were on sick leave?'} = 'Biztosan dolgozott, miközben betegszabadásgon volt?';
    $Self->{Translation}->{'Are you sure that you worked while you were on vacation?'} = 'Biztosan dolgozott, miközben betegszabadásgon volt?';
    $Self->{Translation}->{'Are you sure that you worked while you were on overtime leave?'} =
        'Biztosan dolgozott, miközben túlórát töltött le?';
    $Self->{Translation}->{'Are you sure that you worked more than 16 hours?'} = 'Biztosan többet dolgozott mint 16 óra?';

    # Template: AgentTimeAccountingOverview
    $Self->{Translation}->{'Time reporting monthly overview'} = 'Idõ-kimutatás havi összesítõ';
    $Self->{Translation}->{'Overtime (Hours)'} = 'Túlóra (órák)';
    $Self->{Translation}->{'Overtime (this month)'} = 'Túlóra (ebben a hónapban)';
    $Self->{Translation}->{'Overtime (total)'} = 'Túlóra (összesen)';
    $Self->{Translation}->{'Remaining overtime leave'} = 'Letölthetõ túlóra';
    $Self->{Translation}->{'Vacation (Days)'} = 'Szabadság (nap)';
    $Self->{Translation}->{'Vacation taken (this month)'} = 'Szabadság (ebben a hónapban)';
    $Self->{Translation}->{'Vacation taken (total)'} = 'Szabadság (összesen)';
    $Self->{Translation}->{'Remaining vacation'} = 'Fennmaradó szabadság';
    $Self->{Translation}->{'Sick Leave (Days)'} = 'Betegszabadság (nap)';
    $Self->{Translation}->{'Sick leave taken (this month)'} = 'Betegszabadság (ebben a hónapban)';
    $Self->{Translation}->{'Sick leave taken (total)'} = 'Betegszabadság (összesen)';
    $Self->{Translation}->{'Previous month'} = 'Elõzõ hónap';
    $Self->{Translation}->{'Next month'} = 'Következõ hónap';
    $Self->{Translation}->{'Weekday'} = 'Hétköznap';
    $Self->{Translation}->{'Working Hours'} = 'Munkaidõ';
    $Self->{Translation}->{'Total worked hours'} = 'Összes munkaidõ';
    $Self->{Translation}->{'User\'s project overview'} = 'Felhasználói projekt összefoglaló';
    $Self->{Translation}->{'Hours (monthly)'} = 'Órák (havi)';
    $Self->{Translation}->{'Hours (Lifetime)'} = 'Órák (élettartam)';
    $Self->{Translation}->{'Grand total'} = 'Mindösszesen';

    # Template: AgentTimeAccountingReporting
    $Self->{Translation}->{'Time reporting'} = 'Idõ kimutatás';
    $Self->{Translation}->{'Month Navigation'} = 'Hónap navigáció';
    $Self->{Translation}->{'Go to date'} = '';
    $Self->{Translation}->{'User reports'} = 'Felhasználó kimutatás';
    $Self->{Translation}->{'Monthly total'} = 'Havi összesítõ';
    $Self->{Translation}->{'Lifetime total'} = 'Élettartam összesítõ';
    $Self->{Translation}->{'Overtime leave'} = 'Túlóra letöltés';
    $Self->{Translation}->{'Vacation'} = 'Szabadság';
    $Self->{Translation}->{'Sick leave'} = 'Betegszabadság';
    $Self->{Translation}->{'Vacation remaining'} = 'Hátralévõ távollét';
    $Self->{Translation}->{'Project reports'} = 'Projekt kimutatások';

    # Template: AgentTimeAccountingReportingProject
    $Self->{Translation}->{'Project report'} = 'Projekt kuimutatás';
    $Self->{Translation}->{'Go to reporting overview'} = '';
    $Self->{Translation}->{'Currently only active users in this project are shown. To change this behavior, please update setting:'} =
        '';
    $Self->{Translation}->{'Currently all time accounting users are shown. To change this behavior, please update setting:'} =
        '';

    # Template: AgentTimeAccountingSetting
    $Self->{Translation}->{'Edit Time Accounting Project Settings'} = 'IdõElszámolás Projekt Beállítások';
    $Self->{Translation}->{'Add project'} = 'Új projekt';
    $Self->{Translation}->{'Go to settings overview'} = '';
    $Self->{Translation}->{'Add Project'} = 'Új Projekt';
    $Self->{Translation}->{'Edit Project Settings'} = 'Projekt Beállítások Szerkesztése';
    $Self->{Translation}->{'There is already a project with this name. Please, choose a different one.'} =
        'Már van ilyen nevû projekt, válasszon más nevet.';
    $Self->{Translation}->{'Edit Time Accounting Settings'} = 'IdõElszámolás Beállítások Szerkesztése';
    $Self->{Translation}->{'Add task'} = 'Új feladat';
    $Self->{Translation}->{'New user'} = 'Új felhasználó';
    $Self->{Translation}->{'Filter for Projects'} = 'Projektek Szûrése';
    $Self->{Translation}->{'Filter for Tasks'} = 'Feladatok Szûrése';
    $Self->{Translation}->{'Filter for Users'} = 'Felhasználók Szûrése';
    $Self->{Translation}->{'Project List'} = 'Projekt Lista';
    $Self->{Translation}->{'Task List'} = 'Feladat Lista';
    $Self->{Translation}->{'Add Task'} = 'Új Feladat';
    $Self->{Translation}->{'Edit Task Settings'} = 'Feladat Beállítások Szerkesztése';
    $Self->{Translation}->{'There is already a task with this name. Please, choose a different one.'} =
        'Már van ilyen nevû feladat, válasszon más nevet.';
    $Self->{Translation}->{'User List'} = 'Felhasználó Lista';
    $Self->{Translation}->{'New User Settings'} = 'Új Felhasználó Beállításai';
    $Self->{Translation}->{'Edit User Settings'} = 'Felhasználói Beállítások Szerkesztése';
    $Self->{Translation}->{'Comments'} = 'Megjegyzések';
    $Self->{Translation}->{'Show Overtime'} = 'Mutassa a Túlórát';
    $Self->{Translation}->{'Allow project creation'} = 'Projekt létrehozásának engedélyezése';
    $Self->{Translation}->{'Period Begin'} = 'Idõszak Kezdete';
    $Self->{Translation}->{'Period End'} = 'Idõszak Vége';
    $Self->{Translation}->{'Days of Vacation'} = 'Szabadnapok';
    $Self->{Translation}->{'Hours per Week'} = 'Órák hetente';
    $Self->{Translation}->{'Authorized Overtime'} = 'Jóváhagyott Túlóra';
    $Self->{Translation}->{'Start Date'} = '';
    $Self->{Translation}->{'Please insert a valid date.'} = '';
    $Self->{Translation}->{'End Date'} = '';
    $Self->{Translation}->{'Period end must be after period begin.'} = 'Az idõszak végének a kezdete után kell lennie.';
    $Self->{Translation}->{'Leave Days'} = '';
    $Self->{Translation}->{'Weekly Hours'} = '';
    $Self->{Translation}->{'Overtime'} = '';
    $Self->{Translation}->{'No time periods found.'} = 'Idõszak nem található.';
    $Self->{Translation}->{'Add time period'} = 'Idõszak hozzáadása';

    # Template: AgentTimeAccountingView
    $Self->{Translation}->{'View Time Record'} = 'Idõ Bejegyzés megtekintése';
    $Self->{Translation}->{'View of '} = 'Megtekintés ';
    $Self->{Translation}->{'No data found for this day.'} = 'Nincs adat ehhez a naphoz.';

    # SysConfig
    $Self->{Translation}->{'Agent interface notification module to see the number of incomplete working days for the user.'} =
        'Ügyintézõ interface figyelmeztetõ modul a kitöltetlen munkanapok megjelenítéséhez.';
    $Self->{Translation}->{'Default name for new actions.'} = 'Az új akciók alapértelmezett neve.';
    $Self->{Translation}->{'Default name for new projects.'} = 'Az új projektek alapértelmezett neve.';
    $Self->{Translation}->{'Default setting for date end.'} = 'Alapbeállítás a dátum végéhez.';
    $Self->{Translation}->{'Default setting for date start.'} = 'Alapbeállítás a dátum kezdetéhez.';
    $Self->{Translation}->{'Default setting for description.'} = '';
    $Self->{Translation}->{'Default setting for leave days.'} = 'Alapbeállítás a távollét napjaihoz.';
    $Self->{Translation}->{'Default setting for overtime.'} = 'Alapbeállítás a túlórához.';
    $Self->{Translation}->{'Default setting for the standard weekly hours.'} = 'Alapbeállítás a normál heti órákhoz.';
    $Self->{Translation}->{'Default status for new actions.'} = 'Az új akciók alapértelmezett státusza.';
    $Self->{Translation}->{'Default status for new projects.'} = 'Az új projektek alapértelmezett státusza.';
    $Self->{Translation}->{'Default status for new users.'} = 'Az új felhasználók alapértelmezett státusza.';
    $Self->{Translation}->{'Defines the projects for which a remark is required. If the RegExp matches on the project, you have to insert a remark too. The RegExp use the smx parameter.'} =
        'Adja meg a projekteket, amelyekhez kötelezõ a megjegyzés. Ha a RegExp kifejezés illeszkedik egy projektre, meg kell adnia megjegyzést. A RegExp az smx paramétert használja.';
    $Self->{Translation}->{'Determines if the statistics module may generate time accounting information.'} =
        'Meghatározza, ha a statisztika modul generálhat IdõElszámolás információkat.';
    $Self->{Translation}->{'Edit time accounting settings'} = 'IdõElszámolás beállítások szerkesztése';
    $Self->{Translation}->{'Edit time record'} = 'Idõ bejegyzés szerkesztése';
    $Self->{Translation}->{'For how many days ago you can insert working units.'} = 'Hány napra visszamenõleg tudja megadni a munkaidõt.';
    $Self->{Translation}->{'If enabled, only users that has added working time to the selected project are shown.'} =
        '';
    $Self->{Translation}->{'If enabled, the dropdown elements in the edit screen are changed to autocompletion fields.'} =
        'Ha engedélyezett, a legördülõ elemek helyett automatikus kiegészítés lesz a mezõknél.';
    $Self->{Translation}->{'If enabled, the user is allowed to enter "on vacation leave", "on sick leave" and "on overtime leave" to multiple dates at once.'} =
        '';
    $Self->{Translation}->{'Maximum number of working days after which the working units have to be inserted.'} =
        'Maximum hány nap után kötelezõ megadni a munkaidõt.';
    $Self->{Translation}->{'Maximum number of working days without working units entry after which a warning will be shown.'} =
        '';
    $Self->{Translation}->{'Project time reporting'} = 'Projekt idõ kimutatás';
    $Self->{Translation}->{'Regular expressions for constraining action list according to selected project. Key contains regular expression for project(s), content contains regular expressions for action(s).'} =
        'Reguláris kifejezés a projekthez megfelelõ akciók listájának szükítéséhez. A kulcs reguláris kifejezést tartalmaz a projektekhez, a tartalom reguláris kifejezést tartalmaz az akciókhoz.';
    $Self->{Translation}->{'Regular expressions for constraining project list according to user groups. Key contains regular expression for project(s), content contains comma separated list of groups.'} =
        'Reguláris kifejezés a felhasználók csoportjának megfelelõ projektek listájának szükítéséhez. A kulcs reguláris kifejezést tartalmaz a projektekhez, a tartalom reguláris kifejezést tartalmaz a csoportok listájához.';
    $Self->{Translation}->{'Specifies if working hours can be inserted without start and end times.'} =
        'Adja meg, ha a munkaidõ megadható kezdõ és befejezõ idõpont nélkül.';
    $Self->{Translation}->{'This module forces inserts in TimeAccounting.'} = 'Ez a modul kényszeríti az IdõElszámolás beszúrását..';
    $Self->{Translation}->{'This notification module gives a warning if there are too many incomplete working days.'} =
        'Ez a figyelmeztetõ modul jelzi, ha túl sok kitöltetlen munkanap van.';
    $Self->{Translation}->{'Time accounting edit.'} = '';
    $Self->{Translation}->{'Time accounting overview.'} = '';
    $Self->{Translation}->{'Time accounting reporting.'} = '';
    $Self->{Translation}->{'Time accounting settings.'} = '';
    $Self->{Translation}->{'Time accounting view.'} = '';
    $Self->{Translation}->{'Time accounting.'} = 'IdõElszámolás.';
    $Self->{Translation}->{'To use if some actions reduced the working hours (for example, if only half of the traveling time is paid Key => traveling; Content => 50).'} =
        'Használja, ha valamelyik akció csökkenti a munkaórákat (például ha csak az utazás fele kerül kifizetésre, Kulcs => Utazás; Tartalom =>50).';

}

1;
