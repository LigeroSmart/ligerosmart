# --
# Kernel/System/ITSMChange/WorkOrder.pm - all work order functions
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: WorkOrder.pm,v 1.36 2009-10-19 12:55:34 bes Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange::WorkOrder;

use strict;
use warnings;

use Kernel::System::Valid;
use Kernel::System::GeneralCatalog;
use Kernel::System::LinkObject;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.36 $) [1];

=head1 NAME

Kernel::System::ITSMChange::WorkOrder - work order lib

=head1 SYNOPSIS

All config item functions.

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
    use Kernel::System::User;
    use Kernel::System::ITSMChange::WorkOrder;

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
    my $UserObject = Kernel::System::User->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
        TimeObject   => $TimeObject,
        DBObject     => $DBObject,
        EncodeObject => $EncodeObject,
    );
    my $WorkOrderObject = Kernel::System::ITSMChange::WorkOrder->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        TimeObject   => $TimeObject,
        MainObject   => $MainObject,
        UserObject   => $UserObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (
        qw(DBObject ConfigObject EncodeObject LogObject MainObject TimeObject UserObject)
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    # set default debug flag
    $Self->{Debug} ||= 0;

    # create additional objects
    $Self->{ValidObject}          = Kernel::System::Valid->new( %{$Self} );
    $Self->{GeneralCatalogObject} = Kernel::System::GeneralCatalog->new( %{$Self} );
    $Self->{LinkObject}           = Kernel::System::LinkObject->new( %{$Self} );

    return $Self;
}

=item WorkOrderAdd()

add a new workorder

    my $WorkOrderID = $WorkOrderObject->WorkOrderAdd(
        ChangeID => 123,
        UserID   => 1,
    );

or

    my $WorkOrderID = $WorkOrderObject->WorkOrderAdd(
        ChangeID         => 123,
        WorkOrderNumber  => 5,                                         # (optional)
        Title            => 'Replacement of mail server',              # (optional)
        Instruction      => 'Install the the new server',              # (optional)
        Report           => 'Installed new server without problems',   # (optional)
        WorkOrderStateID => 4,                                         # (optional)
        WorkOrderAgentID => 8,                                         # (optional)
        PlannedStartTime => '2009-10-12 00:00:01',                     # (optional)
        PlannedEndTime   => '2009-10-15 15:00:00',                     # (optional)
        ActualStartTime  => '2009-10-14 00:00:01',                     # (optional)
        ActualEndTime    => '2009-01-20 00:00:01',                     # (optional)
        UserID           => 1,
    );

=cut

sub WorkOrderAdd {
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

    # check change parameters
    return if !$Self->_CheckWorkOrderParams(%Param);

    # get default WorkOrderStateID if not given
    my $ItemDataRef = $Self->{GeneralCatalogObject}->ItemGet(
        Class => 'ITSM::ChangeManagement::WorkOrder::State',
        Name  => 'accepted',
    );

    my $WorkOrderStateID = $Param{WorkOrderStateID} || $ItemDataRef->{ItemID};

    # get default workorder number if not given
    my $WorkOrderNumber = $Param{WorkOrderNumber} || $Self->_GetWorkOrderNumber(%Param);

    # add WorkOrder to database
    return if !$Self->{DBObject}->Do(
        SQL => 'INSERT INTO change_workorder '
            . '(change_id, workorder_number, workorder_state_id, create_time, '
            . 'create_by, change_time, change_by) '
            . 'VALUES (?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{ChangeID}, \$WorkOrderNumber, \$WorkOrderStateID,
            \$Param{UserID}, \$Param{UserID},
        ],
    );

    # get WorkOrder id
    return if !$Self->{DBObject}->Prepare(
        SQL   => 'SELECT id FROM change_workorder WHERE change_id = ? AND workorder_number = ?',
        Bind  => [ \$Param{ChangeID}, \$WorkOrderNumber ],
        Limit => 1,
    );

    my $WorkOrderID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $WorkOrderID = $Row[0];
    }

    return if !$WorkOrderID;

    # TODO: trigger WorkOrderAdd-Event

    # update WorkOrder with remaining parameters
    return if !$Self->WorkOrderUpdate(
        WorkOrderID => $WorkOrderID,
        %Param,
    );

    return $WorkOrderID;
}

=item WorkOrderUpdate()

