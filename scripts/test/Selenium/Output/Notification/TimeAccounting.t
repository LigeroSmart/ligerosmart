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

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # use a calendar with the same business hours for every day so that the UT runs correctly
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

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        # get test user ID
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # get time accounting object
        my $TimeAccountingObject = $Kernel::OM->Get('Kernel::System::TimeAccounting');

        # insert test user into account setting
        $TimeAccountingObject->UserSettingsInsert(
            UserID => $TestUserID,
            Period => '1',
        );

        my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

        $DateTimeObject->Subtract( Days => 40 );
        my $DateTimeSettingsStart = $DateTimeObject->Get();
        my $YearStart             = $DateTimeSettingsStart->{Year};
        my $MonthStart            = $DateTimeSettingsStart->{Month};
        my $DayStart              = $DateTimeSettingsStart->{Day};

        $DateTimeObject->Add(
            Days    => 40,
            Seconds => 1
        );
        my $DateTimeSettings = $DateTimeObject->Get();

        my $YearCurrent  = $DateTimeSettings->{Year};
        my $MonthCurrent = $DateTimeSettings->{Month};
        my $DayCurrent   = $DateTimeSettings->{Day};

        $DateTimeObject->Subtract( Seconds => 1 );
        $DateTimeObject->Add( Days => 1 );
        my $DateTimeSettingsEnd = $DateTimeObject->Get();

        my $YearEnd  = $DateTimeSettingsEnd->{Year};
        my $MonthEnd = $DateTimeSettingsEnd->{Month};
        my $DayEnd   = $DateTimeSettingsEnd->{Day};

        # update user time account setting
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

        # create test project
        my $ProjectTitle = 'Project ' . $Helper->GetRandomID();
        my $ProjectID    = $TimeAccountingObject->ProjectSettingsInsert(
            Project            => $ProjectTitle,
            ProjectDescription => 'Selenium test project',
            ProjectStatus      => 1,
        );

        # create test action
        my $ActionTitle = 'Action ' . $Helper->GetRandomID();
        $TimeAccountingObject->ActionSettingsInsert(
            Action       => $ActionTitle,
            ActionStatus => 1,
        );
        my %ActionData = $TimeAccountingObject->ActionGet(
            Action => $ActionTitle,
        );
        my $ActionID = $ActionData{ID};

        # add working units for test user
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

        # log in test user
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # verify there is notification message
        my $NotificationMessage = 'Please insert your working hours!';
        $Self->True(
            index( $Selenium->get_page_source(), $NotificationMessage ) > -1,
            "$NotificationMessage is found",
        );

        # get DB object
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # get DB clean-up data
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

        # clean system from test created data
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
