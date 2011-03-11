# --
# Kernel/System/Stats/Dynamic/TimeAccounting.pm - all advice functions
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: TimeAccounting.pm,v 1.2 2011-03-11 09:11:06 mab Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Stats::Dynamic::TimeAccounting;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

use Kernel::System::TimeAccounting;
use Date::Pcalc qw( Add_Delta_Days Add_Delta_YMD );

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (
        qw(DBObject ConfigObject LogObject UserObject TimeObject MainObject EncodeObject)
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    # create additional needed objects
    $Self->{TimeAccountingObject} = Kernel::System::TimeAccounting->new(
        %{$Self},
        UserID => 1,
    );

    return $Self;
}

sub GetObjectName {
    my ( $Self, %Param ) = @_;

    return 'TimeAccounting';
}

sub GetObjectAttributes {
    my ( $Self, %Param ) = @_;

    # set predefined start time
    my $TimeStamp = $Self->{TimeObject}->CurrentTimestamp();
    my ($Date) = split /\s+/, $TimeStamp;
    my $Today = sprintf "%s 23:59:59", $Date;

    # get project list
    my %ProjectList = $Self->{TimeAccountingObject}->ProjectSettingsGet(
        Status => 'valid',
    );

    # get action list
    my %ActionListSource = $Self->{TimeAccountingObject}->ActionSettingsGet();
    my %ActionList;

    for my $Action ( keys %ActionListSource ) {
        $ActionList{$Action} = $ActionListSource{$Action}->{Action};
    }

    # get user list
    my %UserList = $Self->{UserObject}->UserList(
        Type  => 'Long',
        Valid => 0,
    );

    my @Attributes = (
        {
            Name             => 'Project',
            UseAsXvalue      => 1,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'Project',
            Block            => 'MultiSelectField',
            Translation      => 0,
            Values           => $ProjectList{Project},
        },
        {
            Name             => 'User',
            UseAsXvalue      => 1,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'User',
            Block            => 'MultiSelectField',
            Translation      => 0,
            Values           => \%UserList,
        },
        {
            Name             => 'Sort sequence',
            UseAsXvalue      => 0,
            UseAsValueSeries => 1,
            UseAsRestriction => 0,
            Element          => 'SortSequence',
            Block            => 'SelectField',
            Translation      => 0,
            Values           => {
                Up   => 'ascending',
                Down => 'descending',
            },
        },
        {
            Name             => 'Task',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'ProjectAction',
            Block            => 'MultiSelectField',
            Translation      => 0,
            Values           => \%ActionList,
        },
        {
            Name             => 'Period',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'Period',
            TimePeriodFormat => 'DateInputFormat',    # 'DateInputFormatLong',
            Block            => 'Time',
            Values           => {
                TimeStart => 'TimeAccountingPeriodStart',
                TimeStop  => 'TimeAccountingPeriodStop',
            },
        },
    );

    return @Attributes;
}

