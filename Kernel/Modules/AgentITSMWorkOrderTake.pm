# --
# Kernel/Modules/AgentITSMWorkOrderTake.pm - the OTRS ITSM ChangeManagement workorder take module
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMWorkOrderTake;

use strict;
use warnings;

use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::ITSMWorkOrder;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (
        qw(ParamObject DBObject LayoutObject LogObject ConfigObject UserObject UserObject GroupObject)
        )
    {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Object!" );
        }
    }

    # create additional objects
    $Self->{ChangeObject}    = Kernel::System::ITSMChange->new(%Param);
    $Self->{WorkOrderObject} = Kernel::System::ITSMChange::ITSMWorkOrder->new(%Param);

    # get config of frontend module
    $Self->{Config} = $Self->{ConfigObject}->Get("ITSMWorkOrder::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get needed WorkOrderID
    my $WorkOrderID = $Self->{ParamObject}->GetParam( Param => 'WorkOrderID' );

    # check needed stuff
    if ( !$WorkOrderID ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'No WorkOrderID is given!',
            Comment => 'Please contact the admin.',
        );
    }

    # get workorder data
    my $WorkOrder = $Self->{WorkOrderObject}->WorkOrderGet(
        WorkOrderID => $WorkOrderID,
        UserID      => $Self->{UserID},
    );

    # check error
    if ( !$WorkOrder ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "WorkOrder '$WorkOrderID' not found in database!",
            Comment => 'Please contact the admin.',
        );
    }

    # check permissions
    # query the permission modules registered in 'ITSMWorkOrder::TakePermission'
    my $Access = $Self->{WorkOrderObject}->Permission(
        Type               => $Self->{Config}->{Permission},
        Action             => $Self->{Action},
        PermissionRegistry => 'ITSMWorkOrder::TakePermission',
        WorkOrderID        => $WorkOrderID,
        UserID             => $Self->{UserID},
    );

    # error screen
    if ( !$Access ) {
        return $Self->{LayoutObject}->NoPermission(
            Message    => "You need $Self->{Config}->{Permission} permissions!",
            WithHeader => 'yes',
        );
    }

    if ( $Self->{Subaction} eq 'WorkOrderTake' ) {

        # set the current user as the workorder agent
        my $CouldUpdateWorkOrder = $Self->{WorkOrderObject}->WorkOrderUpdate(
            WorkOrderID      => $WorkOrderID,
            WorkOrderAgentID => $Self->{UserID},
            UserID           => $Self->{UserID},
        );

        if ($CouldUpdateWorkOrder) {

            # redirect to workorder, when the update was successful
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=AgentITSMWorkOrderZoom;WorkOrderID=$WorkOrderID",
            );
        }
        else {

            # show error message
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Was not able to take the workorder '$WorkOrderID'!",
                Comment => 'Please contact the admin.',
            );
        }
    }

    # Login name of the current workorder agent
    my $WorkOrderAgent = '-';
    if ( $WorkOrder->{WorkOrderAgentID} ) {
        $WorkOrderAgent = $Self->{UserObject}->UserLookup(
            UserID => $WorkOrder->{WorkOrderAgentID},
        );
    }

    # get change that workorder belongs to
    my $Change = $Self->{ChangeObject}->ChangeGet(
        ChangeID => $WorkOrder->{ChangeID},
        UserID   => $Self->{UserID},
    );

    # check if change is found
    if ( !$Change ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Could not find Change for WorkOrder $WorkOrderID!",
            Comment => 'Please contact the admin.',
        );
    }

    # output content
    my $Output = $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMWorkOrderTake',
        Data         => {
            %Param,
            %{$Change},
            %{$WorkOrder},
            WorkOrderAgent => $WorkOrderAgent,
        },
    );

    # build the returned data structure
    my %Data = (
        HTML       => $Output,
        DialogType => 'Confirmation',
    );

    # return JSON-String because of AJAX-Mode
    my $OutputJSON = $Self->{LayoutObject}->JSONEncode( Data => \%Data );

    return $Self->{LayoutObject}->Attachment(
        ContentType => 'application/json; charset=' . $Self->{LayoutObject}->{Charset},
        Content     => $OutputJSON,
        Type        => 'inline',
        NoCache     => 1,
    );
}

1;
