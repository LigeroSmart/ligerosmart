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

        # Create test survey.
        my $SurveyTitle         = 'Survey ' . $Helper->GetRandomID();
        my $Introduction        = 'Survey Introduction';
        my $Description         = 'Survey Description';
        my $NotificationSender  = 'quality@example.com';
        my $NotificationSubject = 'Survey Notification Subject';
        my $NotificationBody    = 'Survey Notification Body';

        my $SurveyObject = $Kernel::OM->Get('Kernel::System::Survey');

        my $SurveyID = $SurveyObject->SurveyAdd(
            UserID                 => 1,
            Title                  => $SurveyTitle,
            Introduction           => $Introduction,
            Description            => $Description,
            NotificationSender     => $NotificationSender,
            NotificationSubject    => $NotificationSubject,
            NotificationBody       => $NotificationBody,
            Queues                 => [2],
            CustomerUserConditions => {
                UserLogin => [
                    {
                        Negation    => 0,
                        RegExpValue => 'John',
                    },
                ],
            },
        );
        $Self->True(
            $SurveyID,
            "Survey ID $SurveyID is created",
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

        # Navigate to AgentSurveyEdit of created test survey.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentSurveyEdit;SurveyID=$SurveyID");

        # Get test params.
        my @Test = (
            {
                ID     => 'Title',
                Stored => $SurveyTitle,
                Edited => $SurveyTitle . ' edited',
            },
            {
                ID     => 'Introduction',
                Stored => $Introduction,
                Edited => $Introduction . ' edited',
            },
            {
                ID     => 'Description',
                Stored => $Description,
                Edited => $Description . ' edited',
            },
            {
                ID     => 'NotificationSender',
                Stored => $NotificationSender,
                Edited => $NotificationSender . ' edited',
            },
            {
                ID     => 'NotificationSubject',
                Stored => $NotificationSubject,
                Edited => $NotificationSubject . ' edited',
            },
            {
                ID     => 'NotificationBody',
                Stored => $NotificationBody,
                Edited => $NotificationBody . ' edited',
            },
        );

        # Check test survey values and edit them.
        for my $SurveyStored (@Test) {

            $Self->Is(
                $Selenium->find_element( "#$SurveyStored->{ID}", 'css' )->get_value(),
                $SurveyStored->{Stored},
                "#$SurveyStored->{ID} stored value",
            );

            # Edit value.
            $Selenium->find_element( "#$SurveyStored->{ID}", 'css' )->send_keys(' edited');
        }

        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#UserLoginInput1").length' );

        # Update customer user condition.
        $Selenium->execute_script(
            "\$('#UserLoginInput1')[0].scrollIntoView(true);",
        );

        $Selenium->execute_script("\$('#UserLoginInput1').val('John edited');");

        # Submit updates and switch back window.
        $Selenium->find_element("//button[\@value='Update'][\@type='submit']")->VerifiedClick();

        # Navigate to AgentSurveyEdit of created test survey again.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentSurveyEdit;SurveyID=$SurveyID");

        # Check edited values.
        for my $SurveryEdited (@Test) {

            $Self->Is(
                $Selenium->find_element( "#$SurveryEdited->{ID}", 'css' )->get_value(),
                $SurveryEdited->{Edited},
                "#$SurveryEdited->{ID} stored value",
            );
        }

        my %Survey = $SurveyObject->SurveyGet(
            SurveyID => $SurveyID,
        );

        # Delete keys that we don't want to compare.
        # Note that CustomerUserConditionsJSON has sometimes different order and therefore
        # it's not evaluated.
        for my $Key (qw(CreateTime CreateBy ChangeTime ChangeBy SurveyNumber CustomerUserConditionsJSON)) {

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
            "CreateUserFirstname"    => 'Admin',
            "CreateUserFullname"     => 'Admin OTRS',
            "CreateUserLastname"     => 'OTRS',
            "CreateUserLogin"        => 'root@localhost',
            "CustomerUserConditions" => {
                "UserLogin" => [
                    {
                        "Negation"    => 0,
                        "RegExpValue" => "John edited",
                    },
                ],
            },
            "Description"         => "$Description edited",
            "Introduction"        => "$Introduction edited",
            "NotificationBody"    => "$NotificationBody edited",
            "NotificationSender"  => "$NotificationSender edited",
            "NotificationSubject" => "$NotificationSubject edited",
            "Queues"              => [2],
            "SendConditionsRaw" =>
                "---\nCustomerUserConditions:\n  UserLogin:\n  - Negation: 0\n    RegExpValue: John edited\n",
            "Status"   => "New",
            "SurveyID" => $SurveyID,
            "Title"    => "$SurveyTitle edited",
        );

        $Self->IsDeeply(
            \%Survey,
            \%ExpectedValue,
            'Check Survey hash deeply.',
        );

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # Clean-up test created survey data.
        my $Success = $DBObject->Do(
            SQL  => "DELETE FROM survey_queue WHERE survey_id = ?",
            Bind => [ \$SurveyID ],
        );
        $Self->True(
            $Success,
            "Survey-Queue for $SurveyTitle is deleted",
        );

        # Delete test created survey.
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
