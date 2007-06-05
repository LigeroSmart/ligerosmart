#--
# Kernel/System/TimeAccounting.pm - all time accounting functions
# Copyright (C) 2003-2007 OTRS GmbH, http://otrs.com/
# --
# $Id: TimeAccounting.pm,v 1.10 2007-06-05 14:19:49 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::TimeAccounting;

use strict;
use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.10 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

use Date::Pcalc qw(Today Days_in_Month Day_of_Week);
#use Kernel::System::CalendarEvent;

=head1 NAME#

Kernel::System::TimeAccounting - timeaccounting lib

=head1 SYNOPSIS

All timeaccounting functions

=head1 PUBLIC INTERFACE#

=over 4

=item new()

create a object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::TimeAccounting;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject    = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
    );
    my $TimeAccountingObject = Kernel::System::TimeAccounting->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
        DBObject => $DBObject,
        UserID => 123,
    );

=cut

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # check needed objects
    foreach (qw(DBObject ConfigObject LogObject UserID TimeObject)) {
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
    my $Self    = shift;
    my %Param   = @_;
    my %Data    = ();
    foreach (qw(Year Month Day)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "UserCurrentPeriodGet: Need $_!");
            return;
        }
    }

    my $Date = sprintf("%04d-%02d-%02d", $Param{Year}, $Param{Month}, $Param{Day}) . " 00:00:00";

    # db select
    $Self->{DBObject}->Prepare (
        SQL => "SELECT user_id, preference_period, date_start, date_end, weekly_hours, leave_days, overtime, status FROM time_accounting_user_period ".
            "WHERE date_start <= '" . $Date . "' AND date_end  >='" . $Date . "'",
    );

    # fetch Data
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {

        $Data{$Row[0]}{UserID}           =  $Row[0];
        $Data{$Row[0]}{Period}           =  $Row[1];
        $Data{$Row[0]}{DateStart}        =  substr($Row[2], 0, 10);
        $Data{$Row[0]}{DateEnd}          =  substr($Row[3], 0, 10);
        $Data{$Row[0]}{WeeklyHours}      =  $Row[4];
        $Data{$Row[0]}{LeaveDays}        =  $Row[5];
        $Data{$Row[0]}{Overtime}         =  $Row[6];
        $Data{$Row[0]}{UserStatus}       =  $Row[7];
    }

    return %Data;
}

=item UserReporting()

returns a hash with informations about leavedays, overtimes,
workinghours etc. of all users

    my %Data = $TimeAccountingObject->UserReporting(
        Year  => '2005',
        Month => '12',
        Day   => '12',      # Optional
    );

=cut

