# --
# Kernel/Output/HTML/LayoutITSMChange.pm - provides generic HTML output for ITSMChange
# Copyright (C) 2003-2010 OTRS AG, http://otrs.com/
# --
# $Id: LayoutITSMChange.pm,v 1.33 2010-01-13 00:34:24 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::LayoutITSMChange;

use strict;
use warnings;

use POSIX qw(ceil);

use Kernel::Output::HTML::Layout;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.33 $) [1];

=over 4

=item ITSMChangeBuildWorkOrderGraph()

returns a output string for WorkOrder graph

    my $String = $LayoutObject->ITSMChangeBuildWorkOrderGraph(
        Change => $ChangeRef,
        WorkOrderObject => $WorkOrderObject,
    );

=cut

sub ITSMChangeBuildWorkOrderGraph {
    my ( $Self, %Param ) = @_;

    # check needed objects
    for my $Object (qw(TimeObject ConfigObject)) {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError(
                Message => "Got no $Object!",
            );
            return;
        }
    }

    # check for change
    my $Change = $Param{Change};
    if ( !$Change ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Change!',
        );
        return;
    }

    # check workorder object
    if ( !$Param{WorkOrderObject} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need WorkOrderObject!',
        );
        return;
    }

    # store workorder object locally
    $Self->{WorkOrderObject} = $Param{WorkOrderObject};

    # check if workorders are available
    return if !$Change->{WorkOrderCount};

    # extra check for ARRAY-ref
    return if ref $Change->{WorkOrderIDs} ne 'ARRAY';

    # hash for smallest time
    my %Time;

    TIMETYPE:
    for my $TimeType (qw(Start End)) {

        # actual time not set, so we can use planned
        if ( !$Change->{"Actual${TimeType}Time"} ) {

            # check if time is set
            next TIMETYPE if !$Change->{"Planned${TimeType}Time"};

            # translate to timestamp
            $Time{"${TimeType}Time"} = $Self->{TimeObject}->TimeStamp2SystemTime(
                String => $Change->{"Planned${TimeType}Time"},
            );

            # jump to next type
            next TIMETYPE;
        }

        # translate planned time to timestamp for equation
        $Time{"Planned${TimeType}Time"} = $Self->{TimeObject}->TimeStamp2SystemTime(
            String => $Change->{"Planned${TimeType}Time"},
        );

        # translate actual time to timestamp for equation
        $Time{"Actual${TimeType}Time"} = $Self->{TimeObject}->TimeStamp2SystemTime(
            String => $Change->{"Actual${TimeType}Time"},
        );
    }

    # get smallest start time
    if ( !$Time{StartTime} ) {
        $Time{StartTime}
            = ( $Time{PlannedStartTime} < $Time{ActualStartTime} )
            ? $Time{PlannedStartTime}
            : $Time{ActualStartTime};
    }

    # get highest end time
    if ( !$Time{EndTime} ) {
        $Time{EndTime}
            = ( $Time{PlannedEndTime} > $Time{ActualEndTime} )
            ? $Time{PlannedEndTime}
            : $Time{ActualEndTime};
    }

    # calculate ticks for change
    my $ChangeTicks = $Self->_ITSMChangeGetChangeTicks(
        Start => $Time{StartTime},
        End   => $Time{EndTime},
    );

    # check for valid ticks
    if ( !$ChangeTicks ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Unable to calculate time scale.',
        );
    }

    # get workorders of change
    my @WorkOrders;
    WORKORDERID:
    for my $WorkOrderID ( @{ $Change->{WorkOrderIDs} } ) {
        my $WorkOrder = $Self->{WorkOrderObject}->WorkOrderGet(
            WorkOrderID => $WorkOrderID,
            UserID      => $Self->{UserID},
        );
        next WORKORDERID if !$WorkOrder;

        push @WorkOrders, $WorkOrder;
    }

    # get config settings
    my $ChangeZoomConfig = $Self->{ConfigObject}->Get('ITSMChange::Frontend::AgentITSMChangeZoom');

    # check config setting
    if ( !$ChangeZoomConfig ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need SysConfig settings for ITSMChange::Frontend::AgentITSMChangeZoom!',
        );
        return;
    }

    # check graph config setting
    if ( !$ChangeZoomConfig->{WorkOrderGraph} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need SysConfig settings for '
                . 'ITSMChange::Frontend::AgentITSMChangeZoom###WorkOrderGraph!',
        );
        return;
    }

    # validity settings of graph settings
    my %WorkOrderGraphCheck = (
        TimeLineColor           => '#[a-fA-F\d]{6}',
        TimeLineWidth           => '\d{1,2}',
        undefined_planned_color => '#[a-fA-F\d]{6}',
        undefined_actual_color  => '#[a-fA-F\d]{6}',
    );

    # check validity of graph settings
    my $WorkOrderGraphConfig = $ChangeZoomConfig->{WorkOrderGraph};
    for my $GraphSetting ( keys %WorkOrderGraphCheck ) {

        # check existense of config setting
        if ( !$WorkOrderGraphConfig->{$GraphSetting} ) {

            # display error and return
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need SysConfig setting '$GraphSetting' in "
                    . "ITSMChange::Frontend::AgentITSMChangeZoom###WorkOrderGraph!",
            );
            return;
        }

        # check validity of config setting
        if (
            $WorkOrderGraphConfig->{$GraphSetting}
            !~ m{ \A $WorkOrderGraphCheck{$GraphSetting} \z }xms
            )
        {

            # display error and return
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "SysConfig setting '$GraphSetting' is invalid in "
                    . "ITSMChange::Frontend::AgentITSMChangeZoom###WorkOrderGraph!",
            );
            return;
        }
    }

    # load graph sceleton
    $Self->Block(
        Name => 'WorkOrderGraph',
        Data => {},
    );

    # create color definitions for all configured workorder types
    my $WorkOrderTypes = $Self->{WorkOrderObject}->WorkOrderTypeList(
        UserID => $Self->{UserID},
    ) || [];

    # create css definitions for workorder types
    WORKORDERTYPE:
    for my $WorkOrderType ( @{$WorkOrderTypes} ) {

        # check workorder type
        next WORKORDERTYPE if !$WorkOrderType;
        next WORKORDERTYPE if !$WorkOrderType->{Value};

        # get name of workorder type
        my $WorkOrderTypeName = $WorkOrderType->{Value};

        # check contents of name
        next WORKORDERTYPE if !$WorkOrderTypeName;

        for my $WorkOrderColor (qw( _planned _actual )) {

            # get configured or fallback planned color for workorder
            my $WorkOrderTypeColor
                = $WorkOrderGraphConfig->{"${WorkOrderTypeName}${WorkOrderColor}_color"};

            # set default color if no color is found
            $WorkOrderTypeColor ||= $WorkOrderGraphConfig->{"undefined${WorkOrderColor}_color"};

            # check validity of workorder color
            if ( $WorkOrderTypeColor !~ m{ \A # [A-Za-z\d]{6} \z }xms ) {
                $WorkOrderTypeColor = $WorkOrderGraphConfig->{"undefined${WorkOrderColor}_color"};
            }

            # display css definitions for planned
            $Self->Block(
                Name => 'CSSWorkOrderType',
                Data => {
                    WorkOrderTypeName  => $WorkOrderTypeName . $WorkOrderColor,
                    WorkOrderTypeColor => $WorkOrderTypeColor,
                },
            );
        }
    }

    # calculate time line parameter
    my $TimeLine = $Self->_ITSMChangeGetTimeLine(
        StartTime => $Time{StartTime},
        EndTime   => $Time{EndTime},
        Ticks     => $ChangeTicks,
    );

    if ( $TimeLine && defined $TimeLine->{TimeLineLeft} ) {

        # calculate height of time line
        my $WorkOrderHeight = 16;
        my $ScaleMargin     = 11;
        $TimeLine->{TimeLineHeight} = ( ( scalar @WorkOrders ) * $WorkOrderHeight ) + $ScaleMargin;

        # display css of timeline
        $Self->Block(
            Name => 'CSSTimeLine',
            Data => {
                %{$TimeLine},
                %{$WorkOrderGraphConfig},
            },
        );

        # display timeline container
        $Self->Block(
            Name => 'TimeLine',
            Data => {},
        );
    }

    # sort workorder ascending to WorkOrderNumber
    @WorkOrders = sort { $a->{WorkOrderNumber} <=> $b->{WorkOrderNumber} } @WorkOrders;

    # build graph of each workorder
    WORKORDER:
    for my $WorkOrder (@WorkOrders) {
        next WORKORDER if !$WorkOrder;

        $Self->_ITSMChangeGetWorkOrderGraph(
            WorkOrder => $WorkOrder,
            StartTime => $Time{StartTime},
            EndTime   => $Time{EndTime},
            Ticks     => $ChangeTicks,
        );
    }

    # build scale of graph
    $Self->_ITSMChangeGetChangeScale(
        StartTime => $Time{StartTime},
        EndTime   => $Time{EndTime},
        Ticks     => $ChangeTicks,
    );

    # render graph and return HTML with ITSMChange.dtl template
    return $Self->Output(
        TemplateFile => 'ITSMChange',
        Data         => {%Param},
    );
}