update a WorkOrder

    my $Success = $WorkOrderObject->WorkOrderUpdate(
        WorkOrderID      => 4,
        ChangeID         => 123,                                       # (optional)
        WorkOrderNumber  => 5,                                         # (optional)
        Title            => 'Replacement of mail server',              # (optional)
        Instruction      => 'Install the the new server',              # (optional)
        Report           => 'Installed new server without problems',   # (optional)
        WorkOrderStateID => 4,                                         # (optional)
        WorkOrderAgentID => 8,                                         # (optional)
        PlannedStartTime => '2009-10-12 00:00:01',                     # (optional)
        PlannedEndTime   => '2009-10-15 15:00:00',                     # (optional)
        ActualStartTime  => '2009-10-14 00:00:01',                     # (optional)
        ActualEndTime    => '2009-01-20 00:00:01',                     # (optional)
        UserID           => 1,
    );

constraints:

xxxStartTime has to be before xxxEndTime. If just one of these parameters is passed
the other time is retrieved from database

=cut

sub WorkOrderUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(WorkOrderID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # check the given parameters
    return if !$Self->_CheckWorkOrderParams(%Param);

    # check if the timestamps are correct
    return if !$Self->_CheckTimestamps(%Param);

    # map update attributes to column names
    my %Attribute = (
        Title            => 'title',
        WorkOrderNumber  => 'workorder_number',
        Instruction      => 'instruction',
        Report           => 'report',
        ChangeID         => 'change_id',
        WorkOrderStateID => 'workorder_state_id',
        WorkOrderAgentID => 'workorder_agent_id',
        PlannedStartTime => 'planned_start_time',
        PlannedEndTime   => 'planned_end_time',
        ActualStartTime  => 'actual_start_time',
        ActualEndTime    => 'actual_end_time',
    );

    # build SQL to update change
    my $SQL = 'UPDATE change_workorder SET ';
    my @Bind;

    WORKORDERATTRIBUTE:
    for my $WorkOrderAttribute ( keys %Attribute ) {

        # do not use column if not in function parameters
        next WORKORDERATTRIBUTE if !exists $Param{$WorkOrderAttribute};

        $SQL .= "$Attribute{$WorkOrderAttribute} = ?, ";
        push @Bind, \$Param{$WorkOrderAttribute};
    }

    $SQL .= 'change_time = current_timestamp, change_by = ? ';
    $SQL .= 'WHERE id = ?';
    push @Bind, \$Param{UserID}, \$Param{WorkOrderID};

    # add change to database
    return if !$Self->{DBObject}->Do(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    # TODO: trigger WordOrderUpdate-Event

    return 1;
}

=item WorkOrderGet()

return a WorkOrder as hash reference

Return

    $WorkOrder{WorkOrderID}
    $WorkOrder{ChangeID}
    $WorkOrder{WorkOrderNumber}
    $WorkOrder{Title}
    $WorkOrder{Instruction}
    $WorkOrder{Report}
    $WorkOrder{WorkOrderStateID}
    $WorkOrder{WorkOrderAgentID}
    $WorkOrder{PlannedStartTime}
    $WorkOrder{PlannedEndTime}
    $WorkOrder{ActualStartTime}
    $WorkOrder{ActualEndTime}
    $WorkOrder{CreateTime}
    $WorkOrder{CreateBy}
    $WorkOrder{ChangeTime}
    $WorkOrder{ChangeBy}

    my $WorkOrderRef = $WorkOrderObject->WorkOrderGet(
        WorkOrderID => 123,
        UserID      => 1,
    );

=cut

sub WorkOrderGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Attribute (qw(WorkOrderID UserID)) {
        if ( !$Param{$Attribute} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Attribute!",
            );
            return;
        }
    }

    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id, change_id, workorder_number, title, instruction, '
            . 'report, workorder_state_id, workorder_agent_id, planned_start_time, '
            . 'planned_end_time, actual_start_time, actual_end_time, create_time, '
            . 'create_by, change_time, change_by '
            . 'FROM change_workorder '
            . 'WHERE id = ?',
        Bind  => [ \$Param{WorkOrderID} ],
        Limit => 1,
    );

    my %WorkOrderData;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $WorkOrderData{WorkOrderID}      = $Row[0];
        $WorkOrderData{ChangeID}         = $Row[1];
        $WorkOrderData{WorkOrderNumber}  = $Row[2];
        $WorkOrderData{Title}            = defined $Row[3] ? $Row[3] : '';
        $WorkOrderData{Instruction}      = defined $Row[4] ? $Row[4] : '';
        $WorkOrderData{Report}           = defined $Row[5] ? $Row[5] : '';
        $WorkOrderData{WorkOrderStateID} = $Row[6];
        $WorkOrderData{WorkOrderAgentID} = $Row[7];
        $WorkOrderData{PlannedStartTime} = $Row[8];
        $WorkOrderData{PlannedEndTime}   = $Row[9];
        $WorkOrderData{ActualStartTime}  = $Row[10];
        $WorkOrderData{ActualEndTime}    = $Row[11];
        $WorkOrderData{CreateTime}       = $Row[12];
        $WorkOrderData{CreateBy}         = $Row[13];
        $WorkOrderData{ChangeTime}       = $Row[14];
        $WorkOrderData{ChangeBy}         = $Row[15];
    }

    if ( !%WorkOrderData ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "WorkOrder with ID $Param{WorkOrderID} does not exist.",
        );
        return;
    }

    return \%WorkOrderData;
}

