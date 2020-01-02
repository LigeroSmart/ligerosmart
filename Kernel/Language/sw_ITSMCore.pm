# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::sw_ITSMCore;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminITSMCIPAllocate
    $Self->{Translation}->{'Criticality ↔ Impact ↔ Priority'} = 'Umuhimu ↔ Madhara ↔ Kipaumbele';
    $Self->{Translation}->{'Manage the priority result of combinating Criticality ↔ Impact.'} =
        'Simamia matokeo ya kipaumbele ya kuunganisha Umuhimu ';
    $Self->{Translation}->{'Priority allocation'} = 'Kuweka kipaumbele';

    # Template: AdminSLA
    $Self->{Translation}->{'Minimum Time Between Incidents'} = 'Kima cha chini cha muda kati ya matukio';

    # Template: AdminService
    $Self->{Translation}->{'Criticality'} = 'Umuhimu';

    # Template: AgentITSMSLAZoom
    $Self->{Translation}->{'SLA Information'} = 'Taarifa za SLA';
    $Self->{Translation}->{'Last changed'} = 'Mwisho kubadilishwa';
    $Self->{Translation}->{'Last changed by'} = 'Mwsho kubadilishwa na';
    $Self->{Translation}->{'Associated Services'} = 'Huduma zinazohusika';

    # Template: AgentITSMServiceZoom
    $Self->{Translation}->{'Service Information'} = 'Taarifa za huduma';
    $Self->{Translation}->{'Current incident state'} = 'Hali ya tukio la sasa';
    $Self->{Translation}->{'Associated SLAs'} = 'SLA zinazohusika';

    # Perl Module: Kernel/Modules/AdminITSMCIPAllocate.pm
    $Self->{Translation}->{'Impact'} = 'Madhara';

    # Perl Module: Kernel/Modules/AgentITSMSLAPrint.pm
    $Self->{Translation}->{'No SLAID is given!'} = '';
    $Self->{Translation}->{'SLAID %s not found in database!'} = '';
    $Self->{Translation}->{'Calendar Default'} = '';

    # Perl Module: Kernel/Modules/AgentITSMSLAZoom.pm
    $Self->{Translation}->{'operational'} = '';
    $Self->{Translation}->{'warning'} = '';
    $Self->{Translation}->{'incident'} = '';

    # Perl Module: Kernel/Modules/AgentITSMServicePrint.pm
    $Self->{Translation}->{'No ServiceID is given!'} = '';
    $Self->{Translation}->{'ServiceID %s not found in database!'} = '';
    $Self->{Translation}->{'Current Incident State'} = 'Hali ya tukio la sasa';

    # Perl Module: Kernel/Output/HTML/LinkObject/Service.pm
    $Self->{Translation}->{'Incident State'} = 'Hali ya tukio';

    # Database XML Definition: ITSMCore.sopm
    $Self->{Translation}->{'Operational'} = 'Uendeshaji';
    $Self->{Translation}->{'Incident'} = 'Tukio';
    $Self->{Translation}->{'End User Service'} = 'Huduma ya mtumiaji wa mwihso';
    $Self->{Translation}->{'Front End'} = 'Mazingira ya mbele';
    $Self->{Translation}->{'Back End'} = 'Mazingira ya nyuma';
    $Self->{Translation}->{'IT Management'} = 'Usimamizi wa IT';
    $Self->{Translation}->{'Reporting'} = 'Uarifu';
    $Self->{Translation}->{'IT Operational'} = 'Uendeshaji wa IT';
    $Self->{Translation}->{'Demonstration'} = 'Maonyesho';
    $Self->{Translation}->{'Project'} = 'Mradi';
    $Self->{Translation}->{'Underpinning Contract'} = 'Mkataba wa kuimarisha';
    $Self->{Translation}->{'Other'} = 'Engine';
    $Self->{Translation}->{'Availability'} = 'Upatikanaji';
    $Self->{Translation}->{'Response Time'} = 'Muda wa majibu';
    $Self->{Translation}->{'Recovery Time'} = 'Muda wa kupona';
    $Self->{Translation}->{'Resolution Rate'} = 'Kiwango cha muonekano';
    $Self->{Translation}->{'Transactions'} = 'Miamala';
    $Self->{Translation}->{'Errors'} = 'Makosa';

    # SysConfig
    $Self->{Translation}->{'Alternative to'} = 'Badala ya ';
    $Self->{Translation}->{'Both'} = '';
    $Self->{Translation}->{'Connected to'} = 'Imeunganishwa na';
    $Self->{Translation}->{'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js and Core.Agent.LinkObject.js.'} =
        '';
    $Self->{Translation}->{'Define which columns are shown in the linked Services widget (LinkObject::ViewMode = "complex"). Note: Only Service attributes are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.'} =
        '';
    $Self->{Translation}->{'Depends on'} = 'Inategemeana na ';
    $Self->{Translation}->{'Frontend module registration for the AdminITSMCIPAllocate configuration in the admin area.'} =
        'Usajili wa moduli za mazingira ya mbele kwa usanidi wa AdminITSMCIPAllocate katika eneo la kiongozi.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLA object in the agent interface.'} =
        'Usajili wa moduli ya mazingira ya mbele kwa kipengee cha ITSMSLA cha wakala  katika kiolesura cha wakala.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLAPrint object in the agent interface.'} =
        'Usajili wa moduli ya mazingira ya mbele kwa kipengee cha  uchapishwaji cha ITSMSLA cha wakala katika kiolesura cha wakala';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLAZoom object in the agent interface.'} =
        'Usajili wa moduli ya mazingira ya mbele kwa kipengee cha kukuzwa cha ITSMSLA cha wakala katika kiolesura cha wakala';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMService object in the agent interface.'} =
        'Usajili wa moduli ya mazingira ya mbele kwa kipengee cha huduma cha ITSMSLA cha wakala katika kiolesura cha wakala.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMServicePrint object in the agent interface.'} =
        'Usajili wa moduli ya mazingira ya mbele kwa kipengee cha kuchapishwa kwa huduma cha ITSMSLA cha wakala katika kiolesura cha wakala.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMServiceZoom object in the agent interface.'} =
        'Usajili wa moduli ya mazingira ya mbele kwa kipengee cha kukuzwa kwa huduma cha ITSMSLA cha wakala katika kiolesura cha wakala.';
    $Self->{Translation}->{'ITSM SLA Overview.'} = '';
    $Self->{Translation}->{'ITSM Service Overview.'} = '';
    $Self->{Translation}->{'Incident State Type'} = '';
    $Self->{Translation}->{'Includes'} = 'Inahusisha';
    $Self->{Translation}->{'Manage priority matrix.'} = 'Simamia matriki ya kipaumbele.';
    $Self->{Translation}->{'Manage the criticality - impact - priority matrix.'} = '';
    $Self->{Translation}->{'Module to show the Back menu item in SLA menu.'} = 'Moduli ya kuonyesha kiungo cha kurudi nyuma katika menyu ya sla.';
    $Self->{Translation}->{'Module to show the Back menu item in service menu.'} = 'Moduli ya kuonyesha kiungo cha kurudi nyuma katika menyu ya huduma.';
    $Self->{Translation}->{'Module to show the Link menu item in service menu.'} = 'Moduli ya kuonyesha kiungo cha kiungo katika menyu ya huduma.';
    $Self->{Translation}->{'Module to show the Print menu item in SLA menu.'} = 'Moduli ya kuonyesha kiungo cha kuchapisha katika menyu ya sla.';
    $Self->{Translation}->{'Module to show the Print menu item in service menu.'} = 'Moduli ya kuonyesha kiungo cha kuchapisha katika menyu ya huduma.';
    $Self->{Translation}->{'Parameters for the incident states in the preference view.'} = 'Vigezo ya hali ya matukio katika mandhari ya mapendeleo.';
    $Self->{Translation}->{'Part of'} = 'Sehemu ya';
    $Self->{Translation}->{'Relevant to'} = 'Husiana na';
    $Self->{Translation}->{'Required for'} = 'Inahitajika kwa';
    $Self->{Translation}->{'SLA Overview'} = 'Marejeo ya SLA';
    $Self->{Translation}->{'SLA Print.'} = '';
    $Self->{Translation}->{'SLA Zoom.'} = '';
    $Self->{Translation}->{'Service Overview'} = 'Marejeo ya huduma';
    $Self->{Translation}->{'Service Print.'} = '';
    $Self->{Translation}->{'Service Zoom.'} = '';
    $Self->{Translation}->{'Service-Area'} = 'Eneo la huduma';
    $Self->{Translation}->{'Set the type and direction of links to be used to calculate the incident state. The key is the name of the link type (as defined in LinkObject::Type), and the value is the direction of the IncidentLinkType that should be followed to calculate the incident state. For example if the IncidentLinkType is set to \'DependsOn\', and the Direction is \'Source\', only \'Depends on\' links will be followed (and not the opposite link \'Required for\') to calculate the incident state. You can add more link types ad directions as you like, e.g. \'Includes\' with the direction \'Target\'. All link types defined in the sysconfig options LinkObject::Type are possible and the direction can be \'Source\', \'Target\', or \'Both\'. IMPORTANT: AFTER YOU MAKE CHANGES TO THIS SYSCONFIG OPTION YOU NEED TO RUN THE CONSOLE COMMAND bin/otrs.Console.pl Admin::ITSM::IncidentState::Recalculate SO THAT ALL INCIDENT STATES WILL BE RECALCULATED BASED ON THE NEW SETTINGS!'} =
        '';
    $Self->{Translation}->{'Source'} = '';
    $Self->{Translation}->{'This setting defines that a \'ITSMChange\' object can be linked with \'Ticket\' objects using the \'Normal\' link type.'} =
        'Mpangilio huu unafafanua kwamba kipengee cha \'Badiliko la ITSM\' kinweza kuunganishwa na kipengee cha \'Tiketi\' kwa kutumia aina ya kiungo \'Kawaida\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'Normal\' link type.'} =
        'Mpangilio huu unafafanua kwamba kipengee cha \'Kipengele cha usanidi cha ITSM\' kinaweza kuunganishwa na kipengee cha \'Maswali yanayoulizwa mara kwa mara\' kwa kutumia aina ya kiungo \'Kawaida\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'ParentChild\' link type.'} =
        'Mpangilio huu unafafanua kwamba kipengee cha \'Kipengele cha usanidi cha ITSM\' kinaweza kuunganishwa na kipengee cha \'Maswali yanayoulizwa mara kwa mara\' kwa kutumia aina ya kiungo \'ParentChild\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'RelevantTo\' link type.'} =
        'Mpangilio huu unafafanua kwamba kipengee cha \'Kipengele cha usanidi cha ITSM\' kinaweza kuunganishwa na kipengee cha \'Maswali yanayoulizwa mara kwa mara\' kwa kutumia aina ya kiungo \'Inahusiana na\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'AlternativeTo\' link type.'} =
        'Mpangilio huu unafafanua kwamba kipengee cha \'Kipengele cha usanidi cha ITSM\' kinaweza kuunganishwa na kipengee cha \'Huduma\' kwa kutumia aina ya kiungo \'Badala ya\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'DependsOn\' link type.'} =
        'Mpangilio huu unafafanua kwamba kipengee cha \'Kipengele cha usanidi cha ITSM\' kinaweza kuunganishwa na kipengee cha \'Huduma\' kwa kutumia aina ya kiungo \'Inategemeana na\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'RelevantTo\' link type.'} =
        'Mpangilio huu unafafanua kwamba kipengee cha \'Kipengele cha usanidi cha ITSM\' kinaweza kuunganishwa na kipengee cha \'Huduma\' kwa kutumia aina ya kiungo \'Husiana na\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'AlternativeTo\' link type.'} =
        'Mpangilio huu unafafanua kwamba kipengee cha \'Kipengele cha usanidi cha ITSM\' kinaweza kuunganishwa na kipengee cha \'Tiketi\' kwa kutumia aina ya kiungo \'Badala ya\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'DependsOn\' link type.'} =
        'Mpangilio huu unafafanua kwamba kipengee cha \'Kipengele cha usanidi cha ITSM\' kinaweza kuunganishwa na kipengee cha \'Tiketi\' kwa kutumia aina ya kiungo \'Inategemeana na\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'RelevantTo\' link type.'} =
        'Mpangilio huu unafafanua kwamba kipengee cha \'Kipengele cha usanidi cha ITSM\' kinaweza kuunganishwa na kipengee cha \'Tiketi\' kwa kutumia aina ya kiungo \'Husiana na\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'AlternativeTo\' link type.'} =
        'Mpangilio huu unafafanua kwamba kipengee cha \'Kipengele cha usanidi cha ITSM\' kinaweza kuunganishwa na kipengee kingine cha\'Kipengele cha usanidi cha ITSM\'  kwa kutumia aina ya kiungo \'Badala ya\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'ConnectedTo\' link type.'} =
        'Mpangilio huu unafafanua kwamba kipengee cha \'Kipengele cha usanidi cha ITSM\' kinaweza kuunganishwa na kipengee kingine cha\'Kipengele cha usanidi cha ITSM\'  kwa kutumia aina ya kiungo \'Inaunganishwa na\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'DependsOn\' link type.'} =
        'Mpangilio huu unafafanua kwamba kipengee cha \'Kipengele cha usanidi cha ITSM\' kinaweza kuunganishwa na kipengee kingine cha\'Kipengele cha usanidi cha ITSM\'  kwa kutumia aina ya kiungo \'Inategemeana na\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'Includes\' link type.'} =
        'Mpangilio huu unafafanua kwamba kipengee cha \'Kipengele cha usanidi cha ITSM\' kinaweza kuunganishwa na kipengee kingine cha\'Kipengele cha usanidi cha ITSM\'  kwa kutumia aina ya kiungo \'Husisha\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'RelevantTo\' link type.'} =
        'Mpangilio huu unafafanua kwamba kipengee cha \'Kipengele cha usanidi cha ITSM\' kinaweza kuunganishwa na kipengee kingine cha\'Kipengele cha usanidi cha ITSM\'  kwa kutumia aina ya kiungo \'Husiana na\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'ITSMConfigItem\' objects using the \'DependsOn\' link type.'} =
        'Mpangilio huu unafafanua kwamba kipengee cha \'Mpangilio wa kazi wa ITSM\' kinaweza kuunganishwa na kipengee kingine cha\'Kipengele cha usanidi cha ITSM\'  kwa kutumia aina ya kiungo \'Inategemeana na\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'ITSMConfigItem\' objects using the \'Normal\' link type.'} =
        'Mpangilio huu unafafanua kwamba kipengee cha \'Mpangilio wa kazi wa ITSM\' kinaweza kuunganishwa na kipengee kingine cha\'Kipengele cha usanidi cha ITSM\'  kwa kutumia aina ya kiungo \'Kawaida\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Service\' objects using the \'DependsOn\' link type.'} =
        'Mpangilio huu unafafanua kwamba kipengee cha \'Mpangilio wa kazi wa ITSM\' kinaweza kuunganishwa na kipengee kingine cha\'Huduma\' kwa kutumia aina ya kiungo \'Inategemeana na\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Service\' objects using the \'Normal\' link type.'} =
        'Mpangilio huu unafafanua kwamba kipengee cha \'Mpangilio wa kazi wa ITSM\' kinaweza kuunganishwa na kipengee kingine cha\'Huduma\' kwa kutumia aina ya kiungo \'Kawaida\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Ticket\' objects using the \'Normal\' link type.'} =
        'Mpangilio huu unafafanua kwamba kipengee cha \'Mpangilio wa kazi wa ITSM\' kinaweza kuunganishwa na kipengee kingine cha\'Tiketi\' kwa kutumia aina ya kiungo \'Kawaida\'.';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'Normal\' link type.'} =
        'Mpangilio huu unafafanua kwamba kipengee cha \'Huduma\' kinaweza kuunganishwa na kipengee cha \'Maswali yanayoulizwa mara kwa mara\' kwa kutumia aina ya kiungo \'Kawaida\'.';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'ParentChild\' link type.'} =
        'Mpangilio huu unafafanua kwamba kipengee cha \'Huduma\' kinaweza kuunganishwa na kipengee cha \'Maswali yanayoulizwa mara kwa mara\' kwa kutumia aina ya kiungo \'ParentChild\'.';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'RelevantTo\' link type.'} =
        'Husiana na';
    $Self->{Translation}->{'This setting defines the link type \'AlternativeTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Mipangilio hii inafafanua aina ya kiungo \'Badala ya\'. Kama jina la chanzo na jina lengwa yana thamani moja, kiungo kinachotokana ni hakina uelekeo. Kama thamani ni tofauti, kiungo kilichotokea kina uelekeo.';
    $Self->{Translation}->{'This setting defines the link type \'ConnectedTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Mipangilio hii inafafanua aina ya kiungo \'Imeunganishwa na\'. Kama jina la chanzo na jina lengwa yana thamani moja, kiungo kinachotokana ni hakina uelekeo. Kama thamani ni tofauti, kiungo kilichotokea kina uelekeo.';
    $Self->{Translation}->{'This setting defines the link type \'DependsOn\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Mipangilio hii inafafanua aina ya kiungo \'Inategemeana na\'. Kama jina la chanzo na jina lengwa yana thamani moja, kiungo kinachotokana ni hakina uelekeo. Kama thamani ni tofauti, kiungo kilichotokea kina uelekeo.';
    $Self->{Translation}->{'This setting defines the link type \'Includes\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Mipangilio hii inafafanua aina ya kiungo \'Inahusisha\'. Kama jina la chanzo na jina lengwa yana thamani moja, kiungo kilichotokea ni hakina uelekeo. Kama thamani ni tofauti, kiungo kilichotokea kina uelekeo.';
    $Self->{Translation}->{'This setting defines the link type \'RelevantTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Mipangilio hii inafafanua aina ya kiungo \'Husiana na\'. Kama jina la chanzo na jina lengwa yana thamani moja, kiungo kilichotokea ni hakina uelekeo. Kama thamani ni tofauti, kiungo kilichotokea kina uelekeo.';
    $Self->{Translation}->{'Width of ITSM textareas.'} = 'Upana wa eneo la matini la ITSM ';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
