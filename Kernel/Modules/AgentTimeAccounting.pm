# --
# Kernel/Modules/AgentTimeAccounting.pm - time accounting module
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: AgentTimeAccounting.pm,v 1.70 2011-01-20 04:48:24 en Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTimeAccounting;

use strict;
use warnings;

use Kernel::System::TimeAccounting;
use Date::Pcalc qw(Today Days_in_Month Day_of_Week Add_Delta_YMD);
use Time::Local;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.70 $) [1];

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

    my %IncompleteWorkingDays = $Self->{TimeAccountingObject}->WorkingUnitsCompletnessCheck();

    # redirect if incomplete working day are out of range
    if (
        $IncompleteWorkingDays{EnforceInsert}
        && $Self->{Action} ne 'AgentTimeAccounting'
        && $Self->{Action} ne 'AgentCalendarSmall'
        )
    {
        return $Self->{LayoutObject}->Redirect(
            OP => 'Action=AgentTimeAccounting;Subaction=Edit'
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
    # show confirmation dialog to delete the entry of this day
    # ---------------------------------------------------------- #
    if ( $Self->{ParamObject}->GetParam( Param => 'DeleteDay' ) ) {

        my ( $Sec, $Min, $Hour, $Day, $Month, $Year )
            = $Self->{TimeObject}->SystemTime2Date(
            SystemTime => $Self->{TimeObject}->SystemTime(),
            );

        # get params
        for my $Parameter (qw(Status Year Month Day)) {
            $Param{$Parameter} = $Self->{ParamObject}->GetParam( Param => $Parameter );
        }

        # Check Date
        if ( !$Param{Year} || !$Param{Month} || !$Param{Day} ) {
            $Param{Year}  = $Year;
            $Param{Month} = $Month;
            $Param{Day}   = $Day;
        }
        else {
            $Param{Year}  = sprintf( "%02d", $Param{Year} );
            $Param{Month} = sprintf( "%02d", $Param{Month} );
            $Param{Day}   = sprintf( "%02d", $Param{Day} );
        }

        my $Output = $Self->{LayoutObject}->Output(
            Data         => {%Param},
            TemplateFile => 'AgentTimeAccountingDelete',
        );

        # build the returned data structure
        my %Data = (
            HTML       => $Output,
            DialogType => 'Confirmation',
        );

        # return JSON-String because of AJAX-Mode
        my $OutputJSON = $Self->{LayoutObject}->JSONEncode( Data => \%Data );

        return $Self->{LayoutObject}->Attachment(
            ContentType => 'application/json; charset=' . $Self->{LayoutObject}->{Charset},
            Content     => $OutputJSON,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # expression add time period was pressed
    elsif (
        $Self->{ParamObject}->GetParam( Param => 'AddPeriod' )
        || $Self->{ParamObject}->GetParam( Param => 'SubmitUserData' )
        )
    {
        my %GetParam = ();

        $GetParam{UserID} = $Self->{ParamObject}->GetParam( Param => 'UserID' );
        my $Periods
            = $Self->{TimeAccountingObject}->UserLastPeriodNumberGet( UserID => $GetParam{UserID} );

        # check validity of periods
        my %Errors = $Self->_CheckValidityUserPeriods( Period => $Periods );

        # if the period data is ok
        if ( !%Errors ) {

            # get all parameters
            for my $Parameter (qw(Subaction Description Calendar)) {
                $GetParam{$Parameter} = $Self->{ParamObject}->GetParam( Param => $Parameter );
            }
            for my $Parameter (qw(ShowOvertime CreateProject)) {
                $GetParam{$Parameter} = $Self->{ParamObject}->GetParam( Param => $Parameter ) || 0;
            }

            my $Period = 1;
            my %PeriodData;

            my %UserData
                = $Self->{TimeAccountingObject}
                ->SingleUserSettingsGet( UserID => $GetParam{UserID} );

            # get parameters for all registered periods
            while ( $UserData{$Period} ) {
                for my $Parameter (qw(WeeklyHours Overtime DateStart DateEnd LeaveDays)) {
                    $PeriodData{$Period}{$Parameter}
                        = $Self->{ParamObject}->GetParam( Param => $Parameter . "[$Period]" )
                        || $UserData{$Period}{$Parameter};
                }
                $PeriodData{$Period}{UserStatus}
                    = $Self->{ParamObject}->GetParam( Param => "PeriodStatus[$Period]" ) || 0;
                $Period++;
            }
            $GetParam{Period} = \%PeriodData;

            # update periods
            if ( !$Self->{TimeAccountingObject}->SingleUserSettingsUpdate(%GetParam) ) {
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => 'Unable to update user settings! Please contact your administrator.'
                );
            }
            if ( $Self->{ParamObject}->GetParam( Param => 'AddPeriod' ) ) {

                # show the edit time settiengs again, but now with a new empty time period line
                return $Self->{LayoutObject}->Redirect(
                    OP =>
                        "Action=AgentTimeAccounting;Subaction=$GetParam{Subaction};UserID=$GetParam{UserID};"
                        . "NewTimePeriod=1",
                );
            }
            else {

                # show the overview of tasks and users
                return $Self->{LayoutObject}->Redirect(
                    OP => "Action=AgentTimeAccounting;Subaction=Setting;User=$Self->{Subaction}",
                );
            }
        }
    }

    # ---------------------------------------------------------- #
    # edit the time accounting elements
    # ---------------------------------------------------------- #
    if ( $Self->{Subaction} eq 'Edit' ) {

        # permission check
        return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' ) if !$Self->{AccessRo};

        my %Frontend   = ();
        my %Data       = ();
        my %ActionList = $Self->_ActionList();
        my ( $Sec, $Min, $Hour, $Day, $Month, $Year )
            = $Self->{TimeObject}->SystemTime2Date(
            SystemTime => $Self->{TimeObject}->SystemTime(),
            );

        # get params
        for my $Parameter (qw(Status Year Month Day)) {
            $Param{$Parameter} = $Self->{ParamObject}->GetParam( Param => $Parameter ) || '';
        }
        $Param{RecordsNumber} = $Self->{ParamObject}->GetParam( Param => 'RecordsNumber' ) || 8;
        $Param{InsertWorkingUnits}
            = $Self->{ParamObject}->GetParam( Param => 'InsertWorkingUnits' );

        # Check Date
        if ( !$Param{Year} || !$Param{Month} || !$Param{Day} ) {
            $Param{Year}  = $Year;
            $Param{Month} = $Month;
            $Param{Day}   = $Day;
        }
        else {
            $Param{Year}  = sprintf( "%02d", $Param{Year} );
            $Param{Month} = sprintf( "%02d", $Param{Month} );
            $Param{Day}   = sprintf( "%02d", $Param{Day} );
        }

        my %User = $Self->{TimeAccountingObject}->UserCurrentPeriodGet(
            Year  => $Param{Year},
            Month => $Param{Month},
            Day   => $Param{Day},
        );

        # for initial use, the first agent with rw-right will be redirected
        # to 'Setting', so he can do the initial settings
        if ( !$User{ $Self->{UserID} } ) {
            return $Self->_FirstUserRedirect();
        }

        my %IncompleteWorkingDays = $Self->{TimeAccountingObject}->WorkingUnitsCompletnessCheck();
        my $MaxAllowedInsertDays
            = $Self->{ConfigObject}->Get('TimeAccounting::MaxAllowedInsertDays') || '10';
        ( $Param{YearAllowed}, $Param{MonthAllowed}, $Param{DayAllowed} )
            = Add_Delta_YMD( $Year, $Month, $Day, 0, 0, -$MaxAllowedInsertDays );
        if (
            timelocal( 1, 0, 0, $Param{Day}, $Param{Month} - 1, $Param{Year} - 1900 ) < timelocal(
                1, 0, 0, $Param{DayAllowed},
                $Param{MonthAllowed} - 1,
                $Param{YearAllowed} - 1900
            )
            )
        {
            if (
                !$IncompleteWorkingDays{Incomplete}{ $Param{Year} }{ $Param{Month} }
                { $Param{Day} }
                )
            {
                return $Self->{LayoutObject}->Redirect(
                    OP =>
                        "Action=$Self->{Action};Subaction=View;Year=$Param{Year};Month=$Param{Month};Day=$Param{Day}"
                );
            }
        }

        # store last screen
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'LastScreen',
            Value =>
                "Action=$Self->{Action};Subaction=Edit;Year=$Param{Year};Month=$Param{Month};Day=$Param{Day}",
        );

        $Param{Month_to_Text} = $MonthArray[ $Param{Month} ];

        ( $Param{YearBack}, $Param{MonthBack}, $Param{DayBack} )
            = Add_Delta_YMD( $Param{Year}, $Param{Month}, $Param{Day}, 0, 0, -1 );
        ( $Param{YearNext}, $Param{MonthNext}, $Param{DayNext} )
            = Add_Delta_YMD( $Param{Year}, $Param{Month}, $Param{Day}, 0, 0, 1 );

        my $ReduceTimeRef = $Self->{ConfigObject}->Get('TimeAccounting::ReduceTime');

        # hashes to store server side errors
        my %Errors          = ();
        my %ServerErrorData = ();
        my $ErrorIndex      = 1;

        # Edit Working Units
        if ( $Param{Status} ) {

            # arrays to save all start and end times for some checks
            my ( @StartTimes, @EndTimes );

            # delete previous entries for this day and user
            $Self->{TimeAccountingObject}->WorkingUnitsDelete(
                Year  => $Param{Year},
                Month => $Param{Month},
                Day   => $Param{Day},
            );

            my %CheckboxCheck = ();
            for my $Element (qw(LeaveDay Sick Overtime)) {
                my $Value = $Self->{ParamObject}->GetParam( Param => $Element );
                if ($Value) {
                    $CheckboxCheck{$Element} = 1;
                    $Param{$Element}         = 'checked="checked"';
                }
                else {
                    $Param{$Element} = ''
                }
            }

            # if more than one check box was checked it is a server error
            if ( scalar keys %CheckboxCheck > 1 ) {
                for my $Checkbox ( keys %CheckboxCheck ) {
                    $Errors{ $Checkbox . 'Invalid' } = 'ServerError';
                }
            }
            else {

                # insert values (if any)
                if ( scalar keys %CheckboxCheck > 0 ) {
                    if (
                        !$Self->{TimeAccountingObject}->WorkingUnitsInsert(
                            Year     => $Param{Year},
                            Month    => $Param{Month},
                            Day      => $Param{Day},
                            LeaveDay => $CheckboxCheck{LeaveDay} || 0,
                            Sick     => $CheckboxCheck{Sick} || 0,
                            Overtime => $CheckboxCheck{Overtime} || 0,
                        )
                        )
                    {
                        return $Self->{LayoutObject}->ErrorScreen(
                            Message => 'Can\'t insert Working Units!'
                        );
                    }
                }
            }

            ID:
            for my $ID ( 1 .. $Param{RecordsNumber} ) {

                # arrays to save the server errors block to show the error msgs
                my ( @StartTimeServerErrorBlock, @EndTimeServerErrorBlock, @PeriodServerErrorBlock )
                    = ();

                for my $Parameter (qw(ProjectID ActionID Remark StartTime EndTime Period)) {
                    $Param{$Parameter}
                        = $Self->{ParamObject}->GetParam( Param => $Parameter . '[' . $ID . ']' );
                }

                next ID if !$Param{ProjectID} && !$Param{ActionID};

                # check for missing values
                if ( $Param{ProjectID} && !$Param{ActionID} ) {
                    $Errors{$ErrorIndex}{ActionIDInvalid} = 'ServerError';
                }
                if ( !$Param{ProjectID} && $Param{ActionID} ) {
                    $Errors{$ErrorIndex}{ProjectIDInvalid} = 'ServerError';
                }

                # create a valid period
                my $Period = $Param{Period};
                if ( $Period =~ /^(\d+),(\d+)/ ) {
                    $Period = $1 . "." . $2;
                }

                #allow format hh:mm
                elsif ( $Param{Period} =~ /^(\d+):(\d+)/ ) {
                    $Period = $1 + $2 / 60;
                }

                # if start or end times are missing, delete the other entry
                if ( !$Param{StartTime} || !$Param{EndTime} ) {
                    $Param{StartTime} = '';
                    $Param{EndTime}   = '';
                }

                # add ':00' to the time, if it doesn't have it yet
                if ( $Param{StartTime} && $Param{StartTime} !~ /^(\d+):(\d+)$/ ) {
                    $Param{StartTime} .= ':00';
                }
                if ( $Param{EndTime} && $Param{EndTime} !~ /^(\d+):(\d+)$/ ) {
                    $Param{EndTime} .= ':00';
                }
                if (
                    ( $Param{StartTime} =~ /^(\d+):(\d+)$/ )
                    && ( $Param{EndTime} =~ /^(\d+):(\d+)$/ )
                    )
                {
                    $Param{StartTime} =~ /^(\d+):(\d+)$/;
                    my $StartTime = $1 * 60 + $2;
                    $Param{EndTime} =~ /^(\d+):(\d+)$/;
                    my $EndTime = $1 * 60 + $2;
                    if ( $ReduceTimeRef->{ $ActionList{ $Param{ActionID} } } ) {
                        $Period = ( $EndTime - $StartTime ) / 60
                            * $ReduceTimeRef->{ $ActionList{ $Param{ActionID} } } / 100;
                    }
                    else {
                        $Period = ( $EndTime - $StartTime ) / 60;
                    }

                    # end time must be after start time
                    if ( $EndTime <= $StartTime ) {
                        $Errors{$ErrorIndex}{EndTimeInvalid} = 'ServerError';
                        push @EndTimeServerErrorBlock, 'EndTimeBeforeStartTimeServerError';
                    }

                    $StartTimes[$ID] = $StartTime;
                    $EndTimes[$ID]   = $EndTime;
                }
                else {
                    if ( $Param{StartTime} && $Param{StartTime} !~ /^(\d+):(\d+)$/ ) {
                        $Errors{$ErrorIndex}{StartTimeInvalid} = 'ServerError';
                        push @StartTimeServerErrorBlock, 'StartTimeInvalidFormatServerError';
                    }
                    if ( $Param{EndTime} && $Param{EndTime} !~ /^(\d+):(\d+)$/ ) {
                        $Errors{$ErrorIndex}{EndTimeInvalid} = 'ServerError';
                        push @EndTimeServerErrorBlock, 'EndTimeInvalidFormatServerError';
                    }
                }

                # negative times are not allowed
                if ( $Param{StartTime} =~ /^-(\d+):(\d+)$/ ) {
                    $Errors{$ErrorIndex}{StartTimeInvalid} = 'ServerError';
                    push @StartTimeServerErrorBlock, 'StartTimeNegativeServerError';
                }
                if ( $Param{EndTime} =~ /^-(\d+):(\d+)$/ ) {
                    $Errors{$ErrorIndex}{EndTimeInvalid} = 'ServerError';
                    push @EndTimeServerErrorBlock, 'EndTimeNegativeServerError';
                }

                # repeated hours are not allowed
                for ( my $Position = $ID - 1; $Position >= 1; $Position-- ) {
                    next if !defined $StartTimes[$Position] || !defined $StartTimes[$ID];

                    if (
                        $StartTimes[$Position] > $StartTimes[$ID]
                        && $StartTimes[$Position] < $EndTimes[$ID]
                        )
                    {
                        $Errors{$ErrorIndex}{EndTimeInvalid} = 'ServerError';
                        push @EndTimeServerErrorBlock, 'EndTimeRepeatedHourServerError'
                            if !grep( /^EndTimeRepeatedHourServerError/,
                            @EndTimeServerErrorBlock );
                    }

                    if (
                        $EndTimes[$Position] > $StartTimes[$ID]
                        && $EndTimes[$Position] < $EndTimes[$ID]
                        )
                    {
                        if ( $EndTimes[$ID] > $EndTimes[$Position] ) {
                            $Errors{$ErrorIndex}{StartTimeInvalid} = 'ServerError';
                            push @StartTimeServerErrorBlock, 'StartTimeRepeatedHourServerError'
                                if !
                                    grep( /^StartTimeRepeatedHourServerError$/,
                                        @StartTimeServerErrorBlock );
                        }
                        else {
                            $Errors{$ErrorIndex}{EndTimeInvalid} = 'ServerError';
                            push @EndTimeServerErrorBlock, 'EndTimeRepeatedHourServerError'
                                if !
                                    grep( /^EndTimeRepeatedHourServerError$/,
                                        @EndTimeServerErrorBlock );
                        }
                    }

                    if ( $StartTimes[$Position] == $StartTimes[$ID] ) {
                        $Errors{$ErrorIndex}{StartTimeInvalid} = 'ServerError';
                        push @StartTimeServerErrorBlock, 'StartTimeRepeatedHourServerError'
                            if !
                                grep( /^StartTimeRepeatedHourServerError$/,
                                    @StartTimeServerErrorBlock );
                    }

                    if ( $EndTimes[$Position] == $EndTimes[$ID] ) {
                        $Errors{$ErrorIndex}{EndTimeInvalid} = 'ServerError';
                        push @EndTimeServerErrorBlock, 'EndTimeRepeatedHourServerError'
                            if !
                                grep( /^EndTimeRepeatedHourServerError$/,
                                    @EndTimeServerErrorBlock );
                    }

                    if (
                        $StartTimes[$ID] > $StartTimes[$Position]
                        && $StartTimes[$ID] < $EndTimes[$Position]
                        )
                    {
                        $Errors{$ErrorIndex}{StartTimeInvalid} = 'ServerError';
                        push @StartTimeServerErrorBlock, 'StartTimeRepeatedHourServerError'
                            if !
                                grep( /^StartTimeRepeatedHourServerError$/,
                                    @StartTimeServerErrorBlock );
                    }

                    if (
                        $EndTimes[$ID] > $StartTimes[$Position]
                        && $EndTimes[$ID] < $EndTimes[$Position]
                        )
                    {
                        $Errors{$ErrorIndex}{EndTimeInvalid} = 'ServerError';
                        push @EndTimeServerErrorBlock, 'EndTimeRepeatedHourServerError'
                            if !
                                grep( /^EndTimeRepeatedHourServerError$/,
                                    @EndTimeServerErrorBlock );
                    }
                }

                # add reference to the server error msgs to be shown
                if ( $Errors{$ErrorIndex} && $Errors{$ErrorIndex}{StartTimeInvalid} ) {
                    $Errors{$ErrorIndex}{StartTimeServerErrorBlock} = \@StartTimeServerErrorBlock;
                }
                if ( $Errors{$ErrorIndex} && $Errors{$ErrorIndex}{EndTimeInvalid} ) {
                    $Errors{$ErrorIndex}{EndTimeServerErrorBlock} = \@EndTimeServerErrorBlock;
                }

                # overwrite period if there are start and end times
                if ( $StartTimes[$ID] && $EndTimes[$ID] ) {
                    $Period = $EndTimes[$ID] - $StartTimes[$ID];

                    # convert period from minutes to hours
                    $Period /= 60;
                }

                # check for errors in the period
                if ( $Period == 0 ) {
                    push @PeriodServerErrorBlock, 'ZeroHoursPeriodServerError';
                    if (
                        $Self->{ConfigObject}->Get('TimeAccounting::InputHoursWithoutStartEndTime')
                        )
                    {
                        $Errors{$ErrorIndex}{PeriodInvalid} = 'ServerError';
                    }
                    else {
                        $Errors{$ErrorIndex}{StartTimeInvalid} = 'ServerError';
                        $Errors{$ErrorIndex}{EndTimeInvalid}   = 'ServerError';
                    }
                }
                else {
                    if ( $Period < 0 ) {
                        $Errors{$ErrorIndex}{PeriodInvalid} = 'ServerError';
                        push @PeriodServerErrorBlock, 'NegativePeriodServerError';
                    }
                }
                if ( $Period > 24 ) {
                    $Errors{$ErrorIndex}{PeriodInvalid} = 'ServerError';
                    push @PeriodServerErrorBlock, 'InvalidHoursPeriodServerError';
                }

                if ( $Errors{$ErrorIndex} && $Errors{$ErrorIndex}{PeriodInvalid} ) {
                    $Errors{$ErrorIndex}{PeriodServerErrorBlock} = \@PeriodServerErrorBlock;
                }

                # if there was an error on this row, save all data in the server error hash
                if ( defined $Errors{$ErrorIndex} ) {
                    for my $Parameter (qw(ProjectID ActionID Remark StartTime EndTime)) {
                        $ServerErrorData{$ErrorIndex}{$Parameter} = $Param{$Parameter};
                    }
                    $ServerErrorData{$ErrorIndex}{Period} = $Period;
                }

                # otherwise, save row on the DB
                else {

                    # initialize the array of working units
                    @{ $Data{WorkingUnits} } = ();

                    my %WorkingUnit = (
                        ProjectID => $Param{ProjectID},
                        ActionID  => $Param{ActionID},
                        Remark    => $Param{Remark},
                        StartTime => $Param{StartTime},
                        EndTime   => $Param{EndTime},
                        Period    => $Period,
                    );
                    push @{ $Data{WorkingUnits} }, \%WorkingUnit;

                    $Data{Year}  = $Param{Year};
                    $Data{Month} = $Param{Month};
                    $Data{Day}   = $Param{Day};

                    if ( !$Self->{TimeAccountingObject}->WorkingUnitsInsert(%Data) ) {
                        return $Self->{LayoutObject}->ErrorScreen(
                            Message => 'Can\'t insert Working Units!'
                        );
                    }
                }

                # increment the error index if there was an error on this row
                $ErrorIndex++ if ( defined $Errors{$ErrorIndex} );
            }

            if (%ServerErrorData) {
                $Param{SuccessfulInsert} = undef;
            }
            else {
                $Param{SuccessfulInsert} = 1;
            }
        }

        # Show Working Units
        # get existing working units
        %Data = $Self->{TimeAccountingObject}->WorkingUnitsGet(
            Year  => $Param{Year},
            Month => $Param{Month},
            Day   => $Param{Day},
        );

        if ( $Self->{ConfigObject}->Get('TimeAccounting::InputHoursWithoutStartEndTime') ) {
            $Param{PeriodBlock}   = 'UnitInputPeriod';
            $Frontend{PeriodNote} = '*';
        }
        else {
            $Param{PeriodBlock}   = 'UnitPeriodWithoutInput';
            $Frontend{PeriodNote} = '';
        }

        if ( time() > timelocal( 1, 0, 0, $Param{Day}, $Param{Month} - 1, $Param{Year} - 1900 ) ) {
            $Self->{LayoutObject}->Block(
                Name => 'UnitBlock',
                Data => { %Param, %Frontend },
            );
        }

        # get sick, leave day and overtime
        $Param{Sick}     = $Data{Sick}     ? 'checked="checked"' : '';
        $Param{LeaveDay} = $Data{LeaveDay} ? 'checked="checked"' : '';
        $Param{Overtime} = $Data{Overtime} ? 'checked="checked"' : '';

        $Param{Total} = $Data{Total};

        # set action list and related constraints
        # generate a JavaScript Array which will be output to the template
        my @ActionIDs = sort { $ActionList{$a} cmp $ActionList{$b} } keys %ActionList;
        my @JSActions;
        foreach my $ActionID (@ActionIDs) {
            push @JSActions, "['$ActionID', '$ActionList{$ActionID}']";
        }
        $Param{JSActionList} = '[' . ( join ', ', @JSActions ) . ']';

        my $ActionListConstraints
            = $Self->{ConfigObject}->Get('TimeAccounting::ActionListConstraints');
        my @JSActionListConstraints;
        for my $ProjectNameRegExp ( keys %{$ActionListConstraints} ) {
            my $ActionNameRegExp = $ActionListConstraints->{$ProjectNameRegExp};
            s{(['"\\])}{\\$1}smxg for ( $ProjectNameRegExp, $ActionNameRegExp );
            push @JSActionListConstraints, "['$ProjectNameRegExp', '$ActionNameRegExp']";
        }
        $Param{JSActionListConstraints} = '[' . ( join ', ', @JSActionListConstraints ) . ']';

        # build a working unit array
        my @Units = (undef);
        if ( $Data{WorkingUnits} ) {
            push @Units, @{ $Data{WorkingUnits} }
        }

        $ErrorIndex = 0;

        # build units
        $Param{"JSProjectList"} = "var JSProjectList = new Array();\n";
        for my $ID ( 1 .. $Param{RecordsNumber} ) {
            $Param{ID} = $ID;
            my $UnitRef   = $Units[$ID];
            my $ShowError = 0;

            if ( !$UnitRef ) {
                $ErrorIndex++;
                $ShowError = 1;
            }

            # get data of projects
            my $ProjectList = $Self->_ProjectList(
                SelectedID => $UnitRef->{ProjectID}
                    || $ServerErrorData{$ErrorIndex}{ProjectID}
                    || '',
            );

            $Param{ProjectID}
                = $UnitRef->{ProjectID}
                || $ServerErrorData{$ErrorIndex}{ProjectID}
                || '';
            $Param{ProjectName} = '';

            # generate JavaScript array which will be output to the template
            my @JSProjectList;
            for my $Project ( @{$ProjectList} ) {
                push @JSProjectList,
                    '{id:' . ( $Project->{Key} || '0' ) . ' , name:\'' . $Project->{Value} . '\'}';

                if ( $Project->{Key} eq $Param{ProjectID} ) {
                    $Param{ProjectName} = $Project->{Value};
                }
            }
            $Param{"JSProjectList"}
                .= "JSProjectList[$ID] = [" . ( join ', ', @JSProjectList ) . "];\n";

            $Frontend{ProjectOption} = $Self->{LayoutObject}->BuildSelection(
                Data        => $ProjectList,
                Name        => "ProjectID[$ID]",
                ID          => "ProjectID$ID",
                Translation => 0,
                Class       => 'Validate_TimeAccounting_Project ProjectSelection '
                    . ( $Errors{$ErrorIndex}{ProjectIDInvalid} || '' ),
                OnChange => "TimeAccounting.Agent.EditTimeRecords.FillActionList($ID);",
            );

# action list initially only contains empty and selected element as well as elements configured for selected project
# if no constraints are configured, all actions will be displayed
            my $ActionData = $Self->_ActionListConstraints(
                ProjectID => $UnitRef->{ProjectID} || $ServerErrorData{$ErrorIndex}{ProjectID},
                ProjectList           => $ProjectList,
                ActionList            => \%ActionList,
                ActionListConstraints => $ActionListConstraints,
            );
            $ActionData->{''} = '';

            if ( $UnitRef && $UnitRef->{ActionID} && $ActionList{ $UnitRef->{ActionID} } ) {
                $ActionData->{ $UnitRef->{ActionID} } = $ActionList{ $UnitRef->{ActionID} };
            }
            elsif (
                $ServerErrorData{$ErrorIndex}
                && $ServerErrorData{$ErrorIndex}{ActionID}
                && $ActionList{ $ServerErrorData{$ErrorIndex}{ActionID} }
                )
            {
                $ActionData->{ $ServerErrorData{$ErrorIndex}{ActionID} }
                    = $ActionList{ $ServerErrorData{$ErrorIndex}{ActionID} };
            }

            $Frontend{ActionOption} = $Self->{LayoutObject}->BuildSelection(

                Data       => $ActionData,
                SelectedID => $UnitRef->{ActionID} || $ServerErrorData{$ErrorIndex}{ActionID} || '',
                Name       => "ActionID[$ID]",
                ID         => "ActionID$ID",
                Translation => 0,
                Class       => 'Validate_DependingRequiredAND Validate_Depending_ProjectID'
                    . $ID
                    . ' ActionSelection '
                    . ( $Errors{$ErrorIndex}{ActionIDInvalid} || '' ),
            );

            $Param{Remark} = $UnitRef->{Remark} || $ServerErrorData{$ErrorIndex}{Remark} || '';

            my $Period;
            if (
                ( $UnitRef->{Period} && $UnitRef->{Period} == 0 )
                || (
                    defined $ServerErrorData{$ErrorIndex}{Period}
                    && $ServerErrorData{$ErrorIndex}{Period} == 0
                )
                )
            {
                $Period = 0;
            }
            else {
                $Period = $UnitRef->{Period} || $ServerErrorData{$ErrorIndex}{Period} || '';
            }

            for my $TimePeriod (qw(StartTime EndTime)) {
                if ($ShowError) {
                    if ( defined $ServerErrorData{$ErrorIndex}{$TimePeriod} ) {
                        $Param{$TimePeriod}
                            = $ServerErrorData{$ErrorIndex}{$TimePeriod} eq '00:00'
                            ? ''
                            : $ServerErrorData{$ErrorIndex}{$TimePeriod};
                    }
                    else {
                        $Param{$TimePeriod} = '';
                    }
                }
                else {
                    if ( $UnitRef->{$TimePeriod} ) {
                        $Param{$TimePeriod}
                            = $UnitRef->{$TimePeriod} eq '00:00' ? '' : $UnitRef->{$TimePeriod};
                    }
                    else {
                        $Param{$TimePeriod} = '';
                    }
                }
            }

            $Self->{LayoutObject}->Block(
                Name => 'Unit',
                Data => {
                    %Param,
                    %Frontend,
                    %{ $Errors{$ErrorIndex} },
                    }
            );

            # add proper server error msg for the start and end times
            my $ServerErrorBlockName;
            if ( $Errors{$ErrorIndex} && $Errors{$ErrorIndex}{StartTimeInvalid} ) {
                if ( scalar @{ $Errors{$ErrorIndex}{StartTimeServerErrorBlock} } > 0 ) {
                    while ( @{ $Errors{$ErrorIndex}{StartTimeServerErrorBlock} } ) {
                        $ServerErrorBlockName
                            = shift @{ $Errors{$ErrorIndex}{StartTimeServerErrorBlock} };
                        $Self->{LayoutObject}->Block( Name => $ServerErrorBlockName );
                    }
                }
                else {
                    $Self->{LayoutObject}->Block( Name => 'StartTimeGenericServerError' );
                }
            }
            if ( $Errors{$ErrorIndex} && $Errors{$ErrorIndex}{EndTimeInvalid} ) {
                if ( scalar @{ $Errors{$ErrorIndex}{EndTimeServerErrorBlock} } > 0 ) {
                    while ( @{ $Errors{$ErrorIndex}{EndTimeServerErrorBlock} } ) {
                        $ServerErrorBlockName
                            = shift @{ $Errors{$ErrorIndex}{EndTimeServerErrorBlock} };
                        $Self->{LayoutObject}->Block( Name => $ServerErrorBlockName );
                    }
                }
                else {
                    $Self->{LayoutObject}->Block( Name => 'EndTimeGenericServerError' );
                }
            }

            $Self->{LayoutObject}->Block(
                Name => $Param{PeriodBlock},
                Data => {
                    Period => $Period,
                    ID     => $ID,
                    %{ $Errors{$ErrorIndex} },
                },
            );

            # add proper server error msg for the period
            if ( $Errors{$ErrorIndex} && $Errors{$ErrorIndex}{PeriodInvalid} ) {
                if ( scalar @{ $Errors{$ErrorIndex}{PeriodServerErrorBlock} } > 0 ) {
                    while ( @{ $Errors{$ErrorIndex}{PeriodServerErrorBlock} } ) {
                        $ServerErrorBlockName
                            = shift @{ $Errors{$ErrorIndex}{PeriodServerErrorBlock} };
                        $Self->{LayoutObject}->Block( Name => $ServerErrorBlockName );
                    }
                }
                else {
                    $Self->{LayoutObject}->Block( Name => 'PeriodGenericServerError' );
                }
            }
            else {
                $Self->{LayoutObject}->Block( Name => 'PeriodGenericServerError' );
            }

            # validity check
            if (
                $Param{InsertWorkingUnits}
                && $UnitRef->{ProjectID}
                && $UnitRef->{ActionID}
                && $Param{Sick}
                )
            {
                $Param{BlockName} = 'SickLeaveMessage';
            }
            elsif (
                $Param{InsertWorkingUnits}
                && $UnitRef->{ProjectID}
                && $UnitRef->{ActionID}
                && $Param{LeaveDay}
                )
            {
                $Param{BlockName} = 'VacationMessage';
            }
            elsif (
                $Param{InsertWorkingUnits}
                && $UnitRef->{ProjectID}
                && $UnitRef->{ActionID}
                && $Param{Overtime}
                )
            {
                $Param{BlockName} = 'OvertimeMessage';
            }
        }

        if (
            $Self->{TimeObject}->SystemTime()
            > timelocal( 1, 0, 0, $Param{Day}, $Param{Month} - 1, $Param{Year} - 1900 )
            )
        {
            $Param{Total} = sprintf( "%.2f", ( $Param{Total} || 0 ) );
            $Self->{LayoutObject}->Block(
                Name => 'Total',
                Data => { %Param, %Frontend },
            );
        }

        # validity checks start
        my $ErrorNote;
        if ( $Param{Total} && $Param{Total} > 24 ) {
            $ErrorNote = 'Can\'t save settings, because a day has only 24 hours!';
        }
        elsif ( $Param{InsertWorkingUnits} && $Param{Total} && $Param{Total} > 16 ) {
            $Param{BlockName} = 'More16HoursMessage';
        }
        if ($ErrorNote) {
            if (
                !$Self->{TimeAccountingObject}->WorkingUnitsDelete(
                    Year  => $Param{Year},
                    Month => $Param{Month},
                    Day   => $Param{Day},
                )
                )
            {
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => 'Can\'t delete Working Units!'
                );
            }
        }

        if ( $Param{BlockName} ) {
            $Self->{LayoutObject}->Block(
                Name => 'ShowConfirmation',
                Data => {
                    BlockName => $Param{BlockName},
                    Year      => $Param{Year},
                    Month     => $Param{Month},
                    Day       => $Param{Day},
                },
            );
        }

        $Param{Date} = $Self->{LayoutObject}->BuildDateSelection(
            %Param,
            Prefix => '',
            Format => 'DateInputFormat',
        );

        if (
            timelocal( 1, 0, 0, $Param{Day}, $Param{Month} - 1, $Param{Year} - 1900 ) < timelocal(
                1, 0, 0, $Param{DayAllowed},
                $Param{MonthAllowed} - 1,
                $Param{YearAllowed} - 1900
            )
            )
        {
            if (
                $IncompleteWorkingDays{Incomplete}{ $Param{Year} }{ $Param{Month} }{ $Param{Day} }
                && !$Param{SuccessfulInsert}
                )
            {
                $Self->{LayoutObject}->Block(
                    Name => 'Readonly',
                    Data => {
                        Description =>
                            'This Date is out of limit, but you haven\'t insert this day yet, so you get one(!) chance to insert'
                    },
                );
            }
        }

        # get incomplete working days
        my %IncompleteWorkingDaysList;

        for my $YearID ( sort keys %{ $IncompleteWorkingDays{Incomplete} } ) {
            for my $MonthID ( sort keys %{ $IncompleteWorkingDays{Incomplete}{$YearID} } ) {
                for my $DayID (
                    sort keys %{ $IncompleteWorkingDays{Incomplete}{$YearID}{$MonthID} }
                    )
                {
                    $IncompleteWorkingDaysList{"$YearID-$MonthID-$DayID"}
                        = "$YearID-$MonthID-$DayID";
                    $Param{Incomplete} = 1;
                }
            }
        }

        # Show text, if incomplete working days are available
        if ( $Param{Incomplete} ) {

            # show incomplete working days as a dropdown
            my $IncompleWorkingDaysSelect = $Self->{LayoutObject}->BuildSelection(
                Data       => \%IncompleteWorkingDaysList,
                SelectedID => "$Param{Year}-$Param{Month}-$Param{Day}",
                Name       => "IncompleteWorkingDaysList",
            );

            $Self->{LayoutObject}->Block(
                Name => 'IncompleteWorkingDays',
                Data => {
                    IncompleteWorkingDaysSelect => $IncompleWorkingDaysSelect,
                },
            );
        }

        my %UserData = $Self->{TimeAccountingObject}->UserGet(
            UserID => $Self->{UserID},
        );

        my $VacationCheck = $Self->{TimeObject}->VacationCheck(
            Year     => $Param{Year},
            Month    => $Param{Month},
            Day      => $Param{Day},
            Calendar => $UserData{Calendar},
        );

        $Param{Weekday} = Day_of_Week( $Param{Year}, $Param{Month}, $Param{Day} );
        if ( $Param{Weekday} != 6 && $Param{Weekday} != 7 && !$VacationCheck ) {
            $Self->{LayoutObject}->Block(
                Name => 'OtherTimes',
                Data => {
                    %Param,
                    %Frontend,
                    %Errors,
                },
            );
        }

        $Param{Weekday_to_Text} = $WeekdayArray[ $Param{Weekday} - 1 ];

        # integrate the handling for required remarks in relation to projects
        $Param{RemarkRegExp} = $Self->_Project2RemarkRegExp();

        # enable autocompletion?
        $Param{EnableAutocompletion}
            = $Self->{ConfigObject}->Get("TimeAccounting::EnableAutoCompletion");

        # build output
        my $Output = $Self->{LayoutObject}->Header( Title => 'Edit' );

        if ( !$IncompleteWorkingDays{EnforceInsert} ) {
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Self->{LayoutObject}->Block(
                Name => 'OverviewProject',
                Data => { %Param, %Frontend },
            );

            # show create project link, if allowed
            my %UserData = $Self->{TimeAccountingObject}->UserGet(
                UserID => $Self->{UserID},
            );
            if ( $UserData{CreateProject} ) {
                $Self->{LayoutObject}->Block( Name => 'CreateProject', );
            }
        }
        else {
            if ( $IncompleteWorkingDays{Warning} ) {
                $Output .= $Self->{LayoutObject}->Notify(
                    Info     => 'Please insert your working hours!',
                    Priority => 'Error'
                );
            }
        }

        if ($ErrorNote) {
            $Output .= $Self->{LayoutObject}->Notify(
                Info     => $ErrorNote,
                Priority => 'Error'
            );
        }
        elsif ( $Param{SuccessfulInsert} )
        {
            $Output .= $Self->{LayoutObject}->Notify( Info => 'Successful insert!', );
        }
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentTimeAccountingEdit',
            Data         => {
                %Param,
                %Frontend,
            },
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ---------------------------------------------------------- #
    # view older day inserts
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'View' ) {

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

        # if no UserID posted use the current user
        $Param{UserID} ||= $Self->{UserID};

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
            Prefix => '',
            Format => 'DateInputFormat',
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

    # ---------------------------------------------------------- #
    # delete object from database
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'Delete' ) {
        for my $Parameter (qw(Day Month Year)) {
            $Param{$Parameter} = $Self->{ParamObject}->GetParam( Param => $Parameter );
        }

        return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' ) if !$Self->{AccessRo};

        if (
            !$Self->{TimeAccountingObject}->WorkingUnitsDelete(
                Year  => $Param{Year},
                Month => $Param{Month},
                Day   => $Param{Day},
            )
            )
        {
            return $Self->{LayoutObject}->ErrorScreen();
        }
        return $Self->{LayoutObject}->Redirect(
            OP =>
                "Action=$Self->{Action};Subaction=Edit;Year=$Param{Year};Month=$Param{Month};Day=$Param{Day}"
        );
    }

    # ---------------------------------------------------------- #
    # overview about the users time accounting
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'Overview' ) {
        my ( $Sec, $Min, $Hour, $CurrentDay, $Month, $Year )
            = $Self->{TimeObject}->SystemTime2Date(
            SystemTime => $Self->{TimeObject}->SystemTime(),
            );

        # permission check
        return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' ) if !$Self->{AccessRo};

        for my $Parameter (qw(Status Day Month Year UserID ProjectStatusShow)) {
            $Param{$Parameter} = $Self->{ParamObject}->GetParam( Param => $Parameter );
        }
        $Param{Subaction} = 'Edit';

        if ( !$Param{UserID} ) {
            $Param{UserID} = $Self->{UserID};
        }
        else {
            if ( $Param{UserID} != $Self->{UserID} && !$Self->{AccessRw} ) {
                return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
            }
            $Param{Subaction} = 'View';
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
                "Action=$Self->{Action};Subaction=Overview;Year=$Param{Year};Month=$Param{Month}",
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
            my $Zone = $Self->{ConfigObject}->Get( "TimeZone::Calendar" . $UserData{Calendar} );
            if ($Zone) {
                my $ZoneSeconds = $Zone * 60 * 60;
                $DayStartTime = $DayStartTime - $ZoneSeconds;
                $DayStopTime  = $DayStopTime - $ZoneSeconds;
            }

            my $ThisDayWorkingTime = $Self->{TimeObject}->WorkingTime(
                StartTime => $DayStartTime,
                StopTime  => $DayStopTime,
                Calendar  => $UserData{Calendar} || '',
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

    # ---------------------------------------------------------- #
    # settings for handling time accounting
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'Setting' ) {

        # permission check
        return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' ) if !$Self->{AccessRw};

        # get the user action to show a msg if an user was updated or added
        my $Note = $Self->{ParamObject}->GetParam( Param => 'User' );

        # build output
        $Self->_SettingOverview();
        my $Output = $Self->{LayoutObject}->Header( Title => 'Setting' );
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # show a notification msg if proper
        if ($Note) {
            $Output .= $Note eq 'EditUser'
                ? $Self->{LayoutObject}->Notify( Info => 'User updated!' )
                : $Self->{LayoutObject}->Notify( Info => 'User added!' );
        }

        $Output .= $Self->{LayoutObject}->Output(
            Data         => \%Param,
            TemplateFile => 'AgentTimeAccountingSetting'
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;

        my %Data = ();

        for my $Parameter (qw(ActionAction ActionUser NewAction NewUser)) {
            $Param{$Parameter} = $Self->{ParamObject}->GetParam( Param => $Parameter );
        }

        if ( $Param{ActionAction} || $Param{NewAction} ) { }
        else {
            my %User = $Self->{TimeAccountingObject}->UserSettingsGet();

            my %LastPeriod = ();
            for my $UserID ( keys %User ) {
                $LastPeriod{$UserID} = 0;
                for my $Period ( keys %{ $User{$UserID} } ) {
                    if ( $LastPeriod{$UserID} < $Period ) {
                        $LastPeriod{$UserID} = $Period;
                    }
                }
                if ( $Self->{ParamObject}->GetParam( Param => "NewUserSetting[${UserID}]" ) ) {
                    my %InsertData = ();
                    $InsertData{UserID} = $UserID;
                    $InsertData{Period} = $LastPeriod{$UserID} + 1;
                    $Param{ActionUser}  = 'true';
                    if ( !$Self->{TimeAccountingObject}->UserSettingsInsert(%InsertData) ) {
                        return $Self->{LayoutObject}->ErrorScreen(
                            Message => 'Can\'t insert user data!'
                        );
                    }
                }
            }

            if ( $Param{ActionUser} || $Param{NewUser} ) {

                my %UserBasics = $Self->{TimeAccountingObject}->UserList();

                USERID:
                for my $UserID ( keys %User ) {

                    for my $Parameter (qw( ShowOvertime CreateProject Calendar )) {
                        $Data{$UserID}{$Parameter}
                            = $Self->{ParamObject}
                            ->GetParam( Param => $Parameter . '[' . $UserID . ']' );
                    }

                    my $Break = '';
                    if (
                        $UserBasics{$UserID}{Description}
                        && $Self->{ParamObject}->GetParam( Param => 'Description[' . $UserID . ']' )
                        )
                    {
                        $Break = "\n";
                    }

                    my $Description
                        = $Self->{ParamObject}->GetParam( Param => "Description[${UserID}]" );

                    $Data{$UserID}{Description}
                        = $UserBasics{$UserID}{Description} . $Break . $Description;

                    $Data{$UserID}{UserID} = $UserID;

                    for my $Period ( keys %{ $User{$UserID} } ) {

                        # the following is because of deactivate user
                        if (
                            !defined $Self->{ParamObject}->GetParam(
                                Param => 'DateStart[' . $UserID . '][' . $Period . ']'
                            )
                            )
                        {
                            delete $Data{$UserID};
                            next USERID;
                        }

                        for my $Parameter (
                            qw(WeeklyHours LeaveDays UserStatus DateStart DateEnd Overtime)
                            )
                        {
                            $Data{$UserID}{$Period}{$Parameter} = $Self->{ParamObject}->GetParam(
                                Param => $Parameter . '[' . $UserID . '][' . $Period . ']'
                            );
                        }
                        $Data{$UserID}{$Period}{UserID} = $UserID;
                        $LastPeriod{$UserID} = $Period;
                    }
                }

                if ( !$Self->{TimeAccountingObject}->UserSettingsUpdate(%Data) ) {
                    return $Self->{LayoutObject}->ErrorScreen(
                        Message => 'Can\'t update user data!'
                    );
                }

                if ( $Param{NewUser} && $Self->{ParamObject}->GetParam( Param => 'NewUserID' ) ) {

                    %Data = ();
                    $Data{UserID} = $Self->{ParamObject}->GetParam( Param => 'NewUserID' );
                    $Data{Period} = '1';
                    if ( !$Self->{TimeAccountingObject}->UserSettingsInsert(%Data) ) {
                        return $Self->{LayoutObject}->ErrorScreen(
                            Message => 'Can\'t insert user data!'
                        );
                    }
                    my %Groups = $Self->{GroupObject}->GroupList( Valid => 1 );
                    my %GroupData = $Self->{GroupObject}->GroupMemberList(
                        UserID => $Data{UserID},
                        Type   => 'ro',
                        Result => 'HASH',
                    );
                    for my $GroupKey ( keys %Groups ) {
                        if ( $Groups{$GroupKey} eq 'time_accounting' && !$GroupData{$GroupKey} ) {

                            $Self->{GroupObject}->GroupMemberAdd(
                                GID        => $GroupKey,
                                UID        => $Data{UserID},
                                Permission => {
                                    ro        => 1,
                                    move_into => 0,
                                    create    => 0,
                                    owner     => 0,
                                    priority  => 0,
                                    rw        => 0,
                                },
                                UserID => $Self->{UserID},
                            );
                        }
                    }
                }
            }
        }

        # Show TimeAccounting Preferences
        my %StatusList = (
            1 => 'valid',
            0 => 'invalid',
        );

        # Show action data
        my %Action      = $Self->{TimeAccountingObject}->ActionSettingsGet();
        my $ActionEmpty = 0;

        for my $ActionID ( sort { $Action{$a}{Action} cmp $Action{$b}{Action} } keys %Action ) {
            $Param{Action}   = $Action{$ActionID}{Action};
            $Param{ActionID} = $ActionID;

            my $StatusOption = $Self->{LayoutObject}->BuildSelection(
                Data       => \%StatusList,
                SelectedID => $Action{$ActionID}{ActionStatus},
                Name       => "ActionStatus[$Param{ActionID}]",
            );

            $Self->{LayoutObject}->Block(
                Name => 'Action',
                Data => {
                    %Param,
                    StatusOption => $StatusOption,
                },
            );
        }

        # Show user data
        my %User       = $Self->{TimeAccountingObject}->UserSettingsGet();
        my %UserBasics = $Self->{TimeAccountingObject}->UserList();
        my %ShownUsers = $Self->{UserObject}->UserList( Type => 'Long', Valid => 1 );

        # fill up the calendar list
        my $CalendarListRef = { 0 => 'Default' };
        my $CalendarIndex = 1;
        while ( $Self->{ConfigObject}->Get( "TimeZone::Calendar" . $CalendarIndex . "Name" ) ) {
            $CalendarListRef->{$CalendarIndex}
                = $Self->{ConfigObject}->Get( "TimeZone::Calendar" . $CalendarIndex . "Name" );
            $CalendarIndex++;
        }

        USERID:
        for my $UserID ( sort { $ShownUsers{$a} cmp $ShownUsers{$b} } keys %ShownUsers ) {
            next USERID if !$User{$UserID};

            $Param{User}   = $ShownUsers{$UserID};
            $Param{UserID} = $UserID;
            my $UserRef       = $User{$UserID};
            my $UserBasicsRef = $UserBasics{$UserID};

            my $Description = $Self->{LayoutObject}->Ascii2Html(
                Text           => $UserBasicsRef->{Description},
                HTMLResultMode => 1,
                NewLine        => 50,
            );

            $Description = $Description ? $Description . '<br>' : '';

            my $CalendarOption = $Self->{LayoutObject}->BuildSelection(
                Data        => $CalendarListRef,
                Name        => "Calendar[$UserID]",
                Translation => 0,
                SelectedID  => $UserBasicsRef->{Calendar} || 0,
            );

            $Self->{LayoutObject}->Block(
                Name => 'User',
                Data => {
                    %Param,
                    Description    => $Description,
                    ShowOvertime   => $UserBasicsRef->{ShowOvertime} ? 'checked="checked"' : '',
                    CreateProject  => $UserBasicsRef->{CreateProject} ? 'checked="checked"' : '',
                    CalendarOption => $CalendarOption,
                },
            );

            delete $ShownUsers{$UserID};

            for my $Period ( sort keys %{$UserRef} ) {

                my $StatusOption = $Self->{LayoutObject}->BuildSelection(
                    Data       => \%StatusList,
                    SelectedID => $UserRef->{$Period}{UserStatus},
                    Name       => "UserStatus[$UserID][$Period]",
                );

                $Self->{LayoutObject}->Block(
                    Name => 'Period',
                    Data => {
                        UserID       => $UserID,
                        WeeklyHours  => $UserRef->{$Period}{WeeklyHours},
                        LeaveDays    => $UserRef->{$Period}{LeaveDays},
                        Overtime     => $UserRef->{$Period}{Overtime},
                        DateStart    => $UserRef->{$Period}{DateStart},
                        DateEnd      => $UserRef->{$Period}{DateEnd},
                        Period       => $Period,
                        StatusOption => $StatusOption,
                    },
                );
            }
        }
    }

    # ---------------------------------------------------------- #
    # time accounting reporting
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'Reporting' ) {
        my %Frontend = ();
        my %ShownUsers = $Self->{UserObject}->UserList( Type => 'Long', Valid => 0 );
        my ( $Sec, $Min, $Hour, $CurrentDay, $Month, $Year )
            = $Self->{TimeObject}->SystemTime2Date(
            SystemTime => $Self->{TimeObject}->SystemTime(),
            );

        # permission check
        return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' ) if !$Self->{AccessRw};

        for my $Parameter (qw(Status Month Year ProjectStatusShow)) {
            $Param{$Parameter} = $Self->{ParamObject}->GetParam( Param => $Parameter );
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
                "Action=$Self->{Action};Subaction=Reporting;Year=$Param{Year};Month=$Param{Month}",
        );

        $Param{Month_to_Text} = $MonthArray[ $Param{Month} ];

        my %Month = ();
        for my $ID ( 1 .. 12 ) {
            $Month{ sprintf( "%02d", $ID ) } = $MonthArray[$ID];
        }

        $Frontend{MonthOption} = $Self->{LayoutObject}->BuildSelection(
            Data        => \%Month,
            SelectedID  => $Param{Month} || '',
            Name        => 'Month',
            Sort        => 'NumericKey',
            Translation => 1,
        );

        my @Year = ( $Year - 4 .. $Year + 1 );

        $Frontend{YearOption} = $Self->{LayoutObject}->BuildSelection(
            Data        => \@Year,
            SelectedID  => $Param{Year} || '',
            Name        => 'Year',
            Translation => 0,
        );

        ( $Param{YearBack}, $Param{MonthBack}, $Param{DayBack} )
            = Add_Delta_YMD( $Param{Year}, $Param{Month}, 1, 0, -1, 0 );
        ( $Param{YearNext}, $Param{MonthNext}, $Param{DayNext} )
            = Add_Delta_YMD( $Param{Year}, $Param{Month}, 1, 0, 1, 0 );

        my %UserReport = $Self->{TimeAccountingObject}->UserReporting(
            Year   => $Param{Year},
            Month  => $Param{Month},
            UserID => $Param{UserID},
        );

        my %UserBasics = $Self->{TimeAccountingObject}->UserList();

        USERID:
        for my $UserID ( sort { $ShownUsers{$a} cmp $ShownUsers{$b} } keys %ShownUsers ) {
            next USERID if !$UserReport{$UserID};

            for my $Parameter (
                qw(LeaveDay Overtime WorkingHours Sick LeaveDayRemaining OvertimeTotal)
                )
            {
                $Param{$Parameter} = sprintf( "%.2f", ( $UserReport{$UserID}{$Parameter} || 0 ) );
                $Param{ 'Total' . $Parameter } += $Param{$Parameter};
            }

            # Show Overtime if allowed
            if ( !$UserBasics{$UserID}{ShowOvertime} ) {
                $Param{Overtime}      = '';
                $Param{OvertimeTotal} = '';
            }

            $Param{User}   = $ShownUsers{$UserID};
            $Param{UserID} = $UserID;
            $Self->{LayoutObject}->Block(
                Name => 'User',
                Data => { %Param, %Frontend },
            );
        }

        for my $Parameter (
            qw(TotalLeaveDay TotalOvertime TotalWorkingHours
            TotalSick TotalLeaveDayRemaining TotalOvertimeTotal)
            )
        {
            $Param{$Parameter} = sprintf( "%.2f", ( $Param{$Parameter} ) || 0 );
        }

        # show the report sort by projects
        if ( !$Param{ProjectStatusShow} || $Param{ProjectStatusShow} eq 'valid' ) {
            $Param{ProjectStatusShow} = 'all';
        }
        elsif ( $Param{ProjectStatusShow} eq 'all' ) {
            $Param{ProjectStatusShow} = 'valid';
        }

        $Param{ShowProjects} = 'Show ' . $Param{ProjectStatusShow} . ' projects';

        my %ProjectData = $Self->{TimeAccountingObject}->ProjectActionReporting(
            Year  => $Param{Year},
            Month => $Param{Month},
        );

        # REMARK:merge this projectreporting list with the list in overview

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
                            RowSpan            => ( 1 + scalar keys %{$ActionsRef} ),
                            Status             => $Param{Status},
                            ProjectDescription => $ProjectDescription,
                            Project            => $ProjectRef->{Name},
                            ProjectID          => $ProjectID,
                        },
                    );
                }
            }

            $Param{Hours}      = sprintf( "%.2f", $Total );
            $Param{HoursTotal} = sprintf( "%.2f", $TotalTotal );
            $Param{TotalHours}      += $Total;
            $Param{TotalHoursTotal} += $TotalTotal;
            $Self->{LayoutObject}->Block(
                Name => 'ActionTotal',
                Data => { %Param, %Frontend },
            );
        }

        $Param{TotalHours}      ||= 0;
        $Param{TotalHoursTotal} ||= 0;

        $Param{TotalHours}      = sprintf( "%.2f", $Param{TotalHours} );
        $Param{TotalHoursTotal} = sprintf( "%.2f", $Param{TotalHoursTotal} );

        # build output
        my $Output .= $Self->{LayoutObject}->Header( Title => 'Reporting' );
        $Output    .= $Self->{LayoutObject}->NavigationBar();
        $Output    .= $Self->{LayoutObject}->Output(
            Data => { %Param, %Frontend },
            TemplateFile => 'AgentTimeAccountingReporting'
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ---------------------------------------------------------- #
    # time accounting project reporting
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'ProjectReporting' ) {
        my %Frontend = ();

        # permission check
        return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' ) if !$Self->{AccessRo};

        # get params
        $Param{ProjectID} = $Self->{ParamObject}->GetParam( Param => 'ProjectID' );

        # check needed params
        if ( !$Param{ProjectID} ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => 'ProjectReporting: Need ProjectID'
            );
        }

        my %Action  = $Self->{TimeAccountingObject}->ActionSettingsGet();
        my %Project = $Self->{TimeAccountingObject}->ProjectSettingsGet();
        $Param{Project} = $Project{Project}{ $Param{ProjectID} };

        my %ShownUsers = $Self->{UserObject}->UserList( Type => 'Long', Valid => 0 );

        # necassary because the ProjectActionReporting is not reworked
        my ( $Sec, $Min, $Hour, $CurrentDay, $Month, $Year )
            = $Self->{TimeObject}->SystemTime2Date(
            SystemTime => $Self->{TimeObject}->SystemTime(),
            );
        my %ProjectData = ();
        my %ProjectTime = ();

        # Only one function should be enough
        for my $UserID ( keys %ShownUsers ) {

            # Overview per project and action
            # REMARK: This is the wrong function to get this information
            %ProjectData = $Self->{TimeAccountingObject}->ProjectActionReporting(
                Year   => $Year,
                Month  => $Month,
                UserID => $UserID,
            );
            if ( $ProjectData{ $Param{ProjectID} } ) {
                my $ActionsRef = $ProjectData{ $Param{ProjectID} }{Actions};
                for my $ActionID ( keys %{$ActionsRef} ) {
                    $ProjectTime{$ActionID}{$UserID}{Hours} = $ActionsRef->{$ActionID}{Total};
                }
            }
            else {
                delete $ShownUsers{$UserID};
            }
        }

        # show the headerline
        for my $UserID ( sort { $ShownUsers{$a} cmp $ShownUsers{$b} } keys %ShownUsers ) {
            $Self->{LayoutObject}->Block(
                Name => 'UserName',
                Data => { User => $ShownUsers{$UserID} },
            );
        }

        # better solution for sort actions necessary
        my %NewAction = ();
        for my $ActionID ( keys %ProjectTime ) {
            $NewAction{$ActionID} = $Action{$ActionID}{Action};
        }
        %Action = %NewAction;

        # show the results
        my %Total = ();
        for my $ActionID ( sort { $Action{$a} cmp $Action{$b} } keys %Action ) {
            my $TotalHours = 0;
            $Self->{LayoutObject}->Block(
                Name => 'Action',
                Data => { Action => $Action{$ActionID}, },
            );
            for my $UserID ( sort { $ShownUsers{$a} cmp $ShownUsers{$b} } keys %ShownUsers ) {
                $TotalHours += $ProjectTime{$ActionID}{$UserID}{Hours} || 0;
                $Total{$UserID} += $ProjectTime{$ActionID}{$UserID}{Hours} || 0;
                $Self->{LayoutObject}->Block(
                    Name => 'User',
                    Data => {
                        Hours => sprintf( "%.2f", $ProjectTime{$ActionID}{$UserID}{Hours} || 0 ),
                    },
                );
            }

            # Total
            $Self->{LayoutObject}->Block(
                Name => 'User',
                Data => { Hours => sprintf( "%.2f", $TotalHours ), },
            );
        }
        $Param{TotalAll} = 0;
        for my $UserID ( sort { $ShownUsers{$a} cmp $ShownUsers{$b} } keys %ShownUsers ) {
            $Param{TotalAll} += $Total{$UserID};
            $Self->{LayoutObject}->Block(
                Name => 'UserTotal',
                Data => { Total => sprintf( "%.2f", $Total{$UserID} ), },
            );
        }

        $Param{TotalAll} = sprintf( "%.2f", $Param{TotalAll} );

        my @ProjectHistoryArray = $Self->{TimeAccountingObject}->ProjectHistory(
            ProjectID => $Param{ProjectID},
        );
        for my $Row (@ProjectHistoryArray) {
            $Self->{LayoutObject}->Block(
                Name => 'Row',
                Data => {
                    User   => $Row->{User},
                    Action => $Row->{Action},
                    Remark => $Row->{Remark} || '--',
                    Period => sprintf( "%.2f", $Row->{Period} ),
                    Date   => $Row->{Date},
                    }
            );
        }

        # show the total sum of hours at the end of the history list
        # I also can use $Param{TotalAll}
        my $ProjectTotalHours = sprintf(
            "%.2f",
            $Self->{TimeAccountingObject}->ProjectTotalHours(
                ProjectID => $Param{ProjectID},
                )
        );

        $Self->{LayoutObject}->Block(
            Name => 'HistoryTotal',
            Data => {
                HistoryTotal => $ProjectTotalHours || 0,
                }
        );

        # build output
        my $Output = $Self->{LayoutObject}->Header( Title => 'ProjectReporting' );
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            Data => { %Param, %Frontend },
            TemplateFile => 'AgentTimeAccountingProjectReporting'
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ---------------------------------------------------------- #
    # add project
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'AddProject' ) {
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->_ProjectSettingsEdit( Action => 'AddProject' );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentTimeAccountingSetting',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ---------------------------------------------------------- #
    # add project action
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'AddProjectAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $Note = '';
        my $ProjectID;
        my ( %GetParam, %Errors );

        # get parameters
        for my $Parameter (qw(Project ProjectDescription)) {
            $GetParam{$Parameter} = $Self->{ParamObject}->GetParam( Param => $Parameter ) || '';
        }
        $GetParam{ProjectStatus} = $Self->{ParamObject}->GetParam( Param => 'ProjectStatus' )
            || '0';

        # check for needed data
        if ( !$GetParam{Project} ) {
            $Errors{ProjectInvalid}   = 'ServerError';
            $Errors{ProjectErrorType} = 'ProjectMissingValue';
        }
        else {

            # check that the name is unique
            my %ExistingProject
                = $Self->{TimeAccountingObject}->ProjectGet( Project => $GetParam{Project} );
            if (%ExistingProject) {
                $Errors{ProjectInvalid}   = 'ServerError';
                $Errors{ProjectErrorType} = 'ProjectDuplicateName';
            }
        }

        # if no errors occurred
        if ( !%Errors ) {

            # add project
            $ProjectID = $Self->{TimeAccountingObject}->ProjectSettingsInsert(%GetParam);

            if ($ProjectID) {

                # build the output
                $Self->_SettingOverview();
                my $Output = $Self->{LayoutObject}->Header();
                $Output .= $Self->{LayoutObject}->NavigationBar();
                $Output .= $Self->{LayoutObject}->Notify( Info => 'Project added!' );
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'AgentTimeAccountingSetting',
                    Data         => {%GetParam},
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
            else {
                $Note = $Self->{LogObject}->GetLogEntry(
                    Type => 'Error',
                    What => 'Message',
                );
            }
        }

        # something went wrong
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Note
            ? $Self->{LayoutObject}->Notify(
            Priority => 'Error',
            Info     => $Note,
            )
            : '';
        $Self->_ProjectSettingsEdit(
            Action => 'AddProject',
            %GetParam,
            %Errors,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentTimeAccountingSetting',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ---------------------------------------------------------- #
    # edit project
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'EditProject' ) {
        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' );

        # get project data
        my %Project = $Self->{TimeAccountingObject}->ProjectGet( ID => $ID );

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->_ProjectSettingsEdit(
            Action => 'EditProject',
            %Project,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentTimeAccountingSetting',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ---------------------------------------------------------- #
    # edit project action
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'EditProjectAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $Note = '';
        my ( %GetParam, %Errors );

        # get parameters
        $GetParam{ID} = $Self->{ParamObject}->GetParam( Param => 'ID' ) || '';
        $GetParam{ProjectStatus} = $Self->{ParamObject}->GetParam( Param => 'ProjectStatus' )
            || '0';
        for my $Parameter (qw(Project ProjectDescription)) {
            $GetParam{$Parameter} = $Self->{ParamObject}->GetParam( Param => $Parameter ) || '';
        }

        # check for needed data
        if ( !$GetParam{Project} ) {
            $Errors{ProjectInvalid} = 'ServerError';
        }
        else {

            # check that the name is unique
            my %ExistingProject
                = $Self->{TimeAccountingObject}->ProjectGet( Project => $GetParam{Project} );

            # if the project name is found, check that the ID is different
            if ( %ExistingProject && $ExistingProject{ID} ne $GetParam{ID} ) {
                $Errors{ProjectInvalid}   = 'ServerError';
                $Errors{ProjectErrorType} = 'ProjectDuplicateName';
            }
        }

        # if no errors occurred
        if ( !%Errors ) {

            # edit project
            if ( $Self->{TimeAccountingObject}->ProjectSettingsUpdate(%GetParam) ) {

                $Self->_SettingOverview();
                my $Output = $Self->{LayoutObject}->Header();
                $Output .= $Self->{LayoutObject}->NavigationBar();
                $Output .= $Self->{LayoutObject}->Notify( Info => 'Project updated!' );
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'AgentTimeAccountingSetting',
                    Data         => \%Param,
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
            else {
                $Note = $Self->{LogObject}->GetLogEntry(
                    Type => 'Error',
                    What => 'Message',
                );
            }
        }

        # something went wrong
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Note
            ? $Self->{LayoutObject}->Notify(
            Priority => 'Error',
            Info     => $Note,
            )
            : '';
        $Self->_ProjectSettingsEdit(
            Action => 'EditProject',
            %GetParam,
            %Param,
            %Errors,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentTimeAccountingSetting',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ---------------------------------------------------------- #
    # add task
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'AddTask' ) {
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->_TaskSettingsEdit( Action => 'AddTask' );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentTimeAccountingSetting',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ---------------------------------------------------------- #
    # add task action
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'AddTaskAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $Note = '';
        my $TaskID;
        my ( %GetParam, %Errors );

        # get parameters
        $GetParam{Task} = $Self->{ParamObject}->GetParam( Param => 'Task' ) || '';
        $GetParam{TaskStatus} = $Self->{ParamObject}->GetParam( Param => 'TaskStatus' )
            || '0';

        # check for needed data
        if ( !$GetParam{Task} ) {
            $Errors{TaskInvalid}   = 'ServerError';
            $Errors{TaskErrorType} = 'TaskMissingValue';
        }
        else {

            # check that the name is unique
            my %ExistingTask
                = $Self->{TimeAccountingObject}->ActionGet( Action => $GetParam{Task} );
            if (%ExistingTask) {
                $Errors{TaskInvalid}   = 'ServerError';
                $Errors{TaskErrorType} = 'TaskDuplicateName';
            }
        }

        # if no errors occurred
        if ( !%Errors ) {

            # add task
            $TaskID = $Self->{TimeAccountingObject}->ActionSettingsInsert(
                Action       => $GetParam{Task},
                ActionStatus => $GetParam{TaskStatus},
            );

            if ($TaskID) {

                # build the output
                $Self->_SettingOverview();
                my $Output = $Self->{LayoutObject}->Header();
                $Output .= $Self->{LayoutObject}->NavigationBar();
                $Output .= $Self->{LayoutObject}->Notify( Info => 'Task added!' );
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'AgentTimeAccountingSetting',
                    Data         => {},
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
            else {
                $Note = $Self->{LogObject}->GetLogEntry(
                    Type => 'Error',
                    What => 'Message',
                );
            }
        }

        # something went wrong
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Note
            ? $Self->{LayoutObject}->Notify(
            Priority => 'Error',
            Info     => $Note,
            )
            : '';
        $Self->_TaskSettingsEdit(
            Action => 'AddTask',
            %GetParam,
            %Errors,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentTimeAccountingSetting',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ---------------------------------------------------------- #
    # edit task
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'EditTask' ) {
        my $ID = $Self->{ParamObject}->GetParam( Param => 'ActionID' ) || '';

        # get project data
        my %Task = $Self->{TimeAccountingObject}->ActionGet( ID => $ID );

        my %TaskData = (
            Task       => $Task{Action},
            TaskStatus => $Task{ActionStatus},
        );

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->_TaskSettingsEdit(
            Action   => 'EditTask',
            ActionID => $ID,
            %TaskData,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentTimeAccountingSetting',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ---------------------------------------------------------- #
    # edit project action
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'EditTaskAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $Note = '';
        my ( %GetParam, %Errors );

        # get parameters
        $GetParam{ActionID}   = $Self->{ParamObject}->GetParam( Param => 'ActionID' )   || '';
        $GetParam{TaskStatus} = $Self->{ParamObject}->GetParam( Param => 'TaskStatus' ) || '0';
        $GetParam{Task}       = $Self->{ParamObject}->GetParam( Param => 'Task' )       || '';

        # check for needed data
        if ( !$GetParam{Task} ) {
            $Errors{TaskInvalid} = 'ServerError';
        }
        else {

            # check that the name is unique
            my %ExistingTask
                = $Self->{TimeAccountingObject}->ActionGet( Action => $GetParam{Task} );

            # if the task name is found, check that the ID is different
            if ( %ExistingTask && $ExistingTask{ID} ne $GetParam{ActionID} ) {
                $Errors{TaskInvalid}   = 'ServerError';
                $Errors{TaskErrorType} = 'TaskDuplicateName';
            }
        }

        # if no errors occurred
        if ( !%Errors ) {

            # edit action (task)
            my $ActionUpdate = $Self->{TimeAccountingObject}->ActionSettingsUpdate(
                ActionID     => $GetParam{ActionID},
                Action       => $GetParam{Task},
                ActionStatus => $GetParam{TaskStatus},
            );

            if ($ActionUpdate) {
                $Self->_SettingOverview();
                my $Output = $Self->{LayoutObject}->Header();
                $Output .= $Self->{LayoutObject}->NavigationBar();
                $Output .= $Self->{LayoutObject}->Notify( Info => 'Task updated!' );
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'AgentTimeAccountingSetting',
                    Data         => \%Param,
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
            else {
                $Note = $Self->{LogObject}->GetLogEntry(
                    Type => 'Error',
                    What => 'Message',
                );
            }
        }

        # something went wrong
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Note
            ? $Self->{LayoutObject}->Notify(
            Priority => 'Error',
            Info     => $Note,
            )
            : '';
        $Self->_TaskSettingsEdit(
            Action => 'EditTask',
            %GetParam,
            %Param,
            %Errors,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentTimeAccountingSetting',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ---------------------------------------------------------- #
    # add user
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'AddUser' ) {

        # get parameters
        my $NewUserID = $Self->{ParamObject}->GetParam( Param => 'NewUserID' )
            || $Self->{ParamObject}->GetParam( Param => 'UserID' )
            || '';
        my $NewTimePeriod = $Self->{ParamObject}->GetParam( Param => 'NewTimePeriod' );

        my $LastPeriodNumber = $Self->{TimeAccountingObject}->UserLastPeriodNumberGet(
            UserID => $NewUserID,
        );

        my $Success = $Self->{TimeAccountingObject}->UserSettingsInsert(
            UserID => $NewUserID,
            Period => $LastPeriodNumber + 1,
        );

        # if it is not an action about adding a new time period
        if ( !$NewTimePeriod ) {
            if ( !$Success ) {
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => 'Can\'t insert user data!'
                );
            }

            my %Groups = $Self->{GroupObject}->GroupList( Valid => 1 );
            my %GroupData = $Self->{GroupObject}->GroupMemberList(
                UserID => $NewUserID,
                Type   => 'ro',
                Result => 'HASH',
            );
            for my $GroupKey ( keys %Groups ) {
                if ( $Groups{$GroupKey} eq 'time_accounting' && !$GroupData{$GroupKey} ) {

                    $Self->{GroupObject}->GroupMemberAdd(
                        GID        => $GroupKey,
                        UID        => $NewUserID,
                        Permission => {
                            ro        => 1,
                            move_into => 0,
                            create    => 0,
                            owner     => 0,
                            priority  => 0,
                            rw        => 0,
                        },
                        UserID => $Self->{UserID},
                    );
                }
            }
        }

        my %User = $Self->{UserObject}->GetUserData( UserID => $NewUserID );
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->_UserSettingsEdit(
            Action    => 'AddUser',
            Subaction => 'AddUser',
            %User,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentTimeAccountingSetting',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ---------------------------------------------------------- #
    # edit user settings
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'EditUser' ) {
        my $ID = $Self->{ParamObject}->GetParam( Param => 'UserID' ) || '';

        my $NewTimePeriod = $Self->{ParamObject}->GetParam( Param => 'NewTimePeriod' );
        my $LastPeriodNumber = $Self->{TimeAccountingObject}->UserLastPeriodNumberGet(
            UserID => $ID,
        );

        # if it is an action about adding a new time period, insert it
        if ($NewTimePeriod) {
            my $Success = $Self->{TimeAccountingObject}->UserSettingsInsert(
                UserID => $ID,
                Period => $LastPeriodNumber + 1,
            );
            if ( !$Success ) {
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => 'Unable to add time period! Please contact your administrator.',
                );
            }
        }

        my %Errors = ();

        if (
            $Self->{ParamObject}->GetParam( Param => 'AddPeriod' )
            || $Self->{ParamObject}->GetParam( Param => 'SubmitUserData' )
            )
        {

            # check validity of periods
            %Errors = $Self->_CheckValidityUserPeriods( Period => $LastPeriodNumber );
        }

        # get user data
        my %User = $Self->{UserObject}->GetUserData( UserID => $ID );

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->_UserSettingsEdit(
            Action    => 'EditUser',
            Subaction => 'EditUser',
            UserID    => $ID,
            Errors    => \%Errors,
            Periods   => $LastPeriodNumber,
            %User,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentTimeAccountingSetting',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ---------------------------------------------------------- #
    # show error screen
    # ---------------------------------------------------------- #
    $Self->{LogObject}->Log( Priority => 'error', Message => "$Self->{Subaction}" );

    #    return $Self->{LayoutObject}->ErrorScreen( Message => 'Invalid Subaction process!' );
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
        if ( $StartDate >= $EndDate ) {
            $Errors{ 'DateEnd-' . $Period . 'Invalid' }   = 'ServerError';
            $Errors{ 'DateEnd-' . $Period . 'ErrorType' } = 'BeforeDateStart';
        }
    }

    return %Errors;
}

sub _FirstUserRedirect {
    my $Self = shift;

    # for initial useing, the first agent with rw-right will be redirected
    # to 'Setting'. Then he can do the initial settings

    my %GroupList = $Self->{GroupObject}->GroupMemberList(
        UserID => $Self->{UserID},
        Type   => 'rw',
        Result => 'HASH',
    );
    for my $GroupKey ( keys %GroupList ) {
        if ( $GroupList{$GroupKey} eq 'time_accounting' ) {
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=AgentTimeAccounting;" . "Subaction=Setting"
            );
        }
    }
    return $Self->{LayoutObject}->ErrorScreen(
        Message =>
            "No UserPeriod available, please contact the time accounting admin to insert your UserPeriod!"
    );
}

sub _ActionList {
    my $Self = shift;

    my %ActionList;
    my %Action = $Self->{TimeAccountingObject}->ActionSettingsGet();

    # get action settings
    ACTIONID:
    for my $ActionID ( keys %Action ) {
        next ACTIONID if !$Action{$ActionID}{ActionStatus};
        next ACTIONID if !$Action{$ActionID}{Action};
        $ActionList{$ActionID} = $Action{$ActionID}{Action};
    }
    $ActionList{''} = '';

    return %ActionList;
}

sub _ActionListConstraints {
    my ( $Self, %Param ) = @_;

    my %List;
    if ( $Param{ProjectID} && keys %{ $Param{ActionListConstraints} } ) {

        my $ProjectName;

        PROJECT:
        for my $Project ( @{ $Param{ProjectList} } ) {
            if ( $Project->{Key} eq $Param{ProjectID} ) {
                $ProjectName = $Project->{Value};
                last PROJECT;
            }
        }

        if ( defined($ProjectName) ) {

            # loop over actions to find matches for configured project
            # and action regexp pairs
            for my $ActionID ( keys %{ $Param{ActionList} } ) {

                my $ActionName = $Param{ActionList}->{$ActionID};

                REGEXP:
                for my $ProjectNameRegExp ( keys %{ $Param{ActionListConstraints} } ) {
                    my $ActionNameRegExp = $Param{ActionListConstraints}->{$ProjectNameRegExp};
                    if (
                        $ProjectName   =~ m{$ProjectNameRegExp}smx
                        && $ActionName =~ m{$ActionNameRegExp}smx
                        )
                    {
                        $List{$ActionID} = $ActionName;
                        last REGEXP;
                    }
                }
            }
        }
    }

    # all available actions will be added if no action was added above (possible misconfiguration)
    if ( !keys %List ) {
        for my $ActionID ( keys %{ $Param{ActionList} } ) {
            my $ActionName = $Param{ActionList}->{$ActionID};
            $List{$ActionID} = $ActionName;
        }
    }

    return \%List;
}

sub _ProjectList {
    my ( $Self, %Param ) = @_;

    # at first a empty line
    my @List = (
        {
            Key   => '',
            Value => '',
        },
    );

    # get project settings
    my %Project = $Self->{TimeAccountingObject}->ProjectSettingsGet(
        Status => 'valid',
    );

    if ( !$Self->{LastProjectsRef} ) {

        # get the last projects
        my @LastProjects = $Self->{TimeAccountingObject}->LastProjectsOfUser();

        # add the favorits
        %{ $Self->{LastProjectsRef} } = map { $_ => 1 } @LastProjects;
    }

    PROJECTID:
    for my $ProjectID (
        sort { $Project{Project}{$a} cmp $Project{Project}{$b} }
        keys %{ $Project{Project} }
        )
    {
        next PROJECTID if !$Self->{LastProjectsRef}->{$ProjectID};
        my %Hash = (
            Key   => $ProjectID,
            Value => $Project{Project}{$ProjectID},
        );
        push @List, \%Hash;

        # at the moment it is not possilbe mark the selected project
        # in the favorit list (I think a bug in Build selection?!)
    }

    # add the seperator
    push @List, {
        Key      => '0',
        Value    => '--------------------',
        Disabled => 1,
    };

    # add all allowed projects to the list
    PROJECTID:
    for my $ProjectID (
        sort { $Project{Project}{$a} cmp $Project{Project}{$b} }
        keys %{ $Project{Project} }
        )
    {
        next PROJECTID if !$Project{Project}{$ProjectID};
        my %Hash = (
            Key   => $ProjectID,
            Value => $Project{Project}{$ProjectID},
        );
        if ( $Param{SelectedID} && $Param{SelectedID} eq $ProjectID ) {
            $Hash{Selected} = 1;
        }

        push @List, \%Hash;
    }

    @List = $Self->_ProjectListConstraints(
        List => \@List,
        SelectedID => $Param{SelectedID} || '',
    );

    return \@List;
}

sub _ProjectListConstraints
{
    my ( $Self, %Param ) = @_;

    my @List;
    my $ProjectCount = 0;
    my $ProjectListConstraints
        = $Self->{ConfigObject}->Get('TimeAccounting::ProjectListConstraints');

    if ( keys %{$ProjectListConstraints} ) {

        # get groups of current user
        my %Groups = $Self->{GroupObject}->GroupMemberList(
            UserID => $Self->{UserID},
            Type   => 'ro',
            Result => 'HASH',
        );
        %Groups = map { $Groups{$_} => 1 } keys %Groups;

        # get project list constraints
        my %ProjectRegex;
        for my $ProjectRegex ( keys %{$ProjectListConstraints} ) {
            for my $ProjectGroup ( split /,\s*/, $ProjectListConstraints->{$ProjectRegex} ) {
                if ( $Groups{$ProjectGroup} ) {
                    $ProjectRegex{$ProjectRegex} = 1;
                }
            }
        }
        my @ProjectRegex = keys %ProjectRegex;

        # reduce project list according to configuration
        if ( ref( $Param{List} ) && @ProjectRegex ) {

            my $ElementCount = 0;

            for my $Project ( @{ $Param{List} } ) {
                my $ProjectName = $Project->{Value};

                # empty first element, last projects separator and currently selected project
                if ( !$ElementCount || !$Project->{Key} || $Project->{Key} eq $Param{SelectedID} ) {
                    push @List, $Project;
                }
                else {
                    PROJECTREGEXP:
                    for my $ProjectRegex (@ProjectRegex) {
                        if ( $ProjectName =~ m{$ProjectRegex}smx ) {
                            push @List, $Project;
                            $ProjectCount++;
                            last PROJECTREGEXP;
                        }
                    }
                }
                $ElementCount++;
            }
        }
    }

# get full project list if constraints resulted in empty project list or if constraints aren't configured (possible misconfiguration)
    if ( !$ProjectCount ) {
        @List = @{ $Param{List} };
    }

    return @List;
}

# integrate the handling for required remarks in relation to projects

sub _Project2RemarkRegExp {
    my $Self = shift;

    my @Projects2Remark = ();
    my %ProjectData     = $Self->{TimeAccountingObject}->ProjectSettingsGet(
        Status => 'valid',
    );

    return '' if !$Self->{ConfigObject}->Get('TimeAccounting::Project2RemarkRegExp');

    my $Project2RemarkRegExp = $Self->{ConfigObject}->Get('TimeAccounting::Project2RemarkRegExp');

    for my $ProjectID ( keys %{ $ProjectData{Project} } ) {
        if ( $ProjectData{Project}{$ProjectID} =~ m{$Project2RemarkRegExp}smx ) {
            push @Projects2Remark, $ProjectID;
        }
    }

    return join '|', @Projects2Remark;
}

sub _ProjectSettingsEdit {
    my ( $Self, %Param ) = @_;

    $Self->{LayoutObject}->Block(
        Name => 'OverviewProject',
        Data => \%Param,
    );

    $Self->{LayoutObject}->Block( Name => 'ActionListProject' );
    $Self->{LayoutObject}->Block( Name => 'ActionSettingOverview' );

    # define status list
    my %StatusList = (
        1 => 'valid',
        0 => 'invalid',
    );

    $Param{StatusOption} = $Self->{LayoutObject}->BuildSelection(
        Data       => \%StatusList,
        SelectedID => $Param{SelectedStatus} || 1,
        Name       => 'ProjectStatus',
    );

    $Self->{LayoutObject}->Block(
        Name => 'OverviewUpdateProject',
        Data => \%Param,
    );

    # shows header
    if ( $Param{Action} eq 'EditProject' ) {
        $Self->{LayoutObject}->Block( Name => 'HeaderEditProject' );
    }
    else {
        $Self->{LayoutObject}->Block( Name => 'HeaderAddProject' );
    }

    # show server error msg (if any) for the project name
    if ( $Param{ProjectErrorType} ) {
        $Self->{LayoutObject}->Block( Name => $Param{ProjectErrorType} );
    }

    return 1;
}

sub _SettingOverview {
    my ( $Self, %Param ) = @_;

    my %Project = ();
    my %Data    = ();

    # build output
    $Self->{LayoutObject}->Block( Name => 'Setting', );
    $Self->{LayoutObject}->Block( Name => 'ProjectFilter' );
    $Self->{LayoutObject}->Block( Name => 'TaskFilter' );
    $Self->{LayoutObject}->Block( Name => 'UserFilter' );
    $Self->{LayoutObject}->Block( Name => 'ActionListSetting' );
    $Self->{LayoutObject}->Block( Name => 'ActionAddProject' );
    $Self->{LayoutObject}->Block( Name => 'ActionAddTask' );

    # get user data
    my %ShownUsers = $Self->{UserObject}->UserList(
        Type  => 'Long',
        Valid => 1,
    );

    # get list of registered users (if any)
    my %User = $Self->{TimeAccountingObject}->UserList();

    USERID:
    for my $UserInfo ( sort { $ShownUsers{$a} cmp $ShownUsers{$b} } keys %ShownUsers ) {
        next USERID if !$User{$UserInfo};

        # delete already registered user from the 'new' list
        delete $ShownUsers{$UserInfo};
    }

    if (%ShownUsers) {
        $ShownUsers{''} = '';
        my $NewUserOption = $Self->{LayoutObject}->BuildSelection(
            Data        => \%ShownUsers,
            SelectedID  => '',
            Name        => 'NewUserID',
            Translation => 0,
        );
        $Self->{LayoutObject}->Block(
            Name => 'ActionAddUser',
            Data => { NewUserOption => $NewUserOption, },
        );
    }

    # Show project data
    %Project = $Self->{TimeAccountingObject}->ProjectSettingsGet();

    $Self->{LayoutObject}->Block(
        Name => 'OverviewResultProject',
        Data => \%Param,
    );

    # define status list
    my %StatusList = (
        1 => 'valid',
        0 => 'invalid',
    );

    # show list of available projects (if any)
    if ( $Project{Project} ) {
        for my $ProjectID (
            sort { $Project{Project}{$a} cmp $Project{Project}{$b} }
            keys %{ $Project{Project} }
            )
        {
            $Param{Project}            = $Project{Project}{$ProjectID};
            $Param{ProjectDescription} = $Project{ProjectDescription}{$ProjectID};
            $Param{ProjectID}          = $ProjectID;
            $Param{Status}             = $StatusList{ $Project{ProjectStatus}{$ProjectID} };

            $Self->{LayoutObject}->Block(
                Name => 'OverviewResultProjectRow',
                Data => {%Param},
            );
        }
    }

    # otherwise, show a no data found msg
    else {
        $Self->{LayoutObject}->Block( Name => 'NoProjectDataFoundMsg' );
    }

    # Show action data
    my %Action = $Self->{TimeAccountingObject}->ActionSettingsGet();

    $Self->{LayoutObject}->Block(
        Name => 'OverviewResultSetting',
        Data => \%Param,
    );

    # show list of available tasks/actions (if any)
    if (%Action) {
        for my $ActionID ( sort { $Action{$a}{Action} cmp $Action{$b}{Action} } keys %Action ) {
            $Param{Action}   = $Action{$ActionID}{Action};
            $Param{ActionID} = $ActionID;
            $Param{Status}   = $StatusList{ $Action{$ActionID}{ActionStatus} };

            $Self->{LayoutObject}->Block(
                Name => 'OverviewResultSettingRow',
                Data => {%Param},
            );
        }
    }

    # otherwise, show a no data found msg
    else {
        $Self->{LayoutObject}->Block( Name => 'NoSettingDataFoundMsg' );
    }

    # show user data
    $Self->{LayoutObject}->Block(
        Name => 'OverviewResultUser',
        Data => \%Param,
    );

    # show list of registered users (if any)
    if (%User) {
        for my $UserID ( sort { $User{$a} cmp $User{$b} } keys %User ) {

            # get missing user data
            my %UserData = $Self->{TimeAccountingObject}->UserGet( UserID => $UserID );
            my %UserGeneralData = $Self->{UserObject}->GetUserData( UserID => $UserID );

            $Param{User} = "$UserGeneralData{UserFirstname} $UserGeneralData{UserLastname} "
                . "($UserGeneralData{UserLogin})",;
            $Param{UserID}     = $UserID;
            $Param{Comment}    = $UserData{Description};
            $Param{CalendarNo} = $UserData{Calendar};
            $Param{Calendar}   = $Self->{ConfigObject}->Get(
                "TimeZone::Calendar"
                    . $Param{CalendarNo} . "Name"
            ) || 'Default';

            $Self->{LayoutObject}->Block(
                Name => 'OverviewResultUserRow',
                Data => {%Param},
            );
        }
    }

    # otherwise, show a no data found msg
    else {
        $Self->{LayoutObject}->Block( Name => 'NoUserDataFoundMsg' );
    }

    return 1;
}

sub _TaskSettingsEdit {
    my ( $Self, %Param ) = @_;

    $Self->{LayoutObject}->Block(
        Name => 'Setting',
        Data => \%Param,
    );

    $Self->{LayoutObject}->Block( Name => 'ActionListSetting' );
    $Self->{LayoutObject}->Block( Name => 'ActionOverviewSetting' );

    # define status list
    my %StatusList = (
        1 => 'valid',
        0 => 'invalid',
    );

    $Param{StatusOption} = $Self->{LayoutObject}->BuildSelection(
        Data       => \%StatusList,
        SelectedID => $Param{SelectedStatus} || 1,
        Name       => 'TaskStatus',
    );

    $Self->{LayoutObject}->Block(
        Name => 'OverviewUpdateTask',
        Data => \%Param,
    );

    # shows header
    if ( $Param{Action} eq 'EditTask' ) {
        $Self->{LayoutObject}->Block( Name => 'HeaderEditTask' );
    }
    else {
        $Self->{LayoutObject}->Block( Name => 'HeaderAddTask' );
    }

    # show server error msg (if any) for the task name
    if ( $Param{TaskErrorType} ) {
        $Self->{LayoutObject}->Block( Name => $Param{TaskErrorType} );
    }

    return 1;
}

sub _UserSettingsEdit {
    my ( $Self, %Param ) = @_;
    my %GetParam = ();

    # get parameters
    for my $Parameter (qw(Description ShowOvertime CreateProject Calendar)) {
        $GetParam{$Parameter} = $Self->{ParamObject}->GetParam( Param => $Parameter );
    }

    $Self->{LayoutObject}->Block(
        Name => 'Setting',
        Data => \%Param,
    );

    $Self->{LayoutObject}->Block( Name => 'ActionListSetting' );
    $Self->{LayoutObject}->Block( Name => 'ActionOverviewSetting' );
    $Self->{LayoutObject}->Block( Name => 'Reference' );

    # define status list
    my %StatusList = (
        1 => 'valid',
        0 => 'invalid',
    );

    # fill up the calendar list
    my $CalendarListRef = { 0 => 'Default' };
    my $CalendarIndex = 1;
    while ( $Self->{ConfigObject}->Get( "TimeZone::Calendar" . $CalendarIndex . "Name" ) ) {
        $CalendarListRef->{$CalendarIndex}
            = $Self->{ConfigObject}->Get( "TimeZone::Calendar" . $CalendarIndex . "Name" );
        $CalendarIndex++;
    }

    # get user data
    my %UserData = $Self->{TimeAccountingObject}->UserGet( UserID => $Param{UserID} );

    $Param{CalendarOption} = $Self->{LayoutObject}->BuildSelection(
        Data        => $CalendarListRef,
        Name        => 'Calendar',
        Translation => 1,
        SelectedID  => $GetParam{Calendar} || $UserData{Calendar} || 0,
    );

    $Param{Description} = $GetParam{Description} || $UserData{Description} || '';

    $Self->{LayoutObject}->Block(
        Name => 'OverviewUpdateUser',
        Data => {
            %Param,
            ShowOvertime => ( $GetParam{ShowOvertime} || $UserData{ShowOvertime} )
            ? 'checked="checked"' : '',
            CreateProject => ( $GetParam{CreateProject} || $UserData{CreateProject} )
            ? 'checked="checked"' : '',
            }
    );

    # shows header
    if ( $Param{Action} eq 'EditUser' ) {
        $Self->{LayoutObject}->Block( Name => 'HeaderEditUser' );
    }
    else {
        $Self->{LayoutObject}->Block(
            Name => 'HeaderAddUser',
            Data => \%Param,
        );
    }

    # if there are errors to show
    if ( $Param{Errors} && %{ $Param{Errors} } ) {

        # show all existing periods
        for ( my $Period = 1; $Period <= $Param{Periods}; $Period++ ) {

            for my $Parameter (qw(DateStart DateEnd LeaveDays WeeklyHours Overtime PeriodStatus )) {
                $GetParam{$Parameter}
                    = $Self->{ParamObject}->GetParam( Param => "$Parameter\[$Period\]" );
            }

            $Param{$Period}{PeriodStatusOption} = $Self->{LayoutObject}->BuildSelection(
                Data       => \%StatusList,
                SelectedID => $GetParam{PeriodStatus} || $Param{$Period}{PeriodStatus},
                Name       => "PeriodStatus[$Period]",
                ID         => "PeriodStatus-$Period",
            );

            $Self->{LayoutObject}->Block(
                Name => 'PeriodOverviewRow',
                Data => {
                    Period           => $Period,
                    DateStartInvalid => $Param{Errors}->{ 'DateStart-' . $Period . 'Invalid' }
                        || '',
                    DateEndInvalid => $Param{Errors}->{ 'DateEnd-' . $Period . 'Invalid' } || '',
                    LeaveDaysInvalid => $Param{Errors}->{ 'LeaveDays-' . $Period . 'Invalid' }
                        || '',
                    DateStart          => $GetParam{DateStart},
                    DateEnd            => $GetParam{DateEnd},
                    LeaveDays          => $GetParam{LeaveDays},
                    WeeklyHours        => $GetParam{WeeklyHours},
                    Overtime           => $GetParam{Overtime},
                    PeriodStatusOption => $Param{$Period}{PeriodStatusOption},
                },
            );

            $Self->{LayoutObject}->Block(
                Name => 'DateStart'
                    . (
                    $Param{Errors}->{ 'DateStart-' . $Period . 'ErrorType' }
                        || 'MissingValue'
                    ),
                Data => { Period => $Period },
            );
            $Self->{LayoutObject}->Block(
                Name => 'DateEnd'
                    . ( $Param{Errors}->{ 'DateEnd-' . $Period . 'ErrorType' } || 'MissingValue' ),
                Data => { Period => $Period },
            );
        }
    }
    else {
        my %User = $Self->{TimeAccountingObject}->SingleUserSettingsGet( UserID => $Param{UserID} );

        # show user data
        if (%User) {
            my $LastPeriodNumber
                = $Self->{TimeAccountingObject}
                ->UserLastPeriodNumberGet( UserID => $Param{UserID} );

            for ( my $Period = 1; $Period <= $LastPeriodNumber; $Period++ ) {
                my %PeriodParam = ();

                # get all needed data to display
                for my $Parameter (qw(DateStart DateEnd LeaveDays WeeklyHours Overtime)) {
                    $PeriodParam{$Parameter} = $User{$Period}{$Parameter};
                }
                $PeriodParam{Period} = $Period;

                $PeriodParam{PeriodStatusOption} = $Self->{LayoutObject}->BuildSelection(
                    Data       => \%StatusList,
                    SelectedID => $User{$Period}{UserStatus},
                    Name       => "PeriodStatus[$Period]",
                    ID         => "PeriodStatus-$Period",
                );

                $Self->{LayoutObject}->Block(
                    Name => 'PeriodOverviewRow',
                    Data => \%PeriodParam,
                );
            }
        }

        # show a no data found msg
        else {
            $Self->{LayoutObject}->Block( Name => 'PeriodOverviewRowNoData' );
        }
    }

    return 1;
}

1;
