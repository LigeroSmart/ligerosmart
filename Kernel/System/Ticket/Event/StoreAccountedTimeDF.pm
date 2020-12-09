# --
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::Event::StoreAccountedTimeDF;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::Log',
    'Kernel::System::Ticket',
    'Kernel::System::LinkObject',
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

    return if !$Param{Data}->{ArticleID};
    my $TicketID = $Param{Data}->{TicketID};
    if ( !$TicketID ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need TicketID",
        );
        return;
    }

    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    my $AccountedTimeInMin = $TicketObject->TicketAccountedTimeGet(TicketID => $TicketID) || 0;

    my $AccountedTime = '0:00';

    my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    my $DynamicFieldConfigAccountedTimeInMin = $DynamicFieldObject->DynamicFieldGet(
        Name => 'AccountedTimeInMin',
    );

    my $DynamicFieldConfigAccountedTime = $DynamicFieldObject->DynamicFieldGet(
        Name => 'AccountedTime',
    );

    if ($AccountedTimeInMin>0) {
        my $h = int($AccountedTimeInMin/60);
        my $m = $AccountedTimeInMin%60;
        $AccountedTime = sprintf "%02d:%02d",$h,$m;
    }

    $DynamicFieldBackendObject->ValueSet(
        DynamicFieldConfig => $DynamicFieldConfigAccountedTimeInMin,
        ObjectID           => $TicketID,
        Value              => $AccountedTimeInMin || '',
        UserID             => $Param{UserID} || 1,
    );

    $DynamicFieldBackendObject->ValueSet(
        DynamicFieldConfig => $DynamicFieldConfigAccountedTime,
        ObjectID           => $TicketID,
        Value              => $AccountedTime || '',
        UserID             => $Param{UserID} || 1,
    );

    my $UseCustomerContract = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Complemento::AccountedTime::UseCustomerContract');


    if($UseCustomerContract){
        $Kernel::OM->Get('Kernel::System::CustomerContract')->CalculateContract(
            TicketID  => $TicketID,
            ArticleID => $Param{Data}->{ArticleID},
            UserID => $Param{UserID}
        )
    }

    return 1;
}

1;
