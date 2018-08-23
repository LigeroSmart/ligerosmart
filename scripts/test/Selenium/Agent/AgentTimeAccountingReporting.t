# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
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
        my $DateTimeObject       = $Kernel::OM->Create('Kernel::System::DateTime');

        # Set MaxIntervalOfIncompleteDays SysConfig on 50 days for test purpose.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'TimeAccounting::MaxIntervalOfIncompleteDays',
            Value => 50,
        );

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

        $Helper->ConfigSettingChange(
            Key   => 'TimeWorkingHours',
            Value => \%Week,
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

        $DateTimeObject->Subtract( Days => 40 );
        my $YearStart = $DateTimeObject->Format(
            Format => '%Y',
        );
        my $MonthStart = $DateTimeObject->Format(
            Format => '%m',
        );
        my $DayStart = $DateTimeObject->Format(
            Format => '%d',
        );

        $DateTimeObject->Add(
            Seconds => 1
        );
        my $DateTimeSettings = $DateTimeObject->Get();

        my $YearCurrent  = $DateTimeSettings->{Year};
        my $MonthCurrent = $DateTimeSettings->{Month};
        my $DayCurrent   = $DateTimeSettings->{Day};

        $DateTimeSettings = $Kernel::OM->Create('Kernel::System::DateTime');
        $DateTimeSettings->Add(
            Days => 1,
        );
        my $DateTimeSettingsEnd = $DateTimeSettings->Get();

        my $YearEnd  = $DateTimeSettingsEnd->{Year};
        my $MonthEnd = $DateTimeSettingsEnd->{Month};
        my $DayEnd   = $DateTimeSettingsEnd->{Day};

        # Update user time account setting.
        $TimeAccountingObject->UserSettingsUpdate(
            UserID        => $TestUserID,
            Description   => 'Selenium test accounting user',
            CreateProject => 1,
            ShowOvertime  => 1,
            Period        => {
                1 => {
                    DateStart   => "$YearStart-$MonthStart-$DayStart",
                    DateEnd     => "$YearEnd-$MonthEnd-$DayEnd",
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

        # Add working units for test user.
        $TimeAccountingObject->WorkingUnitsInsert(
            Year         => $YearCurrent,
            Month        => $MonthCurrent,
            Day          => $DayCurrent,
            LeaveDay     => 1,
            Sick         => 1,
            Overtime     => 1,
            WorkingUnits => [
                {
                    ProjectID => $ProjectID,
                    ActionID  => $ActionID,
                    Remark    => 'Selenium test remark',
                    Period    => '5',
                },
            ],
            UserID => $TestUserID,
        );

        # Login as test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AgentTimeAccountingReporting.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTimeAccountingReporting");

        # Select month and year that are used for testing.
        $Selenium->find_element( "#Month option[value='$MonthStart']", 'css' )->click();
        $Selenium->find_element( "#Year option[value='$YearStart']",   'css' )->click();
        $Selenium->WaitFor(
            JavaScript => "return \$('#Month').val() == $MonthStart && \$('#Year').val() == $YearStart"
        );

        $Selenium->find_element( "#NavigationSelect", 'css' )->VerifiedClick();

        # Check page layout.
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # Verify there is link to test user reports.
        my $UserReportElement = $Selenium->find_element( "$TestUserLogin $TestUserLogin", 'link_text' );
        $UserReportElement->is_enabled();
        $UserReportElement->is_displayed();

        # Verify there is link to test user project reports.
        my $ProjectReportElement = $Selenium->find_element( "$ProjectTitle", 'link_text' );
        $ProjectReportElement->is_enabled();
        $ProjectReportElement->is_displayed();

        # Select test created project.
        $Selenium->find_element( $ProjectTitle, 'link_text' )->VerifiedClick();

        # Check page layout.
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # Verify there is test created action.
        $Self->True(
            index( $Selenium->get_page_source(), $ActionTitle ) > -1,
            "$ActionTitle is found",
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
