# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::th_TH_ITSMCore;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminITSMCIPAllocate
    $Self->{Translation}->{'Criticality ↔ Impact ↔ Priority'} = 'วิกฤต↔ ผลกระทบ ↔ เรียงลำดับความสำคัญ';
    $Self->{Translation}->{'Manage the priority result of combinating Criticality ↔ Impact.'} =
        'การจัดการจัดลำดับความสำคัญของผลการผสมผสานวิกฤต↔ ผลกระทบ';
    $Self->{Translation}->{'Priority allocation'} = 'การจัดสรรลำดับความสำคัญ';

    # Template: AdminSLA
    $Self->{Translation}->{'Minimum Time Between Incidents'} = 'เวลาขั้นต่ำระหว่างเหตุการณ์ที่เกิดขึ้น';

    # Template: AdminService
    $Self->{Translation}->{'Criticality'} = 'วิกฤต';

    # Template: AgentITSMSLAZoom
    $Self->{Translation}->{'SLA Information'} = 'ข้อมูล SLA';
    $Self->{Translation}->{'Last changed'} = 'การเปลี่ยนแปลงล่าสุด';
    $Self->{Translation}->{'Last changed by'} = 'การเปลี่ยนแปลงล่าสุดโดย';
    $Self->{Translation}->{'Associated Services'} = 'การบริการที่เกี่ยวข้อง';

    # Template: AgentITSMServiceZoom
    $Self->{Translation}->{'Service Information'} = 'ข้อมูลการบริการ';
    $Self->{Translation}->{'Current incident state'} = 'สถานภาพของเหต์การณ์ปัจจุบัน';
    $Self->{Translation}->{'Associated SLAs'} = 'SLAsที่เกี่ยวข้อง';

    # Perl Module: Kernel/Modules/AdminITSMCIPAllocate.pm
    $Self->{Translation}->{'Impact'} = 'ผลกระทบ';

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
    $Self->{Translation}->{'Current Incident State'} = 'สถานภาพของเหต์การณ์ปัจจุบัน';

    # Perl Module: Kernel/Output/HTML/LinkObject/Service.pm
    $Self->{Translation}->{'Incident State'} = 'สถานภาพของเหต์การณ์';

    # Database XML Definition: ITSMCore.sopm
    $Self->{Translation}->{'Operational'} = 'การดำเนินงาน';
    $Self->{Translation}->{'Incident'} = 'เหตุการณ์';
    $Self->{Translation}->{'End User Service'} = 'ผู้ใช้บริการขั้นสุดท้าย';
    $Self->{Translation}->{'Front End'} = 'Front End';
    $Self->{Translation}->{'Back End'} = 'Back End';
    $Self->{Translation}->{'IT Management'} = 'การจัดการไอที';
    $Self->{Translation}->{'Reporting'} = 'กำลังรายงาน';
    $Self->{Translation}->{'IT Operational'} = 'การดำเนินงานไอที';
    $Self->{Translation}->{'Demonstration'} = 'การอธิบาย';
    $Self->{Translation}->{'Project'} = 'โปรเจค';
    $Self->{Translation}->{'Underpinning Contract'} = 'สัญญาการหนุน';
    $Self->{Translation}->{'Other'} = 'อื่นๆ';
    $Self->{Translation}->{'Availability'} = 'ความพร้อมใช้งาน';
    $Self->{Translation}->{'Response Time'} = 'ระยะเวลาการตอบสนอง';
    $Self->{Translation}->{'Recovery Time'} = 'เวลาการกู้คืน';
    $Self->{Translation}->{'Resolution Rate'} = 'อัตราการแก้ปัญหา';
    $Self->{Translation}->{'Transactions'} = 'การทำรายการ';
    $Self->{Translation}->{'Errors'} = 'ข้อผิดพลาด';

    # SysConfig
    $Self->{Translation}->{'Alternative to'} = 'เลือกที่';
    $Self->{Translation}->{'Both'} = 'ทั้งหมด';
    $Self->{Translation}->{'Connected to'} = 'เชื่อมโยงไปยัง';
    $Self->{Translation}->{'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js and Core.Agent.LinkObject.js.'} =
        '';
    $Self->{Translation}->{'Define which columns are shown in the linked Services widget (LinkObject::ViewMode = "complex"). Note: Only Service attributes are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.'} =
        '';
    $Self->{Translation}->{'Depends on'} = 'ขึ้นอยู่ ';
    $Self->{Translation}->{'Frontend module registration for the AdminITSMCIPAllocate configuration in the admin area.'} =
        'การลงทะเบียนโมดูล Frontend สำหรับการกำหนดค่าของ AdminITSMCIPAllocate ในพื้นที่ของแอดมิน';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLA object in the agent interface.'} =
        'การลงทะเบียนโมดูล Frontend สำหรับออบเจกต์ของAgentITSMSLA  ในอินเตอร์เฟซของเอเย่นต์';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLAPrint object in the agent interface.'} =
        'การลงทะเบียนโมดูล Frontend สำหรับออบเจกต์ของAgentITSMSLAPrint ในอินเตอร์เฟซของเอเย่นต์';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLAZoom object in the agent interface.'} =
        'การลงทะเบียนโมดูล Frontend สำหรับออบเจกต์ของAgentITSMSLAZoom  ในอินเตอร์เฟซของเอเย่นต์';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMService object in the agent interface.'} =
        'การลงทะเบียนโมดูล Frontend สำหรับออบเจกต์ของAgentITSMService ในอินเตอร์เฟซของเอเย่นต์';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMServicePrint object in the agent interface.'} =
        'การลงทะเบียนโมดูล Frontend สำหรับออบเจกต์ของAgentITSMServicePrint ในอินเตอร์เฟซของเอเย่นต์';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMServiceZoom object in the agent interface.'} =
        'การลงทะเบียนโมดูล Frontend สำหรับออบเจกต์ของAgentITSMServiceZoom ในอินเตอร์เฟซของเอเย่นต์';
    $Self->{Translation}->{'ITSM SLA Overview.'} = '';
    $Self->{Translation}->{'ITSM Service Overview.'} = '';
    $Self->{Translation}->{'Incident State Type'} = '';
    $Self->{Translation}->{'Includes'} = 'รวมถึง';
    $Self->{Translation}->{'Manage priority matrix.'} = 'การจัดการลำดับความสำคัญของเมทริกซ์';
    $Self->{Translation}->{'Manage the criticality - impact - priority matrix.'} = '';
    $Self->{Translation}->{'Module to show the Back menu item in SLA menu.'} = 'โมดูลที่จะแสดงลิงค์การกลับในเมนู SLA';
    $Self->{Translation}->{'Module to show the Back menu item in service menu.'} = 'โมดูลที่จะแสดงลิงค์การกลับในเมนูการบริการ';
    $Self->{Translation}->{'Module to show the Link menu item in service menu.'} = 'โมดูลที่จะแสดงลิงค์ที่เชื่อมต่อในเมนูการบริการ';
    $Self->{Translation}->{'Module to show the Print menu item in SLA menu.'} = 'โมดูลที่จะแสดงลิงค์การพิมพ์ในเมนูSLA';
    $Self->{Translation}->{'Module to show the Print menu item in service menu.'} = 'โมดูลที่จะแสดงลิงค์การพิมพ์ในเมนูการบริการ';
    $Self->{Translation}->{'Parameters for the incident states in the preference view.'} = 'พารามิเตอร์สำหรับสถานภาพของเหตการณ์ในมุมมองการตั้งค่า';
    $Self->{Translation}->{'Part of'} = 'ส่วนหนึ่งของ';
    $Self->{Translation}->{'Relevant to'} = 'เกี่ยวข้องกับ';
    $Self->{Translation}->{'Required for'} = 'จำเป็นสำหรับ';
    $Self->{Translation}->{'SLA Overview'} = 'ภาพรวมของSLA ';
    $Self->{Translation}->{'SLA Print.'} = '';
    $Self->{Translation}->{'SLA Zoom.'} = '';
    $Self->{Translation}->{'Service Overview'} = 'ภาพรวมของการบริการ';
    $Self->{Translation}->{'Service Print.'} = '';
    $Self->{Translation}->{'Service Zoom.'} = '';
    $Self->{Translation}->{'Service-Area'} = 'พื้นที่การให้บริการ';
    $Self->{Translation}->{'Set the type and direction of links to be used to calculate the incident state. The key is the name of the link type (as defined in LinkObject::Type), and the value is the direction of the IncidentLinkType that should be followed to calculate the incident state. For example if the IncidentLinkType is set to \'DependsOn\', and the Direction is \'Source\', only \'Depends on\' links will be followed (and not the opposite link \'Required for\') to calculate the incident state. You can add more link types ad directions as you like, e.g. \'Includes\' with the direction \'Target\'. All link types defined in the sysconfig options LinkObject::Type are possible and the direction can be \'Source\', \'Target\', or \'Both\'. IMPORTANT: AFTER YOU MAKE CHANGES TO THIS SYSCONFIG OPTION YOU NEED TO RUN THE CONSOLE COMMAND bin/otrs.Console.pl Admin::ITSM::IncidentState::Recalculate SO THAT ALL INCIDENT STATES WILL BE RECALCULATED BASED ON THE NEW SETTINGS!'} =
        '';
    $Self->{Translation}->{'Source'} = '';
    $Self->{Translation}->{'This setting defines that a \'ITSMChange\' object can be linked with \'Ticket\' objects using the \'Normal\' link type.'} =
        'การตั้งค่านี้กำหนดว่าออบเจกค์\'ITSMChange\' สามารถลิงค์กับออบเจกค์ \'ตั๋ว\' อื่น โดยการใช้ลิงค์ \'Normal\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'Normal\' link type.'} =
        'การตั้งค่านี้กำหนดว่าออบเจกค์ \'ITSMConfigItem\' สามารถลิงค์กับออบเจกค์ \'FAQ\' โดยการใช้ลิงค์ \'Normal\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'ParentChild\' link type.'} =
        'การตั้งค่านี้กำหนดว่าออบเจกค์ \'ITSMConfigItem\' สามารถลิงค์กับออบเจกค์ \'FAQ\' โดยการใช้ลิงค์ \'ParentChild\' ';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'RelevantTo\' link type.'} =
        'การตั้งค่านี้กำหนดว่าออบเจกค์ \'ITSMConfigItem\' สามารถลิงค์กับออบเจกค์ \'FAQ\' โดยการใช้ลิงค์ \'RelevantTo\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'AlternativeTo\' link type.'} =
        'การตั้งค่านี้กำหนดว่าออบเจกค์ \'ITSMConfigItem\' สามารถลิงค์กับออบเจกค์ \'การบริการ\' โดยการใช้ลิงค์ \'AlternativeTo\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'DependsOn\' link type.'} =
        'การตั้งค่านี้กำหนดว่าออบเจกค์ \'ITSMConfigItem\' สามารถลิงค์กับออบเจกค์ \'การบริการ\' โดยการใช้ลิงค์ \'DependsOn\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'RelevantTo\' link type.'} =
        'การตั้งค่านี้กำหนดว่าออบเจกค์ \'ITSMConfigItem\' สามารถลิงค์กับออบเจกค์ \'การบริการ\'  โดยการใช้ลิงค์ \'RelevantTo\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'AlternativeTo\' link type.'} =
        'การตั้งค่านี้กำหนดว่าออบเจกค์ \'ITSMConfigItem\' สามารถลิงค์กับออบเจกค์ \'ตั๋ว\' โดยการใช้ลิงค์ \'AlternativeTo\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'DependsOn\' link type.'} =
        'การตั้งค่านี้กำหนดว่าออบเจกค์ \'ITSMConfigItem\' สามารถลิงค์กับออบเจกค์ \'ตั๋ว\' โดยการใช้ลิงค์ \'DependsOn\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'RelevantTo\' link type.'} =
        'การตั้งค่านี้กำหนดว่าออบเจกค์ \'ITSMConfigItem\' สามารถลิงค์กับออบเจกค์ \'ตั๋ว\' โดยการใช้ลิงค์ \'RelevantTo\' ';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'AlternativeTo\' link type.'} =
        'การตั้งค่านี้กำหนดว่าออบเจกค์ \'ITSMConfigItem\' สามารถลิงค์กับออบเจกค์ \'ITSMConfigItem\' อื่นๆโดยการใช้ลิงค์ \'AlternativeTo\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'ConnectedTo\' link type.'} =
        'การตั้งค่านี้กำหนดว่าออบเจกค์ \'ITSMConfigItem\' สามารถลิงค์กับออบเจกค์ \'ITSMConfigItem\' อื่นๆโดยการใช้ลิงค์ \'ConnectedTo\' ';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'DependsOn\' link type.'} =
        'การตั้งค่านี้กำหนดว่าออบเจกค์ \'ITSMConfigItem\' สามารถลิงค์กับออบเจกค์ \'ITSMConfigItem\' อื่นๆโดยการใช้ลิงค์ \'DependsOn\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'Includes\' link type.'} =
        'การตั้งค่านี้กำหนดว่าออบเจกค์ \'ITSMConfigItem\' สามารถลิงค์กับออบเจกค์ \'ITSMConfigItem\' อื่นๆโดยการใช้ลิงค์ \'Includes\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'RelevantTo\' link type.'} =
        'การตั้งค่านี้กำหนดว่าออบเจกค์ \'ITSMConfigItem\' สามารถลิงค์กับออบเจกค์ \'ITSMConfigItem\' อื่นๆโดยการใช้ลิงค์ \'RelevantTo\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'ITSMConfigItem\' objects using the \'DependsOn\' link type.'} =
        'การตั้งค่านี้กำหนดว่าออบเจกค์ \'ITSMWorkOrder\' สามารถลิงค์กับออบเจกค์ \'ITSMConfigItem\' โดยการใช้ลิงค์ \'DependsOn\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'ITSMConfigItem\' objects using the \'Normal\' link type.'} =
        'การตั้งค่านี้กำหนดว่าออบเจกค์ \'ITSMWorkOrder\' สามารถลิงค์กับออบเจกค์ \'ITSMConfigItem\' โดยการใช้ลิงค์ \'Normal\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Service\' objects using the \'DependsOn\' link type.'} =
        'การตั้งค่านี้กำหนดว่าออบเจกค์ \'ITSMWorkOrder\' สามารถลิงค์กับออบเจกค์ \'การบริการ\' โดยการใช้ลิงค์ \'DependsOn\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Service\' objects using the \'Normal\' link type.'} =
        'การตั้งค่านี้กำหนดว่าออบเจกค์ \'ITSMWorkOrder\' สามารถลิงค์กับออบเจกค์ \'การบริการ\' โดยการใช้ลิงค์ \'Normal\'';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Ticket\' objects using the \'Normal\' link type.'} =
        'การตั้งค่านี้กำหนดว่าออบเจกค์ \'ITSMWorkOrder\' สามารถลิงค์กับออบเจกค์ \'ตั๋ว\' โดยการใช้ลิงค์ \'Normal\'';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'Normal\' link type.'} =
        'การตั้งค่านี้กำหนดว่าออบเจกค์ \'การบริการ\' สามารถลิงค์กับออบเจกค์ \'FAQ\' โดยการใช้ลิงค์ \'Normal\'';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'ParentChild\' link type.'} =
        'การตั้งค่านี้กำหนดว่าออบเจกค์ \'การบริการ\' สามารถลิงค์กับออบเจกค์ \'FAQ\' โดยการใช้ลิงค์ \'ParentChild\'';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'RelevantTo\' link type.'} =
        'การตั้งค่านี้กำหนดว่าออบเจกค์ \'การบริการ\' สามารถลิงค์กับออบเจกค์ \'FAQ\' โดยการใช้ลิงค์\'RelevantTo\'';
    $Self->{Translation}->{'This setting defines the link type \'AlternativeTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'การตั้งค่านี้กำหนดประเภทลิงค์ \'AlternativeTo\' ถ้าชื่อแหล่งที่มาและชื่อเป้าหมายมีค่าเดียวกัน
ลิงค์ที่ส่งผลให้คือไม่มีทิศทาง แต่ถ้าหากมีค่าต่างกัน ลิงค์ที่เกิดคือการเชื่อมโยงทิศทาง';
    $Self->{Translation}->{'This setting defines the link type \'ConnectedTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'การตั้งค่านี้กำหนดประเภทลิงค์ \'ConnectedTo\' ถ้าชื่อแหล่งที่มาและชื่อเป้าหมายมีค่าเดียวกัน ลิงค์ที่ส่งผลให้คือไม่มีทิศทาง แต่ถ้าหากมีค่าต่างกัน ลิงค์ที่เกิดคือการเชื่อมโยงทิศทาง';
    $Self->{Translation}->{'This setting defines the link type \'DependsOn\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'การตั้งค่านี้กำหนดประเภทลิงค์ \'DependsOn\' ถ้าชื่อแหล่งที่มาและชื่อเป้าหมายมีค่าเดียวกัน ลิงค์ที่ส่งผลให้คือไม่มีทิศทาง แต่ถ้าหากมีค่าต่างกัน ลิงค์ที่เกิดคือการเชื่อมโยงทิศทาง';
    $Self->{Translation}->{'This setting defines the link type \'Includes\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'การตั้งค่านี้กำหนดประเภทลิงค์  \'Includes\' ถ้าชื่อแหล่งที่มาและชื่อเป้าหมายมีค่าเดียวกัน ลิงค์ที่ส่งผลให้คือไม่มีทิศทาง แต่ถ้าหากมีค่าต่างกัน ลิงค์ที่เกิดคือการเชื่อมโยงทิศทาง';
    $Self->{Translation}->{'This setting defines the link type \'RelevantTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'การตั้งค่านี้กำหนดประเภทลิงค์ \'RelevantTo\' ถ้าชื่อแหล่งที่มาและชื่อเป้าหมายมีค่าเดียวกัน ลิงค์ที่ส่งผลให้คือไม่มีทิศทาง แต่ถ้าหากมีค่าต่างกัน ลิงค์ที่เกิดคือการเชื่อมโยงทิศทาง';
    $Self->{Translation}->{'Width of ITSM textareas.'} = 'ความกว้างของพื้นที่ข้อความของ ITSM';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
