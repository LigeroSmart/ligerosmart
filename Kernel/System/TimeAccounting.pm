#--
# Kernel/System/TimeAccounting.pm - all time accounting functions
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: TimeAccounting.pm,v 1.51 2011-01-27 23:46:30 en Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::TimeAccounting;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.51 $) [1];

use Date::Pcalc qw(Today Days_in_Month Day_of_Week check_date);

=head1 NAME#

Kernel::System::TimeAccounting - timeaccounting lib

=head1 SYNOPSIS

All timeaccounting functions

=head1 PUBLIC INTERFACE#

=over 4

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::Time;
    use Kernel::System::User;
    use Kernel::System::TimeAccounting;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $UserObject = Kernel::System::User->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
        TimeObject   => $TimeObject,
        DBObject     => $DBObject,
        EncodeObject => $EncodeObject,
    );
    my $TimeAccountingObject = Kernel::System::TimeAccounting->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        UserID       => 123,
        MainObject   => $MainObject,
        TimeObject   => $TimeObject,
        UserObject   => $UserObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(DBObject ConfigObject LogObject UserID TimeObject UserObject MainObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    return $Self;
}

=item UserCurrentPeriodGet()

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
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "UserCurrentPeriodGet: Need $NeededParam!"
            );
            return;
        }
    }

    # build date string for given params
    my $Date = sprintf( "%04d-%02d-%02d", $Param{Year}, $Param{Month}, $Param{Day} ) . ' 00:00:00';

    # TODO: Check caching!
    # Caching
    if ( $Self->{'Cache::UserCurrentPeriodGet'}{$Date} ) {
        return %{ $Self->{'Cache::UserCurrentPeriodGet'}{$Date} };
    }

    # db select
    my $PrepareSuccess = $Self->{DBObject}->Prepare(
        SQL =>
            'SELECT user_id, preference_period, date_start, date_end, '
            . 'weekly_hours, leave_days, overtime '
            . 'FROM time_accounting_user_period '
            . 'WHERE date_start <= ? AND date_end  >= ? '
            . 'AND status = ?',
        Bind => [ \$Date, \$Date, \1, ],
    );

    # check success of prepare statement
    return if !$PrepareSuccess;

    # fetch Data
    my %Data;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
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

=item UserReporting()

returns a hash with information about leavedays, overtimes,
workinghours etc. of all users

    my %Data = $TimeAccountingObject->UserReporting(
        Year  => '2005',
        Month => '12',
        Day   => '12',      # Optional
    );

=cut

sub UserReporting {
    my ( $Self, %Param ) = @_;

    # check needed params
    for my $NeededParam (qw(Year Month Day)) {
        if ( !$Param{$NeededParam} && $NeededParam ne 'Day' ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "UserReporting: Need $NeededParam!"
            );
            return;
        }
    }

    # check valide date values
    return if !check_date( $Param{Year}, $Param{Month}, $Param{Day} || 1 );

    # get days of month if not provided
    $Param{Day} ||= Days_in_Month( $Param{Year}, $Param{Month} );

    my %UserCurrentPeriod = $Self->UserCurrentPeriodGet(%Param);
    my $YearStart         = 0;
    my $MonthStart        = 0;
    my $DayStart          = 0;
    my $YearEnd           = $Param{Year};
    my $MonthEnd          = $Param{Month};
    my $DayEnd            = $Param{Day};

    my %Data;

    USERID:
    for my $UserID ( keys %UserCurrentPeriod ) {
        if ( $UserCurrentPeriod{$UserID}{DateStart} =~ m{ \A (\d{4})-(\d{2})-(\d{2}) }smx ) {
            $YearStart  = $1;
            $MonthStart = $2;
            $DayStart   = $3;
        }

        if ( !check_date( $YearStart, $MonthStart, $DayStart ) ) {

            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message  => 'UserReporting: Invalid start date for user '
                    . "$UserID: $UserCurrentPeriod{$UserID}{DateStart}"
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

                my $DayEndPoint =
                    $Year == $YearEnd && $Month == $MonthEnd
                    ? $DayEnd
                    : Days_in_Month( $Year, $Month )
                    ;

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
                    my $VacationCheck = $Self->{TimeObject}->VacationCheck(
                        Year  => $Year,
                        Month => $Month,
                        Day   => $Day,
                    );
                    my $Weekday = Day_of_Week( $Year, $Month, $Day );
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
        $CurrentUserData{Overtime} = $CurrentUserData{WorkingHours} - $CurrentUserData{TargetState};
        $CurrentUserData{OvertimeTotal}
            = $UserCurrentPeriod{$UserID}{Overtime}
            + $CurrentUserData{WorkingHoursTotal}
            - $CurrentUserData{TargetStateTotal};
        $CurrentUserData{OvertimeUntil}
            = $CurrentUserData{OvertimeTotal} - $CurrentUserData{Overtime};
        $CurrentUserData{LeaveDayRemaining}
            = $UserCurrentPeriod{$UserID}{LeaveDays} - $CurrentUserData{LeaveDayTotal};

        $Data{$UserID} = \%CurrentUserData;
    }
    return %Data;
}

