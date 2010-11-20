# --
# Kernel/Output/HTML/LayoutFAQ.pm - provides generic agent HTML output
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: LayoutFAQ.pm,v 1.28 2010-11-20 10:57:40 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::LayoutFAQ;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.28 $) [1];

# TODO: check if this can be deleted by finding another solution

sub GetFAQItemVotingRateColor {
    my ( $Self, %Param ) = @_;

    if ( !defined $Param{Rate} ) {
        return $Self->FatalError(
            Message => 'Need rate!'
        );
    }
    my $CssTmp = '';
    my $VotingResultColors
        = $Self->{ConfigObject}->Get('FAQ::Explorer::ItemList::VotingResultColors');

    for my $Key ( sort { $b <=> $a } keys %{$VotingResultColors} ) {
        if ( $Param{Rate} <= $Key ) {
            $CssTmp = $VotingResultColors->{$Key};
        }
    }
    return $CssTmp;
}

=item FAQListShow()

Returns a list of FAQ items as sortable list with pagination.

This function is similar to L<Kernel::Output::HTML::LayoutTicket::TicketListShow()>
in F<Kernel/Output/HTML/LayoutTicket.pm>.

    my $Output = $LayoutObject->FAQListShow(
        FAQIDs  => $FAQIDsRef,                            # total list of FAQIDs, that can be listed
        Total      => scalar @{ $FAQIDsRef },             # total number of list items, in this case
        View       => $Self->{View},                      # optional, the default value is 'Small'
        Filter     => 'All',
        Filters    => \%NavBarFilter,
        FilterLink => $LinkFilter,
        TitleName  => 'Overview: FAQ',
        TitleValue => $Self->{Filter},
        Env        => $Self,
        LinkPage   => $LinkPage,
        LinkSort   => $LinkSort,
        Frontend   => 'Agent',                            # optional (Agent|Customer|Public), default: Agent, indicates from which frontend this function was called
    );

=cut

