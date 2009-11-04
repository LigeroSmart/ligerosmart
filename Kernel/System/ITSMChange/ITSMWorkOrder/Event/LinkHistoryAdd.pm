# --
# Kernel/System/ITSMChange/WorkOrder/Event/LinkHistoryAdd.pm.pm - LinkHistoryAdd event module for WorkOrder
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: LinkHistoryAdd.pm,v 1.3 2009-11-04 12:57:27 reb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange::ITSMWorkOrder::Event::LinkHistoryAdd;

use strict;
use warnings;

use Kernel::System::ITSMChange::History;
use Kernel::System::ITSMChange::ITSMWorkOrder;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

=head1 NAME

Kernel::System::ITSMChange::ITSMWorkOrder::Event::LinkHistoryAdd - WorkOrder history add lib for link events

=head1 SYNOPSIS

Event handler module for history add for link events in WorkOrder.

=head1 PUBLIC INTERFACE

=over 4

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::Main;
    use Kernel::System::Time;
    use Kernel::System::LinkObject;
    use Kernel::System::ITSMChange::ITSMWorkOrder::Event::LinkHistoryAdd;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $LinkObject = Kernel::System::LinkObject->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        TimeObject   => $TimeObject,
        MainObject   => $MainObject,
        EncodeObject => $EncodeObject,
    );
    my $HistoryObject = Kernel::System::ITSMChange::ITSMWorkOrder::Event::LinkHistoryAdd->new(
        ConfigObject  => $ConfigObject,
        EncodeObject  => $EncodeObject,
        LogObject     => $LogObject,
        DBObject      => $DBObject,
        TimeObject    => $TimeObject,
        MainObject    => $MainObject,
        LinkObject    => $LinkObject,
    );

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
    $Self->{HistoryObject}   = Kernel::System::ITSMChange::History->new( %{$Self} );
    $Self->{WorkOrderObject} = Kernel::System::ITSMChange::ITSMWorkOrder->new( %{$Self} );

    return $Self;
}

=item Run()

The C<Run()> method handles the events that are created when the workorder is
(un-)linked to anything.

It returns 1 on success, C<undef> otherwise.

    my $Success = $HistoryObject->Run(
        WorkOrderID  => 123,
        SourceObject => 'Ticket',
        SourceKey    => 9,
        Key          => 123,
        UserID       => 1,
        Config       => ...,
    );

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(WorkOrderID Event Config)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # in history we use Event name without 'Post'
    my $HistoryType = $Param{Event};
    $HistoryType =~ s{ Post$ }{}xms;

    # do history stuff
    if ( $HistoryType eq 'WorkOrderLinkAdd' || $HistoryType eq 'WorkOrderLinkDelete' ) {

        # get workorder
        my $WorkOrder = $Self->{WorkOrderObject}->WorkOrderGet(
            WorkOrderID => $Param{Data}->{WorkOrderID},
            UserID      => $Param{UserID},
        );

        return if !$WorkOrder;

        # tell history that a change was added
        return if !$Self->{HistoryObject}->HistoryAdd(
            HistoryType => $HistoryType,
            WorkOrderID => $Param{Data}->{WorkOrderID},
            UserID      => $Param{UserID},
            ContentNew  => join( '%%', $Param{SourceKey}, $Param{SourceObject} ),
            ChangeID    => $WorkOrder->{ChangeID},
        );
    }

    # error
    else {

        # a non-known event
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "$Param{Event} is a non-known event!",
        );

        return;
    }

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

$Revision: 1.3 $ $Date: 2009-11-04 12:57:27 $

=cut
