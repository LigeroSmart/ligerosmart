#--
# Kernel/System/TimeAccounting.pm - all time accounting functions
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: TimeAccounting.pm,v 1.26 2009-02-14 13:04:14 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::TimeAccounting;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.26 $) [1];

use Date::Pcalc qw(Today Days_in_Month Day_of_Week);

=head1 NAME#

Kernel::System::TimeAccounting - timeaccounting lib

=head1 SYNOPSIS

All timeaccounting functions

=head1 PUBLIC INTERFACE#

=over 4

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::Time;
    use Kernel::System::User;
    use Kernel::System::TimeAccounting;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject    = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
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
    );
    my $TimeAccountingObject = Kernel::System::TimeAccounting->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        UserID       => 123,
        MainObject   => $MainObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(DBObject ConfigObject LogObject UserID TimeObject UserObject MainObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

=item UserCurrentPeriodGet()

returns a hash with the user of the current period data

    my %UserData = $TimeAccountingObject->UserCurrentPeriodGet(
        Year  => '2005',
        Month => '12';
        Day   => '24'
    );

=cut

sub UserCurrentPeriodGet {
    my ( $Self, %Param ) = @_;

    for (qw(Year Month Day)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} ) || '';
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "UserCurrentPeriodGet: Need $_!"
            );
            return;
        }
    }

    my $Date = sprintf( "%04d-%02d-%02d", $Param{Year}, $Param{Month}, $Param{Day} ) . " 00:00:00";

    # Caching
    if ( $Self->{'Cache::UserCurrentPeriodGet'}{$Date} ) {
        return %{ $Self->{'Cache::UserCurrentPeriodGet'}{$Date} };
    }

    # db select
    my %Data = ();
    $Self->{DBObject}->Prepare(
        SQL =>
            "SELECT user_id, preference_period, date_start, date_end, weekly_hours, leave_days, overtime, status FROM time_accounting_user_period "
            . "WHERE date_start <= '$Date' AND date_end  >='$Date'",
    );

    # fetch Data
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        my $UserRef = {
            UserID      => $Row[0],
            Period      => $Row[1],
            DateStart   => substr( $Row[2], 0, 10 ),
            DateEnd     => substr( $Row[3], 0, 10 ),
            WeeklyHours => $Row[4],
            LeaveDays   => $Row[5],
            Overtime    => $Row[6],
            UserStatus  => $Row[7],
        };
        $Data{ $Row[0] } = $UserRef;
    }

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

    my %Data = ();
    for (qw(Year Month Day)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} ) || '';
        if ( !$Param{$_} && $_ ne 'Day' ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "UserReporting: Need $_!" );
            return;
        }
    }

    $Param{Day} ||= Days_in_Month( $Param{Year}, $Param{Month} );

    my %UserCurrentPeriod = $Self->UserCurrentPeriodGet(%Param);
    my $YearStart         = 0;
    my $MonthStart        = 0;
    my $DayStart          = 0;
    my $YearEnd           = $Param{Year};
    my $MonthEnd          = $Param{Month};
    my $DayEnd            = $Param{Day};

    for my $UserID ( keys %UserCurrentPeriod ) {
        if ( $UserCurrentPeriod{$UserID}{DateStart} =~ /^(\d+)-(\d+)-(\d+)/ ) {
            $YearStart  = $1;
            $MonthStart = $2;
            $DayStart   = $3;
        }
        $Data{$UserID}{LeaveDay}         = 0;
        $Data{$UserID}{Sick}             = 0;
        $Data{$UserID}{Overtime}         = 0;
        $Data{$UserID}{TargetState}      = 0;
        $Data{$UserID}{LeaveDayTotal}    = 0;
        $Data{$UserID}{SickTotal}        = 0;
        $Data{$UserID}{OvertimeTotal}    = 0;
        $Data{$UserID}{TargetStateTotal} = 0;

        my $Counter = 0;
        for my $Year ( $YearStart .. $YearEnd ) {
            my $MonthStartPoint = $Year == $YearStart ? $MonthStart : 1;
            my $MonthEndPoint   = $Year == $YearEnd   ? $MonthEnd   : 12;

            for my $Month ( $MonthStartPoint .. $MonthEndPoint ) {

                my $DayStartPoint = $Year == $YearStart && $Month == $MonthStart ? $DayStart : 1;
                my $DayEndPoint = $Year == $YearEnd
                    && $Month == $MonthEnd ? $DayEnd : Days_in_Month( $Year, $Month );

                for my $Day ( $DayStartPoint .. $DayEndPoint ) {
                    my %WorkingUnit = $Self->WorkingUnitsGet(
                        Year   => $Year,
                        Month  => $Month,
                        Day    => $Day,
                        UserID => $UserID,
                    );

                    my $LeaveDay     = 0;
                    my $Sick         = 0;
                    my $Overtime     = 0;
                    my $TargetState  = 0;

                    if ( $WorkingUnit{LeaveDay} ) {
                        $Data{$UserID}{LeaveDayTotal}++;
                        $LeaveDay = 1;
                    }
                    elsif ( $WorkingUnit{Sick} ) {
                        $Data{$UserID}{SickTotal}++;
                        $Sick = 1;
                    }
                    elsif ( $WorkingUnit{Overtime} ) {
                        $Data{$UserID}{OvertimeTotal}++;
                        $Overtime = 1;
                    }

                    $Data{$UserID}{WorkingHoursTotal} += $WorkingUnit{Total};
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
                        $Data{$UserID}{TargetStateTotal}
                            += $UserCurrentPeriod{$UserID}{WeeklyHours} / 5;
                        $TargetState = $UserCurrentPeriod{$UserID}{WeeklyHours} / 5;
                    }

                    if ( $Month == $MonthEnd && $Year == $YearEnd ) {
                        $Data{$UserID}{TargetState}  += $TargetState;
                        $Data{$UserID}{WorkingHours} += $WorkingUnit{Total};
                        $Data{$UserID}{LeaveDay}     += $LeaveDay;
                        $Data{$UserID}{Sick}         += $Sick;
                    }
                }
            }
        }
        $Data{$UserID}{Overtime} = $Data{$UserID}{WorkingHours} - $Data{$UserID}{TargetState};
        $Data{$UserID}{OvertimeTotal}
            = $UserCurrentPeriod{$UserID}{Overtime}
            + $Data{$UserID}{WorkingHoursTotal}
            - $Data{$UserID}{TargetStateTotal};
        $Data{$UserID}{OvertimeUntil} = $Data{$UserID}{OvertimeTotal} - $Data{$UserID}{Overtime};
        $Data{$UserID}{LeaveDayRemaining}
            = $UserCurrentPeriod{$UserID}{LeaveDays} - $Data{$UserID}{LeaveDayTotal};
    }
    return %Data;
}

