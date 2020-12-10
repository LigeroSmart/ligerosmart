# --
# Copyright (C) 2015-2019 Ligero https://ligero.online
# Copyright (C) 2015-2019 Complemento https://complemento.net.br
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --
package Kernel::Language::pt_BR_Forms;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    $Self->{Translation}->{'Hide Article on Customer Interface (if true, provide a default Subject and Body bellow)'} = 
            'Esconder Artigo na Interface de Cliente (Se verdadeiro, defina um Assunto e Corpo padrão abaixo)';
    $Self->{Translation}->{'Manage Dynamic Fields by Service'} = 'Criar Formulários';
    $Self->{Translation}->{'Comments'} = 'Comentários';
    $Self->{Translation}->{'Add Form'} = 'Adicionar Formulário';
    $Self->{Translation}->{'Edit Form'} = 'Editar Formulário';
    $Self->{Translation}->{'Forms'} = 'Formulários';
    $Self->{Translation}->{'Form'} = 'Formulário';
    $Self->{Translation}->{'Ticket Type'} = 'Tipo de Chamado';
    $Self->{Translation}->{'Custom Form for this Service'} = 'Formulário customizado para este Serviço';
    $Self->{Translation}->{'Create custom Forms for your services.'} = 'Crie formulários customizados para seus serviços.';
    $Self->{Translation}->{'COPY'} = 'COPIAR';

    return;
}

1;