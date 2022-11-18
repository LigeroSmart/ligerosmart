# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::pt_BR_QRCode;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: CustomerQRCode
    $Self->{Translation}->{'Open call for the Item'} = 'Abrir chamado para o Item';

}

1;
