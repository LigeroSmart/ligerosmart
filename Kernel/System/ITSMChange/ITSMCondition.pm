# --
# Kernel/System/ITSMChange/ITSMCondition.pm - all condition functions
# Copyright (C) 2003-2010 OTRS AG, http://otrs.com/
# --
# $Id: ITSMCondition.pm,v 1.29 2010-01-27 20:10:13 mae Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange::ITSMCondition;

use strict;
use warnings;

use Kernel::System::Valid;

use base qw(Kernel::System::EventHandler);
use base qw(Kernel::System::ITSMChange::ITSMCondition::Object);
use base qw(Kernel::System::ITSMChange::ITSMCondition::Attribute);
use base qw(Kernel::System::ITSMChange::ITSMCondition::Operator);
use base qw(Kernel::System::ITSMChange::ITSMCondition::Expression);
use base qw(Kernel::System::ITSMChange::ITSMCondition::Action);

use vars qw($VERSION);
$VERSION = qw($Revision: 1.29 $) [1];

=head1 NAME

Kernel::System::ITSMChange::ITSMCondition - condition lib

=head1 SYNOPSIS

All functions for conditions in ITSMChangeManagement.

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
    use Kernel::System::ITSMChange::ITSMCondition;

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
    my $ConditionObject = Kernel::System::ITSMChange::ITSMCondition->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        TimeObject   => $TimeObject,
        MainObject   => $MainObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(DBObject ConfigObject EncodeObject LogObject MainObject TimeObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    # set the debug flag
    $Self->{Debug} = $Param{Debug} || 0;

    # create additional objects
    $Self->{ValidObject} = Kernel::System::Valid->new( %{$Self} );

    # init of event handler
    $Self->EventHandlerInit(
        Config     => 'ITSMCondition::EventModule',
        BaseObject => 'ConditionObject',
        Objects    => {
            %{$Self},
        },
    );

    return $Self;
}

=item ConditionAdd()

Add a new condition.

    my $ConditionID = $ConditionObject->ConditionAdd(
        ChangeID              => 123,
        Name                  => 'The condition name',
        ExpressionConjunction => 'any',                 # (any|all)
        Comment               => 'A comment',           # (optional)
        ValidID               => 1,
        UserID                => 1,
    );

=cut

sub ConditionAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(ChangeID Name ExpressionConjunction ValidID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # check if a condition with this name and change id exist already
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id FROM change_condition '
            . 'WHERE change_id = ? AND name = ?',
        Bind => [
            \$Param{ChangeID}, \$Param{Name},
        ],
        Limit => 1,
    );

    # fetch the result
    my $ConditionID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $ConditionID = $Row[0];
    }

    # a condition with this name and change id exists already
    if ($ConditionID) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "A condition with the name $Param{Name} "
                . "exists already for ChangeID $Param{ChangeID}!",
        );
        return;
    }

    # TODO: execute ConditionAddPre Event

    # add new condition to database
    return if !$Self->{DBObject}->Do(
        SQL => 'INSERT INTO change_condition '
            . '(change_id, name, expression_conjunction, comments, valid_id, '
            . 'create_time, create_by, change_time, change_by) '
            . 'VALUES (?, ?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{ChangeID}, \$Param{Name}, \$Param{ExpressionConjunction},
            \$Param{Comment}, \$Param{ValidID}, \$Param{UserID}, \$Param{UserID},
        ],
    );

    # prepare SQL statement
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id FROM change_condition '
            . 'WHERE change_id = ? AND name = ?',
        Bind => [
            \$Param{ChangeID}, \$Param{Name},
        ],
        Limit => 1,
    );

    # fetch the result
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $ConditionID = $Row[0];
    }

    # check if condition could be added
    if ( !$ConditionID ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "ConditionAdd() failed!",
        );
        return;
    }

    # TODO: execute ConditionAddPost Event

    return $ConditionID;
}

=item ConditionUpdate()

Update a condition.

    my $Success = $ConditionObject->ConditionUpdate(
        ConditionID           => 1234,
        Name                  => 'The condition name',  # (optional)
        ExpressionConjunction => 'any',                 # (optional) (any|all)
        Comment               => 'A comment',           # (optional)
        ValidID               => 1,                     # (optional)
        UserID                => 1,
    );

