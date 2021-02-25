# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Fred::ConfigLog;
## no critic(Perl::Critic::Policy::OTRS::ProhibitOpen)

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
);

=head1 NAME

Kernel::System::Fred::ConfigLog

=head1 SYNOPSIS

handle the config log data

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

    my @LogMessages;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # open the TranslationDebug.log file to get the untranslated words
    my $File = $ConfigObject->Get('Home') . '/var/fred/Config.log';
    my $Filehandle;
    if ( !open $Filehandle, '<', $File ) {
        print STDERR "Can't read /var/fred/Config.log\n";
        return;
    }
    LINE:
    for my $Line ( reverse <$Filehandle> ) {
        last LINE if $Line =~ /FRED/;
        push @LogMessages, $Line;
    }
    close $Filehandle;
    pop @LogMessages;
    $Self->InsertWord( What => "FRED\n" );

    my %IndividualConfig = ();

    for my $Line (@LogMessages) {
        $Line =~ s/\n//;
        $IndividualConfig{$Line}++;
    }

    @LogMessages = ();
    for my $Line ( sort keys %IndividualConfig ) {
        my @SplitedLine = split /;/, $Line;
        push @SplitedLine, $IndividualConfig{$Line};
        push @LogMessages, \@SplitedLine;
    }

    # sort the data
    my $Config  = $ConfigObject->Get('Fred::ConfigLog');
    my $OrderBy = defined( $Config->{OrderBy} ) ? $Config->{OrderBy} : 3;
    if ( $OrderBy == 3 ) {
        @LogMessages = sort { $b->[$OrderBy] <=> $a->[$OrderBy] } @LogMessages;
    }
    else {
        @LogMessages = sort { $a->[$OrderBy] cmp $b->[$OrderBy] } @LogMessages;
    }

    $Param{ModuleRef}->{Data} = \@LogMessages;
    return 1;
}

=item InsertWord()

Save a word in the translation debug log

    $BackendObject->InsertWord(
        What => 'a word',
    );

=cut

sub InsertWord {
    my ( $Self, %Param ) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $FredSettings = $ConfigObject->GetOriginal('Fred::Module');

    if ( !$FredSettings || !$FredSettings->{ConfigLog} || !$FredSettings->{ConfigLog}->{Active} ) {
        return;
    }

    if ( !$Param{Home} ) {
        $Param{Home} = $ConfigObject->GetOriginal('Home');
    }

    # save the word in log file
    my $File = $Param{Home} . '/var/fred/Config.log';
    open my $Filehandle, '>>', $File || die "Can't write $File !\n";
    print $Filehandle $Param{What} . "\n";
    close $Filehandle;

    return 1;
}

1;

=back
