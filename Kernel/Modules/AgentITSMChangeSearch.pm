# --
# Kernel/Modules/AgentITSMChangeSearch.pm - module for change search
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: AgentITSMChangeSearch.pm,v 1.19 2009-12-03 11:15:26 bes Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMChangeSearch;

use strict;
use warnings;

use Kernel::System::CSV;
use Kernel::System::Group;
use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::ITSMWorkOrder;
use Kernel::System::SearchProfile;
use Kernel::System::User;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.19 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (
        qw(ParamObject DBObject LayoutObject LogObject ConfigObject MainObject EncodeObject)
        )
    {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Object!" );
        }
    }

    # create needed objects
    $Self->{ChangeObject}        = Kernel::System::ITSMChange->new(%Param);
    $Self->{CSVObject}           = Kernel::System::CSV->new(%Param);
    $Self->{GroupObject}         = Kernel::System::Group->new(%Param);
    $Self->{SearchProfileObject} = Kernel::System::SearchProfile->new(%Param);
    $Self->{UserObject}          = Kernel::System::User->new(%Param);
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

    # search parameters
    my %GetParam;

    # load profiles string params (press load profile)
    if ( $Self->{TakeLastSearch} ) {
        %GetParam = $Self->{SearchProfileObject}->SearchProfileGet(
            Base      => 'ITSMChangeSearch',
            Name      => $Self->{Profile},
            UserLogin => $Self->{UserLogin},
        );
    }
    else {

        # get scalar search params
        for my $SearchParam (
            qw(ChangeNumber ChangeTitle WorkOrderTitle SelectedCustomerUser SelectedUser1 Description Justification WorkOrderInstruction WorkOrderReport
            )
            )
        {

            # get search string params (get submitted params)
            $GetParam{$SearchParam} = $Self->{ParamObject}->GetParam( Param => $SearchParam );

            # remove white space on the start and end
            if ( $GetParam{$SearchParam} ) {
                $GetParam{$SearchParam} =~ s/\s+$//g;
                $GetParam{$SearchParam} =~ s/^\s+//g;
            }
        }

        if ( $GetParam{SelectedUser1} ) {
            $GetParam{CABAgents} = [ $GetParam{SelectedUser1} ];
        }

        if ( $GetParam{SelectedCustomerUser} ) {
            $GetParam{CABCustomers} = [ $GetParam{SelectedCustomerUser} ];
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

            # get search array params (get submitted params)
            my @Array = $Self->{ParamObject}->GetArray( Param => $SearchParam );
            if (@Array) {
                $GetParam{$SearchParam} = \@Array;
            }
        }
    }

    # set radio button for time search types
    for my $TimeType (
        qw( Realize PlannedStart PlannedEnd ActualStart ActualEnd Create Change )
        )
    {
        my $SearchType = $TimeType . 'TimeSearchType';
        if ( !$GetParam{$SearchType} ) {
            $GetParam{ $SearchType . '::None' } = 'checked="checked"';
        }
        elsif ( $GetParam{$SearchType} eq 'TimePoint' ) {
            $GetParam{ $SearchType . '::TimePoint' } = 'checked="checked"';
        }
        elsif ( $GetParam{$SearchType} eq 'TimeSlot' ) {
            $GetParam{ $SearchType . '::TimeSlot' } = 'checked="checked"';
        }
    }

    # set result form env
    $GetParam{ResultForm} ||= '';

    # show result site
    if ( $Self->{Subaction} eq 'Search' ) {

        # fill up profile name (e.g. with last-search)
        if ( !$Self->{Profile} ) {
            $Self->{Profile} = 'last-search';
        }

        # store last queue screen
        my $URL
            = "Action=ITSMChangeSearch&Subaction=Search&Profile=$Self->{Profile}&SortBy=$Self->{SortBy}"
            . "&OrderBy=$Self->{OrderBy}&TakeLastSearch=1&StartHit=$Self->{StartHit}";
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'LastScreenOverview',
            Value     => $URL,
        );
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'LastScreenView',
            Value     => $URL,
        );

        # get create time settings
        if ( !$GetParam{ArticleTimeSearchType} ) {

            # do nothing on time stuff
        }
        elsif ( $GetParam{ArticleTimeSearchType} eq 'TimeSlot' ) {
            for (qw(Month Day)) {
                $GetParam{"ArticleCreateTimeStart$_"}
                    = sprintf( "%02d", $GetParam{"ArticleCreateTimeStart$_"} );
            }
            for (qw(Month Day)) {
                $GetParam{"ArticleCreateTimeStop$_"}
                    = sprintf( "%02d", $GetParam{"ArticleCreateTimeStop$_"} );
            }
            if (
                $GetParam{ArticleCreateTimeStartDay}
                && $GetParam{ArticleCreateTimeStartMonth}
                && $GetParam{ArticleCreateTimeStartYear}
                )
            {
                $GetParam{ArticleCreateTimeNewerDate}
                    = $GetParam{ArticleCreateTimeStartYear} . '-'
                    . $GetParam{ArticleCreateTimeStartMonth} . '-'
                    . $GetParam{ArticleCreateTimeStartDay}
                    . ' 00:00:01';
            }
            if (
                $GetParam{ArticleCreateTimeStopDay}
                && $GetParam{ArticleCreateTimeStopMonth}
                && $GetParam{ArticleCreateTimeStopYear}
                )
            {
                $GetParam{ArticleCreateTimeOlderDate}
                    = $GetParam{ArticleCreateTimeStopYear} . '-'
                    . $GetParam{ArticleCreateTimeStopMonth} . '-'
                    . $GetParam{ArticleCreateTimeStopDay}
                    . ' 23:59:59';
            }
        }
        elsif ( $GetParam{ArticleTimeSearchType} eq 'TimePoint' ) {
            if (
                $GetParam{ArticleCreateTimePoint}
                && $GetParam{ArticleCreateTimePointStart}
                && $GetParam{ArticleCreateTimePointFormat}
                )
            {
                my $Time = 0;
                if ( $GetParam{ArticleCreateTimePointFormat} eq 'minute' ) {
                    $Time = $GetParam{ArticleCreateTimePoint};
                }
                elsif ( $GetParam{ArticleCreateTimePointFormat} eq 'hour' ) {
                    $Time = $GetParam{ArticleCreateTimePoint} * 60;
                }
                elsif ( $GetParam{ArticleCreateTimePointFormat} eq 'day' ) {
                    $Time = $GetParam{ArticleCreateTimePoint} * 60 * 24;
                }
                elsif ( $GetParam{ArticleCreateTimePointFormat} eq 'week' ) {
                    $Time = $GetParam{ArticleCreateTimePoint} * 60 * 24 * 7;
                }
                elsif ( $GetParam{ArticleCreateTimePointFormat} eq 'month' ) {
                    $Time = $GetParam{ArticleCreateTimePoint} * 60 * 24 * 30;
                }
                elsif ( $GetParam{ArticleCreateTimePointFormat} eq 'year' ) {
                    $Time = $GetParam{ArticleCreateTimePoint} * 60 * 24 * 365;
                }
                if ( $GetParam{ArticleCreateTimePointStart} eq 'Before' ) {
                    $GetParam{ArticleCreateTimeOlderMinutes} = $Time;
                }
                else {
                    $GetParam{ArticleCreateTimeNewerMinutes} = $Time;
                }
            }
        }

        # get create time settings
        if ( !$GetParam{TimeSearchType} ) {

            # do noting ont time stuff
        }
        elsif ( $GetParam{TimeSearchType} eq 'TimeSlot' ) {
            for (qw(Month Day)) {
                $GetParam{"TicketCreateTimeStart$_"}
                    = sprintf( "%02d", $GetParam{"TicketCreateTimeStart$_"} );
            }
            for (qw(Month Day)) {
                $GetParam{"TicketCreateTimeStop$_"}
                    = sprintf( "%02d", $GetParam{"TicketCreateTimeStop$_"} );
            }
            if (
                $GetParam{TicketCreateTimeStartDay}
                && $GetParam{TicketCreateTimeStartMonth}
                && $GetParam{TicketCreateTimeStartYear}
                )
            {
                $GetParam{TicketCreateTimeNewerDate}
                    = $GetParam{TicketCreateTimeStartYear} . '-'
                    . $GetParam{TicketCreateTimeStartMonth} . '-'
                    . $GetParam{TicketCreateTimeStartDay}
                    . ' 00:00:01';
            }
            if (
                $GetParam{TicketCreateTimeStopDay}
                && $GetParam{TicketCreateTimeStopMonth}
                && $GetParam{TicketCreateTimeStopYear}
                )
            {
                $GetParam{TicketCreateTimeOlderDate}
                    = $GetParam{TicketCreateTimeStopYear} . '-'
                    . $GetParam{TicketCreateTimeStopMonth} . '-'
                    . $GetParam{TicketCreateTimeStopDay}
                    . ' 23:59:59';
            }
        }
        elsif ( $GetParam{TimeSearchType} eq 'TimePoint' ) {
            if (
                $GetParam{TicketCreateTimePoint}
                && $GetParam{TicketCreateTimePointStart}
                && $GetParam{TicketCreateTimePointFormat}
                )
            {
                my $Time = 0;
                if ( $GetParam{TicketCreateTimePointFormat} eq 'minute' ) {
                    $Time = $GetParam{TicketCreateTimePoint};
                }
                elsif ( $GetParam{TicketCreateTimePointFormat} eq 'hour' ) {
                    $Time = $GetParam{TicketCreateTimePoint} * 60;
                }
                elsif ( $GetParam{TicketCreateTimePointFormat} eq 'day' ) {
                    $Time = $GetParam{TicketCreateTimePoint} * 60 * 24;
                }
                elsif ( $GetParam{TicketCreateTimePointFormat} eq 'week' ) {
                    $Time = $GetParam{TicketCreateTimePoint} * 60 * 24 * 7;
                }
                elsif ( $GetParam{TicketCreateTimePointFormat} eq 'month' ) {
                    $Time = $GetParam{TicketCreateTimePoint} * 60 * 24 * 30;
                }
                elsif ( $GetParam{TicketCreateTimePointFormat} eq 'year' ) {
                    $Time = $GetParam{TicketCreateTimePoint} * 60 * 24 * 365;
                }
                if ( $GetParam{TicketCreateTimePointStart} eq 'Before' ) {
                    $GetParam{TicketCreateTimeOlderMinutes} = $Time;
                }
                else {
                    $GetParam{TicketCreateTimeNewerMinutes} = $Time;
                }
            }
        }

        # get close time settings
        if ( !$GetParam{ChangeTimeSearchType} ) {

            # do noting ont time stuff
        }
        elsif ( $GetParam{ChangeTimeSearchType} eq 'TimeSlot' ) {
            for (qw(Month Day)) {
                $GetParam{"TicketChangeTimeStart$_"}
                    = sprintf( "%02d", $GetParam{"TicketChangeTimeStart$_"} );
            }
            for (qw(Month Day)) {
                $GetParam{"TicketChangeTimeStop$_"}
                    = sprintf( "%02d", $GetParam{"TicketChangeTimeStop$_"} );
            }
            if (
                $GetParam{TicketChangeTimeStartDay}
                && $GetParam{TicketChangeTimeStartMonth}
                && $GetParam{TicketChangeTimeStartYear}
                )
            {
                $GetParam{TicketChangeTimeNewerDate}
                    = $GetParam{TicketChangeTimeStartYear} . '-'
                    . $GetParam{TicketChangeTimeStartMonth} . '-'
                    . $GetParam{TicketChangeTimeStartDay}
                    . ' 00:00:01';
            }
            if (
                $GetParam{TicketChangeTimeStopDay}
                && $GetParam{TicketChangeTimeStopMonth}
                && $GetParam{TicketChangeTimeStopYear}
                )
            {
                $GetParam{TicketChangeTimeOlderDate}
                    = $GetParam{TicketChangeTimeStopYear} . '-'
                    . $GetParam{TicketChangeTimeStopMonth} . '-'
                    . $GetParam{TicketChangeTimeStopDay}
                    . ' 23:59:59';
            }
        }
        elsif ( $GetParam{ChangeTimeSearchType} eq 'TimePoint' ) {
            if (
                $GetParam{TicketChangeTimePoint}
                && $GetParam{TicketChangeTimePointStart}
                && $GetParam{TicketChangeTimePointFormat}
                )
            {
                my $Time = 0;
                if ( $GetParam{TicketChangeTimePointFormat} eq 'minute' ) {
                    $Time = $GetParam{TicketChangeTimePoint};
                }
                elsif ( $GetParam{TicketChangeTimePointFormat} eq 'hour' ) {
                    $Time = $GetParam{TicketChangeTimePoint} * 60;
                }
                elsif ( $GetParam{TicketChangeTimePointFormat} eq 'day' ) {
                    $Time = $GetParam{TicketChangeTimePoint} * 60 * 24;
                }
                elsif ( $GetParam{TicketChangeTimePointFormat} eq 'week' ) {
                    $Time = $GetParam{TicketChangeTimePoint} * 60 * 24 * 7;
                }
                elsif ( $GetParam{TicketChangeTimePointFormat} eq 'month' ) {
                    $Time = $GetParam{TicketChangeTimePoint} * 60 * 24 * 30;
                }
                elsif ( $GetParam{TicketChangeTimePointFormat} eq 'year' ) {
                    $Time = $GetParam{TicketChangeTimePoint} * 60 * 24 * 365;
                }
                if ( $GetParam{TicketChangeTimePointStart} eq 'Before' ) {
                    $GetParam{TicketChangeTimeOlderMinutes} = $Time;
                }
                else {
                    $GetParam{TicketChangeTimeNewerMinutes} = $Time;
                }
            }
        }

        # get close time settings
        if ( !$GetParam{CloseTimeSearchType} ) {

            # do noting ont time stuff
        }
        elsif ( $GetParam{CloseTimeSearchType} eq 'TimeSlot' ) {
            for (qw(Month Day)) {
                $GetParam{"TicketCloseTimeStart$_"}
                    = sprintf( "%02d", $GetParam{"TicketCloseTimeStart$_"} );
            }
            for (qw(Month Day)) {
                $GetParam{"TicketCloseTimeStop$_"}
                    = sprintf( "%02d", $GetParam{"TicketCloseTimeStop$_"} );
            }
            if (
                $GetParam{TicketCloseTimeStartDay}
                && $GetParam{TicketCloseTimeStartMonth}
                && $GetParam{TicketCloseTimeStartYear}
                )
            {
                $GetParam{TicketCloseTimeNewerDate}
                    = $GetParam{TicketCloseTimeStartYear} . '-'
                    . $GetParam{TicketCloseTimeStartMonth} . '-'
                    . $GetParam{TicketCloseTimeStartDay}
                    . ' 00:00:01';
            }
            if (
                $GetParam{TicketCloseTimeStopDay}
                && $GetParam{TicketCloseTimeStopMonth}
                && $GetParam{TicketCloseTimeStopYear}
                )
            {
                $GetParam{TicketCloseTimeOlderDate}
                    = $GetParam{TicketCloseTimeStopYear} . '-'
                    . $GetParam{TicketCloseTimeStopMonth} . '-'
                    . $GetParam{TicketCloseTimeStopDay}
                    . ' 23:59:59';
            }
        }
        elsif ( $GetParam{CloseTimeSearchType} eq 'TimePoint' ) {
            if (
                $GetParam{TicketCloseTimePoint}
                && $GetParam{TicketCloseTimePointStart}
                && $GetParam{TicketCloseTimePointFormat}
                )
            {
                my $Time = 0;
                if ( $GetParam{TicketCloseTimePointFormat} eq 'minute' ) {
                    $Time = $GetParam{TicketCloseTimePoint};
                }
                elsif ( $GetParam{TicketCloseTimePointFormat} eq 'hour' ) {
                    $Time = $GetParam{TicketCloseTimePoint} * 60;
                }
                elsif ( $GetParam{TicketCloseTimePointFormat} eq 'day' ) {
                    $Time = $GetParam{TicketCloseTimePoint} * 60 * 24;
                }
                elsif ( $GetParam{TicketCloseTimePointFormat} eq 'week' ) {
                    $Time = $GetParam{TicketCloseTimePoint} * 60 * 24 * 7;
                }
                elsif ( $GetParam{TicketCloseTimePointFormat} eq 'month' ) {
                    $Time = $GetParam{TicketCloseTimePoint} * 60 * 24 * 30;
                }
                elsif ( $GetParam{TicketCloseTimePointFormat} eq 'year' ) {
                    $Time = $GetParam{TicketCloseTimePoint} * 60 * 24 * 365;
                }
                if ( $GetParam{TicketCloseTimePointStart} eq 'Before' ) {
                    $GetParam{TicketCloseTimeOlderMinutes} = $Time;
                }
                else {
                    $GetParam{TicketCloseTimeNewerMinutes} = $Time;
                }
            }
        }

        # have a fulltext search per default
        for (
            qw(ChangeTitle WorkOrderTitle Description Justification WorkOrderInstruction WorkOrderReport)
            )
        {
            if ( defined( $GetParam{$_} ) && $GetParam{$_} ne '' ) {
                $GetParam{$_} = "*$GetParam{$_}*";
            }
        }

        # perform ticket search
        my $ViewableChangeIDs = $Self->{ChangeObject}->ChangeSearch(
            Result           => 'ARRAY',
            OrderBy          => [ $Self->{SortBy} ],
            OrderByDirection => [ $Self->{OrderBy} ],
            Limit            => $Self->{SearchLimit},
            UserID           => $Self->{UserID},
            %GetParam,
        );

        if ( $GetParam{ResultForm} eq 'CSV' ) {

            # TODO: remove or implement
        }
        elsif ( $GetParam{ResultForm} eq 'Print' ) {

            # TODO: remove or implement
        }
        else {

            # start html page
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Self->{LayoutObject}->Print( Output => \$Output );
            $Output = '';

            $Self->{Filter} = $Self->{ParamObject}->GetParam( Param => 'Filter' ) || '';
            $Self->{View}   = $Self->{ParamObject}->GetParam( Param => 'View' )   || '';

            # show ticket's
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

            my $FilterLink
                = 'SortBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{SortBy} )
                . '&OrderBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{OrderBy} )
                . '&View=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{View} )
                . '&Profile=' . $Self->{Profile} . '&TakeLastSearch=1&Subaction=Search'
                . '&';

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
                ChangeIDs => $ViewableChangeIDs,
                Total     => scalar @{$ViewableChangeIDs},

                View => $Self->{View},

                Env        => $Self,
                LinkPage   => $LinkPage,
                LinkSort   => $LinkSort,
                LinkFilter => $LinkFilter,
                LinkBack   => $LinkBack,

                TitleName => 'Change Search Result',

                ShowColumns => \@ShowColumns,
            );

            # build footer
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }

    # empty search site
    else {

        # generate search mask
        my $Output = $Self->{LayoutObject}->Header();

        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->MaskForm( %GetParam, Profile => $Self->{Profile}, );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}

