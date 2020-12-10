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

        # Set link object view mode to simple.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'LinkObject::ViewMode',
            Value => 'Simple',
        );

        # Set FAQ::TitleSize.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'FAQ::TitleSize',
            Value => '50',
        );

        # Create test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        # Get test user ID.
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # Create test FAQ items.
        my @ItemIDs;
        my @FAQNumbers;
        for my $FAQ ( 1 .. 2 ) {
            my $ItemID = $FAQObject->FAQAdd(
                Title       => 'Some Text',
                CategoryID  => 1,
                StateID     => 1,
                LanguageID  => 1,
                Keywords    => 'some keywords',
                Field1      => 'Symptom...',
                Field2      => 'Problem...',
                Field3      => 'Solution...',
                Field4      => 'Field4...',
                Field5      => 'Field5...',
                Field6      => 'Comment...',
                Approved    => 1,
                ValidID     => 1,
                ContentType => 'text/plain',
                UserID      => $TestUserID,
            );
            push @ItemIDs, $ItemID;

            my %FAQ = $FAQObject->FAQGet(
                ItemID => $ItemID,
                UserID => 1,
            );

            my $FAQNumber = $FAQ{Number};

            $Self->True(
                $ItemID,
                "Created Ticket ID $ItemID - FAQ Number $FAQNumber",
            );

            push @FAQNumbers, $FAQNumber;
        }

        # Login as test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to link object screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentLinkObject;SourceObject=FAQ;SourceKey=$ItemIDs[0]");

        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#SubmitSearch").length;' );

        # Search for second created test faq.
        $Selenium->find_element(".//*[\@id='SEARCH::Number']")->send_keys( $FAQNumbers[1] );

        $Selenium->execute_script("\$('#SubmitSearch').click();");

        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('#WidgetFAQ').length && \$('input[value=$ItemIDs[1]][type=checkbox]').length;"
        );

        $Selenium->WaitForjQueryEventBound(
            CSSSelector => "#AddLinks",
        );

        # Link created test FAQ items.
        $Selenium->find_element("//input[\@value='$ItemIDs[1]'][\@type='checkbox']")->click();
        $Selenium->WaitFor(
            JavaScript => "return \$('input[value=$ItemIDs[1]][type=checkbox]:checked').length;"
        );

        $Selenium->execute_script(
            "\$('#TypeIdentifier').val('ParentChild::Target').trigger('redraw.InputField').trigger('change');"
        );

        $Selenium->WaitFor( JavaScript => 'return $("#TypeIdentifier").val() === "ParentChild::Target";' );

        $Selenium->find_element( "#AddLinks", 'css' )->VerifiedClick();

        # Navigate to zoom view of created test FAQ item.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentFAQZoom;ItemID=$ItemIDs[0]");

        # Verify that parent test FAQ is linked with child test FAQ.
        $Self->True(
            index( $Selenium->get_page_source(), 'Child' ) > -1,
            "Child - found",
        );
        $Self->True(
            index( $Selenium->get_page_source(), "F:" . $FAQNumbers[1] ) > -1,
            "TicketNumber $FAQNumbers[1] - found",
        );

        # Click on child FAQ.
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentFAQZoom;ItemID=$ItemIDs[1]' )]")->VerifiedClick();

        # Verify that child test FAQ is linked with parent test FAQ.
        $Self->True(
            index( $Selenium->get_page_source(), 'Parent' ) > -1,
            "Parent - found",
        );
        $Self->True(
            index( $Selenium->get_page_source(), "F:" . $FAQNumbers[0] ) > -1,
            "FAQNumber $FAQNumbers[0] - found",
        );

        # Test FAQ title length in complex view for linked FAQs.
        # Set link object view mode to complex.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'LinkObject::ViewMode',
            Value => 'Complex',
        );

        # Update test FAQ title to more then 50 characters (there is 65).
        my $LongFAQTitle = 'This is long test myitem title with more then 50 characters in it';

        # FAQ::TitleSize is set to 50 at the beginning of test.
        my $ShortTitle = substr( $LongFAQTitle, 0, 47 ) . "...";

        my %FAQ = $FAQObject->FAQGet(
            ItemID     => $ItemIDs[1],
            ItemFields => 1,
            UserID     => 1,
        );
        my $Success = $FAQObject->FAQUpdate(
            %FAQ,
            Title  => $LongFAQTitle,
            UserID => 1,
        );
        $Self->True(
            $Success,
            "Updated FAQ title - $ItemIDs[1]"
        );

        # Navigate to AgentFAQZoom screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentFAQZoom;ItemID=$ItemIDs[0]");

        # Check for updated FAQ title in linked FAQ items complex view table.
        $Self->True(
            index( $Selenium->get_page_source(), $LongFAQTitle ) > -1,
            "$LongFAQTitle - found in AgentFAQZoom complex view mode",
        );

        # Collapse all FAQ fields to show link table in the screen.
        $Selenium->execute_script(
            "\$('#FAQBody .Expanded a').click();"
        );

        # Check for "default" visible columns in the Linked FAQ widget.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#WidgetFAQ .DataTable thead tr th:nth-child(1)').text();"
            ),
            ' FAQ# ',
            'Default 1st column name',
        );
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#WidgetFAQ .DataTable thead tr th:nth-child(2)').text();"
            ),
            ' Title ',
            'Default 2nd column name',
        );
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#WidgetFAQ .DataTable thead tr th:nth-child(3)').text();"
            ),
            ' State ',
            'Default 3th column name',
        );
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#WidgetFAQ .DataTable thead tr th:nth-child(4)').text();"
            ),
            ' Created ',
            'Default 4th column name',
        );

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#WidgetFAQ .DataTable thead tr th:nth-child(5)').text();"
            ),
            ' Linked as ',
            'Default 5th column name',
        );

        # Show ActionMenu - usually this is done when user hovers, however it's not possible to simulate this behavior.
        $Selenium->execute_script(
            "\$('#WidgetFAQ .ActionMenu').show();"
        );

        # Check if column settings button is available in the Linked FAQ widget.
        $Selenium->find_element( 'a#linkobject-FAQ-toggle', 'css' )->click();

        # Wait for the complete widget to be fully slided in all the way down to the submit button.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#linkobject-FAQ_submit:visible").length;'
        );

        sleep 1;

        # TODO: remove limitation to firefox.
        if ( $Selenium->{browser_name} eq 'firefox' ) {
            $Self->True(
                1,
                "TODO: DragAndDrop is currently disabled in Firefox",
            );
        }
        else {

            # Remove Approved from left side, and put it to the right side.
            $Selenium->DragAndDrop(
                Element      => '#WidgetFAQ #AvailableField-linkobject-FAQ li[data-fieldname="Approved"]',
                Target       => '#AssignedFields-linkobject-FAQ',
                TargetOffset => {
                    X => 185,
                    Y => 10,
                },
            );

            # Remove State from right side, and put it to the left side.
            $Selenium->DragAndDrop(
                Element      => '#WidgetFAQ #AssignedFields-linkobject-FAQ li[data-fieldname="State"]',
                Target       => '#AvailableField-linkobject-FAQ',
                TargetOffset => {
                    X => 185,
                    Y => 10,
                },
            );

            # Save new columns.
            $Selenium->find_element( '#linkobject-FAQ_submit', 'css' )->click();

            # Wait for AJAX.
            $Selenium->WaitFor(
                JavaScript =>
                    'return typeof($) === "function" && $("#WidgetFAQ .DataTable:visible").length;'
            );

            # Check for "updated" visible columns in the Linked FAQ widget.
            $Self->Is(
                $Selenium->execute_script(
                    "return \$('#WidgetFAQ .DataTable thead tr th:eq(0)').text().trim();"
                ),
                'FAQ#',
                'Updated 1st column name',
            );
            $Self->Is(
                $Selenium->execute_script(
                    "return \$('#WidgetFAQ .DataTable thead tr th:eq(1)').text().trim();"
                ),
                'Approved',
                'Updated 2nd column name',
            );
            $Self->Is(
                $Selenium->execute_script(
                    "return \$('#WidgetFAQ .DataTable thead tr th:eq(2)').text().trim();"
                ),
                'Title',
                'Updated 3rd column name',
            );
            $Self->Is(
                $Selenium->execute_script(
                    "return \$('#WidgetFAQ .DataTable thead tr th:eq(3)').text().trim();"
                ),
                'Created',
                'Updated 4th column name',
            );

            $Self->Is(
                $Selenium->execute_script(
                    "return \$('#WidgetFAQ .DataTable thead tr th:eq(4)').text().trim();"
                ),
                'State',
                'Updated 5th column name',
            );
        }

        # Navigate to link object screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentLinkObject;SourceObject=FAQ;SourceKey=$ItemIDs[0]");

        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("div[data-id=ManageLinks]").length;'
        );
        $Selenium->WaitForjQueryEventBound(
            CSSSelector => "a[href='#ManageLinks']",
        );

        # Click on 'go to link delete screen'.
        $Selenium->find_element("//a[contains(\@href, \'#ManageLinks' )]")->click();
        $Selenium->WaitFor(
            JavaScript =>
                "return \$('div[data-id=ManageLinks].Active').length && \$('#FAQ .DataTable tr span:contains(\"$ShortTitle\")').length;"
        );

        # Check for long FAQ title in LinkDelete screen.
        # This one is displayed on hover.
        $Self->True(
            $Selenium->execute_script("return \$('#FAQ .DataTable tr span[title=\"$LongFAQTitle\"]').length;"),
            "\"title=$LongFAQTitle\" - found in LinkDelete screen - which is displayed on hover",
        );

        # Check for short ticket title in LinkDelete screen.
        $Self->True(
            $Selenium->execute_script("return \$('#FAQ .DataTable tr span:contains(\"$ShortTitle\")').length;"),
            "$ShortTitle - found in LinkDelete screen",
        );

        $Selenium->WaitForjQueryEventBound(
            CSSSelector => "#SelectAllLinks0",
        );

        $Selenium->find_element( "#SelectAllLinks0", 'css' )->click();
        $Selenium->WaitFor( JavaScript => 'return $("#FAQ .DataTable input[type=checkbox]:checked").length;' );

        $Selenium->find_element("//button[\@title='Delete links']")->VerifiedClick();

        # Delete created test tickets.
        for my $ItemID (@ItemIDs) {
            $Success = $FAQObject->FAQDelete(
                ItemID => $ItemID,
                UserID => 1,
            );
            $Self->True(
                $Success,
                "Delete FAQ Item - $ItemID"
            );
        }
    }
);

1;
