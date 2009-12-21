# --
# Kernel/Modules/AdminITSMStateMachine.pm - to add/update/delete state transitions
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: AdminITSMStateMachine.pm,v 1.10 2009-12-21 16:33:39 bes Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminITSMStateMachine;

use strict;
use warnings;

use Kernel::System::GeneralCatalog;
use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::ITSMWorkOrder;
use Kernel::System::ITSMChange::ITSMStateMachine;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.10 $) [1];

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
    $Self->{ChangeObject}         = Kernel::System::ITSMChange->new(%Param);
    $Self->{WorkOrderObject}      = Kernel::System::ITSMChange::ITSMWorkOrder->new(%Param);
    $Self->{GeneralCatalogObject} = Kernel::System::GeneralCatalog->new(%Param);
    $Self->{StateMachineObject}   = Kernel::System::ITSMChange::ITSMStateMachine->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # store needed parameters in %GetParam
    my %GetParam;
    for my $ParamName (qw(StateID NextStateID ObjectType)) {
        $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
    }

    if ( $GetParam{ObjectType} ) {

        # the general catalog class
        my %ConfigItemClass = (
            Change    => 'ITSM::ChangeManagement::Change::State',
            WorkOrder => 'ITSM::ChangeManagement::WorkOrder::State',
        );
        $GetParam{Class} = $ConfigItemClass{ $GetParam{ObjectType} };
    }

    # Build drop-down for the left side.
    $GetParam{ObjectTypeSelectionString} = $Self->{LayoutObject}->BuildSelection(
        Name => 'ObjectType',
        Data => [
            {
                Key   => 'Change',
                Value => 'ITSM::ChangeManagement::Change::State',
            },
            {
                Key   => 'WorkOrder',
                Value => 'ITSM::ChangeManagement::WorkOrder::State',
            },
        ],
        SelectedID   => $GetParam{ObjectType},
        PossibleNone => 1,
        Translation  => 0,
    );

    # provide form for changing the next state
    if ( $Self->{Subaction} eq 'StateTransitionUpdate' ) {
        return $Self->_StateTransitionUpdatePageGet(
            Action => 'StateTransitionUpdate',
            %GetParam,
        );
    }

    # provide form for adding a state transition
    if ( $Self->{Subaction} eq 'StateTransitionAdd' && $GetParam{ObjectType} ) {
        return $Self->_StateTransitionAddPageGet(
            Action => 'StateTransitionAdd',
            %GetParam,
        );
    }

    # check whether next states should be deleted,
    # this determines whether the confirmation page should be shown
    # deletion of next states was ordered, but not comfirmed yet
    if (
        scalar( $Self->{ParamObject}->GetArray( Param => 'DelNextStateIDs' ) )
        && !$Self->{ParamObject}->GetParam( Param => 'DeletionConfirmed' )
        )
    {
        return $Self->_ConfirmDeletionPageGet(
            Action => 'EditStateTransitions',
            %GetParam,
        );
    }

    my $ActionIsOk;

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

    if ( $GetParam{ObjectType} ) {
        my $Note = $ActionIsOk ? '' : $Self->{LayoutObject}->Notify( Priority => 'Error' );

        return $Self->_OverviewStateTransitionsPageGet(
            %GetParam,
            Note => $Note,
        );
    }

    # present a list of object types
    return $Self->_OverviewObjectTypesPageGet(%GetParam);
}

