# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Stats::Dynamic::ITSMChangeManagementChangesIncidents;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::DateTime',
    'Kernel::System::ITSMChange',
    'Kernel::System::Ticket',
    'Kernel::System::Type',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub GetObjectName {
    my ( $Self, %Param ) = @_;

    return 'ITSMChangeManagementChangesIncidents';
}

sub GetObjectBehaviours {
    my ( $Self, %Param ) = @_;

    my %Behaviours = (
        ProvidesDashboardWidget => 1,
    );

    return %Behaviours;
}

sub GetObjectAttributes {
    my ( $Self, %Param ) = @_;

    # get list of ticket types
    my %Objects = $Kernel::OM->Get('Kernel::System::Type')->TypeList(
        Valid => 1,
    );
    $Objects{'-1'} = 'Changes';

    # get current time to fix bug#4870
    my $Today = $Kernel::OM->Create('Kernel::System::DateTime')->Format( Format => '%Y-%m-%d 23:59:59' );

    my @ObjectAttributes = (
        {
            Name             => 'Objects',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'Object',
            Block            => 'MultiSelectField',
            Values           => \%Objects,
            SelectedValues   => [ keys %Objects ],
        },
        {
            Name             => 'Timeperiod',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'TimePeriod',
            TimePeriodFormat => 'DateInputFormat',    # 'DateInputFormatLong',
            Block            => 'Time',
            TimeStop         => $Today,
            Values           => {
                TimeStart => 'CreateTimeNewerDate',
                TimeStop  => 'CreateTimeOlderDate',
            },
        },
    );

    return @ObjectAttributes;
}

sub GetStatElementPreview {
    my ( $Self, %Param ) = @_;

    return int rand 50;
}

sub GetStatElement {
    my ( $Self, %Param ) = @_;

    # delete CreateTimeNewerData as we want to get *ALL* existing objects
    delete $Param{CreateTimeNewerDate};

    # for tickets the search option is "TicketCreateTimeOlderDate"
    $Param{TicketCreateTimeOlderDate} = $Param{CreateTimeOlderDate};

    # if this cell should be filled with number of changes
    if ( $Param{Object}->[0] == -1 ) {
        return $Kernel::OM->Get('Kernel::System::ITSMChange')->ChangeSearch(
            UserID     => 1,
            Result     => 'COUNT',
            Permission => 'ro',
            Limit      => 100_000_000,
            %Param,
        );
    }

    # if this cell should be filled with number of tickets
    else {
        return $Kernel::OM->Get('Kernel::System::Ticket')->TicketSearch(
            UserID     => 1,
            Result     => 'COUNT',
            Permission => 'ro',
            Limit      => 100_000_000,
            TypeIDs    => [ $Param{Object}->[0] ],
            %Param,
        );
    }

    return;
}

sub ExportWrapper {
    my ( $Self, %Param ) = @_;

    # get list of ticket types
    my %Objects = $Kernel::OM->Get('Kernel::System::Type')->TypeList( Valid => 1 );
    $Objects{'-1'} = 'Changes';

    # wrap ids to used spelling
    for my $Use (qw(UseAsValueSeries UseAsRestriction UseAsXvalue)) {
        ELEMENT:
        for my $Element ( @{ $Param{$Use} } ) {

            next ELEMENT if !$Element;
            next ELEMENT if !$Element->{SelectedValues};

            my $ElementName = $Element->{Element};
            my $Values      = $Element->{SelectedValues};

            if ( $ElementName eq 'Object' ) {

                ID:
                for my $ID ( @{$Values} ) {
                    next ID if !$ID;

                    $ID->{Content} = $Objects{ $ID->{Content} };
                }
            }
        }
    }

    return \%Param;
}

sub ImportWrapper {
    my ( $Self, %Param ) = @_;

    # get list of ticket types
    my %Objects = $Kernel::OM->Get('Kernel::System::Type')->TypeList( Valid => 1 );
    $Objects{'-1'} = 'Changes';

    # wrap used spelling to ids
    for my $Use (qw(UseAsValueSeries UseAsRestriction UseAsXvalue)) {
        ELEMENT:
        for my $Element ( @{ $Param{$Use} } ) {

            next ELEMENT if !$Element;
            next ELEMENT if !$Element->{SelectedValues};

            my $ElementName = $Element->{Element};
            my $Values      = $Element->{SelectedValues};

            if ( $ElementName eq 'Object' ) {
                ID:
                for my $ID ( @{$Values} ) {
                    next ID if !$ID;

                    for my $Key ( sort keys %Objects ) {
                        $ID->{Content} = $Key if $Objects{$Key} eq $ID->{Content};
                    }
                }
            }
        }
    }

    return \%Param;
}

1;
