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

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AgentFAQCategory.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentFAQCategory");

        # Check AgentFAQCategory screen.
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # Click on 'Add category'.
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentFAQCategory;Subaction=Add' )]")->VerifiedClick();

        # Check page.
        for my $ID (
            qw(Name ParentID PermissionGroups ValidID Comment)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Create test category.
        my $CategoryName = 'Category ' . $Helper->GetRandomID();
        $Selenium->find_element( "#Name", 'css' )->send_keys($CategoryName);
        $Selenium->execute_script(
            "\$('#PermissionGroups').val(\$('#PermissionGroups option').filter(function () { return \$(this).html() == 'users'; } ).val() ).trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->execute_script("\$('#ValidID').val('1').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Comment", 'css' )->send_keys('Selenium Category');
        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->VerifiedClick();

        # Verify test category is created.
        $Self->True(
            index( $Selenium->get_page_source(), $CategoryName ) > -1,
            "$CategoryName is found",
        );

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # Get test created category ID.
        my $Category = $DBObject->Quote($CategoryName);
        $DBObject->Prepare(
            SQL  => "SELECT id FROM faq_category WHERE name = ?",
            Bind => [ \$CategoryName ]
        );
        my $CategoryID;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $CategoryID = $Row[0];
        }

        # Click on delete icon.
        $Selenium->find_element( "#DeleteCategoryID$CategoryID", 'css' )->click();
        $Selenium->WaitFor( JavaScript => 'return $("#DialogButton1").length' );

        $Selenium->find_element( "#DialogButton1", 'css' )->click();
        $Selenium->WaitFor( JavaScript => "return !\$('.Dialog.Modal').length" );

        # Verify test created category is deleted.
        $Self->True(
            index( $Selenium->get_page_source(), $CategoryName ) == -1,
            "$CategoryName is not found",
        );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => "FAQ" );
    }
);

1;
