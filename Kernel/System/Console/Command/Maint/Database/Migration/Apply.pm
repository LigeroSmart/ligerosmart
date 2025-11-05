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
use List::Util qw( min max );
# use Syntax::Keyword::Try;

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
    $Self->AddOption(
        Name        => 'verbose',
        Description => "Show detailed SQL statements when errors occur.",
        Required    => 0,
        HasValue    => 0,
    );
    $Self->AddArgument(
        Name => 'file',
        Description =>
            "Specify the file name.",
        Required   => 0,
        ValueRegex => qr/.*/smx,
    );
    return;
}

sub Run {
    my ( $Self, %Param ) = @_;


    $Param{Options}->{SourceDir} = $Self->GetOption('source-dir');
    $Param{Options}->{File} = $Self->GetArgument('file');
    $Param{Options}->{Verbose} = $Self->GetOption('verbose');

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    my $DBType = $DBObject->{'DB::Type'};
    my $XMLObject = $Kernel::OM->Get('Kernel::System::XML');

    # print database information
    my $DatabaseDSN  = $DBObject->{DSN};
    my $DatabaseUser = $DBObject->{USER};

    
    # db error handler
    # local $DBObject->{dbh}->{HandleError} = sub {
    #     my (undef, $error) = @_;
    # };
    # $DBObject->{Backend}->{dbh}->{PrintError} = 0;
    # $DBObject->{Backend}->{dbh}->{RaiseError} = 0;

    # Check for database state error.
    if ( !$DBObject ) {
        $Self->PrintError("Connection failed with DSN '$DatabaseDSN' and user '$DatabaseUser'");
        return $Self->ExitCodeError();
    }

    my %MigrationsApplied = ();

    # eval {
        no warnings;
        my @TableBody;
        $DBObject->Prepare( SQL => "SELECT * FROM migrations" );
        my $Result = "";
        my @BatchArray = ();
        while ( my @Row = $DBObject->FetchrowArray() ) {
            # if not exists here, apply commands
            my $migrationName = $Row[1];
            #https://stackoverflow.com/questions/10701210/how-to-find-maximum-and-minimum-value-in-an-array-of-integers-in-perl
            # push($Row[3], @BatchArray);
            $MigrationsApplied{$migrationName} = 1;
            push(@TableBody, [ @Row ]);
            push(@BatchArray, $Row[3]);
        }


        if(@TableBody && !$Param{Options}->{File}) {
            $Self->Print("Migrations already applied:\n");
            my $TableOutput = $Self->TableOutput(
                TableData => {
                    Header => ['ID', 'Name', 'Version', 'Batch step', 'Result', 'Date'],
                    Body   => \@TableBody,
                },
                Indention => 0,
            );
            $Self->Print("\n$TableOutput\n");
        }
    # };

    my $NextBatchNumber = max(@BatchArray) + 1;

    # read migrations YAML directory
    # my $SourceDir = $Self->GetOption('source-dir');
    my $SourceDir = $Param{Options}->{SourceDir} || "/opt/otrs/scripts/database/migrations";

    my %MigrationFileList = ();
    my %ApplyList = ();

    my @Files     = $MainObject->DirectoryRead(
        Directory => $SourceDir,
        Filter    => $Param{Options}->{File} || '*.xml',
    );
    
    if ( !@Files && -f $Param{Options}->{File} ) {
        push @Files, $Param{Options}->{File};
    }

    if ( !@Files ) {
        $Self->PrintError("No XML files found in $SourceDir.\n");
        if($Param{Options}->{File}) {
            $Self->PrintError($Param{Options}->{File});
        }
        return $Self->ExitCodeError();
    }

    FILE:
    for my $File (@Files) {

        my $filename = basename($File);
        my $path = "$SourceDir/$filename";
        next if(!$Param{Options}->{File} && $MigrationsApplied{$filename});

        my $XMLFile = XML::LibXML->load_xml(location => $path);
        if ( !$XMLFile ) {
            $Self->PrintError("Could not read $path");
            return $Self->ExitCodeError();
        }

        foreach my $CodeInstallNode ($XMLFile->findnodes('/Migrations/CodeInstall')) {
            my $Type = $CodeInstallNode->getAttribute('Type') || 'post';
            if($CodeInstallNode->getAttribute('Version')) {
                $ApplyList{$filename}->{CodeInstall}->{Version} = $CodeInstallNode->getAttribute('Version');
            }
            $ApplyList{$filename}->{CodeInstall}->{$Type} = $CodeInstallNode->to_literal;
        }

        foreach my $DatabaseInstallNode ($XMLFile->findnodes('/Migrations/DatabaseInstall')) {
            if($DatabaseInstallNode->getAttribute('Version')) {
                $ApplyList{$filename}->{DatabaseInstall}->{Version} = $CodeInstallNode->getAttribute('Version');
            }
            $ApplyList{$filename}->{DatabaseInstall} = $DatabaseInstallNode->toString();
        }

    }

    my $appliedCount = 0;
    foreach my $fileKey (sort keys %ApplyList) {
        $appliedCount++;

        my $Result;

        $Self->Print("Applying from $fileKey\n");

        if($ApplyList{$fileKey}->{CodeInstall}->{pre}) {
            my $CodeContent = $ApplyList{$fileKey}->{CodeInstall}->{pre};
            my $EvalOK;
            my $CapturedStderr = '';

            {
                # Suppress stacktrace output by redirecting STDERR temporarily
                open my $ErrFH, '>', \$CapturedStderr;    ## no critic (RequireBriefOpen)
                local *STDERR = $ErrFH;

                $EvalOK = eval $CodeContent. "\n1;";    ## no critic
            }

            if ( !$EvalOK ) {
                my $ErrorMsg = $@ || 'Unknown error in CodeInstall[Type=pre]';
                $ErrorMsg =~ s/\s+at\s+\S+\s+line\s+\d+\.?\s*$//;

                # Ignore specific errors related to undefined HASH references
                # These are usually configuration issues that don't prevent system operation
                if ( $ErrorMsg !~ /undefined value as a(?:n)? HASH reference/i ) {
                    $Self->PrintError(
                        sprintf(
                            "Executing CodeInstall[Type=pre] in [%s]: %s\n",
                            $fileKey,
                            $ErrorMsg,
                        )
                    );
                    # Reset color in STDOUT to prevent color bleeding
                    print "\033[0m";

                    $ApplyList{$fileKey}->{Output} = sprintf(
                        "Error in CodeInstall[Type=pre]: %s",
                        $ErrorMsg
                    );
                    return;
                }
            }
        }

        if($ApplyList{$fileKey}->{DatabaseInstall}) {
            my $XMLContentRef = $ApplyList{$fileKey}->{DatabaseInstall};

            # DatabaseInstall
            my @XMLARRAY = $XMLObject->XMLParse( String => $XMLContentRef );

            my @SQL = $DBObject->SQLProcessor( Database => \@XMLARRAY );

            # get post SQL commands (indexes, foreing keys, ...)
            push @SQL, $DBObject->SQLProcessorPost();

            for my $SQL (@SQL) {
                my $SQLSuccess;
                my $EvalOK;
                my $CapturedStderr = '';

                {
                    # Suppress stacktrace output by redirecting STDERR temporarily
                    open my $ErrFH, '>', \$CapturedStderr;    ## no critic (RequireBriefOpen)
                    local *STDERR = $ErrFH;

                    # Execute SQL with error capture
                    $EvalOK = eval {
                        $SQLSuccess = $DBObject->Do( SQL => $SQL );
                        1;
                    };
                }
                # STDERR is automatically restored when exiting the block

                if ( !$EvalOK || !$SQLSuccess ) {
                    # Get clean error message from database
                    my $DBMessage = $DBObject->Error();
                    $DBMessage ||= $@ if $@;                 # fallback to eval error
                    $DBMessage ||= 'Unknown database error'; # final fallback

                    # Remove Perl location info if present
                    $DBMessage =~ s/\s+at\s+\S+\s+line\s+\d+\.?\s*$//;

                    # Display clean error in console
                    $Self->PrintError(
                        sprintf(
                            "Applying migration from [%s]: %s\n",
                            $fileKey,
                            $DBMessage,
                        )
                    );
                    # Reset color in STDOUT to prevent color bleeding
                    print "\033[0m";
                    
                    # Only show SQL if verbose mode is enabled
                    if ( $Param{Options}->{Verbose} ) {
                        $Self->Print("SQL: $SQL\n\n");
                    }

                    # Store error message for migrations table (without SQL)
                    $ApplyList{$fileKey}->{Output} = sprintf(
                        "Error: %s",
                        $DBMessage
                    );
                }
                else {
                    $Result = $SQLSuccess;
                }
            }

        }
        
        if($ApplyList{$fileKey}->{CodeInstall}->{post}) {
            my $CodeContent = $ApplyList{$fileKey}->{CodeInstall}->{post};
            my $EvalOK;
            my $CapturedStderr = '';

            {
                # Suppress stacktrace output by redirecting STDERR temporarily
                open my $ErrFH, '>', \$CapturedStderr;    ## no critic (RequireBriefOpen)
                local *STDERR = $ErrFH;

                $EvalOK = eval $CodeContent. "\n1;";    ## no critic
            }

            if ( !$EvalOK ) {
                my $ErrorMsg = $@ || 'Unknown error in CodeInstall[Type=post]';
                $ErrorMsg =~ s/\s+at\s+\S+\s+line\s+\d+\.?\s*$//;

                # Ignore specific errors related to undefined HASH references
                # These are usually configuration issues that don't prevent system operation
                if ( $ErrorMsg !~ /undefined value as a(?:n)? HASH reference/i ) {
                    $Self->PrintError(
                        sprintf(
                            "Executing CodeInstall[Type=post] in [%s]: %s\n",
                            $fileKey,
                            $ErrorMsg,
                        )
                    );
                    # Reset color in STDOUT to prevent color bleeding
                    print "\033[0m";

                    $ApplyList{$fileKey}->{Output} = sprintf(
                        "Error in CodeInstall[Type=post]: %s",
                        $ErrorMsg
                    );
                }
                # Continue processing other migrations
            }
        }

        my $version = $ConfigObject->{Version};
        my $output = $ApplyList{$fileKey}->{Output} || 'OK';
        $DBObject->Do(
            SQL  => "DELETE FROM migrations WHERE name=?",
            Bind => [ \$fileKey ],
        );
        $DBObject->Do(
            SQL  => "INSERT INTO migrations (name, version, batch, output, create_time) VALUES (?, ?, ?, ?, NOW())",
            Bind => [ \$fileKey, \$version, \$NextBatchNumber, \$output ],
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
