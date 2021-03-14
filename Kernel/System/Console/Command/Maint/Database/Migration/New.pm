package Kernel::System::Console::Command::Maint::Database::Migration::New;

# use strict;
# use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::DB',
);

use POSIX qw(strftime);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Add new file database modifications to current version application');
    $Self->AddOption(
        Name        => 'source-dir',
        Description => "Specify the source dir.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddArgument(
        Name => 'suffix',
        Description =>
            "Specify the suffix file name.",
        Required   => 1,
        ValueRegex => qr/.*/smx,
    );
    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Param{Options}->{SourceDir} = $Self->GetOption('source-dir') || '/opt/otrs/Kernel/Database/Migrations';
    $Param{Options}->{Suffix} = $Self->GetArgument('suffix');

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    my $Template = '<Migrations>
    <DatabaseInstall>
        <!-- apply procedure here -->
    </DatabaseInstall>
    <DatabaseUninstall>
        <!-- rollback procedure here -->
    </DatabaseUninstall>
</Migrations>';

    my $FilePreffix = strftime "%Y%d%m%H%M%S", localtime;
    my $FileSuffix = $Param{Options}->{Suffix};

    my $TargetPath = $Param{Options}->{SourceDir} . "/" . $FilePreffix . "_" . $FileSuffix . ".xml";

    if ( -f $TargetPath ) {
        $Self->PrintError("File $TargetPath already exists");
        return $Self->ExitCodeError();
    }

    my $Success = $MainObject->FileWrite(
        Location => $TargetPath,
        Content  => \$Template,
        Mode     => 'utf8',
    );


    $Self->Print("File $TargetPath created\n");

    return $Self->ExitCodeOk();
}

1;
