# --
# Kernel/System/ITSMChange/Event/HistoryAdd.pm - HistoryAdd event module for ITSMChangeManagement
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: HistoryAdd.pm,v 1.1 2009-10-22 16:08:35 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange::Event::HistoryAdd;

use strict;
use warnings;

use Kernel::System::ITSMChange::History;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

=head1 NAME

Kernel::System::ITSMChange::History - ITSMChangeManagement history add lib

=head1 SYNOPSIS

All functions for history add in ITSMChangeManagement.

=head1 PUBLIC INTERFACE

=over 4

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(DBObject ConfigObject EncodeObject LogObject MainObject TimeObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # we need either a change object or a workorder object
    if ( !$Param{ChangeObject} && !$Param{WorkOrderObject} ) {
        die 'Either ChangeObject or WorkOrderObject is needed!';
    }

    # create additional objects
    $Self->{HistoryObject} = Kernel::System::ITSMChange::History->new( %{$Self} );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Event Config)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # check for either ChangeID or WorkOrderID
    if ( !$Param{ChangeID} && !$Param{WorkOrderID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
        return;
    }

    # do history stuff for Change-Events
    if ( $Param{Event} =~ m{ \A Change .+ \z }xms ) {

        # ... do history update for change add, change update, change...

        #$Self->{LogObject}->Dum_per( '', "ChangeEvent: $Param{Event} " );

    }

    # do history stuff for WorkOrder-Events
    elsif ( $Param{Event} =~ m{ \A WorkOrder .+ \z  }xms ) {

        # ... do history update for workorderAdd, etc...

        #$Self->{LogObject}->Dum_per( '', "WorkOrderEvent: $Param{Event} " );
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

$Revision: 1.1 $ $Date: 2009-10-22 16:08:35 $

=cut
