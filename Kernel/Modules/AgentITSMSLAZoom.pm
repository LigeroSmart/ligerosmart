# --
# Kernel/Modules/AgentITSMSLAZoom.pm - the OTRS ITSM SLA zoom module
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMSLAZoom;

use strict;
use warnings;

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
    $Self->{ServiceObject} = Kernel::System::Service->new(%Param);
    $Self->{SLAObject}     = Kernel::System::SLA->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get params
    my $SLAID = $Self->{ParamObject}->GetParam( Param => "SLAID" );

    # check needed stuff
    if ( !$SLAID ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "No SLAID is given!",
            Comment => 'Please contact the admin.',
        );
    }

    # get sla
    my %SLA = $Self->{SLAObject}->SLAGet(
        SLAID  => $SLAID,
        UserID => $Self->{UserID},
    );
    if ( !$SLA{SLAID} ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "SLAID $SLAID not found in database!",
            Comment => 'Please contact the admin.',
        );
    }

    # get calendar name
    if ( $SLA{Calendar} ) {
        $SLA{CalendarName} = "Calendar $SLA{Calendar} - "
            . $Self->{ConfigObject}->Get( "TimeZone::Calendar" . $SLA{Calendar} . "Name" );
    }
    else {
        $SLA{CalendarName} = 'Calendar Default';
    }

    # run config item menu modules
    if ( ref $Self->{ConfigObject}->Get('ITSMSLA::Frontend::MenuModule') eq 'HASH' ) {
        my %Menus   = %{ $Self->{ConfigObject}->Get('ITSMSLA::Frontend::MenuModule') };
        my $Counter = 0;
        for my $Menu ( sort keys %Menus ) {

            # load module
            if ( $Self->{MainObject}->Require( $Menus{$Menu}->{Module} ) ) {
                my $Object = $Menus{$Menu}->{Module}->new(
                    %{$Self},
                    SLAID => $Self->{SLAID},
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
                    SLA     => \%SLA,
                    Counter => $Counter,
                    Config  => $Menus{$Menu},
                );
            }
            else {
                return $Self->{LayoutObject}->FatalError();
            }
        }
    }

    if ( $SLA{ServiceIDs} && ref $SLA{ServiceIDs} eq 'ARRAY' && @{ $SLA{ServiceIDs} } ) {

        # output row
        $Self->{LayoutObject}->Block(
            Name => 'Service',
        );

        # create service list
        my %ServiceList;
        for my $ServiceID ( @{ $SLA{ServiceIDs} } ) {

            # get service data
            my %Service = $Self->{ServiceObject}->ServiceGet(
                ServiceID     => $ServiceID,
                IncidentState => 1,
                UserID        => $Self->{UserID},
            );

            # add service to hash
            $ServiceList{$ServiceID} = \%Service;
        }

        # set incident signal
        my %InciSignals = (
            operational => 'greenled',
            warning     => 'yellowled',
            incident    => 'redled',
        );

        my $CssClass = '';
        for my $ServiceID (
            sort { $ServiceList{$a}->{Name} cmp $ServiceList{$b}->{Name} }
            keys %ServiceList
            )
        {

            # set output object
            $CssClass = $CssClass eq 'searchpassive' ? 'searchactive' : 'searchpassive';

            # output row
            $Self->{LayoutObject}->Block(
                Name => 'ServiceRow',
                Data => {
                    %{ $ServiceList{$ServiceID} },
                    CurInciSignal => $InciSignals{ $ServiceList{$ServiceID}->{CurInciStateType} },
                    CssClass      => $CssClass,
                },
            );
        }
    }

    # get create user data
    $SLA{CreateByName} = $Self->{UserObject}->UserName(
        UserID => $SLA{CreateBy},
    );

    # get change user data
    $SLA{ChangeByName} = $Self->{UserObject}->UserName(
        UserID => $SLA{ChangeBy},
    );

    # output header
    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # generate output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMSLAZoom',
        Data         => {
            %Param,
            %SLA,
        },
    );
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
