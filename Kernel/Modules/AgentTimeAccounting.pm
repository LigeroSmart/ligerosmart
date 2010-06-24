# --
# Kernel/Modules/AgentTimeAccounting.pm - time accounting module
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: AgentTimeAccounting.pm,v 1.39 2010-06-24 12:35:58 jp Exp $
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
$VERSION = qw($Revision: 1.39 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed Objects
    for (
        qw(ParamObject DBObject ModuleReg LogObject UserObject
        ConfigObject TicketObject TimeObject GroupObject)
        )
    {
        $Self->{LayoutObject}->FatalError( Message => "Got no $_!" ) if !$Self->{$_};
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
            OP => 'Action=AgentTimeAccounting&Subaction=Edit'
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
    # delete the time accounting elements of one day
    # ---------------------------------------------------------- #
    if ( $Self->{ParamObject}->GetParam( Param => 'Delete' ) ) {
        my ( $Sec, $Min, $Hour, $Day, $Month, $Year )
            = $Self->{TimeObject}->SystemTime2Date(
            SystemTime => $Self->{TimeObject}->SystemTime(),
            );

        # get params
        for (qw(Status Year Month Day)) {
            $Param{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
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

        my $Output = $Self->{LayoutObject}->Header( Title => 'Delete' );
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            Data         => \%Param,
            TemplateFile => 'AgentTimeAccountingDelete'
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
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
        for (qw(Status Year Month Day)) {
            $Param{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
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

        my %User = $Self->{TimeAccountingObject}->UserCurrentPeriodGet(
            Year  => $Param{Year},
            Month => $Param{Month},
            Day   => $Param{Day},
        );

        # for initial useing, the first agent with rw-right will be redirected
        # to 'Setting'. Then he can do the initial settings
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
                        "Action=$Self->{Action}&Subaction=View&Year=$Param{Year}&Month=$Param{Month}&Day=$Param{Day}"
                );
            }
        }

        # store last screen
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'LastScreen',
            Value =>
                "Action=$Self->{Action}&Subaction=Edit&Year=$Param{Year}&Month=$Param{Month}&Day=$Param{Day}",
        );

        $Param{Month_to_Text} = $MonthArray[ $Param{Month} ];

        ( $Param{YearBack}, $Param{MonthBack}, $Param{DayBack} )
            = Add_Delta_YMD( $Param{Year}, $Param{Month}, $Param{Day}, 0, 0, -1 );
        ( $Param{YearNext}, $Param{MonthNext}, $Param{DayNext} )
            = Add_Delta_YMD( $Param{Year}, $Param{Month}, $Param{Day}, 0, 0, 1 );

        my $ReduceTimeRef = $Self->{ConfigObject}->Get('TimeAccounting::ReduceTime');

        # Edit Working Units
        if ( $Param{Status} ) {

            ID:
            for my $ID ( 1 .. 16 ) {
                for (qw(ProjectID ActionID Remark StartTime EndTime Period)) {
                    $Param{$_} = $Self->{ParamObject}->GetParam( Param => $_ . '[' . $ID . ']' );
                }

                next ID if !$Param{ProjectID} && !$Param{ActionID};

                # create a valid period
                my $Period = $Param{Period};
                if ( $Period =~ /^(\d+),(\d+)/ ) {
                    $Period = $1 . "." . $2;
                }

                #allow format hh:mm
                elsif ( $Param{Period} =~ /^(\d+):(\d+)/ ) {
                    $Period = $1 + $2 / 60;
                }

                my %WorkingUnit = (
                    ProjectID => $Param{ProjectID},
                    ActionID  => $Param{ActionID},
                    Remark    => $Param{Remark},
                    StartTime => $Param{StartTime},
                    EndTime   => $Param{EndTime},
                    Period    => $Period,
                );

                push @{ $Data{WorkingUnits} }, \%WorkingUnit;

                #if ($Param{StartTime} && $Param{EndTime} && !$Param{Period}) {
                #overwrite Period when Start and Endtime is given...
                next ID if !$Param{StartTime} || !$Param{EndTime};

                if ( $Param{StartTime} =~ /^(\d+):(\d+)/ ) {
                    my $StartTime = $1 * 60 + $2;
                    if ( $Param{EndTime} =~ /^(\d+):(\d+)/ ) {
                        my $EndTime = $1 * 60 + $2;
                        if ( $ReduceTimeRef->{ $ActionList{ $Param{ActionID} } } ) {
                            $WorkingUnit{Period} = ( $EndTime - $StartTime ) / 60
                                * $ReduceTimeRef->{ $ActionList{ $Param{ActionID} } } / 100;
                        }
                        else {
                            $WorkingUnit{Period} = ( $EndTime - $StartTime ) / 60;
                        }
                    }
                }
            }

            my $CheckboxCheck = 0;
            for my $Element (qw(LeaveDay Sick Overtime)) {
                my $Value = $Self->{ParamObject}->GetParam( Param => $Element );
                if ($Value) {
                    $Data{$Element} = 1;
                    $CheckboxCheck++;
                }
            }
            if ( $CheckboxCheck > 1 ) {
                $Param{RequiredDescription} = 'You can only select one checkbox element!';
            }

            $Data{Year}  = $Param{Year};
            $Data{Month} = $Param{Month};
            $Data{Day}   = $Param{Day};

            if ( !$Self->{TimeAccountingObject}->WorkingUnitsInsert(%Data) ) {
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => 'Can\'t insert Working Units!'
                );
            }

            $Param{SuccessfulInsert} = 1;
        }

        # Show Working Units
        # get existing working units
        %Data = $Self->{TimeAccountingObject}->WorkingUnitsGet(
            Year  => $Param{Year},
            Month => $Param{Month},
            Day   => $Param{Day},
        );

        if ( $Self->{ConfigObject}->Get('TimeAccounting::InputHoursWithoutStartEndTime') ) {
            $Param{TextPosition}  = 'left';
            $Param{PeriodBlock}   = 'UnitInputPeriod';
            $Frontend{ClassTime}  = 'footnote';
            $Frontend{PeriodNote} = '*';
            $Self->{LayoutObject}->Block(
                Name => 'FootNote',
                Data => { %Param, %Frontend },
            );
        }
        else {
            $Param{TextPosition}  = 'right';
            $Param{PeriodBlock}   = 'UnitPeriodWithoutInput';
            $Frontend{ClassTime}  = 'required';
            $Frontend{PeriodNote} = '';
        }

        if ( time() > timelocal( 1, 0, 0, $Param{Day}, $Param{Month} - 1, $Param{Year} - 1900 ) ) {
            $Self->{LayoutObject}->Block(
                Name => 'UnitBlock',
                Data => { %Param, %Frontend },
            );
        }

        # get sick, leave day and overtime
        $Param{Sick}     = $Data{Sick}     ? 'checked' : '';
        $Param{LeaveDay} = $Data{LeaveDay} ? 'checked' : '';
        $Param{Overtime} = $Data{Overtime} ? 'checked' : '';

        $Param{Total} = $Data{Total};

        # set action list and related constraints
        $Param{JSActionList} = '['
            . (
            join ', ',
            map      {"['${_}', '$ActionList{$_}']"}
                sort { $ActionList{$a} cmp $ActionList{$b} } keys(%ActionList)
            ) . ']';

        my $ActionListConstraints
            = $Self->{ConfigObject}->Get('TimeAccounting::ActionListConstraints');
        my @JSActionListConstraints;
        for my $ProjectNameRegExp ( keys( %{$ActionListConstraints} ) ) {
            my $ActionNameRegExp = $ActionListConstraints->{$ProjectNameRegExp};
            for ( $ProjectNameRegExp, $ActionNameRegExp ) {
                $_ =~ s{(['"\\])}{\\$1}smxg;
            }
            push @JSActionListConstraints, "['$ProjectNameRegExp', '$ActionNameRegExp']";
        }
        $Param{JSActionListConstraints} = '[' . ( join ', ', @JSActionListConstraints ) . ']';

        # build a working unit array
        my @Units = (undef);
        if ( $Data{WorkingUnits} ) {
            push @Units, @{ $Data{WorkingUnits} }
        }

        my $ShowAllInputFields = scalar @Units > 9 ? 1 : 0;

        # build units
        $Param{"JSProjectList"} = "var JSProjectList = new Array();\n";
        for my $ID ( 1 .. 16 ) {
            $Param{ID} = $ID;
            my $UnitRef = $Units[$ID];

            # get data of projects
            my $ProjectList = $Self->_ProjectList(
                SelectedID => $UnitRef->{ProjectID},
            );

            $Param{ProjectID} = $UnitRef->{ProjectID} || '';
            $Param{ProjectName} = '';

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

            # ProjectOption will not be used any more when project autocompletion is done
            $Frontend{ProjectOption} = $Self->{LayoutObject}->BuildSelection(
                Data        => $ProjectList,
                Name        => "ProjectID[$ID]",
                Translation => 0,

                #Max        => 62,
                Class    => 'ProjectSelection',
                OnChange => "FillActionList($ID);",
            );

# action list initially only contains empty and selected element as well as elements configured for selected project
# if no constraints are configured, all actions will be displayed
            my $ActionData = $Self->_ActionListConstraints(
                ProjectID             => $UnitRef->{ProjectID},
                ProjectList           => $ProjectList,
                ActionList            => \%ActionList,
                ActionListConstraints => $ActionListConstraints,
            );
            $ActionData->{''} = '';
            if ( $UnitRef->{ActionID} && $ActionList{ $UnitRef->{ActionID} } ) {
                $ActionData->{ $UnitRef->{ActionID} } = $ActionList{ $UnitRef->{ActionID} };
            }

            $Frontend{ActionOption} = $Self->{LayoutObject}->BuildSelection(

                #                Data        => \%ActionList,
                Data        => $ActionData,
                SelectedID  => $UnitRef->{ActionID} || '',
                Name        => "ActionID[$ID]",
                Translation => 0,

                #Max        => 37,
                Class => 'ActionSelection',
            );

            $Param{Remark} = $UnitRef->{Remark} || '';
            if ( $UnitRef->{ProjectID} && $UnitRef->{ActionID} ) {
                if ( $UnitRef->{Period} == 0 ) {
                    $Param{UnitRequiredDescription}
                        = 'Can\'t save settings, because of missing period!';
                }
            }

            my $Period = $UnitRef->{Period} || '';

            for (qw(StartTime EndTime)) {
                $Param{$_} = !$UnitRef->{$_} || $UnitRef->{$_} eq '00:00' ? '' : $UnitRef->{$_};
            }

            # Define if the input fields are visible or not
            $Param{Visibility} = $ShowAllInputFields || $ID < 9 ? 'visible' : 'collapse';

            $Self->{LayoutObject}->Block(
                Name => 'Unit',
                Data => { %Param, %Frontend },
            );

            $Self->{LayoutObject}->Block(
                Name => $Param{PeriodBlock},
                Data => {
                    TextPosition => $Param{TextPosition},
                    Period       => $Period,
                    ID           => $ID,
                },
            );

            # Validity checks start
            if (
                $UnitRef->{ProjectID}
                && $UnitRef->{ActionID}
                && $Param{Sick}
                )
            {
                $Param{ReadOnlyDescription}
                    = 'Are you sure, that you worked while you were on sick leave?';
            }
            elsif (
                $UnitRef->{ProjectID}
                && $UnitRef->{ActionID}
                && $Param{LeaveDay}
                )
            {
                $Param{ReadOnlyDescription}
                    = 'Are you sure, that you worked while you were on vacation?';
            }
            elsif (
                $UnitRef->{ProjectID}
                && $UnitRef->{ActionID}
                && $Param{Overtime}
                )
            {
                $Param{ReadOnlyDescription}
                    = 'Are you sure, that you worked while you were on overtime leave?';
            }
            if ( $UnitRef->{ProjectID} && !$UnitRef->{ActionID} ) {
                $Param{UnitRequiredDescription}
                    = 'Can\'t save settings, because of missing task!';
            }
            if ( !$UnitRef->{ProjectID} && $UnitRef->{ActionID} ) {
                $Param{UnitRequiredDescription}
                    = 'Can\'t save settings, because of missing project!';
            }
            if (
                $UnitRef->{StartTime}
                && $UnitRef->{StartTime} ne '00:00'
                && $UnitRef->{EndTime}
                && $UnitRef->{EndTime} ne '00:00'
                )
            {
                if ( $UnitRef->{StartTime} =~ /^(\d+):(\d+)/ ) {
                    my $StartTime = $1 * 60 + $2;
                    if ( $UnitRef->{EndTime} =~ /^(\d+):(\d+)/ ) {
                        my $EndTime = $1 * 60 + $2;
                        if (
                            $UnitRef->{Period}
                            > ( $EndTime - $StartTime ) / 60 + 0.01
                            )
                        {
                            $Param{UnitRequiredDescription}
                                = 'Can\'t save settings, because the Period is bigger'
                                . ' than the interval between Starttime and Endtime!';
                        }
                        if ( $EndTime > 60 * 24 || $StartTime > 60 * 24 ) {
                            $Param{UnitRequiredDescription}
                                = 'Can\'t save settings, because a day has only 24 hours!';
                        }
                    }
                }
            }

            if ( $Param{UnitRequiredDescription} ) {
                $Self->{LayoutObject}->Block(
                    Name => 'UnitRequired',
                    Data => { Description => $Param{UnitRequiredDescription} },
                );

                # REMARK: don't delete all working units
                # REMARK: better would be to delete only incomplete working units
                #if (
                #    !$Self->{TimeAccountingObject}->WorkingUnitsDelete(
                #        Year  => $Param{Year},
                #        Month => $Param{Month},
                #        Day   => $Param{Day},
                #    )
                #    )
                #{
                #    return $Self->{LayoutObject}->ErrorScreen(
                #        Message => 'Can\'t delete Working Units!'
                #    );
                #}
                $Param{UnitRequiredDescription}     = '';
                $Param{UnitRequiredDescriptionTrue} = 1;
            }
            if ( $Param{UnitReadOnlyDescription} ) {
                $Self->{LayoutObject}->Block(
                    Name => 'UnitReadonly',
                    Data => { Description => $Param{UnitReadOnlyDescription} },
                );
                $Param{UnitReadOnlyDescription} = '';
            }

            # Validity checks end

        }

        if (
            $Self->{TimeObject}->SystemTime()
            > timelocal( 1, 0, 0, $Param{Day}, $Param{Month} - 1, $Param{Year} - 1900 )
            )
        {
            $Param{Total} = sprintf( "%.2f", $Param{Total} );
            $Self->{LayoutObject}->Block(
                Name => 'Total',
                Data => { %Param, %Frontend },
            );
        }

        # validity checks start
        if ( $Param{Total} && $Param{Total} > 24 ) {
            $Param{RequiredDescription}
                = 'Can\'t save settings, because of more than 24 working hours!';
        }
        elsif ( $Param{Total} && $Param{Total} > 16 ) {
            $Param{ReadOnlyDescription} = 'Are you sure, that you worked more than 16 hours?';
        }
        if ( $Param{RequiredDescription} ) {
            $Self->{LayoutObject}->Block(
                Name => 'Required',
                Data => { Description => $Param{RequiredDescription} },
            );
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
        if ( $Param{ReadOnlyDescription} ) {
            $Self->{LayoutObject}->Block(
                Name => 'Readonly',
                Data => { Description => $Param{ReadOnlyDescription} },
            );
        }

        # validity checks end

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
                    Name => 'Required',
                    Data => {
                        Description =>
                            'This Date is out of limit, but you haven\'t insert this day yet, so you get one(!) chance to insert'
                    },
                );
            }
        }
        for my $YearID ( sort keys %{ $IncompleteWorkingDays{Incomplete} } ) {
            for my $MonthID ( sort keys %{ $IncompleteWorkingDays{Incomplete}{$YearID} } ) {
                for my $DayID (
                    sort keys %{ $IncompleteWorkingDays{Incomplete}{$YearID}{$MonthID} }
                    )
                {
                    if ( !$Param{Incomplete} ) {
                        $Self->{LayoutObject}->Block( Name => 'IncompleteText', );
                    }
                    my $BoldStart = '';
                    my $BoldEnd   = '';
                    if (
                        $YearID     eq $Param{Year}
                        && $MonthID eq $Param{Month}
                        && $DayID   eq $Param{Day}
                        )
                    {
                        $BoldStart = '<b>';
                        $BoldEnd   = '</b>';
                    }

                    $Self->{LayoutObject}->Block(
                        Name => 'IncompleteWorkingDays',
                        Data => {
                            Year      => $YearID,
                            Month     => $MonthID,
                            Day       => $DayID,
                            BoldStart => $BoldStart,
                            BoldEnd   => $BoldEnd,
                        },
                    );
                    $Param{Incomplete} = 1;
                }
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
        if ( $Param{Weekday} != 6 && $Param{Weekday} != 7 && !$VacationCheck ) {
            $Self->{LayoutObject}->Block(
                Name => 'OtherTimes',
                Data => { %Param, %Frontend },
            );
        }

        $Param{Weekday_to_Text} = $WeekdayArray[ $Param{Weekday} - 1 ];

        # integrate the handling for required remarks in relation to
        # projects
        $Param{RemarkRegExp} = $Self->_Project2RemarkRegExp();

        $Param{LinkVisibility} = $ShowAllInputFields ? 'collapse' : 'visible';

        # build output
        my $Output = $Self->{LayoutObject}->Header( Title => 'Edit' );
        if ( !$IncompleteWorkingDays{EnforceInsert} ) {
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Self->{LayoutObject}->Block(
                Name => 'Overview',
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
        if (
            !$Param{RequiredDescription}
            && !$Param{UnitRequiredDescriptionTrue}
            && $Param{SuccessfulInsert}
            )
        {
            $Output .= $Self->{LayoutObject}->Notify( Info => 'Successful insert!', );
        }
        $Output .= $Self->{LayoutObject}->Output(
            Data => { %Param, %Frontend },
            TemplateFile => 'AgentTimeAccountingEdit'
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ---------------------------------------------------------- #
    # view older day insterts
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'View' ) {

        # permission check
        return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' ) if !$Self->{AccessRo};

        # get params
        for (qw(Day Month Year UserID)) {
            $Param{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
        }

        # check needed params
        for (qw(Day Month Year)) {
            if ( !$Param{$_} ) {
                return $Self->{LayoutObject}->ErrorScreen( Message => "View: Need $_" );
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
            $Self->{LayoutObject}->Block( Name => 'UnitBlock', );

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
        for (qw(Day Month Year)) {
            $Param{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
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
                "Action=$Self->{Action}&Subaction=Edit&Year=$Param{Year}&Month=$Param{Month}&Day=$Param{Day}"
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

        for (qw(Status Day Month Year UserID ProjectStatusShow)) {
            $Param{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
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
                "Action=$Self->{Action}&Subaction=Overview&Year=$Param{Year}&Month=$Param{Month}",
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

            if ( $Param{Year} eq $Year && $Param{Month} eq $Month && $CurrentDay eq $Day ) {
                $Param{Style} = 'bgcolor="orange"';
            }
            elsif ($VacationCheck) {
                $Param{Style}   = 'bgcolor="#EBCCCC"';
                $Param{Comment} = $VacationCheck;
            }
            elsif ( $Param{Weekday} == 6 || $Param{Weekday} == 5 ) {
                $Param{Style} = 'bgcolor="#FFE0E0"';
            }
            else {
                $Param{Style} = 'bgcolor="#E5F0FF"';
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
        for (
            qw(TargetState TargetStateTotal WorkingHoursTotal WorkingHours
            Overtime OvertimeTotal OvertimeUntil LeaveDay LeaveDayTotal
            LeaveDayRemaining Sick SickTotal SickRemaining)
            )
        {
            $UserReport{ $Param{UserID} }{$_} ||= 0;
            $Param{$_} = sprintf( "%.2f", $UserReport{ $Param{UserID} }{$_} );
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

        PROJECTID:
        for my $ProjectID (
            sort { $ProjectData{$a}{Name} cmp $ProjectData{$b}{Name} }
            keys %ProjectData
            )
        {
            my $ProjectRef = $ProjectData{$ProjectID};
            my $ActionsRef = $ProjectRef->{Actions};

            $Param{Project} = '';
            $Param{Class}   = 'contentvalue';
            $Param{Status}  = $ProjectRef->{Status} ? '' : 'passiv';

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
                        },
                    );

                    if ( $UserData{CreateProject} ) {

                        # persons how are allowed to see the create object link are
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
            $Param{Class}      = 'contentkey';
            $Param{Action}     = 'Total';
            $Param{Hours}      = sprintf( "%.2f", $Total );
            $Param{HoursTotal} = sprintf( "%.2f", $TotalTotal );
            $Param{TotalHours}      += $Total;
            $Param{TotalHoursTotal} += $TotalTotal;
            $Self->{LayoutObject}->Block(
                Name => 'Action',
                Data => {%Param},
            );
            $Param{Class} = '';
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
        my %Data = ();

        for (qw(ActionAction ActionUser NewAction NewUser)) {
            $Param{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
        }

        # permission check
        return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' ) if !$Self->{AccessRw};

        $Self->{LayoutObject}->Block( Name => 'Setting', );

        # store last screen
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'LastScreen',
            Value     => "Action=$Self->{Action}&Subaction=Setting",
        );

        if ( $Param{ActionAction} || $Param{NewAction} ) {
            my %Action      = $Self->{TimeAccountingObject}->ActionSettingsGet();
            my $ActionEmpty = 0;
            my %ActionCheck = ();
            for my $ActionID ( keys %Action ) {
                for (qw(Action ActionStatus)) {
                    $Data{$ActionID}{$_}
                        = $Self->{ParamObject}->GetParam( Param => $_ . '[' . $ActionID . ']' );
                }
                if ( !$Data{$ActionID}{Action} ) {
                    $ActionEmpty = 1;
                }

                if (
                    $Data{$ActionID}{Action}
                    && $ActionCheck{ $Data{$ActionID}{Action} }
                    && $ActionCheck{ $Data{$ActionID}{Action} } == 1
                    )
                {
                    return $Self->{LayoutObject}->ErrorScreen(
                        Message => 'The actionnaming must be unique!'
                    );
                }

                $ActionCheck{ $Data{$ActionID}{Action} } = 1;
            }
            if ( !$Self->{TimeAccountingObject}->ActionSettingsUpdate(%Data) ) {
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => 'Can\'t update action data!'
                );
            }
            if ( $Param{NewAction} && !$ActionEmpty ) {
                if ( !$Self->{TimeAccountingObject}->ActionSettingsInsert() ) {
                    return $Self->{LayoutObject}->ErrorScreen(
                        Message => 'Can\'t insert action data!'
                    );
                }
            }
        }
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

                    for (qw( ShowOvertime CreateProject Calendar )) {
                        $Data{$UserID}{$_}
                            = $Self->{ParamObject}->GetParam( Param => $_ . '[' . $UserID . ']' );
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

                        for (qw(WeeklyHours LeaveDays UserStatus DateStart DateEnd Overtime)) {
                            $Data{$UserID}{$Period}{$_} = $Self->{ParamObject}->GetParam(
                                Param => $_ . '[' . $UserID . '][' . $Period . ']'
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
                    for ( keys %Groups ) {
                        if ( $Groups{$_} eq 'time_accounting' && !$GroupData{$_} ) {

                            $Self->{GroupObject}->GroupMemberAdd(
                                GID        => $_,
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
                    ShowOvertime   => $UserBasicsRef->{ShowOvertime} ? 'checked' : '',
                    CreateProject  => $UserBasicsRef->{CreateProject} ? 'checked' : '',
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

        if (%ShownUsers) {
            $ShownUsers{''} = '';
            my $NewUserOption = $Self->{LayoutObject}->BuildSelection(
                Data        => \%ShownUsers,
                SelectedID  => '',
                Name        => 'NewUserID',
                Translation => 0,
            );
            $Self->{LayoutObject}->Block(
                Name => 'NewUserOption',
                Data => { NewUserOption => $NewUserOption, },
            );
        }

        # build output
        my $Output = $Self->{LayoutObject}->Header( Title => 'Setting' );
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            Data         => \%Param,
            TemplateFile => 'AgentTimeAccountingSetting'
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ---------------------------------------------------------- #
    # settings for handling time accounting
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'ProjectSetting' ) {
        my %Project = ();
        my %Data    = ();

        for (qw(ActionProject NewProject)) {
            $Param{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
        }

        # permission check
        return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' ) if !$Self->{AccessRo};

        $Self->{LayoutObject}->Block( Name => 'ProjectSetting', );

        # Edit TimeAccounting Preferences
        if ( $Param{ActionProject} || $Param{NewProject} ) {
            %Project = $Self->{TimeAccountingObject}->ProjectSettingsGet();
            my $ProjectEmpty = 0;
            my %ProjectCheck = ();
            for my $ProjectID ( keys %{ $Project{Project} } ) {
                for (qw(Project ProjectStatus ProjectDescription)) {
                    $Data{$ProjectID}{$_}
                        = $Self->{ParamObject}->GetParam( Param => $_ . '[' . $ProjectID . ']' );
                }
                if ( !$Data{$ProjectID}{Project} ) {
                    $ProjectEmpty = 1;
                }
                if (
                    $Data{$ProjectID}{Project}
                    && $ProjectCheck{ $Data{$ProjectID}{Project} }
                    && $ProjectCheck{ $Data{$ProjectID}{Project} } == 1
                    )
                {
                    return $Self->{LayoutObject}->ErrorScreen(
                        Message => 'The projectnaming must be unique!'
                    );
                }
                else {
                    if ( $Data{$ProjectID}{Project} ) {
                        $ProjectCheck{ $Data{$ProjectID}{Project} } = 1;
                    }
                }
            }
            if ( !$Self->{TimeAccountingObject}->ProjectSettingsUpdate(%Data) ) {
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => 'Can\'t update project data!'
                );
            }
            if ( $Param{NewProject} && !$ProjectEmpty ) {
                if ( !$Self->{TimeAccountingObject}->ProjectSettingsInsert() ) {
                    return $Self->{LayoutObject}->ErrorScreen(
                        Message => 'Can\'t insert project data!'
                    );
                }
            }
        }

        # Show TimeAccounting Preferences
        my %StatusList = (
            1 => 'valid',
            0 => 'invalid',
        );

        # Show project data
        %Project = $Self->{TimeAccountingObject}->ProjectSettingsGet();
        my $ProjectEmpty = 0;
        for my $ProjectID (
            sort { $Project{Project}{$a} cmp $Project{Project}{$b} }
            keys %{ $Project{Project} }
            )
        {

            $Param{Project}            = $Project{Project}{$ProjectID};
            $Param{ProjectDescription} = $Project{ProjectDescription}{$ProjectID};
            $Param{ProjectID}          = $ProjectID;

            my $StatusOption = $Self->{LayoutObject}->BuildSelection(
                Data       => \%StatusList,
                SelectedID => $Project{ProjectStatus}{$ProjectID},
                Name       => "ProjectStatus[$Param{ProjectID}]",
            );

            $Self->{LayoutObject}->Block(
                Name => 'Project',
                Data => {
                    %Param,
                    StatusOption => $StatusOption,
                },
            );
        }

        # build output
        my $Output = $Self->{LayoutObject}->Header( Title => 'Setting' );
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            Data         => \%Param,
            TemplateFile => 'AgentTimeAccountingSetting'
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
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

        for (qw(Status Month Year ProjectStatusShow)) {
            $Param{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
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
                "Action=$Self->{Action}&Subaction=Reporting&Year=$Param{Year}&Month=$Param{Month}",
        );

        $Param{Month_to_Text} = $MonthArray[ $Param{Month} ];

        my %Month = ();
        for my $ID ( 1 .. 12 ) {
            $Month{ sprintf( "%02d", $ID ) }{Value}    = $MonthArray[$ID];
            $Month{ sprintf( "%02d", $ID ) }{Position} = $ID;
            if ( $Param{Month} == $ID ) {
                $Month{ sprintf( "%02d", $ID ) }{Selected} = 1;
            }
        }

        $Frontend{MonthOption} = $Self->{LayoutObject}->OptionElement(
            Data => \%Month,
            Name => 'Month',
        );

        my @Year = ( 2005 .. $Year );

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

            for (qw(LeaveDay Overtime WorkingHours Sick LeaveDayRemaining OvertimeTotal)) {
                $Param{$_} = sprintf( "%.2f", $UserReport{$UserID}{$_} );
                $Param{ 'Total' . $_ } += $Param{$_};
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

        for (
            qw(TotalLeaveDay TotalOvertime TotalWorkingHours
            TotalSick TotalLeaveDayRemaining TotalOvertimeTotal)
            )
        {
            $Param{$_} = sprintf( "%.2f", $Param{$_} );
        }

        # show the report sort by projects
        if ( !$Param{ProjectStatusShow} || $Param{ProjectStatusShow} eq 'valid' ) {
            $Param{ProjectStatusShow} = 'all';
        }
        elsif ( $Param{ProjectStatusShow} eq 'all' ) {
            $Param{ProjectStatusShow} = 'valid';
        }

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
            $Param{Class}   = 'contentvalue';
            $Param{Status}  = $ProjectRef->{Status} ? '' : 'passiv';

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

            $Param{Class}      = 'contentkey';
            $Param{Action}     = 'Total';
            $Param{Hours}      = sprintf( "%.2f", $Total );
            $Param{HoursTotal} = sprintf( "%.2f", $TotalTotal );
            $Param{TotalHours}      += $Total;
            $Param{TotalHoursTotal} += $TotalTotal;
            $Self->{LayoutObject}->Block(
                Name => 'Action',
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
                    Period => $Row->{Period},
                    Date   => $Row->{Date},
                    }
            );
        }

        # show the total sum of hours at the end of the history list
        # I also can use $Param{TotalAll}
        my $ProjectTotalHours = $Self->{TimeAccountingObject}->ProjectTotalHours(
            ProjectID => $Param{ProjectID},
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
    # show error screen
    # ---------------------------------------------------------- #
    return $Self->{LayoutObject}->ErrorScreen( Message => 'Invalid Subaction process!' );
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
    for ( keys %GroupList ) {
        if ( $GroupList{$_} eq 'time_accounting' ) {
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=AgentTimeAccounting&" . "Subaction=Setting"
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
        for my $Project ( @{ $Param{ProjectList} } ) {
            if ( $Project->{Key} eq $Param{ProjectID} ) {
                $ProjectName = $Project->{Value};
                last;
            }
        }

        if ( defined($ProjectName) ) {
            for my $ActionID ( keys %{ $Param{ActionList} } ) {
                my $ActionName = $Param{ActionList}->{$ActionID};
                for my $ProjectNameRegExp ( keys %{ $Param{ActionListConstraints} } ) {
                    my $ActionNameRegExp = $Param{ActionListConstraints}->{$ProjectNameRegExp};
                    if (
                        $ProjectName   =~ m{$ProjectNameRegExp}smx
                        && $ActionName =~ m{$ActionNameRegExp}smx
                        )
                    {
                        $List{$ActionID} = $ActionName;
                        last;
                    }
                }
            }
        }
    }

    # all actions will be added if no action was added above (possible misconfiguration)
    unless ( keys %List ) {
        for my $ActionID ( keys %{ $Param{ActionList} } ) {
            my $ActionName = $Param{ActionList}->{$ActionID};
            $List{$ActionID} = $ActionName;
        }
    }

    return \%List;
}

sub _ProjectList {
    my ( $Self, %Param ) = @_;

    #    # check needed param
    #    if ( !$Param{WorkingUnitID} ) {
    #        $Self->{LayoutObject}->ErrorScreen(
    #            Message => '_ProjectList: Need WorkingUnitID',
    #        );
    #    }

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
                    push( @List, $Project );
                }
                else {
                    for my $ProjectRegex (@ProjectRegex) {
                        if ( $ProjectName =~ m{$ProjectRegex}smx ) {
                            push( @List, $Project );
                            $ProjectCount++;
                            last;
                        }
                    }
                }
                $ElementCount++;
            }
        }
    }

# get full project list if constraints resulted in empty project list or if constraints aren't configured (possible misconfiguration)
    unless ($ProjectCount) {
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
1;
