package Kernel::Language::pt_BR_LigeroToro;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    $Self->{Translation}->{'User Information'} = 'Informações do Usuário';
    $Self->{Translation}->{'User Login'} = 'Usuário';
    $Self->{Translation}->{'User First Name'} = 'Primeiro Nome';
    $Self->{Translation}->{'User Zip Code'} = 'CEP do usuário';
    $Self->{Translation}->{'User City'} = 'Cidade do usuário';
    $Self->{Translation}->{'User Mobile'} = 'Celular';
    $Self->{Translation}->{'User Full Name'} = 'Nome completo';
    $Self->{Translation}->{'User Last Name'} = 'Sobrenome';
    $Self->{Translation}->{'User Country'} = 'País do usuário';
    $Self->{Translation}->{'User Language'} = 'Linguagem do usuário';
    $Self->{Translation}->{'User Phone'} = 'Telefone do usuário';
    $Self->{Translation}->{'User Fax'} = 'FAX do usuário';
    $Self->{Translation}->{'User Customer ID'} = 'ID da Empresa';
    $Self->{Translation}->{'Company City'} = 'Cidade da Empresa';
    $Self->{Translation}->{'Company Country'} = 'País da Empresa';
    $Self->{Translation}->{'Company Zip Code'} = 'CEP da Empresa';
    $Self->{Translation}->{'Company Name'} = 'Nome da Empresa';
    $Self->{Translation}->{'Company URL'} = 'URL da Empresa';
    $Self->{Translation}->{'Company Street'} = 'Rua da Empresa';
    $Self->{Translation}->{'User Tickets'} = 'Chamados do usuário';

}

1;
