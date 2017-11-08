# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::sw_TimeAccounting;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentTimeAccountingDelete
    $Self->{Translation}->{'Do you really want to delete the Time Accounting of this day?'} =
        'Je unataka kufuta Uhasibu wa Muda kwa siku ya leo?';

    # Template: AgentTimeAccountingEdit
    $Self->{Translation}->{'Edit Time Record'} = 'Hariri rekodi ya muda';
    $Self->{Translation}->{'Go to settings'} = 'Nenda kwenye mpangilio';
    $Self->{Translation}->{'Date Navigation'} = 'Uabiri wa tarehe';
    $Self->{Translation}->{'Days without entries'} = 'Siku zisizokuwa na maingizo';
    $Self->{Translation}->{'Select all days'} = 'Chagua siku zote';
    $Self->{Translation}->{'Mass entry'} = 'Ingizo la pamoja';
    $Self->{Translation}->{'Please choose the reason for your absence for the selected days'} =
        'Tafadhali chagua sababu ya kutokuwepo kwa siku zilizo chaguliwa';
    $Self->{Translation}->{'On vacation'} = 'Katika likizo';
    $Self->{Translation}->{'On sick leave'} = 'Katika ruhusa ya wagonjwa';
    $Self->{Translation}->{'On overtime leave'} = 'Katika ruhusa ya muda wa nyongeza';
    $Self->{Translation}->{'Required fields are marked with a "*".'} = 'Sehemu zinazotakiwa zina alama "*"';
    $Self->{Translation}->{'You have to fill in start and end time or a time period.'} = 'Unatakiwa kujaza muda wa kuanza na kumaliza au muda uliotumika.';
    $Self->{Translation}->{'Project'} = 'Mradi';
    $Self->{Translation}->{'Task'} = 'Kazi';
    $Self->{Translation}->{'Remark'} = 'Maoni';
    $Self->{Translation}->{'Please add a remark with more than 8 characters!'} = '';
    $Self->{Translation}->{'Negative times are not allowed.'} = 'Muda hasi hauruhusiwi.';
    $Self->{Translation}->{'Repeated hours are not allowed. Start time matches another interval.'} =
        'Muda uliojirudia hauruhusiwi. Muda wa kuanza unafanana na muda mwingine.';
    $Self->{Translation}->{'Invalid format! Please enter a time with the format HH:MM.'} = 'Muundo batili! Tafadhali ingiza muda na muundo HH:MM.';
    $Self->{Translation}->{'24:00 is only permitted as end time.'} = '24:00 inaruhusiwa katika muda wa kumaliza.';
    $Self->{Translation}->{'Invalid time! A day has only 24 hours.'} = 'Muda batili! Siku ina masaa 24 tu.';
    $Self->{Translation}->{'End time must be after start time.'} = 'Muda wa kumaliza lazima uwe baada ya muda wa kuanza.';
    $Self->{Translation}->{'Repeated hours are not allowed. End time matches another interval.'} =
        'Masaa yaliyojirudia hayaruhusiwi. Muda wa kumaliza unafanana muda mwingine.';
    $Self->{Translation}->{'Invalid period! A day has only 24 hours.'} = 'Muda batili! Siku ina masaa 24 tu.';
    $Self->{Translation}->{'A valid period must be greater than zero.'} = 'Muda halali una masaa zaidi ya sifuri.';
    $Self->{Translation}->{'Invalid period! Negative periods are not allowed.'} = 'Kipindi batili! Vipindi hasi haviruhusiwi.';
    $Self->{Translation}->{'Add one row'} = 'Ongeza safu moja';
    $Self->{Translation}->{'You can only select one checkbox element!'} = 'Unaweza kuchagua elementi moja katika cheki boksi';
    $Self->{Translation}->{'Are you sure that you worked while you were on sick leave?'} = 'Una uhakika ulifanya kazi wakati upo likizo ya wagonjwa?';
    $Self->{Translation}->{'Are you sure that you worked while you were on vacation?'} = 'Una uhakika ulifanya kazi wakati upo likizo?';
    $Self->{Translation}->{'Are you sure that you worked while you were on overtime leave?'} =
        'Una uhakika ulifanya kazi wakati upo likizo ya muda wa nyongeza?';
    $Self->{Translation}->{'Are you sure that you worked more than 16 hours?'} = 'Una uhakika ulifanya kazi zaidi ya masaa 16?';

    # Template: AgentTimeAccountingOverview
    $Self->{Translation}->{'Time reporting monthly overview'} = 'Mapitio ya mwezi ya uarifu wa muda ';
    $Self->{Translation}->{'Overtime (Hours)'} = 'Muda wa nyogneza (Masaa)';
    $Self->{Translation}->{'Overtime (this month)'} = 'Muda wa nyongeza (mwezi huu)';
    $Self->{Translation}->{'Overtime (total)'} = 'Muda wa nyongeza (jumla)';
    $Self->{Translation}->{'Remaining overtime leave'} = 'Muda uliobaki wa likizo ya muda wa nyongeza';
    $Self->{Translation}->{'Vacation (Days)'} = 'Likizo (siku)';
    $Self->{Translation}->{'Vacation taken (this month)'} = 'Likizo iliyochukuliwa (mwezi huu)';
    $Self->{Translation}->{'Vacation taken (total)'} = 'Likizo iliyochukuliwa (jumla)';
    $Self->{Translation}->{'Remaining vacation'} = 'Likizo iliyobaki';
    $Self->{Translation}->{'Sick Leave (Days)'} = 'Likizo ya wagonjwa (siku)';
    $Self->{Translation}->{'Sick leave taken (this month)'} = 'Likizo ya wagonjwa iliyochukuliwa (mwezi huu)';
    $Self->{Translation}->{'Sick leave taken (total)'} = 'Likizo ya wagonjwa iliyochukuliwa (jumla)';
    $Self->{Translation}->{'Previous month'} = 'Mwezi uliopita';
    $Self->{Translation}->{'Next month'} = 'Mwezi ujao';
    $Self->{Translation}->{'Weekday'} = 'Siku za kazi';
    $Self->{Translation}->{'Working Hours'} = 'Masaa ya kazi';
    $Self->{Translation}->{'Total worked hours'} = 'Jumla ya masaa ya kazi';
    $Self->{Translation}->{'User\'s project overview'} = 'Mapitio ya mradi wa mtumiaji';
    $Self->{Translation}->{'Hours (monthly)'} = 'Masaa (kwa mwezi)';
    $Self->{Translation}->{'Hours (Lifetime)'} = 'Masaa (muda wote)';
    $Self->{Translation}->{'Grand total'} = 'Jumla kuu';

    # Template: AgentTimeAccountingReporting
    $Self->{Translation}->{'Time reporting'} = 'Uarifu wa muda';
    $Self->{Translation}->{'Month Navigation'} = 'Uabiri wa mwezi';
    $Self->{Translation}->{'Go to date'} = 'Nenda tarehe';
    $Self->{Translation}->{'User reports'} = 'Ripoti za mtumiaji';
    $Self->{Translation}->{'Monthly total'} = 'Jumla ya mwezi';
    $Self->{Translation}->{'Lifetime total'} = 'Jumla ya muda wote';
    $Self->{Translation}->{'Overtime leave'} = 'Likizo ya muda wa nyongeza';
    $Self->{Translation}->{'Vacation'} = 'Likizo';
    $Self->{Translation}->{'Sick leave'} = 'Likizo ya wagonjwa';
    $Self->{Translation}->{'Vacation remaining'} = 'Likizo iliyobaki';
    $Self->{Translation}->{'Project reports'} = 'Ripoti za mradi';

    # Template: AgentTimeAccountingReportingProject
    $Self->{Translation}->{'Project report'} = 'Ripoti ya mradi';
    $Self->{Translation}->{'Go to reporting overview'} = 'Nenda kwenye mapitio ya uarifu';
    $Self->{Translation}->{'Currently only active users in this project are shown. To change this behavior, please update setting:'} =
        'Kwa sasa watumiaji amilifu tu katika mradi huu wataonyeshwa. Kubadilisha tabia hii, tafadhali sasisha mpangalio.';
    $Self->{Translation}->{'Currently all time accounting users are shown. To change this behavior, please update setting:'} =
        'Kwa sasa watumiaji wote wa muda uliohesabika wataonyeshwa. Kubadilisha tabia hii, tafadhali sasisha mpangalio.';

    # Template: AgentTimeAccountingSetting
    $Self->{Translation}->{'Edit Time Accounting Project Settings'} = 'Hariri Uhasibu wa Muda kwenye mipangilio ya mradi';
    $Self->{Translation}->{'Add project'} = 'Ongeza mradi';
    $Self->{Translation}->{'Go to settings overview'} = 'Nenda kwenye mapitio ya mpangiio';
    $Self->{Translation}->{'Add Project'} = 'Ongeza mradi';
    $Self->{Translation}->{'Edit Project Settings'} = 'Hariri mipangilio ya mradi';
    $Self->{Translation}->{'There is already a project with this name. Please, choose a different one.'} =
        'Tayari kuna mradi wenye hili jina. Tafadhali, chagua jengine.';
    $Self->{Translation}->{'Edit Time Accounting Settings'} = 'Hariri mipangilio ya Uhasubu wa Muda';
    $Self->{Translation}->{'Add task'} = 'Ongeza kazi';
    $Self->{Translation}->{'Filter for projects, tasks or users'} = '';
    $Self->{Translation}->{'Time periods can not be deleted.'} = '';
    $Self->{Translation}->{'Project List'} = 'Orodha ya miradi';
    $Self->{Translation}->{'Task List'} = 'Orodha ya kazi';
    $Self->{Translation}->{'Add Task'} = 'Ongeza kazi';
    $Self->{Translation}->{'Edit Task Settings'} = 'Hariri mipangilio ya kazi';
    $Self->{Translation}->{'There is already a task with this name. Please, choose a different one.'} =
        'Tayari kuna kazi yenye hili jina. Tafadhali chagua jengine.';
    $Self->{Translation}->{'User List'} = 'Orodha ya mtumiaji';
    $Self->{Translation}->{'User Settings'} = '';
    $Self->{Translation}->{'User is allowed to see overtimes'} = '';
    $Self->{Translation}->{'Show Overtime'} = 'Onyesha muda wa nyongeza';
    $Self->{Translation}->{'User is allowed to create projects'} = '';
    $Self->{Translation}->{'Allow project creation'} = 'Ruhusu utengenezaji wa mradi';
    $Self->{Translation}->{'Time Spans'} = '';
    $Self->{Translation}->{'Period Begin'} = 'Kuanza kwa kipengele';
    $Self->{Translation}->{'Period End'} = 'Kuisha kwa kipengele';
    $Self->{Translation}->{'Days of Vacation'} = 'Siku za likizo';
    $Self->{Translation}->{'Hours per Week'} = 'Masaa kwa wiki';
    $Self->{Translation}->{'Authorized Overtime'} = 'Muda wa nyongeza ulioruhusiwa';
    $Self->{Translation}->{'Start Date'} = 'Tarehe ya kuanza';
    $Self->{Translation}->{'Please insert a valid date.'} = 'Tafadhali ingiza tarehe halali';
    $Self->{Translation}->{'End Date'} = 'Tarehe ya kumaliza';
    $Self->{Translation}->{'Period end must be after period begin.'} = 'Mwisho wa kipengele lazima uwe baada ya mwanzo wa kipengele';
    $Self->{Translation}->{'Leave Days'} = 'Siku za likizo';
    $Self->{Translation}->{'Weekly Hours'} = 'Masaa ya wiki';
    $Self->{Translation}->{'Overtime'} = 'Muda wa nyongeza';
    $Self->{Translation}->{'No time periods found.'} = 'Hakuna vipengele vya muda vilivyopatikana';
    $Self->{Translation}->{'Add time period'} = 'Ongeza kipengele cha muda';

    # Template: AgentTimeAccountingView
    $Self->{Translation}->{'View Time Record'} = 'Onyesha kipengele cha muda';
    $Self->{Translation}->{'View of '} = 'Muonekano wa';
    $Self->{Translation}->{'Previous day'} = 'Siku iliyopita';
    $Self->{Translation}->{'Next day'} = 'Siku inayofwata';
    $Self->{Translation}->{'No data found for this day.'} = 'Hakuna data zilizopatikana kwa siku hii';

    # Perl Module: Kernel/Modules/AgentTimeAccountingEdit.pm
    $Self->{Translation}->{'Can\'t insert Working Units!'} = '';
    $Self->{Translation}->{'Last Projects'} = '';
    $Self->{Translation}->{'Can\'t save settings, because a day has only 24 hours!'} = '';
    $Self->{Translation}->{'Can\'t delete Working Units!'} = '';
    $Self->{Translation}->{'This Date is out of limit, but you haven\'t insert this day yet, so you get one(!) chance to insert'} =
        '';
    $Self->{Translation}->{'Incomplete Working Days'} = '';
    $Self->{Translation}->{'Please insert your working hours!'} = 'Tafadhali ingiza massaa ya kazi!';
    $Self->{Translation}->{'Successful insert!'} = 'Ingizo limefanikiwa';
    $Self->{Translation}->{'Error while inserting multiple dates!'} = 'Kosa katika kuingiza tarehe zaidi ya moja!';
    $Self->{Translation}->{'Successfully inserted entries for several dates!'} = 'Maingizo yaliyofanikiwa kwa tarehe zaidi ya moja!';
    $Self->{Translation}->{'Entered date was invalid! Date was changed to today.'} = 'Ingizo la tarehe ni batili! Tarehe imebadilishwa leo.';
    $Self->{Translation}->{'No time period configured, or the specified date is outside of the defined time periods.'} =
        '';
    $Self->{Translation}->{'Please contact the time accounting administrator to update your time periods!'} =
        '';
    $Self->{Translation}->{'Last Selected Projects'} = '';
    $Self->{Translation}->{'All Projects'} = '';

    # Perl Module: Kernel/Modules/AgentTimeAccountingReporting.pm
    $Self->{Translation}->{'ReportingProject: Need ProjectID'} = '';
    $Self->{Translation}->{'Reporting Project'} = '';
    $Self->{Translation}->{'Reporting'} = 'Uarifu';

    # Perl Module: Kernel/Modules/AgentTimeAccountingSetting.pm
    $Self->{Translation}->{'Unable to update user settings!'} = '';
    $Self->{Translation}->{'Project added!'} = '';
    $Self->{Translation}->{'Project updated!'} = '';
    $Self->{Translation}->{'Task added!'} = '';
    $Self->{Translation}->{'Task updated!'} = '';
    $Self->{Translation}->{'The UserID is not valid!'} = '';
    $Self->{Translation}->{'Can\'t insert user data!'} = '';
    $Self->{Translation}->{'Unable to add time period!'} = '';
    $Self->{Translation}->{'Setting'} = 'Mpangilio';
    $Self->{Translation}->{'User updated!'} = '';
    $Self->{Translation}->{'User added!'} = '';
    $Self->{Translation}->{'Add a user to time accounting...'} = '';
    $Self->{Translation}->{'New User'} = '';
    $Self->{Translation}->{'Period Status'} = '';

    # Perl Module: Kernel/Modules/AgentTimeAccountingView.pm
    $Self->{Translation}->{'View: Need %s!'} = '';

    # Perl Module: Kernel/Output/HTML/ToolBar/IncompleteWorkingDays.pm
    $Self->{Translation}->{'Incomplete working days'} = '';

    # JS File: TimeAccounting.Agent.EditTimeRecords
    $Self->{Translation}->{'Please choose at least one day!'} = 'Tafadhali chagua japo siku moja';
    $Self->{Translation}->{'Mass Entry'} = 'Ingizo la pamoja';
    $Self->{Translation}->{'Please choose a reason for absence!'} = 'Tafadhali chagua sababu ya kuto kuwepo!';

    # JS File: TimeAccounting.Agent
    $Self->{Translation}->{'Delete Time Accounting Entry'} = 'Futa ingizo la Uhasibu wa Muda';
    $Self->{Translation}->{'Confirm insert'} = 'Hakiki ingizo';

    # SysConfig
    $Self->{Translation}->{'Agent interface notification module to see the number of incomplete working days for the user.'} =
        'Moduli ya taarifa kwa kiolesura cha wakala kuona idadi ya siku za kazi za mtumiaji zisizo kamili.';
    $Self->{Translation}->{'Default name for new actions.'} = 'Jina la chaguo-msingi kwa vitendo vipya.';
    $Self->{Translation}->{'Default name for new projects.'} = 'Jina la chaguo-msingi kwa miradi mipya';
    $Self->{Translation}->{'Default setting for date end.'} = 'Chaguo-msingi kwa mipangilio ya tarehe ya kumaliza';
    $Self->{Translation}->{'Default setting for date start.'} = 'Chaguo-msingi kwa mipangilio ya tarehe ya kuanza.';
    $Self->{Translation}->{'Default setting for description.'} = 'Chaguo-msingi kwa mipangilio ya maelezo';
    $Self->{Translation}->{'Default setting for leave days.'} = 'Chaguo-msingi la siku za likizo';
    $Self->{Translation}->{'Default setting for overtime.'} = 'Chaguo-msingi la muda wa nyongeza';
    $Self->{Translation}->{'Default setting for the standard weekly hours.'} = 'Chaguo-msingi la mipangilio ya siku za kawaida za wiki';
    $Self->{Translation}->{'Default status for new actions.'} = 'Hali ya chaguo-msingi kwa vitendo vipya.';
    $Self->{Translation}->{'Default status for new projects.'} = 'Hali ya chaguo-msingi kwa miradi mipya.';
    $Self->{Translation}->{'Default status for new users.'} = 'Hali ya chaguo-msingi kwa watumiaji wapya.';
    $Self->{Translation}->{'Defines the projects for which a remark is required. If the RegExp matches on the project, you have to insert a remark too. The RegExp use the smx parameter.'} =
        'Inafafanua miradi ambayo maoni yanahitajika. Kama RegExp inafanana katika mradi, unatakiwa kuweka maoni pia. RegExp inatumia parameta ya smx';
    $Self->{Translation}->{'Determines if the statistics module may generate time accounting information.'} =
        'Inahakiki kama moduli ya takwimu inaweza kutengeneza taarifa ya uhasibu wa muda.';
    $Self->{Translation}->{'Edit time accounting settings.'} = '';
    $Self->{Translation}->{'Edit time record.'} = '';
    $Self->{Translation}->{'For how many days ago you can insert working units.'} = 'Kwa siku ngapi zilizopita unaweza kuingiza vitengo vya kazi.';
    $Self->{Translation}->{'If enabled, only users that has added working time to the selected project are shown.'} =
        'Kama imewezeshwa, watumiaji walioweka muda wa kazi kwa mradi uliochaguliwa ndio wataonyeshwa';
    $Self->{Translation}->{'If enabled, the dropdown elements in the edit screen are changed to modernized autocompletion fields.'} =
        '';
    $Self->{Translation}->{'If enabled, the filter for the previous projects can be used instead two list of projects (last and all ones). It could be used only if TimeAccounting::EnableAutoCompletion is enabled.'} =
        '';
    $Self->{Translation}->{'If enabled, the filter for the previous projects is active by default if there are the previous projects. It could be used only if EnableAutoCompletion and TimeAccounting::UseFilter are enabled.'} =
        '';
    $Self->{Translation}->{'If enabled, the user is allowed to enter "on vacation leave", "on sick leave" and "on overtime leave" to multiple dates at once.'} =
        'Kama imewezeshwa, mtumiaji anaruhusiwa kuingiza "kwenye likizo", "kwenye likizo ya wagonjwa", "kwenye likizo ya siku za nyongeza" kwa tarehe zaidi ya moja kwa mkupuo.';
    $Self->{Translation}->{'Maximum number of working days after which the working units have to be inserted.'} =
        'Kima cha juu cha siku za kazi baada ya vitengo vya kazi kuingizwa.';
    $Self->{Translation}->{'Maximum number of working days without working units entry after which a warning will be shown.'} =
        'Kima cha juu cha siku za kazi bila ya vitengo vya kazi kuingizwa ambavyo  onyo litaonyeshwa.';
    $Self->{Translation}->{'Overview.'} = '';
    $Self->{Translation}->{'Project time reporting.'} = '';
    $Self->{Translation}->{'Regular expressions for constraining action list according to selected project. Key contains regular expression for project(s), content contains regular expressions for action(s).'} =
        'Maneno ya kawaida yanayo kwamisha orodha ya vitendo kwa mradi uliochaguliwa. Ufunguo una maneno ya kawaida ya mradi (miradi), maudhui yana maneno ya kawaida ya kitendo (vitendo). ';
    $Self->{Translation}->{'Regular expressions for constraining project list according to user groups. Key contains regular expression for project(s), content contains comma separated list of groups.'} =
        'Maneno ya kawaida ya kuzuia orodha ya mradi kuendana na makundi ya watumiaji. Ufunguo una maneno ya kawaida ya mradi (miradi), maudhui yana makundi yaliyogawanywa kwa alama ya mkato.';
    $Self->{Translation}->{'Specifies if working hours can be inserted without start and end times.'} =
        'Inabainisha kama masaa ya kazi yanaweza kuingizwa bila ya muda wa kuanza na kumaliza.';
    $Self->{Translation}->{'This module forces inserts in TimeAccounting.'} = 'Hii moduli inaingiza Uhasibu wa Muda';
    $Self->{Translation}->{'This notification module gives a warning if there are too many incomplete working days.'} =
        'Hii moduli ya taarifa inatoa onyo endapo kuna siku nyingi za kazi ambazo hazijakamilika.';
    $Self->{Translation}->{'Time Accounting'} = 'Uhasibu wa muda';
    $Self->{Translation}->{'Time accounting edit.'} = 'Hariri uhasibu wa muda.';
    $Self->{Translation}->{'Time accounting overview.'} = 'Mapitio ya uhasibu wa muda.';
    $Self->{Translation}->{'Time accounting reporting.'} = 'Uarifu wa uhasibu wa muda.';
    $Self->{Translation}->{'Time accounting settings.'} = 'Mpangilio wa uhasibu wa muda.';
    $Self->{Translation}->{'Time accounting view.'} = 'Muonekano wa uhasibu wa muda ';
    $Self->{Translation}->{'Time accounting.'} = 'Uhasibu wa muda';
    $Self->{Translation}->{'To use if some actions reduced the working hours (for example, if only half of the traveling time is paid Key => traveling; Content => 50).'} =
        'Itatumika kama baadhi ya vitendo vitapunguza muda wa kazi (mfano, kama nusu ya muda wa kusafiri umelipwa Ufonguo=> kusafiri; maudhui=> 50).';


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
