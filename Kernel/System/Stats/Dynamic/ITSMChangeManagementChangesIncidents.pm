# --
# Kernel/System/Stats/Dynamic/ITSMChangeManagementChangesIncidents.pm
# Copyright (C) 2003-2010 OTRS AG, http://otrs.com/
# --
# $Id: ITSMChangeManagementChangesIncidents.pm,v 1.3 2010-01-22 08:33:15 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Stats::Dynamic::ITSMChangeManagementChangesIncidents;

use strict;
use warnings;

use Kernel::System::ITSMChange;
use Kernel::System::Ticket;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

my %Objects = (
    1 => 'Incidents',
    2 => 'Changes',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (
        qw(DBObject ConfigObject LogObject UserObject TimeObject MainObject EncodeObject)
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    # create needed objects
    $Self->{ChangeObject} = Kernel::System::ITSMChange->new( %{$Self} );
    $Self->{TicketObject} = Kernel::System::Ticket->new( %{$Self} );

    return $Self;
}

sub GetObjectName {
    my ( $Self, %Param ) = @_;

    return 'ITSMChangeManagementChangesIncidents';
}

sub GetObjectAttributes {
    my ( $Self, %Param ) = @_;

    my @ObjectAttributes = (
        {
            Name             => 'Objects',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'Object',
            Block            => 'MultiSelectField',
            Values           => \%Objects,
        },
        {
            Name             => 'Timeperiod',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'TimePeriod',
            TimePeriodFormat => 'DateInputFormat',    # 'DateInputFormatLong',
            Block            => 'Time',
            Values           => {
                TimeStart => 'CreateTimeNewerDate',
                TimeStop  => 'CreateTimeOlderDate',
            },
        },
    );

    return @ObjectAttributes;
}

sub GetStatElement {
    my ( $Self, %Param ) = @_;

    # delete CreateTimeNewerData as we want to get *ALL* existing objects
    delete $Param{CreateTimeNewerData};

    # if this cell should be filled with number of incidents
    if ( $Param{Object}->[0] == 1 ) {
        return $Self->{TicketObject}->TicketSearch(
            UserID     => 1,
            Result     => 'COUNT',
            Permission => 'ro',
            Limit      => 100_000_000,

            # TODO: Fix this! Wrong ticket type. The correct ticket type would be 'Incident'.
            # But having the type fixed is not a good idea. Would be better to show
            # a list of all ticket types in the stats frontend instead.
            #Types      => ['incident'],
            Types => ['Incident'],
            %Param,
        );
    }

    # if this cell should be filled with number of changes
    elsif ( $Param{Object}->[0] == 2 ) {
        return $Self->{ChangeObject}->ChangeSearch(
            UserID     => 1,
            Result     => 'COUNT',
            Permission => 'ro',
            Limit      => 100_000_000,
            %Param,
        );
    }

    return;
}

sub ExportWrapper {
    my ( $Self, %Param ) = @_;

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

                    for my $Key ( keys %Objects ) {
                        $ID->{Content} = $Key if $Objects{$Key} eq $ID->{Content};
                    }
                }
            }
        }
    }

    return \%Param;
}

1;
