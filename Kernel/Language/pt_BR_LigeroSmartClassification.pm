# --
# Kernel/Language/pt_BR_ComplementoView.pm - translation file
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pt_BR_LigeroSmartClassification;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentTicketLigeroSmartClassification
    $Self->{Translation}->{'Classify now!'} = 'Classificar agora!';
    $Self->{Translation}->{"This ticket is not classified yet. Check Ligero's smart suggestions and solve it now!"} =
         'Este chamado ainda não está classificado. Confira a sugestão do Ligero Smart e resolva agora!';
    $Self->{Translation}->{'Wheter to expand or collapse Smart Classification Widget when ticket is not classified'} =
     'Definir se o Smart Classification deve ficar expandido ou recolhido quando o chamado não está classificado';
    $Self->{Translation}->{'Wheter to expand or collapse Smart Classification Widget when ticket is classified'} = 
     'Definir se o Smart Classification deve ficar expandido, recolhido ou escondido quando o chamado está classificado';
    $Self->{Translation}->{'Hide'} = 'Esconder';

}

1;
