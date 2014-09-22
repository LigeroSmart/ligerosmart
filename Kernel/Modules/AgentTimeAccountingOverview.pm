# --
# Kernel/Modules/AgentTimeAccountingOverview.pm - time accounting overview module
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTimeAccountingOverview;

use strict;
use warnings;

use Kernel::System::TimeAccounting;
use Date::Pcalc qw(Today Days_in_Month Day_of_Week Add_Delta_YMD check_date);
use Time::Local;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed Objects
    for my $Needed (
        qw(ParamObject DBObject ModuleReg LogObject UserObject
        ConfigObject TicketObject TimeObject GroupObject)
        )
    {
        $Self->{LayoutObject}->FatalError( Message => "Got no $Needed!" ) if !$Self->{$Needed};
    }

    # create required objects...
    $Self->{TimeAccountingObject} = Kernel::System::TimeAccounting->new(%Param);

    return $Self;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    # permission check
    return 1 if !$Self->{AccessRo};

    my ( $Sec, $Min, $Hour, $Day, $Month, $Year )
        = $Self->{TimeObject}->SystemTime2Date( SystemTime => $Self->{TimeObject}->SystemTime() );

    my %User = $Self->{TimeAccountingObject}->UserCurrentPeriodGet(
        Year  => $Year,
        Month => $Month,
        Day   => $Day,
    );

    return if !$User{ $Self->{UserID} };

    my %IncompleteWorkingDays = $Self->{TimeAccountingObject}->WorkingUnitsCompletnessCheck(
        UserID => $Self->{UserID},
    );

    # redirect if incomplete working day are out of range
    if (
        $IncompleteWorkingDays{EnforceInsert}
        && $Self->{Action} ne 'AgentTimeAccounting'
        && $Self->{Action} ne 'AgentCalendarSmall'
        )
    {
        return $Self->{LayoutObject}->Redirect( OP => 'Action=AgentTimeAccountingEdit' );
    }
    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my @MonthArray = (
        '',     'January', 'February', 'March',     'April',   'May',
        'June', 'July',    'August',   'September', 'October', 'November',
        'December',
    );
    my @WeekdayArray = ( 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun', );

    # ---------------------------------------------------------- #
    # overview about the users time accounting
    # ---------------------------------------------------------- #
    my ( $Sec, $Min, $Hour, $CurrentDay, $Month, $Year )
        = $Self->{TimeObject}->SystemTime2Date(
        SystemTime => $Self->{TimeObject}->SystemTime(),
        );

    # permission check
    return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' ) if !$Self->{AccessRo};

    for my $Parameter (qw(Status Day Month Year UserID ProjectStatusShow)) {
        $Param{$Parameter} = $Self->{ParamObject}->GetParam( Param => $Parameter );
    }
    $Param{Action} = 'AgentTimeAccountingEdit';

    if ( !$Param{UserID} ) {
        $Param{UserID} = $Self->{UserID};
    }
    else {
        if ( $Param{UserID} != $Self->{UserID} && !$Self->{AccessRw} ) {
            return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
        }
        $Param{Action} = 'AgentTimeAccountingView';
    }
    if ( $Param{UserID} != $Self->{UserID} ) {
        my %ShownUsers = $Self->{UserObject}->UserList( Type => 'Long', Valid => 1 );
        $Param{User} = $ShownUsers{ $Param{UserID} };
        $Self->{LayoutObject}->Block(
            Name => 'User',
            Data => {%Param},
        );
    }

    # Check Date
    if ( !$Param{Year} || !$Param{Month} ) {
        $Param{Year}  = $Year;
        $Param{Month} = $Month;
    }
    else {
        $Param{Month} = sprintf( "%02d", $Param{Month} );
    }

    # store last screen
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreen',
        Value =>
            "Action=$Self->{Action};Year=$Param{Year};Month=$Param{Month}",
    );

    $Param{Month_to_Text} = $MonthArray[ $Param{Month} ];

    ( $Param{YearBack}, $Param{MonthBack}, $Param{DayBack} )
        = Add_Delta_YMD( $Param{Year}, $Param{Month}, 1, 0, -1, 0 );
    ( $Param{YearNext}, $Param{MonthNext}, $Param{DayNext} )
        = Add_Delta_YMD( $Param{Year}, $Param{Month}, 1, 0, 1, 0 );

    # Overview per day
    my $DaysOfMonth = Days_in_Month( $Param{Year}, $Param{Month} );

    my %UserData = $Self->{TimeAccountingObject}->UserGet(
        UserID => $Param{UserID},
    );

    for my $Day ( 1 .. $DaysOfMonth ) {
        $Param{Day} = sprintf( "%02d", $Day );
        $Param{Weekday} = Day_of_Week( $Param{Year}, $Param{Month}, $Day ) - 1;
        my $VacationCheck = $Self->{TimeObject}->VacationCheck(
            Year     => $Param{Year},
            Month    => $Param{Month},
            Day      => $Day,
            Calendar => $UserData{Calendar},
        );

        my $Date = sprintf( "%04d-%02d-%02d", $Param{Year}, $Param{Month}, $Day );
        my $DayStartTime
            = $Self->{TimeObject}->TimeStamp2SystemTime( String => $Date . ' 00:00:00' );
        my $DayStopTime
            = $Self->{TimeObject}->TimeStamp2SystemTime( String => $Date . ' 23:59:59' );

        # add time zone to calculation
        my $UserCalendar = $UserData{Calendar} || '';
        my $Zone = $Self->{ConfigObject}->Get( "TimeZone::Calendar" . $UserCalendar );
        if ($Zone) {
            my $ZoneSeconds = $Zone * 60 * 60;
            $DayStartTime = $DayStartTime - $ZoneSeconds;
            $DayStopTime  = $DayStopTime - $ZoneSeconds;
        }

        my $ThisDayWorkingTime = $Self->{TimeObject}->WorkingTime(
            StartTime => $DayStartTime,
            StopTime  => $DayStopTime,
            Calendar  => $UserCalendar,
        ) || '0';

        if ( $Param{Year} eq $Year && $Param{Month} eq $Month && $CurrentDay eq $Day ) {
            $Param{Class} = 'Active';
        }
        elsif ($VacationCheck) {
            $Param{Class}   = 'Vacation';
            $Param{Comment} = $VacationCheck;
        }
        elsif ($ThisDayWorkingTime) {
            $Param{Class} = 'WorkingDay';
        }
        else {
            $Param{Class} = 'NonWorkingDay';
        }

        my %Data = $Self->{TimeAccountingObject}->WorkingUnitsGet(
            Year   => $Param{Year},
            Month  => $Param{Month},
            Day    => $Param{Day},
            UserID => $Param{UserID},
        );

        $Param{Comment} = $Data{Sick}
            ? 'Sick leave'
            : $Data{LeaveDay} ? 'On vacation'
            : $Data{Overtime} ? 'On overtime leave'
            :                   '';

        $Param{WorkingHours} = $Data{Total} ? sprintf( "%.2f", $Data{Total} ) : '';

        $Param{Weekday_to_Text} = $WeekdayArray[ $Param{Weekday} ];
        $Self->{LayoutObject}->Block(
            Name => 'Row',
            Data => {%Param},
        );
        $Param{Comment} = '';
    }

    my %UserReport = $Self->{TimeAccountingObject}->UserReporting(
        Year  => $Param{Year},
        Month => $Param{Month},
    );
    for my $ReportElement (
        qw(TargetState TargetStateTotal WorkingHoursTotal WorkingHours
        Overtime OvertimeTotal OvertimeUntil LeaveDay LeaveDayTotal
        LeaveDayRemaining Sick SickTotal SickRemaining)
        )
    {
        $UserReport{ $Param{UserID} }{$ReportElement} ||= 0;
        $Param{$ReportElement}
            = sprintf( "%.2f", $UserReport{ $Param{UserID} }{$ReportElement} );
    }

    if ( $UserData{ShowOvertime} ) {
        $Self->{LayoutObject}->Block(
            Name => 'Overtime',
            Data => \%Param,
        );
    }

    # Overview per project and action
    my %ProjectData = $Self->{TimeAccountingObject}->ProjectActionReporting(
        Year   => $Param{Year},
        Month  => $Param{Month},
        UserID => $Param{UserID},
    );

    # show the report sort by projects
    if ( !$Param{ProjectStatusShow} || $Param{ProjectStatusShow} eq 'valid' ) {
        $Param{ProjectStatusShow} = 'all';
    }
    elsif ( $Param{ProjectStatusShow} eq 'all' ) {
        $Param{ProjectStatusShow} = 'valid';
    }

    $Param{ShowProjects} = 'Show ' . $Param{ProjectStatusShow} . ' projects';

    PROJECTID:
    for my $ProjectID (
        sort { $ProjectData{$a}{Name} cmp $ProjectData{$b}{Name} }
        keys %ProjectData
        )
    {
        my $ProjectRef = $ProjectData{$ProjectID};
        my $ActionsRef = $ProjectRef->{Actions};

        $Param{Project} = '';
        $Param{Status} = $ProjectRef->{Status} ? '' : 'passiv';

        my $Total      = 0;
        my $TotalTotal = 0;

        next PROJECTID if $Param{ProjectStatusShow} eq 'all' && $Param{Status};

        if ($ActionsRef) {
            for my $ActionID (
                sort { $ActionsRef->{$a}{Name} cmp $ActionsRef->{$b}{Name} }
                keys %{$ActionsRef}
                )
            {
                my $ActionRef = $ActionsRef->{$ActionID};

                $Param{Action}     = $ActionRef->{Name};
                $Param{Hours}      = sprintf( "%.2f", $ActionRef->{PerMonth} || 0 );
                $Param{HoursTotal} = sprintf( "%.2f", $ActionRef->{Total} || 0 );
                $Total      += $Param{Hours};
                $TotalTotal += $Param{HoursTotal};
                $Self->{LayoutObject}->Block(
                    Name => 'Action',
                    Data => {%Param},
                );
                if ( !$Param{Project} ) {
                    $Param{Project} = $ProjectRef->{Name};
                    my $ProjectDescription = $Self->{LayoutObject}->Ascii2Html(
                        Text           => $ProjectRef->{Description},
                        HTMLResultMode => 1,
                        NewLine        => 50,
                    );

                    $Self->{LayoutObject}->Block(
                        Name => 'Project',
                        Data => {
                            RowSpan => ( 1 + scalar keys %{$ActionsRef} ),
                            Status  => $Param{Status},
                        },
                    );

                    if ($ProjectDescription) {
                        $Self->{LayoutObject}->Block(
                            Name => 'ProjectDescription',
                            Data => {
                                ProjectDescription => $ProjectDescription,
                            },
                        );
                    }

                    if ( $UserData{CreateProject} ) {

                        # persons who are allowed to see the create object link are
                        # allowed to see the project reporting
                        $Self->{LayoutObject}->Block(
                            Name => 'ProjectLink',
                            Data => {
                                Project   => $ProjectRef->{Name},
                                ProjectID => $ProjectID,
                            },
                        );
                    }
                    else {
                        $Self->{LayoutObject}->Block(
                            Name => 'ProjectNoLink',
                            Data => { Project => $ProjectRef->{Name} },
                        );
                    }
                }
            }

            # Now show row with total result of all actions of this project
            $Param{Hours}      = sprintf( "%.2f", $Total );
            $Param{HoursTotal} = sprintf( "%.2f", $TotalTotal );
            $Param{TotalHours}      += $Total;
            $Param{TotalHoursTotal} += $TotalTotal;
            $Self->{LayoutObject}->Block(
                Name => 'ActionTotal',
                Data => {%Param},
            );
        }
    }
    if ( defined( $Param{TotalHours} ) ) {
        $Param{TotalHours} = sprintf( "%.2f", $Param{TotalHours} );
    }
    if ( defined( $Param{TotalHoursTotal} ) ) {
        $Param{TotalHoursTotal} = sprintf( "%.2f", $Param{TotalHoursTotal} );
    }

    # build output
    my $Output = $Self->{LayoutObject}->Header( Title => 'Overview' );
    $Output .= $Self->{LayoutObject}->NavigationBar();
    $Output .= $Self->{LayoutObject}->Output(
        Data         => \%Param,
        TemplateFile => 'AgentTimeAccountingOverview'
    );
    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

