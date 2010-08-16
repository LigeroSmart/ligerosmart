# --
# Kernel/Modules/AgentITSMService.pm - the OTRS::ITSM Service module
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: AgentITSMService.pm,v 1.8 2010-08-16 23:12:28 dz Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMService;

use strict;
use warnings;

use Kernel::System::Service;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.8 $) [1];

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
    my %ServiceList = $Self->{ServiceObject}->ServiceList(
        UserID => $Self->{UserID},
    );

    # add suffix for correct sorting
    for my $Service ( values %ServiceList ) {
        $Service .= '::';
    }

    # set incident signal
    my %InciSignals = (
        operational => 'greenled',
        warning     => 'yellowled',
        incident    => 'redled',
    );

    # check if treeview is enabled
    my $TreeView = 0;
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::ListType') eq 'tree' ) {
        $TreeView = 1;
    }

    for my $ServiceID ( sort { $ServiceList{$a} cmp $ServiceList{$b} } keys %ServiceList ) {

        # get service data
        my %Service = $Self->{ServiceObject}->ServiceGet(
            ServiceID => $ServiceID,
            UserID    => $Self->{UserID},
        );

        # output row
        if ($TreeView) {

            # calculate level space
            my @Fragment   = split '::', $Service{Name};
            my $Level      = scalar @Fragment - 1;
            my $LevelSpace = '&nbsp;&nbsp;&nbsp;&nbsp;' x $Level;

            # output overview row
            $Self->{LayoutObject}->Block(
                Name => 'OverviewRow',
                Data => {
                    %Service,
                    LevelSpace    => $LevelSpace,
                    Name          => $Service{NameShort},
                    CurInciSignal => $InciSignals{ $Service{CurInciStateType} },
                },
            );
        }
        else {

            # output overview row
            $Self->{LayoutObject}->Block(
                Name => 'OverviewRow',
                Data => {
                    %Service,
                    Name          => $Service{Name},
                    CurInciSignal => $InciSignals{ $Service{CurInciStateType} },
                },
            );
        }
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
