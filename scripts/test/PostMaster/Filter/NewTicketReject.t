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

use Kernel::System::PostMaster;
use Kernel::System::PostMaster::Filter::NewTicketReject;

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# use test email backend so no real mail is ever sent
$ConfigObject->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::Test',
);
my $TestEmailObject = $Kernel::OM->Get('Kernel::System::Email::Test');

my $Sender = 'support@example.com';

$ConfigObject->Set(
    Key   => 'PostMaster::PreFilterModule::NewTicketReject::Sender',
    Value => $Sender,
);
$ConfigObject->Set(
    Key   => 'PostMaster::PreFilterModule::NewTicketReject::Subject',
    Value => 'Email rejeitado para abertura de chamado',
);
$ConfigObject->Set(
    Key   => 'PostMaster::PreFilterModule::NewTicketReject::Body',
    Value => 'Please open your request via the customer portal.',
);

# same 'match almost everything' condition used in production for this filter
my $JobConfig = {
    Match => {
        To => '.*',
    },
};

# This reproduces the mail loop incident of 2026-08: a reject mail must never be sent
# back to our own notification address, and must never be sent in reply to mail that
# already announces it doesn't want an auto-response.
my @Tests = (
    {
        Name       => 'External sender - reject mail is sent',
        Email      => "From: customer\@example.com\nTo: $Sender\nSubject: Preciso de ajuda\n\nBody\n",
        ExpectSend => 1,
    },
    {
        Name  => 'Sender is our own notification address - must not create a loop',
        Email =>
            "From: $Sender\nTo: $Sender\nSubject: Email rejeitado para abertura de chamado\n\nBody\n",
        ExpectSend => 0,
    },
    {
        Name  => 'Inbound mail already flagged Auto-Submitted - must not reply',
        Email =>
            "From: customer\@example.com\nTo: $Sender\nAuto-Submitted: auto-generated\nSubject: Preciso de ajuda\n\nBody\n",
        ExpectSend => 0,
    },
    {
        Name  => 'Inbound mail carries Precedence: bulk - must not reply',
        Email =>
            "From: customer\@example.com\nTo: $Sender\nPrecedence: bulk\nSubject: Preciso de ajuda\n\nBody\n",
        ExpectSend => 0,
    },
    {
        Name  => 'Inbound mail carries X-Loop: yes - must not reply',
        Email =>
            "From: customer\@example.com\nTo: $Sender\nX-Loop: yes\nSubject: Preciso de ajuda\n\nBody\n",
        ExpectSend => 0,
    },
);

for my $Test (@Tests) {

    $TestEmailObject->CleanUp();

    my @Email = split /\n/, $Test->{Email};

    my $CommunicationLogObject = $Kernel::OM->Create(
        'Kernel::System::CommunicationLog',
        ObjectParams => {
            Transport => 'Email',
            Direction => 'Incoming',
        },
    );
    $CommunicationLogObject->ObjectLogStart( ObjectLogType => 'Message' );

    my $PostMasterObject = Kernel::System::PostMaster->new(
        CommunicationLogObject => $CommunicationLogObject,
        Email                  => \@Email,
    );

    my $GetParam = $PostMasterObject->GetEmailParams();

    my $FilterObject = Kernel::System::PostMaster::Filter::NewTicketReject->new(
        CommunicationLogObject => $CommunicationLogObject,
        ParserObject            => $PostMasterObject->{ParserObject},
    );

    $FilterObject->Run(
        GetParam  => $GetParam,
        JobConfig => $JobConfig,
    );

    $CommunicationLogObject->ObjectLogStop(
        ObjectLogType => 'Message',
        Status        => 'Successful',
    );
    $CommunicationLogObject->CommunicationStop(
        Status => 'Successful',
    );

    my $Emails = $TestEmailObject->EmailsGet();

    $Self->Is(
        scalar @{$Emails},
        $Test->{ExpectSend},
        "$Test->{Name} - number of emails sent",
    );
}

# cleanup cache is done by RestoreDatabase

1;