=cut

sub ConditionUpdate {
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

    # TODO: execute ConditionUpdatePre Event

    # map update attributes to column names
    my %Attribute = (
        Name                  => 'name',
        ExpressionConjunction => 'expression_conjunction',
        Comment               => 'comments',
        ValidID               => 'valid_id',
    );

    # build SQL to update condition
    my $SQL = 'UPDATE change_condition SET ';
    my @Bind;

    ATTRIBUTE:
    for my $Attribute ( keys %Attribute ) {

        # preserve the old value, when the column isn't in function parameters
        next ATTRIBUTE if !exists $Param{$Attribute};

        # param checking has already been done, so this is safe
        $SQL .= "$Attribute{$Attribute} = ?, ";
        push @Bind, \$Param{$Attribute};
    }

    # add change time and change user
    $SQL .= 'change_time = current_timestamp, change_by = ? ';
    push @Bind, \$Param{UserID};

    # set matching of SQL statement
    $SQL .= 'WHERE id = ?';
    push @Bind, \$Param{ConditionID};

    # update condition
    return if !$Self->{DBObject}->Do(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    # TODO: execute ConditionUpdatePost Event

    return 1;
}

=item ConditionGet()

Returns a hash reference of the condition data for a given ConditionID.

    my $ConditionData = $ConditionObject->ConditionGet(
        ConditionID => 123,
        UserID      => 1,
    );

The returned hash reference contains following elements:

    $ConditionData{ConditionID}
    $ConditionData{ChangeID}
    $ConditionData{Name}
    $ConditionData{ExpressionConjunction}
    $ConditionData{Comment}
    $ConditionData{ValidID}
    $ConditionData{CreateTime}
    $ConditionData{CreateBy}
    $ConditionData{ChangeTime}
    $ConditionData{ChangeBy}

=cut

sub ConditionGet {
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
        SQL => 'SELECT id, change_id, name, expression_conjunction, comments, '
            . 'valid_id, create_time, create_by, change_time, change_by '
            . 'FROM change_condition '
            . 'WHERE id = ?',
        Bind  => [ \$Param{ConditionID} ],
        Limit => 1,
    );

    # fetch the result
    my %ConditionData;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $ConditionData{ConditionID}           = $Row[0];
        $ConditionData{ChangeID}              = $Row[1];
        $ConditionData{Name}                  = $Row[2];
        $ConditionData{ExpressionConjunction} = $Row[3];
        $ConditionData{Comment}               = $Row[4];
        $ConditionData{ValidID}               = $Row[5];
        $ConditionData{CreateTime}            = $Row[6];
        $ConditionData{CreateBy}              = $Row[7];
        $ConditionData{ChangeTime}            = $Row[8];
        $ConditionData{ChangeBy}              = $Row[9];
    }

    # check error
    if ( !%ConditionData ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "ConditionID $Param{ConditionID} does not exist!",
        );
        return;
    }

    return \%ConditionData;
}

=item ConditionList()

return a list of all conditions ids of a given change id as array reference

    my $ConditionIDsRef = $ConditionObject->ConditionList(
        ChangeID => 5,
        Valid    => 0,   # (optional) default 1 (0|1)
        UserID   => 1,
    );

=cut

sub ConditionList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(ChangeID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # check valid param
    if ( !defined $Param{Valid} ) {
        $Param{Valid} = 1;
    }

    # define SQL statement
    my $SQL = 'SELECT id '
        . 'FROM change_condition '
        . 'WHERE change_id = ? ';

    # get only valid condition ids
    if ( $Param{Valid} ) {

        my @ValidIDs = $Self->{ValidObject}->ValidIDsGet();
        my $ValidIDString = join ', ', @ValidIDs;

        $SQL .= "AND valid_id IN ( $ValidIDString ) ";
    }

    # get sorted list
    $SQL .= 'ORDER BY id ASC ';

    # prepare SQL statement
    return if !$Self->{DBObject}->Prepare(
        SQL  => $SQL,
        Bind => [ \$Param{ChangeID} ],
    );

    # fetch the result
    my @ConditionIDs;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @ConditionIDs, $Row[0];
    }

    return \@ConditionIDs;
}

