# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMChangeReset;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get needed ChangeID
    my $ChangeID = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'ChangeID' );

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # check needed stuff
    if ( !$ChangeID ) {
        return $LayoutObject->ErrorScreen(
            Message => 'No ChangeID is given!',
            Comment => 'Please contact the admin.',
        );
    }

    # get change object
    my $ChangeObject = $Kernel::OM->Get('Kernel::System::ITSMChange');

    # get config of frontend module
    $Self->{Config} = $Kernel::OM->Get('Kernel::Config')->Get("ITSMChange::Frontend::$Self->{Action}");

    # check permissions
    my $Access = $ChangeObject->Permission(
        Type     => $Self->{Config}->{Permission},
        Action   => $Self->{Action},
        ChangeID => $ChangeID,
        UserID   => $Self->{UserID},
    );

    # error screen
    if ( !$Access ) {
        return $LayoutObject->NoPermission(
            Message    => "You need $Self->{Config}->{Permission} permissions!",
            WithHeader => 'yes',
        );
    }

    # get change data
    my $Change = $ChangeObject->ChangeGet(
        ChangeID => $ChangeID,
        UserID   => $Self->{UserID},
    );

    # check if change is found
    if ( !$Change ) {
        return $LayoutObject->ErrorScreen(
            Message => "Change '$ChangeID' not found in database!",
            Comment => 'Please contact the admin.',
        );
    }

    # reset change
    if ( $Self->{Subaction} eq 'Reset' ) {

        # get state machine object
        my $StateMachineObject = $Kernel::OM->Get('Kernel::System::ITSMChange::ITSMStateMachine');

        # get start state for Changes
        my $NextChangeStateIDs = $StateMachineObject->StateTransitionGet(
            StateID => 0,
            Class   => 'ITSM::ChangeManagement::Change::State',
        );
        my $ChangeStartStateID = $NextChangeStateIDs->[0];

        # get start state for WorkOrders
        my $NextWorkOrderStateIDs = $StateMachineObject->StateTransitionGet(
            StateID => 0,
            Class   => 'ITSM::ChangeManagement::WorkOrder::State',
        );
        my $WorkOrderStartStateID = $NextWorkOrderStateIDs->[0];

        # reset WorkOrders
        for my $WorkOrderID ( @{ $Change->{WorkOrderIDs} } ) {
            my $CouldUpdateWorkOrder = $Kernel::OM->Get('Kernel::System::ITSMChange::ITSMWorkOrder')->WorkOrderUpdate(
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
                return $LayoutObject->ErrorScreen(
                    Message => "Was not able to reset WorkOrder $WorkOrderID of Change $ChangeID!",
                    Comment => 'Please contact the admin.',
                );
            }
        }

        # reset Change
        my $CouldUpdateChange = $ChangeObject->ChangeUpdate(
            ChangeID           => $ChangeID,
            ChangeStateID      => $ChangeStartStateID,
            BypassStateMachine => 1,
            UserID             => $Self->{UserID},
        );

        # update was successful
        if ($CouldUpdateChange) {

            # load new URL in parent window and close popup
            return $LayoutObject->PopupClose(
                URL => "Action=AgentITSMChangeZoom;ChangeID=$ChangeID",
            );

        }
        else {

            # show error message
            return $LayoutObject->ErrorScreen(
                Message => "Was not able to reset Change $ChangeID!",
                Comment => 'Please contact the admin.',
            );
        }
    }

    # set the dialog type. As default, the dialog will have 2 buttons: Yes and No
    my $DialogType = 'Confirmation';

    # output content
    my $Output .= $LayoutObject->Output(
        TemplateFile => 'AgentITSMChangeReset',
        Data         => {
            %Param,
            %{$Change},
        },
    );

    # build the returned data structure
    my %Data = (
        HTML       => $Output,
        DialogType => $DialogType,
    );

    # return JSON-String because of AJAX-Mode
    my $OutputJSON = $LayoutObject->JSONEncode( Data => \%Data );

    return $LayoutObject->Attachment(
        ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
        Content     => $OutputJSON,
        Type        => 'inline',
        NoCache     => 1,
    );
}

1;
