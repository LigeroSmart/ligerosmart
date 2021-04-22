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

package Kernel::Output::HTML::Ligero::DashboardComplementoMonthlyTickets;

use strict;
use warnings;
use Time::Local qw( timegm_nocheck );

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed objects
   

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

    my $Title = $Param{Title} || '';

    my %Axis = (
        '7Day' => {
            0 => 'Sun',
            1 => 'Mon',
            2 => 'Tue',
            3 => 'Wed',
            4 => 'Thu',
            5 => 'Fri',
            6 => 'Sat',
        },
    );
    
#    my @Queues;
    
#    # Check if queues are forced, otherwise, take the custom queues
#    if ($Param{QueueIDs}){
#         @Queues = split(',',$Param{QueueIDs});
#    } else {
#         @Queues = $Self->{QueueObject}->GetAllCustomQueues( UserID => $Self->{UserID}, );
#    };

    my $DaysRewind     = $Param{Days}||15;
    my @TicketsCreated = ();
    my @TicketsClosed  = ();
    my @TicketWeekdays = ();
    my @TicketYAxis    = ();
    my $Max            = 0;
    my $Key            = 0;

    my $CacheKey = join '-', 'MonthlyTickets',
        $Self->{Action};
#        'Days',
#        $DaysRewind,
#        'Queues',
#        @Queues;

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout'); 
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');
    for my $KeyTemp ( 0 .. $DaysRewind ) {
        $Key = $DaysRewind - $KeyTemp;
        
        my $TimeNow = $TimeObject->SystemTime();
        if ($Key) {
            $TimeNow = $TimeNow - ( 60 * 60 * 24 * $Key );
        }
        my ( $Sec, $Min, $Hour, $Day, $Month, $Year, $WeekDay )
            = $TimeObject->SystemTime2Date(
            SystemTime => $TimeNow,
            );

        $LayoutObject->Block(
            Name => 'DayMonth',
            Data => {
                Category=> substr($LayoutObject->{LanguageObject}->Translate( $Axis{'7Day'}->{$WeekDay} ),0, 1),
               }
            );

        my $CountCreated = $CacheObject->Get(
            Type => 'Dashboard',
            Key  => $CacheKey . "-CountCreated-$Year-$Month-$Day",
        );
    
        # Se não obteve do cache, pega do BD
        if ($CountCreated eq '') {
            $CountCreated = $TicketObject->TicketSearch(
                %{ $Param{'Filter'} },
                # cache search result 30 min
#                CacheTTL => 60 * 30,

                # tickets with create time after ... (ticket newer than this date) (optional)
                TicketCreateTimeNewerDate => "$Year-$Month-$Day 00:00:00",

                # tickets with created time before ... (ticket older than this date) (optional)
                TicketCreateTimeOlderDate => "$Year-$Month-$Day 23:59:59",
#                QueueIDs => \@Queues,

#                CustomerID => $Param{Data}->{UserCustomerID},
                Result     => 'COUNT',

                # search with user permissions
                # Permission => $Self->{Config}->{Permission} || 'ro',
                #UserID => $Self->{UserID},
                UserID => 1,
            );
            # Se CacheTTLLocal definido, armazena o valor recuperado
            if ($Self->{Config}->{CacheTTLLocal} ) {
                $CacheObject->Set(
                    Type  => 'Dashboard',
                    Key  => $CacheKey . "-CountCreated-$Year-$Month-$Day",
                    Value => $CountCreated,
                    TTL   => $Self->{Config}->{CacheTTLLocal} * 60,
                );
            }
        }

        $LayoutObject->Block(
            Name => 'CreatedTickets',
            Data => {
                Count=>$CountCreated||0,
               }
            );

        my $CountClosed = $CacheObject->Get(
            Type => 'Dashboard',
            Key  => $CacheKey . "-CountClosed-$Year-$Month-$Day",
        );

        if ($CountClosed eq '') {
        
            $CountClosed = $TicketObject->TicketSearch(

                %{ $Param{'Filter'} },
                # cache search result 30 min
                CacheTTL => 60 * 30,

                # tickets with create time after ... (ticket newer than this date) (optional)
                TicketCloseTimeNewerDate => "$Year-$Month-$Day 00:00:00",

                # tickets with created time before ... (ticket older than this date) (optional)
                TicketCloseTimeOlderDate => "$Year-$Month-$Day 23:59:59",
#                QueueIDs => \@Queues,

                CustomerID => $Param{Data}->{UserCustomerID},
                Result     => 'COUNT',

                # search with user permissions
    #            Permission => $Self->{Config}->{Permission} || 'ro',
    #            UserID => $Self->{UserID},
                UserID => 1,
            );
                        # Se CacheTTLLocal definido, armazena o valor recuperado
            if ($Self->{Config}->{CacheTTLLocal} ) {
                $CacheObject->Set(
                    Type  => 'Dashboard',
                    Key  => $CacheKey . "-CountClosed-$Year-$Month-$Day",
                    Value => $CountClosed,
                    TTL   => $Self->{Config}->{CacheTTLLocal} * 60,
                );
            }
        }
#        if ( $CountClosed && $CountClosed > $Max ) {
#            $Max = $CountClosed;
#        }
#        push @TicketsClosed, [ 12 - $Key, $CountClosed ];
        $LayoutObject->Block(
            Name => 'Closed',
            Data => {
                Count=>$CountClosed||0,
               }
            );

    }


    my $Content = $LayoutObject->Output(
        TemplateFile => 'AgentDashboardComplementoMonthlyTickets',
        Data         => {
            %{ $Self->{Config} },
            Title => $Title,
            Container => $Param{"Container"},
            %Param,
        },
    );
    
    return $Content;
}

1;
