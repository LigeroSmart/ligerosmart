package Kernel::System::Console::Command::Maint::Daemon::Clean;

# use strict;
# use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Clean Daemon process.');
    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $FQDN = $Kernel::OM->Get('Kernel::Config')->Get('FQDN');

    my $DatabaseDSN  = $DBObject->{DSN};
    my $DatabaseUser = $DBObject->{USER};

    if ( !$DBObject ) {
        $Self->PrintError('Connection failed.');
        return $Self->ExitCodeError();
    }

    $Self->Print("<green>Check processes of host $FQDN</green>\n");

    my $countProcess   = 0;
    my $countScheduler = 0;

    eval {

        # process_id
        $DBObject->Prepare(
            SQL => 'SELECT * FROM process_id WHERE process_host = ?',
            Bind => [ \$FQDN ],
         );

        my @processList;

        PROCESS:
        while ( my @Row = $DBObject->FetchrowArray() ) {
            my $processName = $Row[0];
            my $processId = $Row[1];
            next PROCESS if _check_process_id($processId);
            push @processList, $processId;
        };

        foreach my $process ( @processList ) {
            # Clean process_id
            $DBObject->Do(
                SQL  => 'DELETE FROM process_id WHERE process_id = ? AND process_host = ?',
                Bind => [ \$process, \$FQDN ],
            );
            $countProcess++;
        }

        # process_id
        $DBObject->Prepare(
            SQL => 'SELECT count(*) FROM scheduler_task WHERE lock_time IS NOT NULL'
        );

        my @schedulerRow = $DBObject->FetchrowArray();

        $countScheduler = $schedulerRow[0];

        # Clean scheduler_task
        $DBObject->Prepare( SQL => 'DELETE FROM scheduler_task WHERE lock_time IS NOT NULL' );

    };

    if ($countProcess) {
        $Self->Print("$countProcess process cleaned\n");
    }

    if ($countScheduler) {
        $Self->Print("$countScheduler scheduler cleaned\n");
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

sub _check_process_id {
    my ($pid) = @_;

    return 0 if !$pid;

    my @output = `ps -p $pid 2>/dev/null`;

    return scalar @output > 1;
}

1;
