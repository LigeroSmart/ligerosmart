# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Maint::Database::Migration::Rollback;

# use strict;
# use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::YAML',
);

use XML::LibXML;
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

    $Param{Options}->{SourceDir} = $Self->GetOption('source-dir') || "/opt/otrs/Kernel/Database/Migrations";

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

    my $SourceDir = $Param{Options}->{SourceDir};

    my $Count = 0;

    # eval {

        $DBObject->Prepare( SQL => "SELECT * FROM migrations ORDER BY id DESC LIMIT 1" );
        MIGRATION:
        while ( my @Row = $DBObject->FetchrowArray() ) {

            $Count++;

            # if not exists here, rollback commands
            $Self->Print(join("\t", @Row)."\n");

            my $migrationId = $Row[0];
            my $migrationName = $Row[1];

            my $XMLFile = XML::LibXML->load_xml(location => "$SourceDir/$migrationName");
            if ( !$XMLFile ) {
                $Self->PrintError("Could not read $SourceDir/$migrationName");
                return $Self->ExitCodeError();
            }

            my $XMLNode = $XMLFile->findnodes('/Migrations/DatabaseUninstall/*')->[0];
            if ( $XMLNode ) {
                my $XMLContentRef = $XMLNode->toString();
                
                $Self->Print("Rollback $migrationName\n");

                my @XMLARRAY = $XMLObject->XMLParse( String => $XMLContentRef );
                my @SQL = $DBObject->SQLProcessor( Database => \@XMLARRAY );
                my $Result;
                for my $SQL (@SQL) {
                    $Result = $DBObject->Do( SQL => $SQL );
                    if ( ! $Result ) {
                        $Self->PrintError("Error executing SQL: \n\t$SQL\n");
                        $DBObject->Error();
                        return $Self->ExitCodeError();
                    }
                }
            }

            $DBObject->Do(
                SQL  => "DELETE FROM migrations WHERE id=?",
                Bind => [ \$migrationId ],
            );

            $Self->Print("<green>Migration rollbacked.</green>\n");

        }
    # }; # eval

    if ( !$Count ) {
        $Self->Print("nothing to do\n");
    }

    # print "MigrationFileList\n";
    # print Dumper(%MigrationFileList);
    # print "ApplyList\n";
    # print Dumper(%ApplyList);

    return $Self->ExitCodeOk();
}

1;
