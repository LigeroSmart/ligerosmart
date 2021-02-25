# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::Fred::ConfigLog;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::Output::HTML::Fred::ConfigLog - layout backend module

=head1 SYNOPSIS

All layout functions of the config log module

=over 4

=cut

=item new()

create an object

    $BackendObject = Kernel::Output::HTML::FredConfigLog->new(
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

create the output of the config log

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

    my $HTMLLines = '';
    for my $Line ( @{ $Param{ModuleRef}->{Data} } ) {

        for my $TD ( @{$Line} ) {
            $TD = $LayoutObject->Ascii2Html( Text => $TD );
        }

        if ( $Line->[1] eq 'True' ) {
            $Line->[1] = '';
        }

        for my $Count ( 0 .. 3 ) {
            $Line->[$Count] ||= '';
        }

        $HTMLLines .= "        <tr>\n"
            . "          <td align=\"right\">$Line->[3]</td>\n"
            . "          <td>$Line->[0]</td>\n"
            . "          <td>$Line->[1]</td>\n"
            . "          <td>$Line->[2]</td>\n"
            . "        </tr>";
    }

    return if !$HTMLLines;

    $Param{ModuleRef}->{Output} = $LayoutObject->Output(
        TemplateFile => 'DevelFredConfigLog',
        Data         => {
            HTMLLines => $HTMLLines,
        },
    );

    return 1;
}

1;

=back
