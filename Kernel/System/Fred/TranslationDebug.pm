# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Fred::TranslationDebug;
## no critic(Perl::Critic::Policy::OTRS::ProhibitOpen)

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::Fred::TranslationDebug

=head1 SYNOPSIS

handle the translation debug data

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
        && $ConfigObject->Get('Fred::Module')->{TranslationDebug}
        )
    {
        $Self->{Active} = $ConfigObject->Get('Fred::Module')->{TranslationDebug}->{Active};
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

    # open the TranslationDebug.log file to get the untranslated words
    my $File = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/var/fred/TranslationDebug.log';
    my $Filehandle;
    if ( !open $Filehandle, '<:encoding(UTF-8)', $File ) {    ## no critic
        $Param{ModuleRef}->{Data} = ["Can't read /var/fred/TranslationDebug.log"];
        return;
    }

    # get distinct entries from TranslationDebug.log
    # till the last 'FRED' entry
    my %LogLines;
    LINE:
    for my $Line ( reverse <$Filehandle> ) {
        last LINE if $Line =~ /FRED/;

        chomp $Line;
        next LINE if $Line eq '';

        # skip duplicate entries
        next LINE if $LogLines{$Line};

        $LogLines{$Line} = 1;
    }
    close $Filehandle;

    $Self->InsertWord( What => "FRED\n" );

    my @LogLines = sort { $a cmp $b } keys %LogLines;
    $Param{ModuleRef}->{Data} = \@LogLines;

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

    return if ( !$Self->{Active} );

    # check needed stuff
    if ( !defined( $Param{What} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need What!',
        );
        return;
    }

    # save the word in log file
    my $File = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/var/fred/TranslationDebug.log';
    open my $Filehandle, '>>:encoding(UTF-8)', $File || die "Can't write $File !\n";
    print $Filehandle $Param{What} . "\n";
    close $Filehandle;

    return 1;
}

1;

=back
