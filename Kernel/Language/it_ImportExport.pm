# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::it_ImportExport;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminImportExport
    $Self->{Translation}->{'Import/Export Management'} = 'Gestione Importazione/Esportazione';
    $Self->{Translation}->{'Add template'} = 'Aggiungi modello';
    $Self->{Translation}->{'Create a template to import and export object information.'} = 'Crea un template per importare ed esportare le informazioni degli oggetti.';
    $Self->{Translation}->{'To use this module, you need to install ITSMConfigurationManagement or any other package that provides back end for objects to be imported and exported.'} =
        'Per utilizzare questo modulo, è necessario installare ITSMConfigurationManagement o qualsiasi altro pacchetto che fornisce back-end per gli oggetti da importare ed esportare.';
    $Self->{Translation}->{'Start Import'} = 'Inizia Importazione';
    $Self->{Translation}->{'Start Export'} = 'Inizia Esportazione';
    $Self->{Translation}->{'Delete this template'} = '';
    $Self->{Translation}->{'Step 1 of 5 - Edit common information'} = 'Step 1 di 5 - Modifica informazioni comuni';
    $Self->{Translation}->{'Name is required!'} = 'Il nome è obbligatorio!';
    $Self->{Translation}->{'Object is required!'} = 'L\'oggetto è obbligatorio!';
    $Self->{Translation}->{'Format is required!'} = 'Il formato è obbligatorio!';
    $Self->{Translation}->{'Step 2 of 5 - Edit object information'} = 'Step 2 di 5 - Modifica informazioni oggetto';
    $Self->{Translation}->{'Step 3 of 5 - Edit format information'} = 'Step 3 di 5 - Modifica informazioni formato';
    $Self->{Translation}->{'is required!'} = 'è obbligatorio!';
    $Self->{Translation}->{'Step 4 of 5 - Edit mapping information'} = 'Step 4 di 5 - Modifica informazioni mappatura';
    $Self->{Translation}->{'No map elements found.'} = 'Nessun elemento mappa trovato.';
    $Self->{Translation}->{'Add Mapping Element'} = 'Aggiungi un elemento di mappatura.';
    $Self->{Translation}->{'Step 5 of 5 - Edit search information'} = 'Step 5 di 5 - Modifica informazioni di ricerca';
    $Self->{Translation}->{'Restrict export per search'} = 'Restringere esportazione per ricerca';
    $Self->{Translation}->{'Import information'} = 'Importare informazione';
    $Self->{Translation}->{'Source File'} = 'Archivio origine';
    $Self->{Translation}->{'Import summary for %s'} = 'Importa riepilogo per %s';
    $Self->{Translation}->{'Records'} = 'Voci';
    $Self->{Translation}->{'Success'} = 'Successo';
    $Self->{Translation}->{'Duplicate names'} = 'Duplica i nomi';
    $Self->{Translation}->{'Last processed line number of import file'} = 'Numero dell\'ultima riga processata del file da importare';
    $Self->{Translation}->{'Ok'} = 'Ok';
    $Self->{Translation}->{'Do you really want to delete this template item?'} = 'Vuoi veramente cancellare questo modello?';

    # Perl Module: Kernel/Modules/AdminImportExport.pm
    $Self->{Translation}->{'No object backend found!'} = 'Nessun oggetto di backend trovato!';
    $Self->{Translation}->{'No format backend found!'} = 'Nessun formato di backend trovato!';
    $Self->{Translation}->{'Template not found!'} = 'Modello non trovato!';
    $Self->{Translation}->{'Can\'t insert/update template!'} = 'Non è possibile inserire/modificare template!';
    $Self->{Translation}->{'Needed TemplateID!'} = 'Necessario TemplateID!';
    $Self->{Translation}->{'Error occurred. Import impossible! See Syslog for details.'} = 'Errore riscontrato. Impossibile importare! Leggi i Syslog per ulteriori dettagli.';
    $Self->{Translation}->{'Error occurred. Export impossible! See Syslog for details.'} = 'Errore riscontrato. Impossibile esportare! Leggi i Syslog per ulteriori dettagli.';
    $Self->{Translation}->{'Template List'} = 'Lista Modelli';
    $Self->{Translation}->{'number'} = 'numero';
    $Self->{Translation}->{'number bigger than zero'} = 'numero più grande di zero';
    $Self->{Translation}->{'integer'} = 'intero';
    $Self->{Translation}->{'integer bigger than zero'} = 'intero più grande di zero';
    $Self->{Translation}->{'Element required, please insert data'} = 'Elemento richiesto, inserisci dati gentilmente';
    $Self->{Translation}->{'Invalid data, please insert a valid %s'} = 'Dati non validi, inserisci un %s valido';
    $Self->{Translation}->{'Format not found!'} = 'Formato non trovato!';

    # Perl Module: Kernel/System/ImportExport/FormatBackend/CSV.pm
    $Self->{Translation}->{'Column Separator'} = 'Separatore di colonna';
    $Self->{Translation}->{'Tabulator (TAB)'} = 'Tabulatore (TAB)';
    $Self->{Translation}->{'Semicolon (;)'} = 'Punto e virgola (;)';
    $Self->{Translation}->{'Colon (:)'} = 'Due punti (:)';
    $Self->{Translation}->{'Dot (.)'} = 'Punto (.)';
    $Self->{Translation}->{'Comma (,)'} = 'Virgola (,)';
    $Self->{Translation}->{'Charset'} = 'Charset';
    $Self->{Translation}->{'Include Column Headers'} = 'Includi le Colonne di Intestazione';
    $Self->{Translation}->{'Column'} = 'Colonna';

    # JS File: ITSM.Admin.ImportExport
    $Self->{Translation}->{'Deleting template...'} = 'Eliminazione modello in corso ...';
    $Self->{Translation}->{'There was an error deleting the template. Please check the logs for more information.'} =
        'Si è verificato un errore durante l\'eliminazione del modello. Si prega di controllare i registri per ulteriori informazioni.';
    $Self->{Translation}->{'Template was deleted successfully.'} = 'Il modello è stato eliminato correttamente.';

    # SysConfig
    $Self->{Translation}->{'Format backend module registration for the import/export module.'} =
        'Registrazione del modulo di backend del formato per il modulo di importazione/esportazione.';
    $Self->{Translation}->{'Import and export object information.'} = 'Importa ed esporta le informazioni sull\'oggetto.';
    $Self->{Translation}->{'Import/Export'} = 'Importare/Esportare';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Cancel',
    'Confirm',
    'Delete this template',
    'Deleting template...',
    'Template was deleted successfully.',
    'There was an error deleting the template. Please check the logs for more information.',
    );

}

1;
