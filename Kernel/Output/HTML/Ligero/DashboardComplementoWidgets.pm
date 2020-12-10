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

package Kernel::Output::HTML::Ligero::DashboardComplementoWidgets;

use strict;
use warnings;
use Kernel::System::ObjectManager;
local $Kernel::OM = Kernel::System::ObjectManager->new();
my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');
use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

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

    # quote Title attribute, it will be used as name="" parameter of the iframe
    my $Title = $Self->{Config}->{Title} || '';
    $Title =~ s/\s/_/smx;

    my $CacheKey=$Self->{Name}."-".$Self->{UserID}."-";
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');
    my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');
    my $width=100/$Self->{Config}->{Widgets};
    my $i=1;
    
    # For each widget of this bar
    while ($i<=$Self->{Config}->{Widgets}) {    
        # Check if Dash in cache
        my $content = $CacheObject->Get(
            Type => 'Dashboard',
            Key  => $CacheKey . '-Widget-'.$i,
        );

        # If not in cache
        if (!$content){
#        if (1==1){

            my %WidgetOptions;
            if($Self->{Config}->{"Widget $i"}){
                %WidgetOptions=%{$Self->{Config}->{"Widget $i"}};        
            } else {
                $i++;
                next;
            }	   
            my $WdgModule = $WidgetOptions{'2-WidgetType'};
            if ( !$MainObject->Require($WidgetOptions{'2-WidgetType'}) ) {
                $MainObject->Die("Can't load backend module");
            }
            my %DashParams;
            my @Options = split /;/, $WidgetOptions{"4-WidgetOptions"};
            for my $String (@Options) {
                next if !$String;
                my ( $Key, $Value ) = split /=/, $String;
                $DashParams{$Key}=$Value;
            }                                
            my %TicketSearch;
            my %DynamicFieldsParameters;
            my @Params = split /;/, $WidgetOptions{'3-Filter'};

            STRING:
            for my $String (sort @Params) {
                next STRING if !$String;
                my ( $Key, $Value ) = split /=/, $String;
                $CacheKey .= "-$Key-$Value";                
                if ( $Key eq 'CustomerID' ) {
                    $Key = "CustomerIDRaw";
                }
                # push ARRAYREF attributes directly in an ARRAYREF
                if (
                    $Key
                    =~ /^(StateType|StateTypeIDs|Queues|QueueIDs|Types|TypeIDs|States|StateIDs|Priorities|PriorityIDs|Services|ServiceIDs|SLAs|SLAIDs|Locks|LockIDs|OwnerIDs|ResponsibleIDs|WatchUserIDs|ArchiveFlags)$/
                    )
                {
                    push @{ $TicketSearch{$Key} }, $Value;
                }
                # Tickets that the user which is seeing the dashboard
                elsif ($Key eq 'MyTickets')
                {
                    @{ $TicketSearch{'OwnerIDs'} } = $Self->{UserID};                    
                }
                elsif ($Key eq 'MyQueues')
                {                 
                    @{ $TicketSearch{'QueueIDs'} } = $Kernel::OM->Get('Kernel::System::Queue')->GetAllCustomQueues( UserID => $Self->{UserID}, );                                                             
                }
                # check if parameter is a dynamic field and capture dynamic field name (with DynamicField_)                
                elsif ( $Key =~ m{\A (DynamicField_.+?) _ (.+?) \z}sxm ) {

                    # prevent adding ProcessManagement search parameters (for ProcessWidget)
                    if ( $Self->{Config}->{IsProcessWidget} ) {
                        next STRING if $2 eq $Self->{ProcessManagementProcessID};
                        next STRING if $2 eq $Self->{ProcessManagementActivityID};
                    }

                    push @{ $DynamicFieldsParameters{$1}->{$2} }, $Value;
                } 
                elsif ( !defined $TicketSearch{$Key} ) {

                    # change sort by, if needed
                    if (
                        $Key eq 'SortBy'
                        && $Self->{SortBy}
                        && $Self->{ValidSortableColumns}->{ $Self->{SortBy} }
                        )
                    {
                        $Value = $Self->{SortBy};
                    }
                    elsif ( $Key eq 'SortBy' && !$Self->{ValidSortableColumns}->{$Value} ) {
                        $Value = 'Age';
                    }
                    $TicketSearch{$Key} = $Value;
                }
                elsif ( !ref $TicketSearch{$Key} ) {
                    my $ValueTmp = $TicketSearch{$Key};
                    $TicketSearch{$Key} = [$ValueTmp];
                    push @{ $TicketSearch{$Key} }, $Value;
                }
                else {
                    push @{ $TicketSearch{$Key} }, $Value;
                }
            }

            # create a filter URL
            my $FilterRaw;
            for my $k (keys %TicketSearch){
                # se for array
                if (ref $TicketSearch{$k} eq 'ARRAY'){
                    foreach (@{$TicketSearch{$k}}){
                        $FilterRaw.="$k=$_;"
                    }
                } elsif ($k =~ /Newer/){
                        my $keyname=$k;
                        $keyname =~ s/Newer.*$/Point/;
                        $FilterRaw.="$keyname=$TicketSearch{$k};TimeSearchType=TimePoint;TicketCreateTimePointStart=Last;TicketCreateTimePointFormat=minute;"
                } elsif ($k =~ /Older/){
                        my $keyname=$k;
                        $keyname =~ s/Older.*$/Point/;
                        $FilterRaw.="$keyname=$TicketSearch{$k};TimeSearchType=TimePoint;TicketCreateTimePointStart=Before;TicketCreateTimePointFormat=minute;"
                } else {
                    $FilterRaw.="$k=$TicketSearch{$k};"
                }
            }
            
            $Param{'Filter'}=\%TicketSearch;
            $Param{'FilterRaw'}=$FilterRaw;
            
            $Param{'CacheKey'}=$CacheKey;
            $Param{"Container"}="compwdg".$i.rand(1000099);
            $Param{"Title"}=$WidgetOptions{"1-Title"}||"Dashboard";
        	$Param{"Days"} = $WidgetOptions{"5-Days"} || 30;	
            $Param{"Width"}=$width;

            my $Widget = $WdgModule->new(%$Self);

            $content= $Widget->Run(
                    %Param,
                    %DashParams,
                    Dashboard  => $Self->{Name},
                    Index      => $i,
                    );
                    
            if ( $Self->{Config}->{CacheTTLLocal} ) {
                $CacheObject->Set(
                    Type => 'Dashboard',
                    Key  => $CacheKey . '-Widget-'.$i,
                    Value => $content,
                    TTL   => ($Self->{Config}->{CacheTTLLocal} * 60)+(rand ($Self->{Config}->{CacheTTLLocalAddRandom} * 60)),
                );
            }

        } 

        $LayoutObject->Block(
            Name => 'Widget',
            Data => {
                Container=>$Self->{Config}->{Container1},
                Content=>$content,
            }
        );
        
        $i++;
    }
    


##############################################
# Output!
##############################################    
    my $Content = $LayoutObject->Output(
        TemplateFile => 'AgentDashboardComplementoWidgets',
        Data         => {
            %{ $Self->{Config} },
            Title => $Title,
        },
    );

    return $Content;
}

1;
