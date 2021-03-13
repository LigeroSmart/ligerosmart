# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Maint::Database::Migration::Apply;

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

    $DBObject->Prepare( SQL => "SELECT * FROM migrations" );
    my $Check = 0;
    my %MigrationsApplied = ();

    $Self->Print("Migrations already applied:\n");

    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Check++;

        # if not exists here, apply commands
        $Self->Print(join("\t", @Row)."\n");
        my $migrationName = $Row[1];
        $MigrationsApplied{$migrationName} = 1;
    }


    # read migrations YAML directory
    # my $SourceDir = $Self->GetOption('source-dir');
    my $SourceDir = $Param{Options}->{SourceDir} || "/opt/otrs/scripts/database/migrations";

    my %MigrationFileList = ();
    my %ApplyList = ();

    opendir DIR,$SourceDir. "/". $DBType;
    my @dir = readdir(DIR);
    close DIR;
    foreach(@dir){
        if (-f $SourceDir . "/". $DBType. "/" . $_ ){
            $MigrationFileList{$_} = $_;
        }
    }

    foreach (%MigrationFileList) {

        next if($MigrationsApplied{$_});

        my $filename = $_;

        my $YAMLContentRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
            Location        => "$SourceDir/$DBType/$filename",
            Mode            => 'utf8',
            Type            => 'Local',
            Result          => 'SCALAR',
            DisableWarnings => 1,
        );

        if ( !$YAMLContentRef ) {
            $Self->PrintError("Could not read $SourceDir! $_");
            return $Self->ExitCodeError();
        }

        my $EffectiveValue = $Kernel::OM->Get('Kernel::System::YAML')->Load(
            Data => ${$YAMLContentRef},
        );

        if ( !defined $EffectiveValue ) {
            $Self->PrintError("The content of $SourceDir is invalid");
            return $Self->ExitCodeError();
        }

        $ApplyList{$_} = $EffectiveValue->{apply};

    }


    my $appliedCount = 0;
    foreach my $fileKey (sort keys %ApplyList) {
        $appliedCount++;

        my $Result;

        if($ApplyList{$fileKey}->{sql}) {
            my $sql = $ApplyList{$fileKey}->{sql};

            $Self->Print("Appling $fileKey\n");
            $Result = $DBObject->Do( SQL => $sql );

            if ( ! $Result ) {
                $Self->PrintError("Error executing SQL:\n\t$sql\n");
                $DBObject->Error();
                return $Self->ExitCodeError();
            }
        }

        if($ApplyList{$fileKey}->{command}) {
            my $command = $ApplyList{$fileKey}->{command};
            $Result = system($command);
            if ( ! $Result ) {
                $Self->PrintError("Error executing command:\n\t$command\n");
                $DBObject->Error();
                return $Self->ExitCodeError();
            }
        }

        my $version = '7.0.0';
        $DBObject->Do(
            SQL  => "INSERT INTO migrations (name, version, created_at) VALUES (?, ?, NOW())",
            Bind => [ \$fileKey, \$version ],
        );
    }


    if($appliedCount) {
        $Self->Print("<green>Migration applied.</green>\n");
    }

    return $Self->ExitCodeOk();
}

1;