sub UserReporting {
    my $Self    = shift;
    my %Param   = @_;
    my %Data    = ();
    foreach (qw(Year Month Day)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
        if (!$Param{$_} && $_ ne 'Day') {
            $Self->{LogObject}->Log(Priority => 'error', Message => "UserReporting: Need $_!");
            return;
        }
    }
    if (!$Param{Day}) {
        $Param{Day} = Days_in_Month($Param{Year},  $Param{Month});
    }

    my %UserCurrentPeriod = $Self->UserCurrentPeriodGet(%Param);
    my $YearStart       = 0;
    my $MonthStart      = 0;
    my $DayStart        = 0;
    my $MonthStartPoint = 0;
    my $DayStartPoint   = 0;
    my $MonthEndPoint   = 0;
    my $DayEndPoint     = 0;
    my $YearEnd         = $Param{Year};
    my $MonthEnd        = $Param{Month};
    my $DayEnd          = $Param{Day};

    foreach my $UserID (keys %UserCurrentPeriod){
        if ($UserCurrentPeriod{$UserID}{DateStart} =~ /^(\d+)-(\d+)-(\d+)/) {
            $YearStart  = $1;
            $MonthStart = $2;
            $DayStart   = $3;
        }
        $Data{$UserID}{LeaveDay}         = 0;
        $Data{$UserID}{Diseased}         = 0;
        $Data{$UserID}{Overtime}         = 0;
        $Data{$UserID}{TargetState}      = 0;
        $Data{$UserID}{LeaveDayTotal}    = 0;
        $Data{$UserID}{DiseasedTotal}    = 0;
        $Data{$UserID}{OvertimeTotal}    = 0;
        $Data{$UserID}{TargetStateTotal} = 0;

        my $Counter = 0;
        for (my $Year = $YearStart; $Year <= $YearEnd; $Year++) {
            if ($Year == $YearStart) {
                $MonthStartPoint = $MonthStart;
            }
            else {
                $MonthStartPoint = 1;
            }
            if ($Year == $YearEnd) {
                $MonthEndPoint = $MonthEnd;
            }
            else {
                $MonthEndPoint = 12;
            }
            for (my $Month = $MonthStartPoint; $Month <= $MonthEndPoint; $Month++) {
                if ($Year == $YearStart && $Month == $MonthStart ) {
                    $DayStartPoint = $DayStart;
                }
                else {
                    $DayStartPoint = 1;
                }
                if ($Year == $YearEnd && $Month == $MonthEnd ) {
                    $DayEndPoint = $DayEnd;
                }
                else {
                    $DayEndPoint = Days_in_Month($Year, $Month);
                }
                for (my $Day = $DayStartPoint; $Day <= $DayEndPoint; $Day++) {
                    my %WorkingUnit = $Self->WorkingUnitsGet(
                        Year   => $Year,
                        Month  => $Month,
                        Day    => $Day,
                        UserID => $UserID,
                    );
                    my $WorkingHours = 0;
                    my $LeaveDay     = 0;
                    my $Diseased     = 0;
                    my $Overtime     = 0;
                    my $TargetState  = 0;
                    foreach (keys %WorkingUnit) {
                        $WorkingHours += $WorkingUnit{$_}{Period};
                        if ($WorkingUnit{$_}{ProjectID} == -1) {
                            if ($WorkingUnit{$_}{ActionID} == -2) {
                                $Data{$UserID}{LeaveDayTotal}++;
                                $LeaveDay = 1;
                            }
                            elsif ($WorkingUnit{$_}{ActionID} == -1) {
                                $Data{$UserID}{DiseasedTotal}++;
                                $Diseased = 1;
                            }
                            elsif ($WorkingUnit{$_}{ActionID} == -3) {
                                $Data{$UserID}{OvertimeTotal}++;
                                $Overtime = 1;
                            }
                        }
                    }

                    $Data{$UserID}{WorkingHoursTotal} += $WorkingHours;
                    my $VacationCheck = $Self->VacationCheck(
                        Year  => $Year,
                        Month => $Month,
                        Day   => $Day,
                    );
                    my $Weekday = Day_of_Week($Year, $Month, $Day);
                    if ($Weekday != 6 && $Weekday != 7
                        && !$VacationCheck
                        && !$Diseased && !$LeaveDay
                    ) {
                        $Data{$UserID}{TargetStateTotal} += $UserCurrentPeriod{$UserID}{WeeklyHours}/5;
                        $TargetState = $UserCurrentPeriod{$UserID}{WeeklyHours}/5;
                    }

                    if ($Month == $MonthEnd && $Year == $YearEnd) {
                        $Data{$UserID}{TargetState}  += $TargetState;
                        $Data{$UserID}{WorkingHours} += $WorkingHours;
                        $Data{$UserID}{LeaveDay}     += $LeaveDay;
                        $Data{$UserID}{Diseased}     += $Diseased;
                    }
                }
            }
        }
        $Data{$UserID}{Overtime}          = $Data{$UserID}{WorkingHours}           - $Data{$UserID}{TargetState};
        $Data{$UserID}{OvertimeTotal}     = $UserCurrentPeriod{$UserID}{Overtime}  + $Data{$UserID}{WorkingHoursTotal} - $Data{$UserID}{TargetStateTotal};
        $Data{$UserID}{OvertimeUntil}     = $Data{$UserID}{OvertimeTotal}          - $Data{$UserID}{Overtime};
        $Data{$UserID}{LeaveDayRemaining} = $UserCurrentPeriod{$UserID}{LeaveDays} - $Data{$UserID}{LeaveDayTotal};
    }
    return %Data;
}

