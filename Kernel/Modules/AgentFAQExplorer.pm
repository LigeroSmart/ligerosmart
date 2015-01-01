# --
# Kernel/Modules/AgentFAQExplorer.pm - show the FAQ explorer
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentFAQExplorer;

use strict;
use warnings;

use Kernel::System::FAQ;

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
        Types  => $Self->{ConfigObject}->Get('FAQ::Agent::StateTypes'),
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

    # check for non numeric CategoryID
    if ( $CategoryID !~ /\d+/ ) {
        $CategoryID = 0;
    }

    # get category by name
    my $Category = $Self->{ParamObject}->GetParam( Param => 'Category' ) || '';

    # try to get the Category ID from category name if no Category ID
    if ( $Category && !$CategoryID ) {

        # get the category tree
        my $CategoryTree = $Self->{FAQObject}->CategoryTreeList(
            UserID => $Self->{UserID},
        );

        # reverse the has for easy lookup
        my %ReverseCategoryTree = reverse %{$CategoryTree};

        $CategoryID = $ReverseCategoryTree{$Category} || 0;
    }

    # get navigation bar option
    my $Nav = $Self->{ParamObject}->GetParam( Param => 'Nav' ) || '';

    # save category id to session, to be used in FAQ add screen
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastViewedCategory',
        Value     => $CategoryID,
    );

    # store last overview screen (for back menu action)
    # but only if the FAQ explorer is not shown as overlay
    if ( !$Nav || $Nav ne 'None' ) {

        my $URL = "Action=AgentFAQExplorer;SortBy=$Self->{SortBy}"
            . ";CategoryID=$CategoryID;Nav=$Nav"
            . ";OrderBy=$Self->{OrderBy};StartHit=$Self->{StartHit}";
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'LastScreenOverview',
            Value     => $URL,
        );
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'LastScreenView',
            Value     => $URL,
        );
    }

    # try to get the category data
    my %CategoryData;
    if ($CategoryID) {

        # get category data
        %CategoryData = $Self->{FAQObject}->CategoryGet(
            CategoryID => $CategoryID,
            UserID     => $Self->{UserID},
        );
        if ( !%CategoryData ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "The CategoryID $CategoryID is invalid.",
                Comment => 'Please contact the admin.',
            );
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

    my $Output;
    if ( $Nav && $Nav eq 'None' ) {

        # output header small and no Navbar
        $Output = $Self->{LayoutObject}->Header( Type => 'Small' );
    }
    else {

        # output header and navigation bar
        $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
    }

    # show FAQ path
    $Self->{LayoutObject}->FAQPathShow(
        FAQObject  => $Self->{FAQObject},
        CategoryID => $CategoryID,
        UserID     => $Self->{UserID},
        Nav        => $Nav,
    );

    # get all direct subcategories of the selected category
    my $CategoryIDsRef = $Self->{FAQObject}->AgentCategorySearch(
        ParentID => $CategoryID,
        UserID   => $Self->{UserID},
    );

    # show subcategories list
    $Self->{LayoutObject}->Block( Name => 'Subcategories' );
    $Self->{LayoutObject}->Block( Name => 'OverviewResult' );

    # check if there are subcategories
    if ( $CategoryIDsRef && ref $CategoryIDsRef eq 'ARRAY' && @{$CategoryIDsRef} ) {

        # show data for each subcategory
        for my $SubCategoryID ( @{$CategoryIDsRef} ) {

            # get the category data
            my %SubCategoryData = $Self->{FAQObject}->CategoryGet(
                CategoryID => $SubCategoryID,
                UserID     => $Self->{UserID},
            );

            # get the number of subcategories of this subcategory
            $SubCategoryData{SubCategoryCount} = $Self->{FAQObject}->CategoryCount(
                ParentIDs => [$SubCategoryID],
                UserID    => $Self->{UserID},
            );

            # get the number of FAQ articles in this category
            $SubCategoryData{ArticleCount} = $Self->{FAQObject}->FAQCount(
                CategoryIDs  => [$SubCategoryID],
                ItemStates   => $Self->{InterfaceStates},
                OnlyApproved => 0,
                UserID       => $Self->{UserID},
            );

            # output the category data
            $Self->{LayoutObject}->Block(
                Name => 'OverviewResultRow',
                Data => {
                    Nav => $Nav,
                    %SubCategoryData,
                },
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

    # build necessary stuff for the FAQ article list
    my $LinkPage = 'Filter='
        . $Self->{LayoutObject}->LinkEncode( $Self->{Filter} )
        . ';View=' . $Self->{LayoutObject}->LinkEncode( $Self->{View} )
        . ';Nav=' . $Nav
        . ';SortBy=' . $Self->{LayoutObject}->LinkEncode( $Self->{SortBy} )
        . ';OrderBy=' . $Self->{LayoutObject}->LinkEncode( $Self->{OrderBy} )
        . ';CategoryID=' . $CategoryID
        . ';';
    my $LinkSort = 'Filter='
        . $Self->{LayoutObject}->LinkEncode( $Self->{Filter} )
        . ';View=' . $Self->{LayoutObject}->LinkEncode( $Self->{View} )
        . ';Nav=' . $Nav
        . ';CategoryID=' . $CategoryID
        . ';';
    my $FilterLink = 'SortBy=' . $Self->{LayoutObject}->LinkEncode( $Self->{SortBy} )
        . ';OrderBy=' . $Self->{LayoutObject}->LinkEncode( $Self->{OrderBy} )
        . ';View=' . $Self->{LayoutObject}->LinkEncode( $Self->{View} )
        . ';Nav=' . $Nav
        . ';CategoryID=' . $CategoryID
        . ';';

    # find out which columns should be shown
    my @ShowColumns;
    if ( $Self->{Config}->{ShowColumns} ) {

        # get all possible columns from config
        my %PossibleColumn = %{ $Self->{Config}->{ShowColumns} };

        # get the column names that should be shown
        COLUMNNAME:
        for my $Name ( sort keys %PossibleColumn ) {
            next COLUMNNAME if !$PossibleColumn{$Name};
            push @ShowColumns, $Name;
        }

        # enforce FAQ number column since is the link MasterAction hook
        if ( !$PossibleColumn{'Number'} ) {
            push @ShowColumns, 'Number';
        }
    }

    # build the title value (on top of the article list)
    my $Title = $CategoryData{Name}
        || $Self->{ConfigObject}->Get('FAQ::Default::RootCategoryName')
        || '';

    # build the HTML for the list of FAQ articles in the given category
    my $FAQItemListHTML = $Self->{LayoutObject}->FAQListShow(
        FAQIDs     => \@ViewableFAQIDs,
        Total      => scalar @ViewableFAQIDs,
        View       => $Self->{View},
        Env        => $Self,
        LinkPage   => $LinkPage,
        LinkSort   => $LinkSort,
        LinkFilter => $FilterLink,

        TitleName  => 'FAQ Articles',
        TitleValue => $Title,

        Limit        => $Self->{SearchLimit},
        Filter       => $Self->{Filter},
        FilterLink   => $FilterLink,
        OrderBy      => $Self->{OrderBy},
        SortBy       => $Self->{SortBy},
        ShowColumns  => \@ShowColumns,
        Output       => 1,
        Nav          => $Nav,
        FAQTitleSize => $Self->{Config}->{TitleSize},
    );

    # show the FAQ article list
    $Self->{LayoutObject}->Block(
        Name => 'FAQItemList',
        Data => {
            FAQItemListHTML => $FAQItemListHTML,
        },
    );

    # set QuickSearch mode
    my $Mode = 'Agent';
    if ( $Nav eq 'None' ) {
        $Mode = 'AgentSmall';
    }

    # show QuickSearch
    $Self->{LayoutObject}->FAQShowQuickSearch(
        Mode            => $Mode,
        Interface       => $Self->{Interface},
        InterfaceStates => $Self->{InterfaceStates},
        UserID          => $Self->{UserID},
        Nav             => $Nav,
    );

    my %InfoBoxResults;

    # show last added and last updated articles
    for my $Type (qw(LastCreate LastChange)) {

        my $ShowOk = $Self->{LayoutObject}->FAQShowLatestNewsBox(
            FAQObject       => $Self->{FAQObject},
            Type            => $Type,
            Mode            => 'Agent',
            CategoryID      => $CategoryID,
            Interface       => $Self->{Interface},
            InterfaceStates => $Self->{InterfaceStates},
            UserID          => $Self->{UserID},
            Nav             => $Nav,
        );

        # check error
        if ( !$ShowOk ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        # store the NewsBoxResult
        $InfoBoxResults{$Type} = $ShowOk;

    }

    # show top ten articles
    my $ShowOk = $Self->{LayoutObject}->FAQShowTop10(
        FAQObject       => $Self->{FAQObject},
        Mode            => 'Agent',
        CategoryID      => $CategoryID,
        Interface       => $Self->{Interface},
        InterfaceStates => $Self->{InterfaceStates},
        UserID          => $Self->{UserID},
        Nav             => $Nav,
    );

    # check error
    if ( !$ShowOk ) {
        return $Self->{LayoutObject}->ErrorScreen();
    }

    # store the NewsBoxResult
    $InfoBoxResults{Top10} = $ShowOk;

    # set the Sidebar width
    my $SidebarClass = 'Large';

    # check if all InfoBoxes are empty and hide the Sidebar
    if (
        $InfoBoxResults{LastCreate} eq -1
        && $InfoBoxResults{LastChange} eq -1
        && $InfoBoxResults{Top10} eq -1
        )
    {
        $SidebarClass = 'Hidden';
    }

    if ( $Nav && $Nav eq 'None' ) {
        $SidebarClass = 'Medium';
    }

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentFAQExplorer',
        Data         => {
            %Param,
            CategoryID   => $CategoryID,
            SidebarClass => $SidebarClass,
            %CategoryData,
        },
    );

    # add footer
    if ( $Nav && $Nav eq 'None' ) {
        $Output .= $Self->{LayoutObject}->Footer( Type => 'Small' );
    }
    else {
        $Output .= $Self->{LayoutObject}->Footer();
    }

    return $Output;
}

1;
