# --
# Kernel/System/ITSMChange/ITSMCondition/Operator.pm - all condition operator functions
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: Operator.pm,v 1.1 2009-12-23 10:44:32 mae Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange::ITSMCondition::Operator;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

=head1 NAME

Kernel::System::ITSMChange::ITSMCondition::Operator - condition operator lib

=head1 SYNOPSIS

All functions for condition operators in ITSMChangeManagement.

=head1 PUBLIC INTERFACE

=over 4

=item OperatorAdd()

Add a new operator.

    my $ConditionID = $ConditionObject->OperatorAdd(
        UserID   => 1,
    );

=cut

sub OperatorAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    my $OperatorID;
    return $OperatorID;
}

=item OperatorUpdate()

=cut

sub OperatorUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(OperatorID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    return 1;
}

=item OperatorGet()

=cut

sub OperatorGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Attribute (qw(OperatorID UserID)) {
        if ( !$Param{$Attribute} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Attribute!",
            );
            return;
        }
    }

    my %OperatorData;
    return \%OperatorData;
}

=item OperatorLookup()

=cut

sub OperatorLookup {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Attribute (qw(UserID)) {
        if ( !$Param{$Attribute} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Attribute!",
            );
            return;
        }
    }

    return;
}

=item OperatorList()

return a list of all condition Operator ids as array reference

    my $ConditionOperatorIDsRef = $ConditionObject->OperatorList(
        UserID   => 1,
    );

=cut

sub OperatorList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Attribute (qw(UserID)) {
        if ( !$Param{$Attribute} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Attribute!",
            );
            return;
        }
    }

    return [];
}

=item OperatorDelete()

Delete a condition.

    my $Success = $ConditionObject->OperatorDelete(
        OperatorID => 123,
        UserID   => 1,
    );

=cut

sub OperatorDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Attribute (qw(OperatorID UserID)) {
        if ( !$Param{$Attribute} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Attribute!",
            );
            return;
        }
    }

    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see http://www.gnu.org/licenses/agpl.txt.

=cut

=head1 VERSION

$Revision: 1.1 $ $Date: 2009-12-23 10:44:32 $

=cut
