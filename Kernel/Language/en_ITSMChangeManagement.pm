# --
# Kernel/Language/en_ITSMChangeManagement.pm - the english translation of ITSMChangeManagement
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: en_ITSMChangeManagement.pm,v 1.8 2009-11-24 00:05:02 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::en_ITSMChangeManagement;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.8 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{''} = '';

    # Change menu entry
    $Lang->{'ITSM Change'} = 'Change';

    # Change history entries
    $Lang->{'ChangeHistory::ChangeAdd'}        = 'New Change (ID=%s)';
    $Lang->{'ChangeHistory::ChangeUpdate'}     = '%s: New: %s -> Old: %s';
    $Lang->{'ChangeHistory::ChangeLinkAdd'}    = 'Link to %s (ID=%s) added';
    $Lang->{'ChangeHistory::ChangeLinkDelete'} = 'Link to %s (ID=%s) deleted';
    $Lang->{'ChangeHistory::ChangeCABUpdate'}  = 'CAB %s';
    $Lang->{'ChangeHistory::ChangeCABDelete'}  = 'CAB Deleted %s';

    # WorkOrder history entries
    $Lang->{'WorkOrderHistory::WorkOrderAdd'}        = 'New Workorder (ID=%s)';
    $Lang->{'WorkOrderHistory::WorkOrderUpdate'}     = '%s: New: %s -> Old: %s';
    $Lang->{'WorkOrderHistory::WorkOrderLinkAdd'}    = 'Link to %s (ID=%s) added';
    $Lang->{'WorkOrderHistory::WorkOrderLinkDelete'} = 'Link to %s (ID=%s) deleted';
    $Lang->{'WorkOrderHistory::WorkOrderDelete'}     = 'Workorder (ID=%s) deleted';

    # long WorkOrder history entries
    $Lang->{'WorkOrderHistory::WorkOrderAddWithWorkorderID'}        = 'New Workorder (ID=%s)';
    $Lang->{'WorkOrderHistory::WorkOrderUpdateWithWorkorderID'}     = '(ID=%s) %s: New: %s -> Old: %s';
    $Lang->{'WorkOrderHistory::WorkOrderLinkAddWithWorkorderID'}    = '(ID=%s) Link to %s (ID=%s) added';
    $Lang->{'WorkOrderHistory::WorkOrderLinkDeleteWithWorkorderID'} = '(ID=%s) Link to %s (ID=%s) deleted';
    $Lang->{'WorkOrderHistory::WorkOrderDeleteWithWorkorderID'}     = 'Workorder (ID=%s) deleted';

    # entries for workorder types
    $Lang->{'approval'}  = 'Approval';
    $Lang->{'decision'}  = 'Decision';
    $Lang->{'workorder'} = 'Workorder';
    $Lang->{'backout'}   = 'Backout';
    $Lang->{'pir'}       = 'PIR (Post Implementation Review)';

    return 1;
}

1;
