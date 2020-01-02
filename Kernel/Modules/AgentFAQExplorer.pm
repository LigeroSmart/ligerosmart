# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AgentFAQExplorer;

use strict;
use warnings;

use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # Permission check.
    if ( !$Self->{AccessRo} ) {
        return $LayoutObject->NoPermission(
            Message    => Translatable('You need ro permission!'),
            WithHeader => 'yes',
        );
    }

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # Get config of frontend module.
    my $Config = $ConfigObject->Get("FAQ::Frontend::$Self->{Action}");

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # Get config data.
    my $StartHit    = int( $ParamObject->GetParam( Param => 'StartHit' ) || 1 );
    my $SearchLimit = $Config->{SearchLimit} || 500;
    my $Filter      = $ParamObject->GetParam( Param => 'Filter' ) || '';
    my $View        = $ParamObject->GetParam( Param => 'View' ) || '';
    my $SortBy      = $ParamObject->GetParam( Param => 'SortBy' )
        || $Config->{'SortBy::Default'}
        || 'FAQID';
    my $OrderBy = $ParamObject->GetParam( Param => 'OrderBy' )
        || $Config->{'Order::Default'}
        || 'Down';

    # Get CategoryID.
    my $CategoryID = $ParamObject->GetParam( Param => 'CategoryID' ) || 0;

    # Check for non numeric CategoryID
    if ( $CategoryID !~ /\d+/ ) {
        $CategoryID = 0;
    }

    my $Category = $ParamObject->GetParam( Param => 'Category' ) || '';

    my $FAQObject = $Kernel::OM->Get('Kernel::System::FAQ');

    # Try to get the CategoryID from category name if no CategoryID
    if ( $Category && !$CategoryID ) {

        # Get the category tree.
        my $CategoryTree = $FAQObject->CategoryTreeList(
            UserID => $Self->{UserID},
        );

        # Reverse the hash for easy lookup.
        my %ReverseCategoryTree = reverse %{$CategoryTree};

        $CategoryID = $ReverseCategoryTree{$Category} || 0;
    }

    # Get navigation bar option.
    my $Nav = $ParamObject->GetParam( Param => 'Nav' ) || '';

    my $SessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');

    # Save CategoryID to session, to be used in FAQ add screen.
    $SessionObject->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastViewedCategory',
        Value     => $CategoryID,
    );

    # Store last overview screen (for back menu action) but only if the FAQ explorer is not shown as overlay.
    if ( !$Nav || $Nav ne 'None' ) {

        my $URL = "Action=AgentFAQExplorer;SortBy=$SortBy"
            . ";CategoryID=$CategoryID;Nav=$Nav"
            . ";OrderBy=$OrderBy;StartHit=$StartHit";
        $SessionObject->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'LastScreenOverview',
            Value     => $URL,
        );
        $SessionObject->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'LastScreenView',
            Value     => $URL,
        );
    }

    # Try to get the category data.
    my %CategoryData;
    if ($CategoryID) {

        %CategoryData = $FAQObject->CategoryGet(
            CategoryID => $CategoryID,
            UserID     => $Self->{UserID},
        );
        if ( !%CategoryData ) {
            return $LayoutObject->ErrorScreen(
                Message => $LayoutObject->{LanguageObject}->Translate( 'The CategoryID %s is invalid.', $CategoryID ),
                Comment => Translatable('Please contact the administrator.'),
            );
        }

        # Check user permission.
        my $Permission = $FAQObject->CheckCategoryUserPermission(
            UserID     => $Self->{UserID},
            CategoryID => $CategoryID,
            Type       => 'ro',
        );
        if ( !$Permission ) {
            return $LayoutObject->NoPermission(
                Message    => Translatable('You have no permission for this category!'),
                WithHeader => 'yes',
            );
        }
    }

    my $Output;
    if ( $Nav && $Nav eq 'None' ) {
        $Output = $LayoutObject->Header(
            Type => 'Small',
        );
    }
    else {
        $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
    }

    $LayoutObject->FAQPathShow(
        FAQObject  => $FAQObject,
        CategoryID => $CategoryID,
        UserID     => $Self->{UserID},
        Nav        => $Nav,
    );

    # Get all direct subcategories of the selected category.
    my $CategoryIDsRef = $FAQObject->AgentCategorySearch(
        ParentID => $CategoryID,
        UserID   => $Self->{UserID},
    );

    $LayoutObject->Block(
        Name => 'Subcategories',
        Data => {},
    );
    $LayoutObject->Block(
        Name => 'OverviewResult',
        Data => {},
    );

    # Set default interface settings.
    my $Interface = $FAQObject->StateTypeGet(
        Name   => 'internal',
        UserID => $Self->{UserID},
    );
    my $InterfaceStates = $FAQObject->StateTypeList(
        Types  => $ConfigObject->Get('FAQ::Agent::StateTypes'),
        UserID => $Self->{UserID},
    );

    # Get all items (valid and invalid) if SySConfig is set.
    my $ValidObject = $Kernel::OM->Get('Kernel::System::Valid');
    my @ValidIDs;
    my $Valid = 1;
    if ( $Config->{ShowInvalidFAQItems} ) {
        my %ValidList = $ValidObject->ValidList();
        @ValidIDs = keys %ValidList;
        $Valid    = 0;
    }
    else {
        @ValidIDs = ( $ValidObject->ValidLookup( Valid => 'valid' ) );
    }

    # Check if there are subcategories.
    if ( $CategoryIDsRef && ref $CategoryIDsRef eq 'ARRAY' && @{$CategoryIDsRef} ) {

        # Show data for each subcategory.
        for my $SubCategoryID ( @{$CategoryIDsRef} ) {

            my %SubCategoryData = $FAQObject->CategoryGet(
                CategoryID => $SubCategoryID,
                UserID     => $Self->{UserID},
            );

            # Get the number of subcategories of this subcategory.
            $SubCategoryData{SubCategoryCount} = $FAQObject->CategoryCount(
                ParentIDs => [$SubCategoryID],
                UserID    => $Self->{UserID},
            );

            # Get the number of FAQ articles in this category.
            $SubCategoryData{ArticleCount} = $FAQObject->FAQCount(
                CategoryIDs  => [$SubCategoryID],
                ItemStates   => $InterfaceStates,
                OnlyApproved => 0,
                Valid        => $Valid,
                UserID       => $Self->{UserID},
            );

            # Output the category data.
            $LayoutObject->Block(
                Name => 'OverviewResultRow',
                Data => {
                    Nav => $Nav,
                    %SubCategoryData,
                },
            );
        }
    }

    # Otherwise a no data found message is displayed.
    else {
        $LayoutObject->Block(
            Name => 'NoDataFoundMsg',
        );
    }

    # Search all FAQ items within the given category.
    my @ViewableItemIDs = $FAQObject->FAQSearch(
        OrderBy          => [$SortBy],
        OrderByDirection => [$OrderBy],
        Limit            => $SearchLimit,
        UserID           => $Self->{UserID},
        States           => $InterfaceStates,
        Interface        => $Interface,
        CategoryIDs      => [$CategoryID],
        ValidIDs         => \@ValidIDs,
    );

    # Build necessary stuff for the FAQ article list.
    my $LinkPage = 'Filter='
        . $LayoutObject->LinkEncode($Filter)
        . ';View=' . $LayoutObject->LinkEncode($View)
        . ';Nav=' . $Nav
        . ';SortBy=' . $LayoutObject->LinkEncode($SortBy)
        . ';OrderBy=' . $LayoutObject->LinkEncode($OrderBy)
        . ';CategoryID=' . $CategoryID
        . ';';
    my $LinkSort = 'Filter='
        . $LayoutObject->LinkEncode($Filter)
        . ';View=' . $LayoutObject->LinkEncode($View)
        . ';Nav=' . $Nav
        . ';CategoryID=' . $CategoryID
        . ';';
    my $FilterLink = 'SortBy=' . $LayoutObject->LinkEncode($SortBy)
        . ';OrderBy=' . $LayoutObject->LinkEncode($OrderBy)
        . ';View=' . $LayoutObject->LinkEncode($View)
        . ';Nav=' . $Nav
        . ';CategoryID=' . $CategoryID
        . ';';

    # Find out which columns should be shown.
    my @ShowColumns;
    if ( $Config->{ShowColumns} ) {

        # Get all possible columns from config.
        my %PossibleColumn = %{ $Config->{ShowColumns} };

        # Get the column names that should be shown.
        COLUMNNAME:
        for my $Name ( sort keys %PossibleColumn ) {
            next COLUMNNAME if !$PossibleColumn{$Name};
            push @ShowColumns, $Name;
        }

        # Enforce FAQ number column since is the link MasterAction hook.
        if ( !$PossibleColumn{'Number'} ) {
            push @ShowColumns, 'Number';
        }
    }

    # Build the title value (on top of the article list).
    my $Title = $CategoryData{Name}
        || $ConfigObject->Get('FAQ::Default::RootCategoryName')
        || '';

    # Build the HTML for the list of FAQ articles in the given category.
    my $FAQItemListHTML = $LayoutObject->FAQListShow(
        FAQIDs     => \@ViewableItemIDs,
        Total      => scalar @ViewableItemIDs,
        View       => $View,
        Env        => $Self,
        LinkPage   => $LinkPage,
        LinkSort   => $LinkSort,
        LinkFilter => $FilterLink,

        TitleName  => Translatable('FAQ Articles'),
        TitleValue => $Title,

        Limit        => $SearchLimit,
        Filter       => $Filter,
        FilterLink   => $FilterLink,
        OrderBy      => $OrderBy,
        SortBy       => $SortBy,
        ShowColumns  => \@ShowColumns,
        Output       => 1,
        Nav          => $Nav,
        FAQTitleSize => $Config->{TitleSize},
    );

    # Show the FAQ article list.
    $LayoutObject->Block(
        Name => 'FAQItemList',
        Data => {
            FAQItemListHTML => $FAQItemListHTML,
        },
    );

    # Set QuickSearch mode.
    my $Mode = 'Agent';
    if ( $Nav eq 'None' ) {
        $Mode = 'AgentSmall';
    }

    # Show QuickSearch.
    $LayoutObject->FAQShowQuickSearch(
        Mode            => $Mode,
        Interface       => $Interface,
        InterfaceStates => $InterfaceStates,
        UserID          => $Self->{UserID},
        Nav             => $Nav,
    );

    my %InfoBoxResults;

    # Show last added and last updated articles.
    for my $Type (qw(LastCreate LastChange)) {

        my $ShowOk = $LayoutObject->FAQShowLatestNewsBox(
            FAQObject       => $FAQObject,
            Type            => $Type,
            Mode            => 'Agent',
            CategoryID      => $CategoryID,
            Interface       => $Interface,
            InterfaceStates => $InterfaceStates,
            UserID          => $Self->{UserID},
            Nav             => $Nav,
        );
        if ( !$ShowOk ) {
            return $LayoutObject->ErrorScreen();
        }

        # Store the NewsBoxResult.
        $InfoBoxResults{$Type} = $ShowOk;
    }

    # Show top ten articles.
    my $ShowOk = $LayoutObject->FAQShowTop10(
        FAQObject       => $FAQObject,
        Mode            => 'Agent',
        CategoryID      => $CategoryID,
        Interface       => $Interface,
        InterfaceStates => $InterfaceStates,
        UserID          => $Self->{UserID},
        Nav             => $Nav,
    );
    if ( !$ShowOk ) {
        return $LayoutObject->ErrorScreen();
    }

    # Store the NewsBoxResult.
    $InfoBoxResults{Top10} = $ShowOk;

    # Set the Sidebar width.
    my $SidebarClass = 'Large';

    # Check if all InfoBoxes are empty and hide the Sidebar.
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

    $Output .= $LayoutObject->Output(
        TemplateFile => 'AgentFAQExplorer',
        Data         => {
            %Param,
            CategoryID   => $CategoryID,
            SidebarClass => $SidebarClass,
            %CategoryData,
        },
    );

    if ( $Nav && $Nav eq 'None' ) {
        $Output .= $LayoutObject->Footer(
            Type => 'Small',
        );
    }
    else {
        $Output .= $LayoutObject->Footer();
    }

    return $Output;
}

1;
