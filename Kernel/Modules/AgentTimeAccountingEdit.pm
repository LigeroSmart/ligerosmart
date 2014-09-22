# --
# Kernel/Modules/AgentTimeAccountingEdit.pm - time accounting edit module
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTimeAccountingEdit;

use strict;
use warnings;

use Kernel::System::TimeAccounting;
use Kernel::System::CheckItem;
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
    $Self->{CheckItemObject}      = Kernel::System::CheckItem->new(%Param);

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
    # show confirmation dialog to delete the entry of this day
    # ---------------------------------------------------------- #
    if ( $Self->{ParamObject}->GetParam( Param => 'DeleteDialog' ) ) {

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

    # ---------------------------------------------------------- #
    # delete object from database
    # ---------------------------------------------------------- #
    if ( $Self->{Subaction} eq 'Delete' ) {
        for my $Parameter (qw(Day Month Year)) {
            $Param{$Parameter} = $Self->{ParamObject}->GetParam( Param => $Parameter );
        }

        return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' ) if !$Self->{AccessRo};

        if (
            !$Self->{TimeAccountingObject}->WorkingUnitsDelete(
                Year   => $Param{Year},
                Month  => $Param{Month},
                Day    => $Param{Day},
                UserID => $Self->{UserID},
            )
            )
        {

            return $Self->{LayoutObject}->ErrorScreen();
        }

        return $Self->{LayoutObject}->Redirect(
            OP =>
                "Action=$Self->{Action};Year=$Param{Year};Month=$Param{Month};Day=$Param{Day}"
        );
    }

    #---------------------------------------------------------- #
    # mass entry
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'MassEntry' ) {

        # permission check
        return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' ) if !$Self->{AccessRo};

        # get params
        for my $Parameter (qw(Dates LeaveDay Sick Overtime)) {
            $Param{$Parameter} = $Self->{ParamObject}->GetParam( Param => $Parameter ) || '';
        }

        # split up dates
        my @Dates = split /[|]/, $Param{Dates};
        my $InsertError = 0;

        # save entries in the db
        for my $Date (@Dates) {

            my ( $Year, $Month, $Day ) = split /[-]/, $Date;

            if (
                !$Self->{TimeAccountingObject}->WorkingUnitsInsert(
                    Year     => $Year,
                    Month    => $Month,
                    Day      => $Day,
                    LeaveDay => $Param{LeaveDay} || 0,
                    Sick     => $Param{Sick} || 0,
                    Overtime => $Param{Overtime} || 0,
                    UserID   => $Self->{UserID},
                )
                )
            {
                $InsertError = 1;
            }

        }

        # redirect to edit screen with log message
        return $Self->{LayoutObject}->Redirect(
            OP => 'Action=AgentTimeAccountingEdit;Notification='
                . ( $InsertError ? 'Error' : 'Successful' )
        );

    }

    # ---------------------------------------------------------- #
    # edit the time accounting elements
    # ---------------------------------------------------------- #

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
    for my $Parameter (qw(Status Year Month Day Notification)) {
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

    # check if the given date is a valid date
    # if not valid, set the date to today
    if ( !check_date( $Param{Year}, $Param{Month}, $Param{Day} ) ) {
        $Param{Year}        = $Year;
        $Param{Month}       = $Month;
        $Param{Day}         = $Day;
        $Param{'WrongDate'} = 1;
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

    my %IncompleteWorkingDays = $Self->{TimeAccountingObject}->WorkingUnitsCompletnessCheck(
        UserID => $Self->{UserID},
    );
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
                    "Action=AgentTimeAccountingView;Year=$Param{Year};Month=$Param{Month};Day=$Param{Day}"
            );
        }
    }

    # store last screen
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreen',
        Value =>
            "Action=$Self->{Action};Year=$Param{Year};Month=$Param{Month};Day=$Param{Day}",
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
            Year   => $Param{Year},
            Month  => $Param{Month},
            Day    => $Param{Day},
            UserID => $Self->{UserID},
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
            for my $Checkbox ( sort keys %CheckboxCheck ) {
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
                        UserID   => $Self->{UserID},
                    )
                    )
                {
                    return $Self->{LayoutObject}->ErrorScreen(
                        Message => 'Can\'t insert Working Units!'
                    );
                }
                $Param{SuccessfulInsert} = 1;
            }
        }

        ID:
        for my $ID ( 1 .. $Param{RecordsNumber} ) {

            # arrays to save the server errors block to show the error messages
            my ( @StartTimeServerErrorBlock, @EndTimeServerErrorBlock, @PeriodServerErrorBlock )
                = ();

            for my $Parameter (qw(ProjectID ActionID Remark StartTime EndTime Period)) {
                $Param{$Parameter}
                    = $Self->{ParamObject}->GetParam( Param => $Parameter . '[' . $ID . ']' );
                if ( $Param{$Parameter} ) {
                    my $ParamRef = \$Param{$Parameter};

                    # delete leading and tailing spaces
                    $ParamRef = $Self->{CheckItemObject}->StringClean(
                        StringRef => $ParamRef,
                        TrimLeft  => 1,
                        TrimRight => 1,
                    );
                }
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
            POSITION:
            for ( my $Position = $ID - 1; $Position >= 1; $Position-- ) {
                next POSITION if !defined $StartTimes[$Position] || !defined $StartTimes[$ID];

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

            # '24:00' is only permitted as end time
            if ( $StartTimes[$ID] && $StartTimes[$ID] == 1440 ) {
                $Errors{$ErrorIndex}{StartTimeInvalid} = 'ServerError';
                push @StartTimeServerErrorBlock, 'StartTime24Hours';
            }

            # times superior to 24:00 are not allowed
            if ( $StartTimes[$ID] && $StartTimes[$ID] > 1440 ) {
                $Errors{$ErrorIndex}{StartTimeInvalid} = 'ServerError';
                push @StartTimeServerErrorBlock, 'StartTimeInvalid';
            }
            if ( $EndTimes[$ID] && $EndTimes[$ID] > 1440 ) {
                $Errors{$ErrorIndex}{EndTimeInvalid} = 'ServerError';
                push @EndTimeServerErrorBlock, 'EndTimeInvalid';
            }

            # add reference to the server error messages to be shown
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

                # replace 24:00 for 23:59:59 to be a valid entry in the DB
                $Param{EndTime} = $Param{EndTime} eq '24:00' ? '23:59:59' : $Param{EndTime};

                my %WorkingUnit = (
                    ProjectID => $Param{ProjectID},
                    ActionID  => $Param{ActionID},
                    Remark    => $Param{Remark},
                    StartTime => $Param{StartTime},
                    EndTime   => $Param{EndTime},
                    Period    => $Period,
                );
                push @{ $Data{WorkingUnits} }, \%WorkingUnit;

                $Data{Year}   = $Param{Year};
                $Data{Month}  = $Param{Month};
                $Data{Day}    = $Param{Day};
                $Data{UserID} = $Self->{UserID};

                if ( !$Self->{TimeAccountingObject}->WorkingUnitsInsert(%Data) ) {

                    return $Self->{LayoutObject}->ErrorScreen(
                        Message => 'Can\'t insert Working Units!'
                    );
                }
                $Param{SuccessfulInsert} = 1;
            }

            # increment the error index if there was an error on this row
            $ErrorIndex++ if ( defined $Errors{$ErrorIndex} );
        }

        if (%ServerErrorData) {
            $Param{SuccessfulInsert} = undef;
        }
    }

    # Show Working Units
    # get existing working units
    %Data = $Self->{TimeAccountingObject}->WorkingUnitsGet(
        Year   => $Param{Year},
        Month  => $Param{Month},
        Day    => $Param{Day},
        UserID => $Self->{UserID},
    );

    # get number of working units (=records)
    #    if bigger than RecordsNumber, more than the number of default records were saved for
    #    this date
    if ( $Data{WorkingUnits} ) {
        my $WorkingUnitsCount = @{ $Data{WorkingUnits} };
        if ( $WorkingUnitsCount > $Param{RecordsNumber} ) {
            $Param{RecordsNumber} = $WorkingUnitsCount;
        }
    }

    if ( $Self->{ConfigObject}->Get('TimeAccounting::InputHoursWithoutStartEndTime') ) {
        $Param{PeriodBlock}   = 'UnitInputPeriod';
        $Frontend{PeriodNote} = '*';
    }
    else {
        $Param{PeriodBlock}   = 'UnitPeriodWithoutInput';
        $Frontend{PeriodNote} = '';
    }

    if (
        $Self->{TimeObject}->SystemTime()
        > timelocal( 1, 0, 0, $Param{Day}, $Param{Month} - 1, $Param{Year} - 1900 )
        )
    {
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
    for my $ActionID (@ActionIDs) {
        push @JSActions, "['$ActionID', '$ActionList{$ActionID}']";
    }
    $Param{JSActionList} = '[' . ( join ', ', @JSActions ) . ']';

    my $ActionListConstraints
        = $Self->{ConfigObject}->Get('TimeAccounting::ActionListConstraints');
    my @JSActionListConstraints;
    for my $ProjectNameRegExp ( sort keys %{$ActionListConstraints} ) {
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

        # action list initially only contains empty and selected element as well as elements
        #    configured for selected project
        #    if no constraints are configured, all actions will be displayed
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

            Data        => $ActionData,
            SelectedID  => $UnitRef->{ActionID} || $ServerErrorData{$ErrorIndex}{ActionID} || '',
            Name        => "ActionID[$ID]",
            ID          => "ActionID$ID",
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
                $Param{$TimePeriod} = $ServerErrorData{$ErrorIndex}{$TimePeriod} // '';
            }
            else {
                $Param{$TimePeriod} = $UnitRef->{$TimePeriod} // '';
            }
        }

        if (
            $Period
            && $Param{StartTime} eq '00:00'
            && $Param{EndTime} eq '00:00'
            )
        {
            $Param{StartTime} = '';
            $Param{EndTime}   = '';
        }

        $Self->{LayoutObject}->Block(
            Name => 'Unit',
            Data => {
                %Param,
                %Frontend,
                %{ $Errors{$ErrorIndex} },
            },
        );

        # add proper server error message for the start and end times
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

        # add proper server error message for the period
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
                Year   => $Param{Year},
                Month  => $Param{Month},
                Day    => $Param{Day},
                UserID => $Self->{UserID},
            )
            )
        {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => 'Can\'t delete Working Units!'
            );
        }
    }

    if ( $Param{BlockName} && $Param{SuccessfulInsert} ) {
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
        Validate => 1,
        Prefix   => '',
        Format   => 'DateInputFormat',
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
    %IncompleteWorkingDays = $Self->{TimeAccountingObject}->WorkingUnitsCompletnessCheck(
        UserID => $Self->{UserID},
    );

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

        # if mass entry option is enabled, show list of working days
        if ( $Self->{ConfigObject}->Get("TimeAccounting::AllowMassEntryForUser") ) {

            $Self->{LayoutObject}->Block(
                Name => 'IncompleteWorkingDaysMassEntry',
            );

            for my $WorkingDays ( sort keys %IncompleteWorkingDaysList ) {
                my ( $Year, $Month, $Day )
                    = split( /-/, $IncompleteWorkingDaysList{$WorkingDays} );
                $Self->{LayoutObject}->Block(
                    Name => 'IncompleteWorkingDaysMassEntrySingleDay',
                    Data => {
                        Date  => $IncompleteWorkingDaysList{$WorkingDays},
                        Year  => $Year,
                        Month => $Month,
                        Day   => $Day,
                    },
                );
            }

        }

        # otherwise show incomplete working days as a drop-down
        else {

            # check if current day is incomplete
            # if yes, select the current day in the drop-down
            # otherwise select the empty element
            my $SelectedID;

            if ( $IncompleteWorkingDaysList{"$Param{Year}-$Param{Month}-$Param{Day}"} ) {
                $SelectedID = "$Param{Year}-$Param{Month}-$Param{Day}";
            }

            my $IncompleWorkingDaysSelect = $Self->{LayoutObject}->BuildSelection(
                Data         => \%IncompleteWorkingDaysList,
                SelectedID   => $SelectedID,
                Name         => "IncompleteWorkingDaysList",
                PossibleNone => 1,
            );

            $Self->{LayoutObject}->Block(
                Name => 'IncompleteWorkingDays',
                Data => {
                    IncompleteWorkingDaysSelect => $IncompleWorkingDaysSelect,
                },
            );
        }
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

    # get working days of the user's calendar
    my $CalendarName = 'TimeWorkingHours';
    $CalendarName .= $UserData{Calendar} ? "::Calendar$UserData{Calendar}" : '';
    my $CalendarWorkingHours = $Self->{ConfigObject}->Get($CalendarName);

    # show "other times" block, if necessary
    if (
        @{ $CalendarWorkingHours->{ $WeekdayArray[ $Param{Weekday} - 1 ] } }
        && !$VacationCheck
        )
    {
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

    # enable auto-completion?
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
    elsif ( defined $Param{SuccessfulInsert} )
    {
        $Output .= $Self->{LayoutObject}->Notify( Info => 'Successful insert!', );
    }

    # show mass entry notification
    if ( $Param{Notification} eq 'Error' ) {
        $Output .= $Self->{LayoutObject}->Notify(
            Info     => 'Error while inserting multiple dates!',
            Priority => 'Error'
        );
    }
    elsif ( $Param{Notification} eq 'Successful' ) {
        $Output .= $Self->{LayoutObject}->Notify(
            Info => 'Successfully inserted entries for several dates!',
        );
    }

    # show notification if wrong date was selected
    if ( $Param{WrongDate} ) {
        $Output .= $Self->{LayoutObject}->Notify(
            Info     => 'Entered date was invalid! Date was changed to today.',
            Priority => 'Error'
        );
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

sub _FirstUserRedirect {
    my $Self = shift;

    # for initial using, the first agent with rw-right will be redirected
    # to 'Setting'. Then he can do the initial settings

    my %GroupList = $Self->{GroupObject}->GroupMemberList(
        UserID => $Self->{UserID},
        Type   => 'rw',
        Result => 'HASH',
    );
    for my $GroupKey ( sort keys %GroupList ) {
        if ( $GroupList{$GroupKey} eq 'time_accounting' ) {

            return $Self->{LayoutObject}->Redirect(
                OP => "Action=AgentTimeAccountingSetting"
            );
        }
    }

    return $Self->{LayoutObject}->ErrorScreen(
        Message => "No time period configured, or the specified date is outside of the defined "
            . "time periods. Please contact the time accounting admin to update your time periods!"
    );
}

sub _ActionList {
    my $Self = shift;

    my %ActionList;
    my %Action = $Self->{TimeAccountingObject}->ActionSettingsGet();

    # get action settings
    ACTIONID:
    for my $ActionID ( sort keys %Action ) {
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
            for my $ActionID ( sort keys %{ $Param{ActionList} } ) {

                my $ActionName = $Param{ActionList}->{$ActionID};

                REGEXP:
                for my $ProjectNameRegExp ( sort keys %{ $Param{ActionListConstraints} } ) {
                    my $ActionNameRegExp = $Param{ActionListConstraints}->{$ProjectNameRegExp};
                    if (
                        $ProjectName =~ m{$ProjectNameRegExp}smx
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
        for my $ActionID ( sort keys %{ $Param{ActionList} } ) {
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
        my @LastProjects = $Self->{TimeAccountingObject}->LastProjectsOfUser(
            UserID => $Self->{UserID},
        );

        # add the favorites
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

        # at the moment it is not possible mark the selected project
        # in the favorite list (I think a bug in Build selection?!)
    }

    # add the separator
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

sub _ProjectListConstraints {
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
        for my $ProjectRegex ( sort keys %{$ProjectListConstraints} ) {
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

    for my $ProjectID ( sort keys %{ $ProjectData{Project} } ) {
        if ( $ProjectData{Project}{$ProjectID} =~ m{$Project2RemarkRegExp}smx ) {
            push @Projects2Remark, $ProjectID;
        }
    }

    return join '|', @Projects2Remark;
}

1;
