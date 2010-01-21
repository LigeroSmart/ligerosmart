# --
# Kernel/Modules/AgentITSMTemplateOverview.pm - the template overview module
# Copyright (C) 2003-2010 OTRS AG, http://otrs.com/
# --
# $Id: AgentITSMTemplateOverview.pm,v 1.4 2010-01-21 11:34:14 bes Exp $
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

use vars qw($VERSION);
$VERSION = qw($Revision: 1.4 $) [1];

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

    # investigate refresh
    my $Refresh = $Self->{UserRefreshTime} ? 60 * $Self->{UserRefreshTime} : undef;

    # starting with page ...
    my $Output = $Self->{LayoutObject}->Header( Refresh => $Refresh );
    $Output .= $Self->{LayoutObject}->NavigationBar();
    $Self->{LayoutObject}->Print( Output => \$Output );
    $Output = '';

    # hardcode which columns should be shown
    # the possible columns are:
    #      TemplateID Name Comment Content
    #      TypeID TranslatableType Type
    #      ValidID Valid
    #      CreateBy CreateTime ChangeBy ChangeTime
    my @ShowColumns = qw(
        Name Comment Content TranslatableType Valid
        CreateBy CreateTime ChangeBy ChangeTime
    );

    # to store the filters
    my %Filters;

    # set other filters based on template type
    if ( $Self->{Config}->{'Filter::TemplateTypes'} ) {

        # define position of the filter in the frontend
        my $PrioCounter = 1000;

        # get all template types that should be used as filters
        TEMPLATE_TYPE:
        for my $TemplateType ( @{ $Self->{Config}->{'Filter::TemplateTypes'} } ) {

            # do not use empty template types
            next TEMPLATE_TYPE if !$TemplateType;

            # check if the template type is valid by looking up the id
            my $TemplateTypeID = $Self->{TemplateObject}->TemplateTypeLookup(
                TemplateType => $TemplateType,
                UserID       => $Self->{UserID},
            );

            # do not use invalid template types
            next TEMPLATE_TYPE if !$TemplateTypeID;

            # increase the PrioCounter
            $PrioCounter++;

            # add filter for the current template type
            $Filters{$TemplateType} = {
                Name   => "TemplateType::$TemplateType",
                Prio   => $PrioCounter,
                Search => {
                    TemplateType => $TemplateType,
                    UserID       => $Self->{UserID},
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
                UserID => $Self->{UserID},
            },
        };
    }

    # check if filter is valid
    if ( !$Filters{ $Self->{Filter} } ) {
        $Self->{LayoutObject}->FatalError( Message => "Invalid Filter: $Self->{Filter}!" );
    }

    # search templates which match the selected filter
    my $TemplateList = $Self->{TemplateObject}->TemplateList(
        %{ $Filters{ $Self->{Filter} }->{Search} },
    );

    # for now simply sort numerically
    my @TemplateIDs = sort { $a <=> $b } keys %{$TemplateList};

    # display all navbar filters
    my %NavBarFilter;
    for my $Filter ( keys %Filters ) {

        # display the navbar filter
        $NavBarFilter{ $Filters{$Filter}->{Prio} } = {
            Filter => $Filter,
            %{ $Filters{$Filter} },
        };
    }

    # show templates
    my $LinkPage = 'Filter='
        . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{Filter} )
        . '&';
    my $LinkSort = 'Filter='
        . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{Filter} )
        . '&';
    my $LinkFilter = ''
        . '&';
    $Output .= $Self->{LayoutObject}->ITSMTemplateListShow(

        TemplateIDs => \@TemplateIDs,
        Total       => scalar @TemplateIDs,

        Filter     => $Self->{Filter},
        Filters    => \%NavBarFilter,
        FilterLink => $LinkFilter,

        TitleName  => 'Overview: Template',
        TitleValue => $Self->{Filter},

        Env      => $Self,
        LinkPage => $LinkPage,
        LinkSort => $LinkSort,

        ShowColumns => \@ShowColumns,
    );

    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
