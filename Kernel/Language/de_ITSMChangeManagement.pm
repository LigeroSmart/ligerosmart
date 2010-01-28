# --
# Kernel/Language/de_ITSMChangeManagement.pm - the german translation of ITSMChangeManagement
# Copyright (C) 2003-2010 OTRS AG, http://otrs.com/
# --
# $Id: de_ITSMChangeManagement.pm,v 1.30 2010-01-28 12:27:57 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::de_ITSMChangeManagement;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.30 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'A change must have a title!'}        = 'Ein Change benötigt einen Titel!';
    $Lang->{'A workorder must have a title!'}     = 'Eine Workorder benötigt einen Titel!';
    $Lang->{'Add Change'}                         = 'Change hinzufügen';
    $Lang->{'New time'}                           = 'Neuer Zeitpunkt';
    $Lang->{'The planned start time is invalid!'} = 'Der geplante Startzeitpunk ist ungültig!';
    $Lang->{'The planned end time is invalid!'}   = 'Der geplante Endzeitpunkt ist ungültig!';
    $Lang->{'The planned start time must be before the planned end time!'}
        = 'Der geplante Start muss vor dem geplanten Ende liegen!';
    $Lang->{'Time type'}                          = 'Art des Zeitpunktes';
    $Lang->{'Requested (by customer) Date'}       = 'Wunschtermin (des Kunden)';
    $Lang->{'Imperative::Save'}                   = 'Speichere';
    $Lang->{'as Template'}                        = 'als Vorlage';

    # Change menu
    $Lang->{'ITSM Change'} = 'Change';

    # Change attributes as returned from ChangeGet(), or taken by ChangeUpdate()
    $Lang->{'ChangeAttribute::AccountedTime'}    = 'Benötigte Zeit';
    $Lang->{'ChangeAttribute::ActualStartTime'}  = 'Tatsächlicher Start';
    $Lang->{'ChangeAttribute::ActualEndTime'}    = 'Tatsächliches Ende';
    $Lang->{'ChangeAttribute::CABAgents'}        = 'CAB Agents';
    $Lang->{'ChangeAttribute::CABCustomers'}     = 'CAB Customers';
    $Lang->{'ChangeAttribute::ChangeBuilder'}    = 'Change Builder';
    $Lang->{'ChangeAttribute::ChangeManager'}    = 'Change Manager';
    $Lang->{'ChangeAttribute::ChangeState'}      = 'Change State';
    $Lang->{'ChangeAttribute::PlannedEffort'}    = 'Geplanter Aufwand';
    $Lang->{'ChangeAttribute::PlannedStartTime'} = 'Geplanter Start';
    $Lang->{'ChangeAttribute::PlannedEndTime'}   = 'Geplantes Ende';
    $Lang->{'ChangeAttribute::RequestedTime'}    = 'Wunschtermin';

    # Change history
    $Lang->{'ChangeHistory::ChangeAdd'}              = 'Neuer Change (ID=%s)';
    $Lang->{'ChangeHistory::ChangeUpdate'}           = '%s: Neu: %s -> Alt: %s';
    $Lang->{'ChangeHistory::ChangeLinkAdd'}          = 'Link zu %s (ID=%s) hinzugefügt';
    $Lang->{'ChangeHistory::ChangeLinkDelete'}       = 'Link zu %s (ID=%s) gelöscht';
    $Lang->{'ChangeHistory::ChangeCABUpdate'}        = '%s: Neu: %s -> Alt: %s';
    $Lang->{'ChangeHistory::ChangeCABDelete'}        = 'CAB gelöscht %s';
    $Lang->{'ChangeHistory::ChangeAttachmentAdd'}    = 'Neuer Anhang: %s';
    $Lang->{'ChangeHistory::ChangeAttachmentDelete'} = 'Anhang gelöscht: %s';

    # workorder history
    $Lang->{'WorkOrderHistory::WorkOrderAdd'}              = 'Neue Workorder (ID=%s)';
    $Lang->{'WorkOrderHistory::WorkOrderUpdate'}           = '%s: Neu: %s -> Alt: %s';
    $Lang->{'WorkOrderHistory::WorkOrderLinkAdd'}          = 'Link zu %s (ID=%s) hinzugefügt';
    $Lang->{'WorkOrderHistory::WorkOrderLinkDelete'}       = 'Link to %s (ID=%s) gelöscht';
    $Lang->{'WorkOrderHistory::WorkOrderDelete'}           = 'Workorder (ID=%s) gelöscht';
    $Lang->{'WorkOrderHistory::WorkOrderAttachmentAdd'}    = 'Neuer Anhang für Workorder: %s';
    $Lang->{'WorkOrderHistory::WorkOrderAttachmentDelete'} = 'Anhang von Workorder gelöscht: %s';

    # long workorder history
    $Lang->{'WorkOrderHistory::WorkOrderAddWithWorkOrderID'}              = 'Neue Workorder (ID=%s)';
    $Lang->{'WorkOrderHistory::WorkOrderUpdateWithWorkOrderID'}           = '(ID=%s) %s: Neu: %s -> Alt: %s';
    $Lang->{'WorkOrderHistory::WorkOrderLinkAddWithWorkOrderID'}          = '(ID=%s) Link zu %s (ID=%s) hinzugefügt';
    $Lang->{'WorkOrderHistory::WorkOrderLinkDeleteWithWorkOrderID'}       = '(ID=%s) Link to %s (ID=%s) gelöscht';
    $Lang->{'WorkOrderHistory::WorkOrderDeleteWithWorkOrderID'}           = 'Workorder (ID=%s) gelöscht';
    $Lang->{'WorkOrderHistory::WorkOrderAttachmentAddWithWorkOrderID'}    = '(ID=%s) Neuer Anhang für Workorder: %s';
    $Lang->{'WorkOrderHistory::WorkOrderAttachmentDeleteWithWorkOrderID'} = '(ID=%s) Anhang von Workorder gelöscht: %s';

    # change states
    $Lang->{'requested'}        = 'Requested';
    $Lang->{'pending approval'} = 'Pending Approval';
    $Lang->{'rejected'}         = 'Rejected';
    $Lang->{'approved'}         = 'Approved';
    $Lang->{'in progress'}      = 'In Progress';
    $Lang->{'successful'}       = 'Successful';
    $Lang->{'failed'}           = 'Failed';
    $Lang->{'canceled'}         = 'Canceled';
    $Lang->{'retracted'}        = 'Retracted';

    # workorder states
    $Lang->{'created'}     = 'Created';
    $Lang->{'accepted'}    = 'Accepted';
    $Lang->{'ready'}       = 'Ready';
    $Lang->{'in progress'} = 'In Progress';
    $Lang->{'closed'}      = 'Closed';
    $Lang->{'canceled'}    = 'Canceled';

    # CIP matrix
    $Lang->{'Category'}                         = 'Kategorie';
    $Lang->{'Category <-> Impact <-> Priority'} = 'Kategorie <-> Auswirkung <-> Priorität';

    # workorder types
    $Lang->{'approval'}  = 'Genehmigung';
    $Lang->{'decision'}  = 'Entscheidung';
    $Lang->{'workorder'} = 'Workorder';
    $Lang->{'backout'}   = 'Backout Plan';
    $Lang->{'pir'}       = 'PIR (Post Implementation Review)';

    # Template types
    $Lang->{'TemplateType::ITSMChange'}      = 'Change';
    $Lang->{'TemplateType::ITSMWorkOrder'}   = 'Workorder';
    $Lang->{'TemplateType::CAB'}             = 'CAB';
    $Lang->{'TemplateType::ITSMCondition'}   = 'Condition';

    # Overviews
    $Lang->{'Change Schedule'} = 'Change Schedule';

    return 1;
}

1;