=item ProjectSettingsGet()

returns a hash with all the projects' data

    my %ProjectData = $TimeAccountingObject->ProjectSettingsGet(
        Status => 'valid' || 'invalid', optional default valid && invalid
    );

=cut

sub ProjectSettingsGet {
    my ( $Self, %Param ) = @_;

    my %Data  = ();
    my $Where = '';

    if ( $Param{Status} ) {
        $Where = ' WHERE status = ';
        $Where .= $Param{Status} eq 'invalid' ? "'0'" : "'1'";
    }

    # db select
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id, project, description, status "
            . "FROM time_accounting_project $Where",
    );

    # fetch Data
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        my $ID = $Row[0];
        $Data{Project}{$ID}            = $Row[1];
        $Data{ProjectDescription}{$ID} = $Row[2];
        $Data{ProjectStatus}{$ID}      = $Row[3];
    }
    return %Data;
}

=item ProjectGet()

returns a hash with the requested project data

    my %ProjectData = $TimeAccountingObject->ProjectGet( ID => 2 );

This returns something like:

    $TimeAccountingObject = (
        Project            => 'internal',
        ProjectDescription => 'description',
        ProjectStatus      => 1,
    );

    or

    my %ProjectData = $TimeAccountingObject->ProjectGet( Project => 'internal; );

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
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need ID or project name!' );
        return;
    }

    my %Project;

    # look for the task data with the ID
    if ( $Param{ID} ) {

        # sql
        return if !$Self->{DBObject}->Prepare(
            SQL => 'SELECT project, description, status '
                . 'FROM time_accounting_project WHERE id = ?',
            Bind => [ \$Param{ID} ],
        );
        while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
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

        # sql
        return if !$Self->{DBObject}->Prepare(
            SQL => 'SELECT id, description, status '
                . 'FROM time_accounting_project WHERE project = ?',
            Bind => [ \$Param{Project} ],
        );
        while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
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

=item ProjectSettingsInsert()

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

    $Param{Project} ||= $Self->{ConfigObject}->Get('TimeAccounting::DefaultProjectName');
    $Param{ProjectDescription} ||= '';

    if ( $Param{ProjectStatus} ne '0' && $Param{ProjectStatus} ne '1' ) {
        $Param{ProjectStatus} = $Self->{ConfigObject}->Get('TimeAccounting::DefaultProjectStatus');
    }

    # insert project record
    my $Result = $Self->{DBObject}->Do(
        SQL => 'INSERT INTO time_accounting_project (project, description, status) '
            . 'VALUES (?, ?, ?)',
        Bind => [ \$Param{Project}, \$Param{ProjectDescription}, \$Param{ProjectStatus} ],
    );
    return if !$Result;

    # get ID of newly created project record
    $Result = $Self->{DBObject}->Prepare(
        SQL   => 'SELECT id FROM time_accounting_project WHERE project = ?',
        Bind  => [ \$Param{Project} ],
        Limit => 1,
    );
    return if !$Result;

    # fetch Data
    my $ProjectID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $ProjectID = $Row[0];
    }

    return $ProjectID;
}

=item ProjectSettingsUpdate()

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
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # sql
    return if !$Self->{DBObject}->Do(
        SQL => 'UPDATE time_accounting_project SET project = ?, description = ?, status = ?'
            . ' WHERE id = ?',
        Bind => [
            \$Param{Project}, \$Param{ProjectDescription}, \$Param{ProjectStatus}, \$Param{ID}
        ],
    );

    return 1;
}

=item ActionSettingsGet()

returns a hash with all the actions settings

    my %ActionData = $TimeAccountingObject->ActionSettingsGet();

=cut

sub ActionSettingsGet {
    my $Self = shift;

    my %Data = ();

    # db select
    $Self->{DBObject}->Prepare( SQL => 'SELECT id, action, status FROM time_accounting_action', );

    # fetch Data
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Data{ $Row[0] }{Action}       = $Row[1];
        $Data{ $Row[0] }{ActionStatus} = $Row[2];
    }
    return %Data;
}