=item ITSMChangeListShow()

Returns a list of changes as sortable list with pagination.

(This function is similar to TicketListShow() in Kernel/Output/HTML/LayoutTicket.pm)

    my $Output = $LayoutObject->ITSMChangeListShow(
        ChangeIDs  => $ChangeIDsRef,
        Total      => scalar @{ $ChangeIDsRef },
        View       => $Self->{View},
        Filter     => 'All',
        Filters    => \%NavBarFilter,
        FilterLink => $LinkFilter,
        TitleName  => 'Overview: Change',
        TitleValue => $Self->{Filter},
        Env        => $Self,
        LinkPage   => $LinkPage,
        LinkSort   => $LinkSort,
    );

=cut

sub ITSMChangeListShow {
    my ( $Self, %Param ) = @_;

    # take object ref to local, remove it from %Param (prevent memory leak)
    my $Env = $Param{Env};
    delete $Param{Env};

    # lookup latest used view mode
    if ( !$Param{View} && $Self->{ 'UserITSMChangeOverview' . $Env->{Action} } ) {
        $Param{View} = $Self->{ 'UserITSMChangeOverview' . $Env->{Action} };
    }

    # set defaut view mode to 'small'
    my $View = $Param{View} || 'Small';

    # store latest view mode
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'UserITSMChangeOverview' . $Env->{Action},
        Value     => $View,
    );

    # get backend from config
    my $Backends = $Self->{ConfigObject}->Get('ITSMChange::Frontend::Overview');
    if ( !$Backends ) {
        return $Env->{LayoutObject}->FatalError(
            Message => 'Need config option ITSMChange::Frontend::Overview',
        );
    }

    # check for hash-ref
    if ( ref $Backends ne 'HASH' ) {
        return $Env->{LayoutObject}->FatalError(
            Message => 'Config option ITSMChange::Frontend::Overview needs to be a HASH ref!',
        );
    }

    # check for config key
    if ( !$Backends->{$View} ) {
        return $Env->{LayoutObject}->FatalError(
            Message => "No Config option found for $View!",
        );
    }

    # nav bar
    my $StartHit = $Self->{ParamObject}->GetParam(
        Param => 'StartHit',
    ) || 1;

    # check start option, if higher then elements available, set
    # it to the last overview page (Thanks to Stefan Schmidt!)
    my $PageShown = $Backends->{$View}->{PageShown};
    if ( $StartHit > $Param{Total} ) {
        my $Pages = int( ( $Param{Total} / $PageShown ) + 0.99999 );
        $StartHit = ( ( $Pages - 1 ) * $PageShown ) + 1;
    }

    # set page limit and build page nav
    my $Limit = $Param{Limit} || 20_000;
    my %PageNav = $Env->{LayoutObject}->PageNavBar(
        Limit     => $Limit,
        StartHit  => $StartHit,
        PageShown => $PageShown,
        AllHits   => $Param{Total} || 0,
        Action    => 'Action=' . $Env->{LayoutObject}->{Action},
        Link      => $Param{LinkPage},
    );

    # build navbar content
    $Env->{LayoutObject}->Block(
        Name => 'OverviewNavBar',
        Data => \%Param,
    );

    # back link
    if ( $Param{LinkBack} ) {
        $Env->{LayoutObject}->Block(
            Name => 'OverviewNavBarPageBack',
            Data => \%Param,
        );
    }

    # get filters
    if ( $Param{Filters} ) {

        # get given filters
        my @NavBarFilters;
        for my $Prio ( sort keys %{ $Param{Filters} } ) {
            push @NavBarFilters, $Param{Filters}->{$Prio};
        }

        # build filter content
        $Env->{LayoutObject}->Block(
            Name => 'OverviewNavBarFilter',
            Data => {
                %Param,
            },
        );

        # loop over filters
        my $Count = 0;
        for my $Filter (@NavBarFilters) {

            # at least a second filter is set, build split content
            if ($Count) {
                $Env->{LayoutObject}->Block(
                    Name => 'OverviewNavBarFilterItemSplit',
                    Data => {
                        %Param,
                        %{$Filter},
                    },
                );
            }

            # increment filter count and build filter item
            $Count++;
            $Env->{LayoutObject}->Block(
                Name => 'OverviewNavBarFilterItem',
                Data => {
                    %Param,
                    %{$Filter},
                },
            );

            # filter is selected
            if ( $Filter->{Filter} eq $Param{Filter} ) {
                $Env->{LayoutObject}->Block(
                    Name => 'OverviewNavBarFilterItemSelected',
                    Data => {
                        %Param,
                        %{$Filter},
                    },
                );
            }
            else {
                $Env->{LayoutObject}->Block(
                    Name => 'OverviewNavBarFilterItemSelectedNot',
                    Data => {
                        %Param,
                        %{$Filter},
                    },
                );
            }
        }
    }

    # loop over configured backends
    for my $Backend ( keys %{$Backends} ) {

        # build navbar view mode
        $Env->{LayoutObject}->Block(
            Name => 'OverviewNavBarViewMode',
            Data => {
                %Param,
                %{ $Backends->{$Backend} },
                Filter => $Param{Filter},
                View   => $Backend,
            },
        );

        # current view is configured in backend
        if ( $View eq $Backend ) {
            $Env->{LayoutObject}->Block(
                Name => 'OverviewNavBarViewModeSelected',
                Data => {
                    %Param,
                    %{ $Backends->{$Backend} },
                    Filter => $Param{Filter},
                    View   => $Backend,
                },
            );
        }
        else {
            $Env->{LayoutObject}->Block(
                Name => 'OverviewNavBarViewModeNotSelected',
                Data => {
                    %Param,
                    %{ $Backends->{$Backend} },
                    Filter => $Param{Filter},
                    View   => $Backend,
                },
            );
        }
    }

    # check if page nav is available
    if (%PageNav) {
        $Env->{LayoutObject}->Block(
            Name => 'OverviewNavBarPageNavBar',
            Data => \%PageNav,
        );
    }

    # check if nav bar is available
    if ( $Param{NavBar} ) {
        if ( $Param{NavBar}->{MainName} ) {
            $Env->{LayoutObject}->Block(
                Name => 'OverviewNavBarMain',
                Data => $Param{NavBar},
            );
        }
    }

    # build html content
    my $OutputNavBar = $Env->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMChangeOverviewNavBar',
        Data         => {%Param},
    );

    # create output
    my $OutputRaw = '';
    if ( !$Param{Output} ) {
        $Env->{LayoutObject}->Print(
            Output => \$OutputNavBar,
        );
    }
    else {
        $OutputRaw .= $OutputNavBar;
    }

    # load module
    if ( !$Self->{MainObject}->Require( $Backends->{$View}->{Module} ) ) {
        return $Env->{LayoutObject}->FatalError();
    }

    # check for backend object
    my $Object = $Backends->{$View}->{Module}->new( %{$Env} );
    return if !$Object;

    # run module
    my $Output = $Object->Run(
        %Param,
        Limit     => $Limit,
        StartHit  => $StartHit,
        PageShown => $PageShown,
        AllHits   => $Param{Total} || 0,
    );

    # create output
    if ( !$Param{Output} ) {
        $Env->{LayoutObject}->Print(
            Output => \$Output,
        );
    }
    else {
        $OutputRaw .= $Output;
    }

    # create overview nav bar
    $Env->{LayoutObject}->Block(
        Name => 'OverviewNavBar',
        Data => {%Param},
    );

    # check for page nav and create content
    if (%PageNav) {
        $Env->{LayoutObject}->Block(
            Name => 'OverviewNavBarPageNavBar',
            Data => {%PageNav},
        );
    }

    # create smal nav bar
    my $OutputNavBarSmall = $Env->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMChangeOverviewNavBarSmall',
        Data         => {%Param},
    );

    # create output
    if ( !$Param{Output} ) {
        $Env->{LayoutObject}->Print(
            Output => \$OutputNavBarSmall,
        );
    }
    else {
        $OutputRaw .= $OutputNavBarSmall;
    }

    # return content if available
    return $OutputRaw;
}

