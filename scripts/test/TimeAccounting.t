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

# declare externally defined variables to avoid errors under 'use strict'
use vars qw($Self);

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $RandomNumber = int substr $Helper->GetRandomNumber(), -5, 5;

# data for the new action (task)
my %NewActionData = (
    Action       => 'TestAction' . $RandomNumber,
    ActionStatus => 1,
);

# get time accounting object
my $TimeAccountingObject = $Kernel::OM->Get('Kernel::System::TimeAccounting');

# create a new action (task)
my $Insert = $TimeAccountingObject->ActionSettingsInsert(%NewActionData);

# verify that the action was successfully inserted
$Self->True(
    $Insert,
    'Insert test action settings into database',
);

# get the action data that was inserted above
my %ActionData = $TimeAccountingObject->ActionGet( Action => $NewActionData{Action} );

# verify that the data saved in the DB is the same that was inserted
$Self->Is(
    $ActionData{ActionStatus},
    $NewActionData{ActionStatus},
    'Compare action status saved in DB with the inserted one',
);

# modify the action name
my $Update = $TimeAccountingObject->ActionSettingsUpdate(
    ActionID     => $ActionData{ID},
    Action       => $NewActionData{Action} . 'modified',
    ActionStatus => 1,
);

# verify that the action was updated
$Self->True(
    $Update,
    'Update test action settings',
);

# get all actions data
my %AllActions = $TimeAccountingObject->ActionSettingsGet();

# verify the last modification
$Self->Is(
    $AllActions{ $ActionData{ID} }{Action},
    $NewActionData{Action} . 'modified',
    'Compare action name saved in DB with the specified in the update',
);

# data for the new project
my %NewProjectData = (
    Project            => 'TestProject' . $RandomNumber,
    ProjectDescription => 'Test',
    ProjectStatus      => 1,
);

# create a new project
my $ProjectID = $TimeAccountingObject->ProjectSettingsInsert(%NewProjectData);

# verify that the action was successfully inserted
$Self->True(
    $ProjectID,
    'Insert test project settings into database',
);

# get the action data that was inserted above
my %ProjectData = $TimeAccountingObject->ProjectGet( ID => $ProjectID );

# verify that the data saved in the DB is the same that was inserted
$Self->Is(
    $ProjectData{Project},
    $NewProjectData{Project},
    'Compare project name saved in DB with the inserted one',
);
$Self->Is(
    $ProjectData{ProjectDescription},
    $NewProjectData{ProjectDescription},
    'Compare project description saved in DB with the inserted one',
);
$Self->Is(
    $ProjectData{ProjectStatus},
    $NewProjectData{ProjectStatus},
    'Compare project status saved in DB with the inserted one',
);

# modify the project name
$Update = $TimeAccountingObject->ProjectSettingsUpdate(
    ID                 => $ProjectID,
    Project            => $NewProjectData{Project} . 'modified',
    ProjectDescription => 'Test',
    ProjectStatus      => 1,
);

# verify that the action was updated
$Self->True(
    $Update,
    'Update test project settings',
);

# get all projects data
my %AllProjects = $TimeAccountingObject->ProjectSettingsGet( Status => 'valid' );

# verify the last modification
$Self->Is(
    $AllProjects{Project}{$ProjectID},
    $NewProjectData{Project} . 'modified',
    'Compare project name saved in DB with the specified in the update',
);

# create new user
my $UserLogin = $Kernel::OM->Get('Kernel::System::UnitTest::Helper')->TestUserCreate();
my $UserID    = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
    UserLogin => $UserLogin,
);

# obtain the last registered period of the test user
my $LastPeriodNumber = $TimeAccountingObject->UserLastPeriodNumberGet( UserID => $UserID ) + 1;

# create registry for the new user in TA
$Insert = $TimeAccountingObject->UserSettingsInsert(
    UserID => $UserID,
    Period => $LastPeriodNumber,
);

# verify that the user was successfully inserted
$Self->True(
    $Insert,
    'Insert test user settings into database',
);

# insert another period entry for the same user
$Insert = $TimeAccountingObject->UserSettingsInsert(
    UserID => $UserID,
    Period => $LastPeriodNumber + 1,
);

# verify that the user was successfully inserted
$Self->True(
    $Insert,
    'Insert time period for test user settings into database',
);

