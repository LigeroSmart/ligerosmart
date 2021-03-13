# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Maint::Database::Migration::Rollback;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::YAML',
);


# TODO: remove before release
use Data::Dumper;


sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Apply database modifications to current version application');
    $Self->AddOption(
        Name        => 'source-dir',
        Description => "Specify the source location of the setting value YAML file.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Param{Options}->{SourceDir} = $Self->GetOption('source-dir');

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    my $DBType = $DBObject->{'DB::Type'};

    # print database information
    my $DatabaseDSN  = $DBObject->{DSN};
    my $DatabaseUser = $DBObject->{USER};

    # Check for database state error.
    if ( !$DBObject ) {
        $Self->PrintError("Connection failed with DSN '$DatabaseDSN' and user '$DatabaseUser'");
        return $Self->ExitCodeError();
    }

    my $SourceDir = $Param{Options}->{SourceDir} || "/opt/otrs/scripts/database/migrations";

    $DBObject->Prepare( SQL => "SELECT * FROM migrations ORDER BY id DESC LIMIT 1" );
    my $Count = 0;
    while ( my @Row = $DBObject->FetchrowArray() ) {

        $Count++;

        # if not exists here, rollback commands
        $Self->Print(join("\t", @Row)."\n");

        my $migrationId = $Row[0];
        my $migrationName = $Row[1];

        my $YAMLContentRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
            Location        => "$SourceDir/$DBType/$migrationName",
            Mode            => 'utf8',
            Type            => 'Local',
            Result          => 'SCALAR',
            DisableWarnings => 1,
        );

        if ( !$YAMLContentRef ) {
            $Self->PrintError("Could not read $SourceDir/$DBType/$migrationName");
            return $Self->ExitCodeError();
        }

        my $EffectiveValue = $Kernel::OM->Get('Kernel::System::YAML')->Load(
            Data => ${$YAMLContentRef},
        );

        if ( !defined $EffectiveValue ) {
            $Self->PrintError("The content of $SourceDir is invalid");
            return $Self->ExitCodeError();
        }
        
        $Self->Print("Rollback $migrationName\n");

        my $Result;

        if($EffectiveValue->{rollback}->{sql}) {
            my $sql = $EffectiveValue->{rollback}->{sql};
            $Result = $DBObject->Do( SQL => $sql );

            if ( ! $Result ) {
                $Self->PrintError("Error executing SQL:\n\t$sql\n");
                $DBObject->Error();
                return $Self->ExitCodeError();
            }
        }

        if($EffectiveValue->{rollback}->{command}) {
            my $command = $EffectiveValue->{rollback}->{command};
            $Result = system($EffectiveValue->{rollback}->{command});
            if ( ! $Result ) {
                $Self->PrintError("Error executing command:\n\t$command\n");
                $DBObject->Error();
                return $Self->ExitCodeError();
            }
        }

        if($Result) {
            $DBObject->Do(
                SQL  => "DELETE FROM migrations WHERE id=?",
                Bind => [ \$migrationId ],
            );
        }

    }

    if ( !$Count ) {
        $Self->Print("nothing to do\n");
        # Maint::Database::Migration::Apply
        return $Self->ExitCodeError();
    }

    # print "MigrationFileList\n";
    # print Dumper(%MigrationFileList);
    # print "ApplyList\n";
    # print Dumper(%ApplyList);

    $Self->Print("<green>Migration rollbacked.</green>\n");

    return $Self->ExitCodeOk();
}

1;
