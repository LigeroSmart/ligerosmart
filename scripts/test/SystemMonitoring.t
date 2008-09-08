# --
# SystemMonitoring.t - SystemMonitoring tests
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: SystemMonitoring.t,v 1.1 2008-09-08 22:47:16 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

use Kernel::System::Ticket;
use Kernel::System::PostMaster;

my $FileArray = $Self->{MainObject}->FileRead(
    Location  => $Self->{ConfigObject}->Get('Home') . '/scripts/test/sample/SystemMonitoring1.box',
    Result    => 'ARRAY', # optional - SCALAR|ARRAY
);

my $PostMasterObject = Kernel::System::PostMaster->new(
    %{$Self},
    Email => $FileArray,
);

my @Return = $PostMasterObject->Run();
$Self->Is(
    $Return[0] || 0,
    1,
    "Run() - NewTicket",
);
$Self->True(
    $Return[1] || 0,
    "Run() - NewTicket/TicketID",
);

my $TicketObject = Kernel::System::Ticket->new( %{$Self} );
my %Ticket = $TicketObject->TicketGet(
    TicketID => $Return[1],
);

$Self->Is(
    $Ticket{TicketFreeText1},
    'delphin',
    "Host check",
);

$Self->Is(
    $Ticket{TicketFreeText2},
    'Host',
    "Service check",
);
$Self->Is(
    $Ticket{State},
    'new',
    "Run() - Ticket State",
);

$FileArray = $Self->{MainObject}->FileRead(
    Location  => $Self->{ConfigObject}->Get('Home') . '/scripts/test/sample/SystemMonitoring2.box',
    Result    => 'ARRAY', # optional - SCALAR|ARRAY
);

$PostMasterObject = Kernel::System::PostMaster->new(
    %{$Self},
    Email => $FileArray,
);

@Return = $PostMasterObject->Run();
$Self->Is(
    $Return[0] || 0,
    2,
    "Run() - NewTicket",
);
$Self->True(
    $Return[1] == $Ticket{TicketID},
    "Run() - NewTicket/TicketID",
);

$TicketObject = Kernel::System::Ticket->new( %{$Self} );
%Ticket = $TicketObject->TicketGet(
    TicketID => $Return[1],
);
$Self->Is(
    $Ticket{State},
    'closed successful',
    "Run() - Ticket State",
);

# delete ticket
my $Delete = $TicketObject->TicketDelete(
    TicketID => $Return[1],
    UserID   => 1,
);
$Self->True(
    $Delete || 0,
    "TicketDelete()",
);

1;
