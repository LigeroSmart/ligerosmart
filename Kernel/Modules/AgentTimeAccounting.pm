# --
# Kernel/Modules/AgentTimeAccounting.pm - time accounting module
# Copyright (C) 2003-2006 OTRS GmbH, http://www.otrs.com/
# --
# $Id: AgentTimeAccounting.pm,v 1.7 2006-05-23 09:06:49 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentTimeAccounting;

use strict;
use Kernel::System::TimeAccounting;
use Date::Pcalc qw(Today Days_in_Month Day_of_Week Add_Delta_YMD);
use Time::Local;

use vars qw($VERSION);
$VERSION = '$Revision: 1.7 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get common objects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check needed Opjects
    foreach (qw(ParamObject DBObject ModuleReg LogObject
        ConfigObject TicketObject TimeObject GroupObject)
    ) {
        $Self->{LayoutObject}->FatalError(Message => "Got no $_!") if (!$Self->{$_});
    }

    # create needen objects
    $Self->{TimeAccountingObject} = Kernel::System::TimeAccounting->new(%Param);
    return $Self;
}
# --
sub PreRun {
    my $Self = shift;
    my %Param = @_;
    my ($Sec, $Min, $Hour, $Day, $Month, $Year) = $Self->{TimeObject}->SystemTime2Date(
        SystemTime => $Self->{TimeObject}->SystemTime(),
    );
    my %User = $Self->{TimeAccountingObject}->UserCurrentPeriodGet(
        Year  => $Year,
        Month => $Month,
        Day   => $Day,
    );
    if ($User{$Self->{UserID}}){
        my %IncompleteWorkingDays = $Self->{TimeAccountingObject}->WorkingUnitsCompletnessCheck();
        # redirect if incomplete working day are out of range
        if ($IncompleteWorkingDays{EnforceInsert}
            && $Self->{Action} ne 'AgentTimeAccounting'
            && $Self->{Action} ne 'AgentCalendarSmall')
        {
            return $Self->{LayoutObject}->Redirect(OP => "Action=AgentTimeAccounting&Subaction=Edit");
        }
    }
    return;
}
# --
sub Run {
    my $Self  = shift;
    my %Param = @_;
    my @MonthArray = (
        '',
        'January',
        'February',
        'March',
        'April',
        'May',
        'Juny',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
    );
    my @WeekdayArray = (
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat',
        'Sun',
    );

    # ---------------------------------------------------------- #
    # edit the time accounting elements
    # ---------------------------------------------------------- #
    if ($Self->{Subaction} eq 'Edit') {
        my $Output       = '';
        my %Frontend     = ();
        my %ProjectList  = ();
        my %ActionList   = ();
        my %Data         = ();
        my %Action       = $Self->{TimeAccountingObject}->ActionSettingsGet();
        my ($Sec, $Min, $Hour, $Day, $Month, $Year) = $Self->{TimeObject}->SystemTime2Date(
            SystemTime => $Self->{TimeObject}->SystemTime(),
        );

        # get params
        foreach (qw(Status Year Month Day Delete)) {
            $Param{$_} = $Self->{ParamObject}->GetParam(Param => $_);
        }
        # permission check
        if (!$Self->{AccessRo}) {
            return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
        }

        # Check Date
        if (!$Param{Year} || !$Param{Month} || !$Param{Day}) {
            $Param{Year}  = $Year;
            $Param{Month} = $Month;
            $Param{Day}   = $Day;
        }
        else {
            $Param{Year}  = sprintf("%02d",$Param{Year});
            $Param{Month} = sprintf("%02d",$Param{Month});
            $Param{Day}   = sprintf("%02d",$Param{Day});
        }

        my %User = $Self->{TimeAccountingObject}->UserCurrentPeriodGet(
            Year  => $Param{Year},
            Month => $Param{Month},
            Day   => $Param{Day},
        );

        # for inital useing, the first agent with rw-right will be redirected
        # to 'Setting'. Then he can do the initial settings
        if (!$User{$Self->{UserID}}){
            my %GroupList = $Self->{GroupObject}->GroupMemberList(
                UserID => $Self->{UserID},
                Type   => 'rw',
                Result => 'HASH',
            );

            foreach ((keys %GroupList)) {
                if ($GroupList{$_} eq 'time_accounting') {
                    return $Self->{LayoutObject}->Redirect(OP => "Action=AgentTimeAccounting&" .
                                                                 "Subaction=Setting");
                }
            }
            return $Self->{LayoutObject}->ErrorScreen(Message => "No UserPeriod available, please contact the time accounting admin to insert your UserPeriod!");
        }

        my %IncompleteWorkingDays = $Self->{TimeAccountingObject}->WorkingUnitsCompletnessCheck();
        my $MaxAllowedInsertDays  = $Self->{ConfigObject}->Get('TimeAccounting::MaxAllowedInsertDays') || '10';
        ($Param{YearAllowed}, $Param{MonthAllowed}, $Param{DayAllowed}) = Add_Delta_YMD($Year, $Month, $Day, 0, 0, -$MaxAllowedInsertDays);
        if (timelocal(1, 0, 0 , $Param{Day}, $Param{Month} - 1, $Param{Year} - 1900) < timelocal(1, 0, 0 , $Param{DayAllowed}, $Param{MonthAllowed} - 1, $Param{YearAllowed} - 1900)) {
            if (!$IncompleteWorkingDays{Incomplete}{$Param{Year}}{$Param{Month}}{$Param{Day}}) {
                return $Self->{LayoutObject}->Redirect(OP => "Action=$Self->{Action}&Subaction=View&Year=$Param{Year}&Month=$Param{Month}&Day=$Param{Day}");
            }
        }

        # store last screen
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'LastScreen',
            Value     => "Action=$Self->{Action}&Subaction=Edit&Year=$Param{Year}&Month=$Param{Month}&Day=$Param{Day}",
        );

        $Param{Month_to_Text}   = $MonthArray[$Param{Month}];

        ($Param{YearBack}, $Param{MonthBack}, $Param{DayBack}) = Add_Delta_YMD($Param{Year}, $Param{Month}, $Param{Day}, 0, 0, -1);
        ($Param{YearNext}, $Param{MonthNext}, $Param{DayNext}) = Add_Delta_YMD($Param{Year}, $Param{Month}, $Param{Day}, 0, 0, 1);

    # Edit Working Units
        if ($Param{Status}) {
            if ($Param{Delete}) {
                $Output .= $Self->{LayoutObject}->Header(Title => "Delete");
                $Output .= $Self->{LayoutObject}->NavigationBar();
                $Output .= $Self->{LayoutObject}->Output(Data => {%Param, %Frontend}, TemplateFile => 'AgentTimeAccountingDelete');
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
            my $WorkingUnitID = 0;
            for ($WorkingUnitID = 1; $WorkingUnitID < 10; $WorkingUnitID++) {
                foreach (qw(ProjectID ActionID Remark StartTime EndTime Period)) {
                    $Param{$_} = $Self->{ParamObject}->GetParam(Param => $_ . '[' . $WorkingUnitID . ']');
                }
                if ($Param{ProjectID} || $Param{ActionID}) {
                    $Data{$WorkingUnitID}{ProjectID} = $Param{ProjectID};
                    $Data{$WorkingUnitID}{ActionID}  = $Param{ActionID};
                    $Data{$WorkingUnitID}{Remark}    = $Param{Remark};
                    $Data{$WorkingUnitID}{StartTime} = $Param{StartTime};
                    $Data{$WorkingUnitID}{EndTime}   = $Param{EndTime};
                    $Data{$WorkingUnitID}{Date}      = $Param{Date};
                    if ($Param{Period} =~ /^(\d+),(\d+)/) {
                        $Data{$WorkingUnitID}{Period}    = $1 . "." . $2;
                    }
                    else {
                        $Data{$WorkingUnitID}{Period}    = $Param{Period};
                    }

                    my %ReduceTime = ();
                    if ($Self->{ConfigObject}->Get('TimeAccounting::ReduceTime')) {
                        %ReduceTime = %{$Self->{ConfigObject}->Get('TimeAccounting::ReduceTime')};
                    }
#                    if ($Param{StartTime} && $Param{EndTime} && !$Param{Period}) {
                    if ($Param{StartTime} && $Param{EndTime}) {
                        if ($Param{StartTime} =~ /^(\d+):(\d+)/) {
                            my $StartTime = $1*60 + $2;
                            if ($Param{EndTime} =~ /^(\d+):(\d+)/) {
                                 my $EndTime = $1*60 + $2;
                                if ($ReduceTime{$Action{$Param{ActionID}}{Action}}) {
                                    $Data{$WorkingUnitID}{Period} = ($EndTime - $StartTime)/60 * $ReduceTime{$Action{$Param{ActionID}}{Action}} / 100;
                                }
                                else {
                                    $Data{$WorkingUnitID}{Period} = ($EndTime - $StartTime)/60;
                                }
                            }
                        }
                    }
                }
            }

            my $CheckboxCheck = 0;
            foreach (qw(LeaveDay Diseased Overtime)) {
                $Param{$_} = $Self->{ParamObject}->GetParam(Param => $_);
                if ($Param{$_}) {
                    $WorkingUnitID++;
                    $Data{$WorkingUnitID}{ProjectID} = '-1';
                    $Data{$WorkingUnitID}{ActionID}  = $Param{$_};
                    $Data{$WorkingUnitID}{Remark}    = '';
                    $Data{$WorkingUnitID}{StartTime} = '';
                    $Data{$WorkingUnitID}{EndTime}   = '';
                    $Data{$WorkingUnitID}{Period}    = '';
                    $CheckboxCheck++;
                }
            }
            if ($CheckboxCheck > 1) {
                $Param{RequiredDescription} = "You can only select one checkbox element!";
            }

            $Data{Year}  = $Param{Year};
            $Data{Month} = $Param{Month};
            $Data{Day}   = $Param{Day};
            if (!$Self->{TimeAccountingObject}->WorkingUnitsInsert(%Data)) {
                return $Self->{LayoutObject}->ErrorScreen(Message => 'Can\'t insert Working Units!');
            }
            else {
                $Param{SuccessfulInsert} = 1;
            }
        }

    # Show Working Units
        # get existing working units
        %Data    = $Self->{TimeAccountingObject}->WorkingUnitsGet(
            Year  => $Param{Year},
            Month => $Param{Month},
            Day   => $Param{Day},
        );

        if ($Self->{ConfigObject}->Get('TimeAccounting::InputHoursWithoutStartEndTime')) {
            $Param{TextPosition}  = 'left';
            $Param{PeriodBlock}   = 'UnitInputPeriod';
            $Frontend{ClassTime}  = 'footnote';
            $Frontend{PeriodNote} = '*';
            $Self->{LayoutObject}->Block(
                Name => 'FootNote',
                Data => {%Param, %Frontend},
            );
        }
        else {
            $Param{TextPosition}  = 'right';
            $Param{PeriodBlock}   = 'UnitPeriodWithoutInput';
            $Frontend{ClassTime}  = 'required';
            $Frontend{PeriodNote} = '';
        }

        # get project settings
        my %Project = $Self->{TimeAccountingObject}->ProjectSettingsGet();
        foreach my $ProjectID (keys %{$Project{Project}}) {
            if ($Project{ProjectStatus}{$ProjectID}) {
                $ProjectList{$ProjectID} = $Project{Project}{$ProjectID};
            }
        }
        $ProjectList{''} = '';

        # get action settings
        foreach my $ActionID (keys %Action) {
            if ($Action{$ActionID}{ActionStatus}) {
                $ActionList{$ActionID} = $Action{$ActionID}{Action};
            }
        }
        $ActionList{''} = '';


        if (time() > timelocal(1, 0, 0 , $Param{Day}, $Param{Month} - 1, $Param{Year} - 1900)) {
            $Self->{LayoutObject}->Block(
                Name => 'UnitBlock',
                Data => {%Param, %Frontend},
            );
        }
        # build units
        my $WorkingUnitIDMax = 10;
        my $WorkingUnitID    = 0;
        $Param{Total}        = 0;
        for ($WorkingUnitID = 1; $WorkingUnitID < $WorkingUnitIDMax; $WorkingUnitID++) {
            if ($Data{$WorkingUnitID}{ProjectID} && $Data{$WorkingUnitID}{ProjectID} == -1) {
                if ($Data{$WorkingUnitID}{ActionID}    == -1) {
                    $Param{Diseased} = 'checked';
                }
                elsif ($Data{$WorkingUnitID}{ActionID} == -2) {
                    $Param{LeaveDay} = 'checked';
                }
                elsif ($Data{$WorkingUnitID}{ActionID} == -3) {
                    $Param{Overtime} = 'checked';
                }
                $WorkingUnitIDMax++;
            }
            else {
                $Param{ID} = $WorkingUnitID ;
                # get option fields
                $Frontend{'ActionOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
                    Data       => \%ActionList,
                    SelectedID => $Data{$WorkingUnitID}{ActionID} || '',
                    Name       => "ActionID[$WorkingUnitID]",
                );
                $Frontend{'ProjectOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
                    Data       => \%ProjectList,
                    SelectedID => $Data{$WorkingUnitID}{ProjectID} || '',
                    Name       => "ProjectID[$WorkingUnitID]",
                );

                $Param{Remark}    = $Data{$WorkingUnitID}{Remark} || '';
                if ($Data{$WorkingUnitID}{ProjectID} && $Data{$WorkingUnitID}{ActionID}) {
                    if ($Data{$WorkingUnitID}{Period}) {
                        if ($Data{$WorkingUnitID}{Period} > 0) {
                            $Param{Period}    = $Data{$WorkingUnitID}{Period};
                            $Param{Total}    += $Param{Period};
                        }
                        else {
                            $Param{UnitRequiredDescription} = 'Can\'t save settings, because Starttime is older than Endtime!';
                        }
                    }
                    else {
                        $Param{Period} = '';
                        $Param{UnitRequiredDescription} = 'Can\'t save settings, because of missing period!';
                    }
                }
                else {
                    $Param{Period}    = '';
                    $Param{StartTime} = '';
                    $Param{EndTime}   = '';
                }

#                foreach (qw(Start End)) {
#                    if ($Data{$WorkingUnitID}{$_ . "Time"} && $Data{$WorkingUnitID}{$_ . "Time"} eq '00:00:00') {
#                        $Param{$_ . "Hour"} = '00';
#                        $Param{$_ . "Minute"} = '00';
#                    }
#                    elsif ($Data{$WorkingUnitID}{$_ . "Time"}) {
#                        $Param{$_. "Hour"}   = substr($Data{$WorkingUnitID}{$_}, 0, 2) || '';
#                        $Param{$_. "Minute"} = substr($Data{$WorkingUnitID}{$_}, 3, 2) || '';
#                    }
#                    $Param{$_ . "Time"} = BuildTimeSelection(
#                        Hour   => $Param{$_. "Hour"},
#                        Minute => $Param{$_. "Minute"}
#                        Prefix => $_,
#                        Format => 'TimeInputFormat',
#                    );
#                }

                foreach (qw(StartTime EndTime)) {
                    if ($Data{$WorkingUnitID}{$_} && $Data{$WorkingUnitID}{$_} eq '00:00') {
                        $Param{$_} = '';
                    }
                    else {
                        $Param{$_} = $Data{$WorkingUnitID}{$_};
                    }
                }

                $Self->{LayoutObject}->Block(
                    Name => 'Unit',
                    Data => {%Param, %Frontend},
                );

                $Self->{LayoutObject}->Block(
                    Name => $Param{PeriodBlock},
                    Data => {%Param, %Frontend},
                );


                # Validity checks start
                if ($Data{$WorkingUnitID}{ProjectID} && $Data{$WorkingUnitID}{ActionID} && $Param{Diseased}) {
                    $Param{ReadOnlyDescription} = 'Are you sure, that you worked while you are Diseased?';
                }
                elsif ($Data{$WorkingUnitID}{ProjectID} && $Data{$WorkingUnitID}{ActionID} && $Param{LeaveDay}) {
                    $Param{ReadOnlyDescription} = 'Are you sure, that you worked while you have a leave day?';
                }
                elsif ($Data{$WorkingUnitID}{ProjectID} && $Data{$WorkingUnitID}{ActionID} && $Param{Overtime}) {
                    $Param{ReadOnlyDescription} = 'Are you sure, that you worked while you have overtime?';
                }
                if ($Data{$WorkingUnitID}{ProjectID} && !$Data{$WorkingUnitID}{ActionID}) {
                    $Param{UnitRequiredDescription} = 'Can\'t save settings, because of missing Action!';
                }
                if (!$Data{$WorkingUnitID}{ProjectID} && $Data{$WorkingUnitID}{ActionID}) {
                    $Param{UnitRequiredDescription} = 'Can\'t save settings, because of missing Project!';
                }
                if ($Data{$WorkingUnitID}{StartTime} && $Data{$WorkingUnitID}{StartTime} ne '00:00' && $Data{$WorkingUnitID}{EndTime} && $Data{$WorkingUnitID}{EndTime}  ne '00:00') {
                    if ($Data{$WorkingUnitID}{StartTime} =~ /^(\d+):(\d+)/) {
                        my $StartTime = $1*60 + $2;
                        if ($Data{$WorkingUnitID}{EndTime} =~ /^(\d+):(\d+)/) {
                            my $EndTime = $1*60 + $2;
                            if ($Data{$WorkingUnitID}{Period} > ($EndTime - $StartTime)/60 + 0.01) {
                                $Param{UnitRequiredDescription} = 'Can\'t save settings, because the Period is bigger than the interval between Starttime and Endtime!';
                            }
                            if ($EndTime > 60 * 24 || $StartTime > 60 * 24) {
                                $Param{UnitRequiredDescription} = 'Can\'t save settings, because a day has only 24 hours!';
                            }
                        }
                    }
                }

                if ($Param{UnitRequiredDescription}){
                    $Self->{LayoutObject}->Block(
                        Name => 'UnitRequired',
                        Data => {Description => $Param{UnitRequiredDescription}},
                    );
                    if (!$Self->{TimeAccountingObject}->WorkingUnitsDelete(
                        Year  => $Param{Year},
                        Month => $Param{Month},
                        Day   => $Param{Day},
                    )) {
                        return $Self->{LayoutObject}->ErrorScreen(Message => 'Can\'t delete Working Units!');
                    }
                    $Param{UnitRequiredDescription}     = '';
                    $Param{UnitRequiredDescriptionTrue} = 1;
                }
                if ($Param{UnitReadOnlyDescription}){
                    $Self->{LayoutObject}->Block(
                        Name => 'UnitReadonly',
                        Data => {Description => $Param{UnitReadOnlyDescription}},
                    );
                    $Param{UnitReadOnlyDescription} = '';
                }
                # Validity checks end
            }
        }

        if ($Self->{TimeObject}->SystemTime() > timelocal(1, 0, 0 , $Param{Day}, $Param{Month} - 1, $Param{Year} - 1900)) {
            $Param{Total}           = sprintf ("%.2f", $Param{Total});
            $Self->{LayoutObject}->Block(
                Name => 'Total',
                Data => {%Param, %Frontend},
            );
        }
        # validity checks start
        if ($Param{Total} && $Param{Total} > 24) {
            $Param{RequiredDescription} = 'Can\'t save settings, because of more than 24 working hours!';
        }
        elsif ($Param{Total} && $Param{Total} > 16) {
            $Param{ReadOnlyDescription} = 'Are you sure, that you worked more than 16 hours?';
        }
        if ($Param{RequiredDescription}){
            $Self->{LayoutObject}->Block(
                Name => 'Required',
                Data => {Description => $Param{RequiredDescription}},
            );
            if (!$Self->{TimeAccountingObject}->WorkingUnitsDelete(
                Year  => $Param{Year},
                Month => $Param{Month},
                Day   => $Param{Day},
            )) {
                return $Self->{LayoutObject}->ErrorScreen(Message => 'Can\'t delete Working Units!');
            }
        }
        if ($Param{ReadOnlyDescription}){
            $Self->{LayoutObject}->Block(
                Name => 'Readonly',
                Data => {Description => $Param{ReadOnlyDescription}},
            );
        }

        # validity checks end

        $Param{Date} = $Self->{LayoutObject}->BuildDateSelection(
            %Param,
            Prefix => '',
            Format => 'DateInputFormat',
        );

        if (timelocal(1, 0, 0 , $Param{Day}, $Param{Month} - 1, $Param{Year} - 1900) < timelocal(1, 0, 0 , $Param{DayAllowed}, $Param{MonthAllowed} - 1, $Param{YearAllowed} - 1900)) {
            if ($IncompleteWorkingDays{Incomplete}{$Param{Year}}{$Param{Month}}{$Param{Day}} && !$Param{SuccessfulInsert}) {
                $Self->{LayoutObject}->Block(
                    Name => 'Required',
                    Data => {Description => 'This Date is out of limit, but you haven\'t insert this day yet, so you get one(!) chance to insert'},
                );
            }
        }

        foreach my $YearID (sort keys %{$IncompleteWorkingDays{Incomplete}}) {
            foreach my $MonthID (sort keys %{$IncompleteWorkingDays{Incomplete}{$YearID}}) {
                foreach my $DayID (sort keys %{$IncompleteWorkingDays{Incomplete}{$YearID}{$MonthID}}) {
                    if (!$Param{Incomplete}) {
                        $Self->{LayoutObject}->Block(
                            Name => 'IncompleteText',
                        );
                    }
                    my $BoldStart = '';
                    my $BoldEnd   = '';
                    if ($YearID eq $Param{Year}
                        && $MonthID eq $Param{Month}
                        && $DayID eq $Param{Day}
                    ) {
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

        my $VacationCheck = $Self->{TimeAccountingObject}->VacationCheck(
            Year  => $Year,
            Month => $Month,
            Day   => $Day,
        );

        $Param{Weekday}   = Day_of_Week($Param{Year}, $Param{Month}, $Param{Day});
        if ($Param{Weekday} != 6 && $Param{Weekday} != 7 && !$VacationCheck) {
            $Self->{LayoutObject}->Block(
                Name => 'OtherTimes',
                Data => {%Param, %Frontend},
            );
        }

        $Param{Weekday_to_Text} = $WeekdayArray[$Param{Weekday} - 1];

        # build output
        $Output = $Self->{LayoutObject}->Header(Title => "Edit");
        if (!$IncompleteWorkingDays{EnforceInsert}) {
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Self->{LayoutObject}->Block(
                Name => 'Overview',
                Data => {%Param, %Frontend},
            );
            # show create project link, if allowed
            my %UserBasics = $Self->{TimeAccountingObject}->UserGet();
            if ($UserBasics{$Self->{UserID}}{CreateProject}) {
                $Self->{LayoutObject}->Block(
                    Name => 'CreateProject',
                );
            }
        }
        if (!$Param{RequiredDescription} && !$Param{UnitRequiredDescriptionTrue} && $Param{SuccessfulInsert}) {
            $Output .= $Self->{LayoutObject}->Notify(
                Info => 'Successful insert!',
            );
        }
        $Output .= $Self->{LayoutObject}->Output(
            Data         => {%Param, %Frontend},
            TemplateFile => 'AgentTimeAccountingEdit'
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ---------------------------------------------------------- #
    # view older day insterts
    # ---------------------------------------------------------- #
    elsif ($Self->{Subaction} eq 'View') {
        # permission check
        if (!$Self->{AccessRo}) {
            return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
        }

        # get params
        foreach (qw(Day Month Year UserID)) {
            $Param{$_} = $Self->{ParamObject}->GetParam(Param => $_);
        }

        # check needed params
        foreach (qw(Day Month Year)) {
            if (!$Param{$_}) {
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "View: Need $_"
                );
            }
        }

        # if no UserID posted use the current user
        if (!$Param{UserID}) {
            $Param{UserID} = $Self->{UserID};
        }

        # show the naming of the agent which time accounting is visited
        if ($Param{UserID} != $Self->{UserID}) {
            my %ShownUsers = $Self->{UserObject}->UserList(Type => 'Long', Valid => 1);
            $Param{User}   = $ShownUsers{$Param{UserID}};
            $Self->{LayoutObject}->Block(
                Name => 'User',
                Data => {%Param},
            );
        }

        $Param{Weekday}         = Day_of_Week($Param{Year}, $Param{Month}, $Param{Day});
        $Param{Weekday_to_Text} = $WeekdayArray[$Param{Weekday} - 1];
        $Param{Month_to_Text}   = $MonthArray[$Param{Month}];
        # Values for the link icons <>
        ($Param{YearBack}, $Param{MonthBack}, $Param{DayBack}) = Add_Delta_YMD($Param{Year}, $Param{Month}, $Param{Day}, 0, 0, -1);
        ($Param{YearNext}, $Param{MonthNext}, $Param{DayNext}) = Add_Delta_YMD($Param{Year}, $Param{Month}, $Param{Day}, 0, 0, 1);

        $Param{DateSelection} = $Self->{LayoutObject}->BuildDateSelection(
            %Param,
            Prefix => '',
            Format => 'DateInputFormat',
        );

    # Show Working Units
        # get existing working units
        my %Data    = $Self->{TimeAccountingObject}->WorkingUnitsGet(
            Year   => $Param{Year},
            Month  => $Param{Month},
            Day    => $Param{Day},
            UserID => $Param{UserID},
        );

        $Param{Date} = sprintf("%04d-%02d-%02d", $Param{Year}, $Param{Month}, $Param{Day});

        # get project and action settings
        my %Project = $Self->{TimeAccountingObject}->ProjectSettingsGet();
        my %Action  = $Self->{TimeAccountingObject}->ActionSettingsGet();
        my $Flag = 0;

        foreach my $ID (keys %Data) {
            if ($Data{$ID}{ProjectID} && $Data{$ID}{ProjectID} == -1) {
                if ($Data{$ID}{ActionID}    == -1) {
                    $Param{Diseased} = 'checked';
                }
                elsif ($Data{$ID}{ActionID} == -2) {
                    $Param{LeaveDay} = 'checked';
                }
                elsif ($Data{$ID}{ActionID} == -3) {
                    $Param{Overtime} = 'checked';
                }
            }
            else {
                if (!$Flag) {
                    $Self->{LayoutObject}->Block(
                        Name => 'UnitBlock',
                    );
                }

                $Self->{LayoutObject}->Block(
                    Name => 'Unit',
                    Data => {
                        Project   => $Project{Project}{$Data{$ID}{ProjectID}},
                        Action    => $Action {$Data{$ID}{ActionID}}{Action},
                        Remark    => $Data{$ID}{Remark},
                        StartTime => $Data{$ID}{StartTime},
                        EndTime   => $Data{$ID}{EndTime},
                        Period    => $Data{$ID}{Period},
                    }
                );
                $Flag = 1;
                $Param{Total} += $Data{$ID}{Period};
            }
        }
        if ($Flag) {
            $Self->{LayoutObject}->Block(
                Name => 'Total',
                Data => {Total => sprintf ("%.2f", $Param{Total})}
            );
        }
        if ($Param{Diseased} || $Param{LeaveDay} || $Param{Overtime}) {
            $Self->{LayoutObject}->Block(
                Name => 'OtherTimes',
                Data => {
                    Diseased => $Param{Diseased},
                    LeaveDay => $Param{LeaveDay},
                    Overtime => $Param{Overtime},
                }
            );
        }

        my $Vacation = $Self->{TimeAccountingObject}->VacationCheck(
            Year  => $Param{Year},
            Month => $Param{Month},
            Day   => $Param{Day},
        );

        if ($Vacation) {
            $Self->{LayoutObject}->Block(
                Name => 'Vacation',
                Data => {Vacation => $Vacation},
            );
        }

        # presentation
        my $Output = $Self->{LayoutObject}->Header(Title => "View");
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
    elsif ($Self->{Subaction} eq 'Delete') {
        foreach (qw(Day Month Year)) {
            $Param{$_} = $Self->{ParamObject}->GetParam(Param => $_);
        }

        if (!$Self->{AccessRo}) {
            return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
        }

        if (!$Self->{TimeAccountingObject}->WorkingUnitsDelete(
            Year  => $Param{Year},
            Month => $Param{Month},
            Day   => $Param{Day},
        )) {
            return $Self->{LayoutObject}->ErrorScreen();
        }
        return $Self->{LayoutObject}->Redirect(OP => "Action=$Self->{Action}&Subaction=Edit&Year=$Param{Year}&Month=$Param{Month}&Day=$Param{Day}");
    }

    # ---------------------------------------------------------- #
    # overview about the users time accounting
    # ---------------------------------------------------------- #
    elsif ($Self->{Subaction} eq 'Overview') {
        my $Output   = '';
        my %Frontend = ();
        my ($Sec, $Min, $Hour, $CurrentDay, $Month, $Year) = $Self->{TimeObject}->SystemTime2Date(
            SystemTime => $Self->{TimeObject}->SystemTime(),
        );

        # permission check
        if (!$Self->{AccessRo}) {
            return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
        }


        foreach (qw(Status Day Month Year UserID ProjectStatusShow)) {
            $Param{$_} = $Self->{ParamObject}->GetParam(Param => $_);
        }
        $Param{Subaction} = 'Edit';

        if (!$Param{UserID}) {
            $Param{UserID} = $Self->{UserID};
        }
        else {
            $Param{Subaction} = 'View';
        }

        if ($Param{UserID} != $Self->{UserID}) {
            my %ShownUsers = $Self->{UserObject}->UserList(Type => 'Long', Valid => 1);
            $Param{User}   = $ShownUsers{$Param{UserID}};
            $Self->{LayoutObject}->Block(
                Name => 'User',
                Data => {%Param},
            );
        }

        # Check Date
        if (!$Param{Year} || !$Param{Month}) {
            $Param{Year}  = $Year;
            $Param{Month} = $Month;
        }
        else {
            $Param{Month} = sprintf("%02d", $Param{Month});
        }

        # store last screen
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'LastScreen',
            Value     => "Action=$Self->{Action}&Subaction=Overview&Year=$Param{Year}&Month=$Param{Month}",
        );


        $Param{Month_to_Text}   = $MonthArray[$Param{Month}];

        ($Param{YearBack}, $Param{MonthBack}, $Param{DayBack}) = Add_Delta_YMD($Param{Year}, $Param{Month}, 1, 0, -1, 0);
        ($Param{YearNext}, $Param{MonthNext}, $Param{DayNext}) = Add_Delta_YMD($Param{Year}, $Param{Month}, 1, 0, 1, 0);

        # Overview per day
        my $DaysOfMonth             = Days_in_Month($Param{Year},  $Param{Month});

        for (my $Day = 1; $Day <= $DaysOfMonth; $Day++) {
            $Param{Day}     = sprintf("%02d", $Day);
            $Param{Weekday} = Day_of_Week($Param{Year}, $Param{Month}, $Day)-1;
            my $VacationCheck = $Self->{TimeAccountingObject}->VacationCheck(
                Year  => $Param{Year},
                Month => $Param{Month},
                Day   => $Day,
            );

            if ($Param{Year} eq $Year && $Param{Month} eq $Month && $CurrentDay eq $Day){
                $Param{Style} = 'bgcolor="orange"';
            }
            elsif ($VacationCheck) {
                $Param{Style}   = 'bgcolor="#EBCCCC"';
                $Param{Comment} = $VacationCheck;
            }
            elsif ($Param{Weekday} == 6 || $Param{Weekday} == 5) {
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

            my $WorkingHours = 0;
            my %OtherTime    = ();
            $OtherTime{'-1'} = 'Diseased';
            $OtherTime{'-2'} = 'LeaveDay';
            $OtherTime{'-3'} = 'Overtime';

            foreach my $ID (keys %Data) {
                $WorkingHours += $Data{$ID}{Period};
                if ($Data{$ID}{ProjectID} == -1) {
                    $Param{Comment} = $OtherTime{$Data{$ID}{ActionID}};
                }
            }
            if ($WorkingHours) {
                $Param{WorkingHours} = sprintf ("%.2f", $WorkingHours);
            }
            else {
                $Param{WorkingHours} = '';
            }



            $Param{Weekday_to_Text} = $WeekdayArray[$Param{Weekday}];
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

        foreach (qw(TargetState TargetStateTotal WorkingHoursTotal WorkingHours
            Overtime OvertimeTotal OvertimeUntil LeaveDay LeaveDayTotal
            LeaveDayRemaining Diseased DiseasedTotal DiseasedRemaining)
        ) {
            if (!$UserReport{$Param{UserID}}{$_}) {
                $UserReport{$Param{UserID}}{$_} = 0;
            }
            $Param{$_} = sprintf ("%.2f", $UserReport{$Param{UserID}}{$_});
        }

        # Show Overtime if allowed
        my %UserBasics = $Self->{TimeAccountingObject}->UserGet();
        if ($UserBasics{$Param{UserID}}{ShowOvertime}) {
            $Self->{LayoutObject}->Block(
                Name => 'Overtime',
                Data => {%Param, %Frontend},
            );
        }

        # Overview per project and action
        my %ProjectData = $Self->{TimeAccountingObject}->ProjectActionReporting(
            Year   => $Param{Year},
            Month  => $Param{Month},
            UserID => $Param{UserID},
        );

        # show the report sort by projects
        if (!$Param{ProjectStatusShow} || $Param{ProjectStatusShow} eq 'valid') {
            $Param{ProjectStatusShow} = 'all';
        }
        elsif ($Param{ProjectStatusShow} eq 'all') {
            $Param{ProjectStatusShow} = 'valid';
        }


        my %Project     = $Self->{TimeAccountingObject}->ProjectSettingsGet();
        my %Action      = $Self->{TimeAccountingObject}->ActionSettingsGet();
        foreach my $ProjectID (sort {$Project{Project}{$a} cmp $Project{Project}{$b}} keys %{$Project{Project}}) {
            if ($ProjectData{Total}{$ProjectID}) {
                if ($ProjectID ne '-1') {
                    $Param{Project}= '';
                    $Param{Class}            = 'contentvalue';
                    if ($Project{ProjectStatus}{$ProjectID}) {
                        $Param{Status} = '';
                    }
                    else {
                        $Param{Status} = 'passiv';
                    }
                    my $Total      = 0;
                    my $TotalTotal = 0;

                    if (($Param{ProjectStatusShow} eq 'all' && !$Param{Status})
                        || $Param{ProjectStatusShow} eq 'valid'
                    ) {

                        # action sort wrapper - be careful its not simular with project!!
                        my %SortedActions = ();
                        foreach my $ActionID (keys %{$ProjectData{Total}{$ProjectID}}) {
                            $SortedActions{$ActionID} = $Action{$ActionID}{Action};
                            $Param{RowSpan}++;
                        }
                        foreach my $ActionID (sort {$SortedActions{$a} cmp $SortedActions{$b}} keys %SortedActions) {
                        #foreach my $ActionID (keys %{$ProjectData{Total}{$ProjectID}}) {

                            $Param{Action}     = $Action{$ActionID}{Action};
                            $Param{Hours}      = sprintf ("%.2f", $ProjectData{PerMonth}{$ProjectID}{$ActionID}{Hours} || 0);
                            $Param{HoursTotal} = sprintf ("%.2f", $ProjectData{Total}{$ProjectID}{$ActionID}{Hours}    || 0);
                            $Total      += $Param{Hours};
                            $TotalTotal += $Param{HoursTotal};
                            $Self->{LayoutObject}->Block(
                                Name => 'Action',
                                Data => {%Param, %Frontend},
                            );
                            if (!$Param{Project}) {
                                $Param{Project}            = $Project{Project}{$ProjectID};
                                $Param{ProjectDescription} = $Self->{LayoutObject}->Ascii2Html(
                                    Text           => $Project{ProjectDescription}{$ProjectID},
                                    HTMLResultMode => 1,
                                    NewLine        => 50,
                                );
                                $Param{RowSpan}++;
                                $Self->{LayoutObject}->Block(
                                    Name => 'Project',
                                    Data => {%Param, %Frontend},
                                );
                                if ($UserBasics{$Self->{UserID}}{CreateProject}) {
                                    # persons how are allowed to see the create object link are allowed to see the project reporting
                                    $Self->{LayoutObject}->Block(
                                        Name => 'ProjectLink',
                                        Data => {
                                            Project => $Param{Project},
                                            ProjectID => $ProjectID,
                                        },
                                    );
                                }
                                else {
                                    $Self->{LayoutObject}->Block(
                                        Name => 'ProjectNoLink',
                                        Data => {Project => $Param{Project}},
                                    );
                                }

                                $Param{RowSpan} = 0;
                            }
                        }
                        $Param{Class}            = 'contentkey';
                        $Param{Action}           = 'Total';
                        $Param{Hours}            = sprintf ("%.2f", $Total);
                        $Param{HoursTotal}       = sprintf ("%.2f", $TotalTotal);
                        $Param{TotalHours}      += $Total;
                        $Param{TotalHoursTotal} += $TotalTotal;
                        $Self->{LayoutObject}->Block(
                            Name => 'Action',
                            Data => {%Param, %Frontend},
                        );
                        $Param{Class} = '';
                    }
                }
            }
        }
        $Param{TotalHours}      = sprintf ("%.2f", $Param{TotalHours});
        $Param{TotalHoursTotal} = sprintf ("%.2f", $Param{TotalHoursTotal});

        # build output
        $Output  = $Self->{LayoutObject}->Header(Title => "Overview");
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            Data         => {%Param, %Frontend},
            TemplateFile => 'AgentTimeAccountingOverview'
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # ---------------------------------------------------------- #
    # settings for handling time accounting
    # ---------------------------------------------------------- #
    elsif ($Self->{Subaction} eq 'Setting') {
        my $Output      = '';
        my %Frontend    = ();
        my %Action      = ();
        my %StatusList  = ();
        my %User        = ();
        my %Data        = ();
        my %UserBasics  = ();

        foreach (qw(ActionAction ActionUser NewAction NewUser)) {
            $Param{$_} = $Self->{ParamObject}->GetParam(Param => $_);
        }


        # permission check
        if (!$Self->{AccessRw}) {
            return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
        }

        $Self->{LayoutObject}->Block(
            Name => 'Setting',
        );

        # store last screen
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'LastScreen',
            Value     => "Action=$Self->{Action}&Subaction=Setting",
        );

        if ($Param{ActionAction} || $Param{NewAction}) {
            %Action = $Self->{TimeAccountingObject}->ActionSettingsGet();
            my $ActionEmpty = 0;
            my %ActionCheck = ();
            foreach my $ActionID (keys %Action) {
                foreach (qw(Action ActionStatus)) {
                    $Data{$ActionID}{$_} = $Self->{ParamObject}->GetParam(Param => $_ . '[' . $ActionID . ']');
                }
                if (!$Data{$ActionID}{Action}) {
                    $ActionEmpty = 1;
                }
                if ($Data{$ActionID}{Action} && $ActionCheck{$Data{$ActionID}{Action}} == 1) {
                    return $Self->{LayoutObject}->ErrorScreen(Message => 'The actionnaming must be unique!');
                }
                else {
                    $ActionCheck{$Data{$ActionID}{Action}} = 1;
                }
            }
            if (!$Self->{TimeAccountingObject}->ActionSettingsUpdate(%Data)) {
                return $Self->{LayoutObject}->ErrorScreen(Message => 'Can\'t update action data!');
            }
            if ($Param{NewAction} && !$ActionEmpty) {
                if (!$Self->{TimeAccountingObject}->ActionSettingsInsert()) {
                    return $Self->{LayoutObject}->ErrorScreen(Message => 'Can\'t insert action data!');
                }
            }
        }
        else {
            %User = $Self->{TimeAccountingObject}->UserSettingsGet();
            my %LastPeriod = ();
            foreach my $UserID (keys %User) {
                $LastPeriod{$UserID} = 0;
                foreach my $Period (keys %{$User{$UserID}}) {
                    if ($LastPeriod{$UserID} < $Period) {
                        $LastPeriod{$UserID} = $Period;
                    }
                }
                if ($Self->{ParamObject}->GetParam(Param => 'NewUserSetting[' . $UserID . ']')) {
                    my %InsertData = ();
                    $InsertData{UserID}      = $UserID;
                    $InsertData{Period}      = $LastPeriod{$UserID} + 1;
                    $Param{ActionUser} = 'true';
                    if (!$Self->{TimeAccountingObject}->UserSettingsInsert(%InsertData)) {
                        return $Self->{LayoutObject}->ErrorScreen(Message => 'Can\'t insert user data!');
                    }
                }
            }
            if ($Param{ActionUser} || $Param{NewUser}) {
                %UserBasics = $Self->{TimeAccountingObject}->UserGet();
                foreach my $UserID (keys %User) {
                    foreach (qw(ShowOvertime CreateProject)) {
                        $Data{$UserID}{$_} = $Self->{ParamObject}->GetParam(Param => $_ . '[' . $UserID . ']');
                    }

                    my $Break = '';
                    if ($UserBasics{$UserID}{Description} && $Self->{ParamObject}->GetParam(Param => 'Description[' . $UserID . ']')) {
                        $Break = "\n";
                    }
                    $Data{$UserID}{Description} = $UserBasics{$UserID}{Description} . $Break . $Self->{ParamObject}->GetParam(Param => 'Description[' . $UserID . ']');

                    $Data{$UserID}{UserID} = $UserID;
                    foreach my $Period (keys %{$User{$UserID}}) {
                        foreach (qw(WeeklyHours LeaveDays UserStatus DateStart DateEnd Overtime)) {
                            $Data{$UserID}{$Period}{$_} = $Self->{ParamObject}->GetParam(Param => $_ . '[' . $UserID . '][' . $Period . ']');
                        }
                    $Data{$UserID}{$Period}{UserID} = $UserID;
                    $LastPeriod{$UserID} = $Period;
                    }
                }
                if (!$Self->{TimeAccountingObject}->UserSettingsUpdate(%Data)) {
                    return $Self->{LayoutObject}->ErrorScreen(Message => 'Can\'t update user data!');
                }

                if ($Param{NewUser} && $Self->{ParamObject}->GetParam(Param => 'NewUserID')) {
                    %Data = ();
                    $Data{UserID}      = $Self->{ParamObject}->GetParam(Param => 'NewUserID');
                    $Data{Period}      = '1';
                    if (!$Self->{TimeAccountingObject}->UserSettingsInsert(%Data)) {
                        return $Self->{LayoutObject}->ErrorScreen(Message => 'Can\'t insert user data!');
                    }
                    my %Groups = $Self->{GroupObject}->GroupList(Valid => 1);
                    foreach (keys %Groups) {
                        if ($Groups{$_} eq 'time_accounting') {

                            $Self->{GroupObject}->GroupMemberAdd(
                                GID => $_,
                                UID => $Data{UserID},
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
        $StatusList{1} = 'valid';
        $StatusList{0} = 'invalid';

        # Show action data
        %Action = $Self->{TimeAccountingObject}->ActionSettingsGet();
        my $ActionEmpty = 0;
        my %SortAction  = ();
        foreach my $ActionID (keys %Action) {
            $SortAction{$ActionID} = $Action{$ActionID}{Action};
        }
        foreach my $ActionID (sort {$SortAction{$a} cmp $SortAction{$b}} keys %SortAction) {
            $Param{Action}   = $Action{$ActionID}{Action};
            $Param{ActionID} = $ActionID;

            $Frontend{'StatusOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
                Data       => \%StatusList,
                SelectedID => $Action{$ActionID}{ActionStatus} || '',
                Name       => "ActionStatus[$Param{ActionID}]",
            );

            $Self->{LayoutObject}->Block(
                Name => 'Action',
                Data => {%Param, %Frontend},
            );
        }

        # Show user data
        %User = $Self->{TimeAccountingObject}->UserSettingsGet();
        %UserBasics = $Self->{TimeAccountingObject}->UserGet();
        my %ShownUsers = $Self->{UserObject}->UserList(Type => 'Long', Valid => 1);
        foreach my $UserID (sort {$ShownUsers{$a} cmp $ShownUsers{$b}} keys %ShownUsers) {
            if ($User{$UserID}) {
                $Param{User}        = $ShownUsers{$UserID};
                $Param{UserID}      = $UserID;

                my $Description = '';
                if ($UserBasics{$UserID}{Description}) {
                    $Description = $Self->{LayoutObject}->Ascii2Html(
                        Text           => $UserBasics{$UserID}{Description},
                        HTMLResultMode => 1,
                        NewLine        => 50,
                    ) . "<br>";
                }

                if ($UserBasics{$UserID}{ShowOvertime}) {
                    $UserBasics{$UserID}{ShowOvertime} = "checked";
                }
                if ($UserBasics{$UserID}{CreateProject}) {
                    $UserBasics{$UserID}{CreateProject} = "checked";
                }

                $Self->{LayoutObject}->Block(
                    Name => 'User',
                    Data => {%Param, %Frontend,
                        Description   => $Description,
                        ShowOvertime  => $UserBasics{$UserID}{ShowOvertime},
                        CreateProject => $UserBasics{$UserID}{CreateProject},
                    },
                );

                delete $ShownUsers{$UserID};

                foreach my $Period (sort keys %{$User{$UserID}}) {
                    $Param{WeeklyHours} = $User{$UserID}{$Period}{WeeklyHours};
                    $Param{LeaveDays}   = $User{$UserID}{$Period}{LeaveDays};
                    $Param{Overtime}    = $User{$UserID}{$Period}{Overtime};
                    $Param{DateStart}   = $User{$UserID}{$Period}{DateStart};
                    $Param{DateEnd}     = $User{$UserID}{$Period}{DateEnd};
                    $Param{Period}      = $Period;

                    $Frontend{'StatusOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
                        Data       => \%StatusList,
                        SelectedID => $User{$UserID}{$Period}{UserStatus} || '',
                        Name       => "UserStatus[$UserID][$Period]",
                    );

                    $Self->{LayoutObject}->Block(
                        Name => 'Period',
                        Data => {%Param, %Frontend},
                    );
                }
            }
        }

        if (%ShownUsers) {
            $ShownUsers{''} = '';
            $Frontend{'NewUserOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
                Data       => \%ShownUsers,
                SelectedID => '',
                Name       => "NewUserID",
            );
            $Self->{LayoutObject}->Block(
                Name => 'NewUserOption',
                Data => {%Param, %Frontend},
            );
         }

        # build output
        $Output  = $Self->{LayoutObject}->Header(Title => "Setting");
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            Data         => {%Param, %Frontend},
            TemplateFile => 'AgentTimeAccountingSetting'
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # ---------------------------------------------------------- #
    # settings for handling time accounting
    # ---------------------------------------------------------- #
    elsif ($Self->{Subaction} eq 'ProjectSetting') {
        my $Output     = '';
        my %Frontend   = ();
        my %Project    = ();
        my %StatusList = ();
        my %Data       = ();

        foreach (qw(ActionProject NewProject)) {
            $Param{$_} = $Self->{ParamObject}->GetParam(Param => $_);
        }

        # permission check
        if (!$Self->{AccessRo}) {
            return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
        }

        $Self->{LayoutObject}->Block(
            Name => 'ProjectSetting',
        );

        # Edit TimeAccounting Preferences
        if ($Param{ActionProject} || $Param{NewProject}) {
            %Project = $Self->{TimeAccountingObject}->ProjectSettingsGet();
            my $ProjectEmpty = 0;
            my %ProjectCheck = ();
            foreach my $ProjectID (keys %{$Project{Project}}) {
                foreach (qw(Project ProjectStatus ProjectDescription)) {
                    $Data{$ProjectID}{$_} = $Self->{ParamObject}->GetParam(Param => $_ . '[' . $ProjectID . ']');
                }
                if (!$Data{$ProjectID}{Project}) {
                    $ProjectEmpty = 1;
                }
                if ($Data{$ProjectID}{Project} && $ProjectCheck{$Data{$ProjectID}{Project}} == 1) {
                    return $Self->{LayoutObject}->ErrorScreen(
                        Message => 'The projectnaming must be unique!'
                    );
                }
                else {
                    $ProjectCheck{$Data{$ProjectID}{Project}} = 1;
                }
            }
            if (!$Self->{TimeAccountingObject}->ProjectSettingsUpdate(%Data)) {
                return $Self->{LayoutObject}->ErrorScreen(Message => 'Can\'t update project data!');
            }
            if ($Param{NewProject} && !$ProjectEmpty) {
                if (!$Self->{TimeAccountingObject}->ProjectSettingsInsert()) {
                    return $Self->{LayoutObject}->ErrorScreen(Message => 'Can\'t insert project data!');
                }
            }
        }

        # Show TimeAccounting Preferences
        $StatusList{1} = 'valid';
        $StatusList{0} = 'invalid';

        # Show project data
        %Project = $Self->{TimeAccountingObject}->ProjectSettingsGet();
        my $ProjectEmpty = 0;
        foreach my $ProjectID (sort {$Project{Project}{$a} cmp $Project{Project}{$b}} keys %{$Project{Project}}) {

            $Param{Project}            = $Project{Project}{$ProjectID};
            $Param{ProjectDescription} = $Project{ProjectDescription}{$ProjectID};
            $Param{ProjectID}          = $ProjectID;

            $Frontend{'StatusOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
                Data       => \%StatusList,
                SelectedID => $Project{ProjectStatus}{$ProjectID} || '',
                Name       => "ProjectStatus[$Param{ProjectID}]",
            );


            $Self->{LayoutObject}->Block(
                Name => 'Project',
                Data => {%Param, %Frontend},
            );
        }

        # build output
        $Output  = $Self->{LayoutObject}->Header(Title => "Setting");
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            Data         => {%Param, %Frontend},
            TemplateFile => 'AgentTimeAccountingSetting'
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # ---------------------------------------------------------- #
    # time accounting reporting
    # ---------------------------------------------------------- #
    elsif ($Self->{Subaction} eq 'Reporting') {
        my $Output   = '';
        my %Frontend = ();
        my %ShownUsers = $Self->{UserObject}->UserList(Type => 'Long', Valid => 0);
        my ($Sec, $Min, $Hour, $CurrentDay, $Month, $Year) = $Self->{TimeObject}->SystemTime2Date(
            SystemTime => $Self->{TimeObject}->SystemTime(),
        );

        # permission check
        if (!$Self->{AccessRw}) {
            return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
        }

        foreach (qw(Status Month Year ProjectStatusShow)) {
            $Param{$_} = $Self->{ParamObject}->GetParam(Param => $_);
        }

        # Check Date
        if (!$Param{Year} || !$Param{Month}) {
            $Param{Year}  = $Year;
            $Param{Month} = $Month;
        }
        else {
            $Param{Month} = sprintf("%02d", $Param{Month});
        }

        # store last screen
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'LastScreen',
            Value     => "Action=$Self->{Action}&Subaction=Reporting&Year=$Param{Year}&Month=$Param{Month}",
        );

        $Param{Month_to_Text}   = $MonthArray[$Param{Month}];

        my %Month = ();
        for (my $ID = 1; $ID <= 12; $ID++) {
            $Month{sprintf("%02d",$ID)}{'Value'}    = $MonthArray[$ID];
            $Month{sprintf("%02d",$ID)}{'Position'} = $ID;
            if ($Param{Month} == $ID) {
                $Month{sprintf("%02d",$ID)}{'Selected'} = 1;
            }
        }

        $Frontend{'MonthOption'} = $Self->{LayoutObject}->OptionElement(
            Data       => \%Month,
            Name       => "Month",
        );

        my %Year = ();
        for (my $ID = 2005; $ID <= 2006; $ID++) {
            $Year{$ID} = $ID;
        }
        $Frontend{'YearOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data       => \%Year,
            SelectedID => $Param{Year} || '',
            Name       => "Year",
        );

        ($Param{YearBack}, $Param{MonthBack}, $Param{DayBack}) = Add_Delta_YMD($Param{Year}, $Param{Month}, 1, 0, -1, 0);
        ($Param{YearNext}, $Param{MonthNext}, $Param{DayNext}) = Add_Delta_YMD($Param{Year}, $Param{Month}, 1, 0, 1, 0);

        my %UserReport        = $Self->{TimeAccountingObject}->UserReporting(
            Year   => $Param{Year},
            Month  => $Param{Month},
            UserID => $Param{UserID},
        );

        my %UserBasics = $Self->{TimeAccountingObject}->UserGet();
        foreach my $UserID (sort {$ShownUsers{$a} cmp $ShownUsers{$b}} keys %ShownUsers) {
            if ($UserReport{$UserID}) {
                foreach (qw(LeaveDay Overtime WorkingHours Diseased LeaveDayRemaining OvertimeTotal)) {
                    $Param{$_} = sprintf ("%.2f", $UserReport{$UserID}{$_});
                    $Param{'Total' . $_} += $Param{$_};
                }

                # Show Overtime if allowed
                if (!$UserBasics{$UserID}{ShowOvertime}) {
                    $Param{Overtime}      = '';
                    $Param{OvertimeTotal} = '';
                }

                $Param{User}   = $ShownUsers{$UserID};
                $Param{UserID} = $UserID;
                $Self->{LayoutObject}->Block(
                    Name => 'User',
                    Data => {%Param, %Frontend},
                );
            }
        }
        foreach (qw(TotalLeaveDay TotalOvertime TotalWorkingHours
            TotalDiseased TotalLeaveDayRemaining TotalOvertimeTotal)
        ) {
            $Param{$_} = sprintf ("%.2f", $Param{$_});
        }

        # show the report sort by projects
        if (!$Param{ProjectStatusShow} || $Param{ProjectStatusShow} eq 'valid') {
            $Param{ProjectStatusShow} = 'all';
        }
        elsif ($Param{ProjectStatusShow} eq 'all') {
            $Param{ProjectStatusShow} = 'valid';
        }


        my %ProjectData = $Self->{TimeAccountingObject}->ProjectActionReporting(
            Year  => $Param{Year},
            Month => $Param{Month},
        );

        my %Project     = $Self->{TimeAccountingObject}->ProjectSettingsGet();
        my %Action      = $Self->{TimeAccountingObject}->ActionSettingsGet();
        foreach my $ProjectID (sort {$Project{Project}{$a} cmp $Project{Project}{$b}} keys %{$Project{Project}}) {
            if ($ProjectData{Total}{$ProjectID}) {
                if ($ProjectID ne '-1') {
                    $Param{Project}= '';
                    $Param{Class}            = 'contentvalue';
                    if ($Project{ProjectStatus}{$ProjectID}) {
                        $Param{Status} = '';
                    }
                    else {
                        $Param{Status} = 'passiv';
                    }
                    my $Total      = 0;
                    my $TotalTotal = 0;

                    if (($Param{ProjectStatusShow} eq 'all' && !$Param{Status})
                        || $Param{ProjectStatusShow} eq 'valid'
                    ) {
                        # action sort wrapper - be careful its not simular with project!!
                        my %SortedActions = ();
                        foreach my $ActionID (keys %{$ProjectData{Total}{$ProjectID}}) {
                            $SortedActions{$ActionID} = $Action{$ActionID}{Action};
                            $Param{RowSpan}++;
                        }
                        foreach my $ActionID (sort {$SortedActions{$a} cmp $SortedActions{$b}} keys %SortedActions) {
                        #foreach my $ActionID (keys %{$ProjectData{Total}{$ProjectID}}) {
                            $Param{Action}     = $Action{$ActionID}{Action};
                            $Param{Hours}      = sprintf ("%.2f", $ProjectData{PerMonth}{$ProjectID}{$ActionID}{Hours} || 0);
                            $Param{HoursTotal} = sprintf ("%.2f", $ProjectData{Total}   {$ProjectID}{$ActionID}{Hours}    || 0);
                            $Total      += $Param{Hours};
                            $TotalTotal += $Param{HoursTotal};

                            $Self->{LayoutObject}->Block(
                                Name => 'Action',
                                Data => {%Param, %Frontend},
                            );
                            if (!$Param{Project}) {
                                $Param{Project}            = $Project{Project}{$ProjectID};
                                $Param{ProjectID}          = $ProjectID;
                                $Param{ProjectDescription} = $Self->{LayoutObject}->Ascii2Html(
                                    Text           => $Project{ProjectDescription}{$ProjectID},
                                    HTMLResultMode => 1,
                                    NewLine        => 50,
                                );
                                $Param{RowSpan}++;
                                $Self->{LayoutObject}->Block(
                                    Name => 'Project',
                                    Data => {%Param, %Frontend},
                                );
                                $Param{RowSpan} = 0;
                            }
                        }

                        $Param{Class}            = 'contentkey';
                        $Param{Action}           = 'Total';
                        $Param{Hours}            = sprintf ("%.2f", $Total);
                        $Param{HoursTotal}       = sprintf ("%.2f", $TotalTotal);
                        $Param{TotalHours}      += $Total;
                        $Param{TotalHoursTotal} += $TotalTotal;
                        $Self->{LayoutObject}->Block(
                            Name => 'Action',
                            Data => {%Param, %Frontend},
                        );
                    }
                }
            }
        }
        $Param{TotalHours}      = sprintf ("%.2f", $Param{TotalHours});
        $Param{TotalHoursTotal} = sprintf ("%.2f", $Param{TotalHoursTotal});
        # build output
        $Output .= $Self->{LayoutObject}->Header(Title => "Reporting");
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            Data         => {%Param, %Frontend},
            TemplateFile => 'AgentTimeAccountingReporting'
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # ---------------------------------------------------------- #
    # time accounting project reporting
    # ---------------------------------------------------------- #
    elsif ($Self->{Subaction} eq 'ProjectReporting') {
        my $Output   = '';
        my %Frontend = ();

        # permission check
        if (!$Self->{AccessRo}) {
            return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
        }

        # get params
        foreach (qw(ProjectID)) {
            $Param{$_} = $Self->{ParamObject}->GetParam(Param => $_);
        }

        # check needed params
        foreach (qw(ProjectID)) {
            if (!$Param{$_}) {
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "ProjectReporting: Need $_"
                );
            }
        }

        my %Action      = $Self->{TimeAccountingObject}->ActionSettingsGet();
        my %Project     = $Self->{TimeAccountingObject}->ProjectSettingsGet();
        $Param{Project} = $Project{Project}{$Param{ProjectID}};

        my %ShownUsers = $Self->{UserObject}->UserList(Type => 'Long', Valid => 0);
        # necassary because the ProjectActionReporting is not reworked
        my ($Sec, $Min, $Hour, $CurrentDay, $Month, $Year) = $Self->{TimeObject}->SystemTime2Date(
            SystemTime => $Self->{TimeObject}->SystemTime(),
        );
        my %ProjectData = ();
        my %ProjectTime     = ();

        # Only one function should be enough
        foreach my $UserID (keys %ShownUsers) {
            # Overview per project and action
            %ProjectData = $Self->{TimeAccountingObject}->ProjectActionReporting(
                Year   => $Year,
                Month  => $Month,
                UserID => $UserID,
            );
            if ($ProjectData{Total}{$Param{ProjectID}}) {
                foreach my $ActionID (keys %{$ProjectData{Total}{$Param{ProjectID}}}) {
                    $ProjectTime{$ActionID}{$UserID} = $ProjectData{Total}{$Param{ProjectID}}{$ActionID};
                }
            }
            else {
                delete ($ShownUsers{$UserID});
            }
        }

        # show the headerline
        foreach my $UserID (sort {$ShownUsers{$a} cmp $ShownUsers{$b}} keys %ShownUsers) {
            $Self->{LayoutObject}->Block(
                 Name => 'UserName',
                 Data => {User => $ShownUsers{$UserID}},
            );
        }

        # better solution for sort actions necessary
        my %NewAction = ();
        foreach my $ActionID (keys %ProjectTime) {
            $NewAction{$ActionID} = $Action{$ActionID}{Action};
        }
        %Action = %NewAction;

        # show the results
        my %Total = ();
        foreach my $ActionID (sort {$Action{$a} cmp $Action{$b}} keys %Action) {
            my $TotalHours = 0;
            $Self->{LayoutObject}->Block(
                 Name => 'Action',
                 Data => {
                     Action => $Action{$ActionID},
                 },
            );

            foreach my $UserID (sort {$ShownUsers{$a} cmp $ShownUsers{$b}} keys %ShownUsers) {
                $TotalHours += $ProjectTime{$ActionID}{$UserID}{Hours};
                $Total{$UserID} += $ProjectTime{$ActionID}{$UserID}{Hours};
                $Self->{LayoutObject}->Block(
                    Name => 'User',
                    Data => {
                        Hours => sprintf ("%.2f", $ProjectTime{$ActionID}{$UserID}{Hours} || 0),
                    },
                );
            }
            # Total
            $Self->{LayoutObject}->Block(
                Name => 'User',
                Data => {
                    Hours => sprintf ("%.2f", $TotalHours),
                },
            );
        }
        $Param{TotalAll} = 0;
        foreach my $UserID (sort {$ShownUsers{$a} cmp $ShownUsers{$b}} keys %ShownUsers) {
            $Param{TotalAll} += $Total{$UserID};
            $Self->{LayoutObject}->Block(
                 Name => 'UserTotal',
                 Data => {
                     Total => sprintf ("%.2f", $Total{$UserID}),
                 },
            );
        }

        $Param{TotalAll} = sprintf ("%.2f", $Param{TotalAll});

        # build output
        $Output .= $Self->{LayoutObject}->Header(Title => "ProjectReporting");
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            Data         => {%Param, %Frontend},
            TemplateFile => 'AgentTimeAccountingProjectReporting'
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # ---------------------------------------------------------- #
    # show error screen
    # ---------------------------------------------------------- #
    return $Self->{LayoutObject}->ErrorScreen(Message => "Invalid Subaction process!");
}
# --
1;