=item ActionGet()

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
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need ID or Action!' );
        return;
    }

    my %Task;

    # look for the task data with the ID
    if ( $Param{ID} ) {

        # sql
        return if !$Self->{DBObject}->Prepare(
            SQL => 'SELECT action, status '
                . 'FROM time_accounting_action WHERE id = ?',
            Bind => [ \$Param{ID} ],
        );
        while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
            %Task = (
                ID           => $Param{ID},
                Action       => $Data[0],
                ActionStatus => $Data[1],
            );
        }
    }

    # look for the task data with the task name
    else {

        # sql
        return if !$Self->{DBObject}->Prepare(
            SQL => 'SELECT id, status '
                . 'FROM time_accounting_action WHERE action = ?',
            Bind => [ \$Param{Action} ],
        );
        while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
            %Task = (
                Action       => $Param{Action},
                ID           => $Data[0],
                ActionStatus => $Data[1],
            );
        }
    }
    return %Task;
}

=item ActionSettingsInsert()

inserts a new action in the db

    $TimeAccountingObject->ActionSettingsInsert(
        Action       => 'meeting',   # optional
        ActionStatus => 1 || 0,      # optional
    );

=cut

sub ActionSettingsInsert {
    my ( $Self, %Param ) = @_;

    # db quote
    for ( keys %Param ) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} ) || '';
    }

    $Param{Action} ||= $Self->{ConfigObject}->Get('TimeAccounting::DefaultActionName') || '';
    if ( $Param{ActionStatus} ne '0' && $Param{ActionStatus} ne '1' ) {
        $Param{ActionStatus} = $Self->{ConfigObject}->Get('TimeAccounting::DefaultActionStatus');
    }

    # build sql
    my $SQL
        = "INSERT INTO time_accounting_action (action, status)"
        . " VALUES ('$Param{Action}' , '$Param{ActionStatus}')";

    # db insert
    return if !$Self->{DBObject}->Do( SQL => $SQL );
    return 1;
}

=item ActionSettingsUpdate()

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
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # sql
    return if !$Self->{DBObject}->Do(
        SQL => 'UPDATE time_accounting_action SET action = ?, status = ?'
            . ' WHERE id = ?',
        Bind => [
            \$Param{Action}, \$Param{ActionStatus}, \$Param{ActionID}
        ],
    );

    return 1;
}

=item UserList()

returns a hash with the user data of all users

    my %UserData = $TimeAccountingObject->UserList();

=cut

sub UserList {
    my $Self = shift;

    my %Data = ();

    # db select
    $Self->{DBObject}->Prepare(
        SQL =>
            'SELECT user_id, description, show_overtime, create_project, calendar FROM time_accounting_user',
    );

    # fetch Data
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Data{ $Row[0] }{UserID}        = $Row[0];
        $Data{ $Row[0] }{Description}   = $Row[1];
        $Data{ $Row[0] }{ShowOvertime}  = $Row[2];
        $Data{ $Row[0] }{CreateProject} = $Row[3];
        $Data{ $Row[0] }{Calendar}      = $Row[4];
    }
    return %Data;
}

=item UserGet()

returns a hash with the user data of one user

    my %UserData = $TimeAccountingObject->UserGet(
        UserID => 15,  #
    );

=cut

sub UserGet {
    my ( $Self, %Param ) = @_;

    # check needed data
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'UserGet: Need UserID!'
        );
        return;
    }

    my %Data = ();

    # db select
    $Self->{DBObject}->Prepare(
        SQL =>
            'SELECT description, show_overtime, create_project, calendar FROM time_accounting_user WHERE user_id = ?',
        Bind => [ \$Param{UserID} ],
    );

    # fetch Data
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Data{UserID}        = $Param{UserID};
        $Data{Description}   = $Row[0];
        $Data{ShowOvertime}  = $Row[1];
        $Data{CreateProject} = $Row[2];
        $Data{Calendar}      = $Row[3];
    }
    return %Data;
}

=item UserSettingsGet()

returns a hash with the user period data

    my %UserData = $TimeAccountingObject->UserSettingsGet();

=cut

sub UserSettingsGet {
    my $Self = shift;

    my %Data = ();

    # db select
    $Self->{DBObject}->Prepare(
        SQL =>
            'SELECT user_id, preference_period, date_start, date_end, weekly_hours, leave_days, overtime, status '
            .
            'FROM time_accounting_user_period',
    );

    # fetch Data
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
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

=item SingleUserSettingsGet()

returns a hash with the requested user's period data

    my %UserData = $TimeAccountingObject->SingleUserSettingsGet( UserID => 1 );

=cut

sub SingleUserSettingsGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need ID!' );
        return;
    }

    my %UserData = ();

    # db select
    $Self->{DBObject}->Prepare(
        SQL =>
            'SELECT user_id, preference_period, date_start, date_end, weekly_hours, leave_days, overtime, status '
            .
            'FROM time_accounting_user_period WHERE user_id = ?',
        Bind => [ \$Param{UserID} ],
    );

    # fetch Data
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
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

