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

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # do not check RichText
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

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AgentSurveyAdd
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentSurveyAdd");

        # check page
        for my $ID (
            qw(Title Introduction NotificationSender NotificationSubject NotificationBody Queues Description)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # create test survey
        my $SurveyTitle = 'Survey ' . $Helper->GetRandomID();
        $Selenium->find_element( "#Title",        'css' )->send_keys($SurveyTitle);
        $Selenium->find_element( "#Introduction", 'css' )->send_keys('Selenium Introduction');
        $Selenium->execute_script("\$('#Queue_Search').val('2||Raw').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Description", 'css' )->send_keys('Selenium Description');

        # scroll
        $Selenium->execute_script(
            "\$('#CustomerUserConditions')[0].scrollIntoView(true);",
        );

        $Selenium->execute_script("\$('#CustomerUserConditions').val('UserLogin').change();");
        $Selenium->find_element( "#Description", 'css' )->send_keys('customer');

        # UserLogin
        $Selenium->find_element("//button[\@value='Create'][\@type='submit']")->VerifiedClick();

        # check for test created survey values
        $Self->True(
            index( $Selenium->get_page_source(), $SurveyTitle ) > -1,
            "$SurveyTitle title is found"
        );

        # delete test created survey
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

        # clean-up test created survey data
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
