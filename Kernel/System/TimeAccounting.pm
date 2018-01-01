# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::TimeAccounting;

use strict;
use warnings;

use Kernel::System::DateTime;
use Kernel::System::VariableCheck qw( :all );

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::DateTime',
    'Kernel::System::User',
);

=head1 NAME

Kernel::System::TimeAccounting - time accounting lib

=head1 DESCRIPTION

All time accounting functions

=head1 PUBLIC INTERFACE

=head2 new()

create an object

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $TimeAccountingObject = $Kernel::OM->Get('Kernel::System::TimeAccounting');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

    $Self->{TimeZone} = $Param{TimeZone}
        || $Param{UserTimeZone}
        || $DateTimeObject->OTRSTimeZoneGet();

    return $Self;
}

=head2 UserCurrentPeriodGet()

returns a hash with the current period data of the specified user

    my %UserData = $TimeAccountingObject->UserCurrentPeriodGet(
        Year  => '2005',
        Month => '12',
        Day   => '24',
    );

The returned hash contains the following elements:

    %UserData = (
        1 => {
            UserID      => 1,
            Period      => 123,
            DateStart   => '2005-12-24',
            DateEnd     => '2005-12-24',
            WeeklyHours => 40.4,
            LeaveDays   => 12,
            OverTime    => 34,
        },
    );

=cut

sub UserCurrentPeriodGet {
    my ( $Self, %Param ) = @_;

    # check needed params
    for my $NeededParam (qw(Year Month Day)) {
        if ( !$Param{$NeededParam} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "UserCurrentPeriodGet: Need $NeededParam!",
            );

            return;
        }
    }

    # build date string for given params
    my $Date = sprintf "%04d-%02d-%02d 00:00:00", $Param{Year}, $Param{Month}, $Param{Day};

    # check cache
    if ( $Self->{'Cache::UserCurrentPeriodGet'}{$Date} ) {

        return %{ $Self->{'Cache::UserCurrentPeriodGet'}{$Date} };
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # db select
    return if !$DBObject->Prepare(
        SQL => '
            SELECT user_id, preference_period, date_start, date_end, weekly_hours, leave_days,
                overtime
            FROM time_accounting_user_period
            WHERE date_start <= ?
                AND date_end  >= ?
                AND status = ?',
        Bind => [ \$Date, \$Date, \1, ],
    );

    # fetch the data
    my %Data;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        my $UserRef = {
            UserID      => $Row[0],
            Period      => $Row[1],
            DateStart   => substr( $Row[2], 0, 10 ),
            DateEnd     => substr( $Row[3], 0, 10 ),
            WeeklyHours => $Row[4],
            LeaveDays   => $Row[5],
            Overtime    => $Row[6],
        };
        $Data{ $Row[0] } = $UserRef;
    }

    # check for valid user data
    return if !%Data;

    # store user data in cache
    $Self->{'Cache::UserCurrentPeriodGet'}{$Date} = \%Data;

    return %Data;
}

=head2 UserReporting()

returns a hash with information about leave days, overtimes,
working hours etc. of all users

    my %Data = $TimeAccountingObject->UserReporting(
        Year  => '2005',
        Month => '12',
        Day   => '12',      # Optional
    );

=cut

sub UserReporting {
    my ( $Self, %Param ) = @_;

    # get log object
    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    # check needed params
    for my $NeededParam (qw(Year Month Day)) {
        if ( !$Param{$NeededParam} && $NeededParam ne 'Day' ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "UserReporting: Need $NeededParam!"
            );

            return;
        }
    }

    # check valid date values
    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            Year  => $Param{Year},
            Month => $Param{Month},
            Day   => $Param{Day} || 1,
        },
    );

    return if !$DateTimeObject;

    # get days of month if not provided
    my $LastDayOfMonth = $DateTimeObject->LastDayOfMonthGet();
    $Param{Day} ||= $LastDayOfMonth->{Day};

    my %UserCurrentPeriod = $Self->UserCurrentPeriodGet(%Param);
    my $YearStart         = 1970;
    my $MonthStart        = 1;
    my $DayStart          = 1;
    my $YearEnd           = $Param{Year};
    my $MonthEnd          = $Param{Month};
    my $DayEnd            = $Param{Day};

    my %Data;

    USERID:
    for my $UserID ( sort keys %UserCurrentPeriod ) {

        if ( $UserCurrentPeriod{$UserID}->{DateStart} =~ m{ \A (\d{4})-(\d{2})-(\d{2}) }xms ) {
            $YearStart  = $1;
            $MonthStart = $2;
            $DayStart   = $3;
        }

        my $DateTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                Year  => $YearStart,
                Month => $MonthStart,
                Day   => $DayStart,
            },
        );

        if ( !$DateTimeObject ) {

            $LogObject->Log(
                Priority => 'notice',
                Message  => 'UserReporting: Invalid start date for user '
                    . "$UserID: $UserCurrentPeriod{$UserID}{DateStart}",
            );

            next USERID;
        }

        my %CurrentUserData = (
            LeaveDate        => 0,
            Sick             => 0,
            Overtime         => 0,
            TargetState      => 0,
            LeaveDayTotal    => 0,
            SickTotal        => 0,
            SickTotal        => 0,
            TargetStateTotal => 0,
        );

        my $Calendar = { $Self->UserGet( UserID => $UserID ) }->{Calendar};

        YEAR:
        for my $Year ( $YearStart .. $YearEnd ) {

            my $MonthStartPoint = $Year == $YearStart ? $MonthStart : 1;
            my $MonthEndPoint   = $Year == $YearEnd   ? $MonthEnd   : 12;

            MONTH:
            for my $Month ( $MonthStartPoint .. $MonthEndPoint ) {

                my $DayStartPoint =
                    $Year == $YearStart && $Month == $MonthStart
                    ? $DayStart
                    : 1
                    ;

                my $DayEndPoint;

                if ( $Year == $YearEnd && $Month == $MonthEnd ) {
                    $DayEndPoint = $DayEnd;
                }
                else {
                    $DayEndPoint = $Self->DaysInMonth( $Year, $Month );
                }

                DAY:
                for my $Day ( $DayStartPoint .. $DayEndPoint ) {

                    my %WorkingUnit = $Self->WorkingUnitsGet(
                        Year   => $Year,
                        Month  => $Month,
                        Day    => $Day,
                        UserID => $UserID,
                    );

                    my $LeaveDay    = 0;
                    my $Sick        = 0;
                    my $Overtime    = 0;
                    my $TargetState = 0;

                    if ( $WorkingUnit{LeaveDay} ) {
                        $CurrentUserData{LeaveDayTotal}++;
                        $LeaveDay = 1;
                    }
                    elsif ( $WorkingUnit{Sick} ) {
                        $CurrentUserData{SickTotal}++;
                        $Sick = 1;
                    }
                    elsif ( $WorkingUnit{Overtime} ) {
                        $CurrentUserData{OvertimeTotal}++;
                        $Overtime = 1;
                    }

                    $CurrentUserData{WorkingHoursTotal} += $WorkingUnit{Total};
                    my $VacationCheck = $Self->VacationCheck(
                        Year     => $Year,
                        Month    => $Month,
                        Day      => $Day,
                        Calendar => $Calendar || '',
                    );
                    my $Weekday = $Self->DayOfWeek( $Year, $Month, $Day );
                    if (
                        $Weekday != 6
                        && $Weekday != 7
                        && !$VacationCheck
                        && !$Sick
                        && !$LeaveDay
                        )
                    {
                        $CurrentUserData{TargetStateTotal}
                            += $UserCurrentPeriod{$UserID}{WeeklyHours} / 5;
                        $TargetState = $UserCurrentPeriod{$UserID}{WeeklyHours} / 5;
                    }

                    if ( $Month == $MonthEnd && $Year == $YearEnd ) {
                        $CurrentUserData{TargetState}  += $TargetState;
                        $CurrentUserData{WorkingHours} += $WorkingUnit{Total};
                        $CurrentUserData{LeaveDay}     += $LeaveDay;
                        $CurrentUserData{Sick}         += $Sick;
                    }
                }
            }
        }

        $CurrentUserData{Overtime}      = $CurrentUserData{WorkingHours} - $CurrentUserData{TargetState};
        $CurrentUserData{OvertimeTotal} = $UserCurrentPeriod{$UserID}{Overtime}
            + $CurrentUserData{WorkingHoursTotal}
            - $CurrentUserData{TargetStateTotal};
        $CurrentUserData{OvertimeUntil}     = $CurrentUserData{OvertimeTotal} - $CurrentUserData{Overtime};
        $CurrentUserData{LeaveDayRemaining} = $UserCurrentPeriod{$UserID}{LeaveDays} - $CurrentUserData{LeaveDayTotal};

        $Data{$UserID} = \%CurrentUserData;
    }

    return %Data;
}

