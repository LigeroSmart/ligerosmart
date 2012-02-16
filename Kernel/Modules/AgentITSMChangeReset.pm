# --
# Kernel/Modules/AgentITSMChangeReset.pm - the OTRS::ITSM::ChangeManagement change reset module
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: AgentITSMChangeReset.pm,v 1.1 2012-02-16 12:47:40 jp Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMChangeReset;

use strict;
use warnings;

use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::ITSMStateMachine;
use Kernel::System::ITSMChange::ITSMWorkOrder;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (
        qw(ParamObject DBObject LayoutObject LogObject ConfigObject UserObject GroupObject)
        )
    {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Object!" );
        }
    }

    # create needed objects
    $Self->{ChangeObject}       = Kernel::System::ITSMChange->new(%Param);
    $Self->{WorkOrderObject}    = Kernel::System::ITSMChange::ITSMWorkOrder->new(%Param);
    $Self->{StateMachineObject} = Kernel::System::ITSMChange::ITSMStateMachine->new(%Param);

    # get config of frontend module
    $Self->{Config} = $Self->{ConfigObject}->Get("ITSMChange::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get needed ChangeID
    my $ChangeID = $Self->{ParamObject}->GetParam( Param => 'ChangeID' );

    # check needed stuff
    if ( !$ChangeID ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'No ChangeID is given!',
            Comment => 'Please contact the admin.',
        );
    }

    # check permissions
    my $Access = $Self->{ChangeObject}->Permission(
        Type     => $Self->{Config}->{Permission},
        ChangeID => $ChangeID,
        UserID   => $Self->{UserID},
    );

    # error screen
    if ( !$Access ) {
        return $Self->{LayoutObject}->NoPermission(
            Message    => "You need $Self->{Config}->{Permission} permissions!",
            WithHeader => 'yes',
        );
    }

    # get change data
    my $Change = $Self->{ChangeObject}->ChangeGet(
        ChangeID => $ChangeID,
        UserID   => $Self->{UserID},
    );

    # check if change is found
    if ( !$Change ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Change '$ChangeID' not found in database!",
            Comment => 'Please contact the admin.',
        );
    }

    # reset change
    if ( $Self->{Subaction} eq 'Reset' ) {

        # get start state for Changes
        my $NextChangeStateIDs = $Self->{StateMachineObject}->StateTransitionGet(
            StateID => 0,
            Class   => 'ITSM::ChangeManagement::Change::State',
        );
        my $ChangeStartStateID = $NextChangeStateIDs->[0];

        # get start state for WorkOrders
        my $NextWorkOrderStateIDs = $Self->{StateMachineObject}->StateTransitionGet(
            StateID => 0,
            Class   => 'ITSM::ChangeManagement::WorkOrder::State',
        );
        my $WorkOrderStartStateID = $NextWorkOrderStateIDs->[0];

        # reset WorkOrders
        for my $WorkOrderID ( @{ $Change->{WorkOrderIDs} } ) {
            my $CouldUpdateWorkOrder = $Self->{WorkOrderObject}->WorkOrderUpdate(
                WorkOrderID        => $WorkOrderID,
                WorkOrderStateID   => $WorkOrderStartStateID,
                ActualStartTime    => undef,
                ActualEndTime      => undef,
                Report             => '',
                BypassStateMachine => 1,
                UserID             => $Self->{UserID},
            );

            if ( !$CouldUpdateWorkOrder ) {

                # show error message
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "Was not able to reset WorkOrder $WorkOrderID of Change $ChangeID!",
                    Comment => 'Please contact the admin.',
                );
            }
        }

        # reset Change
        my $CouldUpdateChange = $Self->{ChangeObject}->ChangeUpdate(
            ChangeID           => $ChangeID,
            ChangeStateID      => $ChangeStartStateID,
            BypassStateMachine => 1,
            UserID             => $Self->{UserID},
        );

        # update was successful
        if ($CouldUpdateChange) {

            # load new URL in parent window and close popup
            return $Self->{LayoutObject}->PopupClose(
                URL => "Action=AgentITSMChangeZoom;ChangeID=$ChangeID",
            );

        }
        else {

            # show error message
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Was not able to reset Change $ChangeID!",
                Comment => 'Please contact the admin.',
            );
        }
    }

    # output header
    my $Output = $Self->{LayoutObject}->Header(
        Title => 'Reset',
        Type  => 'Small',
    );

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMChangeReset',
        Data         => {
            %{$Change},
        },
    );

    # add footer
    $Output .= $Self->{LayoutObject}->Footer( Type => 'Small' );

    return $Output;
}

1;
