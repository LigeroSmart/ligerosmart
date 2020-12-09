# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::th_TH_ITSMIncidentProblemManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentTicketOverviewMedium
    $Self->{Translation}->{'Criticality'} = 'วิกฤต';
    $Self->{Translation}->{'Impact'} = 'ผลกระทบ';

    # JS Template: ServiceIncidentState
    $Self->{Translation}->{'Service Incident State'} = 'การบริการสถานภาพของเหตุการณ์';

    # Perl Module: Kernel/Output/HTML/FilterElementPost/ITSMIncidentProblemManagement.pm
    $Self->{Translation}->{'Link ticket'} = 'ลิงค์ตั๋ว';
    $Self->{Translation}->{'Change Decision of %s%s%s'} = '';
    $Self->{Translation}->{'Change ITSM fields of %s%s%s'} = '';

    # Perl Module: var/packagesetup/ITSMIncidentProblemManagement.pm
    $Self->{Translation}->{'Review Required'} = 'ต้องการการวิว';
    $Self->{Translation}->{'Decision Result'} = 'ผลของการตัดสินใจ';
    $Self->{Translation}->{'Approved'} = 'อนุมัติแล้ว';
    $Self->{Translation}->{'Postponed'} = '';
    $Self->{Translation}->{'Pre-approved'} = '';
    $Self->{Translation}->{'Rejected'} = '';
    $Self->{Translation}->{'Repair Start Time'} = 'การซ่อมแซมเวลาเริ่มต้น';
    $Self->{Translation}->{'Recovery Start Time'} = 'การกู้คืนเวลาเริ่มต้น';
    $Self->{Translation}->{'Decision Date'} = 'วันที่การตัดสินใจ';
    $Self->{Translation}->{'Due Date'} = 'วันที่กำหนด';

    # Database XML Definition: ITSMIncidentProblemManagement.sopm
    $Self->{Translation}->{'closed with workaround'} = 'ปิดด้วยวิธีแก้ปัญหา';

    # SysConfig
    $Self->{Translation}->{'Add a decision!'} = 'เพิ่มการตัดสินใจ!';
    $Self->{Translation}->{'Additional ITSM Fields'} = 'ฟิลด์เพิ่มเติมของ ITSM ';
    $Self->{Translation}->{'Additional ITSM ticket fields.'} = '';
    $Self->{Translation}->{'Allows adding notes in the additional ITSM field screen of the agent interface.'} =
        'อนุญาติให้เพิ่มโน้ตในหน้าจอฟิลด์เพิ่มเติมของ ITSM ในอินเตอร์เฟซของเอเย่นต์';
    $Self->{Translation}->{'Allows adding notes in the decision screen of the agent interface.'} =
        'อนุญาติให้เพิ่มโน้ตในหน้าจอการตัดสินใจในอินเตอร์เฟซของเอเย่นต์';
    $Self->{Translation}->{'Allows defining new types for ticket (if ticket type feature is enabled).'} =
        'อนุญาตให้กำหนดประเภทใหม่สำหรับตั๋ว (ถ้าคุณลักษณะประเภทตั๋วถูกเปิดใช้งาน)';
    $Self->{Translation}->{'Change the ITSM fields!'} = 'เปลี่ยนฟิลด์ITSM';
    $Self->{Translation}->{'Decision'} = 'การตัดสินใจ';
    $Self->{Translation}->{'Defines if a ticket lock is required in the additional ITSM field screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        'กำหนดค่าถ้าหากจำเป็นต้องใช้ตั๋วล็อคในหน้าจอฟิลด์เพิ่มเติมของ ITSM ในอินเตอร์เฟซของเอเย่นต์ (ทำการล็อคตั๋วถ้าตั๋วหากยังไม่ได้ล็อคและเซตให้เอเย่นต์ปัจจุบันเป็นเจ้าของอัตโนมัติ)';
    $Self->{Translation}->{'Defines if a ticket lock is required in the decision screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        'กำหนดค่าถ้าหากจำเป็นต้องใช้ตั๋วล็อคในหน้าจอการตัดสินใจ ในอินเตอร์เฟซของเอเย่นต์ (ทำการล็อคตั๋วถ้าตั๋วหากยังไม่ได้ล็อคและเซตให้เอเย่นต์ปัจจุบันเป็นเจ้าของอัตโนมัติ)';
    $Self->{Translation}->{'Defines if the service incident state should be shown during service selection in the agent interface.'} =
        'กำหนดถ้าหากสถานภาพเหตการณ์บริการควรแสดงในระหว่างการเลือกการบริการในอินเตอร์เฟซของเอเย่นต์';
    $Self->{Translation}->{'Defines the default body of a note in the additional ITSM field screen of the agent interface.'} =
        'กำหนดค่าเริ่มต้นของเนื้อเรื่องของโน้ตในหน้าจอฟิลด์เพิ่มเติมของ ITSMในอินเตอร์เฟซของเอเย่นต์';
    $Self->{Translation}->{'Defines the default body of a note in the decision screen of the agent interface.'} =
        'กำหนดค่าเริ่มต้นของเนื้อเรื่องของโน้ตในหน้าจอการตัดสินใจในอินเตอร์เฟซของเอเย่นต์';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the additional ITSM field screen of the agent interface.'} =
        'กำหนดค่าเริ่มต้นของสถานภาพถัดไปของตั๋วหลังจากเพิ่มโน้ตในหน้าจอฟิลด์เพิ่มเติมของ ITSMในอินเตอร์เฟซของเอเย่นต์';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the decision screen of the agent interface.'} =
        'กำหนดค่าเริ่มต้นของสถานภาพถัดไปของตั๋วหลังจากเพิ่มโน้ตในหน้าจอการตัดสินใจในอินเตอร์เฟซของเอเย่นต์';
    $Self->{Translation}->{'Defines the default subject of a note in the additional ITSM field screen of the agent interface.'} =
        'กำหนดหัวข้อเริ่มต้นของโน้ตในหน้าจอฟิลด์เพิ่มเติมของ ITSMในอินเตอร์เฟซของเอเย่นต์';
    $Self->{Translation}->{'Defines the default subject of a note in the decision screen of the agent interface.'} =
        'กำหนดหัวข้อเริ่มต้นของโน้ตในหน้าจอการตัดสินใจในอินเตอร์เฟซของเอเย่นต์';
    $Self->{Translation}->{'Defines the default ticket priority in the additional ITSM field screen of the agent interface.'} =
        'กำหนดลำดับความสำคัญเริ่มต้นของตั๋วในหน้าจอฟิลด์เพิ่มเติมของ ITSMในอินเตอร์เฟซของเอเย่นต์';
    $Self->{Translation}->{'Defines the default ticket priority in the decision screen of the agent interface.'} =
        'กำหนดลำดับความสำคัญเริ่มต้นของตั๋วในหน้าจอการตัดสินใจในอินเตอร์เฟซของเอเย่นต์';
    $Self->{Translation}->{'Defines the history comment for the additional ITSM field screen action, which gets used for ticket history.'} =
        'กำหนดประวัติการแสดงความเห็นสำหรับการกระทำในหน้าจอฟิลด์เพิ่มเติมของ ITSM ซึ่งทำให้เกิดความคุ้นเคยในประวัติของตั๋ว';
    $Self->{Translation}->{'Defines the history comment for the decision screen action, which gets used for ticket history.'} =
        'กำหนดประวัติการแสดงความเห็นสำหรับการกระทำในหน้าจอการตัดสินใจ ซึ่งทำให้เกิดความคุ้นเคยในประวัติของตั๋ว';
    $Self->{Translation}->{'Defines the history type for the additional ITSM field screen action, which gets used for ticket history.'} =
        'กำหนดประเภทประวัติสำหรับการกระทำในหน้าจอฟิลด์เพิ่มเติมของ ITSM ซึ่งทำให้เกิดความคุ้นเคยในประวัติของตั๋ว';
    $Self->{Translation}->{'Defines the history type for the decision screen action, which gets used for ticket history.'} =
        'กำหนดประเภทประวัติสำหรับการกระทำในหน้าจอการตัดสินใจ ซึ่งทำให้เกิดความคุ้นเคยในประวัติของตั๋ว';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the additional ITSM field screen of the agent interface.'} =
        'กำหนดค่าเริ่มต้นของสถานภาพถัดไปของตั๋วหลังจากเพิ่มโน้ตในหน้าจอฟิลด์เพิ่มเติมของ ITSMในอินเตอร์เฟซของเอเย่นต์';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the decision screen of the agent interface.'} =
        'กำหนดค่าเริ่มต้นของสถานภาพถัดไปของตั๋วหลังจากเพิ่มโน้ตในหน้าจอการตัดสินใจในอินเตอร์เฟซของเอเย่นต์';
    $Self->{Translation}->{'Dynamic fields shown in the additional ITSM field screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the decision screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the ticket zoom screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Enables the stats module to generate statistics about the average of ITSM ticket first level solution rate.'} =
        'เปิดใช้งานสถานภาพของโมดูลเพื่อสร้างสถิติเกี่ยวกับค่าเฉลี่ยการแก้ปัญหาขั้นแรกของตั๋ว ITSM ';
    $Self->{Translation}->{'Enables the stats module to generate statistics about the average of ITSM ticket solution.'} =
        'เปิดใช้งานสถานภาพของโมดูลเพื่อสร้างสถิติเกี่ยวกับค่าเฉลี่ยของการแก้ปัญหาตั๋ว ITSM ';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of a ticket in the additional ITSM field screen of the agent interface.'} =
        'เซตสถานภาพของตั๋วในหน้าจอฟิลด์เพิ่มเติมของ ITSMในอินเตอร์เฟซของเอเย่นต์หากเอเย่นต์ได้เพิ่มโน้ต';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of a ticket in the decision screen of the agent interface.'} =
        'เซตสถานภาพของตั๋วในหน้าจอการตัดสินใจนอินเตอร์เฟซของเอเย่นต์หากเอเย่นต์ได้เพิ่มโน้ต';
    $Self->{Translation}->{'Modifies the display order of the dynamic field ITSMImpact and other things.'} =
        '';
    $Self->{Translation}->{'Module to dynamically show the service incident state and to calculate the priority.'} =
        '';
    $Self->{Translation}->{'Required permissions to use the additional ITSM field screen in the agent interface.'} =
        'จำเป็นต้องมีการอนญาติการใช้งานในหน้าจอฟิลด์เพิ่มเติมของ ITSM ในอินเตอร์เฟซของเอเย่นต์';
    $Self->{Translation}->{'Required permissions to use the decision screen in the agent interface.'} =
        'จำเป็นต้องมีการอนญาติการใช้งานในหน้าจอการตัดสินใจ ในอินเตอร์เฟซของเอเย่นต์';
    $Self->{Translation}->{'Service Incident State and Priority Calculation'} = '';
    $Self->{Translation}->{'Sets the service in the additional ITSM field screen of the agent interface (Ticket::Service needs to be activated).'} =
        'เซตการบริการในหน้าจอฟิลด์เพิ่มเติมของ ITSMในอินเตอร์เฟซของเอเย่นต์(ตั๋ว::ต้องมีการเปิดใช้งานการบริการ)';
    $Self->{Translation}->{'Sets the service in the decision screen of the agent interface (Ticket::Service needs to be activated).'} =
        'เซตการบริการในหน้าจอการตัดสินใจในอินเตอร์เฟซของเอเย่นต์(ตั๋ว::ต้องมีการเปิดใช้งานการบริการ)';
    $Self->{Translation}->{'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).'} =
        '';
    $Self->{Translation}->{'Sets the ticket owner in the additional ITSM field screen of the agent interface.'} =
        'เซตเจ้าของตั๋วในหน้าจอฟิลด์เพิ่มเติมของ ITSMในอินเตอร์เฟซของเอเย่นต์';
    $Self->{Translation}->{'Sets the ticket owner in the decision screen of the agent interface.'} =
        'เซตเจ้าของตั๋วในหน้าจอการตัดสินใจในอินเตอร์เฟซของเอเย่นต์';
    $Self->{Translation}->{'Sets the ticket responsible in the additional ITSM field screen of the agent interface.'} =
        'เซตความรับผิดชอบของตั๋วในหน้าจอฟิลด์เพิ่มเติมของ ITSMในอินเตอร์เฟซของเอเย่นต์';
    $Self->{Translation}->{'Sets the ticket responsible in the decision screen of the agent interface.'} =
        'เซตความรับผิดชอบของตั๋วในหน้าจอการตัดสินใจในอินเตอร์เฟซของเอเย่นต์';
    $Self->{Translation}->{'Sets the ticket type in the additional ITSM field screen of the agent interface (Ticket::Type needs to be activated).'} =
        'เซตประเภทของตั๋วในหน้าจอฟิลด์เพิ่มเติมของ ITSMในอินเตอร์เฟซของเอเย่นต์(ตั๋ว::ต้องมีการเปิดใช้งานการบริการ)';
    $Self->{Translation}->{'Sets the ticket type in the decision screen of the agent interface (Ticket::Type needs to be activated).'} =
        'เซตประเภทของตั๋วในหน้าจอการตัดสินใจในอินเตอร์เฟซของเอเย่นต์(ตั๋ว::ต้องมีการเปิดใช้งานการบริการ)';
    $Self->{Translation}->{'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to change the decision of a ticket in its zoom view of the agent interface.'} =
        'แสดงลิงค์ในเมนูเพื่อเปลี่ยนแปลงการตัดสินใจของตั๋วในมุมมองการซูมของอินเตอร์เฟซเอเย่นต์';
    $Self->{Translation}->{'Shows a link in the menu to modify additional ITSM fields in the ticket zoom view of the agent interface.'} =
        'แสดงลิงค์ในเมนูเพือแก้ไขฟิลด์เพิ่มเติมของ ITSM ในมุมมองการซูมของอินเตอร์เฟซเอเย่นต์';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the additional ITSM field screen of the agent interface.'} =
        'แสดงรายชื่อเอเย่นต์ที่เกี่ยวข้องกับตั๋วนี้ในหน้าจอฟิลด์เพิ่มเติมของ ITSMในอินเตอร์เฟซของเอเย่นต์';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the decision screen of the agent interface.'} =
        'แสดงรายชื่อเอเย่นต์ที่เกี่ยวข้องกับตั๋วนี้ในหน้าจอการตัดสินใจในอินเตอร์เฟซของเอเย่นต์';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the additional ITSM field screen of the agent interface.'} =
        'แสดงรายชื่อเอเย่นต์ทั้งหมดที่เป็นไปได้ (เอเย่นต์ทั้งหมดที่ได้รับโน้ตอนุญาติในคิว/ตั๋ว) เพื่อกำหนดว่าใครควรรายงานเกี่ยวกับโน้ตนี้ในในหน้าจอฟิลด์เพิ่มเติมของ ITSMในอินเตอร์เฟซของเอเย่นต์ ';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the decision screen of the agent interface.'} =
        'แสดงรายชื่อเอเย่นต์ทั้งหมดที่เป็นไปได้ (เอเย่นต์ทั้งหมดที่ได้รับโน้ตอนุญาติในคิว/ตั๋ว) เพื่อกำหนดว่าใครควรรายงานเกี่ยวกับโน้ตนี้ในในหน้าจอการตัดสินใจในอินเตอร์เฟซของเอเย่นต์';
    $Self->{Translation}->{'Shows the ticket priority options in the additional ITSM field screen of the agent interface.'} =
        'แสดงตัวเลือกของลำดับความสำคัญของตั๋วในหน้าจอฟิลด์เพิ่มเติมของ ITSMในอินเตอร์เฟซของเอเย่นต์';
    $Self->{Translation}->{'Shows the ticket priority options in the decision screen of the agent interface.'} =
        'แสดงตัวเลือกของลำดับความสำคัญของตั๋วในหน้าจอการตัดสินใจในอินเตอร์เฟซของเอเย่นต์';
    $Self->{Translation}->{'Shows the title fields in the additional ITSM field screen of the agent interface.'} =
        'แสดงหัวข้อฟิลด์ในหน้าจอฟิลด์เพิ่มเติมของ ITSMในอินเตอร์เฟซของเอเย่นต์';
    $Self->{Translation}->{'Shows the title fields in the decision screen of the agent interface.'} =
        'แสดงหัวข้อฟิลด์ในหน้าจอการตัดสิดใจในอินเตอร์เฟซของเอเย่นต์';
    $Self->{Translation}->{'Ticket decision.'} = '';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Service Incident State',
    );

}

1;
