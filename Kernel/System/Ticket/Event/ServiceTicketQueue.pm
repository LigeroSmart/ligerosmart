# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::Event::ServiceTicketQueue;

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
        DynamicFields => 1,
    );

	if(!$Ticket{ServiceID}){
		return;
	}
	
	my %Preferences = $Kernel::OM->Get('Kernel::System::Service')->ServicePreferencesGet(
	   ServiceID => $Ticket{ServiceID},
	   UserID    => 1,
	);

	if(!$Preferences{TicketQueue}){
		return;
	}
	
	if($Preferences{TicketQueue} eq '0-Expression'){
		# get needed objects
		my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
		my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
    
        # replace ticket attributes such as <OTRS_Ticket_DynamicField_Name1> or
        # <OTRS_TICKET_DynamicField_Name1>
        my $Count = 0;
        REPLACEMENT:
        while (
            $Preferences{TicketQueueExpression}
            && $Preferences{TicketQueueExpression} =~ m{<OTRS_TICKET_([A-Za-z0-9_]+)>}msxi
            && $Count++ < 1000
            )
        {
            my $TicketAttribute = $1;

            if ( $TicketAttribute =~ m{DynamicField_(\S+?)_Value} ) {
                my $DynamicFieldName = $1;

                my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
                    Name => $DynamicFieldName,
                );
                next REPLACEMENT if !$DynamicFieldConfig;

                my $DisplayValueStrg = $DynamicFieldBackendObject->ReadableValueRender(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    Value              => $Ticket{"DynamicField_$DynamicFieldName"},
                );

                $Preferences{TicketQueueExpression}
                    =~ s{<OTRS_TICKET_$TicketAttribute>}{$DisplayValueStrg->{Value} // ''}ige;

                next REPLACEMENT;
            }

            # if ticket value is scalar substitute all instances (as strings)
            # this will allow replacements for "<OTRS_TICKET_Title> <OTRS_TICKET_Queue"
            if ( !ref $Ticket{$TicketAttribute} ) {
                $Preferences{TicketQueueExpression}
                    =~ s{<OTRS_TICKET_$TicketAttribute>}{$Ticket{$TicketAttribute} // ''}ige;
            }
            else {

                # if the vale is an array (e.g. a multiselect dynamic field) set the value directly
                # this unfortunately will not let a combination of values to be replaced
                $Preferences{TicketQueueExpression} = $Ticket{$TicketAttribute};
            }
        }
		my $QueueID = $Kernel::OM->Get('Kernel::System::Queue')->QueueLookup( Queue => $Preferences{TicketQueueExpression} )||0;

		if(!$QueueID){
			return;
		} else {
			$Preferences{TicketQueue} = $QueueID;
		}

	} 

	my $Success = $Kernel::OM->Get('Kernel::System::Ticket')->TicketQueueSet(
	   QueueID   => $Preferences{TicketQueue},
	   TicketID => $Param{Data}->{TicketID},
	   UserID   => $Param{UserID},
	);

    return 1;
}

1;
