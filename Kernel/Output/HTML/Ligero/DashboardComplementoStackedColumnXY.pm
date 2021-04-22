# --
# Kernel/Output/HTML/DashboardComplementoStakedColumnTypes.pm
# Display all open tickets in the last 5 months, dividing them
# by ticket Type
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id:
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::Ligero::DashboardComplementoStackedColumnXY;

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
    my $total=0;

    my $xAxisAttribute = $Param{xAxis} || 'Queue';
    my $yAxisAttribute = $Param{yAxis} || '';
    my $NotDefined     = $Param{NotDefined} || 'Not defined';
    
    # Cache
    my $CacheKey = join '-', 'StackedXY',
        $Self->{Action},
        'Filter',$Param{FilterRaw};
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    my $TicketIDs = $CacheObject->Get(
        Type => 'Dashboard',
        Key  => $CacheKey . '-Tickets',
    );

    my @TicketIDsArray;

    # If not a cache
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
    my %xAxisKeys;
    my %yAxisValues;
    
    my $Available=0;
    for my $TicketID (@TicketIDsArray){
        my %Ticket = $TicketObject->TicketGet(
            TicketID      => $TicketID,
            DynamicFields => $Param{DynamicFields} || 0,
            Extended      => 0,
            UserID        => 1,
            Silent        => 0,
        );

        my $xvalue = $Ticket{$xAxisAttribute} || $NotDefined;
        # Total for this category, help us on showing in the correct order
        $xAxisKeys{$xvalue}++;
        
        #Verify if Y axis is defined
        my $yvalue='';
        if ($yAxisAttribute ne '') {
            $yvalue = $Ticket{$yAxisAttribute} || $NotDefined;
        } else {
            $yvalue='Tickets';
        }
        
        # Increase 1 on Y axis/X value
        $yAxisValues{$yvalue}->{$xvalue}++;

        $total++;
    }

    # at this moment, order by the highest value
    my @categories_all = reverse sort { $xAxisKeys{$a} <=> $xAxisKeys{$b} or $a cmp $b } keys %xAxisKeys;
    my @categories;
    
    # Limit results
    my $xLimit=$Param{'xLimit'}||0;
    
    if ($xLimit) {
        @categories = @categories_all[0..$xLimit-1];
    } else {
        @categories = @categories_all;    
    }
    
    
    # For each X
    for my $category (@categories){
        my $ShowName=$category;
        if(exists $Param{CutName} and $Param{CutName} == 1){
                my @Lb=split(/::/,$ShowName);
                $ShowName = $Lb[scalar @Lb - 1];
        }
        $LayoutObject->Block(
            Name => 'category',
            Data => {
                Category=>$ShowName,
               }
        );    
    }

    my $BaseURL = $Param{FilterRaw};
#        $Param{FilterRaw} =~ s/QueueIDs/IgnoreQIDs/g;
#        $Param{FilterRaw} .= ';QueueIDs='.$Q;
    my $baseURL = 'Action=AgentTicketSearch;Subaction=Search;'.$Param{FilterRaw};

    my %UrlField = (
        Queue => {
            Search    => 'QueueIDs',
            Object    => 'Kernel::System::Queue',
            Procedure => 'QueueLookup',
            Key       => 'Queue'
        },
        Service => {
            Search    => 'ServiceIDs',
            Object    => 'Kernel::System::Service',
            Procedure => 'ServiceLookup',
            Key       => 'Name'
        },
	StateID => {
	    Search   	=> 'StateIDs',
	    Object	=> 'Kernel::System::State',
            Procedure   => 'StateLookup',
	    Key		=> 'State'
	}
    );
    if($UrlField{$xAxisAttribute}){
    	$baseURL =~ s/$UrlField{$xAxisAttribute}->{Search}/Ignore$UrlField{$xAxisAttribute}->{Search}/g;    
    }    

    for my $y (sort keys %yAxisValues){
    	my @Values;
        for my $x (@categories){
            my $s = $yAxisValues{$y}->{$x}||0;
            push @Values, $s;
        }
        $LayoutObject->Block(
            Name => 'Series',
            Data => {
                Serie => $y,
#                Values=> join(',',@Values),
                URL   => $BaseURL,
            }
        );
        my $URL;
        my $counter=0;
        for my $Val (@Values){
		if($UrlField{$xAxisAttribute}){
		    my $Object    = $UrlField{$xAxisAttribute}->{Object};
		    my $Procedure = $UrlField{$xAxisAttribute}->{Procedure};
		    my $Key       = $UrlField{$xAxisAttribute}->{Key};

		    $URL = $Kernel::OM->Get($Object)->$Procedure(
		        "$Key" => $categories[$counter],
		    );
		    
		    $URL = $baseURL . ';'. $UrlField{$xAxisAttribute}->{Search} . "=" . $URL;

       	 	}
		$LayoutObject->Block(
		        Name => 'SerieValue',
		        Data => {
		            SerieValue => $Val,
		            SerieUrl=> $URL
		        }
		);
	        $counter++;
          }
		
    }
    my $Content = $LayoutObject->Output(
        TemplateFile => 'AgentDashboardComplementoStakedColumn',
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