=head2 ProjectSettingsGet()

returns a hash with all the projects' data

    my %ProjectData = $TimeAccountingObject->ProjectSettingsGet(
        Status => 'valid' || 'invalid', optional default valid && invalid
    );

=cut

sub ProjectSettingsGet {
    my ( $Self, %Param ) = @_;

    my $Where = '';
    if ( $Param{Status} ) {
        $Where = ' WHERE status = ';
        $Where .= $Param{Status} eq 'invalid' ? "'0'" : "'1'";
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # db select
    $DBObject->Prepare(
        SQL => "
            SELECT id, project, description, status
            FROM time_accounting_project
            $Where",
    );

    # fetch the data
    my %Data;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        my $ID = $Row[0];
        $Data{Project}{$ID}            = $Row[1];
        $Data{ProjectDescription}{$ID} = $Row[2];
        $Data{ProjectStatus}{$ID}      = $Row[3];
    }

    return %Data;
}

=head2 ProjectGet()

returns a hash with the requested project data

    my %ProjectData = $TimeAccountingObject->ProjectGet( ID => 2 );

This returns something like:

    $TimeAccountingObject = (
        Project            => 'internal',
        ProjectDescription => 'description',
        ProjectStatus      => 1,
    );

    or

    my %ProjectData = $TimeAccountingObject->ProjectGet( Project => 'internal' );

This returns something like:

    $TimeAccountingObject = (
        ID                 => 2,
        ProjectDescription => 'description',
        ProjectStatus      => 1,
    );

=cut

sub ProjectGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} && !$Param{Project} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ID or project name!'
        );

        return;
    }

    my %Project;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # look for the task data with the ID
    if ( $Param{ID} ) {

        # SQL
        return if !$DBObject->Prepare(
            SQL => '
                SELECT project, description, status
                FROM time_accounting_project
                WHERE id = ?',
            Bind => [ \$Param{ID} ],
        );
        while ( my @Data = $DBObject->FetchrowArray() ) {
            %Project = (
                ID                 => $Param{ID},
                Project            => $Data[0],
                ProjectDescription => $Data[1],
                ProjectStatus      => $Data[2],
            );
        }
    }

    # look for the task data with the task name
    else {

        # SQL
        return if !$DBObject->Prepare(
            SQL => '
                SELECT id, description, status
                FROM time_accounting_project
                WHERE project = ?',
            Bind => [ \$Param{Project} ],
        );
        while ( my @Data = $DBObject->FetchrowArray() ) {
            %Project = (
                Project            => $Param{Project},
                ID                 => $Data[0],
                ProjectDescription => $Data[1],
                ProjectStatus      => $Data[2],
            );
        }
    }

    return %Project;
}

=head2 ProjectSettingsInsert()

inserts a new project in the db

    $TimeAccountingObject->ProjectSettingsInsert(
        Project            => 'internal',    # optional
        ProjectDescription => 'description', # optional
        ProjectStatus      => 1 || 0,        # optional
    );

    returns ID of created project

=cut

sub ProjectSettingsInsert {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    $Param{Project} ||= $ConfigObject->Get('TimeAccounting::DefaultProjectName');
    $Param{ProjectDescription} ||= '';

    if ( $Param{ProjectStatus} ne '0' && $Param{ProjectStatus} ne '1' ) {
        $Param{ProjectStatus} = $ConfigObject->Get('TimeAccounting::DefaultProjectStatus');
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # insert project record
    return if !$DBObject->Do(
        SQL => '
            INSERT INTO time_accounting_project (project, description, status)
            VALUES (?, ?, ?)',
        Bind => [ \$Param{Project}, \$Param{ProjectDescription}, \$Param{ProjectStatus} ],
    );

    # get id of newly created project record
    return if !$DBObject->Prepare(
        SQL => '
            SELECT id
            FROM time_accounting_project
            WHERE project = ?',
        Bind  => [ \$Param{Project} ],
        Limit => 1,
    );

    # fetch the data
    my $ProjectID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $ProjectID = $Row[0];
    }

    return $ProjectID;
}

=head2 ProjectSettingsUpdate()

updates a project

    my $Success = $TimeAccountingObject->ProjectSettingsUpdate(
        ID                 => 123,
        Project            => 'internal',
        ProjectDescription => 'description',
        ProjectStatus      => 1,
    );

=cut

sub ProjectSettingsUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(ID Project)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );

            return;
        }
    }

    # SQL
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => '
            UPDATE time_accounting_project
            SET project = ?, description = ?, status = ?
            WHERE id = ?',
        Bind => [
            \$Param{Project}, \$Param{ProjectDescription}, \$Param{ProjectStatus}, \$Param{ID},
        ],
    );

    return 1;
}

=head2 ActionSettingsGet()

returns a hash with all the actions settings

    my %ActionData = $TimeAccountingObject->ActionSettingsGet();

=cut

sub ActionSettingsGet {
    my $Self = shift;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # db select
    return if !$DBObject->Prepare(
        SQL => '
            SELECT id, action, status
            FROM time_accounting_action',
    );

    # fetch the data
    my %Data;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Data{ $Row[0] }{Action}       = $Row[1];
        $Data{ $Row[0] }{ActionStatus} = $Row[2];
    }

    return %Data;
}

=head2 ActionGet()

returns a hash with the requested action (task) data

    my %ActionData = $TimeAccountingObject->ActionGet( ID => 2 );

This returns something like:

    $TimeAccountingObject = (
        Action       => 'My task',
        ActionStatus => 1,
    );

    or

    my %ActionData = $TimeAccountingObject->ActionGet( Action => 'My task' );

This returns something like:

    $TimeAccountingObject = (
        ID           => 2,
        ActionStatus => 1,
    );

=cut

