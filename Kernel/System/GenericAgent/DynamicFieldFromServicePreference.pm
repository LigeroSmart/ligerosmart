package Kernel::System::GenericAgent::DynamicFieldFromServicePreference;

use strict;
use warnings;

use utf8;

use Data::Dumper;

use Kernel::System::VariableCheck (qw(:all));

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::Ticket',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # 0=off; 1=on;
    $Self->{Debug} = $Param{Debug} || 0;
    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get objects
    # my $DynamicFieldValueObject   = $Kernel::OM->Get('Kernel::System::DynamicFieldValue');
    my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
    my $ServiceObject             = $Kernel::OM->Get('Kernel::System::Service');
    my $TicketObject              = $Kernel::OM->Get('Kernel::System::Ticket');

    # my $ServiceDynamicField = $DynamicFieldObject->DynamicFieldGet(
    #     Name => $Param{New}->{ServiceFieldName},
    # );

    my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
        Name => $Param{New}->{DynamicFieldName},
    );

    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Param{TicketID} ,
        UserID        => 1,
    );

    return if !$Ticket{ServiceID};

	#### Get Service if Any
    my %Service;
	if($Ticket{ServiceID}){
		%Service = $Kernel::OM->Get('Kernel::System::Service')->ServicePreferencesGet(
			ServiceID => $Ticket{ServiceID},
			UserID    => 1,
		);
		my %ServiceData = $Kernel::OM->Get('Kernel::System::Service')->ServiceGet(
			ServiceID => $Ticket{ServiceID},
			UserID    => 1,
        );

        %Service = (%Service, %ServiceData);

        my $Value;

        if($Service{$Param{New}->{ServiceFieldName}}){
            $Value = $Service{$Param{New}->{ServiceFieldName}};
        }

        my $Success=0;

        if ($Value){
            $Success = $DynamicFieldBackendObject->ValueSet(
                DynamicFieldConfig  => $DynamicField,
                ObjectID => $Param{TicketID},
                Value    => $Value,
                UserID   => 1,
            );
        }
    } 

    return 1;
}

1;