=item WorkOrderList()

return a list of all workorder ids of a given change id as array reference

    my $WorkOrderIDsRef = $WorkOrderObject->WorkOrderList(
        ChangeID = 5,
        UserID   => 1,
    );

=cut

sub WorkOrderList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Attribute (qw(ChangeID UserID)) {
        if ( !$Param{$Attribute} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Attribute!",
            );
            return;
        }
    }

    # get workorder ids
    return if !$Self->{DBObject}->Prepare(
        SQL  => 'SELECT id FROM change_workorder WHERE change_id = ?',
        Bind => [ \$Param{ChangeID} ],
    );

    my @WorkOrderIDs;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @WorkOrderIDs, $Row[0];
    }

    return \@WorkOrderIDs;
}

=item WorkOrderSearch()

return a list of workorder ids as an array reference

    my $WorkOrderIDsRef = $WorkOrderObject->WorkOrderSearch(
        ChangeID          => 123,                                      # (optional)
        WorkOrderNumber   => 12,                                       # (optional)
        Title             => 'Replacement of mail server',             # (optional)
        Instruction       => 'Install the the new server',             # (optional)
        Report            => 'Installed new server without problems',  # (optional)
        WorkOrderStateIDs => [ 11, 12, 13 ],                           # (optional)
        WorkOrderAgentIDs => [ 1, 2, 3 ],                              # (optional)
        CreateBy          => [ 5, 2, 3 ],                              # (optional)
        ChangeBy          => [ 3, 2, 1 ],                              # (optional)

        # changes with planned start time after ...
        PlannedStartTimeNewerDate => '2006-01-09 00:00:01',            # (optional)
        # changes with planned start time before then ....
        PlannedStartTimeOlderDate => '2006-01-19 23:59:59',            # (optional)

        # changes with planned end time after ...
        PlannedEndTimeNewerDate => '2006-01-09 00:00:01',              # (optional)
        # changes with planned end time before then ....
        PlannedEndTimeOlderDate => '2006-01-19 23:59:59',              # (optional)

        # changes with actual start time after ...
        ActualStartTimeNewerDate => '2006-01-09 00:00:01',             # (optional)
        # changes with actual start time before then ....
        ActualStartTimeOlderDate => '2006-01-19 23:59:59',             # (optional)

        # changes with actual end time after ...
        ActualEndTimeNewerDate => '2006-01-09 00:00:01',               # (optional)
        # changes with actual end time before then ....
        ActualEndTimeOlderDate => '2006-01-19 23:59:59',               # (optional)

        # changes with created time after ...
        CreateTimeNewerDate => '2006-01-09 00:00:01',                  # (optional)
        # changes with created time before then ....
        CreateTimeOlderDate => '2006-01-19 23:59:59',                  # (optional)

        # changes with changed time after ...
        ChangeTimeNewerDate => '2006-01-09 00:00:01',                  # (optional)
        # changes with changed time before then ....
        ChangeTimeOlderDate => '2006-01-19 23:59:59',                  # (optional)

        OrderBy => [ 'ChangeID', 'WorkOrderNumber' ],                  # (optional)
        # default: [ 'WorkOrderID' ],
        # (WorkOrderID, ChangeID, WorkOrderNumber,
        # WorkOrderStateID, WorkOrderAgentID,
        # PlannedStartTime, PlannedEndTime,
        # ActualStartTime, ActualEndTime,
        # CreateTime, CreateBy, ChangeTime, ChangeBy)

        # Additional information for OrderBy:
        # The OrderByDirection could specified for each OrderBy attribute.
        # The pairing is made by the array idices.

        OrderByDirection => [ 'Down', 'Up' ],                          # (optional)
        # default: [ 'Down' ],
        # (Down | Up)

        UsingWildcards => 0,                                           # (optional)
        # default 1

        Limit => 100,                                                  # (optional)

        UserID => 1,
    );

=cut

