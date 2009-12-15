# --
# Kernel/Modules/AdminITSMStateMachine.pm - to add/update/delete state transitions
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: AdminITSMStateMachine.pm,v 1.2 2009-12-15 18:53:16 bes Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminITSMStateMachine;

use strict;
use warnings;

use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::ITSMWorkOrder;
use Kernel::System::ITSMChange::ITSMStateMachine;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

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

    # get complete change state list
    my $AllChangeStates = $Self->{ChangeObject}->ChangePossibleStatesGet(
        UserID => $Self->{UserID},
    );

    # build drop-down with change states, for the left side
    $GetParam{ChangeStateSelectionString} = $Self->{LayoutObject}->BuildSelection(
        Data       => $AllChangeStates,
        Name       => 'ChangeStateID',
        SelectedID => $GetParam{ChangeStateID},
    );

    # get complete workorder state list
    my $AllWorkOrderStates = $Self->{WorkOrderObject}->WorkOrderPossibleStatesGet(
        UserID => $Self->{UserID},
    );

    # build drop-down with workorder states, for the left side
    $GetParam{WorkOrderStateSelectionString} = $Self->{LayoutObject}->BuildSelection(
        Data       => $AllWorkOrderStates,
        Name       => 'WorkOrderStateID',
        SelectedID => $GetParam{WorkOrderStateID},
    );

    # provide form for changing the next states
    if ( $Self->{Subaction} eq 'EditStateTransition' ) {

        # Display the name of the state
        if ( $GetParam{ObjectType} eq 'Change' && $GetParam{ChangeStateID} ) {
            $GetParam{StateName} = $Self->{ChangeObject}->ChangeStateLookup(
                ChangeStateID => $GetParam{ChangeStateID},
            );
        }
        elsif ( $GetParam{ObjectType} eq 'WorkOrder' && $GetParam{WorkOrderStateID} ) {
            $GetParam{StateName} = $Self->{WorkOrderObject}->WorkOrderStateLookup(
                WorkOrderStateID => $GetParam{WorkOrderStateID},
            );
        }

        # TODO: avoid code duplication
        # dropdown menu, where possible states can be selected and deselected
        # the existing transition are preselected,
        # multiple selections are explicitly allowed
        if ( $GetParam{ObjectType} eq 'Change' ) {
            my $NextStateIDs = $Self->{StateMachineObject}->StateTransitionGet(
                StateID => $GetParam{ChangeStateID},
                Class   => 'ITSM::ChangeManagement::Change::State',
            );

            $GetParam{NextStateSelectionString} = $Self->{LayoutObject}->BuildSelection(
                Data       => $AllChangeStates,
                Multiple   => 1,
                Size       => scalar( @{$AllChangeStates} ),
                Name       => 'NextChangeStateIDs',
                SelectedID => $NextStateIDs,
            );
        }
        else {
            my $NextStateIDs = $Self->{StateMachineObject}->StateTransitionGet(
                StateID => $GetParam{WorkOrderStateID},
                Class   => 'ITSM::ChangeManagement::WorkOrder::State',
            );

            $GetParam{NextStateSelectionString} = $Self->{LayoutObject}->BuildSelection(
                Data       => $AllWorkOrderStates,
                Multiple   => 1,
                Size       => scalar( @{$AllChangeStates} ),
                Name       => 'NextWorkOrderStateIDs',
                SelectedID => $NextStateIDs,
            );
        }
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->_EditStateTransition(
            Action => 'EditStateTransition',
            %GetParam,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminITSMStateMachine',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # actually add a state transition
    elsif ( $Self->{Subaction} eq 'EditStateTransitionAction' ) {

        # config item class
        my %ConfigItemClass = (
            Change    => 'ITSM::ChangeManagement::Change::State',
            WorkOrder => 'ITSM::ChangeManagement::WorkOrder::State',
        );
        my $Class = $ConfigItemClass{ $GetParam{ObjectType} };

        # the origin of the transitions
        my $StateID
            = $GetParam{ObjectType} eq 'Change'
            ? $GetParam{ChangeStateID}
            : $GetParam{WorkOrderStateID};

        my %OldNextStateID = map { $_ => 1 } @{
            $Self->{StateMachineObject}->StateTransitionGet(
                StateID => $GetParam{ChangeStateID},
                Class   => $Class,
                )
            };

        my %NewNextStateID;
        if ( $GetParam{ObjectType} eq 'Change' ) {
            %NewNextStateID
                = map { $_ => 1 } $Self->{ParamObject}->GetArray( Param => 'NextChangeStateIDs' );
        }
        else {
            %NewNextStateID
                = map { $_ => 1 }
                $Self->{ParamObject}->GetArray( Param => 'NextWorkOrderStateIDs' );
        }

        # Delete the NextStateIDs, which are not in %NewNextStateID
        NEXT_STATE_ID:
        for my $NextStateID ( sort keys %OldNextStateID ) {

            next NEXT_STATE_ID if $NewNextStateID{$NextStateID};

            $Self->{StateMachineObject}->StateTransitionDelete(
                StateID     => $StateID,
                NextStateID => $NextStateID
            );
        }

        # Add the NextStateIDs which are not in %OldNextStateIDs
        NEXT_STATE_ID:
        for my $NextStateID ( sort keys %NewNextStateID ) {

            next NEXT_STATE_ID if $OldNextStateID{$NextStateID};

            $Self->{StateMachineObject}->StateTransitionAdd(
                Class       => $Class,
                StateID     => $StateID,
                NextStateID => $NextStateID
            );
        }

        return $Self->{LayoutObject}->Redirect( OP => 'Action=AdminITSMStateMachine', );
    }

    # ------------------------------------------------------------
    # overview
    # ------------------------------------------------------------
    else {
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

}

sub _EditStateTransition {
    my ( $Self, %Param ) = @_;

    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $Self->{LayoutObject}->Block(
        Name => 'OverviewUpdate',
        Data => \%Param,
    );

    return 1;
}

sub _OverviewOverStateTransitions {
    my ( $Self, %Param ) = @_;

    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => \%Param,
    );
    $Self->{LayoutObject}->Block(
        Name => 'OverviewResult',
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

        # loop over all 'State' and 'NextState' pairs
        for my $StateID ( sort keys %NextStateIDs ) {

            for my $NextStateID ( @{ $NextStateIDs{$StateID} } ) {

                # set output class
                $CssClass = $CssClass eq 'searchactive' ? 'searchpassive' : 'searchactive';

                $Self->{LayoutObject}->Block(
                    Name => 'OverviewResultRow',
                    Data => {
                        Class       => $Class,
                        NextStateID => $NextStateID,
                        CssClass    => $CssClass,
                    },
                );

                if ( $StateID == 0 ) {
                    $Self->{LayoutObject}->Block(
                        Name => 'OverviewResultRowSpecialState',
                        Data => {
                            StateID => $StateID,
                        },
                    );
                }
                else {
                    my $StateName   = $StateID2Name{$ObjectType}->{$StateID};
                    my $StateSignal = $StateName2Signal{$ObjectType}->{$StateName};
                    $Self->{LayoutObject}->Block(
                        Name => 'OverviewResultRowRegularState',
                        Data => {
                            StateName   => $StateName,
                            StateSignal => $StateSignal,
                            StateID     => $StateID,
                        },
                    );
                }

                if ( $NextStateID == 0 ) {
                    $Self->{LayoutObject}->Block(
                        Name => 'OverviewResultRowSpecialNextState',
                        Data => {
                            StateID => $NextStateID,
                        },
                    );
                }
                else {
                    my $StateName   = $StateID2Name{$ObjectType}->{$NextStateID};
                    my $StateSignal = $StateName2Signal{$ObjectType}->{$StateName};
                    $Self->{LayoutObject}->Block(
                        Name => 'OverviewResultRowRegularNextState',
                        Data => {
                            StateName   => $StateName,
                            StateSignal => $StateSignal,
                            StateID     => $NextStateID,
                        },
                    );
                }
            }
        }
    }

    return 1;
}

1;
