# --
# Kernel/Output/HTML/ITSMChangeOverviewSmall.pm.pm
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: ITSMChangeOverviewSmall.pm,v 1.3 2009-11-24 12:46:49 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::ITSMChangeOverviewSmall;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed objects
    for my $Object (
        qw(ConfigObject LogObject DBObject LayoutObject UserID UserObject GroupObject TicketObject MainObject QueueObject)
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(ChangeIDs PageShown StartHit)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $Output   = '';
    my $Counter  = 0;
    my $CssClass = '';
    CHANGEID:
    for my $ChangeID ( @{ $Param{ChangeIDs} } ) {
        $Counter++;
        if ( $Counter >= $Param{StartHit} && $Counter < ( $Param{PageShown} + $Param{StartHit} ) ) {

            # get current change
            my $Change = $Self->{ChangeObject}->ChangeGet(
                UserID   => $Self->{UserID},
                ChangeID => $ChangeID,
            );

            next CHANGEID if !$Change;

            # set CSS-class of the row
            $CssClass = $CssClass eq 'searchpassive' ? 'searchactive' : 'searchpassive';

            my %Data;

            # get change builder data
            my %ChangeBuilderUser = $Self->{UserObject}->GetUserData(
                UserID => $Change->{ChangeBuilderID},
                Cached => 1,
            );
            for my $Postfix (qw(UserLogin UserFirstname UserLastname)) {
                $Data{ 'ChangeBuilder' . $Postfix } = $ChangeBuilderUser{$Postfix};
            }

            $Self->{LayoutObject}->Block(
                Name => 'Record',
                Data => {
                    %{$Change},
                    %Data,
                    CssClass => $CssClass,
                },
            );
        }
    }

    # use template
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMChangeOverviewSmall',
        Data         => {
            %Param,
            Type => $Self->{ViewType},
        },
    );

    return $Output;
}

1;