=item ConditionDelete()

Delete a condition.

    my $Success = $ConditionObject->ConditionDelete(
        ConditionID => 123,
        UserID      => 1,
    );

=cut

sub ConditionDelete {
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

    # TODO: execute ConditionDeletePre Event
    # TODO it may be neccessary to get the ChangeID from ConditionGet()
    # so that the history entry will be written to the correct change

    # delete all expressions for this condition id
    my $Success = $Self->ExpressionDeleteAll(
        ConditionID => $Param{ConditionID},
        UserID      => $Param{UserID},
    );

    return if !$Success;

    # delete all actions for this condition id
    $Success = $Self->ActionDeleteAll(
        ConditionID => $Param{ConditionID},
        UserID      => $Param{UserID},
    );

    return if !$Success;

    # delete condition from database
    return if !$Self->{DBObject}->Do(
        SQL => 'DELETE FROM change_condition '
            . 'WHERE id = ?',
        Bind => [ \$Param{ConditionID} ],
    );

    # TODO: execute ConditionDeletePost Event

    return 1;
}

=item ConditionDeleteAll()

Delete all conditions for a given ChangeID.
All related expressions and actions will be deleted first.

    my $Success = $ConditionObject->ConditionDeleteAll(
        ChangeID => 123,
        UserID   => 1,
    );

=cut

sub ConditionDeleteAll {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(ChangeID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get all condition ids (including invalid) for the given change id
    my $ConditionIDsRef = $Self->ConditionList(
        ChangeID => $Param{ChangeID},
        Valid    => 0,
        UserID   => $Param{UserID},
    );

    # TODO: execute ConditionDeleteAllPre Event

    for my $ConditionID ( @{$ConditionIDsRef} ) {

        # delete all expressions for this condition id
        my $Success = $Self->ExpressionDeleteAll(
            ConditionID => $ConditionID,
            UserID      => $Param{UserID},
        );

        return if !$Success;

        # delete all actions for this condition id
        $Success = $Self->ActionDeleteAll(
            ConditionID => $ConditionID,
            UserID      => $Param{UserID},
        );

        return if !$Success;
    }

    # TODO: execute ConditionDeleteAllPost Event
    # this must be myabe done before deleting the conditions from the database,
    # because of possible foreign key constraints in the change_history table

    # delete conditions from database
    return if !$Self->{DBObject}->Do(
        SQL => 'DELETE FROM change_condition '
            . 'WHERE change_id = ?',
        Bind => [ \$Param{ChangeID} ],
    );

    return 1;
}

=item ConditionMatchExecuteAll()

This functions finds all conditions for a given ChangeID, and in case a condition matches,
all defined actions will be executed.

    my $Success = $ConditionObject->ConditionMatchExecuteAll(
        ChangeID          => 123,
        AttributesChanged => { ITSMChange => [ ChangeTitle, ChangeDescription] },  # (optional)
        UserID            => 1,
    );

=cut

sub ConditionMatchExecuteAll {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(ChangeID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # TODO: Delete this later!
    $Self->{Debug} = 1;

    # TODO: Delete this later!
    # debug output
    if ( $Self->{Debug} ) {

        if ( $Param{AttributesChanged} ) {

            my ($Object) = keys %{ $Param{AttributesChanged} };

            # list of changed attributes
            my $DebugString = "\n\nDebug Information:\n"
                . "Object: $Object\n"
                . "AttributesChanged: "
                . ( join ', ', @{ $Param{AttributesChanged}->{$Object} } )
                . "\n\n";

            print STDERR $DebugString;

            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message  => "$DebugString",
            );
        }
    }

    # get all condition ids for the given change id
    my $ConditionIDsRef = $Self->ConditionList(
        ChangeID => $Param{ChangeID},
        Valid    => 1,
        UserID   => $Param{UserID},
    );

    # check errors
    return if !$ConditionIDsRef;
    return if ref $ConditionIDsRef ne 'ARRAY';

    # no error if just no valid conditions were found
    return 1 if !@{$ConditionIDsRef};

    # match and execute all conditions
    for my $ConditionID ( @{$ConditionIDsRef} ) {

        # match and execute each condition
        my $Success = $Self->ConditionMatchExecute(
            ConditionID       => $ConditionID,
            AttributesChanged => $Param{AttributesChanged},
            UserID            => $Param{UserID},
        );

        # write log entry but do not return
        if ( !$Success ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "ConditionMatchExecute for ConditionID '$ConditionID' failed!",
            );
        }
    }

    return 1;
}