=item UserLastPeriodNumberGet()

returns the number of the last registered period for the specified user

    my $LastPeriodNumber = $TimeAccountingObject->UserLastPeriodNumberGet( UserID => 1 );

=cut

sub UserLastPeriodNumberGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need ID!' );
        return;
    }

    my $LastPeriodNumber;

    # db select
    $Self->{DBObject}->Prepare(
        SQL =>
            'SELECT max(preference_period) '
            .
            'FROM time_accounting_user_period WHERE user_id = ?',
        Bind => [ \$Param{UserID} ],
    );

    # fetch Data
    my @Row = $Self->{DBObject}->FetchrowArray();
    $LastPeriodNumber = $Row[0] || 0;

    return $LastPeriodNumber;
}

=item UserSettingsInsert()

insert new user data in the db

    $TimeAccountingObject->UserSettingsInsert(
        UserID       => '2',
        Period       => '2',
    );

=cut

sub UserSettingsInsert {
    my ( $Self, %Param ) = @_;

    # delete cache
    delete $Self->{'Cache::UserCurrentPeriodGet'};

    $Param{WeeklyHours} = $Self->{ConfigObject}->Get('TimeAccounting::DefaultUserWeeklyHours')
        || '40';
    $Param{LeaveDays}  = $Self->{ConfigObject}->Get('TimeAccounting::DefaultUserLeaveDays') || '25';
    $Param{UserStatus} = $Self->{ConfigObject}->Get('TimeAccounting::DefaultUserStatus')    || '1';
    $Param{Overtime}   = $Self->{ConfigObject}->Get('TimeAccounting::DefaultUserOvertime')  || '0';
    $Param{DateEnd}    = $Self->{ConfigObject}->Get('TimeAccounting::DefaultUserDateEnd')
        || '2011-12-31';
    $Param{DateStart} = $Self->{ConfigObject}->Get('TimeAccounting::DefaultUserDateStart')
        || '2011-01-01';
    $Param{Description} = $Self->{ConfigObject}->Get('TimeAccounting::DefaultUserDescription')
        || 'Put your description here.';

    # db quote
    for ( keys %Param ) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} );
        if ( !defined( $Param{$_} ) ) {
            $Param{$_} = '';
        }
    }

    # build sql
    my $SQL
        = "INSERT INTO time_accounting_user_period (user_id, preference_period, date_start, date_end,"
        . " weekly_hours, leave_days, overtime, status)"
        . " VALUES"
        . " ('$Param{UserID}', '$Param{Period}', '$Param{DateStart} 00:00:00', '$Param{DateEnd} 00:00:00',"
        . " '$Param{WeeklyHours}', '$Param{LeaveDays}', '$Param{Overtime}', '$Param{UserStatus}')";

    # db insert
    return if !$Self->{DBObject}->Do( SQL => $SQL );

    # Split the following code in a seperate function!

    #check if the user still exists
    my $UserID;

    # build sql
    $Self->{DBObject}->Prepare(
        SQL => "SELECT user_id FROM time_accounting_user WHERE user_id = '$Param{UserID}'",
    );

    # fetch Data
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $UserID = $Row[0];
    }
    if ( !defined $UserID ) {
        $SQL = "INSERT INTO time_accounting_user (user_id, description)"
            . " VALUES"
            . " ('$Param{UserID}', '$Param{Description}')";

        # db insert
        return if !$Self->{DBObject}->Do( SQL => $SQL );
    }
    return 1;
}

=item UserSettingsUpdate()

update user data in the db

    $TimeAccountingObject->UserSettingsUpdate(
        UserID => 1,
        Description => 'Some Text',
        CreateProject => 1 || 0,
        ShowOvertime  => 1 || 0,
        1    => {
            UserID => 1,
            Description => 'Some Text',
            CreateProject => 1 || 0,
            ShowOvertime  => 1 || 0,
            1 => {
                UserID       => 1,
                Period       => '1',
                DateStart    => '2005-12-12',
                DateEnd      => '2005-12-31',
                WeeklyHours  => '38',
                LeaveDays    => '25',
                Overtime     => '38',
                UserStatus   => 1 || 0,
            },
        },
        2    => {
            1 => {
                UserID       => 2,
                Period       => '1',
                DateStart    => '2005-12-12',
                DateEnd      => '2005-12-31',
                WeeklyHours  => '38',
                LeaveDays    => '25',
                Overtime     => '38',
                UserStatus   => 1 || 0,
            },
        },
        3    => ......
    );

=cut

