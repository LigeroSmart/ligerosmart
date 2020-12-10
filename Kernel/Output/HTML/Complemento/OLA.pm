# --
# Kernel/Output/HTML/OutputFilterMediaWiki.pm
# Copyright (C) 2011 - 2015 Complemento - Liberdade e Tecnologia http://www.complemento.net.br
# --
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::Complemento::OLA;


use strict;
use warnings;
use List::Util qw(first);
use HTTP::Status qw(:constants :is status_message);
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
	my $QueueObject = $Kernel::OM->Get("Kernel::System::Queue");	
	my $LayoutObject = $Kernel::OM->Get("Kernel::Output::HTML::Layout");
	my %ValidQueues = $QueueObject->GetAllQueues();
    $Data{Queue} = $LayoutObject->BuildSelection(
            Data          => \%ValidQueues,
            Name          => 'Queue',
            PossibleNone  => 1,
        );
	 my %NotifyLevelList = (
	        10 => '10%',
	        20 => '20%',
	        30 => '30%',
	        40 => '40%',
	        50 => '50%',
	        60 => '60%',
	        70 => '70%',
	        80 => '80%',
	        90 => '90%',
	    );
	 $Data{UpdateNotifyOptionStrg} = $LayoutObject->BuildSelection(
        Data         => \%NotifyLevelList,
        Name         => 'UpdateNotify',
        SelectedID   => '',
        Translation  => 0,
        PossibleNone => 1,
    );

    my %Calendar = ( '' => '-' );

    my $Maximum = $ConfigObject->Get("MaximumCalendarNumber") || 50;

    for my $CalendarNumber ( '', 1 .. $Maximum ) {
        if ( $ConfigObject->Get("TimeVacationDays::Calendar$CalendarNumber") ) {
            $Calendar{$CalendarNumber} = "Calendar $CalendarNumber - "
                . $ConfigObject->Get( "TimeZone::Calendar" . $CalendarNumber . "Name" );
        }
    }

	 $Data{CalendarOptionStrg} = $LayoutObject->BuildSelection(
        Data         => \%Calendar,
        Name         => 'Calendar',
        SelectedID   => '',
        Translation  => 0,
        PossibleNone => 1,
    );

	my $iFrame = $LayoutObject->Output(
    	    TemplateFile => 'OutputFilter.Complemento.OLA',
	        Data         => \%Data,
    	);
	my $NewHTML = $iFrame.'<div class="Field SpacingTop">';
	${ $Param{Data} } =~ s/<div class="Field SpacingTop">/$NewHTML/
	
#	${ $Param{Data} } .= $iFrame ;  
#	}
}
1;
