# --
# Kernel/Language/nb_NO_ImportExport.pm - translation file
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# Copyright (C) 2011 Translated by Eirik Wulff <eirik at epledoktor.no>
# --
# $Id: nb_NO_ImportExport.pm,v 1.2 2011-05-05 09:36:13 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::nb_NO_ImportExport;

use strict;

sub Data {
    my $Self = shift;

    # Template: AAAImportExport
    $Self->{Translation}->{'Add mapping template'} = 'Legg til mal for mapping';
    $Self->{Translation}->{'Charset'} = 'Tegnsett';
    $Self->{Translation}->{'Colon (:)'} = 'Kolon (:)';
    $Self->{Translation}->{'Column'} = 'Kolonne';
    $Self->{Translation}->{'Column Separator'} = 'Kolonneseparator';
    $Self->{Translation}->{'Dot (.)'} = 'Punktum (.)';
    $Self->{Translation}->{'Semicolon (;)'} = 'Semikolon (;)';
    $Self->{Translation}->{'Tabulator (TAB)'} = 'Tabulator (TAB)';
    $Self->{Translation}->{'Include Column Headers'} = '';

    # Template: AdminImportExport
    $Self->{Translation}->{'Import/Export Management'} = 'Administrasjon av Import/Eksport';
    $Self->{Translation}->{'Add template'} = 'Legg til mal';
    $Self->{Translation}->{'Note'} = 'Notis';
    $Self->{Translation}->{'Create a template to import and export object information.'} = 'Opprett en mal for å eksportere og importere informasjon';
    $Self->{Translation}->{'Start Import'} = 'Start import';
    $Self->{Translation}->{'Start Export'} = 'Start eksport';
    $Self->{Translation}->{'Delete Template'} = 'Slett mal';
    $Self->{Translation}->{'Step'} = 'Steg';
    $Self->{Translation}->{'Edit common information'} = 'Endre fellesinformasjon';
    $Self->{Translation}->{'Name is required!'} = 'Navn er påkrevd!';
    $Self->{Translation}->{'Object is required!'} = 'Objekt er påkrevd!';
    $Self->{Translation}->{'Format is required!'} = 'Format er påkrevd!';
    $Self->{Translation}->{'Edit object information'} = 'Endre objektet';
    $Self->{Translation}->{'Edit format information'} = 'Endre formatet';
    $Self->{Translation}->{' is required!'} = ' er påkrevd!';
    $Self->{Translation}->{'Edit mapping information'} = 'Endre mapping';
    $Self->{Translation}->{'No map elements found.'} = 'Ingen elementer funnet.';
    $Self->{Translation}->{'Add Mapping Element'} = 'Legg til mapping-element';
    $Self->{Translation}->{'Edit search information'} = 'Endre søk';
    $Self->{Translation}->{'Restrict export per search'} = 'Begrens eksport per søk';
    $Self->{Translation}->{'Import information'} = 'Import-informasjon';
    $Self->{Translation}->{'Source File'} = 'Kildefil';

    # SysConfig
    $Self->{Translation}->{'Format backend module registration for the import/export module.'} = 'Baksidemodul-registrering for formatet til import/eksport-modulen';
    $Self->{Translation}->{'Import and export object information.'} = 'Informasjon for import- og eksport-objekt';
    $Self->{Translation}->{'Import/Export'} = 'Import/Eksport';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #
    $Self->{Translation}->{'Column Seperator'} = 'Kolonne adskillelse';

}

1;
