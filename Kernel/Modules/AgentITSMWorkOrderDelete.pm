# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMWorkOrderDelete;

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

    # get needed WorkOrderID
    my $WorkOrderID = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'WorkOrderID' );

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # check needed stuff
    if ( !$WorkOrderID ) {
        return $LayoutObject->ErrorScreen(
            Message => 'No WorkOrderID is given!',
            Comment => 'Please contact the administrator.',
        );
    }

    # get workorder object
    my $WorkOrderObject = $Kernel::OM->Get('Kernel::System::ITSMChange::ITSMWorkOrder');

    # get workorder data
    my $WorkOrder = $WorkOrderObject->WorkOrderGet(
        WorkOrderID => $WorkOrderID,
        UserID      => $Self->{UserID},
    );

    # check error
    if ( !$WorkOrder ) {
        return $LayoutObject->ErrorScreen(
            Message => "WorkOrder '$WorkOrderID' not found in database!",
            Comment => 'Please contact the administrator.',
        );
    }

    # get change object
    my $ChangeObject = $Kernel::OM->Get('Kernel::System::ITSMChange');

    # get config of frontend module
    $Self->{Config} = $Kernel::OM->Get('Kernel::Config')->Get("ITSMWorkOrder::Frontend::$Self->{Action}");

    # check permissions
    my $Access = $ChangeObject->Permission(
        Type        => $Self->{Config}->{Permission},
        Action      => $Self->{Action},
        ChangeID    => $WorkOrder->{ChangeID},
        WorkOrderID => $WorkOrderID,
        UserID      => $Self->{UserID},
    );

    # error screen, don't show workorder delete mask
    if ( !$Access ) {
        return $LayoutObject->NoPermission(
            Message    => "You need $Self->{Config}->{Permission} permissions on the change!",
            WithHeader => 'yes',
        );
    }

    if ( $Self->{Subaction} eq 'WorkOrderDelete' ) {

        # delete the workorder
        my $CouldDeleteWorkOrder = $WorkOrderObject->WorkOrderDelete(
            WorkOrderID => $WorkOrder->{WorkOrderID},
            UserID      => $Self->{UserID},
        );

        if ($CouldDeleteWorkOrder) {

            # redirect to change, when the deletion was successful
            return $LayoutObject->Redirect(
                OP => "Action=AgentITSMChangeZoom;ChangeID=$WorkOrder->{ChangeID}",
            );
        }
        else {

            # show error message, when delete failed
            return $LayoutObject->ErrorScreen(
                Message => "Was not able to delete the workorder $WorkOrder->{WorkOrderID}!",
                Comment => 'Please contact the administrator.',
            );
        }
    }

    # get change that workorder belongs to
    my $Change = $ChangeObject->ChangeGet(
        ChangeID => $WorkOrder->{ChangeID},
        UserID   => $Self->{UserID},
    );

    # check if change is found
    if ( !$Change ) {
        return $LayoutObject->ErrorScreen(
            Message => "Could not find Change for WorkOrder $WorkOrderID!",
            Comment => 'Please contact the administrator.',
        );
    }

    # get condition object
    my $ConditionObject = $Kernel::OM->Get('Kernel::System::ITSMChange::ITSMCondition');

    # get affected condition ids
    my $AffectedConditionIDs = $ConditionObject->ConditionListByObjectType(
        ObjectType => 'ITSMWorkOrder',
        Selector   => $WorkOrder->{WorkOrderID},
        ChangeID   => $WorkOrder->{ChangeID},
        UserID     => $Self->{UserID},
    ) || [];

    # set the dialog type. As default, the dialog will have 2 buttons: Yes and No
    my $DialogType = 'Confirmation';

    # display list of affected conditions
    if ( @{$AffectedConditionIDs} ) {

        # set the dialog type to have only 1 button: Ok
        $DialogType = 'Message';

        $LayoutObject->Block(
            Name => 'WorkOrderInCondition',
            Data => {},
        );

        CONDITIONID:
        for my $ConditionID ( @{$AffectedConditionIDs} ) {

            # get condition
            my $Condition = $ConditionObject->ConditionGet(
                ConditionID => $ConditionID,
                UserID      => $Self->{UserID},
            );

            # check condition
            next CONDITIONID if !$Condition;

            $LayoutObject->Block(
                Name => 'WorkOrderInConditionRow',
                Data => {
                    %{$Condition},
                    %Param,
                },
            );
        }
    }
    else {
        $LayoutObject->Block(
            Name => 'NoWorkOrderInCondition',
            Data => $WorkOrder,
        );
    }

    # output content
    my $Output .= $LayoutObject->Output(
        TemplateFile => 'AgentITSMWorkOrderDelete',
        Data         => {
            %Param,
            %{$Change},
            %{$WorkOrder},
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
