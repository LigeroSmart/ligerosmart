# --
# Kernel/Language/pt_BR_PublicTicket.pm - translation file
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pt_BR_PublicTicket;

use strict;
use warnings;

use utf8;
sub Data {
    my $Self = shift;
    $Self->{Translation}->{'Information has been sent!'} = 'Informações enviadas!';
    $Self->{Translation}->{'Step already fulfilled :)'} = 'Etapa concluída :)';
    $Self->{Translation}->{'Ticket History'} = 'Histórico do Chamado';
    $Self->{Translation}->{'Would you like to reopen this ticket?'} = 'Gostaria de reabrir este chamado?';
    $Self->{Translation}->{'Defines the next state for a ticket after been reopened by the customer in the Public Ticket Reopen interface.'} = 'Define o próximo estado do chamado após ser reaberto pelo cliente na interface Public Ticket Reopen.';
    $Self->{Translation}->{'Defines which ticket states are allowed to be reopened by the customer in the Public Ticket Reopen interface.'} = 'Define quais estados do chamado permitidos para serem reabertos pelo cliente na interface Public Ticket Reopen.';
    $Self->{Translation}->{'Defines the subject to be used by default on a reopen request by the customer in the Public Ticket Reopen interface.'} = 'Define o assunto que será usado por padrão na solicitação de reabertura de chamado pelo cliente na interface Public Ticket Reopen.';
    $Self->{Translation}->{'Defines the message that will be shown to the customer after the ticket reopen request in the Public Ticket Reopen interface.'} = 'Define a mensagem que será exibida para o cliente após a reabertura com sucesso do chamado na interface Public Ticket Reopen.';
    $Self->{Translation}->{'Defines the default type of the note in the Public Ticket Reopen interface.'} = 'Define o tipo do artigo que será gerado na reabertura de chamado na interface Public Ticket Reopen.';
    $Self->{Translation}->{'Defines the default sender type for tickets in the Public Ticket Reopen interface.'} = 'Define o tipo padrão do gerador do artigo gerado nad reabertura de cahamdo na interface Public Ticket Reopen.';
    $Self->{Translation}->{'Defines the history type for the ticket zoom action, which gets used for ticket history in the Public Ticket Reopen interface.'} = 'Define o tipo de histórico do artigo gerado na reabertura de cahamdo na interface Public Ticket Reopen.';
    $Self->{Translation}->{'Defines the history comment for the ticket zoom action, which gets used for ticket history in the Public Ticket Reopen interface.'} = 'Define o comentário do histórico do artigo gerado na reabertura de cahamdo na interface Public Ticket Reopen.';
    $Self->{Translation}->{'Shows the activated ticket attributes in the Public Ticket Reopen interface (0 = Disabled and 1 = Enabled).'} = 'Exibe os atributos do chamado que estão ativos na interface Public Ticket Reopen (0 = Desabilitado e 1 = Habilitado).';
    $Self->{Translation}->{'Dynamic fields shown in the Public Ticket Reopen interface. Possible settings: 0 = Disabled, 1 = Enabled.'} = 'Campos dinâmicos que serão exibidos na interface Public Ticket Reopen. Configurações possíveis: 0 = Desabilitado, 1 = Habilitado).';
    $Self->{Translation}->{'Need TicketID and TicketKey!'} = 'É preciso informar o TicketID e a TicketKey!';
    $Self->{Translation}->{'Invalid Ticket Key!'} = 'TicketKey Inválida!';
    $Self->{Translation}->{'Ticket State now allowed to be reopened or closed!'} = 'O estado do chamado não permite ser reaberto ou fechado!';
    $Self->{Translation}->{'Defines the greeting that will be shown to the customer in the Public Ticket Reopen interface.'} = 'Define a saudação que será exibida para o usuário na interface Public Ticket Reopen.';
    $Self->{Translation}->{'Hello!'} = 'Olá!';
    $Self->{Translation}->{'Defines the message that will be shown to the customer in the Public Ticket Reopen interface.'} = 'Define a mensagem que será exibida para o usuário na interface Public Ticket Reopen.';
    $Self->{Translation}->{'If your ticket number %s has not been resolved, please write below how we can assist you:'} = 'Caso o seu chamado, de número %s não tenha sido solucionado, por favor, escreva abaixo, de que forma podemos lhe auxiliar:';
    $Self->{Translation}->{'Defines the title preffix that will be used in the Public Ticket Reopen interface.'} = 'Define o prefixo do título que será exibido na interface Public Ticket Reopen.';
    $Self->{Translation}->{'Ticket Reopen'} = 'Reabertura do Chamado';
    $Self->{Translation}->{'Defines the custom message that will be used in the Public Ticket Reopen interface (HTML tags supported).'} = 'Define a mensagem customizada que irá ser exibida na interface Public Ticket Reopen (suporta tag HTML).';
    $Self->{Translation}->{'Defines which states will display the custom messages in the Public Ticket Reopen interface.'} = 'Define quais estados dos tickets irão exibir a mensagem customizada na interface Public Ticket Reopen.';
    $Self->{Translation}->{'Defines the CSS that will be used in the custom message in the Public Ticket Reopen interface.'} = 'Define o estilo CSS que será usado na mensagem customizada na interface Public Ticket Reopen.';
    $Self->{Translation}->{'Defines if the non-delivered surveys will be removed after the ticket reopen (0 = Disabled, 1 = Enabled).'} = 'Define se as pesquisas de satisfação que ainda não foram entregues serão removidas quando o ticket for reaberto (0 = Desabilitado, 1 = Habilitado).';
    $Self->{Translation}->{"Thanks! We'd love to hear your feedback about the support experience. You will be redirected to a Survey in a few seconds..."} = 'Agradecemos! Adoraríamos saber sua opinião sobre sua experiência com nosso atendimento. Estamos redirecionando para uma pesquisa em alguns segundos...';
    $Self->{Translation}->{"Ticket has been closed"} = 'Chamado encerrado';
    $Self->{Translation}->{"The ticket has been successfully reopened."} = 'Seu chamado foi reaberto.';

}

1;