# --
# Kernel/Language/de_OTRSMasterSlave.pm - provides de language translation
# Copyright (C) 2003-2012 OTRS AG, http://otrs.com/
# --
# $Id: de_OTRSMasterSlave.pm,v 1.2 2012-02-21 01:03:45 cg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
package Kernel::Language::de_OTRSMasterSlave;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

sub Data {
    my $Self = shift;

    $Self->{Translation}->{'New Master Ticket'}      = 'Neues Master Ticket';
    $Self->{Translation}->{'Unset Master Ticket'}      = 'Master Ticket aufheben';
    $Self->{Translation}->{'Unset Slave Ticket'}      = 'Slave Ticket aufheben';
    $Self->{Translation}->{'Slave of Ticket#'}      = 'Slave von Ticket#';
    $Self->{Translation}->{'MasterSlave'}    = 'MasterSlave';
    $Self->{Translation}->{'Manage Master/Slave'} = 'Master/Slave verwalten';
    $Self->{Translation}->{'Change the MasterSlave state of the ticket.'}           = 'Den MasterSlave Status des Tickets ändern.';
    $Self->{Translation}->{'Define free text field for master ticket feature.'}                   = 'Das Freitextfeld für die MasterSlave Erweiterung festlegen.';
    $Self->{Translation}->{'Enable the advanced MasterSlave part of the feature.'}             = 'Das erweiterte Verhalten der MasterSlave Erweiterung aktivieren.';
    $Self->{Translation}->{'Enable the feature to unset the MasterSlave state of a ticket in the advanced MasterSlave mode.'}               = 'Aktiviere den Modus um den MasterSlave Status eines Tickets im erweiterten MasterSlave Verhalten aufzuheben.';
    $Self->{Translation}->{'Enable the feature to update the MasterSlave state of a ticket in the advanced MasterSlave mode.'}                   = 'Aktiviere den Modus um den MasterSlave Status eines Tickets im erweiterten MasterSlave Verhalten zu ändern.';
    $Self->{Translation}->{'Enable the feature that slave tickets follow the master ticket to a new master in the advanced MasterSlave mode.'}                = 'Aktiviere den Modus das Slave Tickets dem Master Ticket im erweiterten MasterSlave Verhalten zum neuen Master folgen.';
    $Self->{Translation}->{'This module is preparing master/slave pulldown in email and phone ticket.'}             = 'Legt das Modul fest das das DropDown Feld im Email- und Telefonticket Dialog bereitstellt.';
    $Self->{Translation}->{'Shows a link in the menu to change the MasterSlave status of a ticket in the ticket zoom view of the agent interface.'}       = 'Zeigt einen Link im Menü um den MasterSlave Status eines Tickets im Ticket Zoom Interface des Agenten an.';
    $Self->{Translation}->{'Required permissions to use the ticket MasterSlave screen of a zoomed ticket in the agent interface.'}              = 'Benötigte Berechtigungen um den MasterSlave Dialog im Zoom Ticket Dialog des Agenteninterface anzeigen zu lassen.';

    return 1;
}

1;
