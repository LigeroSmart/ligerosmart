# --
# Kernel/System/CloneDB/Driver/Base.pm - Clone DB backend functions
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::CloneDB::Driver::Base;

use strict;
use warnings;

use MIME::Base64;
use Kernel::System::VariableCheck qw(:all);

=head1 NAME

Kernel::System::CloneDB::Driver::Base - common backend functions

=head1 SYNOPSIS

=head1 PUBLIC INTERFACE

=over 4

=cut

#
# Some up-front sanity checks
#
sub SanityChecks {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(TargetDBObject)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # verify DSN for Source and Target DB
    if ( $Self->{SourceDBObject}->{DSN} eq $Param{TargetDBObject}->{DSN} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Source and target database DSN are the same!"
        );
        return;
    }

    # get a list of tables on Source DB
    my @Tables = $Self->TablesList(
        DBObject => $Self->{SourceDBObject},
    );

    for my $Table (@Tables) {

        # check how many rows exists on
        # Target DB for an specific table
        my $TargetRowCount = $Self->RowCount(
            DBObject => $Param{TargetDBObject},
            Table    => $Table,
        );

        # table should exists
        if ( !defined $TargetRowCount ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Required table '$Table' does not seem to exist in the target database!"
            );
            return;
        }

        # and be empty
        if ( $TargetRowCount > 0 ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Table '$Table' in the target database already contains data!"
            );
            return;
        }
    }

    return 1;
}

#
# Get row count of a table.
#
sub RowCount {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DBObject Table)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # execute counting statement
    $Param{DBObject}->Prepare(
        SQL => "
            SELECT COUNT(*)
            FROM $Param{Table}",
    ) || die @!;

    my $Result;
    while ( my @Row = $Param{DBObject}->FetchrowArray() ) {
        $Result = $Row[0];
    }
    return $Result;
}

#
# Transfer the actual table data
#
sub DataTransfer {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(TargetDBObject TargetDBBackend)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # get a list of tables on Source DB
    my @Tables = $Self->TablesList(
        DBObject => $Self->{SourceDBObject},
    );

    for my $Table (@Tables) {
        print "Converting table $Table...\n";

        # Get the list of columns of this table to be able to
        #   generate correct INSERT statements.
        my @Columns = $Self->ColumnsList(
            Table    => $Table,
            DBObject => $Self->{SourceDBObject},
        );
        my $ColumnsString = join( ', ', @Columns );
        my $BindString = join ', ', map {'?'} @Columns;
        my $SQL = "INSERT INTO $Table ($ColumnsString) VALUES ($BindString)";

        my $RowCount = $Self->RowCount(
            DBObject => $Self->{SourceDBObject},
            Table    => $Table,
        );
        my $Counter = 1;

        # Now fetch all the data and insert it to the target DB.
        $Self->{SourceDBObject}->Prepare(
            SQL => "
               SELECT *
               FROM $Table",
            Limit => 4_000_000_000,
        ) || die @!;

        while ( my @Row = $Self->{SourceDBObject}->FetchrowArray() ) {

            # If the two databases have different blob handling (base64), convert
            #   columns that need it.
            if (
                $Self->{SourceDBObject}->GetDatabaseFunction('DirectBlob')
                != $Param{TargetDBObject}->GetDatabaseFunction('DirectBlob')
                )
            {
                for my $ColumnCounter ( 1 .. $#Columns ) {
                    my $Column = $Columns[$ColumnCounter];

                    next if ( !$Self->{BlobColumns}->{"$Table.$Column"} );

                    if ( !$Self->{SourceDBObject}->GetDatabaseFunction('DirectBlob') ) {
                        $Row[$ColumnCounter] = decode_base64( $Row[$ColumnCounter] );
                    }

                    if ( !$Param{TargetDBObject}->GetDatabaseFunction('DirectBlob') ) {
                        $Self->{EncodeObject}->EncodeOutput( \$Row[$ColumnCounter] );
                        $Row[$ColumnCounter] = encode_base64( $Row[$ColumnCounter] );
                    }

                }

            }
            my @Bind = map { \$_ } @Row;

            print "    Inserting $Counter of $RowCount\n" if $Counter % 1000 == 0;

            $Param{TargetDBObject}->Do(
                SQL  => $SQL,
                Bind => \@Bind,
            ) || die @!;

            $Counter++;
        }

        # if needed, reset the autoincremental field
        if (
            $Param{TargetDBBackend}->can('ResetAutoIncrementField')
            && grep { $_ eq 'id' } @Columns
            )
        {

            $Param{TargetDBBackend}->ResetAutoIncrementField(
                DBObject => $Param{TargetDBObject},
                Table    => $Table,
            );
        }

        print "Finished converting table $Table.\n";
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
