# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::ITSMChange::ITSMCondition::Operator::ITSMChange;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::ITSMChange',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::ITSMChange::ITSMCondition::Operator::ITSMChange - condition itsm change operator lib

=head1 PUBLIC INTERFACE

=head2 new()

Create an object.

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $ConditionOperatorITSMChange = $Kernel::OM->Get('Kernel::System::ITSMChange::ITSMCondition::Operator::ITSMChange');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 Set()

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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get change
    my $Change = $Kernel::OM->Get('Kernel::System::ITSMChange')->ChangeGet(
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
    return $Kernel::OM->Get('Kernel::System::ITSMChange')->ChangeUpdate(
        ChangeID          => $Param{Selector},
        $Param{Attribute} => $Param{ActionValue},
        UserID            => $Param{UserID},
    );
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
