# --
# Kernel/Language/en_ITSMChangeManagement.pm - the english translation of ITSMChangeManagement
# Copyright (C) 2003-2010 OTRS AG, http://otrs.com/
# --
# $Id: en_ITSMChangeManagement.pm,v 1.25 2010-01-28 15:41:20 mae Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::en_ITSMChangeManagement;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.25 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{''} = '';

    $Lang->{'Imperative::Save'}                   = 'Save';

    # Change menu
    $Lang->{'ITSM Change'} = 'Change';

    # Change attributes as returned from ChangeGet(), or taken by ChangeUpdate()
    $Lang->{'ChangeAttribute::AccountedTime'}    = 'Accounted Time';
    $Lang->{'ChangeAttribute::ActualStartTime'}  = 'Actual Start';
    $Lang->{'ChangeAttribute::ActualEndTime'}    = 'Actual End';
    $Lang->{'ChangeAttribute::CABAgents'}        = 'CAB Agents';
    $Lang->{'ChangeAttribute::CABCustomers'}     = 'CAB Customers';
    $Lang->{'ChangeAttribute::ChangeBuilder'}    = 'Change Builder';
    $Lang->{'ChangeAttribute::ChangeManager'}    = 'Change Manager';
    $Lang->{'ChangeAttribute::ChangeNumber'}     = 'Change Number';
    $Lang->{'ChangeAttribute::ChangeState'}      = 'Change Status';
    $Lang->{'ChangeAttribute::ChangeTitle'}      = 'Change Title';
    $Lang->{'ChangeAttribute::PlannedEffort'}    = 'Planned Effort';
    $Lang->{'ChangeAttribute::PlannedStartTime'} = 'Planned Start';
    $Lang->{'ChangeAttribute::PlannedEndTime'}   = 'Planned End';
    $Lang->{'ChangeAttribute::RequestedTime'}    = 'Requested Time';

    # Workorder attributes as returned from WorkOrderGet(), or taken by WorkOrderUpdate()
    $Lang->{'WorkOrderAttribute::WorkOrderAgent'} = 'Workorder Agent';
    $Lang->{'WorkOrderAttribute::WorkOrderNumber'} = 'Workorder Number';
    $Lang->{'WorkOrderAttribute::WorkOrderState'} = 'Workorder State';
    $Lang->{'WorkOrderAttribute::WorkOrderType'}  = 'Workorder Type';

    # Change history
    $Lang->{'ChangeHistory::ChangeAdd'}              = 'New Change (ID=%s)';
    $Lang->{'ChangeHistory::ChangeUpdate'}           = '%s: New: %s -> Old: %s';
    $Lang->{'ChangeHistory::ChangeLinkAdd'}          = 'Link to %s (ID=%s) added';
    $Lang->{'ChangeHistory::ChangeLinkDelete'}       = 'Link to %s (ID=%s) deleted';
    $Lang->{'ChangeHistory::ChangeCABUpdate'}        = '%s: New: %s -> Old: %s';
    $Lang->{'ChangeHistory::ChangeCABDelete'}        = 'CAB Deleted %s';
    $Lang->{'ChangeHistory::ChangeAttachmentAdd'}    = 'New Attachment: %s';
    $Lang->{'ChangeHistory::ChangeAttachmentDelete'} = 'Deleted Attachment %s';

    # workorder history
    $Lang->{'WorkOrderHistory::WorkOrderAdd'}              = 'New Workorder (ID=%s)';
    $Lang->{'WorkOrderHistory::WorkOrderUpdate'}           = '%s: New: %s -> Old: %s';
    $Lang->{'WorkOrderHistory::WorkOrderLinkAdd'}          = 'Link to %s (ID=%s) added';
    $Lang->{'WorkOrderHistory::WorkOrderLinkDelete'}       = 'Link to %s (ID=%s) deleted';
    $Lang->{'WorkOrderHistory::WorkOrderDelete'}           = 'Workorder (ID=%s) deleted';
    $Lang->{'WorkOrderHistory::WorkOrderAttachmentAdd'}    = 'New Attachment for WorkOrder: %s';
    $Lang->{'WorkOrderHistory::WorkOrderAttachmentDelete'} = 'Deleted Attachment from WorkOrder: %s';

    # long workorder history
    $Lang->{'WorkOrderHistory::WorkOrderAddWithWorkOrderID'}              = 'New Workorder (ID=%s)';
    $Lang->{'WorkOrderHistory::WorkOrderUpdateWithWorkOrderID'}           = '(ID=%s) %s: New: %s -> Old: %s';
    $Lang->{'WorkOrderHistory::WorkOrderLinkAddWithWorkOrderID'}          = '(ID=%s) Link to %s (ID=%s) added';
    $Lang->{'WorkOrderHistory::WorkOrderLinkDeleteWithWorkOrderID'}       = '(ID=%s) Link to %s (ID=%s) deleted';
    $Lang->{'WorkOrderHistory::WorkOrderDeleteWithWorkOrderID'}           = 'Workorder (ID=%s) deleted';
    $Lang->{'WorkOrderHistory::WorkOrderAttachmentAddWithWorkOrderID'}    = '(ID=%s) New Attachment for WorkOrder: %s';
    $Lang->{'WorkOrderHistory::WorkOrderAttachmentDeleteWithWorkOrderID'} = '(ID=%s) Deleted Attachment from WorkOrder: %s';

    # condition history
    $Lang->{'ChangeHistory::ConditionAdd'}    = '%s: %s';
    $Lang->{'ChangeHistory::ConditionAddID'}  = 'New Condition (ID=%s)';
    $Lang->{'ChangeHistory::ConditionUpdate'} = '%s: New: %s -> Old: %s';
    $Lang->{'ChangeHistory::ConditionDelete'} = 'Condition (ID=%s) deleted';

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

    # workorder types
    $Lang->{'approval'}  = 'Approval';
    $Lang->{'decision'}  = 'Decision';
    $Lang->{'workorder'} = 'Workorder';
    $Lang->{'backout'}   = 'Backout Plan';
    $Lang->{'pir'}       = 'PIR (Post Implementation Review)';

    # Template types
    $Lang->{'TemplateType::ITSMChange'}      = 'Change';
    $Lang->{'TemplateType::ITSMWorkOrder'}   = 'Workorder';
    $Lang->{'TemplateType::CAB'}             = 'CAB';
    $Lang->{'TemplateType::ITSMCondition'}   = 'Condition';

    return 1;
}

1;