sub GetStatTable {
    my ( $Self, %Param ) = @_;
    my @StatArray;
    my @UserIDs;

    # Users as X-value
    if ( $Param{XValue}{Element} && $Param{XValue}{Element} eq 'User' ) {

        # user have been selected as x-value
        @UserIDs = @{ $Param{XValue}{SelectedValues} };

        # get stat data
        my $StatData = $Self->_GetStatData(
            Param   => \%Param,
            UserIDs => \@UserIDs,
        );

        # check stat data
        return if !$StatData;
        return if ref $StatData ne 'ARRAY';

        my @RawStatArray = @{$StatData};
        return if !@RawStatArray;

        # get list of needed data
        my %ProjectData = $Self->{TimeAccountingObject}->ProjectSettingsGet();
        my %ProjectList = %{ $ProjectData{Project} || {} };

        my %ActionData = $Self->{TimeAccountingObject}->ActionSettingsGet();
        my %ActionList = map { ( $_ => $ActionData{$_}->{Action} ) } keys %ActionData;

        my @SortedProjectIDs = sort { $ProjectList{$a} cmp $ProjectList{$b} } keys %ProjectList;
        my @SortedActionIDs  = sort { $ActionList{$a} cmp $ActionList{$b} } keys %ActionList;

        # re-sort projects depending on selected sequence
        if ( $Param{ValueSeries} && $Param{ValueSeries}[0]{SelectedValues}[0] eq 'Down' ) {
            @SortedProjectIDs = reverse @SortedProjectIDs;
        }

        # iterate over sorted project list
        SORTEDPROJECTID:
        for my $SortedProjectID (@SortedProjectIDs) {

            # check for unselected projects
            next SORTEDPROJECTID if $Param{Restrictions}->{Project} && !grep {
                $_ == $SortedProjectID
            } @{ $Param{Restrictions}->{Project} || [] };

            # get the current project data of current project
            my @ProjectStatData = grep { $_->{ProjectID} == $SortedProjectID } @RawStatArray;

            # iterate over sorted action list
            SORTEDACTIONID:
            for my $SortedActionID (@SortedActionIDs) {

                # check for unselected actions
                next SORTEDACTIONID if $Param{Restrictions}->{ProjectAction} && !grep {
                    $_ == $SortedActionID
                } @{ $Param{Restrictions}->{ProjectAction} || [] };

                # get the current action out of the current project
                my @ActionStatData = grep { $_->{ActionID} == $SortedActionID } @ProjectStatData;

                my @RowData;

                # add descriptive first column
                my $RowLabel = "$ProjectList{$SortedProjectID}::$ActionList{$SortedActionID}";
                push @RowData, $RowLabel;

                # iterate over selected users
                USERID:
                for my $UserID (@UserIDs) {

                    # at least get '0' for user data
                    my $UserPeriodSum = 0;

                    # iterate over period data of user
                    for my $PeriodData ( grep { $_->{UserID} == $UserID } @ActionStatData ) {
                        $UserPeriodSum += $PeriodData->{Period};
                    }

                    # safe user data to row data
                    push @RowData, $UserPeriodSum;
                }

                # store current row to global stat array
                push @StatArray, \@RowData;
            }
        }
    }

    # Projects as X-value
    else {

        # projects have been selected as x-value
        my @ProjectIDs = @{ $Param{XValue}{SelectedValues} };

        # we need to get all users
        my %UserIDs = $Self->{UserObject}->UserList(
            Type  => 'Short',
            Valid => 1,
        );

        @UserIDs = keys %UserIDs;

        # get calculated stats data
        my $StatData = $Self->_GetStatData(
            Param   => \%Param,
            UserIDs => \@UserIDs,
        );

        # check stat data
        return if !$StatData;
        return if ref $StatData ne 'ARRAY';

        my @RawStatArray = @{$StatData};
        return if !@RawStatArray;

        # get list of needed data
        my %UserList = $Self->{UserObject}->UserList(
            Type  => 'Long',
            Valid => 1,
        );

        my @SortedUserIDs = sort { $UserList{$a} cmp $UserList{$b} } keys %UserList;

        # re-sort users depending on selected sequence
        if ( $Param{ValueSeries} && $Param{ValueSeries}[0]{SelectedValues}[0] eq 'Down' ) {
            @SortedUserIDs = reverse @SortedUserIDs;
        }

        # iterate over sorted user list
        SORTEDUSERID:
        for my $SortedUserID (@SortedUserIDs) {

            # check for unselected users
            next SORTEDUSERID if $Param{Restrictions}->{User} && !grep {
                $_ == $SortedUserID
            } @{ $Param{Restrictions}->{User} || [] };

            # get the current user data of current user
            my @UserStatData = grep { $_->{UserID} == $SortedUserID } @RawStatArray;

            my @RowData;

            # add descriptive first column
            my $RowLabel = $UserList{$SortedUserID};
            push @RowData, $RowLabel;

            # iterate over selected projects
            PROJECTID:
            for my $ProjectID (@ProjectIDs) {

                # at least get '0' for user data
                my $ProjectPeriodSum = 0;

                # iterate over period data of user
                for my $PeriodData ( grep { $_->{ProjectID} == $ProjectID } @UserStatData ) {
                    $ProjectPeriodSum += $PeriodData->{Period};
                }

                # safe user data to row data
                push @RowData, $ProjectPeriodSum;
            }

            # store current row to global stat array
            push @StatArray, \@RowData;
        }

    }

    return @StatArray;
}

