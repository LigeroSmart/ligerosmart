# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AgentTimeAccountingOverview;

use strict;
use warnings;

use Kernel::Language qw(Translatable);

use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

    $Self->{TimeZone} = $Param{TimeZone}
        || $Param{UserTimeZone}
        || $DateTimeObject->OTRSTimeZoneGet();

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my @MonthArray = (
        '',     'January', 'February', 'March',     'April',   'May',
        'June', 'July',    'August',   'September', 'October', 'November',
        'December',
    );
    my @WeekdayArray = ( 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun', );

    # get time object
    my $DateTimeObjectCurrent = $Kernel::OM->Create('Kernel::System::DateTime');
    my $TimeAccountingObject  = $Kernel::OM->Get('Kernel::System::TimeAccounting');

    # ---------------------------------------------------------- #
    # overview about the users time accounting
    # ---------------------------------------------------------- #
    my ( $Sec, $Min, $Hour, $CurrentDay, $Month, $Year ) = $TimeAccountingObject->SystemTime2Date(
        SystemTime => $DateTimeObjectCurrent->ToEpoch(),
    );

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # permission check
    if ( !$Self->{AccessRo} ) {
        return $LayoutObject->NoPermission(
            WithHeader => 'yes',
        );
    }

    for my $Parameter (qw(Status Day Month Year UserID ProjectStatusShow)) {
        $Param{$Parameter} = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => $Parameter );
    }
    $Param{Action} = 'AgentTimeAccountingEdit';

    if ( !$Param{UserID} ) {
        $Param{UserID} = $Self->{UserID};
    }
    else {
        if ( $Param{UserID} != $Self->{UserID} && !$Self->{AccessRw} ) {

            return $LayoutObject->NoPermission(
                WithHeader => 'yes',
            );
        }
        $Param{Action} = 'AgentTimeAccountingView';
    }
    if ( $Param{UserID} != $Self->{UserID} ) {
        my %ShownUsers = $Kernel::OM->Get('Kernel::System::User')->UserList(
            Type  => 'Long',
            Valid => 1
        );
        $Param{User} = $ShownUsers{ $Param{UserID} };
        $LayoutObject->Block(
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
    $Kernel::OM->Get('Kernel::System::AuthSession')->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreen',
        Value =>
            "Action=$Self->{Action};Year=$Param{Year};Month=$Param{Month}",
    );

    $Param{Month_to_Text} = $MonthArray[ $Param{Month} ];

    # create one base object
    my $DateTimeObjectGiven = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            Year  => $Param{Year},
            Month => $Param{Month},
            Day   => 1,
        },
    );

    my $DateTimeObjectNext = $DateTimeObjectGiven->Clone();
    my $DateTimeObjectPrev = $DateTimeObjectGiven->Clone();
    my $DateParamsCurrent  = $DateTimeObjectGiven->Get();

    # calculate the next month
    $DateTimeObjectNext->Add(
        Months => 1,
    );

    my $DateParamsNext = $DateTimeObjectNext->Get();

    $Param{YearNext}  = $DateParamsNext->{Year};
    $Param{MonthNext} = $DateParamsNext->{Month};
    $Param{DayNext}   = $DateParamsNext->{Day};

    # calculate the next month
    $DateTimeObjectPrev->Subtract(
        Months => 1,
    );

    my $DateParamsBack = $DateTimeObjectPrev->Get();
    $Param{YearBack}  = $DateParamsBack->{Year};
    $Param{MonthBack} = $DateParamsBack->{Month};
    $Param{DayBack}   = $DateParamsBack->{Day};

    # Overview per day
    my $LastDayOfMonth = $DateTimeObjectGiven->LastDayOfMonthGet();
    my $DaysOfMonth    = $LastDayOfMonth->{Day};

    my %UserData = $TimeAccountingObject->UserGet(
        UserID => $Param{UserID},
    );

    for my $Day ( 1 .. $DaysOfMonth ) {
        $Param{Day} = sprintf( "%02d", $Day );

        $Param{Weekday} = $TimeAccountingObject->DayOfWeek( $Param{Year}, $Param{Month}, $Param{Day} );

        my $VacationCheck = $TimeAccountingObject->VacationCheck(
            Year     => $Param{Year},
            Month    => $Param{Month},
            Day      => $Day,
            Calendar => $UserData{Calendar},
        );

        my $Date                = sprintf( "%04d-%02d-%02d", $Param{Year}, $Param{Month}, $Day );
        my $DateTimeObjectStart = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Date . ' 00:00:00',
            }
        );
        my $DayStartTime = $DateTimeObjectStart->ToEpoch();

        my $DateTimeObjectStop = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Date . ' 23:59:59',
            }
        );
        my $DayStopTime = $DateTimeObjectStop->ToEpoch();

        # add time zone to calculation
        my $UserCalendar = $UserData{Calendar} || '';
        my $Zone         = $Kernel::OM->Get('Kernel::Config')->Get( "TimeZone::Calendar" . $UserCalendar );
        if ($Zone) {
            my $ZoneSeconds = $Zone * 60 * 60;
            $DayStartTime = $DayStartTime - $ZoneSeconds;
            $DayStopTime  = $DayStopTime - $ZoneSeconds;
        }

        my $ThisDayWorkingTime = $TimeAccountingObject->WorkingTime(
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

        my %Data = $TimeAccountingObject->WorkingUnitsGet(
            Year   => $Param{Year},
            Month  => $Param{Month},
            Day    => $Param{Day},
            UserID => $Param{UserID},
        );

        $Param{Comment} = $Data{Sick}
            ? Translatable('Sick leave')
            : $Data{LeaveDay} ? Translatable('On vacation')
            : $Data{Overtime} ? Translatable('On overtime leave')
            :                   '';

        $Param{WorkingHours} = $Data{Total} ? sprintf( "%.2f", $Data{Total} ) : '';

        $Param{Weekday_to_Text} = $WeekdayArray[ $Param{Weekday} - 1 ];
        $LayoutObject->Block(
            Name => 'Row',
            Data => {%Param},
        );
        $Param{Comment} = '';
    }

    my %UserReport = $TimeAccountingObject->UserReporting(
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
        $Param{$ReportElement} = sprintf( "%.2f", $UserReport{ $Param{UserID} }{$ReportElement} );
    }

    if ( $UserData{ShowOvertime} ) {
        $LayoutObject->Block(
            Name => 'Overtime',
            Data => \%Param,
        );
    }

    # Overview per project and action
    my %ProjectData = $TimeAccountingObject->ProjectActionReporting(
        Year   => $Param{Year},
        Month  => $Param{Month},
        UserID => $Param{UserID},
    );

    if ( IsHashRefWithData( \%ProjectData ) ) {

        # show the report sort by projects
        if ( !$Param{ProjectStatusShow} || $Param{ProjectStatusShow} eq 'valid' ) {
            $Param{ProjectStatusShow} = 'all';
        }
        elsif ( $Param{ProjectStatusShow} eq 'all' ) {
            $Param{ProjectStatusShow} = 'valid';
        }

        $Param{ShowProjects} = 'Show ' . $Param{ProjectStatusShow} . ' projects';

        $LayoutObject->Block(
            Name => 'ProjectTable',
            Data => {%Param},
        );

        PROJECTID:
        for my $ProjectID (
            sort { $ProjectData{$a}{Name} cmp $ProjectData{$b}{Name} } keys %ProjectData
            )
        {
            my $ProjectRef = $ProjectData{$ProjectID};
            my $ActionsRef = $ProjectRef->{Actions};

            $Param{Project} = '';
            $Param{Status}  = $ProjectRef->{Status} ? '' : 'passiv';

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
                    $LayoutObject->Block(
                        Name => 'Action',
                        Data => {%Param},
                    );
                    if ( !$Param{Project} ) {
                        $Param{Project} = $ProjectRef->{Name};
                        my $ProjectDescription = $LayoutObject->Ascii2Html(
                            Text           => $ProjectRef->{Description},
                            HTMLResultMode => 1,
                            NewLine        => 50,
                        );

                        $LayoutObject->Block(
                            Name => 'Project',
                            Data => {
                                RowSpan => ( 1 + scalar keys %{$ActionsRef} ),
                                Status  => $Param{Status},
                            },
                        );

                        if ($ProjectDescription) {
                            $LayoutObject->Block(
                                Name => 'ProjectDescription',
                                Data => {
                                    ProjectDescription => $ProjectDescription,
                                },
                            );
                        }

                        if ( $UserData{CreateProject} ) {

                            # persons who are allowed to see the create object link are
                            # allowed to see the project reporting
                            $LayoutObject->Block(
                                Name => 'ProjectLink',
                                Data => {
                                    Project   => $ProjectRef->{Name},
                                    ProjectID => $ProjectID,
                                },
                            );
                        }
                        else {
                            $LayoutObject->Block(
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
                $LayoutObject->Block(
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
        $LayoutObject->Block(
            Name => 'GrandTotal',
            Data => {%Param},
        );
    }

    # build output
    my $Output = $LayoutObject->Header(
        Title => Translatable('Overview'),
    );
    $Output .= $LayoutObject->NavigationBar();
    $Output .= $LayoutObject->Output(
        Data         => \%Param,
        TemplateFile => 'AgentTimeAccountingOverview'
    );
    $Output .= $LayoutObject->Footer();

    return $Output;
}

sub _CheckValidityUserPeriods {
    my ( $Self, %Param ) = @_;

    my %Errors = ();
    my %GetParam;

    # get time object
    my $TimeAccountingObject = $Kernel::OM->Get('Kernel::System::TimeAccounting');

    for ( my $Period = 1; $Period <= $Param{Period}; $Period++ ) {

        # check for needed data
        for my $Parameter (qw(DateStart DateEnd LeaveDays)) {
            $GetParam{$Parameter}
                = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => $Parameter . "[$Period]" );
            if ( !$GetParam{$Parameter} ) {
                $Errors{ $Parameter . '-' . $Period . 'Invalid' }   = 'ServerError';
                $Errors{ $Parameter . '-' . $Period . 'ErrorType' } = 'MissingValue';
            }
        }
        my ( $Year, $Month, $Day ) = split( '-', $GetParam{DateStart} );
        my $StartDate = $TimeAccountingObject->Date2SystemTime(
            Year   => $Year,
            Month  => $Month,
            Day    => $Day,
            Hour   => 0,
            Minute => 0,
            Second => 0,
        );
        ( $Year, $Month, $Day ) = split( '-', $GetParam{DateEnd} );
        my $EndDate = $TimeAccountingObject->Date2SystemTime(
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
