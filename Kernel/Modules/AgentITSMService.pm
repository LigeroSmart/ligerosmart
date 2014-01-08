# --
# Kernel/Modules/AgentITSMService.pm - the OTRS ITSM Service module
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMService;

use strict;
use warnings;

use Kernel::System::Service;

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

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # output overview
    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => {%Param},
    );

    # get service list
    my $ServiceList = $Self->{ServiceObject}->ServiceListGet(
        UserID => $Self->{UserID},
    );

    # set incident signal
    my %InciSignals = (
        operational => 'greenled',
        warning     => 'yellowled',
        incident    => 'redled',
    );

    if ( @{$ServiceList} ) {

        # sort the service list by long service name
        @{$ServiceList} = sort { $a->{Name} . '::' cmp $b->{Name} . '::' } @{$ServiceList};

        for my $ServiceData ( @{$ServiceList} ) {

            # output overview row
            $Self->{LayoutObject}->Block(
                Name => 'OverviewRow',
                Data => {
                    %{$ServiceData},
                    Name          => $ServiceData->{Name},
                    CurInciSignal => $InciSignals{ $ServiceData->{CurInciStateType} },
                    State         => $ServiceData->{CurInciStateType},
                },
            );
        }
    }

    # otherwise it displays a no data found message
    else {
        $Self->{LayoutObject}->Block(
            Name => 'NoDataFoundMsg',
        );
    }

    # investigate refresh
    my $Refresh = $Self->{UserRefreshTime} ? 60 * $Self->{UserRefreshTime} : undef;

    # output header
    my $Output = $Self->{LayoutObject}->Header(
        Title   => 'Overview',
        Refresh => $Refresh,
    );
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # generate output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMService',
        Data         => \%Param,
    );
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
