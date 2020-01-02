# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Maint::Survey::RequestsDelete;

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

    $Self->Description('Delete survey results (including vote data and requests).');
    $Self->AddOption(
        Name        => 'force',
        Description => "Actually delete results now.",
        Required    => 0,
        HasValue    => 0,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    my $DeletePeriod = $Kernel::OM->Get('Kernel::Config')->Get('Survey::DeletePeriod');
    if ( !$DeletePeriod ) {
        die "No days configured in Survey::DeletePeriod.\n";
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Processing pending survey results...</yellow>\n\n");

    # get force option
    my $Force = $Self->GetOption('force');

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # get survey object
    my $SurveyObject = $Kernel::OM->Get('Kernel::System::Survey');

    # get survey ids
    my @SurveyIDs = $SurveyObject->SurveySearch(
        UserID => 1,
    );

    # get delete period (in days)
    my $DeletePeriod = $Kernel::OM->Get('Kernel::Config')->Get('Survey::DeletePeriod');

    my $OlderDateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
    );
    $OlderDateTimeObject->Subtract(
        Days => $DeletePeriod,
    );
    $OlderDateTimeObject->Set(
        Hour   => 23,
        Minute => 59,
        Second => 59,
    );
    my $RequestCreateTimeOlderDate = $OlderDateTimeObject->ToString();

    my $NewerDateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
    );
    $NewerDateTimeObject->Subtract(
        Days => $DeletePeriod + 1,
    );
    $NewerDateTimeObject->Set(
        Hour   => 0,
        Minute => 0,
        Second => 0,
    );
    my $RequestCreateTimeNewerDate = $NewerDateTimeObject->ToString();

    # init result array
    my @ResultList;

    for my $SurveyID (@SurveyIDs) {

        # get public survey keys
        my $PublicSurveyKeys = $SurveyObject->PublicSurveyKeyGet(
            SurveyID => $SurveyID,
        );

        REQUEST:
        for my $PublicKey ( @{$PublicSurveyKeys} ) {

            # get requests
            my %RequestData = $SurveyObject->RequestGet(
                PublicSurveyKey            => $PublicKey,
                RequestCreateTimeOlderDate => $RequestCreateTimeOlderDate,
            );

            # skip if we have no request data
            next REQUEST if !%RequestData;

            # get vote list
            return if !$DBObject->Prepare(
                SQL => '
                    SELECT s.title, t.tn , sr.send_time, sr.vote_time, sr.create_time
                    FROM survey_request sr
                    INNER JOIN ticket t ON t.id = sr.ticket_id
                    INNER JOIN survey s ON s.id = sr.survey_id
                    WHERE sr.id = ?',
                Bind => [ \$RequestData{RequestID} ],
            );

            # fetch the result
            while ( my @Row = $DBObject->FetchrowArray() ) {

                my $Result = join(
                    ' ', "Survey:" . $Row[0] . "\t",
                    "TicketNumber:" . $Row[1] . "\t",
                    "SendTime:" . $Row[2] . "\t",
                    "VoteTime:" . $Row[3] . "\t",
                    "CreateTime:" . $Row[4] . "\t"
                );

                $Self->Print("$Result\n");
            }

            if ($Force) {

                # delete vote data
                my $VoteDelete = $SurveyObject->VoteDelete(
                    RequestID => $RequestData{RequestID},
                );

                # delete request
                my $RequestDelete = $SurveyObject->RequestDelete(
                    RequestID => $RequestData{RequestID},
                );
            }
        }
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
