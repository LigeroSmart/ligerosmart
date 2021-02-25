# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));
use Kernel::System::VariableCheck qw(IsHashRefWithData);

# get needed objects
my $TicketObject              = $Kernel::OM->Get('Kernel::System::Ticket');
my $LinkObject                = $Kernel::OM->Get('Kernel::System::LinkObject');
my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
my $ConfigObject              = $Kernel::OM->Get('Kernel::Config');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# ------------------------------------------------------------ #
# make preparations
# ------------------------------------------------------------ #

# get master/slave dynamic field data
my $MasterSlaveDynamicField     = $ConfigObject->Get('MasterSlave::DynamicField');
my $MasterSlaveDynamicFieldData = $DynamicFieldObject->DynamicFieldGet(
    Name => $MasterSlaveDynamicField,
);

# get random ID
my $RandomID = $HelperObject->GetRandomID();

# create test tickets
my @TicketIDs;
my @TicketNumbers;
for my $Ticket ( 1 .. 3 ) {
    my $TicketNumber = $TicketObject->TicketCreateNumber();
    my $TicketID     = $TicketObject->TicketCreate(
        TN           => $TicketNumber,
        Title        => 'Unit test ticket ' . $RandomID . ' ' . $Ticket,
        Queue        => 'Raw',
        Lock         => 'unlock',
        Priority     => '3 normal',
        State        => 'new',
        CustomerNo   => '123465',
        CustomerUser => 'customer@example.com',
        OwnerID      => 1,
        UserID       => 1,
    );
    $Self->True(
        $TicketID,
        "TicketCreate() Ticket ID $TicketID - TN: $TicketNumber",
    );
    push @TicketIDs,     $TicketID;
    push @TicketNumbers, $TicketNumber;
}

# ------------------------------------------------------------ #
# test master/slave ticket value set
# ------------------------------------------------------------ #

# set first test ticket as master ticket
my $Success = $DynamicFieldBackendObject->ValueSet(
    DynamicFieldConfig => $MasterSlaveDynamicFieldData,
    FieldID            => $MasterSlaveDynamicFieldData->{ID},
    ObjectID           => $TicketIDs[0],
    Value              => 'Master',
    UserID             => 1,
);
$Self->True(
    $Success,
    "ValueSet() Ticket ID $TicketIDs[0] DynamicField $MasterSlaveDynamicField updated as MasterTicket",
);

# set second test ticket as slave ticket
$Success = $DynamicFieldBackendObject->ValueSet(
    DynamicFieldConfig => $MasterSlaveDynamicFieldData,
    FieldID            => $MasterSlaveDynamicFieldData->{ID},
    ObjectID           => $TicketIDs[1],
    Value              => "SlaveOf:$TicketNumbers[0]",
    UserID             => 1,
);
$Self->True(
    $Success,
    "ValueSet() Ticket ID $TicketIDs[1] DynamicField $MasterSlaveDynamicField updated as SlaveOf:$TicketNumbers[0]",
);

# verify there is parent-child link between master/slave tickets
my %LinkKeyList = $LinkObject->LinkKeyList(
    Object1   => 'Ticket',
    Key1      => $TicketIDs[0],
    Object2   => 'Ticket',
    State     => 'Valid',
    Type      => 'ParentChild',
    Direction => 'Both',
    UserID    => 1,
);

$Self->True(
    IsHashRefWithData( \%LinkKeyList ) ? 1 : 0,
    "LinkKeyList() Master/Slave link found - Ticket ID $TicketIDs[0] and $TicketIDs[1]",
);

# ------------------------------------------------------------ #
# test UnsetMaster|UnsetSlave
# ------------------------------------------------------------ #

# enable the MasterSlave::KeepParentChildAfterUnset sysconfig
$Success = $ConfigObject->Set(
    Key   => 'MasterSlave::KeepParentChildAfterUnset',
    Value => 1
);
$Self->True(
    $Success,
    "Set() sysconfig KeepParentChildAfterUnset - enabled",
);

# set second ticket as slave ticket again
$Success = $DynamicFieldBackendObject->ValueSet(
    DynamicFieldConfig => $MasterSlaveDynamicFieldData,
    FieldID            => $MasterSlaveDynamicFieldData->{ID},
    ObjectID           => $TicketIDs[1],
    Value              => "SlaveOf:$TicketNumbers[0]",
    UserID             => 1,
);
$Self->True(
    $Success,
    "ValueSet() Ticket ID $TicketIDs[1] DynamicField $MasterSlaveDynamicField updated again as SlaveOf:$TicketNumbers[0]",
);

# verify there is parent-child link between master/slave tickets
%LinkKeyList = $LinkObject->LinkKeyList(
    Object1   => 'Ticket',
    Key1      => $TicketIDs[0],
    Object2   => 'Ticket',
    State     => 'Valid',
    Type      => 'ParentChild',
    Direction => 'Target',
    UserID    => 1,
);
$Self->True(
    IsHashRefWithData( \%LinkKeyList ) ? 1 : 0,
    "LinkKeyList() Master/Slave link found - Ticket ID $TicketIDs[0] and $TicketIDs[1]",
);

