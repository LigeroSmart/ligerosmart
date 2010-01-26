# --
# Kernel/Modules/AgentITSMWorkOrderTake.pm - the OTRS::ITSM::ChangeManagement workorder take module
# Copyright (C) 2003-2010 OTRS AG, http://otrs.com/
# --
# $Id: AgentITSMWorkOrderTake.pm,v 1.1 2010-01-26 14:17:24 bes Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMWorkOrderTake;

use strict;
use warnings;

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
        qw(ParamObject DBObject LayoutObject LogObject UserObject GroupObject ConfigObject)
        )
    {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Object!" );
        }
    }

    # create additional objects
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

    # set the current user as the workorder agent
    my $CouldUpdateWorkOrder = $Self->{WorkOrderObject}->WorkOrderUpdate(
        WorkOrderID      => $WorkOrderID,
        WorkOrderAgentID => $Self->{UserID},
        UserID           => $Self->{UserID},
    );

    if ($CouldUpdateWorkOrder) {

        # redirect to workorder
        return $Self->{LayoutObject}->Redirect(
            OP => "Action=AgentITSMWorkOrderZoom&WorkOrderID=$WorkOrderID",
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

1;