sub WorkOrderSearch {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );
        return;
    }

    # check parameters, OrderBy and OrderByDirection are array references
    ARGUMENT:
    for my $Argument (qw(OrderBy OrderByDirection)) {
        if ( !defined $Param{$Argument} ) {
            $Param{$Argument} ||= [];
        }
        else {
            if ( ref $Param{$Argument} ne 'ARRAY' ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "$Argument must be an array reference!",
                );
                return;
            }
        }
    }

    # define order table
    my %OrderByTable = (
        ChangeID         => q{wo.change_id},
        WorkOrderID      => q{wo.id},
        WorkOrderNumber  => q{COALESCE( wo.workorder_number, 0 )},
        WorkOrderStateID => q{COALESCE( wo.workorder_state_, 0 )},
        WorkOrderAgentID => q{COALESCE( wo.workorder_agent_, 0 )},
        PlannedStartTime => q{COALESCE( planned_start_time, DATE '0001-01-01' )},
        PlannedEndTime   => q{COALESCE( planned_end_time, DATE '9999-01-01' )},
        ActualStartTime  => q{COALESCE( actual_start_time, DATE '0001-01-01' )},
        ActualEndTime    => q{COALESCE( actual_end_time, DATE '9999-01-01' )},
        CreateTime       => q{wo.create_time},
        CreateBy         => q{wo.create_by},
        ChangeTime       => q{wo.change_time},
        ChangeBy         => q{wo.change_by},
    );

    # check if OrderBy contains only unique valid values
    if ( @{ $Param{OrderBy} } ) {
        my %OrderBySeen;
        ORDERBY:
        for my $OrderBy ( @{ $Param{OrderBy} } ) {

            if ( !$OrderBy || !$OrderByTable{$OrderBy} || $OrderBySeen{$OrderBy} ) {

                # found an error
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "OrderByDirection contains invalid value '$OrderBy' "
                        . " or the value is used more than once!",
                );
                return;
            }

            # remember the value to check if it appears more than once
            $OrderBySeen{$OrderBy} = 1;
        }
    }

    # check if OrderByDirection array contains only 'Up' or 'Down'
    if ( @{ $Param{OrderByDirection} } ) {
        DIRECTION:
        for my $Direction ( @{ $Param{OrderByDirection} } ) {

            # only 'Up' or 'Down' allowed
            next DIRECTION if $Direction eq 'Up';
            next DIRECTION if $Direction eq 'Down';

            # found an error
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "OrderByDirection can only contain 'Up' or 'Down'!",
            );
            return;
        }
    }

    # set default values
    if ( !defined $Param{UsingWildcards} ) {
        $Param{UsingWildcards} = 1;
    }

    my @SQLWhere;    # assemble the conditions used in the WHERE clause

    # set string params
    my %StringParams = (
        WorkOrderNumber => 'wo.workorder_number',
        Title           => 'wo.title',
        Instruction     => 'wo.instruction',
        Report          => 'wo.report',
    );

    # add string params to sql-where-array
    STRINGPARAM:
    for my $StringParam ( keys %StringParams ) {

        # check string params for useful values, the string q{0} is allowed
        next STRINGPARAM if !exists $Param{$StringParam};
        next STRINGPARAM if !defined $Param{$StringParam};
        next STRINGPARAM if $Param{$StringParam} eq '';

        # quote
        $Param{$StringParam} = $Self->{DBObject}->Quote( $Param{$StringParam} );

        # wildcards are used
        if ( $Param{UsingWildcards} ) {

            # Quote
            $Param{$StringParam} = $Self->{DBObject}->Quote( $Param{$StringParam}, 'Like' );

            # replace * with %
            $Param{$StringParam} =~ s{ \*+ }{%}xmsg;

            # do not use string params which contain only %
            next STRINGPARAM if $Param{$StringParam} =~ m{ \A %* \z }xms;

            push @SQLWhere,
                "LOWER($StringParams{$StringParam}) LIKE LOWER('$Param{$StringParam}')";
        }

        # no wildcards are used
        else {
            push @SQLWhere,
                "LOWER($StringParams{$StringParam}) = LOWER('$Param{$StringParam}')";
        }
    }

    # set array params
    my %ArrayParams = (
        ChangeIDs         => 'wo.change_id',
        WorkOrderStateIDs => 'wo.workorder_state_id',
        WorkOrderAgentIDs => 'wo.workorder_agent_id',
        CreateBy          => 'wo.create_by',
        ChangeBy          => 'wo.change_by',
    );

    # add array params to sql-where-array
    ARRAYPARAM:
    for my $ArrayParam ( keys %ArrayParams ) {

        next ARRAYPARAM if !$Param{$ArrayParam};

        if ( ref $Param{$ArrayParam} ne 'ARRAY' ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "$ArrayParam must be an array reference!",
            );
            return;
        }

        next ARRAYPARAM if !@{ $Param{$ArrayParam} };

        # quote
        for my $OneParam ( @{ $Param{$ArrayParam} } ) {
            $OneParam = $Self->{DBObject}->Quote($OneParam);
        }

        # create string
        my $InString = join q{, }, @{ $Param{$ArrayParam} };

        next ARRAYPARAM if !$InString;

        push @SQLWhere, "$ArrayParams{$ArrayParam} IN ($InString)";
    }

    # set time params
    my %TimeParams = (
        CreateTimeNewerDate => 'wo.create_time >=',
        CreateTimeOlderDate => 'wo.create_time <=',
        ChangeTimeNewerDate => 'wo.change_time >=',
        ChangeTimeOlderDate => 'wo.change_time <=',
    );

    # add change time params to sql-where-array
    TIMEPARAM:
    for my $TimeParam ( keys %TimeParams ) {

        next TIMEPARAM if !$Param{$TimeParam};

        if ( $Param{$TimeParam} !~ m{ \A \d\d\d\d-\d\d-\d\d \s \d\d:\d\d:\d\d \z }xms ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Invalid date format found!',
            );
            return;
        }

        # quote
        $Param{$TimeParam} = $Self->{DBObject}->Quote( $Param{$TimeParam} );

        push @SQLWhere, "$TimeParams{$TimeParam} '$Param{$TimeParam}'";
    }

    # set time params in workorder table
    my %WorkOrderTimeParams = (
        PlannedStartTimeNewerDate => 'min(wo.planned_start_time) >=',
        PlannedStartTimeOlderDate => 'min(wo.planned_start_time) <=',
        PlannedEndTimeNewerDate   => 'max(wo.planned_end_time) >=',
        PlannedEndTimeOlderDate   => 'max(wo.planned_end_time) <=',
        ActualStartTimeNewerDate  => 'min(wo.actual_start_time) >=',
        ActualStartTimeOlderDate  => 'min(wo.actual_start_time) <=',
        ActualEndTimeNewerDate    => 'max(wo.actual_end_time) >=',
        ActualEndTimeOlderDate    => 'max(wo.actual_end_time) <=',
    );

    # add work order time params to sql-having-array
    TIMEPARAM:
    for my $TimeParam ( keys %WorkOrderTimeParams ) {

        next TIMEPARAM if !$Param{$TimeParam};

        if ( $Param{$TimeParam} !~ m{ \A \d\d\d\d-\d\d-\d\d \s \d\d:\d\d:\d\d \z }xms ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Invalid date format found!',
            );
            return;
        }

        # quote
        $Param{$TimeParam} = $Self->{DBObject}->Quote( $Param{$TimeParam} );

        push @SQLWhere, "$WorkOrderTimeParams{$TimeParam} '$Param{$TimeParam}'";
    }

    # assemble the ORDER BY clause
    my @SQLOrderBy;
    my $Count = 0;
    ORDERBY:
    for my $OrderBy ( @{ $Param{OrderBy} } ) {

        # set the default order direction
        my $Direction = 'DESC';

        # add the given order direction
        if ( $Param{OrderByDirection}->[$Count] ) {
            if ( $Param{OrderByDirection}->[$Count] eq 'Up' ) {
                $Direction = 'ASC';
            }
            elsif ( $Param{OrderByDirection}->[$Count] eq 'Down' ) {
                $Direction = 'DESC';
            }
        }

        # add SQL
        push @SQLOrderBy, "$OrderByTable{$OrderBy} $Direction";
    }
    continue {
        $Count++;
    }

    # we need at least one sort criterion
    if ( !@SQLOrderBy ) {
        push @SQLOrderBy, "$OrderByTable{WorkOrderID} DESC";
    }

    # assemble the SQL query
    my $SQL = 'SELECT wo.id FROM change_workorder wo ';

    # add the WHERE clause
    if (@SQLWhere) {
        $SQL .= 'WHERE ';
        $SQL .= join ' AND ', map {"( $_ )"} @SQLWhere;
        $SQL .= ' ';
    }

    # add the ORDER BY clause
    if (@SQLOrderBy) {
        $SQL .= 'ORDER BY ';
        $SQL .= join q{, }, @SQLOrderBy;
    }

    # ask database
    return if !$Self->{DBObject}->Prepare(
        SQL   => $SQL,
        Limit => $Param{Limit},
    );

    # fetch the result
    my @WorkOrderIDList;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @WorkOrderIDList, $Row[0];
    }

    return \@WorkOrderIDList;
}

