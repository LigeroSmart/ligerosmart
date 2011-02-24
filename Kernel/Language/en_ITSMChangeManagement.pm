# --
# Kernel/Language/en_ITSMChangeManagement.pm - the english (US) translation of ITSMChangeManagement
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: en_ITSMChangeManagement.pm,v 1.56 2011-02-24 16:15:40 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::en_ITSMChangeManagement;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.56 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    # misc

    # Change menu
    $Lang->{'ITSM Change'}    = 'Change';
    $Lang->{'ITSM Changes'}   = 'Changes';
    $Lang->{'ITSM Workorder'} = 'Workorder';

    # Workorder menu

    # Template menu

    # Change attributes as returned from ChangeGet(), or taken by ChangeUpdate()
    $Lang->{'AccountedTime'}    = 'Accounted Time';
    $Lang->{'ActualEndTime'}    = 'Actual End';
    $Lang->{'ActualStartTime'}  = 'Actual Start';
    $Lang->{'CABAgent'}         = 'CAB Agent';
    $Lang->{'CABAgents'}        = 'CAB Agents';
    $Lang->{'CABCustomer'}      = 'CAB Customer';
    $Lang->{'CABCustomers'}     = 'CAB Customers';
    $Lang->{'Category'}         = 'Category';
    $Lang->{'ChangeBuilder'}    = 'Change Builder';
    $Lang->{'ChangeBy'}         = 'Changed by';
    $Lang->{'ChangeManager'}    = 'Change Manager';
    $Lang->{'ChangeNumber'}     = 'Change Number';
    $Lang->{'ChangeTime'}       = 'Changed';
    $Lang->{'ChangeState'}      = 'Change State';
    $Lang->{'ChangeTitle'}      = 'Change Title';
    $Lang->{'CreateBy'}         = 'Created by';
    $Lang->{'CreateTime'}       = 'Created';
    $Lang->{'Description'}      = 'Description';
    $Lang->{'Impact'}           = 'Impact';
    $Lang->{'Justification'}    = 'Justification';
    $Lang->{'PlannedEffort'}    = 'Planned Effort';
    $Lang->{'PlannedEndTime'}   = 'Planned End';
    $Lang->{'PlannedStartTime'} = 'Planned Start';
    $Lang->{'Priority'}         = 'Priority';
    $Lang->{'RequestedTime'}    = 'Requested Time';

    # Workorder attributes as returned from WorkOrderGet(), or taken by WorkOrderUpdate()
    $Lang->{'Instruction'}      = 'Instruction';
    $Lang->{'Report'}           = 'Report';
    $Lang->{'WorkOrderAgent'}   = 'Workorder Agent';
    $Lang->{'WorkOrderNumber'}  = 'Workorder Number';
    $Lang->{'WorkOrderState'}   = 'Workorder State';
    $Lang->{'WorkOrderTitle'}   = 'Workorder Title';
    $Lang->{'WorkOrderType'}    = 'Workorder Type';

    # Change history
    $Lang->{'ChangeHistory::ChangeAdd'}              = 'New Change (ID=%s)';
    $Lang->{'ChangeHistory::ChangeUpdate'}           = '%s: New: %s -> Old: %s';
    $Lang->{'ChangeHistory::ChangeLinkAdd'}          = 'Link to %s (ID=%s) added';
    $Lang->{'ChangeHistory::ChangeLinkDelete'}       = 'Link to %s (ID=%s) deleted';
    $Lang->{'ChangeHistory::ChangeCABUpdate'}        = '%s: New: %s -> Old: %s';
    $Lang->{'ChangeHistory::ChangeCABDelete'}        = 'CAB Deleted %s';
    $Lang->{'ChangeHistory::ChangeAttachmentAdd'}    = 'New Attachment: %s';
    $Lang->{'ChangeHistory::ChangeAttachmentDelete'} = 'Deleted Attachment %s';
    $Lang->{'ChangeHistory::ChangeNotificationSent'} = 'Notification sent to %s (Event: %s)';

    # workorder history
    $Lang->{'WorkOrderHistory::WorkOrderAdd'}              = 'New Workorder (ID=%s)';
    $Lang->{'WorkOrderHistory::WorkOrderUpdate'}           = '%s: New: %s -> Old: %s';
    $Lang->{'WorkOrderHistory::WorkOrderLinkAdd'}          = 'Link to %s (ID=%s) added';
    $Lang->{'WorkOrderHistory::WorkOrderLinkDelete'}       = 'Link to %s (ID=%s) deleted';
    $Lang->{'WorkOrderHistory::WorkOrderDelete'}           = 'Workorder (ID=%s) deleted';
    $Lang->{'WorkOrderHistory::WorkOrderAttachmentAdd'}    = 'New Attachment for WorkOrder: %s';
    $Lang->{'WorkOrderHistory::WorkOrderAttachmentDelete'} = 'Deleted Attachment from WorkOrder: %s';
    $Lang->{'WorkOrderHistory::WorkOrderNotificationSent'} = 'Notification sent to %s (Event: %s)';

    # long workorder history
    $Lang->{'WorkOrderHistory::WorkOrderAddWithWorkOrderID'}              = 'New Workorder (ID=%s)';
    $Lang->{'WorkOrderHistory::WorkOrderUpdateWithWorkOrderID'}           = '(ID=%s) %s: New: %s -> Old: %s';
    $Lang->{'WorkOrderHistory::WorkOrderLinkAddWithWorkOrderID'}          = '(ID=%s) Link to %s (ID=%s) added';
    $Lang->{'WorkOrderHistory::WorkOrderLinkDeleteWithWorkOrderID'}       = '(ID=%s) Link to %s (ID=%s) deleted';
    $Lang->{'WorkOrderHistory::WorkOrderDeleteWithWorkOrderID'}           = 'Workorder (ID=%s) deleted';
    $Lang->{'WorkOrderHistory::WorkOrderAttachmentAddWithWorkOrderID'}    = '(ID=%s) New Attachment for WorkOrder: %s';
    $Lang->{'WorkOrderHistory::WorkOrderAttachmentDeleteWithWorkOrderID'} = '(ID=%s) Deleted Attachment from WorkOrder: %s';
    $Lang->{'WorkOrderHistory::WorkOrderNotificationSentWithWorkOrderID'} = '(ID=%s) Notification sent to %s (Event: %s)';

    # condition history
    $Lang->{'ChangeHistory::ConditionAdd'}       = '%s: %s';
    $Lang->{'ChangeHistory::ConditionAddID'}     = 'New Condition (ID=%s)';
    $Lang->{'ChangeHistory::ConditionUpdate'}    = '%s (Condition ID=%s): New: %s -> Old: %s';
    $Lang->{'ChangeHistory::ConditionDelete'}    = 'Condition (ID=%s) deleted';
    $Lang->{'ChangeHistory::ConditionDeleteAll'} = 'All Conditions of Change (ID=%s) deleted';

    # expression history
    $Lang->{'ChangeHistory::ExpressionAdd'}       = '%s: %s';
    $Lang->{'ChangeHistory::ExpressionAddID'}     = 'New Expression (ID=%s)';
    $Lang->{'ChangeHistory::ExpressionUpdate'}    = '%s (Expression ID=%s): New: %s -> Old: %s';
    $Lang->{'ChangeHistory::ExpressionDelete'}    = 'Expression (ID=%s) deleted';
    $Lang->{'ChangeHistory::ExpressionDeleteAll'} = 'All Expressions of Condition (ID=%s) deleted';

    # action history
    $Lang->{'ChangeHistory::ActionAdd'}       = '%s: %s';
    $Lang->{'ChangeHistory::ActionAddID'}     = 'New Action (ID=%s)';
    $Lang->{'ChangeHistory::ActionUpdate'}    = '%s (Action ID=%s): New: %s -> Old: %s';
    $Lang->{'ChangeHistory::ActionDelete'}    = 'Action (ID=%s) deleted';
    $Lang->{'ChangeHistory::ActionDeleteAll'} = 'All Actions of Condition (ID=%s) deleted';
    $Lang->{'ChangeHistory::ActionExecute'}   = 'Action (ID=%s) executed: %s';
    $Lang->{'ActionExecute::successfully'}    = 'Successfully';
    $Lang->{'ActionExecute::unsuccessfully'}  = 'Unsuccessfully';

    # history for time events
    $Lang->{'ChangeHistory::ChangePlannedStartTimeReached'}                      = 'Change (ID=%s) reached planned start time.';
    $Lang->{'ChangeHistory::ChangePlannedEndTimeReached'}                        = 'Change (ID=%s) reached planned end time.';
    $Lang->{'ChangeHistory::ChangeActualStartTimeReached'}                       = 'Change (ID=%s) reached actual start time.';
    $Lang->{'ChangeHistory::ChangeActualEndTimeReached'}                         = 'Change (ID=%s) reached actual end time.';
    $Lang->{'ChangeHistory::ChangeRequestedTimeReached'}                         = 'Change (ID=%s) reached requested time.';
    $Lang->{'WorkOrderHistory::WorkOrderPlannedStartTimeReached'}                = 'Workorder (ID=%s) reached planned start time.';
    $Lang->{'WorkOrderHistory::WorkOrderPlannedEndTimeReached'}                  = 'Workorder (ID=%s) reached planned end time.';
    $Lang->{'WorkOrderHistory::WorkOrderActualStartTimeReached'}                 = 'Workorder (ID=%s) reached actual start time.';
    $Lang->{'WorkOrderHistory::WorkOrderActualEndTimeReached'}                   = 'Workorder (ID=%s) reached actual end time.';
    $Lang->{'WorkOrderHistory::WorkOrderPlannedStartTimeReachedWithWorkOrderID'} = 'Workorder (ID=%s) reached planned start time.';
    $Lang->{'WorkOrderHistory::WorkOrderPlannedEndTimeReachedWithWorkOrderID'}   = 'Workorder (ID=%s) reached planned end time.';
    $Lang->{'WorkOrderHistory::WorkOrderActualStartTimeReachedWithWorkOrderID'}  = 'Workorder (ID=%s) reached actual start time.';
    $Lang->{'WorkOrderHistory::WorkOrderActualEndTimeReachedWithWorkOrderID'}    = 'Workorder (ID=%s) reached actual end time.';

    # change states
    $Lang->{'requested'}        = 'Requested';
    $Lang->{'pending approval'} = 'Pending Approval';
    $Lang->{'pending pir'}      = 'Pending PIR';
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

    # Admin Interface

    # Admin StateMachine

    # workorder types
    $Lang->{'approval'}  = 'Approval';
    $Lang->{'decision'}  = 'Decision';
    $Lang->{'workorder'} = 'Workorder';
    $Lang->{'backout'}   = 'Backout Plan';
    $Lang->{'pir'}       = 'PIR (Post Implementation Review)';

    # objects that can be used in condition expressions and actions
    $Lang->{'ITSMChange'}    = 'Change';
    $Lang->{'ITSMWorkOrder'} = 'Workorder';
    $Lang->{'ITSMCondition'} = 'Condition';

    # Overviews

    # Workorder delete

    # Take workorder

    # Condition Overview and Edit
    $Lang->{'not contains'} = 'does not contain';

    # Change Zoom

    # AgentITSMChangePrint

    # AgentITSMChangeSearch
    $Lang->{'No XXX settings'} = "No '%s' settings";

    return 1;
}

1;
