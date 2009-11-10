# --
# Kernel/Language/en_ITSMChangeManagement.pm - the english translation of ITSMChangeManagement
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: en_ITSMChangeManagement.pm,v 1.2 2009-11-10 14:19:52 reb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::en_ITSMChangeManagement;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{''} = '';

    # Change history entries
    $Lang->{'ChangeHistory::ChangeAdd'}        = 'New WorkOrder (ID=%s)';
    $Lang->{'ChangeHistory::ChangeUpdate'}     = '%s: New: %s -> Old: %s';
    $Lang->{'ChangeHistory::ChangeLinkAdd'}    = 'Link to %s (ID=%s) added';
    $Lang->{'ChangeHistory::ChangeLinkDelete'} = 'Link to %s (ID=%s) deleted';
    $Lang->{'ChangeHistory::ChangeCABUpdate'}  = 'CAB %s';
    $Lang->{'ChangeHistory::ChangeCABDelete'}  = 'CAB Deleted %s';

    # WorkOrder history entries
    $Lang->{'WorkOrderHistory::WorkOrderAdd'}        = 'New WorkOrder (ID=%s)';
    $Lang->{'WorkOrderHistory::WorkOrderUpdate'}     = '%s: New: %s -> Old: %s';
    $Lang->{'WorkOrderHistory::WorkOrderLinkAdd'}    = 'Link to %s (ID=%s) added';
    $Lang->{'WorkOrderHistory::WorkOrderLinkDelete'} = 'Link to %s (ID=%s) deleted';

    return 1;
}

1;