$RandomNumber = int substr $Helper->GetRandomNumber(), -3, 3;

# update user data
$Update = $TimeAccountingObject->UserSettingsUpdate(
    UserID        => $UserID,
    Description   => 'Test user' . $RandomNumber,
    CreateProject => 1,
    ShowOvertime  => 1,
    Period        => {
        1 => {
            DateStart   => '2011-01-01',
            DateEnd     => '2011-01-31',
            WeeklyHours => $RandomNumber,
            LeaveDays   => '10',
            Overtime    => '20',
            UserStatus  => 1,
        },
        2 => {
            DateStart   => '2011-02-01',
            DateEnd     => '2011-12-31',
            WeeklyHours => $RandomNumber + 10,
            LeaveDays   => '5',
            Overtime    => '10',
            UserStatus  => 1,
        },
    },
);

# verify that the action was updated
$Self->True(
    $Update,
    'Update test user settings',
);

# get user settings
my %SingleUserData = $TimeAccountingObject->SingleUserSettingsGet( UserID => $UserID );

# verify the last modification
$Self->Is(
    int $SingleUserData{1}{WeeklyHours},
    $RandomNumber,
    'Compare weekly hours for period 1 saved in DB with the specified in the update',
);

$Self->Is(
    int $SingleUserData{2}{WeeklyHours},
    $RandomNumber + 10,
    'Compare weekly hours for period 2 saved in DB with the specified in the update',
);

# get user data
%SingleUserData = $TimeAccountingObject->UserGet( UserID => $UserID );

# compare data saved on the DB with the inserted one
$Self->Is(
    $SingleUserData{Description},
    'Test user' . $RandomNumber,
    'Compare description saved on the DB with the specified in the insertion',
);

# get all users data
my %AllUsersData = $TimeAccountingObject->UserList();

# verify that the test user is in the list
$Self->True(
    $AllUsersData{$UserID}{Description},
    'Verify the existence of the test user in the list'
);

# get all periods of data of all users
my %AllUsersPeriodData = $TimeAccountingObject->UserSettingsGet();

# verify the period data of the test user
my $CorrectUserData =
    (
    $AllUsersPeriodData{$UserID}{1}{WeeklyHours} == $RandomNumber
        && $AllUsersPeriodData{$UserID}{1}{LeaveDays} == 10
        && $AllUsersPeriodData{$UserID}{1}{Overtime} == 20
        && $AllUsersPeriodData{$UserID}{1}{UserStatus}
        && $AllUsersPeriodData{$UserID}{2}{WeeklyHours} == $RandomNumber + 10
        && $AllUsersPeriodData{$UserID}{2}{LeaveDays} == 5
        && $AllUsersPeriodData{$UserID}{2}{Overtime} == 10
        && $AllUsersPeriodData{$UserID}{2}{UserStatus}
    ) ? 1 : 0;

$Self->True(
    $CorrectUserData,
    'Verify the period data of the test user in the list'
);

# get current period of user
my %UserCurrentPeriod = $TimeAccountingObject->UserCurrentPeriodGet(
    Year  => '2011',
    Month => '01',
    Day   => '15',
);

# check the period
$Self->Is(
    $UserCurrentPeriod{$UserID}->{Period},
    1,
    'Verify current period',
);

$Self->Is(
    $UserCurrentPeriod{$UserID}->{DateStart},
    '2011-01-01',
    'Verify start date of current period',
);

$Self->Is(
    $UserCurrentPeriod{$UserID}->{DateEnd},
    '2011-01-31',
    'Verify end date of current period',
);

# hash with the working units for Jan. 15th, 2011
my %WorkingUnits = (
    Year         => '2011',
    Month        => '01',
    Day          => '15',
    LeaveDay     => 0,
    Sick         => 0,
    Overtime     => 0,
    WorkingUnits => [
        {
            ProjectID => $ProjectID,
            ActionID  => $ActionData{ID},
            Remark    => 'My comment',
            StartTime => '7:00',
            EndTime   => '10:00',
            Period    => 3.0,
        },
        {
            ProjectID => $ProjectID,
            ActionID  => $ActionData{ID},
            Remark    => 'My comment',
            StartTime => '13:00',
            EndTime   => '15:00',
            Period    => 2.0,
        },
    ],
    UserID => $UserID,
);

