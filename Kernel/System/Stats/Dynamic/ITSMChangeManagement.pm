# --
# Kernel/System/Stats/Dynamic/ITSMChangeManagement.pm - all advice functions
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Stats::Dynamic::ITSMChangeManagement;

use strict;
use warnings;

use Kernel::System::ITSMChange;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (
        qw(DBObject ConfigObject LogObject UserObject TimeObject UserObject GroupObject MainObject EncodeObject)
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    # create needed objects
    $Self->{ChangeObject} = Kernel::System::ITSMChange->new( %{$Self} );

    return $Self;
}

sub GetObjectName {
    my ( $Self, %Param ) = @_;

    return 'ITSMChangeManagement';
}

sub GetObjectAttributes {
    my ( $Self, %Param ) = @_;

    # get change state list
    my $ChangeStates = $Self->{ChangeObject}->ChangePossibleStatesGet(
        UserID => 1,
    );
    my %ChangeStateList = map { $_->{Key} => $_->{Value} } @{$ChangeStates};

    # get cip lists
    my $Categories = $Self->{ChangeObject}->ChangePossibleCIPGet(
        Type   => 'Category',
        UserID => 1,
    );
    my %CategoryList = map { $_->{Key} => $_->{Value} } @{$Categories};

    my $Impacts = $Self->{ChangeObject}->ChangePossibleCIPGet(
        Type   => 'Impact',
        UserID => 1,
    );
    my %ImpactList = map { $_->{Key} => $_->{Value} } @{$Impacts};

    my $Priorities = $Self->{ChangeObject}->ChangePossibleCIPGet(
        Type   => 'Priority',
        UserID => 1,
    );
    my %PriorityList = map { $_->{Key} => $_->{Value} } @{$Priorities};

    # get current time to fix bug#4870
    my $TimeStamp = $Self->{TimeObject}->CurrentTimestamp();
    my ($Date) = split /\s+/, $TimeStamp;
    my $Today = sprintf "%s 23:59:59", $Date;

    my @ObjectAttributes = (
        {
            Name             => 'Change State',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'ChangeStateIDs',
            Block            => 'MultiSelectField',
            Values           => \%ChangeStateList,
        },
        {
            Name             => 'Category',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'CategoryIDs',
            Block            => 'MultiSelectField',
            Values           => \%CategoryList,
        },
        {
            Name             => 'Priority',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'PriorityIDs',
            Block            => 'MultiSelectField',
            Values           => \%PriorityList,
        },
        {
            Name             => 'Impact',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'ImpactIDs',
            Block            => 'MultiSelectField',
            Translation      => 0,
            Values           => \%ImpactList,
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

sub GetStatElement {
    my ( $Self, %Param ) = @_;

    # search changes
    my $Count = $Self->{ChangeObject}->ChangeSearch(
        UserID     => 1,
        Result     => 'COUNT',
        Permission => 'ro',
        Limit      => 100_000_000,
        %Param,
    );

    return $Count;
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

            if ( $ElementName eq 'ChangeStateIDs' ) {
                my $StateList = $Self->{ChangeObject}->ChangePossibleStatesGet( UserID => 1 );
                ID:
                for my $ID ( @{$Values} ) {
                    next ID if !$ID;

                    STATE:
                    for my $State ( @{$StateList} ) {
                        next STATE if $ID->{Content} ne $State->{Key};
                        $ID->{Content} = $State->{Value};
                    }
                }
            }

            elsif (
                $ElementName eq 'CategoryIDs' || $ElementName eq 'ImpactIDs'
                || $ElementName eq 'PriorityIDs'
                )
            {
                my ($Type) = $ElementName =~ m{ \A (.*?) IDs \z }xms;

                my $CIPList = $Self->{ChangeObject}->ChangePossibleCIPGet(
                    Type   => $Type,
                    UserID => 1,
                );

                ID:
                for my $ID ( @{$Values} ) {
                    next ID if !$ID;

                    ELEMENT:
                    for my $Element ( @{$CIPList} ) {
                        next ELEMENT if $ID->{Content} ne $Element->{Key};
                        $ID->{Content} = $Element->{Value};
                    }
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

            if ( $ElementName eq 'ChangeStateIDs' ) {
                ID:
                for my $ID ( @{$Values} ) {
                    next ID if !$ID;

                    my $ChangeStateID = $Self->{ChangeObject}->ChangeStateLookup(
                        ChangeState => $ID->{Content},
                        Cache       => 1,
                    );
                    if ($ChangeStateID) {
                        $ID->{Content} = $ChangeStateID;
                    }
                    else {
                        $Self->{LogObject}->Log(
                            Priority => 'error',
                            Message  => "Import: Can't find state $ID->{Content}!"
                        );
                        $ID = undef;
                    }
                }
            }

            # import wrapper for CIP
            for my $Type (qw(Category Impact Priority)) {
                if ( $ElementName eq $Type . 'IDs' ) {
                    ID:
                    for my $ID ( @{$Values} ) {
                        next ID if !$ID;

                        my $CIPID = $Self->{ChangeObject}->ChangeCIPLookup(
                            CIP  => $ID->{Content},
                            Type => $Type,
                        );
                        if ($CIPID) {
                            $ID->{Content} = $CIPID;
                        }
                        else {
                            $Self->{LogObject}->Log(
                                Priority => 'error',
                                Message  => "Import: Can't find $Type $ID->{Content}!"
                            );
                            $ID = undef;
                        }
                    }
                }
            }
        }
    }
    return \%Param;
}

1;
