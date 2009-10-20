# --
# Kernel/Modules/AgentITSMWorkOrderAdd.pm - the OTRS::ITSM::ChangeManagement work order add module
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: AgentITSMWorkOrderAdd.pm,v 1.2 2009-10-20 17:47:23 reb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMWorkOrderAdd;

use strict;
use warnings;

use Kernel::System::ITSMChange::WorkOrder;
use Kernel::System::ITSMChange;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

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

    my $ChangeID = $Self->{ParamObject}->GetParam( Param => 'ChangeID' );

    # check needed stuff
    if ( !$ChangeID ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'No ChangeID is given!',
            Comment => 'Please contact the admin.',
        );
    }

    # get workorder data
    my $Change = $Self->{ChangeObject}->ChangeGet(
        ChangeID => $ChangeID,
        UserID   => $Self->{UserID},
    );

    if ( !$Change ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Change $ChangeID not found in database!",
            Comment => 'Please contact the admin.',
        );
    }

    my $Title = $Self->{ParamObject}->GetParam( Param => 'Title' );

    # update workorder
    if ( $Self->{Subaction} eq 'Save' && $Title ) {
        my $WorkOrderID = $Self->{WorkOrderObject}->WorkOrderAdd(
            ChangeID    => $ChangeID,
            Instruction => $Self->{ParamObject}->GetParam( Param => 'Instruction' ),
            Title       => $Title,
            UserID      => $Self->{UserID},
        );

        if ( !$WorkOrderID ) {

            # show error message
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Was not able to add WorkOrder!",
                Comment => 'Please contact the admin.',
            );
        }
        else {

            # redirect to zoom mask
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=AgentITSMWorkOrderZoom&WorkOrderID=$WorkOrderID",
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

    # output header
    my $Output = $Self->{LayoutObject}->Header(
        Title => '',
    );
    $Output .= $Self->{LayoutObject}->NavigationBar();

    $Self->{LayoutObject}->Block(
        Name => 'RichText',
    );

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMWorkOrderAdd',
        Data         => {
            %Param,
            %{$Change},
        },
    );

    # add footer
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
