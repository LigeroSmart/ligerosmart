# --
# Kernel/Output/HTML/FAQOverviewSmall.pm.pm
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::FAQOverviewSmall;

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

    $Self->{MultiLanguage} = $Self->{ConfigObject}->Get('FAQ::MultiLanguage');

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

    # need FAQIDs
    if ( !$Param{FAQIDs} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need the FAQIDs!',
        );
        return;
    }

    # store the FAQIDs
    my @IDs;
    if ( $Param{FAQIDs} && ref $Param{FAQIDs} eq 'ARRAY' ) {
        @IDs = @{ $Param{FAQIDs} };
    }

    if (@IDs) {

        # check ShowColumns parameter
        if ( $Param{ShowColumns} && ref $Param{ShowColumns} eq 'ARRAY' ) {
            @ShowColumns = @{ $Param{ShowColumns} };
        }

        # build column header blocks
        if (@ShowColumns) {

            # call main block
            $Self->{LayoutObject}->Block( Name => 'RecordForm' );

            COLUMN:
            for my $Column (@ShowColumns) {

                next COLUMN if ( $Column eq 'Language' && !$Self->{MultiLanguage} );

                # create needed variables
                my $CSS = 'OverviewHeader';
                my $OrderBy;

                # remove ID if necesary
                if ( $Param{SortBy} ) {
                    $Param{SortBy}
                        = $Param{SortBy} eq 'PriorityID'
                        ? 'Priority'
                        : $Param{SortBy} eq 'CategoryID' ? 'Category'
                        : $Param{SortBy} eq 'LanguageID' ? 'Language'
                        : $Param{SortBy} eq 'StateID'    ? 'State'
                        : $Param{SortBy} eq 'FAQID'      ? 'Number'
                        :                                  $Param{SortBy};
                }

                # set the correct Set CSS class and order by link
                if ( $Param{SortBy} && ( $Param{SortBy} eq $Column ) ) {
                    if ( $Param{OrderBy} && ( $Param{OrderBy} eq 'Up' ) ) {
                        $OrderBy = 'Down';
                        $CSS .= ' SortDescendingLarge';
                    }
                    else {
                        $OrderBy = 'Up';
                        $CSS .= ' SortAscendingLarge';
                    }
                }
                else {
                    $OrderBy = 'Up';
                }

                $Self->{LayoutObject}->Block(
                    Name => 'Record' . $Column . 'Header',
                    Data => {
                        %Param,
                        CSS     => $CSS,
                        OrderBy => $OrderBy,
                    },
                );
            }
        }

        my $Counter = 0;

        ID:
        for my $ID (@IDs) {
            $Counter++;
            if (
                $Counter >= $Param{StartHit}
                && $Counter < ( $Param{PageShown} + $Param{StartHit} )
                )
            {

                # to store all data
                my %Data;

                # get FAQ data
                my %FAQ = $Self->{FAQObject}->FAQGet(
                    ItemID     => $ID,
                    ItemFields => 0,
                    UserID     => $Self->{UserID},
                );

                next ID if !%FAQ;

                # add FAQ data
                %Data = ( %Data, %FAQ );

                # build record block
                $Self->{LayoutObject}->Block(
                    Name => 'Record',
                    Data => {
                        %Param,
                        %Data,
                    },
                );

                # build column record blocks
                if (@ShowColumns) {
                    COLUMN:
                    for my $Column (@ShowColumns) {

                        next COLUMN if ( $Column eq 'Language' && !$Self->{MultiLanguage} );
                        $Self->{LayoutObject}->Block(
                            Name => 'Record' . $Column,
                            Data => {
                                %Param,
                                %Data,
                            },
                        );

                        # do not display columns as links in the customer frontend
                        next COLUMN if $Param{Frontend} eq 'Customer';

                        # show links if available
                        $Self->{LayoutObject}->Block(
                            Name => 'Record' . $Column . 'LinkStart',
                            Data => {
                                %Param,
                                %Data,
                            },
                        );
                        $Self->{LayoutObject}->Block(
                            Name => 'Record' . $Column . 'LinkEnd',
                            Data => {
                                %Param,
                                %Data,
                            },
                        );
                    }
                }
            }
        }
    }
    else {
        $Self->{LayoutObject}->Block( Name => 'NoFAQFound' );
    }

    # use template
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentFAQOverviewSmall',
        Data         => {
            %Param,
            Type        => $Self->{ViewType},
            ColumnCount => scalar @ShowColumns,
        },
    );

    return $Output;
}

1;