# UnsetMaster value from first ticket
$Success = $DynamicFieldBackendObject->ValueSet(
    DynamicFieldConfig => $MasterSlaveDynamicFieldData,
    FieldID            => $MasterSlaveDynamicFieldData->{ID},
    ObjectID           => $TicketIDs[0],
    Value              => 'UnsetMaster',
    UserID             => 1,
);
$Self->True(
    $Success,
    "ValueSet() Ticket ID $TicketIDs[0] DynamicField $MasterSlaveDynamicField updated as UnsetMaster",
);

# UnsetSlave value from second ticket
$Success = $DynamicFieldBackendObject->ValueSet(
    DynamicFieldConfig => $MasterSlaveDynamicFieldData,
    FieldID            => $MasterSlaveDynamicFieldData->{ID},
    ObjectID           => $TicketIDs[1],
    Value              => 'UnsetSlave',
    UserID             => 1,
);
$Self->True(
    $Success,
    "ValueSet() Ticket ID $TicketIDs[1] DynamicField $MasterSlaveDynamicField updated as UnsetSlave",
);

# verify there is still parent-child link between two tickets
%LinkKeyList = $LinkObject->LinkKeyList(
    Object1   => 'Ticket',
    Key1      => $TicketIDs[0],
    Object2   => 'Ticket',
    State     => 'Valid',
    Type      => 'ParentChild',
    Direction => 'Target',
    UserID    => 1,
);
$Self->True(
    IsHashRefWithData( \%LinkKeyList ) ? 1 : 0,
    "LinkKeyList() Master/Slave link found - Ticket ID $TicketIDs[0] and $TicketIDs[1] - KeepParentChildAfterUnset sysconfig enabled",
);

# disable the MasterSlave::KeepParentChildAfterUnset sysconfig
$Success = $ConfigObject->Set(
    Key   => 'MasterSlave::KeepParentChildAfterUnset',
    Value => 0
);
$Self->True(
    $Success,
    "Set() sysconfig KeepParentChildAfterUnset - disabled",
);

# remove parent-child link between two tickets
$Success = $LinkObject->LinkDeleteAll(
    Object => 'Ticket',
    Key    => $TicketIDs[0],
    UserID => 1,
);
$Self->True(
    $Success,
    "LinkDeleteAll() parent-child link for ticket ID $TicketIDs[0] - removed",
);

# set first test ticket as master ticket
$Success = $DynamicFieldBackendObject->ValueSet(
    DynamicFieldConfig => $MasterSlaveDynamicFieldData,
    FieldID            => $MasterSlaveDynamicFieldData->{ID},
    ObjectID           => $TicketIDs[0],
    Value              => 'Master',
    UserID             => 1,
);
$Self->True(
    $Success,
    "ValueSet() Ticket ID $TicketIDs[0] DynamicField $MasterSlaveDynamicField updated as MasterTicket",
);

# set second test ticket as slave ticket
$Success = $DynamicFieldBackendObject->ValueSet(
    DynamicFieldConfig => $MasterSlaveDynamicFieldData,
    FieldID            => $MasterSlaveDynamicFieldData->{ID},
    ObjectID           => $TicketIDs[1],
    Value              => "SlaveOf:$TicketNumbers[0]",
    UserID             => 1,
);
$Self->True(
    $Success,
    "ValueSet() Ticket ID $TicketIDs[1] DynamicField $MasterSlaveDynamicField updated as SlaveOf:$TicketNumbers[0]",
);

# verify there is still parent-child link between two tickets
%LinkKeyList = $LinkObject->LinkKeyList(
    Object1   => 'Ticket',
    Key1      => $TicketIDs[0],
    Object2   => 'Ticket',
    State     => 'Valid',
    Type      => 'ParentChild',
    Direction => 'Target',
    UserID    => 1,
);
$Self->True(
    IsHashRefWithData( \%LinkKeyList ) ? 1 : 0,
    "LinkKeyList() Master/Slave link found - Ticket ID $TicketIDs[0] and $TicketIDs[1]",
);

# UnsetMaster value from first ticket
$Success = $DynamicFieldBackendObject->ValueSet(
    DynamicFieldConfig => $MasterSlaveDynamicFieldData,
    FieldID            => $MasterSlaveDynamicFieldData->{ID},
    ObjectID           => $TicketIDs[0],
    Value              => 'UnsetMaster',
    UserID             => 1,
);
$Self->True(
    $Success,
    "ValueSet() Ticket ID $TicketIDs[0] DynamicField $MasterSlaveDynamicField updated as UnsetMaster",
);