sub MaskForm {
    my ( $Self, %Param ) = @_;

    # get ChangeManagerIDs
    my $ChangeManagerGroupID = $Self->{GroupObject}->GroupLookup(
        Group => 'itsm-change-manager',
    );
    my @ChangeManagerIDs = $Self->{GroupObject}->GroupMemberList(
        Type    => 'ro',
        Result  => 'ID',
        GroupID => $ChangeManagerGroupID,
    );

    # get change manager data for change manager ids
    my %ChangeManagerID2Name;
    for my $ChangeManagerID (@ChangeManagerIDs) {
        my %ChangeManager = $Self->{UserObject}->GetUserData(
            UserID => $ChangeManagerID,
        );

        if (%ChangeManager) {
            $ChangeManagerID2Name{$ChangeManagerID} = sprintf "%s %s (%s)",
                $ChangeManager{UserFirstname},
                $ChangeManager{UserLastname},
                $ChangeManager{UserLogin};
        }
    }

    # build change manager dropdown
    $Param{'ChangeManagerSelectionStrg'} = $Self->{LayoutObject}->BuildSelection(
        Data               => \%ChangeManagerID2Name,
        Name               => 'ChangeManagerIDs',
        Multiple           => 1,
        Size               => 5,
        SelectedIDRefArray => $Param{ChangeManagerID},
    );

    # get ChangeBuilderIDs
    my $ChangeBuilderGroupID = $Self->{GroupObject}->GroupLookup(
        Group => 'itsm-change-builder',
    );
    my @ChangeBuilderIDs = $Self->{GroupObject}->GroupMemberList(
        Type    => 'ro',
        Result  => 'ID',
        GroupID => $ChangeBuilderGroupID,
    );

    # get change builder data for change builder ids
    my %ChangeBuilderID2Name;
    for my $ChangeBuilderID (@ChangeManagerIDs) {
        my %ChangeBuilder = $Self->{UserObject}->GetUserData(
            UserID => $ChangeBuilderID,
        );

        if (%ChangeBuilder) {
            $ChangeBuilderID2Name{$ChangeBuilderID} = sprintf "%s %s (%s)",
                $ChangeBuilder{UserFirstname},
                $ChangeBuilder{UserLastname},
                $ChangeBuilder{UserLogin};
        }
    }

    # build change builder dropdown
    $Param{'ChangeBuilderSelectionStrg'} = $Self->{LayoutObject}->BuildSelection(
        Data               => \%ChangeBuilderID2Name,
        Name               => 'ChangeBuilderIDs',
        Multiple           => 1,
        Size               => 5,
        SelectedIDRefArray => $Param{ChangeBuilderID},
    );

    # get possible Change Categories
    my $Categories = $Self->{ChangeObject}->ChangePossibleCIPGet(
        Type => 'Category',
    );
    $Param{'ChangeCategorySelectionStrg'} = $Self->{LayoutObject}->BuildSelection(
        Data               => $Categories,
        Name               => 'CategoryIDs',
        Multiple           => 1,
        Size               => 5,
        SelectedIDRefArray => $Param{CategoryIDs},
    );

    # get possible Change Impacts
    my $Impacts = $Self->{ChangeObject}->ChangePossibleCIPGet(
        Type => 'Impact',
    );
    $Param{'ChangeImpactSelectionStrg'} = $Self->{LayoutObject}->BuildSelection(
        Data               => $Impacts,
        Name               => 'ImpactIDs',
        Multiple           => 1,
        Size               => 5,
        SelectedIDRefArray => $Param{ImpactIDs},
    );

    # get possible Change Priorities
    my $Priorities = $Self->{ChangeObject}->ChangePossibleCIPGet(
        Type => 'Priority',
    );
    $Param{'ChangePrioritySelectionStrg'} = $Self->{LayoutObject}->BuildSelection(
        Data               => $Priorities,
        Name               => 'PriorityIDs',
        Multiple           => 1,
        Size               => 5,
        SelectedIDRefArray => $Param{PriorityIDs},
    );

    # get change states
    my $ChangeStates = $Self->{ChangeObject}->ChangePossibleStatesGet(
        ChangeID => 1,
        UserID   => $Self->{UserID},
    );
    $Param{'ChangeStateSelectionStrg'} = $Self->{LayoutObject}->BuildSelection(
        Data               => $ChangeStates,
        Name               => 'ChangeStateIDs',
        Multiple           => 1,
        Size               => 5,
        SelectedIDRefArray => $Param{ChangeStateIDs},
    );

    # get created by users
    my %Users = $Self->{UserObject}->UserList(
        Type  => 'Long',
        Valid => 1,
    );
    $Param{'CreateBySelectionStrg'} = $Self->{LayoutObject}->BuildSelection(
        Data               => \%Users,
        Name               => 'CreateBy',
        Multiple           => 1,
        Size               => 5,
        SelectedIDRefArray => $Param{CreateBy},
    );

    # get workorder agents
    $Param{'WorkOrderAgentIDSelectionStrg'} = $Self->{LayoutObject}->BuildSelection(
        Data               => \%Users,
        Name               => 'WorkOrderAgentIDs',
        Multiple           => 1,
        Size               => 5,
        SelectedIDRefArray => $Param{WorkOrderAgentIDs},
    );

    # get workorder states
    my $WorkOrderStates = $Self->{WorkOrderObject}->WorkOrderPossibleStatesGet(
        WorkOrderID => 1,
        UserID      => 1,
    );
    $Param{'WorkOrderStateSelectionStrg'} = $Self->{LayoutObject}->BuildSelection(
        Data               => $WorkOrderStates,
        Name               => 'WorkOrderStateIDs',
        Multiple           => 1,
        Size               => 5,
        SelectedIDRefArray => $Param{WorkOrderStateIDs},
    );

    # what output types are supported
    $Param{'ResultFormStrg'} = $Self->{LayoutObject}->BuildSelection(
        Data => {
            Normal => 'Normal',
            Print  => 'Print',
            CSV    => 'CSV',
        },
        Name => 'ResultForm',
        SelectedID => $Param{ResultForm} || 'Normal',
    );

    # get time fields
    my %OneToFiftyNine = map { $_ => sprintf "%2s", $_ } ( 1 .. 59 );

    for my $TimeType (
        qw(Realize PlannedStart PlannedEnd ActualStart ActualEnd Create Change)
        )
    {
        $Param{ $TimeType . 'TimePoint' } = $Self->{LayoutObject}->BuildSelection(
            Data       => \%OneToFiftyNine,
            Name       => $TimeType . 'TimePoint',
            SelectedID => $Param{ $TimeType . 'TimePoint' },
        );

        $Param{ $TimeType . 'TimePointStart' } = $Self->{LayoutObject}->BuildSelection(
            Data => {
                'Last'   => 'last',
                'Before' => 'before',
            },
            Name => $TimeType . 'TimePointStart',
            SelectedID => $Param{ $TimeType . 'TimePointStart' } || 'Last',
        );

        $Param{ $TimeType . 'TimePointFormat' } = $Self->{LayoutObject}->BuildSelection(
            Data => {
                minute => 'minute(s)',
                hour   => 'hour(s)',
                day    => 'day(s)',
                week   => 'week(s)',
                month  => 'month(s)',
                year   => 'year(s)',
            },
            Name       => $TimeType . 'TimePointFormat',
            SelectedID => $Param{ $TimeType . 'TimePointFormat' },
        );

        $Param{ $TimeType . 'TimeStart' } = $Self->{LayoutObject}->BuildDateSelection(
            %Param,
            Prefix   => $TimeType . 'TimeStart',
            Format   => 'DateInputFormat',
            DiffTime => -( ( 60 * 60 * 24 ) * 30 ),
        );

        $Param{ $TimeType . 'TimeStop' } = $Self->{LayoutObject}->BuildDateSelection(
            %Param,
            Prefix => $TimeType . 'TimeStop',
            Format => 'DateInputFormat',
        );
    }

    # render template
    $Self->{LayoutObject}->Block(
        Name => 'Search',
        Data => { %Param, },
    );

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
            Name => 'CustomerSearchAutoCompleteDivStart',
        );
        $Self->{LayoutObject}->Block(
            Name => 'CustomerSearchAutoCompleteDivEnd',
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
            Name => 'UserSearchAutoCompleteDivStart1',
        );
        $Self->{LayoutObject}->Block(
            Name => 'UserSearchAutoCompleteDivEnd1',
        );
    }
    else {

        # show usersearch buttons for CABAgent
        $Self->{LayoutObject}->Block(
            Name => 'SearchUserButton1',
        );
    }

    for my $TimeType (
        qw(Realize PlannedStart PlannedEnd ActualStart ActualEnd Create Change)
        )
    {

        # show RealizeTime only when enabled in SysConfig
        next if ( $TimeType eq 'Realize' && !$Self->{Config}->{RealizeTime} );

        # show time field
        $Self->{LayoutObject}->Block(
            Name => $TimeType . 'Time',
            Data => {%Param},
        );
    }

    # build output
    my $Output = $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMChangeSearch',
        Data         => \%Param,
    );

    return $Output;
}

1;