sub ActionGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} && !$Param{Action} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ID or Action!'
        );

        return;
    }

    my %Task;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # look for the task data with the ID
    if ( $Param{ID} ) {

        # SQL
        return if !$DBObject->Prepare(
            SQL => '
                SELECT action, status
                FROM time_accounting_action
                WHERE id = ?',
            Bind => [ \$Param{ID} ],
        );
        while ( my @Data = $DBObject->FetchrowArray() ) {
            %Task = (
                ID           => $Param{ID},
                Action       => $Data[0],
                ActionStatus => $Data[1],
            );
        }
    }

    # look for the task data with the task name
    else {

        # SQL
        return if !$DBObject->Prepare(
            SQL => '
                SELECT id, status
                FROM time_accounting_action
                WHERE action = ?',
            Bind => [ \$Param{Action} ],
        );
        while ( my @Data = $DBObject->FetchrowArray() ) {
            %Task = (
                Action       => $Param{Action},
                ID           => $Data[0],
                ActionStatus => $Data[1],
            );
        }
    }

    return %Task;
}

=head2 ActionSettingsInsert()

inserts a new action in the db

    $TimeAccountingObject->ActionSettingsInsert(
        Action       => 'meeting',   # optional
        ActionStatus => 1 || 0,      # optional
    );

=cut

sub ActionSettingsInsert {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    $Param{Action} ||= $ConfigObject->Get('TimeAccounting::DefaultActionName') || '';
    if ( $Param{ActionStatus} ne '0' && $Param{ActionStatus} ne '1' ) {
        $Param{ActionStatus} = $ConfigObject->Get('TimeAccounting::DefaultActionStatus');
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # db insert
    return if !$DBObject->Do(
        SQL => '
            INSERT INTO time_accounting_action (action, status)
            VALUES (?, ?)',
        Bind => [ \$Param{Action}, \$Param{ActionStatus}, ],
    );

    return 1;
}

=head2 ActionSettingsUpdate()

updates an action (task)

    my $Success = $TimeAccountingObject->ActionSettingsUpdate(
        ActionID     => 123,
        Action       => 'internal',
        ActionStatus => 1,
    );

=cut

sub ActionSettingsUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(ActionID Action)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );

            return;
        }
    }

    # SQL
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => '
            UPDATE time_accounting_action
            SET action = ?, status = ?
            WHERE id = ?',
        Bind => [
            \$Param{Action}, \$Param{ActionStatus}, \$Param{ActionID}
        ],
    );

    return 1;
}

=head2 UserList()

returns a hash with the user data of all users

    my %UserData = $TimeAccountingObject->UserList();

=cut

sub UserList {
    my $Self = shift;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # db select
    $DBObject->Prepare(
        SQL => '
            SELECT user_id, description, show_overtime, create_project, calendar
            FROM time_accounting_user',
    );

    # fetch the data
    my %Data;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Data{ $Row[0] }{UserID}        = $Row[0];
        $Data{ $Row[0] }{Description}   = $Row[1];
        $Data{ $Row[0] }{ShowOvertime}  = $Row[2];
        $Data{ $Row[0] }{CreateProject} = $Row[3];
        $Data{ $Row[0] }{Calendar}      = $Row[4];
    }

    return %Data;
}

=head2 UserGet()

returns a hash with the user data of one user

    my %UserData = $TimeAccountingObject->UserGet(
        UserID => 15,
    );

=cut

sub UserGet {
    my ( $Self, %Param ) = @_;

    # check needed data
    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'UserGet: Need UserID!',
        );

        return;
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # db select
    $DBObject->Prepare(
        SQL => '
            SELECT description, show_overtime, create_project, calendar
            FROM time_accounting_user
            WHERE user_id = ?',
        Bind => [ \$Param{UserID} ],
    );

    # fetch the data
    my %Data;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Data{UserID}        = $Param{UserID};
        $Data{Description}   = $Row[0];
        $Data{ShowOvertime}  = $Row[1];
        $Data{CreateProject} = $Row[2];
        $Data{Calendar}      = $Row[3];
    }

    return %Data;
}

=head2 UserSettingsGet()

returns a hash with the complete user period data for all users

    my %UserData = $TimeAccountingObject->UserSettingsGet();

returns:
    %UserData = (
        3 => {
            1 => {
                DateEnd     => "2015-12-31",
                DateStart   => "2015-01-01",
                LeaveDays   => "23.00",
                Overtime    => "0.00",
                Period      => 1,
                UserID      => 3,
                UserStatus  => 1,
                WeeklyHours => "40.00",
            },
            2 => {
                DateEnd     => "2015-12-31",
                DateStart   => "2015-01-01",
                LeaveDays   => "23.00",
                Overtime    => "0.00",
                Period      => 2,
                UserID      => 3,
                UserStatus  => 1,
                WeeklyHours => "32.00",
            },
        },
        4 => {
            1 => {
                DateEnd     => "2015-12-31",
                DateStart   => "2015-01-01",
                LeaveDays   => "23.00",
                Overtime    => "0.00",
                Period      => 1,
                UserID      => 4,
                UserStatus  => 1,
                WeeklyHours => "40.00",
            },
        },
    };

=cut

sub UserSettingsGet {
    my $Self = shift;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # db select
    $DBObject->Prepare(
        SQL => '
            SELECT user_id, preference_period, date_start, date_end, weekly_hours, leave_days,
                overtime, status
            FROM time_accounting_user_period'
    );

    # fetch the data
    my %Data;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Data{ $Row[0] }{ $Row[1] }{UserID}      = $Row[0];
        $Data{ $Row[0] }{ $Row[1] }{Period}      = $Row[1];
        $Data{ $Row[0] }{ $Row[1] }{DateStart}   = substr( $Row[2], 0, 10 );
        $Data{ $Row[0] }{ $Row[1] }{DateEnd}     = substr( $Row[3], 0, 10 );
        $Data{ $Row[0] }{ $Row[1] }{WeeklyHours} = $Row[4];
        $Data{ $Row[0] }{ $Row[1] }{LeaveDays}   = $Row[5];
        $Data{ $Row[0] }{ $Row[1] }{Overtime}    = $Row[6];
        $Data{ $Row[0] }{ $Row[1] }{UserStatus}  = $Row[7];
    }

    return %Data;
}

=head2 SingleUserSettingsGet()

returns a hash with the requested user's period data

    my %UserData = $TimeAccountingObject->SingleUserSettingsGet( UserID => 1 );

=cut

sub SingleUserSettingsGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need UserID!'
        );

        return;
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # db select
    $DBObject->Prepare(
        SQL => '
            SELECT user_id, preference_period, date_start, date_end, weekly_hours, leave_days,
                overtime, status
            FROM time_accounting_user_period WHERE user_id = ?',
        Bind => [ \$Param{UserID} ],
    );

    # fetch the data
    my %UserData;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $UserData{ $Row[1] }{UserID}      = $Row[0];
        $UserData{ $Row[1] }{Period}      = $Row[1];
        $UserData{ $Row[1] }{DateStart}   = substr( $Row[2], 0, 10 );
        $UserData{ $Row[1] }{DateEnd}     = substr( $Row[3], 0, 10 );
        $UserData{ $Row[1] }{WeeklyHours} = $Row[4];
        $UserData{ $Row[1] }{LeaveDays}   = $Row[5];
        $UserData{ $Row[1] }{Overtime}    = $Row[6];
        $UserData{ $Row[1] }{UserStatus}  = $Row[7];
    }

    return %UserData;
}

=head2 UserLastPeriodNumberGet()

returns the number of the last registered period for the specified user

    my $LastPeriodNumber = $TimeAccountingObject->UserLastPeriodNumberGet( UserID => 1 );

=cut