=item ProjectSettingsGet()

returns a hash with the project data

    my %ProjectData = $TimeAccountingObject->ProjectSettingsGet();

=cut

sub ProjectSettingsGet {
    my $Self    = shift;
    my %Data    = ();

    # db select
    $Self->{DBObject}->Prepare (
        SQL => "SELECT id, project, description, status FROM time_accounting_project",
    );

    # fetch Data
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Data{Project}           {$Row[0]} =  $Row[1];
        $Data{ProjectDescription}{$Row[0]} =  $Row[2];
        $Data{ProjectStatus}     {$Row[0]} =  $Row[3];
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
    my $Self    = shift;
    my %Param   = @_;

    if (!$Param{Project}) {
        $Param{Project}       = $Self->{ConfigObject}->Get('TimeAccounting::DefaultProjectName') || '';
    }
    if (!$Param{ProjectStatus}) {
        $Param{ProjectStatus} = $Self->{ConfigObject}->Get('TimeAccounting::DefaultProjectStatus') || '0';
    }

    if (!$Param{ProjectDescription}) {
        $Param{ProjectDescription} = '';
    }

    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }

    # build sql

    my $SQL = "INSERT INTO time_accounting_project (project, description, status) " .
        "VALUES " .
        "('" . $Param{Project} . "', '" . $Param{ProjectDescription} . "', '" . $Param{ProjectStatus} . "')";

    # db insert
    if (!$Self->{DBObject}->Do(SQL => $SQL)) {
        return;
    }
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
    my $Self    = shift;
    my %Param   = @_;

    foreach my $ProjectID (sort keys  %Param) {
        if ($Param{$ProjectID}{Project}) {
            # db quote
            foreach (keys %{$Param{$ProjectID}}) {
                $Param{$ProjectID}{$_} = $Self->{DBObject}->Quote($Param{$ProjectID}{$_}) || '';
            }
            # build sql
            my $SQL = "UPDATE time_accounting_project " .
                "SET project = '" . $Param{$ProjectID}{Project}.
                    "', status = '" . $Param{$ProjectID}{ProjectStatus} .
                    "', description = '" . $Param{$ProjectID}{ProjectDescription} . "' " .
                "WHERE id = '" . $ProjectID . "'";
            # db insert
            if (!$Self->{DBObject}->Do(SQL => $SQL)) {
                return;
            }
        }
    }
    return 1;
}

=item ActionSettingsGet()

returns a hash with the action settings

    my %ActionData = $TimeAccountingObject->ActionSettingsGet();

=cut

sub ActionSettingsGet {
    my $Self    = shift;
    my %Data    = ();

    # db select
    $Self->{DBObject}->Prepare (
        SQL => "SELECT id, action, status FROM time_accounting_action",
    );

    # fetch Data
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Data{$Row[0]}{Action}       =  $Row[1];
        $Data{$Row[0]}{ActionStatus} =  $Row[2];
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
    my $Self    = shift;
    my %Param   = @_;

    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }

    if (!$Param{Action}) {
        $Param{Action}       = $Self->{ConfigObject}->Get('TimeAccounting::DefaultActionName') || '';
    }
    if (!$Param{ActionStatus}) {
        $Param{ActionStatus} = $Self->{ConfigObject}->Get('TimeAccounting::DefaultActionStatus') || '0';
    }

    # build sql
    my $SQL = "INSERT INTO time_accounting_action (action, status)" .
        " VALUES" .
        " ('" . $Param{Action}. "' , '" . $Param{ActionStatus} . "')";
    # db insert
    if (!$Self->{DBObject}->Do(SQL => $SQL)) {
        return;
    }
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
    my $Self    = shift;
    my %Param   = @_;
    my $SQL     = '';

    foreach my $ActionID (sort keys  %Param) {
        if ($Param{$ActionID}{Action}) {
            # db quote
            foreach (keys %{$Param{$ActionID}}) {
                $Param{$ActionID}{$_} = $Self->{DBObject}->Quote($Param{$ActionID}{$_}) || '';
            }
            # build sql
            $SQL = "UPDATE time_accounting_action " .
                "SET action = '" . $Param{$ActionID}{Action}. "', status = '" . $Param{$ActionID}{ActionStatus} . "' " .
                "WHERE id = '" . $ActionID . "'";
            # db insert
            if (!$Self->{DBObject}->Do(SQL => $SQL)) {
                return;
            }
        }
    }
    return 1;
}