=item ConditionMatchExecute()

This function matches the given condition and executes all defined actions.
The optional parameter 'AttributesChanged' defines a list of attributes that were changed
during e.g. a ChangeUpdate-Event. If a condition matches an expression, the attribute of the expression
must be listed in 'AttributesChanged'.

    my $Success = $ConditionObject->ConditionMatchExecute(
        ConditionID       => 123,
        AttributesChanged => { ITSMChange => [ ChangeTitle, ChangeDescription] },  # (optional)
        UserID            => 1,
    );

=cut

sub ConditionMatchExecute {
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

    # get condition data
    my $ConditionData = $Self->ConditionGet(
        ConditionID => $Param{ConditionID},
        UserID      => $Param{UserID},
    );

    # check error
    return if !$ConditionData;

    # get all expressions for the given condition id
    my $ExpressionIDsRef = $Self->ExpressionList(
        ConditionID => $Param{ConditionID},
        UserID      => $Param{UserID},
    );

    # check errors
    return if !$ExpressionIDsRef;
    return if ref $ExpressionIDsRef ne 'ARRAY';

    # no error if just no expressions were found
    return 1 if !@{$ExpressionIDsRef};

    # count the number of expression ids
    my $ExpressionIDCount = scalar @{$ExpressionIDsRef};

    # get all actions for the given condition id
    my $ActionIDsRef = $Self->ActionList(
        ConditionID => $Param{ConditionID},
        UserID      => $Param{UserID},
    );

    # check errors
    return if !$ActionIDsRef;
    return if ref $ActionIDsRef ne 'ARRAY';

    # no error if just no actions were found
    return 1 if !@{$ActionIDsRef};

    # to store the number of positive (true) expressions
    my @ExpressionMatchResult;

    # to store if the condition matches
    my $ConditionMatch;

    # try to match each expression
    EXPRESSIONID:
    for my $ExpressionID ( @{$ExpressionIDsRef} ) {

        # normally give the list of changed attributes to ExpressionMatch() function
        my $AttributesChanged = $Param{AttributesChanged};

        # expression conjunction is 'all' and there is more than one expresion
        if ( $ConditionData->{ExpressionConjunction} eq 'all' && $ExpressionIDCount > 1 ) {

            # do not give the list of changed attributes to ExpressionMatch()
            $AttributesChanged = undef;
        }

        # match expression
        my $ExpressionMatch = $Self->ExpressionMatch(
            ExpressionID      => $ExpressionID,
            AttributesChanged => $AttributesChanged,
            UserID            => $Param{UserID},
        );

        # set ConditionMatch true if ExpressionMatch is true and 'any' is requested
        if ( $ConditionData->{ExpressionConjunction} eq 'any' && $ExpressionMatch ) {
            $ConditionMatch = 1;
            last EXPRESSIONID;
        }

        # condition is false at all, so return true
        if ( $ConditionData->{ExpressionConjunction} eq 'all' && !$ExpressionMatch ) {
            return 1;
        }

        # save current expression match result for later checks
        push @ExpressionMatchResult, $ExpressionMatch;
    }

    # count all results which have a true value
    my $TrueCount = scalar grep { $_ == 1 } @ExpressionMatchResult;

    # if the condition did not match already, and not all expressions are true
    if ( !$ConditionMatch && $TrueCount != $ExpressionIDCount ) {

        # no error: if just the condition did not match,
        # there is no need to execute any actions
        return 1;
    }

    # execute all actions of this condition
    ACTIONID:
    for my $ActionID ( @{$ActionIDsRef} ) {

        # execute each action
        my $Success = $Self->ActionExecute(
            ActionID => $ActionID,
            UserID   => $Param{UserID},
        );

        # check error
        if ( !$Success ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "ActionID '$ActionID' could not be executed successfully "
                    . "for ConditionID '$Param{ConditionID}'.",
            );
        }
    }

    return 1;
}

