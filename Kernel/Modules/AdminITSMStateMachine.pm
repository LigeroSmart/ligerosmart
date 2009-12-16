# --
# Kernel/Modules/AdminITSMStateMachine.pm - to add/update/delete state transitions
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: AdminITSMStateMachine.pm,v 1.7 2009-12-16 14:17:12 bes Exp $
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
$VERSION = qw($Revision: 1.7 $) [1];

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
    for my $ParamName (qw( ChangeStateID WorkOrderStateID ObjectType)) {
        $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
    }

    # check whether next states should be deleted,
    # this determines whether the confirmation page should be shown
    my $ShowConfirmDeletionPage
        = scalar( $Self->{ParamObject}->GetArray( Param => 'DelNextStateIDs' ) )
        && !$Self->{ParamObject}->GetParam( Param => 'DeletionConfirmed' );

    # Build drop-downs for the left side with all change states and all workorders.
    # These dropdown are always needed.
    {
        my $AllChangeStates = $Self->{ChangeObject}->ChangePossibleStatesGet(
            UserID => $Self->{UserID},
        );
        unshift @{$AllChangeStates}, { Key => '0', Value => '0' };
        $GetParam{ChangeStateSelectionString} = $Self->{LayoutObject}->BuildSelection(
            Data       => $AllChangeStates,
            Name       => 'ChangeStateID',
            SelectedID => $GetParam{ChangeStateID},
        );

        my $AllWorkOrderStates = $Self->{WorkOrderObject}->WorkOrderPossibleStatesGet(
            UserID => $Self->{UserID},
        );
        unshift @{$AllWorkOrderStates}, { Key => '0', Value => '0' };
        $GetParam{WorkOrderStateSelectionString} = $Self->{LayoutObject}->BuildSelection(
            Data       => $AllWorkOrderStates,
            Name       => 'WorkOrderStateID',
            SelectedID => $GetParam{WorkOrderStateID},
        );
    }

    # provide form for changing the next states
    if ( $Self->{Subaction} eq 'EditStateTransitions' ) {
        return $Self->_EditStateTransitionsPageGet(
            Action => 'EditStateTransitions',
            %GetParam,
        );
    }

    # deletion of next states was ordered, but not comfirmed yet
    elsif ($ShowConfirmDeletionPage) {
        return $Self->_ConfirmDeletionPageGet(
            Action => 'EditStateTransitions',
            %GetParam,
        );
    }

    # actually add and delete state transitions
    elsif ( $Self->{Subaction} eq 'EditStateTransitionsAction' ) {

        # config item class
        my %ConfigItemClass = (
            Change    => 'ITSM::ChangeManagement::Change::State',
            WorkOrder => 'ITSM::ChangeManagement::WorkOrder::State',
        );
        my $Class = $ConfigItemClass{ $GetParam{ObjectType} };

        # the origin of the transitions
        my $OriginStateID
            = $GetParam{ObjectType} eq 'Change'
            ? $GetParam{ChangeStateID}
            : $GetParam{WorkOrderStateID};

        my %OldNextStateID = map { $_ => 1 } @{
            $Self->{StateMachineObject}->StateTransitionGet(
                StateID => $OriginStateID,
                Class   => $Class,
                )
            };

        # Delete the DelNextStateID's
        for my $NextStateID ( $Self->{ParamObject}->GetArray( Param => 'DelNextStateIDs' ) ) {
            $Self->{StateMachineObject}->StateTransitionDelete(
                StateID     => $OriginStateID,
                NextStateID => $NextStateID
            );
        }

        # Add the AddNextStateID's
        for my $NextStateID ( $Self->{ParamObject}->GetArray( Param => 'AddNextStateIDs' ) ) {

            $Self->{StateMachineObject}->StateTransitionAdd(
                Class       => $Class,
                StateID     => $OriginStateID,
                NextStateID => $NextStateID
            );
        }
    }

    # present a table of all transitions
    $Self->_OverviewOverStateTransitions(%GetParam);
    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminITSMStateMachine',
        Data         => \%Param,
    );
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

