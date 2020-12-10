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

        # Do not check RichText.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0,
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Survey::CheckSendConditionCustomerFields',
            Value => {
                UserLogin => 1,
                UserPhone => 1,
            },
        );

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

        # Navigate to AgentSurveyAdd.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentSurveyAdd");

        # Check page.
        for my $ID (
            qw(Title Introduction NotificationSender NotificationSubject NotificationBody Queues Description)
            )
        {
            $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#$ID').length;" );
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Create test survey.
        my $SurveyTitle = 'Survey ' . $Helper->GetRandomID();
        $Selenium->find_element( "#Title",        'css' )->send_keys($SurveyTitle);
        $Selenium->find_element( "#Introduction", 'css' )->send_keys('Selenium Introduction');
        $Selenium->execute_script("\$('#Queue_Search').val('2||Raw').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Description", 'css' )->send_keys('Selenium Description');

        # Scroll down.
        $Selenium->execute_script(
            "\$('#CustomerUserConditions')[0].scrollIntoView(true);",
        );
        $Self->True(
            $Selenium->execute_script("return \$('#CustomerUserConditions').length;"),
            "Element 'CustomerUserConditions' is found"
        );

        $Selenium->execute_script("\$('#CustomerUserConditions').val('UserLogin').change();");
        $Selenium->find_element( "#Description", 'css' )->send_keys('customer');

        # Scroll down.
        $Selenium->execute_script(
            "\$('button[value=Create][type=submit]')[0].scrollIntoView(true);",
        );
        $Self->True(
            $Selenium->execute_script("return \$('button[value=Create][type=submit]').length;"),
            "Submit button is found"
        );

        # UserLogin.
        $Selenium->find_element("//button[\@value='Create'][\@type='submit']")->VerifiedClick();

        # Check for test created survey values.
        $Self->True(
            index( $Selenium->get_page_source(), $SurveyTitle ) > -1,
            "$SurveyTitle title is found"
        );

        # Delete test created survey.
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        my $SurveyTitleQuoted = $DBObject->Quote($SurveyTitle);
        $DBObject->Prepare(
            SQL  => "SELECT id FROM survey WHERE title = ?",
            Bind => [ \$SurveyTitleQuoted ]
        );
        my $SurveyID;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $SurveyID = $Row[0];
        }

        my %Survey = $Kernel::OM->Get('Kernel::System::Survey')->SurveyGet(
            SurveyID => $SurveyID,
        );

# Delete keys that we don't want to compare. Note that CustomerUserConditionsJSON has sometimes different order and therefore
# it's not evaluated. Also, NotificationBody contains OTRS link, which is different for each system and it's not so relevant for the test.
        for my $Key (
            qw(CreateTime CreateBy ChangeTime ChangeBy SurveyNumber CustomerUserConditionsJSON NotificationBody)
            )
        {

            my $Value = delete $Survey{$Key};
            $Self->True(
                $Value,
                "Make sure that there was '$Key' defined in Survey hash.",
            );
        }

        my %ExpectedValue = (
            "ChangeUserFirstname"    => $TestUserLogin,
            "ChangeUserFullname"     => "$TestUserLogin $TestUserLogin",
            "ChangeUserLastname"     => $TestUserLogin,
            "ChangeUserLogin"        => $TestUserLogin,
            "CreateUserFirstname"    => $TestUserLogin,
            "CreateUserFullname"     => "$TestUserLogin $TestUserLogin",
            "CreateUserLastname"     => $TestUserLogin,
            "CreateUserLogin"        => $TestUserLogin,
            "CustomerUserConditions" => {
                "UserLogin" => [
                    {
                        "Negation"    => 0,
                        "RegExpValue" => "",
                    },
                ],
            },
            "Description"         => "Selenium Descriptioncustomer",
            "Introduction"        => "Selenium Introduction",
            "NotificationSender"  => "quality\@example.com",
            "NotificationSubject" => "Help us with your feedback!",
            "Queues"              => [],
            "SendConditionsRaw" => "---\nCustomerUserConditions:\n  UserLogin:\n  - Negation: 0\n    RegExpValue: ''\n",
            "Status"            => "New",
            "SurveyID"          => $SurveyID,
            "Title"             => $SurveyTitle,
        );

        $Self->IsDeeply(
            \%Survey,
            \%ExpectedValue,
            'Check Survey hash deeply.',
        );

        # Clean-up test created survey data.
        my $Success = $DBObject->Do(
            SQL  => "DELETE FROM survey_queue WHERE survey_id = ?",
            Bind => [ \$SurveyID ],
        );
        $Self->True(
            $Success,
            "Survey-Queue for $SurveyTitle is deleted",
        );

        $Success = $DBObject->Do(
            SQL  => "DELETE FROM survey WHERE id = ?",
            Bind => [ \$SurveyID ],
        );
        $Self->True(
            $Success,
            "$SurveyTitle is deleted",
        );
    }
);

1;
