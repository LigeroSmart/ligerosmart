# --
# Kernel/Output/HTML/LayoutITSMChange.pm - provides generic HTML output for ITSMChange
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::LayoutITSMChange;

use strict;
use warnings;

use Kernel::Output::HTML::Layout;

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
            = ( $Time{PlannedStartTime} lt $Time{ActualStartTime} )
            ? $Time{PlannedStartTime}
            : $Time{ActualStartTime};
    }

    # get highest end time
    if ( !$Time{EndTime} ) {
        $Time{EndTime}
            = ( $Time{PlannedEndTime} gt $Time{ActualEndTime} )
            ? $Time{PlannedEndTime}
            : $Time{ActualEndTime};
    }

    # check for real end of end time for scale and graph items
    # only if ActualStartTime is set
    if (
        $Time{ActualStartTime}
        && !$Time{ActualEndTime}
        && ( $Time{EndTime} lt $Self->{TimeObject}->SystemTime() )
        )
    {
        $Time{EndTime} = $Self->{TimeObject}->SystemTime();
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
    for my $GraphSetting ( sort keys %WorkOrderGraphCheck ) {

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

    # compute effecive label width
    my $LabelWidth = 60;
    if ( $ChangeZoomConfig->{WorkOrderState} && $ChangeZoomConfig->{WorkOrderTitle} ) {
        $LabelWidth += 180;
    }
    elsif ( $ChangeZoomConfig->{WorkOrderState} ) {
        $LabelWidth += 70;
    }
    elsif ( $ChangeZoomConfig->{WorkOrderTitle} ) {
        $LabelWidth += 125;
    }

    # load graph skeleton
    $Self->Block(
        Name => 'WorkOrderGraph',
        Data => {
            LabelWidth  => $LabelWidth,
            LabelMargin => $LabelWidth + 2,
        },
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
        StartTime   => $Time{StartTime},
        EndTime     => $Time{EndTime},
        Ticks       => $ChangeTicks,
        LabelMargin => $LabelWidth + 2,
    );

    # render graph and return HTML with ITSMChange.dtl template
    return $Self->Output(
        TemplateFile => 'ITSMChange',
        Data         => {%Param},
    );
}

=item ITSMChangeListShow()

Returns a list of changes as sortable list with pagination.

This function is similar to L<Kernel::Output::HTML::LayoutTicket::TicketListShow()>
in F<Kernel/Output/HTML/LayoutTicket.pm>.

    my $Output = $LayoutObject->ITSMChangeListShow(
        ChangeIDs  => $ChangeIDsRef,                      # total list of change ids, that can be listed
        Total      => scalar @{ $ChangeIDsRef },          # total number of list items, changes in this case
        View       => $Self->{View},                      # optional, the default value is 'Small'
        Filter     => 'All',
        Filters    => \%NavBarFilter,
        FilterLink => $LinkFilter,
        TitleName  => 'Overview: Changes',
        TitleValue => $Self->{Filter},
        Env        => $Self,
        LinkPage   => $LinkPage,
        LinkSort   => $LinkSort,
        Frontend   => 'Agent',                           # optional (Agent|Customer), default: Agent, indicates from which frontend this function was called
    );

=cut

sub ITSMChangeListShow {
    my ( $Self, %Param ) = @_;

    # take object ref to local, remove it from %Param (prevent memory leak)
    my $Env = delete $Param{Env};

    # lookup latest used view mode
    if ( !$Param{View} && $Self->{ 'UserITSMChangeOverview' . $Env->{Action} } ) {
        $Param{View} = $Self->{ 'UserITSMChangeOverview' . $Env->{Action} };
    }

    # set frontend
    my $Frontend = $Param{Frontend} || 'Agent';

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
            Message => "No config option found for the view '$View'!",
        );
    }

    # nav bar
    my $StartHit = $Self->{ParamObject}->GetParam(
        Param => 'StartHit',
    ) || 1;

    # get personal page shown count
    my $PageShownPreferencesKey = 'UserChangeOverview' . $View . 'PageShown';
    my $PageShown               = $Self->{$PageShownPreferencesKey} || 10;
    my $Group                   = 'ChangeOverview' . $View . 'PageShown';

    # check start option, if higher then elements available, set
    # it to the last overview page (Thanks to Stefan Schmidt!)
    if ( $StartHit > $Param{Total} ) {
        my $Pages = int( ( $Param{Total} / $PageShown ) + 0.99999 );
        $StartHit = ( ( $Pages - 1 ) * $PageShown ) + 1;
    }

    # get data selection
    my %Data;
    my $Config = $Self->{ConfigObject}->Get('PreferencesGroups');
    if ( $Config && $Config->{$Group} && $Config->{$Group}->{Data} ) {
        %Data = %{ $Config->{$Group}->{Data} };
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

    # build shown ticket a page
    $Param{RequestedURL}    = $Param{RequestedURL} || "Action=$Self->{Action}";
    $Param{Group}           = $Group;
    $Param{PreferencesKey}  = $PageShownPreferencesKey;
    $Param{PageShownString} = $Self->BuildSelection(
        Name        => $PageShownPreferencesKey,
        SelectedID  => $PageShown,
        Data        => \%Data,
        Translation => 0,
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
    for my $Backend ( sort keys %{$Backends} ) {

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

        # don't show context settings in AJAX case (e. g. in customer ticket history),
        #   because the submit with page reload will not work there
        if ( !$Param{AJAX} ) {
            $Env->{LayoutObject}->Block(
                Name => 'ContextSettings',
                Data => {
                    %PageNav,
                    %Param,
                },
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
        Frontend  => $Frontend,
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

    # return content if available
    return $OutputRaw;
}

=item BuildFreeTextHTML()

Returns the a hash with HTML code for all defined change or workorder freetext fields.

    my %ChangeFreeTextHTML = $LayoutObject->BuildFreeTextHTML(
        Config                   => \%ChangeFreeTextConfig,
        ChangeData               => \%ChangeFreeTextParam,
        Multiple                 => 1,                             # optional (0|1) default 0
        ConfiguredFreeTextFields => [ 1, 2, 3 ],
    );

or

    my %WorkOrderFreeTextHTML = $LayoutObject->BuildFreeTextHTML(
        Config                   => \%WorkOrderFreeTextConfig,
        WorkOrderData            => \%WorkOrderFreeTextParam,
        Multiple                 => 1,                             # optional (0|1) default 0
        ConfiguredFreeTextFields => [ 4, 5, 6 ],
    );

=cut

sub BuildFreeTextHTML {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Attribute (qw(ConfiguredFreeTextFields)) {
        if ( !$Param{$Attribute} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Attribute!",
            );
            return;
        }
    }

    # check that not both ChangeData and WorkOrderData are given
    if ( $Param{ChangeData} && $Param{WorkOrderData} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need either ChangeData OR WorkOrderData - not both!',
        );
        return;
    }

    # get the config data
    my %Config;
    if ( $Param{Config} ) {
        %Config = %{ $Param{Config} };
    }

    # get the input data and the type (Change or Workorder)
    my %InputData;
    my $Type;
    if ( $Param{ChangeData} ) {
        $Type      = 'Change';
        %InputData = %{ $Param{ChangeData} };
    }
    elsif ( $Param{WorkOrderData} ) {
        $Type      = 'WorkOrder';
        %InputData = %{ $Param{WorkOrderData} };
    }

    # to store the result HTML data
    my %Data;

    # build HTML for all configured fields
    for my $Number ( @{ $Param{ConfiguredFreeTextFields} } ) {

        # freekey config exists
        if (
            ref $Config{ $Type . 'FreeKey' . $Number } eq 'HASH'
            && %{ $Config{ $Type . 'FreeKey' . $Number } }
            )
        {

            # get all config keys for this field
            my @ConfigKeys = keys %{ $Config{ $Type . 'FreeKey' . $Number } };

            # more than one config option exists
            if ( scalar @ConfigKeys > 1 ) {

                # check if NullOption is requested (needed in search forms)
                my $PossibleNone = 0;
                if ( $Param{NullOption} ) {

                    # only if data does not already contain a null entry
                    if (
                        !$Config{ $Type . 'FreeKey' . $Number }->{''}
                        || $Config{ $Type . 'FreeKey' . $Number }->{''} ne '-'
                        )
                    {
                        $PossibleNone = 1;
                    }
                }

                # build dropdown list
                $Data{ $Type . 'FreeKeyField' . $Number } = $Self->BuildSelection(
                    Data         => $Config{ $Type . 'FreeKey' . $Number },
                    Name         => $Type . 'FreeKey' . $Number,
                    SelectedID   => $InputData{ $Type . 'FreeKey' . $Number },
                    Translation  => 0,
                    HTMLQuote    => 1,
                    PossibleNone => $PossibleNone,
                    Multiple     => $Param{Multiple} || 0,
                );
            }

            # just one config option exists and the only key is not an empty string
            elsif ( $ConfigKeys[0] ) {

                #  the null option is set
                if ( $Param{NullOption} ) {

                    # build just a text string
                    $Data{ $Type . 'FreeKeyField' . $Number }
                        = $Config{ $Type . 'FreeKey' . $Number }->{ $ConfigKeys[0] };
                }

                # no null option is set
                else {

                    # build a hidden input field
                    $Data{ $Type . 'FreeKeyField' . $Number }
                        = $Config{ $Type . 'FreeKey' . $Number }->{ $ConfigKeys[0] }
                        . '<input type="hidden" name="'
                        . $Type . 'FreeKey' . $Number
                        . '" value="'
                        . $Self->Ascii2Html( Text => $ConfigKeys[0] ) . '"/>';
                }
            }
        }
        else {

            # freekey data is defined
            if ( defined $InputData{ $Type . 'FreeKey' . $Number } ) {

                # freekey data is an array
                if ( ref $InputData{ $Type . 'FreeKey' . $Number } eq 'ARRAY' ) {

                    # take first element...
                    if ( $InputData{ $Type . 'FreeKey' . $Number }->[0] ) {
                        $InputData{ $Type . 'FreeKey' . $Number }
                            = $InputData{ $Type . 'FreeKey' . $Number }->[0];
                    }

                    # ...or nothing
                    else {
                        $InputData{ $Type . 'FreeKey' . $Number } = '';
                    }
                }

                # build input field with freekey data
                $Data{ $Type . 'FreeKeyField' . $Number }
                    = '<input type="text" id="'
                    . $Type . 'FreeKey' . $Number
                    . '" name="'
                    . $Type . 'FreeKey' . $Number
                    . '" value="'
                    . $Self->Ascii2Html( Text => $InputData{ $Type . 'FreeKey' . $Number } )
                    . '" />';
            }

            # freekey data is not defined
            else {

                # build empty input field
                $Data{ $Type . 'FreeKeyField' . $Number }
                    = '<input type="text" id="'
                    . $Type . 'FreeKey' . $Number
                    . '" name="'
                    . $Type . 'FreeKey' . $Number
                    . '" value="" />';
            }
        }

        # build Validate and Error classes
        my $ValidationClass       = '';
        my $MandatoryClass        = '';
        my $MandatoryMarkerString = '';
        my $ToolTipString         = '';

        # field is a required field
        if ( $Config{Required}->{$Number} ) {

            $ValidationClass       = 'Validate_Required ';
            $MandatoryClass        = 'class="Mandatory"';
            $MandatoryMarkerString = '<span class="Marker">*</span> ';
            $ToolTipString         = '<div id="' . $Type . 'FreeText' . $Number . 'Error" '
                . 'class="TooltipErrorMessage"><p>$Text{"This field is required."}</p></div>';
        }

        # server error occured, add server error class and tooltip
        if ( $InputData{Error}->{$Number} ) {

            $ValidationClass .= 'ServerError ';
            $ToolTipString   .= '<div id="' . $Type . 'FreeText' . $Number . 'ServerError" '
                . 'class="TooltipErrorMessage"><p>$Text{"This field is required."}</p></div>';
        }

        # build freekey string
        $Data{ $Type . 'FreeKeyField' . $Number }
            = '<label id="Label' . $Type . 'FreeText' . $Number . '" '
            . 'for="' . $Type . 'FreeText' . $Number . '" '
            . $MandatoryClass
            . '>'
            . $MandatoryMarkerString
            . $Data{ $Type . 'FreeKeyField' . $Number }
            . ':</label>';

        # freetext config exists
        if ( ref $Config{ $Type . 'FreeText' . $Number } eq 'HASH' ) {

            # check if NullOption is requested (needed in search forms)
            my $PossibleNone = 0;
            if ( $Param{NullOption} ) {

                # only if data does not already contain a null entry
                if (
                    !$Config{ $Type . 'FreeText' . $Number }->{''}
                    || $Config{ $Type . 'FreeText' . $Number }->{''} ne '-'
                    )
                {
                    $PossibleNone = 1;
                }
            }

            # build dropdown list
            $Data{ $Type . 'FreeTextField' . $Number } = $Self->BuildSelection(
                Data         => $Config{ $Type . 'FreeText' . $Number },
                Name         => $Type . 'FreeText' . $Number,
                SelectedID   => $InputData{ $Type . 'FreeText' . $Number },
                Translation  => 0,
                HTMLQuote    => 1,
                PossibleNone => $PossibleNone,
                Multiple     => $Param{Multiple} || 0,
                Class        => $ValidationClass,
            );

            # add tooltips for validation error
            $Data{ $Type . 'FreeTextField' . $Number } .= $ToolTipString;
        }
        else {

            # freetext data is defined
            if ( defined $InputData{ $Type . 'FreeText' . $Number } ) {

                # freetext data is an array
                if ( ref $InputData{ $Type . 'FreeText' . $Number } eq 'ARRAY' ) {

                    # take first element...
                    if ( $InputData{ $Type . 'FreeText' . $Number }->[0] ) {
                        $InputData{ $Type . 'FreeText' . $Number }
                            = $InputData{ $Type . 'FreeText' . $Number }->[0];
                    }

                    # ...or nothing
                    else {
                        $InputData{ $Type . 'FreeText' . $Number } = '';
                    }
                }

                # build input field with freetext data
                $Data{ $Type . 'FreeTextField' . $Number }
                    = '<input type="text" class="W75pc '
                    . $ValidationClass
                    . '" id="'
                    . $Type . 'FreeText' . $Number
                    . '" name="'
                    . $Type . 'FreeText' . $Number
                    . '" value="'
                    . $Self->Ascii2Html( Text => $InputData{ $Type . 'FreeText' . $Number } )
                    . '" />';

                # add tooltips for validation error
                $Data{ $Type . 'FreeTextField' . $Number } .= $ToolTipString;
            }

            # freetext data is not defined
            else {

                # build empty input field
                $Data{ $Type . 'FreeTextField' . $Number }
                    = '<input type="text" class="W75pc '
                    . $ValidationClass
                    . '" id="'
                    . $Type . 'FreeText' . $Number
                    . '" name="'
                    . $Type . 'FreeText' . $Number
                    . '" value="" />';

                # add tooltips for validation error
                $Data{ $Type . 'FreeTextField' . $Number } .= $ToolTipString;
            }
        }
    }

    return %Data;
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
    $Ticks = sprintf( "%.f", $Ticks / 100 );

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
        Scale15   => ( $Param{StartTime} + 20 * $Param{Ticks} ),
        Scale35   => ( $Param{StartTime} + 40 * $Param{Ticks} ),
        Scale55   => ( $Param{StartTime} + 60 * $Param{Ticks} ),
        Scale75   => ( $Param{StartTime} + 80 * $Param{Ticks} ),
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
            LabelMargin => $Param{LabelMargin},
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
                ScaleClass => $Interval,
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

    # get config settings
    my $ChangeZoomConfig = $Self->{ConfigObject}->Get('ITSMChange::Frontend::AgentITSMChangeZoom');

    # add workorder state
    if ( $ChangeZoomConfig->{WorkOrderState} ) {
        $Self->Block(
            Name => 'WorkOrderItemState',
            Data => {
                %{$WorkOrder},
            },
        );
    }

    # add workorder title
    if ( $ChangeZoomConfig->{WorkOrderTitle} ) {
        $Self->Block(
            Name => 'WorkOrderItemTitle',
            Data => {
                %{$WorkOrder},
            },
        );
    }

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
        my $StartPadding = sprintf(
            "%.1f",
            ( $Time{"${TimeType}StartTime"} - $Param{StartTime} ) / $Param{Ticks}
        );
        $StartPadding = ( $StartPadding <= 0 )   ? 0    : $StartPadding;
        $StartPadding = ( $StartPadding >= 100 ) ? 99.9 : $StartPadding;
        $TickValue{"${TimeType}Padding"} = $StartPadding;

        # get values for trailing span
        my $EndTrailing
            = sprintf( "%.1f", ( $Param{EndTime} - $Time{"${TimeType}EndTime"} ) / $Param{Ticks} );
        $EndTrailing = ( $EndTrailing <= 0 )   ? 0    : $EndTrailing;
        $EndTrailing = ( $EndTrailing >= 100 ) ? 99.9 : $EndTrailing;
        $TickValue{"${TimeType}Trailing"} = $EndTrailing;

        # get values for display span
        my $TimeTicks
            = 100 - ( $TickValue{"${TimeType}Padding"} + $TickValue{"${TimeType}Trailing"} );
        $TimeTicks = ( $TimeTicks <= 0 )   ? 0.1  : $TimeTicks;
        $TimeTicks = ( $TimeTicks >= 100 ) ? 99.9 : $TimeTicks;
        $TickValue{"${TimeType}Ticks"} = sprintf( "%.1f", $TimeTicks );
    }

    # set workorder as inactive if it is not started jet
    if ( !$WorkOrderInformation{ActualStartTime} ) {
        $WorkOrderInformation{WorkOrderOpacity} = 'WorkorderInactive';
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

    # set the graph direction (LTR: left, RTL: right)
    if ( $Self->{TextDirection} && $Self->{TextDirection} eq 'rtl' ) {
        $WorkOrderInformation{"GraphDirection"} = 'right';
    }
    else {
        $WorkOrderInformation{"GraphDirection"} = 'left';
    }

    # create graph of workorder item
    $Self->Block(
        Name => 'WorkOrderItemGraph',
        Data => {
            %WorkOrderInformation,
            %TickValue,
        },
    );

    # get the workorder attribute names that should be shown in the tooltip
    my %TooltipAttributes = %{ $ChangeZoomConfig->{'Tooltip::WorkOrderAttributes'} };
    my @ShowAttributes = grep { $TooltipAttributes{$_} } keys %TooltipAttributes;

    # build attribut blocks
    if (@ShowAttributes) {

        ATTRIBUTE:
        for my $Attribute ( sort @ShowAttributes ) {

            # special handling for workorder agent
            if ( $Attribute eq 'WorkOrderAgent' ) {

                $Self->Block(
                    Name => 'WorkOrderAgentBlock',
                    Data => {
                        %WorkOrderInformation,
                    },
                );

                # check the last thing: UserLogin
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

            # handle workorder freetext fields
            elsif ( $Attribute =~ m{ \A WorkOrderFreeText (\d+) }xms ) {

                # only if the workorder freetext field contains something
                next ATTRIBUTE if !$WorkOrderInformation{ 'WorkOrderFreeKey' . $1 };
                next ATTRIBUTE if !$WorkOrderInformation{ 'WorkOrderFreeText' . $1 };

                $Self->Block(
                    Name => 'WorkOrderFreeText',
                    Data => {
                        WorkOrderFreeKey  => $WorkOrderInformation{ 'WorkOrderFreeKey' . $1 },
                        WorkOrderFreeText => $WorkOrderInformation{ 'WorkOrderFreeText' . $1 },
                    },
                );
            }

            # all other attributes
            else {
                $Self->Block(
                    Name => $Attribute,
                    Data => {
                        %WorkOrderInformation,
                    },
                );
            }
        }
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

    # get timeline indent with 1 digit after decimal point
    $TimeLine{TimeLineLeft} = sprintf( "%.1f", ( $RelativeStart / $RelativeEnd ) * 100 );

    # verify percent values
    if ( $TimeLine{TimeLineLeft} <= 0 ) {
        $TimeLine{TimeLineLeft} = 0;
    }
    if ( $TimeLine{TimeLineLeft} >= 100 ) {
        $TimeLine{TimeLineLeft} = 99.9;
    }

    return \%TimeLine;
}

=end Internal:

=back

=cut

1;
