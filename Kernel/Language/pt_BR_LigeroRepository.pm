# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pt_BR_LigeroRepository;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # $$START$$

    # own translations
    $Self->{Translation}->{'Your Ligero Enterprise Account is not working yet!'}   = 'Sua conta Ligero ainda não está funcionando corretamente!';
    $Self->{Translation}->{'Hi! This package requires a Ligero account in order to be downloaded.<br><br>Please, contact us at <a href="mailto:sales@ligero.online">sales@ligero.online</a> or +55(11)2506-0180'}   = 'Olá! Este pacote requer uma conta Enterprise Ligero para ser instalado.<br><br>Por favor, entre em contato através do e-mail <a href="mailto:contato@ligero.online">contato@ligero.online</a> ou +55(11)2506-0180';
    $Self->{Translation}->{'Define private addon repos.'}   = 'Configurar usuário e chave de API para acesso aos AddOns exclusivos da Ligero';
    $Self->{Translation}->{'Ligero Subscription'}   = 'Subscrição Ligero';
    $Self->{Translation}->{'Set Up your Ligero Subscription User and API Key.'}   = 'Configure seu usuário e chave de API da Subscrição Ligero';
    $Self->{Translation}->{'Back to your OTRS Package Manager'}   = 'Voltar para o Gerenciador de Pacotes do OTRS';

    #$Self->{Translation}->{''}   = '';

    # $$STOP$$
}

1;