=item UserGet()

returns a hash with the user data

    my %UserData = $TimeAccountingObject->UserGet();

=cut

sub UserGet {
    my $Self    = shift;
    my %Data    = ();
    # db select
    $Self->{DBObject}->Prepare (
        SQL => "SELECT user_id, description, show_overtime, create_project FROM time_accounting_user",
    );

    # fetch Data
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Data{$Row[0]}{UserID}        =  $Row[0];
        $Data{$Row[0]}{Description}   =  $Row[1];
        $Data{$Row[0]}{ShowOvertime}  =  $Row[2];
        $Data{$Row[0]}{CreateProject} =  $Row[3];
    }
    return %Data;
}

=item UserSettingsGet()

returns a hash with the user period data

    my %UserData = $TimeAccountingObject->UserSettingsGet();

=cut

sub UserSettingsGet {
    my $Self    = shift;
    my %Data    = ();
    # db select
    $Self->{DBObject}->Prepare (
        SQL => "SELECT user_id, preference_period, date_start, date_end, weekly_hours, leave_days, overtime, status FROM time_accounting_user_period",
    );

    # fetch Data
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Data{$Row[0]}{$Row[1]}{UserID}           =  $Row[0];
        $Data{$Row[0]}{$Row[1]}{Period}           =  $Row[1];
        $Data{$Row[0]}{$Row[1]}{DateStart}        =  substr($Row[2], 0, 10);
        $Data{$Row[0]}{$Row[1]}{DateEnd}          =  substr($Row[3], 0, 10);
        $Data{$Row[0]}{$Row[1]}{WeeklyHours}      =  $Row[4];
        $Data{$Row[0]}{$Row[1]}{LeaveDays}        =  $Row[5];
        $Data{$Row[0]}{$Row[1]}{Overtime}         =  $Row[6];
        $Data{$Row[0]}{$Row[1]}{UserStatus}       =  $Row[7];
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
    my $Self    = shift;
    my %Param   = @_;
    my $ID      = '';
    my $SQL     = '';

    $Param{WeeklyHours} = $Self->{ConfigObject}->Get('TimeAccounting::DefaultUserWeeklyHours') || '40';
    $Param{LeaveDays}   = $Self->{ConfigObject}->Get('TimeAccounting::DefaultUserLeaveDays')   || '25';
    $Param{UserStatus}  = $Self->{ConfigObject}->Get('TimeAccounting::DefaultUserStatus')      || '1';
    $Param{Overtime}    = $Self->{ConfigObject}->Get('TimeAccounting::DefaultUserOvertime')    || '0';
    $Param{DateEnd}     = $Self->{ConfigObject}->Get('TimeAccounting::DefaultUserDateEnd')     || '2007-12-31';
    $Param{DateStart}   = $Self->{ConfigObject}->Get('TimeAccounting::DefaultUserDateStart')   || '2007-01-01';
    $Param{Description}   = $Self->{ConfigObject}->Get('TimeAccounting::DefaultUserDescription') || '';

    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
        if( !defined($Param{$_})) {
            $Param{$_} = '';
        }
    }

    # build sql
    $SQL = "INSERT INTO time_accounting_user_period (user_id, preference_period, date_start, date_end," .
        " weekly_hours, leave_days, overtime, status)" .
        " VALUES" .
        " ('$Param{UserID}', '$Param{Period}', '$Param{DateStart} 00:00:00', '$Param{DateEnd} 00:00:00'," .
        " '$Param{WeeklyHours}', '$Param{LeaveDays}', '$Param{Overtime}', '$Param{UserStatus}')";
    # db insert
    if (!$Self->{DBObject}->Do(SQL => $SQL)) {
        return;
    }

    # Split the following code in a seperate function!

    #check if the user still exists
    my $UserID;
    # build sql
    $Self->{DBObject}->Prepare (
        SQL => "SELECT user_id FROM time_accounting_user WHERE user_id = '" . $Param{UserID}. "'",
    );

    # fetch Data
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $UserID           =  $Row[0];
    }
    if (!defined($UserID)) {
        $SQL = "INSERT INTO time_accounting_user (user_id, description)" .
            " VALUES" .
            " ('$Param{UserID}', '$Param{Description}')";
        # db insert
        if (!$Self->{DBObject}->Do(SQL => $SQL)) {
            return;
        }
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
    my $Self    = shift;
    my %Param   = @_;
    foreach my $UserID (sort keys  %Param) {
        foreach (qw(UserID Description)) {
            $Param{$UserID}{$_} = $Self->{DBObject}->Quote($Param{$UserID}{$_}) || '';
        }

        #set default for ShowOverTime...
        if( !defined($Param{$UserID}{ShowOvertime})) {
            $Param{$UserID}{ShowOvertime} = 0;
        }

        #set default for CreateProject...
        if( !defined($Param{$UserID}{CreateProject})) {
            $Param{$UserID}{CreateProject} = 0;
        }

        # build sql
        my $SQL = "UPDATE time_accounting_user " .
            "SET description = '"   . $Param{$UserID}{Description} .
            "', show_overtime = '"  . $Param{$UserID}{ShowOvertime} .
            "', create_project = '" . $Param{$UserID}{CreateProject} . "' " .
            "WHERE user_id = '" . $Param{$UserID}{UserID}. "'";
        # db insert
        if (!$Self->{DBObject}->Do(SQL => $SQL)) {
            return;
        }

        foreach (qw(UserID Description ShowOvertime CreateProject)) {
            delete ($Param{$UserID}{$_});
        }

        foreach my $Period (keys %{$Param{$UserID}}) {
            # db quote
            foreach (keys %{$Param{$UserID}{$Period}}) {
                $Param{$UserID}{$Period}{$_} = $Self->{DBObject}->Quote($Param{$UserID}{$Period}{$_}) || '';
            }
            # build sql
            my $SQL = "UPDATE time_accounting_user_period " .
                "SET leave_days = '"  . $Param{$UserID}{$Period}{LeaveDays} .
                "', date_start = '"   . $Param{$UserID}{$Period}{DateStart} .
                "', date_end = '"     . $Param{$UserID}{$Period}{DateEnd} .
                "', overtime = '"     . $Param{$UserID}{$Period}{Overtime} .
                "', weekly_hours = '" . $Param{$UserID}{$Period}{WeeklyHours} .
                "', status = '"       . $Param{$UserID}{$Period}{UserStatus}. "' " .
                "WHERE user_id = '" . $Param{$UserID}{$Period}{UserID} .
                "' AND preference_period = '" . $Period . "'";
            # db insert
            if (!$Self->{DBObject}->Do(SQL => $SQL)) {
                return;
            }
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
    my $Self                = shift;
    my %Param               = @_;
    my %Data                = ();
    my $WorkingUnitID       = 0;
    my %CompleteWorkingDays = ();
    my ($Sec, $Min, $Hour, $Day, $Month, $Year) = $Self->{TimeObject}->SystemTime2Date(
        SystemTime => $Self->{TimeObject}->SystemTime(),
    );

    $Param{UserID} = $Self->{DBObject}->Quote($Param{UserID}) || '';

    if (!$Param{UserID}) {
        $Param{UserID} = $Self->{UserID};
    }

    $Self->{DBObject}->Prepare (
        SQL => "SELECT DISTINCT time_start FROM time_accounting_table WHERE user_id = '$Param{UserID}'",
    );

    # fetch Data
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        if ($Row[0] =~ /^(\d+)-(\d+)-(\d+)(.+?)/) {
            $CompleteWorkingDays{$1}{$2}{$3} = 1;
        }
    }
    my %UserCurrentPeriod = $Self->UserCurrentPeriodGet(
        Year   => $Year,
        Month  => $Month,
        Day    => $Day,
    );
    my $WorkingDays     = 0;
    my $YearStart       = 0;
    my $MonthStart      = 0;
    my $DayStart        = 0;
    my $MonthStartPoint = 0;
    my $DayStartPoint   = 0;
    my $MonthEndPoint   = 0;
    my $DayEndPoint     = 0;
    my $YearEnd         = $Year;
    my $MonthEnd        = $Month;
    my $DayEnd          = $Day;

    if ($UserCurrentPeriod{$Param{UserID}}{DateStart} =~ /^(\d+)-(\d+)-(\d+)/) {
        $YearStart  = $1;
        $MonthStart = $2;
        $DayStart   = $3;
    }

    for (my $Year = $YearStart; $Year <= $YearEnd; $Year++) {
        if ($Year == $YearStart) {
            $MonthStartPoint = $MonthStart;
        }
        else {
            $MonthStartPoint = 1;
        }
        if ($Year == $YearEnd) {
            $MonthEndPoint = $MonthEnd;
        }
        else {
            $MonthEndPoint = 12;
        }
        for (my $Month = $MonthStartPoint; $Month <= $MonthEndPoint; $Month++) {
            if ($Year == $YearStart && $Month == $MonthStart ) {
                $DayStartPoint = $DayStart;
            }
            else {
                $DayStartPoint = 1;
            }
            if ($Year == $YearEnd && $Month == $MonthEnd ) {
                $DayEndPoint = $DayEnd;
            }
            else {
                $DayEndPoint = Days_in_Month($Year, $Month);
            }
            my $MonthString = sprintf("%02d",$Month);
            for (my $Day = $DayStartPoint; $Day <= $DayEndPoint; $Day++) {
                my $VacationCheck = $Self->VacationCheck(
                    Year  => $Year,
                    Month => $Month,
                    Day   => $Day,
                );

                my $DayString = sprintf("%02d",$Day);
                my $Weekday = Day_of_Week($Year, $Month, $Day);
                if ($Weekday != 6 && $Weekday != 7 && !$VacationCheck) {
                    $WorkingDays++;
                }
                if ($Weekday != 6 && $Weekday != 7
                    && !$VacationCheck
                    && !$CompleteWorkingDays{$Year}{$MonthString}{$DayString}
                ) {
                    $Data{Incomplete}{$Year}{$MonthString}{$DayString} = $WorkingDays;
                }
            }
        }
    }
    my $MaxIntervallOfIncompleteDays              = $Self->{ConfigObject}->Get('TimeAccounting::MaxIntervalOfIncompleteDays') || '5';
    my $MaxIntervallOfIncompleteDaysBeforeWarning = $Self->{ConfigObject}->Get('TimeAccounting::MaxIntervalOfIncompleteDaysBeforeWarning') || '3';

    foreach my $Year (keys %{$Data{Incomplete}}) {
        foreach my $Month (keys %{$Data{Incomplete}{$Year}}) {
            foreach my $Day (keys %{$Data{Incomplete}{$Year}{$Month}}) {
                if ($Data{Incomplete}{$Year}{$Month}{$Day} < $WorkingDays - $MaxIntervallOfIncompleteDays) {
                    $Data{EnforceInsert} = 1;
                }
                elsif ($Data{Incomplete}{$Year}{$Month}{$Day} < $WorkingDays - $MaxIntervallOfIncompleteDaysBeforeWarning) {
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
    my $Self          = shift;
    my %Param         = @_;
    my %Data          = ();
    my $WorkingUnitID = 0;
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }
    if (!$Param{UserID}) {
        $Param{UserID} = $Self->{UserID};
    }

    my $Date = sprintf("%04d-%02d-%02d", $Param{Year}, $Param{Month}, $Param{Day});
    $Self->{DBObject}->Prepare (
        SQL => "SELECT user_id, project_id, action_id, remark, time_start, time_end," .
            " period FROM time_accounting_table WHERE time_start LIKE '$Date%'" .
            " AND user_id = '$Param{UserID}' ORDER by id",
    );

    # fetch Data
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        if ($Row[4] =~ /^(.+?)\s(\d+:\d+):(\d+)/) {
            $WorkingUnitID++;
            $Data{$WorkingUnitID}{UserID}     =  $Row[0];
            $Data{$WorkingUnitID}{ProjectID}  =  $Row[1];
            $Data{$WorkingUnitID}{ActionID}   =  $Row[2];
            $Data{$WorkingUnitID}{Remark}     =  $Row[3];
            $Data{$WorkingUnitID}{StartTime}  =  $2;
            if( defined($Row[6])) {
                $Data{$WorkingUnitID}{Period}     =  sprintf ("%.2f", $Row[6]);
            } else {
                $Data{$WorkingUnitID}{Period}     =  0;
            }

            $Data{$WorkingUnitID}{Date}       =  $1;
            if ($Row[5] =~ /^(.+?)\s(\d+:\d+):(\d+)/) {
                $Data{$WorkingUnitID}{EndTime}    =  $2;
            }
        }
    }
    return %Data;
}

=item WorkingUnitsInsert()

insert working units in the db

    $TimeAccountingObject->WorkingUnitsInsert(
        Year  => '2005',
        Month => '07',
        Day   => '02',
        1    => {
            ProjectID => 1,
            ActionID  => 23,
            Remark    => 4,
            StartTime => '7:30',
            EndTime   => '11:00',
            Period    => '8.5',
        },
        2 ......
    );

=cut

sub WorkingUnitsInsert {
    my $Self    = shift;
    my %Param   = @_;
    my $SQL     = '';

    foreach (qw(Year Month Day)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "WorkingUnitsInsert: Need $_!");
            return;
        }
    }
    my $Date = sprintf("%04d-%02d-%02d", $Param{Year}, $Param{Month}, $Param{Day});

    if (!$Self->WorkingUnitsDelete(
            Year  => $Param{Year},
            Month => $Param{Month},
            Day   => $Param{Day},
        )
    ) {
        $Self->{LogObject}->Log(Priority => 'error', Message => 'Can\'t delete Working Units!');
        return;
    }

    delete $Param{Year};
    delete $Param{Month};
    delete $Param{Day};

    #insert new working units
    foreach my $WorkingUnitID (sort keys  %Param) {
        # db quote
        foreach (keys %{$Param{$WorkingUnitID}}) {
            $Param{$WorkingUnitID}{$_} = $Self->{DBObject}->Quote($Param{$WorkingUnitID}{$_}) || '';
        }
        my $StartTime = $Date." ".$Param{$WorkingUnitID}{StartTime};
        my $EndTime   = $Date." ".$Param{$WorkingUnitID}{EndTime};

        if( (!defined($Param{$WorkingUnitID}{Period})) || ($Param{$WorkingUnitID}{Period} eq '')) {
            $Param{$WorkingUnitID}{Period} = 'NULL';
        }

        # build sql
        $SQL = "INSERT INTO time_accounting_table (user_id, project_id, action_id, remark," .
            " time_start, time_end, period, created )" .
            " VALUES" .
            " ('$Self->{UserID}', '$Param{$WorkingUnitID}{ProjectID}', '$Param{$WorkingUnitID}{ActionID}'," .
            " '$Param{$WorkingUnitID}{Remark}', '$StartTime', '$EndTime', $Param{$WorkingUnitID}{Period}," .
            " current_timestamp)";
        # db insert
        if (!$Self->{DBObject}->Do(SQL => $SQL)) {
            return;
        }
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
    my $Self    = shift;
    my %Param   = @_;
    my $SQL     = '';

    foreach (qw(Year Month Day)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "WorkingUnitsInsert: Need $_!");
            return;
        }
    }
    my $Date = sprintf("%04d-%02d-%02d", $Param{Year}, $Param{Month}, $Param{Day});

    # delete old working units
    $SQL = "DELETE FROM time_accounting_table " .
        "WHERE time_start LIKE '$Date%' AND user_id = '$Self->{UserID}'" ;
    if (!$Self->{DBObject}->Do(SQL => $SQL)) {
        return ;
    }
    return 1;
}

