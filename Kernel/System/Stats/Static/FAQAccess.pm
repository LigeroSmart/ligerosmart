# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Stats::Static::FAQAccess;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::FAQ',
    'Kernel::System::Log',
    'Kernel::System::DateTime',
);

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub GetObjectBehaviours {
    my ( $Self, %Param ) = @_;

    my %Behaviours = (
        ProvidesDashboardWidget => 0,
    );

    return %Behaviours;
}

sub Param {

    my $Self = shift;

    my @Params = ();

    # Get current time.
    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
    );
    my $DateTimeSettings = $DateTimeObject->Get();

    my $D = sprintf( "%02d", $DateTimeSettings->{Day} );
    my $M = sprintf( "%02d", $DateTimeSettings->{Month} );
    my $Y = sprintf( "%02d", $DateTimeSettings->{Year} );

    # Create possible time selections.
    my %Year  = map { $_ => $_ } ( $Y - 10 .. $Y + 1 );
    my %Month = map { sprintf( "%02d", $_ ) => sprintf( "%02d", $_ ) } ( 1 .. 12 );
    my %Day   = map { sprintf( "%02d", $_ ) => sprintf( "%02d", $_ ) } ( 1 .. 31 );

    push @Params, {
        Frontend   => 'Start day',
        Name       => 'StartDay',
        Multiple   => 0,
        Size       => 0,
        SelectedID => '01',
        Data       => {
            %Day,
        },
    };
    push @Params, {
        Frontend   => 'Start month',
        Name       => 'StartMonth',
        Multiple   => 0,
        Size       => 0,
        SelectedID => $M,
        Data       => {
            %Month,
        },
    };
    push @Params, {
        Frontend   => 'Start year',
        Name       => 'StartYear',
        Multiple   => 0,
        Size       => 0,
        SelectedID => $Y,
        Data       => {
            %Year,
        },
    };
    push @Params, {
        Frontend   => 'End day',
        Name       => 'EndDay',
        Multiple   => 0,
        Size       => 0,
        SelectedID => $D,
        Data       => {
            %Day,
        },
    };
    push @Params, {
        Frontend   => 'End month',
        Name       => 'EndMonth',
        Multiple   => 0,
        Size       => 0,
        SelectedID => $M,
        Data       => {
            %Month,
        },
    };
    push @Params, {
        Frontend   => 'End year',
        Name       => 'EndYear',
        Multiple   => 0,
        Size       => 0,
        SelectedID => $Y,
        Data       => {
            %Year,
        },
    };

    return @Params;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $ParamName (qw(StartYear StartMonth StartDay EndYear EndMonth EndDay)) {
        if ( !$Param{$ParamName} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $ParamName!",
            );
            return;
        }
    }

    my $DateTimeObjectStart = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            Year     => $Param{StartYear},
            Month    => $Param{StartMonth},
            Day      => 1,
            TimeZone => 'floating',
        },
    );

    my $LastDayOfMonthStart;
    if ( defined $DateTimeObjectStart ) {
        $LastDayOfMonthStart = $DateTimeObjectStart->LastDayOfMonthGet();
    }

    # Correct start day of month if entered wrong by user.
    my $StartDay = sprintf( "%02d", $LastDayOfMonthStart );
    if ( $Param{StartDay} < $StartDay ) {
        $StartDay = $Param{StartDay};
    }

    my $DateTimeObjectEnd = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            Year     => $Param{EndYear},
            Month    => $Param{EndMonth},
            Day      => 1,
            TimeZone => 'floating',
        },
    );

    my $LastDayOfMonthEnd;
    if ( defined $DateTimeObjectEnd ) {
        $LastDayOfMonthEnd = $DateTimeObjectEnd->LastDayOfMonthGet();
    }

    # Correct end day of month if entered wrong by user.
    my $EndDay = sprintf( "%02d", $LastDayOfMonthEnd );
    if ( $Param{EndDay} < $EndDay ) {
        $EndDay = $Param{EndDay};
    }

    # Set start and end date.
    my $StartDate = "$Param{StartYear}-$Param{StartMonth}-$StartDay 00:00:00";
    my $EndDate   = "$Param{EndYear}-$Param{EndMonth}-$EndDay 23:59:59";

    my $FAQObject = $Kernel::OM->Get('Kernel::System::FAQ');

    my $ConfigObject        = $Kernel::OM->Get('Kernel::Config');
    my $FAQTop10LimitConfig = $ConfigObject->Get('FAQ::Explorer::Top10::Limit');

    # Get a count of all FAQ articles.
    my $Top10ItemIDsRef = $FAQObject->FAQTop10Get(
        Interface => 'internal',
        StartDate => $StartDate,
        EndDate   => $EndDate,
        UserID    => 1,
        Limit     => $FAQTop10LimitConfig,
    ) || [];

    # Build result table.
    my @Data;
    for my $ItemIDRef ( @{$Top10ItemIDsRef} ) {

        my %FAQData = $FAQObject->FAQGet(
            ItemID     => $ItemIDRef->{ItemID},
            ItemFields => 0,
            UserID     => 1,
        );

        my $VoteData = $FAQObject->ItemVoteDataGet(
            ItemID => $ItemIDRef->{ItemID},
            UserID => 1,
        );
        my $VoteResult = sprintf(
            "%0."
                . $ConfigObject->Get(
                "FAQ::Explorer::ItemList::VotingResultDecimalPlaces"
                )
                . "f",
            $VoteData->{Result}
                || 0
        );
        my $Votes = $VoteData->{Votes} || 0;

        # Build table row.
        push @Data, [
            $FAQData{Number},
            $FAQData{Title},
            $ItemIDRef->{Count},
            $VoteResult,
            $Votes,
        ];
    }

    # Set report title.
    my $Title = "$Param{StartYear}-$Param{StartMonth}-$StartDay - $Param{EndYear}-$Param{EndMonth}-$EndDay";

    # Table headlines.
    my @HeadData = (
        'FAQ #',
        'Title',
        'Count',
        'Vote Result',
        'Votes',
    );

    my @Result = ( [$Title], [@HeadData], @Data );

    return @Result;
}

1;
