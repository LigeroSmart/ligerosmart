# --
# Kernel/System/CloneDB/Driver/Base.pm - Clone DB backend functions
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
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

use Kernel::System::DB;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Encode',
    'Kernel::System::Log',
    'Kernel::System::Time',
);

=head1 NAME

Kernel::System::CloneDB::Driver::Base - common backend functions

=head1 SYNOPSIS

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();

    $Kernel::OM->ObjectParamAdd(
        'Kernel::System::CloneDB::Driver::Base' => {
            BlobColumns => $BlobColumns,
            CheckEncodingColumns => $CheckEncodingColumns,
        },
    );
    my $CloneDBBaseObject = $Kernel::OM->Get('Kernel::System::CloneDB::Driver::Base');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for my $Needed (
        qw(BlobColumns CheckEncodingColumns)
        )
    {
        die "Got no $Needed!" if !$Param{$Needed};

        $Self->{$Needed} = $Param{$Needed};
    }

    return $Self;
}

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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    # verify DSN for Source and Target DB
    if ( $Kernel::OM->Get('Kernel::System::DB')->{DSN} eq $Param{TargetDBObject}->{DSN} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Source and target database DSN are the same!"
        );
        return;
    }

    # get skip tables settings
    my $SkipTables = $Kernel::OM->Get('Kernel::Config')->Get('CloneDB::SkipTables');

    # get a list of tables on Source DB
    my @Tables = $Self->TablesList(
        DBObject => $Kernel::OM->Get('Kernel::System::DB'),
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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Required table '$Table' does not seem to exist in the target database!"
            );
            return;
        }

        # and be empty
        if ( $TargetRowCount > 0 ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    # get logfile location
    my $LogFile = $Kernel::OM->Get('Kernel::Config')->Get('CloneDB::LogFile');

    # file handle
    my $FH;

    # get skip tables settings
    my $SkipTables = $Kernel::OM->Get('Kernel::Config')->Get('CloneDB::SkipTables');

    # get a list of tables on Source DB
    my @Tables = $Self->TablesList(
        DBObject => $Kernel::OM->Get('Kernel::System::DB'),
    );

    TABLES:
    for my $Table (@Tables) {

        if ( defined $SkipTables->{ lc $Table } && $SkipTables->{ lc $Table } ) {
            $Self->PrintWithTime("Skipping table $Table...\n");
            next TABLES;
        }

        if ( $Param{DryRun} ) {
            $Self->PrintWithTime("Checking table $Table...\n") if $Param{DryRun};
        }
        else {
            $Self->PrintWithTime("Converting table $Table...\n")
        }

        # Get the list of columns of this table to be able to
        #   generate correct INSERT statements.
        my @Columns = $Self->ColumnsList(
            Table    => $Table,
            DBObject => $Kernel::OM->Get('Kernel::System::DB'),
        );
        my $ColumnsString = join( ', ', @Columns );
        my $BindString = join ', ', map {'?'} @Columns;
        my $SQL = "INSERT INTO $Table ($ColumnsString) VALUES ($BindString)";

        my $RowCount = $Self->RowCount(
            DBObject => $Kernel::OM->Get('Kernel::System::DB'),
            Table    => $Table,
        );
        my $Counter = 1;

        # Now fetch all the data and insert it to the target DB.
        $Kernel::OM->Get('Kernel::System::DB')->Prepare(
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
        while ( my @Row = $Kernel::OM->Get('Kernel::System::DB')->FetchrowArray() ) {

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
                    } || '';

                    # remove wrong characters
                    if ( $TmpResult =~ m{[\x{FFFD}]}xms ) {
                        $TmpResult =~ s{[\x{FFFD}]}{}xms;
                    }

                    # generate a log message with full info about error and replacement
                    my $ReplacementMessage =
                        "On table: $Table, column: $Column, id: $Row[0] - exists an invalid utf8 value. \n"
                        .
                        " $ColumnValue is replaced by : $TmpResult . \n\n";

                    # open logfile
                    if ( !open $FH, '>>', $LogFile ) {    ## no critic

                        # print write error
                        print STDERR "\n Can't write $LogFile: $! \n";
                        return;
                    }

                    # switch filehandle to utf8 mode if utf-8 is used
                    binmode $FH, ':utf8';                 ## no critic

                    # write on log file
                    print $FH $ReplacementMessage;

                    # close the filehandle
                    close $FH;

                    # set new vale on Row result from DB
                    $Row[$ColumnCounter] = $TmpResult;

                }

                # Only for mysql
                if ( $Row[$ColumnCounter] && $Param{TargetDBObject}->{'DB::Type'} eq 'mysql' ) {

                    # Replace any unicode characters that need more then three bytes in UTF8
                    #   with the unicode replacement character. MySQL's utf8 encoding only
                    #   supports three bytes. In future we might want to use utf8mb4 (supported
                    #   since 5.5.3+).
                    # See also http://mathiasbynens.be/notes/mysql-utf8mb4.
                    $Row[$ColumnCounter] =~ s/([\x{10000}-\x{10FFFF}])/"\x{FFFD}"/eg;
                }

            }

            # in case dry run do nothing more
            next TABLEROW if $Param{DryRun};

            # If the two databases have different blob handling (base64), convert
            #   columns that need it.
            if (
                $Kernel::OM->Get('Kernel::System::DB')->GetDatabaseFunction('DirectBlob')
                != $Param{TargetDBObject}->GetDatabaseFunction('DirectBlob')
                )
            {
                COLUMN:
                for my $ColumnCounter ( 1 .. $#Columns ) {
                    my $Column = $Columns[$ColumnCounter];

                    next COLUMN if ( !$Self->{BlobColumns}->{ lc "$Table.$Column" } );

                    if ( !$Kernel::OM->Get('Kernel::System::DB')->GetDatabaseFunction('DirectBlob') ) {
                        $Row[$ColumnCounter] = decode_base64( $Row[$ColumnCounter] );
                    }

                    if ( !$Param{TargetDBObject}->GetDatabaseFunction('DirectBlob') ) {
                        Kernel::OM->Get('Kernel::System::Encode')->EncodeOutput( \$Row[$ColumnCounter] );
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

        $Self->PrintWithTime("Finished converting table $Table.\n");
    }

    # if DryRun mode is activate, return a diferent value
    return 2 if $Param{DryRun};

    return 1;
}

sub PrintWithTime {
    my $Self = shift;

    my $TimeStamp = $Kernel::OM->Get('Kernel::System::Time')->SystemTime2TimeStamp(
        SystemTime => $Kernel::OM->Get('Kernel::System::Time')->SystemTime(),
    );

    print "[$TimeStamp] ", @_;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
