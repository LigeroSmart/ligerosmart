# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Maint::Ticket::OLACheck;

use strict;
use warnings;
use Data::Dumper;
use List::Util qw(first);
use POSIX ":sys_wait_h";
use Time::HiRes qw(sleep);
use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DateTime',
    'Kernel::System::Ticket',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Trigger ticket escalation events and notification events for OLA.');

    $Self->AddOption(
        Name        => 'micro-sleep',
        Description => "Specify microseconds to sleep after every ticket to reduce system load (e.g. 1000).",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/^\d+$/smx,
    );
    
    $Self->AddOption(
        Name        => 'open-tickets-only',
        Description => "Search only tickets that are not closed",
        Required    => 0,
        HasValue    => 0,
    );

    $Self->AddOption(
        Name        => 'force-pid',
        Description => "Start even if another process is still registered in the database.",
        Required    => 0,
        HasValue    => 0,
    );

    $Self->AddOption(
        Name        => 'children',
        Description => "Specify the number of child processes to be used for indexing (default: 4, maximum: 20).",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/^\d+$/smx,
    );

    $Self->AddOption(
        Name        => 'JsonTicketSearch',
        Description => 'Json Data. Ex: \'{"States":["new","open"],"Priority":"3 normal"}\'',
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    my $Children = $Self->GetOption('children') // 4;

    if ( $Children > 20 ) {
        die "The allowed maximum amount of child processes is 20!\n";
    }

    my $ForcePID = $Self->GetOption('force-pid');

    my $PIDObject = $Kernel::OM->Get('Kernel::System::PID');

    my %PID = $PIDObject->PIDGet(
        Name => 'OLACheck',
    );

    if ( %PID && !$ForcePID ) {
        die "Active indexing process already running! Skipping...\n";
    }

    my $Success = $PIDObject->PIDCreate(
        Name  => 'OLACheck',
        Force => $Self->GetOption('force-pid'),
    );

    if ( !$Success ) {
        die "Unable to register indexing process! Skipping...\n";
    }

    return;
}

# =item Run()
#
#
# =cut

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Processing ticket OLA escalation events...</yellow>\n");

    my $Children = $Self->GetOption('children') // 4;

    # get needed objects
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');
    my %Search;

    if($Self->GetOption('JsonTicketSearch')){
        my $JsonData = $JSONObject->Decode(
            Data => $Self->GetOption('JsonTicketSearch'),
        );
        %Search = %{$JsonData};
    }
    my %OpenStates;
    if ($Self->GetOption('open-tickets-only')) 
    {
        $Self->Print("<yellow>Working only on open tickets...</yellow>\n");
        $OpenStates{StateType} = ['open','new','pending reminder','pending auto'];
    }

    # get all tickets
    my @TicketIDs = $Kernel::OM->Get('Kernel::System::Ticket')->TicketSearch(
        # Only on Open
        %OpenStates,
        %Search,
        Result => 'ARRAY',
        Limit      => 100_000_000,
        UserID     => 1,
        Permission => 'ro',
    );

    # Destroy objects for the child processes.
    $Kernel::OM->ObjectsDiscard(
        Objects => [
            'Kernel::System::DB',
        ],
        ForcePackageReload => 0,
    );

    # Split TicketIDs into equal arrays for the child processes.
    my @TicketChunks;
    my $Count = 0;
    for my $TicketID (@TicketIDs) {
        push @{ $TicketChunks[ $Count++ % $Children ] }, $TicketID;
    }

    my %ActiveChildPID;

    TICKETCHUNK:
    for my $TicketIDChunk (@TicketChunks) {

        # Create a child process.
        my $PID = fork;

        # Could not create child.
        if ( $PID < 0 ) {

            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Unable to fork to a child process for OLA Check!"
            );
            last TICKETCHUNK;
        }

        # We're in the child process.
        if ( !$PID ) {
           # Add the chunk of ticket data to the index.
            TICKETID:
            for my $TicketID ( @{$TicketIDChunk} ) {
                    # print $TicketID."\n";
                    $Kernel::OM->Get('Kernel::System::Ticket::Event::OLA')->Run(
                        Data =>{
                            TicketID => $TicketID,
                        },
                        Event => 'RebuildIndex', # Just to not be empty
                        Config => '1',
                        UserID   => 1,
                    );
                    next TICKETID if !$Self->GetOption('micro-sleep');
                    Time::HiRes::usleep( $Self->GetOption('micro-sleep') );
            }

            # Close child process at the end.
            exit 0;
        }
        $ActiveChildPID{$PID} = {
            PID => $PID,
        };
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

sub PostRun {
    my ($Self) = @_;

    my $Success = $Kernel::OM->Get('Kernel::System::PID')->PIDDelete(
        Name => 'OLACheck',
    );

    if ( !$Success ) {
        $Self->PrintError("Unable to unregister indexing process! Skipping...\n");
        return $Self->ExitCodeError();
    }

    return $Success;
}

1;