# FRAMEWORK-2.1: this function should be included in the timeobject
=item VacationCheck()

check if the selected day is a vacation (it doesn't matter if you
insert 01 or 1 for month or day in the function or in the SysConfig)

    $TimeAccountingObject->VacationCheck(
        Year  => '2005',
        Month => '7', || 07
        Day   => '13',
    );

=cut

sub VacationCheck {
    my $Self         = shift;
    my %Param        = @_;
    my $VacationName = '';

    # check required params
    foreach (qw(Year Month Day)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "VacationCheck: Need $_!"
            );
            return;
        }
    }
    $Param{Month} = sprintf("%02d", $Param{Month});
    $Param{Day}   = sprintf("%02d", $Param{Day});

    my $TimeVacationDays        = $Self->{ConfigObject}->Get('TimeVacationDays');
    my $TimeVacationDaysOneTime = $Self->{ConfigObject}->Get('TimeVacationDaysOneTime');
    if (defined($TimeVacationDays->{$Param{Month}}->{$Param{Day}})) {
        return $TimeVacationDays->{$Param{Month}}->{$Param{Day}};
    }
    elsif (defined($TimeVacationDaysOneTime->{$Param{Year}}->{$Param{Month}}->{$Param{Day}})) {
        return $TimeVacationDaysOneTime->{$Param{Year}}->{$Param{Month}}->{$Param{Day}};
    }
    elsif (defined($TimeVacationDays->{int($Param{Month})}->{int($Param{Day})})) {
        return $TimeVacationDays->{int($Param{Month})}->{int($Param{Day})};
    }
    elsif (defined($TimeVacationDaysOneTime->{$Param{Year}}->{int($Param{Month})}->{int($Param{Day})})) {
        return $TimeVacationDaysOneTime->{$Param{Year}}->{int($Param{Month})}->{int($Param{Day})};
    }
    return;
}

