# --
# Kernel/Output/HTML/OutputFilterMediaWiki.pm
# Copyright (C) 2011 - 2015 Complemento - Liberdade e Tecnologia http://www.complemento.net.br
# --
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::Ligero::OutputFilterConfigDashboards;

use strict;
use warnings;
require LWP::UserAgent;
use List::Util qw(first);
use HTTP::Status qw(:constants :is status_message);


sub new {
	my ( $Type, %Param ) = @_;

	# allocate new hash for object
	my $Self = {};
	bless( $Self, $Type );

	# get needed objects


	$Self->{UserID} = $Param{UserID};

	$Self->{EncodeObject} = $Kernel::OM->Get('Kernel::System::Encode');

	$Self->{QueueObject} = $Kernel::OM->Get('Kernel::System::Queue');
	$Self->{StateObject} = $Kernel::OM->Get('Kernel::System::State');
	$Self->{CustomerCompanyObject} = $Kernel::OM->Get('Kernel::System::CustomerCompany');
	$Self->{PriorityObject} = $Kernel::OM->Get('Kernel::System::Priority');
	$Self->{ServiceObject} = $Kernel::OM->Get('Kernel::System::Service');
	$Self->{SLAObject} = $Kernel::OM->Get('Kernel::System::SLA');
	$Self->{TypeObject} = $Kernel::OM->Get('Kernel::System::Type');


    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;
    my $CustomerIDPage;
    my $ServicePage;
    my $TicketPage;
    my %Data = ();
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    # get template name
    my $Templatename = $Param{TemplateFile} || '';
    return 1 if !$Templatename;

    # Static Parameters for bar overview
    my @Parameters = qw(Filter_Expired Theme 2-WidgetType);
    for my $P (@Parameters){
        $LayoutObject->Block(
          	Name => 'Parameter',
            Data => {
            	Parameter => $P,
	        }
        );
        my $Options = $ConfigObject->Get("ComplementoDashboards_".$P."_Options");
        my %options = %{$Options};
        for my $k (sort keys %options){

            $LayoutObject->Block(
              	Name => 'Option',
                Data => {
                	key => $k,
                    content => $options{$k},
		        }
            );
        }
    }
    # End Static Parameters
    
    # Filter parameter for Overview Dashboard
    my @GenericFilterTypes = qw(Queue State Service Type SLA CustomerCompany Priority StateType) ;
    
    for my $filter (@GenericFilterTypes){
        # Standard
        my $Key    = $filter.'IDs';
        my $Type   = $filter;
        my $Object = $filter;
         
        # Custom things
        if ($filter eq "CustomerCompany") {
            $Key  = 'CustomerID';
            $Type = 'CustomerID';
        } elsif ($filter eq "StateType"){
            $Type = 'State Type';
            $Object = 'State';
        }

        my $method = $filter.'List';
        my %Items = $Self->{$Object.'Object'}->$method(UserID=>1);

        for my $k (sort keys %Items){
		#COMPLEMENTO ROBERT Escape nas aspas simples devido ao uso do nome para funções no javascript
		$Items{$k} =~ s/\'/\\'/g;
        $Items{$k} =~ s/[\n\r]//g;
	        #---------------------

            $LayoutObject->Block(
              	Name => 'Filter',
                Data => {
                    Type  => $Type,
                	Name  => $Items{$k},
                    Key   => $Key,
                    Value => $k,
	            }
            );
        }
    }


    my @ExtraFilters = @{$ConfigObject->Get("ComplementoDashboards_ExtraFilters")};
    
    if (@ExtraFilters){
        for my $Filter (@ExtraFilters){
     
                my @fil = split /\(|\)|=/,$Filter;
                
                $fil[0] =~ s/\s+$//;

                $LayoutObject->Block(
                  	Name => 'Filter',
                    Data => {
                        Type  => $fil[0],
                    	Name  => '',
                        Key   => $fil[1],
                        Value => $fil[2],
	                }
                );
        }
    }

    # Filter parameter for Overview Dashboard Widget Options
    my %AllOptions = %{$ConfigObject->Get("ComplementoDashboards_WidgetOptions")};
    
    for my $k(keys %AllOptions){

        $LayoutObject->Block(
          	Name => 'WidgetOptionKey',
            Data => {
                WidgetOptionKey   => $k,
            }
        );
        
        my @Values = @{$AllOptions{$k}};
    
        for my $v (sort @Values){
            # Escape ' for the javascript goodness
            $v =~ s/\'/\\\'/g;
            $LayoutObject->Block(
              	Name => 'WidgetOptionValue',
                Data => {
                    WidgetOptionValue  => $v,
                }
            );
        }



    }

    
	my $Script = $LayoutObject->Output(
	    TemplateFile => 'OutputFilterConfigDashboards',
        Data         => \%Data,
	); 


    ${ $Param{Data} }.=$Script;


    return ${ $Param{Data} };


#	    ${ $Param{Data} } =~ s{(<div \s+ id="ArticleTree">)}{$iFrame $1}xms;
#	}else{

#    	return ${ $Param{Data} };
#	}
}

1;
