# --
# Kernel/Output/HTML/LayoutFAQ.pm - provides generic agent HTML output
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: LayoutFAQ.pm,v 1.12 2010-11-03 19:47:01 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Output::HTML::LayoutFAQ;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.12 $) [1];

#sub AgentFAQCategoryListOption {
#
#    my ( $Self, %Param ) = @_;
#
#    my $Output         = '';
#    my $Size           = defined( $Param{Size} ) ? "size='$Param{Size}'" : '';
#    my $MaxLevel       = defined( $Param{MaxLevel} ) ? $Param{MaxLevel} : 10;
#    my $Selected       = defined( $Param{Selected} ) ? $Param{Selected} : '';
#    my $SelectedIDs    = $Param{SelectedIDs} || [];
#    my $SelectedID     = defined( $Param{SelectedID} ) ? $Param{SelectedID} : '';
#    my $Multiple       = $Param{Multiple} ? 'multiple' : '';
#    my $OnChangeSubmit = defined( $Param{OnChangeSubmit} ) ? $Param{OnChangeSubmit} : '';
#    if ($OnChangeSubmit) {
#        $OnChangeSubmit = " onchange=\"submit()\"";
#    }
#    if ( $Param{OnChange} ) {
#        $OnChangeSubmit = " onchange=\"$Param{OnChange}\"";
#    }
#
#    if ( defined( $Param{SelectedID} ) ) {
#        $SelectedIDs = [$SelectedID];
#    }
#
#    my %CategoryList = %{ $Param{CategoryList} };
#
#    # build tree list
#    $Output .= '<select name="' . $Param{Name} . "\" id=\"" . $Param{Name} . "\" $Size $Multiple $OnChangeSubmit>";
#
#    if ( $Param{RootElement} ) {
#        $Output .= '<option value="0">-</option>';
#    }
#
#    if (
#        $Param{CategoryList}
#        && ref( $Param{CategoryList} ) eq 'HASH'
#        && %{ $Param{CategoryList} }
#        )
#    {
#        $Output .= $Self->AgentFAQCategoryListOptionElement(
#            CategoryList => \%CategoryList,
#            LevelCounter => 0,
#            ParentID     => 0,
#            SelectedIDs  => $SelectedIDs,
#        );
#    }
#    $Output .= '</select>';
#
#    return $Output;
#}

#sub AgentFAQCategoryListOptionElement {
#    my ( $Self, %Param ) = @_;
#
#    my $Output = '';
#
#    my $LevelCounter = $Param{LevelCounter} || 0;
#    my $ParentID     = $Param{ParentID};
#
#    my %ParentNames;
#
#    my %CategoryList       = %{ $Param{CategoryList} };
#    my %CategoryLevelList  = %{ $CategoryList{ $ParentID } };
#    my %SelectedIDs        = map { $_ => 1 } @{ $Param{SelectedIDs} };
#
#    my @TempSubCategoryIDs = map  { "Level:$LevelCounter" . "ParentID:$ParentID", $_ }
#                             sort { $CategoryLevelList{$a} cmp $CategoryLevelList{$b} }
#                             keys %CategoryLevelList;
#
#    SUBCATEGORYID:
#    while ( @TempSubCategoryIDs ) {
#
#        # add level counter id to subcategory array
#        if ( $TempSubCategoryIDs[0] =~ m{ Level : ( \d+ ) ParentID : ( \d+ ) }xms ) {
#            $LevelCounter = $1;
#            $ParentID     = $2;
#            shift @TempSubCategoryIDs;
#        }
#
#        # get next subcategory id
#        my $SubCategoryID = shift @TempSubCategoryIDs;
#
#        # get new category level list
#        %CategoryLevelList = %{ $CategoryList{ $ParentID } };
#
#        # create output
#        $Output .= '<option value="' . $SubCategoryID . '"';
#        if ( $SelectedIDs{ $SubCategoryID } ) {
#            $Output .= ' selected';
#        }
#        $Output .= '>';
#
#        # get category name
#        my $CategoryName = $CategoryLevelList{$SubCategoryID};
#
#        # append parent name to child category name
#        if ( $ParentNames{$ParentID} ) {
#            $CategoryName = $ParentNames{$ParentID} . '::' . $CategoryName;
#        }
#
#        # set current child complete name to ParentNames hash for further use
#        $ParentNames{$SubCategoryID} = $CategoryName;
#
#        $Output .= $CategoryName;
#        $Output .= '</option>';
#
#        # check if subcategory has own subcategories
#        next SUBCATEGORYID if !$CategoryList{ $SubCategoryID };
#
#        # increase level
#        my $NextLevel = $LevelCounter + 1;
#
#        # get new subcategory ids
#        my %NewCategoryLevelList = %{ $CategoryList{ $SubCategoryID } };
#        my @NewSubcategoryIDs = map  { "Level:$NextLevel" . "ParentID:$SubCategoryID", $_ }
#                                sort { $NewCategoryLevelList{$a} cmp $NewCategoryLevelList{$b} }
#                                keys %NewCategoryLevelList;
#
#        # add new subcategory ids at beginning of temp array
#        unshift @TempSubCategoryIDs, @NewSubcategoryIDs;
#    }
#
#    return $Output;
#}

sub GetFAQItemVotingRateColor {
    my ( $Self, %Param ) = @_;

    if ( !defined $Param{Rate} ) {
        return $Self->FatalError(
            Message => 'Need rate!'
        );
    }
    my $CssTmp = '';
    my %VotingResultColors
        = %{ $Self->{ConfigObject}->Get('FAQ::Explorer::ItemList::VotingResultColors') };
    for my $Key ( sort( { $b <=> $a } keys(%VotingResultColors) ) ) {
        if ( $Param{Rate} <= $Key ) {
            $CssTmp = $VotingResultColors{$Key};
        }
    }
    return $CssTmp;
}

=item FAQListShow()

Returns a list of FAQ items as sortable list with pagination.

This function is similar to L<Kernel::Output::HTML::LayoutTicket::TicketListShow()>
in F<Kernel/Output/HTML/LayoutTicket.pm>.

    my $Output = $LayoutObject->ITSMChangeListShow(
        FAQIDs  => $FAQIDsRef,                            # total list of FAQIDs, that can be listed
        Total      => scalar @{ $FAQIDsRef },          # total number of list items, in this case
        View       => $Self->{View},                      # optional, the default value is 'Small'
        Filter     => 'All',
        Filters    => \%NavBarFilter,
        FilterLink => $LinkFilter,
        TitleName  => 'Overview: FAQ',
        TitleValue => $Self->{Filter},
        Env        => $Self,
        LinkPage   => $LinkPage,
        LinkSort   => $LinkSort,
        Frontend   => 'Agent',                           # optional (Agent|Customer|Public), default: Agent, indicates from which frontend this function was called
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

    # build shown ticket a page
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

1;