=item ProjectSettingsGet()

returns a hash with the project data

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
        $Where .= $Param{Status} eq 'invalid' ? '0' : '1';
    }

    # db select
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id, project, description, status FROM time_accounting_project $Where",
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

=item ProjectSettingsInsert()

insert new project data in the db

    $TimeAccountingObject->ProjectSettingsInsert(
        Project       => 'internal', # optional
        ProjectStatus => 1 || 0,     # optional
    );

=cut

sub ProjectSettingsInsert {
    my ( $Self, %Param ) = @_;

    $Param{Project} ||= $Self->{ConfigObject}->Get('TimeAccounting::DefaultProjectName') || '';
    $Param{ProjectStatus} ||= $Self->{ConfigObject}->Get('TimeAccounting::DefaultProjectStatus')
        || '0';
    $Param{ProjectDescription} ||= '';

    # db quote
    for ( keys %Param ) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} ) || '';
    }

    # build sql

    my $SQL
        = "INSERT INTO time_accounting_project (project, description, status) "
        . "VALUES ('$Param{Project}', '$Param{ProjectDescription}', '$Param{ProjectStatus}')";

    # db insert
    return if !$Self->{DBObject}->Do( SQL => $SQL );
    return 1;
}

=item ProjectSettingsUpdate()

update project data in the db

    $TimeAccountingObject->ProjectSettingsUpdate(
        1    => {                        # equal ProjectID
            Project       => 'internal',
            ProjectStatus => 1 || 0,
        },
        2    => {                        # equal ProjectID
            Project       => 'projectname',
            ProjectStatus => 1 || 0,
        },
        3    => ......
    );

=cut

sub ProjectSettingsUpdate {
    my ( $Self, %Param ) = @_;

    PROJECTID:
    for my $ProjectID ( sort keys %Param ) {
        next if !$Param{$ProjectID}{Project};

        # db quote
        for ( keys %{ $Param{$ProjectID} } ) {
            $Param{$ProjectID}{$_} = $Self->{DBObject}->Quote( $Param{$ProjectID}{$_} ) || '';
        }

        # build sql
        my $SQL
            = "UPDATE time_accounting_project "
            . "SET project = '"
            . $Param{$ProjectID}{Project}
            . "', status = '"
            . $Param{$ProjectID}{ProjectStatus}
            . "', description = '"
            . $Param{$ProjectID}{ProjectDescription} . "' "
            . "WHERE id = '"
            . $ProjectID . "'";

        # db insert
        return if !$Self->{DBObject}->Do( SQL => $SQL );
    }
    return 1;
}

=item ActionSettingsGet()

returns a hash with the action settings

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

=item ActionSettingsInsert()

insert new action data in the db

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
    $Param{ActionStatus} ||= $Self->{ConfigObject}->Get('TimeAccounting::DefaultActionStatus')
        || '0';

    # build sql
    my $SQL
        = "INSERT INTO time_accounting_action (action, status)"
        . " VALUES ('$Param{Action}' , '$Param{ActionStatus}')";

    # db insert
    return if !$Self->{DBObject}->Do( SQL => $SQL );
    return 1;
}

=item ActionSettingsUpdate()

update action data in the db

    $TimeAccountingObject->ActionSettingsUpdate(
        1    => {                      # equal ActionID
            Action       => 'meeting',
            ActionStatus => 1 || 0,
        },
        2    => {                      # equal ActionID
            Action       => 'journey',
            ActionStatus => 1 || 0,
        },
        3    => ......
    );

