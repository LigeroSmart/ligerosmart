# --
# Kernel/Modules/AgentITSMWorkOrderReport.pm - the OTRS::ITSM::ChangeManagement workorder report module
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: AgentITSMWorkOrderReport.pm,v 1.16 2009-11-28 16:01:29 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMWorkOrderReport;

use strict;
use warnings;

use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::ITSMWorkOrder;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.16 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(ParamObject DBObject LayoutObject LogObject ConfigObject)) {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Object!" );
        }
    }

    # create needed objects
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

    # check permissions
    my $Access = $Self->{WorkOrderObject}->Permission(
        Type        => $Self->{Config}->{Permission},
        WorkOrderID => $WorkOrderID,
        UserID      => $Self->{UserID},
    );

    # error screen
    if ( !$Access ) {
        return $Self->{LayoutObject}->NoPermission(
            Message    => "You need $Self->{Config}->{Permission} permissions!",
            WithHeader => 'yes',
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
            Message => "WorkOrder $WorkOrderID not found in database!",
            Comment => 'Please contact the admin.',
        );
    }

    # save the needed GET params in Hash
    my %GetParam;
    for my $ParamName (qw(Report WorkOrderStateID)) {
        $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
    }

    # update workorder
    if ( $Self->{Subaction} eq 'Save' ) {
        my $CouldUpdateWorkOrder = $Self->{WorkOrderObject}->WorkOrderUpdate(
            WorkOrderID      => $WorkOrder->{WorkOrderID},
            Report           => $GetParam{Report},
            WorkOrderStateID => $GetParam{WorkOrderStateID},
            UserID           => $Self->{UserID},
        );

        # if workorder update was successful
        if ($CouldUpdateWorkOrder) {

            # redirect to zoom mask
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=AgentITSMWorkOrderZoom&WorkOrderID=$WorkOrder->{WorkOrderID}",
            );
        }
        else {

            # show error message
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Was not able to update WorkOrder $WorkOrder->{WorkOrderID}!",
                Comment => 'Please contact the admin.',
            );
        }
    }

    # get change that the workorder belongs to
    my $Change = $Self->{ChangeObject}->ChangeGet(
        ChangeID => $WorkOrder->{ChangeID},
        UserID   => $Self->{UserID},
    );

    # no change found
    if ( !$Change ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Could not find Change for WorkOrder $WorkOrderID!",
            Comment => 'Please contact the admin.',
        );
    }

    # get workorder state list
    my $WorkOrderPossibleStates = $Self->{WorkOrderObject}->WorkOrderPossibleStatesGet(
        WorkOrderID => $WorkOrderID,
        UserID      => $Self->{UserID},
    );

    # build drop-down with workorder states
    $Param{StateSelect} = $Self->{LayoutObject}->BuildSelection(
        Data       => $WorkOrderPossibleStates,
        Name       => 'WorkOrderStateID',
        SelectedID => $WorkOrder->{WorkOrderStateID},
    );

    # show state dropdown
    $Self->{LayoutObject}->Block(
        Name => 'State',
        Data => {
            %Param,
        },
    );

    # output header
    my $Output = $Self->{LayoutObject}->Header(
        Title => $WorkOrder->{WorkOrderTitle},
    );
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # add rich text editor
    if ( $Self->{ConfigObject}->Get('Frontend::RichText') ) {
        $Self->{LayoutObject}->Block(
            Name => 'RichText',
        );
    }

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMWorkOrderReport',
        Data         => {
            %Param,
            %{$Change},
            %{$WorkOrder},
        },
    );

    # add footer
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
