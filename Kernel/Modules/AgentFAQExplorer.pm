# --
# Kernel/Modules/AgentFAQExplorer.pm - show the faq explorer
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: AgentFAQExplorer.pm,v 1.1 2010-11-26 18:12:47 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentFAQExplorer;

use strict;
use warnings;

use Kernel::System::FAQ;
use Kernel::System::User;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (
        qw(ParamObject DBObject LayoutObject LogObject ConfigObject UserObject GroupObject)
        )
    {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Object!" );
        }
    }

    # create additional objects
    $Self->{FAQObject} = Kernel::System::FAQ->new(%Param);

    # get config of frontend module
    $Self->{Config} = $Self->{ConfigObject}->Get("FAQ::Frontend::$Self->{Action}");

    # set default interface settings
    $Self->{Interface} = $Self->{FAQObject}->StateTypeGet(
        Name   => 'internal',
        UserID => $Self->{UserID},
    );
    $Self->{InterfaceStates} = $Self->{FAQObject}->StateTypeList(
        Types => [ 'internal', 'external', 'public' ],
        UserID => $Self->{UserID},
    );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # permission check
    if ( !$Self->{AccessRo} ) {
        return $Self->{LayoutObject}->NoPermission(
            Message    => 'You need ro permission!',
            WithHeader => 'yes',
        );
    }

    # get config data
    $Self->{StartHit} = int( $Self->{ParamObject}->GetParam( Param => 'StartHit' ) || 1 );
    $Self->{SearchLimit} = $Self->{Config}->{SearchLimit} || 500;
    $Self->{Filter} = $Self->{ParamObject}->GetParam( Param => 'Filter' ) || '';
    $Self->{View}   = $Self->{ParamObject}->GetParam( Param => 'View' )   || '';
    $Self->{SortBy} = $Self->{ParamObject}->GetParam( Param => 'SortBy' )
        || $Self->{Config}->{'SortBy::Default'}
        || 'FAQID';
    $Self->{OrderBy} = $Self->{ParamObject}->GetParam( Param => 'OrderBy' )
        || $Self->{Config}->{'Order::Default'}
        || 'Down';

    # get category id
    my $CategoryID = $Self->{ParamObject}->GetParam( Param => 'CategoryID' ) || 0;

    # save category id to session, to be used in FAQ add screen
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastViewedCategory',
        Value     => $CategoryID,
    );

    # try to get the category data
    my %CategoryData;
    if ($CategoryID) {

        # get category data
        %CategoryData = $Self->{FAQObject}->CategoryGet(
            CategoryID => $CategoryID,
            UserID     => $Self->{UserID},
        );
        if ( !%CategoryData ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        # check user permission
        my $Permission = $Self->{FAQObject}->CheckCategoryUserPermission(
            UserID     => $Self->{UserID},
            CategoryID => $CategoryID,
        );

        # show error message
        if ( !$Permission ) {
            return $Self->{LayoutObject}->NoPermission(
                Message    => 'You have no permission for this category!',
                WithHeader => 'yes',
            );
        }
    }

    # output header and navigation bar
    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # show FAQ path
    $Self->{LayoutObject}->FAQPathShow(
        FAQObject  => $Self->{FAQObject},
        CategoryID => $CategoryID,
        UserID     => $Self->{UserID},
    );

    # get all direct sub-categories of the selected category
    my $CategoryIDsRef = $Self->{FAQObject}->AgentCategorySearch(
        ParentID => $CategoryID,
        UserID   => $Self->{UserID},
    );

    # show sub-categories list
    $Self->{LayoutObject}->Block( Name => 'Subcategories' );
    $Self->{LayoutObject}->Block( Name => 'OverviewResult' );

    # check if there are sub-categories
    if ( $CategoryIDsRef && ref $CategoryIDsRef eq 'ARRAY' && @{$CategoryIDsRef} ) {

        # show data for each sub-category
        for my $SubCategoryID ( @{$CategoryIDsRef} ) {

            # get the category data
            my %SubCategoryData = $Self->{FAQObject}->CategoryGet(
                CategoryID => $SubCategoryID,
                UserID     => $Self->{UserID},
            );

            # get the number of sub-categories of this sub-category
            $SubCategoryData{SubCategoryCount} = $Self->{FAQObject}->CategoryCount(
                ParentIDs => [$SubCategoryID],
                UserID    => $Self->{UserID},
            );

            # get the number of faq articles in this category
            $SubCategoryData{ArticleCount} = $Self->{FAQObject}->FAQCount(
                CategoryIDs  => [$SubCategoryID],
                ItemStates   => $Self->{InterfaceStates},
                OnlyApproved => 0,
                UserID       => $Self->{UserID},
            );

            # output the category data
            $Self->{LayoutObject}->Block(
                Name => 'OverviewResultRow',
                Data => {%SubCategoryData},
            );
        }
    }

    # otherwise a no data found message is displayed
    else {
        $Self->{LayoutObject}->Block(
            Name => 'NoDataFoundMsg',
        );
    }

    # search all FAQ articles within the given category
    my @ViewableFAQIDs = $Self->{FAQObject}->FAQSearch(
        OrderBy          => [ $Self->{SortBy} ],
        OrderByDirection => [ $Self->{OrderBy} ],
        Limit            => $Self->{SearchLimit},
        UserID           => $Self->{UserID},
        States           => $Self->{InterfaceStates},
        Interface        => $Self->{Interface},
        CategoryIDs      => [$CategoryID],
    );

    # build neccessary stuff for the FAQ article list
    my $LinkPage = 'Filter='
        . $Self->{LayoutObject}->LinkEncode( $Self->{Filter} )
        . ';View=' . $Self->{LayoutObject}->LinkEncode( $Self->{View} )
        . ';SortBy=' . $Self->{LayoutObject}->LinkEncode( $Self->{SortBy} )
        . ';OrderBy=' . $Self->{LayoutObject}->LinkEncode( $Self->{OrderBy} )
        . ';CategoryID=' . $CategoryID
        . ';';
    my $LinkSort = 'Filter='
        . $Self->{LayoutObject}->LinkEncode( $Self->{Filter} )
        . ';View=' . $Self->{LayoutObject}->LinkEncode( $Self->{View} )
        . ';CategoryID=' . $CategoryID
        . ';';
    my $FilterLink
        = 'SortBy=' . $Self->{LayoutObject}->LinkEncode( $Self->{SortBy} )
        . ';OrderBy=' . $Self->{LayoutObject}->LinkEncode( $Self->{OrderBy} )
        . ';View=' . $Self->{LayoutObject}->LinkEncode( $Self->{View} )
        . ';CategoryID=' . $CategoryID
        . ';';

    # find out which columns should be shown
    my @ShowColumns;
    if ( $Self->{Config}->{ShowColumns} ) {

        # get all possible columns from config
        my %PossibleColumn = %{ $Self->{Config}->{ShowColumns} };

        # get the column names that should be shown
        COLUMNNAME:
        for my $Name ( keys %PossibleColumn ) {
            next COLUMNNAME if !$PossibleColumn{$Name};
            push @ShowColumns, $Name;
        }
    }

    # build the title value (on top of the article list)
    my $Title
        = $CategoryData{Name}
        || $Self->{ConfigObject}->Get('FAQ::Default::RootCategoryName')
        || '';

    # build the html for the list of FAQ articles in the given category
    my $FAQItemListHTML = $Self->{LayoutObject}->FAQListShow(
        FAQIDs     => \@ViewableFAQIDs,
        Total      => scalar @ViewableFAQIDs,
        View       => $Self->{View},
        Env        => $Self,
        LinkPage   => $LinkPage,
        LinkSort   => $LinkSort,
        LinkFilter => $FilterLink,

        TitleName  => 'Articles',
        TitleValue => $Title,

        Limit       => $Self->{SearchLimit},
        Filter      => $Self->{Filter},
        FilterLink  => $FilterLink,
        OrderBy     => $Self->{OrderBy},
        SortBy      => $Self->{SortBy},
        ShowColumns => \@ShowColumns,
        Output      => 1,
    );

    # show the FAQ article list
    $Self->{LayoutObject}->Block(
        Name => 'FAQItemList',
        Data => {
            FAQItemListHTML => $FAQItemListHTML,
        },
    );

    # show last added articles
    $Self->_ShowFAQInfoBox(
        CategoryID => $CategoryID,
        Type       => 'LastCreate',
    );

    # show last updated articles
    $Self->_ShowFAQInfoBox(
        CategoryID => $CategoryID,
        Type       => 'LastChange',
    );

    # TODO
    # show top ten articles

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentFAQExplorer',
        Data         => {
            %Param,
            CategoryID => $CategoryID,
            %CategoryData,
        },
    );

    # add footer
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