sub UserSettingsUpdate {
    my ( $Self, %Param ) = @_;

    # delete cache
    delete $Self->{'Cache::UserCurrentPeriodGet'};

    USERID:
    for my $UserID ( sort keys %Param ) {

        my $UserRef = $Param{$UserID};

        if ( !defined $UserRef->{1}{DateStart} && !defined $UserRef->{1}{DateEnd} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "UserSettingUpdate: There are no data for user id $UserID!"
            );
            next USERID;
        }

        #set default for ShowOverTime...
        $UserRef->{ShowOvertime} ||= 0;

        #set default for CreateProject...
        $UserRef->{CreateProject} ||= 0;
        $UserRef->{Calendar}      ||= 0;

        # build sql
        my $SQL
            = "UPDATE time_accounting_user "
            . "SET description = ?, show_overtime = ?, create_project = ?, calendar = ? "
            . "WHERE user_id = ?";

        my $Bind = [
            \$UserRef->{Description}, \$UserRef->{ShowOvertime},
            \$UserRef->{CreateProject}, \$UserRef->{Calendar}, \$UserRef->{UserID}
        ];

        # db insert
        return if !$Self->{DBObject}->Do(
            SQL  => $SQL,
            Bind => $Bind,
        );

        for (qw(UserID Description ShowOvertime CreateProject Calendar)) {
            delete $UserRef->{$_};
        }

        for my $Period ( keys %{$UserRef} ) {

            my $PeriodRef = $UserRef->{$Period};

            # build sql
            my $SQL
                = "UPDATE time_accounting_user_period "
                . "SET leave_days = ?, date_start = ?"
                . ", date_end = ?, overtime = ?"
                . ", weekly_hours = ?, status = ? "
                . "WHERE user_id = ? AND preference_period = ?";

            my $Bind = [
                \$PeriodRef->{LeaveDays}, \$PeriodRef->{DateStart},   \$PeriodRef->{DateEnd},
                \$PeriodRef->{Overtime},  \$PeriodRef->{WeeklyHours}, \$PeriodRef->{UserStatus},
                \$PeriodRef->{UserID},    \$Period,
            ];

            # db insert
            return if !$Self->{DBObject}->Do( SQL => $SQL, Bind => $Bind );
        }
    }
    return 1;
}

=item SingleUserSettingsUpdate()

updates user data in the db

    $TimeAccountingObject->SingleUserSettingsUpdate(
        UserID        => 1,
        Description   => 'Some Text',
        CreateProject => 1 || 0,
        ShowOvertime  => 1 || 0,
        Period        => {
            1 => {
                DateStart    => '2010-12-12',
                DateEnd      => '2010-12-31',
                WeeklyHours  => '38',
                LeaveDays    => '25',
                Overtime     => '38',
                UserStatus   => 1 || 0,
            },
            2 => {
                DateStart    => '2010-12-12',
                DateEnd      => '2010-12-31',
                WeeklyHours  => '38',
                LeaveDays    => '25',
                Overtime     => '38',
                UserStatus   => 1 || 0,
            },
            3 => ......
        }
    );

=cut

sub SingleUserSettingsUpdate {
    my ( $Self, %Param ) = @_;

    # delete cache
    delete $Self->{'Cache::UserCurrentPeriodGet'};

    my $UserID = $Param{UserID};

    if ( !defined $Param{Period}->{1}{DateStart} && !defined $Param{Period}->{1}{DateEnd} ) {
        return $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "UserSettingUpdate: No data for user id $UserID!"
        );
    }

    #set default values
    $Param{ShowOvertime}  ||= 0;
    $Param{CreateProject} ||= 0;
    $Param{Calendar}      ||= 0;

    # build sql
    my $SQL
        = "UPDATE time_accounting_user "
        . "SET description = ?, show_overtime = ?, create_project = ?, calendar = ? "
        . "WHERE user_id = ?";

    my $Bind = [
        \$Param{Description}, \$Param{ShowOvertime},
        \$Param{CreateProject}, \$Param{Calendar}, \$Param{UserID}
    ];

    # db insert
    return if !$Self->{DBObject}->Do(
        SQL  => $SQL,
        Bind => $Bind,
    );

    # update all periods
    for my $Period ( keys %{ $Param{Period} } ) {

        # build sql
        my $SQL
            = "UPDATE time_accounting_user_period "
            . "SET leave_days = ?, date_start = ?"
            . ", date_end = ?, overtime = ?"
            . ", weekly_hours = ?, status = ? "
            . "WHERE user_id = ? AND preference_period = ?";

        my $Bind = [
            \$Param{Period}->{$Period}{LeaveDays},   \$Param{Period}->{$Period}{DateStart},
            \$Param{Period}->{$Period}{DateEnd},     \$Param{Period}->{$Period}{Overtime},
            \$Param{Period}->{$Period}{WeeklyHours}, \$Param{Period}->{$Period}{UserStatus},
            \$UserID, \$Period,
        ];

        # db insert
        return if !$Self->{DBObject}->Do( SQL => $SQL, Bind => $Bind );
    }

    return 1;
}

