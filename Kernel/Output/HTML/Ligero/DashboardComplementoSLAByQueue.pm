# --
# Kernel/Output/HTML/DashboardComplementoDouble.pm
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id:
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::Ligero::DashboardComplementoSLAByQueue;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;
    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );



    return $Self;
}

sub Preferences {
    my ( $Self, %Param ) = @_;
    return;
}

sub Config {
    my ( $Self, %Param ) = @_;
    return (
        %{ $Self->{Config} }
    );
}

sub Run {
    no warnings 'uninitialized';
    
    my ( $Self, %Param ) = @_;
    my $Title = $Param{'Title'} || '';
    my @Queues;
    my $total=0;
    
    my %Filter = %{ $Param{'Filter'} };
    
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket'); 
    my $EscalationKey = $Param{EscalationKey} || 'SolutionDiffInMin';
    my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');
    # Check if queues are forced, otherwise, take the custom queues
    if ($Filter{QueueIDs}){
         @Queues = @{$Filter{QueueIDs}};
         delete $Filter{QueueIDs};
    } else {
         @Queues = $QueueObject->GetAllCustomQueues( UserID => $Self->{UserID}, );
    }
		
    my %QueuesGoal = split /[,:]/, $Param{QueuesGoal};
  
    # At least on queue should be define, 3 is the recomended
    return if ! @Queues;
    
    my $QueueName;
    #TimeObject 
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');
    # @TODO: Create Cache schema for this work
    # Loop on each queue
    for my $Q (@Queues){

        # if the Queue don't have a goal, so it should be 100 for default
        my $QueueGoal = $QueuesGoal{$Q} || $Param{DefaultGoal} || 100;
        # Takes Queue name
        $QueueName = $QueueObject->QueueLookup(
					 	 QueueID=>$Q,
                     );
        # Take current time
        my ($Sec, $Min, $Hour, $Day, $Month, $Year, $WeekDay) = $TimeObject->SystemTime2Date(
                SystemTime => $TimeObject->SystemTime(),
            );
        my $NYear=$Year;
        my $NMonth;
        if ($Month == "12"){
            $NMonth = "01";
            $NYear++;
        } else {
            $NMonth=$Month+1;
        }
        $NMonth = sprintf '%02s',$NMonth;


        my @Tickets;

        my $CacheKey = join '-', 'SLA',
            $Self->{Action},
            $Param{CacheKey},
            'Queues',$Q;       
         # get cache object
          my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');  
       
        my $TicketIDs = $CacheObject->Get(
            Type => 'Dashboard',
            Key  => $CacheKey . '-Tickets',
        );
      	  # Se não tiver em cache        
        if(!$TicketIDs || 1==1){
       		#Trata as datas
       		#
       		#
       		$Param{TicketCloseTimeNewerDate} = "2017-03-01" if(!$Param{TicketCloseTimeNewerDate});
			$Param{TicketCloseTimeOlderDate} = "2019-$NMonth-01" if(!$Param{TicketCloseTimeOlderDate});
		 
            # Search tickets on this queue   
            @Tickets = $TicketObject->TicketSearch(
                            %Filter,
                            QueueIDs => [$Q],
                            UserID     => 1,
                            Result => 'ARRAY',
                            TicketCloseTimeNewerDate => $Param{TicketCloseTimeNewerDate} . " 00:00:00",
                            TicketCloseTimeOlderDate => $Param{TicketCloseTimeOlderDate} . " 00:00:00",
                            );

            $TicketIDs = \@Tickets;
            if ( $Self->{Config}->{CacheTTLLocal} ) {
                $CacheObject->Set(
                    Type  => 'Dashboard',
                    Key   => $CacheKey . '-Tickets',
                    Value => $TicketIDs,
                    TTL   => $Self->{Config}->{CacheTTLLocal} * 60,
                );
            }


        } else {
            @Tickets = @{$TicketIDs};
        }
        # declare some variables
        my $Count=0;
        my $InTime=0;



        # for each ticket, check escalation
        for my $TicketID (@Tickets){
    
            my %Ticket = $TicketObject->TicketGet(
                TicketID => $TicketID,
                Extended => 1,
            );
            if (exists ($Ticket{$EscalationKey})){
                $Count++;
                if($Ticket{$EscalationKey} > 0){
                    $InTime++;
                } 
            } elsif ($Param{AllTickets} eq "1"){
                # Case the ticket don't have an escalation time, and we are considering all tickets
                # than it should be computed as InTime
                $InTime++;
            }
        }

        # Check if we should consider tickets without SLA as Solved in time
        if ($Param{AllTickets} eq "1"){
            $Count = scalar @Tickets;
        }

        $total+=$Count;
    
        # Se a opção CutQueueName estiver definida, limpamos o inicio do nome da fila
        # por exemplo, se a fila se chama Comercial::Propostas, ele será exibida como "Propostas"
        my $QueueLabel;  
    
        if($Param{CutQueueName} == 1){
            my @QueueLb=split(/::/,$QueueName);
            $QueueName = $QueueLb[scalar @QueueLb - 1];
        }
        if($Param{BreakLine} == 1){
            $QueueName =~ s/ /||break||/;
        }
    
        if($Count>0){
        
            # Calculate the percentual of tickets solved in time
            my $percentual=int($InTime*100/$Count);

            $LayoutObject->Block(
                Name => 'SeriesName',
                Data => {
                    QueueID=>$Q,
                    QueueName=>$QueueName,
                   }
            );
            # SLA Goal of the queue
            $LayoutObject->Block(
                Name => 'SeriesGoal',
                Data => {
                    Goal=>$QueueGoal,
                   }
            );
            $LayoutObject->Block(
                Name => 'Series',
                Data => {
                    Count=>$percentual,
                   }
            );
        }
    };
    
    my $Content = $LayoutObject->Output(
        TemplateFile => 'AgentDashboardComplementoSLAByQueue',
        Data         => {
            %{ $Self->{Config} },
            Title => $Title,
            Total => $total,
            Container => $Param{"Container"},
            Gradient=>$Param{Gradient},
            %Param,
        },
    );
    return $Content;
}

1;
