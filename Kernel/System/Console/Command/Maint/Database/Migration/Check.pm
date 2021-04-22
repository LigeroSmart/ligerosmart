# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Maint::Database::Migration::Check;

# use strict;
# use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::DB',
);

use File::Basename;

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Check LigeroSmart database connectivity.');
    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # print database information
    my $DatabaseDSN  = $DBObject->{DSN};
    my $DatabaseUser = $DBObject->{USER};

    $Self->Print("<yellow>Trying to connect to database '$DatabaseDSN' with user '$DatabaseUser'...</yellow>\n");

    # Check for database state error.
    if ( !$DBObject ) {
        $Self->PrintError('Connection failed.');
        return $Self->ExitCodeError();
    }

    # Try to get some data from the database.
    # eval {
        my $SourceDir = $Param{Options}->{SourceDir} || "/opt/otrs/scripts/database/migrations";

        my @Files     = $MainObject->DirectoryRead(
            Directory => $SourceDir,
            Filter    => '*.xml',
        );

        my @BaseFiles = map { "'".basename($_)."'" } @Files;
        my $JoinedFiles = join(',', @BaseFiles);

        my $FilesCount = @BaseFiles;

        $DBObject->Prepare( SQL => "SELECT count(*) FROM migrations WHERE name IN ($JoinedFiles)" );
        my $MigratedCount = 0;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $MigratedCount = $Row[0];
        }
        if ( $MigratedCount != $FilesCount ) {
            $Self->Print("Apply migration\n");
            system('otrs.Console.pl Maint::Database::Migration::Apply');
            return $Self->ExitCodeError();
        }
    # };
    $Self->Print("<green>Connection successful.</green>\n");

    return $Self->ExitCodeOk();
}

1;