sub ExportWrapper {
    my ( $Self, %Param ) = @_;

    # wrap ids to used spelling
    for my $Use (qw(UseAsValueSeries UseAsRestriction UseAsXvalue)) {
        ELEMENT:
        for my $Element ( @{ $Param{$Use} } ) {
            next ELEMENT if !$Element || !$Element->{SelectedValues};
            my $ElementName = $Element->{Element};
            my $Values      = $Element->{SelectedValues};

            if ( $ElementName eq 'User' ) {
                ID:
                for my $ID ( @{$Values} ) {
                    next ID if !$ID;

                    $ID->{Content} = $Self->{UserObject}->UserLookup( UserID => $ID->{Content} );
                }
            }
            elsif ( $ElementName eq 'Project' ) {
                ID:
                for my $ID ( @{$Values} ) {
                    next ID if !$ID;

                    my %TmpProjectData
                        = $Self->{TimeAccountingObject}->ProjectGet( ID => $ID->{Content} );
                    $ID->{Content} = $TmpProjectData{Project};
                }
            }
            elsif ( $ElementName eq 'ProjectAction' ) {
                ID:
                for my $ID ( @{$Values} ) {
                    next ID if !$ID;

                    my %TmpActionData
                        = $Self->{TimeAccountingObject}->ActionGet( ID => $ID->{Content} );
                    $ID->{Content} = $TmpActionData{Action};
                }
            }
        }
    }
    return \%Param;
}

sub ImportWrapper {
    my ( $Self, %Param ) = @_;

    # wrap used spelling to ids
    for my $Use (qw(UseAsValueSeries UseAsRestriction UseAsXvalue)) {
        ELEMENT:
        for my $Element ( @{ $Param{$Use} } ) {
            next ELEMENT if !$Element || !$Element->{SelectedValues};

            my $ElementName = $Element->{Element};
            my $Values      = $Element->{SelectedValues};

            if ( $ElementName eq 'User' ) {
                ID:
                for my $ID ( @{$Values} ) {
                    next ID if !$ID;

                    if ( $Self->{UserObject}->UserLookup( UserLogin => $ID->{Content} ) ) {
                        $ID->{Content}
                            = $Self->{UserObject}->UserLookup( UserLogin => $ID->{Content} );
                    }
                    else {
                        $Self->{LogObject}->Log(
                            Priority => 'error',
                            Message  => "Import: Can' find the user $ID->{Content}!"
                        );
                        $ID = undef;
                    }
                }
            }
            elsif ( $ElementName eq 'Project' ) {
                ID:
                for my $ID ( @{$Values} ) {
                    next ID if !$ID;

                    my %Project = $Self->{TimeAccountingObject}->ProjectGet(
                        Project => $ID->{Content},
                    );
                    if ( $Project{ID} ) {
                        $ID->{Content} = $Project{ID};
                    }
                    else {
                        $Self->{LogObject}->Log(
                            Priority => 'error',
                            Message  => "Import: Can' find project $ID->{Content}!"
                        );
                        $ID = undef;
                    }
                }
            }
            elsif ( $ElementName eq 'ProjectAction' ) {
                ID:
                for my $ID ( @{$Values} ) {
                    next ID if !$ID;

                    my %Action = $Self->{TimeAccountingObject}->ActionGet(
                        Action => $ID->{Content},
                    );
                    if ( $Action{ID} ) {
                        $ID->{Content} = $Action{ID};
                    }
                    else {
                        $Self->{LogObject}->Log(
                            Priority => 'error',
                            Message  => "Import: Can' find action $ID->{Content}!"
                        );
                        $ID = undef;
                    }
                }
            }
        }
    }
    return \%Param;
}

