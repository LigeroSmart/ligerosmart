
package Kernel::System::Ticket::Event::TicketKeyGenerator;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Digest::MD5 qw(md5 md5_hex md5_base64);



our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::Log',
    'Kernel::System::Ticket',
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
    for my $Needed (qw(Data Event Config UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # listen to all kinds of events
    if ( !$Param{Data}->{TicketID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need TicketID in Data!",
        );
        return;
    }

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # get ticket data in silent mode, it could be that the ticket was deleted
    # in the meantime
    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Param{Data}->{TicketID},
        DynamicFields => 1,
        Silent        => 1,
    );

    return if ( !%Ticket );

    # get dynamic field objects
    my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # get the dynamic fields
    my $DynamicField = $DynamicFieldObject->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => ['Ticket'],
	FieldFilter => { TicketKey => 1 }
    );

    # create a lookup table by name (since name is unique)
    my %DynamicFieldLookup;
    DYNAMICFIELD:
    for my $DynamicField ( @{$DynamicField} ) {
        next DYNAMICFIELD if !$DynamicField->{Name};
        $DynamicFieldLookup{ $DynamicField->{Name} } = $DynamicField;
    }

    # do not set default dynamic field if already set
    return if $Ticket{ 'DynamicField_TicketKey' };

    # check if field is defined and valid
    return if !$DynamicFieldLookup{ 'TicketKey' };

    # get dynamic field config
    my $DynamicFieldConfig = $DynamicFieldLookup{ 'TicketKey' };

    # set the value
    my $keyValue = md5_hex($Param{Data}->{TicketID});
    my $Success  = $DynamicFieldBackendObject->ValueSet(
        DynamicFieldConfig => $DynamicFieldConfig,
        ObjectID           => $Param{Data}->{TicketID},
        Value              => $keyValue,
        UserID             => $Param{UserID},
    );

    if ( !$Success ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can not set value $keyValue for dynamic field TicketKey!"
        );
    }
    return 1;
}

1;