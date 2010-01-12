# --
# Kernel/System/ITSMChange/ITSMCondition/Expression.pm - all condition expression functions
# Copyright (C) 2003-2010 OTRS AG, http://otrs.com/
# --
# $Id: Expression.pm,v 1.15 2010-01-12 19:47:00 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange::ITSMCondition::Expression;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.15 $) [1];

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

    # handle 'CompareValue' in a special way
    if ( !exists $Param{CompareValue} || !defined $Param{CompareValue} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need CompareValue!',
        );
        return;
    }

    # TODO: execute ExpressionAddPre Event

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

    # TODO: execute ExpressionAddPost Event

    return $ExpressionID;
}

=item ExpressionUpdate()

Update a condition expression.

    my $Success = $ConditionObject->ExpressionUpdate(
        ExpressionID => 1234,
        ObjectID     => 234,        # (optional)
        AttributeID  => 345,        # (optional)
        OperatorID   => 456,        # (optional)
        Selector     => 1234',      # (optional)
        CompareValue => 'rejected', # (optional)
        UserID       => 1,
    );

=cut

sub ExpressionUpdate {
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

    # TODO: execute ExpressionUpdatePre Event

    # map update attributes to column names
    my %Attribute = (
        ObjectID     => 'object_id',
        AttributeID  => 'attribute_id',
        OperatorID   => 'operator_id',
        Selector     => 'selector',
        CompareValue => 'compare_value',
    );

    # build SQL to update expression
    my $SQL = 'UPDATE condition_expression SET ';
    my @Bind;

    ATTRIBUTE:
    for my $Attribute ( keys %Attribute ) {

        # preserve the old value, when the column isn't in function parameters
        next ATTRIBUTE if !exists $Param{$Attribute};
        next ATTRIBUTE if !defined $Param{$Attribute};

        # param checking has already been done, so this is safe
        $SQL .= "$Attribute{$Attribute} = ?, ";
        push @Bind, \$Param{$Attribute};
    }

    # set condition ID to allow trailing comma of previous loop
    $SQL .= ' condition_id = condition_id ';

    # set matching of SQL statement
    $SQL .= 'WHERE id = ?';
    push @Bind, \$Param{ExpressionID};

    # update expression
    return if !$Self->{DBObject}->Do(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    # TODO: execute ExpressionUpdatePost Event

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

=item ExpressionMatch()

Returns the boolean value of an expression.

    my $Match = $ConditionObject->ExpressionMatch(
        ExpressionID      => 123,
        AttributesChanged => [ 'ChangeTitle', 'ChangeStateID' ],  # (optional)
        UserID            => 1,
    );

=cut

sub ExpressionMatch {
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

    # get expression content
    my $Expression = $Self->ExpressionGet(
        ExpressionID => $Param{ExpressionID},
        UserID       => $Param{UserID},
    );

    # check expression content
    return if !$Expression;

    # get expression attributes
    my $ExpressionData = $Self->_ExpressionMatchInit(
        Expression => $Expression,
        UserID     => $Param{UserID},
    );

    # check expression attributes
    return if !$ExpressionData;

    # TODO: check for changed fields

    # get object name
    my $ObjectName = $ExpressionData->{Object}->{Name};

    # get object data
    my $ExpressionObjectData = $Self->ObjectDataGet(
        ConditionID => $Expression->{ConditionID},
        ObjectName  => $ObjectName,
        Selector    => $Expression->{Selector},
        UserID      => $Param{UserID},
    );

    # check for expression object data
    # no need to execute operator if it is an empty array ref
    if (
        !$ExpressionObjectData
        || ref $ExpressionObjectData ne 'ARRAY'
        || ref $ExpressionObjectData eq 'ARRAY' && !@{$ExpressionObjectData}
        )
    {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "No object data for $ObjectName ($Expression->{Selector}) found!",
        );
        return;
    }

    # get attribute type
    my $AttributeType = $ExpressionData->{Attribute}->{Name};

    # check attribute type
    if ( !$AttributeType ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "No attribute $ObjectName ($Expression->{Selector}) found!",
        );
        return;
    }

    # check for object attribute
    for my $ExpressionObject ( @{$ExpressionObjectData} ) {
        if ( !exists $ExpressionObject->{$AttributeType} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "No object attribute for $ObjectName ($AttributeType) found!",
            );
            return;
        }
    }

    # return result of the expressions execution
    return $Self->OperatorExecute(
        OperatorName => $ExpressionData->{Operator}->{Name},
        Attribute    => $AttributeType,
        Selector     => $Expression->{Selector},
        ObjectData   => $ExpressionObjectData,
        CompareValue => $Expression->{CompareValue},
        UserID       => $Param{UserID},
    );
}

=item _ExpressionMatchInit()

Returns object, attribute and operator of a given expression.

    my $ExpressionData = $ConditionObject->_ExpressionMatchInit(
        Expression => $ExpressionRef,
        UserID     => 1,
    );

=cut

sub _ExpressionMatchInit {
    my ( $Self, %Param ) = @_;

    # extract expression
    my $Expression = $Param{Expression};

    # declate expression data
    my %ExpressionData;

    # get object data
    $ExpressionData{Object} = $Self->ObjectGet(
        ObjectID => $Expression->{ObjectID},
        UserID   => $Param{UserID},
    );

    # check for object data
    if ( !$ExpressionData{Object} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "No value for 'Object' with ID '$Expression->{ObjectID}'!",
        );
        return;
    }

    # get attribute data
    $ExpressionData{Attribute} = $Self->AttributeGet(
        AttributeID => $Expression->{AttributeID},
        UserID      => $Param{UserID},
    );

    # check for attribute data
    if ( !$ExpressionData{Attribute} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "No value for 'Attribute' with ID '$Expression->{AttributeID}'!",
        );
        return;
    }

    # get operator data
    $ExpressionData{Operator} = $Self->OperatorGet(
        OperatorID => $Expression->{OperatorID},
        UserID     => $Param{UserID},
    );

    # check for operator data
    if ( !$ExpressionData{Operator} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "No value for 'Operator' with ID '$Expression->{OperatorID}'!",
        );
        return;
    }

    return \%ExpressionData;
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

$Revision: 1.15 $ $Date: 2010-01-12 19:47:00 $

=cut