sub _ShowFAQInfoBox {
    my ( $Self, %Param ) = @_;

    if ( !$Param{Type} ) {
        $Self->{LayoutObject}->ErrorScreen(
            Message => 'No Type is given!',
            Comment => 'Please contact the admin.',
        );
        return;
    }

    # check needed stuff
    if ( !defined $Param{CategoryID} ) {
        $Self->{LayoutObject}->ErrorScreen(
            Message => 'No CategoryID is given!',
            Comment => 'Please contact the admin.',
        );
        return;
    }

    # check needed stuff
    if ( $Param{Type} !~ m{ LastCreate | LastChange }xms ) {
        $Self->{LayoutObject}->ErrorScreen(
            Message => 'Type must be either LastCreate or LastChange!',
            Comment => 'Please contact the admin.',
        );
        return;
    }

    # set order by search parameter and header based on type
    my $OrderBy;
    my $Header;
    if ( $Param{Type} eq 'LastCreate' ) {
        $OrderBy = 'Created';
        $Header  = 'Last added FAQ articles';
    }
    elsif ( $Param{Type} eq 'LastChange' ) {
        $OrderBy = 'Changed';
        $Header  = 'Last updated FAQ articles';
    }

    # show last added articles
    my $Show = $Self->{ConfigObject}->Get("FAQ::Explorer::$Param{Type}::Show");
    if ( $Show->{ $Self->{Interface}->{Name} } ) {

        # to store search param for categories
        my %CategorySearchParam;

        # if subcategories should also be shown
        if ( $Self->{ConfigObject}->Get("FAQ::Explorer::$Param{Type}::ShowSubCategoryItems") ) {

            # find the subcategories of this category
            my $SubCategoryIDsRef = $Self->{FAQObject}->CategorySubCategoryIDList(
                ParentID => $Param{CategoryID},
                Mode     => 'Agent',
                UserID   => $Self->{UserID},
            );

            # search in the given category and add the sub-category
            $CategorySearchParam{CategoryIDs} = [ $Param{CategoryID}, @{$SubCategoryIDsRef} ];
        }

        # a category is given and subcategories should not be shown
        elsif ( $Param{CategoryID} ) {

            # search only in the given category
            $CategorySearchParam{CategoryIDs} = [ $Param{CategoryID} ];
        }

        # search the FAQ articles
        my @ItemIDs = $Self->{FAQObject}->FAQSearch(
            States           => $Self->{InterfaceStates},
            OrderBy          => [$OrderBy],
            OrderByDirection => ['Down'],
            Interface        => $Self->{Interface},
            Limit  => $Self->{ConfigObject}->Get("FAQ::Explorer::$Param{Type}::Limit") || 5,
            UserID => $Self->{UserID},
            %CategorySearchParam,
        );

        # there is something to show
        if (@ItemIDs) {

            # show the info box
            $Self->{LayoutObject}->Block(
                Name => 'InfoBoxFAQMiniList',
                Data => {
                    Header => $Header,
                },
            );

            for my $ItemID (@ItemIDs) {

                # get FAQ data
                my %FAQData = $Self->{FAQObject}->FAQGet(
                    ItemID => $ItemID,
                    UserID => $Self->{UserID},
                );

                # show the article row
                $Self->{LayoutObject}->Block(
                    Name => 'InfoBoxFAQMiniListItemRow',
                    Data => {%FAQData},
                );
            }
        }
    }

    return 1;
}

1;