=item WorkingUnitsCompletnessCheck()

returns a hash with the incomplete working days and
the information if the incomplete working days are in the allowed
range.

    my %WorkingUnitsCheck = $TimeAccountingObject->WorkingUnitsCompletnessCheck(
        UserID => '2',    # Optional
    );

=cut

sub WorkingUnitsCompletnessCheck {
    my ( $Self, %Param ) = @_;

    my %Data                = ();
    my $WorkingUnitID       = 0;
    my %CompleteWorkingDays = ();
    my ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = $Self->{TimeObject}->SystemTime2Date(
        SystemTime => $Self->{TimeObject}->SystemTime(),
    );

    my $UserID = $Param{UserID} || $Self->{UserID};

    # TODO: Search only in the CurrentUserPeriod
    # TODO: Search only working units where action_id and project_id is true

    $Self->{DBObject}->Prepare(
        SQL  => "SELECT DISTINCT time_start FROM time_accounting_table WHERE user_id = ?",
        Bind => [ \$UserID ],
    );

    # fetch Data
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
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
    my $YearStart   = 0;
    my $MonthStart  = 0;
    my $DayStart    = 0;
    my $YearEnd     = $Year;
    my $MonthEnd    = $Month;
    my $DayEnd      = $Day;

    if ( $UserCurrentPeriod{$UserID}{DateStart} =~ /^(\d+)-(\d+)-(\d+)/ ) {
        $YearStart  = $1;
        $MonthStart = $2;
        $DayStart   = $3;
    }

    my $Calendar = { $Self->UserGet( UserID => $UserID ) }->{Calendar};

    for my $Year ( $YearStart .. $YearEnd ) {

        my $MonthStartPoint = $Year == $YearStart ? $MonthStart : 1;
        my $MonthEndPoint   = $Year == $YearEnd   ? $MonthEnd   : 12;

        for my $Month ( $MonthStartPoint .. $MonthEndPoint ) {
            my $DayStartPoint = $Year == $YearStart && $Month == $MonthStart ? $DayStart : 1;
            my $DayEndPoint = $Year == $YearEnd
                && $Month == $MonthEnd ? $DayEnd : Days_in_Month( $Year, $Month );
            my $MonthString = sprintf( "%02d", $Month );

            for my $Day ( $DayStartPoint .. $DayEndPoint ) {
                my $VacationCheck = $Self->{TimeObject}->VacationCheck(
                    Year     => $Year,
                    Month    => $Month,
                    Day      => $Day,
                    Calendar => $Calendar,
                );

                my $Date = sprintf( "%04d-%02d-%02d", $Year, $Month, $Day );
                my $DayStartTime
                    = $Self->{TimeObject}->TimeStamp2SystemTime( String => $Date . ' 00:00:00' );
                my $DayStopTime
                    = $Self->{TimeObject}->TimeStamp2SystemTime( String => $Date . ' 23:59:59' );

                # add time zone to calculation
                my $Zone = $Self->{ConfigObject}->Get( "TimeZone::Calendar" . $Calendar );
                if ($Zone) {
                    my $ZoneSeconds = $Zone * 60 * 60;
                    $DayStartTime = $DayStartTime - $ZoneSeconds;
                    $DayStopTime  = $DayStopTime - $ZoneSeconds;
                }

                my $ThisDayWorkingTime = $Self->{TimeObject}->WorkingTime(
                    StartTime => $DayStartTime,
                    StopTime  => $DayStopTime,
                    Calendar  => $Calendar || '',
                ) || '0';

                my $DayString = sprintf( "%02d", $Day );

                if ( $ThisDayWorkingTime && !$VacationCheck ) {
                    $WorkingDays++;
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
    my $MaxIntervallOfIncompleteDays
        = $Self->{ConfigObject}->Get('TimeAccounting::MaxIntervalOfIncompleteDays') || '5';
    my $MaxIntervallOfIncompleteDaysBeforeWarning
        = $Self->{ConfigObject}->Get('TimeAccounting::MaxIntervalOfIncompleteDaysBeforeWarning')
        || '3';
    for my $Year ( keys %{ $Data{Incomplete} } ) {
        for my $Month ( keys %{ $Data{Incomplete}{$Year} } ) {
            for my $Day ( keys %{ $Data{Incomplete}{$Year}{$Month} } ) {
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

=item WorkingUnitsGet()

returns a hash with the working units data

    my %WorkingUnitsData = $TimeAccountingObject->WorkingUnitsGet(
        Year   => '2005',
        Month  => '7',
        Day    => '13',
        UserID => '2',    # Optional
    );

=cut

sub WorkingUnitsGet {
    my ( $Self, %Param ) = @_;

    for ( keys %Param ) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} ) || '';
    }

    $Param{UserID} ||= $Self->{UserID};

    my $Date      = sprintf( "%04d-%02d-%02d", $Param{Year}, $Param{Month}, $Param{Day} );
    my $DateStart = $Date . " 00:00:00";
    my $DateStop  = $Date . " 23:59:59";

    $Self->{DBObject}->Prepare(
        SQL => "SELECT user_id, project_id, action_id, remark, time_start, time_end,"
            . " period FROM time_accounting_table "
            . " WHERE "
            . " time_start >= '$DateStart' "
            . " AND time_start <= '$DateStop' "
            . " AND user_id = '$Param{UserID}' ORDER by id",
    );

    my %Data = (
        Total => 0,
        Date  => $Date,
    );

    # fetch Data
    ROW:
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        next ROW if $Row[4] !~ m{^ (.+?) \s (\d+:\d+) : (\d+) }smx;

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
        if ( $Row[5] =~ m{^(.+?)\s(\d+:\d+):(\d+)}smx ) {
            $EndTime = $2;
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

=item WorkingUnitsInsert()

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
        ]
    );

=cut

sub WorkingUnitsInsert {
    my ( $Self, %Param ) = @_;
    for (qw(Year Month Day)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "WorkingUnitsInsert: Need $_!"
            );
            return;
        }
    }
    my $Date = sprintf( "%04d-%02d-%02d", $Param{Year}, $Param{Month}, $Param{Day} );

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

    #insert new working units
    UNITREF:
    for my $UnitRef ( @{ $Param{WorkingUnits} } ) {
        my $StartTime = $Date . ' ' . $UnitRef->{StartTime};
        my $EndTime   = $Date . ' ' . $UnitRef->{EndTime};

        # '' does not work in integer field of postgres
        $UnitRef->{ProjectID} ||= 0;
        $UnitRef->{ActionID}  ||= 0;
        $UnitRef->{Period}    ||= 0;

        # build sql
        my $SQL
            = "INSERT INTO time_accounting_table "
            . "(user_id, project_id, action_id, remark,"
            . " time_start, time_end, period, created )"
            . " VALUES  ( ?, ?, ?, ?, ?, ?, ?, current_timestamp)";
        my $Bind = [
            \$Self->{UserID}, \$UnitRef->{ProjectID}, \$UnitRef->{ActionID},
            \$UnitRef->{Remark}, \$StartTime, \$EndTime, \$UnitRef->{Period}
        ];

        # db insert
        return if !$Self->{DBObject}->Do( SQL => $SQL, Bind => $Bind );
    }
    return 1;
}

=item WorkingUnitsDelete()

delets working units in the db

    $TimeAccountingObject->WorkingUnitsDelete(
        Year  => '2005',
        Month => '7',
        Day   => '13',
    );

=cut

sub WorkingUnitsDelete {
    my ( $Self, %Param ) = @_;

    for (qw(Year Month Day)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} ) || '';
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "WorkingUnitsInsert: Need $_!"
            );
            return;
        }
    }
    my $Date = sprintf( "%04d-%02d-%02d", $Param{Year}, $Param{Month}, $Param{Day} );

    # delete old working units
    my $SQL = "DELETE FROM time_accounting_table "
        . "WHERE time_start <= '$Date 23:59:59'"
        . " AND time_start >= '$Date 00:00:00' "
        . " AND user_id = '$Self->{UserID}'";

    return if !$Self->{DBObject}->Do( SQL => $SQL );
    return 1;
}