# UnsetSlave value from second ticket
$Success = $DynamicFieldBackendObject->ValueSet(
    DynamicFieldConfig => $MasterSlaveDynamicFieldData,
    FieldID            => $MasterSlaveDynamicFieldData->{ID},
    ObjectID           => $TicketIDs[1],
    Value              => 'UnsetSlave',
    UserID             => 1,
);
$Self->True(
    $Success,
    "ValueSet() Ticket ID $TicketIDs[1] DynamicField $MasterSlaveDynamicField updated as UnsetSlave",
);

# verify there is no more parent-child link between two tickets
%LinkKeyList = $LinkObject->LinkKeyList(
    Object1   => 'Ticket',
    Key1      => $TicketIDs[0],
    Object2   => 'Ticket',
    State     => 'Valid',
    Type      => 'ParentChild',
    Direction => 'Target',
    UserID    => 1,
);
$Self->True(
    !IsHashRefWithData( \%LinkKeyList ),
    "LinkKeyList() Master/Slave link removed - Ticket ID $TicketIDs[0] and $TicketIDs[1] - KeepParentChildAfterUnset sysconfig disabled",
);

# ------------------------------------------------------------ #
# test update Master|Slave field
# ------------------------------------------------------------ #

# enable the MasterSlave::KeepParentChildAfterUpdate sysconfig
$Success = $ConfigObject->Set(
    Key   => 'MasterSlave::KeepParentChildAfterUpdate',
    Value => 1
);
$Self->True(
    $Success,
    "Set() sysconfig KeepParentChildAfterUpdate - enabled",
);

# set first test ticket as master ticket
$Success = $DynamicFieldBackendObject->ValueSet(
    DynamicFieldConfig => $MasterSlaveDynamicFieldData,
    FieldID            => $MasterSlaveDynamicFieldData->{ID},
    ObjectID           => $TicketIDs[0],
    Value              => 'Master',
    UserID             => 1,
);
$Self->True(
    $Success,
    "ValueSet() Ticket ID $TicketIDs[0] DynamicField $MasterSlaveDynamicField updated as MasterTicket",
);

# set second test ticket as master ticket
$Success = $DynamicFieldBackendObject->ValueSet(
    DynamicFieldConfig => $MasterSlaveDynamicFieldData,
    FieldID            => $MasterSlaveDynamicFieldData->{ID},
    ObjectID           => $TicketIDs[1],
    Value              => "Master",
    UserID             => 1,
);
$Self->True(
    $Success,
    "ValueSet() Ticket ID $TicketIDs[1] DynamicField $MasterSlaveDynamicField updated as MasterTicket",
);

# set third test ticket as slave of second ticket
$Success = $DynamicFieldBackendObject->ValueSet(
    DynamicFieldConfig => $MasterSlaveDynamicFieldData,
    FieldID            => $MasterSlaveDynamicFieldData->{ID},
    ObjectID           => $TicketIDs[2],
    Value              => "SlaveOf:$TicketNumbers[1]",
    UserID             => 1,
);
$Self->True(
    $Success,
    "ValueSet() Ticket ID $TicketIDs[2] DynamicField $MasterSlaveDynamicField updated as SlaveOf:$TicketNumbers[1]",
);

# verify there is parent-child link between two tickets
%LinkKeyList = $LinkObject->LinkKeyList(
    Object1   => 'Ticket',
    Key1      => $TicketIDs[1],
    Object2   => 'Ticket',
    State     => 'Valid',
    Type      => 'ParentChild',
    Direction => 'Target',
    UserID    => 1,
);
$Self->True(
    IsHashRefWithData( \%LinkKeyList ) ? 1 : 0,
    "LinkKeyList() Master/Slave link found - Ticket ID $TicketIDs[1] and $TicketIDs[2]",
);

# set second ticket as slave of first ticket
$Success = $DynamicFieldBackendObject->ValueSet(
    DynamicFieldConfig => $MasterSlaveDynamicFieldData,
    FieldID            => $MasterSlaveDynamicFieldData->{ID},
    ObjectID           => $TicketIDs[1],
    Value              => "SlaveOf:$TicketNumbers[0]",
    UserID             => 1,
);
$Self->True(
    $Success,
    "ValueSet() Ticket ID $TicketIDs[1] DynamicField $MasterSlaveDynamicField updated as SlaveOf:$TicketNumbers[0]",
);

# verify there parent-child-parent link between three tickets
%LinkKeyList = $LinkObject->LinkKeyList(
    Object1   => 'Ticket',
    Key1      => $TicketIDs[1],
    Object2   => 'Ticket',
    State     => 'Valid',
    Type      => 'ParentChild',
    Direction => 'Both',
    UserID    => 1,
);
$Self->True(
    IsHashRefWithData( \%LinkKeyList ),
    "LinkKeyList() Master/Slave link found - Ticket ID $TicketIDs[0], $TicketIDs[1] and $TicketIDs[2] - KeepParentChildAfterUpdate sysconfig enabled",
);

# Cleanup is done by RestoreDatabase.

1;
