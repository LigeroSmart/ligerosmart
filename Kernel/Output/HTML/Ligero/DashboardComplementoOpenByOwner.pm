# --
# Kernel/Output/HTML/DashboardComplementoOpenByOwner.pm
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id:
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.

#
# @Params:
#       QueueIDs=1,2,3... Filter for queues. Use user preferencial queues if not defined (Custom Queues)
#       StateTypeIDs =1,2,3 Filter for StateTypeIDs (required!)
#
# --

package Kernel::Output::HTML::Ligero::DashboardComplementoOpenByOwner;

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
    my ( $Self, %Param ) = @_;

    my $Title = $Param{'Title'} || '';

    my $url;
    my $reverse=$Param{'reverse'}||0;
#    my @Queues;
    my $total=0;
    
    # Check if queues are forced, otherwise, take the custom queues
#    if ($Param{QueueIDs}){
#         @Queues = split(',',$Param{QueueIDs});
#    } else {
#         @Queues = $Self->{QueueObject}->GetAllCustomQueues( UserID => $Self->{UserID}, );
#    }
    
    $url="Action=AgentTicketSearch;Subaction=Search;$Param{FilterRaw}";

    my $CacheKey = join '-', 'OpenOwner',
        $Self->{Action},
        'Filter',$Param{FilterRaw};
#        'Queues',@Queues;

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket'); 
    my $UserObject   = $Kernel::OM->Get('Kernel::System::User');

    my $TicketIDs = $CacheObject->Get(
        Type => 'Dashboard',
        Key  => $CacheKey . '-Tickets',
    );

    my @TicketIDsArray;
    # If not in cache
    if (!$TicketIDs) {

        @TicketIDsArray = $TicketObject->TicketSearch(
                        %{ $Param{'Filter'} },
                        UserID     => 1,
                        Result => 'ARRAY',
                        OrderBy => ['Down','Down'],  # Down|Up
                        SortBy  => ['Lock','Owner'],   # Owner|Responsible|CustomerID|State|TicketNumber|Queue|Priority|Age|Type|Lock

                        );

        $TicketIDs = \@TicketIDsArray;
        if ( $Self->{Config}->{CacheTTLLocal} ) {
            $CacheObject->Set(
                Type  => 'Dashboard',
                Key   => $CacheKey . '-Tickets',
                Value => $TicketIDs,
                TTL   => $Self->{Config}->{CacheTTLLocal} * 60,
            );
        }

    } else {
        @TicketIDsArray = @{$TicketIDs};
    }

    # Obtem cada Ticket, fazemos um loop e contabilizamos a quantidade de tickets por analista
    my %List;
    my $Available=0;
    for my $TicketID (@TicketIDsArray){
        my %Ticket = $TicketObject->TicketGet(
            TicketID      => $TicketID,
            DynamicFields => 0,         # Optional, default 0. To include the dynamic field values for this ticket on the return structure.
            UserID        => 1,
            Silent        => 0,         # Optional, default 0. To suppress the warning if the ticket does not exist.
        );
        if($Ticket{Lock} eq 'lock'){
            $List{$Ticket{OwnerID}}++;
        } else {
            $Available++;
        }
        $total++;
    }

    # Display the results
    my $bgcolor='#F6F6F6';
    my $Username;
#    for my $agent (keys %List){
# Ordem: reverse sort: os atendentes com menos chamados vem primeiro
    if ($reverse!=1){
        for my $agent ( sort {$List{$a} cmp $List{$b} } keys %List){

            $Username=$UserObject->UserName(
                            UserID=>$agent,
                        );
            
            $LayoutObject->Block(
                Name => 'line',
                Data => {
                    Summary=>$Username,
                    Url=>$url.";OwnerIDs=$agent;LockIDs=2",
                    Count=>$List{$agent},
                    Bgcolor=>$bgcolor,
                   }
                );
            $bgcolor=$bgcolor eq '#F6F6F6'?'#fff':'#F6F6F6';
        }
    } else {
        for my $agent ( reverse sort {$List{$a} cmp $List{$b} } keys %List){

            $Username=$UserObject->UserName(
                            UserID=>$agent,
                        );
            
            $LayoutObject->Block(
                Name => 'line',
                Data => {
                    Summary=>$Username,
                    Url=>$url.";OwnerIDs=$agent;LockIDs=2",
                    Count=>$List{$agent},
                    Bgcolor=>$bgcolor,
                   }
                );
            $bgcolor=$bgcolor eq '#F6F6F6'?'#fff':'#F6F6F6';
        }
    } # If Reverse
    
    $LayoutObject->Block(
        Name => 'line',
        Data => {
            TranslatableSummary=>"Tickets available",
            Count=>$Available,
            Bgcolor=>$bgcolor,
            Url=>$url.";LockIDs=1",
           }
        );
    
    my $Content = $LayoutObject->Output(
        TemplateFile => 'AgentDashboardComplementoTicketDigest',
        Data         => {
            %{ $Self->{Config} },
            Title => $Title,
            Total => $total,
            Container => $Param{"Container"},
            %Param,
        },
    );
    return $Content;
}

1;
