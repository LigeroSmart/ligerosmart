# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::Fred::SQLLog;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::Output::HTML::Fred::SQLLog - layout backend module

=head1 SYNOPSIS

All layout functions of SQL log module

=over 4

=cut

=item new()

create an object

    $BackendObject = Kernel::Output::HTML::FredSQLLog->new(
        %Param,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=item CreateFredOutput()

create the output of the SQL log

    $LayoutObject->CreateFredOutput(
        ModulesRef => $ModulesRef,
    );

=cut

sub CreateFredOutput {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ModuleRef} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ModuleRef!',
        );
        return;
    }

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my @SQLLog;

    for my $Line ( @{ $Param{ModuleRef}->{Data} } ) {

        my %SQLLogEntry = (
            Time            => $Line->[4] * 1000,
            EqualStatements => $Line->[5] || '',
            Statement       => $Line->[1],
            Package         => $Line->[3],
            BindParameters  => $Line->[2],
        );

        for my $Line ( split( /;/, $Line->[3] ) ) {
            $SQLLogEntry{StackTrace} //= [];
            push @{ $SQLLogEntry{StackTrace} }, $Line;
        }

        push @SQLLog, \%SQLLogEntry;
    }

    $Param{ModuleRef}->{Output} = $LayoutObject->Output(
        TemplateFile => 'DevelFredSQLLog',
        Data         => {
            AllStatements    => $Param{ModuleRef}->{AllStatements},
            DoStatements     => $Param{ModuleRef}->{DoStatements},
            SelectStatements => $Param{ModuleRef}->{SelectStatements},
            Time             => $Param{ModuleRef}->{Time},
            SQLLog           => \@SQLLog,
        },
    );

    return 1;
}

1;

=back
