# --
# Kernel/Language/zh_CN_ITSMTicket.pm - translation file
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: zh_CN_ITSMTicket.pm,v 1.10 2012-06-28 21:11:08 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::zh_CN_ITSMTicket;

use strict;

sub Data {
    my $Self = shift;

    # Template: AgentTicketActionCommon
    $Self->{Translation}->{'Change Decision of Ticket'} = '';
    $Self->{Translation}->{'Change ITSM fields of ticket'} = '为该 Ticket 更改 ITSM 域';
    $Self->{Translation}->{'Impact'} = '';

    # Template: AgentTicketAddtlITSMField

    # Template: AgentTicketDecision

    # Template: AgentTicketEmail
    $Self->{Translation}->{'Link ticket'} = '';

    # Template: AgentTicketOverviewMedium

    # Template: AgentTicketOverviewPreview
    $Self->{Translation}->{'Criticality'} = '';

    # Template: AgentTicketPhone

    # Template: AgentTicketPrint

    # Template: AgentTicketZoom
    $Self->{Translation}->{'Decision Result'} = '决定结果';
    $Self->{Translation}->{'Decision Date'} = '决定日期';
    $Self->{Translation}->{'Repair Start Time'} = '修复开始时间';
    $Self->{Translation}->{'Recovery Start Time'} = '恢复运作时间';
    $Self->{Translation}->{'Due Date'} = '截止日期';

    # Template: CustomerTicketPrint

    # Template: CustomerTicketZoom

    # SysConfig
    $Self->{Translation}->{'Add a decision!'} = '增加一个决议!';
    $Self->{Translation}->{'Additional ITSM Fields'} = '额外的 ITSM 域';
    $Self->{Translation}->{'Allows adding notes in the additional ITSM field screen of the agent interface.'} = '';
    $Self->{Translation}->{'Allows adding notes in the decision screen of the agent interface.'} = '';
    $Self->{Translation}->{'Article free text options shown in the additional ITSM field screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} = '';
    $Self->{Translation}->{'Article free text options shown in the decision screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} = '';
    $Self->{Translation}->{'Change the ITSM fields!'} = '更改 ITSM 域!';
    $Self->{Translation}->{'Decision'} = '决定';
    $Self->{Translation}->{'Defines if a ticket lock is required in the additional ITSM field screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} = '';
    $Self->{Translation}->{'Defines if a ticket lock is required in the decision screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} = '';
    $Self->{Translation}->{'Defines the default body of a note in the additional ITSM field screen of the agent interface.'} = '';
    $Self->{Translation}->{'Defines the default body of a note in the decision screen of the agent interface.'} = '';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the additional ITSM field screen of the agent interface.'} = '';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the decision screen of the agent interface.'} = '';
    $Self->{Translation}->{'Defines the default subject of a note in the additional ITSM field screen of the agent interface.'} = '';
    $Self->{Translation}->{'Defines the default subject of a note in the decision screen of the agent interface.'} = '';
    $Self->{Translation}->{'Defines the default ticket priority in the additional ITSM field screen of the agent interface.'} = '';
    $Self->{Translation}->{'Defines the default ticket priority in the decision screen of the agent interface.'} = '';
    $Self->{Translation}->{'Defines the default type of the note in the additional ITSM field screen of the agent interface.'} = '';
    $Self->{Translation}->{'Defines the default type of the note in the decision screen of the agent interface.'} = '';
    $Self->{Translation}->{'Defines the history comment for the additional ITSM field screen action, which gets used for ticket history.'} = '';
    $Self->{Translation}->{'Defines the history comment for the decision screen action, which gets used for ticket history.'} = '';
    $Self->{Translation}->{'Defines the history type for the additional ITSM field screen action, which gets used for ticket history.'} = '';
    $Self->{Translation}->{'Defines the history type for the decision screen action, which gets used for ticket history.'} = '';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the additional ITSM field screen of the agent interface.'} = '';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the decision screen of the agent interface.'} = '';
    $Self->{Translation}->{'Defines the the free key field number 13 for tickets to add a new ticket attribute.'} = '';
    $Self->{Translation}->{'Defines the the free key field number 14 for tickets to add a new ticket attribute.'} = '';
    $Self->{Translation}->{'Defines the the free key field number 15 for tickets to add a new ticket attribute.'} = '';
    $Self->{Translation}->{'Defines the the free key field number 16 for tickets to add a new ticket attribute.'} = '';
    $Self->{Translation}->{'Enables the stats module to generate statistics about the average of ITSM ticket first level solution rate.'} = '';
    $Self->{Translation}->{'Enables the stats module to generate statistics about the average of ITSM ticket solution.'} = '';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of a ticket in the additional ITSM field screen of the agent interface.'} = '';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of a ticket in the decision screen of the agent interface.'} = '';
    $Self->{Translation}->{'Required permissions to use the additional ITSM field screen in the agent interface.'} = '';
    $Self->{Translation}->{'Required permissions to use the decision screen in the agent interface.'} = '';
    $Self->{Translation}->{'Sets the service in the additional ITSM field screen of the agent interface (Ticket::Service needs to be activated).'} = '';
    $Self->{Translation}->{'Sets the service in the decision screen of the agent interface (Ticket::Service needs to be activated).'} = '';
    $Self->{Translation}->{'Sets the ticket owner in the additional ITSM field screen of the agent interface.'} = '';
    $Self->{Translation}->{'Sets the ticket owner in the decision screen of the agent interface.'} = '';
    $Self->{Translation}->{'Sets the ticket responsible in the additional ITSM field screen of the agent interface.'} = '';
    $Self->{Translation}->{'Sets the ticket responsible in the decision screen of the agent interface.'} = '';
    $Self->{Translation}->{'Sets the ticket type in the additional ITSM field screen of the agent interface (Ticket::Type needs to be activated).'} = '';
    $Self->{Translation}->{'Sets the ticket type in the decision screen of the agent interface (Ticket::Type needs to be activated).'} = '';
    $Self->{Translation}->{'Shows a link in the menu to change the decision of a ticket in its zoom view of the agent interface.'} = '';
    $Self->{Translation}->{'Shows a link in the menu to modify additional ITSM fields in the ticket zoom view of the agent interface.'} = '';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the additional ITSM field screen of the agent interface.'} = '';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the decision screen of the agent interface.'} = '';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the additional ITSM field screen of the agent interface.'} = '';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the decision screen of the agent interface.'} = '';
    $Self->{Translation}->{'Shows the ticket priority options in the additional ITSM field screen of the agent interface.'} = '';
    $Self->{Translation}->{'Shows the ticket priority options in the decision screen of the agent interface.'} = '';
    $Self->{Translation}->{'Shows the title fields in the additional ITSM field screen of the agent interface.'} = '';
    $Self->{Translation}->{'Shows the title fields in the decision screen of the agent interface.'} = '';
    $Self->{Translation}->{'Ticket free text options shown in the additional ITSM field screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} = '';
    $Self->{Translation}->{'Ticket free text options shown in the decision screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} = '';
    $Self->{Translation}->{'Ticket free time options shown in the additional ITSM field screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} = '';
    $Self->{Translation}->{'Ticket free time options shown in the decision screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} = '';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #
    $Self->{Translation}->{'Add decision to ticket'} = '增加决定到 Ticket';
    $Self->{Translation}->{'Approved'} = '批准';
    $Self->{Translation}->{'Postponed'} = '推迟';
    $Self->{Translation}->{'Pre-approved'} = '预先核准';
    $Self->{Translation}->{'Reason'} = '理由';
    $Self->{Translation}->{'Rejected'} = '拒绝';
    $Self->{Translation}->{'Review Required'} = '审查申请';
    $Self->{Translation}->{'closed with workaround'} = '替代方法而关闭';

}

1;
