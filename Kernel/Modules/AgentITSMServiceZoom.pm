# --
# Kernel/Modules/AgentITSMServiceZoom.pm - the OTRS ITSM Service zoom module
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMServiceZoom;

use strict;
use warnings;

use Kernel::System::LinkObject;
use Kernel::System::Service;
use Kernel::System::SLA;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(ConfigObject ParamObject DBObject LayoutObject LogObject)) {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Object!" );
        }
    }
    $Self->{LinkObject}    = Kernel::System::LinkObject->new(%Param);
    $Self->{ServiceObject} = Kernel::System::Service->new(%Param);
    $Self->{SLAObject}     = Kernel::System::SLA->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get params
    my $ServiceID = $Self->{ParamObject}->GetParam( Param => 'ServiceID' );

    # check needed stuff
    if ( !$ServiceID ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'No ServiceID is given!',
            Comment => 'Please contact the admin.',
        );
    }

    # get service
    my %Service = $Self->{ServiceObject}->ServiceGet(
        ServiceID     => $ServiceID,
        IncidentState => 1,
        UserID        => $Self->{UserID},
    );
    if ( !$Service{ServiceID} ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "ServiceID $ServiceID not found in database!",
            Comment => 'Please contact the admin.',
        );
    }

    # run config item menu modules
    if ( ref $Self->{ConfigObject}->Get('ITSMService::Frontend::MenuModule') eq 'HASH' ) {
        my %Menus   = %{ $Self->{ConfigObject}->Get('ITSMService::Frontend::MenuModule') };
        my $Counter = 0;
        for my $Menu ( sort keys %Menus ) {

            # load module
            if ( $Self->{MainObject}->Require( $Menus{$Menu}->{Module} ) ) {
                my $Object = $Menus{$Menu}->{Module}->new(
                    %{$Self},
                    ServiceID => $Self->{ServiceID},
                );

                # set classes
                if ( $Menus{$Menu}->{Target} ) {
                    if ( $Menus{$Menu}->{Target} eq 'PopUp' ) {
                        $Menus{$Menu}->{MenuClass} = 'AsPopup';
                    }
                    elsif ( $Menus{$Menu}->{Target} eq 'Back' ) {
                        $Menus{$Menu}->{MenuClass} = 'HistoryBack';
                    }
                }

                # run module
                $Counter = $Object->Run(
                    %Param,
                    Service => \%Service,
                    Counter => $Counter,
                    Config  => $Menus{$Menu},
                );
            }
            else {
                return $Self->{LayoutObject}->FatalError();
            }
        }
    }

    # get sla list
    my %SLAList = $Self->{SLAObject}->SLAList(
        ServiceID => $ServiceID,
        UserID    => $Self->{UserID},
    );
    if (%SLAList) {

        # output row
        $Self->{LayoutObject}->Block(
            Name => 'SLA',
        );

        for my $SLAID ( sort { $SLAList{$a} cmp $SLAList{$b} } keys %SLAList ) {

            # get sla data
            my %SLA = $Self->{SLAObject}->SLAGet(
                SLAID  => $SLAID,
                UserID => $Self->{UserID},
            );

            # output row
            $Self->{LayoutObject}->Block(
                Name => 'SLARow',
                Data => {
                    %SLA,
                },
            );
        }
    }

    # get linked objects
    my $LinkListWithData = $Self->{LinkObject}->LinkListWithData(
        Object => 'Service',
        Key    => $ServiceID,
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

    # set incident signal
    my %InciSignals = (
        operational => 'greenled',
        warning     => 'yellowled',
        incident    => 'redled',
    );

    # get create user data
    $Service{CreateByName} = $Self->{UserObject}->UserName(
        UserID => $Service{CreateBy},
    );

    # get change user data
    $Service{ChangeByName} = $Self->{UserObject}->UserName(
        UserID => $Service{ChangeBy},
    );

    # store last screen
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenView',
        Value     => $Self->{RequestedURL},
    );

    # output header
    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # generate output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMServiceZoom',
        Data         => {
            %Param,
            %Service,
            CurInciSignal => $InciSignals{ $Service{CurInciStateType} },
        },
    );
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
