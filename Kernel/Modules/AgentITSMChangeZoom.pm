# --
# Kernel/Modules/AgentITSMChangeZoom.pm - the OTRS::ITSM::ChangeManagement change zoom module
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: AgentITSMChangeZoom.pm,v 1.14 2009-10-27 16:40:47 bes Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMChangeZoom;

use strict;
use warnings;

use Kernel::System::LinkObject;
use Kernel::System::CustomerUser;
use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::WorkOrder;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.14 $) [1];

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
    $Self->{LinkObject}         = Kernel::System::LinkObject->new(%Param);
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);
    $Self->{ChangeObject}       = Kernel::System::ITSMChange->new(%Param);
    $Self->{WorkOrderObject}    = Kernel::System::ITSMChange::WorkOrder->new(%Param);

    # get config of frontend module
    $Self->{Config} = $Self->{ConfigObject}->Get("ITSMChangeManagement::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get params
    my $ChangeID = $Self->{ParamObject}->GetParam( Param => "ChangeID" );

    # check needed stuff
    if ( !$ChangeID ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "No ChangeID is given!",
            Comment => 'Please contact the admin.',
        );
    }

    # get Change
    my $Change = $Self->{ChangeObject}->ChangeGet(
        ChangeID => $ChangeID,
        UserID   => $Self->{UserID},
    );

    # check error
    if ( !$Change ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Change $Change not found in database!",
            Comment => 'Please contact the admin.',
        );
    }

    # run change menu modules
    if ( ref $Self->{ConfigObject}->Get('ITSMChange::Frontend::MenuModule') eq 'HASH' ) {

        # get items for menu
        my %Menus   = %{ $Self->{ConfigObject}->Get('ITSMChange::Frontend::MenuModule') };
        my $Counter = 0;

        for my $Menu ( sort keys %Menus ) {

            # load module
            if ( $Self->{MainObject}->Require( $Menus{$Menu}->{Module} ) ) {
                my $Object = $Menus{$Menu}->{Module}->new(
                    %{$Self},
                    ChangeID => $Self->{ChangeID},
                );

                # run module
                $Counter = $Object->Run(
                    %Param,
                    Change  => $Change,
                    Counter => $Counter,
                    Config  => $Menus{$Menu},
                );
            }
            else {
                return $Self->{LayoutObject}->FatalError();
            }
        }
    }

    # break Description after 80 chars
    if ( $Change->{Description} ) {
        $Change->{Description} =~ s{ (\S{80}) }{ $1\n }xmsg;
    }

    # break Justification after 80 chars
    if ( $Change->{Justification} ) {
        $Change->{Justification} =~ s{ (\S{80}) }{ $1\n }xmsg;
    }

    # output header
    my $Output = $Self->{LayoutObject}->Header(
        Value => $Change->{ChangeTitle},
    );
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # build temporary workorder zoom
    WORKORDERID:
    for my $WorkOrderID ( @{ $Change->{WorkOrderIDs} } ) {
        my $WorkOrder = $Self->{WorkOrderObject}->WorkOrderGet(
            WorkOrderID => $WorkOrderID,
            UserID      => $Self->{UserID},
        );

        $Self->{LayoutObject}->Block(
            Name => 'WorkOrderListItem',
            Data => {
                %{$WorkOrder},
            },
        );
    }

    # all postfixes needed for information
    my @Postfixes = qw(UserLogin UserFirstname UserLastname);

    # get change builder data
    my %ChangeBuilderUser = $Self->{UserObject}->GetUserData(
        UserID => $Change->{ChangeBuilderID},
        Cached => 1,
    );

    # get ChangeBuilder user information
    for my $Postfix (@Postfixes) {
        $Change->{ 'ChangeBuilder' . $Postfix } = $ChangeBuilderUser{$Postfix};
    }

    # get create user data
    my %CreateUser = $Self->{UserObject}->GetUserData(
        UserID => $Change->{CreateBy},
        Cached => 1,
    );

    # get CreateBy user information
    for my $Postfix (@Postfixes) {
        $Change->{ 'Create' . $Postfix } = $CreateUser{$Postfix};
    }

    # get change user data
    my %ChangeUser = $Self->{UserObject}->GetUserData(
        UserID => $Change->{ChangeBy},
        Cached => 1,
    );

    # get ChangeBy user information
    for my $Postfix (@Postfixes) {
        $Change->{ 'Change' . $Postfix } = $ChangeUser{$Postfix};
    }

    # output meta block
    $Self->{LayoutObject}->Block(
        Name => 'Meta',
        Data => {
            %{$Change},
        },
    );

    # get change manager data
    my %ChangeManagerUser;
    if ( $Change->{ChangeManagerID} ) {

        # get change manager data
        %ChangeManagerUser = $Self->{UserObject}->GetUserData(
            UserID => $Change->{ChangeManagerID},
            Cached => 1,
        );
    }

    # get change manager information
    for my $Postfix (qw(UserLogin UserFirstname UserLastname)) {
        $Change->{ 'ChangeManager' . $Postfix } = $ChangeManagerUser{$Postfix} || '';
    }

    # output change manager block
    if (%ChangeManagerUser) {

        # show name and mail address if user exists
        $Self->{LayoutObject}->Block(
            Name => 'ChangeManager',
            Data => {
                %{$Change},
            },
        );
    }
    else {

        # show dash if no change manager exists
        $Self->{LayoutObject}->Block(
            Name => 'EmptyChangeManager',
            Data => {},
        );
    }

    # output CAB block
    $Self->{LayoutObject}->Block(
        Name => 'CAB',
        Data => {
            %{$Change},
        },
    );

    # build and output CAB agents
    CABAGENT:
    for my $CABAgent ( @{ $Change->{CABAgents} } ) {
        next CABAGENT if !$CABAgent;

        my %CABAgentUserData = $Self->{UserObject}->GetUserData(
            UserID => $CABAgent,
            Cache  => 1,
        );

        next CABAGENT if !%CABAgentUserData;

        # build content for agent block
        my %CABAgentData;
        for my $Postfix (@Postfixes) {
            $CABAgentData{ 'CABAgent' . $Postfix } = $CABAgentUserData{$Postfix};
        }

        # output agent block
        $Self->{LayoutObject}->Block(
            Name => 'CABAgent',
            Data => {
                %CABAgentData,
            },
        );
    }

    # build and output CAB customers
    CABCUSTOMER:
    for my $CABCustomer ( @{ $Change->{CABCustomers} } ) {
        next CABCUSTOMER if !$CABCustomer;

        my %CABCustomerUserData = $Self->{CustomerUserObject}->CustomerUserDataGet(
            User => $CABCustomer,
        );

        next CABCUSTOMER if !%CABCustomerUserData;

        # build content for CAB customer block
        my %CABCustomerData;
        for my $Postfix (@Postfixes) {
            $CABCustomerData{ 'CABCustomer' . $Postfix } = $CABCustomerUserData{$Postfix};
        }

        # output CAB customer block
        $Self->{LayoutObject}->Block(
            Name => 'CABCustomer',
            Data => {
                %CABCustomerData,
            },
        );
    }

    # get linked objects
    my $LinkListWithData = $Self->{LinkObject}->LinkListWithData(
        Object => 'ITSMChange',
        Key    => $ChangeID,
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

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMChangeZoom',
        Data         => {
            %{$Change},
        },
    );

    # add footer
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
