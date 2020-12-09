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

package Kernel::Output::HTML::Ligero::DashboardComplementoPieDrilldown;

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
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    # @TODO: PEGAR X E Y DAS CONFIGURAÇÕES
    my $xAxisAttribute = $Param{xAxis} || 'Queue';
    my $yAxisAttribute = $Param{yAxis} || '';
    my $NotDefined     = $Param{NotDefined} || 'Not defined';

    my $baseURL = 'Action=AgentTicketSearch;Subaction=Search;'.$Param{FilterRaw};
    
    # filtros de campos "especiais"
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
        State => {
            Search       => 'StateIDs',
            Object         => 'Kernel::System::State',
            Procedure    => 'StateLookup',
            Key            => 'State'
        },
        Priority =>{
            Search       => 'PriorityIDs',
            Object       => 'Kernel::System::Priority',
            Procedure    => 'PriorityLookup',
            Key          => 'Priority'    
        },
        Owner =>{
            Search       => 'OwnerIDs',
            Object       => 'Kernel::System::User',
            Procedure    => 'UserLookup',
            Key          => 'UserLogin'
        },

    );

    # Tratamento para URL. Se o eixo X também está sendo utilizado como filtro, devemos ignorá-lo na URL, de tal forma
    # que ao clicar em uma fatia, do primeiro nivel do grafico de pizza, tenhamos acesso apenas aos tickets daquele pedaço
    if($UrlField{$xAxisAttribute}){
        $baseURL =~ s/$UrlField{$xAxisAttribute}->{Search}/Ignore$UrlField{$xAxisAttribute}->{Search}/g;    
    } else {
        $baseURL =~ s/$xAxisAttribute/Ignore$xAxisAttribute/g;    
    }
    
    # Cache
    my $CacheKey = join '-', 'PieDrilldown',
        $Self->{Action},
        'Filter',$Param{FilterRaw};
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
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

    # Obtem cada Ticket, fazemos um loop e contabilizamos a quantidade de tickets por eixo X
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
            # Increase 1 
            $yAxisValues{$xvalue}->{$yvalue}++;
        }

        $total++;
    }

    # at this moment, order by the highest value
    my @categories = sort keys %xAxisKeys;

    # Variavel para armazenar a URL gerada para cada eixo X
    my %xURLs;

    # For each X
    for my $category (@categories){
        my $URL;
        my $dd='';
        my $ddTranslate;
        
        if ($xAxisKeys{$category}) {
            $dd = $category;
            if(exists $Param{CutName} and $Param{CutName} == 1){
                my @Lb=split(/::/,$dd);
                $dd = $Lb[scalar @Lb - 1];
            }
        }
        if ($Param{Translate}) {
            $ddTranslate=$dd;
            $dd='';
        }

        

        # Armazenamos o campo de pesquisa e o valor de pesquisa
        my $SearchField=$xAxisAttribute;
        my $SearchValue=$category;
        # Alguns parametros especiais, como fila, estado, serviço e prioridade, não podem ser pesquisados
        # com os valores "crus", temos então que encontrar seu ID e fazer as devidas substituições
        if($UrlField{$xAxisAttribute}){
            my $Object    = $UrlField{$xAxisAttribute}->{Object};
            my $Procedure = $UrlField{$xAxisAttribute}->{Procedure};
            my $Key       = $UrlField{$xAxisAttribute}->{Key};
            $SearchField  = $UrlField{$xAxisAttribute}->{Search};

            $SearchValue = $Kernel::OM->Get($Object)->$Procedure(
                "$Key" => $category,
            );
        } elsif ($xAxisAttribute =~ /^DynamicField_/) {
            # Campos Dinamicos tem um jeito particular de serem passados para pesquisa também
            $SearchField = "ShownAttributes=LabelSearch_$xAxisAttribute;Search_$xAxisAttribute";
        }

        $URL = $baseURL . ';'. $SearchField . "=" . $SearchValue;
        # Armazena a URL gerada para utilização no eixo y
        $xURLs{$category} = $URL;

        $LayoutObject->Block(
            Name => 'Series',
            Data => {
                Name=>$category,
                'Count' =>$xAxisKeys{$category},
                id => '',
                URL=> $URL,
                Drilldown => $dd,
                DrilldownTranslate => $ddTranslate,
                Gradient=>$Param{Gradient},
               }
        );    
    }
    
    for my $y (sort keys %yAxisValues){
        my $URL;
        my $dd;
        my $ddTranslate;
        if ($Param{Translate}) {
            $ddTranslate=$y;
        } else {
            $dd=$y;
        }
        
        $LayoutObject->Block(
            Name => 'Drilldown',
            Data => {
                Drilldown=>$dd,
                DrilldownTranslate=>$ddTranslate,
               }
        );
        
        for my $x (sort keys %{$yAxisValues{$y}}){
            # Armazenamos o campo de pesquisa e o valor de pesquisa
            my $SearchField=$yAxisAttribute;
            my $SearchValue=$x;

            if( exists $UrlField{$yAxisAttribute}->{Object}){
            
                my $Object    = $UrlField{$yAxisAttribute}->{Object};
                my $Procedure = $UrlField{$yAxisAttribute}->{Procedure};
                my $Key       = $UrlField{$yAxisAttribute}->{Key};
                $SearchField  = $UrlField{$yAxisAttribute}->{Search};
            
                $SearchValue = $Kernel::OM->Get($Object)->$Procedure(
                    "$Key" => $x,
                );

            }

            my $yUrl = $xURLs{$y};

            $yUrl =~ s/$SearchField/Ignore$SearchField/g;


            if ($SearchField =~ /^DynamicField_/) {
                # Campos Dinamicos tem um jeito particular de serem passados para pesquisa também
                $SearchField = "ShownAttributes=LabelSearch_$SearchField;Search_$SearchField";
            }

            $yUrl .= ";$SearchField=$SearchValue";

            my $ddv;
            my $ddvTranslate;
            if ($Param{Translate}) {
                $ddvTranslate=$x;
            } else {
                $ddv=$x;
            }
            $LayoutObject->Block(
                Name => 'DrilldownValue',
                Data => {
                    DrilldownURL            =>  $yUrl,
                    DrilldownKey            =>  $ddv,
                    DrilldownKeyTranslate   =>  $ddvTranslate,
                    DrilldownValue          =>  $yAxisValues{$y}->{$x},
                   }
            );
        }
    }
    
    # Show counts or Percentage
    if ($Param{ShowPercentage}){
        $Param{NumberFormat} = "this.point.percentage.toFixed(0) +' %'";
    } else {
        $Param{NumberFormat} = "this.y";
    }
    
    my $Content = $LayoutObject->Output(
        TemplateFile => 'AgentDashboardComplementoPieDrilldown',
        Data         => {
            %{ $Self->{Config} },
            Title => $Title,
            Total => $total,
            xAxis => $xAxisAttribute,          
            Container => $Param{"Container"},
            %Param,
            Legend  =>$Param{Legend}||'false',
        },
    );
    return $Content;
}

1;
