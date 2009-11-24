# --
# Kernel/Modules/AgentITSMChange.pm - the OTRS::ITSM::ChangeManagement change overview module
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: AgentITSMChange.pm,v 1.16 2009-11-24 12:50:49 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMChange;

use strict;
use warnings;

use Kernel::System::ITSMChange;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.16 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(ParamObject DBObject LayoutObject LogObject ConfigObject UserObject)) {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Object!" );
        }
    }

    # create needed objects
    $Self->{ChangeObject} = Kernel::System::ITSMChange->new(%Param);

    # get config of frontend module
    $Self->{Config} = $Self->{ConfigObject}->Get("ITSMChange::Frontend::$Self->{Action}");

    # get filter and view params
    $Self->{Filter} = $Self->{ParamObject}->GetParam( Param => 'Filter' ) || 'All';
    $Self->{View}   = $Self->{ParamObject}->GetParam( Param => 'View' )   || '';

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check permissions
    my $Access = $Self->{ChangeObject}->Permission(
        Type   => $Self->{Config}->{Permission},
        UserID => $Self->{UserID},
    );

    # error screen
    if ( !$Access ) {
        return $Self->{LayoutObject}->NoPermission(
            Message    => "You need $Self->{Config}->{Permission} permissions!",
            WithHeader => 'yes',
        );
    }

    # store last screen, used for backlinks
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenChanges',
        Value     => $Self->{RequestedURL},
    );

    # get sorting parameters
    my $SortBy = $Self->{ParamObject}->GetParam( Param => 'SortBy' )
        || $Self->{Config}->{'SortBy::Default'}
        || 'PlannedStartTime';

    # get ordering parameters
    my $OrderBy = $Self->{ParamObject}->GetParam( Param => 'OrderBy' )
        || $Self->{Config}->{'Order::Default'}
        || 'Up';

    # investigate refresh
    my $Refresh = $Self->{UserRefreshTime} ? 60 * $Self->{UserRefreshTime} : undef;

    # starting with page ...
    my $Output = $Self->{LayoutObject}->Header( Refresh => $Refresh );
    $Output .= $Self->{LayoutObject}->NavigationBar();
    $Self->{LayoutObject}->Print( Output => \$Output );
    $Output = '';

    # set search filters
    my %Filters = (
        All => {
            Name   => 'All',
            Prio   => 1000,
            Search => {
                OrderBy          => [$SortBy],
                OrderByDirection => [$OrderBy],
                Limit            => 1000,
                UserID           => $Self->{UserID},
            },
        },

        # TODO these are just examples
        # think about using sysconfig for configurable filter settings
        'successful' => {
            Name   => 'successful',
            Prio   => 1001,
            Search => {
                OrderBy          => [$SortBy],
                OrderByDirection => [$OrderBy],
                ChangeStates     => ['successful'],
                Limit            => 1000,
                UserID           => $Self->{UserID},
            },
        },
        'requested' => {
            Name   => 'requested',
            Prio   => 1002,
            Search => {
                OrderBy          => [$SortBy],
                OrderByDirection => [$OrderBy],
                ChangeStates     => ['requested'],
                Limit            => 1000,
                UserID           => $Self->{UserID},
            },
        },
    );

    # check if filter is valid
    if ( !$Filters{ $Self->{Filter} } ) {
        $Self->{LayoutObject}->FatalError( Message => "Invalid Filter: $Self->{Filter}!" );
    }

    # search changes which match the selected filter
    my $ChangeIDsRef = $Self->{ChangeObject}->ChangeSearch(
        %{ $Filters{ $Self->{Filter} }->{Search} },
    );

    my %NavBarFilter;
    for my $Filter ( keys %Filters ) {

        # count the number of changes for each filter
        my $Count = $Self->{ChangeObject}->ChangeSearch(
            %{ $Filters{$Filter}->{Search} },
            Result => 'COUNT',
        );

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
        . '&View=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{View} )
        . '&SortBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $SortBy )
        . '&OrderBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $OrderBy )
        . '&';
    my $LinkSort = 'Filter='
        . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{Filter} )
        . '&View=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{View} )
        . '&';
    my $LinkFilter = 'SortBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $SortBy )
        . '&OrderBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $OrderBy )
        . '&View=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{View} )
        . '&';
    $Output .= $Self->{LayoutObject}->ITSMChangeListShow(
        ChangeIDs => $ChangeIDsRef,
        Total     => scalar @{$ChangeIDsRef},

        View => $Self->{View},

        Filter     => $Self->{Filter},
        Filters    => \%NavBarFilter,
        FilterLink => $LinkFilter,

        TitleName  => 'Overview: Change',
        TitleValue => $Self->{Filter},

        Env      => $Self,
        LinkPage => $LinkPage,
        LinkSort => $LinkSort,
    );

    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

1;
