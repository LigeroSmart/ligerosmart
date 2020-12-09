# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::it_GeneralCatalog;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAGeneralCatalog
    $Self->{Translation}->{'Functionality'} = 'Funzionalità';

    # Template: AdminGeneralCatalog
    $Self->{Translation}->{'General Catalog Management'} = 'Gestione del Catalogo Generale';
    $Self->{Translation}->{'Items in Class'} = 'Elementi nella Classe';
    $Self->{Translation}->{'Edit Item'} = 'Modifica Elemento';
    $Self->{Translation}->{'Add Class'} = 'Aggiungi Classe';
    $Self->{Translation}->{'Add Item'} = 'Aggiungi Elemento';
    $Self->{Translation}->{'Add Catalog Item'} = 'Aggiungi Elemento al Catalogo';
    $Self->{Translation}->{'Add Catalog Class'} = 'Aggiungi Classe al Catalogo';
    $Self->{Translation}->{'Catalog Class'} = 'Classe di Catalogo';
    $Self->{Translation}->{'Edit Catalog Item'} = 'Modifica elemento di catalogo';

    # JS File: ITSM.GeneralCatalog
    $Self->{Translation}->{'Warning incident state can not be set to invalid.'} = 'Lo stato dell\'incidente di avviso non può essere impostato su non valido.';

    # SysConfig
    $Self->{Translation}->{'Comment 2'} = 'Commento 2';
    $Self->{Translation}->{'Create and manage the General Catalog.'} = 'Crea e gestisci il Catalogo Generale';
    $Self->{Translation}->{'Define the general catalog comment 2.'} = 'Definisci il commento 2 del catalogo generale';
    $Self->{Translation}->{'Defines the URL JS Color Picker path.'} = 'Specifica il percorso dell\'URL del selettore di colori JS.';
    $Self->{Translation}->{'Frontend module registration for the AdminGeneralCatalog configuration in the admin area.'} =
        'Modulo di registrazione per la configurazione di AdminGeneralCatalog nell\'area di admin.';
    $Self->{Translation}->{'General Catalog'} = 'Catalogo Generale';
    $Self->{Translation}->{'Parameters for the example comment 2 of the general catalog attributes.'} =
        'Parametri per il commento di esempio 2 degli attributi del catalogo generale.';
    $Self->{Translation}->{'Parameters for the example permission groups of the general catalog attributes.'} =
        'Parametri per i gruppi di permessi di esempio degli attributi del catalogo generale.';
    $Self->{Translation}->{'Permission Group'} = 'Gruppo di autorizzazioni';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Cancel',
    'Warning',
    'Warning incident state can not be set to invalid.',
    );

}

1;
