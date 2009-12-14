# --
# Kernel/System/ITSMChange/ITSMStateMachine.pm - all state machine functions
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: ITSMStateMachine.pm,v 1.1 2009-12-14 22:51:48 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange::ITSMStateMachine;

use strict;
use warnings;

use Kernel::System::GeneralCatalog;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

=head1 NAME

Kernel::System::ITSMChange::ITSMStateMachine - statemachine lib

=head1 SYNOPSIS

All functions for statemachine in ITSMChangeManagement.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::Main;
    use Kernel::System::Time;
    use Kernel::System::ITSMChange::ITSMStateMachine;

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
    my $StateMachineObject = Kernel::System::ITSMChange::ITSMStateMachine->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        TimeObject   => $TimeObject,
        MainObject   => $MainObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(DBObject ConfigObject EncodeObject LogObject MainObject TimeObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    # set the debug flag
    $Self->{Debug} = $Param{Debug} || 0;

    # create additional objects
    $Self->{GeneralCatalogObject} = Kernel::System::GeneralCatalog->new( %{$Self} );

    return $Self;
}

=item StateTransitionAdd()

Add a new state transition. Returns the transition id on success.

    my $TransitionID = $StateMachineObject->StateTransitionAdd(
        StateID     => 1,  # id within the given class, or 0 to indicate the start state
        NextStateID => 2,  # id within the given class, or 0 to indicate an end state
        Class       => 'ITSM::ChangeManagement::Change::State', # the name of a general catalog class
    );

=cut

sub StateTransitionAdd {
    my ( $Self, %Param ) = @_;

    # check if StateID and NextStateID (they can be 0) and class are given
    for my $Argument (qw(StateID NextStateID Class)) {
        if ( !defined $Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # check that not both StateID and NextStateID are zero
    if ( !$Param{StateID} && !$Param{NextStateID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "StateID and NextStateID can't both be zero!",
        );
        return;
    }

    # check if StateID and NextStateID belong to the given class
    ARGUMENT:
    for my $Argument (qw(StateID NextStateID)) {

        # dont check zero values
        next ARGUMENT if !$Param{$Argument};

        # get class
        my $DataRef = $Self->{GeneralCatalogObject}->ItemGet(
            ItemID => $Param{$Argument},
        );

        # check if id belongs to given class
        if ( !$DataRef || !%{$DataRef} || $DataRef->{Class} ne $Param{Class} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "$Argument $Param{$Argument} is not in the class $Param{Class}!",
            );
            return;
        }
    }

    # check if StateID is a start state (=0) and another start state already exists
    if ( !$Param{StateID} ) {

        # count the number of exsting start states in the given class
        # ( the state_id 0 indicates that the next_state_id is a start state )
        return if !$Self->{DBObject}->Prepare(
            SQL => 'SELECT count(s.id) '
                . 'FROM change_state_machine s, general_catalog g '
                . 'WHERE g.general_catalog_class = ? '
                . 'AND s.next_state_id = g.id '
                . 'AND s.state_id = 0',
            Bind  => [ \$Param{Class} ],
            Limit => 1,
        );

        # fetch the result
        my $Count;
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            $Count = $Row[0];
        }

        # if there is already a start state
        if ($Count) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Can not add state id $Param{NextStateID} as start state. "
                    . "There is already a start state defined for class $Param{Class}!",
            );
            return;
        }
    }

    # prevent setting an end state transition, if other state transistions exist already
    if ( !$Param{NextStateID} ) {

        # check if other state transistions exist for the given StateID
        my $NextStateIDs = $Self->StateTransitionGet(
            StateID => $Param{StateID},
            Class   => $Param{Class},
        );

        if ( $NextStateIDs && @{$NextStateIDs} && scalar @{$NextStateIDs} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message =>
                    "StateTransitionAdd() failed! Can not set StateID $Param{StateID} as end state, "
                    . "because other following states exist, which must be deleted first!",
            );
            return;
        }
    }

    # add state transition to database
    return if !$Self->{DBObject}->Do(
        SQL => 'INSERT INTO change_state_machine '
            . '(state_id, next_state_id) '
            . 'VALUES (?, ?)',
        Bind => [
            \$Param{StateID}, \$Param{NextStateID},
        ],
    );

    # get TransitionID
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id FROM change_state_machine '
            . 'WHERE state_id = ? '
            . 'AND next_state_id = ?',
        Bind => [ \$Param{StateID}, \$Param{NextStateID} ],
        Limit => 1,
    );

    # fetch the result
    my $TransitionID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $TransitionID = $Row[0];
    }

    # check if state transition could be added
    if ( !$TransitionID ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "StateTransitionAdd() failed!",
        );
        return;
    }

    return $TransitionID;
}

=item StateTransitionDelete()

Delete a state transition. Returns true on success.

    my $Success = $StateMachineObject->StateTransitionDelete(
        StateID     => 1,  # id within the given class, or 0 to indicate the start state
        NextStateID => 2,  # id within the given class, or 0 to indicate an end state
    );

=cut

