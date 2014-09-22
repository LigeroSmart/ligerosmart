# --
# Kernel/Modules/AgentTimeAccountingView.pm - time accounting view module
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTimeAccountingView;

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

        return $Self->{LayoutObject}->Redirect(
            OP => 'Action=AgentTimeAccountingEdit;Subaction=Edit'
        );
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
    # view older day inserts
    # ---------------------------------------------------------- #

    # permission check
    return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' ) if !$Self->{AccessRo};

    # get params
    for my $Parameter (qw(Day Month Year UserID)) {
        $Param{$Parameter} = $Self->{ParamObject}->GetParam( Param => $Parameter );
    }

    # check needed params
    for my $Needed (qw(Day Month Year)) {
        if ( !$Param{$Needed} ) {

            return $Self->{LayoutObject}->ErrorScreen( Message => "View: Need $Needed" );
        }
    }

    # format the date parts
    $Param{Year}  = sprintf( "%02d", $Param{Year} );
    $Param{Month} = sprintf( "%02d", $Param{Month} );
    $Param{Day}   = sprintf( "%02d", $Param{Day} );

    # if no UserID posted use the current user
    $Param{UserID} ||= $Self->{UserID};

    # get current date and time
    my ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = $Self->{TimeObject}->SystemTime2Date(
        SystemTime => $Self->{TimeObject}->SystemTime(),
    );

    my $MaxAllowedInsertDays
        = $Self->{ConfigObject}->Get('TimeAccounting::MaxAllowedInsertDays') || '10';
    ( $Param{YearAllowed}, $Param{MonthAllowed}, $Param{DayAllowed} )
        = Add_Delta_YMD( $Year, $Month, $Day, 0, 0, -$MaxAllowedInsertDays );

    # redirect to the edit screen, if necessary
    if (
        timelocal( 1, 0, 0, $Param{Day}, $Param{Month} - 1, $Param{Year} - 1900 ) > timelocal(
            1, 0, 0, $Param{DayAllowed},
            $Param{MonthAllowed} - 1,
            $Param{YearAllowed} - 1900
        ) && $Param{UserID} == $Self->{UserID}
        )
    {

        return $Self->{LayoutObject}->Redirect(
            OP =>
                "Action=AgentTimeAccountingEdit;Subaction=Edit;Year=$Param{Year};Month=$Param{Month};Day=$Param{Day}"
        );
    }

    # show the naming of the agent which time accounting is visited
    if ( $Param{UserID} != $Self->{UserID} ) {
        my %ShownUsers = $Self->{UserObject}->UserList( Type => 'Long', Valid => 1 );
        $Param{User} = $ShownUsers{ $Param{UserID} };
        $Self->{LayoutObject}->Block(
            Name => 'User',
            Data => {%Param},
        );
    }

    $Param{Weekday}         = Day_of_Week( $Param{Year}, $Param{Month}, $Param{Day} );
    $Param{Weekday_to_Text} = $WeekdayArray[ $Param{Weekday} - 1 ];
    $Param{Month_to_Text}   = $MonthArray[ $Param{Month} ];

    # Values for the link icons <>
    ( $Param{YearBack}, $Param{MonthBack}, $Param{DayBack} )
        = Add_Delta_YMD( $Param{Year}, $Param{Month}, $Param{Day}, 0, 0, -1 );
    ( $Param{YearNext}, $Param{MonthNext}, $Param{DayNext} )
        = Add_Delta_YMD( $Param{Year}, $Param{Month}, $Param{Day}, 0, 0, 1 );

    $Param{DateSelection} = $Self->{LayoutObject}->BuildDateSelection(
        %Param,
        Prefix   => '',
        Format   => 'DateInputFormat',
        Validate => 1,
        Class    => $Param{Errors}->{DateInvalid},
    );

    # Show Working Units
    # get existing working units
    my %Data = $Self->{TimeAccountingObject}->WorkingUnitsGet(
        Year   => $Param{Year},
        Month  => $Param{Month},
        Day    => $Param{Day},
        UserID => $Param{UserID},
    );

    $Param{Date} = $Data{Date};

    # get project and action settings
    my %Project = $Self->{TimeAccountingObject}->ProjectSettingsGet();
    my %Action  = $Self->{TimeAccountingObject}->ActionSettingsGet();

    # get sick, leave day and overtime
    $Param{Sick}     = $Data{Sick}     ? 'checked' : '';
    $Param{LeaveDay} = $Data{LeaveDay} ? 'checked' : '';
    $Param{Overtime} = $Data{Overtime} ? 'checked' : '';

    # only show the unit block if there is some data
    my $UnitsRef = $Data{WorkingUnits};
    if ( $UnitsRef->[0] ) {

        for my $UnitRef ( @{$UnitsRef} ) {

            $Self->{LayoutObject}->Block(
                Name => 'Unit',
                Data => {
                    Project   => $Project{Project}{ $UnitRef->{ProjectID} },
                    Action    => $Action{ $UnitRef->{ActionID} }{Action},
                    Remark    => $UnitRef->{Remark},
                    StartTime => $UnitRef->{StartTime},
                    EndTime   => $UnitRef->{EndTime},
                    Period    => $UnitRef->{Period},
                    }
            );
        }

        $Self->{LayoutObject}->Block(
            Name => 'Total',
            Data => { Total => sprintf( "%.2f", $Data{Total} ) }
        );
    }
    else {
        $Self->{LayoutObject}->Block( Name => 'NoDataFound' );
    }

    if ( $Param{Sick} || $Param{LeaveDay} || $Param{Overtime} ) {
        $Self->{LayoutObject}->Block(
            Name => 'OtherTimes',
            Data => {
                Sick     => $Param{Sick},
                LeaveDay => $Param{LeaveDay},
                Overtime => $Param{Overtime},
                }
        );
    }

    my %UserData = $Self->{TimeAccountingObject}->UserGet(
        UserID => $Param{UserID},
    );

    my $Vacation = $Self->{TimeObject}->VacationCheck(
        Year     => $Param{Year},
        Month    => $Param{Month},
        Day      => $Param{Day},
        Calendar => $UserData{Calendar},
    );

    if ($Vacation) {
        $Self->{LayoutObject}->Block(
            Name => 'Vacation',
            Data => { Vacation => $Vacation },
        );
    }

    # presentation
    my $Output = $Self->{LayoutObject}->Header( Title => 'View' );
    $Output .= $Self->{LayoutObject}->NavigationBar();
    $Output .= $Self->{LayoutObject}->Output(
        Data         => \%Param,
        TemplateFile => 'AgentTimeAccountingView'
    );
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
