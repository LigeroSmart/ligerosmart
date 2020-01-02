# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::sr_Latn_ITSMCore;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminITSMCIPAllocate
    $Self->{Translation}->{'Criticality ↔ Impact ↔ Priority'} = 'Značaj ↔ uticaj ↔ prioritet';
    $Self->{Translation}->{'Manage the priority result of combinating Criticality ↔ Impact.'} =
        'Upravljanje rezultatom prioriteta kombinovanjem značaj ↔ uticaj.';
    $Self->{Translation}->{'Priority allocation'} = 'Raspodela prioriteta';

    # Template: AdminSLA
    $Self->{Translation}->{'Minimum Time Between Incidents'} = 'Minimalno vreme između incidenata';

    # Template: AdminService
    $Self->{Translation}->{'Criticality'} = 'Značaj';

    # Template: AgentITSMSLAZoom
    $Self->{Translation}->{'SLA Information'} = 'Informacije o SLA';
    $Self->{Translation}->{'Last changed'} = 'Zadnji put promenjeno';
    $Self->{Translation}->{'Last changed by'} = 'Poslednji je menjao';
    $Self->{Translation}->{'Associated Services'} = 'Povezani servisi';

    # Template: AgentITSMServiceZoom
    $Self->{Translation}->{'Service Information'} = 'Servisna informacija';
    $Self->{Translation}->{'Current incident state'} = 'Trenutno stanje incidenta';
    $Self->{Translation}->{'Associated SLAs'} = 'Povezani SLA';

    # Perl Module: Kernel/Modules/AdminITSMCIPAllocate.pm
    $Self->{Translation}->{'Impact'} = 'Uticaj';

    # Perl Module: Kernel/Modules/AgentITSMSLAPrint.pm
    $Self->{Translation}->{'No SLAID is given!'} = 'Nije dat SLAID!';
    $Self->{Translation}->{'SLAID %s not found in database!'} = 'SLAID %s nije nađen u bazi podataka!';
    $Self->{Translation}->{'Calendar Default'} = 'Podrazumevani kalendar';

    # Perl Module: Kernel/Modules/AgentITSMSLAZoom.pm
    $Self->{Translation}->{'operational'} = 'operativni';
    $Self->{Translation}->{'warning'} = 'upozorenje';
    $Self->{Translation}->{'incident'} = 'incident';

    # Perl Module: Kernel/Modules/AgentITSMServicePrint.pm
    $Self->{Translation}->{'No ServiceID is given!'} = 'Nije dat ServiceID!';
    $Self->{Translation}->{'ServiceID %s not found in database!'} = 'ServiceID "%s" nije nađen u bazi podataka!';
    $Self->{Translation}->{'Current Incident State'} = 'Trenutno stanje incidenta';

    # Perl Module: Kernel/Output/HTML/LinkObject/Service.pm
    $Self->{Translation}->{'Incident State'} = 'Stanje incidenta';

    # Database XML Definition: ITSMCore.sopm
    $Self->{Translation}->{'Operational'} = 'Operativni';
    $Self->{Translation}->{'Incident'} = 'Incident';
    $Self->{Translation}->{'End User Service'} = 'Servis za krajnjeg korisnika';
    $Self->{Translation}->{'Front End'} = 'Pristupni kraj';
    $Self->{Translation}->{'Back End'} = 'Pozadina';
    $Self->{Translation}->{'IT Management'} = 'IT upravljanje';
    $Self->{Translation}->{'Reporting'} = 'Izveštavanje';
    $Self->{Translation}->{'IT Operational'} = 'IT operativno';
    $Self->{Translation}->{'Demonstration'} = 'Demonstracija';
    $Self->{Translation}->{'Project'} = 'Projekat';
    $Self->{Translation}->{'Underpinning Contract'} = 'U osnovi ugovora';
    $Self->{Translation}->{'Other'} = 'Drugo';
    $Self->{Translation}->{'Availability'} = 'Dostupnost';
    $Self->{Translation}->{'Response Time'} = 'Vreme odgovora';
    $Self->{Translation}->{'Recovery Time'} = 'Vreme oporavka';
    $Self->{Translation}->{'Resolution Rate'} = 'Stopa rešavanja';
    $Self->{Translation}->{'Transactions'} = 'Transakcije';
    $Self->{Translation}->{'Errors'} = 'Greške';

    # SysConfig
    $Self->{Translation}->{'Alternative to'} = 'Alternativa za';
    $Self->{Translation}->{'Both'} = 'Oba';
    $Self->{Translation}->{'Connected to'} = 'Povezano na';
    $Self->{Translation}->{'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js and Core.Agent.LinkObject.js.'} =
        'Definiše Akcije gde je dugme postavki dostupno u povezanom grafičkom elementu objekta (LinkObject::ViewMode = "complex"). Molimo da imate na umu da ove Akcije moraju da budu registrovane u sledećim JS i CSS datotekama: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js i Core.Agent.LinkObject.js.';
    $Self->{Translation}->{'Define which columns are shown in the linked Services widget (LinkObject::ViewMode = "complex"). Note: Only Service attributes are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.'} =
        'Definiše koje kolone su prikazane u povezanom grafičkom elementu Servisa (LinkObject::ViewMode = "complex"). Napomena: Samo atributi servisa su dozvoljeni za podrazumevane kolone. Moguće postavke: 0 = onemogućeno, 1 = dostupno, 2 = podrazumevano aktivirano.';
    $Self->{Translation}->{'Depends on'} = 'Zavisi od';
    $Self->{Translation}->{'Frontend module registration for the AdminITSMCIPAllocate configuration in the admin area.'} =
        'Registracija pristupnog modula za konfiguraciju AdminITSMCIPAllocate u prostoru administratora.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLA object in the agent interface.'} =
        'Registracija pristupnog modula za konfiguraciju AgentITSMSLA objekta u interfejsu operatera.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLAPrint object in the agent interface.'} =
        'Registracija pristupnog modula za konfiguraciju AgentITSMSLAPrint objekta u interfejsu operatera.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLAZoom object in the agent interface.'} =
        'Registracija pristupnog modula za konfiguraciju AgentITSMSLAZoom objekta u interfejsu operatera.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMService object in the agent interface.'} =
        'Registracija pristupnog modula za konfiguraciju AgentITSMService objekta u interfejsu operatera.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMServicePrint object in the agent interface.'} =
        'Registracija pristupnog modula za konfiguraciju AgentITSMServicePrint objekta u interfejsu operatera.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMServiceZoom object in the agent interface.'} =
        'Registracija pristupnog modula za konfiguraciju AgentITSMServiceZoom objekta u interfejsu operatera.';
    $Self->{Translation}->{'ITSM SLA Overview.'} = 'ITSM pregled SLA.';
    $Self->{Translation}->{'ITSM Service Overview.'} = 'ITSM pregled servisa.';
    $Self->{Translation}->{'Incident State Type'} = 'Tip stanja incidenta';
    $Self->{Translation}->{'Includes'} = 'Uključuje';
    $Self->{Translation}->{'Manage priority matrix.'} = 'Urediti matricu prioriteta';
    $Self->{Translation}->{'Manage the criticality - impact - priority matrix.'} = 'Uređivanje matrica značaj - uticaj - prioritet.';
    $Self->{Translation}->{'Module to show the Back menu item in SLA menu.'} = 'Modul za prikaz veze za vraćanje u SLA meniju.';
    $Self->{Translation}->{'Module to show the Back menu item in service menu.'} = 'Modul za prikaz veze za vraćanje u servisnom meniju.';
    $Self->{Translation}->{'Module to show the Link menu item in service menu.'} = 'Modul za prikaz veze u servisnom meniju.';
    $Self->{Translation}->{'Module to show the Print menu item in SLA menu.'} = 'Modul za prikaz veze za štampu u SLA meniju.';
    $Self->{Translation}->{'Module to show the Print menu item in service menu.'} = 'Modul za prikaz veze za štampu u servisnom meniju.';
    $Self->{Translation}->{'Parameters for the incident states in the preference view.'} = 'Parametri za incidentne statuse u prikazu podešavanja.';
    $Self->{Translation}->{'Part of'} = 'Sastavni deo';
    $Self->{Translation}->{'Relevant to'} = 'U zavisnosti';
    $Self->{Translation}->{'Required for'} = 'Obavezno za';
    $Self->{Translation}->{'SLA Overview'} = 'Pregled SLA';
    $Self->{Translation}->{'SLA Print.'} = 'Štampa SLA.';
    $Self->{Translation}->{'SLA Zoom.'} = 'Detalji SLA.';
    $Self->{Translation}->{'Service Overview'} = 'Pregled servisa';
    $Self->{Translation}->{'Service Print.'} = 'Štampa servisa.';
    $Self->{Translation}->{'Service Zoom.'} = 'Detalji servisa.';
    $Self->{Translation}->{'Service-Area'} = 'Prostor servisa';
    $Self->{Translation}->{'Set the type and direction of links to be used to calculate the incident state. The key is the name of the link type (as defined in LinkObject::Type), and the value is the direction of the IncidentLinkType that should be followed to calculate the incident state. For example if the IncidentLinkType is set to \'DependsOn\', and the Direction is \'Source\', only \'Depends on\' links will be followed (and not the opposite link \'Required for\') to calculate the incident state. You can add more link types ad directions as you like, e.g. \'Includes\' with the direction \'Target\'. All link types defined in the sysconfig options LinkObject::Type are possible and the direction can be \'Source\', \'Target\', or \'Both\'. IMPORTANT: AFTER YOU MAKE CHANGES TO THIS SYSCONFIG OPTION YOU NEED TO RUN THE CONSOLE COMMAND bin/otrs.Console.pl Admin::ITSM::IncidentState::Recalculate SO THAT ALL INCIDENT STATES WILL BE RECALCULATED BASED ON THE NEW SETTINGS!'} =
        'Podešava tip i smer veza koji će se koristiti za utvrđivanje stanja incidenta. Ključ je naziv tipa veze (kao što je definisano u LinkObject::Type), a vrednost je smer IncidentLinkType koji treba ispratiti za određivanje stanja incidenta. Na primer, ako je IncidentLinkType podešen na DependsOn i smer je Source, samo veza "Zavisi od" će biti praćena (a neće i suprotna veza "Neophodno za") u određivanju stanja incidenta. Ukoliko želite može dodati još tipova i smerova veza, npr. "Uključuje" sa smerom "Cilj". Svi tipovi veza definisani u sistemskoj konfiguraciji LinkObject::Type su mogući i smer može biti "Izvor", "Cilj" ili "Oba". VAŽNO: NAKON IZMENE OPCIJA SISTEMSKE KONFIGURACIJE MORATE POKRENUTI SKRIPT bin/otrs.Console.pl Admin::ITSM::IncidentState::Recalculate DA BI SVA STANJA INCIDENTA BILA PONOVO UTVRĐENA NA OSNOVU NOVIH PODEŠAVANJA!';
    $Self->{Translation}->{'Source'} = 'Izvor';
    $Self->{Translation}->{'This setting defines that a \'ITSMChange\' object can be linked with \'Ticket\' objects using the \'Normal\' link type.'} =
        'Ovo podešavanje određuje da li vezom tipa "Normal" objekat ITSM promena može da se poveže sa objektom tiketa.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'Normal\' link type.'} =
        'Ovo podešavanje određuje da li vezom tipa "Normal" objekat ITSM konfiguraciona stavka može da se poveže sa objektom FAQ.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'ParentChild\' link type.'} =
        'Ovo podešavanje određuje da li vezom tipa ParentChild objekat ITSM konfiguraciona stavka može da se poveže sa objektom FAQ.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'RelevantTo\' link type.'} =
        'Ovo podešavanje određuje da li vezom tipa "RelevantTo" objekat ITSM konfiguraciona stavka može da se poveže sa objektom FAQ.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'AlternativeTo\' link type.'} =
        'Ovo podešavanje određuje da li vezom tipa "AlternativeTo" objekat ITSM konfiguraciona stavka može da se poveže sa objektom servisa.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'DependsOn\' link type.'} =
        'Ovo podešavanje određuje da li vezom tipa "DependsOn" objekat ITSM konfiguraciona stavka može da se poveže sa objektom servisa.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'RelevantTo\' link type.'} =
        'Ovo podešavanje određuje da li vezom tipa "RelevantTo" objekat ITSM konfiguraciona stavka može da se poveže sa objektom servisa.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'AlternativeTo\' link type.'} =
        'Ovo podešavanje određuje da li vezom tipa "AlternativeTo" objekat ITSM konfiguraciona stavka može da se poveže sa objektom tiketa.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'DependsOn\' link type.'} =
        'Ovo podešavanje određuje da li vezom tipa "DependsOn" objekat ITSM konfiguraciona stavka može da se poveže sa objektom tiketa.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'RelevantTo\' link type.'} =
        'Ovo podešavanje određuje da li vezom tipa "RelevantTo" objekat ITSM konfiguraciona stavka može da se poveže sa objektom tiketa.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'AlternativeTo\' link type.'} =
        'Ovo podešavanje određuje da li vezom tipa "AlternativeTo" objekat ITSM konfiguraciona stavka može da se poveže sa drugim objektom ITSM konfiguraciona stavka.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'ConnectedTo\' link type.'} =
        'Ovo podešavanje određuje da li vezom tipa "ConnectedTo" objekat ITSM konfiguraciona stavka može da se poveže sa drugim objektom ITSM konfiguraciona stavka.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'DependsOn\' link type.'} =
        'Ovo podešavanje određuje da li vezom tipa "DependsOn" objekat ITSM konfiguraciona stavka može da se poveže sa drugim objektom ITSM konfiguraciona stavka.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'Includes\' link type.'} =
        'Ovo podešavanje određuje da li vezom tipa "Includes" objekat ITSM konfiguraciona stavka može da se poveže sa drugim objektom ITSM konfiguraciona stavka.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'RelevantTo\' link type.'} =
        'Ovo podešavanje određuje da li vezom tipa "RelevantTo" objekat ITSM konfiguraciona stavka može da se poveže sa drugim objektom ITSM konfiguraciona stavka.';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'ITSMConfigItem\' objects using the \'DependsOn\' link type.'} =
        'Ovo podešavanje određuje da li vezom tipa "DependsOn" objekat ITSM radni nalog može da se poveže sa objektom ITSM konfiguraciona stavka.';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'ITSMConfigItem\' objects using the \'Normal\' link type.'} =
        'Ovo podešavanje određuje da li vezom tipa "Normal" objekat ITSM radni nalog može da se poveže sa objektom ITSM konfiguraciona stavka.';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Service\' objects using the \'DependsOn\' link type.'} =
        'Ovo podešavanje određuje da li vezom tipa "DependsOn" objekat ITSM radni nalog može da se poveže sa objektom servisa.';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Service\' objects using the \'Normal\' link type.'} =
        'Ovo podešavanje određuje da li vezom tipa "Normal" objekat ITSM radni nalog može da se poveže sa objektom servisa.';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Ticket\' objects using the \'Normal\' link type.'} =
        'Ovo podešavanje određuje da li vezom tipa "Normal" objekat ITSM radni nalog može da se poveže sa objektom tiketa.';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'Normal\' link type.'} =
        'Ovo podešavanje određuje da objekat servis može da se poveže sa objektom FAQ vezom tipa "Normal".';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'ParentChild\' link type.'} =
        'Ovo podešavanje određuje da objekat servis može da se poveže sa objektom FAQ vezom tipa "ParentChild".';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'RelevantTo\' link type.'} =
        'Ovo podešavanje određuje da objekat servis može da se poveže sa objektom FAQ vezom tipa "RelevantTo".';
    $Self->{Translation}->{'This setting defines the link type \'AlternativeTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Ovo podešavanje definiše vezu tipa "AlternativeTo". Ako izvorni i ciljni naziv sadrže istu vrednost, rezultujuća veza je neusmerena. Ako su vrednosti različite, rezultujuća veza je usmerena.';
    $Self->{Translation}->{'This setting defines the link type \'ConnectedTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Ovo podešavanje definiše vezu tipa "ConnectedTo". Ako izvorni i ciljni naziv sadrže istu vrednost, rezultujuća veza je neusmerena. Ako su vrednosti različite, rezultujuća veza je usmerena.';
    $Self->{Translation}->{'This setting defines the link type \'DependsOn\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Ovo podešavanje definiše vezu tipa "DependsOn". Ako izvorni i ciljni naziv sadrže istu vrednost, rezultujuća veza je neusmerena. Ako su vrednosti različite, rezultujuća veza je usmerena.';
    $Self->{Translation}->{'This setting defines the link type \'Includes\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Ovo podešavanje definiše vezu tipa "Includes". Ako izvorni i ciljni naziv sadrže istu vrednost, rezultujuća veza je neusmerena. Ako su vrednosti različite, rezultujuća veza je usmerena.';
    $Self->{Translation}->{'This setting defines the link type \'RelevantTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Ovo podešavanje definiše vezu tipa "RelevantTo". Ako izvorni i ciljni naziv sadrže istu vrednost, rezultujuća veza je neusmerena. Ako su vrednosti različite, rezultujuća veza je usmerena.';
    $Self->{Translation}->{'Width of ITSM textareas.'} = 'Širina ITSM prostora teksta.';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
