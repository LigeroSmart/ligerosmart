# --
# Kernel/Modules/AgentITSMChangeSearch.pm - module for change search
# Copyright (C) 2003-2010 OTRS AG, http://otrs.com/
# --
# $Id: AgentITSMChangeSearch.pm,v 1.54 2010-04-27 20:36:57 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMChangeSearch;

use strict;
use warnings;

use Kernel::System::CustomerUser;
use Kernel::System::SearchProfile;
use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::ITSMWorkOrder;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.54 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (
        qw(ParamObject DBObject LayoutObject LogObject UserObject GroupObject ConfigObject MainObject EncodeObject)
        )
    {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Object!" );
        }
    }

    # create needed objects
    $Self->{CustomerUserObject}  = Kernel::System::CustomerUser->new(%Param);
    $Self->{SearchProfileObject} = Kernel::System::SearchProfile->new(%Param);
    $Self->{ChangeObject}        = Kernel::System::ITSMChange->new(%Param);
    $Self->{WorkOrderObject}     = Kernel::System::ITSMChange::ITSMWorkOrder->new(%Param);

    # get config for frontend
    $Self->{Config} = $Self->{ConfigObject}->Get("ITSMChange::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get confid data
    $Self->{StartHit} = $Self->{ParamObject}->GetParam( Param => 'StartHit' ) || 1;
    $Self->{SearchLimit} = $Self->{Config}->{SearchLimit} || 500;
    $Self->{SortBy} = $Self->{ParamObject}->GetParam( Param => 'SortBy' )
        || $Self->{Config}->{'SortBy::Default'}
        || 'ChangeID';
    $Self->{OrderBy} = $Self->{ParamObject}->GetParam( Param => 'OrderBy' )
        || $Self->{Config}->{'Order::Default'}
        || 'Down';
    $Self->{TakeLastSearch} = $Self->{ParamObject}->GetParam( Param => 'TakeLastSearch' ) || '';
    $Self->{Profile} = $Self->{ParamObject}->GetParam( Param => 'Profile' ) || 'last-search';

    # search parameters
    my %GetParam;

    # load parameters from search profile,
    # this happens when the next result page should be shown, or when the results are reordered
    if ( ( $Self->{Subaction} eq 'LoadProfile' && $Self->{Profile} ) || $Self->{TakeLastSearch} ) {
        %GetParam = $Self->{SearchProfileObject}->SearchProfileGet(
            Base      => 'ITSMChangeSearch',
            Name      => $Self->{Profile},
            UserLogin => $Self->{UserLogin},
        );
    }
    else {

        # get scalar search params
        for my $ParamName (
            qw(
            ChangeNumber ChangeTitle Description Justification
            SelectedCustomerUser CABCustomer
            SelectedUser1        CABAgent
            WorkOrderTitle WorkOrderInstruction WorkOrderReport
            )
            )
        {
            $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );

            # remove whitespace on the start and end
            if ( $GetParam{$ParamName} ) {
                $GetParam{$ParamName} =~ s{ \A \s+ }{}xms;
                $GetParam{$ParamName} =~ s{ \s+ \z }{}xms;
            }
        }

        # get array search params
        for my $SearchParam (
            qw( ChangeStateIDs
            ChangeManagerIDs ChangeBuilderIDs
            PriorityIDs CategoryIDs ImpactIDs
            CreateBy
            WorkOrderStateIDs WorkOrderAgentIDs
            )
            )
        {
            my @Array = $Self->{ParamObject}->GetArray( Param => $SearchParam );
            if (@Array) {
                $GetParam{$SearchParam} = \@Array;
            }
        }

        # get time related params
        for my $TimeType (
            qw( Requested PlannedStart PlannedEnd ActualStart ActualEnd Create Change )
            )
        {
            for my $Part (
                qw(
                SearchType
                PointFormat Point PointStart
                Start StartDay StartMonth StartYear
                Stop  StopDay  StopMonth  StopYear
                )
                )
            {
                my $ParamKey = "${TimeType}Time${Part}";
                my $ParamVal = $Self->{ParamObject}->GetParam( Param => $ParamKey );

                # remove white space on the start and end
                if ($ParamVal) {
                    $ParamVal =~ s{ \A \s+ }{}xms;
                    $ParamVal =~ s{ \s+ \z }{}xms;
                }

                # store in %GetParam
                $GetParam{$ParamKey} = $ParamVal;
            }
        }
    }

    # remove old profile stuff
    $Self->{SearchProfileObject}->SearchProfileDelete(
        Base      => 'ITSMChangeSearch',
        Name      => $Self->{Profile},
        UserLogin => $Self->{UserLogin},
    );

    # insert new profile params
    for my $Key ( keys %GetParam ) {
        if ( $GetParam{$Key} ) {
            $Self->{SearchProfileObject}->SearchProfileAdd(
                Base      => 'ITSMChangeSearch',
                Name      => $Self->{Profile},
                Key       => $Key,
                Value     => $GetParam{$Key},
                UserLogin => $Self->{UserLogin},
            );
        }
    }

    # Remember the reason why searching was not attempted.
    # The entries are the names of the dtl validation error blocks.
    my @ValidationErrors;

    # this is needed to handle user requests when autocompletion is turned off
    # %ExpandInfo gets info about chosen user and all available users
    my %ExpandInfo;

    # show result site or perform other actions
    if ( $Self->{Subaction} eq 'Search' ) {

        # Extract the parameters that are not needed for searching,
        # which are not stored in the search profile
        for my $ParamName (
            qw(
            CABCustomerID ExpandCABCustomer1 ExpandCABCustomer2 ClearCABCustomer
            CABAgentID    ExpandCABAgent1    ExpandCABAgent2    ClearCABAgent
            )
            )
        {
            $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
        }

        # is a "search user" or "search customer" button clicked
        my $ExpandUser = $GetParam{ExpandCABAgent1} || $GetParam{ExpandCABAgent2}
            || $GetParam{ExpandCABCustomer1} || $GetParam{ExpandCABCustomer2};

        # is a "clear user" button clicked
        my $ClearUser = $GetParam{ClearCABAgent} || $GetParam{ClearCABCustomer};

        if ($ExpandUser) {

            # get user and customer info when autocompletion is turned off
            %ExpandInfo = $Self->_GetExpandInfo(%GetParam);
        }
        elsif ($ClearUser) {

            # which fields to clear
            my %FieldMap = (
                ClearCABAgent    => [qw(CABAgent    SelectedUser1)],
                ClearCABCustomer => [qw(CABCustomer SelectedCustomerUser)],
            );

            # actually clear the fields associated with the button that was clicked
            my $Fields = $FieldMap{$ClearUser} || [];
            for my $Field ( @{$Fields} ) {
                $GetParam{$Field} = '';
            }
        }
        else {

            # store last queue screen
            my $URL
                = "Action=AgentITSMChangeSearch&Subaction=Search&Profile=$Self->{Profile}&SortBy=$Self->{SortBy}"
                . "&OrderBy=$Self->{OrderBy}&TakeLastSearch=1&StartHit=$Self->{StartHit}";
            $Self->{SessionObject}->UpdateSessionID(
                SessionID => $Self->{SessionID},
                Key       => 'LastScreenChanges',
                Value     => $URL,
            );
            $Self->{SessionObject}->UpdateSessionID(
                SessionID => $Self->{SessionID},
                Key       => 'LastChangeView',
                Value     => $URL,
            );

            # prepare CABAgents and CABCustomers, checking for emptied text fields
            if ( $GetParam{SelectedUser1} && $GetParam{CABAgent} ) {
                $GetParam{CABAgents} = [ $GetParam{SelectedUser1} ];
            }
            if ( $GetParam{SelectedCustomerUser} && $GetParam{CABCustomer} ) {
                $GetParam{CABCustomers} = [ $GetParam{SelectedCustomerUser} ];
            }

            # get and check the time search parameters
            TIMETYPE:
            for my $TimeType (
                qw( Requested PlannedStart PlannedEnd ActualStart ActualEnd Create Change )
                )
            {

                # extract the time search parameters for $TimeType into %TimeSelectionParam
                my %TimeSelectionParam;
                for my $Part (
                    qw(
                    SearchType
                    PointFormat Point PointStart
                    Start StartDay StartMonth StartYear
                    Stop  StopDay  StopMonth  StopYear
                    )
                    )
                {
                    $TimeSelectionParam{$Part} = $GetParam{ $TimeType . 'Time' . $Part };
                }

                # nothing to do, when no time search type has been selected
                next TIMETYPE if !$TimeSelectionParam{SearchType};

                if ( $TimeSelectionParam{SearchType} eq 'TimeSlot' ) {

                    my %SystemTime;    # used for checking the ordering of the two times

                    # the earlier limit
                    if (
                        $TimeSelectionParam{StartDay}
                        && $TimeSelectionParam{StartMonth}
                        && $TimeSelectionParam{StartYear}
                        )
                    {

                        # format as timestamp
                        $GetParam{ $TimeType . 'TimeNewerDate' } = sprintf
                            '%04d-%02d-%02d 00:00:01',
                            $TimeSelectionParam{StartYear},
                            $TimeSelectionParam{StartMonth},
                            $TimeSelectionParam{StartDay};

                        # check the validity
                        $SystemTime{TimeNewerDate} = $Self->{TimeObject}->TimeStamp2SystemTime(
                            String => $GetParam{ $TimeType . 'TimeNewerDate' },
                        );
                        if ( !$SystemTime{TimeNewerDate} ) {
                            push @ValidationErrors, $TimeType . 'InvalidTimeSlot';
                        }
                    }

                    # the later limit
                    if (
                        $TimeSelectionParam{StopDay}
                        && $TimeSelectionParam{StopMonth}
                        && $TimeSelectionParam{StopYear}
                        )
                    {

                        # format as timestamp
                        $GetParam{ $TimeType . 'TimeOlderDate' } = sprintf
                            '%04d-%02d-%02d 23:59:59',
                            $TimeSelectionParam{StopYear},
                            $TimeSelectionParam{StopMonth},
                            $TimeSelectionParam{StopDay};

                        # check the validity
                        $SystemTime{TimeOlderDate} = $Self->{TimeObject}->TimeStamp2SystemTime(
                            String => $GetParam{ $TimeType . 'TimeOlderDate' },
                        );
                        if ( !$SystemTime{TimeOlderDate} ) {
                            push @ValidationErrors, $TimeType . 'InvalidTimeSlot';
                        }
                    }

                    # check the ordering of the times
                    if (
                        $SystemTime{TimeNewerDate}
                        && $SystemTime{TimeOlderDate}
                        && $SystemTime{TimeNewerDate} >= $SystemTime{TimeOlderDate}
                        )
                    {
                        push @ValidationErrors, $TimeType . 'InvalidTimeSlot';
                    }

                }
                elsif ( $TimeSelectionParam{SearchType} eq 'TimePoint' ) {

                    # queries relative to now
                    if (
                        $TimeSelectionParam{Point}
                        && $TimeSelectionParam{PointStart}
                        && $TimeSelectionParam{PointFormat}
                        )
                    {
                        my $DiffSeconds = 0;
                        if ( $TimeSelectionParam{PointFormat} eq 'minute' ) {
                            $DiffSeconds = $TimeSelectionParam{Point} * 60;
                        }
                        elsif ( $TimeSelectionParam{PointFormat} eq 'hour' ) {
                            $DiffSeconds = $TimeSelectionParam{Point} * 60 * 60;
                        }
                        elsif ( $TimeSelectionParam{PointFormat} eq 'day' ) {
                            $DiffSeconds = $TimeSelectionParam{Point} * 60 * 60 * 24;
                        }
                        elsif ( $TimeSelectionParam{PointFormat} eq 'week' ) {
                            $DiffSeconds = $TimeSelectionParam{Point} * 60 * 60 * 24 * 7;
                        }
                        elsif ( $TimeSelectionParam{PointFormat} eq 'month' ) {
                            $DiffSeconds = $TimeSelectionParam{Point} * 60 * 60 * 24 * 30;
                        }
                        elsif ( $TimeSelectionParam{PointFormat} eq 'year' ) {
                            $DiffSeconds = $TimeSelectionParam{Point} * 60 * 60 * 24 * 365;
                        }

                        my $CurrentSystemTime = $Self->{TimeObject}->SystemTime();
                        my $CurrentTimeStamp  = $Self->{TimeObject}->SystemTime2TimeStamp(
                            SystemTime => $CurrentSystemTime
                        );
                        if ( $TimeSelectionParam{PointStart} eq 'Before' ) {

                            # search in the future
                            my $SearchTimeStamp = $Self->{TimeObject}->SystemTime2TimeStamp(
                                SystemTime => $CurrentSystemTime + $DiffSeconds,
                            );
                            $GetParam{ $TimeType . 'TimeNewerDate' } = $CurrentTimeStamp;
                            $GetParam{ $TimeType . 'TimeOlderDate' } = $SearchTimeStamp;
                        }
                        else {
                            my $SearchTimeStamp = $Self->{TimeObject}->SystemTime2TimeStamp(
                                SystemTime => $CurrentSystemTime - $DiffSeconds,
                            );
                            $GetParam{ $TimeType . 'TimeNewerDate' } = $SearchTimeStamp;
                            $GetParam{ $TimeType . 'TimeOlderDate' } = $CurrentTimeStamp;
                        }
                    }
                }
                else {

                    # unknown search types are simply ignored
                }
            }

            # search for substrings by default
            for (
                qw(ChangeTitle WorkOrderTitle Description Justification WorkOrderInstruction WorkOrderReport)
                )
            {
                if ( defined( $GetParam{$_} ) && $GetParam{$_} ne '' ) {
                    $GetParam{$_} = "*$GetParam{$_}*";
                }
            }

            # do not search, when there are validation errors
            if ( !@ValidationErrors ) {

                # perform ticket search
                my $ViewableChangeIDs = $Self->{ChangeObject}->ChangeSearch(
                    Result           => 'ARRAY',
                    OrderBy          => [ $Self->{SortBy} ],
                    OrderByDirection => [ $Self->{OrderBy} ],
                    Limit            => $Self->{SearchLimit},
                    UserID           => $Self->{UserID},
                    %GetParam,
                );

                # start html page
                my $Output = $Self->{LayoutObject}->Header();
                $Output .= $Self->{LayoutObject}->NavigationBar();
                $Self->{LayoutObject}->Print( Output => \$Output );
                $Output = '';

                $Self->{Filter} = $Self->{ParamObject}->GetParam( Param => 'Filter' ) || '';
                $Self->{View}   = $Self->{ParamObject}->GetParam( Param => 'View' )   || '';

                # show changes
                my $LinkPage = 'Filter='
                    . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{Filter} )
                    . '&View=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{View} )
                    . '&SortBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{SortBy} )
                    . '&OrderBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{OrderBy} )
                    . '&Profile=' . $Self->{Profile} . '&TakeLastSearch=1&Subaction=Search'
                    . '&';
                my $LinkSort = 'Filter='
                    . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{Filter} )
                    . '&View=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{View} )
                    . '&Profile=' . $Self->{Profile} . '&TakeLastSearch=1&Subaction=Search'
                    . '&';
                my $LinkFilter = 'TakeLastSearch=1&Subaction=Search&Profile='
                    . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{Profile} )
                    . '&';
                my $LinkBack = 'Subaction=LoadProfile&Profile='
                    . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{Profile} )
                    . '&TakeLastSearch=1&';

                # find out which columns should be shown
                my @ShowColumns;
                if ( $Self->{Config}->{ShowColumns} ) {

                    # get all possible columns from config
                    my %PossibleColumn = %{ $Self->{Config}->{ShowColumns} };

                    # get the column names that should be shown
                    COLUMNNAME:
                    for my $Name ( keys %PossibleColumn ) {
                        next COLUMNNAME if !$PossibleColumn{$Name};
                        push @ShowColumns, $Name;
                    }
                }

                $Output .= $Self->{LayoutObject}->ITSMChangeListShow(
                    ChangeIDs   => $ViewableChangeIDs,
                    Total       => scalar @{$ViewableChangeIDs},
                    View        => $Self->{View},
                    Env         => $Self,
                    LinkPage    => $LinkPage,
                    LinkSort    => $LinkSort,
                    LinkFilter  => $LinkFilter,
                    LinkBack    => $LinkBack,
                    TitleName   => 'Change Search Result',
                    ShowColumns => \@ShowColumns,
                );

                # build footer
                $Output .= $Self->{LayoutObject}->Footer();

                return $Output;
            }
        }
    }

    # There was no 'SubAction', or there were validation errors, or an user or customer was searched
    # generate search mask
    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();
    $Output .= $Self->_MaskForm(
        %GetParam,
        %ExpandInfo,
        ValidationErrors => \@ValidationErrors,
    );
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

