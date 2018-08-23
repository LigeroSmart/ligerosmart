# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::sr_Cyrl_OTRSMasterSlave;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminDynamicFieldMasterSlave
    $Self->{Translation}->{'Field'} = 'Поље';

    # Template: AgentTicketMasterSlave
    $Self->{Translation}->{'Manage Master/Slave status for %s%s%s'} = 'Управљање статусом главни/зависни за %s%s%s';

    # Perl Module: Kernel/Modules/AgentTicketMasterSlave.pm
    $Self->{Translation}->{'New Master Ticket'} = 'Нови главни тикет';
    $Self->{Translation}->{'Unset Master Ticket'} = 'Опозови подешавање главног тикета';
    $Self->{Translation}->{'Unset Slave Ticket'} = 'Опозови подешавање зависног тикета';
    $Self->{Translation}->{'Slave of %s%s%s: %s'} = 'Зависни од %s%s%s: %s';

    # Perl Module: Kernel/Output/HTML/TicketBulk/MasterSlave.pm
    $Self->{Translation}->{'Unset Master Tickets'} = 'Опозови подешавање главних тикета';
    $Self->{Translation}->{'Unset Slave Tickets'} = 'Опозови подешавање зависних тикета';

    # Perl Module: Kernel/System/DynamicField/Driver/MasterSlave.pm
    $Self->{Translation}->{'Master'} = 'Главно';
    $Self->{Translation}->{'Slave of %s%s%s'} = 'Зависни од %s%s%s';
    $Self->{Translation}->{'Master Ticket'} = 'Главни тикет';

    # SysConfig
    $Self->{Translation}->{'All master tickets'} = 'Сви главни тикети';
    $Self->{Translation}->{'All slave tickets'} = 'Сви зависни тикети';
    $Self->{Translation}->{'Allows adding notes in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Дозвољава додавање белешки на главни/зависни екрану детаљног приказа тикета оператерског интерфејса.';
    $Self->{Translation}->{'Change the MasterSlave state of the ticket.'} = 'Промени главни/зависни статус тикета.';
    $Self->{Translation}->{'Defines dynamic field name for master ticket feature.'} = 'Дефинише динамички назив поља за функцију главног тикета.';
    $Self->{Translation}->{'Defines if a ticket lock is required in the ticket MasterSlave screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        'Одређује да ли је потребно закључати главни/зависни екран тикета на детаљном приказу тикета у интерфејсу оператера (ако тикет још увек није закључан, тикет ће добити статус закључан и тренутни оператер ће бити аутоматски постављен као власник).';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Одређује подразумевани наредни статус тикета после додаваља белешке, на главни/зависни екрану детаљног приказа тикета у интерфејсу оператера.';
    $Self->{Translation}->{'Defines the default ticket priority in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Одређује подразумевани приоритет тикета на главни/зависни екану детаљног приказа тикета у интерфејсу оператера.';
    $Self->{Translation}->{'Defines the default type of the note in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Одређује подразумевани тип белешке на главни/зависни екрану детаљног приказа тикета у интерфејсу оператера.';
    $Self->{Translation}->{'Defines the history comment for the ticket MasterSlave screen action, which gets used for ticket history in the agent interface.'} =
        'Одређује коментар за историјат на главни/зависни екранској акцији, што ће се користити за историјат у интерфејсу оператера.';
    $Self->{Translation}->{'Defines the history type for the ticket MasterSlave screen action, which gets used for ticket history in the agent interface.'} =
        'Одређује тип историјата за главни/зависни екранску акцију, што ће се користити за историјат у интерфејсу оператера.';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Одређује наредни статус тикета после додаваља белешке, на главни/зависни екрану детаљног приказа тикета у интерфејсу оператера.';
    $Self->{Translation}->{'Enables the advanced MasterSlave part of the feature.'} = 'Активира напредни део функције главни/зависни.';
    $Self->{Translation}->{'Enables the feature that slave tickets follow the master ticket to a new master in the advanced MasterSlave mode.'} =
        'Активирање својства да зависни тикет прати главни на нови главни у напредном главни/зависни моду.';
    $Self->{Translation}->{'Enables the feature to change the MasterSlave state of a ticket in the advanced MasterSlave mode.'} =
        'Активирање функције за промену стања тикета главни/зависни  у напредном главни/зависни моду.';
    $Self->{Translation}->{'Enables the feature to forward articles from type \'forward\' of a master ticket to the customers of the slave tickets. By default (disabled) it will not forward articles from type \'forward\' to the slave tickets.'} =
        'Активирање својства за прослеђивање чланака типа "проследи" главног тикета корисницима зависних тикета. Подразумевано је (искључено) да се ништа не прослеђује зависним тикетима.';
    $Self->{Translation}->{'Enables the feature to keep parent-child link after change of the MasterSlave state in the advanced MasterSlave mode.'} =
        'Активирање функције за задржавање везе надређени-подређени после измене стања главни/зависни у напредном главни/зависни моду.';
    $Self->{Translation}->{'Enables the feature to keep parent-child link after unset of the MasterSlave state in the advanced MasterSlave mode.'} =
        'Активирање функције за задржавање везе надређени-подређени после опозива подешавања стања главни/зависни  у напредном главни/зависни моду.';
    $Self->{Translation}->{'Enables the feature to unset the MasterSlave state of a ticket in the advanced MasterSlave mode.'} =
        'Активирање функције за опозив подешавања стања тикета главни/зависни у напредном главни/зависни моду.';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of the ticket in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Ако је оператер додао напомену, подешава статус тикета на екрану главни/зависни тикета на детаљном приказу у интерфејсу оператера.';
    $Self->{Translation}->{'Master / Slave'} = 'Главни / зависни';
    $Self->{Translation}->{'Master Tickets'} = 'Главни тикети';
    $Self->{Translation}->{'MasterSlave'} = 'Главни/зависни';
    $Self->{Translation}->{'MasterSlave module for Ticket Bulk feature.'} = 'Модул главни/зависни за функцију масовне обраде тикета.';
    $Self->{Translation}->{'Parameters for the dashboard backend of the master tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.'} =
        'Параметри за додатак прегледа главних тикета контролне табле у интерфејсу оператера. "Limit" је број подразумевано приказаних тикета. "Group" се користи да ограничи приступ додатку (нпр. Group: admin;group1;group2;). "Default" одређује да ли је подразумевано активиран или да је потребно да га корисник мануелно активира. "CacheTTLLocal" је време у минутима за кеш додатка. ';
    $Self->{Translation}->{'Parameters for the dashboard backend of the slave tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.'} =
        'Параметри за додатак прегледа зависних тикета контролне табле у интерфејсу оператера. "Limit" је број подразумевано приказаних тикета. "Group" се користи да ограничи приступ додатку (нпр. Group: admin;group1;group2;). "Default" одређује да ли је подразумевано активиран или да је потребно да га корисник мануелно активира. "CacheTTLLocal" је време у минутима за кеш додатка. ';
    $Self->{Translation}->{'Registration of the ticket event module.'} = 'Регистрација модула догађаја за тикете.';
    $Self->{Translation}->{'Required permissions to use the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Неопходна дозвола за употребу главни/зависни екрана детаљног приказа тикета у интерфејсу оператера.';
    $Self->{Translation}->{'Sets if Master / Slave field must be selected by the agent.'} = 'Дефинише да ли поље Главни / Зависни мора бити подешено од стране оператера.';
    $Self->{Translation}->{'Sets the default body text for notes added in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Одређује подразумевани садржај за напомене додате на на Главни/Зависни екрану детаљног приказа тикета у интерфејсу оператера.';
    $Self->{Translation}->{'Sets the default subject for notes added in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Одређује подразумевани предмет за напомене додате на Главни/Зависни екрану детаљног приказа тикета у интерфејсу оператера.';
    $Self->{Translation}->{'Sets the responsible agent of the ticket in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Одређује одговорног оператера за тикет на екрану главни/зависни  детаљног приказа тикета у интерфејсу оператера.';
    $Self->{Translation}->{'Sets the service in the ticket MasterSlave screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).'} =
        'Одређује сервис на главни/зависни екрану детаљног приказа тикета у интерфејсу оператера (Ticket::Service мора бити активиран).';
    $Self->{Translation}->{'Sets the ticket owner in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Одређује власника тикета на главни/зависни екрану детаљног приказа тикета у интерфејсу оператера.';
    $Self->{Translation}->{'Sets the ticket type in the ticket MasterSlave screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).'} =
        'Одређује тип тикета на главни/зависни екрану детаљног приказа тикета у интерфејсу оператера (Ticket::Type мора бити активиран).';
    $Self->{Translation}->{'Shows a link in the menu to change the MasterSlave status of a ticket in the ticket zoom view of the agent interface.'} =
        'У менију приказује везу за измену главни/зависни статуса тикета на детаљном приказу тикета у интерфејсу оператера.';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Приказује листу свих оператера укључених у овај тикет на главни/зависни екрану детаљног приказа тикета у интерфејсу оператера.';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Приказује листу свих могућих оператера (сви оператери са дозволом за напомену за ред/тикет) ради утврђивања ко треба да буде информисан о овој напомени, на главни/зависни екрану тикета на детаљном приказу тикета у интерфејсу оператера.';
    $Self->{Translation}->{'Shows the ticket priority options in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Приказује опције приоритета тикета на екрану главни/зависни тикета на детаљном приказу тикета у интерфејсу оператера.';
    $Self->{Translation}->{'Shows the title field in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Приказује насловна поља на екрану главни/зависни тикета у интерфејсу оператера.';
    $Self->{Translation}->{'Slave Tickets'} = 'Зависни тикети';
    $Self->{Translation}->{'Specifies the different article types where the real name from Master ticket will be replaced with the one in the Slave ticket.'} =
        'Наводи разне типове чланака где ће стварно име са главног тикета бити замењено са једним на зависном тикету.';
    $Self->{Translation}->{'Specifies the different note types that will be used in the system.'} =
        'Одређује различите типове напомена који ће се користити у систему.';
    $Self->{Translation}->{'This module activates Master/Slave field in new email and phone ticket screens.'} =
        'Овај модул активира поље главни/зависни на екрану нових имејл тикета и тикета позива.';
    $Self->{Translation}->{'Ticket MasterSlave.'} = 'Тикет главни/зависни.';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
