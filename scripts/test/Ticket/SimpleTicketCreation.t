# --
# Copyright (C) 2025 LigeroSmart
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get needed object
my $ConfigObject         = $Kernel::OM->Get('Kernel::Config');
my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
my $UploadCacheObject    = $Kernel::OM->Get('Kernel::System::Web::UploadCache');
my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
    ChannelName => 'Internal',
);

# create test data
my $TicketID = $TicketObject->TicketCreate(
    Title        => 'Some Ticket Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'closed successful',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

$Self->True(
    $TicketID,
    'TicketCreate()',
);

# add HTML
my $HTML = '<html>
<head>
<title>Test</title>
</head>
<body>
<b>Test HTML document.</b>
<img src="cid:1234" border="0">
<img src="Untitled%20Attachment" border="0">
Special case from Lotus Notes:
<img src=cid:_1_09B1841409B1651C003EDE23C325785D border="0">
</body>
</html>';

my $ArticleID = $ArticleBackendObject->ArticleCreate(
    TicketID             => $TicketID,
    IsVisibleForCustomer => 0,
    SenderType           => 'agent',
    From                 => 'Some Agent <email@example.com>',
    To                   => 'Some Customer <customer@example.com>',
    Subject              => 'Fax Agreement laalala',
    Body                 => $HTML,
    ContentType          => 'text/html; charset=ISO-8859-15',
    HistoryType          => 'OwnerUpdate',
    HistoryComment       => 'Some free text!',
    UserID               => 1,
    NoAgentNotify        => 1,                                        # if you don't want to send agent notifications
);

$ArticleBackendObject->ArticleWriteAttachment(
    Filename    => 'some.html',
    MimeType    => 'text/html',
    ContentType => 'text/html',
    Content     => '<html>some html</html>',
    ContentID   => '',
    ArticleID   => $ArticleID,
    UserID      => 1,
);

1;
