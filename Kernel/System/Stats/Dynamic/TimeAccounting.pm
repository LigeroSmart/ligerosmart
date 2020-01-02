# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Stats::Dynamic::TimeAccounting;

use strict;
use warnings;

use Kernel::Language qw(Translatable);
use Kernel::System::VariableCheck qw(IsArrayRefWithData);

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::DateTime',
    'Kernel::System::TimeAccounting',
    'Kernel::System::User',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub GetObjectName {
    my ( $Self, %Param ) = @_;

    return 'TimeAccounting';
}

sub GetObjectAttributes {
    my ( $Self, %Param ) = @_;

    my $DateTimeObjectCurrent = $Kernel::OM->Create('Kernel::System::DateTime');

    # set predefined start time
    my $TimeStamp = $DateTimeObjectCurrent->ToEpoch();
    my ($Date) = split /\s+/, $TimeStamp;
    my $Today = sprintf "%s 23:59:59", $Date;

    # get time accounting object
    my $TimeAccountingObject = $Kernel::OM->Get('Kernel::System::TimeAccounting');

    # get project list
    my %ProjectList = $TimeAccountingObject->ProjectSettingsGet(
        Status => 'valid',
    );

    # get action list
    my %ActionListSource = $TimeAccountingObject->ActionSettingsGet();
    my %ActionList;

    for my $Action ( sort keys %ActionListSource ) {
        $ActionList{$Action} = $ActionListSource{$Action}->{Action};
    }

    # get user list
    my %UserList = $Kernel::OM->Get('Kernel::System::User')->UserList(
        Type  => 'Long',
        Valid => 0,
    );

    my @Attributes = (
        {
            Name             => Translatable('Project'),
            UseAsXvalue      => 1,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'Project',
            Block            => 'MultiSelectField',
            Translation      => 0,
            Values           => $ProjectList{Project},
        },
        {
            Name             => Translatable('User'),
            UseAsXvalue      => 1,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'User',
            Block            => 'MultiSelectField',
            Translation      => 0,
            Values           => \%UserList,
        },
        {
            Name             => Translatable('Sort sequence'),
            UseAsXvalue      => 0,
            UseAsValueSeries => 1,
            UseAsRestriction => 0,
            Element          => 'SortSequence',
            Block            => 'SelectField',
            Translation      => 1,
            Values           => {
                Up   => 'ascending',
                Down => 'descending',
            },
        },
        {
            Name             => Translatable('Task'),
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'ProjectAction',
            Block            => 'MultiSelectField',
            Translation      => 0,
            Values           => \%ActionList,
        },
        {
            Name             => Translatable('Period'),
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'Period',
            TimePeriodFormat => 'DateInputFormat',        # 'DateInputFormatLong',
            Block            => 'Time',
            Values           => {
                TimeStart => 'TimeAccountingPeriodStart',
                TimeStop  => 'TimeAccountingPeriodStop',
            },
        },
    );

    return @Attributes;
}

sub GetHeaderLine {
    my ( $Self, %Param ) = @_;
    my @HeaderLine = ("");

    # Users as X-value
    if ( $Param{XValue}->{Element} && $Param{XValue}->{Element} eq 'User' ) {

        # user have been selected as x-value
        my @UserIDs = @{ $Param{XValue}->{SelectedValues} };

        # get user object
        my $UserObject = $Kernel::OM->Get('Kernel::System::User');

        # iterate over selected users
        USERID:
        for my $UserID (@UserIDs) {
            my $UserName = $UserObject->UserName(
                UserID => $UserID,
            );

            push @HeaderLine, $UserName;
        }
    }

    # Projects as X-value
    else {
        # projects have been selected as x-value
        my @ProjectIDs = @{ $Param{XValue}->{SelectedValues} };

        # get time accounting object
        my $TimeAccountingObject = $Kernel::OM->Get('Kernel::System::TimeAccounting');

        # iterate over selected projects
        PROJECTID:
        for my $ProjectID (@ProjectIDs) {
            my %ProjectData = $TimeAccountingObject->ProjectGet(
                ID => $ProjectID,
            );

            push @HeaderLine, $ProjectData{Project};
        }
    }

    return \@HeaderLine;
}