=item WorkOrderDelete()

delete a workorder

NOTE: This function must first remove all links to this WorkOrderObject,

    my $Success = $WorkOrderObject->WorkOrderDelete(
        WorkOrderID => 123,
        UserID      => 1,
    );

=cut

sub WorkOrderDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Attribute (qw(WorkOrderID UserID)) {
        if ( !$Param{$Attribute} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Attribute!",
            );
            return;
        }
    }

    # TODO: Delete all links

    # TODO: trigger WorkOrder delete event

    # delete the workorder
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM change_workorder WHERE id = ? ',
        Bind => [ \$Param{WorkOrderID} ],
    );

    return 1;
}

=item WorkOrderChangeTimeGet()

Returns a list of PlannedStartTime | PlannedEndTime | ActualStartTime | ActualEndTime
of a change, which would be the respective time of the earliest starting
workorder (for start times) or the latest ending workorder (for end times).

For PlannedStartTime | PlannedEndTime | ActualEndTime Undefined is returned
if any of the workorders of a change has the wanted time not defined.

The ActualStartTime is defined when any of the workorders of a change has
a defined ActualStartTime.

Return

    $Time{PlannedStartTime}
    $Time{PlannedEndTime}
    $Time{ActualStartTime}
    $Time{ActualEndTime}

    my $TimeRef = $WorkOrderObject->WorkOrderChangeTimeGet(
        ChangeID => 123,

        Types    => [ 'PlannedStartTime', 'PlannedEndTime' ],
        # (PlannedStartTime | PlannedEndTime
        # | ActualStartTime | ActualEndTime )

        UserID   => 1,

        # ---------------------------------------------------- #

        # TODO: (decide this later!)
        Maybe add this new attribute:

        # These are WorkOrderTypes (Types, not States!)
        # which would be excluded from the calculation
        # of the change start time.

        ExcludeWorkOrderTypes => [ 'approval', 'pir' ], # (optional)

        # ---------------------------------------------------- #
    );

