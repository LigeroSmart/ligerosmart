# --
# Kernel/Modules/AgentITSMSLA.pm - the OTRS::ITSM SLA module
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: AgentITSMSLA.pm,v 1.4 2009-05-18 09:48:35 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMSLA;

use strict;
use warnings;

use Kernel::System::SLA;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.4 $) [1];

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
    $Self->{SLAObject} = Kernel::System::SLA->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # output overview
    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => {%Param},
    );

    # get sla list
    my %SLAList = $Self->{SLAObject}->SLAList(
        UserID => $Self->{UserID},
    );

    my $CssClass = '';
    for my $SLAID ( sort { $SLAList{$a} cmp $SLAList{$b} } keys %SLAList ) {

        # set output object
        $CssClass = $CssClass eq 'searchpassive' ? 'searchactive' : 'searchpassive';

        # get sla data
        my %SLA = $Self->{SLAObject}->SLAGet(
            SLAID  => $SLAID,
            UserID => $Self->{UserID},
        );

        # output overview row
        $Self->{LayoutObject}->Block(
            Name => 'OverviewRow',
            Data => {
                %SLA,
                CssClass => $CssClass,
            },
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
        TemplateFile => 'AgentITSMSLA',
        Data         => \%Param,
    );
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
