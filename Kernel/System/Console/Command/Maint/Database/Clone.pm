# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Maint::Database::Clone;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::CloneDB::Backend',
    'Kernel::System::DB',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    my $Description = <<EOF;
This script clones an OTRS database into an empty target database, even
on another database platform. It will dynamically get the list of tables in the
source DB, and copy the data of each table to the target DB.
Please note that you first need to configure the target database via SysConfig.
EOF

    $Self->Description($Description);

    $Self->AddOption(
        Name        => 'force',
        Description => "Continue even if there are errors while writing the data.",
        Required    => 0,
        HasValue    => 0,
        ValueRegex  => qr/.*/smx,
    );

    $Self->AddOption(
        Name        => 'dry-run',
        Description => "Dry run mode, only read and verify, but don't write to the target database.",
        Required    => 0,
        HasValue    => 0,
        ValueRegex  => qr/.*/smx,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    my $SourceDBObject = $Kernel::OM->Get('Kernel::System::DB')
        || die "Could not connect to source DB";

    # create CloneDB backend object
    my $CloneDBBackendObject = $Kernel::OM->Get('Kernel::System::CloneDB::Backend')
        || die "Could not create clone db object.";

    # get the target DB settings
    my $TargetDBSettings = $Kernel::OM->Get('Kernel::Config')->Get('CloneDB::TargetDBSettings');

    # create DB connections
    my $TargetDBObject = $CloneDBBackendObject->CreateTargetDBConnection(
        TargetDBSettings => $TargetDBSettings,
    );
    die "Could not create target DB connection." if !$TargetDBObject;

    # store target DB object for use it later
    $Self->{TargetDBObject} = $TargetDBObject;

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Meaningful start message...</yellow>\n");

    my %Options;
    $Options{'force'}   = $Self->GetOption('force');
    $Options{'dry-run'} = $Self->GetOption('dry-run');

    # get target DB object
    my $TargetDBObject = $Self->{TargetDBObject};

    # get clone DB object
    my $CloneDBBackendObject = $Kernel::OM->Get('Kernel::System::CloneDB::Backend');

    if ( !defined $Options{'dry-run'} ) {
        $CloneDBBackendObject->PopulateTargetStructuresPre(
            TargetDBObject => $TargetDBObject,
            Force          => $Options{'force'} || '',
        );
    }

    my $SanityResult = $CloneDBBackendObject->SanityChecks(
        TargetDBObject => $TargetDBObject,
        DryRun         => $Options{'dry-run'} || '',
    );
    if ($SanityResult) {
        my $DataTransferResult = $CloneDBBackendObject->DataTransfer(
            TargetDBObject => $TargetDBObject,
            DryRun         => $Options{'dry-run'} || '',
            Force          => $Options{'force'} || '',
        );

        if ( !$DataTransferResult ) {
            $Self->Print("System was unable to complete the data transfer. \n");
            return $Self->ExitCodeError();
        }

        if ( $DataTransferResult eq 2 ) {
            $Self->Print("Dry run successfully finished.\n");
        }
    }

    if ( !defined $Options{'dry-run'} ) {
        $CloneDBBackendObject->PopulateTargetStructuresPost(
            TargetDBObject => $TargetDBObject,
        );
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
