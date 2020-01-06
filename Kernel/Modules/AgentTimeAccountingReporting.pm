# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AgentTimeAccountingReporting;

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

    # get needed objects
    my $LayoutObject          = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject           = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $TimeAccountingObject  = $Kernel::OM->Get('Kernel::System::TimeAccounting');
    my $DateTimeObjectCurrent = $Kernel::OM->Create('Kernel::System::DateTime');
    my $UserObject            = $Kernel::OM->Get('Kernel::System::User');

    # ---------------------------------------------------------- #
    # time accounting project reporting
    # ---------------------------------------------------------- #
    if ( $Self->{Subaction} eq 'ReportingProject' ) {

        my $Config = $Kernel::OM->Get('Kernel::Config')->Get("TimeAccounting::Frontend::$Self->{Subaction}");

        my %Frontend = ();

        # permission check
        if ( !$Self->{AccessRo} ) {
            return $LayoutObject->NoPermission(
                WithHeader => 'yes',
            );
        }

        # get params
        $Param{ProjectID} = $ParamObject->GetParam( Param => 'ProjectID' );

        # check needed params
        if ( !$Param{ProjectID} ) {

            return $LayoutObject->ErrorScreen(
                Message => Translatable('ReportingProject: Need ProjectID')
            );
        }

        my %Action  = $TimeAccountingObject->ActionSettingsGet();
        my %Project = $TimeAccountingObject->ProjectSettingsGet();
        $Param{Project} = $Project{Project}->{ $Param{ProjectID} };

        # get system users
        my %ShownUsers = $UserObject->UserList(
            Type  => 'Long',
            Valid => 0
        );

        $Param{ShowOnlyActiveUsers} = $Config->{ShowOnlyActiveUsers};

        if ( $Param{ShowOnlyActiveUsers} ) {

            # get registered users
            my %RegisteredUsers = $TimeAccountingObject->UserList();

            # reduce shown users to only the ones that are registered in time accounting
            %ShownUsers = map { $_ => $ShownUsers{$_} } keys %RegisteredUsers;
        }

        # necessary because the ProjectActionReporting is not reworked
        my ( $Sec, $Min, $Hour, $CurrentDay, $Month, $Year ) = $TimeAccountingObject->SystemTime2Date(
            SystemTime => $DateTimeObjectCurrent->ToEpoch(),
        );
        my %ProjectData = ();
        my %ProjectTime = ();

        my @UserWhiteList;

        # Only one function should be enough
        for my $UserID ( sort keys %ShownUsers ) {

            # Overview per project and action
            # REMARK: This is the wrong function to get this information
            %ProjectData = $TimeAccountingObject->ProjectActionReporting(
                Year   => $Year,
                Month  => $Month,
                UserID => $UserID,
            );
            if ( $ProjectData{ $Param{ProjectID} } ) {
                my $UserTotalHoursInProject;
                my $ActionsRef = $ProjectData{ $Param{ProjectID} }->{Actions};
                for my $ActionID ( sort keys %{$ActionsRef} ) {
                    $ProjectTime{$ActionID}->{$UserID}->{Hours} = $ActionsRef->{$ActionID}->{Total};

                    # remember the sum of all hours of all tasks
                    $UserTotalHoursInProject += $ActionsRef->{$ActionID}->{Total} || 0;
                }

                # remember only the users that has been added hours to this project
                if ( defined $UserTotalHoursInProject && $UserTotalHoursInProject > 0 ) {
                    push @UserWhiteList, $UserID;
                }
            }
        }

        if ( $Param{ShowOnlyActiveUsers} ) {

            # reduce shown users to only the ones that are active in the project (by adding hours)
            %ShownUsers = map { $_ => $ShownUsers{$_} } @UserWhiteList;
        }

        if ( !IsHashRefWithData( \%ShownUsers ) ) {
            $LayoutObject->Block(
                Name => 'NoUserDataFoundMsg',
                Data => {},
            );
        }
        else {
            $LayoutObject->Block(
                Name => 'UserTable',
                Data => {},
            );

            # show the header line
            for my $UserID ( sort { $ShownUsers{$a} cmp $ShownUsers{$b} } keys %ShownUsers ) {
                $LayoutObject->Block(
                    Name => 'UserName',
                    Data => { User => $ShownUsers{$UserID} },
                );
            }

            # better solution for sort actions necessary
            my %NewAction = ();
            for my $ActionID ( sort keys %ProjectTime ) {
                $NewAction{$ActionID} = $Action{$ActionID}->{Action};
            }
            %Action = %NewAction;

            # show the results
            my %Total = ();
            for my $ActionID ( sort { $Action{$a} cmp $Action{$b} } keys %Action ) {
                my $TotalHours = 0;
                $LayoutObject->Block(
                    Name => 'Action',
                    Data => {
                        Action => $Action{$ActionID},
                    },
                );
                for my $UserID ( sort { $ShownUsers{$a} cmp $ShownUsers{$b} } keys %ShownUsers ) {
                    $TotalHours     += $ProjectTime{$ActionID}{$UserID}{Hours} || 0;
                    $Total{$UserID} += $ProjectTime{$ActionID}{$UserID}{Hours} || 0;
                    $LayoutObject->Block(
                        Name => 'User',
                        Data => {
                            Hours =>
                                sprintf( "%.2f", $ProjectTime{$ActionID}{$UserID}{Hours} || 0 ),
                        },
                    );
                }

                # Total
                $LayoutObject->Block(
                    Name => 'User',
                    Data => {
                        Hours => sprintf( "%.2f", $TotalHours ),
                    },
                );
            }
            $Param{TotalAll} = 0;
            for my $UserID ( sort { $ShownUsers{$a} cmp $ShownUsers{$b} } keys %ShownUsers ) {
                $Param{TotalAll} += $Total{$UserID};
                $LayoutObject->Block(
                    Name => 'UserTotal',
                    Data => {
                        Total => sprintf( "%.2f", $Total{$UserID} ),
                    },
                );
            }

            $LayoutObject->Block(
                Name => 'UserTotalAll',
                Data => {
                    TotalAll => sprintf( "%.2f", $Param{TotalAll} ),
                },
            );
        }
        my @ProjectHistoryArray = $TimeAccountingObject->ProjectHistory(
            ProjectID => $Param{ProjectID},
        );

        if ( !IsArrayRefWithData( \@ProjectHistoryArray ) ) {
            $LayoutObject->Block(
                Name => 'NoProjectDataFoundMsg',
                Data => {},
            );
        }
        else {
            $LayoutObject->Block(
                Name => 'ProjectTable',
                Data => {
                    %Param,
                    %Frontend
                },
            );

            for my $Row (@ProjectHistoryArray) {
                $LayoutObject->Block(
                    Name => 'Row',
                    Data => {
                        User   => $Row->{User},
                        Action => $Row->{Action},
                        Remark => $Row->{Remark} || '--',
                        Period => sprintf( "%.2f", $Row->{Period} ),
                        Date   => $Row->{Date},
                    },
                );
            }

            # show the total sum of hours at the end of the history list
            # I also can use $Param{TotalAll}
            my $ProjectTotalHours = sprintf(
                "%.2f",
                $TimeAccountingObject->ProjectTotalHours(
                    ProjectID => $Param{ProjectID},
                )
            );

            $LayoutObject->Block(
                Name => 'HistoryTotal',
                Data => {
                    HistoryTotal => $ProjectTotalHours || 0,
                },
            );
        }

        # build output
        my $Output = $LayoutObject->Header(
            Title => Translatable('Reporting Project'),
        );
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $LayoutObject->Output(
            Data => {
                %Param,
                %Frontend,
            },
            TemplateFile => 'AgentTimeAccountingReportingProject',
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # ---------------------------------------------------------- #
    # time accounting reporting
    # ---------------------------------------------------------- #
    my %Frontend   = ();
    my %ShownUsers = $UserObject->UserList(
        Type  => 'Long',
        Valid => 0
    );
    my ( $Sec, $Min, $Hour, $CurrentDay, $Month, $Year ) = $TimeAccountingObject->SystemTime2Date(
        SystemTime => $DateTimeObjectCurrent->ToEpoch(),
    );

    # permission check
    if ( !$Self->{AccessRw} ) {
        return $LayoutObject->NoPermission(
            WithHeader => 'yes',
        );
    }

    for my $Parameter (qw(Status Month Year ProjectStatusShow)) {
        $Param{$Parameter} = $ParamObject->GetParam( Param => $Parameter );
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

    my %Month = ();
    for my $ID ( 1 .. 12 ) {
        $Month{ sprintf( "%02d", $ID ) } = $MonthArray[$ID];
    }

    $Frontend{MonthOption} = $LayoutObject->BuildSelection(
        Data        => \%Month,
        SelectedID  => $Param{Month} || '',
        Name        => 'Month',
        Sort        => 'NumericKey',
        Translation => 1,
        Title       => $LayoutObject->{LanguageObject}->Translate("Month"),
    );

    my @Year = ( $Year - 4 .. $Year + 1 );

    $Frontend{YearOption} = $LayoutObject->BuildSelection(
        Data        => \@Year,
        SelectedID  => $Param{Year} || '',
        Name        => 'Year',
        Translation => 0,
        Title       => $LayoutObject->{LanguageObject}->Translate("Year"),
    );

    ( $Param{YearBack}, $Param{MonthBack}, $Param{DayBack} )
        = $TimeAccountingObject->AddDeltaYMD( $Param{Year}, $Param{Month}, 1, 0, -1, 0 );
    ( $Param{YearNext}, $Param{MonthNext}, $Param{DayNext} )
        = $TimeAccountingObject->AddDeltaYMD( $Param{Year}, $Param{Month}, 1, 0, 1, 0 );

    my %UserReport = $TimeAccountingObject->UserReporting(
        Year   => $Param{Year},
        Month  => $Param{Month},
        UserID => $Param{UserID},
    );

    my %UserBasics = $TimeAccountingObject->UserList();

    if ( !IsHashRefWithData( \%ShownUsers ) || !IsHashRefWithData( \%UserReport ) ) {
        $LayoutObject->Block(
            Name => 'NoUserDataFoundMsg',
            Data => {},
        );
    }
    else {

        $LayoutObject->Block(
            Name => 'UserTable',
            Data => { %Param, %Frontend },
        );

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
            $LayoutObject->Block(
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

        $LayoutObject->Block(
            Name => 'UserGrandTotal',
            Data => {%Param},
        );
    }

    # show the report sort by projects
    if ( !$Param{ProjectStatusShow} || $Param{ProjectStatusShow} eq 'valid' ) {
        $Param{ProjectStatusShow} = 'all';
    }
    elsif ( $Param{ProjectStatusShow} eq 'all' ) {
        $Param{ProjectStatusShow} = 'valid';
    }

    $Param{ShowProjects} = 'Show ' . $Param{ProjectStatusShow} . ' projects';

    my %ProjectData = $TimeAccountingObject->ProjectActionReporting(
        Year  => $Param{Year},
        Month => $Param{Month},
    );

    if ( !IsHashRefWithData( \%ProjectData ) ) {
        $LayoutObject->Block(
            Name => 'NoProjectDataFoundMsg',
            Data => {},
        );
        $Param{ProjectStatusLinkClass} = 'Hidden';
    }
    else {
        $LayoutObject->Block(
            Name => 'ProjectTable',
            Data => { %Param, %Frontend },
        );

        # REMARK: merge this project reporting list with the list in overview
        PROJECTID:
        for my $ProjectID (
            sort { $ProjectData{$a}->{Name} cmp $ProjectData{$b}->{Name} }
            keys %ProjectData
            )
        {
            my $ProjectRef = $ProjectData{$ProjectID};
            my $ActionsRef = $ProjectRef->{Actions};

            $Param{Project} = '';
            $Param{Status}  = $ProjectRef->{Status} ? '' : 'passiv';

            my $Total      = 0;
            my $TotalTotal = 0;

            next PROJECTID if $Param{ProjectStatusShow} eq 'all' && $Param{Status};

            for my $ActionID (
                sort { $ActionsRef->{$a}->{Name} cmp $ActionsRef->{$b}->{Name} }
                keys %{$ActionsRef}
                )
            {
                my $ActionRef = $ActionsRef->{$ActionID};

                $Param{ProjectID}  = $ProjectID;
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
            $LayoutObject->Block(
                Name => 'ActionTotal',
                Data => { %Param, %Frontend },
            );
        }

        $Param{TotalHours}      ||= 0;
        $Param{TotalHoursTotal} ||= 0;

        $Param{TotalHours}      = sprintf( "%.2f", $Param{TotalHours} );
        $Param{TotalHoursTotal} = sprintf( "%.2f", $Param{TotalHoursTotal} );

        $LayoutObject->Block(
            Name => 'ProjectGrandTotal',
            Data => { %Param, %Frontend },
        );
    }

    # build output
    my $Output = $LayoutObject->Header(
        Title => Translatable('Reporting'),
    );
    $Output .= $LayoutObject->NavigationBar();
    $Output .= $LayoutObject->Output(
        Data         => { %Param, %Frontend },
        TemplateFile => 'AgentTimeAccountingReporting'
    );
    $Output .= $LayoutObject->Footer();

    return $Output;
}

1;
