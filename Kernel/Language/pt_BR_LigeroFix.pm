# --
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pt_BR_LigeroFix;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    $Self->{Translation}->{'Suggested Solutions'} = 'Soluções Sugeridas';
    $Self->{Translation}->{'User CIs'} = 'CIs do usuário';
    $Self->{Translation}->{'Customer CIs'} = 'CIs do cliente';
    $Self->{Translation}->{'Problems'} = 'Problemas';
    $Self->{Translation}->{'Link to the ticket'} = 'Associar ao ticket';
    $Self->{Translation}->{'Open in a new tab'} = 'Abrir em uma nova aba';

}

1;
