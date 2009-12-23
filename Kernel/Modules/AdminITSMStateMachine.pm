# --
# Kernel/Modules/AdminITSMStateMachine.pm - to add/update/delete state transitions
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: AdminITSMStateMachine.pm,v 1.20 2009-12-23 15:18:30 bes Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminITSMStateMachine;

use strict;
use warnings;

use Kernel::System::ITSMChange::ITSMStateMachine;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.20 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for (qw(ParamObject DBObject LayoutObject ConfigObject LogObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    # create additional objects
    $Self->{StateMachineObject} = Kernel::System::ITSMChange::ITSMStateMachine->new(%Param);

    $Self->{ConfigByName}  = {};
    $Self->{ConfigByClass} = {};

    # read and prepare the config,
    # the hash keys of $Config are not significant
    my $Config = $Self->{ConfigObject}->Get("ITSMStateMachine::Object") || {};
    for my $HashRef ( values %{$Config} ) {
        $Self->{ConfigByName}->{ $HashRef->{Name} }   = $HashRef;
        $Self->{ConfigByClass}->{ $HashRef->{Class} } = $HashRef;
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # store needed parameters in %GetParam
    my %GetParam;
    for my $ParamName (qw(StateID NextStateID ObjectType Class)) {
        $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
    }

    # translate from name to class and visa versa
    if ( !$GetParam{Class} && $GetParam{ObjectType} ) {
        $GetParam{Class} = $Self->{ConfigByName}->{ $GetParam{ObjectType} }->{Class};
    }
    elsif ( !$GetParam{ObjectType} && $GetParam{Class} ) {
        $GetParam{ObjectType} = $Self->{ConfigByClass}->{ $GetParam{Class} }->{Name};
    }

    # Build drop-down for the left side.
    my @ArrHashRef;
    for my $Class ( sort keys %{ $Self->{ConfigByClass} } ) {
        push @ArrHashRef, { Key => $Class, Value => $Class, };
    }
    $GetParam{ClassSelectionString} = $Self->{LayoutObject}->BuildSelection(
        Name         => 'Class',
        Data         => \@ArrHashRef,
        SelectedID   => $GetParam{Class},
        PossibleNone => 1,
        Translation  => 0,
    );

    my $Note = '';

    # provide form for changing the next state
    if ( $Self->{Subaction} eq 'StateTransitionUpdate' ) {
        return $Self->_StateTransitionUpdatePageGet(
            Action => 'StateTransitionUpdate',
            %GetParam,
        );
    }

    # provide form for adding a state transition
    elsif ( $Self->{Subaction} eq 'StateTransitionAdd' ) {
        if ( !$GetParam{ObjectType} ) {
            $Note .= $Self->{LayoutObject}->Notify(
                Priority => 'Error',
                Info     => 'Please select first an object type!',
            );
        }
        else {
            return $Self->_StateTransitionAddPageGet(
                Action => 'StateTransitionAdd',
                %GetParam,
            );
        }
    }

    # check whether next states should be deleted,
    # this determines whether the confirmation page should be shown
    # deletion of next states was ordered, but not comfirmed yet
    elsif (
        scalar( $Self->{ParamObject}->GetArray( Param => 'DelNextStateIDs' ) )
        && !$Self->{ParamObject}->GetParam( Param => 'DeletionConfirmed' )
        )
    {
        return $Self->_ConfirmDeletionPageGet(
            Action => 'EditStateTransitions',
            %GetParam,
        );
    }

    my $ActionIsOk = 1;

    # update the next state of a state transition
    if ( $Self->{Subaction} eq 'StateTransitionUpdateAction' ) {

        for my $ParamName (qw(NewNextStateID)) {
            $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
        }

        # Update the state transition
        $ActionIsOk = $Self->{StateMachineObject}->StateTransitionUpdate(
            Class          => $GetParam{Class},
            StateID        => $GetParam{StateID},
            NextStateID    => $GetParam{NextStateID},
            NewNextStateID => $GetParam{NewNextStateID},
        );
    }
    elsif ( $Self->{Subaction} eq 'StateTransitionAddAction' ) {

        my $IsValid = 1;

        # we need to distinguish between empty string '' and the string '0'.
        # '' indicates that no value was selected, which is invalid
        # '0' indicated '*START*' or '*END*'
        if ( $GetParam{StateID} eq '' ) {
            $IsValid = 0;
            $Note .= $Self->{LayoutObject}->Notify(
                Priority => 'Error',
                Info     => 'Please select a state!',
            );
        }

        if ( $GetParam{NextStateID} eq '' ) {
            $IsValid = 0;
            $Note .= $Self->{LayoutObject}->Notify(
                Priority => 'Error',
                Info     => 'Please select a next state!',
            );
        }

        if ( !$IsValid ) {
            return $Self->_StateTransitionAddPageGet(
                %GetParam,
                Action => 'StateTransitionAdd',
                Note   => $Note,
            );
        }

        # Add the state transition
        $ActionIsOk = $Self->{StateMachineObject}->StateTransitionAdd(
            Class       => $GetParam{Class},
            StateID     => $GetParam{StateID},
            NextStateID => $GetParam{NextStateID},
        );
    }

    # actually add and delete state transitions
    elsif ( $Self->{Subaction} eq 'EditStateTransitionsAction' ) {

        # Delete the DelNextStateID's
        for my $NextStateID ( $Self->{ParamObject}->GetArray( Param => 'DelNextStateIDs' ) ) {
            $ActionIsOk = $Self->{StateMachineObject}->StateTransitionDelete(
                StateID     => $GetParam{StateID},
                NextStateID => $NextStateID
            );
        }

        # Add the AddNextStateID's
        for my $NextStateID ( $Self->{ParamObject}->GetArray( Param => 'AddNextStateIDs' ) ) {

            $ActionIsOk = $Self->{StateMachineObject}->StateTransitionAdd(
                Class       => $GetParam{Class},
                StateID     => $GetParam{StateID},
                NextStateID => $NextStateID
            );
        }
    }

    if ( $GetParam{Class} ) {
        $Note .= $ActionIsOk ? '' : $Self->{LayoutObject}->Notify( Priority => 'Error' );

        return $Self->_OverviewStateTransitionsPageGet(
            %GetParam,
            Note => $Note,
        );
    }

    # present a list of object types
    return $Self->_OverviewClassesPageGet(
        %GetParam,
        Note => $Note,
    );
}

# provide a form for changing the next state of a transition
sub _StateTransitionUpdatePageGet {
    my ( $Self, %Param ) = @_;

    $Param{StateName} = $Self->{StateMachineObject}->StateLookup(
        Class   => $Param{Class},
        StateID => $Param{StateID},
    ) || '*START*';

    # the currently possible next states
    my %OldNextStateID = map { $_ => 1 } @{
        $Self->{StateMachineObject}->StateTransitionGet(
            StateID => $Param{StateID},
            Class   => $Param{Class},
            ) || []
        };

    # ArrayHashRef with all states for a catalog class
    my $AllArrayHashRef = $Self->{StateMachineObject}->StateList(
        Class  => $Param{Class},
        UserID => $Self->{UserID},
    );

    # Add the special final state
    push @{$AllArrayHashRef}, { Key => '0', Value => '*END*' };

    #  $AllArrayHashRef into an Array of the old next states and the possible new next states
    my @AddArrayHashRef;
    for my $HashRef ( @{$AllArrayHashRef} ) {
        if ( $HashRef->{Key} == $Param{NextStateID} ) {

            # the current next state can be selected too
            push @AddArrayHashRef, $HashRef;
        }
        elsif ( $OldNextStateID{ $HashRef->{Key} } ) {

            # already existing transitions are not offered
        }
        elsif ( $HashRef->{Key} == $Param{StateID} ) {

            # do not encourage a transition to the same state
        }
        else {
            push @AddArrayHashRef, $HashRef;
        }
    }

    # dropdown menu, where the next state can be selected for addition
    $Param{NextStateSelectionString} = $Self->{LayoutObject}->BuildSelection(
        Data       => \@AddArrayHashRef,
        Name       => 'NewNextStateID',
        SelectedID => $Param{NextStateID},
    );

    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();

    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $Self->{LayoutObject}->Block(
        Name => 'StateTransitionUpdate',
        Data => \%Param,
    );
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminITSMStateMachine',
        Data         => \%Param,
    );
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

# provide a form for add a new state transition
sub _StateTransitionAddPageGet {
    my ( $Self, %Param ) = @_;

    # the origin of the transitions
    my $StateID = $Param{StateID};

    # ArrayHashRef with all states for a catalog class
    my $AllArrayHashRef = $Self->{StateMachineObject}->StateList(
        Class  => $Param{Class},
        UserID => $Self->{UserID},
    );

    # Add the special final state
    push @{$AllArrayHashRef}, { Key => '0', Value => '*START*' };

    # dropdown menu, where the state can be selected for addition
    $Param{StateSelectionString} = $Self->{LayoutObject}->BuildSelection(
        Data         => $AllArrayHashRef,
        Name         => 'StateID',
        SelectedID   => $Param{StateID},
        PossibleNone => 1,
    );

    # dropdown menu, where the next state can be selected for addition
    $AllArrayHashRef->[-1] = { Key => '0', Value => '*END*' };
    $Param{NextStateSelectionString} = $Self->{LayoutObject}->BuildSelection(
        Data         => $AllArrayHashRef,
        Name         => 'NextStateID',
        SelectedID   => $Param{NextStateID},
        PossibleNone => 1,
    );

    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();
    $Output .= $Param{Note} || '';

    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $Self->{LayoutObject}->Block(
        Name => 'StateTransitionAdd',
        Data => \%Param,
    );
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminITSMStateMachine',
        Data         => \%Param,
    );
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

# show the confirm deletion page
sub _ConfirmDeletionPageGet {
    my ( $Self, %Param ) = @_;

    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();

    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    my $StateName = $Self->{StateMachineObject}->StateLookup(
        Class   => $Param{Class},
        StateID => $Param{StateID},
    ) || '*START*';
    $Self->{LayoutObject}->Block(
        Name => 'ConfirmDeletion',
        Data => {
            %Param,
            StateName => $StateName,
            }
    );

    # Show which states are scheduled to be deleted
    my @DelNextStateIDs = $Self->{ParamObject}->GetArray( Param => 'DelNextStateIDs' );
    for my $NextStateID (@DelNextStateIDs) {
        my $NextStateName = $Self->{StateMachineObject}->StateLookup(
            Class   => $Param{Class},
            StateID => $NextStateID,
        ) || '*END*';
        $Self->{LayoutObject}->Block(
            Name => 'ConfirmDeletionDelNextState',
            Data => {
                NextStateID   => $NextStateID,
                NextStateName => $NextStateName,
            },
        );
    }

    # Show which states are scheduled to be added
    my @AddNextStateIDs = $Self->{ParamObject}->GetArray( Param => 'AddNextStateIDs' );
    if (@AddNextStateIDs) {
        $Self->{LayoutObject}->Block(
            Name => 'ConfirmDeletionAddNextStatesExist',
        );
    }
    for my $NextStateID (@AddNextStateIDs) {
        my $NextStateName = $Self->{StateMachineObject}->StateLookup(
            Class   => $Param{Class},
            StateID => $NextStateID,
        ) || '*END*';
        $Self->{LayoutObject}->Block(
            Name => 'ConfirmDeletionAddNextState',
            Data => {
                NextStateID   => $NextStateID,
                NextStateName => $NextStateName,
            },
        );
    }

    # set hidden params for deleting next state ids
    for my $NextStateID ( $Self->{ParamObject}->GetArray( Param => 'DelNextStateIDs' ) ) {
        $Self->{LayoutObject}->Block(
            Name => 'ConfirmDeletionDelNextStateHidden',
            Data => { NextStateID => $NextStateID },
        );
    }

    # set hidden params for adding next state ids
    for my $NextStateID ( $Self->{ParamObject}->GetArray( Param => 'AddNextStateIDs' ) ) {
        $Self->{LayoutObject}->Block(
            Name => 'ConfirmDeletionAddNextStateHidden',
            Data => { NextStateID => $NextStateID },
        );
    }

    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminITSMStateMachine',
        Data         => \%Param,
    );
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

# Show a table of all state transitions
sub _OverviewStateTransitionsPageGet {
    my ( $Self, %Param ) = @_;

    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $Self->{LayoutObject}->Block(
        Name => 'OverviewStateTransitions',
        Data => \%Param,
    );

    # lookup for state names
    my $CssClass = 'searchactive';
    my %NextStateIDs
        = %{ $Self->{StateMachineObject}->StateTransitionList( Class => $Param{Class} ) || {} };

    # loop over all 'State' and 'NextState' pairs for the ObjectType
    for my $StateID ( sort keys %NextStateIDs ) {

        for my $NextStateID ( @{ $NextStateIDs{$StateID} } ) {

            # set output class
            $CssClass = $CssClass eq 'searchactive' ? 'searchpassive' : 'searchactive';

            # state names
            my $StateName = $Self->{StateMachineObject}->StateLookup(
                Class   => $Param{Class},
                StateID => $StateID,
            ) || '*START*';
            my $NextStateName = $Self->{StateMachineObject}->StateLookup(
                Class   => $Param{Class},
                StateID => $NextStateID,
            ) || '*END*';

            $Self->{LayoutObject}->Block(
                Name => 'StateTransitionRow',
                Data => {
                    CssClass      => $CssClass,
                    ObjectType    => $Param{ObjectType},
                    StateID       => $StateID,
                    StateName     => $StateName,
                    NextStateID   => $NextStateID,
                    NextStateName => $NextStateName,
                },
            );
        }
    }

    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();
    $Output .= $Param{Note};
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminITSMStateMachine',
        Data         => \%Param,
    );
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

# Show a list of relevant object types
sub _OverviewClassesPageGet {
    my ( $Self, %Param ) = @_;

    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => \%Param,
    );
    $Self->{LayoutObject}->Block(
        Name => 'OverviewClasses',
        Data => \%Param,
    );

    my $CssClass = 'searchactive';
    for my $Class ( sort keys %{ $Self->{ConfigByClass} } ) {
        $CssClass = $CssClass eq 'searchactive' ? 'searchpassive' : 'searchactive';
        $Self->{LayoutObject}->Block(
            Name => 'OverviewClassesRow',
            Data => {
                CssClass   => $CssClass,
                ObjectType => $Self->{ConfigByClass}->{$Class}->{Name},
                Class      => $Class,
            },
        );
    }

    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();
    $Output .= $Param{Note};
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminITSMStateMachine',
        Data         => \%Param,
    );
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