=cut

sub WorkOrderChangeTimeGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Attribute (qw(ChangeID Types UserID)) {
        if ( !$Param{$Attribute} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Attribute!",
            );
            return;
        }
    }

    # check params
    for my $Argument (qw(Types)) {
        if ( !defined $Param{$Argument} ) {
            $Param{$Argument} = [];
        }
        else {
            if ( ref $Param{$Argument} ne 'ARRAY' ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "$Argument must be an array reference!",
                );
                return;
            }
        }
    }

    # define expected TimeTypes
    my %TimeReturn = (
        'PlannedStartTime' => undef,
        'PlannedEndTime'   => undef,
        'ActualStartTime'  => undef,
        'ActualEndTime'    => undef,
    );

    # mapping for time types -> column
    # COALESCE returns the first non-NULL value.
    # It should be available for DB2, MS SQL Server, MySQL, Oracle and Postgres.
    # Ingres seems to have COALESCE only since r3.
    # http://www.orafaq.com/forum/mv/msg/149054/418609/0/#msg_418609
    my %TypeColumnMap = (
        PlannedStartTime => q{MIN( COALESCE( planned_start_time, DATE '0001-01-01' ) )},
        PlannedEndTime   => q{MAX( COALESCE( planned_end_time, DATE '9999-01-01' ) )},
        ActualStartTime  => q{MIN( actual_start_time )},
        ActualEndTime    => q{MAX( COALESCE( actual_end_time, DATE '9999-01-01' ) )},
    );

    # error if unknown time type is given
    for my $ArgumentType ( @{ $Param{Types} } ) {
        if ( !$TypeColumnMap{$ArgumentType} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Unknown type '$ArgumentType'! "
                    . "Allowed types are 'PlannedStartTime', 'PlannedEndTime', "
                    . "'ActualStartTime', 'ActualEndTime'!",
            );
            return;
        }
    }

    # build columns, the order of the array is important!
    my @SelectColumns;
    SELECTCOLUM:
    for my $SelectColumn ( @{ $Param{Types} } ) {
        next SELECTCOLUM if !$SelectColumn;

        push @SelectColumns, $TypeColumnMap{$SelectColumn};
    }

    if ( !@SelectColumns ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'No Type selected!',
        );
        return;
    }

    # set column from given time type
    # my $Column = $TypeColumnMap{ $Param{Type} };

    # check if there is a work order with an undefined time of the requested type
    # return if !$Self->{DBObject}->Prepare(
    #     SQL => 'SELECT COUNT(*) '
    #         . 'FROM change_workorder '
    #         . 'WHERE change_id = ? '
    #         . "AND $Column IS NULL",
    #     Bind  => [ \$Param{ChangeID} ],
    #     Limit => 1,
    # );

    #my $UndefinedTime;
    #while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
    #    $UndefinedTime = $Row[0];
    #}

    # there is a workorder with an undefined time of the requested type
    #return if $UndefinedTime;

    # build sql, using min or max functions
    my $SQL = 'SELECT ';

    # add colums
    if (@SelectColumns) {
        $SQL .= join q{, }, @SelectColumns;
    }

    # add from and where clause
    $SQL .= ' FROM change_workorder WHERE change_id = ?';

    # retrieve the requested time
    return if !$Self->{DBObject}->Prepare(
        SQL   => $SQL,
        Bind  => [ \$Param{ChangeID} ],
        Limit => 1,
    );

    # reverse select lookup hash for return values
    my %ColumnType = reverse %TypeColumnMap;

    # extract time values
    my @Times;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        for my $SelectIndex ( 0 .. $#SelectColumns ) {
            my $Time = $Row[$SelectIndex];

            if (
                !$Time    # no workorders
                || $Time =~ m{ \A 0001-01-01 }xms    # default time used in min()
                || $Time =~ m{ \A 9999-01-01 }xms    # default time used in max()
                )
            {
                $TimeReturn{ $ColumnType{ $SelectColumns[$SelectIndex] } } = undef;
            }
            else {
                $TimeReturn{ $ColumnType{ $SelectColumns[$SelectIndex] } } = $Time;
            }
        }
    }    # end while FetchrowArray

    return \%TimeReturn;
}

