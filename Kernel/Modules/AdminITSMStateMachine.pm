# --
# Kernel/Modules/AdminITSMStateMachine.pm - to add/update/delete state transitions
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: AdminITSMStateMachine.pm,v 1.1 2009-12-15 15:10:40 bes Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminITSMStateMachine;

use strict;
use warnings;

use Kernel::System::GeneralCatalog;
use Kernel::System::ITSMChange::ITSMStateMachine;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

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
    $Self->{GeneralCatalogObject} = Kernel::System::GeneralCatalog->new(%Param);
    $Self->{StateMachineObject}   = Kernel::System::ITSMChange::ITSMStateMachine->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # Provide form for editing a state transition
    if ( $Self->{Subaction} eq 'EditStateTransition' ) {
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->_EditStateTransition(
            Action => 'EditStateTransition',
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminITSMStateMachine',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # actually edit the state transition
    elsif ( $Self->{Subaction} eq 'EditStateTransitionAction' ) {

        my $Note = '';
        my %GetParam;
        for (qw()) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ ) || '';
        }

        $Self->_OverviewOverStateTransitions();
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Notify( Info => 'State transition updated!' );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminITSMStateMachine',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # provide form for adding a state transition
    elsif ( $Self->{Subaction} eq 'Add' ) {
        my %GetParam;

        $GetParam{Name} = $Self->{ParamObject}->GetParam( Param => 'Name' );

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->_EditStateTransition(
            Action => 'Add',
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
    elsif ( $Self->{Subaction} eq 'AddAction' ) {

        my $Note = '';
        my %GetParam;
        for (qw()) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ ) || '';
        }

        return $Self->{LayoutObject}->Redirect( OP => 'Action=AdminITSMStateMachine', );
    }

    # ------------------------------------------------------------
    # overview
    # ------------------------------------------------------------
    else {
        $Self->_OverviewOverStateTransitions();
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
