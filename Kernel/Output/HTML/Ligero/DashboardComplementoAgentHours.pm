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

package Kernel::Output::HTML::Ligero::DashboardComplementoAgentHours;

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
	my $Ini = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Complemento::AccountedTime::DynamicFieldStartID');
    my $End = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Complemento::AccountedTime::DynamicFieldEndID');
	
#To-Do
#Criar um select que traga as horas lançadas por cada atendente
 # get cache object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout'); 
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');
	my $DBObject =	$Kernel::OM->Get("Kernel::System::DB");
	
	my %Header =(
		th1 => "Name",
		th2 => "Day",
		th3 => "Month"
	);	
	foreach my $Keys (sort keys %Header){
		$LayoutObject->Block(
			Name => 'Theader',
			Data => {
				Theader => $LayoutObject->{LanguageObject}->Translate($Header{$Keys}),
			},
		);	
	}
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
       	 
        my $Year=$year+1900;
        my $Month=$mon+1;
		#Create Search Data
		if(length $Month eq 1){
            $Month = "0".$Month;
    	    $Month = "01" if ($Month eq 0);
        }
		my $AgentBlackList = $Param{AgentBlackList};
		my $TimeNewerDate = $Year."-".$Month."-01 00:00:00";
		
		my $TimeNewerDateDay = $Year."-".$Month."-".$mday . " 00:00:00";
		my $TimeEndDateDay = $Year."-".$Month."-".$mday ." 23:59:59";
		my %Data;
		my $SQL = "SELECT concat(u.first_name, ' ' , u.last_name) as full_name, 
            SUM(IF( a.change_time >= "."\"$TimeNewerDate\"" . ",TIME_TO_SEC(TIMEDIFF(f.fim, i.inicio))/60,0)) as MONTH ,
            SUM(IF( a.change_time  between "."\"$TimeNewerDateDay\""." and " ."\"$TimeEndDateDay\"". " ,TIME_TO_SEC(TIMEDIFF(f.fim, i.inicio))/60,0)) as DAY 
 FROM 
                (
                 SELECT field_id, object_id, value_date as inicio FROM 
                 dynamic_field_value as d  
                 LEFT JOIN 
                  article a on a.id = d.object_id  where field_id = ? and a.change_time >= now() - INTERVAL 1 month ) i   
                 LEFT JOIN 
                 (
                 SELECT object_id, value_date as fim FROM 
                 dynamic_field_value as d  
                 LEFT JOIN 
                  article a on a.id = d.object_id where field_id= ? and a.change_time >= now() - INTERVAL 1 month) f on i.object_id = f.object_id   
                 LEFT JOIN 
                  article a on i.object_id = a.id    
                 LEFT JOIN 
                  ticket t ON  t.id = a.ticket_id    
                 LEFT JOIN 
                  users u on a.change_by = u.id ";
				  $SQL .= "where u.id not in ( $AgentBlackList)" if ($AgentBlackList); 
				  $SQL .= " group by u.id";

#	$Kernel::OM->Get("Kernel::System::Log")->Dumper($SQL);
	return if !$DBObject->Prepare(
		SQL => $SQL,
		Bind => [\$Ini, \$End],
	); 	   
	my $TotalDay = 0;
	my $TotalMonth = 0;
	while (my @Row = $DBObject->FetchrowArray() ){
		$TotalDay += $Row[2];
		$TotalMonth += $Row[1];
		$LayoutObject->Block(
			Name => 'TrItem',
			Data => {
				FullName => $Row[0],
				Day => convert_to_hhmmss($Row[2]),
				Month => convert_to_hhmmss($Row[1]),
			}
		);	

	}
	$LayoutObject->Block(
		Name => 'TrTotal',
		Data => {
			Total => 'Total',
			TotalDay => convert_to_hhmmss($TotalDay),
			TotalMonth => convert_to_hhmmss($TotalMonth)
		});
    my $Content = $LayoutObject->Output(
        TemplateFile => 'AgentDashboardComplementoAgentHours',
        Data         => {
			%Data,
           # Title => $Title,
           # Container => $Param{"Container"},
            %Param,
        },
    );
    
    return $Content;
}
 sub convert_to_hhmmss {

  my $hourz=int($_[0]/60);

  my $minz=$_[0] % 60;

  my $secz=int($minz % 60);

  

  return sprintf ("%02d:%02d:%02d", $hourz,$minz,$secz)

 

 }
1;
