# --
# Kernel/Language/it_TimeAccounting.pm - translation file
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::it_TimeAccounting;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # Template: AAATimeAccounting
    $Self->{Translation}->{'Time Accounting'} = '';

    # Template: AgentTimeAccountingDelete
    $Self->{Translation}->{'Do you really want to delete the Time Accounting of this day?'} =
        'Vuoi veramente cancellare la rendicontazione temporale di oggi ?';

    # Template: AgentTimeAccountingEdit
    $Self->{Translation}->{'Edit Time Record'} = 'Modifica la rendicontazione';
    $Self->{Translation}->{'Project settings'} = 'Impostazioni del progetto';
    $Self->{Translation}->{'Date Navigation'} = 'Navigazione per data';
    $Self->{Translation}->{'Previous day'} = 'Giorno precedente';
    $Self->{Translation}->{'Next day'} = 'Giorno successivo';
    $Self->{Translation}->{'Days without entries'} = 'Giorni senza informazioni';
    $Self->{Translation}->{'Select all days'} = '';
    $Self->{Translation}->{'Mass entry'} = '';
    $Self->{Translation}->{'Please choose the reason for your absence for the selected days'} =
        '';
    $Self->{Translation}->{'On vacation'} = 'Ferie';
    $Self->{Translation}->{'On sick leave'} = 'Assente per malattia';
    $Self->{Translation}->{'On overtime leave'} = 'Assente per recupero';
    $Self->{Translation}->{'Please choose at least one day!'} = '';
    $Self->{Translation}->{'Please choose a reason for absence!'} = '';
    $Self->{Translation}->{'Mass Entry'} = '';
    $Self->{Translation}->{'Required fields are marked with a "*".'} = 'I campi obbligatori sono indicati con "*".';
    $Self->{Translation}->{'You have to fill in start and end time or a time period.'} = 'E\' obbligatorio inserire inizio e fine oppure un periodo.';
    $Self->{Translation}->{'Project'} = 'Progetto';
    $Self->{Translation}->{'Task'} = 'Compito';
    $Self->{Translation}->{'Remark'} = 'Commento';
    $Self->{Translation}->{'Please add a remark with more than 8 characters!.'} = 'Inserire un commeto più lungo di 8 caratteri!';
    $Self->{Translation}->{'Negative times are not allowed.'} = 'Non possono essere inseriti valori negativi.';
    $Self->{Translation}->{'Repeated hours are not allowed. Start time matches another interval.'} =
        'Non è permesso inserire ore ripetute. L\'orario di inizio coincide con un altro intervallo.';
    $Self->{Translation}->{'Invalid format! Please enter a time with the format HH:MM.'} = '';
    $Self->{Translation}->{'24:00 is only permitted as end time.'} = '';
    $Self->{Translation}->{'Invalid time! A day has only 24 hours.'} = '';
    $Self->{Translation}->{'End time must be after start time.'} = 'L\'orario di fine è posteriore all\'orario di inizio.';
    $Self->{Translation}->{'Repeated hours are not allowed. End time matches another interval.'} =
        'Non è permesso inserire ore ripetute. L\'orario di fine coincide con un altro intervallo.';
    $Self->{Translation}->{'Invalid period! A day has only 24 hours.'} = 'Periodo non valido. Una giornata ha solo 24 ore.';
    $Self->{Translation}->{'A valid period must be greater than zero.'} = 'Un periodo valido deve essere maggiore di zero.';
    $Self->{Translation}->{'Invalid period! Negative periods are not allowed.'} = 'Periodo non valido. Valori negativi non ammessi.';
    $Self->{Translation}->{'Add one row'} = 'Aggiungere una riga';
    $Self->{Translation}->{'Total'} = 'Totale';
    $Self->{Translation}->{'You can only select one checkbox element!'} = 'Puoi selezionare solo un elemento!';
    $Self->{Translation}->{'Show all items'} = 'Mostra tutti gli elementi';
    $Self->{Translation}->{'Delete Time Accounting Entry'} = 'Cancellare voce di rendicontazione';
    $Self->{Translation}->{'Confirm insert'} = 'Confermare inserimento';
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

    # Template: AgentTimeAccountingProjectReporting
    $Self->{Translation}->{'Project report'} = 'Riassunto progetto';

    # Template: AgentTimeAccountingReporting
    $Self->{Translation}->{'Time reporting'} = 'Report del tempo';
    $Self->{Translation}->{'Month Navigation'} = 'Navigazione per mese';
    $Self->{Translation}->{'User reports'} = 'Report utente';
    $Self->{Translation}->{'Monthly total'} = 'Totale mensile';
    $Self->{Translation}->{'Lifetime total'} = 'Totale gLobale';
    $Self->{Translation}->{'Overtime leave'} = 'Assenze per recupero';
    $Self->{Translation}->{'Vacation'} = 'Ferie';
    $Self->{Translation}->{'Sick leave'} = 'Malattia';
    $Self->{Translation}->{'Vacation remaining'} = 'Giorni rimanenti';
    $Self->{Translation}->{'Project reports'} = 'Riassunti progetto';

    # Template: AgentTimeAccountingSetting
    $Self->{Translation}->{'Edit Time Accounting Project Settings'} = 'Modificare le configurazioni di gestione del tempo del progetto.';
    $Self->{Translation}->{'Add project'} = 'Aggiungere progetto';
    $Self->{Translation}->{'Add Project'} = 'Aggiungere progetto';
    $Self->{Translation}->{'Edit Project Settings'} = 'Modificare la configurazione del progetto';
    $Self->{Translation}->{'There is already a project with this name. Please, choose a different one.'} =
        'Esiste già un progetto con questo nome. Scegleire un nome diverso.';
    $Self->{Translation}->{'Edit Time Accounting Settings'} = 'Modificare le configurazioni della rendicontazione';
    $Self->{Translation}->{'Add task'} = 'Aggiungere compito';
    $Self->{Translation}->{'New user'} = 'Nuovo utente';
    $Self->{Translation}->{'Filter for Projects'} = 'Filtro per progetti';
    $Self->{Translation}->{'Filter for Tasks'} = 'Filtro per compiti';
    $Self->{Translation}->{'Filter for Users'} = 'Filtro per utenti';
    $Self->{Translation}->{'Project List'} = 'Elenco dei progetti';
    $Self->{Translation}->{'Task List'} = 'Elenco dei compiti';
    $Self->{Translation}->{'Add Task'} = 'Aggiungere compito';
    $Self->{Translation}->{'Edit Task Settings'} = 'Modificare la configurazione dei compiti';
    $Self->{Translation}->{'There is already a task with this name. Please, choose a different one.'} =
        'Esiste già un compito con questo nome. Scegliere un nome diverso.';
    $Self->{Translation}->{'User List'} = 'Elenco utenti';
    $Self->{Translation}->{'New User Settings'} = 'Configurazioni nuovo utente';
    $Self->{Translation}->{'Edit User Settings'} = 'Modificare configurazione utente';
    $Self->{Translation}->{'Comments'} = 'Commenti';
    $Self->{Translation}->{'Show Overtime'} = 'Mostrare straordinari';
    $Self->{Translation}->{'Allow project creation'} = 'Cosentire la creazione del progetto';
    $Self->{Translation}->{'Period Begin'} = 'Periodo di inizio';
    $Self->{Translation}->{'Period End'} = 'Periodo di termine';
    $Self->{Translation}->{'Days of Vacation'} = 'Giorni di Assenza';
    $Self->{Translation}->{'Hours per Week'} = 'Ore alla settimana';
    $Self->{Translation}->{'Authorized Overtime'} = 'Straordinari autorizzati';
    $Self->{Translation}->{'Please insert a valid date.'} = '';
    $Self->{Translation}->{'Period end must be after period begin.'} = 'Il periodo finale deve essere posteriore al periodo iniziale.';
    $Self->{Translation}->{'No time periods found.'} = 'Non ci sono periodi.';
    $Self->{Translation}->{'Add time period'} = 'Aggiungi periodo';

    # Template: AgentTimeAccountingView
    $Self->{Translation}->{'View Time Record'} = 'Visualizzare registro orario';
    $Self->{Translation}->{'View of '} = 'Visualizzazione di  ';
    $Self->{Translation}->{'No data found for this day.'} = 'Nessun dato trovato per questo giorno.';

    # SysConfig
    $Self->{Translation}->{'Agent interface notification module to see the number of incomplete working days for the user.'} =
        '';
    $Self->{Translation}->{'Default name for new actions.'} = '';
    $Self->{Translation}->{'Default name for new projects.'} = '';
    $Self->{Translation}->{'Default setting for date end.'} = '';
    $Self->{Translation}->{'Default setting for date start.'} = '';
    $Self->{Translation}->{'Default setting for description.'} = '';
    $Self->{Translation}->{'Default setting for leave days.'} = '';
    $Self->{Translation}->{'Default setting for overtime.'} = '';
    $Self->{Translation}->{'Default setting for the standard weekly hours.'} = '';
    $Self->{Translation}->{'Default status for new actions.'} = '';
    $Self->{Translation}->{'Default status for new projects.'} = '';
    $Self->{Translation}->{'Default status for new users.'} = '';
    $Self->{Translation}->{'Defines the projects for which a remark is required. If the RegExp matches on the project, you have to insert a remark too. The RegExp use the smx parameter.'} =
        '';
    $Self->{Translation}->{'Determines if the statistics module may generate time accounting information.'} =
        '';
    $Self->{Translation}->{'Edit time accounting settings'} = '';
    $Self->{Translation}->{'Edit time record'} = '';
    $Self->{Translation}->{'For how many days ago you can insert working units.'} = '';
    $Self->{Translation}->{'If enabled, the dropdown elements in the edit screen are changed to autocompletion fields.'} =
        '';
    $Self->{Translation}->{'If enabled, the user is allowed to enter "on vacation leave", "on sick leave" and "on overtime leave" to multiple dates at once.'} =
        '';
    $Self->{Translation}->{'Maximum number of working days after which the working units have to be inserted.'} =
        '';
    $Self->{Translation}->{'Maximum number of working days without working units entry after which a warning will be shown.'} =
        '';
    $Self->{Translation}->{'Project time reporting'} = '';
    $Self->{Translation}->{'Regular expressions for constraining action list according to selected project. Key contains regular expression for project(s), content contains regular expressions for action(s).'} =
        '';
    $Self->{Translation}->{'Regular expressions for constraining project list according to user groups. Key contains regular expression for project(s), content contains comma separated list of groups.'} =
        '';
    $Self->{Translation}->{'Specifies if working hours can be inserted without start and end times.'} =
        '';
    $Self->{Translation}->{'This module forces inserts in TimeAccounting.'} = '';
    $Self->{Translation}->{'This notification module gives a warning if there are too many incomplete working days.'} =
        '';
    $Self->{Translation}->{'Time accounting.'} = '';
    $Self->{Translation}->{'To use if some actions reduced the working hours (for example, if only half of the traveling time is paid Key => traveling; Content => 50).'} =
        '';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #
    $Self->{Translation}->{'Can\'t delete Working Units!'} = '¡Imposible eliminar las unidades de trabajo!';
    $Self->{Translation}->{'Can\'t save settings, because a day has only 24 hours!'} = '¡Imposible guardar la configuración porque un día sólo tiene 24 horas!';
    $Self->{Translation}->{'Date navigation'} = 'Navigazione per data';
    $Self->{Translation}->{'Period is bigger than the interval between start and end times!'} =
        'Il periodo è superiore all\'intervallo di inizio\fine!';
    $Self->{Translation}->{'Please insert your working hours!'} = '¡Favor de insertar sus horas de trabajo!';
    $Self->{Translation}->{'Project added!'} = 'Progetto aggiunto!';
    $Self->{Translation}->{'Project updated!'} = 'Progetto aggiornato!';
    $Self->{Translation}->{'Reporting'} = 'Reporte';
    $Self->{Translation}->{'Show all projects'} = 'Mostrare tutti i progetti';
    $Self->{Translation}->{'Show valid projects'} = 'Mostrare solo i progetti validi';
    $Self->{Translation}->{'Successful insert!'} = 'Inserimento terminato positivamente';
    $Self->{Translation}->{'Task added!'} = 'Compito aggiunto!';
    $Self->{Translation}->{'Task updated!'} = 'Compito aggiornato!';
    $Self->{Translation}->{'TimeAccounting'} = 'Rendicontazione';
    $Self->{Translation}->{'User added!'} = 'Utente aggiunto!';
    $Self->{Translation}->{'User updated!'} = 'Utente aggiornato!';

}

1;
