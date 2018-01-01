# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::CloneDB::Driver::oracle;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

use parent qw(Kernel::System::CloneDB::Driver::Base);

our @ObjectDependencies = (
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::CloneDB::Driver::oracle

=head1 SYNOPSIS

CloneDBs oracle Driver delegate

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

    # set default sid
    if ( !defined $Param{TargetDatabaseSID} ) {
        $Param{TargetDatabaseSID} = 'XE';
    }

    # set default sid
    if ( !defined $Param{TargetDatabasePort} ) {
        $Param{TargetDatabasePort} = '1521';
    }

    # include DSN for target DB
    $Param{TargetDatabaseDSN} =
        "DBI:Oracle:sid=$Param{TargetDatabaseSID};host=$Param{TargetDatabaseHost};port=$Param{TargetDatabasePort};";

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
            SELECT table_name
            FROM user_tables
            ORDER BY table_name ASC",
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
                Message  => "Need $Needed!"
            );

            return;
        }
    }

    $Param{DBObject}->Prepare(
        SQL => "SELECT column_name
                FROM all_tab_columns
                WHERE table_name = ?",
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
    while ( my @Row = $Param{DBObject}->FetchrowArray() ) {
        $LastID = $Row[0];
    }

    # add one more to the last ID
    $LastID++;

    my $SEName = 'SE_' . uc $Param{Table};

    # we assume the sequence have a minimum value (0)
    # we will to increase it till the last entry on
    # if field we have

    # verify if the sequence exists
    $Param{DBObject}->Prepare(
        SQL => "
            SELECT COUNT(*)
            FROM user_sequences
            WHERE sequence_name = ?",
        Limit => 1,
        Bind  => [
            \$SEName,
        ],
    ) || die @!;

    my $SequenceCount;
    while ( my @Row = $Param{DBObject}->FetchrowArray() ) {
        $SequenceCount = $Row[0];
    }

    if ($SequenceCount) {

        # set increment as last number on the id field, plus one
        my $SQL = "ALTER SEQUENCE $SEName INCREMENT BY $LastID";

        $Param{DBObject}->Do(
            SQL => $SQL,
        ) || die @!;

        # get next value for sequence
        $SQL = "SELECT $SEName.nextval FROM dual";

        $Param{DBObject}->Prepare(
            SQL => $SQL,
        ) || die @!;

        my $ResultNextVal;
        while ( my @Row = $Param{DBObject}->FetchrowArray() ) {
            $ResultNextVal = $Row[0];
        }

        # reset sequence to increment by 1 to 1
        $SQL = "ALTER SEQUENCE $SEName INCREMENT BY 1";

        $Param{DBObject}->Do(
            SQL => $SQL,
        ) || die @!;
    }

    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
