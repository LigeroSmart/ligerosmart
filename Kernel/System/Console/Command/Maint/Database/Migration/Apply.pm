# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Maint::Database::Migration::Apply;

# use strict;
# use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::DB',
);

use File::Basename;
use XML::LibXML;
# use Syntax::Keyword::Try;
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

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    my $DBType = $DBObject->{'DB::Type'};
    my $XMLObject = $Kernel::OM->Get('Kernel::System::XML');

    # print database information
    my $DatabaseDSN  = $DBObject->{DSN};
    my $DatabaseUser = $DBObject->{USER};

    # Check for database state error.
    if ( !$DBObject ) {
        $Self->PrintError("Connection failed with DSN '$DatabaseDSN' and user '$DatabaseUser'");
        return $Self->ExitCodeError();
    }

    my %MigrationsApplied = ();

    eval {
        no warnings;

        $DBObject->Prepare( SQL => "SELECT * FROM migrations" );
        my $Result = "";
        while ( my @Row = $DBObject->FetchrowArray() ) {
            # if not exists here, apply commands
            $Result .= join("\t", @Row)."\n";
            my $migrationName = $Row[1];
            $MigrationsApplied{$migrationName} = 1;
        }

        if($Result) {
            $Self->Print("Migrations already applied:\n");
            $Self->Print($Result);
        }
    };


    # read migrations YAML directory
    # my $SourceDir = $Self->GetOption('source-dir');
    my $SourceDir = $Param{Options}->{SourceDir} || "/opt/otrs/Kernel/Database/Migrations";

    my %MigrationFileList = ();
    my %ApplyList = ();

    my @Files     = $MainObject->DirectoryRead(
        Directory => $SourceDir,
        Filter    => '*.xml',
    );

    if ( !@Files ) {
        $Self->PrintError("No XML files found in $SourceDir.");
        return $Self->ExitCodeError();
    }

    FILE:
    for my $File (@Files) {

        my $filename = basename($File);
        next if($MigrationsApplied{$filename});

        my $XMLFile = XML::LibXML->load_xml(location => "$SourceDir/$filename");
        if ( !$XMLFile ) {
            $Self->PrintError("Could not read $SourceDir/$filename");
            return $Self->ExitCodeError();
        }

        my $XMLNode = $XMLFile->findnodes('/Migrations/DatabaseInstall/*')->[0];

        if( $XMLNode ) {
            $ApplyList{$filename} = $XMLNode->toString();
        }

    }

    my $appliedCount = 0;
    foreach my $fileKey (sort keys %ApplyList) {
        $appliedCount++;

        my $Result;

        if($ApplyList{$fileKey}) {
            my $XMLContentRef = $ApplyList{$fileKey};

            $Self->Print("Applying from $fileKey\n");
            my @XMLARRAY = $XMLObject->XMLParse( String => $XMLContentRef );

            my @SQL = $DBObject->SQLProcessor( Database => \@XMLARRAY );

            for my $SQL (@SQL) {
                $Result = $DBObject->Do( SQL => $SQL );
                if ( ! $Result ) {
                    $Self->PrintError("Error executing SQL: \n\t$SQL\n");
                    $DBObject->Error();
                    return $Self->ExitCodeError();
                }
            }

        }

        my $version = '7.0.0';
        $DBObject->Do(
            SQL  => "INSERT INTO migrations (name, version, create_time) VALUES (?, ?, NOW())",
            Bind => [ \$fileKey, \$version ],
        );
    }

    if($appliedCount) {
        $Self->Print("<green>Migration applied.</green>\n");
    }

    return $Self->ExitCodeOk();
}

# sub _CreateMigrationsTable {

#     my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
#     my $DBType = $DBObject->{'DB::Type'};
#     # create migrations table if not exists
#     if($DBType == 'mysql') {
#         $DBObject->Do( 
#             SQL =>  "CREATE TABLE `migrations` (
#                 `id` int(11) AUTO_INCREMENT PRIMARY KEY,
#                 `name` varchar(50) NOT NULL,
#                 `version` varchar(10) NOT NULL,
#                 `created_at` datetime NOT NULL
#             ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='database modifications history';"
#         );
#     }

#     if($DBType == 'postgresql') {
#         # TODO: check compatibility
#         # $DBObject->Do( 
#         #     SQL =>  "CREATE TABLE `migrations` (;"
#         # );
#     }

#     if($DBType == 'oracle') {
#         # TODO: check compatibility
#         # $DBObject->Do( 
#         #     SQL =>  "CREATE TABLE `migrations` (;"
#         # );
#     }
# }

1;
