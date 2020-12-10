# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper    = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $FAQObject = $Kernel::OM->Get('Kernel::System::FAQ');

        $Helper->ConfigSettingChange(
            Key   => 'FAQ::Frontend::CustomerFAQExplorer###SearchPageShown',
            Value => '40',
            Valid => 1,
        );

        $Helper->ConfigSettingChange(
            Key   => 'FAQ::Frontend::CustomerFAQExplorer###SearchLimit',
            Value => '200',
            Valid => 1,
        );

        my $RandomID = $Helper->GetRandomID();

        # Create FAQ category.
        my $CategoryName = "CategoryA$RandomID";
        my $CategoryID   = $FAQObject->CategoryAdd(
            Name     => $CategoryName,
            Comment  => 'Some comment',
            ParentID => 0,
            ValidID  => 1,
            UserID   => 1,
        );
        $Self->True(
            $CategoryID,
            "CategoryID $CategoryID is created",
        );

        # Setup group for category.
        my $GroupID = $Kernel::OM->Get('Kernel::System::Group')->GroupLookup(
            Group => 'users',
        );
        $FAQObject->SetCategoryGroup(
            CategoryID => $CategoryID,
            GroupIDs   => [$GroupID],
            UserID     => 1,
        );

        # Get 'external (customer)' state ID.
        my %States = $FAQObject->StateList(
            UserID => 1,
        );
        %States = reverse %States;

        my $StateID = $States{'external (customer)'};

        # Create test FAQs.
        my @Items;
        for my $Count ( 1 .. 5 ) {
            my $FAQTitle = "FAQ$Count-$RandomID";
            my $ItemID   = $FAQObject->FAQAdd(
                Title       => $FAQTitle,
                CategoryID  => $CategoryID,
                StateID     => $StateID,
                LanguageID  => 1,
                ValidID     => 1,
                UserID      => 1,
                Approved    => 1,
                ContentType => 'text/html',
            );

            $Self->True(
                $ItemID,
                "FAQID $ItemID is created $FAQTitle",
            );

            push @Items, {
                ItemID   => $ItemID,
                FAQTitle => $FAQTitle,
                Page     => ( $Count < 4 ) ? 1 : 2,
            };
        }

        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate() || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Customer',
            User     => $TestCustomerUserLogin,
            Password => $TestCustomerUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to CustomerFAQExplorer screen of created test FAQ.
        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerFAQExplorer");

        # Check CustomerFAQExplorer screen.
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # Test data for explorer screen.
        my @Tests = (
            {
                ScreenData => 'FAQ Explorer',
            },
            {
                ScreenData => 'Latest created FAQ articles',
            },
            {
                ScreenData => 'Latest updated FAQ articles',
            },
        );

        for my $Test (@Tests) {
            $Self->True(
                index( $Selenium->get_page_source(), $Test->{ScreenData} ) > -1,
                "$Test->{ScreenData} is found",
            );
        }

        # Click on test created category, go to subcategory screen.
        $Selenium->find_element( "$CategoryName", 'link_text' )->VerifiedClick();

        # Order FAQ item per FAQID by Down.
        $Selenium->VerifiedGet(
            "${ScriptAlias}customer.pl?Action=CustomerFAQExplorer;CategoryID=$CategoryID;SortBy=Title;Order=Up"
        );

        # Check test created FAQs.
        my $Index = 0;
        for my $Test (@Items) {
            $Self->Is(
                $Selenium->execute_script(
                    "return \$('h3:contains(\"FAQ Articles\")').closest('.WidgetSimple').find('tbody tr:eq($Index) td:eq(1)').text().trim();"
                ),
                $Test->{FAQTitle},
                "FAQ Article '$Test->{FAQTitle}' is found"
            );
            $Index++;
        }

        # Check if CustomerFAQExplorer show pagination if configured SearchLimit is reached (see bug#13885).
        $Helper->ConfigSettingChange(
            Key   => 'FAQ::Frontend::CustomerFAQExplorer###SearchPageShown',
            Value => '3',
            Valid => 1,
        );

        $Helper->ConfigSettingChange(
            Key   => 'FAQ::Frontend::CustomerFAQExplorer###SearchLimit',
            Value => '5',
            Valid => 1,
        );

        $Selenium->VerifiedGet(
            "${ScriptAlias}customer.pl?Action=CustomerFAQExplorer;CategoryID=$CategoryID;SortBy=Title;Order=Up"
        );

        # Check items in the first page.
        for my $Item (@Items) {
            my $IsFound = ( $Item->{Page} == 1 ) ? 'is found' : 'is not found';
            my $Length  = ( $Item->{Page} == 1 ) ? 1          : 0;

            $Self->Is(
                $Selenium->execute_script(
                    "return \$('h3:contains(\"FAQ Articles\")').closest('.WidgetSimple').find('td a[href*=\"Action=CustomerFAQZoom;ItemID=$Item->{ItemID}\"]').length;"
                ),
                $Length,
                "Page 1 - FAQ Article '$Item->{FAQTitle}' $IsFound"
            );
        }

        # Go to second result page.
        $Selenium->find_element( "#CustomerFAQExplorerPage2", 'css' )->VerifiedClick();

        # Check items in the second page.
        for my $Item (@Items) {
            my $IsFound = ( $Item->{Page} == 2 ) ? 'is found' : 'is not found';
            my $Length  = ( $Item->{Page} == 2 ) ? 1          : 0;

            $Self->Is(
                $Selenium->execute_script(
                    "return \$('h3:contains(\"FAQ Articles\")').closest('.WidgetSimple').find('td a[href*=\"Action=CustomerFAQZoom;ItemID=$Item->{ItemID}\"]').length;"
                ),
                $Length,
                "Page 2 - FAQ Article '$Item->{FAQTitle}' $IsFound"
            );
        }

        # FAQ subcategories are shown on CustomerFAQExplorer. See bug#14053.
        # Create Subcategory.
        my $SubCategoryName = "Sub$CategoryName";
        my $SubCategoryID   = $FAQObject->CategoryAdd(
            Name     => $SubCategoryName,
            Comment  => 'Subcategory',
            ParentID => $CategoryID,
            ValidID  => 1,
            UserID   => 1,
        );
        $Self->True(
            $SubCategoryID,
            "SubCategoryID $SubCategoryID is created",
        );

        # Setup group for Subcategory.
        $GroupID = $Kernel::OM->Get('Kernel::System::Group')->GroupLookup(
            Group => 'users',
        );
        $FAQObject->SetCategoryGroup(
            CategoryID => $SubCategoryID,
            GroupIDs   => [$GroupID],
            UserID     => 1,
        );

        # Create Subcategory FAQ.
        my $SubFAQTitle = "SubFAQ-$RandomID";
        my $SubItemID   = $FAQObject->FAQAdd(
            Title       => $SubFAQTitle,
            CategoryID  => $SubCategoryID,
            StateID     => $StateID,
            LanguageID  => 1,
            ValidID     => 1,
            UserID      => 1,
            Approved    => 1,
            ContentType => 'text/html',
        );

        $Self->True(
            $SubItemID,
            "Subcategory itemID $SubItemID is created",
        );

        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerFAQExplorer");

        # Check if Subcategory is shown.
        $Self->True(
            $Selenium->execute_script(
                "return \$(\"a[href*='Action=CustomerFAQExplorer;CategoryID=$SubCategoryID']\").length == 0"
            ),
            "SubCategoryID $SubCategoryID in not found."
        );

        $Selenium->find_element( "$CategoryName", 'link_text' )->VerifiedClick();

        # Check if Subcategory is present.
        $Self->Is(
            $Selenium->execute_script(
                "return \$(\"a[href*='Action=CustomerFAQExplorer;CategoryID=$SubCategoryID']\").text().trim()"
            ),
            "$SubCategoryName",
            "Subcategory $SubCategoryName is found."
        );

        # Delete FAQ category.
        for my $CategoryIDs ( $CategoryID, $SubCategoryID )
        {
            my $Success = $FAQObject->CategoryDelete(
                CategoryID => $CategoryIDs,
                UserID     => 1,
            );
            $Self->True(
                $Success,
                "CategoryID $CategoryIDs is deleted",
            );
        }

        # Delete FAQs.
        push @Items,
            {
            ItemID => $SubItemID,
            };
        for my $FAQ (@Items) {
            my $Success = $FAQObject->FAQDelete(
                ItemID => $FAQ->{ItemID},
                UserID => 1,
            );
            $Self->True(
                $Success,
                "FAQID $FAQ->{ItemID} is deleted",
            );
        }

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => "FAQ" );
    }
);

1;