sub UserLastPeriodNumberGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need UserID!'
        );

        return;
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # db select
    $DBObject->Prepare(
        SQL => '
            SELECT max(preference_period)
            FROM time_accounting_user_period
            WHERE user_id = ?',
        Bind => [ \$Param{UserID} ],
    );

    # fetch the data
    my @Row = $DBObject->FetchrowArray();
    my $LastPeriodNumber = $Row[0] || 0;

    return $LastPeriodNumber;
}

=head2 UserSettingsInsert()

insert new user data in the db

    $TimeAccountingObject->UserSettingsInsert(
        UserID       => '2',
        Period       => '2',
    );

=cut

sub UserSettingsInsert {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw (UserID Period)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed"
            );

            return;
        }
    }

    # check if user exists
    if ( !$Kernel::OM->Get('Kernel::System::User')->UserLookup( UserID => $Param{UserID} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "UserID $Param{UserID} does not exist!"
        );

        return;
    }

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    $Param{WeeklyHours} = $ConfigObject->Get('TimeAccounting::DefaultUserWeeklyHours')
        || '40';
    $Param{LeaveDays}  = $ConfigObject->Get('TimeAccounting::DefaultUserLeaveDays') || '25';
    $Param{UserStatus} = $ConfigObject->Get('TimeAccounting::DefaultUserStatus')    || '1';
    $Param{Overtime}   = $ConfigObject->Get('TimeAccounting::DefaultUserOvertime')  || '0';
    $Param{DateEnd}    = $ConfigObject->Get('TimeAccounting::DefaultUserDateEnd')
        || '2017-12-31';
    $Param{DateStart} = $ConfigObject->Get('TimeAccounting::DefaultUserDateStart')
        || '2017-01-01';
    $Param{Description} = $ConfigObject->Get('TimeAccounting::DefaultUserDescription')
        || 'Put your description here.';

    $Param{DateStart} .= ' 00:00:00';
    $Param{DateEnd}   .= ' 00:00:00';

    # delete cache
    delete $Self->{'Cache::UserCurrentPeriodGet'};

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # db insert
    return if !$DBObject->Do(
        SQL => '
            INSERT INTO time_accounting_user_period (user_id, preference_period, date_start,
                date_end, weekly_hours, leave_days, overtime, status)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
        Bind => [
            \$Param{UserID},      \$Param{Period},    \$Param{DateStart}, \$Param{DateEnd},
            \$Param{WeeklyHours}, \$Param{LeaveDays}, \$Param{Overtime},  \$Param{UserStatus},
        ],
    );

    # select UserID
    $DBObject->Prepare(
        SQL => '
            SELECT user_id
            FROM time_accounting_user
            WHERE user_id = ?',
        Bind  => [ \$Param{UserID}, ],
        Limit => 1,
    );

    # fetch the data
    my $UserID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $UserID = $Row[0];
    }

    if ( !defined $UserID ) {

        # db insert
        return if !$DBObject->Do(
            SQL => '
                INSERT INTO time_accounting_user (user_id, description)
                VALUES (?, ?)',
            Bind => [ \$Param{UserID}, \$Param{Description}, ],
        );
    }

    return 1;
}

=head2 UserSettingsUpdate()

updates user data in the db

    $TimeAccountingObject->UserSettingsUpdate(
        UserID        => 1,
        Description   => 'Some Text',
        CreateProject => 1 || 0,
        ShowOvertime  => 1 || 0,
        Period        => {
            1 => {
                DateStart    => '2015-12-12',
                DateEnd      => '2015-12-31',
                WeeklyHours  => '38',
                LeaveDays    => '25',
                Overtime     => '38',
                UserStatus   => 1 || 0,
            },
            2 => {
                DateStart    => '2015-12-12',
                DateEnd      => '2015-12-31',
                WeeklyHours  => '38',
                LeaveDays    => '25',
                Overtime     => '38',
                UserStatus   => 1 || 0,
            },
            3 => ......
        }
    );

=cut

sub UserSettingsUpdate {
    my ( $Self, %Param ) = @_;

    # delete cache
    delete $Self->{'Cache::UserCurrentPeriodGet'};

    my $UserID = $Param{UserID};

    if ( !defined $Param{Period}->{1}{DateStart} && !defined $Param{Period}->{1}{DateEnd} ) {

        return $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "UserSettingUpdate: No data for user id $UserID!"
        );
    }

    # set default values
    $Param{ShowOvertime}  ||= 0;
    $Param{CreateProject} ||= 0;
    $Param{Calendar}      ||= 0;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # db insert
    return if !$DBObject->Do(
        SQL => '
            UPDATE time_accounting_user
            SET description = ?, show_overtime = ?, create_project = ?, calendar = ?
            WHERE user_id = ?',
        Bind => [
            \$Param{Description}, \$Param{ShowOvertime},
            \$Param{CreateProject}, \$Param{Calendar}, \$Param{UserID}
        ],
    );

    # update all periods
    for my $Period ( sort keys %{ $Param{Period} } ) {

        # db insert
        return if !$DBObject->Do(
            SQL => '
                UPDATE time_accounting_user_period
                SET leave_days = ?, date_start = ?, date_end = ?, overtime = ?, weekly_hours = ?,
                    status = ?
                WHERE user_id = ?
                    AND preference_period = ?',
            Bind => [
                \$Param{Period}->{$Period}{LeaveDays},   \$Param{Period}->{$Period}{DateStart},
                \$Param{Period}->{$Period}{DateEnd},     \$Param{Period}->{$Period}{Overtime},
                \$Param{Period}->{$Period}{WeeklyHours}, \$Param{Period}->{$Period}{UserStatus},
                \$UserID, \$Period,
                ]
        );
    }

    return 1;
}

=head2 WorkingUnitsCompletnessCheck()

returns a hash with the incomplete working days and
the information if the incomplete working days are in the allowed
range.

    my %WorkingUnitsCheck = $TimeAccountingObject->WorkingUnitsCompletnessCheck(
        UserID => 123,
    );

=cut