=item ConditionMatchStateLock()

    my $Success = $ConditionObject->ConditionMatchStateLock(
        ObjectName => 'ITSMChange',
        Selector   => 234,
        StateID    => 123,
        UserID     => 1,
    );

=cut

sub ConditionMatchStateLock {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(ObjectName Selector StateID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get id of object
    my $ObjectID = $Self->ObjectLookup(
        Name   => $Param{ObjectName},
        UserID => $Param{UserID},
    );
    return if !$ObjectID;

    # get id of operator;
    my $OperatorName = 'lock';
    my $OperatorID   = $Self->OperatorLookup(
        Name   => $OperatorName,
        UserID => $Param{UserID},
    );
    return if !$OperatorID;

    # get conditions
    my $Conditions = $Self->_ConditionListByObject(
        ObjectName => $Param{ObjectName},
        Selector   => $Param{Selector},
        UserID     => $Param{UserID},
    ) || [];
    return if !@{$Conditions};

    # get all actions affecting this object
    my @AffectedConditionIDs;
    CONDITIONID:
    for my $ConditionID ( @{$Conditions} ) {
        my $ConditionActions = $Self->ActionList(
            ConditionID => $ConditionID,
            UserID      => $Param{UserID},
        ) || [];

        # check actions
        next CONDITIONID if !@{$ConditionActions};

        # check for actions
        ACTIONID:
        for my $ActionID ( @{$ConditionActions} ) {

            # get action
            my $Action = $Self->ActionGet(
                ActionID => $ActionID,
                UserID   => $Param{UserID},
            );

            # check action
            next ACTIONID if !$Action;

            # store only affected actions
            if (
                $Action->{ObjectID}       eq $ObjectID
                && $Action->{OperatorID}  eq $OperatorID
                && $Action->{Selector}    eq $Param{Selector}
                && $Action->{ActionValue} eq $Param{StateID}
                )
            {
                push @AffectedConditionIDs, $Action->{ConditionID};
            }
        }
    }

    # check for affected conditions
    return if !@AffectedConditionIDs;

    # check for positive condition matches
    AFFECTEDCONDITIONID:
    for my $AffectedConditionID (@AffectedConditionIDs) {

        # get condition
        my $ConditionMatch = $Self->_ConditionMatch(
            ConditionID => $AffectedConditionID,
            UserID      => $Param{UserID},
        );
        next AFFECTEDCONDITIONID if !$ConditionMatch;

        # condition matched successfully
        return 1 if $ConditionMatch;
    }

    # no condition matched
    return;
}

=item ConditionCompareValueFieldType()

Returns the type of the compare value field as string, based on the given object id and attribute id.

    my $FieldType = $ConditionObject->ConditionCompareValueFieldType(
        ObjectID    => 1234,
        AttributeID => 5,
        UserID      => 1,
    );

Returns 'Text' or 'Selection' or 'Date'.

TODO: Add 'Autocomplete' type for ChangeBuilder, ChangeManager, WorkOrderAgent, etc...

=cut

sub ConditionCompareValueFieldType {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(ObjectID AttributeID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # lookup object name
    my $ObjectName = $Self->ObjectLookup(
        ObjectID => $Param{ObjectID},
    );

    # check error
    if ( !$ObjectName ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "ObjectID $Param{ObjectID} does not exist!",
        );
        return;
    }

    # lookup attribute name
    my $AttributeName = $Self->AttributeLookup( AttributeID => $Param{AttributeID} );

    # check error
    if ( !$AttributeName ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "AttributeID $Param{AttributeID} does not exist!",
        );
        return;
    }

    # get the field type config for the given object
    my $Config = $Self->{ConfigObject}->Get( $ObjectName . '::Attribute::CompareValue::FieldType' );

    # check error
    return if !$Config;

    # get the field type for the given attribute
    my $FieldType = $Config->{$AttributeName} || '';

    return $FieldType;
}

=begin Internal:

=item _ConditionMatch()

