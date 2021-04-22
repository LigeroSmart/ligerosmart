# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pt_BR_LigeroPortal;

use strict;
use warnings;

use utf8;
sub Data {
    my $Self = shift;

    $Self->{Translation}->{'I need more help...'} = 'Preciso de mais ajuda...';
    $Self->{Translation}->{'Was this article helpful?'} = 'Esta informação foi útil?';
    $Self->{Translation}->{'Service Article'} = 'Artigo do Serviço';
    $Self->{Translation}->{'Service Description Article'} = 'Artigo de Descrição do Serviço';
    $Self->{Translation}->{'Service Catalog'} = 'Catálogo de Serviços';
    $Self->{Translation}->{'More Services:'} = 'Mais Serviços:';
    $Self->{Translation}->{'Fix Now!'} = 'Resolva já!';
    $Self->{Translation}->{'Alerts'} = 'Avisos';
    $Self->{Translation}->{'Search in this category...'} = 'Pesquisar nesta categoria...';
    $Self->{Translation}->{'What are you looking for?'} = 'O que você procura?';
    $Self->{Translation}->{'No results found'} = 'Nenhum resultado encontrado';
    $Self->{Translation}->{'What do you need?'} = 'O que você precisa fazer?';
    $Self->{Translation}->{'Image'} = 'Imagem';
    $Self->{Translation}->{"Service Description - It's shown on customer interface"} = "Descrição do Serviço - Exibido na interface do cliente";
    $Self->{Translation}->{'Results Found'} = 'Resultados encontrados';
    $Self->{Translation}->{'Request Support'} = 'Suporte';
    $Self->{Translation}->{'Service Request'} = 'Solicitar serviço';
    $Self->{Translation}->{'Request Support - Urgent'} = 'Suporte urgente';
    $Self->{Translation}->{'FAQ Article'} = 'Artigo';
    $Self->{Translation}->{'Quick Access'} = 'Acesso Rápido';
    $Self->{Translation}->{'Service Category'} = 'Categoria de Serviços';
}

1;
