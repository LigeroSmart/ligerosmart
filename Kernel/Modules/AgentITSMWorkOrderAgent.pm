# --
# Kernel/Modules/AgentITSMWorkOrderAgent.pm - the OTRS ITSM ChangeManagement workorder agent edit module
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMWorkOrderAgent;

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
        qw(ParamObject DBObject LayoutObject LogObject UserObject GroupObject ConfigObject)
        )
    {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Object!" );
        }
    }

    # create additional objects
    $Self->{ChangeObject}    = Kernel::System::ITSMChange->new(%Param);
    $Self->{WorkOrderObject} = Kernel::System::ITSMChange::ITSMWorkOrder->new(%Param);

    # get config for frontend
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
    my $Access = $Self->{ChangeObject}->Permission(
        Type        => $Self->{Config}->{Permission},
        Action      => $Self->{Action},
        ChangeID    => $WorkOrder->{ChangeID},
        WorkOrderID => $WorkOrderID,
        UserID      => $Self->{UserID},
    );

    # error screen
    if ( !$Access ) {
        return $Self->{LayoutObject}->NoPermission(
            Message    => "You need $Self->{Config}->{Permission} permissions on the change!",
            WithHeader => 'yes',
        );
    }

    my %GetParam;
    for my $ParamName (qw(User UserSelected)) {
        $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
    }

    my $UserServerError = '';

    # handle the 'Save' subaction
    if ( $Self->{Subaction} eq 'Save' ) {

        # workorder agent is empty and no button but the 'Save' button is clicked
        if ( !$GetParam{User} ) {

            # setting workorder agent to empty
            my $CouldUpdateWorkOrder = $Self->{WorkOrderObject}->WorkOrderUpdate(
                WorkOrderID      => $WorkOrder->{WorkOrderID},
                WorkOrderAgentID => undef,
                UserID           => $Self->{UserID},
            );

            if ($CouldUpdateWorkOrder) {

                # load new URL in parent window and close popup
                return $Self->{LayoutObject}->PopupClose(
                    URL => $Self->{LastWorkOrderView},
                );

            }
            else {

                # show error message
                return $Self->{LayoutObject}->ErrorScreen(
                    Message =>
                        "Was not able to set the workorder agent of the workorder '$WorkOrder->{WorkOrderID}' to empty!",
                    Comment => 'Please contact the admin.',
                );
            }
        }

        # if a workorder agent is selected and no button but the 'Save' button is clicked
        elsif ( $GetParam{UserSelected} ) {

            # workorder agent is required for an update
            my %ErrorAllRequired = $Self->_CheckWorkOrderAgent(%GetParam);

            # if everything is fine
            if ( !%ErrorAllRequired ) {

                my $CouldUpdateWorkOrder = $Self->{WorkOrderObject}->WorkOrderUpdate(
                    WorkOrderID      => $WorkOrder->{WorkOrderID},
                    WorkOrderAgentID => $GetParam{UserSelected},
                    UserID           => $Self->{UserID},
                );

                if ($CouldUpdateWorkOrder) {

                    # load new URL in parent window and close popup
                    return $Self->{LayoutObject}->PopupClose(
                        URL =>
                            "Action=AgentITSMWorkOrderZoom;WorkOrderID=$WorkOrder->{WorkOrderID}",
                    );
                }
                else {

                    # show error message
                    return $Self->{LayoutObject}->ErrorScreen(
                        Message =>
                            "Was not able to update the workorder '$WorkOrder->{WorkOrderID}'!",
                        Comment => 'Please contact the admin.',
                    );
                }
            }
            else {
                if ( $ErrorAllRequired{User} ) {
                    $UserServerError = 'ServerError';
                }
            }
        }
        elsif ( !$GetParam{UserSelected} ) {
            $UserServerError = 'ServerError';
        }
    }

    # show current workorder agent
    if ( $WorkOrder->{WorkOrderAgentID} ) {
        my %UserData = $Self->{UserObject}->GetUserData(
            UserID => $WorkOrder->{WorkOrderAgentID},
        );

        $Param{UserID} = $UserData{UserID};
        $Param{User}   = sprintf '"%s %s" <%s>',
            $UserData{UserFirstname},
            $UserData{UserLastname},
            $UserData{UserEmail};
    }

    # get change that workorder belongs to
    my $Change = $Self->{ChangeObject}->ChangeGet(
        ChangeID => $WorkOrder->{ChangeID},
        UserID   => $Self->{UserID},
    );

    # check whether change was found
    if ( !$Change ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Could not find Change for WorkOrder $WorkOrderID!",
            Comment => 'Please contact the admin.',
        );
    }

    $Self->{LayoutObject}->Block(
        Name => 'UserSearchInit',
        Data => {
            ItemID => 'User',
        },
    );

    # output header
    my $Output = $Self->{LayoutObject}->Header(
        Title => $WorkOrder->{WorkOrderTitle},
        Type  => 'Small',
    );

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMWorkOrderAgent',
        Data         => {
            UserServerError => $UserServerError,
            %Param,
            %{$Change},
            %{$WorkOrder},
        },
    );

    # add footer
    $Output .= $Self->{LayoutObject}->Footer( Type => 'Small' );

    return $Output;
}

sub _CheckWorkOrderAgent {
    my ( $Self, %Param ) = @_;

    # hash for error info
    my %Errors;

    # check workorder agent
    if ( !$Param{User} || !$Param{UserSelected} ) {
        $Errors{User} = 1;
    }
    else {

        # get workorder agent data
        my %User = $Self->{UserObject}->GetUserData(
            UserID => $Param{UserSelected},
        );

        # show error if user not exists
        if ( !%User ) {
            $Errors{User} = 1;
        }
        else {

            # compare input value with user data
            my $CheckString = sprintf '"%s %s" <%s>',
                $User{UserFirstname},
                $User{UserLastname},
                $User{UserEmail};

            # show error
            if ( $CheckString ne $Param{User} ) {
                $Errors{User} = 1;
            }
        }
    }

    return %Errors;
}

1;
