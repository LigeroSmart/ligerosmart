# --
# --
package Kernel::System::GenericAgent::DayTimerProcessTransition;

use strict;
use warnings;
use CGI ":standard";
use URI;
use URI::QueryParam;
use POSIX;
use Data::Dumper;
use Kernel::System::DynamicField;
use Kernel::System::DynamicField::Backend;

# use Kernel::System::Priority;

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicFieldBackend',
    'Kernel::System::DynamicFieldValue',
    'Kernel::System::Ticket',
    'Kernel::System::Time',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{DynamicFieldObject}         = $Kernel::OM->Get('Kernel::System::DynamicField');
    $Self->{LogObject}                  = $Kernel::OM->Get('Kernel::System::Log');
    $Self->{TimeObject}                 = $Kernel::OM->Get('Kernel::System::Time');
    $Self->{TicketObject}               = $Kernel::OM->Get('Kernel::System::Ticket');
    $Self->{DynamicFieldBackendObject}  = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # 0=off; 1=on;
    $Self->{Debug} = $Param{Debug} || 0;

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $DynamicFieldValueObject = $Kernel::OM->Get('Kernel::System::DynamicFieldValue');

    # Input Parameters
    # - Days
    # - ProcessActivityID

    my $Days;
    if($Param{New}->{'Days'}){
      $Days = $Param{New}->{'Days'};
    } else {
        return 1;
    }

    my $ProcessActivityID;
    if($Param{New}->{'ProcessActivityID'}){
      $ProcessActivityID = $Param{New}->{'ProcessActivityID'};
    } else {
        return 1;
    }
    

    my $TemplateGeneratorObject = $Kernel::OM->Get('Kernel::System::TemplateGenerator');
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my $LinkObject = $Kernel::OM->Get('Kernel::System::LinkObject');

    my %Ticket = $TicketObject->TicketGet(
            TicketID      => $Param{TicketID},
            DynamicFields => 1,
            UserID        => 1,
        );

    # create datetime object
    my $NowObj = $Kernel::OM->Create('Kernel::System::DateTime');

    my $TicketCreatedObj = $NowObj->Clone();
    $TicketCreatedObj->Set(
        String => $Ticket{Created}
    );

    my $LinkDate = $LinkObject->GetLastTicketLinkDate( ObjectID => $Param{TicketID} );

    if($LinkDate){
        $TicketCreatedObj->Set(
            String => $LinkDate
        );
    }

    my $DeltaObj = $TicketCreatedObj->Delta(
        DateTimeObject => $NowObj,
    );

    return if ($DeltaObj->{Days} < $Days);    

    my $DFActivity = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
        Name => 'ProcessManagementActivityID',
    );
    my $Success = $Kernel::OM->Get('Kernel::System::DynamicField::Backend')->ValueSet(
      DynamicFieldConfig	=> $DFActivity,
      ObjectID			=> $Param{TicketID}, 
      Value				=> $ProcessActivityID || '',
      UserID				=> 1,
    );

    $TicketObject->EventHandler(
        Event => 'TicketDynamicFieldUpdate_ProcessManagementActivityID',
        Data  => {
            FieldName => 'ProcessManagementActivityID',
            Value     => $ProcessActivityID,
            OldValue  => '',
            TicketID  => $Param{TicketID},
            UserID    => 1,
        },
        UserID => 1,
    );

    my $Success=1;

    return $Success;
}

1;