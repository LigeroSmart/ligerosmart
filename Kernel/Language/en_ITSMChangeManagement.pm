# --
# Kernel/Language/en_ITSMChangeManagement.pm - the english translation of ITSMChangeManagement
# Copyright (C) 2003-2010 OTRS AG, http://otrs.com/
# --
# $Id: en_ITSMChangeManagement.pm,v 1.16 2010-01-20 10:37:57 bes Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::en_ITSMChangeManagement;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.16 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{''} = '';

    $Lang->{'Imperative::Save'}                   = 'Save';

    # Change menu
    $Lang->{'ITSM Change'} = 'Change';

    # Change history
    $Lang->{'ChangeHistory::ChangeAdd'}              = 'New Change (ID=%s)';
    $Lang->{'ChangeHistory::ChangeUpdate'}           = '%s: New: %s -> Old: %s';
    $Lang->{'ChangeHistory::ChangeLinkAdd'}          = 'Link to %s (ID=%s) added';
    $Lang->{'ChangeHistory::ChangeLinkDelete'}       = 'Link to %s (ID=%s) deleted';
    $Lang->{'ChangeHistory::ChangeCABUpdate'}        = '%s: New: %s -> Old: %s';
    $Lang->{'ChangeHistory::ChangeCABDelete'}        = 'CAB Deleted %s';
    $Lang->{'ChangeHistory::ChangeAttachmentAdd'}    = 'New Attachment: %s';
    $Lang->{'ChangeHistory::ChangeAttachmentDelete'} = 'Deleted Attachment %s';

    # WorkOrder history
    $Lang->{'WorkOrderHistory::WorkOrderAdd'}              = 'New Workorder (ID=%s)';
    $Lang->{'WorkOrderHistory::WorkOrderUpdate'}           = '%s: New: %s -> Old: %s';
    $Lang->{'WorkOrderHistory::WorkOrderLinkAdd'}          = 'Link to %s (ID=%s) added';
    $Lang->{'WorkOrderHistory::WorkOrderLinkDelete'}       = 'Link to %s (ID=%s) deleted';
    $Lang->{'WorkOrderHistory::WorkOrderDelete'}           = 'Workorder (ID=%s) deleted';
    $Lang->{'WorkOrderHistory::WorkOrderAttachmentAdd'}    = 'New Attachment for WorkOrder: %s';
    $Lang->{'WorkOrderHistory::WorkOrderAttachmentDelete'} = 'Deleted Attachment from WorkOrder: %s';

    # long WorkOrder history
    $Lang->{'WorkOrderHistory::WorkOrderAddWithWorkOrderID'}              = 'New Workorder (ID=%s)';
    $Lang->{'WorkOrderHistory::WorkOrderUpdateWithWorkOrderID'}           = '(ID=%s) %s: New: %s -> Old: %s';
    $Lang->{'WorkOrderHistory::WorkOrderLinkAddWithWorkOrderID'}          = '(ID=%s) Link to %s (ID=%s) added';
    $Lang->{'WorkOrderHistory::WorkOrderLinkDeleteWithWorkOrderID'}       = '(ID=%s) Link to %s (ID=%s) deleted';
    $Lang->{'WorkOrderHistory::WorkOrderDeleteWithWorkOrderID'}           = 'Workorder (ID=%s) deleted';
    $Lang->{'WorkOrderHistory::WorkOrderAttachmentAddWithWorkOrderID'}    = '(ID=%s) New Attachment for WorkOrder: %s';
    $Lang->{'WorkOrderHistory::WorkOrderAttachmentDeleteWithWorkOrderID'} = '(ID=%s) Deleted Attachment from WorkOrder: %s';

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
    $Lang->{'backout'}   = 'Backout';
    $Lang->{'pir'}       = 'PIR (Post Implementation Review)';

    return 1;
}

1;
