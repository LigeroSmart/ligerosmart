# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get needed objects
        my $Helper               = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $GeneralCatalogObject = $Kernel::OM->Get('Kernel::System::GeneralCatalog');

        # get 'Location' catalog class IDs
        my $ConfigItemDataRef = $GeneralCatalogObject->ItemGet(
            Class => 'ITSM::ConfigItem::Class',
            Name  => 'Location',
        );
        my $LocationConfigItemID = $ConfigItemDataRef->{ItemID};

        # get 'Production' deployment state ID
        my $DeplStateDataRef = $GeneralCatalogObject->ItemGet(
            Class => 'ITSM::ConfigItem::DeploymentState',
            Name  => 'Production',
        );
        my $ProductionDeplStateID = $DeplStateDataRef->{ItemID};

        # get needed objects
        my $ConfigItemObject = $Kernel::OM->Get('Kernel::System::ITSMConfigItem');
        my $ConfigObject     = $Kernel::OM->Get('Kernel::Config');

        # create ConfigItem number
        my $ConfigItemNumber = $ConfigItemObject->ConfigItemNumberCreate(
            Type    => $ConfigObject->Get('ITSMConfigItem::NumberGenerator'),
            ClassID => $LocationConfigItemID,
        );

        # add 'Location' test ConfigItem
        my $ConfigItemID = $ConfigItemObject->ConfigItemAdd(
            Number  => $ConfigItemNumber,
            ClassID => $LocationConfigItemID,
            UserID  => 1,
        );

        # add a new version
        my $VersionName = "Selenium" . $Helper->GetRandomID();
        my $VersionID   = $ConfigItemObject->VersionAdd(
            Name         => $VersionName,
            DefinitionID => 1,
            DeplStateID  => $ProductionDeplStateID,
            InciStateID  => 1,
            UserID       => 1,
            ConfigItemID => $ConfigItemID,
        );

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'itsm-configitem' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # navigate to AdminImportExport screen
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        $Selenium->get("${ScriptAlias}index.pl?Action=AdminImportExport");

        # check screen
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # click on 'Add template'
        $Selenium->find_element("//a[contains(\@href, \'Action=AdminImportExport;Subaction=TemplateEdit' )]")->click();

        # check and input step 1 of 5 screen
        for my $StepOneID (
            qw(Name Object Format ValidID Comment)
            )
        {
            my $Element = $Selenium->find_element( "#$StepOneID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }
        my $ImportExportName = "ImportExport" . $Helper->GetRandomID();
        $Selenium->find_element( "#Name", 'css' )->send_keys($ImportExportName);
        $Selenium->execute_script(
            "\$('#Object').val('ITSMConfigItem').trigger('redraw.InputField').trigger('change');");
        $Selenium->execute_script("\$('#Format').val('CSV').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Comment", 'css' )->send_keys('SeleniumTest');
        $Selenium->find_element("//button[\@value='SubmitNext'][\@type='submit']")->click();

        # check and inpot step 2 of 5 screen
        for my $StepTwoID (
            qw(ClassID CountMax EmptyFieldsLeaveTheOldValues)
            )
        {
            my $Element = $Selenium->find_element( "#$StepTwoID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }
        $Selenium->execute_script(
            "\$('#ClassID').val('$LocationConfigItemID').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element("//button[\@value='SubmitNext'][\@type='submit']")->click();

        # check and input step 3 of 5 screen
        for my $StepThreeID (
            qw(ColumnSeparator Charset IncludeColumnHeaders)
            )
        {
            my $Element = $Selenium->find_element( "#$StepThreeID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }
        $Selenium->execute_script(
            "\$('#ColumnSeparator').val('Comma').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element("//button[\@value='SubmitNext'][\@type='submit']")->click();

        # check and input step 4 of 5 screen
        $Selenium->find_element( "#MappingAdd", 'css' )->click();
        for my $StepFourID (
            qw(Key Identifier)
            )
        {
            my $Element = $Selenium->find_element(".//*[\@id='Object::0::$StepFourID']");

            $Element->is_enabled();
            $Element->is_displayed();
        }

        for my $StepFourClass (
            qw(ArrowUp ArrowDown DeleteColomn)
            )
        {
            my $Element = $Selenium->find_element( ".$StepFourClass", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # select 'Number' mapping element
        $Selenium->find_element(".//*[\@id='Object::0::Key']/option[2]")->click();

        # add and select 'Name' mapping element
        $Selenium->find_element( "#MappingAdd", 'css' )->click();
        $Selenium->find_element(".//*[\@id='Object::1::Key']/option[3]")->click();

        # add and select 'Deployment State' mapping element
        $Selenium->find_element( "#MappingAdd", 'css' )->click();
        $Selenium->find_element(".//*[\@id='Object::2::Key']/option[4]")->click();

        # add and select 'Incident State' mapping element
        $Selenium->find_element( "#MappingAdd", 'css' )->click();
        $Selenium->find_element(".//*[\@id='Object::3::Key']/option[5]")->click();
        $Selenium->find_element("//button[\@value='SubmitNext'][\@type='submit']")->click();

        # check step 5 of 5 screen
        for my $StepFourID (
            qw(RestrictExport Number Name DeplStateIDs InciStateIDs Type Phone1 Phone2
            Fax E-Mail Address Note)
            )
        {
            my $Element = $Selenium->find_element( "#$StepFourID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # search ConfigItem by number and deployment state
        $Selenium->find_element( "#RestrictExport", 'css' )->click();
        $Selenium->find_element( "#Number",         'css' )->send_keys($ConfigItemNumber);
        $Selenium->find_element( "#Name",           'css' )->send_keys($VersionName);
        $Selenium->execute_script(
            "\$('#DeplStateIDs').val('$ProductionDeplStateID').trigger('redraw.InputField').trigger('change');");
        $Selenium->execute_script("\$('#InciStateIDs').val('1').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element("//button[\@value='SubmitNext'][\@type='submit']")->click();

        # get needed objects
        my $ImportExportObject = $Kernel::OM->Get('Kernel::System::ImportExport');
        my $DBObject           = $Kernel::OM->Get('Kernel::System::DB');

        # get TemplateID of created test template
        $DBObject->Prepare(
            SQL   => 'SELECT id FROM imexport_template WHERE name = ?',
            Bind  => [ \$ImportExportName ],
            Limit => 1,
        );

        # fetch the result
        my $TemplateID;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $TemplateID = $Row[0];
        }

        # navigate to test created ConfigItem and verify it
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentITSMConfigItemZoom;ConfigItemID=$ConfigItemID");
        $Self->True(
            index( $Selenium->get_page_source(), $VersionName ) > -1,
            "Test config item name $VersionName - found",
        );

        # export created test template
        my $ExportResultRef = $ImportExportObject->Export(
            TemplateID => $TemplateID,
            UserID     => 1,
        );

        # delete created test ConfigItem, so it can be imported back
        my $Success = $ConfigItemObject->ConfigItemDelete(
            ConfigItemID => $ConfigItemID,
            UserID       => 1,
        );
        $Self->True(
            $Success,
            "Deleted ConfigItemID - $ConfigItemID",
        );

        # refresh screen and verify that test ConfigItem is deleted
        $Selenium->refresh();
        $Self->True(
            index( $Selenium->get_page_source(), $VersionName ) == -1,
            "Test config item name $VersionName - not found",
        );

        # get main object
        my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

        # create test Exported file to a system
        my $ExportFileName = "ITSMExport" . $Helper->GetRandomID() . ".csv";
        my $ExportLocation = $ConfigObject->Get('Home') . "/var/tmp/" . $ExportFileName;
        $Success = $MainObject->FileWrite(
            Location   => $ExportLocation,
            Content    => \$ExportResultRef->{DestinationContent}->[0],
            Mode       => 'utf8',
            Type       => 'Attachment',
            Permission => '664',
        );
        $Self->True(
            $Success,
            "Export file $ExportFileName - created",
        );

        # navigate to AdminImportExport screen
        $Selenium->get("${ScriptAlias}index.pl?Action=AdminImportExport");

        # click on 'Import'
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ImportInformation;TemplateID=$TemplateID' )]")
            ->click();

        # select Exported file and start importing
        $Selenium->find_element("//input[contains(\@name, \'SourceFile' )]")->send_keys($ExportLocation);
        $Selenium->find_element("//button[\@value='Start Import'][\@type='submit']")->VerifiedClick();

        # check for expected outcome
        $Self->True(
            index( $Selenium->get_page_source(), '(Created: 1)' ) > -1,
            "Import test ConfigItem - success",
        );

        # navigate to imported test created ConfigItem and verify it
        my $ImportedConfigItemID = $ConfigItemID + 1;
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentITSMConfigItemZoom;ConfigItemID=$ImportedConfigItemID");
        $Self->True(
            index( $Selenium->get_page_source(), $VersionName ) > -1,
            "Test config item name $VersionName - found",
        );

        # navigate to AdminImportExport screen
        $Selenium->get("${ScriptAlias}index.pl?Action=AdminImportExport");

        # click to delete test template
        $Selenium->find_element( "#DeleteTemplateID$TemplateID", 'css' )->click();

        # delete test imported ConfigItem
        $Success = $ConfigItemObject->ConfigItemDelete(
            ConfigItemID => $ImportedConfigItemID,
            UserID       => 1,
        );
        $Self->True(
            $Success,
            "Deleted ConfigItemID - $ImportedConfigItemID",
        );

        # delete test Exported file from system
        $Success = $MainObject->FileDelete(
            Location => $ExportLocation,
            Type     => 'Attachment',
        );
        $Self->True(
            $Success,
            "Export file $ExportFileName - deleted",
        );
    }
);

1;