sub _MaskForm {
    my ( $Self, %Param ) = @_;

    # Get a complete list of users
    # for the selection 'ChangeBuilder', 'ChangeManager' and 'created by user'.
    # Out of office nice might be appended to the values.
    my %Users = $Self->{UserObject}->UserList(
        Type  => 'Long',
        Valid => 1,
    );

    # dropdown menu for 'created by users'
    $Param{'CreateBySelectionString'} = $Self->{LayoutObject}->BuildSelection(
        Data       => \%Users,
        Name       => 'CreateBy',
        Multiple   => 1,
        Size       => 5,
        SelectedID => $Param{CreateBy},
    );

    # build change manager dropdown
    $Param{'ChangeManagerSelectionString'} = $Self->{LayoutObject}->BuildSelection(
        Data       => \%Users,
        Name       => 'ChangeManagerIDs',
        Multiple   => 1,
        Size       => 5,
        SelectedID => $Param{ChangeManagerIDs},
    );

    # build change builder dropdown
    $Param{'ChangeBuilderSelectionString'} = $Self->{LayoutObject}->BuildSelection(
        Data       => \%Users,
        Name       => 'ChangeBuilderIDs',
        Multiple   => 1,
        Size       => 5,
        SelectedID => $Param{ChangeBuilderIDs},
    );

    # get possible Change Categories
    my $Categories = $Self->{ChangeObject}->ChangePossibleCIPGet(
        Type   => 'Category',
        UserID => $Self->{UserID},
    );
    $Param{'ChangeCategorySelectionString'} = $Self->{LayoutObject}->BuildSelection(
        Data       => $Categories,
        Name       => 'CategoryIDs',
        Multiple   => 1,
        Size       => 5,
        SelectedID => $Param{CategoryIDs},
    );

    # get possible Change Impacts
    my $Impacts = $Self->{ChangeObject}->ChangePossibleCIPGet(
        Type   => 'Impact',
        UserID => $Self->{UserID},
    );
    $Param{'ChangeImpactSelectionString'} = $Self->{LayoutObject}->BuildSelection(
        Data       => $Impacts,
        Name       => 'ImpactIDs',
        Multiple   => 1,
        Size       => 5,
        SelectedID => $Param{ImpactIDs},
    );

    # get possible Change Priorities
    my $Priorities = $Self->{ChangeObject}->ChangePossibleCIPGet(
        Type   => 'Priority',
        UserID => $Self->{UserID},
    );
    $Param{'ChangePrioritySelectionString'} = $Self->{LayoutObject}->BuildSelection(
        Data       => $Priorities,
        Name       => 'PriorityIDs',
        Multiple   => 1,
        Size       => 5,
        SelectedID => $Param{PriorityIDs},
    );

    # get change states
    my $ChangeStates = $Self->{ChangeObject}->ChangePossibleStatesGet(
        UserID => $Self->{UserID},
    );
    $Param{'ChangeStateSelectionString'} = $Self->{LayoutObject}->BuildSelection(
        Data       => $ChangeStates,
        Name       => 'ChangeStateIDs',
        Multiple   => 1,
        Size       => 5,
        SelectedID => $Param{ChangeStateIDs},
    );

    # get workorder agents
    $Param{'WorkOrderAgentIDSelectionString'} = $Self->{LayoutObject}->BuildSelection(
        Data       => \%Users,
        Name       => 'WorkOrderAgentIDs',
        Multiple   => 1,
        Size       => 5,
        SelectedID => $Param{WorkOrderAgentIDs},
    );

    # get workorder states
    my $WorkOrderStates = $Self->{WorkOrderObject}->WorkOrderPossibleStatesGet(
        UserID => 1,
    );
    $Param{'WorkOrderStateSelectionString'} = $Self->{LayoutObject}->BuildSelection(
        Data       => $WorkOrderStates,
        Name       => 'WorkOrderStateIDs',
        Multiple   => 1,
        Size       => 5,
        SelectedID => $Param{WorkOrderStateIDs},
    );

    # number of minutes, days, weeks, months and years
    my %OneToFiftyNine = map { $_ => sprintf '%2s', $_ } ( 1 .. 59 );

    # time period that can be selected from the GUI
    my %TimePeriod = %{ $Self->{ConfigObject}->Get('ITSMWorkOrder::TimePeriod') };

    # setup for the time search fields
    my @TimeTypes = (
        { Prefix => 'Requested',    Title => 'Requested (by customer) Date', },
        { Prefix => 'PlannedStart', Title => 'PlannedStartTime', },
        { Prefix => 'PlannedEnd',   Title => 'PlannedEndTime', },
        { Prefix => 'ActualStart',  Title => 'ActualStartTime', },
        { Prefix => 'ActualEnd',    Title => 'ActualEndTime', },
        { Prefix => 'Create',       Title => 'CreateTime', },
        { Prefix => 'Change',       Title => 'ChangeTime', },
    );

    TIMETYPE:
    for my $TimeType (@TimeTypes) {
        my $Prefix = $TimeType->{Prefix};

        # show RequestedTime only when enabled in SysConfig
        if ( $Prefix eq 'Requested' && !$Self->{Config}->{RequestedTime} ) {
            next TIMETYPE;
        }

        my $Title             = $Self->{LayoutObject}->{LanguageObject}->Get( $TimeType->{Title} );
        my %TimeSelectionData = (
            Prefix => $Prefix,
            Title  => $Title,
        );

        # set radio button for time search types
        my $SearchType = $Prefix . 'TimeSearchType';
        if ( !$Param{$SearchType} ) {
            $TimeSelectionData{'TimeSearchType::None'} = 'checked="checked"';
        }
        elsif ( $Param{$SearchType} eq 'TimePoint' ) {
            $TimeSelectionData{'TimeSearchType::TimePoint'} = 'checked="checked"';
        }
        elsif ( $Param{$SearchType} eq 'TimeSlot' ) {
            $TimeSelectionData{'TimeSearchType::TimeSlot'} = 'checked="checked"';
        }

        $TimeSelectionData{TimePoint} = $Self->{LayoutObject}->BuildSelection(
            Data       => \%OneToFiftyNine,
            Name       => $Prefix . 'TimePoint',
            SelectedID => $Param{ $Prefix . 'TimePoint' },
        );

        $TimeSelectionData{TimePointStart} = $Self->{LayoutObject}->BuildSelection(
            Data => {
                'Last'   => 'last',
                'Before' => 'before',
            },
            Name => $Prefix . 'TimePointStart',
            SelectedID => $Param{ $Prefix . 'TimePointStart' } || 'Last',
        );

        $TimeSelectionData{TimePointFormat} = $Self->{LayoutObject}->BuildSelection(
            Data => {
                minute => 'minute(s)',
                hour   => 'hour(s)',
                day    => 'day(s)',
                week   => 'week(s)',
                month  => 'month(s)',
                year   => 'year(s)',
            },
            Name       => $Prefix . 'TimePointFormat',
            SelectedID => $Param{ $Prefix . 'TimePointFormat' },
        );

        $TimeSelectionData{TimeStart} = $Self->{LayoutObject}->BuildDateSelection(
            %Param,
            %TimePeriod,
            Prefix   => $Prefix . 'TimeStart',
            Format   => 'DateInputFormat',
            DiffTime => -( ( 60 * 60 * 24 ) * 30 ),
        );

        $TimeSelectionData{TimeStop} = $Self->{LayoutObject}->BuildDateSelection(
            %Param,
            %TimePeriod,
            Prefix => $Prefix . 'TimeStop',
            Format => 'DateInputFormat',
        );

        # show time field
        $Self->{LayoutObject}->Block(
            Name => 'TimeSelection',
            Data => \%TimeSelectionData,
        );

        # show time type specific validation errors
        if ( grep { $_ eq $Prefix . 'InvalidTimeSlot' } @{ $Param{ValidationErrors} } ) {
            $Self->{LayoutObject}->Block(
                Name => 'InvalidTimeSlot',
                Data => \%TimeSelectionData,
            );
        }
    }

    TIMETYPE:
    for my $TimeType (@TimeTypes) {
        my $Prefix = $TimeType->{Prefix};

        # show RequestedTime only when enabled in SysConfig
        if ( $Prefix eq 'Requested' && !$Self->{Config}->{RequestedTime} ) {
            next TIMETYPE;
        }

        # show JS code for time field
        $Self->{LayoutObject}->Block(
            Name => 'TimeSelectionJS',
            Data => {
                Prefix => $Prefix,
            },
        );
    }

    # build customer search autocomplete field for CABCustomer
    my $CustomerAutoCompleteConfig
        = $Self->{ConfigObject}->Get('ITSMChange::Frontend::CustomerSearchAutoComplete');
    if ( $CustomerAutoCompleteConfig->{Active} ) {
        $Self->{LayoutObject}->Block(
            Name => 'CustomerSearchAutoComplete',
            Data => {
                minQueryLength => $CustomerAutoCompleteConfig->{MinQueryLength} || 2,
                queryDelay     => $CustomerAutoCompleteConfig->{QueryDelay}     || 0.1,
                typeAhead      => $CustomerAutoCompleteConfig->{TypeAhead}      || 'false',
                maxResultsDisplayed => $CustomerAutoCompleteConfig->{MaxResultsDisplayed} || 20,
            },
        );
        $Self->{LayoutObject}->Block(
            Name => 'CABCustomerSearchAutoCompleteDivStart',
        );
        $Self->{LayoutObject}->Block(
            Name => 'CABCustomerSearchAutoCompleteDivEnd',
        );
    }
    else {
        $Self->{LayoutObject}->Block(
            Name => 'SearchCustomerButton',
        );
    }

    # build user search autocomplete field for CABAgent
    my $UserAutoCompleteConfig
        = $Self->{ConfigObject}->Get('ITSMChange::Frontend::UserSearchAutoComplete');
    if ( $UserAutoCompleteConfig->{Active} ) {

        # general blocks
        $Self->{LayoutObject}->Block(
            Name => 'UserSearchAutoComplete',
        );

        # CABAgent
        $Self->{LayoutObject}->Block(
            Name => 'UserSearchAutoCompleteCode',
            Data => {
                minQueryLength      => $UserAutoCompleteConfig->{MinQueryLength}      || 2,
                queryDelay          => $UserAutoCompleteConfig->{QueryDelay}          || 0.1,
                typeAhead           => $UserAutoCompleteConfig->{TypeAhead}           || 'false',
                maxResultsDisplayed => $UserAutoCompleteConfig->{MaxResultsDisplayed} || 20,
                InputNr             => 1,
            },
        );

        # return for CABAgent
        $Self->{LayoutObject}->Block(
            Name => 'UserSearchAutoCompleteReturnElements',
            Data => {
                InputNr => 1,
            },
        );

        # CABAgent
        $Self->{LayoutObject}->Block(
            Name => 'CABAgentSearchAutoCompleteDivStart1',
        );
        $Self->{LayoutObject}->Block(
            Name => 'CABAgentSearchAutoCompleteDivEnd1',
        );
    }
    else {

        # show usersearch buttons for CABAgent
        $Self->{LayoutObject}->Block(
            Name => 'SearchUserButton1',
        );
    }

    # build output
    my $Output = $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMChangeSearch',
        Data         => \%Param,
    );

    return $Output;
}

