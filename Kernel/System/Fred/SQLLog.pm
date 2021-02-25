# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Fred::SQLLog;
## no critic(Perl::Critic::Policy::OTRS::ProhibitOpen)

use strict;
use warnings;

use Time::HiRes qw(gettimeofday tv_interval);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::Fred::SQLLog

=head1 SYNOPSIS

Show a log of the SQL statements executed since the last view of the log.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    if (
        ref $ConfigObject->Get('Fred::Module')
        && $ConfigObject->Get('Fred::Module')->{SQLLog}
        )
    {
        $Self->{Active} = $ConfigObject->Get('Fred::Module')->{SQLLog}->{Active};
    }

    return $Self;
}

=item DataGet()

Get the data for this Fred module. Returns true or false.
And add the data to the module ref.

    $BackendObject->DataGet(
        ModuleRef => $ModuleRef,
    );

=cut

sub DataGet {
    my ( $Self, %Param ) = @_;

    # open the file SQL.log
    my $File = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/var/fred/SQL.log';

    my $Filehandle;
    if ( !open $Filehandle, '<', $File ) {    ## no critic
        $Param{ModuleRef}->{Data} = ["Can't read /var/fred/SQL.log"];
        return;
    }

    my @LogMessages;
    my $DoStatements     = 0;
    my $SelectStatements = 0;

    # slurp in the whole logfile, in order to access the lines at the end
    LINE:
    for my $Line ( reverse <$Filehandle> ) {

        # do not show the log from the previous request
        last LINE if $Line =~ /FRED/;

     # a typical line from SQL.log looks like:
     # SQL-SELECT##!##SELECT 1 + 1 FROM dual WHERE id = ? AND user_id = ?##!##1, 2##!##Kernel::System::User##!##0.004397
        my @SplitLogLine = split /##!##/, $Line;
        if ( $SplitLogLine[0] eq 'SQL-DO' && $SplitLogLine[1] =~ m{ \A SELECT }xms ) {
            $SplitLogLine[0] .= ' - Perhaps you have an error you use DO for a SELECT-Statement:';
        }
        push @LogMessages, \@SplitLogLine;

        if ( $SplitLogLine[0] eq 'SQL-DO' ) {
            $DoStatements++;
        }

        if ( $SplitLogLine[4] ) {
            $Param{ModuleRef}->{Time} += $SplitLogLine[4];
        }
    }

    pop @LogMessages;
    close $Filehandle;

    # find SQL-statements used multiple times
    my %MultiUsed;
    for my $StatementRef (@LogMessages) {
        $MultiUsed{ $StatementRef->[1] }++;
    }
    for my $StatementRef (@LogMessages) {
        push @{$StatementRef}, ( $MultiUsed{ $StatementRef->[1] } - 1 );
    }

    # Add marker for the next view
    $Self->InsertWord( What => "FRED\n" );

    # set the data for the output template
    $Param{ModuleRef}->{Data}             = \@LogMessages;
    $Param{ModuleRef}->{AllStatements}    = scalar @LogMessages;
    $Param{ModuleRef}->{DoStatements}     = $DoStatements;
    $Param{ModuleRef}->{SelectStatements} = $Param{ModuleRef}->{AllStatements} - $DoStatements;

    return 1;
}

=item InsertWord()

Append a semicolon separated record line to the the SQL log.

    $BackendObject->InsertWord(
        What => 'SQL-SELECT;SELECT 1 + 1 FROM dual;Kernel::System::User;0.004397',
    );

=cut

sub InsertWord {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{What} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need What!',
        );
        return;
    }

    # Fixup multiline SQL statements
    if ( $Param{What} =~ m/^SQL/smx ) {
        my @What = split '##!##', $Param{What};

        # hide white space
        $What[1] =~ s/\r?\n/ /smxg;
        $What[1] =~ s/\s+/ /smxg;
        $Param{What} = join '##!##', @What;
    }

    # apppend the line to log file
    my $File = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/var/fred/SQL.log';
    open my $Filehandle, '>>', $File || die "Can't write $File !\n";
    print $Filehandle $Param{What}, "\n";
    close $Filehandle;

    return 1;
}

sub PreStatement {
    my ( $Self, %Param ) = @_;

    return if ( !$Self->{Active} );

    $Self->{PrepareStart} = [gettimeofday];

    return;
}

sub PostStatement {
    my ( $Self, %Param ) = @_;

    return if ( !$Self->{Active} );

    my $DiffTime = tv_interval( $Self->{PrepareStart} );

    my @StackTrace;

    COUNT:
    for ( my $Count = 1; $Count < 30; $Count++ ) {
        my ( $Package1, $Filename1, $Line1, $Subroutine1 ) = caller($Count);
        last COUNT if !$Line1;
        my ( $Package2, $Filename2, $Line2, $Subroutine2 ) = caller( 1 + $Count );
        $Subroutine2 ||= $0;    # if there is no caller module use the file name
        $Subroutine2 =~ s/Kernel::System/K::S/;
        $Subroutine2 =~ s/Kernel::Modules/K::M/;
        $Subroutine2 =~ s/Kernel::Output/K::O/;
        push @StackTrace, "$Subroutine2:$Line1";
    }

    my @Array = map { defined $_ && defined ${$_} ? ${$_} : 'undef' } @{ $Param{Bind} || [] };

    # Replace newlines
    @Array = map { $_ =~ s{\r?\n}{[\\n]}smxg; $_; } @Array;    ## no critic

    # Limit bind param length
    @Array = map { length($_) > 100 ? ( substr( $_, 0, 100 ) . '[...]' ) : $_ } @Array;
    my $BindString = @Array ? join ', ', @Array : '';

    my $Prefix = $Param{SQL} =~ m{^SELECT}ixms ? 'SELECT' : 'DO';

    $Self->InsertWord(
        What => "SQL-$Prefix##!##$Param{SQL}##!##$BindString##!##"
            . join( ';', @StackTrace )
            . "##!##$DiffTime",
    );

    return;
}

1;

=back
