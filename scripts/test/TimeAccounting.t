# --
# scripts/test/TimeAccounting.t - TimeAccounting testscript
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: TimeAccounting.t,v 1.9 2011-01-25 23:42:54 en Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

# declare externally defined variables to avoid errors under 'use strict'
use vars qw($Self);

use Kernel::System::TimeAccounting;
use Kernel::System::User;

my $UserObject           = Kernel::System::User->new( %{$Self} );
my $TimeAccountingObject = Kernel::System::TimeAccounting->new(
    %{$Self},
    UserID     => 1,
    UserObject => $UserObject,
);

# data for the new action (task)
my $RandomNumber  = int( rand(10000) );
my %NewActionData = (
    Action       => 'TestAction' . $RandomNumber,
    ActionStatus => 1,
);

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

# data for new user
my %UserData = (
    UserFirstname => 'Huber',
    UserLastname  => 'Manfred',
    UserLogin     => 'mhuber' . $RandomNumber,
    UserPw        => 'pass',
    UserEmail     => 'email@mydomain.com',
    ValidID       => 1,
    ChangeUserID  => 1,
);

# create test user
my $UserID = $UserObject->UserAdd(%UserData);

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

$RandomNumber = int( rand(100) );

# update user data
$Update = $TimeAccountingObject->SingleUserSettingsUpdate(
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
            DateEnd     => '2011-02-28',
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

$UserData{ValidID} = 0;
$UserData{UserID}  = $UserID;
$UserObject->UserUpdate(%UserData);
$TimeAccountingObject->SingleUserSettingsUpdate(
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

1;
