# --
# Kernel/Output/HTML/FAQOverviewSmall.pm.pm
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: FAQOverviewSmall.pm,v 1.4 2010-11-03 22:44:51 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::FAQOverviewSmall;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.4 $) [1];

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

    my $FAQData = scalar @IDs;
    if ($FAQData){

        # check ShowColumns parameter
        if ( $Param{ShowColumns} && ref $Param{ShowColumns} eq 'ARRAY' ) {
            @ShowColumns = @{ $Param{ShowColumns} };
        }

        # build column header blocks
        if (@ShowColumns) {
            for my $Column (@ShowColumns) {

                # create needed veriables
                my $CSS = '';
                my $OrderBy;

                # remove ID if necesary
                if ( $Param{SortBy} ) {
                    $Param{SortBy} = ( $Param{SortBy} eq 'PriorityID' )
                        ? 'Priority'
                        : ( $Param{SortBy} eq 'CategoryID' ) ? 'Category'
                        : ( $Param{SortBy} eq 'LanguageID' ) ? 'Language'
                        : ( $Param{SortBy} eq 'StateID' )    ? 'State'
                        :                                    $Param{SortBy};
                }

                # set the correct Set CSS class and order by link
                if ( $Param{SortBy} && ( $Param{SortBy} eq $Column ) ) {
                    if ( $Param{OrderBy} && ( $Param{OrderBy} eq 'Up' ) ) {
                        $OrderBy = 'Down';
                        $CSS .= ' SortDescending';
                    }
                    else {
                        $OrderBy = 'Up';
                        $CSS .= ' SortAscending';
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

        my $Counter  = 0;
        my $CssClass = '';
        ID:
        for my $ID (@IDs) {
            $Counter++;
            if ( $Counter >= $Param{StartHit} && $Counter < ( $Param{PageShown} + $Param{StartHit} ) ) {

                # to store all data
                my %Data;

                # get FAQ data
                my %FAQ = $Self->{FAQObject}->FAQGet(
                    FAQID   => $ID,
                    UserID => $Self->{UserID},
                );

                next ID if !%FAQ;

                # add FAQ data
                %Data = ( %Data, %FAQ );

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
                    COLUMN:
                    for my $Column (@ShowColumns) {
                        $Self->{LayoutObject}->Block(
                            Name => 'Record' . $Column,
                            Data => {
                                %Param,
                                %Data,
                                CssClass => $CssClass,
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
                                CssClass => $CssClass,
                            },
                        );
                        $Self->{LayoutObject}->Block(
                            Name => 'Record' . $Column . 'LinkEnd',
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
