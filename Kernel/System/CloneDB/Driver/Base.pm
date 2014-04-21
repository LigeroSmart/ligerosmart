# --
# Kernel/System/CloneDB/Driver/Base.pm - Clone DB backend functions
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::CloneDB::Driver::Base;

use strict;
use warnings;

use Encode;
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

    # return is dry run
    return 1 if $Param{DryRun};

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

    # get skip tables settings
    my $SkipTables
        = $Self->{ConfigObject}->Get('CloneDB::SkipTables');

    # get a list of tables on Source DB
    my @Tables = $Self->TablesList(
        DBObject => $Self->{SourceDBObject},
    );

    TABLES:
    for my $Table (@Tables) {

        if ( defined $SkipTables->{ lc $Table } && $SkipTables->{ lc $Table } ) {
            print "Skipping table $Table on SanityChecks\n";
            next TABLES;
        }

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

    # get logfile location
    my $LogFile = $Self->{ConfigObject}->Get('CloneDB::LogFile');

    # file handle
    my $FH;

    # get skip tables settings
    my $SkipTables
        = $Self->{ConfigObject}->Get('CloneDB::SkipTables');

    # get a list of tables on Source DB
    my @Tables = $Self->TablesList(
        DBObject => $Self->{SourceDBObject},
    );

    TABLES:
    for my $Table (@Tables) {

        if ( defined $SkipTables->{ lc $Table } && $SkipTables->{ lc $Table } ) {
            print "Skipping table $Table...\n";
            next TABLES;
        }

        print "Converting table $Table...\n" if !$Param{DryRun};

        # on dry run just check tables
        print "Checking table $Table...\n" if $Param{DryRun};

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
               SELECT $ColumnsString
               FROM $Table",
            Limit => 4_000_000_000,
        ) || die @!;

        # if needed, set pre-requisites
        if (
            $Param{TargetDBBackend}->can('SetPreRequisites')
            && grep { $_ eq 'id' } @Columns
            && !$Param{DryRun}
            )
        {

            $Param{TargetDBBackend}->SetPreRequisites(
                DBObject => $Param{TargetDBObject},
                Table    => $Table,
            );
        }

        TABLEROW:
        while ( my @Row = $Self->{SourceDBObject}->FetchrowArray() ) {

            # open logfile
            if ( !open $FH, '>>', $LogFile ) {    ## no critic

                # print error screen
                print STDERR "\n Can't write $LogFile: $! \n";
                return;
            }

            # switch filehandle to utf8 mode if utf-8 is used
            binmode $FH, ':utf8';                 ## no critic

            COLUMNVALUES:
            for my $ColumnCounter ( 1 .. $#Columns ) {
                my $Column = $Columns[$ColumnCounter];

                # get column value
                my $ColumnValue = $Row[$ColumnCounter];

                # verify if the string value have the utf8 flag enabled
                next COLUMNVALUES if !utf8::is_utf8($ColumnValue);

                # check enconding for column value
                if ( !eval { Encode::is_utf8( $ColumnValue, 1 ) } ) {

                    # replace invalid characters with � (U+FFFD, Unicode replacement character)
                    # If it runs on good UTF-8 input, output should be identical to input
                    my $TmpResult = eval {
                        Encode::decode( 'UTF-8', $ColumnValue );
                    };

                    # remove wrong characters
                    if ( $TmpResult =~ m{[\x{FFFD}]}xms ) {
                        $TmpResult =~ s{[\x{FFFD}]}{}xms;
                    }

                    # generate a log message with full info about error and replacement
                    my $ReplacementMessage =
                        "On table: $Table, column: $Column, id: $Row[0] - exists an invalid utf8 value. \n"
                        .
                        " $ColumnValue is replaced by : $TmpResult . \n\n";

                    # write on log file
                    print $FH $ReplacementMessage;

                    # set new vale on Row result from DB
                    $Row[$ColumnCounter] = $TmpResult;
                }

            }

            # in case dry run do nothing more
            next TABLEROW if $Param{DryRun};

            # If the two databases have different blob handling (base64), convert
            #   columns that need it.
            if (
                $Self->{SourceDBObject}->GetDatabaseFunction('DirectBlob')
                != $Param{TargetDBObject}->GetDatabaseFunction('DirectBlob')
                )
            {
                for my $ColumnCounter ( 1 .. $#Columns ) {
                    my $Column = $Columns[$ColumnCounter];

                    next if ( !$Self->{BlobColumns}->{ lc "$Table.$Column" } );

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

            my $Success = $Param{TargetDBObject}->Do(
                SQL  => $SQL,
                Bind => \@Bind,
            );

            if ( !$Success ) {
                print STDERR "Could not insert data: Table: $Table - id:$Row[0]. \n";
                die @! if !$Param{Force};
            }

            $Counter++;
        }

        # in case dry run do nothing more
        next TABLES if $Param{DryRun};

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

    # if DryRun mode is activate, return a diferent value
    return 2 if $Param{DryRun};

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
