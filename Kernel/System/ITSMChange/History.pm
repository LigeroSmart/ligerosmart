# --
# Kernel/System/ITSMChange/History.pm - all change and workorder history functions
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: History.pm,v 1.4 2009-10-27 15:43:35 reb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange::History;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.4 $) [1];

=head1 NAME

Kernel::System::ITSMChange::History - all change and workorder history functions

=head1 SYNOPSIS

All history functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

# NOTE: Look at ITSMConfigurationManagement, but use new EventHandling Module
# (currently in ITSMCore, will be in OTRS 2.5 framework later)

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(DBObject ConfigObject EncodeObject LogObject MainObject TimeObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    # set default debug flag
    $Self->{Debug} ||= 0;

    # create additional objects
    # ...

    return $Self;
}

=item HistoryAdd()

Adds a single history entry to the history. Returns 1 on success, C<undef> otherwise.

    my $Success = $HistoryObject->HistoryAdd(
        ChangeID      => 1234,           # either ChangeID or WorkOrderID is needed
        WorkOrderID   => 123,            # either ChangeID or WorkOrderID is needed
        HistoryType   => 'WorkOrderAdd', # either HistoryType or HistoryTypeID is needed
        HistoryTypeID => 1,              # either HistoryType or HistoryTypeID is needed
        UserID        => 1,
        Content       => 'Any useful information',
    );

=cut

sub HistoryAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(UserID Content)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # either HistoryType or HistoryTypeID is needed
    if ( !( $Param{HistoryType} || $Param{HistoryTypeID} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need HistoryType or HistoryTypeID!',
        );
        return;
    }

    # either ChangeID or WorkOrderID is needed
    if ( !( $Param{ChangeID} || $Param{WorkOrderID} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need ChangeID or WorkOrderID!',
        );
        return;
    }

    # get history type id from history type if history type is given.
    if ( $Param{HistoryType} ) {
        my $ID = $Self->HistoryTypeLookup( HistoryType => $Param{HistoryType} );

        # no valid history type given
        if ( !$ID ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Invalid history type given!',
            );
            return;
        }

        $Param{HistoryTypeID} = $ID;
    }

    # should change id be saved when it is a workorder entry?

    # insert history entry
    return if !$Self->{DBObject}->Do(
        SQL => 'INSERT INTO change_history ( change_id, workorder_id, content, create_by, '
            . 'create_time, type_id ) VALUES ( ?, ?, ?, ?, current_timestamp, ? )',
        Bind => [
            \$Param{ChangeID},
            \$Param{WorkOrderID},
            \$Param{Content},
            \$Param{UserID},
            \$Param{HistoryTypeID},
        ],
    );

    return 1;
}

=item WorkOrderHistoryGet()

Returns a list of all history entries that belong to the given WorkOrderID. The
list contains hash references with these information:

    $Info{HistoryEntryID}
    $Info{ChangeID}
    $Info{WorkOrderID}
    $Info{HistoryType}
    $Info{HistoryTypeID}
    $Info{Content}
    $Info{CreatedBy}
    $Info{CreatedTime}
    $Info{UserID}
    $Info{UserLogin}
    $Info{UserLastname}
    $Info{UserFirstname}

    my $HistoryEntries = $HistoryObject->WorkOrderHistoryGet(
        ChangeID => 123,
        UserID   => 1,
    );

=cut

sub WorkOrderHistoryGet {
    my ( $Self, %Param ) = @_;

    # check for needed stuff
    for my $Attribute (qw(WorkOrderID UserID)) {
        if ( !$Param{$Attribute} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Attribute!",
            );
            return;
        }
    }
}

=item ChangeHistoryGet()

Returns a list of all history entries that belong to the given ChangeID - including
history entries for workorders. The list contains hash references with these information:

    $Info{HistoryEntryID}
    $Info{ChangeID}
    $Info{WorkOrderID}
    $Info{HistoryType}
    $Info{HistoryTypeID}
    $Info{Content}
    $Info{CreatedBy}
    $Info{CreatedTime}
    $Info{UserID}
    $Info{UserLogin}
    $Info{UserLastname}
    $Info{UserFirstname}

    my $HistoryEntries = $HistoryObject->ChangeHistoryGet(
        ChangeID => 123,
        UserID   => 1,
    );

=cut

sub ChangeHistoryGet {
    my ( $Self, %Param ) = @_;

    # check for needed stuff
    for my $Attribute (qw(ChangeID UserID)) {
        if ( !$Param{$Attribute} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Attribute!",
            );
            return;
        }
    }
}

=item WorkOrderHistoryDelete()

Deletes all entries in history table that belongs to the given WorkOrderID.
The method returns 1 on success and C<undef> otherwise.

    my $Success = $HistoryObject->WorkOrderHistoryDelete(
        WorkOrderID => 123,
        UserID      => 1,
    );

=cut

sub WorkOrderHistoryDelete {
    my ( $Self, %Param ) = @_;

    # check for needed stuff
    for my $Attribute (qw(WorkOrderID UserID)) {
        if ( !$Param{$Attribute} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Attribute!",
            );
            return;
        }
    }
}

=item ChangeHistoryDelete()

Deletes all entries in history table that belongs to the given ChangeID.
The method returns 1 on success and C<undef> otherwise.

    my $Success = $HistoryObject->ChangeHistoryDelete(
        ChangeID => 123,
        UserID   => 1,
    );

=cut

sub ChangeHistoryDelete {
    my ( $Self, %Param ) = @_;

    # check for needed stuff
    for my $Attribute (qw(ChangeID UserID)) {
        if ( !$Param{$Attribute} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Attribute!",
            );
            return;
        }
    }
}

=item HistoryTypeLookup()

This method does a lookup for a history type. If a history type id is given,
it returns the name of the history type. If a history type is given, the appropriate
id is returned.

    my $Name = $HistoryObject->HistoryTypeLookup(
        HistoryTypeID => 1234,
    );

    my $Id = $HistoryObject->HistoryTypeLookup(
        HistoryType => 'WorkOrderAdd',
    );

=cut

sub HistoryTypeLookup {
    my ( $Self, %Param ) = @_;

    # check for needed stuff
    if ( !$Param{HistoryTypeID} && !$Param{HistoryType} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need HistoryTypeID or HistoryType!',
        );
        return;
    }

    # if both valid keys are given, return
    if ( $Param{HistoryTypeID} && $Param{HistoryType} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need either HistoryTypeID OR HistoryType - not both!',
        );
        return;
    }

    # find out what the used key is
    my $Key = 'HistoryType';

    if ( $Param{HistoryTypeID} ) {
        $Key = 'HistoryTypeID';
    }

    # if result is cached return that result
    return $Self->{Cache}->{HistoryTypeLookup}->{ $Param{$Key} }
        if $Self->{Cache}->{HistoryTypeLookup}->{ $Param{$Key} };

    # set the appropriate SQL statement
    my $SQL = 'SELECT name FROM change_history_type WHERE id = ?';

    if ( $Key eq 'HistoryType' ) {
        $SQL = 'SELECT id FROM change_history_type WHERE name = ?';
    }

    # fetch the requested value
    return if !$Self->{DBObject}->Prepare(
        SQL   => $SQL,
        Bind  => [ \$Param{$Key} ],
        Limit => 1,
    );

    my $Value;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Value = $Row[0];
    }

    # save value in cache
    $Self->{Cache}->{HistoryTypeLookup}->{ $Param{$Key} } = $Value;

    return $Value;
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

$Revision: 1.4 $ $Date: 2009-10-27 15:43:35 $

=cut