=begin Internal:

=item _ITSMChangeGetChangeTicks()

a helper method for the workorder graph of a change

=cut

sub _ITSMChangeGetChangeTicks {
    my ( $Self, %Param ) = @_;

    # check for start and end
    return if !$Param{Start} || !$Param{End};

    # make sure we got integers
    return if $Param{Start} !~ m{ \A \d+ \z }xms;
    return if $Param{End} !~ m{ \A \d+ \z }xms;

    # calculate time span in sec
    my $Ticks = $Param{End} - $Param{Start};

    # check for computing error
    return if $Ticks <= 0;

    # get seconds per percent and round down
    $Ticks = ceil( $Ticks / 100 );

    return $Ticks;
}

=item _ITSMChangeGetChangeScale()

a helper method for the workorder graph of a change

=cut

sub _ITSMChangeGetChangeScale {
    my ( $Self, %Param ) = @_;

    # check for start time
    return if !$Param{StartTime};

    # check for start time is an integer value
    return if $Param{StartTime} !~ m{ \A \d+ \z }xms;

    # add start and end time and calculate scale naming
    my %ScaleName = (
        StartTime => $Param{StartTime},
        EndTime   => $Param{EndTime},
        Scale20   => ( $Param{StartTime} + 20 * $Param{Ticks} ),
        Scale40   => ( $Param{StartTime} + 40 * $Param{Ticks} ),
        Scale60   => ( $Param{StartTime} + 60 * $Param{Ticks} ),
        Scale80   => ( $Param{StartTime} + 80 * $Param{Ticks} ),
    );

    # translate timestamps in date format
    map {
        $ScaleName{$_} = $Self->{TimeObject}->SystemTime2TimeStamp(
            SystemTime => $ScaleName{$_}
            )
    } keys %ScaleName;

    # create scale block
    $Self->Block(
        Name => 'Scale',
        Data => {
            %ScaleName,
        },
    );

    INTERVAL:
    for my $Interval ( sort keys %ScaleName ) {

        # do not display scale if translating failed
        next INTERVAL if !$ScaleName{$Interval};

        # do not display start or end
        next INTERVAL if $Interval =~ m{ \A ( Start | End ) Time \z }xms;

        # build scale label block
        $Self->Block(
            Name => 'ScaleLabel',
            Data => {
                ScaleLabel => $ScaleName{$Interval},
            },
        );
    }
}