sub WorkingUnitsCompletnessCheck {
    my ( $Self, %Param ) = @_;

    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need UserID"
        );

        return;
    }

    my %Data                = ();
    my $WorkingUnitID       = 0;
    my %CompleteWorkingDays = ();

    # get time object
    my $DateTimeObject   = $Kernel::OM->Create('Kernel::System::DateTime');
    my $DateTimeSettings = $DateTimeObject->Get();

    my ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = (
        $DateTimeSettings->{Second},
        $DateTimeSettings->{Minute},
        $DateTimeSettings->{Hour},
        $DateTimeSettings->{Day},
        $DateTimeSettings->{Month},
        $DateTimeSettings->{Year},
    );

    my $UserID = $Param{UserID};

    # TODO: Search only in the CurrentUserPeriod
    # TODO: Search only working units where action_id and project_id is true

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    $DBObject->Prepare(
        SQL => '
            SELECT DISTINCT time_start
            FROM time_accounting_table
            WHERE user_id = ?',
        Bind => [ \$UserID ],
    );

    # fetch the data
    while ( my @Row = $DBObject->FetchrowArray() ) {
        if ( $Row[0] =~ /^(\d+)-(\d+)-(\d+)/ ) {
            $CompleteWorkingDays{$1}{$2}{$3} = 1;
        }
    }

    my %UserCurrentPeriod = $Self->UserCurrentPeriodGet(
        Year  => $Year,
        Month => $Month,
        Day   => $Day,
    );

    my $WorkingDays = 0;
    my $YearStart   = 1970;
    my $MonthStart  = 1;
    my $DayStart    = 1;
    my $YearEnd     = $Year;
    my $MonthEnd    = $Month;
    my $DayEnd      = $Day;

    if (
        $UserCurrentPeriod{$UserID}->{DateStart}
        && $UserCurrentPeriod{$UserID}->{DateStart} =~ /^(\d+)-(\d+)-(\d+)/
        )
    {
        $YearStart  = $1;
        $MonthStart = $2;
        $DayStart   = $3;
    }

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $Calendar = { $Self->UserGet( UserID => $UserID ) }->{Calendar};

    for my $Year ( $YearStart .. $YearEnd ) {

        my $MonthStartPoint = $Year == $YearStart ? $MonthStart : 1;
        my $MonthEndPoint   = $Year == $YearEnd   ? $MonthEnd   : 12;

        for my $Month ( $MonthStartPoint .. $MonthEndPoint ) {

            my $DayStartPoint = $Year == $YearStart && $Month == $MonthStart ? $DayStart : 1;

            my $DayEndPoint;
            if ( $Year == $YearEnd && $Month == $MonthEnd ) {
                $DayEndPoint = $DayEnd;
            }
            else {
                $DayEndPoint = $Self->DaysInMonth( $Year, $Month );
            }

            my $MonthString = sprintf "%02d", $Month;

            for my $Day ( $DayStartPoint .. $DayEndPoint ) {

                my $VacationCheck = $Self->VacationCheck(
                    Year     => $Year,
                    Month    => $Month,
                    Day      => $Day,
                    Calendar => $Calendar || '',
                );

                # Get calendar timezone or use the one of time-accounting object.
                my $TimeZone = $ConfigObject->Get( "TimeZone::Calendar" . ( $Calendar || '' ) )
                    || $Self->{TimeZone};

                my $DayStartTime = $Kernel::OM->Create(
                    'Kernel::System::DateTime',
                    ObjectParams => {
                        Year     => $Year,
                        Month    => $Month,
                        Day      => $Day,
                        Hour     => 0,
                        Minute   => 0,
                        Second   => 0,
                        TimeZone => $TimeZone,
                    },
                );

                my $DayStopTime = $DayStartTime->Clone();
                $DayStopTime->Set(
                    Hour   => 23,
                    Minute => 59,
                    Second => 59,
                );

                # Convert to the timezone of time-accounting object.
                $DayStartTime->ToTimeZone(
                    TimeZone => $Self->{TimeZone},
                );
                $DayStopTime->ToTimeZone(
                    TimeZone => $Self->{TimeZone},
                );

                # Convert to epochs.
                $DayStartTime = $DayStartTime->ToEpoch();
                $DayStopTime  = $DayStopTime->ToEpoch();

                # OLD CODE

                #my $DateTimeObject = $Kernel::OM->Create(
                #    'Kernel::System::DateTime',
                #    ObjectParams => {
                #        Year  => $Year,
                #        Month => $Month,
                #        Day   => $Day,
                #    },
                #);

                #my $Date = sprintf "%04d-%02d-%02d", $Year, $Month, $Day;

                #my $DateTimeObjectStart = $Kernel::OM->Create(
                #    'Kernel::System::DateTime',
                #    ObjectParams => {
                #        String => $Date . ' 00:00:00',
                #    },
                #);
                #my $DayStartTime = $DateTimeObjectStart->ToEpoch();

                #my $DateTimeObjectStop = $Kernel::OM->Create(
                #    'Kernel::System::DateTime',
                #    ObjectParams => {
                #        String => $Date . ' 23:59:59',
                #    },
                #);
                #my $DayStopTime = $DateTimeObjectStop->ToEpoch();

                # add time zone to calculation
                #my $Zone = $ConfigObject->Get( "TimeZone::Calendar" . ( $Calendar || '' ) );
                #if ($Zone) {
                #    my $ZoneSeconds = $Zone * 60 * 60;
                #    $DayStartTime = $DayStartTime - $ZoneSeconds;
                #    $DayStopTime  = $DayStopTime - $ZoneSeconds;
                #}

                # END

                my $ThisDayWorkingTime = $Self->WorkingTime(
                    StartTime => $DayStartTime,
                    StopTime  => $DayStopTime,
                    Calendar  => $Calendar || '',
                ) || '0';

                my $DayString = sprintf "%02d", $Day;

                if ( $ThisDayWorkingTime && !$VacationCheck ) {
                    $WorkingDays += 1;
                }
                if (
                    $ThisDayWorkingTime
                    && !$VacationCheck
                    && !$CompleteWorkingDays{$Year}{$MonthString}{$DayString}
                    )
                {
                    $Data{Incomplete}{$Year}{$MonthString}{$DayString} = $WorkingDays;
                }
            }
        }
    }
    my $MaxIntervallOfIncompleteDays = $ConfigObject->Get('TimeAccounting::MaxIntervalOfIncompleteDays') || '5';
    my $MaxIntervallOfIncompleteDaysBeforeWarning
        = $ConfigObject->Get('TimeAccounting::MaxIntervalOfIncompleteDaysBeforeWarning')
        || '3';
    for my $Year ( sort keys %{ $Data{Incomplete} } ) {

        for my $Month ( sort keys %{ $Data{Incomplete}{$Year} } ) {

            for my $Day ( sort keys %{ $Data{Incomplete}{$Year}{$Month} } ) {

                if (
                    $Data{Incomplete}{$Year}{$Month}{$Day}
                    < $WorkingDays - $MaxIntervallOfIncompleteDays
                    )
                {
                    $Data{EnforceInsert} = 1;
                }
                elsif (
                    $Data{Incomplete}{$Year}{$Month}{$Day}
                    < $WorkingDays - $MaxIntervallOfIncompleteDaysBeforeWarning
                    )
                {
                    $Data{Warning} = 1;
                }
            }
        }
    }

    return %Data;
}

=head2 WorkingUnitsGet()

returns a hash with the working units data

    my %WorkingUnitsData = $TimeAccountingObject->WorkingUnitsGet(
        Year   => '2005',
        Month  => '7',
        Day    => '13',
        UserID => '123',
    );

=cut

sub WorkingUnitsGet {
    my ( $Self, %Param ) = @_;

    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need UserID"
        );

        return;
    }

    my $Date      = sprintf "%04d-%02d-%02d", $Param{Year}, $Param{Month}, $Param{Day};
    my $DateStart = $Date . " 00:00:00";
    my $DateStop  = $Date . " 23:59:59";

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # ask the database
    $DBObject->Prepare(
        SQL => '
            SELECT user_id, project_id, action_id, remark, time_start, time_end, period
            FROM time_accounting_table
            WHERE time_start >= ?
                AND time_start <= ?
                AND user_id = ?
            ORDER by id',
        Bind => [ \$DateStart, \$DateStop, \$Param{UserID} ],
    );

    my %Data = (
        Total => 0,
        Date  => $Date,
    );

    # fetch the result
    ROW:
    while ( my @Row = $DBObject->FetchrowArray() ) {

        next ROW if $Row[4] !~ m{^ (.+?) \s (\d+:\d+) : (\d+) }xms;

        # check if it is a special working unit
        if ( $Row[1] == -1 ) {
            my $ActionID = $Row[2];

            $Data{Sick}     = $ActionID == -1 ? 1 : 0;
            $Data{LeaveDay} = $ActionID == -2 ? 1 : 0;
            $Data{Overtime} = $ActionID == -3 ? 1 : 0;

            next ROW;
        }

        my $StartTime = $2;
        my $EndTime   = '';
        if ( $Row[5] =~ m{^(.+?)\s(\d+:\d+):(\d+)}xms ) {
            $EndTime = $2;

            # replace 23:59:59 with 24:00
            if ( $EndTime eq '23:59' && $3 eq '59' ) {
                $EndTime = '24:00';
            }
        }

        my %WorkingUnit = (
            UserID    => $Row[0],
            ProjectID => $Row[1],
            ActionID  => $Row[2],
            Remark    => $Row[3],
            StartTime => $StartTime,
            EndTime   => $EndTime,
            Period    => defined( $Row[6] ) ? sprintf( "%.2f", $Row[6] ) : 0,
        );

        # only count complete working units
        if ( $Row[1] && $Row[2] ) {
            $Data{Total} += $WorkingUnit{Period};
        }

        push @{ $Data{WorkingUnits} }, \%WorkingUnit;
    }

    return %Data;
}

