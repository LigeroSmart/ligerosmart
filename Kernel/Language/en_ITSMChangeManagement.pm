# --
# Kernel/Language/en_ITSMChangeManagement.pm - the english translation of ITSMChangeManagement
# Copyright (C) 2003-2010 OTRS AG, http://otrs.com/
# --
# $Id: en_ITSMChangeManagement.pm,v 1.47 2010-02-08 14:50:18 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::en_ITSMChangeManagement;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.47 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    # misc
    $Lang->{'Imperative::Save'} = 'Save';

    # ITSM ChangeManagement icons
    $Lang->{'My Changes'}    = 'My Changes';
    $Lang->{'My Workorders'} = 'My Workorders';

    # Change menu
    $Lang->{'ITSM Change'}    = 'Change';
    $Lang->{'ITSM Workorder'} = 'Workorder';
    $Lang->{'ITSM Schedule'}  = 'Schedule';

    # Workorder menu

    # Template menu

    # Change attributes as returned from ChangeGet(), or taken by ChangeUpdate()
    $Lang->{'ChangeAttribute::AccountedTime'}    = 'Accounted Time';
    $Lang->{'ChangeAttribute::ActualEndTime'}    = 'Actual End';
    $Lang->{'ChangeAttribute::ActualStartTime'}  = 'Actual Start';
    $Lang->{'ChangeAttribute::CABAgent'}         = 'CAB Agent';
    $Lang->{'ChangeAttribute::CABAgents'}        = 'CAB Agents';
    $Lang->{'ChangeAttribute::CABCustomer'}      = 'CAB Customer';
    $Lang->{'ChangeAttribute::CABCustomers'}     = 'CAB Customers';
    $Lang->{'ChangeAttribute::Category'}         = 'Category';
    $Lang->{'ChangeAttribute::ChangeBuilder'}    = 'Change Builder';
    $Lang->{'ChangeAttribute::ChangeBy'}         = 'Changed by';
    $Lang->{'ChangeAttribute::ChangeManager'}    = 'Change Manager';
    $Lang->{'ChangeAttribute::ChangeNumber'}     = 'Change Number';
    $Lang->{'ChangeAttribute::ChangeTime'}       = 'Changed';
    $Lang->{'ChangeAttribute::ChangeState'}      = 'Change State';
    $Lang->{'ChangeAttribute::ChangeTitle'}      = 'Change Title';
    $Lang->{'ChangeAttribute::CreateBy'}         = 'Created by';
    $Lang->{'ChangeAttribute::CreateTime'}       = 'Created';
    $Lang->{'ChangeAttribute::Description'}      = 'Description';
    $Lang->{'ChangeAttribute::Impact'}           = 'Impact';
    $Lang->{'ChangeAttribute::Justification'}    = 'Justification';
    $Lang->{'ChangeAttribute::PlannedEffort'}    = 'Planned Effort';
    $Lang->{'ChangeAttribute::PlannedEndTime'}   = 'Planned End';
    $Lang->{'ChangeAttribute::PlannedStartTime'} = 'Planned Start';
    $Lang->{'ChangeAttribute::Priority'}         = 'Priority';
    $Lang->{'ChangeAttribute::RequestedTime'}    = 'Requested Time';

    # Workorder attributes as returned from WorkOrderGet(), or taken by WorkOrderUpdate()
    $Lang->{'WorkOrderAttribute::AccountedTime'}    = 'Accounted Time';
    $Lang->{'WorkOrderAttribute::ActualEndTime'}    = 'Actual End';
    $Lang->{'WorkOrderAttribute::ActualStartTime'}  = 'Actual Start';
    $Lang->{'WorkOrderAttribute::ChangeBy'}         = 'Changed by';
    $Lang->{'WorkOrderAttribute::ChangeTime'}       = 'Changed';
    $Lang->{'WorkOrderAttribute::CreateBy'}         = 'Created by';
    $Lang->{'WorkOrderAttribute::CreateTime'}       = 'Created';
    $Lang->{'WorkOrderAttribute::Instruction'}      = 'Instruction';
    $Lang->{'WorkOrderAttribute::PlannedEffort'}    = 'Planned Effort';
    $Lang->{'WorkOrderAttribute::PlannedEndTime'}   = 'Planned End';
    $Lang->{'WorkOrderAttribute::PlannedStartTime'} = 'Planned Start';
    $Lang->{'WorkOrderAttribute::Report'}           = 'Report';
    $Lang->{'WorkOrderAttribute::WorkOrderAgent'}   = 'Workorder Agent';
    $Lang->{'WorkOrderAttribute::WorkOrderNumber'}  = 'Workorder Number';
    $Lang->{'WorkOrderAttribute::WorkOrderState'}   = 'Workorder State';
    $Lang->{'WorkOrderAttribute::WorkOrderTitle'}   = 'Workorder Title';
    $Lang->{'WorkOrderAttribute::WorkOrderType'}    = 'Workorder Type';

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

    # Template types
    $Lang->{'TemplateType::ITSMChange'}    = 'Change';
    $Lang->{'TemplateType::ITSMWorkOrder'} = 'Workorder';
    $Lang->{'TemplateType::CAB'}           = 'CAB';
    $Lang->{'TemplateType::ITSMCondition'} = 'Condition';

    # objects that can be used in condition expressions and actions
    $Lang->{'ITSMChange'}    = 'Change';
    $Lang->{'ITSMWorkOrder'} = 'Workorder';

    # Overviews

    # Workorder delete

    # Take workorder
    $Lang->{'Imperative::Take Workorder'} = 'Take Workorder';

    # Condition Overview and Edit
    $Lang->{'ITSMCondition::Selector::any'}             = 'any';
    $Lang->{'ITSMCondition::Selector::all'}             = 'all';
    $Lang->{'ITSMCondition::Operator::is'}              = 'is';
    $Lang->{'ITSMCondition::Operator::is not'}          = 'is not';
    $Lang->{'ITSMCondition::Operator::is empty'}        = 'is empty';
    $Lang->{'ITSMCondition::Operator::is not empty'}    = 'is not empty';
    $Lang->{'ITSMCondition::Operator::is greater than'} = 'is greater than';
    $Lang->{'ITSMCondition::Operator::is less than'}    = 'is less than';
    $Lang->{'ITSMCondition::Operator::is before'}       = 'is before';
    $Lang->{'ITSMCondition::Operator::is after'}        = 'is after';
    $Lang->{'ITSMCondition::Operator::contains'}        = 'contains';
    $Lang->{'ITSMCondition::Operator::not contains'}    = 'does not contain';
    $Lang->{'ITSMCondition::Operator::begins with'}     = 'begins with';
    $Lang->{'ITSMCondition::Operator::ends with'}       = 'ends with';
    $Lang->{'ITSMCondition::Operator::set'}             = 'set';
    $Lang->{'ITSMCondition::Operator::lock'}            = 'lock';

    # Change Zoom

    # AgentITSMChangePrint

    # AgentITSMChangeSearch
    $Lang->{'No XXX settings'} = "No '%s' settings";

    return 1;
}

1;
