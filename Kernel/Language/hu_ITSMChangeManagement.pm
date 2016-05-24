# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::hu_ITSMChangeManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAITSMChangeManagement
    $Self->{Translation}->{'ITSMChange'} = 'ITSM változás';
    $Self->{Translation}->{'ITSMChanges'} = 'ITSM változások';
    $Self->{Translation}->{'ITSM Changes'} = 'ITSM változások';
    $Self->{Translation}->{'workorder'} = 'munkamegrendelés';
    $Self->{Translation}->{'A change must have a title!'} = 'A változásnak rendelkeznie kell egy címmel!';
    $Self->{Translation}->{'A condition must have a name!'} = 'A feltételnek rendelkeznie kell egy névvel!';
    $Self->{Translation}->{'A template must have a name!'} = 'A sablonnak rendelkeznie kell egy névvel!';
    $Self->{Translation}->{'A workorder must have a title!'} = 'A munkamegrendelésnek rendelkeznie kell egy címmel!';
    $Self->{Translation}->{'Add CAB Template'} = 'CAB sablon hozzáadása';
    $Self->{Translation}->{'Add Workorder'} = 'Munkamegrendelés hozzáadása';
    $Self->{Translation}->{'Add a workorder to the change'} = 'Egy munkamegrendelés hozzáadása a változáshoz';
    $Self->{Translation}->{'Add new condition and action pair'} = 'Új feltétel és művelet pár hozzáadása';
    $Self->{Translation}->{'Agent interface module to show the ChangeManager overview icon.'} =
        'Ügyintézői felület modul a változásmenedzser áttekintő ikonjának megjelenítéséhez.';
    $Self->{Translation}->{'Agent interface module to show the MyCAB overview icon.'} = 'Ügyintézői felület modul a saját CAB áttekintő ikonjának megjelenítéséhez.';
    $Self->{Translation}->{'Agent interface module to show the MyChanges overview icon.'} = 'Ügyintézői felület modul a saját változások áttekintő ikonjának megjelenítéséhez.';
    $Self->{Translation}->{'Agent interface module to show the MyWorkOrders overview icon.'} =
        'Ügyintézői felület modul a saját munkamegrendelések áttekintő ikonjának megjelenítéséhez.';
    $Self->{Translation}->{'CABAgents'} = 'CAB ügyintézők';
    $Self->{Translation}->{'CABCustomers'} = 'CAB ügyfelek';
    $Self->{Translation}->{'Change Overview'} = 'Változás áttekintő';
    $Self->{Translation}->{'Change Schedule'} = 'Változásütemezés';
    $Self->{Translation}->{'Change involved persons of the change'} = 'A változás résztvevő személyeinek módosítása';
    $Self->{Translation}->{'ChangeHistory::ActionAdd'} = 'Változás előzmények::Hozzáadás művelet';
    $Self->{Translation}->{'ChangeHistory::ActionAddID'} = 'Változás előzmények::Azonosító hozzáadása művelet';
    $Self->{Translation}->{'ChangeHistory::ActionDelete'} = 'Változás előzmények::Törlés művelet';
    $Self->{Translation}->{'ChangeHistory::ActionDeleteAll'} = 'Változás előzmények::Összes törlése művelet';
    $Self->{Translation}->{'ChangeHistory::ActionExecute'} = 'Változás előzmények::Végrehajtás művelet';
    $Self->{Translation}->{'ChangeHistory::ActionUpdate'} = 'Változás előzmények::Frissítés művelet';
    $Self->{Translation}->{'ChangeHistory::ChangeActualEndTimeReached'} = 'Változás előzmények::Változás tényleges befejezési ideje elérve';
    $Self->{Translation}->{'ChangeHistory::ChangeActualStartTimeReached'} = 'Változás előzmények::Változás tényleges kezdési ideje elérve';
    $Self->{Translation}->{'ChangeHistory::ChangeAdd'} = 'Változás előzmények::Változás hozzáadás';
    $Self->{Translation}->{'ChangeHistory::ChangeAttachmentAdd'} = 'Változás előzmények::Változásmelléklet hozzáadás';
    $Self->{Translation}->{'ChangeHistory::ChangeAttachmentDelete'} = 'Változás előzmények::Változásmelléklet törlés';
    $Self->{Translation}->{'ChangeHistory::ChangeCABDelete'} = 'Változás előzmények::Változás CAB törlés';
    $Self->{Translation}->{'ChangeHistory::ChangeCABUpdate'} = 'Változás előzmények::Változás CAB frissítés';
    $Self->{Translation}->{'ChangeHistory::ChangeLinkAdd'} = 'Változás előzmények::Változás-hivatkozás hozzáadás';
    $Self->{Translation}->{'ChangeHistory::ChangeLinkDelete'} = 'Változás előzmények::Változás-hivatkozás törlés';
    $Self->{Translation}->{'ChangeHistory::ChangeNotificationSent'} = 'Változás előzmények::Változásértesítés küldés';
    $Self->{Translation}->{'ChangeHistory::ChangePlannedEndTimeReached'} = 'Változás előzmények::Változás tervezett befejezési ideje elérve';
    $Self->{Translation}->{'ChangeHistory::ChangePlannedStartTimeReached'} = 'Változás előzmények::Változás tervezett kezdési ideje elérve';
    $Self->{Translation}->{'ChangeHistory::ChangeRequestedTimeReached'} = 'Változás előzmények::Változás kért ideje elérve';
    $Self->{Translation}->{'ChangeHistory::ChangeUpdate'} = 'Változás előzmények::Változás frissítés';
    $Self->{Translation}->{'ChangeHistory::ConditionAdd'} = 'Változás előzmények::Feltétel hozzáadás';
    $Self->{Translation}->{'ChangeHistory::ConditionAddID'} = 'Változás előzmények::Feltétel azonosító hozzáadás';
    $Self->{Translation}->{'ChangeHistory::ConditionDelete'} = 'Változás előzmények::Feltétel törlés';
    $Self->{Translation}->{'ChangeHistory::ConditionDeleteAll'} = 'Változás előzmények::Feltétel összes törlés';
    $Self->{Translation}->{'ChangeHistory::ConditionUpdate'} = 'Változás előzmények::Feltétel frissítés';
    $Self->{Translation}->{'ChangeHistory::ExpressionAdd'} = 'Változás előzmények::Kifejezés hozzáadás';
    $Self->{Translation}->{'ChangeHistory::ExpressionAddID'} = 'Változás előzmények::Kifejezés azonosító hozzáadás';
    $Self->{Translation}->{'ChangeHistory::ExpressionDelete'} = 'Változás előzmények::Kifejezés törlés';
    $Self->{Translation}->{'ChangeHistory::ExpressionDeleteAll'} = 'Változás előzmények::Kifejezés összes törlés';
    $Self->{Translation}->{'ChangeHistory::ExpressionUpdate'} = 'Változás előzmények::Kifejezés frissítés';
    $Self->{Translation}->{'ChangeNumber'} = 'Változásszám';
    $Self->{Translation}->{'Condition Edit'} = 'Feltétel szerkesztés';
    $Self->{Translation}->{'Create Change'} = 'Változás létrehozása';
    $Self->{Translation}->{'Create a change from this ticket!'} = 'Változás létrehozása ebből a jegyből!';
    $Self->{Translation}->{'Delete Workorder'} = 'Munkamegrendelés törlése';
    $Self->{Translation}->{'Edit the change'} = 'A változás szerkesztése';
    $Self->{Translation}->{'Edit the conditions of the change'} = 'A változás feltételeinek szerkesztése';
    $Self->{Translation}->{'Edit the workorder'} = 'A munkamegrendelés szerkesztése';
    $Self->{Translation}->{'Expression'} = 'Kifejezés';
    $Self->{Translation}->{'Full-Text Search in Change and Workorder'} = 'Szabad-szavas keresés a változásban és a munkamegrendelésben';
    $Self->{Translation}->{'ITSMCondition'} = 'ITSM feltétel';
    $Self->{Translation}->{'ITSMWorkOrder'} = 'ITSM munkamegrendelés';
    $Self->{Translation}->{'Link another object to the change'} = 'Másik objektum összekapcsolása a változással';
    $Self->{Translation}->{'Link another object to the workorder'} = 'Másik objektum összekapcsolása a munkamegrendeléssel';
    $Self->{Translation}->{'Move all workorders in time'} = 'Minden munkamegrendelés áthelyezése az időben';
    $Self->{Translation}->{'My CABs'} = 'Saját CAB-ok';
    $Self->{Translation}->{'My Changes'} = 'Saját változások';
    $Self->{Translation}->{'My Workorders'} = 'Saját munkamegrendelések';
    $Self->{Translation}->{'No XXX settings'} = 'Nincsenek XXX beállítások';
    $Self->{Translation}->{'PIR (Post Implementation Review)'} = 'PIR (megvalósítás utáni vizsgálat)';
    $Self->{Translation}->{'PSA (Projected Service Availability)'} = 'PSA (vetített szolgáltatás elérhetőség)';
    $Self->{Translation}->{'Please select first a catalog class!'} = 'Először válasszon egy katalógusosztályt!';
    $Self->{Translation}->{'Print the change'} = 'A változás nyomtatása';
    $Self->{Translation}->{'Print the workorder'} = 'A munkamegrendelés nyomtatása';
    $Self->{Translation}->{'RequestedTime'} = 'Kért idő';
    $Self->{Translation}->{'Save Change CAB as Template'} = 'Változás CAB mentése sablonként';
    $Self->{Translation}->{'Save change as a template'} = 'Változás mentése sablonként';
    $Self->{Translation}->{'Save workorder as a template'} = 'Munkamegrendelés mentése sablonként';
    $Self->{Translation}->{'Search Changes'} = 'Változások keresése';
    $Self->{Translation}->{'Set the agent for the workorder'} = 'Az ügyintéző beállítása a munkamegrendeléshez';
    $Self->{Translation}->{'Take Workorder'} = 'Munkamegrendelés felvétele';
    $Self->{Translation}->{'Take the workorder'} = 'A munkamegrendelés felvétele';
    $Self->{Translation}->{'Template Overview'} = 'Sablon áttekintő';
    $Self->{Translation}->{'The planned end time is invalid!'} = 'A tervezett befejezési idő érvénytelen!';
    $Self->{Translation}->{'The planned start time is invalid!'} = 'A tervezett kezdési idő érvénytelen!';
    $Self->{Translation}->{'The planned time is invalid!'} = 'A tervezett idő érvénytelen!';
    $Self->{Translation}->{'The requested time is invalid!'} = 'A kért idő érvénytelen!';
    $Self->{Translation}->{'New (from template)'} = 'Új (sablonból)';
    $Self->{Translation}->{'Add from template'} = 'Hozzáadás sablonból';
    $Self->{Translation}->{'Add Workorder (from template)'} = 'Munkamegrendelés hozzáadása (sablonból)';
    $Self->{Translation}->{'Add a workorder (from template) to the change'} = 'Egy munkamegrendelés hozzáadása (sablonból) a változáshoz';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualEndTimeReached'} = 'Munkamegrendelés előzmények::Munkamegrendelés tényleges befejezési ideje elérve';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualEndTimeReachedWithWorkOrderID'} =
        'Munkamegrendelés előzmények::Munkamegrendelés tényleges befejezési ideje elérve munkamegrendelés-azonosítóval';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualStartTimeReached'} = 'Munkamegrendelés előzmények::Munkamegrendelés tényleges kezdési ideje elérve';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualStartTimeReachedWithWorkOrderID'} =
        'Munkamegrendelés előzmények::Munkamegrendelés tényleges kezdési ideje elérve munkamegrendelés-azonosítóval';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAdd'} = 'Munkamegrendelés előzmények::Munkamegrendelés hozzáadás';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAddWithWorkOrderID'} = 'Munkamegrendelés előzmények::Munkamegrendelés hozzáadás munkamegrendelés-azonosítóval';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentAdd'} = 'Munkamegrendelés előzmények::Munkamegrendelés melléklet hozzáadás';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentAddWithWorkOrderID'} = 'Munkamegrendelés előzmények::Munkamegrendelés melléklet hozzáadás munkamegrendelés-azonosítóval';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentDelete'} = 'Munkamegrendelés előzmények::Munkamegrendelés melléklet törlés';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentDeleteWithWorkOrderID'} = 'Munkamegrendelés előzmények::Munkamegrendelés melléklet törlés munkamegrendelés-azonosítóval';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentAdd'} = 'Munkamegrendelés előzmények::Munkamegrendelés jelentés melléklet hozzáadás';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentAddWithWorkOrderID'} =
        'Munkamegrendelés előzmények::Munkamegrendelés jelentés melléklet hozzáadás munkamegrendelés-azonosítóval';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentDelete'} = 'Munkamegrendelés előzmények::Munkamegrendelés jelentés melléklet törlés';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentDeleteWithWorkOrderID'} =
        'Munkamegrendelés előzmények::Munkamegrendelés jelentés melléklet törlés munkamegrendelés-azonosítóval';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderDelete'} = 'Munkamegrendelés előzmények::Munkamegrendelés törlés';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderDeleteWithWorkOrderID'} = 'Munkamegrendelés előzmények::Munkamegrendelés törlés munkamegrendelés-azonosítóval';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkAdd'} = 'Munkamegrendelés előzmények::Munkamegrendelés hivatkozás hozzáadás';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkAddWithWorkOrderID'} = 'Munkamegrendelés előzmények::Munkamegrendelés hivatkozás hozzáadás munkamegrendelés-azonosítóval';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkDelete'} = 'Munkamegrendelés előzmények::Munkamegrendelés hivatkozás törlés';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkDeleteWithWorkOrderID'} = 'Munkamegrendelés előzmények::Munkamegrendelés hivatkozás törlés munkamegrendelés-azonosítóval';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderNotificationSent'} = 'Munkamegrendelés előzmények::Munkamegrendelés értesítés küldés';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderNotificationSentWithWorkOrderID'} = 'Munkamegrendelés előzmények::Munkamegrendelés értesítés küldés munkamegrendelés-azonosítóval';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedEndTimeReached'} = 'Munkamegrendelés előzmények::Munkamegrendelés tervezett befejezési ideje elérve';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedEndTimeReachedWithWorkOrderID'} =
        'Munkamegrendelés előzmények::Munkamegrendelés tervezett befejezési ideje elérve munkamegrendelés-azonosítóval';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedStartTimeReached'} = 'Munkamegrendelés előzmények::Munkamegrendelés tervezett kezdési ideje elérve';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedStartTimeReachedWithWorkOrderID'} =
        'Munkamegrendelés előzmények::Munkamegrendelés tervezett kezdési ideje elérve munkamegrendelés-azonosítóval';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderUpdate'} = 'Munkamegrendelés előzmények::Munkamegrendelés frissítés';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderUpdateWithWorkOrderID'} = 'Munkamegrendelés előzmények::Munkamegrendelés frissítés munkamegrendelés-azonosítóval';
    $Self->{Translation}->{'WorkOrderNumber'} = 'Munkamegrendelés-szám';
    $Self->{Translation}->{'accepted'} = 'elfogadva';
    $Self->{Translation}->{'any'} = 'bármely';
    $Self->{Translation}->{'approval'} = 'jóváhagyás';
    $Self->{Translation}->{'approved'} = 'jóváhagyva';
    $Self->{Translation}->{'backout'} = 'visszalépés';
    $Self->{Translation}->{'begins with'} = 'ezzel kezdődik';
    $Self->{Translation}->{'canceled'} = 'megszakítva';
    $Self->{Translation}->{'contains'} = 'tartalmazza';
    $Self->{Translation}->{'created'} = 'létrehozva';
    $Self->{Translation}->{'decision'} = 'döntés';
    $Self->{Translation}->{'ends with'} = 'ezzel végződik';
    $Self->{Translation}->{'failed'} = 'sikertelen';
    $Self->{Translation}->{'in progress'} = 'folyamatban';
    $Self->{Translation}->{'is'} = 'egyenlő';
    $Self->{Translation}->{'is after'} = 'ez után';
    $Self->{Translation}->{'is before'} = 'ez előtt';
    $Self->{Translation}->{'is empty'} = 'üres';
    $Self->{Translation}->{'is greater than'} = 'nagyobb mint';
    $Self->{Translation}->{'is less than'} = 'kisebb mint';
    $Self->{Translation}->{'is not'} = 'nem';
    $Self->{Translation}->{'is not empty'} = 'nem üres';
    $Self->{Translation}->{'not contains'} = 'nem tartalmazza';
    $Self->{Translation}->{'pending approval'} = 'jóváhagyásra vár';
    $Self->{Translation}->{'pending pir'} = 'függőben lévő PIR';
    $Self->{Translation}->{'pir'} = 'PIR';
    $Self->{Translation}->{'ready'} = 'kész';
    $Self->{Translation}->{'rejected'} = 'visszautasítva';
    $Self->{Translation}->{'requested'} = 'kérve';
    $Self->{Translation}->{'retracted'} = 'visszavonva';
    $Self->{Translation}->{'set'} = 'beállítva';
    $Self->{Translation}->{'successful'} = 'sikeres';

    # Template: AdminITSMChangeCIPAllocate
    $Self->{Translation}->{'Category <-> Impact <-> Priority'} = 'Kategória <-> Hatás <-> Prioritás';
    $Self->{Translation}->{'Manage the priority result of combinating Category <-> Impact.'} =
        'A Kategória <-> Hatás összetétel prioritás eredményének kezelése.';
    $Self->{Translation}->{'Priority allocation'} = 'Prioritás lefoglalás';

    # Template: AdminITSMChangeNotification
    $Self->{Translation}->{'ITSM ChangeManagement Notification Management'} = 'ITSM változásmenedzsment értesítés kezelés';
    $Self->{Translation}->{'Add Notification Rule'} = 'Értesítési szabály hozzáadása';
    $Self->{Translation}->{'Rule'} = 'Szabály';
    $Self->{Translation}->{'A notification should have a name!'} = 'Az értesítésnek rendelkeznie kell egy névvel!';
    $Self->{Translation}->{'Name is required.'} = 'A név kötelező.';

    # Template: AdminITSMStateMachine
    $Self->{Translation}->{'Admin State Machine'} = 'Adminisztrátori állapotgép';
    $Self->{Translation}->{'Select a catalog class!'} = 'Válasszon egy katalógusosztályt!';
    $Self->{Translation}->{'A catalog class is required!'} = 'A katalógusosztály kötelező!';
    $Self->{Translation}->{'Add a state transition'} = 'Egy állapotátmenet hozzáadása';
    $Self->{Translation}->{'Catalog Class'} = 'Katalógusosztály';
    $Self->{Translation}->{'Object Name'} = 'Objektumnév';
    $Self->{Translation}->{'Overview over state transitions for'} = 'Állapotátmenetek áttekintése ennél:';
    $Self->{Translation}->{'Delete this state transition'} = 'Az állapotátmenet törlése';
    $Self->{Translation}->{'Add a new state transition for'} = 'Egy új állapotátmenet hozzáadása ehhez:';
    $Self->{Translation}->{'Please select a state!'} = 'Válasszon egy állapotot!';
    $Self->{Translation}->{'Please select a next state!'} = 'Válasszon egy következő állapotot!';
    $Self->{Translation}->{'Edit a state transition for'} = 'Egy állapotátmenet szerkesztése ennél:';
    $Self->{Translation}->{'Do you really want to delete the state transition'} = 'Valóban törölni szeretné az állapotátmenetet';
    $Self->{Translation}->{'from'} = 'ettől:';
    $Self->{Translation}->{'to'} = 'eddig';

    # Template: AgentITSMChangeAdd
    $Self->{Translation}->{'Add Change'} = 'Változás hozzáadása';
    $Self->{Translation}->{'ITSM Change'} = 'ITSM változás';
    $Self->{Translation}->{'Justification'} = 'Indoklás';
    $Self->{Translation}->{'Input invalid.'} = 'Érvénytelen bemenet.';
    $Self->{Translation}->{'Impact'} = 'Hatás';
    $Self->{Translation}->{'Requested Date'} = 'Kért dátum';

    # Template: AgentITSMChangeAddFromTemplate
    $Self->{Translation}->{'Select Change Template'} = 'Változássablon kiválasztása';
    $Self->{Translation}->{'Time type'} = 'Időtípus';
    $Self->{Translation}->{'Invalid time type.'} = 'Érvénytelen időtípus.';
    $Self->{Translation}->{'New time'} = 'Új idő';

    # Template: AgentITSMChangeCABTemplate
    $Self->{Translation}->{'Save Change CAB as template'} = 'Változás CAB mentése sablonként';
    $Self->{Translation}->{'go to involved persons screen'} = 'ugrás a résztvevő személyek képernyőjéhez';
    $Self->{Translation}->{'Invalid Name'} = 'Érvénytelen név';

    # Template: AgentITSMChangeCondition
    $Self->{Translation}->{'Conditions and Actions'} = 'Feltételek és műveletek';
    $Self->{Translation}->{'Delete Condition'} = 'Feltétel törlése';
    $Self->{Translation}->{'Add new condition'} = 'Új feltétel hozzáadása';

    # Template: AgentITSMChangeConditionEdit
    $Self->{Translation}->{'Need a valid name.'} = 'Egy érvényes név szükséges.';
    $Self->{Translation}->{'A valid name is needed.'} = '';
    $Self->{Translation}->{'Duplicate name:'} = 'Név kettőzése:';
    $Self->{Translation}->{'This name is already used by another condition.'} = 'Ezt a nevet már egy másik feltétel használja.';
    $Self->{Translation}->{'Matching'} = 'Illeszkedés';
    $Self->{Translation}->{'Any expression (OR)'} = 'Bármely kifejezés (VAGY)';
    $Self->{Translation}->{'All expressions (AND)'} = 'Minden kifejezés (ÉS)';
    $Self->{Translation}->{'Expressions'} = 'Kifejezések';
    $Self->{Translation}->{'Selector'} = 'Kiválasztó';
    $Self->{Translation}->{'Operator'} = 'Művelet';
    $Self->{Translation}->{'Delete Expression'} = 'Kifejezés törlése';
    $Self->{Translation}->{'No Expressions found.'} = 'Nem találhatók kifejezések.';
    $Self->{Translation}->{'Add new expression'} = 'Új kifejezés hozzáadása';
    $Self->{Translation}->{'Delete Action'} = 'Művelet törlése';
    $Self->{Translation}->{'No Actions found.'} = 'Nem találhatók műveletek.';
    $Self->{Translation}->{'Add new action'} = 'Új művelet hozzáadása';

    # Template: AgentITSMChangeDelete
    $Self->{Translation}->{'Do you really want to delete this change?'} = 'Valóban törölni szeretné ezt a változást?';

    # Template: AgentITSMChangeHistory
    $Self->{Translation}->{'History of'} = 'Előzmények';
    $Self->{Translation}->{'Workorder'} = 'Munkamegrendelés';
    $Self->{Translation}->{'Show details'} = 'Részletek megjelenítése';
    $Self->{Translation}->{'Show workorder'} = 'Munkamegrendelés megjelenítése';

    # Template: AgentITSMChangeHistoryZoom
    $Self->{Translation}->{'Detailed history information of'} = 'Részletes előzmény információk:';
    $Self->{Translation}->{'Modified'} = 'Módosítva';
    $Self->{Translation}->{'Old Value'} = 'Régi érték';
    $Self->{Translation}->{'New Value'} = 'Új érték';

    # Template: AgentITSMChangeInvolvedPersons
    $Self->{Translation}->{'Involved Persons'} = 'Résztvevő személyek';
    $Self->{Translation}->{'ChangeManager'} = 'Változásmenedzser';
    $Self->{Translation}->{'User invalid.'} = 'Érvénytelen felhasználó.';
    $Self->{Translation}->{'ChangeBuilder'} = 'Változásösszeállító';
    $Self->{Translation}->{'Change Advisory Board'} = 'Változásmenedzsment-tanács';
    $Self->{Translation}->{'CAB Template'} = 'CAB sablon';
    $Self->{Translation}->{'Apply Template'} = 'Sablon alkalmazása';
    $Self->{Translation}->{'NewTemplate'} = 'Új sablon';
    $Self->{Translation}->{'Save this CAB as template'} = 'A CAB mentése sablonként';
    $Self->{Translation}->{'Add to CAB'} = 'Hozzáadás CAB-hoz';
    $Self->{Translation}->{'Invalid User'} = 'Érvénytelen felhasználó';
    $Self->{Translation}->{'Current CAB'} = 'Jelenlegi CAB';

    # Template: AgentITSMChangeOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = 'Környezet beállítások';
    $Self->{Translation}->{'Changes per page'} = 'Oldalankénti változások';

    # Template: AgentITSMChangeOverviewSmall
    $Self->{Translation}->{'WorkOrderTitle'} = 'Munkamegrendelés cím';
    $Self->{Translation}->{'ChangeTitle'} = 'Változáscím';
    $Self->{Translation}->{'WorkOrderAgent'} = 'Munkamegrendelés ügyintéző';
    $Self->{Translation}->{'Workorders'} = 'Munkamegrendelések';
    $Self->{Translation}->{'ChangeState'} = 'Változásállapot';
    $Self->{Translation}->{'WorkOrderState'} = 'Munkamegrendelés-állapot';
    $Self->{Translation}->{'WorkOrderType'} = 'Munkamegrendelés-típus';
    $Self->{Translation}->{'Requested Time'} = 'Kért idő';
    $Self->{Translation}->{'PlannedStartTime'} = 'Tervezett kezdési idő';
    $Self->{Translation}->{'PlannedEndTime'} = 'Tervezett befejezési idő';
    $Self->{Translation}->{'ActualStartTime'} = 'Tényleges kezdési idő';
    $Self->{Translation}->{'ActualEndTime'} = 'Tényleges befejezési idő';

    # Template: AgentITSMChangeReset
    $Self->{Translation}->{'Do you really want to reset this change?'} = 'Valóban vissza szeretné állítani ezt a változást?';

    # Template: AgentITSMChangeSearch
    $Self->{Translation}->{'(e.g. 10*5155 or 105658*)'} = '(például 10*5155 vagy 105658*)';
    $Self->{Translation}->{'CABAgent'} = 'CAB ügyintéző';
    $Self->{Translation}->{'e.g.'} = 'például';
    $Self->{Translation}->{'CABCustomer'} = 'CAB ügyfél';
    $Self->{Translation}->{'ITSM Workorder'} = 'ITSM munkamegrendelés';
    $Self->{Translation}->{'Instruction'} = 'Utasítás';
    $Self->{Translation}->{'Report'} = 'Jelentés';
    $Self->{Translation}->{'Change Category'} = 'Kategória módosítása';
    $Self->{Translation}->{'(before/after)'} = '(előtt/után)';
    $Self->{Translation}->{'(between)'} = '(között)';

    # Template: AgentITSMChangeTemplate
    $Self->{Translation}->{'Save Change as Template'} = 'Változás mentése sablonként';
    $Self->{Translation}->{'A template should have a name!'} = 'A sablonnak rendelkeznie kell egy névvel!';
    $Self->{Translation}->{'The template name is required.'} = 'A sablonnév kötelező.';
    $Self->{Translation}->{'Reset States'} = 'Állapotok visszaállítása';
    $Self->{Translation}->{'Overwrite original template'} = 'Eredeti sablon felülírása';
    $Self->{Translation}->{'Delete original change'} = 'Eredeti változás törlése';

    # Template: AgentITSMChangeTimeSlot
    $Self->{Translation}->{'Move Time Slot'} = 'Időrés áthelyezése';

    # Template: AgentITSMChangeZoom
    $Self->{Translation}->{'Change Information'} = 'Változás információk';
    $Self->{Translation}->{'PlannedEffort'} = 'Tervezett ráfordítás';
    $Self->{Translation}->{'Change Initiator(s)'} = 'Változáskezdeményezők';
    $Self->{Translation}->{'Change Manager'} = 'Változásmenedzser';
    $Self->{Translation}->{'Change Builder'} = 'Változásösszeállító';
    $Self->{Translation}->{'CAB'} = 'CAB';
    $Self->{Translation}->{'Last changed'} = 'Utoljára módosítva';
    $Self->{Translation}->{'Last changed by'} = 'Utoljára módosította';
    $Self->{Translation}->{'Ok'} = 'OK';
    $Self->{Translation}->{'To open links in the following description blocks, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).'} =
        'A következő leírásblokkokban lévő hivatkozások megnyitásához lehet, hogy meg kell nyomnia a Ctrl vagy a Cmd vagy a Shift billentyűt, miközben a hivatkozásra kattint (a böngészőjétől és az operációs rendszerétől függően).';
    $Self->{Translation}->{'Download Attachment'} = 'Melléklet letöltése';

    # Template: AgentITSMTemplateDelete
    $Self->{Translation}->{'Do you really want to delete this template?'} = 'Valóban törölni szeretné ezt a sablont?';

    # Template: AgentITSMTemplateEditCAB
    $Self->{Translation}->{'Edit CAB Template'} = 'CAB sablon szerkesztése';

    # Template: AgentITSMTemplateEditContent
    $Self->{Translation}->{'This will create a new change from this template, so you can edit and save it.'} =
        'Ez létre fog hozni egy új változást ebből a sablonból, így szerkesztheti és elmentheti azt.';
    $Self->{Translation}->{'The new change will be deleted automatically after it has been saved as template.'} =
        'Az új változás automatikusan törölve lesz, miután mentésre került sablonként.';
    $Self->{Translation}->{'This will create a new workorder from this template, so you can edit and save it.'} =
        'Ez létre fog hozni egy új munkamegrendelést ebből a sablonból, így szerkesztheti és elmentheti azt.';
    $Self->{Translation}->{'A temporary change will be created which contains the workorder.'} =
        'Egy ideiglenes változás lesz létrehozva, amely tartalmazza a munkamegrendelést.';
    $Self->{Translation}->{'The temporary change and new workorder will be deleted automatically after the workorder has been saved as template.'} =
        'Az ideiglenes változás és az új munkamegrendelés automatikusan törölve lesz, miután a munkamegrendelés mentésre került sablonként.';
    $Self->{Translation}->{'Do you want to proceed?'} = 'Szeretné folytatni?';

    # Template: AgentITSMTemplateOverviewSmall
    $Self->{Translation}->{'TemplateID'} = 'Sablon-azonosító';
    $Self->{Translation}->{'Edit Content'} = 'Tartalom szerkesztése';
    $Self->{Translation}->{'CreateBy'} = 'Létrehozta';
    $Self->{Translation}->{'CreateTime'} = 'Létrehozás ideje';
    $Self->{Translation}->{'ChangeBy'} = 'Módosította';
    $Self->{Translation}->{'ChangeTime'} = 'Módosítás ideje';
    $Self->{Translation}->{'Edit Template Content'} = 'Sablontartalom szerkesztése';
    $Self->{Translation}->{'Delete Template'} = 'Sablon törlése';

    # Template: AgentITSMWorkOrderAdd
    $Self->{Translation}->{'Add Workorder to'} = 'Munkamegrendelés hozzáadása ehhez:';
    $Self->{Translation}->{'Invalid workorder type.'} = 'Érvénytelen munkamegrendelés-típus.';
    $Self->{Translation}->{'The planned start time must be before the planned end time!'} = 'A tervezett kezdési időnek a tervezett befejezési idő előtt kell lennie!';
    $Self->{Translation}->{'Invalid format.'} = 'Érvénytelen formátum.';

    # Template: AgentITSMWorkOrderAddFromTemplate
    $Self->{Translation}->{'Select Workorder Template'} = 'Munkamegrendelés-sablon kiválasztása';

    # Template: AgentITSMWorkOrderDelete
    $Self->{Translation}->{'Do you really want to delete this workorder?'} = 'Valóban törölni szeretné ezt a munkamegrendelést?';
    $Self->{Translation}->{'You can not delete this Workorder. It is used in at least one Condition!'} =
        'Nem törölheti ezt a munkamegrendelést. Legalább egy feltételben használják!';
    $Self->{Translation}->{'This Workorder is used in the following Condition(s)'} = 'Ezt a munkamegrendelést a következő feltételekben használják';

    # Template: AgentITSMWorkOrderEdit
    $Self->{Translation}->{'Move following workorders accordingly'} = 'A követő munkamegrendelések áthelyezése eszerint';
    $Self->{Translation}->{'If the planned end time of this workorder is changed, the planned start times of all following workorders will be changed accordingly'} =
        'Ha ennek a munkamegrendelésnek megváltozik a tervezett befejezési ideje, akkor az összes azt követő munkamegrendelés tervezett kezdési ideje is meg fog változni eszerint';

    # Template: AgentITSMWorkOrderReport
    $Self->{Translation}->{'The actual start time must be before the actual end time!'} = 'A tényleges kezdési időnek a tényleges befejezési idő előtt kell lennie!';
    $Self->{Translation}->{'The actual start time must be set, when the actual end time is set!'} =
        'A tényleges kezdési időnek beállítva kell lennie, amikor a tényleges befejezési idő be van állítva!';

    # Template: AgentITSMWorkOrderTake
    $Self->{Translation}->{'Current Agent'} = 'Jelenlegi ügyintéző';
    $Self->{Translation}->{'Do you really want to take this workorder?'} = 'Valóban fel szeretné vennie ezt a munkamegrendelést?';

    # Template: AgentITSMWorkOrderTemplate
    $Self->{Translation}->{'Save Workorder as Template'} = 'Munkamegrendelés mentése sablonként';
    $Self->{Translation}->{'Delete original workorder (and surrounding change)'} = 'Eredeti munkamegrendelés (és a környező változás) törlése';

    # Template: AgentITSMWorkOrderZoom
    $Self->{Translation}->{'Workorder Information'} = 'Munkamegrendelés-információk';

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
    $Self->{Translation}->{'WorkOrders'} = 'Munkamegrendelések';
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
    $Self->{Translation}->{'WorkOrderHistory::'} = 'WorkOrderHistory::';
    $Self->{Translation}->{'WorkOrder History'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderHistoryZoom.pm
    $Self->{Translation}->{'History entry "%s" not found in the database!'} = '';
    $Self->{Translation}->{'WorkOrder History Zoom'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderTake.pm
    $Self->{Translation}->{'Was not able to take the workorder %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderTemplate.pm
    $Self->{Translation}->{'The workorder "%s" could not be serialized.'} = '';

    # Perl Module: Kernel/Output/HTML/ToolBar/MyWorkOrders.pm
    $Self->{Translation}->{'My Work Orders'} = 'Saját munkamegrendelések';

}

1;
