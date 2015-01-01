# --
# Kernel/Output/HTML/FAQJournalOverviewSmall.pm.pm
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::FAQJournalOverviewSmall;

use strict;
use warnings;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed objects
    for my $Object (
        qw(ConfigObject LogObject DBObject LayoutObject UserID UserObject MainObject)
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Output;
    my @ShowColumns;

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

    # need Journal
    if ( !$Param{Journal} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need the Journal!',
        );
        return;
    }

    # store the journal locally
    my @JournalEntries;
    if ( $Param{Journal} && ref $Param{Journal} eq 'ARRAY' ) {
        @JournalEntries = @{ $Param{Journal} };
    }

    # show Journal Entries as rows
    if (@JournalEntries) {

        # check ShowColumns parameter
        if ( $Param{ShowColumns} && ref $Param{ShowColumns} eq 'ARRAY' ) {
            @ShowColumns = @{ $Param{ShowColumns} };
        }

        # build column header blocks
        if (@ShowColumns) {

            # call main block
            $Self->{LayoutObject}->Block( Name => 'RecordForm' );

            for my $Column (@ShowColumns) {

                # call header specific block
                $Self->{LayoutObject}->Block(
                    Name => 'Record' . $Column . 'Header',
                    Data => {
                        %Param,
                    },
                );
            }
        }

        my $Counter = 0;

        JournalEntry:
        for my $JournalEntry (@JournalEntries) {
            $Counter++;
            if (
                $Counter >= $Param{StartHit}
                && $Counter < ( $Param{PageShown} + $Param{StartHit} )
                )
            {

                # get FAQ data for corruption check
                my %FAQ = $Self->{FAQObject}->FAQGet(
                    ItemID     => $JournalEntry->{ItemID},
                    ItemFields => 0,
                    UserID     => $Self->{UserID},
                );

                $JournalEntry->{CleanSubject} = $Self->{FAQObject}->FAQArticleTitleClean(
                    Title => $FAQ{Title},
                    Size  => $Param{TitleSize},
                );

                next ID if !%FAQ;

                # build record block
                $Self->{LayoutObject}->Block(
                    Name => 'Record',
                    Data => {
                        %Param,
                        %{$JournalEntry},
                        Counter => $Counter,
                    },
                );

                # build column record blocks
                if (@ShowColumns) {
                    COLUMN:
                    for my $Column (@ShowColumns) {
                        $Self->{LayoutObject}->Block(
                            Name => 'Record' . $Column,
                            Data => {
                                %Param,
                                %{$JournalEntry},
                            },
                        );

                        # show links if available
                        $Self->{LayoutObject}->Block(
                            Name => 'Record' . $Column . 'LinkStart',
                            Data => {
                                %Param,
                                %{$JournalEntry},
                            },
                        );
                        $Self->{LayoutObject}->Block(
                            Name => 'Record' . $Column . 'LinkEnd',
                            Data => {
                                %Param,
                                %{$JournalEntry},
                            },
                        );
                    }
                }
            }
        }
    }

    # otherwise set an No FAQ Journal message
    else {
        $Self->{LayoutObject}->Block( Name => 'NoFAQFound' );
    }

    # use template
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentFAQJournalOverviewSmall',
        Data         => {
            %Param,
            Type        => $Self->{ViewType},
            ColumnCount => scalar @ShowColumns,
        },
    );

    return $Output;
}

1;
