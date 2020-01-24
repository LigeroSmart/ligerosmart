# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::it_TimeAccounting;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentTimeAccountingDelete
    $Self->{Translation}->{'Do you really want to delete the Time Accounting of this day?'} =
        'Vuoi veramente cancellare la rendicontazione temporale di oggi ?';

    # Template: AgentTimeAccountingEdit
    $Self->{Translation}->{'Edit Time Record'} = 'Modifica la rendicontazione';
    $Self->{Translation}->{'Go to settings'} = 'Vai alle impostazioni';
    $Self->{Translation}->{'Date Navigation'} = 'Navigazione per data';
    $Self->{Translation}->{'Days without entries'} = 'Giorni senza informazioni';
    $Self->{Translation}->{'Select all days'} = 'Seleziona tutti i giorni';
    $Self->{Translation}->{'Mass entry'} = 'Inserimento massivo';
    $Self->{Translation}->{'Please choose the reason for your absence for the selected days'} =
        'Per favore seleziona il motivo della tua assenza per i giorni selezionati.';
    $Self->{Translation}->{'On vacation'} = 'Ferie';
    $Self->{Translation}->{'On sick leave'} = 'Assente per malattia';
    $Self->{Translation}->{'On overtime leave'} = 'Assente per recupero';
    $Self->{Translation}->{'Required fields are marked with a "*".'} = 'I campi obbligatori sono indicati con "*".';
    $Self->{Translation}->{'You have to fill in start and end time or a time period.'} = 'E\' obbligatorio inserire inizio e fine oppure un periodo.';
    $Self->{Translation}->{'Project'} = 'Progetto';
    $Self->{Translation}->{'Task'} = 'Compito';
    $Self->{Translation}->{'Remark'} = 'Commento';
    $Self->{Translation}->{'Please add a remark with more than 8 characters!'} = 'Aggiungere un commento con più di 8 caratteri!';
    $Self->{Translation}->{'Negative times are not allowed.'} = 'Non possono essere inseriti valori negativi.';
    $Self->{Translation}->{'Repeated hours are not allowed. Start time matches another interval.'} =
        'Non è permesso inserire ore ripetute. L\'orario di inizio coincide con un altro intervallo.';
    $Self->{Translation}->{'Invalid format! Please enter a time with the format HH:MM.'} = 'Formato non valido. Inserire un orario nel formato HH:MM.';
    $Self->{Translation}->{'24:00 is only permitted as end time.'} = 'L\'ora 24:00 è consentita solo come ora di fine.';
    $Self->{Translation}->{'Invalid time! A day has only 24 hours.'} = 'Orario non valido! In un giorno ci sono solo 24 ore.';
    $Self->{Translation}->{'End time must be after start time.'} = 'L\'orario di fine è posteriore all\'orario di inizio.';
    $Self->{Translation}->{'Repeated hours are not allowed. End time matches another interval.'} =
        'Non è permesso inserire ore ripetute. L\'orario di fine coincide con un altro intervallo.';
    $Self->{Translation}->{'Invalid period! A day has only 24 hours.'} = 'Periodo non valido. Una giornata ha solo 24 ore.';
    $Self->{Translation}->{'A valid period must be greater than zero.'} = 'Un periodo valido deve essere maggiore di zero.';
    $Self->{Translation}->{'Invalid period! Negative periods are not allowed.'} = 'Periodo non valido. Valori negativi non ammessi.';
    $Self->{Translation}->{'Add one row'} = 'Aggiungere una riga';
    $Self->{Translation}->{'You can only select one checkbox element!'} = 'Puoi selezionare solo un elemento!';
    $Self->{Translation}->{'Are you sure that you worked while you were on sick leave?'} = 'Sei sicuro di aver lavorato mentre eri assente per malattia?';
    $Self->{Translation}->{'Are you sure that you worked while you were on vacation?'} = 'Sei sicuro di aver lavorato mentre eri in ferie?';
    $Self->{Translation}->{'Are you sure that you worked while you were on overtime leave?'} =
        'Sei sicuro di aver lavorato mentre eri assente per recupero ?';
    $Self->{Translation}->{'Are you sure that you worked more than 16 hours?'} = 'Sei sicuro di aver lavorato più di 16 ore?';

    # Template: AgentTimeAccountingOverview
    $Self->{Translation}->{'Time reporting monthly overview'} = 'Cruscotto mensile di rendicontazione temporale';
    $Self->{Translation}->{'Overtime (Hours)'} = 'Straordinario (ore)';
    $Self->{Translation}->{'Overtime (this month)'} = 'Straordinario (questo mese)';
    $Self->{Translation}->{'Overtime (total)'} = 'Straordinario (totale)';
    $Self->{Translation}->{'Remaining overtime leave'} = 'Totale ore di recupero disponibili';
    $Self->{Translation}->{'Vacation (Days)'} = 'Ferie (giorni)';
    $Self->{Translation}->{'Vacation taken (this month)'} = 'Ferie utilizzate (questo mese)';
    $Self->{Translation}->{'Vacation taken (total)'} = 'Ferie utilizzate (totale)';
    $Self->{Translation}->{'Remaining vacation'} = 'Ferie residue';
    $Self->{Translation}->{'Sick Leave (Days)'} = 'Assenze per malattia (giorni)';
    $Self->{Translation}->{'Sick leave taken (this month)'} = 'Assenze per malattia utilizzate (questo mese)';
    $Self->{Translation}->{'Sick leave taken (total)'} = 'Assenze per malattia (totale)';
    $Self->{Translation}->{'Previous month'} = 'Mese precedente';
    $Self->{Translation}->{'Next month'} = 'Mese seguente';
    $Self->{Translation}->{'Weekday'} = 'Giorno della settimana';
    $Self->{Translation}->{'Working Hours'} = 'Ore lavorative';
    $Self->{Translation}->{'Total worked hours'} = 'Totale ore lavorate';
    $Self->{Translation}->{'User\'s project overview'} = 'Visualizzazione del progetto - Utente';
    $Self->{Translation}->{'Hours (monthly)'} = 'Ore (mensili)';
    $Self->{Translation}->{'Hours (Lifetime)'} = 'Ore (globali)';
    $Self->{Translation}->{'Grand total'} = 'Totale omnicomprensivo';

    # Template: AgentTimeAccountingReporting
    $Self->{Translation}->{'Time reporting'} = 'Report del tempo';
    $Self->{Translation}->{'Month Navigation'} = 'Navigazione per mese';
    $Self->{Translation}->{'Go to date'} = 'Vai alla data';
    $Self->{Translation}->{'User reports'} = 'Report utente';
    $Self->{Translation}->{'Monthly total'} = 'Totale mensile';
    $Self->{Translation}->{'Lifetime total'} = 'Totale gLobale';
    $Self->{Translation}->{'Overtime leave'} = 'Assenze per recupero';
    $Self->{Translation}->{'Vacation'} = 'Ferie';
    $Self->{Translation}->{'Sick leave'} = 'Malattia';
    $Self->{Translation}->{'Vacation remaining'} = 'Giorni rimanenti';
    $Self->{Translation}->{'Project reports'} = 'Riassunti progetto';

    # Template: AgentTimeAccountingReportingProject
    $Self->{Translation}->{'Project report'} = 'Riassunto progetto';
    $Self->{Translation}->{'Go to reporting overview'} = 'Vai al riepilogo di reportistica';
    $Self->{Translation}->{'Currently only active users in this project are shown. To change this behavior, please update setting:'} =
        'Vengono mostrati solo gli utenti attivi di questo progetto. Per cambiare questo comportaento aggiornare il parametro: ';
    $Self->{Translation}->{'Currently all time accounting users are shown. To change this behavior, please update setting:'} =
        'Vengono mostrati tutti gli utenti per la rendicontazione tempo. Per cambiare questo comportamento aggiornare il parametro:';

    # Template: AgentTimeAccountingSetting
    $Self->{Translation}->{'Edit Time Accounting Project Settings'} = 'Modificare le configurazioni di gestione del tempo del progetto.';
    $Self->{Translation}->{'Add project'} = 'Aggiungere progetto';
    $Self->{Translation}->{'Go to settings overview'} = 'Vai al riepilogo impostazioni';
    $Self->{Translation}->{'Add Project'} = 'Aggiungere progetto';
    $Self->{Translation}->{'Edit Project Settings'} = 'Modificare la configurazione del progetto';
    $Self->{Translation}->{'There is already a project with this name. Please, choose a different one.'} =
        'Esiste già un progetto con questo nome. Scegleire un nome diverso.';
    $Self->{Translation}->{'Edit Time Accounting Settings'} = 'Modificare le configurazioni della rendicontazione';
    $Self->{Translation}->{'Add task'} = 'Aggiungere compito';
    $Self->{Translation}->{'Filter for projects, tasks or users'} = 'Filtro per progetti, attività o utenti';
    $Self->{Translation}->{'Time periods can not be deleted.'} = 'I periodi di tempo non possono essere eliminati.';
    $Self->{Translation}->{'Project List'} = 'Elenco dei progetti';
    $Self->{Translation}->{'Task List'} = 'Elenco dei compiti';
    $Self->{Translation}->{'Add Task'} = 'Aggiungere compito';
    $Self->{Translation}->{'Edit Task Settings'} = 'Modificare la configurazione dei compiti';
    $Self->{Translation}->{'There is already a task with this name. Please, choose a different one.'} =
        'Esiste già un task con questo nome. Scegliere un nome diverso.';
    $Self->{Translation}->{'User List'} = 'Elenco utenti';
    $Self->{Translation}->{'User Settings'} = 'Impostazioni utente';
    $Self->{Translation}->{'User is allowed to see overtimes'} = 'L\'Utente può vedere lo straordinario';
    $Self->{Translation}->{'Show Overtime'} = 'Mostrare straordinari';
    $Self->{Translation}->{'User is allowed to create projects'} = 'L\'Utente può creare progetti';
    $Self->{Translation}->{'Allow project creation'} = 'Consentire la creazione del progetto';
    $Self->{Translation}->{'User is allowed to skip time accounting'} = 'L\'utente è autorizzato a saltare la contabilità del tempo';
    $Self->{Translation}->{'Allow time accounting skipping'} = 'Consenti il ​​salto della contabilità del tempo';
    $Self->{Translation}->{'If this option is selected, time accounting is effectively optional for the user.'} =
        'Se questa opzione è selezionata, la contabilità temporale è effettivamente facoltativa per l\'utente.';
    $Self->{Translation}->{'There will be no warnings about missing entries and no entry enforcement.'} =
        'Non ci saranno avvisi in merito a voci mancanti e nessuna applicazione di accesso.';
    $Self->{Translation}->{'Time Spans'} = 'Intervalli di tempo';
    $Self->{Translation}->{'Period Begin'} = 'Periodo di inizio';
    $Self->{Translation}->{'Period End'} = 'Periodo di termine';
    $Self->{Translation}->{'Days of Vacation'} = 'Giorni di Assenza';
    $Self->{Translation}->{'Hours per Week'} = 'Ore alla settimana';
    $Self->{Translation}->{'Authorized Overtime'} = 'Straordinari autorizzati';
    $Self->{Translation}->{'Start Date'} = 'Data di inizio';
    $Self->{Translation}->{'Please insert a valid date.'} = 'Inserire una data valida.';
    $Self->{Translation}->{'End Date'} = 'Data Fine';
    $Self->{Translation}->{'Period end must be after period begin.'} = 'Il periodo finale deve essere posteriore al periodo iniziale.';
    $Self->{Translation}->{'Leave Days'} = 'Giorni di assenza';
    $Self->{Translation}->{'Weekly Hours'} = 'Orari della Settimana';
    $Self->{Translation}->{'Overtime'} = 'Straordinario';
    $Self->{Translation}->{'No time periods found.'} = 'Non ci sono periodi.';
    $Self->{Translation}->{'Add time period'} = 'Aggiungi periodo';

    # Template: AgentTimeAccountingView
    $Self->{Translation}->{'View Time Record'} = 'Visualizzare registro orario';
    $Self->{Translation}->{'View of '} = 'Visualizzazione di  ';
    $Self->{Translation}->{'Previous day'} = 'Giorno precedente';
    $Self->{Translation}->{'Next day'} = 'Giorno successivo';
    $Self->{Translation}->{'No data found for this day.'} = 'Nessun dato trovato per questo giorno.';

    # Perl Module: Kernel/Modules/AgentTimeAccountingEdit.pm
    $Self->{Translation}->{'Can\'t insert Working Units!'} = 'Non puoi inserire le unità lavorative!';
    $Self->{Translation}->{'Last Projects'} = 'Ultimi progetti';
    $Self->{Translation}->{'Can\'t save settings, because a day has only 24 hours!'} = 'Non puoi salvare le impostazioni, perchè un giorno ha solo 24 ore!';
    $Self->{Translation}->{'Can\'t delete Working Units!'} = 'Non puoi cancellare le unità lavorative!';
    $Self->{Translation}->{'This Date is out of limit, but you haven\'t insert this day yet, so you get one(!) chance to insert'} =
        'Questa Data è fuori limite massimo, ma non hai ancora ancora inserito questo giorno, quindi hai ancora una (!) possibilità di inserirne uno.';
    $Self->{Translation}->{'Incomplete Working Days'} = 'Giorni lavorativi incompleti';
    $Self->{Translation}->{'Successful insert!'} = 'Inserimento avvenuto con successo!';
    $Self->{Translation}->{'Error while inserting multiple dates!'} = 'Si è verificato un errore nell\'inserimento di date multiple!';
    $Self->{Translation}->{'Successfully inserted entries for several dates!'} = 'Inserimento di date multiple avvenuto con successo!';
    $Self->{Translation}->{'Entered date was invalid! Date was changed to today.'} = 'La data inserita non è valida! E\' stata impostata la data di oggi.';
    $Self->{Translation}->{'No time period configured, or the specified date is outside of the defined time periods.'} =
        'Nessun periodo di tempo configurato, o la data specificata è fuori dai periodi di tempo definiti.';
    $Self->{Translation}->{'Please contact the time accounting administrator to update your time periods!'} =
        'Per favore, contattare l\'amministrazione della contabilizzazione temporale per aggiornare i tuoi intervalli di tempo!';
    $Self->{Translation}->{'Last Selected Projects'} = 'Ultimi progetti selezionati';
    $Self->{Translation}->{'All Projects'} = 'Tutti i progetti';

    # Perl Module: Kernel/Modules/AgentTimeAccountingReporting.pm
    $Self->{Translation}->{'ReportingProject: Need ProjectID'} = 'RapportoProgetto: ProjectID necessario';
    $Self->{Translation}->{'Reporting Project'} = 'Compilando il rapporto del progetto';
    $Self->{Translation}->{'Reporting'} = 'Reportistica';

    # Perl Module: Kernel/Modules/AgentTimeAccountingSetting.pm
    $Self->{Translation}->{'Unable to update user settings!'} = 'Impossibile aggiornare le impostazioni utente!';
    $Self->{Translation}->{'Project added!'} = 'Progetto aggiunto!';
    $Self->{Translation}->{'Project updated!'} = 'Progetto aggiornato!';
    $Self->{Translation}->{'Task added!'} = 'Attività aggiunta!';
    $Self->{Translation}->{'Task updated!'} = 'Attività aggiornata!';
    $Self->{Translation}->{'The UserID is not valid!'} = 'Lo UserID non è valido!';
    $Self->{Translation}->{'Can\'t insert user data!'} = 'Non puoi inserire i dati dell\'utente!';
    $Self->{Translation}->{'Unable to add time period!'} = 'Non sei abilitato ad inserire i periodi di tempo!';
    $Self->{Translation}->{'Setting'} = 'Impostazione';
    $Self->{Translation}->{'User updated!'} = 'Utente aggiornato!';
    $Self->{Translation}->{'User added!'} = 'Utente inserito!';
    $Self->{Translation}->{'Add a user to time accounting...'} = 'Aggiungi un utente per la contabilizzazione temporale';
    $Self->{Translation}->{'New User'} = 'Nuovo utente';
    $Self->{Translation}->{'Period Status'} = 'Stato di periodo';

    # Perl Module: Kernel/Modules/AgentTimeAccountingView.pm
    $Self->{Translation}->{'View: Need %s!'} = 'Vista: %s richiesto!';

    # Perl Module: Kernel/Output/HTML/Notification/TimeAccounting.pm
    $Self->{Translation}->{'Please insert your working hours!'} = 'Inserire l\'orario lavorativo!';

    # Perl Module: Kernel/Output/HTML/ToolBar/IncompleteWorkingDays.pm
    $Self->{Translation}->{'Incomplete working days'} = 'Giorni lavorativi incompleti';

    # JS File: TimeAccounting.Agent.EditTimeRecords
    $Self->{Translation}->{'Please choose at least one day!'} = 'Specificare almeno un giorno!';
    $Self->{Translation}->{'Mass Entry'} = 'Inserimento massivo';
    $Self->{Translation}->{'Please choose a reason for absence!'} = 'Selezionare un motivo per l\'assenza!';

    # JS File: TimeAccounting.Agent
    $Self->{Translation}->{'Delete Time Accounting Entry'} = 'Cancellare voce di rendicontazione';
    $Self->{Translation}->{'Confirm insert'} = 'Confermare inserimento';

    # SysConfig
    $Self->{Translation}->{'Agent interface notification module to see the number of incomplete working days for the user.'} =
        'Modulo di notifica dell\'interfaccia agente per vedere il numero di giorni lavorativi incompleti per l\'utente';
    $Self->{Translation}->{'Default name for new actions.'} = 'Nome predefinito per le nuove azioni.';
    $Self->{Translation}->{'Default name for new projects.'} = 'Nome predefinito per i nuovi progetti.';
    $Self->{Translation}->{'Default setting for date end.'} = 'Valore predefinito per la data di fine.';
    $Self->{Translation}->{'Default setting for date start.'} = 'Valore predefinito per la data di inizio.';
    $Self->{Translation}->{'Default setting for description.'} = 'Valore predefinito per la descrizione.';
    $Self->{Translation}->{'Default setting for leave days.'} = 'Valore predefinito per i giorni di assenza/vacanza.';
    $Self->{Translation}->{'Default setting for overtime.'} = 'Valore predefinito per lo straordinario.';
    $Self->{Translation}->{'Default setting for the standard weekly hours.'} = 'Valore predefinito per l\'orario settimanale standard.';
    $Self->{Translation}->{'Default status for new actions.'} = 'Valore predefinito per le nuove azioni.';
    $Self->{Translation}->{'Default status for new projects.'} = 'Valore predefinito per i nuovi progetti.';
    $Self->{Translation}->{'Default status for new users.'} = 'Valore predefinito per i nuovi utenti.';
    $Self->{Translation}->{'Defines the projects for which a remark is required. If the RegExp matches on the project, you have to insert a remark too. The RegExp use the smx parameter.'} =
        'Definisce i progetti per i quali una annotazione è obbligatoria. Se la RegExp coincide il progetto si è obbligati ad inserire una annotazione. La RegExp utilizza il parametro smx.';
    $Self->{Translation}->{'Determines if the statistics module may generate time accounting information.'} =
        'Determina se il modulo statistiche può generare informazioni di rendicontazione temporale.';
    $Self->{Translation}->{'Edit time accounting settings.'} = 'Modifica le impostazioni della rendicontazione temporale.';
    $Self->{Translation}->{'Edit time record.'} = 'Modifica registro orario';
    $Self->{Translation}->{'For how many days ago you can insert working units.'} = 'Numero massimo di giorni nel passato in cui è possibile inserire le unità di lavoro.';
    $Self->{Translation}->{'If enabled, only users that has added working time to the selected project are shown.'} =
        'Se abilitato, mostra solo gli utenti che hanno aggiunto voci di tempo lavoro al progetto selezionato.';
    $Self->{Translation}->{'If enabled, the dropdown elements in the edit screen are changed to modernized autocompletion fields.'} =
        'Se abilitata, gli elementi a tendina nella schermata di modifica sono sostituiti da più moderni campi con completamento automatico.';
    $Self->{Translation}->{'If enabled, the filter for the previous projects can be used instead two list of projects (last and all ones). It could be used only if TimeAccounting::EnableAutoCompletion is enabled.'} =
        'Se abilitata, il filtro per i progetti precedenti può essere utilizzato al posto di due elenchi di progetti (ultimo e tutti). Può essere utilizzato solo se TimeAccounting::EnableAutoCompletion è abilitata.';
    $Self->{Translation}->{'If enabled, the filter for the previous projects is active by default if there are the previous projects. It could be used only if EnableAutoCompletion and TimeAccounting::UseFilter are enabled.'} =
        'Se abilitata, il filtro per i progetti precedenti è attivo in modo predefinito se ci sono progetti precedenti. Può essere utilizzato solo se EnableAutoCompletion e TimeAccounting::UseFilter sono abilitati.';
    $Self->{Translation}->{'If enabled, the user is allowed to enter "on vacation leave", "on sick leave" and "on overtime leave" to multiple dates at once.'} =
        'Se abilitato, è possibile per gli utenti inserire i campi "periodo di vacanza", "periodo di malattia" e "straordinario" con date multiple.';
    $Self->{Translation}->{'Maximum number of working days after which the working units have to be inserted.'} =
        'Numero massimo di giorni lavorativi in cui è possibile inserire le voci di unità di lavoro.';
    $Self->{Translation}->{'Maximum number of working days without working units entry after which a warning will be shown.'} =
        'Numero massimo di giorni lavorativi che non hanno voci di unità di lavoro oltre il quale verrà mostrato un avviso.';
    $Self->{Translation}->{'Overview.'} = 'Vista Globale.';
    $Self->{Translation}->{'Project time reporting.'} = 'Rapporto del tempo di progetto.';
    $Self->{Translation}->{'Regular expressions for constraining action list according to selected project. Key contains regular expression for project(s), content contains regular expressions for action(s).'} =
        'Espressioni regolari per vincolare lista di azioni in base al progetto selezionato. La chiave contiene un\'espressione regolare per il/i progetto/i, il contenuto contiene espressioni regolari per le azioni.';
    $Self->{Translation}->{'Regular expressions for constraining project list according to user groups. Key contains regular expression for project(s), content contains comma separated list of groups.'} =
        'Espressioni regolari per vincolare lista di progetti in base ai gruppi utente. La chiave contiene un\'espressione regolare per il/i progetto/i, il contenuto contiene espressioni regolari per le azioni.';
    $Self->{Translation}->{'Specifies if working hours can be inserted without start and end times.'} =
        'Specifica se le ore lavorative possono essere inserite senza orari di inizio e di fine.';
    $Self->{Translation}->{'This module forces inserts in TimeAccounting.'} = 'Questo modulo forza gli inserimenti in TimeAccounting.';
    $Self->{Translation}->{'This notification module gives a warning if there are too many incomplete working days.'} =
        'Questo modulo di notifica genera un avviso se ci sono troppi giorni lavorativi non completi.';
    $Self->{Translation}->{'Time Accounting'} = 'Rendicontazione Temporale';
    $Self->{Translation}->{'Time accounting edit.'} = 'Modifica rendicontazione tempo.';
    $Self->{Translation}->{'Time accounting overview.'} = 'Panoramica sulla contabilizzazione tempo.';
    $Self->{Translation}->{'Time accounting reporting.'} = 'Reportistica sulla contabilizzazione tempo.';
    $Self->{Translation}->{'Time accounting settings.'} = 'Impostazioni per la contabilizzazione tempo.';
    $Self->{Translation}->{'Time accounting view.'} = 'Vista contabilizzazione tempo.';
    $Self->{Translation}->{'Time accounting.'} = 'Contabilizzazione tempo.';
    $Self->{Translation}->{'To use if some actions reduced the working hours (for example, if only half of the traveling time is paid Key => traveling; Content => 50).'} =
        'Da utilizzare se alcune azioni hanno ridotto le ore lavorative (per esempio: se solo la metà del tempo di viaggio è pagato: Chiave => Viaggio; Contenuto => 50).';


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