=head2 WorkingUnitsInsert()

insert working units in the db

    $TimeAccountingObject->WorkingUnitsInsert(
        Year  => '2005',
        Month => '07',
        Day   => '02',
        LeaveDay => 1, || 0
        Sick     => 1, || 0
        Overtime => 1, || 0
        WorkingUnits => [
            {
                ProjectID => 1,
                ActionID  => 23,
                Remark    => 'SomeText',
                StartTime => '7:30',
                EndTime   => '11:00',
                Period    => '8.5',
            },
            { ...... },
        ],
        UserID => 123,
    );

=cut

sub WorkingUnitsInsert {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Year Month Day UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "WorkingUnitsInsert: Need $Needed!"
            );

            return;
        }
    }

    my $Date = sprintf "%04d-%02d-%02d", $Param{Year}, $Param{Month}, $Param{Day};

    # add special time working units
    my %SpecialAction = (
        'Sick'     => '-1',
        'LeaveDay' => '-2',
        'Overtime' => '-3',
    );

    ELEMENT:
    for my $Element (qw(LeaveDay Sick Overtime)) {

        next ELEMENT if !$Param{$Element};

        my %Unit = (
            ProjectID => -1,
            ActionID  => $SpecialAction{$Element},
            Remark    => '',
            StartTime => '',
            EndTime   => '',
            Period    => 0,
        );

        push @{ $Param{WorkingUnits} }, \%Unit;
    }

    # insert new working units
    UNITREF:
    for my $UnitRef ( @{ $Param{WorkingUnits} } ) {

        my $StartTime = $Date . ' ' . ( $UnitRef->{StartTime} || '00:00' ) . ':00';
        my $EndTime   = $Date . ' ' . ( $UnitRef->{EndTime}   || '00:00' ) . ':00';

        # '' does not work in integer field of PostgreSQL
        $UnitRef->{ProjectID} ||= 0;
        $UnitRef->{ActionID}  ||= 0;
        $UnitRef->{Period}    ||= 0;

        # build DQL
        my $SQL = '
            INSERT INTO time_accounting_table (user_id, project_id, action_id, remark, time_start,
                time_end, period, created )
            VALUES  ( ?, ?, ?, ?, ?, ?, ?, current_timestamp)';
        my $Bind = [
            \$Param{UserID}, \$UnitRef->{ProjectID}, \$UnitRef->{ActionID},
            \$UnitRef->{Remark}, \$StartTime, \$EndTime, \$UnitRef->{Period},
        ];

        # db insert
        return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
            SQL  => $SQL,
            Bind => $Bind
        );
    }

    return 1;
}

=head2 WorkingUnitsDelete()

deletes working units in the db

    $TimeAccountingObject->WorkingUnitsDelete(
        Year   => '2015',
        Month  => '7',
        Day    => '13',
        UserID => 123,
    );

=cut

sub WorkingUnitsDelete {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Year Month Day UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "WorkingUnitsInsert: Need $Needed!"
            );

            return;
        }
    }

    my $Date      = sprintf "%04d-%02d-%02d", $Param{Year}, $Param{Month}, $Param{Day};
    my $StartTime = $Date . ' 00:00:00';
    my $EndTime   = $Date . ' 23:59:59';

    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => '
            DELETE FROM time_accounting_table
            WHERE time_start >= ?
                AND time_start <= ?
                AND user_id = ?',
        Bind => [ \$StartTime, \$EndTime, \$Param{UserID}, ],
    );

    return 1;
}

=head2 ProjectActionReporting()

returns a hash with the hours dependent project and action data

    my %ProjectData = $TimeAccountingObject->ProjectActionReporting(
        Year  => 2005,
        Month => 7,
        UserID => 123, # optional; no UserID means 'of all users'
    );

=cut