sub StateTransitionDelete {
    my ( $Self, %Param ) = @_;

    # check if StateID and NextStateID are given (they can be 0)
    for my $Argument (qw(StateID NextStateID)) {
        if ( !defined $Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # delete state transition from database
    return if !$Self->{DBObject}->Do(
        SQL => 'DELETE FROM change_state_machine '
            . 'WHERE state_id = ? AND next_state_id = ?',
        Bind => [
            \$Param{StateID}, \$Param{NextStateID},
        ],
    );

    return 1;
}

=item StateTransitionDeleteAll()

Delete all state transitions of a class. Returns true on success.

    my $Success = $StateMachineObject->StateTransitionDeleteAll(
        Class => 'ITSM::ChangeManagement::Change::State', # the name of a general catalog class
    );

=cut

sub StateTransitionDeleteAll {
    my ( $Self, %Param ) = @_;

    # check needed parameter
    if ( !defined $Param{Class} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need Class!",
        );
        return;
    }

    # find all state ids and next_state ids which belong to the given class
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id '
            . 'FROM general_catalog '
            . 'WHERE general_catalog_class = ?',
        Bind => [ \$Param{Class} ],
    );

    my @IDs;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @IDs, $Row[0];
    }

    # return if no state transitions exist for the given class
    return 1 if !@IDs;

    # build id string
    my $IDString = join ', ', @IDs;

    # delete state transition from database
    return if !$Self->{DBObject}->Do(
        SQL => "DELETE FROM change_state_machine "
            . "WHERE state_id IN ( $IDString ) "
            . "OR next_state_id IN ( $IDString )",
    );

    return 1;

}

=item StateTransitionGet()

Get a state transition for a given state id.
Returns an array reference of the next state ids.

    my $NextStateIDsRef = $StateMachineObject->StateTransitionGet(
        StateID => 1,  # id within the given class, or 0 to indicate the start state
        Class   => 'ITSM::ChangeManagement::Change::State', # the name of a general catalog class
    );

=cut

sub StateTransitionGet {
    my ( $Self, %Param ) = @_;

    # check if StateID are given (they can be 0)
    for my $Argument (qw(StateID Class)) {
        if ( !defined $Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # check if StateID belongs to the given class, but only if state id is not a start state (=0)
    if ( $Param{StateID} ) {

        # get class of given StateID
        my $DataRef = $Self->{GeneralCatalogObject}->ItemGet(
            ItemID => $Param{StateID},
        );

        # check if StateID belongs to given class
        if ( !$DataRef || !%{$DataRef} || $DataRef->{Class} ne $Param{Class} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "StateID $Param{StateID} is not in the class $Param{Class}!",
            );
            return;
        }
    }

    # find all state ids and next_state ids which belong to the given class
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT DISTINCT s.next_state_id '
            . 'FROM change_state_machine s '
            . 'LEFT OUTER JOIN general_catalog g '
            . 'ON ( (s.state_id = g.id ) OR (s.next_state_id = g.id) ) '
            . 'WHERE s.state_id = ? AND g.general_catalog_class = ?',
        Bind => [ \$Param{StateID}, \$Param{Class} ],
    );

    my @NextStateIDs;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @NextStateIDs, $Row[0];
    }

    # if the start state was requested and more than one start state was found
    if ( !$Param{StateID} ) {

        if ( !@NextStateIDs ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Can not get initial state for '$Param{Class}' "
                    . "No initial state was found!",
            );
            return;
        }
        if ( scalar @NextStateIDs > 1 ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Can not get initial state for '$Param{Class}' "
                    . "More than one initial state was found!",
            );
            return;
        }
    }

    return \@NextStateIDs;
}

=item StateTransitionList()

Return a state transition list hash-array reference.
The hash key is the StateID, the hash value is an array reference of NextStateIDs.

    my $StateTransitionsRef = $StateMachineObject->StateTransitionList(
        Class => 'ITSM::ChangeManagement::Change::State', # the name of a general catalog class
    );

Return example:

    $StateTransitionsRef = {
        0 => [ 1 ],
        1 => [ 2, 3, 4 ],
        2 => [ 5 ],
        3 => [ 6, 7 ],
        4 => [ 0 ],
        5 => [ 0 ],
        6 => [ 0 ],
        7 => [ 0 ],
    };

=cut

sub StateTransitionList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Class} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Class!',
        );
        return;
    }

    # get state transitions
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT DISTINCT s.id , s.state_id , s.next_state_id , g.general_catalog_class '
            . 'FROM change_state_machine s '
            . 'LEFT OUTER JOIN general_catalog g '
            . 'ON ( (s.state_id = g.id ) OR (s.next_state_id = g.id) ) '
            . 'WHERE g.general_catalog_class = ?',
        Bind => [ \$Param{Class} ],
    );

    my %StateTransition;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @{ $StateTransition{ $Row[1] } }, $Row[2];
    }

    return \%StateTransition;
}

=item StateTransitionUpdate()

Add a new state transition. Returns the transition id on success.

    my $UpdateSuccess = $StateMachineObject->StateTransitionUpdate(
        StateID        => 1,  # id within the given class, or 0 to indicate the start state
        NextStateID    => 2,  # id within the given class, or 0 to indicate an end state
        NewNextStateID => 3,  # id within the given class, or 0 to indicate an end state
        Class          => 'ITSM::ChangeManagement::Change::State', # the name of a general catalog class
    );