=item ProjectActionReporting()

returns a hash with the hours dependent project and action data

    my %ProjectData = $TimeAccountingObject->ProjectActionReporting(
        Year  => 2005,
        Month => 7,
        UserID => 123,
    );

=cut

sub ProjectActionReporting {
    my $Self     = shift;
    my %Param    = @_;
    my %Data     = ();
    my $IDSelect = '';
    foreach (qw(Year Month)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "ProjectActionReporting: Need $_!");
            return;
        }
    }
    if ($Param{UserID}) {
        $Param{UserID} = $Self->{DBObject}->Quote($Param{UserID}) || '';
        $IDSelect = " AND user_id = '$Param{UserID}'";
    }
    # hours per month
    my $DateString = $Param{Year} . "-" . sprintf("%02d", $Param{Month});

    my $SQL_Query_TimeStart = "time_start <= '$DateString-31 23:59:59'$IDSelect";

    #tto: yes, I know there are some non-leap-years, ...
    #...but com'on these few entries in the error log won't bother too much... :-)
    if( ($Param{Month} == 2) || ($Param{Month} == 4) || ($Param{Month} == 6) || ($Param{Month} == 9) || ($Param{Month} == 11)){
        $SQL_Query_TimeStart = "time_start <= '$DateString-30 23:59:59'$IDSelect";
    }

    # Total hours
    $Self->{DBObject}->Prepare (
        SQL => "SELECT project_id, action_id, period FROM time_accounting_table WHERE $SQL_Query_TimeStart",
    );
    # fetch Data
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Data{Total}{$Row[0]}{$Row[1]}{Hours} += $Row[2];
    }

    $Self->{DBObject}->Prepare (
        SQL => "SELECT project_id, action_id, period FROM time_accounting_table" .
            " WHERE time_start >= '$DateString-01 00:00:00' AND $SQL_Query_TimeStart",
    );

    # fetch Data
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Data{PerMonth}{$Row[0]}{$Row[1]}{Hours} += $Row[2];
    }
    return %Data;

}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=head1 VERSION

$Revision: 1.10 $ $Date: 2007-06-05 14:19:49 $

=cut