sub _EditStateTransitionsPageGet {
    my ( $Self, %Param ) = @_;

    # the origin of the transitions
    my $OriginStateID = $Param{ObjectType} eq 'Change'
        ? $Param{ChangeStateID}
        : $Param{WorkOrderStateID};

    # Display the name of the origin state
    if ( $Param{ObjectType} eq 'Change' && $Param{ChangeStateID} ) {
        $Param{StateName} = $Self->{ChangeObject}->ChangeStateLookup(
            ChangeStateID => $OriginStateID,
        );
    }
    elsif ( $Param{ObjectType} eq 'WorkOrder' && $Param{WorkOrderStateID} ) {
        $Param{StateName} = $Self->{WorkOrderObject}->WorkOrderStateLookup(
            WorkOrderStateID => $OriginStateID,
        );
    }

    # config item class
    my %ConfigItemClass = (
        Change    => 'ITSM::ChangeManagement::Change::State',
        WorkOrder => 'ITSM::ChangeManagement::WorkOrder::State',
    );
    my $Class = $ConfigItemClass{ $Param{ObjectType} };

    # the currently possible next states
    my %OldNextStateID = map { $_ => 1 } @{
        $Self->{StateMachineObject}->StateTransitionGet(
            StateID => $OriginStateID,
            Class   => $Class,
            )
        };

    # ArrayHashRef with the all states
    my $AllArrayHashRef;
    if ( $Param{ObjectType} eq 'Change' ) {

        # all change states
        $AllArrayHashRef = $Self->{ChangeObject}->ChangePossibleStatesGet(
            UserID => $Self->{UserID},
        );
    }
    else {

        # all workorder states
        $AllArrayHashRef = $Self->{ChangeObject}->ChangePossibleStatesGet(
            UserID => $Self->{UserID},
        );
    }

    # Add the special final state
    push @{$AllArrayHashRef}, { Key => '0', Value => '0' };

    # split $AllArrayHashRef into an Array of the old next states and the possible new next states
    my ( @DelArrayHashRef, @AddArrayHashRef );
    for my $HashRef ( @{$AllArrayHashRef} ) {
        if ( $OldNextStateID{ $HashRef->{Key} } ) {
            push @DelArrayHashRef, $HashRef;
        }
        else {
            push @AddArrayHashRef, $HashRef;
        }
    }

    # dropdown menu, where the old next states can be selected for deletion
    # multiple selections are explicitly allowed
    $Param{DelNextStateSelectionString} = $Self->{LayoutObject}->BuildSelection(
        Data     => \@DelArrayHashRef,
        Multiple => 1,
        Size     => scalar(@DelArrayHashRef),
        Name     => 'DelNextStateIDs',
    );

    # dropdown menu, where the next states can be selected for addition
    # multiple selections are explicitly allowed
    $Param{AddNextStateSelectionString} = $Self->{LayoutObject}->BuildSelection(
        Data     => \@AddArrayHashRef,
        Multiple => 1,
        Size     => scalar(@AddArrayHashRef),
        Name     => 'AddNextStateIDs',
    );

    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();

    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $Self->{LayoutObject}->Block(
        Name => 'EditStateTransitions',
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

    $Self->{LayoutObject}->Block(
        Name => 'ConfirmDeletion',
        Data => \%Param,
    );

    # Show states which should be deleted
    for my $NextStateID ( $Self->{ParamObject}->GetArray( Param => 'DelNextStateIDs' ) ) {
        $Self->{LayoutObject}->Block(
            Name => 'ConfirmDeletionDelNextState',
            Data => { NextStateID => $NextStateID },
        );
    }

    # Show states which should be added
    for my $NextStateID ( $Self->{ParamObject}->GetArray( Param => 'AddNextStateIDs' ) ) {
        $Self->{LayoutObject}->Block(
            Name => 'ConfirmDeletionAddNextState',
            Data => { NextStateID => $NextStateID },
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
sub _OverviewOverStateTransitions {
    my ( $Self, %Param ) = @_;

    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => \%Param,
    );
    $Self->{LayoutObject}->Block(
        Name => 'OverviewStateTransitions',
        Data => \%Param,
    );

    # lookup table for the config item class
    my %ConfigItemClass = (
        Change    => 'ITSM::ChangeManagement::Change::State',
        WorkOrder => 'ITSM::ChangeManagement::WorkOrder::State',
    );

    # set up some lookup tables for displaying the state name and signal
    # TODO: Avoid direct usage of GeneralCatalogObject
    my ( %StateID2Name, %StateName2Signal );
    for my $ObjectType (qw(Change WorkOrder)) {

        # get the state names
        my $Class = $ConfigItemClass{$ObjectType};
        $StateID2Name{$ObjectType} = $Self->{GeneralCatalogObject}->ItemList( Class => $Class );

        # get the state signals
        $StateName2Signal{$ObjectType}
            = $Self->{ConfigObject}->Get("ITSM${ObjectType}::State::Signal");
    }

    my $CssClass = 'searchactive';
    for my $ObjectType (qw(Change WorkOrder)) {
        my $Class = $ConfigItemClass{$ObjectType};
        my %NextStateIDs = %{ $Self->{StateMachineObject}->StateTransitionList( Class => $Class ) };

        # loop over all 'State' and 'NextState' pairs for the ObjectType
        for my $StateID ( sort keys %NextStateIDs ) {

            for my $NextStateID ( @{ $NextStateIDs{$StateID} } ) {

                # set output class
                $CssClass = $CssClass eq 'searchactive' ? 'searchpassive' : 'searchactive';

                # values for the origin state
                my $StateName   = $StateID2Name{$ObjectType}->{$StateID}       || $StateID;
                my $StateSignal = $StateName2Signal{$ObjectType}->{$StateName} || '';

                # values for the next state
                my $NextStateName   = $StateID2Name{$ObjectType}->{$NextStateID}   || $NextStateID;
                my $NextStateSignal = $StateName2Signal{$ObjectType}->{$StateName} || '';

                $Self->{LayoutObject}->Block(
                    Name => 'StateTransitionRow',
                    Data => {
                        CssClass        => $CssClass,
                        ObjectType      => $ObjectType,
                        Class           => $Class,
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
    }

    return 1;
}

1;
