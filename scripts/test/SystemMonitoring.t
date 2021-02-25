# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;

use vars qw($Self);

use Kernel::System::PostMaster;

# add or update dynamic fields if needed
my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

my @DynamicfieldIDs;
my @DynamicFieldUpdate;
my %NeededDynamicfields = (
    TicketFreeText1  => 1,
    TicketFreeText2  => 1,
    ArticleFreeText1 => 1,
);

# list available dynamic fields
my $DynamicFields = $DynamicFieldObject->DynamicFieldList(
    Valid      => 0,
    ResultType => 'HASH',
);
$DynamicFields = ( ref $DynamicFields eq 'HASH' ? $DynamicFields : {} );
$DynamicFields = { reverse %{$DynamicFields} };

for my $FieldName ( sort keys %NeededDynamicfields ) {
    if ( !$DynamicFields->{$FieldName} ) {

        # create a dynamic field
        my $FieldID = $DynamicFieldObject->DynamicFieldAdd(
            Name       => $FieldName,
            Label      => $FieldName . "_test",
            FieldOrder => 9991,
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            Config     => {
                DefaultValue => 'a value',
            },
            ValidID => 1,
            UserID  => 1,
        );

        # verify dynamic field creation
        $Self->True(
            $FieldID,
            "DynamicFieldAdd() successful for Field $FieldName",
        );

        push @DynamicfieldIDs, $FieldID;
    }
    else {
        my $DynamicField = $DynamicFieldObject->DynamicFieldGet( ID => $DynamicFields->{$FieldName} );

        if ( $DynamicField->{ValidID} > 1 ) {
            push @DynamicFieldUpdate, $DynamicField;
            $DynamicField->{ValidID} = 1;
            my $SuccessUpdate = $DynamicFieldObject->DynamicFieldUpdate(
                %{$DynamicField},
                Reorder => 0,
                UserID  => 1,
                ValidID => 1,
            );

            # verify dynamic field creation
            $Self->True(
                $SuccessUpdate,
                "DynamicFieldUpdate() successful update for Field $DynamicField->{Name}",
            );
        }
    }
}

# get needed objects
my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

my $FileArray = $MainObject->FileRead(
    Location => $ConfigObject->Get('Home') . '/scripts/test/sample/SystemMonitoring1.box',
    Result   => 'ARRAY',                                                                     # optional - SCALAR|ARRAY
);

my $CommunicationLogObject = $Kernel::OM->Create(
    'Kernel::System::CommunicationLog',
    ObjectParams => {
        Transport => 'Email',
        Direction => 'Incoming',
    },
);
$CommunicationLogObject->ObjectLogStart( ObjectLogType => 'Message' );

my $PostMasterObject = Kernel::System::PostMaster->new(
    %{$Self},
    Email                  => $FileArray,
    CommunicationLogObject => $CommunicationLogObject,
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

$CommunicationLogObject->ObjectLogStop(
    ObjectLogType => 'Message',
    Status        => 'Successful',
);
$CommunicationLogObject->CommunicationStop(
    Status => 'Successful',
);

my $TicketObject = Kernel::System::Ticket->new( %{$Self} );
my %Ticket       = $TicketObject->TicketGet(
    TicketID      => $Return[1],
    DynamicFields => 1,
);

$Self->Is(
    $Ticket{DynamicField_TicketFreeText1},
    'delphin',
    "Host check",
);

$Self->Is(
    $Ticket{DynamicField_TicketFreeText2},
    'Host',
    "Service check",
);
$Self->Is(
    $Ticket{State},
    'new',
    "Run() - Ticket State",
);

$FileArray = $MainObject->FileRead(
    Location => $ConfigObject->Get('Home') . '/scripts/test/sample/SystemMonitoring2.box',
    Result   => 'ARRAY',                                                                     # optional - SCALAR|ARRAY
);

my $CommunicationLogObject2 = $Kernel::OM->Create(
    'Kernel::System::CommunicationLog',
    ObjectParams => {
        Transport => 'Email',
        Direction => 'Incoming',
    },
);
$CommunicationLogObject2->ObjectLogStart( ObjectLogType => 'Message' );

$PostMasterObject = Kernel::System::PostMaster->new(
    %{$Self},
    Email                  => $FileArray,
    CommunicationLogObject => $CommunicationLogObject2,
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

$CommunicationLogObject2->ObjectLogStop(
    ObjectLogType => 'Message',
    Status        => 'Successful',
);
$CommunicationLogObject2->CommunicationStop(
    Status => 'Successful',
);

# get ticket object
$TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
%Ticket       = $TicketObject->TicketGet(
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

# revert changes to dynamic fields
for my $DynamicField (@DynamicFieldUpdate) {
    my $SuccessUpdate = $DynamicFieldObject->DynamicFieldUpdate(
        Reorder => 0,
        UserID  => 1,
        %{$DynamicField},
    );
    $Self->True(
        $SuccessUpdate,
        "Reverted changes on ValidID for $DynamicField->{Name} field.",
    );
}

for my $DynamicFieldID (@DynamicfieldIDs) {

    # delete the dynamic field
    my $FieldDelete = $DynamicFieldObject->DynamicFieldDelete(
        ID     => $DynamicFieldID,
        UserID => 1,
    );
    $Self->True(
        $FieldDelete,
        "Deleted dynamic field with id $DynamicFieldID.",
    );
}

1;