sub FAQListShow {
    my ( $Self, %Param ) = @_;

    # take object ref to local, remove it from %Param (prevent memory leak)
    my $Env = delete $Param{Env};

    # lookup latest used view mode
    if ( !$Param{View} && $Self->{ 'UserFAQOverview' . $Env->{Action} } ) {
        $Param{View} = $Self->{ 'UserFAQOverview' . $Env->{Action} };
    }

    # set frontend
    my $Frontend = $Param{Frontend} || 'Agent';

    # set defaut view mode to 'small'
    my $View = $Param{View} || 'Small';

    # store latest view mode
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'UserFAQOverview' . $Env->{Action},
        Value     => $View,
    );

    # get backend from config
    my $Backends = $Self->{ConfigObject}->Get('FAQ::Frontend::Overview');
    if ( !$Backends ) {
        return $Env->{LayoutObject}->FatalError(
            Message => 'Need config option FAQ::Frontend::Overview',
        );
    }

    # check for hash-ref
    if ( ref $Backends ne 'HASH' ) {
        return $Env->{LayoutObject}->FatalError(
            Message => 'Config option FAQ::Frontend::Overview needs to be a HASH ref!',
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
    my $PageShownPreferencesKey = 'UserFAQOverview' . $View . 'PageShown';
    my $PageShown               = $Self->{$PageShownPreferencesKey} || 10;
    my $Group                   = 'FAQOverview' . $View . 'PageShown';

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

    # build shown faq articles on a page
    $Param{RequestedURL}    = "Action=$Self->{Action}";
    $Param{Group}           = $Group;
    $Param{PreferencesKey}  = $PageShownPreferencesKey;
    $Param{PageShownString} = $Self->BuildSelection(
        Name       => $PageShownPreferencesKey,
        SelectedID => $PageShown,
        Data       => \%Data,
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

        # don't show context settings in AJAX case (e. g. in customer ticket history),
        # because the submit with page reload will not work there
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
        TemplateFile => 'AgentFAQOverviewNavBar',
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

=item FAQContentShow()

Outputs the necessary DTL blocks to display the FAQ item fields for the supplied FAQ item ID.
The fields displayed are also restricted by the permissions represented by the supplied interface

    $LayoutObject->FAQContentShow(
        FAQObject       => $FAQObject,                 # needed for core module interaction
        FAQData         => %{ $FAQData },
        InterfaceStates => $Self->{InterfaceStates},
        UserID          => 1,
    );

=cut

sub FAQContentShow {
    my ( $Self, %Param ) = @_;

    # check parameters
    for my $ParamName (qw(FAQObject FAQData InterfaceStates UserID)) {
        if ( !$Param{$ParamName} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $ParamName!",
            );
            return;
        }
    }

    # store FAQ object locally
    $Self->{FAQObject} = $Param{FAQObject};

    # get the config of FAQ fields that should be shown
    my %Fields;
    FIELD:
    for my $Number ( 1 .. 6 ) {

        # get config of FAQ field
        my $Config = $Self->{ConfigObject}->Get( 'FAQ::Item::Field' . $Number );

        # skip over not shown fields
        next FIELD if !$Config->{Show};

        # store only the config of fields that should be shown
        $Fields{ "Field" . $Number } = $Config;
    }

    # sort shown fields by priority
    FIELD:
    for my $Field ( sort { $Fields{$a}->{Prio} <=> $Fields{$b}->{Prio} } keys %Fields ) {

        # get the state type data of this field
        my $StateTypeData = $Self->{FAQObject}->StateTypeGet(
            Name   => $Fields{$Field}->{Show},
            UserID => $Param{UserID},
        );

        # do not show fields that are not allowed in the given interface
        next FIELD if !$Param{InterfaceStates}->{ $StateTypeData->{StateID} };

        # show the field
        $Self->Block(
            Name => 'FAQContent',
            Data => {
                Field     => $Field,
                Caption   => $Fields{$Field}->{'Caption'},
                StateName => $StateTypeData->{Name},
                Content   => $Param{FAQData}->{$Field} || '',
            },
        );
    }
}

=item FAQPathShow()

if its allowd by the configuration, outputs the necessary DTL blocks to display the FAQ item path,
and returns the value 1.

    my ShowPath = $LayoutObject->FAQPathShow(
        FAQObject   => $FAQObject,                   # needed for core module interaction
        CategoryID  => $FAQData{CategoryID},
        UserID      => 1,
    );

=cut

sub FAQPathShow {
    my ( $Self, %Param ) = @_;

    # check parameters
    for my $ParamName (qw(FAQObject CategoryID UserID)) {
        if ( !$Param{$ParamName} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $ParamName!",
            );
            return;
        }
    }

    # store FAQ object locally
    $Self->{FAQObject} = $Param{FAQObject};

    # output category root
    $Self->Block(
        Name => 'FAQPathCategoryElement',
        Data => {
            'Name'       => $Self->{ConfigObject}->Get('FAQ::Default::RootCategoryName'),
            'CategoryID' => '0',
        },
    );

    # get Show FAQ Path setting
    my $ShowPath = $Self->{ConfigObject}->Get('FAQ::Explorer::Path::Show');

    # do not diplay the path if setting is off
    return if !$ShowPath;

    # get category list to construct the path
    my $CategoryList = $Self->{FAQObject}->FAQPathListGet(
        CategoryID => $Param{CategoryID},
        UserID     => $Param{UserID},
    );

    # output subcategories
    for my $CategoryData ( @{$CategoryList} ) {
        $Self->Block(
            Name => 'FAQPathCategoryElement',
            Data => { %{$CategoryData} },
        );
    }
    return 1;
}

=item FAQRatingStarsShow()

Outputs the necessary DTL blocks to represent the FAQ item rating as "Stars" in the scale from
1 to 5

    $LayoutObject->FAQRatingStarsShow(
        VoteResult => $FAQData->{VoteResult},
        Votes      => $FAQData ->{Votes},
    );

=cut

sub FAQRatingStarsShow {
    my ( $Self, %Param ) = @_;

    # check parameters
    for my $ParamName (qw(VoteResult Votes)) {
        if ( !defined $Param{$ParamName} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $ParamName!",
            );
            return;
        }
    }

    # get stars by mutiply by 5 and divide by 100
    # 100 because Vote result is a %
    # 5 because we have only 5 stars
    my $StarCounter = int( $Param{VoteResult} * 0.05 );
    if ( $StarCounter < 5 ) {

        # add 1 because lowest value should be 1
        $StarCounter++;
    }

    # the number of stars can't be grater that 5
    elsif ( $StarCounter > 5 ) {
        $StarCounter = 5;
    }

    # do not output any star if this FAQ has been not voted
    if ( $Param{Votes} eq '0' ) {
        $StarCounter = 0;
    }

    # show stars only if the FAQ item has been voted at least once even if the $VoteResult is 0
    else {

        # output stars
        for ( 1 .. $StarCounter ) {
            $Self->Block(
                Name => 'RateStars',
            );
        }
    }

    # output stars text
    $Self->Block(
        Name => 'RateStarsCount',
        Data => { Stars => $StarCounter },
    );
}

1;
