# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AgentTimeAccountingEdit;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(IsArrayRefWithData);
use Kernel::Language qw(Translatable);

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

sub PreRun {
    my ( $Self, %Param ) = @_;

    # permission check
    return 1 if !$Self->{AccessRo};

    my $DateTimeObjectCurrent = $Kernel::OM->Create('Kernel::System::DateTime');
    my $TimeAccountingObject  = $Kernel::OM->Get('Kernel::System::TimeAccounting');

    my ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = $TimeAccountingObject->SystemTime2Date(
        SystemTime => $DateTimeObjectCurrent->ToEpoch(),
    );

    my %User = $TimeAccountingObject->UserCurrentPeriodGet(
        Year  => $Year,
        Month => $Month,
        Day   => $Day,
    );

    return if !$User{ $Self->{UserID} };

    my %IncompleteWorkingDays = $TimeAccountingObject->WorkingUnitsCompletnessCheck(
        UserID => $Self->{UserID},
    );

    # redirect if incomplete working day are out of range
    if (
        $IncompleteWorkingDays{EnforceInsert}
        && $Self->{Action} ne 'AgentTimeAccountingEdit'
        && $Self->{Action} !~ /AgentTimeAccounting/
        )
    {

        return $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Redirect(
            OP => 'Action=AgentTimeAccountingEdit',
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

    # get needed objects
    my $ParamObject           = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject          = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $TimeAccountingObject  = $Kernel::OM->Get('Kernel::System::TimeAccounting');
    my $DateTimeObjectCurrent = $Kernel::OM->Create('Kernel::System::DateTime');

    # ---------------------------------------------------------- #
    # show confirmation dialog to delete the entry of this day
    # ---------------------------------------------------------- #
    if ( $ParamObject->GetParam( Param => 'DeleteDialog' ) ) {

        my ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = $TimeAccountingObject->SystemTime2Date(
            SystemTime => $DateTimeObjectCurrent->ToEpoch(),
        );

        # get params
        for my $Parameter (qw(Status Year Month Day)) {
            $Param{$Parameter} = $ParamObject->GetParam( Param => $Parameter );
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

        my $Output = $LayoutObject->Output(
            Data         => {%Param},
            TemplateFile => 'AgentTimeAccountingDelete',
        );

        # build the returned data structure
        my %Data = (
            HTML       => $Output,
            DialogType => 'Confirmation',
        );

        # return JSON-String because of AJAX-Mode
        my $OutputJSON = $LayoutObject->JSONEncode(
            Data => \%Data,
        );

        return $LayoutObject->Attachment(
            ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
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
            $Param{$Parameter} = $ParamObject->GetParam( Param => $Parameter );
        }

        if ( !$Self->{AccessRo} ) {
            return $LayoutObject->NoPermission(
                WithHeader => 'yes',
            );
        }

        if (
            !$TimeAccountingObject->WorkingUnitsDelete(
                Year   => $Param{Year},
                Month  => $Param{Month},
                Day    => $Param{Day},
                UserID => $Self->{UserID},
            )
            )
        {

            return $LayoutObject->ErrorScreen();
        }

        return $LayoutObject->Redirect(
            OP =>
                "Action=$Self->{Action};Year=$Param{Year};Month=$Param{Month};Day=$Param{Day}",
        );
    }

    #---------------------------------------------------------- #
    # mass entry
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'MassEntry' ) {

        # permission check
        if ( !$Self->{AccessRo} ) {
            return $LayoutObject->NoPermission(
                WithHeader => 'yes',
            );
        }

        # get params
        for my $Parameter (qw(Dates LeaveDay Sick Overtime)) {
            $Param{$Parameter} = $ParamObject->GetParam( Param => $Parameter ) || '';
        }

        # split up dates
        my @Dates       = split /[|]/, $Param{Dates};
        my $InsertError = 0;

        # save entries in the db
        for my $Date (@Dates) {

            my ( $Year, $Month, $Day ) = split /[-]/, $Date;

            if (
                !$TimeAccountingObject->WorkingUnitsInsert(
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
        return $LayoutObject->Redirect(
            OP => 'Action=AgentTimeAccountingEdit;Notification='
                . ( $InsertError ? 'Error' : 'Successful' ),
        );

    }

    # ---------------------------------------------------------- #
    # edit the time accounting elements
    # ---------------------------------------------------------- #

    # permission check
    if ( !$Self->{AccessRo} ) {
        return $LayoutObject->NoPermission(
            WithHeader => 'yes',
        );
    }

    # get params
    for my $Parameter (qw(Status Year Month Day Notification)) {
        $Param{$Parameter} = $ParamObject->GetParam( Param => $Parameter ) || '';
    }
    $Param{RecordsNumber}      = $ParamObject->GetParam( Param => 'RecordsNumber' ) || 8;
    $Param{InsertWorkingUnits} = $ParamObject->GetParam( Param => 'InsertWorkingUnits' );

    my ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = $TimeAccountingObject->SystemTime2Date(
        SystemTime => $DateTimeObjectCurrent->ToEpoch(),
    );

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
    my $DateTimeValid = $DateTimeObjectCurrent->Validate(
        Year     => $Param{Year},
        Month    => $Param{Month},
        Day      => $Param{Day},
        Hour     => 0,
        Minute   => 0,
        Second   => 0,
        TimeZone => 'UTC',
    );

    if ( !$DateTimeValid ) {
        $Param{Year}        = $Year;
        $Param{Month}       = $Month;
        $Param{Day}         = $Day;
        $Param{'WrongDate'} = 1;
    }

    my %User = $TimeAccountingObject->UserCurrentPeriodGet(
        Year  => $Param{Year},
        Month => $Param{Month},
        Day   => $Param{Day},
    );

    # for initial use, the first agent with rw-right will be redirected
    # to 'Setting', so he can do the initial settings
    if ( !$User{ $Self->{UserID} } ) {
        return $Self->_FirstUserRedirect();
    }

    my %IncompleteWorkingDays = $TimeAccountingObject->WorkingUnitsCompletnessCheck(
        UserID => $Self->{UserID},
    );

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $MaxAllowedInsertDays = $ConfigObject->Get('TimeAccounting::MaxAllowedInsertDays') || '10';
    ( $Param{YearAllowed}, $Param{MonthAllowed}, $Param{DayAllowed} )
        = $TimeAccountingObject->AddDeltaYMD( $Year, $Month, $Day, 0, 0, -$MaxAllowedInsertDays );

    my $DateTimeObjectGiven = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            Year  => $Param{Year},
            Month => $Param{Month},
            Day   => $Param{Day},
        }
    );

    my $DateTimeObjectAllowed = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            Year  => $Param{YearAllowed},
            Month => $Param{MonthAllowed},
            Day   => $Param{DayAllowed},
        }
    );

    if ( $DateTimeObjectGiven->Compare( DateTimeObject => $DateTimeObjectAllowed ) < 0 ) {
        if ( !$IncompleteWorkingDays{Incomplete}{ $Param{Year} }{ $Param{Month} }{ $Param{Day} } ) {
            return $LayoutObject->Redirect(
                OP =>
                    "Action=AgentTimeAccountingView;Year=$Param{Year};Month=$Param{Month};Day=$Param{Day}",
            );
        }
    }

    # store last screen
    $Kernel::OM->Get('Kernel::System::AuthSession')->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreen',
        Value =>
            "Action=$Self->{Action};Year=$Param{Year};Month=$Param{Month};Day=$Param{Day}",
    );

    $Param{Month_to_Text} = $MonthArray[ $Param{Month} ];

    ( $Param{YearBack}, $Param{MonthBack}, $Param{DayBack} )
        = $TimeAccountingObject->AddDeltaYMD( $Param{Year}, $Param{Month}, $Param{Day}, 0, 0, -1 );
    ( $Param{YearNext}, $Param{MonthNext}, $Param{DayNext} )
        = $TimeAccountingObject->AddDeltaYMD( $Param{Year}, $Param{Month}, $Param{Day}, 0, 0, 1 );

    my $ReduceTimeRef = $ConfigObject->Get('TimeAccounting::ReduceTime');

    # hashes to store server side errors
    my %Errors          = ();
    my %ServerErrorData = ();
    my $ErrorIndex      = 1;

    my %Data;
    my %ActionList = $Self->_ActionList();

    # Edit Working Units
    if ( $Param{Status} ) {

        # arrays to save all start and end times for some checks
        my ( @StartTimes, @EndTimes );

        # delete previous entries for this day and user
        $TimeAccountingObject->WorkingUnitsDelete(
            Year   => $Param{Year},
            Month  => $Param{Month},
            Day    => $Param{Day},
            UserID => $Self->{UserID},
        );

        my %CheckboxCheck = ();
        for my $Element (qw(LeaveDay Sick Overtime)) {
            my $Value = $ParamObject->GetParam( Param => $Element );
            if ($Value) {
                $CheckboxCheck{$Element} = 1;
                $Param{$Element}         = 'checked="checked"';
            }
            else {
                $Param{$Element} = '';
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
                    !$TimeAccountingObject->WorkingUnitsInsert(
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
                    return $LayoutObject->ErrorScreen(
                        Message => Translatable('Can\'t insert Working Units!'),
                    );
                }
                $Param{SuccessfulInsert} = 1;
            }
        }

        # get check item object
        my $CheckItemObject = $Kernel::OM->Get('Kernel::System::CheckItem');

        ID:
        for my $ID ( 1 .. $Param{RecordsNumber} ) {

            # arrays to save the server errors block to show the error messages
            my ( @StartTimeServerErrorBlock, @EndTimeServerErrorBlock, @PeriodServerErrorBlock ) = ();

            for my $Parameter (qw(ProjectID ActionID Remark StartTime EndTime Period)) {
                $Param{$Parameter} = $ParamObject->GetParam( Param => $Parameter . '[' . $ID . ']' );
                if ( $Param{$Parameter} ) {
                    my $ParamRef = \$Param{$Parameter};

                    # delete leading and tailing spaces
                    $ParamRef = $CheckItemObject->StringClean(
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
                next POSITION if !defined $StartTimes[$Position];
                next POSITION if !defined $StartTimes[$ID];

                if (
                    $StartTimes[$Position] > $StartTimes[$ID]
                    && $StartTimes[$Position] < $EndTimes[$ID]
                    )
                {
                    $Errors{$ErrorIndex}{EndTimeInvalid} = 'ServerError';
                    if ( !grep {/^EndTimeRepeatedHourServerError/} @EndTimeServerErrorBlock ) {
                        push @EndTimeServerErrorBlock, 'EndTimeRepeatedHourServerError';
                    }
                }

                if (
                    $EndTimes[$Position] > $StartTimes[$ID]
                    && $EndTimes[$Position] < $EndTimes[$ID]
                    )
                {
                    if ( $EndTimes[$ID] > $EndTimes[$Position] ) {
                        $Errors{$ErrorIndex}{StartTimeInvalid} = 'ServerError';
                        if (
                            !grep {/^StartTimeRepeatedHourServerError$/}
                            @StartTimeServerErrorBlock
                            )
                        {
                            push @StartTimeServerErrorBlock, 'StartTimeRepeatedHourServerError';
                        }
                    }
                    else {
                        $Errors{$ErrorIndex}{EndTimeInvalid} = 'ServerError';
                        if ( !grep {/^EndTimeRepeatedHourServerError$/} @EndTimeServerErrorBlock ) {
                            push @EndTimeServerErrorBlock, 'EndTimeRepeatedHourServerError';
                        }
                    }
                }

                if ( $StartTimes[$Position] == $StartTimes[$ID] ) {
                    $Errors{$ErrorIndex}{StartTimeInvalid} = 'ServerError';
                    if ( !grep {/^StartTimeRepeatedHourServerError$/} @StartTimeServerErrorBlock ) {
                        push @StartTimeServerErrorBlock, 'StartTimeRepeatedHourServerError';
                    }
                }

                if ( $EndTimes[$Position] == $EndTimes[$ID] ) {
                    $Errors{$ErrorIndex}{EndTimeInvalid} = 'ServerError';
                    if ( !grep {/^EndTimeRepeatedHourServerError$/} @EndTimeServerErrorBlock ) {
                        push @EndTimeServerErrorBlock, 'EndTimeRepeatedHourServerError';
                    }
                }

                if (
                    $StartTimes[$ID] > $StartTimes[$Position]
                    && $StartTimes[$ID] < $EndTimes[$Position]
                    )
                {
                    $Errors{$ErrorIndex}{StartTimeInvalid} = 'ServerError';
                    if ( !grep {/^StartTimeRepeatedHourServerError$/} @StartTimeServerErrorBlock ) {
                        push @StartTimeServerErrorBlock, 'StartTimeRepeatedHourServerError';
                    }
                }

                if (
                    $EndTimes[$ID] > $StartTimes[$Position]
                    && $EndTimes[$ID] < $EndTimes[$Position]
                    )
                {
                    $Errors{$ErrorIndex}{EndTimeInvalid} = 'ServerError';
                    if ( !grep {/^EndTimeRepeatedHourServerError$/} @EndTimeServerErrorBlock ) {
                        push @EndTimeServerErrorBlock, 'EndTimeRepeatedHourServerError';
                    }
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
                    $ConfigObject->Get('TimeAccounting::InputHoursWithoutStartEndTime')
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

                if ( !$TimeAccountingObject->WorkingUnitsInsert(%Data) ) {

                    return $LayoutObject->ErrorScreen(
                        Message => Translatable('Can\'t insert Working Units!'),
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
    %Data = $TimeAccountingObject->WorkingUnitsGet(
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

    my %Frontend;

    if ( $ConfigObject->Get('TimeAccounting::InputHoursWithoutStartEndTime') ) {
        $Param{PeriodBlock}   = 'UnitInputPeriod';
        $Frontend{PeriodNote} = '*';
    }
    else {
        $Param{PeriodBlock}   = 'UnitPeriodWithoutInput';
        $Frontend{PeriodNote} = '';
    }

    if ( $DateTimeObjectCurrent->Compare( DateTimeObject => $DateTimeObjectGiven ) ) {
        $LayoutObject->Block(
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
        push @JSActions, [
            $ActionID,
            $ActionList{$ActionID}
        ];
    }

    $LayoutObject->AddJSData(
        Key   => 'ActionList',
        Value => \@JSActions
    );

    my $ActionListConstraints = $ConfigObject->Get('TimeAccounting::ActionListConstraints');
    my @JSActionListConstraints;
    for my $ProjectNameRegExp ( sort keys %{$ActionListConstraints} ) {
        my $ActionNameRegExp = $ActionListConstraints->{$ProjectNameRegExp};
        s{(['"\\])}{\\$1}smxg for ( $ProjectNameRegExp, $ActionNameRegExp );
        push @JSActionListConstraints, [
            $ProjectNameRegExp,
            $ActionNameRegExp
        ];
    }

    $LayoutObject->AddJSData(
        Key   => 'ActionListConstraints',
        Value => \@JSActionListConstraints
    );

    # build a working unit array
    my @Units = (undef);
    if ( $Data{WorkingUnits} ) {
        push @Units, @{ $Data{WorkingUnits} };
    }

    $ErrorIndex = 0;

    # build units
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

        $Param{ProjectID} = $UnitRef->{ProjectID}
            || $ServerErrorData{$ErrorIndex}{ProjectID}
            || '';
        $Param{ProjectName} = '';

        # set common params for project selection
        my %ProjectOptionParams = (
            Name        => "ProjectID[$ID]",
            ID          => "ProjectID$ID",
            Translation => 0,
            Class       => 'Validate_TimeAccounting_Project ProjectSelection '
                . ( $Errors{$ErrorIndex}{ProjectIDInvalid} || '' ),
            OnChange => "TimeAccounting.Agent.EditTimeRecords.FillActionList($ID);",
            Title    => $LayoutObject->{LanguageObject}->Translate("Project"),
        );

        my $EnableAutoCompletion = $ConfigObject->Get("TimeAccounting::EnableAutoCompletion") || 0;
        my $Class                = $EnableAutoCompletion ? ' Modernize' : '';

        # set params for modern inputs
        $ProjectOptionParams{Class} .= $Class;

        if ( $EnableAutoCompletion && $ConfigObject->Get("TimeAccounting::UseFilter") ) {

            # add filter for the previous projects
            $ProjectOptionParams{Data}    = $ProjectList->{AllProjects};
            $ProjectOptionParams{Filters} = {
                LastProjects => {
                    Name   => $LayoutObject->{LanguageObject}->Translate('Last Projects'),
                    Values => $ProjectList->{LastProjects},
                },
            };

            # if there are the previous projects, expand filter dialog
            if ( scalar @{ $ProjectList->{LastProjects} } > 1 ) {
                $ProjectOptionParams{ExpandFilters} = 1;

                # make the filter active by default if 'ActiveFilter' is enabled
                if ( $ConfigObject->Get("TimeAccounting::ActiveFilter") ) {
                    $ProjectOptionParams{Filters}->{LastProjects}->{Active} = 1;
                }
            }
        }
        else {
            # set params for traditional selects (and modern input fields if filter is not used)
            my @Projects = ( @{ $ProjectList->{LastProjects} }, @{ $ProjectList->{AllProjects} } );
            $ProjectOptionParams{Data} = \@Projects;
        }

        # build projects select
        $Frontend{ProjectOption} = $LayoutObject->BuildSelection(
            %ProjectOptionParams,
        );

        # action list initially only contains empty and selected element as well as elements
        # configured for selected project
        # if no constraints are configured, all actions will be displayed
        my $ActionData = $Self->_ActionListConstraints(
            ProjectID             => $UnitRef->{ProjectID} || $ServerErrorData{$ErrorIndex}->{ProjectID},
            ProjectList           => $ProjectList,
            ActionList            => \%ActionList,
            ActionListConstraints => $ActionListConstraints,
        );
        $ActionData->{''} = '-';

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

        $Frontend{ActionOption} = $LayoutObject->BuildSelection(

            Data        => $ActionData,
            SelectedID  => $UnitRef->{ActionID} || $ServerErrorData{$ErrorIndex}{ActionID} || '',
            Name        => "ActionID[$ID]",
            ID          => "ActionID$ID",
            Translation => 0,
            Class       => 'Validate_DependingRequiredAND Validate_Depending_ProjectID'
                . $ID
                . ' ActionSelection '
                . ( $Errors{$ErrorIndex}{ActionIDInvalid} || '' )
                . $Class,
            Title => $LayoutObject->{LanguageObject}->Translate("Task"),
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

        $LayoutObject->Block(
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
                    $ServerErrorBlockName = shift @{ $Errors{$ErrorIndex}{StartTimeServerErrorBlock} };
                    $LayoutObject->Block(
                        Name => $ServerErrorBlockName,
                        Data => {},
                    );
                }
            }
            else {
                $LayoutObject->Block(
                    Name => 'StartTimeGenericServerError',
                    Data => {},
                );
            }
        }
        if ( $Errors{$ErrorIndex} && $Errors{$ErrorIndex}{EndTimeInvalid} ) {
            if ( scalar @{ $Errors{$ErrorIndex}{EndTimeServerErrorBlock} } > 0 ) {
                while ( @{ $Errors{$ErrorIndex}{EndTimeServerErrorBlock} } ) {
                    $ServerErrorBlockName = shift @{ $Errors{$ErrorIndex}{EndTimeServerErrorBlock} };
                    $LayoutObject->Block(
                        Name => $ServerErrorBlockName,
                        Data => {}
                    );
                }
            }
            else {
                $LayoutObject->Block(
                    Name => 'EndTimeGenericServerError',
                    Data => {},
                );
            }
        }

        $LayoutObject->Block(
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
                    $ServerErrorBlockName = shift @{ $Errors{$ErrorIndex}{PeriodServerErrorBlock} };
                    $LayoutObject->Block(
                        Name => $ServerErrorBlockName,
                        Data => {},
                    );
                }
            }
            else {
                $LayoutObject->Block(
                    Name => 'PeriodGenericServerError',
                    Data => {},
                );
            }
        }
        else {
            $LayoutObject->Block(
                Name => 'PeriodGenericServerError',
                Data => {},
            );
        }

        # validity check
        if (
            $Param{InsertWorkingUnits}
            && $UnitRef->{ProjectID}
            && $UnitRef->{ActionID}
            && $Param{Sick}
            )
        {
            $Param{BlockName} = $LayoutObject->{LanguageObject}
                ->Translate('Are you sure that you worked while you were on sick leave?');
        }
        elsif (
            $Param{InsertWorkingUnits}
            && $UnitRef->{ProjectID}
            && $UnitRef->{ActionID}
            && $Param{LeaveDay}
            )
        {
            $Param{BlockName} = $LayoutObject->{LanguageObject}
                ->Translate('Are you sure that you worked while you were on vacation?');
        }
        elsif (
            $Param{InsertWorkingUnits}
            && $UnitRef->{ProjectID}
            && $UnitRef->{ActionID}
            && $Param{Overtime}
            )
        {
            $Param{BlockName} = $LayoutObject->{LanguageObject}
                ->Translate('Are you sure that you worked while you were on overtime leave?');
        }
    }

    if ( $DateTimeObjectCurrent->Compare( DateTimeObject => $DateTimeObjectGiven ) ) {
        $Param{Total} = sprintf( "%.2f", ( $Param{Total} || 0 ) );
        $LayoutObject->Block(
            Name => 'Total',
            Data => { %Param, %Frontend },
        );
    }

    # validity checks start
    my $ErrorNote;
    if ( $Param{Total} && $Param{Total} > 24 ) {
        $ErrorNote = Translatable('Can\'t save settings, because a day has only 24 hours!');
    }
    elsif ( $Param{InsertWorkingUnits} && $Param{Total} && $Param{Total} > 16 ) {
        $Param{BlockName}
            = $LayoutObject->{LanguageObject}->Translate('Are you sure that you worked more than 16 hours?');
    }
    if ($ErrorNote) {
        if (
            !$TimeAccountingObject->WorkingUnitsDelete(
                Year   => $Param{Year},
                Month  => $Param{Month},
                Day    => $Param{Day},
                UserID => $Self->{UserID},
            )
            )
        {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('Can\'t delete Working Units!'),
            );
        }
    }

    if ( $Param{BlockName} && $Param{SuccessfulInsert} ) {
        $LayoutObject->AddJSData(
            Key   => 'BlockName',
            Value => $Param{BlockName},
        );
    }

    $Param{Date} = $LayoutObject->BuildDateSelection(
        %Param,
        Validate => 1,
        Prefix   => '',
        Format   => 'DateInputFormat',
    );

    if ( $DateTimeObjectGiven->Compare( DateTimeObject => $DateTimeObjectAllowed ) < 0 ) {
        if (
            $IncompleteWorkingDays{Incomplete}{ $Param{Year} }{ $Param{Month} }{ $Param{Day} }
            && !$Param{SuccessfulInsert}
            )
        {
            $LayoutObject->Block(
                Name => 'Readonly',
                Data => {
                    Description =>
                        Translatable(
                        'This Date is out of limit, but you haven\'t insert this day yet, so you get one(!) chance to insert'
                        ),
                },
            );
        }
    }

    # get incomplete working days
    my %IncompleteWorkingDaysList;
    %IncompleteWorkingDays = $TimeAccountingObject->WorkingUnitsCompletnessCheck(
        UserID => $Self->{UserID},
    );

    for my $YearID ( sort keys %{ $IncompleteWorkingDays{Incomplete} } ) {
        for my $MonthID ( sort keys %{ $IncompleteWorkingDays{Incomplete}{$YearID} } ) {
            for my $DayID (
                sort keys %{ $IncompleteWorkingDays{Incomplete}{$YearID}{$MonthID} }
                )
            {
                $IncompleteWorkingDaysList{"$YearID-$MonthID-$DayID"} = "$YearID-$MonthID-$DayID";
                $Param{Incomplete}                                    = 1;
            }
        }
    }

    # Show text, if incomplete working days are available
    if ( $Param{Incomplete} ) {

        # if mass entry option is enabled, show list of working days
        if ( $ConfigObject->Get("TimeAccounting::AllowMassEntryForUser") ) {

            $LayoutObject->Block(
                Name => 'IncompleteWorkingDaysMassEntry',
            );

            for my $WorkingDays ( sort keys %IncompleteWorkingDaysList ) {

                my ( $Year, $Month, $Day ) = split( /-/, $IncompleteWorkingDaysList{$WorkingDays} );
                my $DateTimeObjectWorkingDay = $Kernel::OM->Create(
                    'Kernel::System::DateTime',
                    ObjectParams => {
                        Year  => $Year,
                        Month => $Month,
                        Day   => $Day,
                    }
                );

                $LayoutObject->Block(
                    Name => 'IncompleteWorkingDaysMassEntrySingleDay',
                    Data => {
                        Date    => $IncompleteWorkingDaysList{$WorkingDays},
                        DateHR  => $DateTimeObjectWorkingDay->ToString(),
                        Weekday => $TimeAccountingObject->DayOfWeekToName(
                            Number => $TimeAccountingObject->DayOfWeek( $Year, $Month, $Day )
                        ),
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

            my $IncompleWorkingDaysSelect = $LayoutObject->BuildSelection(
                Data         => \%IncompleteWorkingDaysList,
                SelectedID   => $SelectedID,
                Name         => "IncompleteWorkingDaysList",
                PossibleNone => 1,
                Title =>
                    $LayoutObject->{LanguageObject}->Translate("Incomplete Working Days"),
                Class => 'Modernize',
            );

            $LayoutObject->Block(
                Name => 'IncompleteWorkingDays',
                Data => {
                    IncompleteWorkingDaysSelect => $IncompleWorkingDaysSelect,
                },
            );
        }
    }

    my %UserData = $TimeAccountingObject->UserGet(
        UserID => $Self->{UserID},
    );

    my $VacationCheck = $TimeAccountingObject->VacationCheck(
        Year     => $Param{Year},
        Month    => $Param{Month},
        Day      => $Param{Day},
        Calendar => $UserData{Calendar},
    );

    $Param{Weekday}
        = $Kernel::OM->Get('Kernel::System::TimeAccounting')->DayOfWeek( $Param{Year}, $Param{Month}, $Param{Day} );

    # get working days of the user's calendar
    my $CalendarName = 'TimeWorkingHours';
    $CalendarName .= $UserData{Calendar} ? "::Calendar$UserData{Calendar}" : '';
    my $CalendarWorkingHours = $ConfigObject->Get($CalendarName);

    # show "other times" block, if necessary
    if (
        IsArrayRefWithData( $CalendarWorkingHours->{ $WeekdayArray[ $Param{Weekday} - 1 ] } )
        && !$VacationCheck
        )
    {
        $LayoutObject->Block(
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
    $LayoutObject->AddJSData(
        Key   => 'RemarkRegExp',
        Value => $Param{RemarkRegExp},
    );

    # build output
    my $Output = $LayoutObject->Header(
        Title => 'Edit',
    );

    $Output .= $LayoutObject->NavigationBar();
    $LayoutObject->Block(
        Name => 'OverviewProject',
        Data => { %Param, %Frontend },
    );

    if ( !$IncompleteWorkingDays{EnforceInsert} ) {

        # show create project link, if allowed
        my %UserData = $TimeAccountingObject->UserGet(
            UserID => $Self->{UserID},
        );
        if ( $UserData{CreateProject} ) {
            $LayoutObject->Block(
                Name => 'CreateProject',
            );
        }
    }

    if ($ErrorNote) {
        $Output .= $LayoutObject->Notify(
            Info     => $ErrorNote,
            Priority => 'Error',
        );
    }
    elsif ( defined $Param{SuccessfulInsert} )
    {
        $Output .= $LayoutObject->Notify(
            Info => Translatable('Successful insert!'),
        );
    }

    # show mass entry notification
    if ( $Param{Notification} eq 'Error' ) {
        $Output .= $LayoutObject->Notify(
            Info     => Translatable('Error while inserting multiple dates!'),
            Priority => 'Error',
        );
    }
    elsif ( $Param{Notification} eq 'Successful' ) {
        $Output .= $LayoutObject->Notify(
            Info => Translatable('Successfully inserted entries for several dates!'),
        );
    }

    # show notification if wrong date was selected
    if ( $Param{WrongDate} ) {
        $Output .= $LayoutObject->Notify(
            Info     => Translatable('Entered date was invalid! Date was changed to today.'),
            Priority => 'Error',
        );
    }

    $LayoutObject->AddJSData(
        Key   => 'Year',
        Value => $Param{Year},
    );
    $LayoutObject->AddJSData(
        Key   => 'Month',
        Value => $Param{Month},
    );
    $LayoutObject->AddJSData(
        Key   => 'Day',
        Value => $Param{Day},
    );

    $Output .= $LayoutObject->Output(
        TemplateFile => 'AgentTimeAccountingEdit',
        Data         => {
            %Param,
            %Frontend,
        },
    );
    $Output .= $LayoutObject->Footer();
    return $Output;

}

sub _FirstUserRedirect {
    my $Self = shift;

    # For initial usage, the first agent with 'rw' rights will be redirected to 'Setting'. Then they can configure
    #   initial settings for the time accounting feature.

    # Define action and get its frontend module registration.
    my $Action = 'AgentTimeAccountingSetting';
    my $Config = $Kernel::OM->Get('Kernel::Config')->Get('Frontend::Module')->{$Action};

    # Get group names from config.
    my @GroupNames = @{ $Config->{Group} || [] };

    my $Permission = 0;

    # If access is restricted, allow access only if user has appropriate permissions in configured group(s).
    if (@GroupNames) {

        my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

        # Get user groups, where the user has the appropriate permissions.
        my %Groups = $GroupObject->GroupMemberList(
            UserID => $Self->{UserID},
            Type   => 'rw',
            Result => 'HASH',
        );

        GROUP:
        for my $GroupName (@GroupNames) {
            next GROUP if !$GroupName;

            # Get the group ID.
            my $GroupID = $GroupObject->GroupLookup(
                Group => $GroupName,
            );
            next GROUP if !$GroupID;

            # Stop checking if membership in at least one group is found.
            if ( $Groups{$GroupID} ) {
                $Permission = 1;
                last GROUP;
            }
        }
    }

    # Otherwise, always allow access.
    else {
        $Permission = 1;
    }

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    return $LayoutObject->Redirect( OP => "Action=$Action" ) if $Permission;

    return $LayoutObject->ErrorScreen(
        Message =>
            Translatable('No time period configured, or the specified date is outside of the defined time periods.'),
        Comment => Translatable('Please contact the time accounting administrator to update your time periods!'),
    );
}

sub _ActionList {
    my $Self = shift;

    my %ActionList;
    my %Action = $Kernel::OM->Get('Kernel::System::TimeAccounting')->ActionSettingsGet();

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
        for my $Project ( @{ $Param{ProjectList}->{AllProjects} } ) {
            if ( $Project->{Key} eq $Param{ProjectID} ) {
                $ProjectName = $Project->{Value};
                last PROJECT;
            }
        }

        if ( defined($ProjectName) ) {

            # loop over actions to find matches for configured project
            # and action reg-exp pairs
            for my $ActionID ( sort keys %{ $Param{ActionList} } ) {

                my $ActionName = $Param{ActionList}->{$ActionID};

                PROJECTNAMEREGEXP:
                for my $ProjectNameRegExp ( sort keys %{ $Param{ActionListConstraints} } ) {
                    my $ActionNameRegExp = $Param{ActionListConstraints}->{$ProjectNameRegExp};
                    if (
                        $ProjectName   =~ m{$ProjectNameRegExp}smx
                        && $ActionName =~ m{$ActionNameRegExp}smx
                        )
                    {
                        $List{$ActionID} = $ActionName;
                        last PROJECTNAMEREGEXP;
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

    # get time accounting object
    my $TimeAccountingObject = $Kernel::OM->Get('Kernel::System::TimeAccounting');

    # get project settings
    my %Project = $TimeAccountingObject->ProjectSettingsGet(
        Status => 'valid',
    );

    if ( !$Self->{LastProjectsRef} ) {

        # get the last projects
        my @LastProjects = $TimeAccountingObject->LastProjectsOfUser(
            UserID => $Self->{UserID},
        );

        # add the favorites
        %{ $Self->{LastProjectsRef} } = map { $_ => 1 } @LastProjects;
    }

    my @LastProjects = (
        {
            Key   => '',
            Value => '-',
        },
    );

    # add the separator
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
        push @LastProjects, \%Hash;
    }

    @LastProjects = $Self->_ProjectListConstraints(
        List       => \@LastProjects,
        SelectedID => $Param{SelectedID} || '',
    );

    my @AllProjects;
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # check if AutoCompletion is disabled
    # in this case a separator is needed between two lists of projects (last and all)
    if (
        !$ConfigObject->Get("TimeAccounting::EnableAutoCompletion")
        || !$ConfigObject->Get("TimeAccounting::UseFilter")
        )
    {
        if ( scalar @LastProjects > 1 ) {

            my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

            # add last projects separator to the beginning of the list
            my $LastProjectsStr = $LayoutObject->{LanguageObject}->Translate('Last Selected Projects');

            unshift @LastProjects, {
                Key      => '0',
                Value    => "---$LastProjectsStr---",
                Disabled => 1,
            };

            # add all projects separator right after the last selected projects list
            my $AllProjectsStr = $LayoutObject->{LanguageObject}->Translate('All Projects');

            push @LastProjects, {
                Key      => '0',
                Value    => "---$AllProjectsStr---",
                Disabled => 1,
            };
        }
    }
    else {
        @AllProjects = (
            {
                Key   => '',
                Value => '-',
            },
        );
    }

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

        push @AllProjects, \%Hash;
    }

    @AllProjects = $Self->_ProjectListConstraints(
        List       => \@AllProjects,
        SelectedID => $Param{SelectedID} || '',
    );

    my %Projects = (
        LastProjects => \@LastProjects,
        AllProjects  => \@AllProjects,
    );

    return \%Projects;
}

sub _ProjectListConstraints {
    my ( $Self, %Param ) = @_;

    my @List;
    my $ProjectCount           = 0;
    my $ProjectListConstraints = $Kernel::OM->Get('Kernel::Config')->Get('TimeAccounting::ProjectListConstraints');

    if ( keys %{$ProjectListConstraints} ) {

        # get groups of current user
        my %Groups = $Kernel::OM->Get('Kernel::System::Group')->GroupMemberList(
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

    # get full project list if constraints resulted in empty project list or if constraints aren't
    # configured (possible misconfiguration)
    if ( !$ProjectCount ) {
        @List = @{ $Param{List} };
    }

    return @List;
}

# integrate the handling for required remarks in relation to projects

sub _Project2RemarkRegExp {
    my $Self = shift;

    my @Projects2Remark = ();
    my %ProjectData     = $Kernel::OM->Get('Kernel::System::TimeAccounting')->ProjectSettingsGet(
        Status => 'valid',
    );

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    return '' if !$ConfigObject->Get('TimeAccounting::Project2RemarkRegExp');

    my $Project2RemarkRegExp = $ConfigObject->Get('TimeAccounting::Project2RemarkRegExp');

    for my $ProjectID ( sort keys %{ $ProjectData{Project} } ) {
        if ( $ProjectData{Project}{$ProjectID} =~ m{$Project2RemarkRegExp}smx ) {
            push @Projects2Remark, $ProjectID;
        }
    }

    return join '|', @Projects2Remark;
}

1;
