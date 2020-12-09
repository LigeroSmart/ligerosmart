# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pt_BR_UpdateParentProcessValidation;
use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;
    my $Lang = $Self->{Translation};
    return 0 if ref $Lang ne 'HASH';

    # $$START$$

    $Lang->{'A child ticket has been closed, please check it: %s.'} = 'Um chamado filho foi encerrado, por favor verifique: %s.';
    $Lang->{'Child ticket closed: %s'} = 'Chamado filho encerrado: %s';


    return 0;

    # $$STOP$$
}

1;
