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

package Kernel::Output::HTML::Ligero::DashboardComplementoQueuePie;

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

    my %Filter = %{ $Param{'Filter'} };
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');
	
    my @Queues;
    my $total=0;
    # Check if queues are forced, otherwise, take the custom queues
  
    if ($Filter{QueueIDs}){
         @Queues = @{$Filter{QueueIDs}};
         delete $Filter{QueueIDs};
    } else {
         @Queues = $QueueObject->GetAllCustomQueues( UserID => $Self->{UserID}, );
    }

    my $QueueName;
    my $Count;

    for my $Q (@Queues){
        $QueueName = $QueueObject->QueueLookup(
                            QueueID=>$Q,
                        );

        # Cache 4.0
        my $filtros = join(", ", map { "$_ X $Filter{$_}" } keys %Filter);
        my $CacheKey = join '-', 'Pie',
            $Self->{Action},
            $Param{CacheKey},
            'Queues',$Q;
           

        # get cache object
        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
 
        $Count = $CacheObject->Get(
            Type => 'Dashboard',
            Key  => $CacheKey . '-Count',
        );
        
        # Se não tem em cache
        if ($Count eq ''){
            $Count = $TicketObject->TicketSearch(
                            %Filter,
                            'QueueIDs' => [$Q],
                            UserID     => 1,
                            Result => 'COUNT',
                            );
            if ( $Self->{Config}->{CacheTTLLocal} ) {
                $CacheObject->Set(
                    Type  => 'Dashboard',
                    Key   => $CacheKey . '-Count',
                    Value => $Count,
                    TTL   => $Self->{Config}->{CacheTTLLocal} * 60,
                );
            }
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
    
        $Param{FilterRaw} =~ s/QueueIDs/IgnoreQIDs/g;
        $Param{FilterRaw} .= ';QueueIDs='.$Q;
        
        if($Count>0){      
           $LayoutObject->Block(
                Name => 'Series',
                Data => {
                    URL => "Action=AgentTicketSearch;Subaction=Search;".$Param{FilterRaw},
                    QueueID=>$Q,
                    QueueName=>$QueueName,
                    Count=>$Count,
                    Gradient=>$Param{Gradient},
                    Width=>$Param{Width},
                   }
                );
        }
    };
    
    
    my $Content = $LayoutObject->Output(
        TemplateFile => 'AgentDashboardComplementoQueuePie',
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
