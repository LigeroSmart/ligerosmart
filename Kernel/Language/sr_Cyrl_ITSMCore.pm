# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::sr_Cyrl_ITSMCore;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminITSMCIPAllocate
    $Self->{Translation}->{'Criticality ↔ Impact ↔ Priority'} = 'Значај ↔ утицај ↔ приоритет';
    $Self->{Translation}->{'Manage the priority result of combinating Criticality ↔ Impact.'} =
        'Управљање резултатом приоритета комбиновањем значај ↔ утицај.';
    $Self->{Translation}->{'Priority allocation'} = 'Расподела приоритета';

    # Template: AdminSLA
    $Self->{Translation}->{'Minimum Time Between Incidents'} = 'Минимално време између инцидената';

    # Template: AdminService
    $Self->{Translation}->{'Criticality'} = 'Значај';

    # Template: AgentITSMSLAZoom
    $Self->{Translation}->{'SLA Information'} = 'Информације о SLA';
    $Self->{Translation}->{'Last changed'} = 'Задњи пут промењено';
    $Self->{Translation}->{'Last changed by'} = 'Последњи је мењао';
    $Self->{Translation}->{'Associated Services'} = 'Повезани сервиси';

    # Template: AgentITSMServiceZoom
    $Self->{Translation}->{'Service Information'} = 'Сервисна информација';
    $Self->{Translation}->{'Current incident state'} = 'Тренутно стање инцидента';
    $Self->{Translation}->{'Associated SLAs'} = 'Повезани SLA';

    # Perl Module: Kernel/Modules/AdminITSMCIPAllocate.pm
    $Self->{Translation}->{'Impact'} = 'Утицај';

    # Perl Module: Kernel/Modules/AgentITSMSLAPrint.pm
    $Self->{Translation}->{'No SLAID is given!'} = 'Није дат SLAID!';
    $Self->{Translation}->{'SLAID %s not found in database!'} = 'SLAID %s није нађен у бази података!';
    $Self->{Translation}->{'Calendar Default'} = 'Подразумевани календар';

    # Perl Module: Kernel/Modules/AgentITSMSLAZoom.pm
    $Self->{Translation}->{'operational'} = 'оперативни';
    $Self->{Translation}->{'warning'} = 'упозорење';
    $Self->{Translation}->{'incident'} = 'инцидент';

    # Perl Module: Kernel/Modules/AgentITSMServicePrint.pm
    $Self->{Translation}->{'No ServiceID is given!'} = 'Није дат ServiceID!';
    $Self->{Translation}->{'ServiceID %s not found in database!'} = 'ServiceID "%s" није нађен у бази података!';
    $Self->{Translation}->{'Current Incident State'} = 'Тренутно стање инцидента';

    # Perl Module: Kernel/Output/HTML/LinkObject/Service.pm
    $Self->{Translation}->{'Incident State'} = 'Стање инцидента';

    # Database XML Definition: ITSMCore.sopm
    $Self->{Translation}->{'Operational'} = 'Оперативни';
    $Self->{Translation}->{'Incident'} = 'Инцидент';
    $Self->{Translation}->{'End User Service'} = 'Сервис за крајњег корисника';
    $Self->{Translation}->{'Front End'} = 'Приступни крај';
    $Self->{Translation}->{'Back End'} = 'Позадина';
    $Self->{Translation}->{'IT Management'} = 'ИТ управљање';
    $Self->{Translation}->{'Reporting'} = 'Извештавање';
    $Self->{Translation}->{'IT Operational'} = 'IT оперативно';
    $Self->{Translation}->{'Demonstration'} = 'Демонстрација';
    $Self->{Translation}->{'Project'} = 'Пројекат';
    $Self->{Translation}->{'Underpinning Contract'} = 'У основи уговора';
    $Self->{Translation}->{'Other'} = 'Друго';
    $Self->{Translation}->{'Availability'} = 'Доступност';
    $Self->{Translation}->{'Response Time'} = 'Време одговора';
    $Self->{Translation}->{'Recovery Time'} = 'Време опоравка';
    $Self->{Translation}->{'Resolution Rate'} = 'Стопа решавања';
    $Self->{Translation}->{'Transactions'} = 'Трансакције';
    $Self->{Translation}->{'Errors'} = 'Грешке';

    # SysConfig
    $Self->{Translation}->{'Alternative to'} = 'Алтернатива за';
    $Self->{Translation}->{'Both'} = 'Оба';
    $Self->{Translation}->{'Connected to'} = 'Повезано на';
    $Self->{Translation}->{'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js and Core.Agent.LinkObject.js.'} =
        'Дефинише Акције где је дугме поставки доступно у повезаном графичком елементу објекта (LinkObject::ViewMode = "complex"). Молимо да имате на уму да ове Акције морају да буду регистроване у следећим JS и CSS датотекама: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js и Core.Agent.LinkObject.js.';
    $Self->{Translation}->{'Define which columns are shown in the linked Services widget (LinkObject::ViewMode = "complex"). Note: Only Service attributes are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.'} =
        'Дефинише које колоне су приказане у повезаном графичком елементу Сервиса (LinkObject::ViewMode = "complex"). Напомена: Само атрибути сервиса су дозвољени за подразумеване колоне. Могуће поставке: 0 = онемогућено, 1 = доступно, 2 = подразумевано активирано.';
    $Self->{Translation}->{'Depends on'} = 'Зависи од';
    $Self->{Translation}->{'Frontend module registration for the AdminITSMCIPAllocate configuration in the admin area.'} =
        'Регистрација приступног модула за конфигурацију AdminITSMCIPAllocate у простору администратора.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLA object in the agent interface.'} =
        'Регистрација приступног модула за конфигурацију AgentITSMSLA објекта у интерфејсу оператера.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLAPrint object in the agent interface.'} =
        'Регистрација приступног модула за конфигурацију AgentITSMSLAPrint објекта у интерфејсу оператера.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLAZoom object in the agent interface.'} =
        'Регистрација приступног модула за конфигурацију AgentITSMSLAZoom објекта у интерфејсу оператера.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMService object in the agent interface.'} =
        'Регистрација приступног модула за конфигурацију AgentITSMService објекта у интерфејсу оператера.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMServicePrint object in the agent interface.'} =
        'Регистрација приступног модула за конфигурацију AgentITSMServicePrint објекта у интерфејсу оператера.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMServiceZoom object in the agent interface.'} =
        'Регистрација приступног модула за конфигурацију AgentITSMServiceZoom објекта у интерфејсу оператера.';
    $Self->{Translation}->{'ITSM SLA Overview.'} = 'ITSM преглед SLA.';
    $Self->{Translation}->{'ITSM Service Overview.'} = 'ITSM преглед сервиса.';
    $Self->{Translation}->{'Incident State Type'} = 'Тип стања инцидента';
    $Self->{Translation}->{'Includes'} = 'Укључује';
    $Self->{Translation}->{'Manage priority matrix.'} = 'Уредити матрицу приоритета';
    $Self->{Translation}->{'Manage the criticality - impact - priority matrix.'} = 'Уређивање матрица значај - утицај - приоритет.';
    $Self->{Translation}->{'Module to show the Back menu item in SLA menu.'} = 'Модул за приказ везе за враћање у SLA менију.';
    $Self->{Translation}->{'Module to show the Back menu item in service menu.'} = 'Модул за приказ везе за враћање у сервисном менију.';
    $Self->{Translation}->{'Module to show the Link menu item in service menu.'} = 'Модул за приказ везе у сервисном менију.';
    $Self->{Translation}->{'Module to show the Print menu item in SLA menu.'} = 'Модул за приказ везе за штампу у SLA менију.';
    $Self->{Translation}->{'Module to show the Print menu item in service menu.'} = 'Модул за приказ везе за штампу у сервисном менију.';
    $Self->{Translation}->{'Parameters for the incident states in the preference view.'} = 'Параметри за инцидентне статусе у приказу подешавања.';
    $Self->{Translation}->{'Part of'} = 'Саставни део';
    $Self->{Translation}->{'Relevant to'} = 'У зависности';
    $Self->{Translation}->{'Required for'} = 'Обавезно за';
    $Self->{Translation}->{'SLA Overview'} = 'Преглед SLA';
    $Self->{Translation}->{'SLA Print.'} = 'Штампа SLA.';
    $Self->{Translation}->{'SLA Zoom.'} = 'Детаљи SLA.';
    $Self->{Translation}->{'Service Overview'} = 'Преглед сервиса';
    $Self->{Translation}->{'Service Print.'} = 'Штампа сервиса.';
    $Self->{Translation}->{'Service Zoom.'} = 'Детаљи сервиса.';
    $Self->{Translation}->{'Service-Area'} = 'Простор сервиса';
    $Self->{Translation}->{'Set the type and direction of links to be used to calculate the incident state. The key is the name of the link type (as defined in LinkObject::Type), and the value is the direction of the IncidentLinkType that should be followed to calculate the incident state. For example if the IncidentLinkType is set to \'DependsOn\', and the Direction is \'Source\', only \'Depends on\' links will be followed (and not the opposite link \'Required for\') to calculate the incident state. You can add more link types ad directions as you like, e.g. \'Includes\' with the direction \'Target\'. All link types defined in the sysconfig options LinkObject::Type are possible and the direction can be \'Source\', \'Target\', or \'Both\'. IMPORTANT: AFTER YOU MAKE CHANGES TO THIS SYSCONFIG OPTION YOU NEED TO RUN THE CONSOLE COMMAND bin/otrs.Console.pl Admin::ITSM::IncidentState::Recalculate SO THAT ALL INCIDENT STATES WILL BE RECALCULATED BASED ON THE NEW SETTINGS!'} =
        'Подешава тип и смер веза који ће се користити за утврђивање стања инцидента. Кључ је назив типа везе (као што је дефинисано у LinkObject::Type), а вредност је смер IncidentLinkType који треба испратити за одређивање стања инцидента. На пример, ако је IncidentLinkType подешен на DependsOn и смер је Source, само веза "Зависи од" ће бити праћена (а неће и супротна веза "Неопходно за") у одређивању стања инцидента. Уколико желите може додати још типова и смерова веза, нпр. "Укључује" са смером "Циљ". Сви типови веза дефинисани у системској конфигурацији LinkObject::Type су могући и смер може бити "Извор", "Циљ" или "Оба". ВАЖНО: НАКОН ИЗМЕНЕ ОПЦИЈА СИСТЕМСКЕ КОНФИГУРАЦИЈЕ МОРАТЕ ПОКРЕНУТИ СКРИПТ bin/otrs.Console.pl Admin::ITSM::IncidentState::Recalculate ДА БИ СВА СТАЊА ИНЦИДЕНТА БИЛА ПОНОВО УТВРЂЕНА НА ОСНОВУ НОВИХ ПОДЕШАВАЊА!';
    $Self->{Translation}->{'Source'} = 'Извор';
    $Self->{Translation}->{'This setting defines that a \'ITSMChange\' object can be linked with \'Ticket\' objects using the \'Normal\' link type.'} =
        'Ово подешавање одређује да ли везом типа "Normal" објекат ITSM промена може да се повеже са објектом тикета.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'Normal\' link type.'} =
        'Ово подешавање одређује да ли везом типа "Normal" објекат ITSM конфигурациона ставка може да се повеже са објектом FAQ.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'ParentChild\' link type.'} =
        'Ово подешавање одређује да ли везом типа ParentChild објекат ITSM конфигурациона ставка може да се повеже са објектом FAQ.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'RelevantTo\' link type.'} =
        'Ово подешавање одређује да ли везом типа "RelevantTo" објекат ITSM конфигурациона ставка може да се повеже са објектом FAQ.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'AlternativeTo\' link type.'} =
        'Ово подешавање одређује да ли везом типа "AlternativeTo" објекат ITSM конфигурациона ставка може да се повеже са објектом сервиса.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'DependsOn\' link type.'} =
        'Ово подешавање одређује да ли везом типа "DependsOn" објекат ITSM конфигурациона ставка може да се повеже са објектом сервиса.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'RelevantTo\' link type.'} =
        'Ово подешавање одређује да ли везом типа "RelevantTo" објекат ITSM конфигурациона ставка може да се повеже са објектом сервиса.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'AlternativeTo\' link type.'} =
        'Ово подешавање одређује да ли везом типа "AlternativeTo" објекат ITSM конфигурациона ставка може да се повеже са објектом тикета.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'DependsOn\' link type.'} =
        'Ово подешавање одређује да ли везом типа "DependsOn" објекат ITSM конфигурациона ставка може да се повеже са објектом тикета.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'RelevantTo\' link type.'} =
        'Ово подешавање одређује да ли везом типа "RelevantTo" објекат ITSM конфигурациона ставка може да се повеже са објектом тикета.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'AlternativeTo\' link type.'} =
        'Ово подешавање одређује да ли везом типа "AlternativeTo" објекaт ITSM конфигурациона ставка може да се повеже са другим објектом ITSM конфигурациона ставка.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'ConnectedTo\' link type.'} =
        'Ово подешавање одређује да ли везом типа "ConnectedTo" објекат ITSM конфигурациона ставка може да се повеже са другим објектом ITSM конфигурациона ставка.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'DependsOn\' link type.'} =
        'Ово подешавање одређује да ли везом типа "DependsOn" објекат ITSM конфигурациона ставка може да се повеже са другим објектом ITSM конфигурациона ставка.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'Includes\' link type.'} =
        'Ово подешавање одређује да ли везом типа "Includes" објекат ITSM конфигурациона ставка може да се повеже са другим објектом ITSM конфигурациона ставка.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'RelevantTo\' link type.'} =
        'Ово подешавање одређује да ли везом типа "RelevantTo" објекат ITSM конфигурациона ставка може да се повеже са другим објектом ITSM конфигурациона ставка.';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'ITSMConfigItem\' objects using the \'DependsOn\' link type.'} =
        'Ово подешавање одређује да ли везом типа "DependsOn" објекат ITSM радни налог може да се повеже са објектом ITSM конфигурациона ставка.';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'ITSMConfigItem\' objects using the \'Normal\' link type.'} =
        'Ово подешавање одређује да ли везом типа "Normal" објекат ITSM радни налог може да се повеже са објектом ITSM конфигурациона ставка.';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Service\' objects using the \'DependsOn\' link type.'} =
        'Ово подешавање одређује да ли везом типа "DependsOn" објекат ITSM радни налог може да се повеже са објектом сервиса.';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Service\' objects using the \'Normal\' link type.'} =
        'Ово подешавање одређује да ли везом типа "Normal" објекат ITSM радни налог може да се повеже са објектом сервиса.';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Ticket\' objects using the \'Normal\' link type.'} =
        'Ово подешавање одређује да ли везом типа "Normal" објекат ITSM радни налог може да се повеже са објектом тикета.';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'Normal\' link type.'} =
        'Ово подешавање одређује да објекат сервис може да се повеже са објектом FAQ везом типа "Normal".';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'ParentChild\' link type.'} =
        'Ово подешавање одређује да објекат сервис може да се повеже са објектом FAQ везом типа "ParentChild".';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'RelevantTo\' link type.'} =
        'Ово подешавање одређује да објекат сервис може да се повеже са објектом FAQ везом типа "RelevantTo".';
    $Self->{Translation}->{'This setting defines the link type \'AlternativeTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Ово подешавање дефинише везу типа "AlternativeTo". Ако изворни и циљни назив садрже исту вредност, резултујућа веза је неусмерена. Ако су вредности различите, резултујућа веза је усмерена.';
    $Self->{Translation}->{'This setting defines the link type \'ConnectedTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Ово подешавање дефинише везу типа "ConnectedTo". Ако изворни и циљни назив садрже исту вредност, резултујућа веза је неусмерена. Ако су вредности различите, резултујућа веза је усмерена.';
    $Self->{Translation}->{'This setting defines the link type \'DependsOn\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Ово подешавање дефинише везу типа "DependsOn". Ако изворни и циљни назив садрже исту вредност, резултујућа веза је неусмерена. Ако су вредности различите, резултујућа веза је усмерена.';
    $Self->{Translation}->{'This setting defines the link type \'Includes\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Ово подешавање дефинише везу типа "Includes". Ако изворни и циљни назив садрже исту вредност, резултујућа веза је неусмерена. Ако су вредности различите, резултујућа веза је усмерена.';
    $Self->{Translation}->{'This setting defines the link type \'RelevantTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Ово подешавање дефинише везу типа "RelevantTo". Ако изворни и циљни назив садрже исту вредност, резултујућа веза је неусмерена. Ако су вредности различите, резултујућа веза је усмерена.';
    $Self->{Translation}->{'Width of ITSM textareas.'} = 'Ширина ITSM простора текста.';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
