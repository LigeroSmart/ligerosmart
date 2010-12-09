# --
# Kernel/Modules/CustomerITSMChangeSchedule.pm - the OTRS::ITSM::ChangeManagement customer change schedule overview module
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: CustomerITSMChangeSchedule.pm,v 1.6 2010-12-09 03:01:04 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::CustomerITSMChangeSchedule;

use strict;
use warnings;

use Kernel::System::ITSMChange;
use Kernel::System::LinkObject;
use Kernel::System::Service;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.6 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (
        qw(ParamObject DBObject LayoutObject LogObject ConfigObject UserObject GroupObject)
        )
    {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Object!" );
        }
    }

    # create needed objects
    $Self->{ChangeObject}  = Kernel::System::ITSMChange->new(%Param);
    $Self->{LinkObject}    = Kernel::System::LinkObject->new(%Param);
    $Self->{ServiceObject} = Kernel::System::Service->new(%Param);

    # get config of frontend module
    $Self->{Config} = $Self->{ConfigObject}->Get("ITSMChange::Frontend::$Self->{Action}");

    # get filter and view params
    $Self->{Filter} = $Self->{ParamObject}->GetParam( Param => 'Filter' ) || 'All';
    $Self->{View}   = $Self->{ParamObject}->GetParam( Param => 'View' )   || '';

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # store last screen
    if (
        !$Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'LastChangeView',
            Value     => $Self->{RequestedURL},
        )
        )
    {
        my $Output = $Self->{LayoutObject}->CustomerHeader( Title => 'Error' );
        $Output .= $Self->{LayoutObject}->CustomerError();
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
    }

    # check needed CustomerID
    if ( !$Self->{UserCustomerID} ) {
        my $Output = $Self->{LayoutObject}->CustomerHeader( Title => 'Error' );
        $Output .= $Self->{LayoutObject}->CustomerError( Message => 'Need CustomerID!' );
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
    }

    # get sorting parameters
    my $SortBy = $Self->{ParamObject}->GetParam( Param => 'SortBy' )
        || $Self->{Config}->{'SortBy::Default'}
        || 'PlannedStartTime';

    # get ordering parameters
    my $OrderBy = $Self->{ParamObject}->GetParam( Param => 'OrderBy' )
        || $Self->{Config}->{'Order::Default'}
        || 'Up';

    my @SortByArray  = ($SortBy);
    my @OrderByArray = ($OrderBy);

    # investigate refresh
    my $Refresh = $Self->{UserRefreshTime} ? 60 * $Self->{UserRefreshTime} : undef;

    # starting with page ...
    my $Output = $Self->{LayoutObject}->CustomerHeader(
        Refresh => $Refresh,
        Title   => '',
    );

    # build NavigationBar
    $Output .= $Self->{LayoutObject}->CustomerNavigationBar();

    $Self->{LayoutObject}->Print( Output => \$Output );
    $Output = '';

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

    # to store the filters
    my %Filters;

    # set other filters based on change state
    if ( $Self->{Config}->{'Filter::ChangeStates'} ) {

        # define position of the filter in the frontend
        my $PrioCounter = 1000;

        # get all change states that should be used as filters
        CHANGESTATE:
        for my $ChangeState ( @{ $Self->{Config}->{'Filter::ChangeStates'} } ) {

            # do not use empty change states
            next CHANGESTATE if !$ChangeState;

            # check if state is valid by looking up the state id
            my $ChangeStateID = $Self->{ChangeObject}->ChangeStateLookup(
                ChangeState => $ChangeState,
            );

            # do not use invalid change states
            next CHANGESTATE if !$ChangeStateID;

            # increase the PrioCounter
            $PrioCounter++;

            # add filter for the current change state
            $Filters{$ChangeState} = {
                Name   => $ChangeState,
                Prio   => $PrioCounter,
                Search => {
                    ChangeStates     => [$ChangeState],
                    OrderBy          => \@SortByArray,
                    OrderByDirection => \@OrderByArray,
                    Limit            => 1000,
                    UserID           => 1,
                },
            };
        }
    }

    # if only one filter exists
    if ( scalar keys %Filters == 1 ) {

        # get the name of the only filter
        my ($FilterName) = keys %Filters;

        # activate this filter
        $Self->{Filter} = $FilterName;
    }
    else {

        # add default filter
        $Filters{All} = {
            Name   => 'All',
            Prio   => 1000,
            Search => {
                ChangeStates     => $Self->{Config}->{'Filter::ChangeStates'},
                OrderBy          => \@SortByArray,
                OrderByDirection => \@OrderByArray,
                Limit            => 1000,
                UserID           => 1,
            },
        };
    }

    # check if filter is valid
    if ( !$Filters{ $Self->{Filter} } ) {
        $Self->{LayoutObject}->FatalError( Message => "Invalid Filter: $Self->{Filter}!" );
    }

    # search changes which match the selected filter
    my $ChangeIDsRef = $Self->{ChangeObject}->ChangeSearch(
        %{ $Filters{ $Self->{Filter} }->{Search} },
    );
    my @ChangeIDs = @{$ChangeIDsRef};

    # if configured, get only changes which have workorders that are linked with a service
    if ( $Self->{Config}->{ShowOnlyChangesWithAllowedServices} ) {

        # get all services the customer user is allowed to use
        my %CustomerUserServices = $Self->{ServiceObject}->CustomerUserServiceMemberList(
            CustomerUserLogin => $Self->{UserID},
            Result            => 'HASH',
            DefaultServices   => 1,
        );

        my %UniqueChangeIDs;
        CHANGEID:
        for my $ChangeID (@ChangeIDs) {

            # get change data
            my $Change = $Self->{ChangeObject}->ChangeGet(
                UserID   => $Self->{UserID},
                ChangeID => $ChangeID,
            );

            # get workorder ids
            my @WorkOrderIDs = @{ $Change->{WorkOrderIDs} };

            # don't show changes with no workorders (as they can not be linked with a service)
            next CHANGEID if !@WorkOrderIDs;

            WORKORDERID:
            for my $WorkOrderID (@WorkOrderIDs) {

                # get the list of linked services
                my %LinkKeyList = $Self->{LinkObject}->LinkKeyList(
                    Object1 => 'ITSMWorkOrder',
                    Key1    => $WorkOrderID,
                    Object2 => 'Service',
                    State   => 'Valid',
                    UserID  => 1,
                );

                # workorder has no linked service
                next WORKORDERID if !%LinkKeyList;

                SERVICEID:
                for my $ServiceID ( keys %LinkKeyList ) {

                    # only use services where the customer is allowed to use the service
                    next SERVICEID if !$CustomerUserServices{$ServiceID};

                    # add change id to list of visible changes for the customer
                    $UniqueChangeIDs{$ChangeID}++;
                }
            }
        }

        @ChangeIDs = keys %UniqueChangeIDs;
    }

    # display all navbar filters
    my %NavBarFilter;
    for my $Filter ( keys %Filters ) {

        # do not show the filter count in customer interface,
        # if the feature ShowOnlyChangesWithAllowedServices is activevated
        # because it is not accurate due to service restrictions for customer users
        my $Count;
        if ( $Self->{Config}->{ShowOnlyChangesWithAllowedServices} ) {
            $Count = undef;
        }
        else {

            # count the number of changes for each filter
            $Count = $Self->{ChangeObject}->ChangeSearch(
                %{ $Filters{$Filter}->{Search} },
                Result => 'COUNT',
            );
        }

        # display the navbar filter
        $NavBarFilter{ $Filters{$Filter}->{Prio} } = {
            Count  => $Count,
            Filter => $Filter,
            %{ $Filters{$Filter} },
        };
    }

    # show changes
    my $LinkPage = 'Filter='
        . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{Filter} )
        . ';View=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{View} )
        . ';SortBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $SortBy )
        . ';OrderBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $OrderBy )
        . ';';
    my $LinkSort = 'Filter='
        . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{Filter} )
        . ';View=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{View} )
        . ';';
    my $LinkFilter = 'SortBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $SortBy )
        . ';OrderBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $OrderBy )
        . ';View=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{View} )
        . ';';
    $Output .= $Self->{LayoutObject}->ITSMChangeListShow(

        ChangeIDs => \@ChangeIDs,
        Total     => scalar @ChangeIDs,

        View => $Self->{View},

        Filter     => $Self->{Filter},
        Filters    => \%NavBarFilter,
        FilterLink => $LinkFilter,

        TitleName  => 'Overview: Change Schedule',
        TitleValue => $Self->{Filter},

        Env      => $Self,
        LinkPage => $LinkPage,
        LinkSort => $LinkSort,

        ShowColumns => \@ShowColumns,

        Frontend => 'Customer',
    );

    # get page footer
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
