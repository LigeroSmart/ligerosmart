# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
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

        my $CategoryID = $FAQObject->CategoryAdd(
            Name     => 'Category' . $Helper->GetRandomID(),
            Comment  => 'Some comment',
            ParentID => 0,
            ValidID  => 1,
            UserID   => 1,
        );

        $Self->True(
            $CategoryID,
            "FAQ category is created - ID $CategoryID",
        );

        # Add test group.
        my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');
        my $GroupID     = $GroupObject->GroupAdd(
            Name    => 'group' . $Helper->GetRandomID(),
            Comment => 'Comment describing the group',
            ValidID => 1,
            UserID  => 1,
        );

        $FAQObject->SetCategoryGroup(
            CategoryID => $CategoryID,
            GroupIDs   => [$GroupID],
            UserID     => 1,
        );

        my @FAQSearch;

        # Create test FAQs.
        for my $Title (qw( FAQSearch FAQChangeSearch )) {
            for ( 1 .. 5 ) {
                my $FAQTitle = $Title . $Helper->GetRandomID();
                my $ItemID   = $FAQObject->FAQAdd(
                    Title       => $FAQTitle,
                    CategoryID  => $CategoryID,
                    StateID     => 1,
                    LanguageID  => 1,
                    ValidID     => 1,
                    UserID      => 1,
                    ContentType => 'text/html',
                );

                $Self->True(
                    $ItemID,
                    "FAQ item is created - ID $ItemID",
                );

                my %FAQ = (
                    ItemID   => $ItemID,
                    FAQTitle => $FAQTitle,
                    Type     => $Title,
                );

                push @FAQSearch, \%FAQ;
            }
        }

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

        # Navigate to AgentFAQSearch form.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentFAQSearch");

        # Wait until form has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => "return \$('#SearchProfile').length" );

        # Check ticket search page.
        for my $ID (
            qw(SearchProfile SearchProfileNew Attribute ResultForm SearchFormSubmit)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Add search filter by title and run it.
        $Selenium->execute_script("\$('#Attribute').val('Title').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "Title", 'name' )->send_keys('FAQ*');
        $Selenium->execute_script(
            "\$('#Attribute').val('CategoryIDs').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->execute_script(
            "\$('#CategoryIDs').val('$CategoryID').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->find_element( "#SearchFormSubmit", 'css' )->VerifiedClick();

        # Check AgentFAQSearch result screen.
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # Check test FAQs searched by 'FAQ*'.
        # There are no test FAQs, user doesn't have permission for test category.
        for my $FAQ (@FAQSearch) {

            # Check if there is no test FAQ on screen.
            $Self->True(
                index( $Selenium->get_page_source(), $FAQ->{FAQTitle} ) == -1,
                "$FAQ->{FAQTitle} - found",
            );
        }

        my $UserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
            Silent    => 1,
        );

        # Add user permission for test group.
        my $Success = $GroupObject->PermissionGroupUserAdd(
            GID        => $GroupID,
            UID        => $UserID,
            Permission => {
                ro        => 1,
                move_into => 0,
                create    => 0,
                owner     => 0,
                priority  => 0,
                rw        => 0,
            },
            UserID => 1,
        );

        $Self->True(
            $Success,
            "PermissionGroupUserAdd() is done.",
        );

        # Check 'Change search options' screen.
        $Selenium->find_element( "#FAQSearch", 'css' )->click();

        # Wait until form has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => "return \$('#SearchProfile').length" );

        $Selenium->find_element( "Title",             'name' )->clear();
        $Selenium->find_element( "Title",             'name' )->send_keys('FAQ*');
        $Selenium->find_element( "#SearchFormSubmit", 'css' )->VerifiedClick();

        for my $FAQ (@FAQSearch) {

            # Check if there is test FAQ on screen.
            $Self->True(
                index( $Selenium->get_page_source(), $FAQ->{FAQTitle} ) > -1,
                "$FAQ->{FAQTitle} - found",
            );
        }

        # Check 'Change search options' screen.
        $Selenium->find_element( "#FAQSearch", 'css' )->click();

        # Wait until form has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => "return \$('#SearchProfile').length" );

        $Selenium->find_element( "Title",             'name' )->clear();
        $Selenium->find_element( "Title",             'name' )->send_keys('FAQChangeSearch*');
        $Selenium->find_element( "#SearchFormSubmit", 'css' )->VerifiedClick();

        # Check test FAQs searched by 'FAQChangeSearch*'.
        # Delete test FAQs after checking.
        for my $FAQ (@FAQSearch) {

            if ( $FAQ->{Type} eq 'FAQChangeSearch' ) {

                # Check if there is test FAQChangeSearch* on screen.
                $Self->True(
                    index( $Selenium->get_page_source(), $FAQ->{FAQTitle} ) > -1,
                    "$FAQ->{FAQTitle} is found",
                );
            }
            else {

                # Check if there is no test FAQSearch* on screen.
                $Self->True(
                    index( $Selenium->get_page_source(), $FAQ->{FAQTitle} ) == -1,
                    "$FAQ->{FAQTitle} is not found",
                );
            }

            my $Success = $FAQObject->FAQDelete(
                ItemID => $FAQ->{ItemID},
                UserID => 1,
            );
            $Self->True(
                $Success,
                "FAQ is deleted - ID $FAQ->{ItemID}",
            );

        }

        # Check 'Change search options' button again.
        $Selenium->find_element( "#FAQSearch", 'css' )->click();

        # Wait until form has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => "return \$('#SearchProfile').length" );

        $Selenium->find_element( "Title",             'name' )->clear();
        $Selenium->find_element( "Title",             'name' )->send_keys('FAQChangeSearch*');
        $Selenium->find_element( "#SearchFormSubmit", 'css' )->VerifiedClick();

        # Check no data message.
        $Selenium->find_element( "#EmptyMessageSmall", 'css' );
        $Self->True(
            index( $Selenium->get_page_source(), 'No FAQ data found.' ) > -1,
            "No FAQ data found.",
        );

        # Delete test category.
        $Success = $FAQObject->CategoryDelete(
            CategoryID => $CategoryID,
            UserID     => 1,
        );

        $Self->True(
            $Success,
            "FAQ category is deleted - ID $CategoryID",
        );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => "FAQ" );
    }
);

1;
