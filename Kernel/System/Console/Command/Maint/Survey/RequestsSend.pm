# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Maint::Survey::RequestsSend;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::DateTime',
    'Kernel::System::Survey',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Send pending survey requests.');
    $Self->AddOption(
        Name        => 'force',
        Description => "Actually send the requests now.",
        Required    => 0,
        HasValue    => 0,
    );

    $Self->AdditionalHelp(<<"EOF");

 <yellow>Configure delayed request sending:</yellow>

  <yellow>1.</yellow> Go to your SysConfig (Survey->Core) and configure <green>Survey::SendInHoursAfterClose</green> to a higher value than 0
  <yellow>2.</yellow> Create a survey, make it master
  <yellow>3.</yellow> Create a ticket, close it
  <yellow>4.</yellow> Wait the necessary amount of hours you had configured
  <yellow>5.</yellow> You can do a dry run to get a list of survey requests that would be sent ( do not use --force )
  <yellow>6.</yellow> If you're fine with it, go again to SysConfig (Survey->Daemon::SchedulerCronTaskManager::Task) and activate daemon task <green> Daemon::SchedulerCronTaskManager::Task###SurveyRequestsSend</green>
EOF

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Processing pending survey requests...</yellow>\n\n");

    # get force option
    my $Force = $Self->GetOption('force');

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # find survey_requests that haven't been sent yet
    my $Success = $DBObject->Prepare(
        SQL => "
            SELECT sq.id, sq.ticket_id, sq.create_time, sq.public_survey_key
            FROM survey_request sq
                INNER JOIN ticket ON ticket.id = sq.ticket_id
            WHERE sq.send_time IS NULL
            ORDER BY sq.create_time DESC",
    );

    if ( !$Success ) {
        $Self->PrintError("DB error during a Prepare function.\n");
        return $Self->ExitCodeError();
    }

    # fetch the result
    my @RequestList;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @RequestList, {
            ID              => $Row[0],
            TicketID        => $Row[1],
            CreateTime      => $Row[2],
            PublicSurveyKey => $Row[3],
        };
    }

    if ( !@RequestList ) {
        $Self->Print("\n<green>Done.</green>\n");
        return $Self->ExitCodeOk();
    }

    # get SystemTime in UnixTime
    my $SystemTime = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch();

    REQUEST:
    for my $Request (@RequestList) {

        for my $Needed (qw(ID TicketID CreateTime)) {
            if ( !$Request->{$Needed} ) {
                $Self->Print("<red>Error: $Needed missing in service_request row.</red>\n");
                next REQUEST;
            }
        }

        # convert create_time to unixtime
        my $CreateTime = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Request->{CreateTime},
            },
        )->ToEpoch();

        $Self->Print(
            "  RequestID: <yellow>$Request->{ID}</yellow>\n   -For TicketID: $Request->{TicketID}\n"
        );

        my $SendInHoursAfterClose = $Kernel::OM->Get('Kernel::Config')->Get('Survey::SendInHoursAfterClose');

        # don't send for survey_requests that are younger than CreateTime + $SendINHoursAfterClose
        if ( $SendInHoursAfterClose * 3_600 + $CreateTime > $SystemTime ) {
            $Self->Print(
                "   -Skipped because send time wasn't reached yet.\n\n"
            );
            next REQUEST;
        }

        $Self->Print(
            "   -Sending request...\n"
        );

        if ($Force) {
            my $Success = $Kernel::OM->Get('Kernel::System::Survey')->RequestSend(
                TriggerSendRequests => 1,
                SurveyRequestID     => $Request->{ID},
                TicketID            => $Request->{TicketID},
                PublicSurveyKey     => $Request->{PublicSurveyKey},
            );
            if ( !$Success ) {
                $Self->Print("    <red>Error sending the request</red>\n");
            }
            elsif ( $Success eq 'Queue' || $Success eq 'Type' || $Success eq 'Service' ) {
                $Self->Print("    <red>Error sending the request</red>\n");
                $Self->Print("    <red>Ticket $Success does not match to assigned survey request.</red>\n");
            }
            else {
                $Self->Print("    <green>Request is sent successfully.</green>\n");
            }
        }
        $Self->Print("\n");
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