This function matches the given condition and executes 'no' actions.
The optional parameter 'AttributesChanged' defines a list of attributes that were changed
during e.g. a ChangeUpdate-Event. If a condition matches an expression, the attribute of the expression
must be listed in 'AttributesChanged'.

    my $Success = $ConditionObject->_ConditionMatch(
        ConditionID       => 123,
        AttributesChanged => { ITSMChange => [ ChangeTitle, ChangeDescription] },  # (optional)
        UserID            => 1,
    );

=cut

sub _ConditionMatch {
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

    # get condition data
    my $ConditionData = $Self->ConditionGet(
        ConditionID => $Param{ConditionID},
        UserID      => $Param{UserID},
    );

    # check error
    return if !$ConditionData;

    # get all expressions for the given condition id
    my $ExpressionIDsRef = $Self->ExpressionList(
        ConditionID => $Param{ConditionID},
        UserID      => $Param{UserID},
    );

    # check errors
    return if !$ExpressionIDsRef;
    return if ref $ExpressionIDsRef ne 'ARRAY';

    # no error if just no expressions were found
    return 0 if !@{$ExpressionIDsRef};

    # count the number of expression ids
    my $ExpressionIDCount = scalar @{$ExpressionIDsRef};

    # to store the number of positive (true) expressions
    my @ExpressionMatchResult;

    # to store if the condition matches
    my $ConditionMatch;

    # try to match each expression
    EXPRESSIONID:
    for my $ExpressionID ( @{$ExpressionIDsRef} ) {

        # normally give the list of changed attributes to ExpressionMatch() function
        my $AttributesChanged = $Param{AttributesChanged};

        # expression conjunction is 'all' and there is more than one expresion
        if ( $ConditionData->{ExpressionConjunction} eq 'all' && $ExpressionIDCount > 1 ) {

            # do not give the list of changed attributes to ExpressionMatch()
            $AttributesChanged = undef;
        }

        # match expression
        my $ExpressionMatch = $Self->ExpressionMatch(
            ExpressionID      => $ExpressionID,
            AttributesChanged => $AttributesChanged,
            UserID            => $Param{UserID},
        );

        # set ConditionMatch true if ExpressionMatch is true and 'any' is requested
        if ( $ConditionData->{ExpressionConjunction} eq 'any' && $ExpressionMatch ) {
            return 1;
        }

        # condition is false at all, so return true
        if ( $ConditionData->{ExpressionConjunction} eq 'all' && !$ExpressionMatch ) {
            return 0;
        }

        # save current expression match result for later checks
        push @ExpressionMatchResult, $ExpressionMatch;
    }

    # count all results which have a true value
    my $TrueCount = scalar grep { $_ == 1 } @ExpressionMatchResult;

    # if the condition did not match already, and not all expressions are true
    if ( !$ConditionMatch && $TrueCount != $ExpressionIDCount ) {

        # not all expressions have matched
        return 0;
    }

    return 1;
}

=item _ConditionListByObject()

return a list of all conditions ids of a given object.

    my $ConditionIDsRef = $ConditionObject->_ConditionListByObject(
        ObjectName => 'ITSMChange'
        Selector   => 123,
        UserID   => 1,
    );

=cut

sub _ConditionListByObject {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(ObjectName Selector UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get change id
    my $ChangeID;

    if ( $Param{ObjectName} eq 'ITSMChange' ) {

        # selector is needed change id
        $ChangeID = $Param{Selector};
    }
    elsif ( $Param{ObjectName} eq 'ITSMWorkOrder' ) {

        # get workorder
        my $WorkOrder = $Self->{WorkOrderObject}->WorkOrderGet(
            WorkOrderID => $Param{Selector},
            UserID      => $Param{UserID},
        );
        return if !$WorkOrder;

        # get change id
        $ChangeID = $WorkOrder->{ChangeID};
    }

    # check change id
    return if !$ChangeID;

    # get conditions for this change
    my $Conditions = $Self->ConditionList(
        ChangeID => $ChangeID,
        UserID   => $Param{UserID},
    );

    return $Conditions;
}

1;

=end Internal:

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see http://www.gnu.org/licenses/agpl.txt.

=cut

=head1 VERSION

$Revision: 1.29 $ $Date: 2010-01-27 20:10:13 $

=cut
