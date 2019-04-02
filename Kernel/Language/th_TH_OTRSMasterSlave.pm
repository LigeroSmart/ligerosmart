# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::th_TH_OTRSMasterSlave;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminDynamicFieldMasterSlave
    $Self->{Translation}->{'Field'} = 'ฟิลด์';

    # Template: AgentTicketMasterSlave
    $Self->{Translation}->{'Manage Master/Slave status for %s%s%s'} = '';

    # Perl Module: Kernel/Modules/AgentTicketMasterSlave.pm
    $Self->{Translation}->{'New Master Ticket'} = 'ตั๋วมาสเตอร์ใหม่';
    $Self->{Translation}->{'Unset Master Ticket'} = 'ยกเลิกการตั้งค่าตั๋วมาสเตอร์';
    $Self->{Translation}->{'Unset Slave Ticket'} = 'ยกเลิกการตั้งค่าตั๋วSlave';
    $Self->{Translation}->{'Slave of %s%s%s: %s'} = '';

    # Perl Module: Kernel/Output/HTML/TicketBulk/MasterSlave.pm
    $Self->{Translation}->{'Unset Master Tickets'} = '';
    $Self->{Translation}->{'Unset Slave Tickets'} = '';

    # Perl Module: Kernel/System/DynamicField/Driver/MasterSlave.pm
    $Self->{Translation}->{'Master'} = 'มาสเตอร์';
    $Self->{Translation}->{'Slave of %s%s%s'} = '';
    $Self->{Translation}->{'Master Ticket'} = '';

    # SysConfig
    $Self->{Translation}->{'All master tickets'} = '';
    $Self->{Translation}->{'All slave tickets'} = '';
    $Self->{Translation}->{'Allows adding notes in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'อนุญาตให้เพิ่มโน้ตในหน้าจอตั๋วMasterSlave ของตั๋วซูมในอินเตอร์เฟซเอเย่นต์ ';
    $Self->{Translation}->{'Change the MasterSlave state of the ticket.'} = 'เปลี่ยนสถานภาพของตั๋ว MasterSlave ';
    $Self->{Translation}->{'Defines dynamic field name for master ticket feature.'} = '';
    $Self->{Translation}->{'Defines if a ticket lock is required in the ticket MasterSlave screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        'กำหนดค่าถ้าหากจำเป็นต้องใช้ตั๋วล็อคในหน้าจอตั๋วMasterSlaveของตั๋วซูมในอินเตอร์เฟซของเอเย่นต์ (ทำการล็อคตั๋วถ้าหากตั๋วยังไม่ได้ล็อคและระบุให้เอเย่นต์ปัจจุบันเป็นเจ้าของอัตโนมัติ)';
    $Self->{Translation}->{'Defines if the MasterSlave note is visible for the customer by default.'} =
        '';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'กำหนดค่าเริ่มต้นของสถานภาพถัดไปของตั๋วหลังจากเพิ่มโน้ตในหน้าจอตั๋วMasterSlave ของตั๋วซูมในอินเตอร์เฟซเอเย่นต์ ';
    $Self->{Translation}->{'Defines the default ticket priority in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'กำหนดลำดับความสำคัญเริ่มต้นของตั๋วในหน้าจอตั๋วMasterSlave ของตั๋วซูมในอินเตอร์เฟซเอเย่นต์';
    $Self->{Translation}->{'Defines the history comment for the ticket MasterSlave screen action, which gets used for ticket history in the agent interface.'} =
        'กำหนดประวัติการแสดงความเห็นสำหรับการกระทำหน้าจอตั๋วMasterSlave ของตั๋วซูม ซึ่งทำให้เกิดความคุ้นเคยในประวัติของตั๋วในอินเตอร์เฟซเอเย่นต์';
    $Self->{Translation}->{'Defines the history type for the ticket MasterSlave screen action, which gets used for ticket history in the agent interface.'} =
        'กำหนดประเภทประวัติสำหรับการกระทำสำหรับการกระทำหน้าจอตั๋วMasterSlave ของตั๋วซูม ซึ่งทำให้เกิดความคุ้นเคยในประวัติของตั๋วในอินเตอร์เฟซเอเย่นต์';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'กำหนดสถานภาพถัดไปของตั๋วหลังจากเพิ่มโน้ตในหน้าจอตั๋วMasterSlave ของตั๋วซูมในอินเตอร์เฟซเอเย่นต์';
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
        'เซตสถานภาพของตั๋วในหน้าจอตั๋ว MasterSlave ของตั๋วซูมในอินเตอร์เฟซของเอเย่นต์หากเอเย่นต์ได้เพิ่มโน้ต';
    $Self->{Translation}->{'Master / Slave'} = 'มาสเตอร์/Slave';
    $Self->{Translation}->{'Master Tickets'} = '';
    $Self->{Translation}->{'MasterSlave'} = '';
    $Self->{Translation}->{'MasterSlave module for Ticket Bulk feature.'} = 'โมดูล มาสเตอร์/Slave สำหรับคุณลักษณะกลุ่มตั๋ว';
    $Self->{Translation}->{'Parameters for the dashboard backend of the master tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.'} =
        'พารามิเตอร์สำหรับแดชบอร์ดเบื้องหลังของภาพรวมตั๋วmaster ของอินเตอร์เฟสเอเย่นต์ "จำกัด" คือกำหนดจำนวนของรายการที่แสดงโดยค่าเริ่มต้น "กลุ่ม" จะถูกนำมาใช้เพื่อจำกัดการเข้าถึงปลั๊กอิน (เช่นกลุ่ม: ผู้ดูแลระบบ; กลุ่ม 1; กลุ่ม2;) "เริ่มต้น" ระบุว่าถ้าปลั๊กอินถูกเปิดใช้งานโดยค่าเริ่มต้นหรือหากผู้ใช้ต้องการเพื่อเปิดใช้งานได้ด้วยตนเอง';
    $Self->{Translation}->{'Parameters for the dashboard backend of the slave tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.'} =
        'พารามิเตอร์สำหรับแดชบอร์ดเบื้องหลังของภาพรวมตั๋วslave tของอินเตอร์เฟสเอเย่นต์ "จำกัด" คือกำหนดจำนวนของรายการที่แสดงโดยค่าเริ่มต้น "กลุ่ม" จะถูกนำมาใช้เพื่อจำกัดการเข้าถึงปลั๊กอิน (เช่นกลุ่ม: ผู้ดูแลระบบ; กลุ่ม 1; กลุ่ม2;) "เริ่มต้น" ระบุว่าถ้าปลั๊กอินถูกเปิดใช้งานโดยค่าเริ่มต้นหรือหากผู้ใช้ต้องการเพื่อเปิดใช้งานได้ด้วยตนเอง';
    $Self->{Translation}->{'Registration of the ticket event module.'} = 'ารลงทะเบียนของโมดูลตั๋วกิจกรรม';
    $Self->{Translation}->{'Required permissions to use the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'จำเป็นต้องมีการอนุญาติในการใช้งานในหน้าจอตั๋ว MasterSlave ในตั๋วซูมในอินเตอร์เฟซของเอเย่นต์';
    $Self->{Translation}->{'Sets if Master / Slave field must be selected by the agent.'} = '';
    $Self->{Translation}->{'Sets the default body text for notes added in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'ระบุข้อความส่วนเนื้อหาเริ่มต้นสำหรับโน้ตที่ถูกเพิ่มเข้ามาในหน้าจอตั๋ว MasterSlave ของตั๋วซูมในอินเตอร์เฟซเอเย่นต์';
    $Self->{Translation}->{'Sets the default subject for notes added in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'ระบุหัวข้อเริ่มต้นสำหรับโน้ตที่ถูกเพิ่มเข้ามาในหน้าจอตั๋ว MasterSlave ของตั๋วซูมในอินเตอร์เฟซเอเย่นต์';
    $Self->{Translation}->{'Sets the responsible agent of the ticket in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'กำหนดเอเย่นต์ที่รับผิดชอบตั๋วในหน้าจอตั๋ว MasterSlave ของตั๋วซูมในอินเตอร์เฟซเอเย่นต์';
    $Self->{Translation}->{'Sets the service in the ticket MasterSlave screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).'} =
        'กำหนดการบริการในหน้าจอตั๋ว MasterSlave ของตั๋วซูมในอินเตอร์เฟซเอเย่นต์ (ตั๋ว ::การบริการจำเป็นต้องมีการเปิดใช้งาน)';
    $Self->{Translation}->{'Sets the ticket owner in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'กำหนดเจ้าของตั๋วในหน้าจอตั๋ว MasterSlave ของตั๋วซูมในอินเตอร์เฟซเอเย่นต์';
    $Self->{Translation}->{'Sets the ticket type in the ticket MasterSlave screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).'} =
        'กำหนดประเภทของตั๋วในหน้าจอตั๋ว MasterSlave ของตั๋วซูมในอินเตอร์เฟซเอเย่นต์ (ตั๋ว ::ประเภทตั๋วจำเป็นต้องมีการเปิดใช้งาน)';
    $Self->{Translation}->{'Shows a link in the menu to change the MasterSlave status of a ticket in the ticket zoom view of the agent interface.'} =
        'แสดงลิงค์ในเมนูเพื่อเปลี่ยนสถานภาพของตั๋ว MasterSlave ในการซูมตั๋วของอินเตอร์เฟซเอเย่นต์';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'แสดงรายชื่อของเอเย่นต์ที่เกี่ยวข้องกับตั๋วนี้ในหน้าจอตั๋ว MasterSlave ของตั๋วซูมในอินเตอร์เฟซเอเย่นต์';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'แสดงรายชื่อเอเย่นต์ที่เป็นไปได้ทั้งหมด (เอเย่นต์ทั้งหมดที่ได้รับโน้ตอนุญาติในคิว/ตั๋ว) เพื่อกำหนดว่าใครควรรายงานเกี่ยวกับโน้ตนี้ในในหน้าจอตั๋วMasterSlave ของตั๋วซูมในอินเตอร์เฟซของเอเย่นต์';
    $Self->{Translation}->{'Shows the ticket priority options in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'แสดงตัวเลือกลำดับความสำคัญของตั๋วในหน้าจอตั๋ว MasterSlave ของตั๋วซูมในอินเตอร์เฟซเอเย่นต์';
    $Self->{Translation}->{'Shows the title field in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '';
    $Self->{Translation}->{'Slave Tickets'} = '';
    $Self->{Translation}->{'Specifies the different article communication channels where the real name from Master ticket will be replaced with the one in the Slave ticket.'} =
        '';
    $Self->{Translation}->{'This module activates Master/Slave field in new email and phone ticket screens.'} =
        'โมดูลนี้เปิดใช้งานฟิลด์ Master /Slave ในหน้าจออีเมลใหม่และตั๋วโทรศัพท์';
    $Self->{Translation}->{'This setting is deprecated and will be removed in further versions of OTRSMasterSlave.'} =
        '';
    $Self->{Translation}->{'Ticket MasterSlave.'} = '';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
