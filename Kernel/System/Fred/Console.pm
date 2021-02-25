# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Fred::Console;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::Fred::Console

=head1 SYNOPSIS

gives you all functions which are needed for the FRED-console

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
And adds the data to the module ref.

    $BackendObject->DataGet(
        ModuleRef => $ModuleRef,
    );

=cut

sub DataGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Ref (qw(ModuleRef HTMLDataRef FredModulesRef)) {
        if ( !$Param{$Ref} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Ref!",
            );
            return;
        }
    }

    my @Modules;
    for my $Module ( sort keys %{ $Param{FredModulesRef} } ) {
        if ( $Module ne 'Console' ) {
            push @Modules, $Module;
        }
    }
    $Param{ModuleRef}->{Data} = \@Modules;

    if ( ${ $Param{HTMLDataRef} } !~ m/Fred-Setting/ && ${ $Param{HTMLDataRef} } =~ /\<body.*?\>/ )
    {
        $Param{ModuleRef}->{Status} = 1;
    }

    if ( ${ $Param{HTMLDataRef} } !~ m/name="Action" value="Login"/ ) {
        $Param{ModuleRef}->{Setting} = 1;
    }

    return 1;
}

1;

=back
