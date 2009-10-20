# --
# Kernel/Modules/AgentITSMWorkOrderEdit.pm - the OTRS::ITSM::ChangeManagement work order edit module
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: AgentITSMWorkOrderEdit.pm,v 1.3 2009-10-20 17:29:48 reb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMWorkOrderEdit;

use strict;
use warnings;

use Kernel::System::ITSMChange::WorkOrder;
use Kernel::System::ITSMChange;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

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

    $Self->{WorkOrderObject} = Kernel::System::ITSMChange::WorkOrder->new(%Param);
    $Self->{ChangeObject}    = Kernel::System::ITSMChange->new(%Param);

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

    # currenttitle is the value for the title input
    $Param{CurrentTitle} = $WorkOrder->{Title};

    my $Title = $Self->{ParamObject}->GetParam( Param => 'Title' );

    # update workorder
    if ( $Self->{Subaction} eq 'Save' && $Title ) {
        my $Success = $Self->{WorkOrderObject}->WorkOrderUpdate(
            WorkOrderID => $WorkOrder->{WorkOrderID},
            Instruction => $Self->{ParamObject}->GetParam( Param => 'Instruction' ),
            Title       => $Title,
            UserID      => $Self->{UserID},
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
    elsif ( $Self->{Subaction} eq 'Save' && !$Title ) {

        # show invalid message
        $Self->{LayoutObject}->Block(
            Name => 'InvalidTitle',
        );

        # don't show title
        $Param{CurrentTitle} = '';
    }

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

    # output header
    my $Output = $Self->{LayoutObject}->Header(
        Title => $WorkOrder->{Title},
    );
    $Output .= $Self->{LayoutObject}->NavigationBar();

    $Self->{LayoutObject}->Block(
        Name => 'RichText',
    );

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMWorkOrderEdit',
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
