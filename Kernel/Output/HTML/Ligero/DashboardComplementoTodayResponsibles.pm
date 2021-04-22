# --
# Kernel/Output/HTML/DashboardComplementoTodayResponsibles.pm
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

package Kernel::Output::HTML::Ligero::DashboardComplementoTodayResponsibles;

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


    my %Filter = %{ $Param{'Filter'} };


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
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');
    my $TimeNow = $TimeObject->SystemTime();
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my $UserObject = $Kernel::OM->Get('Kernel::System::User');

    my ( $Sec, $Min, $Hour, $Day, $Month, $Year, $WeekDay )
        = $TimeObject->SystemTime2Date(
        SystemTime => $TimeNow,
        );
    $url.=";TicketCreateTimeStartYear=$Year;TicketCreateTimeStopYear=$Year;TicketCreateTimeStartMonth=$Month";
    $url.=";TicketCreateTimeStopMonth=$Month;TicketCreateTimeStartDay=$Day;TicketCreateTimeStopDay=$Day;TimeSearchType=TimeSlot";

    my @Tickets = $TicketObject->TicketSearch(
                    %Filter,
                    # Created Today
                    # tickets with create time after ... (ticket newer than this date) (optional)
                    TicketCreateTimeNewerDate => "$Year-$Month-$Day 00:00:01",
                    # tickets with created time before ... (ticket older than this date) (optional)
                    TicketCreateTimeOlderDate => "$Year-$Month-$Day 23:59:59",
                    #Other Filters
#                    StateTypeIDs => \@StateTypeIDs,
#                    CreatedQueueIDs => \@Queues,
                    UserID     => 1,
                    Result => 'ARRAY',
                    OrderBy => ['Down','Down'],  # Down|Up
                    SortBy  => ['Responsible'],   # Owner|Responsible|CustomerID|State|TicketNumber|Queue|Priority|Age|Type|Lock

                    );

    # Obtem cada Ticket, fazemos um loop e contabilizamos a quantidade de tickets por analista
    my %List;
    my $Available=0;
    for my $TicketID (@Tickets){
        my %Ticket = $TicketObject->TicketGet(
            TicketID      => $TicketID,
            DynamicFields => 0,         # Optional, default 0. To include the dynamic field values for this ticket on the return structure.
            UserID        => 1,
            Silent        => 0,         # Optional, default 0. To suppress the warning if the ticket does not exist.
        );
        if($Ticket{Responsible} ne 'root@localhost'){
            $List{$Ticket{Responsible}}++;
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
                            User=>$agent,
                        );
            my $ResponsibleID = $UserObject->UserLookup(
                            UserLogin=>$agent,
            );
            
            $LayoutObject->Block(
                Name => 'line',
                Data => {
                    Summary=>$Username,
                    Url=>$url.";ResponsibleIDs=$ResponsibleID",
                    Count=>$List{$agent},
                    Bgcolor=>$bgcolor,
                   }
                );
            $bgcolor=$bgcolor eq '#F6F6F6'?'#fff':'#F6F6F6';
        }
    } else {
        for my $agent ( reverse sort {$List{$a} cmp $List{$b} } keys %List){

            $Username= $UserObject->UserName(
                            User=>$agent,
                        );

            my $ResponsibleID = $UserObject->UserLookup(
                            UserLogin=>$agent,
            );
            
            $LayoutObject->Block(
                Name => 'line',
                Data => {
                    Summary=>$Username,
                    Url=>$url.";ResponsibleIDs=$ResponsibleID",
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
            TranslatableSummary=>"Without Responsible",
            Count=>$Available,
            Bgcolor=>$bgcolor,
            Url=>$url.";ResponsibleIDs=1",
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
