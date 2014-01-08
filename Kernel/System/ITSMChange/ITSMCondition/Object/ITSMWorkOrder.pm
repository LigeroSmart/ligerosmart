# --
# Kernel/System/ITSMChange/ITSMCondition/Object/ITSMWorkOrder.pm - all itsm workorder object functions
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange::ITSMCondition::Object::ITSMWorkOrder;

use strict;
use warnings;

use Kernel::System::ITSMChange::ITSMWorkOrder;
use Kernel::System::ITSMChange::ITSMCondition;

=head1 NAME

Kernel::System::ITSMChange::ITSMCondition::Object::ITSMWorkOrder - condition itsm workorder object lib

=head1 SYNOPSIS

All ITSMWorkOrder object functions for conditions in ITSMChangeManagement.

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
    use Kernel::System::ITSMChange::ITSMCondition::Object::ITSMWorkOrder;

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
    my $ConditionObjectITSMWorkOrder = Kernel::System::ITSMChange::ITSMCondition::Object::ITSMWorkOrder->new(
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
        qw(DBObject ConfigObject EncodeObject LogObject UserObject GroupObject MainObject TimeObject)
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    # create additional objects
    $Self->{WorkOrderObject} = Kernel::System::ITSMChange::ITSMWorkOrder->new( %{$Self} );
    $Self->{ConditionObject} = Kernel::System::ITSMChange::ITSMCondition->new( %{$Self} );

    return $Self;
}

=item DataGet()

Returns workorder data in an array reference.

    my $WorkOrderDataRef = $ConditionObjectITSMWorkOrder->DataGet(
        Selector => 1234,
        UserID   => 2345,
    );

=cut

sub DataGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Selector UserID)) {
        if ( !exists $Param{$Argument} || !defined $Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # handle 'any' or 'all' in a special case
    return $Self->_DataGetAll(%Param) if $Param{Selector} eq 'any';
    return $Self->_DataGetAll(%Param) if $Param{Selector} eq 'all';

    # remap params
    my %WorkOrderGet = (
        WorkOrderID => $Param{Selector},
        UserID      => $Param{UserID},
    );

    # get workorder as anon hash ref
    my $WorkOrder = $Self->{WorkOrderObject}->WorkOrderGet(%WorkOrderGet);

    # check for workorder
    return if !$WorkOrder;

    # build array ref
    my $WorkOrderData = [$WorkOrder];

    return $WorkOrderData;
}

=item CompareValueList()

Returns a list of available CompareValues for the given attribute id of a workorder object as hash reference.

    my $CompareValueList = $ConditionObjectITSMWorkOrder->CompareValueList(
        AttributeName => 'WorkOrderStateID',
        UserID        => 1,
    );

Returns a hash reference like this, for the workorder attribute 'WorkOrderStateID':

    $CompareValueList = {
        10    => 'created',
        12    => 'accepted',
        13    => 'ready',
        14    => 'in progress',
        15    => 'closed',
        16    => 'canceled',
    }

=cut

sub CompareValueList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(AttributeName UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # to store the list
    my $CompareValueList = {};

    # WorkOrderStateID
    if ( $Param{AttributeName} eq 'WorkOrderStateID' ) {

        # get workorder state list
        $CompareValueList = $Self->{WorkOrderObject}->WorkOrderPossibleStatesGet(
            UserID => $Param{UserID},
        );
    }

    # WorkOrderTypeID
    elsif ( $Param{AttributeName} eq 'WorkOrderTypeID' ) {

        # get workorder type list
        $CompareValueList = $Self->{WorkOrderObject}->WorkOrderTypeList(
            UserID => $Param{UserID},
        );
    }
    elsif ( $Param{AttributeName} eq 'WorkOrderAgentID' ) {

        # get a complete list of users
        my %Users = $Self->{UserObject}->UserList(
            Type  => 'Long',
            Valid => 1,
        );

        $CompareValueList = \%Users;
    }

    return $CompareValueList;
}

=item SelectorList()

Returns a list of all selectors available for the given workorder object id and condition id as hash reference

    my $SelectorList = $ConditionObjectITSMWorkOrder->SelectorList(
        ObjectID    => 1234,
        ConditionID => 5,
        UserID      => 1,
    );

Returns a hash reference like this:

    $SelectorList = {
        10    => '1 - WorkorderTitle of Workorder 1',
        12    => '2 - WorkorderTitle of Workorder 2',
        34    => '3 - WorkorderTitle of Workorder 3',
        'any' => 'any',
        'all' => 'all',
    }

=cut

sub SelectorList {
    my ( $Self, %Param ) = @_;

    # get all workorder ids of change
    my $WorkOrderIDs = $Self->{WorkOrderObject}->WorkOrderList(
        ChangeID => $Param{ChangeID},
        UserID   => $Param{UserID},
    );

    # check for workorder ids
    return if !$WorkOrderIDs;
    return if ref $WorkOrderIDs ne 'ARRAY';

    # build selector list
    my %SelectorList;
    for my $WorkOrderID ( @{$WorkOrderIDs} ) {

        # get workorder data
        my $WorkOrderData = $Self->{WorkOrderObject}->WorkOrderGet(
            WorkOrderID => $WorkOrderID,
            UserID      => $Param{UserID},
        );

        $SelectorList{ $WorkOrderData->{WorkOrderID} }
            = $WorkOrderData->{WorkOrderNumber} . ' - ' . $WorkOrderData->{WorkOrderTitle};
    }

    # add 'all' selector (for expressions and actions)
    $SelectorList{'all'} = 'all';

    # add 'any' selector only for expressions
    if ( $Param{ExpressionID} ) {
        $SelectorList{'any'} = 'any';
    }

    return \%SelectorList;
}

=begin Internal:

=item _DataGetAll()

    my $WorkOrderDataArrayRef = $ConditionObjectITSMWorkOrder->_DataGetAll(
        ConditionID => 123,
        UserID      => 1,
    );

=cut

sub _DataGetAll {
    my ( $Self, %Param ) = @_;

    # get condition
    my $ConditionData = $Self->{ConditionObject}->ConditionGet(
        ConditionID => $Param{ConditionID},
        UserID      => $Param{UserID},
    );

    # check for condition
    return if !$ConditionData;

    # get all workorder ids of change
    my $WorkOrderIDs = $Self->{WorkOrderObject}->WorkOrderList(
        ChangeID => $ConditionData->{ChangeID},
        UserID   => $Param{UserID},
    );

    # check for workorder ids
    return if !$WorkOrderIDs;
    return if ref $WorkOrderIDs ne 'ARRAY';
    return if !@{$WorkOrderIDs};

    # get workorder data
    my @WorkOrderData;
    WORKORDERID:
    for my $WorkOrderID ( @{$WorkOrderIDs} ) {
        my $WorkOrder = $Self->{WorkOrderObject}->WorkOrderGet(
            WorkOrderID => $WorkOrderID,
            UserID      => $Param{UserID},
        );

        # check workorder
        next WORKORDERID if !$WorkOrder;

        # add workorder to return array
        push @WorkOrderData, $WorkOrder;
    }

    # return workorder data
    return \@WorkOrderData;
}

1;

=end Internal:

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