# insert working units in the DB
$Insert = $TimeAccountingObject->WorkingUnitsInsert(%WorkingUnits);

# verify that the working units were successfully inserted
$Self->True(
    $Insert,
    'Insert working units for test user into database',
);

# get all days without working units entry
my %WorkingUnitsCheck = $TimeAccountingObject->WorkingUnitsCompletnessCheck(
    UserID => $UserID,
);

# verify that Jan 15th, 2011 is not in the list of days without entry
$Self->False(
    defined $WorkingUnitsCheck{'Incomplete'}{'2011'}{'01'}{'15'},
    'Verify completion of working units'
);

# get working units of all users
my %Data = $TimeAccountingObject->UserReporting(
    Year  => '2011',
    Month => '01',
    Day   => '15',
);

# verify the correctness of the working units for the test user
$Self->Is(
    $Data{$UserID}{WorkingHoursTotal},
    5,
    'Verify number of working hours of the test user',
);

# get projects in which the test user has worked on
my @LastProjects = $TimeAccountingObject->LastProjectsOfUser(
    UserID => $UserID,
);

my $TestProjectExistence;

ID:
for my $ID (@LastProjects) {
    next ID if $ID != $ProjectID;
    $TestProjectExistence = 1;
}

# verify that existence of the test project into the user's list
$Self->True(
    $TestProjectExistence,
    'Verify that existence of the test project into the user\'s list',
);

# get project - action working hours
my %ProjectActionWorkingHours = $TimeAccountingObject->ProjectActionReporting(
    Year   => 2011,
    Month  => 1,
    UserID => $UserID,
);

# verify total reported hours for the test action (task) and test project
$Self->Is(
    $ProjectActionWorkingHours{$ProjectID}{Actions}{ $ActionData{ID} }{Total},
    '5',
    'Verify total reported hours for the test action (task) and test project',
);

# get project working units
my @ProjectHistoryArray = $TimeAccountingObject->ProjectHistory( ProjectID => $ProjectID );

my $TotalHours;

# get sum of all working unit for the test project
for my $Project (@ProjectHistoryArray) {
    $TotalHours += $Project->{Period};
}

my $TestProjectTotalHours = $TimeAccountingObject->ProjectTotalHours(
    ProjectID => $ProjectID,
);

# verify total working units for the test project
$Self->Is(
    int $TotalHours,
    int $TestProjectTotalHours,
    'Verify total hours of test project',
);

# delete working units for Jan. 15th, 2011
my $Delete = $TimeAccountingObject->WorkingUnitsDelete(
    Year   => '2011',
    Month  => '1',
    Day    => '15',
    UserID => $UserID,
);

# verify that the working units were successfully deleted
$Self->True(
    $Delete,
    'Delete working units for test',
);

# get working units for Jan. 15th, 2011
my %WorkingUnitsData = $TimeAccountingObject->WorkingUnitsGet(
    Year   => '2011',
    Month  => '1',
    Day    => '15',
    UserID => $UserID,
);

# verify nonexistence of the deleted working units
$Self->Is(
    $WorkingUnitsData{Total},
    '0',
    'Verify nonexistence of the deleted working units',
);

# set to invalid all registries used for the tests
$TimeAccountingObject->ActionSettingsUpdate(
    ActionID     => $ActionData{ID},
    Action       => $NewActionData{Action} . 'modified',
    ActionStatus => 0,
);

$TimeAccountingObject->ProjectSettingsUpdate(
    ID                 => $ProjectID,
    Project            => $NewProjectData{Project} . 'modified',
    ProjectDescription => 'Test',
    ProjectStatus      => 0,
);

$TimeAccountingObject->UserSettingsUpdate(
    UserID        => $UserID,
    Description   => 'Test user',
    CreateProject => 0,
    ShowOvertime  => 0,
    Period        => {
        1 => {
            DateStart   => '2011-01-01',
            DateEnd     => '2011-01-31',
            WeeklyHours => '50',
            LeaveDays   => '10',
            Overtime    => '20',
            UserStatus  => 0,
        },
        2 => {
            DateStart   => '2011-02-01',
            DateEnd     => '2011-02-28',
            WeeklyHours => '30',
            LeaveDays   => '5',
            Overtime    => '10',
            UserStatus  => 0,
        },
    },
);

# cleanup is done by RestoreDatabase.

1;