sub ProjectActionReporting {
    my ( $Self, %Param ) = @_;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    for my $Parameter (qw(Year Month)) {
        $Param{$Parameter} = $DBObject->Quote( $Param{$Parameter} ) || '';
        if ( !$Param{$Parameter} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "ProjectActionReporting: Need $Parameter!"
            );

            return;
        }
    }

    # hours per month
    my $DaysInMonth = $Self->DaysInMonth( $Param{Year}, $Param{Month} );
    my $DateString = $Param{Year} . "-" . sprintf( "%02d", $Param{Month} );
    my $SQLDate = "$DateString-$DaysInMonth 23:59:59";

    my $SQL = '
        SELECT project_id, action_id, period
        FROM time_accounting_table
        WHERE project_id != -1
            AND time_start <= ?';
    my @Bind = ( \$SQLDate );

    if ( $Param{UserID} ) {
        $SQL .= ' AND user_id = ?';
        push @Bind, \$Param{UserID};
    }

    # total hours
    $DBObject->Prepare(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    # fetch the data
    my %Data;
    ROW:
    while ( my @Row = $DBObject->FetchrowArray() ) {

        next ROW if !$Row[2];

        $Data{ $Row[0] }->{Actions}->{ $Row[1] }->{Total} += $Row[2];
    }

    my $SQLDateStart = "$DateString-01 00:00:00";

    $SQL = '
        SELECT project_id, action_id, period
        FROM time_accounting_table
        WHERE project_id != -1
            AND time_start >= ?
            AND time_start <= ?';
    @Bind = ( \$SQLDateStart, \$SQLDate );

    if ( $Param{UserID} ) {
        $SQL .= ' AND user_id = ?';
        push @Bind, \$Param{UserID};
    }

    $DBObject->Prepare(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    # fetch the data
    ROW:
    while ( my @Row = $DBObject->FetchrowArray() ) {

        next ROW if !$Row[2];

        $Data{ $Row[0] }->{Actions}->{ $Row[1] }->{PerMonth} += $Row[2];
    }

    # add readable components
    my %Project = $Self->ProjectSettingsGet();
    my %Action  = $Self->ActionSettingsGet();

    for my $ProjectID ( sort keys %Data ) {

        $Data{$ProjectID}->{Name}        = $Project{Project}->{$ProjectID} || '';
        $Data{$ProjectID}->{Status}      = $Project{ProjectStatus}->{$ProjectID};
        $Data{$ProjectID}->{Description} = $Project{ProjectDescription}->{$ProjectID};

        my $ActionsRef = $Data{$ProjectID}->{Actions};

        for my $ActionID ( sort keys %{$ActionsRef} ) {
            $Data{$ProjectID}->{Actions}->{$ActionID}->{Name} = $Action{$ActionID}->{Action} || '';
        }
    }

    return %Data;
}

=head2 ProjectTotalHours()

returns the sum of all hours related to a project

    my $ProjectTotalHours = $TimeAccountingObject->ProjectTotalHours(
        ProjectID  => 15,
    );

=cut

sub ProjectTotalHours {
    my ( $Self, %Param ) = @_;

    # check needed param
    if ( !$Param{ProjectID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'ProjectActionReporting: Need ProjectID!'
        );

        return;
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # ask the database
    return if !$DBObject->Prepare(
        SQL => '
            SELECT SUM(period)
            FROM time_accounting_table
            WHERE project_id = ?',
        Bind  => [ \$Param{ProjectID} ],
        Limit => 1,
    );

    # fetch the result
    my $Total = 0;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Total = $Row[0];
    }

    return $Total;
}

=head2 ProjectHistory()

returns an array with all WorkingUnits related to a project

    my @ProjectHistoryArray = $TimeAccountingObject->ProjectHistory(
        ProjectID  => 15,
    );

This would return

    @ProjectHistoryArray = (
        {
            ID        => 999,
            UserID    => 15,
            User      => 'Tom',
            ActionID  => 6,
            Action    => 'misc',
            Remark    => 'remark',
            TimeStart => '7:00',
            TimeEnd   => '18:00',
            Date      => '2008-10-31', # the date of the working unit
            Period    => 11,
            Created   => '2008-11-01', # the insert time of the working unit
        },
        {
            ID        => 999,
            UserID    => 16,
            User      => 'Mane',
            ActionID  => 7,
            Action    => 'development',
            Remark    => 'remark',
            TimeStart => '7:00',
            TimeEnd   => '18:00',
            Period    => 11,
            Date      => '2008-11-03',
            Created   => '2008-11-03',
        }
    );

=cut

sub ProjectHistory {
    my ( $Self, %Param ) = @_;

    # check needed param
    if ( !$Param{ProjectID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'ProjectActionReporting: Need ProjectID!',
        );
        return;
    }

    # call action data to get the readable name of the action
    my %ActionData = $Self->ActionSettingsGet();

    # get user list
    my %ShownUsers = $Kernel::OM->Get('Kernel::System::User')->UserList(
        Type  => 'Long',
        Valid => 0,
    );

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # ask the database
    $DBObject->Prepare(
        SQL => '
            SELECT id, user_id, action_id, remark, time_start, time_end, period, created
            FROM time_accounting_table
            WHERE project_id = ?
            ORDER BY time_start',
        Bind => [ \$Param{ProjectID} ],
    );

    # fetch the result
    my @Data;
    while ( my @Row = $DBObject->FetchrowArray() ) {

        my $UserRef = {
            ID        => $Row[0],
            UserID    => $Row[1],
            User      => $ShownUsers{ $Row[1] },
            ActionID  => $Row[2],
            Action    => $ActionData{ $Row[2] }{Action},
            Remark    => $Row[3] || '',
            TimeStart => $Row[4],
            TimeEnd   => $Row[5],
            Date      => $Row[4],
            Period    => $Row[6],
            Created   => $Row[7],
        };
        $UserRef->{Date} =~ s{(\d\d\d\d-\d\d-\d\d) \s .+ }{$1}xms;

        push @Data, $UserRef;
    }

    return @Data;
}

=head2 LastProjectsOfUser()

returns an array with the last projects of the current user

    my @LastProjects = $TimeAccountingObject->LastProjectsOfUser(
        UserID => 123,
    );

=cut

sub LastProjectsOfUser {
    my ( $Self, %Param ) = @_;

    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need UserID"
        );

        return;
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # db select
    # I don't use distinct because of ORDER BY problems of PostgreSQL
    return if !$DBObject->Prepare(
        SQL => '
            SELECT project_id FROM time_accounting_table
            WHERE user_id = ?
                AND project_id <> -1
            ORDER BY time_start DESC',
        Bind  => [ \$Param{UserID} ],
        Limit => 40,
    );

    # fetch the result
    my %Projects;
    my $Counter = 0;
    ROW:
    while ( my @Row = $DBObject->FetchrowArray() ) {

        next ROW if $Counter > 7;
        next ROW if $Projects{ $Row[0] };

        $Projects{ $Row[0] } = 1;
        $Counter++;
    }

    return keys %Projects;
}

=head2 DayOfWeek()

Substitute for Date::Pcalc::Day_of_Week() which uses Kernel::System::DateTime.

=cut

sub DayOfWeek {
    my ( $Self, $Year, $Month, $Day ) = @_;

    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            Year     => $Year,
            Month    => $Month,
            Day      => $Day,
            TimeZone => 'floating',
        },
    );

    if ( !$DateTimeObject ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => "error",
            Message  => "Error creating DateTime object.",
        );

        return;
    }

    my $DateTimeValues = $DateTimeObject->Get();

    return $DateTimeValues->{DayOfWeek};
}

=head2 AddDeltaYMD()

Substitute for Date::Pcalc::Add_Delta_YMD() which uses Kernel::System::DateTime.

=cut

sub AddDeltaYMD {
    my ( $Self, $Year, $Month, $Day, $YearsToAdd, $MonthsToAdd, $DaysToAdd ) = @_;

    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            Year     => $Year,
            Month    => $Month,
            Day      => $Day,
            TimeZone => 'floating',
        },
    );

    if ( !$DateTimeObject ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => "error",
            Message  => "Error creating DateTime object.",
        );

        return ( $Year, $Month, $Day, );
    }

    $DateTimeObject->Add(
        Years  => $YearsToAdd  || 0,
        Months => $MonthsToAdd || 0,
        Days   => $DaysToAdd   || 0,
    );
    my $DateTimeValues = $DateTimeObject->Get();

    return (
        $DateTimeValues->{Year},
        $DateTimeValues->{Month},
        $DateTimeValues->{Day},
    );
}

=head2 DaysInMonth()

Substitute for Date::Pcalc::Days_in_Month() which uses Kernel::System::DateTime.

=cut

sub DaysInMonth {
    my ( $Self, $Year, $Month ) = @_;

    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            Year     => $Year,
            Month    => $Month,
            Day      => 1,
            TimeZone => 'floating',
        },
    );

    if ( !$DateTimeObject ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => "error",
            Message  => "Error creating DateTime object.",
        );

        return;
    }

    my $LastDayOfMonth = $DateTimeObject->LastDayOfMonthGet();

    return $LastDayOfMonth->{Day};
}

=head2 VacationCheck()

check if the selected day is a vacation (it does not matter if you
insert 01 or 1 for month or day in the function or in the SysConfig)

returns (true) vacation day if exists, returns false if date is no
vacation day

    $TimeAccountingObject->VacationCheck(
        Year     => 2005,
        Month    => 7 || '07',
        Day      => 13,
    );

    $TimeAccountingObject->VacationCheck(
        Year     => 2005,
        Month    => 7 || '07',
        Day      => 13,
        Calendar => 3, # '' is default; 0 is handled like ''
    );

=cut

sub VacationCheck {
    my ( $Self, %Param ) = @_;

    # check required params
    for (qw(Year Month Day)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "VacationCheck: Need $_!",
            );
            return;
        }
    }

    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            %Param,
            TimeZone => $Self->{TimeZone},
        },
    );
    if ( !$DateTimeObject ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Error creating DateTime object.",
        );
        return;
    }

    return $DateTimeObject->IsVacationDay(
        Calendar => $Param{Calendar},
    );
}

=head2 WorkingTime()

