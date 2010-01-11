# --
# Kernel/System/ITSMChange/ITSMCondition/Object.pm - all condition object functions
# Copyright (C) 2003-2010 OTRS AG, http://otrs.com/
# --
# $Id: Object.pm,v 1.10 2010-01-11 15:07:37 mae Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange::ITSMCondition::Object;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.10 $) [1];

=head1 NAME

Kernel::System::ITSMChange::ITSMCondition::Object - condition object lib

=head1 SYNOPSIS

All functions for condition objects in ITSMChangeManagement.

=head1 PUBLIC INTERFACE

=over 4

=item ObjectAdd()

Add a new condition object.

    my $ConditionID = $ConditionObject->ObjectAdd(
        Name   => 'ObjectName',
        UserID => 1,
    );

=cut

sub ObjectAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Name UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # make lookup with given name for checks
    my $CheckObjectID = $Self->ObjectLookup(
        Name   => $Param{Name},
        UserID => $Param{UserID},
    );

    # check if object name already exists
    if ($CheckObjectID) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Condition object ($Param{Name}) already exists!",
        );
        return;
    }

    # add new object name to database
    return if !$Self->{DBObject}->Do(
        SQL => 'INSERT INTO condition_object '
            . '(name) '
            . 'VALUES (?)',
        Bind => [ \$Param{Name} ],
    );

    # get id of created object
    my $ObjectID = $Self->ObjectLookup(
        Name   => $Param{Name},
        UserID => $Param{UserID},
    );

    # check if object could be added
    if ( !$ObjectID ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "ObjectAdd() failed!",
        );
        return;
    }

    return $ObjectID;
}

=item ObjectUpdate()

Update a condition object.

    my $Success = $ConditionObject->ObjectUpdate(
        ObjectID => 1234,
        Name     => 'NewObjectName',
        UserID   => 1,
    );

=cut

sub ObjectUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(ObjectID Name UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get object data
    my $ObjectData = $Self->ObjectGet(
        ObjectID => $Param{ObjectID},
        UserID   => $Param{UserID},
    );

    # check object data
    if ( !$ObjectData ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "ObjectUpdate of $Param{ObjectID} failed!",
        );
        return;
    }

    # update object in database
    return if !$Self->{DBObject}->Do(
        SQL => 'UPDATE condition_object '
            . 'SET name = ? '
            . 'WHERE id = ?',
        Bind => [
            \$Param{Name},
            \$Param{ObjectID},
        ],
    );

    return 1;
}

=item ObjectGet()

Get a condition object for a given object id.
Returns a hash reference of the object data.

    my $ConditionObjectRef = $ConditionObject->ObjectGet(
        ObjectID => 1234,
        UserID   => 1,
    );

The returned hash reference contains following elements:

    $ConditionObject{ObjectID}
    $ConditionObject{Name}

=cut

sub ObjectGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(ObjectID UserID)) {
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
        SQL   => 'SELECT id, name FROM condition_object WHERE id = ?',
        Bind  => [ \$Param{ObjectID} ],
        Limit => 1,
    );

    # fetch the result
    my %ObjectData;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $ObjectData{ObjectID} = $Row[0];
        $ObjectData{Name}     = $Row[1];
    }

    # check error
    if ( !%ObjectData ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "ObjectID $Param{ObjectID} does not exist!",
        );
        return;
    }

    return \%ObjectData;
}

=item ObjectLookup()

This method does a lookup for a condition object. If an object
id is given, it returns the name of the object. If the name of the
object is given, the appropriate id is returned.

    my $ObjectName = $ConditionObject->ObjectLookup(
        ObjectID => 4321,
        UserID   => 1234,
    );

    my $ObjectID = $ConditionObject->ObjectLookup(
        Name   => 'ObjectName',
        UserID => 1234,
    );

=cut

sub ObjectLookup {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need UserID!",
        );
        return;
    }

    # check if both parameters are given
    if ( $Param{ObjectID} && $Param{Name} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need ObjectID or Name - not both!',
        );
        return;
    }

    # check if both parameters are not given
    if ( !$Param{ObjectID} && !$Param{Name} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need ObjectID or Name - none is given!',
        );
        return;
    }

    # prepare SQL statements
    if ( $Param{ObjectID} ) {
        return if !$Self->{DBObject}->Prepare(
            SQL   => 'SELECT name FROM condition_object WHERE id = ?',
            Bind  => [ \$Param{ObjectID} ],
            Limit => 1,
        );
    }
    elsif ( $Param{Name} ) {
        return if !$Self->{DBObject}->Prepare(
            SQL   => 'SELECT id FROM condition_object WHERE name = ?',
            Bind  => [ \$Param{Name} ],
            Limit => 1,
        );
    }

    # fetch the result
    my $Lookup;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Lookup = $Row[0];
    }

    return $Lookup;
}

