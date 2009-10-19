# --
# Kernel/Modules/AgentITSMChangeZoom.pm - the OTRS::ITSM::ChangeManagement change zoom module
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: AgentITSMChangeZoom.pm,v 1.3 2009-10-19 16:19:28 mae Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMChangeZoom;

use strict;
use warnings;

use Kernel::System::ITSMChange;
use Kernel::System::LinkObject;
use Kernel::System::GeneralCatalog;

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
    $Self->{ChangeObject}         = Kernel::System::ITSMChange->new(%Param);
    $Self->{LinkObject}           = Kernel::System::LinkObject->new(%Param);
    $Self->{GeneralCatalogObject} = Kernel::System::GeneralCatalog->new(%Param);

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

    # strip header on max 80 chars
    $Change->{Title} =~ s{ \A (.{80}) (.*) \z }{ $1 }xms;

    # break words after 80 chars
    $Change->{Description}   =~ s{ (\S{80}) }{ $1\n }xmsg;
    $Change->{Justification} =~ s{ (\S{80}) }{ $1\n }xmsg;

    # output header
    my $Output = $Self->{LayoutObject}->Header(
        Value => $Change->{Title},
    );
    $Output .= $Self->{LayoutObject}->NavigationBar();

    my @Postfixes = qw(UserLogin UserFirstname UserLastname);

    # get change manager data
    my %ChangeManagerUser = $Self->{UserObject}->GetUserData(
        UserID => $Change->{ChangeManagerID},
        Cached => 1,
    );
    for my $Postfix (@Postfixes) {
        $Change->{ 'ChangeManager' . $Postfix } = $ChangeManagerUser{$Postfix};
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

    # output meta block
    $Self->{LayoutObject}->Block(
        Name => 'Meta',
        Data => {
            %{$Change},
            CurChangeSignal => $CurChangeSignal{
                (
                    $Self->{GeneralCatalogObject}->ItemGet(
                        ItemID => $Change->{ChangeStateID},
                        ) || {}
                    )->{Name}
                },
            CurChangeState => (
                $Self->{GeneralCatalogObject}->ItemGet(
                    ItemID => $Change->{ChangeStateID},
                    ) || {}
                )->{Name},
        },
    );

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