sub _CheckValidityUserPeriods {
    my ( $Self, %Param ) = @_;

    my %Errors = ();
    my %GetParam;

    for ( my $Period = 1; $Period <= $Param{Period}; $Period++ ) {

        # check for needed data
        for my $Parameter (qw(DateStart DateEnd LeaveDays)) {
            $GetParam{$Parameter}
                = $Self->{ParamObject}->GetParam( Param => $Parameter . "[$Period]" );
            if ( !$GetParam{$Parameter} ) {
                $Errors{ $Parameter . '-' . $Period . 'Invalid' }   = 'ServerError';
                $Errors{ $Parameter . '-' . $Period . 'ErrorType' } = 'MissingValue';
            }
        }
        my ( $Year, $Month, $Day ) = split( '-', $GetParam{DateStart} );
        my $StartDate = $Self->{TimeObject}->Date2SystemTime(
            Year   => $Year,
            Month  => $Month,
            Day    => $Day,
            Hour   => 0,
            Minute => 0,
            Second => 0,
        );
        ( $Year, $Month, $Day ) = split( '-', $GetParam{DateEnd} );
        my $EndDate = $Self->{TimeObject}->Date2SystemTime(
            Year   => $Year,
            Month  => $Month,
            Day    => $Day,
            Hour   => 0,
            Minute => 0,
            Second => 0,
        );
        if ( !$StartDate ) {
            $Errors{ 'DateStart-' . $Period . 'Invalid' }   = 'ServerError';
            $Errors{ 'DateStart-' . $Period . 'ErrorType' } = 'Invalid';
        }
        if ( !$EndDate ) {
            $Errors{ 'DateEnd-' . $Period . 'Invalid' }   = 'ServerError';
            $Errors{ 'DateEnd-' . $Period . 'ErrorType' } = 'Invalid';
        }
        if ( $StartDate && $EndDate && $StartDate >= $EndDate ) {
            $Errors{ 'DateEnd-' . $Period . 'Invalid' }   = 'ServerError';
            $Errors{ 'DateEnd-' . $Period . 'ErrorType' } = 'BeforeDateStart';
        }
    }

    return %Errors;
}

1;