=item _CheckWorkOrderStateID()

check if a given work order state id is valid

    my $Ok = $WorkOrderObject->_CheckWorkOrderStateID(
        WorkOrderStateID => 25,
    );

=cut

sub _CheckWorkOrderStateID {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{WorkOrderStateID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need WorkOrderStateID!',
        );
        return;
    }

    # get work order state list
    my $WorkOrderStateList = $Self->{GeneralCatalogObject}->ItemList(
        Class => 'ITSM::ChangeManagement::WorkOrder::State',
    );

    if (
        !$WorkOrderStateList
        || ref $WorkOrderStateList ne 'HASH'
        || !$WorkOrderStateList->{ $Param{WorkOrderStateID} }
        )
    {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "No valid work order state id given!",
        );
        return;
    }

    return 1;
}

=item _CheckWorkOrderTypeID()

check if a given work order type id is valid

    my $Ok = $WorkOrderObject->_CheckWorkOrderTypeID(
        WorkOrderTypeID => 2,
    );

=cut

sub _CheckWorkOrderTypeID {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{WorkOrderTypeID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need WorkOrderTypeID!',
        );
        return;
    }

    # get work order type list
    my $WorkOrderTypeList = $Self->{GeneralCatalogObject}->ItemList(
        Class => 'ITSM::ChangeManagement::WorkOrder::Type',
    );

    if (
        !$WorkOrderTypeList
        || ref $WorkOrderTypeList ne 'HASH'
        || !$WorkOrderTypeList->{ $Param{WorkOrderTypeID} }
        )
    {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "No valid work order type id given!",
        );
        return;
    }

    return 1;
}

=item _GetWorkOrderNumber()

Get a new unused workorder number for a given ChangeID.
The highest current workorder number for a given change is
looked up and increased by one.

    my $WorkOrderNumber = $WorkOrderObject->_GetWorkOrderNumber(
        ChangeID => 2,
    );

=cut

sub _GetWorkOrderNumber {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ChangeID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need ChangeID!',
        );
        return;
    }

    # get max workorder number
    return if !$Self->{DBObject}->Prepare(
        SQL   => 'SELECT MAX(workorder_number) FROM change_workorder WHERE change_id = ?',
        Bind  => [ \$Param{ChangeID} ],
        Limit => 1,
    );

    my $WorkOrderNumber;
    while ( my @Row = $Self->{DBObject}->FetchrowArray ) {
        $WorkOrderNumber = $Row[0];
    }

    # increment number to get a non-existent work order number
    $WorkOrderNumber++;

    return $WorkOrderNumber;
}

=item _CheckWorkOrderParams()

Checks if the various parameters are valid.

    my $Ok = $WorkOrderObject->_CheckWorkOrderParams(
        ChangeID         => 123,                                       # (optional)
        WorkOrderNumber  => 5,                                         # (optional)
        Title            => 'Replacement of mail server',              # (optional)
        Instruction      => 'Install the the new server',              # (optional)
        Report           => 'Installed new server without problems',   # (optional)
        WorkOrderStateID => 4,                                         # (optional)
        WorkOrderAgentID => 8,                                         # (optional)
        PlannedStartTime => '2009-10-01 10:33:00',                     # (optional)
        ActualStartTime  => '2009-10-01 10:33:00',                     # (optional)
        PlannedEndTime   => '2009-10-01 10:33:00',                     # (optional)
        ActualEndTime    => '2009-10-01 10:33:00',                     # (optional)
    );

