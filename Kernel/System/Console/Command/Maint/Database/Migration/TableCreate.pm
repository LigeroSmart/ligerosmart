 

package Kernel::System::Console::Command::Maint::Database::Migration::TableCreate;

# use strict;
# use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::DB',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Create table migrations');
    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    my $DBType = $DBObject->{'DB::Type'};
    my $XMLObject = $Kernel::OM->Get('Kernel::System::XML');

    my $XMLContentRef = '<DatabaseInstall>
        <TableCreate Name="migrations">
	   	    <Column AutoIncrement="true" Name="id" PrimaryKey="true" Required="true" Type="INTEGER" />
            <Column Name="name" Required="true" Size="60" Type="VARCHAR"/>
            <Column Name="version" Required="true" Size="20" Type="VARCHAR"/>
            <Column Name="batch" Type="INTEGER"/>
            <Column Name="create_time" Type="DATE" />
            <Index Name="migrations_name_idx">
                <IndexColumn Name="name"/>
            </Index>
        </TableCreate>
    </DatabaseInstall>';

    $Self->Print("Creating migrations table\n");
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

    return $Self->ExitCodeOk();
}


1;
