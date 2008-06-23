# --
# Kernel/Modules/AgentITSMLocationZoom.pm - the OTRS::ITSM Location zoom module
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AgentITSMLocationZoom.pm,v 1.2 2008-06-23 21:51:35 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::AgentITSMLocationZoom;

use strict;
use warnings;

use Kernel::System::GeneralCatalog;
use Kernel::System::ITSMLocation;
use Kernel::System::LinkObject;

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
    $Self->{GeneralCatalogObject} = Kernel::System::GeneralCatalog->new(%Param);
    $Self->{LocationObject}       = Kernel::System::ITSMLocation->new(%Param);
    $Self->{LinkObject}           = Kernel::System::LinkObject->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get params
    my $LocationID = $Self->{ParamObject}->GetParam( Param => 'LocationID' );

    # check needed stuff
    if ( !$LocationID ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'No LocationID is given!',
            Comment => 'Please contact the admin.',
        );
    }

    # get location
    my %Location = $Self->{LocationObject}->LocationGet(
        LocationID => $LocationID,
        UserID     => $Self->{UserID},
    );
    if ( !$Location{LocationID} ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "LocationID $LocationID not found in database!",
            Comment => 'Please contact the admin.',
        );
    }

    # get type list
    my $TypeList = $Self->{GeneralCatalogObject}->ItemList(
        Class => 'ITSM::Location::Type',
    );
    $Location{Type}    = $TypeList->{ $Location{TypeID} };
    $Location{Address} = $Self->{LayoutObject}->Ascii2Html(
        Text           => $Location{Address},
        HTMLResultMode => 1,
    );

    # run config item menu modules
    if ( ref $Self->{ConfigObject}->Get('ITSMLocation::Frontend::MenuModule') eq 'HASH' ) {
        my %Menus   = %{ $Self->{ConfigObject}->Get('ITSMLocation::Frontend::MenuModule') };
        my $Counter = 0;
        for my $Menu ( sort keys %Menus ) {

            # load module
            if ( $Self->{MainObject}->Require( $Menus{$Menu}->{Module} ) ) {
                my $Object = $Menus{$Menu}->{Module}->new(
                    %{$Self},
                    LocationID => $Self->{LocationID},
                );

                # run module
                $Counter = $Object->Run(
                    %Param,
                    Location => \%Location,
                    Counter  => $Counter,
                    Config   => $Menus{$Menu},
                );
            }
            else {
                return $Self->{LayoutObject}->FatalError();
            }
        }
    }

    # get linked objects
    my $LinkListWithData = $Self->{LinkObject}->LinkListWithData(
        Object => 'ITSMLocation',
        Key    => $LocationID,
        State  => 'Valid',
        UserID => $Self->{UserID},
    );

    # get link table view mode
    my $LinkTableViewMode = $Self->{ConfigObject}->Get( 'LinkObject::ViewMode' );

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

    # get create user data
    my %CreateUser = $Self->{UserObject}->GetUserData(
        UserID => $Location{CreateBy},
        Cached => 1,
    );
    for my $Postfix (qw(UserLogin UserFirstname UserLastname)) {
        $Location{ 'Create' . $Postfix } = $CreateUser{$Postfix};
    }

    # get change user data
    my %ChangeUser = $Self->{UserObject}->GetUserData(
        UserID => $Location{ChangeBy},
        Cached => 1,
    );
    for my $Postfix (qw(UserLogin UserFirstname UserLastname)) {
        $Location{ 'Change' . $Postfix } = $ChangeUser{$Postfix};
    }

    # set last screen view (ITSMLocation)
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'ITSMLocationLastScreenView',
        Value     => "Action=$Self->{Action}&LocationID=$LocationID",
    );

    # set last screen view (LinkObject)
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LinkObjectLastScreen',
        Value     => "Action=$Self->{Action}&LocationID=$LocationID",
    );

    # output header
    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # generate output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMLocationZoom',
        Data => { %Param, %Location },
    );
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