=item ProjectActionReporting()

returns a hash with the hours dependent project and action data

    my %ProjectData = $TimeAccountingObject->ProjectActionReporting(
        Year  => 2005,
        Month => 7,
        UserID => 123, # optional; no UserID means 'of all user'
    );

=cut

sub ProjectActionReporting {
    my ( $Self, %Param ) = @_;

    my %Data     = ();
    my $IDSelect = '';
    for (qw(Year Month)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} ) || '';
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "ProjectActionReporting: Need $_!"
            );
            return;
        }
    }
    if ( $Param{UserID} ) {
        $Param{UserID} = $Self->{DBObject}->Quote( $Param{UserID} ) || '';
        $IDSelect = " AND user_id = '$Param{UserID}'";
    }

    # hours per month
    my $DaysInMonth = Days_in_Month( $Param{Year}, $Param{Month} );
    my $DateString = $Param{Year} . "-" . sprintf( "%02d", $Param{Month} );

    my $SQL_Query_TimeStart = "time_start <= '$DateString-$DaysInMonth 23:59:59'$IDSelect";

    # Total hours
    $Self->{DBObject}->Prepare(
        SQL => "SELECT project_id, action_id, period FROM time_accounting_table"
            . " WHERE project_id != -1 AND $SQL_Query_TimeStart",
    );

    # fetch Data
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        next if !$Row[2];
        $Data{ $Row[0] }{Actions}{ $Row[1] }{Total} += $Row[2];
    }

    $Self->{DBObject}->Prepare(
        SQL => "SELECT project_id, action_id, period FROM time_accounting_table"
            . " WHERE project_id != -1 "
            . " AND time_start >= '$DateString-01 00:00:00' "
            . " AND $SQL_Query_TimeStart",
    );

    # fetch Data
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        next if !$Row[2];
        $Data{ $Row[0] }{Actions}{ $Row[1] }{PerMonth} += $Row[2];
    }

    # add readable components
    my %Project = $Self->ProjectSettingsGet();
    my %Action  = $Self->ActionSettingsGet();
    for my $ProjectID ( keys %Data ) {
        $Data{$ProjectID}{Name}        = $Project{Project}{$ProjectID};
        $Data{$ProjectID}{Status}      = $Project{ProjectStatus}{$ProjectID};
        $Data{$ProjectID}{Description} = $Project{ProjectDescription}{$ProjectID};
        my $ActionsRef = $Data{$ProjectID}{Actions};
        for my $ActionID ( keys %{$ActionsRef} ) {
            $Data{$ProjectID}{Actions}{$ActionID}{Name} = $Action{$ActionID}{Action};
        }
    }

    return %Data;
}