sub GetStatTable {
    my ( $Self, %Param ) = @_;
    my @StatArray;
    my @UserIDs;

    # Users as X-value
    if ( $Param{XValue}->{Element} && $Param{XValue}->{Element} eq 'User' ) {

        # user have been selected as x-value
        @UserIDs = @{ $Param{XValue}->{SelectedValues} };

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

        # get time accounting object
        my $TimeAccountingObject = $Kernel::OM->Get('Kernel::System::TimeAccounting');

        # get list of needed data
        my %ProjectData = $TimeAccountingObject->ProjectSettingsGet();
        my %ProjectList = %{ $ProjectData{Project} || {} };

        my %ActionData = $TimeAccountingObject->ActionSettingsGet();
        my %ActionList = map { ( $_ => $ActionData{$_}->{Action} ) } keys %ActionData;

        my @SortedProjectIDs = sort { $ProjectList{$a} cmp $ProjectList{$b} } keys %ProjectList;
        my @SortedActionIDs  = sort { $ActionList{$a} cmp $ActionList{$b} } keys %ActionList;

        # re-sort projects depending on selected sequence
        if (
            IsArrayRefWithData( $Param{ValueSeries} )
            && $Param{ValueSeries}->[0]->{SelectedValues}->[0] eq 'Down'
            )
        {
            @SortedProjectIDs = reverse @SortedProjectIDs;
        }

        # iterate over sorted project list
        SORTEDPROJECTID:
        for my $SortedProjectID (@SortedProjectIDs) {

            # check for unselected projects
            if (
                $Param{Restrictions}->{Project}
                && !grep { $_ == $SortedProjectID } @{ $Param{Restrictions}->{Project} || [] }
                )
            {
                next SORTEDPROJECTID;
            }

            # get the current project data of current project
            my @ProjectStatData = grep { $_->{ProjectID} == $SortedProjectID } @RawStatArray;

            # iterate over sorted action list
            SORTEDACTIONID:
            for my $SortedActionID (@SortedActionIDs) {

                # check for unselected actions
                if (
                    $Param{Restrictions}->{ProjectAction}
                    && !grep { $_ == $SortedActionID } @{ $Param{Restrictions}->{ProjectAction} || [] }
                    )
                {
                    next SORTEDACTIONID;
                }

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
        my @ProjectIDs = @{ $Param{XValue}->{SelectedValues} };

        # get user object
        my $UserObject = $Kernel::OM->Get('Kernel::System::User');

        # we need to get all users
        my %UserIDs = $UserObject->UserList(
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
        my %UserList = $UserObject->UserList(
            Type  => 'Long',
            Valid => 1,
        );

        my @SortedUserIDs = sort { $UserList{$a} cmp $UserList{$b} } keys %UserList;

        # re-sort users depending on selected sequence
        if (
            IsArrayRefWithData( $Param{ValueSeries} )
            && $Param{ValueSeries}->[0]->{SelectedValues}->[0] eq 'Down'
            )
        {
            @SortedUserIDs = reverse @SortedUserIDs;
        }

        # iterate over sorted user list
        SORTEDUSERID:
        for my $SortedUserID (@SortedUserIDs) {

            # check for unselected users
            if (
                $Param{Restrictions}->{User}
                && !grep { $_ == $SortedUserID } @{ $Param{Restrictions}->{User} || [] }
                )
            {
                next SORTEDUSERID;
            }

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

sub GetStatTablePreview {
    my ( $Self, %Param ) = @_;

    my @StatArray;
    my @UserIDs;

    # Users as X-value
    if ( $Param{XValue}->{Element} && $Param{XValue}->{Element} eq 'User' ) {

        # user have been selected as x-value
        @UserIDs = @{ $Param{XValue}->{SelectedValues} };

        # get time accounting object
        my $TimeAccountingObject = $Kernel::OM->Get('Kernel::System::TimeAccounting');

        # get list of needed data
        my %ProjectData = $TimeAccountingObject->ProjectSettingsGet();
        my %ProjectList = %{ $ProjectData{Project} || {} };

        my %ActionData = $TimeAccountingObject->ActionSettingsGet();
        my %ActionList = map { ( $_ => $ActionData{$_}->{Action} ) } keys %ActionData;

        my @SortedProjectIDs = sort { $ProjectList{$a} cmp $ProjectList{$b} } keys %ProjectList;
        my @SortedActionIDs  = sort { $ActionList{$a} cmp $ActionList{$b} } keys %ActionList;

        # re-sort projects depending on selected sequence
        if (
            IsArrayRefWithData( $Param{ValueSeries} )
            && $Param{ValueSeries}->[0]->{SelectedValues}->[0] eq 'Down'
            )
        {
            @SortedProjectIDs = reverse @SortedProjectIDs;
        }

        # iterate over sorted project list
        SORTEDPROJECTID:
        for my $SortedProjectID (@SortedProjectIDs) {

            # check for unselected projects
            if (
                $Param{Restrictions}->{Project}
                && !grep { $_ == $SortedProjectID } @{ $Param{Restrictions}->{Project} || [] }
                )
            {
                next SORTEDPROJECTID;
            }

            # iterate over sorted action list
            SORTEDACTIONID:
            for my $SortedActionID (@SortedActionIDs) {

                # check for unselected actions
                if (
                    $Param{Restrictions}->{ProjectAction}
                    && !grep { $_ == $SortedActionID } @{ $Param{Restrictions}->{ProjectAction} || [] }
                    )
                {
                    next SORTEDACTIONID;
                }

                my @RowData;

                # add descriptive first column
                my $RowLabel = "$ProjectList{$SortedProjectID}::$ActionList{$SortedActionID}";
                push @RowData, $RowLabel;

                # iterate over selected users
                USERID:
                for my $UserID (@UserIDs) {

                    # safe user data to row data
                    push @RowData, int rand 50;
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

        # get user object
        my $UserObject = $Kernel::OM->Get('Kernel::System::User');

        # we need to get all users
        my %UserIDs = $UserObject->UserList(
            Type  => 'Short',
            Valid => 1,
        );

        @UserIDs = keys %UserIDs;

        # get list of needed data
        my %UserList = $UserObject->UserList(
            Type  => 'Long',
            Valid => 1,
        );

        my @SortedUserIDs = sort { $UserList{$a} cmp $UserList{$b} } keys %UserList;

        # re-sort users depending on selected sequence
        if (
            IsArrayRefWithData( $Param{ValueSeries} )
            && $Param{ValueSeries}->[0]->{SelectedValues}->[0] eq 'Down'
            )
        {
            @SortedUserIDs = reverse @SortedUserIDs;
        }

        # iterate over sorted user list
        SORTEDUSERID:
        for my $SortedUserID (@SortedUserIDs) {

            # check for unselected users
            if (
                $Param{Restrictions}->{User}
                && !grep { $_ == $SortedUserID } @{ $Param{Restrictions}->{User} || [] }
                )
            {
                next SORTEDUSERID;
            }

            my @RowData;

            # add descriptive first column
            my $RowLabel = $UserList{$SortedUserID};
            push @RowData, $RowLabel;

            # iterate over selected projects
            PROJECTID:
            for my $ProjectID (@ProjectIDs) {

                # safe user data to row data
                push @RowData, int rand 50;
            }

            # store current row to global stat array
            push @StatArray, \@RowData;
        }
    }

    return @StatArray;
}

sub ExportWrapper {
    my ( $Self, %Param ) = @_;

    # get needed objects
    my $UserObject           = $Kernel::OM->Get('Kernel::System::User');
    my $TimeAccountingObject = $Kernel::OM->Get('Kernel::System::TimeAccounting');

    # wrap ids to used spelling
    for my $Use (qw(UseAsValueSeries UseAsRestriction UseAsXvalue)) {

        ELEMENT:
        for my $Element ( @{ $Param{$Use} } ) {
            next ELEMENT if !$Element;
            next ELEMENT if !$Element->{SelectedValues};

            my $ElementName = $Element->{Element};
            my $Values      = $Element->{SelectedValues};

            if ( $ElementName eq 'User' ) {

                ID:
                for my $ID ( @{$Values} ) {
                    next ID if !$ID;

                    $ID->{Content} = $UserObject->UserLookup(
                        UserID => $ID->{Content}
                    );
                }
            }
            elsif ( $ElementName eq 'Project' ) {

                ID:
                for my $ID ( @{$Values} ) {
                    next ID if !$ID;

                    my %TmpProjectData = $TimeAccountingObject->ProjectGet(
                        ID => $ID->{Content}
                    );
                    $ID->{Content} = $TmpProjectData{Project};
                }
            }
            elsif ( $ElementName eq 'ProjectAction' ) {

                ID:
                for my $ID ( @{$Values} ) {
                    next ID if !$ID;

                    my %TmpActionData = $TimeAccountingObject->ActionGet(
                        ID => $ID->{Content}
                    );
                    $ID->{Content} = $TmpActionData{Action};
                }
            }
        }
    }
    return \%Param;
}

sub ImportWrapper {
    my ( $Self, %Param ) = @_;

    # get needed objects
    my $UserObject           = $Kernel::OM->Get('Kernel::System::User');
    my $LogObject            = $Kernel::OM->Get('Kernel::System::Log');
    my $TimeAccountingObject = $Kernel::OM->Get('Kernel::System::TimeAccounting');

    # wrap used spelling to ids
    for my $Use (qw(UseAsValueSeries UseAsRestriction UseAsXvalue)) {
        ELEMENT:
        for my $Element ( @{ $Param{$Use} } ) {
            next ELEMENT if !$Element;
            next ELEMENT if !$Element->{SelectedValues};

            my $ElementName = $Element->{Element};
            my $Values      = $Element->{SelectedValues};

            if ( $ElementName eq 'User' ) {

                ID:
                for my $ID ( @{$Values} ) {
                    next ID if !$ID;

                    my $UserID = $UserObject->UserLookup(
                        UserLogin => $ID->{Content},
                    );

                    if ($UserID) {
                        $ID->{Content} = $UserID;
                    }
                    else {
                        $LogObject->Log(
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

                    my %Project = $TimeAccountingObject->ProjectGet(
                        Project => $ID->{Content},
                    );
                    if ( $Project{ID} ) {
                        $ID->{Content} = $Project{ID};
                    }
                    else {
                        $LogObject->Log(
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

                    my %Action = $TimeAccountingObject->ActionGet(
                        Action => $ID->{Content},
                    );
                    if ( $Action{ID} ) {
                        $ID->{Content} = $Action{ID};
                    }
                    else {
                        $LogObject->Log(
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

sub GetExtendedTitle {
    my ( $Self, %Param ) = @_;

    return if $Param{Restrictions}->{TimeAccountingPeriodStart} || $Param{Restrictions}->{TimeAccountingPeriodStop};

    my %DateIndexToName = (
        'Second' => 0,
        'Minute' => 1,
        'Hour'   => 2,
        'Day'    => 3,
        'Month'  => 4,
        'Year'   => 5,
    );

    my %PreviousMonthDates = $Self->_GetPreviousMonthDates(
        DateIndexToName => \%DateIndexToName,
    );

    my $StartDate = sprintf "%04d-%02d-%02d 00:00:00", $PreviousMonthDates{NewStartDate}->[0],
        $PreviousMonthDates{NewStartDate}->[1], $PreviousMonthDates{NewStartDate}->[2];
    my $StopDate = sprintf "%04d-%02d-%02d 00:00:00", $PreviousMonthDates{NewStopDate}->[0],
        $PreviousMonthDates{NewStopDate}->[1], $PreviousMonthDates{NewStopDate}->[2];

    return "$StartDate-$StopDate";
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

    # get time accounting object
    my $TimeAccountingObject = $Kernel::OM->Get('Kernel::System::TimeAccounting');

    # looping over all or selected users
    for my $UserID (@UserIDs) {

        my $StartDate;
        my $StopDate;

        # check if time period has been selected
        if ( $Param{Param}->{Restrictions}->{TimeAccountingPeriodStart} ) {

            # get UNIX time-stamp of start and end values
            $StartDate = $TimeAccountingObject->TimeStamp2SystemTime(
                String => $Param{Param}->{Restrictions}->{TimeAccountingPeriodStart},
            );
            $StopDate = $TimeAccountingObject->TimeStamp2SystemTime(
                String => $Param{Param}->{Restrictions}->{TimeAccountingPeriodStop},
            );
        }
        else {

            # IMPORTANT:
            # If no time period had been selected previous month will be used as period!
            my %PreviousMonthDates = $Self->_GetPreviousMonthDates(
                DateIndexToName => \%DateIndexToName,
            );

            # Calculate UNIX timestamps for start and stop date.
            $StartDate = $TimeAccountingObject->Date2SystemTime(
                Year   => $PreviousMonthDates{NewStartDate}->[0],
                Month  => $PreviousMonthDates{NewStartDate}->[1],
                Day    => $PreviousMonthDates{NewStartDate}->[2],
                Hour   => 0,
                Minute => 0,
                Second => 0,
            );
            $StopDate = $TimeAccountingObject->Date2SystemTime(
                Year   => $PreviousMonthDates{NewStopDate}->[0],
                Month  => $PreviousMonthDates{NewStopDate}->[1],
                Day    => $PreviousMonthDates{NewStopDate}->[2],
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

            # get needed date values out of time-stamp
            my @DateValues = $TimeAccountingObject->SystemTime2Date(
                SystemTime => $DateOfPeriod,
            );

            # get working unit for user and day
            my %WorkingUnit = $TimeAccountingObject->WorkingUnitsGet(
                Year   => $DateValues[ $DateIndexToName{'Year'} ],
                Month  => $DateValues[ $DateIndexToName{'Month'} ],
                Day    => $DateValues[ $DateIndexToName{'Day'} ],
                UserID => $UserID,
            );

            # extract detailed information
            my @DayWorkingUnits = @{ $WorkingUnit{WorkingUnits} || [] };

            # check for project restrictions
            if (
                $Param{Param}->{Restrictions}->{Project}
                && ref $Param{Param}->{Restrictions}->{Project} eq 'ARRAY'
                )
            {

                # build matching hash for selected projects
                my %SelectedProjectIDs = map { ( $_ => 1 ) } @{ $Param{Param}->{Restrictions}->{Project} };

                # filter only selected projects
                my @FilteredProjectWUs = grep {
                    $SelectedProjectIDs{ $_->{ProjectID} }
                } @DayWorkingUnits;

                @DayWorkingUnits = @FilteredProjectWUs;
            }

            # check for task restrictions
            if (
                $Param{Param}->{Restrictions}->{ProjectAction}
                && ref $Param{Param}->{Restrictions}->{ProjectAction} eq 'ARRAY'
                )
            {

                # build matching hash for selected actions
                my %SelectedActionIDs = map { ( $_ => 1 ) } @{ $Param{Param}->{Restrictions}->{ProjectAction} };

                # filter only selected actions
                my @FilteredActionWUs = grep { $SelectedActionIDs{ $_->{ActionID} } } @DayWorkingUnits;

                @DayWorkingUnits = @FilteredActionWUs;
            }

            # check for user restrictions
            if (
                $Param{Param}->{Restrictions}->{User}
                && ref $Param{Param}->{Restrictions}->{User} eq 'ARRAY'
                )
            {

                # build matching hash for selected actions
                my %SelectedUserIDs = map { ( $_ => 1 ) } @{ $Param{Param}->{Restrictions}->{User} };

                # filter only selected actions
                my @FilteredUserWUs = grep { $SelectedUserIDs{ $_->{UserID} } } @DayWorkingUnits;

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

sub _GetPreviousMonthDates {
    my ( $Self, %Param ) = @_;

    if ( !$Param{DateIndexToName} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need DateIndexToName!",
        );

        return;
    }

    # get time accounting object
    my $TimeAccountingObject  = $Kernel::OM->Get('Kernel::System::TimeAccounting');
    my $DateTimeObjectCurrent = $Kernel::OM->Create('Kernel::System::DateTime');

    # Get current date values.
    my @CurrentDate = $TimeAccountingObject->SystemTime2Date(
        SystemTime => $DateTimeObjectCurrent->ToEpoch(),
    );

    # Get first day of previous month.
    my @NewStartDate = $TimeAccountingObject->AddDeltaYMD(
        $CurrentDate[ $Param{DateIndexToName}->{'Year'} ],
        $CurrentDate[ $Param{DateIndexToName}->{'Month'} ],
        1,
        0,
        -1,
        0,
    );

    # Get first day of next month relative to previous month.
    my @NewStopDate = $TimeAccountingObject->AddDeltaYMD(
        $NewStartDate[0],
        $NewStartDate[1],
        $NewStartDate[2],
        0,
        +1,
        0,
    );

    # Get last of day previous month.
    @NewStopDate = $TimeAccountingObject->AddDeltaYMD(
        $NewStopDate[0],
        $NewStopDate[1],
        $NewStopDate[2],
        0,
        0,
        -1,
    );

    return (
        NewStartDate => \@NewStartDate,
        NewStopDate  => \@NewStopDate,
    );
}

1;
