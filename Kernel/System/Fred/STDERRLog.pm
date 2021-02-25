# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Fred::STDERRLog;
## no critic(Perl::Critic::Policy::OTRS::ProhibitOpen)

use strict;
use warnings;

use IO::Handle;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::Fred::STDERRLog

=head1 SYNOPSIS

handle the STDERR log data

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

    # check needed stuff
    for my $Needed (qw(ModuleRef)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # Make sure that we get everything to disk before trying to read it (otherwise content could be lost).
    STDERR->flush();

    # open the STDERR.log file to get the STDERR messages
    my $File = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/var/fred/STDERR.log';
    my $Filehandle;

    if ( !open $Filehandle, '<:encoding(UTF-8)', $File ) {    ## no critic
        $Param{ModuleRef}->{Data} = [
            "Perhaps you don't have permission at /var/fred/ or /Kernel/Config/Files/AAAFred.pm.",
            "Can't read /var/fred/STDERR.log",
        ];
        return;
    }

    # Read log until last "FRED" marker.
    my @LogMessages;
    LINE:
    for my $Line ( reverse <$Filehandle> ) {
        last LINE if $Line =~ m{ \A \s* FRED \s* \z}xms;
        push @LogMessages, $Line;
    }
    close $Filehandle;

    print STDERR "\nFRED\n";

    # trim the log message array
    LINE:
    for my $Line (@LogMessages) {
        last LINE if $Line !~ m{ \A \s* \z }xms;
        shift @LogMessages;
    }

    # trim the log message array
    LINE:
    for my $Line ( reverse @LogMessages ) {
        last LINE if $Line !~ m{ \A \s* \z }xms;
        shift @LogMessages;
    }

    $Param{ModuleRef}->{Data} = \@LogMessages;

    return 1;
}

1;

=back