=item _ITSMChangeGetWorkOrderGraph()

a helper method for the workorder graph of a change

=cut

sub _ITSMChangeGetWorkOrderGraph {
    my ( $Self, %Param ) = @_;

    # check for workorder
    return if !$Param{WorkOrder};

    # extract workorder
    my $WorkOrder = $Param{WorkOrder};

    # save orig workorder for workorder information
    my %WorkOrderInformation = %{$WorkOrder};

    # translate workorder type
    $WorkOrder->{TranslatedWorkOrderType}
        = $Self->{LanguageObject}->Get( $WorkOrder->{WorkOrderType} );

    # build label for link in graph
    $WorkOrder->{WorkOrderLabel}
        = "Title: $WorkOrder->{WorkOrderTitle} | Type: $WorkOrder->{TranslatedWorkOrderType}";

    # create workorder item
    $Self->Block(
        Name => 'WorkOrderItem',
        Data => {
            %{$WorkOrder},
        },
    );

    # check if ticks are calculated
    return if !$Param{Ticks};

    # set planned if no actual time is set
    if ( !$WorkOrder->{ActualStartTime} ) {
        $WorkOrder->{ActualStartTime} = $WorkOrder->{PlannedStartTime};
        $WorkOrder->{ActualEndTime}   = $WorkOrder->{PlannedEndTime};
    }

    # set current time if no actual end time is set
    if ( $WorkOrder->{ActualStartTime} && !$WorkOrder->{ActualEndTime} ) {
        $WorkOrder->{ActualEndTime} = $Self->{TimeObject}->CurrentTimestamp();
    }

    # set nice display of undef actual times
    for my $TimeType (qw(ActualStartTime ActualEndTime)) {
        if ( !$WorkOrderInformation{$TimeType} ) {
            $WorkOrderInformation{"Empty${TimeType}"} = '-';
        }
    }

    # hash for time values
    my %Time;

    for my $TimeType (qw(PlannedStartTime PlannedEndTime ActualStartTime ActualEndTime)) {

        # translate time
        $Time{$TimeType} = $Self->{TimeObject}->TimeStamp2SystemTime(
            String => $WorkOrder->{$TimeType},
        );
    }

    # determine length of workorder
    my %TickValue;

    for my $TimeType (qw( Planned Actual )) {

        # get values for padding span
        $TickValue{"${TimeType}Padding"} = ceil(
            ( $Time{"${TimeType}StartTime"} - $Param{StartTime} ) / $Param{Ticks}
        );

        # get values for display span
        $TickValue{"${TimeType}Ticks"} = int(
            ( $Time{"${TimeType}EndTime"} - $Time{"${TimeType}StartTime"} ) / $Param{Ticks}
        ) || 1;

        # get at least 1 percent for display span
        # if padding would gain 100 percent
        $TickValue{"${TimeType}Padding"}
            = ( $TickValue{"${TimeType}Ticks"} == 1 && $TickValue{"${TimeType}Padding"} == 100 )
            ? 99
            : $TickValue{"${TimeType}Padding"};

        # get trailing space
        $TickValue{"${TimeType}Trailing"}
            = 100 - ( $TickValue{"${TimeType}Padding"} + $TickValue{"${TimeType}Ticks"} );

        # correct math
        if ( $TickValue{"${TimeType}Trailing"} == -1 ) {
            $TickValue{"${TimeType}Trailing"} = 0;
            $TickValue{"${TimeType}Ticks"} -= 1;
        }
    }

    # set workorder as inactive if it is not started jet
    if ( !$WorkOrderInformation{ActualStartTime} ) {
        $WorkOrderInformation{WorkOrderOpacity} = 'inactive';
    }

    # set workorder agent
    if ( $WorkOrderInformation{WorkOrderAgentID} ) {
        my %WorkOrderAgentData = $Self->{UserObject}->GetUserData(
            UserID => $WorkOrderInformation{WorkOrderAgentID},
            Cached => 1,
        );

        if (%WorkOrderAgentData) {

            # get WorkOrderAgent information
            for my $Postfix (qw(UserLogin UserFirstname UserLastname)) {
                $WorkOrderInformation{"WorkOrderAgent$Postfix"} = $WorkOrderAgentData{$Postfix}
                    || '';
            }
        }
    }

    # create graph of workorder item
    $Self->Block(
        Name => 'WorkOrderItemGraph',
        Data => {
            %WorkOrderInformation,
            %TickValue,
        },
    );

    # check the least thing: UserLogin
    if ( $WorkOrderInformation{WorkOrderAgentUserLogin} ) {
        $Self->Block(
            Name => 'WorkOrderAgent',
            Data => {
                %WorkOrderInformation,
            },
        );
    }
    else {
        $Self->Block(
            Name => 'EmptyWorkOrderAgent',
            Data => {
                %WorkOrderInformation,
            },
        );
    }
}

