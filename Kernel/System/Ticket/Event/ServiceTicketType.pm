# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::Event::ServiceTicketType;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::Ticket',
    'Kernel::System::Service',
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

    # check needed stuff
    for (qw(Data Event Config UserID)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }
    for (qw(TicketID)) {
        if ( !$Param{Data}->{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_ in Data!"
            );
            return;
        }
    }

    my %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
        TicketID      => $Param{Data}->{TicketID},
        DynamicFields => 0,
    );

	if(!$Ticket{ServiceID}){
		return;
	}
	
	my %Preferences = $Kernel::OM->Get('Kernel::System::Service')->ServicePreferencesGet(
	   ServiceID => $Ticket{ServiceID},
	   UserID    => 1,
	);

	if(!$Preferences{TicketType}){
		return;
	}
	
	my $Success = $Kernel::OM->Get('Kernel::System::Ticket')->TicketTypeSet(
       TypeID   => $Preferences{TicketType},
       TicketID => $Param{Data}->{TicketID},
       UserID   => $Param{UserID},
    );

    return 1;
}

1;