get the working time in seconds between these local system times.

    my $WorkingTime = $TimeAccountingObject->WorkingTime(
        StartTime => $Created,
        StopTime  => $TimeObject->SystemTime(),
    );

    my $WorkingTime = $TimeAccountingObject->WorkingTime(
        StartTime => $Created,
        StopTime  => $TimeObject->SystemTime(),
        Calendar  => 3, # '' is default
    );

=cut

sub WorkingTime {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(StartTime StopTime)) {
        if ( !defined $Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }

    return 0 if $Param{StartTime} >= $Param{StopTime};

    my $StartDateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            Epoch    => $Param{StartTime},
            TimeZone => $Self->{TimeZone},
        },
    );

    my $StopDateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            Epoch    => $Param{StopTime},
            TimeZone => $Self->{TimeZone},
        },
    );

    my $Delta = $StartDateTimeObject->Delta(
        DateTimeObject => $StopDateTimeObject,
        ForWorkingTime => 1,
        Calendar       => $Param{Calendar},
    );

    if ( !IsHashRefWithData($Delta) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Error calculating working time.',
        );
        return;
    }

    return $Delta->{AbsoluteSeconds};
}

=head2 SystemTime2Date()

converts a system time to a structured date array.

    my ($Sec, $Min, $Hour, $Day, $Month, $Year, $WeekDay) = $TimeAccountingObject->SystemTime2Date(
        SystemTime => $TimeObject->SystemTime(),
    );

$WeekDay is the day of the week, with 0 indicating Sunday and 3 indicating Wednesday.

=cut

sub SystemTime2Date {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !defined $Param{SystemTime} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need SystemTime!',
        );
        return;
    }

    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            Epoch => $Param{SystemTime},
        },
    );

    $DateTimeObject->ToTimeZone( TimeZone => $Self->{TimeZone} );

    my $DateTimeValues = $DateTimeObject->Get();

    my $Year  = $DateTimeValues->{Year};
    my $Month = sprintf "%02d", $DateTimeValues->{Month};
    my $Day   = sprintf "%02d", $DateTimeValues->{Day};
    my $Hour  = sprintf "%02d", $DateTimeValues->{Hour};
    my $Min   = sprintf "%02d", $DateTimeValues->{Minute};
    my $Sec   = sprintf "%02d", $DateTimeValues->{Second};

    my $WDay = $DateTimeValues->{DayOfWeek} == 7 ? 0 : $DateTimeValues->{DayOfWeek};

    return ( $Sec, $Min, $Hour, $Day, $Month, $Year, $WDay );
}

=head2 DayOfWeekToName()

Convert a day number into the day name

    my $DayName = $TimeAccountingObject->DayOfWeekToName(
        Number => 1 # will return 'Monday'
    );

=cut

sub DayOfWeekToName {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !defined $Param{Number} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Number!",
        );
        return;
    }

    if ( !IsPositiveInteger( $Param{Number} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Number must be a positive integer!",
        );
        return;
    }
    if ( $Param{Number} > 7 ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Number must not be grater than 7!",
        );
        return;
    }

    my @DayNames = (
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday'
    );

    return $DayNames[ $Param{Number} - 1 ];
}

=head2 Date2SystemTime()

converts a structured date array to system time of OTRS.

    my $SystemTime = $TimeAccountingObject->Date2SystemTime(
        Year   => 2004,
        Month  => 8,
        Day    => 14,
        Hour   => 22,
        Minute => 45,
        Second => 0,
    );

=cut

sub Date2SystemTime {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Year Month Day Hour Minute Second)) {
        if ( !defined $Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }

    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            %Param,
            TimeZone => $Self->{TimeZone},
        },
    );

    if ( !$DateTimeObject ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message =>
                "Invalid Date '$Param{Year}-$Param{Month}-$Param{Day} $Param{Hour}:$Param{Minute}:$Param{Second}'!",
        );
        return;
    }

    my $SystemTime = $DateTimeObject->ToEpoch();

    return $SystemTime;
}

=head2 TimeStamp2SystemTime()

converts a given time stamp to local system time.

    my $SystemTime = $TimeObject->TimeStamp2SystemTime(
        String => '2004-08-14 22:45:00',
    );

=cut

sub TimeStamp2SystemTime {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{String} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need String!',
        );
        return;
    }

    my $SystemTime = 0;

    # match iso date format
    if ( $Param{String} =~ /(\d{4})-(\d{1,2})-(\d{1,2})\s(\d{1,2}):(\d{1,2}):(\d{1,2})/ ) {
        $SystemTime = $Self->Date2SystemTime(
            Year   => $1,
            Month  => $2,
            Day    => $3,
            Hour   => $4,
            Minute => $5,
            Second => $6,
        );
    }

    # match iso date format (wrong format)
    elsif ( $Param{String} =~ /(\d{1,2})-(\d{1,2})-(\d{4})\s(\d{1,2}):(\d{1,2}):(\d{1,2})/ ) {
        $SystemTime = $Self->Date2SystemTime(
            Year   => $3,
            Month  => $2,
            Day    => $1,
            Hour   => $4,
            Minute => $5,
            Second => $6,
        );
    }

    # match euro time format
    elsif ( $Param{String} =~ /(\d{1,2})\.(\d{1,2})\.(\d{4})\s(\d{1,2}):(\d{1,2}):(\d{1,2})/ ) {
        $SystemTime = $Self->Date2SystemTime(
            Year   => $3,
            Month  => $2,
            Day    => $1,
            Hour   => $4,
            Minute => $5,
            Second => $6,
        );
    }

    # match yyyy-mm-ddThh:mm:ss+tt:zz time format
    elsif (
        $Param{String}
        =~ /(\d{4})-(\d{1,2})-(\d{1,2})T(\d{1,2}):(\d{1,2}):(\d{1,2})(\+|\-)((\d{1,2}):(\d{1,2}))/i
        )
    {
        $SystemTime = $Self->Date2SystemTime(
            Year   => $1,
            Month  => $2,
            Day    => $3,
            Hour   => $4,
            Minute => $5,
            Second => $6,
        );
    }

    # match mail time format
    elsif (
        $Param{String}
        =~ /((...),\s+|)(\d{1,2})\s(...)\s(\d{4})\s(\d{1,2}):(\d{1,2}):(\d{1,2})\s((\+|\-)(\d{2})(\d{2})|...)/
        )
    {
        my @MonthMap    = qw/Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec/;
        my $Month       = 1;
        my $MonthString = $4;
        for my $MonthCount ( 0 .. $#MonthMap ) {
            if ( $MonthString =~ /$MonthMap[$MonthCount]/i ) {
                $Month = $MonthCount + 1;
            }
        }
        $SystemTime = $Self->Date2SystemTime(
            Year   => $5,
            Month  => $Month,
            Day    => $3,
            Hour   => $6,
            Minute => $7,
            Second => $8,
        );    # + $Self->{TimeSecDiff};
    }
    elsif (    # match yyyy-mm-ddThh:mm:ssZ
        $Param{String} =~ /(\d{4})-(\d{1,2})-(\d{1,2})T(\d{1,2}):(\d{1,2}):(\d{1,2})Z$/
        )
    {
        $SystemTime = $Self->Date2SystemTime(
            Year   => $1,
            Month  => $2,
            Day    => $3,
            Hour   => $4,
            Minute => $5,
            Second => $6,
        );
    }

    # return error
    if ( !defined $SystemTime ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Invalid Date '$Param{String}'!",
        );
    }

    # return system time
    return $SystemTime;

}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
