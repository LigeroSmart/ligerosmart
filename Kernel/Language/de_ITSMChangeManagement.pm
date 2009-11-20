# --
# Kernel/Language/de_ITSMChangeManagement.pm - the german translation of ITSMChangeManagement
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: de_ITSMChangeManagement.pm,v 1.7 2009-11-20 08:13:14 reb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::de_ITSMChangeManagement;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.7 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'A change must have a title!'}        = 'Ein Change benötigt einen Titel!';
    $Lang->{'A workorder must have a title!'}     = 'Eine Workorder benötigt einen Titel!';
    $Lang->{'Add Change'}                         = 'Change hinzufügen';
    $Lang->{'The planned start time is invalid!'} = 'Der geplante Startzeitpunk ist ungültig!';
    $Lang->{'The planned end time is invalid!'}   = 'Der geplante Endzeitpunkt ist ungültig!';
    $Lang->{'The planned start time must be before the planned end time!'}
        = 'Der geplante Start muss vor dem geplanten Ende liegen!';

    # Change history entries
    $Lang->{'ChangeHistory::ChangeAdd'}        = 'Neuer Change (ID=%s)';
    $Lang->{'ChangeHistory::ChangeUpdate'}     = '%s: Neu: %s -> Alt: %s';
    $Lang->{'ChangeHistory::ChangeLinkAdd'}    = 'Link zu %s (ID=%s) hinzugefügt';
    $Lang->{'ChangeHistory::ChangeLinkDelete'} = 'Link zu %s (ID=%s) gelöscht';
    $Lang->{'ChangeHistory::ChangeCABUpdate'}  = 'CAB %s';
    $Lang->{'ChangeHistory::ChangeCABDelete'}  = 'CAB gelöscht %s';

    # WorkOrder history entries
    $Lang->{'WorkOrderHistory::WorkOrderAdd'}        = 'Neue Workorder (ID=%s)';
    $Lang->{'WorkOrderHistory::WorkOrderUpdate'}     = '%s: Neu: %s -> Alt: %s';
    $Lang->{'WorkOrderHistory::WorkOrderLinkAdd'}    = 'Link zu %s (ID=%s) hinzugefügt';
    $Lang->{'WorkOrderHistory::WorkOrderLinkDelete'} = 'Link to %s (ID=%s) gelöscht';
    $Lang->{'WorkOrderHistory::WorkOrderDelete'}     = 'Workorder (ID=%s) gelöscht';

    # long WorkOrder history entries
    $Lang->{'WorkOrderHistory::WorkOrderAddWithWorkorderID'}        = 'Neue Workorder (ID=%s)';
    $Lang->{'WorkOrderHistory::WorkOrderUpdateWithWorkorderID'}     = '(ID=%s) %s: Neu: %s -> Alt: %s';
    $Lang->{'WorkOrderHistory::WorkOrderLinkAddWithWorkorderID'}    = '(ID=%s) Link zu %s (ID=%s) hinzugefügt';
    $Lang->{'WorkOrderHistory::WorkOrderLinkDeleteWithWorkorderID'} = '(ID=%s) Link to %s (ID=%s) gelöscht';
    $Lang->{'WorkOrderHistory::WorkOrderDeleteWithWorkorderID'}     = 'Workorder (ID=%s) gelöscht';

    # entries for CIP matrix
    $Lang->{'Category'}                         = 'Kategorie';
    $Lang->{'Category <-> Impact <-> Priority'} = 'Kategorie <-> Auswirkung <-> Priorität';

    return 1;
}

1;
