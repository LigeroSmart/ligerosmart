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

        # Disable default Vacation days.
        $Helper->ConfigSettingChange(
            Key   => 'TimeVacationDays',
            Value => {},
        );

        # disable MassEntry features
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'TimeAccounting::AllowMassEntryForUser',
            Value => 0,
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

        my $DateTimeObject   = $Kernel::OM->Create('Kernel::System::DateTime');
        my $DateTimeSettings = $DateTimeObject->Get();

        my $YearCurrent  = $DateTimeSettings->{Year};
        my $MonthCurrent = $DateTimeSettings->{Month};
        my $DayCurrent   = $DateTimeSettings->{Day};

        # update user time account setting
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

        # log in test user
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AgentTimeAccountingEdit
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTimeAccountingEdit");

        # add additional row
        $Selenium->find_element("//button[\@id='MoreInputFields'][\@type='button']")->VerifiedClick();

        # check time accounting edit field IDs, first and added row
        for my $Row ( 1, 9 ) {
            for my $EditFieldID (
                qw(ProjectID ActionID Remark StartTime EndTime Period)
                )
            {
                my $Element = $Selenium->find_element( "#$EditFieldID$Row", 'css' );
                $Element->is_enabled();
                $Element->is_displayed();
            }
        }
        for my $EditRestID (
            qw(Month Day Year DayDatepickerIcon NavigationSelect IncompleteWorkingDaysList LeaveDay Sick Overtime)
            )
        {
            my $Element = $Selenium->find_element( "#$EditRestID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # edit time accounting for test created user
        $Selenium->execute_script(
            "\$('#ProjectID1').val('$ProjectID').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->execute_script("\$('#ActionID1').val('$ActionID').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Remark1",    'css' )->send_keys('Selenium test remark');
        $Selenium->find_element( "#StartTime1", 'css' )->send_keys('10:00');
        $Selenium->find_element( "#EndTime1",   'css' )->send_keys( '16:00', "\t" );

        # submit work accounting edit time record
        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->VerifiedClick();

        # verify that period calculate correct time
        $Self->Is(
            $Selenium->find_element( "#Period1", 'css' )->get_value(),
            '6.00',
            "Period time correctly calculated",
        );

        # verify submit message
        my $SubmitMessage = 'Successful insert!';
        $Self->True(
            index( $Selenium->get_page_source(), $SubmitMessage ) > -1,
            "$SubmitMessage is found",
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
