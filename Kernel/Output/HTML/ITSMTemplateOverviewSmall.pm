# --
# Kernel/Output/HTML/ITSMTemplateOverviewSmall.pm.pm
# Copyright (C) 2003-2010 OTRS AG, http://otrs.com/
# --
# $Id: ITSMTemplateOverviewSmall.pm,v 1.1 2010-01-20 16:16:26 bes Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::ITSMTemplateOverviewSmall;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

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
    for my $Needed (qw(PageShown StartHit)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # need TemplateIDs
    if ( !$Param{TemplateIDs} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need the TemplateIDs!',
        );
        return;
    }

    # store the template IDs
    my @IDs = @{ $Param{TemplateIDs} };

    # check ShowColumns parameter
    my @ShowColumns;
    if ( $Param{ShowColumns} && ref $Param{ShowColumns} eq 'ARRAY' ) {
        @ShowColumns = @{ $Param{ShowColumns} };
    }

    # build column header blocks
    if (@ShowColumns) {
        for my $Column (@ShowColumns) {
            $Self->{LayoutObject}->Block(
                Name => 'Record' . $Column . 'Header',
                Data => \%Param,
            );
        }
    }

    my $Output   = '';
    my $Counter  = 0;
    my $CssClass = '';
    ID:
    for my $ID (@IDs) {
        $Counter++;
        if ( $Counter >= $Param{StartHit} && $Counter < ( $Param{PageShown} + $Param{StartHit} ) ) {

            # display the template data
            my $Template = $Self->{TemplateObject}->TemplateGet(
                TemplateID => $ID,
                UserID     => $Self->{UserID},
            );
            my %Data = %{$Template};

            # set css class of the row
            $CssClass = $CssClass eq 'searchpassive' ? 'searchactive' : 'searchpassive';

            # build record block
            $Self->{LayoutObject}->Block(
                Name => 'Record',
                Data => {
                    %Param,
                    %Data,
                    CssClass => $CssClass,
                },
            );

            # build column record blocks
            if (@ShowColumns) {
                for my $Column (@ShowColumns) {
                    $Self->{LayoutObject}->Block(
                        Name => 'Record' . $Column,
                        Data => {
                            %Param,
                            %Data,
                            CssClass => $CssClass,
                        },
                    );
                }
            }
        }
    }

    # use template
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMTemplateOverviewSmall',
        Data         => {
            %Param,
            Type        => $Self->{ViewType},
            ColumnCount => scalar @ShowColumns,
        },
    );

    return $Output;
}

1;
