# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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

# get needed objects
my $TicketObject              = $Kernel::OM->Get('Kernel::System::Ticket');
my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
my $LinkObject                = $Kernel::OM->Get('Kernel::System::LinkObject');
my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
my $UserObject                = $Kernel::OM->Get('Kernel::System::User');
my $CustomerUserObject        = $Kernel::OM->Get('Kernel::System::CustomerUser');
my $ConfigObject              = $Kernel::OM->Get('Kernel::Config');

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

# get random ID
my $RandomID = $HelperObject->GetRandomID();

# get master/slave dynamic field data
my $MasterSlaveDynamicField     = $ConfigObject->Get('MasterSlave::DynamicField');
my $MasterSlaveDynamicFieldData = $DynamicFieldObject->DynamicFieldGet(
    Name => $MasterSlaveDynamicField,
);

# create new user
my $TestUserLogin = $HelperObject->TestUserCreate(
    Groups   => [ 'admin', 'users' ],
    Language => 'en'
);
$Self->True(
    $TestUserLogin,
    "UserAdd() $TestUserLogin",
);

# create new customer user
my $TestCustomerUserLogin = $HelperObject->TestCustomerUserCreate(
    Language => 'en',
);
$Self->True(
    $TestCustomerUserLogin,
    "CustomerUserAdd() $TestCustomerUserLogin",
);

