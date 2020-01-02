# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::sw_ImportExport;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminImportExport
    $Self->{Translation}->{'Import/Export Management'} = 'Usimamizi wa kuleta/Hamisha';
    $Self->{Translation}->{'Add template'} = 'Ongeza kielezo';
    $Self->{Translation}->{'Create a template to import and export object information.'} = 'Tengeneza kiolezo kuleta na kuhamisha taarifa za kipengee';
    $Self->{Translation}->{'To use this module, you need to install ITSMConfigurationManagement or any other package that provides back end for objects to be imported and exported.'} =
        '';
    $Self->{Translation}->{'Start Import'} = 'Anza kuleta';
    $Self->{Translation}->{'Start Export'} = 'Anza kuhamisha';
    $Self->{Translation}->{'Delete this template'} = '';
    $Self->{Translation}->{'Step 1 of 5 - Edit common information'} = '';
    $Self->{Translation}->{'Name is required!'} = 'Jina linahitajika!';
    $Self->{Translation}->{'Object is required!'} = 'Kipengee kinahitajika!';
    $Self->{Translation}->{'Format is required!'} = 'Umbizo unahitajika';
    $Self->{Translation}->{'Step 2 of 5 - Edit object information'} = '';
    $Self->{Translation}->{'Step 3 of 5 - Edit format information'} = '';
    $Self->{Translation}->{'is required!'} = 'Inahitajika';
    $Self->{Translation}->{'Step 4 of 5 - Edit mapping information'} = '';
    $Self->{Translation}->{'No map elements found.'} = 'Hakuna elementi zilizopatikana';
    $Self->{Translation}->{'Add Mapping Element'} = 'Ongeza elementi za kuweka ramani';
    $Self->{Translation}->{'Step 5 of 5 - Edit search information'} = '';
    $Self->{Translation}->{'Restrict export per search'} = 'Zuia uhamishaji kwa kila utafutaji';
    $Self->{Translation}->{'Import information'} = 'Leta taarifa';
    $Self->{Translation}->{'Source File'} = 'Faili la chanzo';
    $Self->{Translation}->{'Import summary for %s'} = '';
    $Self->{Translation}->{'Records'} = 'Kumbukumbu';
    $Self->{Translation}->{'Success'} = 'Mafanikio';
    $Self->{Translation}->{'Duplicate names'} = 'Jina limejirudia:';
    $Self->{Translation}->{'Last processed line number of import file'} = 'Namba ya mstari unaokatika mchakato wa mwisho wa faili lililoletwa';
    $Self->{Translation}->{'Ok'} = 'Sawa';
    $Self->{Translation}->{'Do you really want to delete this template item?'} = '';

    # Perl Module: Kernel/Modules/AdminImportExport.pm
    $Self->{Translation}->{'No object backend found!'} = '';
    $Self->{Translation}->{'No format backend found!'} = '';
    $Self->{Translation}->{'Template not found!'} = '';
    $Self->{Translation}->{'Can\'t insert/update template!'} = '';
    $Self->{Translation}->{'Needed TemplateID!'} = '';
    $Self->{Translation}->{'Error occurred. Import impossible! See Syslog for details.'} = '';
    $Self->{Translation}->{'Error occurred. Export impossible! See Syslog for details.'} = '';
    $Self->{Translation}->{'Template List'} = '';
    $Self->{Translation}->{'number'} = '';
    $Self->{Translation}->{'number bigger than zero'} = '';
    $Self->{Translation}->{'integer'} = '';
    $Self->{Translation}->{'integer bigger than zero'} = '';
    $Self->{Translation}->{'Element required, please insert data'} = '';
    $Self->{Translation}->{'Invalid data, please insert a valid %s'} = '';
    $Self->{Translation}->{'Format not found!'} = '';

    # Perl Module: Kernel/System/ImportExport/FormatBackend/CSV.pm
    $Self->{Translation}->{'Column Separator'} = 'Kitenganishi safu wima';
    $Self->{Translation}->{'Tabulator (TAB)'} = 'Tabo (TAB)';
    $Self->{Translation}->{'Semicolon (;)'} = 'Alama ya nukta mkato (;)';
    $Self->{Translation}->{'Colon (:)'} = 'Colon (:)';
    $Self->{Translation}->{'Dot (.)'} = 'Nukta (.)';
    $Self->{Translation}->{'Comma (,)'} = '';
    $Self->{Translation}->{'Charset'} = 'Seti ya herufi';
    $Self->{Translation}->{'Include Column Headers'} = 'Ambatisha vichwa vya habari vya safuwima';
    $Self->{Translation}->{'Column'} = 'Safuwima';

    # JS File: ITSM.Admin.ImportExport
    $Self->{Translation}->{'Deleting template...'} = '';
    $Self->{Translation}->{'There was an error deleting the template. Please check the logs for more information.'} =
        '';
    $Self->{Translation}->{'Template was deleted successfully.'} = '';

    # SysConfig
    $Self->{Translation}->{'Format backend module registration for the import/export module.'} =
        'Umbiza usajili wa moduli wa mazingira ya nyuma kwa ajili ya moduli ya kuleta/kuhamisha';
    $Self->{Translation}->{'Import and export object information.'} = 'Leta na hamisha taarifa za kipengee';
    $Self->{Translation}->{'Import/Export'} = 'Leta/Hamisha';


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
