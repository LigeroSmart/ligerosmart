# --
# Kernel/Modules/AgentITSMService.pm - the OTRS::ITSM Service module
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AgentITSMService.pm,v 1.3 2008-08-02 12:37:13 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::AgentITSMService;

use strict;
use warnings;

use Kernel::System::Service;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

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

    my $CssClass = '';
    for my $ServiceID ( sort { $ServiceList{$a} cmp $ServiceList{$b} } keys %ServiceList ) {

        # set output object
        $CssClass = $CssClass eq 'searchpassive' ? 'searchactive' : 'searchpassive';

        # get service data
        my %Service = $Self->{ServiceObject}->ServiceGet(
            ServiceID => $ServiceID,
            UserID    => $Self->{UserID},
        );

        # output row
        if ( $Self->{ConfigObject}->Get('Ticket::Frontend::ListType') eq 'tree' ) {

            # output overview row
            $Self->{LayoutObject}->Block(
                Name => 'OverviewRow',
                Data => {
                    %Service,
                    Name          => $Service{NameShort},
                    CurInciSignal => $InciSignals{ $Service{CurInciStateType} },
                    CssClass      => $CssClass,
                },
            );

            my @Fragment = split '::', $Service{Name};
            pop @Fragment;

            for (@Fragment) {

                # output overview row space
                $Self->{LayoutObject}->Block(
                    Name => 'OverviewRowSpace',
                );
            }
        }
        else {

            # output overview row
            $Self->{LayoutObject}->Block(
                Name => 'OverviewRow',
                Data => {
                    %Service,
                    Name          => $Service{Name},
                    CurInciSignal => $InciSignals{ $Service{CurInciStateType} },
                    CssClass      => $CssClass,
                },
            );
        }
    }

    # set last screen view
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'ITSMServiceLastScreenOverview',
        Value     => "Action=$Self->{Action}",
    );

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