=cut

sub StateTransitionUpdate {
    my ( $Self, %Param ) = @_;

    # check if StateID, NextStateID and NewNextStateID are given (they can be 0)
    for my $Argument (qw(StateID NextStateID NewNextStateID Class)) {
        if ( !defined $Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # check that not both StateID and NextStateID are zero
    if ( !$Param{StateID} && !$Param{NextStateID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "StateID and NextStateID can't both be zero!",
        );
        return;
    }

    # check that not both StateID and NewNextStateID are zero
    if ( !$Param{StateID} && !$Param{NewNextStateID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "StateID and NewNextStateID can't both be zero!",
        );
        return;
    }

    # check if StateID, NextStateID and NewNextStateID belong to the given class
    ARGUMENT:
    for my $Argument (qw(StateID NextStateID NewNextStateID)) {

        # dont check zero values
        next ARGUMENT if !$Param{$Argument};

        # get class
        my $DataRef = $Self->{GeneralCatalogObject}->ItemGet(
            ItemID => $Param{$Argument},
        );

        # check if id belongs to given class
        if ( !$DataRef || !%{$DataRef} || $DataRef->{Class} ne $Param{Class} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "$Argument $Param{$Argument} is not in the class $Param{Class}!",
            );
            return;
        }
    }

    # do not update if the new next state is the same
    return 1 if $Param{NextStateID} == $Param{NewNextStateID};

    # get the existing state transition id that should be updated
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT DISTINCT s.id '
            . 'FROM change_state_machine s '
            . 'LEFT OUTER JOIN general_catalog g '
            . 'ON ( (s.state_id = g.id ) OR (s.next_state_id = g.id) ) '
            . 'WHERE s.state_id = ? AND s.next_state_id = ? '
            . 'AND g.general_catalog_class = ?',
        Bind => [ \$Param{StateID}, \$Param{NextStateID}, \$Param{Class} ],
        Limit => 1,
    );

    my $TransitionID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $TransitionID = $Row[0];
    }

    # check that the state transition that should be updated exists
    if ( !$TransitionID ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can not update state transition! A state transition with "
                . "StateID $Param{StateID} and NextStateID $Param{NextStateID} does not exist!",
        );
        return;
    }

    # prevent setting an end state transition, if other state transistions exist already
    if ( !$Param{NewNextStateID} ) {

        # check if other state transistions exist for the given StateID
        my $NextStateIDs = $Self->StateTransitionGet(
            StateID => $Param{StateID},
            Class   => $Param{Class},
        );

        if ( $NextStateIDs && @{$NextStateIDs} && scalar @{$NextStateIDs} ) {

            $Self->{LogObject}->Log(
                Priority => 'error',
                Message =>
                    "StateTransitionAdd() failed! Can not set StateID $Param{StateID} as end state, "
                    . "because other following states exist, which must be deleted first!",
            );
            return;
        }
    }

    # update state transition
    return if !$Self->{DBObject}->Do(
        SQL => 'UPDATE change_state_machine '
            . 'SET next_state_id = ? '
            . 'WHERE id = ?',
        Bind => [ \$Param{NewNextStateID}, \$TransitionID ],
    );

    return 1;
}

# TODO Check if this function can be deleted!

=item StateLookup()

This method does a lookup for a state. If a state id is given,
it returns the name of the state. If a state name is given,
the appropriate id is returned.

    my $State = $StateMachineObject->StateLookup(
        StateID => 1234,
        Class   => 'ITSM::ChangeManagement::Change::State',
    );

    my $StateID = $StateMachineObject->StateLookup(
        State   => 'accepted',
        Class   => 'ITSM::ChangeManagement::Change::State',
    );

=cut

sub StateLookup {
    my ( $Self, %Param ) = @_;

    # check Class parameter
    if ( !$Param{Class} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Class!',
        );
        return;
    }

    # either StateID or State must be passed
    if ( !$Param{StateID} && !$Param{State} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need StateID or State!',
        );
        return;
    }

    # only one parameter State or StateID is allowed
    if ( $Param{StateID} && $Param{State} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need StateID OR State - not both!',
        );
        return;
    }

    # get the change states from the general catalog
    my %StateID2Name = %{
        $Self->{GeneralCatalogObject}->ItemList(
            Class => $Param{Class},
            )
        };

    # check the state hash
    if ( !%StateID2Name ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Could not retrieve change states from the general catalog.',
        );
        return;
    }
    if ( $Param{StateID} ) {
        return $StateID2Name{ $Param{StateID} };
    }
    else {

        # reverse key - value pairs to have the name as keys
        my %StateName2ID = reverse %StateID2Name;

        return $StateName2ID{ $Param{State} };
    }
}

1;

=begin Internal:
=end Internal:

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see http://www.gnu.org/licenses/agpl.txt.

=cut

=head1 VERSION

$Revision: 1.1 $ $Date: 2009-12-14 22:51:48 $

=cut