# create first test ticket
my $MasterTicketNumber = $TicketObject->TicketCreateNumber();
my $MasterTicketID     = $TicketObject->TicketCreate(
    TN           => $MasterTicketNumber,
    Title        => 'Master unit test ticket ' . $RandomID,
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerNo   => $TestCustomerUserLogin,
    CustomerUser => $TestCustomerUserLogin,
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

# create article for test ticket
my $ArticleID = $EmailBackendObject->ArticleCreate(
    TicketID             => $MasterTicketID,
    IsVisibleForCustomer => 1,
    SenderType           => 'agent',
    Subject              => 'Master Article',
    Body                 => 'Unit test MasterTicket',
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

# set test ticket as master ticket
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

# create second test ticket
my $SlaveTicketNumber = $TicketObject->TicketCreateNumber();
my $SlaveTicketID     = $TicketObject->TicketCreate(
    TN           => $SlaveTicketNumber,
    Title        => 'Slave unit test ticket ' . $RandomID,
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => $TestCustomerUserLogin,
    CustomerUser => $TestCustomerUserLogin . '@localunittest.com',
    OwnerID      => 1,
    UserID       => 1,
);
$Self->True(
    $SlaveTicketID,
    "TicketCreate() Ticket ID $SlaveTicketID",
);
$Success = $DynamicFieldBackendObject->ValueSet(
    DynamicFieldConfig => $DynamicField,
    ObjectID           => $SlaveTicketID,
    Value              => "SlaveOf:$MasterTicketNumber",
    UserID             => 1,
);

# ------------------------------------------------------------ #
# test event ArticleSend
# ------------------------------------------------------------ #

# create master ticket article and forward it
my $MasterNewSubject = $TicketObject->TicketSubjectBuild(
    TicketNumber => $MasterTicketNumber,
    Subject      => 'Master Article',
    Action       => 'Forward',
);
my $ForwardArticleID = $EmailBackendObject->ArticleSend(
    TicketID             => $MasterTicketID,
    IsVisibleForCustomer => 1,
    SenderType           => 'agent',
    From                 => 'Some Agent <email@example.com>',
    To                   => 'Some Customer A <customer-a@example.com>',
    Subject              => $MasterNewSubject,
    Body                 => 'Unit test forwarded article',
    Charset              => 'iso-8859-15',
    MimeType             => 'text/plain',
    HistoryType          => 'Forward',
    HistoryComment       => 'Forwarded article',
    NoAgentNotify        => 0,
    UserID               => 1,
);
$Self->True(
    $Success,
    "ArticleSend() Forwarded MasterTicket Article ID $ForwardArticleID",
);

# get master ticket history
my @MasterHistoryLines = $TicketObject->HistoryGet(
    TicketID => $MasterTicketID,
    UserID   => 1,
);

my $MasterLastHistoryEntry = $MasterHistoryLines[-1];

# verify master ticket article is created
$Self->IsDeeply(
    $MasterLastHistoryEntry->{Name},
    'MasterTicketAction: ArticleSend',
    "MasterTicket ArticleSend event - ",
);

# get slave ticket history
my @SlaveHistoryLines = $TicketObject->HistoryGet(
    TicketID => $SlaveTicketID,
    UserID   => 1,
);
my $SlaveLastHistoryEntry = $SlaveHistoryLines[-1];

# verify slave ticket article tried to send
$Self->IsDeeply(
    $SlaveLastHistoryEntry->{Name},
    'MasterTicket: no customer email found, send no master message to customer.',
    "SlaveTicket ArticleSend event - ",
);

# ------------------------------------------------------------ #
# test event ArticleCreate
# ------------------------------------------------------------ #
my $InternalBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
    ChannelName => 'Internal',
);

# create note article for master ticket
my $ArticleIDCreate = $InternalBackendObject->ArticleCreate(
    TicketID             => $MasterTicketID,
    IsVisibleForCustomer => 0,
    SenderType           => 'agent',
    Subject              => 'Note article',
    Body                 => 'Unit test MasterTicket',
    ContentType          => 'text/plain; charset=ISO-8859-15',
    HistoryType          => 'AddNote',
    HistoryComment       => 'Unit test article',
    UserID               => 1,
);
$Self->True(
    $ArticleIDCreate,
    "ArticleCreate() Note Article ID $ArticleIDCreate created for MasterTicket ID $MasterTicketID",
);

# get master ticket history
@MasterHistoryLines = $TicketObject->HistoryGet(
    TicketID => $MasterTicketID,
    UserID   => 1,
);
($MasterLastHistoryEntry) = grep { $_->{Name} eq 'MasterTicketAction: ArticleCreate' } @MasterHistoryLines;

# verify master ticket article is created
$Self->IsDeeply(
    $MasterLastHistoryEntry->{Name},
    'MasterTicketAction: ArticleCreate',
    "MasterTicket ArticleCreate event - ",
);

# get slave ticket history
@SlaveHistoryLines = $TicketObject->HistoryGet(
    TicketID => $SlaveTicketID,
    UserID   => 1,
);
($SlaveLastHistoryEntry) = grep { $_->{Name} eq 'Added article based on master ticket.' } @SlaveHistoryLines;

# verify slave ticket article is created
$Self->IsDeeply(
    $SlaveLastHistoryEntry->{Name},
    'Added article based on master ticket.',
    "SlaveTicket ArticleCreate event - ",
);

# ------------------------------------------------------------ #
# test event TicketStateUpdate
# ------------------------------------------------------------ #

# change master ticket state to 'open'
$Success = $TicketObject->TicketStateSet(
    State    => 'open',
    TicketID => $MasterTicketID,
    UserID   => 1,
);
$Self->True(
    $Success,
    "TicketStateSet() MasterTicket state updated - 'open'",
);

# get master ticket history
@MasterHistoryLines = $TicketObject->HistoryGet(
    TicketID => $MasterTicketID,
    UserID   => 1,
);
$MasterLastHistoryEntry = $MasterHistoryLines[-1];

# verify master ticket state is updated
$Self->IsDeeply(
    $MasterLastHistoryEntry->{Name},
    'MasterTicketAction: TicketStateUpdate',
    "MasterTicket TicketStateUpdate event - ",
);

# verify slave ticket state is updated
my %SlaveTicketData = $TicketObject->TicketGet(
    TicketID => $SlaveTicketID,
    UserID   => 1,
);

$Self->IsDeeply(
    $SlaveTicketData{State},
    'open',
    "SlaveTicket state updated - 'open' - ",
);

# ------------------------------------------------------------ #
# test event TicketPendingTimeUpdate
# ------------------------------------------------------------ #

# change pending time for master ticket
$Success = $TicketObject->TicketPendingTimeSet(
    Year     => 0000,
    Month    => 00,
    Day      => 00,
    Hour     => 00,
    Minute   => 00,
    TicketID => $MasterTicketID,
    UserID   => 1,
);
$Self->True(
    $Success,
    "TicketPendingTimeSet() MasterTicket pending time updated",
);

# get master ticket history
@MasterHistoryLines = $TicketObject->HistoryGet(
    TicketID => $MasterTicketID,
    UserID   => 1,
);
$MasterLastHistoryEntry = $MasterHistoryLines[-1];

# verify master ticket pending time is updated
$Self->IsDeeply(
    $MasterLastHistoryEntry->{Name},
    'MasterTicketAction: TicketPendingTimeUpdate',
    "MasterTicket TicketPendingTimeUpdate event - ",
);

# get slave ticket history
@SlaveHistoryLines = $TicketObject->HistoryGet(
    TicketID => $SlaveTicketID,
    UserID   => 1,
);
$SlaveLastHistoryEntry = $SlaveHistoryLines[-1];

# verify slave ticket pending time is updated
$Self->IsDeeply(
    $SlaveLastHistoryEntry->{Name},
    '%%00-00-00 00:00',
    "SlaveTicket pending time update - ",
);

# ------------------------------------------------------------ #
# test event TicketPriorityUpdate
# ------------------------------------------------------------ #

# change master ticket priority to '2 low'
$Success = $TicketObject->TicketPrioritySet(
    TicketID => $MasterTicketID,
    Priority => '2 low',
    UserID   => 1,
);
$Self->True(
    $Success,
    "TicketPrioritySet() MasterTicket priority updated - '2 low'",
);

# get master ticket history
@MasterHistoryLines = $TicketObject->HistoryGet(
    TicketID => $MasterTicketID,
    UserID   => 1,
);
$MasterLastHistoryEntry = $MasterHistoryLines[-1];

# verify master ticket priority is updated
$Self->IsDeeply(
    $MasterLastHistoryEntry->{Name},
    'MasterTicketAction: TicketPriorityUpdate',
    "MasterTicket TicketPriorityUpdate event - ",
);

# verify slave ticket priority is updated
%SlaveTicketData = $TicketObject->TicketGet(
    TicketID => $SlaveTicketID,
    UserID   => 1,
);
$Self->IsDeeply(
    $SlaveTicketData{Priority},
    '2 low',
    "SlaveTicket priority updated - '2 low' - ",
);

# ------------------------------------------------------------ #
# test event TicketOwnerUpdate
# ------------------------------------------------------------ #

# change master ticket owner
$Success = $TicketObject->TicketOwnerSet(
    TicketID => $MasterTicketID,
    NewUser  => $TestUserLogin,
    UserID   => 1,
);
$Self->True(
    $Success,
    "TicketOwnerSet() MasterTicket owner updated - $TestUserLogin",
);

# get master ticket history
@MasterHistoryLines = $TicketObject->HistoryGet(
    TicketID => $MasterTicketID,
    UserID   => 1,
);
$MasterLastHistoryEntry = $MasterHistoryLines[-1];

# verify master ticket owner is updated
$Self->IsDeeply(
    $MasterLastHistoryEntry->{Name},
    'MasterTicketAction: TicketOwnerUpdate',
    "MasterTicket TicketOwnerUpdate event - ",
);

# verify slave ticket owner is updated
%SlaveTicketData = $TicketObject->TicketGet(
    TicketID => $SlaveTicketID,
    UserID   => 1,
);
$Self->IsDeeply(
    $SlaveTicketData{Owner},
    $TestUserLogin,
    "SlaveTicket owner updated - ",
);

# ------------------------------------------------------------ #
# test event TicketResponsibleUpdate
# ------------------------------------------------------------ #

# set new responsible user for master ticket
$Success = $TicketObject->TicketResponsibleSet(
    TicketID => $MasterTicketID,
    NewUser  => $TestUserLogin,
    UserID   => 1,
);
$Self->True(
    $Success,
    "TicketResponsibleSet() MasterTicket responsible updated - $TestUserLogin",
);

# get master ticket history
@MasterHistoryLines = $TicketObject->HistoryGet(
    TicketID => $MasterTicketID,
    UserID   => 1,
);
$MasterLastHistoryEntry = $MasterHistoryLines[-1];

# verify master ticket responsible user is updated
$Self->IsDeeply(
    $MasterLastHistoryEntry->{Name},
    'MasterTicketAction: TicketResponsibleUpdate',
    "MasterTicket TicketResponsibleUpdate event - ",
);

# verify slave ticket owner is updated
%SlaveTicketData = $TicketObject->TicketGet(
    TicketID => $SlaveTicketID,
    UserID   => 1,
);
$Self->IsDeeply(
    $SlaveTicketData{Responsible},
    $TestUserLogin,
    "SlaveTicket responsible updated - ",
);

# ------------------------------------------------------------ #
# test event TicketLockUpdate
# ------------------------------------------------------------ #

# lock master ticket
$Success = $TicketObject->TicketLockSet(
    Lock     => 'lock',
    TicketID => $MasterTicketID,
    UserID   => 1,
);
$Self->True(
    $Success,
    "TicketLockSet() MasterTicket is locked",
);

# get master ticket history
@MasterHistoryLines = $TicketObject->HistoryGet(
    TicketID => $MasterTicketID,
    UserID   => 1,
);
$MasterLastHistoryEntry = $MasterHistoryLines[-1];

# verify master ticket is locked
$Self->IsDeeply(
    $MasterLastHistoryEntry->{Name},
    'MasterTicketAction: TicketLockUpdate',
    "MasterTicket TicketLockUpdate event - ",
);

# verify slave ticket is locked
%SlaveTicketData = $TicketObject->TicketGet(
    TicketID => $SlaveTicketID,
    UserID   => 1,
);
$Self->IsDeeply(
    $SlaveTicketData{Lock},
    'lock',
    "SlaveTicket lock updated - ",
);

# cleanup is done by RestoreDatabase

1;
