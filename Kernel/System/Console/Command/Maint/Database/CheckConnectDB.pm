# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# Kernel/System/Console/Command/Maint/Database/CheckConnectDB.pm
# --

package Kernel::System::Console::Command::Maint::Database::CheckConnectDB;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Main',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Check OTRS database connectivity.');
    $Self->AddOption(
        Name        => 'type',
        Description => 'Repairs invalid database schema (like deleting invalid default values for datetime fields).',
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'dsn',
        Description => 'Repairs invalid database schema (like deleting invalid default values for datetime fields).',
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'user',
        Description => 'Repairs invalid database schema (like deleting invalid default values for datetime fields).',
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'password',
        Description => 'Repairs invalid database schema (like deleting invalid default values for datetime fields).',
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'sql',
        Description => 'Repairs invalid database schema (like deleting invalid default values for datetime fields).',
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    local $Kernel::OM = Kernel::System::ObjectManager->new(
        'Kernel::System::DB' => {
            # if you don't supply the following parameters, the ones found in
            # Kernel/Config.pm are used instead:
            DatabaseDSN  => $Self->GetOption('dsn'), #'DBI:odbc:database=123;host=localhost;',
            DatabaseUser => $Self->GetOption('user'), #'user',
            DatabasePw   => $Self->GetOption('password'), #'somepass',
            Type         => $Self->GetOption('type'), #'mysql',
            IsSlaveDB    => 1,
            Attribute => {
                LongTruncOk => 1,
                LongReadLen => 100*1024,
            },
        },
    ); 

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # print database information
    my $DatabaseDSN  = $DBObject->{DSN};
    my $DatabaseUser = $DBObject->{USER};
    my $DatabaseType = $DBObject->{'DB::Type'};

    my $DatabaseVersion = $DBObject->Version();

    $Self->Print("<yellow>Trying to connect to database '$DatabaseDSN', type '$DatabaseType', version '$DatabaseVersion' and with user '$DatabaseUser'...</yellow>\n");

    # Check for database state error.
    if ( !$DBObject ) {
        $Self->PrintError('Connection failed.');
        return $Self->ExitCodeError();
    }

    # Try to get some data from the database.
    $DBObject->Prepare( SQL => $Self->GetOption('sql') );
    my $Check = 0;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Check++;
    }
    if ( !$Check ) {
        $Self->PrintError("Connection was successful, but database content is missing.");
        return $Self->ExitCodeError();
    }
    $Self->Print("<green>Connection successful.</green>\n");

    return $Self->ExitCodeOk();
}

1;