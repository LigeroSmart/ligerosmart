# --
# Kernel/System/ITSMChange/WorkOrder/Event/LinkHistoryAdd.pm.pm - LinkHistoryAdd event module for WorkOrder
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: LinkHistoryAdd.pm,v 1.1 2009-10-28 23:19:00 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange::ITSMWorkOrder::Event::LinkHistoryAdd;

use strict;
use warnings;

use Kernel::System::ITSMChange::History;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

=head1 NAME

Kernel::System::ITSMChange::ITSMWorkOrder::Event::LinkHistoryAdd - WorkOrder history add lib for link events

=head1 SYNOPSIS

Event handler module for history add for link events in WorkOrder.

=head1 PUBLIC INTERFACE

=over 4

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(DBObject ConfigObject EncodeObject LogObject MainObject TimeObject LinkObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # create additional objects
    $Self->{HistoryObject} = Kernel::System::ITSMChange::History->new( %{$Self} );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(WorkOrderID Event Config)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # TODO:
    # Look in ConfigItem how the history entry should
    # look like, e.g.:
    #        Comment      => $ID . '%%' . $Object,

    # ... a link to a workorder object was added or deleted
    #    $Self->{LogObject}->Du_mper(
    #        '',
    #        "LinkWorkOrderEvent: $Param{Event}",
    #        "Object: WorkOrder with ID: $Param{Data}->{WorkOrderID}",
    #        "Object: $Param{Data}->{Object} with ID: $Param{Data}->{ID}",
    #        "LinkType: $Param{Type}",
    #        " Data: ", $Param{Data},
    #    );

    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see http://www.gnu.org/licenses/agpl.txt.

=cut

=head1 VERSION

$Revision: 1.1 $ $Date: 2009-10-28 23:19:00 $

=cut