=item ProjectTotalHours()

returns the sum of all hours related to a project

    my $ProjectTotalHours = $TimeAccountingObject->ProjectTotalHours(
        ProjectID  => 15,
    );

=cut

sub ProjectTotalHours {
    my ( $Self, %Param ) = @_;

    # check needed param
    if ( !$Param{ProjectID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'ProjectActionReporting: Need ProjectID!'
        );
        return;
    }

    # db select
    my $Total = 0;
    my $SQL   = 'SELECT SUM(period) FROM time_accounting_table WHERE project_id = ?';
    my $Bind  = [ \$Param{ProjectID} ];
    return if !$Self->{DBObject}->Prepare( SQL => $SQL, Bind => $Bind );

    # fetch Data
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Total = $Row[0];
    }

    return $Total;
}

=item ProjectHistory()

returns an array with all WorkingUnits related to a project

    my @ProjectHistoryArray = $TimeAccountingObject->ProjectHistory(
        ProjectID  => 15,
    );

e.g. @ProjectHistoryArray = (
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
        $Self->{LogObject}->Log(
            Priority => 'error', Message => 'ProjectActionReporting: Need ProjectID!'
        );
        return;
    }

    # call action data to get the readable name of the action
    my %ActionData = $Self->ActionSettingsGet();

    my %ShownUsers = $Self->{UserObject}->UserList( Type => 'Long', Valid => 0 );

    # db select
    my @Data = ();
    my $SQL  = 'SELECT id, user_id, action_id, remark, time_start, time_end, period, created '
        . ' FROM time_accounting_table WHERE project_id = ?';
    my $Bind = [ \$Param{ProjectID} ];
    $Self->{DBObject}->Prepare( SQL => $SQL, Bind => $Bind );

    # fetch Data
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
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
        $UserRef->{Date} =~ s{(\d\d\d\d-\d\d-\d\d) \s .+ }{$1}smx;

        push @Data, $UserRef;
    }

    return @Data;

}

=item LastProjectsOfUser()

returns an array with the last projects of the current user

    my @LastProjects = $TimeAccountingObject->LastProjectsOfUser();

=cut

sub LastProjectsOfUser {
    my $Self = shift;

    # db select
    # I don't use distinct because of ORDER BY problems of postgre sql
    my %Projects = ();
    my $SQL
        = 'SELECT project_id FROM time_accounting_table WHERE user_id = ? AND project_id <> -1 ORDER BY time_start DESC';
    my $Bind  = [ \$Self->{UserID} ];
    my $Limit = 40;
    return if !$Self->{DBObject}->Prepare( SQL => $SQL, Bind => $Bind, Limit => $Limit );

    # fetch Data
    my $Counter = 0;
    ROW:
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        next ROW if $Counter > 7;
        next ROW if $Projects{ $Row[0] };

        $Projects{ $Row[0] } = 1;
        $Counter++;
    }

    return keys %Projects;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=head1 VERSION

$Revision: 1.51 $ $Date: 2011-01-27 23:46:30 $

=cut
