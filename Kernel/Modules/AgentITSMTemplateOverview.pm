# --
# Kernel/Modules/AgentITSMTemplateOverview.pm - the template overview module
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMTemplateOverview;

use strict;
use warnings;

use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::Template;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (
        qw(ParamObject DBObject LayoutObject LogObject ConfigObject UserObject UserObject GroupObject)
        )
    {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Object!" );
        }
    }

    # create additional objects
    $Self->{ChangeObject}   = Kernel::System::ITSMChange->new(%Param);
    $Self->{TemplateObject} = Kernel::System::ITSMChange::Template->new(%Param);

    # get config of frontend module
    $Self->{Config} = $Self->{ConfigObject}->Get("ITSMChange::Frontend::$Self->{Action}");

    # get filter params
    $Self->{Filter} = $Self->{ParamObject}->GetParam( Param => 'Filter' ) || 'All';

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check permissions
    my $Access = $Self->{ChangeObject}->Permission(
        Type   => $Self->{Config}->{Permission},
        Action => $Self->{Action},
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
        Key       => 'LastScreenTemplates',
        Value     => $Self->{RequestedURL},
    );

    # get sorting parameters
    my $SortBy = $Self->{ParamObject}->GetParam( Param => 'SortBy' )
        || $Self->{Config}->{'SortBy::Default'}
        || 'TemplateID';

    # get ordering parameters
    my $OrderBy = $Self->{ParamObject}->GetParam( Param => 'OrderBy' )
        || $Self->{Config}->{'Order::Default'}
        || 'Up';

    my @SortByArray  = ($SortBy);
    my @OrderByArray = ($OrderBy);

    # investigate refresh
    my $Refresh = $Self->{UserRefreshTime} ? 60 * $Self->{UserRefreshTime} : undef;

    # starting with page ...
    my $Output = $Self->{LayoutObject}->Header( Refresh => $Refresh );
    $Output .= $Self->{LayoutObject}->NavigationBar();
    $Self->{LayoutObject}->Print( Output => \$Output );
    $Output = '';

    # find out which columns should be shown
    my @ShowColumns;
    if ( $Self->{Config}->{ShowColumns} ) {

        # get all possible columns from config
        my %PossibleColumn = %{ $Self->{Config}->{ShowColumns} };

        # get the column names that should be shown
        @ShowColumns = grep { $PossibleColumn{$_} } keys %PossibleColumn;
    }

    # to store the filters
    my %Filters;

    # set other filters based on template type
    if ( $Self->{Config}->{'Filter::TemplateTypes'} ) {

        # define position of the filter in the frontend
        my $PrioCounter = 1000;

        # get all template types that should be used as filters
        TEMPLATETYPE:
        for my $TemplateType ( @{ $Self->{Config}->{'Filter::TemplateTypes'} } ) {

            # do not use empty template types
            next TEMPLATETYPE if !$TemplateType;

            # check if the template type is valid by looking up the id
            my $TemplateTypeID = $Self->{TemplateObject}->TemplateTypeLookup(
                TemplateType => $TemplateType,
            );

            # do not use invalid template types
            next TEMPLATETYPE if !$TemplateTypeID;

            # increase the PrioCounter
            $PrioCounter++;

            # add filter with params for the search method
            $Filters{$TemplateType} = {
                Name   => $TemplateType,
                Prio   => $PrioCounter,
                Search => {
                    TemplateTypes    => [$TemplateType],
                    OrderBy          => \@SortByArray,
                    OrderByDirection => \@OrderByArray,
                    Limit            => 1000,
                    UserID           => $Self->{UserID},
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

        # add default filter, which shows all items
        $Filters{All} = {
            Name   => 'All',
            Prio   => 1000,
            Search => {
                OrderBy          => \@SortByArray,
                OrderByDirection => \@OrderByArray,
                Limit            => 1000,
                UserID           => $Self->{UserID},
            },
        };
    }

    # check if filter is valid
    if ( !$Filters{ $Self->{Filter} } ) {
        $Self->{LayoutObject}->FatalError( Message => "Invalid Filter: $Self->{Filter}!" );
    }

    # search templates which match the selected filter
    my $IDsRef = $Self->{TemplateObject}->TemplateSearch(
        %{ $Filters{ $Self->{Filter} }->{Search} },
    );

    # display all navbar filters
    my %NavBarFilter;
    for my $Filter ( sort keys %Filters ) {

        # count the number of items for each filter
        my $Count = $Self->{TemplateObject}->TemplateSearch(
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

    # show the list
    my $LinkPage = 'Filter='
        . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{Filter} )
        . ';SortBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $SortBy )
        . ';OrderBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $OrderBy )
        . ';';
    my $LinkSort = 'Filter='
        . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{Filter} )
        . ';';
    my $LinkFilter = 'SortBy='
        . $Self->{LayoutObject}->Ascii2Html( Text => $SortBy )
        . ';OrderBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $OrderBy )
        . ';';
    $Output .= $Self->{LayoutObject}->ITSMTemplateListShow(

        TemplateIDs => $IDsRef,
        Total       => scalar @{$IDsRef},
        Filter      => $Self->{Filter},
        Filters     => \%NavBarFilter,
        FilterLink  => $LinkFilter,

        TitleName => $Self->{LayoutObject}->{LanguageObject}->Get('Overview')
            . ': ' . $Self->{LayoutObject}->{LanguageObject}->Get('Template'),

        TitleValue => $Filters{ $Self->{Filter} }->{Name},

        Env      => $Self,
        LinkPage => $LinkPage,
        LinkSort => $LinkSort,

        ShowColumns => \@ShowColumns,
        OrderBy     => $OrderBy,
        SortBy      => $SortBy,
    );

    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