=cut

sub ActionSettingsUpdate {
    my ( $Self, %Param ) = @_;

    for my $ActionID ( sort keys %Param ) {
        if ( $Param{$ActionID}{Action} ) {

            # db quote
            for ( keys %{ $Param{$ActionID} } ) {
                $Param{$ActionID}{$_} = $Self->{DBObject}->Quote( $Param{$ActionID}{$_} ) || '';
            }

            # build sql
            my $SQL
                = "UPDATE time_accounting_action "
                . "SET action = '"
                . $Param{$ActionID}{Action}
                . "', status = '"
                . $Param{$ActionID}{ActionStatus} . "' "
                . "WHERE id = '"
                . $ActionID . "'";

            # db insert
            return if !$Self->{DBObject}->Do( SQL => $SQL );
        }
    }
    return 1;
}

=item UserList()

returns a hash with the user data of all user

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
        || '2007-12-31';
    $Param{DateStart} = $Self->{ConfigObject}->Get('TimeAccounting::DefaultUserDateStart')
        || '2007-01-01';
    $Param{Description} = $Self->{ConfigObject}->Get('TimeAccounting::DefaultUserDescription')
        || '';

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

=item WorkingUnitsCompletnessCheck()

returns a hash with the incomplete working days and
the information if the incomplete working day are in the allowed
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

                my $DayString = sprintf( "%02d", $Day );
                my $Weekday = Day_of_Week( $Year, $Month, $Day );
                if ( $Weekday != 6 && $Weekday != 7 && !$VacationCheck ) {
                    $WorkingDays++;
                }
                if (
                    $Weekday != 6
                    && $Weekday != 7
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

    my $Date = sprintf( "%04d-%02d-%02d", $Param{Year}, $Param{Month}, $Param{Day} );
    $Self->{DBObject}->Prepare(
        SQL => "SELECT user_id, project_id, action_id, remark, time_start, time_end,"
            . " period FROM time_accounting_table WHERE time_start LIKE '$Date%'"
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
        my $EndTime = '';
        if ($Row[5] =~ m{^(.+?)\s(\d+:\d+):(\d+)}smx) {
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
        $Data{Total} += $WorkingUnit{Period};
        push @{$Data{WorkingUnits}}, \%WorkingUnit;
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
                Remark    => 'SomeText,
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

    # delete exiting data
    if ( !$Self->WorkingUnitsDelete( %Param ) ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Can\'t delete Working Units!' );
        return;
    }

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

        push @{$Param{WorkingUnits}}, \%Unit;
    }

    #insert new working units
    for my $UnitRef ( @{$Param{WorkingUnits}} ) {

        # db quote
        for ( keys %{ $UnitRef } ) {
            $UnitRef->{$_} = $Self->{DBObject}->Quote( $UnitRef->{$_} ) || '';
        }

        my $StartTime = $Date . ' ' . $UnitRef->{StartTime};
        my $EndTime   = $Date . ' ' . $UnitRef->{EndTime};

        # '' does not work in integer field of postgres
        $UnitRef->{ProjectID} ||= 0;
        $UnitRef->{ActionID}  ||= 0;
        $UnitRef->{Period}    ||= 0;

        # build sql
        my $SQL
            = "INSERT INTO time_accounting_table (user_id, project_id, action_id, remark,"
            . " time_start, time_end, period, created )"
            . " VALUES"
            . " ('$Self->{UserID}', '$UnitRef->{ProjectID}', '$UnitRef->{ActionID}',"
            . " '$UnitRef->{Remark}', '$StartTime', '$EndTime', $UnitRef->{Period},"
            . " current_timestamp)";

        # db insert
        return if !$Self->{DBObject}->Do( SQL => $SQL );
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
        . "WHERE time_start <= '$Date 23:59:59' AND time_start >= '$Date 00:00:00' "
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
        SQL =>
            "SELECT project_id, action_id, period FROM time_accounting_table WHERE $SQL_Query_TimeStart",
    );

    # fetch Data
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        next if !$Row[2];
        $Data{Total}{ $Row[0] }{ $Row[1] }{Hours} += $Row[2];
    }

    $Self->{DBObject}->Prepare(
        SQL => "SELECT project_id, action_id, period FROM time_accounting_table"
            . " WHERE time_start >= '$DateString-01 00:00:00' AND $SQL_Query_TimeStart",
    );

    # fetch Data
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        next if !$Row[2];
        $Data{PerMonth}{ $Row[0] }{ $Row[1] }{Hours} += $Row[2];
    }

    return %Data;
}

=item ProjectTotalHours()

returns the total sum of all hours related to a project

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

returns a array with all WorkingUnits related to a project

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

returns the a array with the last projects of the user

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
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Counter++;
        if ( $Counter < 7 ) {
            $Projects{ $Row[0] } = 1;
        }
    }

    return keys %Projects;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.

=head1 VERSION

$Revision: 1.26 $ $Date: 2009-02-14 13:04:14 $

=cut
