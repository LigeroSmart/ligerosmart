# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

# start RestoreDatabse
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# ------------------------------------------------------------ #
# make preparations
# ------------------------------------------------------------ #

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# enable config MasterSlave::ForwardSlaves
$ConfigObject->Set(
    Key   => 'MasterSlave::ForwardSlaves',
    Value => 1,
);
$ConfigObject->Set(
    Key   => 'CheckMXRecord',
    Value => 0,
);
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);
$ConfigObject->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::DoNotSendEmail',
);

my $RandomID = $HelperObject->GetRandomID();

my $DynamicFieldObject          = $Kernel::OM->Get('Kernel::System::DynamicField');
my $MasterSlaveDynamicField     = $ConfigObject->Get('MasterSlave::DynamicField');
my $MasterSlaveDynamicFieldData = $DynamicFieldObject->DynamicFieldGet(
    Name => $MasterSlaveDynamicField,
);

# Create new user.
my $TestUserLogin = $HelperObject->TestUserCreate(
    Groups   => [ 'admin', 'users' ],
    Language => 'en'
);
$Self->True(
    $TestUserLogin,
    "UserAdd() $TestUserLogin",
);

# Create new customer users.
my $TestCustomerUserLogin1 = $HelperObject->TestCustomerUserCreate(
    Language => 'en',
);
$Self->True(
    $TestCustomerUserLogin1,
    "CustomerUserAdd() $TestCustomerUserLogin1",
);

my $TestCustomerUserLogin2 = $HelperObject->TestCustomerUserCreate(
    Language => 'en',
);
$Self->True(
    $TestCustomerUserLogin2,
    "CustomerUserAdd() $TestCustomerUserLogin2",
);

my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

# Create first test ticket.
my $MasterTicketNumber = $TicketObject->TicketCreateNumber();
my $MasterTicketID     = $TicketObject->TicketCreate(
    TN           => $MasterTicketNumber,
    Title        => 'Master unit test ticket ' . $RandomID,
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerNo   => $TestCustomerUserLogin1,
    CustomerUser => $TestCustomerUserLogin1,
    ,
    OwnerID => 1,
    UserID  => 1,
);
$Self->True(
    $MasterTicketID,
    "TicketCreate() Ticket ID $MasterTicketID",
);

my $EmailBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
    ChannelName => 'Email',
);

# Create article for test ticket.
my $ArticleID = $EmailBackendObject->ArticleCreate(
    TicketID             => $MasterTicketID,
    From                 => 'root@localhost',
    To                   => 'test@examples.com',
    IsVisibleForCustomer => 1,
    SenderType           => 'agent',
    Subject              => 'Master Article',
    Body                 => "Unit test MasterTicket $TestCustomerUserLogin1 $TestCustomerUserLogin1",
    ContentType          => 'text/plain; charset=ISO-8859-15',
    HistoryType          => 'EmailCustomer',
    HistoryComment       => 'Unit test article',
    UserID               => 1,
);
$Self->True(
    $ArticleID,
    "ArticleCreate() Article ID $ArticleID",
);

my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
    ID => $MasterSlaveDynamicFieldData->{ID},
);

my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

# Set test ticket as master ticket.
my $Success = $DynamicFieldBackendObject->ValueSet(
    DynamicFieldConfig => $DynamicField,
    ObjectID           => $MasterTicketID,
    Value              => 'Master',
    UserID             => 1,
);
$Self->True(
    $Success,
    "ValueSet() Ticket ID $MasterTicketID DynamicField $MasterSlaveDynamicField updated as MasterTicket",
);

# Create second test ticket.
my $SlaveTicketNumber = $TicketObject->TicketCreateNumber();
my $SlaveTicketID     = $TicketObject->TicketCreate(
    TN           => $SlaveTicketNumber,
    Title        => 'Slave unit test ticket ' . $RandomID,
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => $TestCustomerUserLogin2,
    CustomerUser => $TestCustomerUserLogin2,
    OwnerID      => 1,
    UserID       => 1,
);
$Self->True(
    $SlaveTicketID,
    "TicketCreate() Ticket ID $SlaveTicketID",
);

# Set test ticket as slave of master ticket.
$Success = $DynamicFieldBackendObject->ValueSet(
    DynamicFieldConfig => $DynamicField,
    ObjectID           => $SlaveTicketID,
    Value              => "SlaveOf:$MasterTicketNumber",
    UserID             => 1,
);
$Self->True(
    $Success,
    "ValueSet() Ticket ID $SlaveTicketID DynamicField $MasterSlaveDynamicField updated as SlaveTicket",
);

my $EventObject = $Kernel::OM->Get('Kernel::System::Ticket::Event::MasterSlave');

my @Tests = (
    {
        Name           => 'Do not replace',
        EffectiveValue => {
            Email => 0,
        },
        Match => "$TestCustomerUserLogin1 $TestCustomerUserLogin1",
    },
    {
        Name           => 'Customer replace',
        EffectiveValue => {
            Email => 1,
        },
        Match => "$TestCustomerUserLogin2 $TestCustomerUserLogin2",
    },
);

my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

TEST:
for my $Test (@Tests) {
    $ConfigObject->Set(
        Key   => 'ReplaceCustomerRealNameOnSlaveArticleCommunicationChannels',
        Value => $Test->{EffectiveValue},
    );
    my $Success = $EventObject->Run(
        Event => 'ArticleSend',
        Data  => {
            TicketID => $MasterTicketID,
        },
        Config => {},
        UserID => 1,
    );
    $Self->True(
        $Success,
        "$Test->{Name} - ArticleSend event executed correctly",
    );

    my @Articles = $ArticleObject->ArticleList(
        TicketID => $SlaveTicketID,
    );

    my $ArticleBackendObject = $ArticleObject->BackendForArticle(
        TicketID  => $Articles[-1]->{TicketID},
        ArticleID => $Articles[-1]->{ArticleID},
    );

    my %Article = $ArticleBackendObject->ArticleGet(
        TicketID  => $Articles[-1]->{TicketID},
        ArticleID => $Articles[-1]->{ArticleID},
    );

    my $MatchSuccess = $Article{Body} =~ m{$Test->{Match}} // 0;

    $Self->True(
        $MatchSuccess,
        "$Test->{Name} - New article body matched customer real name: '$Test->{Match}'",
    );
}

1;
