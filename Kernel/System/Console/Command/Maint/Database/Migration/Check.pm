# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Maint::Database::Migration::Check;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::DB',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Check LigeroSmart database connectivity.');
    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

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
    $DBObject->Prepare( SQL => "SELECT * FROM migrations" );
    my $Check = 0;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Check++;
    }
    if ( !$Check ) {
        $Self->PrintError("Connection was successful, but database content is missing.");
        system('otrs.Console.pl Maint::Database::Migration::Apply');
        return $Self->ExitCodeError();
    }
    $Self->Print("<green>Connection successful.</green>\n");

    return $Self->ExitCodeOk();
}

1;
