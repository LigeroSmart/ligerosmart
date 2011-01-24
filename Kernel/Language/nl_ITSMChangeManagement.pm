# --
# Kernel/Language/nl_ITSMChangeManagement.pm - the Dutch translation of ITSMChangeManagement
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: nl_ITSMChangeManagement.pm,v 1.3 2011-01-24 10:38:42 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::nl_ITSMChangeManagement;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    # misc
    $Lang->{'A change must have a title!'}          = 'Vul een titel in voor de change.';
    $Lang->{'Template Name'}                        = 'Template-naam';
    $Lang->{'Templates'}                            = 'Templates';
    $Lang->{'A workorder must have a title!'}       = 'Vul een titel in voor de workorder';
    $Lang->{'Clear'}                                = 'Leegmaken';
    $Lang->{'Create a change from this ticket!'}    = 'Maak een change van dit ticket';
    $Lang->{'Create Change'}                        = 'Change aanmaken';
    $Lang->{'e.g.'}                                 = 'bijvoorbeeld';
    $Lang->{'Save Change as Template'}              = 'Bewaar Change als template';
    $Lang->{'Reset States'}                         = 'Statussen resetten';
    $Lang->{'Save Workorder as template'}           = 'Bewaar Work Order als template';
    $Lang->{'Save this CAB as template'}            = 'Bewaar dit CAB als template';
    $Lang->{'New time'}                             = 'Nieuw tijdstip';
    $Lang->{'Requested (by customer) Date'}         = 'Aangevraagd door klant voor datum';
    $Lang->{'The planned end time is invalid!'}     = 'De geplande eindtijd is ongeldig';
    $Lang->{'The planned start time is invalid!'}   = 'Die geplande eindtijd is';
    $Lang->{'The planned start time must be before the planned end time!'}
        = 'De gepande starttijd moet eerder zijn dan de einddatum.';
    $Lang->{'The requested time is invalid!'}       = 'Die angegebene Zeit ist ungültig!';
    $Lang->{'Time type'}                            = 'Tijd-type';
    $Lang->{'Do you really want to delete this template?'} = 'Wilt u deze template echt verwijderen?';
    $Lang->{'Change Advisory Board'}                = 'Change Advisory Board';
    $Lang->{'CAB'}                                  = 'CAB';
    $Lang->{'Apply Template'}                       = 'Kies template';
    $Lang->{'Last changed'}                         = 'Laatst aangepast op';
    $Lang->{'Last changed by'}                      = 'Laatst aangepast door';

    # ITSM ChangeManagement menu
    $Lang->{'My Changes'}                           = 'Mijn changes';
    $Lang->{'My Workorders'}                        = 'Mijn workorders';
    $Lang->{'PIR (Post Implementation Review)'}     = 'PIR (Post Implementation Review)';
    $Lang->{'PSA (Projected Service Availability)'} = 'PSA (Projected Service Availability)';
    $Lang->{'My CABs'}                              = 'Mijn CABs';
    $Lang->{'Change Overview'}                      = 'Changeoverzicht';
    $Lang->{'Template Overview'}                    = 'Templateoverzicht';
    $Lang->{'Search Changes'}                       = 'Zoek Changes';

    # Change menu
    $Lang->{'ITSM Change'}                          = 'Change';
    $Lang->{'ITSM Changes'}                          = 'Changes';
    $Lang->{'ITSM Workorder'}                        = 'Workorder';
    $Lang->{'Schedule'}                              = 'Schedule';
    $Lang->{'Involved Persons'}                      = 'Betrokken personen';
    $Lang->{'Add Workorder'}                         = 'Workorder toevoegen';
    $Lang->{'Template'}                              = 'Template';
    $Lang->{'Move Time Slot'}                        = 'Verplaats timeslot';
    $Lang->{'Print the change'}                      = 'Change afdrukken';
    $Lang->{'Edit the change'}                       = 'Change wijzigen';
    $Lang->{'Change involved persons of the change'} = 'Wijzig de betrokken personen bij deze change';
    $Lang->{'Add a workorder to the change'}         = 'Voeg een workorder toe aan deze change';
    $Lang->{'Edit the conditions of the change'}     = 'Wijzig de condities van deze change';
    $Lang->{'Link another object to the change'}     = 'Koppel een object aan deze change';
    $Lang->{'Save change as a template'}             = 'Sla deze change op als template';
    $Lang->{'Move all workorders in time'}           = 'Verplaats alle workorders in tijd';
    $Lang->{'Current CAB'}                           = 'Actueel CAB';
    $Lang->{'Add to CAB'}                            = 'Toevoegen aan CAB';
    $Lang->{'Add CAB Template'}                      = 'CAB template toevoegen';
    $Lang->{'Add Workorder to'}                      = 'Voeg werkorder toe aan';
    $Lang->{'Select Workorder Template'}             = 'Workorder template kiezen';
    $Lang->{'Select Change Template'}                = 'Change template kiezen';
    $Lang->{'The planned time is invalid!'}          = 'Het geplande tijdstip is ongeldig';

    # Workorder menu
    $Lang->{'Workorder'}                            = 'Work Order';
    $Lang->{'Save workorder as a template'}         = 'Workorder als template opslaan';
    $Lang->{'Link another object to the workorder'} = 'Koppel een ander object aan deze Work Order';
    $Lang->{'Delete Workorder'}                     = 'Work Order verwijderen';
    $Lang->{'Edit the workorder'}                   = 'Work Order wijzigen';
    $Lang->{'Print the workorder'}                  = 'Work Order afdrukken';
    $Lang->{'Set the agent for the workorder'}      = 'Kies een agent voor Work Order';

    # Template menu
    $Lang->{'A template must have a name!'} = 'Kies een naam voor de template.';

    # History interface
    $Lang->{'Show details'}                         = 'Toon details';
    $Lang->{'Show workorder'}                       = 'Toon Work Order';
    $Lang->{'Old Value'}                            = 'Oude waarde';
    $Lang->{'New Value'}                            = 'Nieuwe waarde';
    $Lang->{'Detailed history information of'}      = 'Gedetailleerde informatie van';

    # Change attributes as returned from ChangeGet(), or taken by ChangeUpdate()
    $Lang->{'AccountedTime'}    = 'Vastgelegde tijd';
    $Lang->{'ActualEndTime'}    = 'Werkelijke eindtijd';
    $Lang->{'ActualStartTime'}  = 'Werkelijke starttijd';
    $Lang->{'CABAgent'}         = 'CAB gebruiker';
    $Lang->{'CABAgents'}        = 'CAB gebruikers';
    $Lang->{'CABCustomer'}      = 'CAB klant';
    $Lang->{'CABCustomers'}     = 'CAB klanten';
    $Lang->{'Category'}         = 'Categorie';
    $Lang->{'ChangeBuilder'}    = 'Change-samensteller';
    $Lang->{'ChangeBy'}         = 'Aangepast door';
    $Lang->{'ChangeManager'}    = 'Change Manager';
    $Lang->{'ChangeNumber'}     = 'Changenummer';
    $Lang->{'ChangeTime'}       = 'Aangepast op';
    $Lang->{'ChangeState'}      = 'Change-status';
    $Lang->{'ChangeTitle'}      = 'Change-titel';
    $Lang->{'CreateBy'}         = 'Aangemaakt door';
    $Lang->{'CreateTime'}       = 'Aangemaakt op';
    $Lang->{'Description'}      = 'Beschrijving';
    $Lang->{'Impact'}           = 'Impact';
    $Lang->{'Justification'}    = 'Rechtvaardiging';
    $Lang->{'PlannedEffort'}    = 'Geplande inspanning';
    $Lang->{'PlannedEndTime'}   = 'Geplande eindtijd';
    $Lang->{'PlannedStartTime'} = 'Geplande starttijd';
    $Lang->{'Priority'}         = 'Prioriteit';
    $Lang->{'RequestedTime'}    = 'Gevraagde implementatietijd';
    $Lang->{'Requested Date'}    = 'Gevraagde implementatietijd';

    # Workorder attributes as returned from WorkOrderGet(), or taken by WorkOrderUpdate()
    $Lang->{'Instruction'}      = 'Instructie';
    $Lang->{'Report'}           = 'Bericht';
    $Lang->{'WorkOrderAgent'}   = 'Work Order-gebruiker';
    $Lang->{'WorkOrderNumber'}  = 'Work Order-nummer';
    $Lang->{'WorkOrderState'}   = 'Work Order-status';
    $Lang->{'WorkOrderTitle'}   = 'Work Order-titel';
    $Lang->{'WorkOrderType'}    = 'Work Order-type';

    # Change history
    $Lang->{'ChangeHistory::ChangeAdd'}              = 'Nieuwe Change (ID=%s)';
    $Lang->{'ChangeHistory::ChangeUpdate'}           = '%s: nieuw: %s -> oud: %s';
    $Lang->{'ChangeHistory::ChangeLinkAdd'}          = 'Link naar %s (ID=%s) toegevoegd';
    $Lang->{'ChangeHistory::ChangeLinkDelete'}       = 'Link naar %s (ID=%s) verwijderd';
    $Lang->{'ChangeHistory::ChangeCABUpdate'}        = '%s: nieuw: %s -> oud: %s';
    $Lang->{'ChangeHistory::ChangeCABDelete'}        = 'CAB verwijderd %s';
    $Lang->{'ChangeHistory::ChangeAttachmentAdd'}    = 'Nieuwe bijlage: %s';
    $Lang->{'ChangeHistory::ChangeAttachmentDelete'} = 'Bijlage verwijderd: %s';
    $Lang->{'ChangeHistory::ChangeNotificationSent'} = 'Notificatie gestuurd aan %s(Event: %s)';

    # workorder history
    $Lang->{'WorkOrderHistory::WorkOrderAdd'}              = 'nieuwe Workorder (ID=%s)';
    $Lang->{'WorkOrderHistory::WorkOrderUpdate'}           = '%s: nieuw: %s -> oud: %s';
    $Lang->{'WorkOrderHistory::WorkOrderLinkAdd'}          = 'Link naar %s (ID=%s) toegevoegd';
    $Lang->{'WorkOrderHistory::WorkOrderLinkDelete'}       = 'Link naar %s (ID=%s) verwijderd';
    $Lang->{'WorkOrderHistory::WorkOrderDelete'}           = 'Work Order (ID=%s) verwijderd';
    $Lang->{'WorkOrderHistory::WorkOrderAttachmentAdd'}    = 'Nieuwe bijlage bij Work Order: %s';
    $Lang->{'WorkOrderHistory::WorkOrderAttachmentDelete'} = 'Bijlage van Work Order verwijderd: %s';
    $Lang->{'WorkOrderHistory::WorkOrderNotificationSent'} = 'Notificatie gestuurd aan %s (Event: %s)';

    # long workorder history
    $Lang->{'WorkOrderHistory::WorkOrderAddWithWorkOrderID'}              = 'Nieuw Work Order (ID=%s)';
    $Lang->{'WorkOrderHistory::WorkOrderUpdateWithWorkOrderID'}           = '(ID=%s) %s: nieuw: %s -> oud: %s';
    $Lang->{'WorkOrderHistory::WorkOrderLinkAddWithWorkOrderID'}          = '(ID=%s) Link naar %s (ID=%s) toegevoegd';
    $Lang->{'WorkOrderHistory::WorkOrderLinkDeleteWithWorkOrderID'}       = '(ID=%s) Link naar %s (ID=%s) verwijderd';
    $Lang->{'WorkOrderHistory::WorkOrderDeleteWithWorkOrderID'}           = 'Workorder (ID=%s) verwijderd';
    $Lang->{'WorkOrderHistory::WorkOrderAttachmentAddWithWorkOrderID'}    = '(ID=%s) Nieuwe bijlage bij Work Order: %s';
    $Lang->{'WorkOrderHistory::WorkOrderAttachmentDeleteWithWorkOrderID'} = '(ID=%s) Bijlage van Work Order verwijderd: %s';
    $Lang->{'WorkOrderHistory::WorkOrderNotificationSentWithWorkOrderID'} = '(ID=%s) Notificatie gestuurd aan %s (Event: %s)';

    # condition history
    $Lang->{'ChangeHistory::ConditionAdd'}       = '%s: %s';
    $Lang->{'ChangeHistory::ConditionAddID'}     = 'Nieuwe conditie (ID=%s)';
    $Lang->{'ChangeHistory::ConditionUpdate'}    = '%s (conditie ID=%s): nieuw: %s -> oud: %s';
    $Lang->{'ChangeHistory::ConditionDelete'}    = 'Conditie (ID=%s) verwijderd';
    $Lang->{'ChangeHistory::ConditionDeleteAll'} = 'Alle condities voor change (ID=%s) verwijderd.';

    # expression history
    $Lang->{'ChangeHistory::ExpressionAdd'}       = '%s: %s';
    $Lang->{'ChangeHistory::ExpressionAddID'}     = 'Nieuwe expressie (ID=%s)';
    $Lang->{'ChangeHistory::ExpressionUpdate'}    = '%s (expressie-ID=%s): nieuw: %s -> oud: %s';
    $Lang->{'ChangeHistory::ExpressionDelete'}    = 'Expressie (ID=%s) verwijderd';
    $Lang->{'ChangeHistory::ExpressionDeleteAll'} = 'Alle expressies voor change (ID=%s) verwijderd';

    # action history
    $Lang->{'ChangeHistory::ActionAdd'}       = '%s: %s';
    $Lang->{'ChangeHistory::ActionAddID'}     = 'Nieuwe actie (ID=%s)';
    $Lang->{'ChangeHistory::ActionUpdate'}    = '%s (Actie-ID=%s): nieuw: %s -> Old: %s';
    $Lang->{'ChangeHistory::ActionDelete'}    = 'Actie (ID=%s) verwijderd';
    $Lang->{'ChangeHistory::ActionDeleteAll'} = 'Alle akties (ID=%s) verwijderd';
    $Lang->{'ChangeHistory::ActionExecute'}   = 'Actie (ID=%s) uitgevoerd: %s';
    $Lang->{'ActionExecute::successfully'}    = 'succesvol';
    $Lang->{'ActionExecute::unsuccessfully'}  = 'niet succesvol';

    # history for time events
    $Lang->{'ChangeHistory::ChangePlannedStartTimeReached'}                      = 'Change (ID=%s) heeft de geplande starttijd bereikt.';
    $Lang->{'ChangeHistory::ChangePlannedEndTimeReached'}                        = 'Change (ID=%s) heeft de geplande eindtijd bereikt.';
    $Lang->{'ChangeHistory::ChangeActualStartTimeReached'}                       = 'Change (ID=%s) is begonnen.';
    $Lang->{'ChangeHistory::ChangeActualEndTimeReached'}                         = 'Change (ID=%s) is beëindigd.';
    $Lang->{'ChangeHistory::ChangeRequestedTimeReached'}                         = 'Change (ID=%s) heeft de aangevraagde eindtijd bereikt.';
    $Lang->{'WorkOrderHistory::WorkOrderPlannedStartTimeReached'}                = 'Work Order (ID=%s) heeft de geplande starttijd bereikt.';
    $Lang->{'WorkOrderHistory::WorkOrderPlannedEndTimeReached'}                  = 'Work Order (ID=%s) heeft de geplande eindtijd bereikt.';
    $Lang->{'WorkOrderHistory::WorkOrderActualStartTimeReached'}                 = 'Work Order (ID=%s) is begonnen.';
    $Lang->{'WorkOrderHistory::WorkOrderActualEndTimeReached'}                   = 'Work Order (ID=%s) is beëindigd.';
    $Lang->{'WorkOrderHistory::WorkOrderPlannedStartTimeReachedWithWorkOrderID'} = 'Work Order (ID=%s) heeft de geplande starttijd bereikt.';
    $Lang->{'WorkOrderHistory::WorkOrderPlannedEndTimeReachedWithWorkOrderID'}   = 'Work Order (ID=%s) heeft de geplande eindtijd bereikt.';
    $Lang->{'WorkOrderHistory::WorkOrderActualStartTimeReachedWithWorkOrderID'}  = 'Work Order (ID=%s) is begonnen.';
    $Lang->{'WorkOrderHistory::WorkOrderActualEndTimeReachedWithWorkOrderID'}    = 'Work Order (ID=%s) is beëindigd.';

    # change states
    $Lang->{'requested'}        = 'Aangevraagd';
    $Lang->{'pending approval'} = 'Wacht op goedkeuring';
    $Lang->{'pending pir'}      = 'Wacht op PIR';
    $Lang->{'rejected'}         = 'Afgewezen';
    $Lang->{'approved'}         = 'Goedgekeurd';
    $Lang->{'in progress'}      = 'In uitvoering';
    $Lang->{'successful'}       = 'Succesvol';
    $Lang->{'failed'}           = 'Mislukt';
    $Lang->{'canceled'}         = 'Gecanceld';
    $Lang->{'retracted'}        = 'Ingetrokken';

    # workorder states
    $Lang->{'created'}     = 'Aangemaakt';
    $Lang->{'accepted'}    = 'Geaccepteerd';
    $Lang->{'ready'}       = 'Klaar';
    $Lang->{'in progress'} = 'In uitvoering';
    $Lang->{'closed'}      = 'Gesloten';
    $Lang->{'canceled'}    = 'Gecanceld';

    # Admin Interface
    $Lang->{'Category <-> Impact <-> Priority'}      = 'Categorie <-> Impact <-> Prioriteit';
    $Lang->{'Notification (ITSM Change Management)'} = 'Notificaties (ITSM Change Management)';

    # Admin StateMachine
    $Lang->{'Add a state transition'}               = 'Nieuwe statusovergang toevoegen';
    $Lang->{'Add a new state transition for'}       = 'Voeg een nieuwe statusovergang toe voor';
    $Lang->{'Edit a state transition for'}          = 'Bewerken van statusovergangen voor';
    $Lang->{'Overview over state transitions for'}  = 'Overzicht van statusovergangen voor';
    $Lang->{'Object Name'}                          = 'Object-naam';
    $Lang->{'Please select first a catalog class!'} = 'Kies een Catalog klasse.';

    # workorder types
    $Lang->{'approval'}  = 'Goedkeuring';
    $Lang->{'decision'}  = 'Beslissing';
    $Lang->{'workorder'} = 'Work Order';
    $Lang->{'backout'}   = 'Backout Plan';
    $Lang->{'pir'}       = 'PIR (Post Implementation Review)';

    # objects that can be used in condition expressions and actions
    $Lang->{'ITSMChange'}    = 'Change';
    $Lang->{'ITSMWorkOrder'} = 'Work Order';
    $Lang->{'ITSMCondition'} = 'Conditie';

    # Overviews
    $Lang->{'Change Schedule'} = 'Change Schedule';

    # Workorder delete
    $Lang->{'Do you really want to delete this workorder?'} = 'Wilt u deze Work Order verwijderen?';
    $Lang->{'You can not delete this Workorder. It is used in at least one Condition!'} = 'Deze Work Order kan niet verwijderd worden. Hij is in tenminste één conditie gebruikt.';
    $Lang->{'This Workorder is used in the following Condition(s)'} = 'Deze Work Order is gebruikt in de volgende conditie(s)';

    # Take workorder
    $Lang->{'Take Workorder'}                             = 'Work Order overnemen';
    $Lang->{'Take the workorder'}                         = 'Deze Work Order overnemen';
    $Lang->{'Current Agent'}                              = 'Aktuele gebruiker';
    $Lang->{'Do you really want to take this workorder?'} = 'Deze Work Order overnemen?';

    # Condition Overview and Edit
    $Lang->{'Condition'}                                = 'Conditie';
    $Lang->{'Conditions'}                               = 'Condities';
    $Lang->{'Expression'}                               = 'Voorwaarde';
    $Lang->{'Expressions'}                              = 'Voorwaarden';
    $Lang->{'Action'}                                   = 'Actie';
    $Lang->{'Actions'}                                  = 'Acties';
    $Lang->{'Matching'}                                 = 'Matching';
    $Lang->{'Conditions and Actions'}                   = 'Condities en acties';
    $Lang->{'Add new condition and action pair'}        = 'Voeg een contitie- en actie-paar toe';
    $Lang->{'A condition must have a name!'}            = 'Vul een titel in voor de conditie';
    $Lang->{'Condition Edit'}                           = 'Contities bewerken';
    $Lang->{'Add new expression'}                       = 'Nieuwe voorwaarde toevoegen';
    $Lang->{'Add new action'}                           = 'Nieuwe actie toevoegen';
    $Lang->{'Any expression (OR)'}                      = 'Een voorwaarde (OR)';
    $Lang->{'All expressions (AND)'}                    = 'Alle voorwaarden (AND)';
    $Lang->{'Attribute'}                                = 'Attribuut';
    $Lang->{'Value'}                                    = 'Waarde';
    $Lang->{'any'}                                      = 'enkele';
    $Lang->{'all'}                                      = 'alle';
    $Lang->{'is'}                                       = 'is';
    $Lang->{'is not'}                                   = 'is niet';
    $Lang->{'is empty'}                                 = 'is leeg';
    $Lang->{'is not empty'}                             = 'is niet leeg';
    $Lang->{'is greater than'}                          = 'is groter dan';
    $Lang->{'is less than'}                             = 'is kleiner dan';
    $Lang->{'is before'}                                = 'is eerder dan';
    $Lang->{'is after'}                                 = 'is later dan';
    $Lang->{'contains'}                                 = 'bevat';
    $Lang->{'not contains'}                             = 'bevat niet';
    $Lang->{'begins with'}                              = 'begint met';
    $Lang->{'ends with'}                                = 'eindigt op';
    $Lang->{'set'}                                      = 'plaats';
    $Lang->{'lock'}                                     = 'grendel';

    # Change Zoom
    $Lang->{'Change Initiator(s)'} = 'Change initiator(s)';

    # AgentITSMChangePrint
    $Lang->{'Linked Objects'} = 'Gekoppelde objecten';
    $Lang->{'Full-Text Search in Change and Workorder'} =
        'Zoeken op tekst binnen changes en work orders';

    # AgentITSMChangeSearch
    $Lang->{'No XXX settings'} = "Geen '%s' gekozen";

    return 1;
}

1;
