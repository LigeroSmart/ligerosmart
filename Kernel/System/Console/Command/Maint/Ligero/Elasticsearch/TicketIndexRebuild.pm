# --
# Copyright (C) 2001-2016 Complemento - Liberdade e Tecnologia http://www.complemento.net.br
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Maint::Ligero::Elasticsearch::TicketIndexRebuild;

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

    $Self->Description('Completely rebuild the article search index on Elasticsearch for Ligero Search.');
    $Self->AddOption(
        Name        => 'micro-sleep',
        Description => "Specify microseconds to sleep after every ticket to reduce system load (e.g. 1000).",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/^\d+$/smx,
    );

    $Self->AddOption(
        Name        => 'TicketID',
        Description => "TicketID for individual index",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/^\d+$/smx,
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Rebuilding Ticket search index...</yellow>\n");

    # disable ticket events
    $Kernel::OM->Get('Kernel::Config')->{'Ticket::EventModulePost'} = {};

    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    my %Search;

    my $TicketID = $Self->GetOption('TicketID');
    if ($TicketID) {
        $Search{TicketID} = $TicketID
    }
    

    # get all tickets
    my @TicketIDs = $TicketObject->TicketSearch(
        ArchiveFlags => [ 'y', 'n' ],
        OrderBy      => 'Down',
        SortBy       => 'Age',
        Result       => 'ARRAY',
        Limit        => 100_000_000,
        Permission   => 'ro',
        UserID       => 1,
        %Search
    );

    my $Count      = 0;
    my $MicroSleep = $Self->GetOption('micro-sleep');

    # Get WebService ID
    my $WebService = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceGet(
       Name => 'LigeroTicketIndexer',
    );
    
    TICKETID:
    for my $TicketID (@TicketIDs) {

        $Count++;


        #Call WebService
        $Kernel::OM->Get('Kernel::GenericInterface::Requester')->Run(
            WebserviceID => $WebService->{ID},
            Invoker      => 'LigeroTicketIndexer',
            Data         => {
                                TicketID => $TicketID
                            },
        );
        

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

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
