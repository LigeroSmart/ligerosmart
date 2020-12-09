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

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper    = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $FAQObject = $Kernel::OM->Get('Kernel::System::FAQ');

        # Disable check of email addresses.
        $Helper->ConfigSettingChange(
            Key   => 'CustomerGroupSupport',
            Value => 1,
        );

        # Create test FAQ category.
        my $CategoryID = $FAQObject->CategoryAdd(
            Name     => 'Category ' . $Helper->GetRandomID(),
            Comment  => 'Selenium Category',
            ParentID => 0,
            ValidID  => 1,
            UserID   => 1,
        );
        $Self->True(
            $CategoryID,
            "FAQ category is created - $CategoryID",
        );

        # Add test group.
        my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');
        my $GroupID     = $GroupObject->GroupAdd(
            Name    => 'group' . $Helper->GetRandomID(),
            Comment => 'Comment describing the group',
            ValidID => 1,
            UserID  => 1,
        );

        # Set test FAQ category permission.
        $FAQObject->SetCategoryGroup(
            CategoryID => $CategoryID,
            GroupIDs   => [$GroupID],
            UserID     => 1,
        );

        # Create test FAQs.
        my @FAQSearch;
        for my $Title (qw( FAQSearch FAQChangeSearch )) {
            for my $Item ( 1 .. 5 ) {

                # Add test FAQ.
                my $FAQTitle = $Title . $Helper->GetRandomID();
                my $ItemID   = $FAQObject->FAQAdd(
                    Title       => $FAQTitle,
                    CategoryID  => $CategoryID,
                    StateID     => 1,
                    LanguageID  => 1,
                    ValidID     => 1,
                    UserID      => 1,
                    Approved    => 1,
                    ContentType => 'text/html',
                );

                $Self->True(
                    $ItemID,
                    "FAQ is created - $ItemID",
                );

                my %FAQ = (
                    ItemID   => $ItemID,
                    FAQTitle => $FAQTitle,
                    Type     => $Title,
                );

                push @FAQSearch, \%FAQ;
            }

        }

        # Create and login test customer.
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate() || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Customer',
            User     => $TestCustomerUserLogin,
            Password => $TestCustomerUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to CustomerFAQSearch form.
        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerFAQSearch");

        # Check ticket search page.
        for my $ID (
            qw(Profile Number FullText Title Keyword LanguageIDs CategoryIDs NoVoteSet VotePoint
            VoteSearchType NoRateSet RatePoint RateSearchType RateSearch NoTimeSet Date DateRange
            ItemCreateTimePointStart ItemCreateTimePoint ItemCreateTimePointFormat ItemCreateTimeStartMonth
            ItemCreateTimeStartDay ItemCreateTimeStartYear ItemCreateTimeStopMonth ItemCreateTimeStopDay
            ItemCreateTimeStopYear SaveProfile Profil Submit ResultForm)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Search FAQ by title and run it.
        $Selenium->find_element( "#Title",  'css' )->send_keys('FAQ*');
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        # Check CustomerFAQSearch result screen.
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # Check test FAQs searched by 'FAQ*''
        # There are no test FAQs, user doesn't have permission for test category.
        for my $FAQ (@FAQSearch) {

            # check if there is not test FAQ on screen
            $Self->True(
                index( $Selenium->get_page_source(), $FAQ->{FAQTitle} ) == -1,
                "$FAQ->{FAQTitle} is found",
            );
        }

        # Add user permission for test group.
        my $Success = $Kernel::OM->Get('Kernel::System::CustomerGroup')->GroupMemberAdd(
            GID        => $GroupID,
            UID        => $TestCustomerUserLogin,
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
            "GroupMemberAdd() is done.",
        );

        # Check 'Change search options' button again.
        $Selenium->find_element("//a[contains(\@href, \'Action=CustomerFAQSearch;Subaction=LoadProfile' )]")
            ->VerifiedClick();
        $Selenium->find_element( "#Title",  'css' )->clear();
        $Selenium->find_element( "#Title",  'css' )->send_keys('FAQ*');
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        for my $FAQ (@FAQSearch) {

            # Check if there is test FAQ on screen.
            $Self->True(
                index( $Selenium->get_page_source(), $FAQ->{FAQTitle} ) > -1,
                "$FAQ->{FAQTitle} is found",
            );
        }

        # Check 'Change search options' screen.
        $Selenium->find_element("//a[contains(\@href, \'Action=CustomerFAQSearch;Subaction=LoadProfile' )]")
            ->VerifiedClick();

        $Selenium->find_element( "#Title", 'css' )->clear();
        $Selenium->find_element( "#Title", 'css' )->send_keys('FAQChangeSearch*');
        $Selenium->execute_script(
            "\$('#CategoryIDs').val('$CategoryID').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        # Check test FAQs searched by 'FAQChangeSearch*'.
        # Delete test FAQs after checking.
        for my $FAQ (@FAQSearch) {

            if ( $FAQ->{Type} eq 'FAQChangeSearch' ) {

                # Check if there is test FAQChangeSearch* on screen.
                $Self->True(
                    index( $Selenium->get_page_source(), $FAQ->{FAQTitle} ) > -1,
                    "$FAQ->{FAQTitle} - found",
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
        $Selenium->find_element("//a[contains(\@href, \'Action=CustomerFAQSearch;Subaction=LoadProfile' )]")
            ->VerifiedClick();

        $Selenium->find_element( "#Title",  'css' )->clear();
        $Selenium->find_element( "#Title",  'css' )->send_keys( $Helper->GetRandomID() );
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        # Check no data message.
        $Selenium->find_element( "#EmptyMessage", 'css' );
        $Self->True(
            index( $Selenium->get_page_source(), 'No FAQ data found.' ) > -1,
            "No FAQ data found.",
        );

        # Delete test created FAQ category.
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