These string parameters have length constraints:

    Parameter      | max. length
    ---------------+-----------------
    Title          |  250 characters
    Instruction    | 3800 characters
    Report         | 3800 characters

=cut

sub _CheckWorkOrderParams {
    my ( $Self, %Param ) = @_;

    # check the string and id parameters
    ARGUMENT:
    for my $Argument (
        qw(Title Instruction Report WorkOrderAgentID WorkOrderStateID WorkOrderNumber ChangeID)
        )
    {

        # params are not required
        next ARGUMENT if !exists $Param{$Argument};

        # check if param is not defined
        if ( !defined $Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "The parameter '$Argument' must be defined!",
            );
            return;
        }

        # check if param is not a reference
        if ( ref $Param{$Argument} ne '' ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "The parameter '$Argument' mustn't be a reference!",
            );
            return;
        }

        # check the maximum length of title
        if ( $Argument eq 'Title' && length( $Param{$Argument} ) > 250 ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "The parameter '$Argument' must be shorter than 250 characters!",
            );
            return;
        }

        # check the maximum length of description and justification
        if ( $Argument eq 'Instruction' || $Argument eq 'Report' ) {
            if ( length( $Param{$Argument} ) > 3800 ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "The parameter '$Argument' must be shorter than 3800 characters!",
                );
                return;
            }
        }
    }

    # check time formats
    OPTION:
    for my $Option (qw(PlannedStartTime PlannedEndTime ActualStartTime ActualEndTime)) {
        next OPTION if !$Param{$Option};

        return if $Param{$Option} !~ m{ \A \d\d\d\d-\d\d-\d\d \s \d\d:\d\d:\d\d \z }xms;
    }

    # check workorder agent
    if ( exists $Param{WorkOrderAgentID} && defined $Param{WorkOrderAgentID} ) {

        # WorkOrderAgent must be an agent
        my %UserData = $Self->{UserObject}->GetUserData(
            UserID => $Param{WorkOrderAgentID},
            Valid  => 1,
        );

        if ( !$UserData{UserID} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "The WorkOrderAgentID $Param{WorkOrderAgentID} is not a valid user id!",
            );
            return;
        }
    }

    # check if given ChangeStateID is valid
    if ( exists $Param{WorkOrderStateID} ) {
        return if !$Self->_CheckWorkOrderStateID(
            WorkOrderStateID => $Param{WorkOrderStateID},
        );
    }

    return 1;
}

=item _CheckTimestamps()

Checks the constraints of timestamps: xxxStartTime must be before xxxEndTime

    my $Ok = $WorkOrderObject->_CheckTimestamps(
        WorkOrderID      => 123,
        PlannedStartTime => '2009-10-12 00:00:01',                     # (optional)
        PlannedEndTime   => '2009-10-15 15:00:00',                     # (optional)
        ActualStartTime  => '2009-10-14 00:00:01',                     # (optional)
        ActualEndTime    => '2009-01-20 00:00:01',                     # (optional)
        UserID           => 1,
    );

If PlannedStartTime is given, PlannedEndTime has to be given, too - and vice versa.
If ActualStartTime, ActualEndTime is optional.

=cut

sub _CheckTimestamps {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(WorkOrderID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get workorder data
    my $WorkOrderData = $Self->WorkOrderGet(
        WorkOrderID => $Param{WorkOrderID},
        UserID      => $Param{UserID},
    );

    # check times
    TYPE:
    for my $Type (qw(Actual Planned)) {
        next TYPE if !( $Param{ $Type . 'StartTime' } || $Param{ $Type . 'EndTime' } );

        my $StartTime = $Param{ $Type . 'StartTime' } || $WorkOrderData->{ $Type . 'StartTime' };
        my $EndTime   = $Param{ $Type . 'EndTime' }   || $WorkOrderData->{ $Type . 'EndTime' };

        next TYPE if $Type eq 'Actual' && $StartTime && !$EndTime;

        return if !( $StartTime && $EndTime );

        $StartTime =~ s{ \D }{}xmsg;
        $EndTime   =~ s{ \D }{}xmsg;

        return if $StartTime > $EndTime;
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

$Revision: 1.36 $ $Date: 2009-10-19 12:55:34 $

=cut
