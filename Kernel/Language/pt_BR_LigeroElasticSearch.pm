# --
# Copyright (C) 2015-2019 Ligero https://ligero.online
# Copyright (C) 2015-2019 Complemento https://complemento.net.br
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --
package Kernel::Language::pt_BR_LigeroElasticSearch;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    $Self->{Translation}->{'When a group is changed in a queue, we recomend reindex the Elastic Search.'} = 
            'Recomendamos que seja realizado uma nova indexação do Elastic Searh quando o Grupo da fila for alterado.';

    return;
}

1;