# --
# Kernel/Language/hu_Survey.pm - translation file
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::hu_Survey;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAASurvey
    $Self->{Translation}->{'- Change Status -'} = '- Állapot módosítása -';
    $Self->{Translation}->{'Add New Survey'} = 'Új kérdőív hozzáadása';
    $Self->{Translation}->{'Survey Edit'} = 'Kérdőív szerkesztése';
    $Self->{Translation}->{'Survey Edit Questions'} = 'Kérdőív kérdések szerkesztése';
    $Self->{Translation}->{'Question Edit'} = 'Kérdés szerkesztése';
    $Self->{Translation}->{'Answer Edit'} = 'Válasz szerkesztése';
    $Self->{Translation}->{'Can\'t set new status! No questions defined.'} = 'Nem állítható be az új állapot! Nincsenek kérdések meghatározva.';
    $Self->{Translation}->{'Status changed.'} = 'Állapot módosítva.';
    $Self->{Translation}->{'Thank you for your feedback.'} = 'Köszönjük a visszajelzését.';
    $Self->{Translation}->{'The survey is finished.'} = 'A kérdőív befejeződött.';
    $Self->{Translation}->{'Complete'} = 'Kész';
    $Self->{Translation}->{'Incomplete'} = 'Befejezetlen';
    $Self->{Translation}->{'Checkbox (List)'} = 'Jelölőnégyzet (lista)';
    $Self->{Translation}->{'Radio'} = 'Rádió';
    $Self->{Translation}->{'Radio (List)'} = 'Rádió (lista)';
    $Self->{Translation}->{'Stats Overview'} = 'Statisztikák áttekintése';
    $Self->{Translation}->{'Survey Description'} = 'Kérdőív leírása';
    $Self->{Translation}->{'Survey Introduction'} = 'Kérdőív bevezetése';
    $Self->{Translation}->{'Yes/No'} = 'Igen/Nem';
    $Self->{Translation}->{'YesNo'} = 'IgenNem';
    $Self->{Translation}->{'answered'} = 'megválaszolt';
    $Self->{Translation}->{'not answered'} = 'nem megválaszolt';
    $Self->{Translation}->{'Stats Detail'} = 'Statisztikák részlete';
    $Self->{Translation}->{'Stats Details'} = 'Statisztikák részletei';
    $Self->{Translation}->{'You have already answered the survey.'} = 'Már kitöltötte a kérdőívet.';
    $Self->{Translation}->{'Survey#'} = 'Kérdőív#';
    $Self->{Translation}->{'- No queue selected -'} = '- Nincs várólista kijelölve -';
    $Self->{Translation}->{'Master'} = 'Mester';
    $Self->{Translation}->{'New Status'} = 'Új állapot';
    $Self->{Translation}->{'Question Type'} = 'Kérdés típusa';

    # Template: AgentSurveyAdd
    $Self->{Translation}->{'Create New Survey'} = 'Új kérdőív létrehozása';
    $Self->{Translation}->{'Introduction'} = 'Bevezetés';
    $Self->{Translation}->{'Internal Description'} = 'Belső leírás';

    # Template: AgentSurveyEdit
    $Self->{Translation}->{'Edit General Info'} = 'Általános információk szerkesztése';

    # Template: AgentSurveyEditQuestions
    $Self->{Translation}->{'Edit Questions'} = 'Kérdések szerkesztése';
    $Self->{Translation}->{'Add Question'} = 'Kérdés hozzáadása';
    $Self->{Translation}->{'Type the question'} = 'Gépelje be a kérdést';
    $Self->{Translation}->{'Answer required'} = 'Válasz kötelező';
    $Self->{Translation}->{'Survey Questions'} = 'Kérdőív kérdések';
    $Self->{Translation}->{'No questions saved for this survey.'} = 'Nincsenek kérdések elmentve ehhez a kérdőívhez.';
    $Self->{Translation}->{'Question'} = 'Kérdés';
    $Self->{Translation}->{'Answer Required'} = 'Válasz kötelező';
    $Self->{Translation}->{'When you finish to edit the survey questions just close this window.'} =
        'Amikor befejezte a kérdőív kérdéseinek szerkesztését, akkor egyszerűen zárja be ezt az ablakot.';
    $Self->{Translation}->{'Do you really want to delete this question? ALL associated data will be LOST!'} =
        'Valóban törölni szeretné ezt a kérdést? MINDEN kapcsolódó adat el fog VESZNI!';
    $Self->{Translation}->{'Edit Question'} = 'Kérdés szerkesztése';
    $Self->{Translation}->{'go back to questions'} = 'vissza a kérdésekhez';
    $Self->{Translation}->{'Possible Answers For'} = 'Lehetséges válaszok a következőhöz';
    $Self->{Translation}->{'Add Answer'} = 'Válasz hozzáadása';
    $Self->{Translation}->{'No answers saved for this question.'} = 'Nincsenek válaszok elmentve ehhez a kérdéshez.';
    $Self->{Translation}->{'Do you really want to delete this answer?'} = 'Valóban törölni szeretné ezt a választ?';
    $Self->{Translation}->{'This doesn\'t have several answers, a textarea will be displayed.'} =
        'Ennek nincs több válasza, egy szövegdoboz lesz megjelenítve.';
    $Self->{Translation}->{'Go back'} = 'Vissza';
    $Self->{Translation}->{'Edit Answer'} = 'Válasz szerkesztése';
    $Self->{Translation}->{'go back to edit question'} = 'vissza a kérdés szerkesztéséhez';

    # Template: AgentSurveyOverviewNavBar
    $Self->{Translation}->{'Max. shown Surveys per page'} = 'Oldalanként megjelenített legtöbb kérdőív';

    # Template: AgentSurveyOverviewSmall
    $Self->{Translation}->{'Notification Sender'} = 'Értesítés küldője';
    $Self->{Translation}->{'Notification Subject'} = 'Értesítés tárgya';
    $Self->{Translation}->{'Notification Body'} = 'Értesítés törzse';
    $Self->{Translation}->{'Changed By'} = 'Módosította';

    # Template: AgentSurveyStats
    $Self->{Translation}->{'Stats Overview of'} = 'A következő statisztikáinak áttekintése';
    $Self->{Translation}->{'Requests Table'} = 'Kérések táblázat';
    $Self->{Translation}->{'Send Time'} = 'Küldés ideje';
    $Self->{Translation}->{'Vote Time'} = 'Szavazás ideje';
    $Self->{Translation}->{'See Details'} = 'Részletek megtekintése';
    $Self->{Translation}->{'Survey Stat Details'} = 'Kérdőív statisztika részletek';
    $Self->{Translation}->{'go back to stats overview'} = 'vissza a statisztikák áttekintőjéhez';

    # Template: AgentSurveyZoom
    $Self->{Translation}->{'Survey Information'} = 'Kérdőív információk';
    $Self->{Translation}->{'Sent requests'} = 'Elküldött kérések';
    $Self->{Translation}->{'Received surveys'} = 'Beérkezett kérdőívek';
    $Self->{Translation}->{'Survey Details'} = 'Kérdőív részletek';
    $Self->{Translation}->{'Ticket Services'} = 'Jegyszolgáltatások';
    $Self->{Translation}->{'Survey Results Graph'} = 'Kérdőív eredmények grafikonja';
    $Self->{Translation}->{'No stat results.'} = 'Nincsenek statisztika eredmények.';

    # Template: PublicSurvey
    $Self->{Translation}->{'Survey'} = 'Kérdőív';
    $Self->{Translation}->{'Please answer these questions'} = 'Válaszoljon ezekre a kérdésekre';
    $Self->{Translation}->{'Show my answers'} = 'Saját válaszaim megjelenítése';
    $Self->{Translation}->{'These are your answers'} = 'Ezek az Ön válaszai';
    $Self->{Translation}->{'Survey Title'} = 'Kérdőív címe';

    # SysConfig
    $Self->{Translation}->{'A Survey Module.'} = 'Egy kérdőív modul.';
    $Self->{Translation}->{'A module to edit survey questions.'} = 'Egy modul a kérdőív kérdéseinek szerkesztéséhez.';
    $Self->{Translation}->{'All parameters for the Survey object in the agent interface.'} =
        'Az összes paraméter a kérdőív objektumhoz az ügyintézői felületen.';
    $Self->{Translation}->{'Amount of days after sending a survey mail in which no new survey requests are sent to the same customer. Selecting 0 will always send the survey mail.'} =
        'A napok száma egy olyan kérdőív levél kiküldése után, amelyben nincsenek új kérdőív kérések elküldve ugyanannak az ügyfélnek. A 0 választása mindig el fogja küldeni a kérdőív levelet.';
    $Self->{Translation}->{'Default body for the notification email to customers about new survey.'} =
        'Az ügyfeleknek az új kérdőívvel kapcsolatban elküldött értesítő e-mail alapértelmezett törzse.';
    $Self->{Translation}->{'Default sender for the notification email to customers about new survey.'} =
        'Az ügyfeleknek az új kérdőívvel kapcsolatban elküldött értesítő e-mail alapértelmezett küldője.';
    $Self->{Translation}->{'Default subject for the notification email to customers about new survey.'} =
        'Az ügyfeleknek az új kérdőívvel kapcsolatban elküldött értesítő e-mail alapértelmezett tárgya.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a survey list.'} =
        'Egy áttekintő modult határoz meg egy kérdőívlista kis nézetének megjelenítéséhez.';
    $Self->{Translation}->{'Defines maximum amount of surveys that get sent to a customer per 30 days. ( 0 means no maximum, all survey requests will be sent).'} =
        'Meghatározza a kérdőívek legnagyobb mennyiségét, amelyet 30 naponta elküldhetnek egy ügyfélnek (a 0 azt jelenti, hogy nincs maximum, minden kérdőív kérés elküldésre kerül).';
    $Self->{Translation}->{'Defines the amount in hours a ticket has to be closed to trigger the sending of a survey, ( 0 means send immediately after close ).'} =
        'Azt a mennyiséget határozza meg órában, amelyben egy jegyet le kell zárni egy kérdőív küldésének aktiválásához (a 0 azt jelenti, hogy a lezárás után azonnal küldeni kell).';
    $Self->{Translation}->{'Defines the default height for Richtext views for SurveyZoom elements.'} =
        'Meghatározza a Richtext nézetek alapértelmezett magasságát a SurveyZoom elemeknél.';
    $Self->{Translation}->{'Defines the shown columns in the survey overview. This option has no effect on the position of the columns.'} =
        'Meghatározza a megjelenített oszlopokat a kérdőív áttekintőben. Ennek a beállításnak nincs hatása az oszlopok helyzetére.';
    $Self->{Translation}->{'Edit Survey General Information'} = 'Kérdőív általános információinak szerkesztése';
    $Self->{Translation}->{'Edit Survey Questions'} = 'Kérdőív kérdések szerkesztése';
    $Self->{Translation}->{'Enable or disable the ShowVoteData screen in the public interface to show data of a specific survey result when the customer tries to answer a survey the second time.'} =
        'A ShowVoteData képernyő engedélyezése vagy letiltása a nyilvános felületen egy adott kérdőíveredmény adatainak megjelenítéséhez, amikor az ügyfél másodszor próbál meg válaszolni a kérdőívre.';
    $Self->{Translation}->{'Enable or disable the send condition check for the service.'} = 'A küldési feltétel ellenőrzésének engedélyezése vagy letiltása a szolgáltatásnál.';
    $Self->{Translation}->{'Enable or disable the send condition check for the ticket type.'} =
        'A küldési feltétel ellenőrzésének engedélyezése vagy letiltása a jegytípusnál.';
    $Self->{Translation}->{'Frontend module registration for survey add in the agent interface.'} =
        'Előtétprogram modul regisztráció az ügyintézői felületen lévő kérdőív hozzáadásához.';
    $Self->{Translation}->{'Frontend module registration for survey edit in the agent interface.'} =
        'Előtétprogram modul regisztráció az ügyintézői felületen lévő kérdőív szerkesztéséhez.';
    $Self->{Translation}->{'Frontend module registration for survey stats in the agent interface.'} =
        'Előtétprogram modul regisztráció az ügyintézői felületen lévő kérdőív statisztikákhoz.';
    $Self->{Translation}->{'Frontend module registration for survey zoom in the agent interface.'} =
        'Előtétprogram modul regisztráció az ügyintézői felületen lévő kérdőív nagyításához.';
    $Self->{Translation}->{'Frontend module registration for the PublicSurvey object in the public Survey area.'} =
        'Előtétprogram modul regisztráció a PublicSurvey objektumhoz a nyilvános kérdőív területen.';
    $Self->{Translation}->{'If this regex matches, no customer survey will be sent.'} = 'Ha ez a reguláris kifejezés illeszkedik, akkor az ügyfélkérdőív nem kerül kiküldésre.';
    $Self->{Translation}->{'Parameters for the pages (in which the surveys are shown) of the small survey overview.'} =
        'Paraméterek a kis kérdőív áttekintő oldalaihoz (amelyekben a kérdőívek megjelennek).';
    $Self->{Translation}->{'Public Survey.'} = 'Nyilvános kérdőív.';
    $Self->{Translation}->{'Shows a link in the menu to edit a survey in its zoom view of the agent interface.'} =
        'Egy hivatkozást jelenít meg a menüben egy kérdőív szerkesztéséhez az ügyintézői felületen az elem nagyítási nézetében.';
    $Self->{Translation}->{'Shows a link in the menu to edit survey questions in its zoom view of the agent interface.'} =
        'Egy hivatkozást jelenít meg a menüben a kérdőív kérdéseinek szerkesztéséhez az ügyintézői felületen az elem nagyítási nézetében.';
    $Self->{Translation}->{'Shows a link in the menu to go back in the survey zoom view of the agent interface.'} =
        'Egy hivatkozást jelenít meg a menüben az ügyintézői felület kérdőív nagyítási nézetébe való visszatéréshez.';
    $Self->{Translation}->{'Shows a link in the menu to zoom into the survey statistics details in its zoom view of the agent interface.'} =
        'Egy hivatkozást jelenít meg a menüben egy kérdőív statisztika részleteibe való nagyításhoz az ügyintézői felületen az elem nagyítási nézetében.';
    $Self->{Translation}->{'Survey Edit Module.'} = 'Kérdőív szerkesztés modul.';
    $Self->{Translation}->{'Survey Overview "Small" Limit'} = 'Kérdőív áttekintő „kis” korlát';
    $Self->{Translation}->{'Survey Stats Module.'} = 'Kérdőív statisztikák modul.';
    $Self->{Translation}->{'Survey Zoom Module.'} = 'Kérdőív nagyítás modul.';
    $Self->{Translation}->{'Survey limit per page for Survey Overview "Small"'} = 'Oldalankénti kérdőív korlát a „kis” kérdőív áttekintőnél';
    $Self->{Translation}->{'Surveys will not be sent to the configured email addresses.'} = 'A kérdőívek nem kerülnek elküldésre a beállított e-mail címekre.';
    $Self->{Translation}->{'The identifier for a survey, e.g. Survey#, MySurvey#. The default is Survey#.'} =
        'Egy kérdőív azonosítója, például Survey#, MySurvey#. Az alapértelmezett: Survey#.';
    $Self->{Translation}->{'Ticket event module to send automatically survey email requests to customers if a ticket is closed.'} =
        'Jegy esemény modul automatikus kérdőív e-mail kérések küldéséhez az ügyfeleknek, ha egy jegy le van zárva.';
    $Self->{Translation}->{'Zoom Into Statistics Details'} = 'Nagyítás a statisztikák részleteibe';

}

1;
