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
    $Self->{Translation}->{'Link another object to the change'} = 'Másik objektum hozzákapcsolása a változáshoz';
    $Self->{Translation}->{'Link another object to the workorder'} = 'Másik objektum hozzákapcsolása a munkamegrendeléshez';
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
    $Self->{Translation}->{'A a valid name is needed.'} = 'Egy érvényes név szükséges.';
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

    # Perl Module: Kernel/Modules/AgentITSMChangePIR.pm
    $Self->{Translation}->{'PIR'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangePSA.pm
    $Self->{Translation}->{'PSA'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeSearch.pm
    $Self->{Translation}->{'WorkOrders'} = 'Munkamegrendelések';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderHistory.pm
    $Self->{Translation}->{'WorkOrderHistory::'} = '';

    # Perl Module: Kernel/Output/HTML/ToolBar/MyWorkOrders.pm
    $Self->{Translation}->{'My Work Orders'} = '';

    # SysConfig
    $Self->{Translation}->{'A list of the agents who have permission to take workorders. Key is a login name. Content is 0 or 1.'} =
        'Azon ügyintézők listája, akik jogosultsággal rendelkeznek a munkamegrendelések felvételéhez. A kulcs a bejelentkezési név. A tartalom 0 vagy 1.';
    $Self->{Translation}->{'A list of workorder states, at which the ActualStartTime of a workorder will be set if it was empty at this point.'} =
        'Azon munkamegrendelés-állapotok listája, amelyeknél egy munkamegrendelés tényleges kezdési ideje be lesz állítva, ha az üres ennél a pontnál.';
    $Self->{Translation}->{'Add a change from template.'} = '';
    $Self->{Translation}->{'Add a change.'} = '';
    $Self->{Translation}->{'Admin of the CIP matrix.'} = 'A CIP mátrix adminisztrátora.';
    $Self->{Translation}->{'Admin of the state machine.'} = 'Az állapotgép adminisztrátora.';
    $Self->{Translation}->{'Agent interface notification module to see the number of change advisory boards.'} =
        'Ügyintézői felület értesítési modul a változásmenedzsment-tanácsok számának megtekintéséhez.';
    $Self->{Translation}->{'Agent interface notification module to see the number of changes managed by the user.'} =
        'Ügyintézői felület értesítési modul a felhasználó által kezelt változások számának megtekintéséhez.';
    $Self->{Translation}->{'Agent interface notification module to see the number of changes.'} =
        'Ügyintézői felület értesítési modul a változások számának megtekintéséhez.';
    $Self->{Translation}->{'Agent interface notification module to see the number of work orders.'} =
        'Ügyintézői felület értesítési modul a munkamegrendelések számának megtekintéséhez.';
    $Self->{Translation}->{'Cache time in minutes for the change management toolbars. Default: 3 hours (180 minutes).'} =
        'Gyorsítótár idő percben a változásmenedzsment eszköztárnál. Alapértelmezett: 3 óra (180 perc).';
    $Self->{Translation}->{'Cache time in minutes for the change management. Default: 5 days (7200 minutes).'} =
        'Gyorsítótár idő percben a változásmenedzsmentnél. Alapértelmezett: 5 nap (7200 perc).';
    $Self->{Translation}->{'Change History.'} = '';
    $Self->{Translation}->{'Change Involved Persons.'} = '';
    $Self->{Translation}->{'Change Overview "Small" Limit'} = 'Változás áttekintő „kis” korlát';
    $Self->{Translation}->{'Change Print.'} = '';
    $Self->{Translation}->{'Change Schedule.'} = '';
    $Self->{Translation}->{'Change Zoom.'} = '';
    $Self->{Translation}->{'Change and WorkOrder templates edited by this user.'} = 'A felhasználó által szerkesztett változás és munkamegrendelés sablonok.';
    $Self->{Translation}->{'Change limit per page for Change Overview "Small"'} = 'Oldalankénti változás korlát a „kis” változás áttekintőnél';
    $Self->{Translation}->{'Change search backend router of the agent interface.'} = 'Az ügyintézői felület változás keresési háttérprogram útválasztója.';
    $Self->{Translation}->{'Change-Area'} = '';
    $Self->{Translation}->{'Configures how often the notifications are sent when planned the start time or other time values have been reached/passed.'} =
        'Beállítja, hogy milyen gyakran legyenek elküldve az értesítések, amikor elérik/átadják a tervezett kezdési időt vagy más időértékeket.';
    $Self->{Translation}->{'Create a change (from template) from this ticket!'} = '';
    $Self->{Translation}->{'Create and manage ITSM Change Management notifications.'} = '';
    $Self->{Translation}->{'Default type for a workorder. This entry must exist in general catalog class \'ITSM::ChangeManagement::WorkOrder::Type\'.'} =
        'Egy munkamegrendelés alapértelmezett típusa. Ennek a bejegyzésnek léteznie kell az „ITSM::ChangeManagement::WorkOrder::Type” általános katalógus osztályban.';
    $Self->{Translation}->{'Define the signals for each workorder state.'} = 'A szignálok meghatározása minden munkamegrendelés-állapotnál.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a change list.'} =
        'Egy áttekintő modult határoz meg egy változáslista kis nézetének megjelenítéséhez.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a template list.'} =
        'Egy áttekintő modult határoz meg egy sablonlista kis nézetének megjelenítéséhez.';
    $Self->{Translation}->{'Defines if it will be possible to print the accounted time.'} = 'Meghatározza, hogy lehetséges lesz-e kinyomtatni az elszámolt időt.';
    $Self->{Translation}->{'Defines if it will be possible to print the planned effort.'} = 'Meghatározza, hogy lehetséges lesz-e kinyomtatni a tervezett ráfordítást.';
    $Self->{Translation}->{'Defines if reachable (as defined by the state machine) change end states should be allowed if a change is in a locked state.'} =
        'Meghatározza, hogy az elérhető (ahogy az állapotgép meghatározta) változás befejezési állapotait el kell-e fogadni, ha egy változás zárolt állapotban van.';
    $Self->{Translation}->{'Defines if reachable (as defined by the state machine) workorder end states should be allowed if a workorder is in a locked state.'} =
        'Meghatározza, hogy az elérhető (ahogy az állapotgép meghatározta) munkamegrendelés befejezési állapotait el kell-e fogadni, ha egy munkamegrendelés zárolt állapotban van.';
    $Self->{Translation}->{'Defines if the accounted time should be shown.'} = 'Meghatározza, hogy az elszámolt időt meg kell-e jeleníteni.';
    $Self->{Translation}->{'Defines if the actual start and end times should be set.'} = 'Meghatározza, hogy a tényleges kezdési és befejezési időket be kell-e állítani.';
    $Self->{Translation}->{'Defines if the change search and the workorder search functions could use the mirror DB.'} =
        'Meghatározza, hogy a változáskeresés és a munkamegrendelés-keresés funkciók használhatják-e a tükör adatbázist.';
    $Self->{Translation}->{'Defines if the change state can be set in AgentITSMChangeEdit.'} =
        'Meghatározza, hogy a változás állapota beállítható-e az AgentITSMChangeEdit beállításban.';
    $Self->{Translation}->{'Defines if the planned effort should be shown.'} = 'Meghatározza, hogy a tervezett ráfordítást meg kell-e jeleníteni.';
    $Self->{Translation}->{'Defines if the requested date should be print by customer.'} = 'Meghatározza, hogy a kért dátumot ügyfél szerint kell-e kinyomtatni.';
    $Self->{Translation}->{'Defines if the requested date should be searched by customer.'} =
        'Meghatározza, hogy a kért dátumot ügyfél szerint kell-e keresni.';
    $Self->{Translation}->{'Defines if the requested date should be set by customer.'} = 'Meghatározza, hogy a kért dátumot ügyfél szerint kell-e beállítani.';
    $Self->{Translation}->{'Defines if the requested date should be shown by customer.'} = 'Meghatározza, hogy a kért dátumot ügyfél szerint kell-e megjeleníteni.';
    $Self->{Translation}->{'Defines if the workorder state should be shown.'} = 'Meghatározza, hogy a munkamegrendelés állapotát meg kell-e jeleníteni.';
    $Self->{Translation}->{'Defines if the workorder title should be shown.'} = 'Meghatározza, hogy a munkamegrendelés címét meg kell-e jeleníteni.';
    $Self->{Translation}->{'Defines shown graph attributes.'} = 'Meghatározza a megjelenített grafikonattribútumokat.';
    $Self->{Translation}->{'Defines that only changes containing Workorders linked with services, which the customer user has permission to use will be shown. Any other changes will not be displayed.'} =
        'Meghatározza, hogy csak azok a szolgáltatásokkal összekapcsolt munkamegrendeléseket tartalmazó változások lesznek megjelenítve, amelyekre az ügyfélfelhasználónak használati jogosultsága van. Minden egyéb változás nem kerül megjelenítésre.';
    $Self->{Translation}->{'Defines the change states that will be allowed to delete.'} = 'Meghatározza azokat a változásállapotokat, amelyek engedélyezettek lesznek törlésre.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the Change PSA overview.'} =
        'Meghatározza azokat a változásállapotokat, amelyek szűrőkként lesznek használva a változás PSA áttekintőjében.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the Change Schedule overview.'} =
        'Meghatározza azokat a változásállapotokat, amelyek szűrőkként lesznek használva a változásütemezés áttekintőjében.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the MyCAB overview.'} =
        'Meghatározza azokat a változásállapotokat, amelyek szűrőkként lesznek használva a saját CAB áttekintőjében.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the MyChanges overview.'} =
        'Meghatározza azokat a változásállapotokat, amelyek szűrőkként lesznek használva a saját változások áttekintőjében.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the change manager overview.'} =
        'Meghatározza azokat a változásállapotokat, amelyek szűrőkként lesznek használva a változáskezelő áttekintőjében.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the change overview.'} =
        'Meghatározza azokat a változásállapotokat, amelyek szűrőkként lesznek használva a változás áttekintőjében.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the customer change schedule overview.'} =
        'Meghatározza azokat a változásállapotokat, amelyek szűrőkként lesznek használva az ügyfél változásütemezés áttekintőjében.';
    $Self->{Translation}->{'Defines the default change title for a dummy change which is needed to edit a workorder template.'} =
        'Meghatározza egy üres változás alapértelmezett változáscímét, amely egy munkamegrendelés-sablon szerkesztéséhez szükséges.';
    $Self->{Translation}->{'Defines the default sort criteria in the change PSA overview.'} =
        'Meghatározza az alapértelmezett rendezési feltételt a változás PSA áttekintőjében.';
    $Self->{Translation}->{'Defines the default sort criteria in the change manager overview.'} =
        'Meghatározza az alapértelmezett rendezési feltételt a változásmenedzser áttekintőjében.';
    $Self->{Translation}->{'Defines the default sort criteria in the change overview.'} = 'Meghatározza az alapértelmezett rendezési feltételt a változás áttekintőjében.';
    $Self->{Translation}->{'Defines the default sort criteria in the change schedule overview.'} =
        'Meghatározza az alapértelmezett rendezési feltételt a változásütemezés áttekintőjében.';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the MyCAB overview.'} =
        'Meghatározza a változások alapértelmezett rendezési feltételét a saját CAB áttekintőjében.';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the MyChanges overview.'} =
        'Meghatározza a változások alapértelmezett rendezési feltételét a saját változások áttekintőjében.';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the MyWorkorders overview.'} =
        'Meghatározza a változások alapértelmezett rendezési feltételét a saját munkamegrendelések áttekintőjében.';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the PIR overview.'} =
        'Meghatározza a változások alapértelmezett rendezési feltételét a PIR áttekintőjében.';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the customer change schedule overview.'} =
        'Meghatározza a változások alapértelmezett rendezési feltételét az ügyfél változásütemezés áttekintőjében.';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the template overview.'} =
        'Meghatározza a változások alapértelmezett rendezési feltételét a sablon áttekintőjében.';
    $Self->{Translation}->{'Defines the default sort order in the MyCAB overview.'} = 'Meghatározza az alapértelmezett rendezési sorrendet a saját CAB áttekintőjében.';
    $Self->{Translation}->{'Defines the default sort order in the MyChanges overview.'} = 'Meghatározza az alapértelmezett rendezési sorrendet a saját változások áttekintőjében.';
    $Self->{Translation}->{'Defines the default sort order in the MyWorkorders overview.'} =
        'Meghatározza az alapértelmezett rendezési sorrendet a saját munkamegrendelések áttekintőjében.';
    $Self->{Translation}->{'Defines the default sort order in the PIR overview.'} = 'Meghatározza az alapértelmezett rendezési sorrendet a PIR áttekintőjében.';
    $Self->{Translation}->{'Defines the default sort order in the change PSA overview.'} = 'Meghatározza az alapértelmezett rendezési sorrendet a változás PSA áttekintőjében.';
    $Self->{Translation}->{'Defines the default sort order in the change manager overview.'} =
        'Meghatározza az alapértelmezett rendezési sorrendet a változásmenedzser áttekintőjében.';
    $Self->{Translation}->{'Defines the default sort order in the change overview.'} = 'Meghatározza az alapértelmezett rendezési sorrendet a változás áttekintőjében.';
    $Self->{Translation}->{'Defines the default sort order in the change schedule overview.'} =
        'Meghatározza az alapértelmezett rendezési sorrendet a változásütemezés áttekintőjében.';
    $Self->{Translation}->{'Defines the default sort order in the customer change schedule overview.'} =
        'Meghatározza az alapértelmezett rendezési sorrendet az ügyfél változásütemezés áttekintőjében.';
    $Self->{Translation}->{'Defines the default sort order in the template overview.'} = 'Meghatározza az alapértelmezett rendezési sorrendet a sablon áttekintőjében.';
    $Self->{Translation}->{'Defines the default value for the category of a change.'} = 'Meghatározza egy változás kategóriájának alapértelmezett értékét.';
    $Self->{Translation}->{'Defines the default value for the impact of a change.'} = 'Meghatározza egy változás hatásának alapértelmezett értékét.';
    $Self->{Translation}->{'Defines the field type of CompareValue fields for change attributes used in AgentITSMChangeConditionEdit. Valid values are Selection, Text and Date. If a type is not defined, the field will not be shown.'} =
        'Meghatározza az „Összehasonlítás érték” mezők mezőtípusát az AgentITSMChangeConditionEdit osztályban használt változás attribútumainál. Az érvényes értékek: Selection, Text és Date. Ha a típus nincs meghatározva, akkor a mező nem lesz látható.';
    $Self->{Translation}->{'Defines the field type of CompareValue fields for workorder attributes used in AgentITSMChangeConditionEdit. Valid values are Selection, Text and Date. If a type is not defined, the field will not be shown.'} =
        'Meghatározza az „Összehasonlítás érték” mezők mezőtípusát az AgentITSMChangeConditionEdit osztályban használt munkamegrendelés attribútumainál. Az érvényes értékek: Selection, Text és Date. Ha a típus nincs meghatározva, akkor a mező nem lesz látható.';
    $Self->{Translation}->{'Defines the object attributes that are selectable for change objects in AgentITSMChangeConditionEdit.'} =
        'Meghatározza azokat az objektumattribútumokat, amelyek kiválaszthatók a változásobjektumoknál az AgentITSMChangeConditionEdit osztályban.';
    $Self->{Translation}->{'Defines the object attributes that are selectable for workorder objects in AgentITSMChangeConditionEdit.'} =
        'Meghatározza azokat az objektumattribútumokat, amelyek kiválaszthatók a munkamegrendelés objektumoknál az AgentITSMChangeConditionEdit osztályban.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute AccountedTime in AgentITSMChangeConditionEdit.'} =
        'Meghatározza azokat az operátorokat, amelyek kiválaszthatók az „Elszámolt idő” attribútumnál az AgentITSMChangeConditionEdit osztályban.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ActualEndTime in AgentITSMChangeConditionEdit.'} =
        'Meghatározza azokat az operátorokat, amelyek kiválaszthatók a „Tényleges befejetési idő” attribútumnál az AgentITSMChangeConditionEdit osztályban.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ActualStartTime in AgentITSMChangeConditionEdit.'} =
        'Meghatározza azokat az operátorokat, amelyek kiválaszthatók a „Tényleges kezdési idő” attribútumnál az AgentITSMChangeConditionEdit osztályban.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute CategoryID in AgentITSMChangeConditionEdit.'} =
        'Meghatározza azokat az operátorokat, amelyek kiválaszthatók a „Kategória-azonosító” attribútumnál az AgentITSMChangeConditionEdit osztályban.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeBuilderID in AgentITSMChangeConditionEdit.'} =
        'Meghatározza azokat az operátorokat, amelyek kiválaszthatók a „Változásösszeállító-azonosító” attribútumnál az AgentITSMChangeConditionEdit osztályban.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeManagerID in AgentITSMChangeConditionEdit.'} =
        'Meghatározza azokat az operátorokat, amelyek kiválaszthatók a „Változásmenedzser-azonosító” attribútumnál az AgentITSMChangeConditionEdit osztályban.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeStateID in AgentITSMChangeConditionEdit.'} =
        'Meghatározza azokat az operátorokat, amelyek kiválaszthatók a „Változásállapot-azonosító” attribútumnál az AgentITSMChangeConditionEdit osztályban.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeTitle in AgentITSMChangeConditionEdit.'} =
        'Meghatározza azokat az operátorokat, amelyek kiválaszthatók a „Változáscím” attribútumnál az AgentITSMChangeConditionEdit osztályban.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute DynamicField in AgentITSMChangeConditionEdit.'} =
        'Meghatározza azokat az operátorokat, amelyek kiválaszthatók a „Dinamikus mező” attribútumnál az AgentITSMChangeConditionEdit osztályban.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ImpactID in AgentITSMChangeConditionEdit.'} =
        'Meghatározza azokat az operátorokat, amelyek kiválaszthatók a „Hatásazonosító” attribútumnál az AgentITSMChangeConditionEdit osztályban.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PlannedEffort in AgentITSMChangeConditionEdit.'} =
        'Meghatározza azokat az operátorokat, amelyek kiválaszthatók a „Tervezett ráfordítás” attribútumnál az AgentITSMChangeConditionEdit osztályban.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PlannedEndTime in AgentITSMChangeConditionEdit.'} =
        'Meghatározza azokat az operátorokat, amelyek kiválaszthatók a „Tervezett befejezési idő” attribútumnál az AgentITSMChangeConditionEdit osztályban.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PlannedStartTime in AgentITSMChangeConditionEdit.'} =
        'Meghatározza azokat az operátorokat, amelyek kiválaszthatók a „Tervezett kezdési idő” attribútumnál az AgentITSMChangeConditionEdit osztályban.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PriorityID in AgentITSMChangeConditionEdit.'} =
        'Meghatározza azokat az operátorokat, amelyek kiválaszthatók a „Prioritás-azonosító” attribútumnál az AgentITSMChangeConditionEdit osztályban.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute RequestedTime in AgentITSMChangeConditionEdit.'} =
        'Meghatározza azokat az operátorokat, amelyek kiválaszthatók a „Kért idő” attribútumnál az AgentITSMChangeConditionEdit osztályban.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderAgentID in AgentITSMChangeConditionEdit.'} =
        'Meghatározza azokat az operátorokat, amelyek kiválaszthatók a „Munkamegrendelés ügyintéző-azonosító” attribútumnál az AgentITSMChangeConditionEdit osztályban.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderNumber in AgentITSMChangeConditionEdit.'} =
        'Meghatározza azokat az operátorokat, amelyek kiválaszthatók a „Munkamegrendelés-szám” attribútumnál az AgentITSMChangeConditionEdit osztályban.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderStateID in AgentITSMChangeConditionEdit.'} =
        'Meghatározza azokat az operátorokat, amelyek kiválaszthatók a „Munkamegrendelésállapot-azonosító” attribútumnál az AgentITSMChangeConditionEdit osztályban.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderTitle in AgentITSMChangeConditionEdit.'} =
        'Meghatározza azokat az operátorokat, amelyek kiválaszthatók a „Munkamegrendelés-cím” attribútumnál az AgentITSMChangeConditionEdit osztályban.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderTypeID in AgentITSMChangeConditionEdit.'} =
        'Meghatározza azokat az operátorokat, amelyek kiválaszthatók a „Munkamegrendeléstípus-azonosító” attribútumnál az AgentITSMChangeConditionEdit osztályban.';
    $Self->{Translation}->{'Defines the period (in years), in which start and end times can be selected.'} =
        'Meghatározza (években) azt az időszakot, amelyben a kezdési és befejezési idők kiválaszthatók.';
    $Self->{Translation}->{'Defines the shown attributes of a workorder in the tooltip of the workorder graph in the change zoom. To show workorder dynamic fields in the tooltip, they must be specified like DynamicField_WorkOrderFieldName1, DynamicField_WorkOrderFieldName2, etc.'} =
        'Meghatározza egy munkamegrendelés megjelenített attribútumait a változásnagyításban lévő munkamegrendelés-grafikon buboréksúgójában. Ahhoz, hogy a munkamegrendelés dinamikus mezői megjelenjenek a buboréksúgóban, meg kell adni azokat a következőképpen: DynamicField_WorkOrderFieldName1, DynamicField_WorkOrderFieldName2, stb.';
    $Self->{Translation}->{'Defines the shown columns in the Change PSA overview. This option has no effect on the position of the column.'} =
        'Meghatározza a megjelenített oszlopokat a változás PSA áttekintőjében. Ennek a beállításnak nincs hatása az oszlop helyzetére.';
    $Self->{Translation}->{'Defines the shown columns in the Change Schedule overview. This option has no effect on the position of the column.'} =
        'Meghatározza a megjelenített oszlopokat a változásütemezés áttekintőjében. Ennek a beállításnak nincs hatása az oszlop helyzetére.';
    $Self->{Translation}->{'Defines the shown columns in the MyCAB overview. This option has no effect on the position of the column.'} =
        'Meghatározza a megjelenített oszlopokat a saját CAB áttekintőjében. Ennek a beállításnak nincs hatása az oszlop helyzetére.';
    $Self->{Translation}->{'Defines the shown columns in the MyChanges overview. This option has no effect on the position of the column.'} =
        'Meghatározza a megjelenített oszlopokat a saját változások áttekintőjében. Ennek a beállításnak nincs hatása az oszlop helyzetére.';
    $Self->{Translation}->{'Defines the shown columns in the MyWorkorders overview. This option has no effect on the position of the column.'} =
        'Meghatározza a megjelenített oszlopokat a saját munkamegrendelések áttekintőjében. Ennek a beállításnak nincs hatása az oszlop helyzetére.';
    $Self->{Translation}->{'Defines the shown columns in the PIR overview. This option has no effect on the position of the column.'} =
        'Meghatározza a megjelenített oszlopokat a PIR áttekintőjében. Ennek a beállításnak nincs hatása az oszlop helyzetére.';
    $Self->{Translation}->{'Defines the shown columns in the change manager overview. This option has no effect on the position of the column.'} =
        'Meghatározza a megjelenített oszlopokat a változásmenedzser áttekintőjében. Ennek a beállításnak nincs hatása az oszlop helyzetére.';
    $Self->{Translation}->{'Defines the shown columns in the change overview. This option has no effect on the position of the column.'} =
        'Meghatározza a megjelenített oszlopokat a változás áttekintőjében. Ennek a beállításnak nincs hatása az oszlop helyzetére.';
    $Self->{Translation}->{'Defines the shown columns in the change search. This option has no effect on the position of the column.'} =
        'Meghatározza a megjelenített oszlopokat a változáskeresőben. Ennek a beállításnak nincs hatása az oszlop helyzetére.';
    $Self->{Translation}->{'Defines the shown columns in the customer change schedule overview. This option has no effect on the position of the column.'} =
        'Meghatározza a megjelenített oszlopokat az ügyfél változásütemezés áttekintőjében. Ennek a beállításnak nincs hatása az oszlop helyzetére.';
    $Self->{Translation}->{'Defines the shown columns in the template overview. This option has no effect on the position of the column.'} =
        'Meghatározza a megjelenített oszlopokat a sablon áttekintőjében. Ennek a beállításnak nincs hatása az oszlop helyzetére.';
    $Self->{Translation}->{'Defines the signals for each ITSMChange state.'} = 'Meghatározza a szignálokat minden egyes ITSMChange állapothoz.';
    $Self->{Translation}->{'Defines the template types that will be used as filters in the template overview.'} =
        'Meghatározza azokat a sablontípusokat, amelyek szűrőkként lesznek használva a sablon áttekintőjében.';
    $Self->{Translation}->{'Defines the workorder states that will be used as filters in the MyWorkorders overview.'} =
        'Meghatározza azokat a munkamegrendelés-állapotokat, amelyek szűrőkként lesznek használva a saját munkamegrendelések áttekintőjében.';
    $Self->{Translation}->{'Defines the workorder states that will be used as filters in the PIR overview.'} =
        'Meghatározza azokat a munkamegrendelés-állapotokat, amelyek szűrőkként lesznek használva a PIR áttekintőjében.';
    $Self->{Translation}->{'Defines the workorder types that will be used to show the PIR overview.'} =
        'Meghatározza azokat a munkamegrendelés-típusokat, amelyek a PIR áttekintő megjelenítéshez lesznek használva.';
    $Self->{Translation}->{'Defines whether notifications should be sent.'} = 'Meghatározza, hogy az értesítéseket el kell-e küldeni.';
    $Self->{Translation}->{'Delete Change'} = '';
    $Self->{Translation}->{'Delete a change.'} = '';
    $Self->{Translation}->{'Details of a change history entry.'} = '';
    $Self->{Translation}->{'Determines if an agent can exchange the X-axis of a stat if he generates one.'} =
        'Meghatározza, hogy egy ügyintéző kicserélheti-e egy statisztika X-tengelyét, ha létrehozott egyet.';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes done for config item classes.'} =
        'Meghatározza, hogy a közös statisztikák modul előállíthat-e statisztikákat az elvégzett változásokról a konfigurációelem osztályoknál.';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes regarding change state updates within a timeperiod.'} =
        'Meghatározza, hogy a közös statisztikák modul előállíthat-e statisztikákat egy időszakon belüli változásállapot frissítésekre vonatkozó változásokról.';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes regarding the relation between changes and incident tickets.'} =
        'Meghatározza, hogy a közös statisztikák modul előállíthat-e statisztikákat a változások és incidensjegyek közötti kapcsolatra vonatkozó változásokról.';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes.'} =
        'Meghatározza, hogy a közös statisztikák modul előállíthat-e statisztikákat a változásokról.';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about the number of Rfc tickets a requester created.'} =
        'Meghatározza, hogy a közös statisztikák modul előállíthat-e statisztikákat egy kérő által létrehozott Rfc jegyek számáról.';
    $Self->{Translation}->{'Dynamic fields (for changes and workorders) shown in the change print screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        'Az ügyintézői felület változás nyomtatás képernyőjén megjelenített dinamikus mezők (változásokhoz és munkamegrendelésekhez). Lehetséges beállítások: 0 = Letiltva, 1 = Engedélyezve.';
    $Self->{Translation}->{'Dynamic fields shown in the change add screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        'Az ügyintézői felület változás hozzáadás képernyőjén megjelenített dinamikus mezők. Lehetséges beállítások: 0 = Letiltva, 1 = Engedélyezve, 2 = Engedélyezve és kötelező.';
    $Self->{Translation}->{'Dynamic fields shown in the change edit screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        'Az ügyintézői felület változás szerkesztés képernyőjén megjelenített dinamikus mezők. Lehetséges beállítások: 0 = Letiltva, 1 = Engedélyezve, 2 = Engedélyezve és kötelező.';
    $Self->{Translation}->{'Dynamic fields shown in the change search screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        'Az ügyintézői felület változás keresés képernyőjén megjelenített dinamikus mezők. Lehetséges beállítások: 0 = Letiltva, 1 = Engedélyezve.';
    $Self->{Translation}->{'Dynamic fields shown in the change zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        'Az ügyintézői felület változás nagyítás képernyőjén megjelenített dinamikus mezők. Lehetséges beállítások: 0 = Letiltva, 1 = Engedélyezve.';
    $Self->{Translation}->{'Dynamic fields shown in the workorder add screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        'Az ügyintézői felület munkamegrendelés hozzáadás képernyőjén megjelenített dinamikus mezők. Lehetséges beállítások: 0 = Letiltva, 1 = Engedélyezve, 2 = Engedélyezve és kötelező.';
    $Self->{Translation}->{'Dynamic fields shown in the workorder edit screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        'Az ügyintézői felület munkamegrendelés szerkesztés képernyőjén megjelenített dinamikus mezők. Lehetséges beállítások: 0 = Letiltva, 1 = Engedélyezve, 2 = Engedélyezve és kötelező.';
    $Self->{Translation}->{'Dynamic fields shown in the workorder report screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        'Az ügyintézői felület munkamegrendelés jelentés képernyőjén megjelenített dinamikus mezők. Lehetséges beállítások: 0 = Letiltva, 1 = Engedélyezve, 2 = Engedélyezve és kötelező.';
    $Self->{Translation}->{'Dynamic fields shown in the workorder zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        'Az ügyintézői felület munkamegrendelés nagyítás képernyőjén megjelenített dinamikus mezők. Lehetséges beállítások: 0 = Letiltva, 1 = Engedélyezve.';
    $Self->{Translation}->{'DynamicField event module to handle the update of conditions if dynamic fields are added, updated or deleted.'} =
        'Dinamikus mező eseménymodul a feltételek frissítésének kezeléséhez, ha dinamikus mezők kerülnek hozzáadásra, frissítésre vagy törlésre.';
    $Self->{Translation}->{'Edit a change.'} = '';
    $Self->{Translation}->{'Forward schedule of changes. Overview over approved changes.'} =
        '';
    $Self->{Translation}->{'ITSM Change CAB Templates.'} = '';
    $Self->{Translation}->{'ITSM Change Condition Edit.'} = '';
    $Self->{Translation}->{'ITSM Change Condition Overview.'} = '';
    $Self->{Translation}->{'ITSM Change Management Notifications'} = '';
    $Self->{Translation}->{'ITSM Change Manager Overview.'} = '';
    $Self->{Translation}->{'ITSM Change PIR Overview.'} = '';
    $Self->{Translation}->{'ITSM MyCAB Overview.'} = '';
    $Self->{Translation}->{'ITSM MyChanges Overview.'} = '';
    $Self->{Translation}->{'ITSM MyWorkorders Overview.'} = '';
    $Self->{Translation}->{'ITSM Template Delete.'} = '';
    $Self->{Translation}->{'ITSM Template Edit CAB.'} = '';
    $Self->{Translation}->{'ITSM Template Edit Content.'} = '';
    $Self->{Translation}->{'ITSM Template Edit.'} = '';
    $Self->{Translation}->{'ITSM Template Overview.'} = '';
    $Self->{Translation}->{'ITSM event module deletes the history of changes.'} = 'ITSM eseménymodul, amely törli a változások előzményeit.';
    $Self->{Translation}->{'ITSM event module that cleans up conditions.'} = 'ITSM eseménymodul, amely törli a feltételeket.';
    $Self->{Translation}->{'ITSM event module that deletes the cache for a toolbar.'} = 'ITSM eseménymodul, amely törli a gyorsítótárat egy eszköztárnál.';
    $Self->{Translation}->{'ITSM event module that matches conditions and executes actions.'} =
        'ITSM eseménymodul, amely feltételeket illeszt és műveleteket hajt végre.';
    $Self->{Translation}->{'ITSM event module that sends notifications.'} = 'ITSM eseménymodul, amely értesítéseket küld.';
    $Self->{Translation}->{'ITSM event module that updates the history of changes.'} = 'ITSM eseménymodul, amely frissíti a változások előzményeit.';
    $Self->{Translation}->{'ITSM event module to recalculate the workorder numbers.'} = 'ITSM eseménymodul a munkamegrendelés számainak újraszámolásához.';
    $Self->{Translation}->{'ITSM event module to set the actual start and end times of workorders.'} =
        'ITSM eseménymodul a munkamegrendelések tényleges kezdési és befejezési idejének beállításához.';
    $Self->{Translation}->{'ITSM event module updates the history of changes.'} = 'ITSM eseménymodul, amely frissíti a változások előzményeit.';
    $Self->{Translation}->{'ITSM event module updates the history of conditions.'} = 'ITSM eseménymodul, amely frissíti a feltételek előzményeit.';
    $Self->{Translation}->{'ITSM event module updates the history of workorders.'} = 'ITSM eseménymodul, amely frissíti a munkamegrendelések előzményeit.';
    $Self->{Translation}->{'If frequency is \'regularly\', you can configure how often the notications are sent (every X hours).'} =
        'Ha a gyakoriság „rendszeresen”, akkor beállíthatja, hogy az értesítések milyen gyakran legyenek elküldve (minden X. órában).';
    $Self->{Translation}->{'Logfile for the ITSM change counter. This file is used for creating the change numbers.'} =
        'Naplófájl az ITSM változásszámlálóhoz. Ezt a fájlt a változásszámok létrehozásához használják.';
    $Self->{Translation}->{'Lookup of CAB members for autocompletion.'} = '';
    $Self->{Translation}->{'Lookup of agents, used for autocompletion.'} = '';
    $Self->{Translation}->{'Module to check if WorkOrderAdd or WorkOrderAddFromTemplate should be permitted.'} =
        'Egy modul annak ellenőrzéséhez, hogy a „Munkamegrendelés hozzáadása” vagy a „Munkamegrendelés hozzáadása sablonból” osztályokat engedélyezni kell-e.';
    $Self->{Translation}->{'Module to check the CAB members.'} = 'Egy modul a CAB-tagok ellenőrzéséhez.';
    $Self->{Translation}->{'Module to check the agent.'} = 'Egy modul az ügyintéző ellenőrzéséhez.';
    $Self->{Translation}->{'Module to check the change builder.'} = 'Egy modul a változásösszeállító ellenőrzéséhez.';
    $Self->{Translation}->{'Module to check the change manager.'} = 'Egy modul a változásmenedzser ellenőrzéséhez.';
    $Self->{Translation}->{'Module to check the workorder agent.'} = 'Egy modul a munkamegrendelés ügyintézőjének ellenőrzéséhez.';
    $Self->{Translation}->{'Module to check whether no workorder agent is set.'} = 'Egy modul annak ellenőrzéséhez, hogy van-e munkamegrendelés-ügyintéző beállítva.';
    $Self->{Translation}->{'Module to check whether the agent is contained in the configured list.'} =
        'Egy modul annak ellenőrzéséhez, hogy az ügyintézőt tartalmazza-e a beállítási lista.';
    $Self->{Translation}->{'Module to show a link to create a change from this ticket. The ticket will be automatically linked with the new change.'} =
        'Egy modul egy hivatkozás megjelenítéséhez, amely egy változás létrehozására mutat ebből a jegyből. A jegy automatikusan össze lesz kapcsolva az új változással.';
    $Self->{Translation}->{'Move Time Slot.'} = '';
    $Self->{Translation}->{'Only users of these groups have the permission to use the ticket types as defined in "ITSMChange::AddChangeLinkTicketTypes" if the feature "Ticket::Acl::Module###200-Ticket::Acl::Module" is enabled.'} =
        'Csak ezen csoportok felhasználóinak van jogosultsága az „ITSMChange::AddChangeLinkTicketTypes” beállításban meghatározott jegytípusok használatára, ha a „Ticket::Acl::Module###200-Ticket::Acl::Module” szolgáltatás engedélyezve van.';
    $Self->{Translation}->{'Overview over all Changes.'} = '';
    $Self->{Translation}->{'Parameters for the UserCreateWorkOrderNextMask object in the preference view of the agent interface.'} =
        'A UserCreateWorkOrderNextMask objektum paraméterei az ügyintézői felület beállítás nézetében.';
    $Self->{Translation}->{'Parameters for the pages (in which the changes are shown) of the small change overview.'} =
        'Paraméterek a kis változás áttekintő oldalaihoz (amelyekben a változások megjelennek).';
    $Self->{Translation}->{'Presents a link in the menu to show the involved persons in a change, in the zoom view of such change in the agent interface.'} =
        'Egy hivatkozást jelenít meg a menüben egy változásban érintett személyek megjelenítéséhez az ilyen változás nagyítás nézetében az ügyintézői felületen.';
    $Self->{Translation}->{'Projected Service Availability (PSA)'} = '';
    $Self->{Translation}->{'Projected Service Availability (PSA) of changes. Overview of approved changes and their services.'} =
        '';
    $Self->{Translation}->{'Required privileges in order for an agent to take a workorder.'} =
        'A szükséges jogosultságok annak érdekében, hogy egy ügyintéző felvehessen egy munkamegrendelést.';
    $Self->{Translation}->{'Required privileges to access the overview of all changes.'} = 'A szükséges jogosultságok az összes változás áttekintőjének hozzáféréséhez.';
    $Self->{Translation}->{'Required privileges to add a workorder.'} = 'A szükséges jogosultságok egy munkamegrendelés hozzáadásához.';
    $Self->{Translation}->{'Required privileges to change the workorder agent.'} = 'A szükséges jogosultságok egy munkamegrendelés ügyintézőjének megváltoztatásához.';
    $Self->{Translation}->{'Required privileges to create a template from a change.'} = 'A szükséges jogosultságok egy sablon létrehozásához egy változásból.';
    $Self->{Translation}->{'Required privileges to create a template from a changes\' CAB.'} =
        'A szükséges jogosultságok egy sablon létrehozásához a változások CAB-jából.';
    $Self->{Translation}->{'Required privileges to create a template from a workorder.'} = 'A szükséges jogosultságok egy sablon létrehozásához egy munkamegrendelésből.';
    $Self->{Translation}->{'Required privileges to create changes from templates.'} = 'A szükséges jogosultságok változások létrehozásához sablonokból.';
    $Self->{Translation}->{'Required privileges to create changes.'} = 'A szükséges jogosultságok változások létrehozásához.';
    $Self->{Translation}->{'Required privileges to delete a template.'} = 'A szükséges jogosultságok egy sablon törléséhez.';
    $Self->{Translation}->{'Required privileges to delete a workorder.'} = 'A szükséges jogosultságok egy munkamegrendelés törléséhez.';
    $Self->{Translation}->{'Required privileges to delete changes.'} = 'A szükséges jogosultságok változások törléséhez.';
    $Self->{Translation}->{'Required privileges to edit a template.'} = 'A szükséges jogosultságok egy sablon szerkesztéséhez.';
    $Self->{Translation}->{'Required privileges to edit a workorder.'} = 'A szükséges jogosultságok egy munkamegrendelés szerkesztéséhez.';
    $Self->{Translation}->{'Required privileges to edit changes.'} = 'A szükséges jogosultságok változások szerkesztéséhez.';
    $Self->{Translation}->{'Required privileges to edit the conditions of changes.'} = 'A szükséges jogosultságok változások feltételeinek szerkesztéséhez.';
    $Self->{Translation}->{'Required privileges to edit the content of a template.'} = 'A szükséges jogosultságok egy sablon tartalmának szerkesztéséhez.';
    $Self->{Translation}->{'Required privileges to edit the involved persons of a change.'} =
        'A szükséges jogosultságok egy változásban érintett személyek szerkesztéséhez.';
    $Self->{Translation}->{'Required privileges to move changes in time.'} = 'A szükséges jogosultságok a változások áthelyezéséhez az időben.';
    $Self->{Translation}->{'Required privileges to print a change.'} = 'A szükséges jogosultságok egy változás kinyomtatásához.';
    $Self->{Translation}->{'Required privileges to reset changes.'} = 'A szükséges jogosultságok változások visszaállításához.';
    $Self->{Translation}->{'Required privileges to view a workorder.'} = 'A szükséges jogosultságok egy munkamegrendelés megtekintéséhez.';
    $Self->{Translation}->{'Required privileges to view changes.'} = 'A szükséges jogosultságok változások megtekintéséhez.';
    $Self->{Translation}->{'Required privileges to view list of changes where the user is a CAB member.'} =
        'A szükséges jogosultságok azon változások listájának megtekintéséhez, ahol a felhasználó egy CAB-tag.';
    $Self->{Translation}->{'Required privileges to view list of changes where the user is the change manager.'} =
        'A szükséges jogosultságok azon változások listájának megtekintéséhez, ahol a felhasználó a változásmenedzser.';
    $Self->{Translation}->{'Required privileges to view overview over all templates.'} = 'A szükséges jogosultságok az összes sablon áttekintőjének megtekintéséhez.';
    $Self->{Translation}->{'Required privileges to view the conditions of changes.'} = 'A szükséges jogosultságok változások feltételeinek megtekintéséhez.';
    $Self->{Translation}->{'Required privileges to view the history of a change.'} = 'A szükséges jogosultságok egy változás előzményeinek megtekintéséhez.';
    $Self->{Translation}->{'Required privileges to view the history of a workorder.'} = 'A szükséges jogosultságok egy munkamegrendelés előzményeinek megtekintéséhez.';
    $Self->{Translation}->{'Required privileges to view the history zoom of a change.'} = 'A szükséges jogosultságok egy változás előzményei nagyításának megtekintéséhez.';
    $Self->{Translation}->{'Required privileges to view the history zoom of a workorder.'} =
        'A szükséges jogosultságok egy munkamegrendelés előzményei nagyításának megtekintéséhez.';
    $Self->{Translation}->{'Required privileges to view the list of Change Schedule.'} = 'A szükséges jogosultságok a változásütemezés listájának megtekintéséhez.';
    $Self->{Translation}->{'Required privileges to view the list of change PSA.'} = 'A szükséges jogosultságok a változás PSA listájának megtekintéséhez.';
    $Self->{Translation}->{'Required privileges to view the list of changes with an upcoming PIR (Post Implementation Review).'} =
        'A szükséges jogosultságok egy közelgő PIR-rel (megvalósítás utáni vizsgálattal) rendelkező változások listájának megtekintéséhez.';
    $Self->{Translation}->{'Required privileges to view the list of own changes.'} = 'A szükséges jogosultságok a saját változások listájának megtekintéséhez.';
    $Self->{Translation}->{'Required privileges to view the list of own workorders.'} = 'A szükséges jogosultságok a saját munkamegrendelések listájának megtekintéséhez.';
    $Self->{Translation}->{'Required privileges to write a report for the workorder.'} = 'A szükséges jogosultságok egy jelentés írásához a munkamegrendelésnél.';
    $Self->{Translation}->{'Reset a change and its workorders.'} = '';
    $Self->{Translation}->{'Reset change and its workorders'} = '';
    $Self->{Translation}->{'Run task to check if specific times have been in reached in changes and workorders.'} =
        '';
    $Self->{Translation}->{'Screen after creating a workorder'} = 'Egy munkamegrendelés létrehozása utáni képernyő';
    $Self->{Translation}->{'Search Changes.'} = '';
    $Self->{Translation}->{'Selects the change number generator module. "AutoIncrement" increments the change number, the SystemID and the counter are used with SystemID.counter format (e.g. 100118, 100119). With "Date", the change numbers will be generated by the current date and a counter; this format looks like Year.Month.Day.counter, e.g. 2010062400001, 2010062400002. With "DateChecksum", the counter will be appended as checksum to the string of date plus the SystemID. The checksum will be rotated on a daily basis. This format looks like Year.Month.Day.SystemID.Counter.CheckSum, e.g. 2010062410000017, 2010062410000026.'} =
        'Kiválasztja a változásszám előállító modult. Az „AutoIncrement” növeli a változásszámot, ahol a rendszer-azonosítót és a számlálót a RendszerID.számláló formátummal használja (például 100118, 100119). A „Date” értékkel a változásszámokat az aktuális dátum és a számláló fogja előállítani. A formátum így néz ki: Év.Hónap.Nap.számláló (például 2010062400001, 2010062400002). A „DateChecksum” használatával a számláló ellenőrzőösszegként lesz hozzáfűzve a dátum és a rendszer-azonosító szövegéhez. Az ellenőrzőösszeg naponta fog átfordulni. A formátum így néz ki: Év.Hónap.Nap.RendszerID.Számláló.EllÖsszeg (például 2010062410000017, 2010062410000026).';
    $Self->{Translation}->{'Set the default height (in pixels) of inline HTML fields in AgentITSMChangeZoom and AgentITSMWorkOrderZoom.'} =
        'A beágyazott HTML mezők alapértelmezett magasságának beállítása (képpontban) az AgentITSMChangeZoom és az AgentITSMWorkOrderZoom felületen.';
    $Self->{Translation}->{'Set the maximum height (in pixels) of inline HTML fields in AgentITSMChangeZoom and AgentITSMWorkOrderZoom.'} =
        'A beágyazott HTML mezők legnagyobb magasságának beállítása (képpontban) az AgentITSMChangeZoom és az AgentITSMWorkOrderZoom felületen.';
    $Self->{Translation}->{'Sets the minimal change counter size (if "AutoIncrement" was selected as ITSMChange::NumberGenerator). Default is 5, this means the counter starts from 10000.'} =
        'Beállítja a legkisebb változásszámláló méretet (ha „AutoIncrement” lett kiválasztva ITSM változás::Számelőállítóként) Az alapértelmezett 5, amely azt jelenti, hogy a számláló 10000-től fog indulni.';
    $Self->{Translation}->{'Sets up the state machine for changes.'} = 'Beállítja az állapotgépet a változásoknál.';
    $Self->{Translation}->{'Sets up the state machine for workorders.'} = 'Beállítja az állapotgépet a munkamegrendeléseknél.';
    $Self->{Translation}->{'Show this screen after I created a new workorder'} = 'Ezen képernyő megjelenítése egy új munkamegrendelés létrehozása után';
    $Self->{Translation}->{'Shows a checkbox in the AgentITSMWorkOrderEdit screen that defines if the the following workorders should also be moved if a workorder is modified and the planned end time has changed.'} =
        'Egy jelölőnégyzetet jelenít meg az AgentITSMWorkOrderEdit képernyőn, amely azt határozza meg, hogy a következő munkamegrendeléseket is át kell-e helyezni, ha egy munkamegrendelés módosult és a tervezett befejezési idő megváltozott.';
    $Self->{Translation}->{'Shows a link in the menu that allows changing the work order agent, in the zoom view of such work order of the agent interface.'} =
        'Egy hivatkozást jelenít meg a menüben, amely lehetővé teszi a munkamegrendelés ügyintézőjének megváltoztatását az ügyintézői felületnek az ilyen munkamegrendelés nagyítási nézetén.';
    $Self->{Translation}->{'Shows a link in the menu that allows defining a change as a template in the zoom view of the change, in the agent interface.'} =
        'Egy hivatkozást jelenít meg a menüben, amely lehetővé teszi egy változás sablonként való meghatározását a változás nagyítás nézetében az ügyintézői felületen.';
    $Self->{Translation}->{'Shows a link in the menu that allows defining a work order as a template in the zoom view of the work order, in the agent interface.'} =
        'Egy hivatkozást jelenít meg a menüben, amely lehetővé teszi egy munkamegrendelés sablonként való meghatározását a munkamegrendelés nagyítás nézetében az ügyintézői felületen.';
    $Self->{Translation}->{'Shows a link in the menu that allows editing the report of a workd order, in the zoom view of such work order of the agent interface.'} =
        'Egy hivatkozást jelenít meg a menüben, amely lehetővé teszi egy munkamegrendelés jelentésének szerkesztését az ügyintézői felületnek az ilyen munkamegrendelés nagyítási nézetén.';
    $Self->{Translation}->{'Shows a link in the menu that allows linking a change with another object in the change zoom view of the agent interface.'} =
        'Egy hivatkozást jelenít meg a menüben, amely lehetővé teszi egy változás összekapcsolását egy másik objektummal az ügyintézői felület változás nagyítás nézetében.';
    $Self->{Translation}->{'Shows a link in the menu that allows linking a work order with another object in the zoom view of such work order of the agent interface.'} =
        'Egy hivatkozást jelenít meg a menüben, amely lehetővé teszi egy munkamegrendelés hozzákapcsolását egy másik objektumhoz az ügyintézői felületnek az ilyen munkamegrendelés nagyítási nézetén.';
    $Self->{Translation}->{'Shows a link in the menu that allows moving the time slot of a change in its zoom view of the agent interface.'} =
        'Egy hivatkozást jelenít meg a menüben, amely lehetővé teszi egy változás időrésének áthelyezését az ügyintézői felületen az elem nagyítási nézetében.';
    $Self->{Translation}->{'Shows a link in the menu that allows taking a work order in the its zoom view of the agent interface.'} =
        'Egy hivatkozást jelenít meg a menüben, amely lehetővé teszi egy munkamegrendelés felvételét az ügyintézői felületen az elem nagyítási nézetében.';
    $Self->{Translation}->{'Shows a link in the menu to access the conditions of a change in the its zoom view of the agent interface.'} =
        'Egy hivatkozást jelenít meg a menüben egy változás feltételeinek eléréséhez az ügyintézői felületen az elem nagyítási nézetében.';
    $Self->{Translation}->{'Shows a link in the menu to access the history of a change in the its zoom view of the agent interface.'} =
        'Egy hivatkozást jelenít meg a menüben egy változás előzményeinek eléréséhez az ügyintézői felületen az elem nagyítási nézetében.';
    $Self->{Translation}->{'Shows a link in the menu to access the history of a work order in the its zoom view of the agent interface.'} =
        'Egy hivatkozást jelenít meg a menüben egy munkamegrendelés előzményeinek eléréséhez az ügyintézői felületen az elem nagyítási nézetében.';
    $Self->{Translation}->{'Shows a link in the menu to add a work order in the change zoom view of the agent interface.'} =
        'Egy hivatkozást jelenít meg a menüben egy munkamegrendelés hozzáadásához az ügyintézői felület változás nagyítás nézetében.';
    $Self->{Translation}->{'Shows a link in the menu to delete a change in its zoom view of the agent interface.'} =
        'Egy hivatkozást jelenít meg a menüben egy változás törléséhez az ügyintézői felületen az elem nagyítási nézetében.';
    $Self->{Translation}->{'Shows a link in the menu to delete a work order in its zoom view of the agent interface.'} =
        'Egy hivatkozást jelenít meg a menüben egy munkamegrendelés törléséhez az ügyintézői felületen az elem nagyítási nézetében.';
    $Self->{Translation}->{'Shows a link in the menu to edit a change in the its zoom view of the agent interface.'} =
        'Egy hivatkozást jelenít meg a menüben egy változás szerkesztéséhez az ügyintézői felületen az elem nagyítási nézetében.';
    $Self->{Translation}->{'Shows a link in the menu to edit a work order in the its zoom view of the agent interface.'} =
        'Egy hivatkozást jelenít meg a menüben egy munkamegrendelés szerkesztéséhez az ügyintézői felületen az elem nagyítási nézetében.';
    $Self->{Translation}->{'Shows a link in the menu to go back in the change zoom view of the agent interface.'} =
        'Egy hivatkozást jelenít meg a menüben az ügyintézői felület változás nagyítási nézetébe való visszatéréshez.';
    $Self->{Translation}->{'Shows a link in the menu to go back in the work order zoom view of the agent interface.'} =
        'Egy hivatkozást jelenít meg a menüben az ügyintézői felület munkamegrendelés nagyítási nézetébe való visszatéréshez.';
    $Self->{Translation}->{'Shows a link in the menu to print a change in the its zoom view of the agent interface.'} =
        'Egy hivatkozást jelenít meg a menüben egy változás nyomtatásához az ügyintézői felületen az elem nagyítási nézetében.';
    $Self->{Translation}->{'Shows a link in the menu to print a work order in the its zoom view of the agent interface.'} =
        'Egy hivatkozást jelenít meg a menüben egy munkamegrendelés nyomtatásához az ügyintézői felületen az elem nagyítási nézetében.';
    $Self->{Translation}->{'Shows a link in the menu to reset a change and its workorders in its zoom view of the agent interface.'} =
        'Egy hivatkozást jelenít meg a menüben egy változás és annak munkamegrendelései visszaállításához az ügyintézői felületen az elem nagyítási nézetében.';
    $Self->{Translation}->{'Shows the change history (reverse ordered) in the agent interface.'} =
        'Megjeleníti a változás előzményeit (fordított sorrendben) az ügyintézői felületen.';
    $Self->{Translation}->{'State Machine'} = 'Állapotgép';
    $Self->{Translation}->{'Stores change and workorder ids and their corresponding template id, while a user is editing a template.'} =
        'Változás- és munkamegrendelés-azonosítókat, valamint a nekik megfelelő sablonazonosítót tárolja, miközben egy felhasználó szerkeszt egy sablont.';
    $Self->{Translation}->{'Take Workorder.'} = '';
    $Self->{Translation}->{'Template.'} = '';
    $Self->{Translation}->{'The identifier for a change, e.g. Change#, MyChange#. The default is Change#.'} =
        'Egy változás azonosítója, például Change#, MyChange#. Az alapértelmezett: Change#.';
    $Self->{Translation}->{'The identifier for a workorder, e.g. Workorder#, MyWorkorder#. The default is Workorder#.'} =
        'Egy munkamegrendelés azonosítója, például Workorder#, MyWorkorder#. Az alapértelmezett: Workorder#.';
    $Self->{Translation}->{'This ACL module restricts the usuage of the ticket types that are defined in the sysconfig option \'ITSMChange::AddChangeLinkTicketTypes\', to users of the groups as defined in "ITSMChange::RestrictTicketTypes::Groups". As this ACL could collide with other ACLs which are also related to the ticket type, this sysconfig option is disabled by default and should only be activated if needed.'} =
        'Ez az ACL modul korlátozza az „ITSMChange::AddChangeLinkTicketTypes” rendszerbeállítási lehetőségben meghatározott jegytípusok használatát az „ITSMChange::RestrictTicketTypes::Groups” csoportban meghatározott felhasználókra. Mivel ez az ACL ütközhet más olyan ACL-ekkel, amelyek szintén a jegytípussal vannak összefüggésben, ezért ez a rendszerbeállítási lehetőség alapértelmezetten le van tiltva, és csak akkor kell aktiválni, ha szükséges.';
    $Self->{Translation}->{'Types of tickets, where in the ticket zoom view a link to add a change will be displayed.'} =
        'Jegyek típusai, ahol a jegy nagyítás nézetben egy változás hozzáadására mutató hivatkozás lesz megjelenítve.';
    $Self->{Translation}->{'Workorder Add (from template).'} = '';
    $Self->{Translation}->{'Workorder Add.'} = '';
    $Self->{Translation}->{'Workorder Agent.'} = '';
    $Self->{Translation}->{'Workorder Delete.'} = '';
    $Self->{Translation}->{'Workorder Edit.'} = '';
    $Self->{Translation}->{'Workorder History Zoom.'} = '';
    $Self->{Translation}->{'Workorder History.'} = '';
    $Self->{Translation}->{'Workorder Report.'} = '';
    $Self->{Translation}->{'Workorder Zoom.'} = '';
    $Self->{Translation}->{'once'} = '';
    $Self->{Translation}->{'regularly'} = '';

}

1;
