# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::LigeroAPI;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Group',
    'Kernel::System::Lock',
    'Kernel::System::Log',
    'Kernel::System::State',
    'Kernel::System::DateTime',
);

sub new {
    my ($Type) = @_;

    my $Self = {};
    return bless( $Self, $Type );
}

sub TicketAcceleratorIndex {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(UserID QueueID ShownQueueIDs)) {
        if ( !exists( $Param{$_} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # db quote
    for (qw(UserID)) {
        $Param{$_} = $DBObject->Quote( $Param{$_}, 'Integer' );
    }

    # get user groups
    my $Type             = 'rw';
    my $AgentTicketQueue = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Frontend::AgentTicketQueue');
    if (
        $AgentTicketQueue
        && ref $AgentTicketQueue eq 'HASH'
        && $AgentTicketQueue->{ViewAllPossibleTickets}
        )
    {
        $Type = 'ro';
    }

    my %GroupList = $Kernel::OM->Get('Kernel::System::Group')->PermissionUserGet(
        UserID => $Param{UserID},
        Type   => $Type,
    );

    my @GroupIDs = sort keys %GroupList;

    my @QueueIDs = @{ $Param{ShownQueueIDs} };
    my %Queues;
    $Queues{MaxAge}       = 0;
    $Queues{TicketsShown} = 0;
    $Queues{TicketsAvail} = 0;

    # prepare "All tickets: ??" in Queue
    my @ViewableLockIDs = $Kernel::OM->Get('Kernel::System::Lock')->LockViewableLock(
        Type => 'ID',
    );

    my %ViewableLockIDs = ( map { $_ => 1 } @ViewableLockIDs );

    my @ViewableStateIDs = $Kernel::OM->Get('Kernel::System::State')->StateGetStatesByType(
        Type   => 'Viewable',
        Result => 'ID',
    );

    if (@QueueIDs) {

        my $SQL = "
            SELECT count(*)
            FROM ticket st
            INNER JOIN ticket_state tst ON st.ticket_state_id = tst.id
            WHERE st.ticket_state_id IN ( ${\(join ', ', @ViewableStateIDs)} )
                AND st.archive_flag = 0
                AND st.queue_id IN (";

        for ( 0 .. $#QueueIDs ) {

            if ( $_ > 0 ) {
                $SQL .= ",";
            }

            $SQL .= $DBObject->Quote( $QueueIDs[$_], 'Integer' );
        }
        $SQL .= " )";

        if($Param{JustOpenOrdened}){
            $SQL .= " AND tst.type_id IN (1,2,4,5) ORDER BY count(*) desc ";
        }

        $DBObject->Prepare( SQL => $SQL );

        while ( my @Row = $DBObject->FetchrowArray() ) {
            $Queues{AllTickets} = $Row[0];
        }
    }

    

    # check if user is in min. one group! if not, return here
    if ( !@GroupIDs ) {

        my %Hashes;
        $Hashes{QueueID} = 0;
        $Hashes{Queue}   = 'CustomQueue';
        $Hashes{MaxAge}  = 0;
        $Hashes{Count}   = 0;

        push @{ $Queues{Queues} }, \%Hashes;

        return %Queues;
    }

    if($Param{JustOpenOrdened}){
        # CustomQueue add on
        return if !$DBObject->Prepare(

            # Differentiate between total and unlocked tickets
            SQL => "
                SELECT count(*), st.ticket_lock_id
                FROM ticket st, queue sq, personal_queues suq, ticket_state tst
                WHERE st.ticket_state_id IN ( ${\(join ', ', @ViewableStateIDs)} )
                    AND st.queue_id = sq.id
                    AND st.archive_flag = 0
                    AND suq.queue_id = st.queue_id
                    AND sq.group_id IN ( ${\(join ', ', @GroupIDs)} )
                    AND suq.user_id = $Param{UserID}
                    AND st.ticket_state_id = tst.id
                    AND tst.type_id IN (1,2,4,5) 
                    GROUP BY st.ticket_lock_id 
                    ORDER BY count(*) desc",
        );
    } else {
        # CustomQueue add on
        return if !$DBObject->Prepare(

            # Differentiate between total and unlocked tickets
            SQL => "
                SELECT count(*), st.ticket_lock_id
                FROM ticket st, queue sq, personal_queues suq
                WHERE st.ticket_state_id IN ( ${\(join ', ', @ViewableStateIDs)} )
                    AND st.queue_id = sq.id
                    AND st.archive_flag = 0
                    AND suq.queue_id = st.queue_id
                    AND sq.group_id IN ( ${\(join ', ', @GroupIDs)} )
                    AND suq.user_id = $Param{UserID}
                    GROUP BY st.ticket_lock_id",
        );
    }

    

    my %CustomQueueHashes = (
        QueueID => 0,
        Queue   => 'CustomQueue',
        MaxAge  => 0,
        Count   => 0,
        Total   => 0,
    );

    while ( my @Row = $DBObject->FetchrowArray() ) {

        $CustomQueueHashes{Total} += $Row[0];

        if ( $ViewableLockIDs{ $Row[1] } ) {
            $CustomQueueHashes{Count} += $Row[0];
        }
    }

    push @{ $Queues{Queues} }, \%CustomQueueHashes;

    # set some things
    if ( $Param{QueueID} == 0 ) {
        $Queues{TicketsShown} = $CustomQueueHashes{Total};
        $Queues{TicketsAvail} = $CustomQueueHashes{Count};
    }

    # prepare the tickets in Queue bar (all data only with my/your Permission)
    if($Param{JustOpenOrdened}){
        return if !$DBObject->Prepare(
            SQL => "
                SELECT st.queue_id, sq.name, min(st.create_time), st.ticket_lock_id, count(*)
                FROM ticket st, queue sq, ticket_state tst
                WHERE st.ticket_state_id IN ( ${\(join ', ', @ViewableStateIDs)} )
                    AND st.queue_id = sq.id
                    AND st.archive_flag = 0
                    AND sq.group_id IN ( ${\(join ', ', @GroupIDs)} )
                    AND st.ticket_state_id = tst.id
                    AND tst.type_id IN (1,2,4,5) 
                GROUP BY st.queue_id, sq.name, st.ticket_lock_id
                ORDER BY count(*) desc"
        );
    } else {
        return if !$DBObject->Prepare(
            SQL => "
                SELECT st.queue_id, sq.name, min(st.create_time), st.ticket_lock_id, count(*)
                FROM ticket st, queue sq
                WHERE st.ticket_state_id IN ( ${\(join ', ', @ViewableStateIDs)} )
                    AND st.queue_id = sq.id
                    AND st.archive_flag = 0
                    AND sq.group_id IN ( ${\(join ', ', @GroupIDs)} )
                GROUP BY st.queue_id, sq.name, st.ticket_lock_id
                ORDER BY sq.name"
        );
    }
    

    my $CurrentDateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

    my %QueuesSeen;
    while ( my @Row = $DBObject->FetchrowArray() ) {

        my $Queue     = $Row[1];
        my $QueueData = $QueuesSeen{$Queue};    # ref to HASH

        if ( !$QueueData ) {

            $QueueData = $QueuesSeen{$Queue} = {
                QueueID => $Row[0],
                Queue   => $Queue,
                Total   => 0,
                Count   => 0,
                MaxAge  => 0,
            };

            push @{ $Queues{Queues} }, $QueueData;
        }

        my $Count = $Row[4];
        $QueueData->{Total} += $Count;

        if ( $ViewableLockIDs{ $Row[3] } ) {

            $QueueData->{Count} += $Count;

            my $TicketCreatedDTObj = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $Row[2],
                },
            );

            my $Delta  = $TicketCreatedDTObj->Delta( DateTimeObject => $CurrentDateTimeObject );
            my $MaxAge = $Delta->{AbsoluteSeconds};
            $QueueData->{MaxAge} = $MaxAge if $MaxAge > $QueueData->{MaxAge};

            # get the oldest queue id
            if ( $QueueData->{MaxAge} > $Queues{MaxAge} ) {
                $Queues{MaxAge}          = $QueueData->{MaxAge};
                $Queues{QueueIDOfMaxAge} = $QueueData->{QueueID};
            }
        }

        # set some things
        if ( $Param{QueueID} eq $Queue ) {
            $Queues{TicketsShown} = $QueueData->{Total};
            $Queues{TicketsAvail} = $QueueData->{Count};
        }
    }

    return %Queues;
}

1;