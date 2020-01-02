# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AgentFAQJournal;

use strict;
use warnings;

use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # Get config for frontend.
    my $Config = $Kernel::OM->Get('Kernel::Config')->Get("FAQ::Frontend::$Self->{Action}");

    my $JournalLimit = $Config->{JournalLimit} || 500;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # Permission check.
    if ( !$Self->{AccessRo} ) {
        return $LayoutObject->NoPermission(
            Message    => Translatable('You need ro permission!'),
            WithHeader => 'yes',
        );
    }

    # Get Journal entries.
    my $Journal = $Kernel::OM->Get('Kernel::System::FAQ')->FAQJournalGet(
        UserID => $Self->{UserID},
    ) // [];

    # Find out which columns should be shown.
    my @ShowColumns;
    if ( $Config->{ShowColumns} ) {

        # Get all possible columns from config.
        my %PossibleColumn = %{ $Config->{ShowColumns} };

        # Get the column names that should be shown.
        COLUMNNAME:
        for my $Name ( sort keys %PossibleColumn ) {
            next COLUMNNAME if !$PossibleColumn{$Name};
            push @ShowColumns, $Name;
        }

        # Enforce FAQ number column since is the link MasterAction hook.
        if ( !$PossibleColumn{'Number'} ) {
            push @ShowColumns, 'Number';
        }
    }

    my $Output = $LayoutObject->Header(
        Value => Translatable('FAQ Journal'),
    );
    $Output .= $LayoutObject->NavigationBar();

    $Output .= $Self->_FAQJournalShow(
        Journal          => $Journal,
        Total            => scalar @{$Journal},
        TitleName        => $LayoutObject->{LanguageObject}->Translate('FAQ Journal'),
        Limit            => $JournalLimit,
        ShowColumns      => \@ShowColumns,
        JournalTitleSize => $Config->{TitleSize},
    );
    $Output .= $LayoutObject->Footer();

    return $Output;
}

sub _FAQJournalShow {
    my ( $Self, %Param ) = @_;

    # Lookup latest used view mode.
    if ( !$Param{View} && $Self->{ 'UserFAQJournalOverview' . $Self->{Action} } ) {
        $Param{View} = $Self->{ 'UserFAQJournalOverview' . $Self->{Action} };
    }

    # Set frontend.
    my $Frontend = 'Agent';

    # Set default view mode to 'small'.
    my $View = $Param{View} || 'Small';

    my $SessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');

    # Store latest view mode.
    $SessionObject->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'UserFAQJournalOverview' . $Self->{Action},
        Value     => $View,
    );

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get backend from config
    my $Backends = $ConfigObject->Get('FAQ::Frontend::JournalOverview');
    if ( !$Backends ) {
        return $LayoutObject->FatalError(
            Message => Translatable('Need config option FAQ::Frontend::Overview'),
        );
    }
    if ( ref $Backends ne 'HASH' ) {
        return $LayoutObject->FatalError(
            Message => Translatable('Config option FAQ::Frontend::Overview needs to be a HASH ref!'),
        );
    }

    # Check for config key.
    if ( !$Backends->{$View} ) {
        return $LayoutObject->FatalError(
            Message => $LayoutObject->{LanguageObject}->Translate( 'No config option found for the view "%s"!', $View ),
        );
    }

    my $StartHit = int( $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'StartHit' ) || 1 );

    # Get personal page shown count.
    my $PageShownPreferencesKey = 'UserFAQJournalOverview' . $View . 'PageShown';
    my $PageShown               = $Self->{$PageShownPreferencesKey} || 10;
    my $Group                   = 'FAQJournalOverview' . $View . 'PageShown';

    # Check start option, if higher then elements available, set it to the last overview page
    #   (Thanks to Stefan Schmidt!)
    if ( $StartHit > $Param{Total} ) {
        my $Pages = int( ( $Param{Total} / $PageShown ) + 0.99999 );
        $StartHit = ( ( $Pages - 1 ) * $PageShown ) + 1;
    }

    # Get data selection.
    my %Data;
    my $Config = $ConfigObject->Get('PreferencesGroups');
    if ( $Config && $Config->{$Group} && $Config->{$Group}->{Data} ) {
        %Data = %{ $Config->{$Group}->{Data} };
    }

    # Set page limit and build page navigation.
    my $Limit   = $Param{Limit} || 20_000;
    my %PageNav = $LayoutObject->PageNavBar(
        Limit     => $Limit,
        StartHit  => $StartHit,
        PageShown => $PageShown,
        AllHits   => $Param{Total} || 0,
        Action    => 'Action=' . $LayoutObject->{Action},
        Link      => $Param{LinkPage},
    );

    # Build shown FAQ articles on a page.
    $Param{RequestedURL}    = "Action=$Self->{Action}";
    $Param{Group}           = $Group;
    $Param{PreferencesKey}  = $PageShownPreferencesKey;
    $Param{PageShownString} = $LayoutObject->BuildSelection(
        Name       => $PageShownPreferencesKey,
        SelectedID => $PageShown,
        Data       => \%Data,
    );

    # Store last overview screen (for back menu action).
    $SessionObject->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenOverview',
        Value     => $Param{RequestedURL},
    );
    $SessionObject->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenView',
        Value     => $Param{RequestedURL},
    );

    # Build navigation bar content.
    $LayoutObject->Block(
        Name => 'OverviewNavBar',
        Data => \%Param,
    );

    for my $Backend ( sort keys %{$Backends} ) {

        # Build navigation bar view mode.
        $LayoutObject->Block(
            Name => 'OverviewNavBarViewMode',
            Data => {
                %Param,
                %{ $Backends->{$Backend} },
                Filter => $Param{Filter},
                View   => $Backend,
            },
        );

        # Current view is configured in backend.
        if ( $View eq $Backend ) {
            $LayoutObject->Block(
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
            $LayoutObject->Block(
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

    # Check if page navigation is available.
    if (%PageNav) {
        $LayoutObject->Block(
            Name => 'OverviewNavBarPageNavBar',
            Data => \%PageNav,
        );

        # Don't show context settings in AJAX case (e. g. in customer FAQ history), because the
        #   submit with page reload will not work there
        if ( !$Param{AJAX} ) {
            $LayoutObject->Block(
                Name => 'ContextSettings',
                Data => {
                    %PageNav,
                    %Param,
                },
            );
        }
    }

    my $OutputNavBar = $LayoutObject->Output(
        TemplateFile => 'AgentFAQOverviewNavBar',
        Data         => {
            View => $View,
            %Param,
        },
    );

    my $OutputRaw = $OutputNavBar;

    if ( !$Kernel::OM->Get('Kernel::System::Main')->Require( $Backends->{$View}->{Module} ) ) {
        return $LayoutObject->FatalError();
    }

    # Check for backend object.
    my $Object = $Backends->{$View}->{Module}->new( %{$Self} );
    return if !$Object;

    # Run module.
    my $Output = $Object->Run(
        %Param,
        Limit     => $Limit,
        StartHit  => $StartHit,
        PageShown => $PageShown,
        AllHits   => $Param{Total} || 0,
        Frontend  => $Frontend,
        TitleSize => $Param{JournalTitleSize},
    );

    $OutputRaw .= $Output;

    # Create overview navigation bar.
    $LayoutObject->Block(
        Name => 'OverviewNavBar',
        Data => {%Param},
    );

    # Return content if available.
    return $OutputRaw;
}

1;
