# --
# Kernel/System/ITSMChange/ITSMCondition/Expression.pm - all condition expression functions
# Copyright (C) 2003-2010 OTRS AG, http://otrs.com/
# --
# $Id: Expression.pm,v 1.2 2010-01-07 13:28:54 mae Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange::ITSMCondition::Expression;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

=head1 NAME

Kernel::System::ITSMChange::ITSMCondition::Expression - condition expression lib

=head1 SYNOPSIS

All functions for condition expressions in ITSMChangeManagement.

=head1 PUBLIC INTERFACE

=over 4

=item ExpressionAdd()

Add a new condition expression.

    my $ExpressionID = $ConditionObject->ExpressionAdd(
        ConditionID  => 123,
        ObjectID     => 234,
        AttributeID  => 345,
        OperatorID   => 456,
        Selector     => 1234',
        CompareValue => 'rejected',
        UserID       => 1,
    );

=cut

sub ExpressionAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (
        qw(
        ConditionID
        ObjectID
        AttributeID
        OperatorID
        Selector
        CompareValue
        UserID
        )
        )
    {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # TODO:
    my $CheckExpressionID;

    # check if expression name already exists
    if ($CheckExpressionID) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Condition expression ($Param{Name}) already exists!",
        );
        return;
    }

    # add new expression name to database
    return if !$Self->{DBObject}->Do(
        SQL => 'INSERT INTO condition_expression '
            . '(condition_id, object_id, attribute_id, '
            . 'operator_id, selector, compare_value) '
            . 'VALUES (?, ?, ?, ?, ?, ?)',
        Bind => [
            \$Param{ConditionID}, \$Param{ObjectID}, \$Param{AttributeID},
            \$Param{OperatorID},  \$Param{Selector}, \$Param{CompareValue},
        ],
    );

    # prepare SQL statement
    my $ExpressionID;
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id FROM condition_expression '
            . 'WHERE condition_id = ? AND object_id = ? AND attribute_id = ? '
            . 'AND operator_id = ? AND selector = ? AND compare_value = ?',
        Bind => [
            \$Param{ConditionID}, \$Param{ObjectID}, \$Param{AttributeID},
            \$Param{OperatorID},  \$Param{Selector}, \$Param{CompareValue},
        ],
        Limit => 1,
    );

    # get id of created expression
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $ExpressionID = $Row[0];
    }

    # check if expression could be added
    if ( !$ExpressionID ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "ExpressionAdd() failed!",
        );
        return;
    }

    return $ExpressionID;
}

=item ExpressionUpdate()

Update a condition expression.

    my $Success = $ConditionObject->ExpressionUpdate(
        ExpressionID => 1234,
        Name        => 'NewExpressionName',
        UserID      => 1,
    );

=cut

sub ExpressionUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(ExpressionID Name UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get expression data
    my $ExpressionData = $Self->ExpressionGet(
        ExpressionID => $Param{ExpressionID},
        UserID       => $Param{UserID},
    );

    # check expression data
    if ( !$ExpressionData ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "ExpressionUpdate of $Param{ExpressionID} failed!",
        );
        return;
    }

    # update expression in database
    return if !$Self->{DBObject}->Do(
        SQL => 'UPDATE condition_expression '
            . 'SET name = ? '
            . 'WHERE id = ?',
        Bind => [
            \$Param{Name},
            \$Param{ExpressionID},
        ],
    );

    return 1;
}

=item ExpressionGet()

Get a condition expression for a given expression id.
Returns a hash reference of the expression data.

    my $ConditionExpressionRef = $ConditionObject->ExpressionGet(
        ExpressionID => 1234,
        UserID       => 1,
    );

The returned hash reference contains following elements:

    $ConditionExpression{ExpressionID}
    $ConditionExpression{ConditionID}
    $ConditionExpression{ObjectID}
    $ConditionExpression{AttributeID}
    $ConditionExpression{OperatorID}
    $ConditionExpression{Selector}
    $ConditionExpression{CompareValue}

=cut

sub ExpressionGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(ExpressionID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # prepare SQL statement
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id, condition_id, object_id, attribute_id, '
            . 'operator_id, selector, compare_value '
            . 'FROM condition_expression WHERE id = ?',
        Bind  => [ \$Param{ExpressionID} ],
        Limit => 1,
    );

    # fetch the result
    my %ExpressionData;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $ExpressionData{ExpressionID} = $Row[0];
        $ExpressionData{ConditionID}  = $Row[1];
        $ExpressionData{ObjectID}     = $Row[2];
        $ExpressionData{AttributeID}  = $Row[3];
        $ExpressionData{OperatorID}   = $Row[4];
        $ExpressionData{Selector}     = $Row[5];
        $ExpressionData{CompareValue} = $Row[6];
    }

    # check error
    if ( !%ExpressionData ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "ExpressionID $Param{ExpressionID} does not exist!",
        );
        return;
    }

    return \%ExpressionData;
}

=item ExpressionList()

Returns a list of all condition expression ids for
a given ConditionID as array reference.

    my $ConditionExpressionIDsRef = $ConditionObject->ExpressionList(
        ConditionID => 1234,
        UserID      => 1,
    );

=cut

sub ExpressionList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(ConditionID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # prepare SQL statement
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id FROM condition_expression '
            . 'WHERE condition_id = ?',
        Bind => [ \$Param{ConditionID} ],
    );

    # fetch the result
    my @ExpressionList;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @ExpressionList, $Row[0];
    }

    return \@ExpressionList;
}

=item ExpressionDelete()

Deletes a condition expression.

    my $Success = $ConditionObject->ExpressionDelete(
        ExpressionID => 123,
        UserID      => 1,
    );

=cut

sub ExpressionDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(ExpressionID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # delete condition expression from database
    return if !$Self->{DBObject}->Do(
        SQL => 'DELETE FROM condition_expression '
            . 'WHERE id = ?',
        Bind => [ \$Param{ExpressionID} ],
    );

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

$Revision: 1.2 $ $Date: 2010-01-07 13:28:54 $

=cut
