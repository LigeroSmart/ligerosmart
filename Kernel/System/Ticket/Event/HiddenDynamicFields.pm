# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::Event::HiddenDynamicFields;

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

    my $DynamicFieldsByService = $Kernel::OM->Get('Kernel::System::DynamicFieldByService')->GetDynamicFieldByService(ServiceID => $Ticket{ServiceID});


    if ($DynamicFieldsByService->{Config}){
        DIALOGFIELD:
            for my $CurrentField ( @{ $DynamicFieldsByService->{Config}{FieldOrder} } ) {
                my %FieldData = %{ $DynamicFieldsByService->{Config}{Fields}{$CurrentField} };

                next DIALOGFIELD if $FieldData{Display};

                if ( $CurrentField =~ m{^DynamicField_(.*)}xms ) {
                    my $DynamicFieldName = $1;

                    my $DF = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
                	    Name => $DynamicFieldName,
                    );

                    my $Success = $Kernel::OM->Get('Kernel::System::DynamicField::Backend')->ValueSet(
                        DynamicFieldConfig	=> $DF,
                        ObjectID			=> $Param{Data}->{TicketID}, 
                        Value				=> $FieldData{DefaultValue} || '',
                        UserID				=> 1,
                    );	
                }

                
        }
    }

    return 1;
}

1;