=item ObjectList()

Returns a list of all condition object ids as array reference

    my $ConditionObjectIDsRef = $ConditionObject->ObjectList(
        UserID => 1,
    );

=cut

sub ObjectList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need UserID!",
        );
        return;
    }

    # prepare SQL statement
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT name FROM condition_object',
    );

    # fetch the result
    my @ObjectList;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @ObjectList, $Row[0];
    }

    return \@ObjectList;
}

=item ObjectDelete()

Deletes a condition object.

    my $Success = $ConditionObject->ObjectDelete(
        ObjectID => 123,
        UserID   => 1,
    );

=cut

sub ObjectDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(ObjectID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # delete condition object from database
    return if !$Self->{DBObject}->Do(
        SQL => 'DELETE FROM condition_object '
            . 'WHERE id = ?',
        Bind => [ \$Param{ObjectID} ],
    );

    return 1;
}

=item ObjectDataGet()

Return the data of a given type and selector of a certain object.

    my $ObjectDataRef = $ConditionObject->ObjectDataGet(
        ObjectName => 'ITSMChange',
        Selector   => ( '123' | 'all' | 'any' ),
        UserID     => 1,
    );

=cut

sub ObjectDataGet {
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

    # define known objects and function calls
    my %ObjectAction = (
        ITSMChange       => \&_ObjectITSMChange,
        ITSMWorkOrder    => \&_ObjectITSMWorkOrder,
        ITSMWorkOrderAll => \&_ObjectITSMWorkOrderAll,
    );

    # define the needed selectors
    my %ObjectSelector = (
        ITSMChange    => 'ChangeID',
        ITSMWorkOrder => 'WorkOrderID',
    );

    # get object type
    my $ObjectType = $Param{ObjectName};

    # check for manageable object
    if ( !exists $ObjectAction{$ObjectType} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "No object action for $ObjectType found!",
        );
        return;
    }

    # extract needed sub and selector
    my $ActionSub      = $ObjectAction{$ObjectType};
    my $ActionSelector = $ObjectSelector{$ObjectType};

    # handle 'all' or 'any' in a special way
    if ( $Param{Selector} =~ m{ ( all | any ) }smx ) {
        $ActionSub = $ObjectAction{ $ObjectType . 'All' };
        return $Self->$ActionSub(
            UserID => $Param{UserID},
        );
    }

    # get and return object
    return [
        $Self->$ActionSub(
            $ActionSelector => $Param{Selector},
            UserID          => $Param{UserID},
            )
    ];
}

=item _ObjectITSMChange()

Returns a change object.

    my $Change = $ConditionObject->_ObjectITSMChange();

=cut

sub _ObjectITSMChange {
    my ( $Self, %Param ) = @_;

    # get and return change data
    return $Self->{ChangeObject}->ChangeGet(%Param);
}

=item _ObjectITSMWorkOrder()

Returns a workorder object.

    my $WorkOrder = $ConditionObject->_ObjectITSMWorkOrder();

=cut

sub _ObjectITSMWorkOrder {
    my ( $Self, %Param ) = @_;

    # get and return workorder data
    return $Self->{WorkOrderObject}->WorkOrderGet(%Param);
}

=item _ObjectITSMWorkOrderAll()

Returns a workorder ids of a change.

    my $WorkOrderIDsRef = $ConditionObject->_ObjectITSMWorkOrderAll();

=cut

sub _ObjectITSMWorkOrderAll {
    my ( $Self, %Param ) = @_;

    # get and return workorder data
    my $WorkOrder = $Self->{WorkOrderObject}->WorkOrderGet(%Param);

    # check for workorder
    return if !$WorkOrder;

    # get all workorder ids of change
    my $WorkOrderIDs = $Self->{WorkOrderObject}->WorkOrderList(
        ChangeID => $WorkOrder->{ChangeID},
        UserID   => $Param{UserID},
    );

    # check for workorder ids
    return if !$WorkOrderIDs || ref $WorkOrderIDs ne 'ARRAY';

    # get workorder data
    my @WorkOrderData;
    WORKORDERID:
    for my $WorkOrderID ( @{$WorkOrderIDs} ) {
        $WorkOrder = $Self->{WorkOrderObject}->WorkOrderGet(
            WorkOrderID => $WorkOrderID,
            UserID      => $Param{UserID},
        );

        # check workorder
        next WORKORDERID if !$WorkOrder;

        # add workorder to return array
        push @WorkOrderData, $WorkOrder;
    }

    return \@WorkOrderData;
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

$Revision: 1.10 $ $Date: 2010-01-11 15:07:37 $

=cut