sub _GetExpandInfo {
    my ( $Self, %Param ) = @_;

    my %Info;    # this hash will be returned

    # get group id for the group 'itsm-change'.
    my $ITSMChangeGroupID = $Self->{GroupObject}->GroupLookup(
        Group => 'itsm-change',
    );

    # get members of group 'itsm-change'.
    # Only members of this group may be CABAgents.
    # TODO: what about agents that were removed from 'itsm-change', but are still CAB members ?
    my %ITSMChangeUsers = $Self->{GroupObject}->GroupMemberList(
        GroupID => $ITSMChangeGroupID,
        Type    => 'ro',
        Result  => 'HASH',
        Cached  => 1,
    );

    # currently the only Agent search is for 'CABAgent', but more might be added
    for my $Name (qw(CABAgent)) {

        # the fields in .dtl have a number at the end
        my $Key = 1;

        # handle the "search user" button
        if ( $Param{ 'Expand' . $Name . '1' } ) {

            # search for agents
            my %UserFound = $Self->{UserObject}->UserSearch(
                Search => $Param{$Name} . '*',
                Valid  => 1,
            );

            # UserSearch() returns values with a trailing space, get rid of it
            for my $Name ( values %UserFound ) {
                $Name =~ s{ \s+ \z }{}xms;
            }

            # filter the itsm-change users in found users
            my %UserList;
            USERID:
            for my $UserID ( keys %ITSMChangeUsers ) {
                next USERID if !$UserFound{$UserID};

                $UserList{$UserID} = $UserFound{$UserID};
            }

            # if a single user was found, fill up SelectedUser and the search field
            my @KeysUserList = keys %UserList;
            if ( scalar @KeysUserList == 1 ) {

                # if user is found, display the name
                $Info{$Name} = $UserList{ $KeysUserList[0] };

                # get user
                my %UserData = $Self->{UserObject}->GetUserData(
                    UserID => $KeysUserList[0],
                );

                # if user is found set hidden field,
                # this is the id that will actually be used in ChangeSearch
                if ( $UserData{UserID} ) {
                    $Info{ 'SelectedUser' . $Key } = $UserData{UserID};
                }
            }

            # if no or more the one user was found, show list
            # and clean UserID
            else {

                # reset input field
                $Info{ 'SelectedUser' . $Key } = '';

                # build drop down with found users
                $Info{ $Name . 'SelectionString' } = $Self->{LayoutObject}->BuildSelection(
                    Name => $Name . 'ID',
                    Data => \%UserList,
                );

                # show 'take this user' button
                $Self->{LayoutObject}->Block(
                    Name => 'Take' . $Name,
                );

                # clear the selected user if no user was found
                if ( !%UserList ) {
                    $Info{$Name} = '';
                    $Info{ 'SelectedUser' . $Key } = '';
                }
            }
        }

        # handle the "take this user" button
        elsif ( $Param{ 'Expand' . $Name . '2' } ) {

            # show user data
            my $UserID   = $Param{ $Name . 'ID' };
            my %UserData = $Self->{UserObject}->GetUserData(
                UserID => $UserID,
            );

            # if user is found
            if (%UserData) {

                # set hidden field
                $Info{ 'SelectedUser' . $Key } = $UserID;
                $Info{$Name} = sprintf '"%s %s" <%s>',
                    $UserData{UserFirstname},
                    $UserData{UserLastname},
                    $UserData{UserEmail};
            }
        }
    }

    # search for CABCustomer
    if ( $Param{ExpandCABCustomer1} ) {

        # search customers
        my %CustomerUserFound = $Self->{CustomerUserObject}->CustomerSearch(
            Search => $Param{CABCustomer} . '*',
            Valid  => 1,
        );

        # save found customer users in @CustomerUserList
        my @CustomerUserList;
        for my $CustomerUserID ( keys %CustomerUserFound ) {

            push @CustomerUserList, {
                Name => $CustomerUserFound{$CustomerUserID},
                ID   => $CustomerUserID,
            };
        }

        # check if just one customer user exists
        # if just one, fillup CustomerUserID and CustomerID
        if ( scalar @CustomerUserList == 1 ) {

            # if user is found, display the name
            $Info{CABCustomer} = $CustomerUserList[0]->{Name};

            # set hidden field when a customer user is found
            # this is the id that will actually be used in ChangeSearch
            $Info{'SelectedCustomerUser'} = $CustomerUserList[0]->{ID};
        }

        # if more the one user exists, show list
        # and clean UserID
        else {

            # build list for drop down
            my @UserListForDropDown;
            for my $User (@CustomerUserList) {
                push @UserListForDropDown, {
                    Key   => $User->{ID},
                    Value => $User->{Name},
                };
            }

            # reset input field
            $Info{CABCustomer} = '';

            # build drop down with found customer users
            $Info{CABCustomerSelectionString} = $Self->{LayoutObject}->BuildSelection(
                Name => 'CABCustomerID',
                Data => \@UserListForDropDown,
            );

            # show 'take this user' button
            $Self->{LayoutObject}->Block(
                Name => 'TakeCABCustomer',
            );

            # clear to if there is no customer found
            if ( !@CustomerUserList ) {
                $Info{'CABCustomer'}   = '';
                $Info{'CABCustomerID'} = '';
            }
        }
    }

    # handle the "take this user" button
    elsif ( $Param{ExpandCABCustomer2} ) {

        # show user data
        my $CustomerUserID = $Param{'CABCustomerID'};
        my %UserData;

        # get customer user data
        my %CustomerUserData = $Self->{CustomerUserObject}->CustomerUserDataGet(
            User  => $CustomerUserID,
            Valid => 1,
        );

        # if user is found
        if (%CustomerUserData) {

            # set hidden field
            $Info{SelectedCustomerUser} = $CustomerUserID;
            $Info{CABCustomer}          = sprintf '"%s %s" <%s>',
                $CustomerUserData{UserFirstname},
                $CustomerUserData{UserLastname},
                $CustomerUserData{UserEmail};
        }
    }

    return %Info;
}

1;
