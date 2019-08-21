# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
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

        my $Helper               = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $TimeAccountingObject = $Kernel::OM->Get('Kernel::System::TimeAccounting');

        # Use a calendar with the same business hours for every day so that the UT runs correctly
        # on every day of the week and outside usual business hours.
        my %Week;
        my @Days = qw(Sun Mon Tue Wed Thu Fri Sat);
        for my $Day (@Days) {
            $Week{$Day} = [ 0 .. 23 ];
        }
        $Helper->ConfigSettingChange(
            Key   => 'TimeWorkingHours',
            Value => \%Week,
        );

        # Disable default Vacation days.
        $Helper->ConfigSettingChange(
            Key   => 'TimeVacationDays',
            Value => {},
        );

        # Disable MassEntry features.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'TimeAccounting::AllowMassEntryForUser',
            Value => 0,
        );

        # Create test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        # Get test user ID.
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # Insert test user into account setting.
        $TimeAccountingObject->UserSettingsInsert(
            UserID => $TestUserID,
            Period => '1',
        );

        my $DateTimeObject   = $Kernel::OM->Create('Kernel::System::DateTime');
        my $DateTimeSettings = $DateTimeObject->Get();

        my $YearCurrent  = $DateTimeSettings->{Year};
        my $MonthCurrent = $DateTimeSettings->{Month};
        my $DayCurrent   = $DateTimeSettings->{Day};

        # Update user time account setting.
        $TimeAccountingObject->UserSettingsUpdate(
            UserID        => $TestUserID,
            Description   => 'Selenium test accounting user',
            CreateProject => 1,
            ShowOvertime  => 1,
            Period        => {
                1 => {
                    DateStart   => "$YearCurrent-$MonthCurrent-$DayCurrent",
                    DateEnd     => "$YearCurrent-$MonthCurrent-$DayCurrent",
                    WeeklyHours => '38',
                    LeaveDays   => '25',
                    Overtime    => '38',
                    UserStatus  => 1,
                },
            },
        );

        # Create test project.
        my $ProjectTitle = 'Project ' . $Helper->GetRandomID();
        my $ProjectID    = $TimeAccountingObject->ProjectSettingsInsert(
            Project            => $ProjectTitle,
            ProjectDescription => 'Selenium test project',
            ProjectStatus      => 1,
        );

        # Create test action.
        my $ActionTitle = 'Action ' . $Helper->GetRandomID();
        $TimeAccountingObject->ActionSettingsInsert(
            Action       => $ActionTitle,
            ActionStatus => 1,
        );
        my %ActionData = $TimeAccountingObject->ActionGet(
            Action => $ActionTitle,
        );
        my $ActionID = $ActionData{ID};

        # Login as test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AgentTimeAccountingEdit.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTimeAccountingEdit");

        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("#RecordsNumber").length;'
        );

        # Add additional row.
        my $RecordsNumber     = $Selenium->execute_script('return parseInt($("#RecordsNumber").val(), 10);');
        my $NextRecordsNumber = $RecordsNumber + 1;

        $Selenium->execute_script(
            "\$(\"#MoreInputFields\")[0].scrollIntoView(true);",
        );
        $Selenium->WaitForjQueryEventBound(
            CSSSelector => "#MoreInputFields",
        );
        $Selenium->find_element( "#MoreInputFields", 'css' )->click();

        $Selenium->WaitFor(
            JavaScript => "return \$('#RecordsNumber').val() == $NextRecordsNumber;"
        );
        $Selenium->WaitFor(
            JavaScript => "return \$('#InsertWorkingHours tr.WorkingHours').length == $NextRecordsNumber;"
        );

        # Check time accounting edit field IDs, first and added row.
        for my $Row ( 1, $NextRecordsNumber ) {
            for my $EditFieldID (
                qw(ProjectID ActionID Remark StartTime EndTime Period)
                )
            {
                $Self->True(
                    $Selenium->execute_script("return \$('#$EditFieldID$Row').length;"),
                    "Element '#$EditFieldID$Row' is found in screen",
                );
            }
        }
        for my $EditRestID (
            qw(Month Day Year DayDatepickerIcon NavigationSelect IncompleteWorkingDaysList LeaveDay Sick Overtime)
            )
        {
            $Self->True(
                $Selenium->execute_script("return \$('#$EditRestID').length;"),
                "Element '#$EditRestID' is found in screen",
            );
        }

        # Edit time accounting for test created user.
        $Selenium->InputFieldValueSet(
            Element => '#ProjectID1',
            Value   => $ProjectID,
        );

        $Selenium->InputFieldValueSet(
            Element => '#ActionID1',
            Value   => $ActionID,
        );

        $Selenium->find_element( "#Remark1",    'css' )->send_keys('Selenium test remark');
        $Selenium->find_element( "#StartTime1", 'css' )->send_keys('10:00');
        $Selenium->find_element( "#EndTime1",   'css' )->send_keys( '16:00', "\t" );

        # Submit work accounting edit time record.
        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->VerifiedClick();

        # Verify that period calculate correct time.
        $Self->Is(
            $Selenium->find_element( "#Period1", 'css' )->get_value(),
            '6.00',
            "Period time correctly calculated",
        );

        # Verify submit message.
        my $SubmitMessage = 'Successful insert!';
        $Self->True(
            index( $Selenium->get_page_source(), $SubmitMessage ) > -1,
            "$SubmitMessage is found",
        );

        # Check if Agent have access to Navbar. See bug#13466.
        # Navigate to AgentTimeAccountingSetting.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentTimeAccountingSetting;Subaction=EditUser;UserID=$TestUserID"
        );

        # Subtract 10 days from current date.
        my $Interval = 10;
        $DateTimeObject->Subtract( Days => $Interval );
        my $YearStart = $DateTimeObject->Format(
            Format => '%Y',
        );
        my $MonthStart = $DateTimeObject->Format(
            Format => '%m',
        );
        my $DayStart = $DateTimeObject->Format(
            Format => '%d',
        );

        my $SubtractedDate = "$YearStart-$MonthStart-$DayStart";
        $Selenium->find_element( "#DateStart-1", 'css' )->clear();
        $Selenium->find_element( "#DateStart-1", 'css' )->send_keys($SubtractedDate);

        $Selenium->WaitForjQueryEventBound(
            CSSSelector => "#SubmitUserData",
        );
        $Selenium->find_element( "#SubmitUserData", 'css' )->click();

        $Selenium->WaitFor(
            JavaScript => "return \$('.MessageBox.Error a[href*=\"Action=AgentTimeAccountingEdit\"]').length;"
        );

        # Check if error notification is shown on page.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('.MessageBox.Error a[href*=\"Action=AgentTimeAccountingEdit\"]').text().trim();"
            ),
            "Please insert your working hours!",
            'Error notification for inserting working hours is found',
        );

        # Checks if Incomplete working days is shown.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('.IncompleteWorkingDays .Counter').text();"
            ),
            $Interval,
            "$Interval incomplete working days is found in toolbar counter",
        );

        # Try to navigate to AgentDashboard.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentDashboard");

        $Self->False(
            index( $Selenium->get_current_url(), 'Action=AgentDashboard' ) > -1,
            "User is bloked to use application, it is needed to insert working hours",
        );

        # Disable MassEntry features.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'TimeAccounting::MaxIntervalOfIncompleteDays',
            Value => 15,
        );

        # Disable MassEntry features.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'TimeAccounting::MaxIntervalOfIncompleteDaysBeforeWarning',
            Value => 5,
        );

        # Refresh the screen to load new notification after changing config.
        $Selenium->VerifiedRefresh();

        $Selenium->WaitFor(
            JavaScript => "return \$('.MessageBox.Notice a[href*=\"Action=AgentTimeAccountingEdit\"]').length;"
        );

        # Check if warrning notification is shown on page.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('.MessageBox.Notice a[href*=\"Action=AgentTimeAccountingEdit\"]').text().trim();"
            ),
            "Please insert your working hours!",
            'Warrning notification for inserting working hours is found',
        );

        # Try to navigate to AgentDashboard.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentDashboard");

        $Self->True(
            index( $Selenium->get_current_url(), 'Action=AgentDashboard' ) > -1,
            "User is not bloked to use application",
        );

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # Get DB clean-up data.
        my @DBCleanData = (
            {
                Quoted  => $ProjectTitle,
                Table   => 'time_accounting_project',
                Where   => 'project',
                Bind    => '',
                Message => "$ProjectTitle is deleted",
            },
            {
                Quoted  => $ActionTitle,
                Table   => 'time_accounting_action',
                Where   => 'action',
                Bind    => '',
                Message => "$ActionTitle is deleted",
            },
            {
                Table   => 'time_accounting_table',
                Where   => 'user_id',
                Bind    => $TestUserID,
                Message => "Test user $TestUserID is removed from accounting table",
            },
            {
                Table   => 'time_accounting_user',
                Where   => 'user_id',
                Bind    => $TestUserID,
                Message => "Test user $TestUserID is removed from accounting setting",
            },
            {
                Table   => 'time_accounting_user_period',
                Where   => 'user_id',
                Bind    => $TestUserID,
                Message => "Test user $TestUserID is removed from accounting period",
            },
        );

        # Clean system from test created data.
        for my $Delete (@DBCleanData) {
            if ( $Delete->{Quoted} ) {
                $Delete->{Bind} = $DBObject->Quote( $Delete->{Quoted} );
            }
            my $Success = $DBObject->Do(
                SQL  => "DELETE FROM $Delete->{Table} WHERE $Delete->{Where} = ?",
                Bind => [ \$Delete->{Bind} ],
            );
            $Self->True(
                $Success,
                $Delete->{Message},
            );
        }
    }
);

1;
