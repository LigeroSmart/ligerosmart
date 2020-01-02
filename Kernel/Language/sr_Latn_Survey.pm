# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::sr_Latn_Survey;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentSurveyAdd
    $Self->{Translation}->{'Create New Survey'} = 'Napravi novu anketu';
    $Self->{Translation}->{'Introduction'} = 'Uvod';
    $Self->{Translation}->{'Survey Introduction'} = 'Uvod u anketu';
    $Self->{Translation}->{'Notification Body'} = 'Sardžaj obaveštenja';
    $Self->{Translation}->{'Ticket Types'} = 'Tipovi tiketa';
    $Self->{Translation}->{'Internal Description'} = 'Interni opis';
    $Self->{Translation}->{'Customer conditions'} = 'Uslovi klijenta';
    $Self->{Translation}->{'Please choose a Customer property to add a condition.'} = 'Molimo izaberite atribut klijenta za dodavanje uslova.';
    $Self->{Translation}->{'Public survey key'} = 'Javni ključ ankete';
    $Self->{Translation}->{'Example survey'} = 'Primer ankete';

    # Template: AgentSurveyEdit
    $Self->{Translation}->{'Edit General Info'} = 'Uredi opšte informacije';

    # Template: AgentSurveyEditQuestions
    $Self->{Translation}->{'Edit Questions'} = 'Uredi pitanja';
    $Self->{Translation}->{'You are here'} = 'Vi ste ovde';
    $Self->{Translation}->{'Survey Questions'} = 'Anketna pitanja';
    $Self->{Translation}->{'Add Question'} = 'Dodaj pitanje';
    $Self->{Translation}->{'Type the question'} = 'Unesi pitanje';
    $Self->{Translation}->{'Answer required'} = 'Obavezan odgovor';
    $Self->{Translation}->{'No questions saved for this survey.'} = 'Za ovu anketu nisu sačuvana pitanja.';
    $Self->{Translation}->{'Question'} = 'Pitanje';
    $Self->{Translation}->{'Answer Required'} = 'Obavezan odgovor';
    $Self->{Translation}->{'When you finish to edit the survey questions just close this screen.'} =
        'Kada završite sa uređivanjem anketnih pitanja samo zatvorite ovaj prozor.';
    $Self->{Translation}->{'Close this window'} = 'Zatvori ovaj prozor';
    $Self->{Translation}->{'Edit Question'} = 'Uredi pitanje';
    $Self->{Translation}->{'go back to questions'} = 'nazad na pitanja';
    $Self->{Translation}->{'Question:'} = 'Pitanje:';
    $Self->{Translation}->{'Possible Answers For'} = 'Mogući odgovori za';
    $Self->{Translation}->{'Add Answer'} = 'Dodaj odgovor';
    $Self->{Translation}->{'No answers saved for this question.'} = 'Za ovo pitanje nisu sačuvani odgovori.';
    $Self->{Translation}->{'This doesn\'t have several answers, a textarea will be displayed.'} =
        'Ovo nema više odgovora, prostor za tekst će biti prikazan.';
    $Self->{Translation}->{'Edit Answer'} = 'Uredi odgovor';
    $Self->{Translation}->{'go back to edit question'} = 'nazad na uređivanje pitanja';
    $Self->{Translation}->{'Answer:'} = 'Odgovor:';

    # Template: AgentSurveyOverviewNavBar
    $Self->{Translation}->{'Survey overview options'} = 'Podešavanja pregleda ankete';
    $Self->{Translation}->{'Searches in the attributes Number, Title, Introduction, Description, NotificationSender, NotificationSubject and NotificationBody, overriding other attributes with the same name.'} =
        'Pretrage u atributima Number, Title, Introduction, Description, NotificationSender, NotificationSubject i NotificationBody, redefiniu druge atribute sa istim imenom.';
    $Self->{Translation}->{'Survey Create Time'} = 'Vreme kreiranja ankete';
    $Self->{Translation}->{'No restriction'} = 'Bez ograničenja';
    $Self->{Translation}->{'Only surveys created between'} = 'Samo ankete kreirane između';
    $Self->{Translation}->{'Max. shown surveys per page'} = 'Maksimum prikazanih anketa po strani';

    # Template: AgentSurveyOverviewSmall
    $Self->{Translation}->{'Notification Sender'} = 'Pošiljaoc obaveštenja';
    $Self->{Translation}->{'Notification Subject'} = 'Predmet obaveštenja';
    $Self->{Translation}->{'Changed By'} = 'Menjao';

    # Template: AgentSurveyStats
    $Self->{Translation}->{'Stats Overview of'} = 'Pregled statistike za';
    $Self->{Translation}->{'Requests Table'} = 'Tabela zahteva';
    $Self->{Translation}->{'Select all requests'} = 'Izaberi sve zahteve';
    $Self->{Translation}->{'Send Time'} = 'Vreme slanja';
    $Self->{Translation}->{'Vote Time'} = 'Vreme glasanja';
    $Self->{Translation}->{'Select this request'} = 'Izaberi ovaj zahtev';
    $Self->{Translation}->{'See Details'} = 'Vidi detalje';
    $Self->{Translation}->{'Delete stats'} = 'Obriši statistike';
    $Self->{Translation}->{'Survey Stat Details'} = 'Detalji statistike ankete';
    $Self->{Translation}->{'go back to stats overview'} = 'idi nazad na pregled statistike';
    $Self->{Translation}->{'Previous vote'} = 'Prethodni glas';
    $Self->{Translation}->{'Next vote'} = 'Sledeći glas';

    # Template: AgentSurveyZoom
    $Self->{Translation}->{'Survey Information'} = 'Informacije o anketi';
    $Self->{Translation}->{'Sent requests'} = 'Poslati zahtevi';
    $Self->{Translation}->{'Received surveys'} = 'Primljene ankete';
    $Self->{Translation}->{'Survey Details'} = 'Detalji ankete';
    $Self->{Translation}->{'Ticket Services'} = 'Usluge za tiket';
    $Self->{Translation}->{'Survey Results Graph'} = 'Grafikon rezultata ankete';
    $Self->{Translation}->{'No stat results.'} = 'Nema statistike rezultata.';

    # Template: PublicSurvey
    $Self->{Translation}->{'Survey'} = 'Anketa';
    $Self->{Translation}->{'Please answer these questions'} = 'Molimo da odgovorite na ova pitanja';
    $Self->{Translation}->{'Show my answers'} = 'Pokaži moje odgovore';
    $Self->{Translation}->{'These are your answers'} = 'Ovo su vaši odgovori';
    $Self->{Translation}->{'Survey Title'} = 'Naslov ankete';

    # Perl Module: Kernel/Modules/AgentSurveyAdd.pm
    $Self->{Translation}->{'Add New Survey'} = 'Dodaj novu anketu';

    # Perl Module: Kernel/Modules/AgentSurveyEdit.pm
    $Self->{Translation}->{'You have no permission for this survey!'} = 'Nemate dozvolu za ovu anketu!';
    $Self->{Translation}->{'No SurveyID is given!'} = 'Nije dat ID Ankete!';
    $Self->{Translation}->{'Survey Edit'} = 'Uredi anketu';

    # Perl Module: Kernel/Modules/AgentSurveyEditQuestions.pm
    $Self->{Translation}->{'You have no permission for this survey or question!'} = 'Nemate dozvolu za ovu anketu ili pitanje!';
    $Self->{Translation}->{'You have no permission for this survey, question or answer!'} = 'Nemate dozvolu za ovu anketu, pitanje ili odgovor!';
    $Self->{Translation}->{'Survey Edit Questions'} = 'Uredi anketna pitanja';
    $Self->{Translation}->{'Yes/No'} = 'Da/Ne';
    $Self->{Translation}->{'Radio (List)'} = 'Dugme (Lista)';
    $Self->{Translation}->{'Checkbox (List)'} = 'Polje za potvrdu (Lista)';
    $Self->{Translation}->{'Net Promoter Score'} = 'Ocena promotera';
    $Self->{Translation}->{'Question Type'} = 'Tip pitanja';
    $Self->{Translation}->{'Complete'} = 'Kompletno';
    $Self->{Translation}->{'Incomplete'} = 'Nekompletno';
    $Self->{Translation}->{'Question Edit'} = 'Uredi pitanje';
    $Self->{Translation}->{'Answer Edit'} = 'Uredi odgovor';

    # Perl Module: Kernel/Modules/AgentSurveyStats.pm
    $Self->{Translation}->{'Stats Overview'} = 'Pregled statistike';
    $Self->{Translation}->{'You have no permission for this survey or stats detail!'} = 'Nemate dozvolu za ovu anketu ili detalje statistike!';
    $Self->{Translation}->{'Stats Detail'} = 'Detalj statistike';

    # Perl Module: Kernel/Modules/AgentSurveyZoom.pm
    $Self->{Translation}->{'Can\'t set new status! No questions defined.'} = 'Ne može se postaviti novi status! Nema definisanih pitanja.';
    $Self->{Translation}->{'Can\'t set new status! Questions incomplete.'} = 'Ne može se postaviti novi status! Pitanja su nepotpuna.';
    $Self->{Translation}->{'Status changed.'} = 'Status promenjen.';
    $Self->{Translation}->{'- No queue selected -'} = '- Nije izabran red -';
    $Self->{Translation}->{'- No ticket type selected -'} = '- Nije izabran tip tiketa -';
    $Self->{Translation}->{'- No ticket service selected -'} = '- Nije izabran servis tiketa -';
    $Self->{Translation}->{'- Change Status -'} = '- Promeni status -';
    $Self->{Translation}->{'Master'} = 'Glavno';
    $Self->{Translation}->{'Invalid'} = 'Nevažeći';
    $Self->{Translation}->{'New Status'} = 'Novi status';
    $Self->{Translation}->{'Survey Description'} = 'Opis ankete';
    $Self->{Translation}->{'answered'} = 'odgovoreno';
    $Self->{Translation}->{'not answered'} = 'nije odgovoreno';

    # Perl Module: Kernel/Modules/PublicSurvey.pm
    $Self->{Translation}->{'Thank you for your feedback.'} = 'Hvala na vašim odgovorima.';
    $Self->{Translation}->{'The survey is finished.'} = 'Anketa je završena.';
    $Self->{Translation}->{'Survey Message!'} = 'Poruka ankete!';
    $Self->{Translation}->{'Module not enabled.'} = 'Modul nije aktiviran.';
    $Self->{Translation}->{'This functionality is not enabled, please contact your administrator.'} =
        'Ova funcionalnost nije omogućena, molimo kontaktirajte vašeg administratora.';
    $Self->{Translation}->{'Survey Error!'} = 'Greška u anketi!';
    $Self->{Translation}->{'Invalid survey key.'} = 'Neispravan ključ ankete.';
    $Self->{Translation}->{'The inserted survey key is invalid, if you followed a link maybe this is obsolete or broken.'} =
        'Uneti ključ ankete je neispravan, ako ste pratili vezu možda je ona nevažeća ili oštećena.';
    $Self->{Translation}->{'Survey Vote'} = 'Glasanje u anketi';
    $Self->{Translation}->{'Survey Vote Data'} = 'Podaci o glasanju u anketi';
    $Self->{Translation}->{'You have already answered the survey.'} = 'Već ste odgovorili na anketu.';

    # Perl Module: Kernel/System/Stats/Dynamic/SurveyList.pm
    $Self->{Translation}->{'Survey List'} = 'Lista anketa';

    # JS File: Survey.Agent.SurveyEditQuestions
    $Self->{Translation}->{'Do you really want to delete this question? ALL associated data will be LOST!'} =
        'Da li zaista želite da obrišete ovo pitanje? SVI povezani podaci će biti IZGUBLJENI!';
    $Self->{Translation}->{'Do you really want to delete this answer?'} = 'Da li zaista želite da izbrišete ovaj odgovor?';

    # SysConfig
    $Self->{Translation}->{'A Survey Module.'} = 'Anketni modul.';
    $Self->{Translation}->{'A module to edit survey questions.'} = 'Modul za uređivanje anketnih pitanja.';
    $Self->{Translation}->{'All parameters for the Survey object in the agent interface.'} =
        'Svi parametri Objekta ankete u interfejsu operatera.';
    $Self->{Translation}->{'Amount of days after sending a survey mail in which no new survey requests are sent to the same customer. Selecting 0 will always send the survey mail.'} =
        'Broj dana posle slanja imejla o anketi za koje istom korisniku neće biti slani novi zahtevi. Ako izaberete 0 imejl o anketi se uvek šalje.';
    $Self->{Translation}->{'Default body for the notification email to customers about new survey.'} =
        'Podrazumevani sadržaj imejla obaveštenja o novoj anketi za korisnike.';
    $Self->{Translation}->{'Default sender for the notification email to customers about new survey.'} =
        'Podrazumevani pošiljaoc imejla obaveštenja o novom istraživanju za korisnike.';
    $Self->{Translation}->{'Default subject for the notification email to customers about new survey.'} =
        'Podrazumevani predmet imejla obaveštenja o novoj anketi za korisnike.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a survey list.'} =
        'Definiše modul pregleda za mali prikaz liste anketa. ';
    $Self->{Translation}->{'Defines groups which have a permission to change survey status. Array is empty by default and agents from all groups can change survey status.'} =
        'Određuje grupe koje imaju dozvolu da menjaju status ankete. Tabela je podrazumevano prazna i operateri iz svih grupa mogu da menjaju status ankete.';
    $Self->{Translation}->{'Defines if survey requests will be only send to real customers.'} =
        'Definiše da li će zahtevi za ankete biti poslati samo pravim klijentima.';
    $Self->{Translation}->{'Defines maximum amount of surveys that get sent to a customer per 30 days. ( 0 means no maximum, all survey requests will be sent).'} =
        'Definiše maksimalni broj anketa koji će biti poslat korisniku tokom 30 dana. (0 znači da nema maksimuma, svi zahtevi će biti poslati).';
    $Self->{Translation}->{'Defines the amount in hours a ticket has to be closed to trigger the sending of a survey, ( 0 means send immediately after close ). Note: delayed survey sending is done by the OTRS Daemon, prior activation of \'Daemon::SchedulerCronTaskManager::Task###SurveyRequestsSend\' setting.'} =
        'Definiše broj sati od zatvaranja tiketa za pokretanje slanja ankete. (0 znači da se šalje odmah po zatvaranju). Napomena: odlaganje slanja ankete obavlja „OTRS ” servis pre aktiviranja „Daemon::SchedulerCronTaskManager::Task###SurveyRequestsSend” postavke.';
    $Self->{Translation}->{'Defines the columns for the dropdown list for building send conditions (0 => inactive, 1 => active).'} =
        'Definiše kolone za listu prilikom pravljenja uslova zahteva (0 => isključeno, 1 => uključeno).';
    $Self->{Translation}->{'Defines the default height for Richtext views for SurveyZoom elements.'} =
        'Definiše podrazumevanu visinu okvira za prikaz teksta  za detaljni prikaz elemenata ankete.';
    $Self->{Translation}->{'Defines the groups (rw) which can delete survey stats.'} = 'Definiše grupe (rw) koje mogu da brišu statistike anketa.';
    $Self->{Translation}->{'Defines the maximum height for Richtext views for SurveyZoom elements.'} =
        'Određuje maksimalnu visinu „Richtext” prikaza teksta  za detaljni prikaz elemenata ankete.';
    $Self->{Translation}->{'Defines the shown columns in the survey overview. This option has no effect on the position of the columns.'} =
        'Definiše prikazane kolone u pregledu ankete. Ova opcije nema uticaj na pozicije kolona.';
    $Self->{Translation}->{'Determines if the statistics module may generate survey lists.'} =
        'Određuje da li modul statistika može generisati liste anketa.';
    $Self->{Translation}->{'Edit survey general information.'} = 'Uredi opšte informacije o anketi.';
    $Self->{Translation}->{'Edit survey questions.'} = 'Uredi anketna pitanja.';
    $Self->{Translation}->{'Enable or disable the ShowVoteData screen in the public interface to show data of a specific survey result when the customer tries to answer a survey the second time.'} =
        'Uključi ili isključi prikaz ekrana za glasanje na javnom interfejsu radi prikaza rezultata pojedine ankete kada korisnik pokuša da odgovori na upitnik po drugi put.';
    $Self->{Translation}->{'Enable or disable the send condition check for the service.'} = 'Uključi ili isključi proveru statusa slanja za uslugu.';
    $Self->{Translation}->{'Enable or disable the send condition check for the ticket type.'} =
        'Uključi ili isključi proveru statusa slanja za tip tiketa.';
    $Self->{Translation}->{'Frontend module registration for survey add in the agent interface.'} =
        'Registracija "Frontend" modula za dodavanje ankete u interfejsu operatera.';
    $Self->{Translation}->{'Frontend module registration for survey edit in the agent interface.'} =
        'Registracija "Frontend" modula za izmene ankete u interfejsu operatera.';
    $Self->{Translation}->{'Frontend module registration for survey stats in the agent interface.'} =
        'Registracija "Frontend" modula za statistiku ankete u interfejsu operatera.';
    $Self->{Translation}->{'Frontend module registration for survey zoom in the agent interface.'} =
        'Registracija "Frontend" modula za detaljni prikaz ankete u interfejsu operatera.';
    $Self->{Translation}->{'Frontend module registration for the PublicSurvey object in the public Survey area.'} =
        'Registracija "Frontend" modula za javne anketne objekte ankete u prostoru javnih anketa.';
    $Self->{Translation}->{'If this regex matches, no customer survey will be sent.'} = 'Ako se ovaj izraz poklapa, anketa neće biti poslata korisniku.';
    $Self->{Translation}->{'Limit.'} = 'Ograničenje.';
    $Self->{Translation}->{'Parameters for the pages (in which the surveys are shown) of the small survey overview.'} =
        'Parametri stranica (na kojima su ankete vidljive) na malom prikazu pregleda anketa.';
    $Self->{Translation}->{'Public Survey.'} = 'Javna anketa.';
    $Self->{Translation}->{'Results older than the configured amount of days will be deleted. Note: delete results done by the OTRS Daemon, prior activation of \'Task###SurveyRequestsDelete\' setting.'} =
        'Rezultati stariji od podešenog broja dana će biti obrisani. Napomena: rezultate briše OTRS sistemski servis, po aktivaciji podešavanja \'Task###SurveyRequestsDelete\'.';
    $Self->{Translation}->{'Shows a link in the menu to edit a survey in its zoom view of the agent interface.'} =
        'U meniju prikazuje vezu za uređivanje ankete u detaljnom prikazu interfejsa operatera.';
    $Self->{Translation}->{'Shows a link in the menu to edit survey questions in its zoom view of the agent interface.'} =
        'U meniju prikazuje vezu za uređivanje anketnih pitanja u detaljnom prikazu interfejsa operatera.';
    $Self->{Translation}->{'Shows a link in the menu to go back in the survey zoom view of the agent interface.'} =
        'U meniju prikazuje vezu za povratak u detaljni prikaz ankete u interfejsu operatera.';
    $Self->{Translation}->{'Shows a link in the menu to zoom into the survey statistics details in its zoom view of the agent interface.'} =
        'U meniju prikazuje vezu za detaljni prikaz statistike ankete u detaljnom prikazu na interfejsu operatera.';
    $Self->{Translation}->{'Stats Details'} = 'Detalji statistike';
    $Self->{Translation}->{'Survey Add Module.'} = 'Modul za dodavanje ankete.';
    $Self->{Translation}->{'Survey Edit Module.'} = 'Modul za uređivanje ankete.';
    $Self->{Translation}->{'Survey Overview "Small" Limit'} = 'Ograničenje pregleda ankete - „malo”';
    $Self->{Translation}->{'Survey Stats Module.'} = 'Modul za statistiku ankete.';
    $Self->{Translation}->{'Survey Zoom Module.'} = 'Modul za detaljni prikaz ankete.';
    $Self->{Translation}->{'Survey limit per page for Survey Overview "Small".'} = 'Ograničenje ankete po strani za pregled malog formata.';
    $Self->{Translation}->{'Surveys will not be sent to the configured email addresses.'} = 'Anketa neće biti poslata na podešenu imejl adresu.';
    $Self->{Translation}->{'The identifier for a survey, e.g. Survey#, MySurvey#. The default is Survey#.'} =
        'Identifikator za anketu, npr. Survey#, MySurvey#. Podrazumevano je Survey#.';
    $Self->{Translation}->{'Ticket event module to send automatically survey email requests to customers if a ticket is closed.'} =
        'Modul događaja na tiketu za automatsko slanje imejla o istraživanju korisnicima ako je tiket zatvoren.';
    $Self->{Translation}->{'Trigger delete results (including vote data and requests).'} = 'Okida brisanje rezultata (uključujući podatke primljenih glasova i poslatih zahteva).';
    $Self->{Translation}->{'Trigger sending delayed survey requests.'} = 'Okidač odloženog slanja zahteva za anketu.';
    $Self->{Translation}->{'Zoom into statistics details.'} = 'Ulaz u detaljni prikaz statistike.';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Do you really want to delete this answer?',
    'Do you really want to delete this question? ALL associated data will be LOST!',
    'Settings',
    'Submit',
    );

}

1;
