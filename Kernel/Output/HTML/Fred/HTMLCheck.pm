# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::Fred::HTMLCheck;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::Output::HTML::Fred::HTMLCheck - layout backend module

=head1 SYNOPSIS

All layout functions of HTML check object

=over 4

=cut

=item new()

create an object

    $BackendObject = Kernel::Output::HTML::FredSTDERRLog->new(
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

create the output of the STDERR log

    $LayoutObject->CreateFredOutput(
        ModulesRef => $ModulesRef,
    );

=cut

sub CreateFredOutput {
    my ( $Self, %Param ) = @_;

    my $HTMLLines = '';

    # check needed stuff
    if ( !$Param{ModuleRef} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ModuleRef!',
        );
        return;
    }

    $Param{ModuleRef}->{Output} = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Output(
        TemplateFile => 'DevelFredHTMLCheck',
        Data         => {
            HTMLLines => $HTMLLines,
        },
    );

    return 1;
}

1;

=back
