# --
# Kernel/Output/HTML/OutputFilterMediaWiki.pm
# Copyright (C) 2011 - 2015 Complemento - Liberdade e Tecnologia http://www.complemento.net.br
# --
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::Complemento::OLAAgentTicketZoom;
use Data::Dumper;
use strict;
use warnings;
sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;
    my %Data = ();
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $ConfigObject = $Kernel::OM->Get("Kernel::Config");
    my $LayoutObject = $Kernel::OM->Get("Kernel::Output::HTML::Layout");
    my $QueueObject = $Kernel::OM->Get("Kernel::System::Queue");	
    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

    if(${ $Param{Data}} !~ /id=\"ArticleItems\"/ ){
    	return;
    }

    my %HashClassColor = (
	    'Stopped - Expired'		=>	'Stopped Expired',
	    'In Progress - Expired' =>  'Progress Expired',
	    'In Progress - Alert'	=>  'Progress Alert',
	    'In Progress'			=>  'Progress',
	    'Stopped'				=> 	'Stopped',
    );

    my $TicketID =  $ParamObject->GetParam( Param => 'TicketID' );
    
    my %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
	    TicketID => $TicketID,
	    DynamicFields => 1,
	    Extended => 0,
	    UserID => 1
	);

    my @QueueRunningOlas;
    my @QueueStoppedOlas;
    # Verifica se algum OLA de Fila está em execução
    OLA:
    for my $QueueOla (grep $_ =~ /^DynamicField_OlaQueue.*State/, keys %Ticket){
	next OLA if ! $Ticket{$QueueOla};
	$QueueOla =~ /^DynamicField_OlaQueue(.*)State/;
	my $QueueID = $1;
	my $Diff = $QueueOla;
	my $Dest = $QueueOla;
	
	my $DFName = $QueueOla;
	$DFName =~ s/^DynamicField_//;
	
	$Diff =~ s/State$/Diff/g;
	$Dest =~ s/State$/Destination/g;
    my $Name = $QueueObject->QueueLookup( QueueID => $QueueID );
    $Name  =~ s/\:\:/&nbsp;:: /gm;
	my %OlaInformation = (
	    Name        => $Name,
	    State 	    => $Ticket{$QueueOla},
	    Destination => $Ticket{$Dest},
	    Diff        => $Ticket{$Diff},
	);
	
	if ($Ticket{$QueueOla} =~ /^In Progress/)
	{
	    push @QueueRunningOlas, \%OlaInformation;
	} 
	else 
	{
	    push @QueueStoppedOlas, \%OlaInformation;
	}
    }
    
    if (scalar @QueueStoppedOlas)
    {
	@QueueStoppedOlas = sort { $a->{Name} cmp $b->{Name} } @QueueStoppedOlas;
    }
    $LayoutObject->Block(
	    Name => 'CurrentQueue',
	    Data => \%Data, 
    ) if (scalar @QueueRunningOlas) > 0;

    foreach my $Hash (@QueueRunningOlas){

        $Hash->{Expired} = ($Hash->{Diff} >= 0 ) ?  "Remaining" : 'Expired' ; 

        #$Hash->{Icon} = $HashFontAwesome{$Hash->{State}};
        $Hash->{Class} = $HashClassColor{$Hash->{State}} || $Hash->{State} ;
        $Hash->{State} = (split /-/, $Hash->{State})[0];
        $Hash->{Diff} = _Convert_time(abs($Hash->{Diff})*60);
        $LayoutObject->Block(
            Name => 'CurrentQueueOLA',
            Data => $Hash, 
        );
    }
    # TODO: Opção para não exibir OLA das demais filas
    # para cada um dos demais OLA's
    # 
    $LayoutObject->Block(
	    Name => 'OtherQueue',
	    Data => \%Data, 
    ) if (scalar @QueueStoppedOlas) > 0;

    foreach my $Hash (@QueueStoppedOlas){
	    $Hash->{Expired} = ($Hash->{Diff} >= 0 ) ?  "Remaining" : 'Expired' ;

	    #$Hash->{Icon} = 'fa-pause';

	    $Hash->{Class} = $HashClassColor{$Hash->{State}};
	    $Hash->{State} = (split /-/, $Hash->{State})[0];
	    $Hash->{Diff} = _Convert_time(abs($Hash->{Diff})*60);
	    $LayoutObject->Block(
	    Name => 'OtherQueueOLA',
	    Data => $Hash, 
    );
    }

    my $Snippet = $LayoutObject->Output(
	TemplateFile => 'OutputFilter.Complemento.OLAAgentTicketZoom',
	    Data         => \%Data,
    );
    ${ $Param{Data} } =~ s{(<div \s+ class="SidebarColumn">)}{$1 $Snippet}xsm;
}

sub _Convert_time {
  my $time = shift;
  my $days = int($time / 86400);
  $time -= ($days * 86400);
  my $hours = int($time / 3600);
  $time -= ($hours * 3600);
  my $minutes = int($time / 60);
  my $seconds = $time % 60;

  $days = $days < 1 ? '' : $days .'d ';
  $hours = $hours < 1 ? '' : $hours .'h ';
  $minutes = $minutes < 1 ? '' : $minutes . 'm ';
  $seconds = $minutes ne '' ? '' : $seconds . 's';
  $time = ($days . $hours . $minutes . $seconds) || '0s' ;
  return $time;
}
1;
