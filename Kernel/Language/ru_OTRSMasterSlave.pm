# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ru_OTRSMasterSlave;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentTicketMasterSlave
    $Self->{Translation}->{'Change Free Text of %s%s'} = 'Изменить Free Text для %s%s';
    $Self->{Translation}->{'Change Owner of %s%s'} = 'Изменить владельца для %s%s';
    $Self->{Translation}->{'Close %s%s'} = 'Закрыть %s%s';
    $Self->{Translation}->{'Add Note to %s%s'} = 'Добавить заметку/сообщение к %s%s';
    $Self->{Translation}->{'Set Pending Time for %s%s'} = 'Установить время ожидания до %s%s';
    $Self->{Translation}->{'Change Priority of %s%s'} = 'Изменить приоритет для %s%s';
    $Self->{Translation}->{'Change Responsible of %s%s'} = 'Изменить ответственного для %s%s';
    $Self->{Translation}->{'Manage Master/Slave status for %s%s'} = '';
    $Self->{Translation}->{'Set Master/Slave Value'} = 'Установить значение Master/Slave';
    $Self->{Translation}->{'Text will also be received by:'} = 'Текст будет (также) получен:';

    # Perl Module: Kernel/Modules/AgentTicketMasterSlave.pm
    $Self->{Translation}->{'New Master Ticket'} = 'Новая Master заявка';
    $Self->{Translation}->{'Unset Master Ticket'} = 'Снять значение Master заявка';
    $Self->{Translation}->{'Unset Slave Ticket'} = 'Снять значение Slave заявка';
    $Self->{Translation}->{'Slave of Ticket#'} = 'Slave от Заявки#';

    # Perl Module: Kernel/Output/HTML/TicketBulk/MasterSlave.pm
    $Self->{Translation}->{'Unset Master Tickets'} = '';
    $Self->{Translation}->{'Unset Slave Tickets'} = '';

    # SysConfig
    $Self->{Translation}->{'All master tickets'} = '';
    $Self->{Translation}->{'All slave tickets'} = '';
    $Self->{Translation}->{'Allows adding notes in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Позволяет добавить сообщение на экране MasterSlave в интерфейсе агента.';
    $Self->{Translation}->{'Change the MasterSlave state of the ticket.'} = 'Изменить состояние MasterSlave для этой заявки.';
    $Self->{Translation}->{'Defines dynamic field name for master ticket feature.'} = '';
    $Self->{Translation}->{'Defines if a ticket lock is required in the ticket MasterSlave screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        'Требуется ли блокировка заявки при применении опции MasterSlave в интерфейсе агента (если заявка еще не заблокирована, она блокируется и текущий агент становится ее Владельцем).';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Задает следующее состояние по умолчанию для заявки после добавления заметки на экране MasterSlave заявки при ее просмотре в интерфейсе агента.';
    $Self->{Translation}->{'Defines the default ticket priority in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Задает умалчиваемый приоритет заявки на экране MasterSlave при просмотре заявки в интерфейсе агента.';
    $Self->{Translation}->{'Defines the default type of the note in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Задает умалчиваемый тип сообщения на экране MasterSlave при просмотре заявки в интерфейсе агента.';
    $Self->{Translation}->{'Defines the history comment for the ticket MasterSlave screen action, which gets used for ticket history in the agent interface.'} =
        'Задает текст комментария в записи истории при вызове MasterSlave экрана , в интерфейсе агента.';
    $Self->{Translation}->{'Defines the history type for the ticket MasterSlave screen action, which gets used for ticket history in the agent interface.'} =
        'Задает тип записи истории при вызове MasterSlave экрана , в интерфейсе агента.';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Задает следующее состояние для заявки после добавления заметки на экране MasterSlave заявки при ее просмотре в интерфейсе агента.';
    $Self->{Translation}->{'Disabled'} = '';
    $Self->{Translation}->{'Enabled'} = '';
    $Self->{Translation}->{'Enables the advanced MasterSlave part of the feature.'} = '';
    $Self->{Translation}->{'Enables the feature that slave tickets follow the master ticket to a new master in the advanced MasterSlave mode.'} =
        '';
    $Self->{Translation}->{'Enables the feature to change the MasterSlave state of a ticket in the advanced MasterSlave mode.'} =
        '';
    $Self->{Translation}->{'Enables the feature to forward articles from type \'forward\' of a master ticket to the customers of the slave tickets. By default (disabled) it will not forward articles from type \'forward\' to the slave tickets.'} =
        '';
    $Self->{Translation}->{'Enables the feature to keep parent-child link after change of the MasterSlave state in the advanced MasterSlave mode.'} =
        '';
    $Self->{Translation}->{'Enables the feature to keep parent-child link after unset of the MasterSlave state in the advanced MasterSlave mode.'} =
        '';
    $Self->{Translation}->{'Enables the feature to unset the MasterSlave state of a ticket in the advanced MasterSlave mode.'} =
        '';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of the ticket in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Если сообщение/заметка добавлена агентом, задает состояние заявки на экране MasterSlave  в интерфейсе агента.';
    $Self->{Translation}->{'Master / Slave'} = 'Master / Slave';
    $Self->{Translation}->{'Master Tickets'} = '';
    $Self->{Translation}->{'MasterSlave'} = '';
    $Self->{Translation}->{'MasterSlave module for Ticket Bulk feature.'} = 'MasterSlave модуль для функции Массовое действие.';
    $Self->{Translation}->{'Parameters for the dashboard backend of the master tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.'} =
        'Параметры для раздела Дайджеста с информацией о master заявках в интерфейсе агента. "Group" используется для ограничения доступа к разделу (например, Group: admin;group1;group2;). "Default" - задает, будет ли раздел доступен по умолчанию или агент должен активировать его вручную. "CacheTTLLocal" - время обновления кэша в минутах для этого раздела.';
    $Self->{Translation}->{'Parameters for the dashboard backend of the slave tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.'} =
        'Параметры для раздела Дайджеста с информацией о slave заявках в интерфейсе агента. "Group" используется для ограничения доступа к разделу (например, Group: admin;group1;group2;). "Default" - задает, будет ли раздел доступен по умолчанию или агент должен активировать его вручную. "CacheTTLLocal" - время обновления кэша в минутах для этого раздела.';
    $Self->{Translation}->{'Registration of the ticket event module.'} = 'Регистрация модуля обработки событий заявки.';
    $Self->{Translation}->{'Required permissions to use the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Права, требуемые для использования функции MasterSlave заявок в интерфейсе агента.';
    $Self->{Translation}->{'Sets the default body text for notes added in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Устанавливает текст сообщения по умолчанию при добавлении сообщения на экране MasterSlave заявки в интерфейсе агента.';
    $Self->{Translation}->{'Sets the default subject for notes added in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Устанавливает тему сообщения по умолчанию при добавлении сообщения на экране MasterSlave заявки в интерфейсе агента.';
    $Self->{Translation}->{'Sets the responsible agent of the ticket in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Задает Ответственного за заявку на экране MasterSlave заявки в интерфейсе агента.';
    $Self->{Translation}->{'Sets the service in the ticket MasterSlave screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).'} =
        'Задает сервис для заявки на экране MasterSlave заявки в интерфейсе агента. (Параметр Ticket::Service должен быть включен).';
    $Self->{Translation}->{'Sets the ticket owner in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Задает Владельца заявки на экране MasterSlave заявки в интерфейсе агента.';
    $Self->{Translation}->{'Sets the ticket type in the ticket MasterSlave screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).'} =
        'Задает тип заявки на экране MasterSlave заявки в интерфейсе агента. (Параметр Ticket::Service должен быть включен).';
    $Self->{Translation}->{'Shows a link in the menu to change the MasterSlave status of a ticket in the ticket zoom view of the agent interface.'} =
        'Задает ссылку в меню для изменения MasterSlave статуса  на экране просмотра заявки в интерфейсе агента.';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Показывает список всех привлекаемых агентов по этой заявке на экране MasterSlave заявки в интерфейсе агента. ';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Показывает список всех доступных агентов (всех агентов с правами note для очереди/заявки), чтобы задать кого нужно информировать об этой заметке на экране MasterSlave заявки в интерфейсе агента. ';
    $Self->{Translation}->{'Shows the ticket priority options in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Дает возможность изменить приоритет на экране MasterSlave заявки в интерфейсе агента. ';
    $Self->{Translation}->{'Shows the title fields in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Дает возможность изменить тему заявки на экране MasterSlave заявки в интерфейсе агента. ';
    $Self->{Translation}->{'Slave Tickets'} = '';
    $Self->{Translation}->{'Specifies the different article types where the real name from Master ticket will be replaced with the one in the Slave ticket.'} =
        'Задает различные типы сообщений/заметок для случая замены реального имени из главной заявки в таким же в подчиненной.';
    $Self->{Translation}->{'This module activates Master/Slave field in new email and phone ticket screens.'} =
        'Этот модуль включает возможность выбора master/slave опции на экране создания заявки, на основе телефонного звонка или письма клиента агентом.';
    $Self->{Translation}->{'Ticket MasterSlave.'} = '';

}

1;
