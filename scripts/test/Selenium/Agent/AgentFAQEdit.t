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

        # Do not check RichText.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0,
        );

        # Get test params.
        my $FAQTitle = 'FAQ ' . $Helper->GetRandomID();
        my %Test     = (
            Stored => {
                Title       => $FAQTitle,
                CategoryID  => 1,
                StateID     => 1,
                LanguageID  => 1,
                Keywords    => 'Selenium Keywords',
                Field1      => 'Selenium Symptom',
                Field2      => 'Selenium Problem',
                Field3      => 'Selenium Solution',
                Field6      => 'Selenium Comment',
                ContentType => 'text/html',
                ValidID     => 1,
            },
            Edited => {
                Title       => $FAQTitle . ' Edit',
                CategoryID  => 1,
                StateID     => 2,
                LanguageID  => 2,
                Keywords    => 'Selenium Keywords Edit',
                Field1      => 'Selenium Symptom Edit',
                Field2      => 'Selenium Problem Edit',
                Field3      => 'Selenium Solution Edit',
                Field6      => 'Selenium Comment Edit',
                ContentType => 'text/html',
                ValidID     => 2,
            },
        );

        # Create test FAQ.
        my @ItemIDs;
        my $ItemID = $FAQObject->FAQAdd(
            %{ $Test{Stored} },
            UserID => 1,
        );

        $Self->True(
            $ItemID,
            "FAQ is created - ID $ItemID",
        );

        push @ItemIDs, $ItemID;

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

        # Navigate to AgentFAQZoom of created test FAQ.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentFAQZoom;ItemID=$ItemID;Nav=");

        # Verify its right screen.
        $Self->True(
            index( $Selenium->get_page_source(), $FAQTitle ) > -1,
            "$FAQTitle is found",
        );

        # Navigate to AgentFAQEdit screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentFAQEdit;ItemID=$ItemID");

        # Verify stored values.
        for my $Stored ( sort keys %{ $Test{Stored} } ) {
            if ( $Stored ne 'ContentType' ) {
                $Self->Is(
                    $Selenium->find_element( '#' . $Stored, 'css' )->get_value(),
                    "$Test{Stored}->{$Stored}",
                    "#$Stored stored value",
                );
            }
        }

        # Edit test FAQ.
        $Selenium->find_element( "#Title", 'css' )->send_keys(' Edit');
        $Selenium->InputFieldValueSet(
            Element => '#StateID',
            Value   => 2,
        );
        $Selenium->InputFieldValueSet(
            Element => '#LanguageID',
            Value   => 2,
        );
        $Selenium->find_element( "#Keywords", 'css' )->send_keys(' Edit');
        $Selenium->find_element( "#Field1",   'css' )->send_keys(' Edit');
        $Selenium->find_element( "#Field2",   'css' )->send_keys(' Edit');
        $Selenium->find_element( "#Field3",   'css' )->send_keys(' Edit');
        $Selenium->find_element( "#Field6",   'css' )->send_keys(' Edit');
        $Selenium->InputFieldValueSet(
            Element => '#ValidID',
            Value   => 2,
        );

        $Selenium->find_element( "#FAQSubmit", 'css' )->VerifiedClick();

        # Navigate to AgentFAQEdit screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentFAQEdit;ItemID=$ItemID");

        # Verify edited values.
        for my $Edited ( sort keys %{ $Test{Edited} } ) {
            if ( $Edited ne 'ContentType' ) {
                $Self->Is(
                    $Selenium->find_element( '#' . $Edited, 'css' )->get_value(),
                    "$Test{Edited}->{$Edited}",
                    "#$Edited stored value",
                );
            }
        }

        # Enable RichText.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 1,
        );

        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentFAQAdd");

        # Wait until jQuery is loaded.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function';" );

        my $UploadCacheObject = $Kernel::OM->Get('Kernel::System::Web::UploadCache');
        my $ConfigObject      = $Kernel::OM->Get('Kernel::Config');
        my $EncodeObject      = $Kernel::OM->Get('Kernel::System::Encode');
        my $MainObject        = $Kernel::OM->Get('Kernel::System::Main');

        # Create FAQ item with inline attachment.
        my $Location = $ConfigObject->Get('Home')
            . "/scripts/test/sample/WebUploadCache/WebUploadCache-Test1.png";
        my $ContentRef = $MainObject->FileRead(
            Location => $Location,
            Mode     => 'binmode',
        );
        my $Content = ${$ContentRef};
        $EncodeObject->EncodeOutput( \$Content );

        my $FormID      = $Selenium->execute_script("return \$('input[name=FormID]').val();");
        my $Filename    = 'Inline' . $Helper->GetRandomID();
        my $ContentID   = $Helper->GetRandomID();
        my $Disposition = 'inline';

        # Add picture to upload cache.
        my $Add = $UploadCacheObject->FormIDAddFile(
            FormID      => $FormID,
            Filename    => "$Filename.png",
            Content     => $Content,
            ContentType => 'text/html',
            ContentID   => $ContentID,
            Disposition => $Disposition,
        );
        $Self->True(
            $Add,
            "Inline picture is added to upload cache successfully",
        );

        my $Field1HTML =
            '<!DOCTYPE html><html><body>' .
            '<img alt="" src="/' . $ScriptAlias . 'index.pl?Action=PictureUpload;FormID=' . $FormID .
            ';ContentID=' . $ContentID . '" /></body></html>';

        $Selenium->find_element( "#Title", 'css' )->send_keys('Test Title');
        $Selenium->InputFieldValueSet(
            Element => '#CategoryID',
            Value   => 1,
        );
        $Selenium->InputFieldValueSet(
            Element => '#StateID',
            Value   => 2,
        );
        $Selenium->InputFieldValueSet(
            Element => '#StateID',
            Value   => 1,
        );

        # Wait until CKEDITOR is loaded (there are 4 editors in the screen).
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('body.cke_editable', \$('.cke_wysiwyg_frame').contents()).length === 4;"
        );

        $Selenium->execute_script("CKEDITOR.instances.Field1.setData('$Field1HTML');");
        $Selenium->WaitFor(
            JavaScript =>
                "return CKEDITOR.instances.Field1.getData().indexOf('FormID=$FormID;ContentID=$ContentID') > -1;"
        );

        $Selenium->InputFieldValueSet(
            Element => '#ValidID',
            Value   => 1,
        );

        # Submit and switch back window.
        $Selenium->find_element( "#FAQSubmit", 'css' )->VerifiedClick();
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('a[href*=\"Action=AgentFAQEdit;ItemID=\"]').length"
        );

        # Get ItemID.
        my @FAQ = split( 'ItemID=', $Selenium->get_current_url() );
        push @ItemIDs, $FAQ[1];

        # Get attachments before Edit screen.
        my @ExistingAttachments = $FAQObject->AttachmentIndex(
            ItemID     => $ItemIDs[1],
            ShowInline => 1,
            UserID     => 1,
        );

        $Self->Is(
            scalar @ExistingAttachments,
            1,
            "Before Edit screen - there is one Inline attachment",
        );
        $Self->Is(
            $ExistingAttachments[0]->{Filename},
            "$Filename.png",
            "Before Edit screen - Inline attachment $Filename.png is found",
        );

        # Navigate to AgentFAQEdit screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentFAQEdit;ItemID=$ItemIDs[1]");

        # # Wait until page has loaded, if necessary.
        $Selenium->WaitForjQueryEventBound(
            CSSSelector => "#FAQSubmit",
        );
        $Selenium->find_element( "#FAQSubmit", 'css' )->VerifiedClick();

        # Waiting just to be sure attachment is stored.
        sleep 1;

        # Get attachments after Edit screen.
        @ExistingAttachments = $FAQObject->AttachmentIndex(
            ItemID     => $ItemIDs[1],
            ShowInline => 1,
            UserID     => 1,
        );

        $Self->Is(
            scalar @ExistingAttachments,
            1,
            "After Edit screen - there is one Inline attachment",
        );
        $Self->Is(
            $ExistingAttachments[0]->{Filename},
            "$Filename.png",
            "After Edit screen - Inline attachment $Filename.png is found",
        );

        # Delete test created FAQs.
        for my $ItemID (@ItemIDs) {
            my $Success = $FAQObject->FAQDelete(
                ItemID => $ItemID,
                UserID => 1,
            );
            $Self->True(
                $Success,
                "FAQ item is deleted - ID $ItemID",
            );
        }

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => "FAQ" );
    }
);

1;
