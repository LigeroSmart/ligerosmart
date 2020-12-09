# --
# Copyright (C) 2001-2016 Complemento - Liberdade e Tecnologia http://www.complemento.net.br
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::Ligero::ServiceCatalog::SidebarWidget::OpenTickets;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::Output::HTML::Layout',
    'Kernel::Language',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );
    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

	my $ServiceID = $Param{GetParam}->{ServiceID}||'';
	my $DefaultServiceID = $Param{GetParam}->{DefaultServiceID}||'';

	# Se não tiver Service ID (ou seja, não é pagina principal do catalogo), retorna)
	if($ServiceID && ($ServiceID ne $DefaultServiceID)){
		return '';
	}
	
	my $ParamConfig = $Param{ConfigItem};
	my $Limit = $ParamConfig->{Limit};

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
	
	
	my @TicketIDs = $TicketObject->TicketSearch(
       # result (required)
      Result => 'Array',
	  Limit  => $Limit,
	  CustomerUserID => $Param{UserID},
		StateType => 'Open',
	);

	# Se não encontrou nada, retorna
	if(!(scalar @TicketIDs>0)){
		return '';
	}

	my $Output='';
	foreach my $TicketID (@TicketIDs){
	my %Ticket = $TicketObject->TicketGet(
       TicketID      => $TicketID,
       DynamicFields => 0,         # Optional, default 0. To include the dynamic field values for this ticket on the return structure.
       UserID        => $Param{UserID},
       Silent        => 0,         # Optional, default 0. To suppress the warning if the ticket does not exist.
   );
		$LayoutObject->Block(
			Name => "OpenTicket",
			Data  => \%Ticket
		);
	}
	
    $Output = $LayoutObject->Output(
        TemplateFile => 'Ligero/ServiceCatalog/Sidebar/OpenTickets',
    );
    return $Output;
}

1;