sub _GetStatData {

    my ( $Self, %Param ) = @_;

    my @Return;
    my @UserIDs = @{ $Param{UserIDs} || [] };

    my %DateIndexToName = (
        'Second' => 0,
        'Minute' => 1,
        'Hour'   => 2,
        'Day'    => 3,
        'Month'  => 4,
        'Year'   => 5,
    );

    # looping over all or selected users
    for my $UserID (@UserIDs) {

        my $StartDate;
        my $StopDate;

        # check if time period has been selected
        if ( $Param{Param}{Restrictions}{TimeAccountingPeriodStart} ) {

            # get unix timestamp of start and end values
            $StartDate = $Self->{TimeObject}->TimeStamp2SystemTime(
                String => $Param{Param}{Restrictions}{TimeAccountingPeriodStart},
            );
            $StopDate = $Self->{TimeObject}->TimeStamp2SystemTime(
                String => $Param{Param}{Restrictions}{TimeAccountingPeriodStop},
            );
        }
        else {

            # IMPORTANT:
            # If no time period had been selected previous month will be used as period!

            # get current date values
            my @CurrentDate = $Self->{TimeObject}->SystemTime2Date(
                SystemTime => $Self->{TimeObject}->SystemTime(),
            );

            # get first day of previous month
            my @NewStartDate = Add_Delta_YMD(
                $CurrentDate[ $DateIndexToName{'Year'} ],
                $CurrentDate[ $DateIndexToName{'Month'} ],
                1,
                0,
                -1,
                0,
            );

            # get first day of next month relative to previous month
            my @NewStopDate = Add_Delta_YMD(
                $NewStartDate[0],
                $NewStartDate[1],
                $NewStartDate[2],
                0,
                +1,
                0,
            );

            # get last of day previous month
            @NewStopDate = Add_Delta_YMD(
                $NewStopDate[0],
                $NewStopDate[1],
                $NewStopDate[2],
                0,
                0,
                -1,
            );

            # calculate unix timestamp for start and stop date
            $StartDate = $Self->{TimeObject}->Date2SystemTime(
                Year   => $NewStartDate[0],
                Month  => $NewStartDate[1],
                Day    => $NewStartDate[2],
                Hour   => 0,
                Minute => 0,
                Second => 0,
            );
            $StopDate = $Self->{TimeObject}->Date2SystemTime(
                Year   => $NewStopDate[0],
                Month  => $NewStopDate[1],
                Day    => $NewStopDate[2],
                Hour   => 23,
                Minute => 59,
                Second => 59,
            );
        }

        # calculate number of days within the given range
        my $Days = int( ( $StopDate - $StartDate ) / 86400 ) + 1;

        DAY:
        for my $Day ( 0 .. $Days ) {

            # get day relative to start date
            my $DateOfPeriod = $StartDate + $Day * 86400;

            # get needed date values out of timestamp
            my @DateValues = $Self->{TimeObject}->SystemTime2Date(
                SystemTime => $DateOfPeriod,
            );

            # get working unit for user and day
            my %WorkingUnit = $Self->{TimeAccountingObject}->WorkingUnitsGet(
                Year   => $DateValues[ $DateIndexToName{'Year'} ],
                Month  => $DateValues[ $DateIndexToName{'Month'} ],
                Day    => $DateValues[ $DateIndexToName{'Day'} ],
                UserID => $UserID,
            );

            # extract detailed information
            my @DayWorkingUnits = @{ $WorkingUnit{WorkingUnits} || [] };

            # check for project restrictions
            if (
                $Param{Param}{Restrictions}->{Project}
                && ref $Param{Param}{Restrictions}->{Project} eq 'ARRAY'
                )
            {

                # build matching hash for selected projects
                my %SelectedProjectIDs
                    = map { ( $_ => 1 ) } @{ $Param{Param}{Restrictions}->{Project} };

                # filter only selected projects
                my @FilteredProjectWUs = grep {
                    $SelectedProjectIDs{ $_->{ProjectID} }
                } @DayWorkingUnits;

                @DayWorkingUnits = @FilteredProjectWUs;
            }

            # check for task restrictions
            if (
                $Param{Param}{Restrictions}->{ProjectAction}
                && ref $Param{Param}{Restrictions}->{ProjectAction} eq 'ARRAY'
                )
            {

                # build matching hash for selected actions
                my %SelectedActionIDs
                    = map { ( $_ => 1 ) } @{ $Param{Param}{Restrictions}->{ProjectAction} };

                # filter only selected actions
                my @FilteredActionWUs = grep {
                    $SelectedActionIDs{ $_->{ActionID} }
                } @DayWorkingUnits;

                @DayWorkingUnits = @FilteredActionWUs;
            }

            # check for user restrictions
            if (
                $Param{Param}{Restrictions}->{User}
                && ref $Param{Param}{Restrictions}->{User} eq 'ARRAY'
                )
            {

                # build matching hash for selected actions
                my %SelectedUserIDs = map { ( $_ => 1 ) } @{ $Param{Param}{Restrictions}->{User} };

                # filter only selected actions
                my @FilteredUserWUs = grep {
                    $SelectedUserIDs{ $_->{UserID} }
                } @DayWorkingUnits;

                @DayWorkingUnits = @FilteredUserWUs;
            }

            # do not store data if no data is available
            next DAY if !@DayWorkingUnits;

            # add data to global result set
            push @Return, @DayWorkingUnits;
        }
    }

    return \@Return;

}

1;
