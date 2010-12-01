# --
# Kernel/Modules/CustomerFAQExplorer.pm - customer FAQ explorer
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: CustomerFAQExplorer.pm,v 1.2 2010-12-01 10:14:17 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::CustomerFAQExplorer;

use strict;
use warnings;

use Kernel::System::FAQ;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (
        qw(ParamObject DBObject LayoutObject LogObject ConfigObject)
        )
    {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Object!" );
        }
    }

    # create needed objects
    $Self->{FAQObject} = Kernel::System::FAQ->new(%Param);

    # get config of frontend module
    $Self->{Config} = $Self->{ConfigObject}->Get("FAQ::Frontend::$Self->{Action}");

    # set default interface settings
    $Self->{Interface} = $Self->{FAQObject}->StateTypeGet(
        Name   => 'external',
        UserID => $Self->{UserID},
    );
    $Self->{InterfaceStates} = $Self->{FAQObject}->StateTypeList(
        Types => [ 'external', 'public' ],
        UserID => $Self->{UserID},
    );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get config data
    $Self->{StartHit} = int( $Self->{ParamObject}->GetParam( Param => 'StartHit' ) || 1 );
    $Self->{SearchLimit}     = $Self->{Config}->{SearchLimit}     || 200;
    $Self->{SearchPageShown} = $Self->{Config}->{SearchPageShown} || 3;

    # get category id
    my $CategoryID = $Self->{ParamObject}->GetParam( Param => 'CategoryID' ) || 0;

    # try to get the category data
    my %CategoryData;
    if ($CategoryID) {

        # get category data
        %CategoryData = $Self->{FAQObject}->CategoryGet(
            CategoryID => $CategoryID,
            UserID     => $Self->{UserID},
        );
        if ( !%CategoryData ) {
            return $Self->{LayoutObject}->CustomerNoPermission( WithHeader => 'yes' );
        }

        # check user permission
        my $Permission = $Self->{FAQObject}->CheckCategoryCustomerPermission(
            CustomerUser => $Self->{UserLogin},
            CategoryID   => $CategoryID,
            UserID       => $Self->{UserID},
        );

        # permission check
        if ( !$Permission ) {
            return $Self->{LayoutObject}->CustomerNoPermission( WithHeader => 'yes' );
        }
    }

    # store the last screen overview in session
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenOverview',
        Value     => $Self->{RequestedURL},
    );

    # output header
    my $Output = $Self->{LayoutObject}->CustomerHeader(
        Value => '',
    );
    $Output .= $Self->{LayoutObject}->CustomerNavigationBar();

    # show FAQ path
    $Self->{LayoutObject}->FAQPathShow(
        FAQObject  => $Self->{FAQObject},
        CategoryID => $CategoryID,
        UserID     => $Self->{UserID},
    );

    # get all direct subcategories of the selected category
    my $CategoryIDsRef = $Self->{FAQObject}->CustomerCategorySearch(
        ParentID     => $CategoryID,
        CustomerUser => $Self->{UserLogin},
        Mode         => 'Customer',
        UserID       => $Self->{UserID},
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

            # get the number of faq articles in this category
            $SubCategoryData{ArticleCount} = $Self->{FAQObject}->FAQCount(
                CategoryIDs  => [$SubCategoryID],
                ItemStates   => $Self->{InterfaceStates},
                OnlyApproved => 1,
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
        OrderBy          => ['FAQID'],
        OrderByDirection => ['Down'],
        Limit            => $Self->{SearchLimit},
        UserID           => $Self->{UserID},
        States           => $Self->{InterfaceStates},
        Interface        => $Self->{Interface},
        CategoryIDs      => [$CategoryID],
    );

    # show the FAQ article list
    $Self->{LayoutObject}->Block(
        Name => 'FAQItemList',
        Data => {},
    );

    my $Counter = 0;
    for my $FAQID (@ViewableFAQIDs) {

        $Counter++;

        # build search result
        if (
            $Counter >= $Self->{StartHit}
            && $Counter < ( $Self->{SearchPageShown} + $Self->{StartHit} )
            )
        {

            # get FAQ data details
            my %FAQData = $Self->{FAQObject}->FAQGet(
                FAQID  => $FAQID,
                UserID => $Self->{UserID},
            );

            # add blocks to template
            $Self->{LayoutObject}->Block(
                Name => 'Record',
                Data => {
                    %FAQData,
                },
            );
        }
    }

    # build search navigation bar
    my %PageNav = $Self->{LayoutObject}->PageNavBar(
        Limit     => $Self->{SearchLimit},
        StartHit  => $Self->{StartHit},
        PageShown => $Self->{SearchPageShown},
        AllHits   => $Counter,
        Action    => "Action=CustomerFAQExplorer;CategoryID=$CategoryID",
        Link      => '',
        IDPrefix  => "CustomerFAQExplorer",
    );

    # show footer filter - show only if more the one page is available
    if ( defined $PageNav{TotalHits} && ( $PageNav{TotalHits} > $Self->{SearchPageShown} ) ) {
        $Self->{LayoutObject}->Block(
            Name => 'Pagination',
            Data => {
                %Param,
                %PageNav,
            },
        );
    }

    # show last added and last updated articles
    for my $Type (qw(LastCreate LastChange)) {

        my $ShowOk = $Self->{LayoutObject}->FAQShowLatestNewsBox(
            FAQObject       => $Self->{FAQObject},
            Type            => $Type,
            Mode            => 'Customer',
            CustomerUser    => $Self->{UserLogin},
            CategoryID      => $CategoryID,
            Interface       => $Self->{Interface},
            InterfaceStates => $Self->{InterfaceStates},
            UserID          => $Self->{UserID},
        );

        # check error
        if ( !$ShowOk ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }

    # show top ten articles
    my $ShowOk = $Self->{LayoutObject}->FAQShowTop10(
        FAQObject       => $Self->{FAQObject},
        Mode            => 'Customer',
        CustomerUser    => $Self->{UserLogin},
        CategoryID      => $CategoryID,
        Interface       => $Self->{Interface},
        InterfaceStates => $Self->{InterfaceStates},
        UserID          => $Self->{UserID},
    );

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'CustomerFAQExplorer',
        Data         => {
            %Param,
            CategoryID => $CategoryID,
            %CategoryData,
        },
    );

    # add footer
    $Output .= $Self->{LayoutObject}->CustomerFooter();

    return $Output;
}

1;