# provide a form for changing the next state of a transition
sub _StateTransitionUpdatePageGet {
    my ( $Self, %Param ) = @_;

    # Display the name of the origin state
    if ( $Param{ObjectType} eq 'Change' ) {
        $Param{StateName} = $Self->{ChangeObject}->ChangeStateLookup(
            ChangeStateID => $Param{StateID},
        );
    }
    elsif ( $Param{ObjectType} eq 'WorkOrder' ) {
        $Param{StateName} = $Self->{WorkOrderObject}->WorkOrderStateLookup(
            WorkOrderStateID => $Param{StateID},
        );
    }
    $Param{StateName} ||= $Param{StateID};

    # Display the name of the old next state
    if ( $Param{ObjectType} eq 'Change' ) {
        $Param{OldNextStateName} = $Self->{ChangeObject}->ChangeStateLookup(
            ChangeStateID => $Param{NextStateID},
        );
    }
    elsif ( $Param{ObjectType} eq 'WorkOrder' ) {
        $Param{OldNextStateName} = $Self->{WorkOrderObject}->WorkOrderStateLookup(
            WorkOrderStateID => $Param{NextStateID},
        );
    }
    $Param{OldNextStateName} ||= $Param{NextStateID};

    # the currently possible next states
    my %OldNextStateID = map { $_ => 1 } @{
        $Self->{StateMachineObject}->StateTransitionGet(
            StateID => $Param{StateID},
            Class   => $Param{Class},
            ) || []
        };

    # ArrayHashRef with the all states for an object type
    my $AllArrayHashRef;
    if ( $Param{ObjectType} eq 'Change' ) {
        $AllArrayHashRef = $Self->{ChangeObject}->ChangePossibleStatesGet(
            UserID => $Self->{UserID},
        );
    }
    else {
        $AllArrayHashRef = $Self->{WorkOrderObject}->WorkOrderPossibleStatesGet(
            UserID => $Self->{UserID},
        );
    }

    # Add the special final state
    push @{$AllArrayHashRef}, { Key => '0', Value => '*END*' };

    # split $AllArrayHashRef into an Array of the old next states and the possible new next states
    my @AddArrayHashRef;
    for my $HashRef ( @{$AllArrayHashRef} ) {
        if ( $OldNextStateID{ $HashRef->{Key} } ) {

            # already existing transitions are not offered
        }
        elsif ( $HashRef->{Key} == $Param{StateID} ) {

            # do not encourage a transition to the same state
        }
        else {
            push @AddArrayHashRef, $HashRef;
        }
    }

    # dropdown menu, where the next states can be selected for addition
    # multiple selections are explicitly allowed
    $Param{NextStateSelectionString} = $Self->{LayoutObject}->BuildSelection(
        Data => \@AddArrayHashRef,
        Size => scalar(@AddArrayHashRef),
        Name => 'NewNextStateID',
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

    # ArrayHashRef with the all states for an object type
    my $AllArrayHashRef;
    if ( $Param{ObjectType} eq 'Change' ) {
        $AllArrayHashRef = $Self->{ChangeObject}->ChangePossibleStatesGet(
            UserID => $Self->{UserID},
        );
    }
    else {
        $AllArrayHashRef = $Self->{WorkOrderObject}->WorkOrderPossibleStatesGet(
            UserID => $Self->{UserID},
        );
    }

    # Add the special final state
    push @{$AllArrayHashRef}, { Key => '0', Value => '*START*' };

    # multiple selections are explicitly allowed
    $Param{StateSelectionString} = $Self->{LayoutObject}->BuildSelection(
        Data => $AllArrayHashRef,
        Size => scalar( @{$AllArrayHashRef} ),
        Name => 'StateID',
    );

    # dropdown menu, where the next states can be selected for addition
    # multiple selections are explicitly allowed
    $AllArrayHashRef->[-1] = { Key => '0', Value => '*END*' };
    $Param{NextStateSelectionString} = $Self->{LayoutObject}->BuildSelection(
        Data => $AllArrayHashRef,
        Size => scalar( @{$AllArrayHashRef} ),
        Name => 'NextStateID',
    );

    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();

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

    # set up some lookup tables for displaying the state name
    my %StateID2Name;
    for my $ObjectType (qw(Change WorkOrder)) {

        # lookup table for the config item class
        my %ConfigItemClass = (
            Change    => 'ITSM::ChangeManagement::Change::State',
            WorkOrder => 'ITSM::ChangeManagement::WorkOrder::State',
        );

        # get the state names
        my $Class = $ConfigItemClass{$ObjectType};

        # TODO: Avoid direct usage of GeneralCatalogObject
        $StateID2Name{$ObjectType} = $Self->{GeneralCatalogObject}->ItemList( Class => $Class );
    }

    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();

    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    my $StateName = $StateID2Name{ $Param{ObjectType} }->{ $Param{StateID} }
        || $Param{StateID};
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
        my $NextStateName = $StateID2Name{ $Param{ObjectType} }->{$NextStateID} || $NextStateID;
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
        my $NextStateName = $StateID2Name{ $Param{ObjectType} }->{$NextStateID} || $NextStateID;
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

    my $ObjectType = $Param{ObjectType};

    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $Self->{LayoutObject}->Block(
        Name => 'OverviewStateTransitions',
        Data => {
            %Param,
            Class => $Param{Class},
            }
    );

    # get the state names
    # TODO: Avoid direct usage of GeneralCatalogObject
    my $StateID2Name = $Self->{GeneralCatalogObject}->ItemList( Class => $Param{Class} );

    # get the state signals
    my $StateName2Signal = $Self->{ConfigObject}->Get("ITSM${ObjectType}::State::Signal");

    my $CssClass = 'searchactive';
    my %NextStateIDs
        = %{ $Self->{StateMachineObject}->StateTransitionList( Class => $Param{Class} ) || {} };

    # loop over all 'State' and 'NextState' pairs for the ObjectType
    for my $StateID ( sort keys %NextStateIDs ) {

        for my $NextStateID ( @{ $NextStateIDs{$StateID} } ) {

            # set output class
            $CssClass = $CssClass eq 'searchactive' ? 'searchpassive' : 'searchactive';

            # values for the origin state
            my $StateName   = $StateID2Name->{$StateID}       || $StateID;
            my $StateSignal = $StateName2Signal->{$StateName} || '';

            # values for the next state
            my $NextStateName   = $StateID2Name->{$NextStateID}   || $NextStateID;
            my $NextStateSignal = $StateName2Signal->{$StateName} || '';

            $Self->{LayoutObject}->Block(
                Name => 'StateTransitionRow',
                Data => {
                    CssClass        => $CssClass,
                    ObjectType      => $ObjectType,
                    StateID         => $StateID,
                    StateName       => $StateName,
                    StateSignal     => $StateSignal,
                    NextStateID     => $NextStateID,
                    NextStateName   => $NextStateName,
                    NextStateSignal => $NextStateSignal,
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
sub _OverviewObjectTypesPageGet {
    my ( $Self, %Param ) = @_;

    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => \%Param,
    );
    $Self->{LayoutObject}->Block(
        Name => 'OverviewObjectTypes',
        Data => \%Param,
    );

    # lookup table for the config item class
    my %ConfigItemClass = (
        Change    => 'ITSM::ChangeManagement::Change::State',
        WorkOrder => 'ITSM::ChangeManagement::WorkOrder::State',
    );

    my $CssClass = 'searchactive';
    for my $ObjectType (qw(Change WorkOrder)) {
        my $Class = $ConfigItemClass{$ObjectType};

        $CssClass = $CssClass eq 'searchactive' ? 'searchpassive' : 'searchactive';

        $Self->{LayoutObject}->Block(
            Name => 'OverviewObjectTypeRow',
            Data => {
                CssClass   => $CssClass,
                ObjectType => $ObjectType,
                Class      => $Class,
            },
        );
    }

    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminITSMStateMachine',
        Data         => \%Param,
    );
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
