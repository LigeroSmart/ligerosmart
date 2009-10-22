# --
# Kernel/Modules/AgentITSMChangeZoom.pm - the OTRS::ITSM::ChangeManagement change zoom module
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: AgentITSMChangeZoom.pm,v 1.11 2009-10-22 13:07:41 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMChangeZoom;

use strict;
use warnings;

use Kernel::System::GeneralCatalog;
use Kernel::System::LinkObject;
use Kernel::System::CustomerUser;
use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::WorkOrder;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.11 $) [1];

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
    $Self->{GeneralCatalogObject} = Kernel::System::GeneralCatalog->new(%Param);
    $Self->{LinkObject}           = Kernel::System::LinkObject->new(%Param);
    $Self->{CustomerUserObject}   = Kernel::System::CustomerUser->new(%Param);
    $Self->{ChangeObject}         = Kernel::System::ITSMChange->new(%Param);
    $Self->{WorkOrderObject}      = Kernel::System::ITSMChange::WorkOrder->new(%Param);

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

    if ( !$Change ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Change $Change not found in database!",
            Comment => 'Please contact the admin.',
        );
    }

    # run change menu modules
    if ( ref $Self->{ConfigObject}->Get('ITSMChange::Frontend::MenuModule') eq 'HASH' ) {
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

    # strip header on max 80 chars
    $Change->{ChangeTitle} =~ s{ \A (.{80}) (.*) \z }{ $1 }xms;

    # break words after 80 chars
    $Change->{Description}   =~ s{ (\S{80}) }{ $1\n }xmsg;
    $Change->{Justification} =~ s{ (\S{80}) }{ $1\n }xmsg;

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

    my @Postfixes = qw(UserLogin UserFirstname UserLastname);

    if ( $Change->{ChangeManagerID} ) {

        # get change manager data
        my %ChangeManagerUser = $Self->{UserObject}->GetUserData(
            UserID => $Change->{ChangeManagerID},
            Cached => 1,
        );
        for my $Postfix (@Postfixes) {
            if ( $Postfix eq 'UserFirstname' ) {
                $Change->{ 'ChangeManager' . $Postfix } = '(' . $ChangeManagerUser{$Postfix};
            }
            elsif ( $Postfix eq 'UserLastname' ) {
                $Change->{ 'ChangeManager' . $Postfix } = $ChangeManagerUser{$Postfix} . ')';
            }
            else {
                $Change->{ 'ChangeManager' . $Postfix } = $ChangeManagerUser{$Postfix};
            }
        }
    }
    else {
        $Change->{ChangeManagerUserLogin} = '-';
    }

    # get change builder data
    my %ChangeBuilderUser = $Self->{UserObject}->GetUserData(
        UserID => $Change->{ChangeBuilderID},
        Cached => 1,
    );
    for my $Postfix (@Postfixes) {
        $Change->{ 'ChangeBuilder' . $Postfix } = $ChangeBuilderUser{$Postfix};
    }

    # get create user data
    my %CreateUser = $Self->{UserObject}->GetUserData(
        UserID => $Change->{CreateBy},
        Cached => 1,
    );
    for my $Postfix (@Postfixes) {
        $Change->{ 'Create' . $Postfix } = $CreateUser{$Postfix};
    }

    # get change user data
    my %ChangeUser = $Self->{UserObject}->GetUserData(
        UserID => $Change->{ChangeBy},
        Cached => 1,
    );
    for my $Postfix (@Postfixes) {
        $Change->{ 'Change' . $Postfix } = $ChangeUser{$Postfix};
    }

    # get change state
    my $ChangeState = $Self->{GeneralCatalogObject}->ItemGet(
        ItemID => $Change->{ChangeStateID},
    ) || {};

    # get all change state signals
    my $ChangeStateSignal = $Self->{ConfigObject}->Get('ITSMChange::State::Signal');

    # output meta block
    $Self->{LayoutObject}->Block(
        Name => 'Meta',
        Data => {
            %{$Change},
            ChangeState       => $ChangeState->{Name},
            ChangeStateSignal => $ChangeStateSignal->{ $ChangeState->{Name} },
        },
    );

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

        # build content for customer block
        my %CABCustomerData;
        for my $Postfix (@Postfixes) {
            $CABCustomerData{ 'CABCustomer' . $Postfix } = $CABCustomerUserData{$Postfix};
        }

        # output agent block
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
