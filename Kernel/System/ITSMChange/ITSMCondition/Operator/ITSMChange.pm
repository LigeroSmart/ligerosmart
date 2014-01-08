# --
# Kernel/System/ITSMChange/ITSMCondition/Operator/ITSMChange.pm - all itsm change operator functions
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange::ITSMCondition::Operator::ITSMChange;

use strict;
use warnings;

use Kernel::System::ITSMChange;

=head1 NAME

Kernel::System::ITSMChange::ITSMCondition::Operator::ITSMChange - condition itsm change operator lib

=head1 SYNOPSIS

All ITSMChange operator functions for conditions in ITSMChangeManagement.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::Main;
    use Kernel::System::Time;
    use Kernel::System::ITSMChange::ITSMCondition::Operator::ITSMChange;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $ConditionOperatorITSMChange = Kernel::System::ITSMChange::ITSMCondition::Operator::ITSMChange->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
        TimeObject   => $TimeObject,
        DBObject     => $DBObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (
        qw(DBObject ConfigObject EncodeObject LogObject MainObject UserObject GroupObject TimeObject)
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    # create additional objects
    $Self->{ChangeObject} = Kernel::System::ITSMChange->new( %{$Self} );

    return $Self;
}

=item Set()

Updates a change with the given data.

    my $Success = $ITSMChangeOperator->Set(
        Selector    => 1234,
        Attribute   => 'ChangeStateID',
        ActionValue => 2345,
        UserID      => 1234,
    );

=cut

sub Set {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Selector Attribute ActionValue UserID)) {
        if ( !exists $Param{$Argument} || !defined $Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get change
    my $Change = $Self->{ChangeObject}->ChangeGet(
        ChangeID => $Param{Selector},
        UserID   => $Param{UserID},
    );

    # check error
    return if !$Change;
    return if ref $Change ne 'HASH';

    # set change attribute to empty string if it is not true
    $Change->{ $Param{Attribute} } ||= '';

    # do not update the attribute if it already has this value
    # ( this will prevent infinite event looping! )
    return 1 if $Change->{ $Param{Attribute} } eq $Param{ActionValue};

    # update change and return update result
    return $Self->{ChangeObject}->ChangeUpdate(
        ChangeID          => $Param{Selector},
        $Param{Attribute} => $Param{ActionValue},
        UserID            => $Param{UserID},
    );
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
