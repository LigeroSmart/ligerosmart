# --
# Kernel/Language/de_ITSMCore.pm - the german translation of ITSMCore
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: de_ITSMCore.pm,v 1.20 2010-08-12 22:58:07 en Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::de_ITSMCore;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.20 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Criticality'}                         = 'Kritikalität';
    $Lang->{'Impact'}                              = 'Auswirkung';
    $Lang->{'Criticality <-> Impact <-> Priority'} = 'Kritikalität <-> Auswirkung <-> Priorität';
    $Lang->{'allocation'}                          = 'zuordnen';
    $Lang->{'Priority allocation'}                 = 'Priorität zuordnen';
    $Lang->{'Relevant to'}                         = 'Relevant für';
    $Lang->{'Includes'}                            = 'Beinhaltet';
    $Lang->{'Part of'}                             = 'Teil von';
    $Lang->{'Depends on'}                          = 'Hängt ab von';
    $Lang->{'Required for'}                        = 'Benötigt für';
    $Lang->{'Connected to'}                        = 'Verbunden mit';
    $Lang->{'Alternative to'}                      = 'Alternativ zu';
    $Lang->{'Incident State'}                      = 'Vorfallsstatus';
    $Lang->{'Current Incident State'}              = 'Aktueller Vorfallsstatus';
    $Lang->{'Current State'}                       = 'Aktueller Status';
    $Lang->{'Service-Area'}                        = 'Service-Bereich';
    $Lang->{'Minimum Time Between Incidents'}      = 'Mindestzeit zwischen Incidents';
    $Lang->{'Service Overview'}                    = 'Service Übersicht';
    $Lang->{'SLA Overview'}                        = 'SLA Übersicht';
    $Lang->{'Associated Services'}                 = 'Zugehörige Services';
    $Lang->{'Associated SLAs'}                     = 'Zugehörige SLAs';
    $Lang->{'Back End'}                            = 'Backend';
    $Lang->{'Demonstration'}                       = 'Demonstration';
    $Lang->{'End User Service'}                    = 'Anwender-Service';
    $Lang->{'Front End'}                           = 'Frontend';
    $Lang->{'IT Management'}                       = 'IT Management';
    $Lang->{'IT Operational'}                      = 'IT Betrieb';
    $Lang->{'Other'}                               = 'Sonstiges';
    $Lang->{'Project'}                             = 'Projekt';
    $Lang->{'Reporting'}                           = 'Reporting';
    $Lang->{'Training'}                            = 'Training';
    $Lang->{'Underpinning Contract'}               = 'Underpinning Contract';
    $Lang->{'Availability'}                        = 'Verfügbarkeit';
    $Lang->{'Errors'}                              = 'Fehler';
    $Lang->{'Other'}                               = 'Sonstiges';
    $Lang->{'Recovery Time'}                       = 'Wiederherstellungszeit';
    $Lang->{'Resolution Rate'}                     = 'Lösungszeit';
    $Lang->{'Response Time'}                       = 'Reaktionszeit';
    $Lang->{'Transactions'}                        = 'Transaktionen';
    $Lang->{'This setting controls the name of the application as is shown in the web interface as well as the tabs and title bar of your web browser.'} = 'Im WebFrontend angezeigter Name der Software.';
    $Lang->{'Determines the way the linked objects are displayed in each zoom mask.'} = 'Legt die Ansicht der verlinkten Objekte in den jeweiligen Zoom-Masken fest.';
    $Lang->{'List of online repositories (for example you also can use other installations as repositoriy by using Key="http://example.com/otrs/public.pl?Action=PublicRepository&File=" and Content="Some Name").'} = 'Liste der zur Verfuegung stehenden Online-Quellen (es koennen z. B. auch andere Installationen als Online-Quellen verwendet werden mit der Verwendung von Key="http://example.com/otrs/public.pl?Action=PublicRepository&File=" and Content="Ein Name").';
    $Lang->{'Frontend module registration for the AgentITSMService object in the agent interface.'} = 'Frontendmodul-Registration des AgentITSMService-Objekts im Agent-Interface.';
    $Lang->{'Frontend module registration for the AgentITSMSLA object in the agent interface.'} = 'Frontendmodul-Registration des AgentITSMSLA-Objekts im Agent-Interface.';
    $Lang->{'Frontend module registration for the AgentITSMServiceZoom object in the agent interface.'} = 'Frontendmodul-Registration des AgentITSMServiceZoom-Objekts im Agent-Interface.';
    $Lang->{'Frontend module registration for the AgentITSMServicePrint object in the agent interface.'} = 'Frontendmodul-Registration des AgentITSMServicePrint-Objekts im Agent-Interface.';
    $Lang->{'Frontend module registration for the AgentITSMSLAZoom object in the agent interface.'} = 'Frontendmodul-Registration des AgentITSMSLAZoom-Objekts im Agent-Interface.';
    $Lang->{'Frontend module registration for the AgentITSMSLAPrint object in the agent interface.'} = 'Frontendmodul-Registration des AgentITSMSLAPrint-Objekts im Agent-Interface.';
    $Lang->{'Module to show back link in service menu.'} = 'Über dieses Modul wird der Zurück-Link in der Linkleiste der Service-Ansicht angezeigt.';
    $Lang->{'Module to show print link in service menu.'} = 'Über dieses Modul wird der Drucken-Link in der Linkleiste der Service-Ansicht angezeigt.';
    $Lang->{'Module to show link link in service menu.'} = 'Über dieses Modul wird der Verknüpfen-Link in der Linkleiste der Service-Ansicht angezeigt.';
    $Lang->{'Module to show back link in sla menu.'} = 'Über dieses Modul wird der Zurück-Link in der Linkleiste der SLA-Ansicht angezeigt.';
    $Lang->{'Module to show print link in sla menu.'} = 'Über dieses Modul wird der Drucken-Link in der Linkleiste der SLA-Ansicht angezeigt.';
    $Lang->{'If ticket service/SLA feature is enabled, you can define ticket services and SLAs for tickets (e. g. email, desktop, network, ...).'} = 'Wenn das Ticket-Service/SLA Feature aktiviert ist, können Ticket Services und SLAs pro Ticket gesetzt werden (z. B. Email, Arbeitsplatz, Netzwerk, ...).';

    return 1;
}

1;
