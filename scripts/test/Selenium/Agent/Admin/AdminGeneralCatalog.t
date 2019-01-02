# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Create and log in test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AdminGeneralCatalog screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminGeneralCatalog");

        # Click "Add Catalog Class".
        $Selenium->find_element("//button[\@value='Add'][\@type='submit']")->VerifiedClick();

        # Check for input fields.
        for my $ID (
            qw(ClassDsc Name ValidID Comment)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Check client side validation.
        $Selenium->find_element( "#Name",   'css' )->clear();
        $Selenium->find_element( "#Submit", 'css' )->click();
        $Selenium->WaitFor( JavaScript => 'return $("#Name.Error").length' );

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#Name').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # Create real test catalog class.
        my $CatalogClassDsc  = "CatalogClassDsc" . $Helper->GetRandomID();
        my $CatalogClassName = "CatalogClassName" . $Helper->GetRandomID();
        $Selenium->find_element( "#ClassDsc", 'css' )->send_keys($CatalogClassDsc);
        $Selenium->find_element( "#Name",     'css' )->send_keys($CatalogClassName);
        $Selenium->find_element( "#Comment",  'css' )->send_keys("Selenium catalog class");
        $Selenium->execute_script("\$('#ValidID').val('1').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( '#Submit', 'css' )->VerifiedClick();

        # Click "Go to overview".
        $Selenium->find_element("//a[contains(\@href, \'Action=AdminGeneralCatalog' )]")->VerifiedClick();

        # Check for created test catalog class in AdminGeneralCatalog screen and click on it.
        $Self->True(
            index( $Selenium->get_page_source(), $CatalogClassDsc ) > -1,
            "Created test catalog class $CatalogClassDsc - found",
        );
        $Selenium->find_element(
            "//a[contains(\@href, \'Action=AdminGeneralCatalog;Subaction=ItemList;Class=$CatalogClassDsc' )]"
        )->VerifiedClick();

        # Click "Add Catalog Item".
        $Selenium->find_element("//button[\@value='Add'][\@type='submit']")->VerifiedClick();

        # Check client side validation.
        $Selenium->find_element( "#Name",   'css' )->clear();
        $Selenium->find_element( "#Submit", 'css' )->click();
        $Selenium->WaitFor( JavaScript => 'return $("#Name.Error").length' );

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#Name').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # Try to create catalog item that already exists.
        $Selenium->find_element( "#Name", 'css' )->send_keys($CatalogClassName);
        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->VerifiedClick();

        # Verify error message.
        $Self->True(
            index( $Selenium->get_page_source(), 'Need ItemID OR Class and Name!' ) > -1,
            "Error message - displayed",
        );

        # Return back to test catalog class screen and click on "Add Catalog Item".
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AdminGeneralCatalog;Subaction=ItemList;Class=$CatalogClassDsc"
        );
        $Selenium->find_element("//button[\@value='Add'][\@type='submit']")->VerifiedClick();

        # Create real test catalog item.
        my $CatalogClassItem = "CatalogClassItem" . $Helper->GetRandomID();
        $Selenium->find_element( "#Name",    'css' )->send_keys($CatalogClassItem);
        $Selenium->find_element( "#Comment", 'css' )->send_keys("Selenium catalog item");
        $Selenium->execute_script("\$('#ValidID').val('1').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->VerifiedClick();

        # Get test catalog items IDs.
        my @CatalogItemIDs;
        for my $CatalogItems ( $CatalogClassName, $CatalogClassItem ) {
            my $CatalogClassItemData = $Kernel::OM->Get('Kernel::System::GeneralCatalog')->ItemGet(
                Class => $CatalogClassDsc,
                Name  => $CatalogItems,
            );
            my $CatalogItemID = $CatalogClassItemData->{ItemID};
            push @CatalogItemIDs, $CatalogItemID;
        }

        # Check for created test catalog item and click on it.
        $Self->True(
            index( $Selenium->get_page_source(), $CatalogClassItem ) > -1,
            "Created test catalog item $CatalogClassItem - found",
        );
        $Selenium->find_element(
            "//a[contains(\@href, \'Action=AdminGeneralCatalog;Subaction=ItemEdit;ItemID=$CatalogItemIDs[1]' )]"
        )->VerifiedClick();

        # Check new test catalog item values.
        $Self->Is(
            $Selenium->find_element( '#Name', 'css' )->get_value(),
            $CatalogClassItem,
            "#Name stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#Comment', 'css' )->get_value(),
            "Selenium catalog item",
            "#Comment stored value",
        );

        # Edit name and comment.
        my $EditCatalogClassItem = "Edit" . $CatalogClassItem;
        $Selenium->find_element( "#Name",    'css' )->clear();
        $Selenium->find_element( "#Name",    'css' )->send_keys($EditCatalogClassItem);
        $Selenium->find_element( "#Comment", 'css' )->send_keys(" edit");
        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->VerifiedClick();

        # Check edited test catalog item values.
        $Selenium->find_element( $EditCatalogClassItem, 'link_text' )->VerifiedClick();
        $Self->Is(
            $Selenium->find_element( '#Name', 'css' )->get_value(),
            $EditCatalogClassItem,
            "#Name updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#Comment', 'css' )->get_value(),
            "Selenium catalog item edit",
            "#Comment updated value",
        );

        # Click on 'cancel' and verify correct link.
        $Selenium->find_element( "Cancel", 'link_text' )->VerifiedClick();
        $Self->True(
            $Selenium->find_element( $EditCatalogClassItem, 'link_text' ),
            "Cancel link is correct."
        );

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # Delete created test catalog class.
        for my $CatalogItem (@CatalogItemIDs) {

            my $Success = $DBObject->Do(
                SQL => "DELETE FROM general_catalog_preferences WHERE general_catalog_id = $CatalogItem",
            );
            $Self->True(
                $Success,
                "CatalogItemID $CatalogItem preference - deleted",
            );

            $Success = $DBObject->Do(
                SQL => "DELETE FROM general_catalog WHERE id = $CatalogItem",
            );
            $Self->True(
                $Success,
                "CatalogItemID $CatalogItem - deleted",
            );
        }

        # Clean up cache.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'GeneralCatalog' );
    }
);

1;
