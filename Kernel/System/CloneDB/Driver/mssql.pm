# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::CloneDB::Driver::mssql;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

use parent qw(Kernel::System::CloneDB::Driver::Base);

our @ObjectDependencies = (
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::CloneDB::Driver::mssql

=head1 SYNOPSIS

CloneDBs C<mssql> Driver delegate

=head1 PUBLIC INTERFACE

This module implements the public interface of L<Kernel::System::CloneDB::Backend>.
Please look there for a detailed reference of the functions.

=over 4

=cut

#
# create external db connection.
#
sub CreateTargetDBConnection {
    my ( $Self, %Param ) = @_;

    # check TargetDBSettings
    for my $Needed (
        qw(TargetDatabaseHost TargetDatabase TargetDatabaseUser TargetDatabasePw TargetDatabaseType)
        )
    {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed for external DB settings!",
            );

            return;
        }
    }

    # set default driver
    if ( !defined $Param{TargetDatabaseDriver} ) {
        $Param{TargetDatabaseDriver} = 'SQL Server';
    }

    # include DSN for target DB
    $Param{TargetDatabaseDSN} =
        "DBI:ODBC:driver={$Param{TargetDatabaseDriver}};Database=$Param{TargetDatabase};Server=$Param{TargetDatabaseHost};";

    # create target DB object
    my $TargetDBObject = Kernel::System::DB->new(
        DatabaseDSN  => $Param{TargetDatabaseDSN},
        DatabaseUser => $Param{TargetDatabaseUser},
        DatabasePw   => $Param{TargetDatabasePw},
        Type         => $Param{TargetDatabaseType},
    );

    if ( !$TargetDBObject ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not connect to target DB!",
        );

        return;
    }

    return $TargetDBObject;
}

#
# List all tables in the source database in alphabetical order.
#
sub TablesList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{DBObject} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need DBObject!",
        );

        return;
    }

    $Param{DBObject}->Prepare(
        SQL => "
            SELECT TABLE_NAME
            FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_TYPE = 'BASE TABLE'
            ORDER BY TABLE_NAME ASC",
    ) || die @!;

    my @Result;
    while ( my @Row = $Param{DBObject}->FetchrowArray() ) {
        push @Result, $Row[0];
    }

    return @Result;
}

#
# List all columns of a table in the order of their position.
#
sub ColumnsList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DBObject Table)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    $Param{DBObject}->Prepare(
        SQL => "
            SELECT column_name
            FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_NAME = ?",
        Bind => [
            \$Param{Table},
        ],
    ) || die @!;

    my @Result;
    while ( my @Row = $Param{DBObject}->FetchrowArray() ) {
        push @Result, $Row[0];
    }
    return @Result;
}

#
# Reset the 'id' auto-increment field to the last one in the table.
#
sub ResetAutoIncrementField {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DBObject Table)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    $Param{DBObject}->Prepare(
        SQL => "
            SELECT id
            FROM $Param{Table}
            ORDER BY id DESC",
        Limit => 1,
    ) || die @!;

    my $LastID;
    ROW:
    while ( my @Row = $Param{DBObject}->FetchrowArray() ) {
        $LastID = $Row[0];
        last ROW;
    }

    if ($LastID) {

        # add one more to the last ID
        $LastID++;

        # set increment as last number on the id field, plus one
        my $SQL = "DBCC CHECKIDENT('$Param{Table}', RESEED, $LastID)";

        $Param{DBObject}->Prepare(
            SQL => $SQL,
        ) || die @!;

    }

    $Param{DBObject}->Prepare(
        SQL   => "select OBJECTPROPERTY(object_id('$Param{Table}'), 'TableHasIdentity')",
        Limit => 1,
    ) || die @!;

    my $TableHasIdentity = 0;
    while ( my @Row = $Param{DBObject}->FetchrowArray() ) {
        $TableHasIdentity = $Row[0];
    }

    if ( $TableHasIdentity eq '1' ) {

        # set IDENTITY_INSERT to OFF
        my $SQL = "SET IDENTITY_INSERT $Param{Table} OFF";

        $Param{DBObject}->Do(
            SQL => $SQL,
        ) || die @!;

    }

    return 1;
}

#
# Set pre-requisites in the table.
#
sub SetPreRequisites {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DBObject Table)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    $Param{DBObject}->Prepare(
        SQL   => "select OBJECTPROPERTY(object_id('$Param{Table}'), 'TableHasIdentity')",
        Limit => 1,
    ) || die @!;

    my $TableHasIdentity = 0;
    while ( my @Row = $Param{DBObject}->FetchrowArray() ) {
        $TableHasIdentity = $Row[0];
    }

    if ( $TableHasIdentity eq '1' ) {

        # set IDENTITY_INSERT to ON
        my $SQL = "SET IDENTITY_INSERT $Param{Table} ON";

        $Param{DBObject}->Do(
            SQL => $SQL,
        ) || die @!;

    }

    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
