# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Maint::FAQ::ContentTypeSet;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::FAQ',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Sets the content type of FAQ items.');
    $Self->AddOption(
        Name => 'faq-item-id',
        Description =>
            "specify one or more ids of faq items to set its content type (if not set, all FAQ items will be affected).",
        Required   => 0,
        HasValue   => 1,
        ValueRegex => qr/.*/smx,
        Multiple   => 1,
    );
    $Self->AddOption(
        Name        => 'content-type',
        Description => "text/plain or text/html (if not set, the content type will be determined automatically).",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/(?: text\/plain | text\/html )/smx,
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Setting content type of FAQ items...</yellow>\n");

    my @FAQItemIDs  = @{ $Self->GetOption('faq-item-id') // [] };
    my $ContentType = $Self->GetOption('content-type') // '';

    my %FunctionParams;

    if (@FAQItemIDs) {
        $FunctionParams{FAQItemIDs} = \@FAQItemIDs;
    }

    if ($ContentType) {
        $FunctionParams{ContentType} = $ContentType;
    }

    my $Succes = $Kernel::OM->Get('Kernel::System::FAQ')->FAQContentTypeSet(%FunctionParams);

    if ( !$Succes ) {
        $Self->Print("<red>Fail.</red>\n");
        return $Self->ExitCodeError();

    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
