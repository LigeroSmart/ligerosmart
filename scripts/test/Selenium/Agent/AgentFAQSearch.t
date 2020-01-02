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

        my $Helper      = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $FAQObject   = $Kernel::OM->Get('Kernel::System::FAQ');
        my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

        my $RandomID = $Helper->GetRandomID();

        # Create test group.
        my $GroupName = "group-$RandomID";
        my $GroupID   = $GroupObject->GroupAdd(
            Name    => $GroupName,
            ValidID => 1,
            UserID  => 1,
        );
        $Self->True(
            $GroupID,
            "GroupID $GroupID - created",
        );

        # Modify AgentFAQAdd module registration configuration to allow only test created group as RW.
        # Test bug#14068 CreateBy selection honor group configuration.
        my %AgentFAQAddModuleConfig = $Kernel::OM->Get('Kernel::System::SysConfig')->SettingGet(
            Name    => 'Frontend::Module###AgentFAQAdd',
            Default => 1,
        );

        my %AgentFAQAddModuleConfigUpdate = %{ $AgentFAQAddModuleConfig{EffectiveValue} };
        $AgentFAQAddModuleConfigUpdate{Group} = [$GroupName];

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::Module###AgentFAQAdd',
            Value => \%AgentFAQAddModuleConfigUpdate,
        );

        my $CategoryID = $FAQObject->CategoryAdd(
            Name     => 'Category' . $RandomID,
            Comment  => 'Some comment',
            ParentID => 0,
            ValidID  => 1,
            UserID   => 1,
        );

        $Self->True(
            $CategoryID,
            "FAQ category is created - ID $CategoryID",
        );

        $FAQObject->SetCategoryGroup(
            CategoryID => $CategoryID,
            GroupIDs   => [$GroupID],
            UserID     => 1,
        );

        # Create DynamicField.
        my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
        my $DFTextName         = 'Text' . $RandomID;

        my $DynamicFieldID = $DynamicFieldObject->DynamicFieldAdd(
            Name       => $DFTextName,
            Label      => $DFTextName,
            FieldOrder => 9990,
            FieldType  => 'Text',
            ObjectType => 'FAQ',
            Config     => {
                DefaultValue => '',
            },
            Reorder => 0,
            ValidID => 1,
            UserID  => 1,
        );
        $Self->True(
            $DynamicFieldID,
            "DynamicFieldID $DynamicFieldID is created."
        );

        # Get test created DynamicField
        my $TextTypeDynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
            Name => $DFTextName,
        );
        my $BackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

        # Enable test created DynamicField on AgentFAQSearch overview screen.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'FAQ::Frontend::OverviewSmall###DynamicField',
            Value => {
                $DFTextName => 1,
            },
        );

        # Create test user.
        my $TestUser = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUser,
        );

        # Create test user which is in group defined in the module configuration as RW in AgentFAQAdd.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users', $GroupName ],
        ) || die "Did not get test user";

        my $TestUserLoginID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        my @FAQSearch;

        # Create test FAQs.
        my $Count = 0;
        for my $Title (qw( FAQSearch FAQChangeSearch )) {
            for ( 1 .. 5 ) {
                my $FAQTitle = $Title . $Helper->GetRandomID();
                my $ItemID   = $FAQObject->FAQAdd(
                    Title       => $FAQTitle,
                    CategoryID  => $CategoryID,
                    StateID     => 1,
                    LanguageID  => 1,
                    ValidID     => 1,
                    UserID      => $TestUserLoginID,
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

                # Set DynamicField value.
                my $DFValue = $Count . 'DFValue';
                my $Success = $BackendObject->ValueSet(
                    DynamicFieldConfig => $TextTypeDynamicFieldConfig,
                    ObjectID           => $ItemID,
                    Value              => $DFValue,
                    UserID             => 1,
                );
                $Self->True(
                    $Success,
                    "Value '$DFValue' is set successfully for FAQID $ItemID",
                );
                $Count++;
            }
        }

        # Login test user.
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

        # Add CreatedBy and verify bug#14068.
        $Selenium->execute_script(
            "\$('#Attribute').val('CreatedUserIDs').trigger('redraw.InputField').trigger('change');"
        );

        $Self->Is(
            $Selenium->execute_script("return \$('#CreatedUserIDs option[value=$TestUserLoginID]').length;"),
            1,
            "$TestUserLoginID which is in group $GroupName is found as possible selection"
        );
        $Self->Is(
            $Selenium->execute_script("return \$('#CreatedUserIDs option[value=$TestUserID]').length;"),
            0,
            "$TestUser which is in not group $GroupName is not found as possible selection"
        );

        $Selenium->find_element( "#SearchFormSubmit", 'css' )->VerifiedClick();

        # Check AgentFAQSearch result screen.
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # Check test FAQs searched by 'FAQ*'.
        # All FAQs will be in a search result.
        $Count = 9;
        for my $FAQ (@FAQSearch) {

            # Check if there is test FAQ on screen.
            $Self->True(
                index( $Selenium->get_page_source(), $FAQ->{FAQTitle} ) > -1,
                "$FAQ->{FAQTitle} - found",
            );

            # Verify sorting and ordering of FAQs.
            $Self->True(
                $Selenium->execute_script(
                    "return \$('tbody tr:eq(\"$Count\") td > a[href*=\"ItemID=$FAQ->{ItemID}\"]').length;"
                ),
                "$FAQ->{FAQTitle} is in correct order - SortBy = FAQID, OrderBy = Down."
            );
            $Count--;
        }

        # Click to sort and order by DynamicField values.
        # See bug#12780 (https://bugs.otrs.org/show_bug.cgi?id=12780).
        $Selenium->find_element("//a[contains(\@href, \'SortBy=DynamicField_$DFTextName' )]")->VerifiedClick();

        $Count = 0;
        for my $FAQ (@FAQSearch) {

            # Verify sorting and ordering of FAQs.
            $Self->True(
                $Selenium->execute_script(
                    "return \$('tbody tr:eq(\"$Count\") td > a[href*=\"ItemID=$FAQ->{ItemID}\"]').length;"
                ),
                "$FAQ->{FAQTitle} is in correct order - SortBy = DynamicField, OrderBy = Up."
            );
            $Count++;
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
        my $Success = $FAQObject->CategoryDelete(
            CategoryID => $CategoryID,
            UserID     => 1,
        );

        $Self->True(
            $Success,
            "FAQ category is deleted - ID $CategoryID",
        );

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # Delete group-user relation.
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM group_user WHERE group_id = ?",
            Bind => [ \$GroupID ],
        );
        $Self->True(
            $Success,
            "Group-user relation for group ID $GroupID is deleted",
        );

        # Delete test group.
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM groups WHERE id = ?",
            Bind => [ \$GroupID ],
        );
        $Self->True(
            $Success,
            "GroupID $GroupID is deleted",
        );

        # Delete DynamicField.
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM dynamic_field_value WHERE field_id = ?",
            Bind => [ \$DynamicFieldID ],
        );
        $Success = $DynamicFieldObject->DynamicFieldDelete(
            ID     => $DynamicFieldID,
            UserID => 1,
        );
        $Self->True(
            $Success,
            "DynamicFieldID $DynamicFieldID is deleted.",
        );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => "FAQ" );
    }
);

1;