=item _ITSMChangeGetTimeLine()

a helper method for the workorder graph of a change

=cut

sub _ITSMChangeGetTimeLine {
    my ( $Self, %Param ) = @_;

    # check for start time
    return if !$Param{StartTime};

    # check for start time is an integer value
    return if $Param{StartTime} !~ m{ \A \d+ \z }xms;

    # check for end time
    return if !$Param{EndTime};

    # check for end time is an integer value
    return if $Param{EndTime} !~ m{ \A \d+ \z }xms;

    # check for ticks
    return if !$Param{Ticks};

    # check for ticks is an integer value
    return if $Param{Ticks} !~ m{ \A \d+ \z }xms;

    # get current system time
    my $CurrentTime = $Self->{TimeObject}->SystemTime();

    # check for system time
    return if !$CurrentTime;

    # check if current time is in change time interval
    return if $CurrentTime < $Param{StartTime};
    return if $CurrentTime > $Param{EndTime};

    # time line data
    my %TimeLine;

    # calculate percent of timeline
    my $RelativeEnd   = $Param{EndTime} - $Param{StartTime};
    my $RelativeStart = $CurrentTime - $Param{StartTime};
    $TimeLine{TimeLineLeft} = int( ( $RelativeStart / $RelativeEnd ) * 100 );

    return \%TimeLine;
}

=end Internal:

=back

=cut

1;
