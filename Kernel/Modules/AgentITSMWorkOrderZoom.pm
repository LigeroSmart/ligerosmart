# --
# Kernel/Modules/AgentITSMWorkOrderZoom.pm - the OTRS::ITSM::ChangeManagement work order zoom module
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: AgentITSMWorkOrderZoom.pm,v 1.5 2009-10-19 20:26:27 reb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMWorkOrderZoom;

use strict;
use warnings;

use Kernel::System::ITSMChange::WorkOrder;
use Kernel::System::ITSMChange;
use Kernel::System::GeneralCatalog;
use Kernel::System::LinkObject;

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
    $Self->{LinkObject}           = Kernel::System::LinkObject->new(%Param);

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
            Message => "WorkOrder $WorkOrder not found in database!",
            Comment => 'Please contact the admin.',
        );
    }

    # strip header on max 80 chars
    $WorkOrder->{Title} =~ s{ \A (.{80}) .* \z }{ $1 }xms;

    # break words after 80 chars
    $WorkOrder->{Instruction} =~ s{ (\S{80}) }{ $1\n }xmsg;
    $WorkOrder->{Report}      =~ s{ (\S{80}) }{ $1\n }xmsg;

    # get the change that workorder belongs to
    my $Change = $Self->{ChangeObject}->ChangeGet(
        ChangeID => $WorkOrder->{ChangeID},
        UserID   => $Self->{UserID},
    );

    # run work order menu modules
    if ( ref $Self->{ConfigObject}->Get('ITSMChange::WorkOrder::Frontend::MenuModule') eq 'HASH' ) {
        my %Menus = %{ $Self->{ConfigObject}->Get('ITSMChange::WorkOrder::Frontend::MenuModule') };
        my $Counter = 0;
        for my $Menu ( sort keys %Menus ) {

            # load module
            if ( $Self->{MainObject}->Require( $Menus{$Menu}->{Module} ) ) {
                my $Object = $Menus{$Menu}->{Module}->new(
                    %{$Self},
                    WorkOrderID => $WorkOrder->{WorkOrderID},
                );

                # run module
                $Counter = $Object->Run(
                    %Param,
                    WorkOrder => $WorkOrder,
                    Counter   => $Counter,
                    Config    => $Menus{$Menu},
                );
            }
            else {
                return $Self->{LayoutObject}->FatalError();
            }
        }
    }

    # output header
    my $Output = $Self->{LayoutObject}->Header(
        Title => $WorkOrder->{Title},
    );
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # get create user data
    my %CreateUser = $Self->{UserObject}->GetUserData(
        UserID => $WorkOrder->{CreateBy},
        Cached => 1,
    );

    for my $Postfix (qw(UserLogin UserFirstname UserLastname)) {
        $WorkOrder->{ 'Create' . $Postfix } = $CreateUser{$Postfix};
    }

    # get change user data
    my %ChangeUser = $Self->{UserObject}->GetUserData(
        UserID => $WorkOrder->{ChangeBy},
        Cached => 1,
    );

    for my $Postfix (qw(UserLogin UserFirstname UserLastname)) {
        $WorkOrder->{ 'Change' . $Postfix } = $ChangeUser{$Postfix};
    }

    # get change builder user
    my %ChangeBuilderUser = $Self->{UserObject}->GetUserData(
        UserID => $Change->{ChangeBuilderID},
        Cached => 1,
    );

    for my $Postfix (qw(UserLogin UserFirstname UserLastname)) {
        $WorkOrder->{ 'ChangeBuilder' . $Postfix } = $ChangeBuilderUser{$Postfix};
    }

    $WorkOrder->{ChangeBuilderString} = '-';

    if (%ChangeBuilderUser) {
        $WorkOrder->{ChangeBuilderString} = sprintf "%s (%s %s)",
            $WorkOrder->{ChangeBuilderUserLogin},
            $WorkOrder->{ChangeBuilderUserFirstname},
            $WorkOrder->{ChangeBuilderUserLastname};
    }

    # get work order user
    $WorkOrder->{WorkOrderAgentString} = '-';
    if ( $WorkOrder->{WorkOrderAgentID} ) {

        # get work order agent user
        my %WorkOrderAgentUser = $Self->{UserObject}->GetUserData(
            UserID => $WorkOrder->{WorkOrderAgentID},
            Cached => 1,
        );

        for my $Postfix (qw(UserLogin UserFirstname UserLastname)) {
            $WorkOrder->{ 'WorkOrderAgent' . $Postfix } = $WorkOrderAgentUser{$Postfix} || '';
        }

        # build string for frontend if user exists
        if (%WorkOrderAgentUser) {
            $WorkOrder->{WorkOrderAgentString} = sprintf "%s (%s %s)",
                $WorkOrder->{WorkOrderAgentUserLogin},
                $WorkOrder->{WorkOrderAgentUserFirstname},
                $WorkOrder->{WorkOrderAgentUserLastname};
        }
    }

    # get work order state list
    my $WorkOrderStateList = $Self->{GeneralCatalogObject}->ItemList(
        Class => 'ITSM::ChangeManagement::WorkOrder::State',
    ) || {};

    # temp color for changes
    my %CurWorkOrderSignal = (
        118 => 'greenled',
    );

    # output meta block
    $Self->{LayoutObject}->Block(
        Name => 'Meta',
        Data => {
            %{$WorkOrder},
            CurWorkOrderSignal => $CurWorkOrderSignal{ $WorkOrder->{WorkOrderStateID} },
            CurWorkOrderState  => $WorkOrderStateList->{ $WorkOrder->{WorkOrderStateID} },
        },
    );

    # get linked objects
    my $LinkListWithData = $Self->{LinkObject}->LinkListWithData(
        Object => 'WorkOrder',
        Key    => $WorkOrderID,
        State  => 'Valid',
        UserID => $Self->{UserID},
    );

    # get link table view mode
    my $LinkTableViewMode = $Self->{ConfigObject}->Get('LinkObject::ViewMode');

    # create the link table
    my $LinkTableStrg = $Self->{LayoutObject}->LinkObjectTableCreate(
        LinkListWithData => $LinkListWithData,
        ViewMode         => $LinkTableViewMode,
    );

    # output the link table
    if ($LinkTableStrg) {
        $Self->{LayoutObject}->Block(
            Name => 'LinkTable' . $LinkTableViewMode,
            Data => {
                LinkTableStrg => $LinkTableStrg,
            },
        );
    }

    # TODO: GeneralCatalog-Preferences definition of LED color
    #  CurInciSignal => $InciSignals{ $LastVersion->{CurInciStateType} },
    # temp color for changes
    my %CurChangeSignal = (
        requested          => 'yellowled',
        accepted           => 'greenled',
        'pending approval' => 'yellowled',
        rejected           => 'grayled',
        approved           => 'greenled',
        'in progress'      => 'yellowled',
        successfull        => 'greenled',
        failed             => 'redled',
        canceled           => 'grayled',
    );

    my $ChangeStateList = $Self->{GeneralCatalogObject}->ItemList(
        Class => 'ITSM::ChangeManagement::Change::State',
    ) || {};

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMWorkOrderZoom',
        Data         => {
            ChangeNumber    => $Change->{ChangeNumber},
            ChangeBuilder   => $Change->{ChangeBuilder},
            ChangeTitle     => $Change->{Title},
            CurChangeSignal => $CurChangeSignal{ $ChangeStateList->{ $Change->{ChangeStateID} } },
            CurChangeState  => $ChangeStateList->{ $Change->{ChangeStateID} },
            CurWorkOrderSignal => $CurWorkOrderSignal{ $WorkOrder->{WorkOrderStateID} },
            CurWorkOrderState  => $WorkOrderStateList->{ $WorkOrder->{WorkOrderStateID} },
            %{$WorkOrder},
        },
    );

    # add footer
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
