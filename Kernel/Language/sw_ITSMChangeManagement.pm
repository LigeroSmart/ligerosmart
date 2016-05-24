# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::sw_ITSMChangeManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAITSMChangeManagement
    $Self->{Translation}->{'ITSMChange'} = 'BadiliITSM';
    $Self->{Translation}->{'ITSMChanges'} = 'MabadilikoITSM';
    $Self->{Translation}->{'ITSM Changes'} = 'Mabadiliko ya ITSM';
    $Self->{Translation}->{'workorder'} = 'oda ya kazi';
    $Self->{Translation}->{'A change must have a title!'} = 'Mabadiliko lazima yawe na kichwa cha habari!';
    $Self->{Translation}->{'A condition must have a name!'} = 'Sharti lazima liwe na jina!';
    $Self->{Translation}->{'A template must have a name!'} = 'Kiolezo lazima kiwe na jina!';
    $Self->{Translation}->{'A workorder must have a title!'} = 'Oda ya kazi lazima iwe na kichwa cha habari!';
    $Self->{Translation}->{'Add CAB Template'} = 'Ongeza kiolezo cha CAB';
    $Self->{Translation}->{'Add Workorder'} = 'Ongeza Oda ya kazi';
    $Self->{Translation}->{'Add a workorder to the change'} = 'Ongeza  oda ya kazi kwenye mabadiliko';
    $Self->{Translation}->{'Add new condition and action pair'} = 'Ongeza sharti jipya na kazi';
    $Self->{Translation}->{'Agent interface module to show the ChangeManager overview icon.'} =
        'Moduli ya kiolesura cha wakala kuonyesha ikoni ya mapitio ya MenejaMabadiliko.';
    $Self->{Translation}->{'Agent interface module to show the MyCAB overview icon.'} = 'Moduli ya kiolesura cha wakala kuonyesha ikoni ya mapitio ya CABYangu.';
    $Self->{Translation}->{'Agent interface module to show the MyChanges overview icon.'} = 'Moduli ya kiolesura cha wakala kuonyesha ikoni ya mapitio ya MabadilikoYangu.';
    $Self->{Translation}->{'Agent interface module to show the MyWorkOrders overview icon.'} =
        'Moduli ya kiolesura cha wakala kuonyesha ikoni ya mapitio ya OdaZanguzaKazi.';
    $Self->{Translation}->{'CABAgents'} = 'MawakalaCAB';
    $Self->{Translation}->{'CABCustomers'} = 'WatejaCAB';
    $Self->{Translation}->{'Change Overview'} = 'Mapitio ya Mabadiliko';
    $Self->{Translation}->{'Change Schedule'} = 'Badili Ratiba';
    $Self->{Translation}->{'Change involved persons of the change'} = 'Mabadiliko yanayohusisha watu wa mabadiliko';
    $Self->{Translation}->{'ChangeHistory::ActionAdd'} = 'BadiliHistoria::OngezaKitendo';
    $Self->{Translation}->{'ChangeHistory::ActionAddID'} = 'BadiliHistoria::KitambulishoOngezaKitendo';
    $Self->{Translation}->{'ChangeHistory::ActionDelete'} = 'BadiliHistoria::FutaKitendo';
    $Self->{Translation}->{'ChangeHistory::ActionDeleteAll'} = 'BadiliHistoria::FutaHistoriaZote';
    $Self->{Translation}->{'ChangeHistory::ActionExecute'} = 'BadiliHistoria::TekelezaKitendo';
    $Self->{Translation}->{'ChangeHistory::ActionUpdate'} = 'BadiliHistoria::SasishaKitendo';
    $Self->{Translation}->{'ChangeHistory::ChangeActualEndTimeReached'} = 'BadiliHistoria::BadiliMudaKumalizaUmefikiwa';
    $Self->{Translation}->{'ChangeHistory::ChangeActualStartTimeReached'} = 'BadiliHistoria::BadiliMudaKuanzaUmefikiwa';
    $Self->{Translation}->{'ChangeHistory::ChangeAdd'} = 'BadiliHistoria::OngezaMabadiliko';
    $Self->{Translation}->{'ChangeHistory::ChangeAttachmentAdd'} = 'BadiliHistoria::BadiliKiambatanishoOngeza';
    $Self->{Translation}->{'ChangeHistory::ChangeAttachmentDelete'} = 'BadiliHistoria::BadiliKiambatanishoFuta';
    $Self->{Translation}->{'ChangeHistory::ChangeCABDelete'} = 'BadiliHistoria::BadiliCABFuta';
    $Self->{Translation}->{'ChangeHistory::ChangeCABUpdate'} = 'BadiliHistoria::BadiliCABFuta';
    $Self->{Translation}->{'ChangeHistory::ChangeLinkAdd'} = 'BadiliHistoria::BadiliKiungoOngeza';
    $Self->{Translation}->{'ChangeHistory::ChangeLinkDelete'} = 'BadiliHistoria::BadiliKiungoFuta';
    $Self->{Translation}->{'ChangeHistory::ChangeNotificationSent'} = 'BadiliHistoria::BadiliTaarifaImetumwa';
    $Self->{Translation}->{'ChangeHistory::ChangePlannedEndTimeReached'} = 'BadiliHistoria::BadiliMudaUliopangwaKumalizaUmefikiwa';
    $Self->{Translation}->{'ChangeHistory::ChangePlannedStartTimeReached'} = 'BadiliHistoria::BadiliMudaUliopangwaKunzaUmefikiwa';
    $Self->{Translation}->{'ChangeHistory::ChangeRequestedTimeReached'} = 'BadiliHistoria::BadiliMudaUlioombwaUmefikiwa';
    $Self->{Translation}->{'ChangeHistory::ChangeUpdate'} = 'BadiliHistoria::BadiliKisasisho';
    $Self->{Translation}->{'ChangeHistory::ConditionAdd'} = 'BadiliHistoria::Sharti';
    $Self->{Translation}->{'ChangeHistory::ConditionAddID'} = 'BadiliHistoria::ShartiOngezaKitambulisho';
    $Self->{Translation}->{'ChangeHistory::ConditionDelete'} = 'BadiliHistoria::ShartiFuta';
    $Self->{Translation}->{'ChangeHistory::ConditionDeleteAll'} = 'BadiliHistoria::ShartiFutaZote';
    $Self->{Translation}->{'ChangeHistory::ConditionUpdate'} = 'BadiliHistoria::ShartiSasisha';
    $Self->{Translation}->{'ChangeHistory::ExpressionAdd'} = 'BadiliHistoria::UsemiOngeza';
    $Self->{Translation}->{'ChangeHistory::ExpressionAddID'} = 'BadiliHistoria::UsemiOngezaKitambulisho';
    $Self->{Translation}->{'ChangeHistory::ExpressionDelete'} = 'BadiliHistoria::UsemiFuta';
    $Self->{Translation}->{'ChangeHistory::ExpressionDeleteAll'} = 'BadiliHistoria::UsemiFutaZote';
    $Self->{Translation}->{'ChangeHistory::ExpressionUpdate'} = 'BadiliHistoria::UsemiSasisha';
    $Self->{Translation}->{'ChangeNumber'} = 'BadiliNambari';
    $Self->{Translation}->{'Condition Edit'} = 'Sharti Hariri';
    $Self->{Translation}->{'Create Change'} = 'Tengeneza Mabadiliko';
    $Self->{Translation}->{'Create a change from this ticket!'} = 'Tengeneza Mabadiliko kutoka kwenye hii tiketi!';
    $Self->{Translation}->{'Delete Workorder'} = 'Futa Oda ya kazi';
    $Self->{Translation}->{'Edit the change'} = 'Hariri mabadiliko';
    $Self->{Translation}->{'Edit the conditions of the change'} = 'Hariri masharti ya mabadiliko';
    $Self->{Translation}->{'Edit the workorder'} = 'Hariri oda ya kazi';
    $Self->{Translation}->{'Expression'} = 'Usemi';
    $Self->{Translation}->{'Full-Text Search in Change and Workorder'} = 'Tafuta Nakala-Kamili katika Mabadiliko na Oda ya kazi';
    $Self->{Translation}->{'ITSMCondition'} = 'MashartiITSM';
    $Self->{Translation}->{'ITSMWorkOrder'} = 'ITSMOdaYaKazi';
    $Self->{Translation}->{'Link another object to the change'} = 'Unganisha kitu kingine kwenye mabadiliko';
    $Self->{Translation}->{'Link another object to the workorder'} = 'Unganisha kitu kingine kwenye oda ya kazi';
    $Self->{Translation}->{'Move all workorders in time'} = 'Hamisha oda zote za kazi kwa muda';
    $Self->{Translation}->{'My CABs'} = 'CAB zangu';
    $Self->{Translation}->{'My Changes'} = 'Mabadiliko Yangu';
    $Self->{Translation}->{'My Workorders'} = 'Oda zangu za kazi';
    $Self->{Translation}->{'No XXX settings'} = 'Hakuna mipangilio XXX';
    $Self->{Translation}->{'PIR (Post Implementation Review)'} = 'Baada ya utekelezaji wa mapitio (PIR)';
    $Self->{Translation}->{'PSA (Projected Service Availability)'} = 'Makadirio huduma upatikanaji (PSA)';
    $Self->{Translation}->{'Please select first a catalog class!'} = 'Tafadhali chagua tabaka la kwanza la katalogi!';
    $Self->{Translation}->{'Print the change'} = 'Chapisha mabadiliko';
    $Self->{Translation}->{'Print the workorder'} = 'Chapisha oda ya kazi';
    $Self->{Translation}->{'RequestedTime'} = 'MudaUlioombwa';
    $Self->{Translation}->{'Save Change CAB as Template'} = 'Hifadhi Mabadiliko ya CAB kama Kiolezo';
    $Self->{Translation}->{'Save change as a template'} = 'Hifadhi mabadiliko kama kiolezo';
    $Self->{Translation}->{'Save workorder as a template'} = 'Hifadhi oda ya kazi kama kiolezo';
    $Self->{Translation}->{'Search Changes'} = 'Tafuta Mabadiliko';
    $Self->{Translation}->{'Set the agent for the workorder'} = 'Seti wakala kwa oda ya kazi';
    $Self->{Translation}->{'Take Workorder'} = 'Chukua Oda ya kazi';
    $Self->{Translation}->{'Take the workorder'} = 'Chukua oda ya kazi';
    $Self->{Translation}->{'Template Overview'} = 'Mapitio ya Kiolezo';
    $Self->{Translation}->{'The planned end time is invalid!'} = 'Muda wa kumaliza uliopangwa ni batili!';
    $Self->{Translation}->{'The planned start time is invalid!'} = 'Muda wa kuanza uliopangwa ni batili!';
    $Self->{Translation}->{'The planned time is invalid!'} = 'Muda uliopangwa ni batili!';
    $Self->{Translation}->{'The requested time is invalid!'} = 'Muda ulioombwa ni batili!';
    $Self->{Translation}->{'New (from template)'} = 'Mpya (kutoka kwenye kiolezo)';
    $Self->{Translation}->{'Add from template'} = 'Ongeza kutoka kwenye kiolezo';
    $Self->{Translation}->{'Add Workorder (from template)'} = 'Ongeza Oda ya kazi (kutoka kwenye kiolezo)';
    $Self->{Translation}->{'Add a workorder (from template) to the change'} = 'Ongeza oda ya kazi (kutoka kwenye kiolezo) kwenye mabadiliko';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualEndTimeReached'} = 'OdaYaKaziHistoria::OdaYaKaziMudaHalisiKumalizaUmefikiwa';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualEndTimeReachedWithWorkOrderID'} =
        'OdaYaKaziHistoria::OdaYaKaziMudaHalisiKumalizaUmefikiwaWenyeKitambulishoChaOdaYaKazi';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualStartTimeReached'} = 'OdaYaKaziHistoria::OdaYaKaziMudaHalisiKunzaUmefikiwa';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualStartTimeReachedWithWorkOrderID'} =
        'OdaYaKaziHistoria::OdaYaKaziMudaHalisiKunzaUmefikiwaWenyeKitambulishoChaOdaYaKazi';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAdd'} = 'OdaYaKaziHistoria::OdaYaKaziOngeza';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAddWithWorkOrderID'} = 'OdaYaKaziHistoria::OdaYaKaziOngezaYenyeKitambulishoChaOdaYaKazi';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentAdd'} = 'OdaYaKaziHistoria::OdaYaKaziKiambatanishoOngeza';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentAddWithWorkOrderID'} = 'OdaYaKaziHistoria::OdaYaKaziKiambatanishoOngezaYenyeKitambulishoChaOdaYaKazi';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentDelete'} = 'OdaYaKaziHistoria::OdaYaKaziKiambatanishoFuta';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentDeleteWithWorkOrderID'} = 'OdaYaKaziHistoria::OdaYaKaziKiambatanishoFutaYenyeKitambulishoChaOdaYaKazi';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentAdd'} = 'OdaYaKaziHistoria::OdaYaKaziOngezaKiambatanishoChaRipoti';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentAddWithWorkOrderID'} =
        'OdaYaKaziHistoria::OdaYaKaziOngezaKiambatanishoChaRipotiChenyeKitambulishoChaOdaYaKazi';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentDelete'} = 'OdaYaKaziHistoria::OdaYaKaziFutaKiambatanishoChaRipoti';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentDeleteWithWorkOrderID'} =
        'OdaYaKaziHistoria::OdaYaKaziFutaKiambatanishoChaRipotiChenyeKitambulishoChaOdaYaKazi';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderDelete'} = 'OdaYaKaziHistoria::OdaYaKaziFuta';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderDeleteWithWorkOrderID'} = 'OdaYaKaziHistoria::OdaYaKaziFutaYenyeKitambulishoChaOdaYaKazi';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkAdd'} = 'OdaYaKaziHistoria::OdaYaKaziOngezaKiungo';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkAddWithWorkOrderID'} = 'OdaYaKaziHistoria::OdaYaKaziOngezaKiungoChenyeKitambulishoChaOdaYaKazi';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkDelete'} = 'OdaYaKaziHistoria::OdaYaKaziFutaKiungo';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkDeleteWithWorkOrderID'} = 'OdaYaKaziHistoria::OdaYaKaziFutaKiungoChenyeKitambulishoChaOdaYaKazi';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderNotificationSent'} = 'OdaYaKaziHistoria::OdaYaKaziTaarifaImetumwa';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderNotificationSentWithWorkOrderID'} = 'OdaYaKaziHistoria::OdaYaKaziTaarifaImetumwaYenyeKitambulishoChaOdaYaKazi';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedEndTimeReached'} = 'OdaYaKaziHistoria::OdaYaKaziMudaKumalizaUliopangwaUmefikiwa';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedEndTimeReachedWithWorkOrderID'} =
        'OdaYaKaziHistoria::OdaYaKaziMudaKumalizaUliopangwaUmefikiwaWenyeKitambulishoChaOdaYaKazi';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedStartTimeReached'} = 'OdaYaKaziHistoria::OdaYaKaziMudaKuanzaUliopangwaUmefikiwa';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedStartTimeReachedWithWorkOrderID'} =
        'OdaYaKaziHistoria::OdaYaKaziMudaKuanzaUliopangwaUmefikiwaWenyeKitambulishoChaOdaYaKazi';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderUpdate'} = 'OdaYaKaziHistoria::OdaYaKaziSasisha';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderUpdateWithWorkOrderID'} = 'OdaYaKaziHistoria::OdaYaKaziSasishaYenyeKitambulishoChaOdaYaKazi';
    $Self->{Translation}->{'WorkOrderNumber'} = 'NambariYaOdaYaKazi';
    $Self->{Translation}->{'accepted'} = 'kubaliwa';
    $Self->{Translation}->{'any'} = 'yoyote';
    $Self->{Translation}->{'approval'} = 'kibali';
    $Self->{Translation}->{'approved'} = 'kubaliwa';
    $Self->{Translation}->{'backout'} = 'kujitoa';
    $Self->{Translation}->{'begins with'} = 'inaanza na';
    $Self->{Translation}->{'canceled'} = 'sitishwa';
    $Self->{Translation}->{'contains'} = 'vyenye';
    $Self->{Translation}->{'created'} = 'tengenezwa';
    $Self->{Translation}->{'decision'} = 'maamuzi';
    $Self->{Translation}->{'ends with'} = 'inaishia na';
    $Self->{Translation}->{'failed'} = 'Shindwa';
    $Self->{Translation}->{'in progress'} = 'kwenye maendeleo';
    $Self->{Translation}->{'is'} = 'ni';
    $Self->{Translation}->{'is after'} = 'ni baada';
    $Self->{Translation}->{'is before'} = 'ni kabla';
    $Self->{Translation}->{'is empty'} = 'ni tupu';
    $Self->{Translation}->{'is greater than'} = 'ni kubwa zaidi ya';
    $Self->{Translation}->{'is less than'} = 'ni ndogo zaidi ya';
    $Self->{Translation}->{'is not'} = 'siyo';
    $Self->{Translation}->{'is not empty'} = 'siyo tupu';
    $Self->{Translation}->{'not contains'} = 'haina kitu';
    $Self->{Translation}->{'pending approval'} = 'kibali kinasubiri';
    $Self->{Translation}->{'pending pir'} = 'pir inasubiri';
    $Self->{Translation}->{'pir'} = 'baada ya utekelezaji wa mapitio';
    $Self->{Translation}->{'ready'} = 'tayari';
    $Self->{Translation}->{'rejected'} = 'kataliwa';
    $Self->{Translation}->{'requested'} = 'ombwa';
    $Self->{Translation}->{'retracted'} = 'ondoa';
    $Self->{Translation}->{'set'} = 'seti';
    $Self->{Translation}->{'successful'} = 'mafanikio';

    # Template: AdminITSMChangeCIPAllocate
    $Self->{Translation}->{'Category <-> Impact <-> Priority'} = 'Kategoria<-> Athari<-> Kipaumbele';
    $Self->{Translation}->{'Manage the priority result of combinating Category <-> Impact.'} =
        'Simamia matokeo ya kipaumbele cha Kategoria zinazochanganywa <-> Athari.';
    $Self->{Translation}->{'Priority allocation'} = 'Utengaji wa kipaumbele';

    # Template: AdminITSMChangeNotification
    $Self->{Translation}->{'ITSM ChangeManagement Notification Management'} = 'Usimamizi wa Taarifa za ITSM UsimamiziMabadiliko';
    $Self->{Translation}->{'Add Notification Rule'} = 'Ongeza Sheria ya Taarifa';
    $Self->{Translation}->{'Rule'} = 'Sheria';
    $Self->{Translation}->{'A notification should have a name!'} = 'Taarifa lazima iwe na jina!';
    $Self->{Translation}->{'Name is required.'} = 'Jina linatakiwa.';

    # Template: AdminITSMStateMachine
    $Self->{Translation}->{'Admin State Machine'} = 'Mashine ya Hali ya Msimamizi';
    $Self->{Translation}->{'Select a catalog class!'} = 'Chagua tabaka la katalogi!';
    $Self->{Translation}->{'A catalog class is required!'} = 'Tabaka la katalogi linatakiwa!';
    $Self->{Translation}->{'Add a state transition'} = 'Ongeza mpito wa hali';
    $Self->{Translation}->{'Catalog Class'} = 'Tabaka Katalogi';
    $Self->{Translation}->{'Object Name'} = 'Jina la Kitu';
    $Self->{Translation}->{'Overview over state transitions for'} = 'Mapitio ya mapito ya hali ya';
    $Self->{Translation}->{'Delete this state transition'} = 'Futa hali hii ya mpito';
    $Self->{Translation}->{'Add a new state transition for'} = 'Ongeza hali mpya ya mpito ya';
    $Self->{Translation}->{'Please select a state!'} = 'Tafadhali chagua hali!';
    $Self->{Translation}->{'Please select a next state!'} = 'Tafadhali chagua hali inayofuata!';
    $Self->{Translation}->{'Edit a state transition for'} = 'Hariri hali ya mpito ya';
    $Self->{Translation}->{'Do you really want to delete the state transition'} = 'Kweli unataka kufuta hali ya mpito';
    $Self->{Translation}->{'from'} = 'kutoka';
    $Self->{Translation}->{'to'} = '';

    # Template: AgentITSMChangeAdd
    $Self->{Translation}->{'Add Change'} = 'Ongeza Mabadiliko';
    $Self->{Translation}->{'ITSM Change'} = 'Mabadiliko ya ITSM';
    $Self->{Translation}->{'Justification'} = 'Uhalali';
    $Self->{Translation}->{'Input invalid.'} = 'Ingizo batili.';
    $Self->{Translation}->{'Impact'} = 'Athari';
    $Self->{Translation}->{'Requested Date'} = 'Tarehe Iliyoombwa';

    # Template: AgentITSMChangeAddFromTemplate
    $Self->{Translation}->{'Select Change Template'} = 'Chagua Badili Kiolezo';
    $Self->{Translation}->{'Time type'} = 'Aina ya muda';
    $Self->{Translation}->{'Invalid time type.'} = 'Aina batili ya muda.';
    $Self->{Translation}->{'New time'} = 'Mda mpya';

    # Template: AgentITSMChangeCABTemplate
    $Self->{Translation}->{'Save Change CAB as template'} = 'Hifadhi Mabadiliko ya CAB kama kiolezo';
    $Self->{Translation}->{'go to involved persons screen'} = 'nenda kwenye skrini ya watu wanaohusika';
    $Self->{Translation}->{'Invalid Name'} = 'Jina Batili';

    # Template: AgentITSMChangeCondition
    $Self->{Translation}->{'Conditions and Actions'} = 'Masharti na Vitendo';
    $Self->{Translation}->{'Delete Condition'} = 'Futa Sharti';
    $Self->{Translation}->{'Add new condition'} = 'Ongeza sharti jipya';

    # Template: AgentITSMChangeConditionEdit
    $Self->{Translation}->{'Need a valid name.'} = 'Inahitaji jina halali.';
    $Self->{Translation}->{'A valid name is needed.'} = '';
    $Self->{Translation}->{'Duplicate name:'} = 'Jina limejirudia:';
    $Self->{Translation}->{'This name is already used by another condition.'} = 'Hili jina tayari limetumika na sharti jingine.';
    $Self->{Translation}->{'Matching'} = 'Lingana';
    $Self->{Translation}->{'Any expression (OR)'} = 'Usemi wowote (AU)';
    $Self->{Translation}->{'All expressions (AND)'} = 'Smi zote (NA)';
    $Self->{Translation}->{'Expressions'} = 'Semi';
    $Self->{Translation}->{'Selector'} = 'Kiteuzi';
    $Self->{Translation}->{'Operator'} = 'Opereta';
    $Self->{Translation}->{'Delete Expression'} = 'Futa Usemi';
    $Self->{Translation}->{'No Expressions found.'} = 'Hakuna Semi zilizopatikana.';
    $Self->{Translation}->{'Add new expression'} = 'Ongeza usemi mpya';
    $Self->{Translation}->{'Delete Action'} = 'Futa Kitendo';
    $Self->{Translation}->{'No Actions found.'} = 'Hakuna vitendo vilivyopatikana.';
    $Self->{Translation}->{'Add new action'} = 'Ongeza kitendo kipya';

    # Template: AgentITSMChangeDelete
    $Self->{Translation}->{'Do you really want to delete this change?'} = 'Kweli unataka kufuta mabadiliko haya?';

    # Template: AgentITSMChangeHistory
    $Self->{Translation}->{'History of'} = '';
    $Self->{Translation}->{'Workorder'} = 'Oda ya kazi';
    $Self->{Translation}->{'Show details'} = 'Onyesha undani';
    $Self->{Translation}->{'Show workorder'} = 'Onyesha oda ya kazi';

    # Template: AgentITSMChangeHistoryZoom
    $Self->{Translation}->{'Detailed history information of'} = 'Undani wa taarifa ya historia ya';
    $Self->{Translation}->{'Modified'} = 'Rekebishwa';
    $Self->{Translation}->{'Old Value'} = 'Thamani ya Zamani';
    $Self->{Translation}->{'New Value'} = 'Thamani Mpya';

    # Template: AgentITSMChangeInvolvedPersons
    $Self->{Translation}->{'Involved Persons'} = 'Watu waliohusika';
    $Self->{Translation}->{'ChangeManager'} = 'MenejaMabadiliko';
    $Self->{Translation}->{'User invalid.'} = 'Mtumiaji batili.';
    $Self->{Translation}->{'ChangeBuilder'} = 'MjenziMabadiliko';
    $Self->{Translation}->{'Change Advisory Board'} = 'Bodi ya Ushauri ya Mabadiliko';
    $Self->{Translation}->{'CAB Template'} = 'Kiolezo cha CAB';
    $Self->{Translation}->{'Apply Template'} = 'Omba Kiolezo';
    $Self->{Translation}->{'NewTemplate'} = 'Kiolezo Kipya';
    $Self->{Translation}->{'Save this CAB as template'} = 'Hifadhi hii CAB kama kiolezo';
    $Self->{Translation}->{'Add to CAB'} = 'Ongeza kwa CAB';
    $Self->{Translation}->{'Invalid User'} = 'Mtumiaji Batili';
    $Self->{Translation}->{'Current CAB'} = 'CAB ya sasa';

    # Template: AgentITSMChangeOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = 'Mipangilio ya Muktadha';
    $Self->{Translation}->{'Changes per page'} = 'Mabadiliko kwa kurasa';

    # Template: AgentITSMChangeOverviewSmall
    $Self->{Translation}->{'WorkOrderTitle'} = 'Kichwa cha habari cha Oda ya Kazi';
    $Self->{Translation}->{'ChangeTitle'} = 'Badili Kicha cha Habari';
    $Self->{Translation}->{'WorkOrderAgent'} = 'WakalaWaOdaYaKazi';
    $Self->{Translation}->{'Workorders'} = 'Oda za kazi';
    $Self->{Translation}->{'ChangeState'} = 'BadiliHali';
    $Self->{Translation}->{'WorkOrderState'} = 'HaliYaOdaYaKazi';
    $Self->{Translation}->{'WorkOrderType'} = 'AinaYaOdaYaKazi';
    $Self->{Translation}->{'Requested Time'} = 'Muda Ulioombwa';
    $Self->{Translation}->{'PlannedStartTime'} = 'MudaKuanzaUliopangwa';
    $Self->{Translation}->{'PlannedEndTime'} = 'MudaKuishaUliopangwa';
    $Self->{Translation}->{'ActualStartTime'} = 'MudaHalisiKuanza';
    $Self->{Translation}->{'ActualEndTime'} = 'MudaHalisiKumaliza';

    # Template: AgentITSMChangeReset
    $Self->{Translation}->{'Do you really want to reset this change?'} = 'Kweli unataka kuweka upya mabadiliko haya?';

    # Template: AgentITSMChangeSearch
    $Self->{Translation}->{'(e.g. 10*5155 or 105658*)'} = '(mf. 10*5155 au 105658*)';
    $Self->{Translation}->{'CABAgent'} = 'WakalaCAB';
    $Self->{Translation}->{'e.g.'} = 'mf.';
    $Self->{Translation}->{'CABCustomer'} = 'MtejaCAB';
    $Self->{Translation}->{'ITSM Workorder'} = 'Oda ya kazi ya ITSM';
    $Self->{Translation}->{'Instruction'} = 'Melekezo';
    $Self->{Translation}->{'Report'} = 'Ripoti';
    $Self->{Translation}->{'Change Category'} = 'Badili Kategoria';
    $Self->{Translation}->{'(before/after)'} = '(kabla/baada)';
    $Self->{Translation}->{'(between)'} = '(katikati)';

    # Template: AgentITSMChangeTemplate
    $Self->{Translation}->{'Save Change as Template'} = 'Hifadhi Mabadiliko kama Kiolezo';
    $Self->{Translation}->{'A template should have a name!'} = 'Kiolezo lazima kiwe na jina!';
    $Self->{Translation}->{'The template name is required.'} = 'Jina la kiolezo linahitajika.';
    $Self->{Translation}->{'Reset States'} = 'Seti Upya Hali';
    $Self->{Translation}->{'Overwrite original template'} = 'Andika juu ya kiolezo halisi';
    $Self->{Translation}->{'Delete original change'} = 'Futa mabadiliko halisi';

    # Template: AgentITSMChangeTimeSlot
    $Self->{Translation}->{'Move Time Slot'} = 'Sogeza Kipengele cha Muda';

    # Template: AgentITSMChangeZoom
    $Self->{Translation}->{'Change Information'} = 'Badili Taarifa';
    $Self->{Translation}->{'PlannedEffort'} = 'JuhudiIliyopangwa';
    $Self->{Translation}->{'Change Initiator(s)'} = 'Badili Vianzishi';
    $Self->{Translation}->{'Change Manager'} = 'Meneja Mabadiliko';
    $Self->{Translation}->{'Change Builder'} = 'Meneja Mjenzi';
    $Self->{Translation}->{'CAB'} = 'CAB';
    $Self->{Translation}->{'Last changed'} = 'Mara ya mwisho imebadilishwa';
    $Self->{Translation}->{'Last changed by'} = 'Mara ya mwisho imebadilishwa na';
    $Self->{Translation}->{'Ok'} = 'Sawa';
    $Self->{Translation}->{'To open links in the following description blocks, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).'} =
        '';
    $Self->{Translation}->{'Download Attachment'} = 'Pakua Kiambatanisho';

    # Template: AgentITSMTemplateDelete
    $Self->{Translation}->{'Do you really want to delete this template?'} = 'Kweli uanataka kufuta hiki kiolezo?';

    # Template: AgentITSMTemplateEditCAB
    $Self->{Translation}->{'Edit CAB Template'} = 'Hariri kiolezo cha CAB';

    # Template: AgentITSMTemplateEditContent
    $Self->{Translation}->{'This will create a new change from this template, so you can edit and save it.'} =
        'Hii itatengeneza mabadiliko mapya kutoka kwenye hiki kiolezo, ili uweze kuhariri na kuhifadhi.';
    $Self->{Translation}->{'The new change will be deleted automatically after it has been saved as template.'} =
        'Mabadiliko mapya yatafutwa kiotomatiki baada ya kuhifadhiwa kama kiolezo.';
    $Self->{Translation}->{'This will create a new workorder from this template, so you can edit and save it.'} =
        'Hii itatengeneza oda mpya ya kazi kutoka kwenye kiolezo hiki, ili uweze kuihariri na kuihifadhi.';
    $Self->{Translation}->{'A temporary change will be created which contains the workorder.'} =
        'Mabadiliko ya muda yatatengenezwa yenye oda ya kazi.';
    $Self->{Translation}->{'The temporary change and new workorder will be deleted automatically after the workorder has been saved as template.'} =
        'Mabadiliko ya muda na oda ya kazi mpya yatafutwa kiotomatiki baada ya oda ya kazi kuhifadhiwa kama kiolezo.';
    $Self->{Translation}->{'Do you want to proceed?'} = 'Unataka kuendelea?';

    # Template: AgentITSMTemplateOverviewSmall
    $Self->{Translation}->{'TemplateID'} = 'Kitambulisho cha Kiolezo';
    $Self->{Translation}->{'Edit Content'} = 'Hariri Maudhui';
    $Self->{Translation}->{'CreateBy'} = 'TengenezaNa';
    $Self->{Translation}->{'CreateTime'} = 'TengenezaMuda';
    $Self->{Translation}->{'ChangeBy'} = 'BadiliNa';
    $Self->{Translation}->{'ChangeTime'} = 'BadilishaMuda';
    $Self->{Translation}->{'Edit Template Content'} = 'Hariri Maudhui ya Kiolezo';
    $Self->{Translation}->{'Delete Template'} = 'Futa Kiolezo';

    # Template: AgentITSMWorkOrderAdd
    $Self->{Translation}->{'Add Workorder to'} = 'Ongeza Oda ya kazi kwenye';
    $Self->{Translation}->{'Invalid workorder type.'} = 'Aina batili ya oda ya kazi';
    $Self->{Translation}->{'The planned start time must be before the planned end time!'} = 'Muda uliopangwa wa kuanza unatakiwa kuwa kabla ya muda uliopangwa wa kumaliza!';
    $Self->{Translation}->{'Invalid format.'} = 'Umbizo batili.';

    # Template: AgentITSMWorkOrderAddFromTemplate
    $Self->{Translation}->{'Select Workorder Template'} = 'Chagua Kiolezo cha Oda ya kazi';

    # Template: AgentITSMWorkOrderDelete
    $Self->{Translation}->{'Do you really want to delete this workorder?'} = 'Kweli unataka kufuta oda hii ya kazi?';
    $Self->{Translation}->{'You can not delete this Workorder. It is used in at least one Condition!'} =
        'Huwezi kufuta oda hii ya kazi. Inatumika japo kwenye sharti moja!';
    $Self->{Translation}->{'This Workorder is used in the following Condition(s)'} = 'Hii oda ya kazi inatumika kwenye Masharti yafuatayo.';

    # Template: AgentITSMWorkOrderEdit
    $Self->{Translation}->{'Move following workorders accordingly'} = 'Hamisha oda za kazi zifuatazo ipasavyo';
    $Self->{Translation}->{'If the planned end time of this workorder is changed, the planned start times of all following workorders will be changed accordingly'} =
        'Kama muda wa kumaliza wa oda ya kazi hii umebadilishwa, muda wa kuanza wa oda za kazi zote zinazofuata zitabadilika';

    # Template: AgentITSMWorkOrderReport
    $Self->{Translation}->{'The actual start time must be before the actual end time!'} = 'Muda halisi wa kuanza lazima uwe kabla ya muda halisi wa kumaliza!';
    $Self->{Translation}->{'The actual start time must be set, when the actual end time is set!'} =
        'Muda halisi wa kuanza lazima usetiwe, pale muda wa kumaliza umesetiwa!';

    # Template: AgentITSMWorkOrderTake
    $Self->{Translation}->{'Current Agent'} = 'Wakala wa sasa';
    $Self->{Translation}->{'Do you really want to take this workorder?'} = 'Kweli unataka kuchukua oda hii ya kazi?';

    # Template: AgentITSMWorkOrderTemplate
    $Self->{Translation}->{'Save Workorder as Template'} = 'Hifadhi Oda ya kazi kama Kiolezo';
    $Self->{Translation}->{'Delete original workorder (and surrounding change)'} = 'Futa oda halisi ya kazi (na mabadiliko yanayoizunguka)';

    # Template: AgentITSMWorkOrderZoom
    $Self->{Translation}->{'Workorder Information'} = 'Taarifa ya Oda ya kazi';

    # Perl Module: Kernel/Modules/AdminITSMChangeNotification.pm
    $Self->{Translation}->{'Unknown notification %s!'} = '';
    $Self->{Translation}->{'There was an error creating the notification.'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChange.pm
    $Self->{Translation}->{'Overview: ITSM Changes'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeAdd.pm
    $Self->{Translation}->{'Ticket with TicketID %s does not exist!'} = '';
    $Self->{Translation}->{'Missing sysconfig option "ITSMChange::AddChangeLinkTicketTypes"!'} =
        '';
    $Self->{Translation}->{'Was not able to add change!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeAddFromTemplate.pm
    $Self->{Translation}->{'Was not able to create change from template!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeCABTemplate.pm
    $Self->{Translation}->{'No ChangeID is given!'} = '';
    $Self->{Translation}->{'No change found for changeID %s.'} = '';
    $Self->{Translation}->{'The CAB of change "%s" could not be serialized.'} = '';
    $Self->{Translation}->{'Could not add the template.'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeCondition.pm
    $Self->{Translation}->{'Change "%s" not found in database!'} = '';
    $Self->{Translation}->{'Could not delete ConditionID %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeConditionEdit.pm
    $Self->{Translation}->{'No %s is given!'} = '';
    $Self->{Translation}->{'Could not create new condition!'} = '';
    $Self->{Translation}->{'Could not update ConditionID %s!'} = '';
    $Self->{Translation}->{'Could not update ExpressionID %s!'} = '';
    $Self->{Translation}->{'Could not add new Expression!'} = '';
    $Self->{Translation}->{'Could not update ActionID %s!'} = '';
    $Self->{Translation}->{'Could not add new Action!'} = '';
    $Self->{Translation}->{'Could not delete ExpressionID %s!'} = '';
    $Self->{Translation}->{'Could not delete ActionID %s!'} = '';
    $Self->{Translation}->{'Error: Unknown field type "%s"!'} = '';
    $Self->{Translation}->{'ConditionID %s does not belong to the given ChangeID %s!'} = '';
    $Self->{Translation}->{'Please contact the administrator.'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeDelete.pm
    $Self->{Translation}->{'Change "%s" does not have an allowed change state to be deleted!'} =
        '';
    $Self->{Translation}->{'Was not able to delete the changeID %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeEdit.pm
    $Self->{Translation}->{'Was not able to update Change!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeHistory.pm
    $Self->{Translation}->{'Can\'t show history, as no ChangeID is given!'} = '';
    $Self->{Translation}->{'Change "%s" not found in the database!'} = '';
    $Self->{Translation}->{'Unknown type "%s" encountered!'} = '';
    $Self->{Translation}->{'Change History'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeHistoryZoom.pm
    $Self->{Translation}->{'Can\'t show history zoom, no HistoryEntryID is given!'} = '';
    $Self->{Translation}->{'HistoryEntry "%s" not found in database!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeInvolvedPersons.pm
    $Self->{Translation}->{'Was not able to update Change CAB for Change %s!'} = '';
    $Self->{Translation}->{'Was not able to update Change %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeManager.pm
    $Self->{Translation}->{'Overview: ChangeManager'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeMyCAB.pm
    $Self->{Translation}->{'Overview: My CAB'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeMyChanges.pm
    $Self->{Translation}->{'Overview: My Changes'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeMyWorkOrders.pm
    $Self->{Translation}->{'Overview: My Workorders'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangePIR.pm
    $Self->{Translation}->{'Overview: PIR'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangePSA.pm
    $Self->{Translation}->{'Overview: PSA'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangePrint.pm
    $Self->{Translation}->{'WorkOrder "%s" not found in database!'} = '';
    $Self->{Translation}->{'Can\'t create output, as the workorder is not attached to a change!'} =
        '';
    $Self->{Translation}->{'Can\'t create output, as no ChangeID is given!'} = '';
    $Self->{Translation}->{'unknown change title'} = '';
    $Self->{Translation}->{'unknown workorder title'} = '';
    $Self->{Translation}->{'ITSM Workorder Overview (%s)'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeReset.pm
    $Self->{Translation}->{'Was not able to reset WorkOrder %s of Change %s!'} = '';
    $Self->{Translation}->{'Was not able to reset Change %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeSchedule.pm
    $Self->{Translation}->{'Overview: Change Schedule'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeSearch.pm
    $Self->{Translation}->{'Change Search'} = '';
    $Self->{Translation}->{'WorkOrders'} = 'Oda za kazi';
    $Self->{Translation}->{'Change Search Result'} = '';
    $Self->{Translation}->{'Change Number'} = '';
    $Self->{Translation}->{'Change Title'} = '';
    $Self->{Translation}->{'Work Order Title'} = '';
    $Self->{Translation}->{'CAB Agent'} = '';
    $Self->{Translation}->{'CAB Customer'} = '';
    $Self->{Translation}->{'Change Description'} = '';
    $Self->{Translation}->{'Change Justification'} = '';
    $Self->{Translation}->{'WorkOrder Instruction'} = '';
    $Self->{Translation}->{'WorkOrder Report'} = '';
    $Self->{Translation}->{'Change Priority'} = '';
    $Self->{Translation}->{'Change Impact'} = '';
    $Self->{Translation}->{'Change State'} = '';
    $Self->{Translation}->{'Created By'} = '';
    $Self->{Translation}->{'WorkOrder State'} = '';
    $Self->{Translation}->{'WorkOrder Type'} = '';
    $Self->{Translation}->{'WorkOrder Agent'} = '';
    $Self->{Translation}->{'Planned Start Time'} = '';
    $Self->{Translation}->{'Planned End Time'} = '';
    $Self->{Translation}->{'Actual Start Time'} = '';
    $Self->{Translation}->{'Actual End Time'} = '';
    $Self->{Translation}->{'Change Time'} = '';
    $Self->{Translation}->{'before'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeTemplate.pm
    $Self->{Translation}->{'The change "%s" could not be serialized.'} = '';
    $Self->{Translation}->{'Could not update the template "%s".'} = '';
    $Self->{Translation}->{'Could not delete change "%s".'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeTimeSlot.pm
    $Self->{Translation}->{'The change can\'t be moved, as it has no workorders.'} = '';
    $Self->{Translation}->{'Add a workorder first.'} = '';
    $Self->{Translation}->{'Can\'t move a change which already has started!'} = '';
    $Self->{Translation}->{'Please move the individual workorders instead.'} = '';
    $Self->{Translation}->{'The current %s could not be determined.'} = '';
    $Self->{Translation}->{'The %s of all workorders has to be defined.'} = '';
    $Self->{Translation}->{'Was not able to move time slot for workorder #%s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMTemplateDelete.pm
    $Self->{Translation}->{'You need %s permission!'} = '';
    $Self->{Translation}->{'No TemplateID is given!'} = '';
    $Self->{Translation}->{'Template "%s" not found in database!'} = '';
    $Self->{Translation}->{'Was not able to delete the template %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMTemplateEdit.pm
    $Self->{Translation}->{'Was not able to update Template %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMTemplateEditCAB.pm
    $Self->{Translation}->{'Was not able to update Template "%s"!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMTemplateEditContent.pm
    $Self->{Translation}->{'Was not able to create change!'} = '';
    $Self->{Translation}->{'Was not able to create workorder from template!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMTemplateOverview.pm
    $Self->{Translation}->{'Overview: Template'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderAdd.pm
    $Self->{Translation}->{'You need %s permissions on the change!'} = '';
    $Self->{Translation}->{'Was not able to add workorder!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderAgent.pm
    $Self->{Translation}->{'No WorkOrderID is given!'} = '';
    $Self->{Translation}->{'Was not able to set the workorder agent of the workorder "%s" to empty!'} =
        '';
    $Self->{Translation}->{'Was not able to update the workorder "%s"!'} = '';
    $Self->{Translation}->{'Could not find Change for WorkOrder %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderDelete.pm
    $Self->{Translation}->{'Was not able to delete the workorder %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderEdit.pm
    $Self->{Translation}->{'Was not able to update WorkOrder %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderHistory.pm
    $Self->{Translation}->{'Can\'t show history, as no WorkOrderID is given!'} = '';
    $Self->{Translation}->{'WorkOrder "%s" not found in the database!'} = '';
    $Self->{Translation}->{'WorkOrderHistory::'} = '';
    $Self->{Translation}->{'WorkOrder History'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderHistoryZoom.pm
    $Self->{Translation}->{'History entry "%s" not found in the database!'} = '';
    $Self->{Translation}->{'WorkOrder History Zoom'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderTake.pm
    $Self->{Translation}->{'Was not able to take the workorder %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderTemplate.pm
    $Self->{Translation}->{'The workorder "%s" could not be serialized.'} = '';

    # Perl Module: Kernel/Output/HTML/ToolBar/MyWorkOrders.pm
    $Self->{Translation}->{'My Work Orders'} = '';

}

1;
