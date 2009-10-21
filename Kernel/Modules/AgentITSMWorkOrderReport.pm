# --
# Kernel/Modules/AgentITSMWorkOrderReport.pm - the OTRS::ITSM::ChangeManagement work order report module
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: AgentITSMWorkOrderReport.pm,v 1.5 2009-10-21 08:59:39 reb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMWorkOrderReport;

use strict;
use warnings;

use Kernel::System::GeneralCatalog;
use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::WorkOrder;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.5 $) [1];

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

    $Self->{ChangeObject}         = Kernel::System::ITSMChange->new(%Param);
    $Self->{WorkOrderObject}      = Kernel::System::ITSMChange::WorkOrder->new(%Param);
    $Self->{GeneralCatalogObject} = Kernel::System::GeneralCatalog->new(%Param);

    # get config of frontend module
    $Self->{Config} = $Self->{ConfigObject}->Get("ITSMChangeManagement::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

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

    if ( !$WorkOrder ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "WorkOrder $WorkOrderID not found in database!",
            Comment => 'Please contact the admin.',
        );
    }

    # update workorder
    if ( $Self->{Subaction} eq 'Save' ) {
        my $Success = $Self->{WorkOrderObject}->WorkOrderUpdate(
            WorkOrderID      => $WorkOrder->{WorkOrderID},
            Report           => $Self->{ParamObject}->GetParam( Param => 'Report' ),
            WorkOrderStateID => $Self->{ParamObject}->GetParam( Param => 'WorkOrderStateID' ),
            UserID           => $Self->{UserID},
        );

        if ( !$Success ) {

            # show error message
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Was not able to update WorkOrder $WorkOrder->{WorkOrderID}!",
                Comment => 'Please contact the admin.',
            );
        }
        else {

            # redirect to zoom mask
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=AgentITSMWorkOrderZoom&WorkOrderID=$WorkOrder->{WorkOrderID}",
            );
        }
    }

    # strip header on max 80 chars
    $WorkOrder->{WorkOrderTitle} =~ s{ \A (.{80}) .* \z }{ $1 }xms;

    # get change that workorder belongs to
    my $Change = $Self->{ChangeObject}->ChangeGet(
        ChangeID => $WorkOrder->{ChangeID},
        UserID   => $Self->{UserID},
    );

    if ( !$Change ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Could not find Change for WorkOrder $WorkOrder!",
            Comment => 'Please contact the admin.',
        );
    }

    # get work order state list
    my $WorkOrderStateList = $Self->{GeneralCatalogObject}->ItemList(
        Class => 'ITSM::ChangeManagement::WorkOrder::State',
    ) || {};

    $Param{StateSelect} = $Self->{LayoutObject}->BuildSelection(
        Data       => $WorkOrderStateList,
        Name       => 'WorkOrderStateID',
        SelectedID => $WorkOrder->{WorkOrderStateID},
    );

    # output header
    my $Output = $Self->{LayoutObject}->Header(
        Title => $WorkOrder->{WorkOrderTitle},
    );
    $Output .= $Self->{LayoutObject}->NavigationBar();

    $Self->{LayoutObject}->Block(
        Name => 'RichText',
    );

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
