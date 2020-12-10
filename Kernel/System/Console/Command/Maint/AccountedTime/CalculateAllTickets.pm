# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Maint::AccountedTime::CalculateAllTickets;

use strict;
use warnings;

use Time::HiRes();

use base qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Ticket',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Completely rebuild the ticket Accounted Times.');
    $Self->AddOption(
        Name        => 'micro-sleep',
        Description => "Specify microseconds to sleep after every ticket to reduce system load (e.g. 1000).",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/^\d+$/smx,
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Recalculating ticket accounted time...</yellow>\n");
    my $TicketObject =  $Kernel::OM->Get('Kernel::System::Ticket');

    # get all tickets
    my @TicketIDs = $TicketObject->TicketSearch(
        Result     => 'ARRAY',
        Limit      => 100_000_000,
        UserID     => 1,
        Permission => 'ro',
    );

    my $Count      = 0;
    my $MicroSleep = $Self->GetOption('micro-sleep');

    my $StartField = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Complemento::AccountedTime::DynamicFieldStartID');
    my $EndField = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Complemento::AccountedTime::DynamicFieldEndID');

    my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    my $DynamicFieldStart = $DynamicFieldObject->DynamicFieldGet(
        ID   => $StartField,             # ID or Name must be provided
    );

    my $DynamicFieldEnd = $DynamicFieldObject->DynamicFieldGet(
        ID   => $EndField,             # ID or Name must be provided
    );

    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

    TICKETID:
    for my $TicketID (@TicketIDs) {

        $Count++;

        # Get all articles with dynamic fields
        my @ArticleBox = $TicketObject->ArticleContentIndex(
            TicketID                   => $TicketID,
            UserID                     => 1,
            DynamicFields              => 1,
        );
        #for each article, recalculate time accounting
        ARTICLE:
        for my $Article(@ArticleBox){
                next ARTICLE if (!$Article->{"DynamicField_$DynamicFieldStart->{Name}"} || !$Article->{"DynamicField_$DynamicFieldEnd->{Name}"});

                # Calcula o tempo contabilizado
                my $Start = $TimeObject->TimeStamp2SystemTime(
                    String => $Article->{"DynamicField_$DynamicFieldStart->{Name}"},
                );
                my $End = $TimeObject->TimeStamp2SystemTime(
                    String => $Article->{"DynamicField_$DynamicFieldEnd->{Name}"},
                );

                my $AccountedTimeInMin = int(($End-$Start)/60);

                # For Article Edit Addon
                # get database object
                my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
                return if !$DBObject->Do(
                    SQL => 'DELETE FROM time_accounting where article_id = ?',
                    Bind => [ \$Article->{ArticleID} ],
                );

                # Set new accounted time
                $TicketObject->TicketAccountTime(
                    TicketID  => $TicketID,
                    ArticleID => $Article->{ArticleID},
                    TimeUnit  => $AccountedTimeInMin,
                    UserID    => $Article->{CreatedBy},
                ) if $AccountedTimeInMin;
                
                #Update no campo create_time colocando a data do CampoDinamico "Start"
                return if !$DBObject->Do(
                    SQL => 'UPDATE time_accounting set create_time = ? where article_id = ?',
                    Bind => [ \$Article->{"DynamicField_$DynamicFieldStart->{Name}"}, \$Article->{ArticleID} ],
                );



        }

        if ( $Count % 2000 == 0 ) {
            my $Percent = int( $Count / ( $#TicketIDs / 100 ) );
            $Self->Print(
                "<yellow>$Count</yellow> of <yellow>$#TicketIDs</yellow> processed (<yellow>$Percent %</yellow> done).\n"
            );
        }

        Time::HiRes::usleep($MicroSleep) if $MicroSleep;
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;
