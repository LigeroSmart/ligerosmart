# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::th_TH_ITSMChangeManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminITSMChangeCIPAllocate
    $Self->{Translation}->{'Category ↔ Impact ↔ Priority'} = 'หมวดหมู่↔ ผลกระทบ ↔ ลำดับความสำคัญ';
    $Self->{Translation}->{'Manage the priority result of combinating Category ↔ Impact.'} =
        'การจัดการลำดับความสำคัญของผลการผสมผสานวิกฤต↔ ผลกระทบ';
    $Self->{Translation}->{'Priority allocation'} = 'การจัดสรรลำดับความสำคัญ';

    # Template: AdminITSMChangeNotification
    $Self->{Translation}->{'ITSM ChangeManagement Notification Management'} = 'การจัดการการแจ้งเตือน ITSM ChangeManagement';
    $Self->{Translation}->{'Add Notification Rule'} = 'เพิ่มการแจ้งเตือนบทบาทหน้าที่';
    $Self->{Translation}->{'Edit Notification Rule'} = '';
    $Self->{Translation}->{'A notification should have a name!'} = 'การแจ้งเตือนต้องมีชื่อ!';
    $Self->{Translation}->{'Name is required.'} = 'ต้องระบุชื่อ!';

    # Template: AdminITSMStateMachine
    $Self->{Translation}->{'Admin State Machine'} = 'ผู้ดูแลสถานะกลไก';
    $Self->{Translation}->{'Select a catalog class!'} = 'เลือกคลาสแคตตาล็อก';
    $Self->{Translation}->{'A catalog class is required!'} = 'ต้องระบุคลาสหมวดหมู่';
    $Self->{Translation}->{'Add a state transition'} = 'เพิ่มสถานภาพการเปลี่ยนแปลง';
    $Self->{Translation}->{'Catalog Class'} = 'ห้องแค็ตตาล็อก';
    $Self->{Translation}->{'Object Name'} = 'ชื่อออบเจกต์';
    $Self->{Translation}->{'Overview over state transitions for'} = 'ภาพรวมของสถานภาพการเปลี่ยนแปลงสำหรับ';
    $Self->{Translation}->{'Delete this state transition'} = 'ลบสถานภาพการเปลี่ยนแปลงนี้';
    $Self->{Translation}->{'Add a new state transition for'} = 'เพิ่มสถานภาพการเปลี่ยนแปลงสำหรับ';
    $Self->{Translation}->{'Please select a state!'} = 'กรุณาเลือกสถานภาพ';
    $Self->{Translation}->{'Please select a next state!'} = 'กรุณาเลือกสถานภาพถัดไป';
    $Self->{Translation}->{'Edit a state transition for'} = 'แก้ไขสถานภาพการเปลี่ยนแปลงสำหรับ';
    $Self->{Translation}->{'Do you really want to delete the state transition'} = 'คุณแน่ใจหรือไม่ว่าต้องการลบการเปลี่ยนสถานภาพนี้';

    # Template: AgentITSMChangeAdd
    $Self->{Translation}->{'Add Change'} = 'เพิ่มChange ';
    $Self->{Translation}->{'ITSM Change'} = 'ITSM Change ';
    $Self->{Translation}->{'Justification'} = 'แสดงเหตุผล';
    $Self->{Translation}->{'Input invalid.'} = 'input ไม่ถูกต้อง';
    $Self->{Translation}->{'Impact'} = 'ผลกระทบ';
    $Self->{Translation}->{'Requested Date'} = 'เวลาที่ร้องขอ';

    # Template: AgentITSMChangeAddFromTemplate
    $Self->{Translation}->{'Select Change Template'} = 'เลือกแม่แบบการเปลี่ยนแปลง';
    $Self->{Translation}->{'Time type'} = 'ประเภทเวลา';
    $Self->{Translation}->{'Invalid time type.'} = 'ประเภทเวลาไม่ถูกต้อง';
    $Self->{Translation}->{'New time'} = 'เวลาใหม่';

    # Template: AgentITSMChangeCABTemplate
    $Self->{Translation}->{'Save Change CAB as template'} = 'บันทึกChange CAB เป็นแม่แบบ';
    $Self->{Translation}->{'go to involved persons screen'} = 'ไปที่สกรีนของบุคคลที่เกี่ยวข้อง';
    $Self->{Translation}->{'Invalid Name'} = 'ชื่อไม่ถูกต้อง';

    # Template: AgentITSMChangeCondition
    $Self->{Translation}->{'Conditions and Actions'} = 'เงื่อนไขและการทำงาน';
    $Self->{Translation}->{'Delete Condition'} = 'ลบเงื่อนไข';
    $Self->{Translation}->{'Add new condition'} = 'เพิ่มเงื่อนไขใหม่';

    # Template: AgentITSMChangeConditionEdit
    $Self->{Translation}->{'Edit Condition'} = '';
    $Self->{Translation}->{'Need a valid name.'} = 'ต้องการชื่อที่ถูกต้อง';
    $Self->{Translation}->{'A valid name is needed.'} = '';
    $Self->{Translation}->{'Duplicate name:'} = 'ชื่อซ้ำ';
    $Self->{Translation}->{'This name is already used by another condition.'} = 'ชื่อนี้ได้ถูกใช้งานโดยเงื่อนไขอื่น';
    $Self->{Translation}->{'Matching'} = 'ตรงกัน';
    $Self->{Translation}->{'Any expression (OR)'} = 'การแสดงผลใดๆ (OR)';
    $Self->{Translation}->{'All expressions (AND)'} = 'การแสดงผลทั้งหมด (AND)';
    $Self->{Translation}->{'Expressions'} = 'การแสดงผล';
    $Self->{Translation}->{'Selector'} = 'ผู้เลือก';
    $Self->{Translation}->{'Operator'} = 'ผู้ดำเนินการ';
    $Self->{Translation}->{'Delete Expression'} = 'ลบการแสดงผล';
    $Self->{Translation}->{'No Expressions found.'} = 'ไม่พบการแสดงผล';
    $Self->{Translation}->{'Add new expression'} = 'เพิ่มการแสดงผล';
    $Self->{Translation}->{'Delete Action'} = 'ลบการทำงาน';
    $Self->{Translation}->{'No Actions found.'} = 'ไม่พบการทำงาน';
    $Self->{Translation}->{'Add new action'} = 'เพิ่มการทำงานใหม่';

    # Template: AgentITSMChangeDelete
    $Self->{Translation}->{'Do you really want to delete this change?'} = 'คุณต้องการลบChange นี้หรือไม่?';

    # Template: AgentITSMChangeEdit
    $Self->{Translation}->{'Edit %s%s'} = '';

    # Template: AgentITSMChangeHistory
    $Self->{Translation}->{'History of %s%s'} = 'ประวัติของ %s%s';
    $Self->{Translation}->{'History Content'} = 'เนื้อหาประวัติ';
    $Self->{Translation}->{'Workorder'} = 'ใบสั่งงาน';
    $Self->{Translation}->{'Createtime'} = 'เวลาที่สร้าง';
    $Self->{Translation}->{'Show details'} = 'แสดงเนื้อหา';
    $Self->{Translation}->{'Show workorder'} = 'แสดงใบสั่งงาน';

    # Template: AgentITSMChangeHistoryZoom
    $Self->{Translation}->{'Detailed history information of %s'} = '';
    $Self->{Translation}->{'Modified'} = 'การปรับเปลี่ยน';
    $Self->{Translation}->{'Old Value'} = 'ค่าเดิม';
    $Self->{Translation}->{'New Value'} = 'ค่าใหม่';

    # Template: AgentITSMChangeInvolvedPersons
    $Self->{Translation}->{'Edit Involved Persons of %s%s'} = '';
    $Self->{Translation}->{'Involved Persons'} = 'บุคคลที่เกี่ยวข้อง';
    $Self->{Translation}->{'ChangeManager'} = 'ผู้จัดการของChange ';
    $Self->{Translation}->{'User invalid.'} = 'ผู้ใช้ไม่ถูกต้อง';
    $Self->{Translation}->{'ChangeBuilder'} = 'ผู้สร้างChange ';
    $Self->{Translation}->{'Change Advisory Board'} = 'คณะกรรมการที่ปรึกษา Change';
    $Self->{Translation}->{'CAB Template'} = 'แม่แบบ CAB';
    $Self->{Translation}->{'Apply Template'} = 'ใช้แม่แบบ';
    $Self->{Translation}->{'NewTemplate'} = 'แม่แบบใหม่';
    $Self->{Translation}->{'Save this CAB as template'} = 'บันทึก CAB นี้เป็นแม่แบบ';
    $Self->{Translation}->{'Add to CAB'} = 'เพิ่มไปยัง CAB';
    $Self->{Translation}->{'Invalid User'} = 'ผู้ใช้ไม่ถูกต้อง';
    $Self->{Translation}->{'Current CAB'} = 'CAB ปัจจุบัน';

    # Template: AgentITSMChangeOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = 'การตั้งค่าข้อความ';
    $Self->{Translation}->{'Changes per page'} = 'Changes ในแต่ละหน้า';

    # Template: AgentITSMChangeOverviewSmall
    $Self->{Translation}->{'Workorder Title'} = '';
    $Self->{Translation}->{'Change Title'} = '';
    $Self->{Translation}->{'Workorder Agent'} = '';
    $Self->{Translation}->{'Change Builder'} = 'ผู้สร้าง Change';
    $Self->{Translation}->{'Change Manager'} = 'ผู้จัดการ ';
    $Self->{Translation}->{'Workorders'} = 'ใบสั่งงาน';
    $Self->{Translation}->{'Change State'} = '';
    $Self->{Translation}->{'Workorder State'} = '';
    $Self->{Translation}->{'Workorder Type'} = '';
    $Self->{Translation}->{'Requested Time'} = 'เวลาที่ร้องขอ';
    $Self->{Translation}->{'Planned Start Time'} = '';
    $Self->{Translation}->{'Planned End Time'} = '';
    $Self->{Translation}->{'Actual Start Time'} = '';
    $Self->{Translation}->{'Actual End Time'} = '';

    # Template: AgentITSMChangeReset
    $Self->{Translation}->{'Do you really want to reset this change?'} = 'คุณต้องการรีเซตการเปลี่ยนแปลงนี้หรือไม่?';

    # Template: AgentITSMChangeSearch
    $Self->{Translation}->{'(e.g. 10*5155 or 105658*)'} = '(เช่น 10*5155 หรือ 105658*)';
    $Self->{Translation}->{'CAB Agent'} = '';
    $Self->{Translation}->{'e.g.'} = 'เช่น';
    $Self->{Translation}->{'CAB Customer'} = '';
    $Self->{Translation}->{'ITSM Workorder Instruction'} = '';
    $Self->{Translation}->{'ITSM Workorder Report'} = '';
    $Self->{Translation}->{'ITSM Change Priority'} = '';
    $Self->{Translation}->{'ITSM Change Impact'} = '';
    $Self->{Translation}->{'Change Category'} = 'หมวดหมู่ของChange ';
    $Self->{Translation}->{'(before/after)'} = '(ก่อน/หลัง)';
    $Self->{Translation}->{'(between)'} = '(ระหว่าง)';

    # Template: AgentITSMChangeTemplate
    $Self->{Translation}->{'Save Change as Template'} = 'บันทึกChange เป็นแม่แบบ';
    $Self->{Translation}->{'A template should have a name!'} = 'ควรระบุชื่อแม่แบบ!';
    $Self->{Translation}->{'The template name is required.'} = 'ต้องระบุชื่อของแม่แบบ!';
    $Self->{Translation}->{'Reset States'} = 'รีเซตสถานภาพ';
    $Self->{Translation}->{'Overwrite original template'} = 'เขียนทับแม่แบบเดิม';
    $Self->{Translation}->{'Delete original change'} = 'ลบChange เดิม';

    # Template: AgentITSMChangeTimeSlot
    $Self->{Translation}->{'Move Time Slot'} = 'ย้าย Time Slot';

    # Template: AgentITSMChangeZoom
    $Self->{Translation}->{'Change Information'} = 'ข้อมูลของChange ';
    $Self->{Translation}->{'Planned Effort'} = '';
    $Self->{Translation}->{'Accounted Time'} = '';
    $Self->{Translation}->{'Change Initiator(s)'} = 'ผู้ริเริ่ม(s) Change';
    $Self->{Translation}->{'CAB'} = 'CAB';
    $Self->{Translation}->{'Last changed'} = 'การเปลี่ยนแปลงล่าสุด';
    $Self->{Translation}->{'Last changed by'} = 'การเปลี่ยนแปลงล่าสุดโดย';
    $Self->{Translation}->{'To open links in the following description blocks, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).'} =
        'ในการเปิดการลิ้งในบล็อกคำอธิบายต่อไปนี้ คุณอาจจะต้องกดปุ่ม Ctrl หรือ Cmd หรือ Shift ในขณะที่กดลิ้ง (ขึ้นอยุ่กับเบราเซอร์และระบบปฎิบัติการของคุณ)';
    $Self->{Translation}->{'Download Attachment'} = 'ดาวน์โหลดสิ่งที่แนบมา';

    # Template: AgentITSMTemplateEditCAB
    $Self->{Translation}->{'Edit CAB Template'} = 'แก้ไขแม่แบบ CAB';

    # Template: AgentITSMTemplateEditContent
    $Self->{Translation}->{'This will create a new change from this template, so you can edit and save it.'} =
        'นี่จะสร้างChange ใหม่จากแม่แบบนี้ ดังนั้นคุณจึงสามารถแก้ไขและบันทึกไว้';
    $Self->{Translation}->{'The new change will be deleted automatically after it has been saved as template.'} =
        'Change ใหม่จะถูกลบโดยอัตโนมัติหลังจากที่มันได้รับการบันทึกเป็นแม่แบบ';
    $Self->{Translation}->{'This will create a new workorder from this template, so you can edit and save it.'} =
        'นี่จะสร้างใบสั่งงานใหม่จากแม่แบบนี้ ดังนั้นคุณจึงสามารถแก้ไขและบันทึกไว้';
    $Self->{Translation}->{'A temporary change will be created which contains the workorder.'} =
        'Change ชั่วคราวจะถูกสร้างขึ้นซึ่งประกอบด้วยใบสั่งงาน';
    $Self->{Translation}->{'The temporary change and new workorder will be deleted automatically after the workorder has been saved as template.'} =
        'Change ชั่วคราวและใบสั่งงานใหม่จะถูกลบโดยอัตโนมัติหลังจากที่มันได้รับการบันทึกเป็นแม่แบบ';
    $Self->{Translation}->{'Do you want to proceed?'} = 'คุณต้องการดำเนินการต่อไปหรือไม่?';

    # Template: AgentITSMTemplateOverviewSmall
    $Self->{Translation}->{'Template ID'} = '';
    $Self->{Translation}->{'Edit Content'} = 'แก้ไข้เนื้อหา';
    $Self->{Translation}->{'Create by'} = '';
    $Self->{Translation}->{'Change by'} = '';
    $Self->{Translation}->{'Change Time'} = '';

    # Template: AgentITSMWorkOrderAdd
    $Self->{Translation}->{'Add Workorder to %s%s'} = '';
    $Self->{Translation}->{'Instruction'} = 'การสร้าง';
    $Self->{Translation}->{'Invalid workorder type.'} = 'ประเภทใบสั่งงานไม่ถูกต้อง';
    $Self->{Translation}->{'The planned start time must be before the planned end time!'} = 'เวลาเริ่มต้นที่วางแผนจะต้องเริ่มก่อนเวลาสิ้นสุดที่วางแผนไว้!';
    $Self->{Translation}->{'Invalid format.'} = 'รูปแบบไม่ถูกต้อง';

    # Template: AgentITSMWorkOrderAddFromTemplate
    $Self->{Translation}->{'Select Workorder Template'} = 'เลือกแม่แบบใบสั่งงาน';

    # Template: AgentITSMWorkOrderAgent
    $Self->{Translation}->{'Edit Workorder Agent of %s%s'} = '';

    # Template: AgentITSMWorkOrderDelete
    $Self->{Translation}->{'Do you really want to delete this workorder?'} = 'คุณแน่ใจหรือไม่ที่จะลบใบสั่งงานนี้?';
    $Self->{Translation}->{'You can not delete this Workorder. It is used in at least one Condition!'} =
        'คุณไม่สามรถลบใบสั่งงานนี้ เนื่องจากได้ใช้งานอย่างน้อยหนึ่งเงื่อนไข!';
    $Self->{Translation}->{'This Workorder is used in the following Condition(s)'} = 'ใบสั่งงานนี้จะใช้ในเงื่อนไขดังต่อไปนี้ (s)';

    # Template: AgentITSMWorkOrderEdit
    $Self->{Translation}->{'Edit %s%s-%s'} = '';
    $Self->{Translation}->{'Move following workorders accordingly'} = 'ย้าย workorders ต่อไปนี้ตามลำดับ';
    $Self->{Translation}->{'If the planned end time of this workorder is changed, the planned start times of all following workorders will be changed accordingly'} =
        'หากเวลาสิ้นสุดที่วางแผนไว้ของ workorder นี้มีการเปลี่ยนแปลง ดังนั้นเวลาเริ่มต้นที่วางแผนไว้ ของ workorders ต่อไปนี้จะมีการเปลี่ยนแปลงตามความเหมาะสม';

    # Template: AgentITSMWorkOrderHistory
    $Self->{Translation}->{'History of %s%s-%s'} = '';

    # Template: AgentITSMWorkOrderReport
    $Self->{Translation}->{'Edit Report of %s%s-%s'} = '';
    $Self->{Translation}->{'Report'} = 'รายงาน';
    $Self->{Translation}->{'The actual start time must be before the actual end time!'} = 'เวลาเริ่มต้นที่เกิดขึ้นจริงจะต้องเริ่มก่อนเวลาสิ้นสุดที่เกิดขึ้นจริง!';
    $Self->{Translation}->{'The actual start time must be set, when the actual end time is set!'} =
        'เวลาเริ่มต้นที่เกิดขึ้นจริงจะต้องตั้งค่าเมื่อเวลาสิ้นสุดที่เกิดขึ้นจริงมีการตั้งค่า!';

    # Template: AgentITSMWorkOrderTake
    $Self->{Translation}->{'Current Agent'} = 'เอเย่นต์ปัจจุบัน';
    $Self->{Translation}->{'Do you really want to take this workorder?'} = 'คุณแน่ใจหรือไม่ที่จะลบใบสั่งงานนี้?';

    # Template: AgentITSMWorkOrderTemplate
    $Self->{Translation}->{'Save Workorder as Template'} = 'บันทึกใบสั่งงานเป็นแม่แบบ';
    $Self->{Translation}->{'Delete original workorder (and surrounding change)'} = 'ลบworkorder เดิม(และการเปลี่ยนแปลงใกล้เคียง)';

    # Template: AgentITSMWorkOrderZoom
    $Self->{Translation}->{'Workorder Information'} = 'ข้อมูลของใบสั่งงาน';

    # Perl Module: Kernel/Modules/AdminITSMChangeNotification.pm
    $Self->{Translation}->{'Notification Added!'} = '';
    $Self->{Translation}->{'Unknown notification %s!'} = '';
    $Self->{Translation}->{'There was an error creating the notification.'} = '';

    # Perl Module: Kernel/Modules/AdminITSMStateMachine.pm
    $Self->{Translation}->{'State Transition Updated!'} = '';
    $Self->{Translation}->{'State Transition Added!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChange.pm
    $Self->{Translation}->{'Overview: ITSM Changes'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeAdd.pm
    $Self->{Translation}->{'Ticket with TicketID %s does not exist!'} = '';
    $Self->{Translation}->{'Missing sysconfig option "ITSMChange::AddChangeLinkTicketTypes"!'} =
        '';
    $Self->{Translation}->{'Was not able to add change!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeAddFromTemplate.pm
    $Self->{Translation}->{'Was not able to create change from template!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeCABTemplate.pm
    $Self->{Translation}->{'No ChangeID is given!'} = '';
    $Self->{Translation}->{'No change found for changeID %s.'} = '';
    $Self->{Translation}->{'The CAB of change "%s" could not be serialized.'} = '';
    $Self->{Translation}->{'Could not add the template.'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeCondition.pm
    $Self->{Translation}->{'Change "%s" not found in database!'} = '';
    $Self->{Translation}->{'Could not delete ConditionID %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeConditionEdit.pm
    $Self->{Translation}->{'No %s is given!'} = '';
    $Self->{Translation}->{'Could not create new condition!'} = '';
    $Self->{Translation}->{'Could not update ConditionID %s!'} = '';
    $Self->{Translation}->{'Could not update ExpressionID %s!'} = '';
    $Self->{Translation}->{'Could not add new Expression!'} = '';
    $Self->{Translation}->{'Could not update ActionID %s!'} = '';
    $Self->{Translation}->{'Could not add new Action!'} = '';
    $Self->{Translation}->{'Could not delete ExpressionID %s!'} = '';
    $Self->{Translation}->{'Could not delete ActionID %s!'} = '';
    $Self->{Translation}->{'Error: Unknown field type "%s"!'} = '';
    $Self->{Translation}->{'ConditionID %s does not belong to the given ChangeID %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeDelete.pm
    $Self->{Translation}->{'Change "%s" does not have an allowed change state to be deleted!'} =
        '';
    $Self->{Translation}->{'Was not able to delete the changeID %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeEdit.pm
    $Self->{Translation}->{'Was not able to update Change!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeHistory.pm
    $Self->{Translation}->{'Can\'t show history, as no ChangeID is given!'} = '';
    $Self->{Translation}->{'Change "%s" not found in the database!'} = '';
    $Self->{Translation}->{'Unknown type "%s" encountered!'} = '';
    $Self->{Translation}->{'Change History'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeHistoryZoom.pm
    $Self->{Translation}->{'Can\'t show history zoom, no HistoryEntryID is given!'} = '';
    $Self->{Translation}->{'HistoryEntry "%s" not found in database!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeInvolvedPersons.pm
    $Self->{Translation}->{'Was not able to update Change CAB for Change %s!'} = '';
    $Self->{Translation}->{'Was not able to update Change %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeManager.pm
    $Self->{Translation}->{'Overview: ChangeManager'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeMyCAB.pm
    $Self->{Translation}->{'Overview: My CAB'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeMyChanges.pm
    $Self->{Translation}->{'Overview: My Changes'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeMyWorkOrders.pm
    $Self->{Translation}->{'Overview: My Workorders'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangePIR.pm
    $Self->{Translation}->{'Overview: PIR'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangePSA.pm
    $Self->{Translation}->{'Overview: PSA'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangePrint.pm
    $Self->{Translation}->{'WorkOrder "%s" not found in database!'} = '';
    $Self->{Translation}->{'Can\'t create output, as the workorder is not attached to a change!'} =
        '';
    $Self->{Translation}->{'Can\'t create output, as no ChangeID is given!'} = '';
    $Self->{Translation}->{'unknown change title'} = '';
    $Self->{Translation}->{'ITSM Workorder'} = 'ใบสั่งงาน ITSM';
    $Self->{Translation}->{'WorkOrderNumber'} = 'ใบสั่งงานที่';
    $Self->{Translation}->{'WorkOrderTitle'} = 'หัวข้อใบสั่งงาน';
    $Self->{Translation}->{'unknown workorder title'} = '';
    $Self->{Translation}->{'ChangeState'} = 'สถานภาพของChange ';
    $Self->{Translation}->{'PlannedEffort'} = 'ความพยายามที่วางแผนไว้';
    $Self->{Translation}->{'CAB Agents'} = '';
    $Self->{Translation}->{'CAB Customers'} = '';
    $Self->{Translation}->{'RequestedTime'} = 'เวลาที่ร้องขอ';
    $Self->{Translation}->{'PlannedStartTime'} = 'เวลาเริ่มต้นที่วางแผน';
    $Self->{Translation}->{'PlannedEndTime'} = 'เวลาสิ้นสุดที่วางแผน';
    $Self->{Translation}->{'ActualStartTime'} = 'เวลาเริ่มต้นที่เกิดขึ้นจริง';
    $Self->{Translation}->{'ActualEndTime'} = 'เวลาสิ้นสุดที่เกิดขึ้นจริง';
    $Self->{Translation}->{'ChangeTime'} = 'เวลาของการเปลี่ยนแปลง';
    $Self->{Translation}->{'ChangeNumber'} = 'ลำดับของChange';
    $Self->{Translation}->{'WorkOrderState'} = 'สถานภาพของใบสั่งงาน';
    $Self->{Translation}->{'WorkOrderType'} = 'ประเภทใบสั่งงาน';
    $Self->{Translation}->{'WorkOrderAgent'} = 'เอเย่นต์ของใบสั่งงาน';
    $Self->{Translation}->{'ITSM Workorder Overview (%s)'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeReset.pm
    $Self->{Translation}->{'Was not able to reset WorkOrder %s of Change %s!'} = '';
    $Self->{Translation}->{'Was not able to reset Change %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeSchedule.pm
    $Self->{Translation}->{'Overview: Change Schedule'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeSearch.pm
    $Self->{Translation}->{'Change Search'} = '';
    $Self->{Translation}->{'ChangeTitle'} = 'หัวข้อChange ';
    $Self->{Translation}->{'WorkOrders'} = 'ใบสั่งงาน';
    $Self->{Translation}->{'Change Search Result'} = '';
    $Self->{Translation}->{'Change Number'} = '';
    $Self->{Translation}->{'Work Order Title'} = '';
    $Self->{Translation}->{'Change Description'} = '';
    $Self->{Translation}->{'Change Justification'} = '';
    $Self->{Translation}->{'WorkOrder Instruction'} = '';
    $Self->{Translation}->{'WorkOrder Report'} = '';
    $Self->{Translation}->{'Change Priority'} = '';
    $Self->{Translation}->{'Change Impact'} = '';
    $Self->{Translation}->{'Created By'} = '';
    $Self->{Translation}->{'WorkOrder State'} = '';
    $Self->{Translation}->{'WorkOrder Type'} = '';
    $Self->{Translation}->{'WorkOrder Agent'} = '';
    $Self->{Translation}->{'before'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeTemplate.pm
    $Self->{Translation}->{'The change "%s" could not be serialized.'} = '';
    $Self->{Translation}->{'Could not update the template "%s".'} = '';
    $Self->{Translation}->{'Could not delete change "%s".'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeTimeSlot.pm
    $Self->{Translation}->{'The change can\'t be moved, as it has no workorders.'} = '';
    $Self->{Translation}->{'Add a workorder first.'} = '';
    $Self->{Translation}->{'Can\'t move a change which already has started!'} = '';
    $Self->{Translation}->{'Please move the individual workorders instead.'} = '';
    $Self->{Translation}->{'The current %s could not be determined.'} = '';
    $Self->{Translation}->{'The %s of all workorders has to be defined.'} = '';
    $Self->{Translation}->{'Was not able to move time slot for workorder #%s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMTemplateDelete.pm
    $Self->{Translation}->{'You need %s permission!'} = '';
    $Self->{Translation}->{'No TemplateID is given!'} = '';
    $Self->{Translation}->{'Template "%s" not found in database!'} = '';
    $Self->{Translation}->{'Was not able to delete the template %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMTemplateEdit.pm
    $Self->{Translation}->{'Was not able to update Template %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMTemplateEditCAB.pm
    $Self->{Translation}->{'Was not able to update Template "%s"!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMTemplateEditContent.pm
    $Self->{Translation}->{'Was not able to create change!'} = '';
    $Self->{Translation}->{'Was not able to create workorder from template!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMTemplateOverview.pm
    $Self->{Translation}->{'Overview: Template'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderAdd.pm
    $Self->{Translation}->{'You need %s permissions on the change!'} = '';
    $Self->{Translation}->{'Was not able to add workorder!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderAgent.pm
    $Self->{Translation}->{'No WorkOrderID is given!'} = '';
    $Self->{Translation}->{'Was not able to set the workorder agent of the workorder "%s" to empty!'} =
        '';
    $Self->{Translation}->{'Was not able to update the workorder "%s"!'} = '';
    $Self->{Translation}->{'Could not find Change for WorkOrder %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderDelete.pm
    $Self->{Translation}->{'Was not able to delete the workorder %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderEdit.pm
    $Self->{Translation}->{'Was not able to update WorkOrder %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderHistory.pm
    $Self->{Translation}->{'Can\'t show history, as no WorkOrderID is given!'} = '';
    $Self->{Translation}->{'WorkOrder "%s" not found in the database!'} = '';
    $Self->{Translation}->{'WorkOrder History'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderHistoryZoom.pm
    $Self->{Translation}->{'History entry "%s" not found in the database!'} = '';
    $Self->{Translation}->{'WorkOrder History Zoom'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderTake.pm
    $Self->{Translation}->{'Was not able to take the workorder %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderTemplate.pm
    $Self->{Translation}->{'The workorder "%s" could not be serialized.'} = '';

    # Perl Module: Kernel/Output/HTML/Layout/ITSMChange.pm
    $Self->{Translation}->{'Need config option %s!'} = '';
    $Self->{Translation}->{'Config option %s needs to be a HASH ref!'} = '';
    $Self->{Translation}->{'No config option found for the view "%s"!'} = '';
    $Self->{Translation}->{'Title: %s | Type: %s'} = '';

    # Perl Module: Kernel/Output/HTML/ToolBar/MyCAB.pm
    $Self->{Translation}->{'My CABs'} = 'CAB ของฉัน';

    # Perl Module: Kernel/Output/HTML/ToolBar/MyChanges.pm
    $Self->{Translation}->{'My Changes'} = 'changeของฉัน';

    # Perl Module: Kernel/Output/HTML/ToolBar/MyWorkOrders.pm
    $Self->{Translation}->{'My Work Orders'} = '';

    # Perl Module: Kernel/System/ITSMChange/History.pm
    $Self->{Translation}->{'%s: %s'} = '';
    $Self->{Translation}->{'New Action (ID=%s)'} = '';
    $Self->{Translation}->{'Action (ID=%s) deleted'} = '';
    $Self->{Translation}->{'All Actions of Condition (ID=%s) deleted'} = '';
    $Self->{Translation}->{'Action (ID=%s) executed: %s'} = '';
    $Self->{Translation}->{'%s (Action ID=%s): (new=%s, old=%s)'} = '';
    $Self->{Translation}->{'Change (ID=%s) reached actual end time.'} = '';
    $Self->{Translation}->{'Change (ID=%s) reached actual start time.'} = '';
    $Self->{Translation}->{'New Change (ID=%s)'} = '';
    $Self->{Translation}->{'New Attachment: %s'} = '';
    $Self->{Translation}->{'Deleted Attachment %s'} = '';
    $Self->{Translation}->{'CAB Deleted %s'} = '';
    $Self->{Translation}->{'%s: (new=%s, old=%s)'} = '';
    $Self->{Translation}->{'Link to %s (ID=%s) added'} = '';
    $Self->{Translation}->{'Link to %s (ID=%s) deleted'} = '';
    $Self->{Translation}->{'Notification sent to %s (Event: %s)'} = '';
    $Self->{Translation}->{'Change (ID=%s) reached planned end time.'} = '';
    $Self->{Translation}->{'Change (ID=%s) reached planned start time.'} = '';
    $Self->{Translation}->{'Change (ID=%s) reached requested time.'} = '';
    $Self->{Translation}->{'New Condition (ID=%s)'} = '';
    $Self->{Translation}->{'Condition (ID=%s) deleted'} = '';
    $Self->{Translation}->{'All Conditions of Change (ID=%s) deleted'} = '';
    $Self->{Translation}->{'%s (Condition ID=%s): (new=%s, old=%s)'} = '';
    $Self->{Translation}->{'New Expression (ID=%s)'} = '';
    $Self->{Translation}->{'Expression (ID=%s) deleted'} = '';
    $Self->{Translation}->{'All Expressions of Condition (ID=%s) deleted'} = '';
    $Self->{Translation}->{'%s (Expression ID=%s): (new=%s, old=%s)'} = '';
    $Self->{Translation}->{'Workorder (ID=%s) reached actual end time.'} = '';
    $Self->{Translation}->{'Workorder (ID=%s) reached actual start time.'} = '';
    $Self->{Translation}->{'New Workorder (ID=%s)'} = '';
    $Self->{Translation}->{'New Attachment for WorkOrder: %s'} = '';
    $Self->{Translation}->{'(ID=%s) New Attachment for WorkOrder: %s'} = '';
    $Self->{Translation}->{'Deleted Attachment from WorkOrder: %s'} = '';
    $Self->{Translation}->{'(ID=%s) Deleted Attachment from WorkOrder: %s'} = '';
    $Self->{Translation}->{'New Report Attachment for WorkOrder: %s'} = '';
    $Self->{Translation}->{'(ID=%s) New Report Attachment for WorkOrder: %s'} = '';
    $Self->{Translation}->{'Deleted Report Attachment from WorkOrder: %s'} = '';
    $Self->{Translation}->{'(ID=%s) Deleted Report Attachment from WorkOrder: %s'} = '';
    $Self->{Translation}->{'Workorder (ID=%s) deleted'} = '';
    $Self->{Translation}->{'(ID=%s) Link to %s (ID=%s) added'} = '';
    $Self->{Translation}->{'(ID=%s) Link to %s (ID=%s) deleted'} = '';
    $Self->{Translation}->{'(ID=%s) Notification sent to %s (Event: %s)'} = '';
    $Self->{Translation}->{'Workorder (ID=%s) reached planned end time.'} = '';
    $Self->{Translation}->{'Workorder (ID=%s) reached planned start time.'} = '';
    $Self->{Translation}->{'(ID=%s) %s: (new=%s, old=%s)'} = '';

    # Perl Module: Kernel/System/ITSMChange/ITSMCondition/Object/ITSMWorkOrder.pm
    $Self->{Translation}->{'all'} = 'ทั้งหมด';
    $Self->{Translation}->{'any'} = 'ใดๆ';

    # Perl Module: Kernel/System/ITSMChange/Notification.pm
    $Self->{Translation}->{'Previous Change Builder'} = '';
    $Self->{Translation}->{'Previous Change Manager'} = '';
    $Self->{Translation}->{'Workorder Agents'} = '';
    $Self->{Translation}->{'Previous Workorder Agent'} = '';
    $Self->{Translation}->{'Change Initiators'} = '';
    $Self->{Translation}->{'Group ITSMChange'} = '';
    $Self->{Translation}->{'Group ITSMChangeBuilder'} = '';
    $Self->{Translation}->{'Group ITSMChangeManager'} = '';

    # Database XML Definition: ITSMChangeManagement.sopm
    $Self->{Translation}->{'requested'} = 'ร้องขอ';
    $Self->{Translation}->{'pending approval'} = 'การอนุมัติที่ค้างอยู่';
    $Self->{Translation}->{'rejected'} = 'ถูกปฏิเสธ';
    $Self->{Translation}->{'approved'} = 'อนุมัติแล้ว';
    $Self->{Translation}->{'in progress'} = 'อยู่ในข่วงดำเนินการ';
    $Self->{Translation}->{'pending pir'} = 'PIR ที่ค้างอยู่';
    $Self->{Translation}->{'successful'} = 'สำเร็จ';
    $Self->{Translation}->{'failed'} = 'ล้มเหลว';
    $Self->{Translation}->{'canceled'} = 'ยกเลิก';
    $Self->{Translation}->{'retracted'} = 'ถอยกลับ';
    $Self->{Translation}->{'created'} = 'สร้างแล้ว';
    $Self->{Translation}->{'accepted'} = 'ยอมรับแล้ว';
    $Self->{Translation}->{'ready'} = 'เรียบร้อย';
    $Self->{Translation}->{'approval'} = 'การอนุมัติ';
    $Self->{Translation}->{'workorder'} = 'ใบสั่งงาน';
    $Self->{Translation}->{'backout'} = 'backout';
    $Self->{Translation}->{'decision'} = 'การตัดสินใจ';
    $Self->{Translation}->{'pir'} = 'pir';
    $Self->{Translation}->{'ChangeStateID'} = '';
    $Self->{Translation}->{'CategoryID'} = '';
    $Self->{Translation}->{'ImpactID'} = '';
    $Self->{Translation}->{'PriorityID'} = '';
    $Self->{Translation}->{'ChangeManagerID'} = '';
    $Self->{Translation}->{'ChangeBuilderID'} = '';
    $Self->{Translation}->{'WorkOrderStateID'} = '';
    $Self->{Translation}->{'WorkOrderTypeID'} = '';
    $Self->{Translation}->{'WorkOrderAgentID'} = '';
    $Self->{Translation}->{'is'} = 'คือ';
    $Self->{Translation}->{'is not'} = 'คือ ไม่';
    $Self->{Translation}->{'is empty'} = 'คือ ว่างเปล่า';
    $Self->{Translation}->{'is not empty'} = 'คือ ไม่ว่างเปล่า';
    $Self->{Translation}->{'is greater than'} = 'คือ มากกว่า';
    $Self->{Translation}->{'is less than'} = 'คือ น้อยกว่า';
    $Self->{Translation}->{'is before'} = 'คือ ก่อนหน้า';
    $Self->{Translation}->{'is after'} = 'คือ หลังจาก';
    $Self->{Translation}->{'contains'} = 'บรรจุ';
    $Self->{Translation}->{'not contains'} = 'ไม่บรรจุ';
    $Self->{Translation}->{'begins with'} = 'เริ่มต้นด้วย';
    $Self->{Translation}->{'ends with'} = 'ลงท้ายด้วย';
    $Self->{Translation}->{'set'} = 'ตั้งค่า';

    # JS File: ITSM.Agent.ChangeManagement.Condition
    $Self->{Translation}->{'Do you really want to delete this expression?'} = '';
    $Self->{Translation}->{'Do you really want to delete this action?'} = '';
    $Self->{Translation}->{'Do you really want to delete this condition?'} = '';

    # JS File: ITSM.Agent.ChangeManagement.ConfirmDialog
    $Self->{Translation}->{'Ok'} = 'โอเค';

    # SysConfig
    $Self->{Translation}->{'A list of the agents who have permission to take workorders. Key is a login name. Content is 0 or 1.'} =
        'รายชื่อของเอเย่นต์ที่ได้รับอนุญาตให้ใช้ใบสั่งงาน คีย์สำคัญคือชื่อล๊อกอิน เนื้อหาเป็น 0 หรือ 1';
    $Self->{Translation}->{'A list of workorder states, at which the ActualStartTime of a workorder will be set if it was empty at this point.'} =
        'รายการสถานภาพของใบสั่งงานที่ ActualStartTime ของ workorder จะถูกตั้งค่าถ้าหากจุดนี้เป็นที่ว่างเปล่า';
    $Self->{Translation}->{'Actual end time'} = '';
    $Self->{Translation}->{'Actual start time'} = '';
    $Self->{Translation}->{'Add Workorder'} = 'เพิ่มใบสั่งงาน';
    $Self->{Translation}->{'Add Workorder (from Template)'} = '';
    $Self->{Translation}->{'Add a change from template.'} = '';
    $Self->{Translation}->{'Add a change.'} = '';
    $Self->{Translation}->{'Add a workorder (from template) to the change.'} = '';
    $Self->{Translation}->{'Add a workorder to the change.'} = '';
    $Self->{Translation}->{'Add from template'} = 'เพิ่มจากแม่แบบ';
    $Self->{Translation}->{'Admin of the CIP matrix.'} = 'ผู้ดูแลระบบของ CIP matrix.';
    $Self->{Translation}->{'Admin of the state machine.'} = 'ผู้ดูแลของสถานะกลไก';
    $Self->{Translation}->{'Agent interface notification module to see the number of change advisory boards.'} =
        'โมดูลอินเตอร์เฟซการแจ้งเตือนเอเย่นต์ในการดูจำนวนของการเปลี่ยนแปลงของ advisory boards ';
    $Self->{Translation}->{'Agent interface notification module to see the number of changes managed by the user.'} =
        'โมดูลอินเตอร์เฟซการแจ้งเตือนเอเย่นต์ในการดูจำนวนของการเปลี่ยนแปลงการควบคุมโดยลูกค้า';
    $Self->{Translation}->{'Agent interface notification module to see the number of changes.'} =
        'โมดูลอินเตอร์เฟซการแจ้งเตือนตัวของเอเย่นต์ในการดูจำนวนของการเปลี่ยนแปลง';
    $Self->{Translation}->{'Agent interface notification module to see the number of workorders.'} =
        '';
    $Self->{Translation}->{'CAB Member Search'} = '';
    $Self->{Translation}->{'Cache time in minutes for the change management toolbars. Default: 3 hours (180 minutes).'} =
        'เวลา Cache ต่อนาทีสำหรับการจัดการการเปลี่ยนแปลง';
    $Self->{Translation}->{'Cache time in minutes for the change management. Default: 5 days (7200 minutes).'} =
        'แคชเวลาเป็นนาทีสำหรับการจัดการการเปลี่ยนแปลง เริ่มต้น: 5 วัน (7200 นาที)';
    $Self->{Translation}->{'Change CAB Templates'} = '';
    $Self->{Translation}->{'Change History.'} = '';
    $Self->{Translation}->{'Change Involved Persons.'} = '';
    $Self->{Translation}->{'Change Overview "Small" Limit'} = 'ภาพรวมของChange "ขนาดเล็ก"';
    $Self->{Translation}->{'Change Overview.'} = '';
    $Self->{Translation}->{'Change Print.'} = '';
    $Self->{Translation}->{'Change Schedule'} = 'ตารางchange';
    $Self->{Translation}->{'Change Schedule.'} = '';
    $Self->{Translation}->{'Change Settings'} = '';
    $Self->{Translation}->{'Change Zoom'} = '';
    $Self->{Translation}->{'Change Zoom.'} = '';
    $Self->{Translation}->{'Change and Workorder Templates'} = '';
    $Self->{Translation}->{'Change and workorder templates edited by this user.'} = '';
    $Self->{Translation}->{'Change area.'} = '';
    $Self->{Translation}->{'Change involved persons of the change.'} = '';
    $Self->{Translation}->{'Change limit per page for Change Overview "Small".'} = '';
    $Self->{Translation}->{'Change number'} = '';
    $Self->{Translation}->{'Change search backend router of the agent interface.'} = 'เปลี่ยนการค้นหา  backend router ของอินเตอร์เฟซเอเย่นต์';
    $Self->{Translation}->{'Change state'} = '';
    $Self->{Translation}->{'Change time'} = '';
    $Self->{Translation}->{'Change title'} = '';
    $Self->{Translation}->{'Condition Edit'} = 'แก้ไขเงื่อนไข';
    $Self->{Translation}->{'Condition Overview'} = '';
    $Self->{Translation}->{'Configure which screen should be shown after a new workorder has been created.'} =
        '';
    $Self->{Translation}->{'Configures how often the notifications are sent when planned the start time or other time values have been reached/passed.'} =
        'กำหนดค่าการแจ้งเตือนจะถูกส่งบ่อยแค่ใหนเมื่อมีการวางแผนเวลาเริ่มต้นหรือค่าเวลาอื่น ๆ ได้มาถึง /ผ่านไป';
    $Self->{Translation}->{'Create Change'} = 'สร้างChange';
    $Self->{Translation}->{'Create Change (from Template)'} = '';
    $Self->{Translation}->{'Create a change (from template) from this ticket.'} = '';
    $Self->{Translation}->{'Create a change from this ticket.'} = '';
    $Self->{Translation}->{'Create and manage ITSM Change Management notifications.'} = '';
    $Self->{Translation}->{'Create and manage change notifications.'} = '';
    $Self->{Translation}->{'Default type for a workorder. This entry must exist in general catalog class \'ITSM::ChangeManagement::WorkOrder::Type\'.'} =
        'ประเภทเริ่มต้นสำหรับการสั่งงาน รายการป้อนนี้ต้องมีอยู่ในคลาสแคตตาล็อกทั่วไป \'ITSM::ChangeManagement::WorkOrder::Type\'.';
    $Self->{Translation}->{'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js and Core.Agent.LinkObject.js.'} =
        '';
    $Self->{Translation}->{'Define the signals for each workorder state.'} = 'กำหนดสัญญาณสำหรับแต่ละสถานภาพของใบสั่งงาน';
    $Self->{Translation}->{'Define which columns are shown in the linked Changes widget (LinkObject::ViewMode = "complex"). Note: Only Change attributes are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.'} =
        '';
    $Self->{Translation}->{'Define which columns are shown in the linked Workorder widget (LinkObject::ViewMode = "complex"). Note: Only Workorder attributes are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.'} =
        '';
    $Self->{Translation}->{'Defines an overview module to show the small view of a change list.'} =
        'กำหนดโมดูลภาพรวมที่จะแสดงมุมมองเล็กๆของรายการการเปลี่ยนแปลง';
    $Self->{Translation}->{'Defines an overview module to show the small view of a template list.'} =
        'กำหนดโมดูลภาพรวมที่จะแสดงมุมมองเล็ก ๆ ของรายการแม่แบบ';
    $Self->{Translation}->{'Defines if it will be possible to print the accounted time.'} = 'กำหนดค่าถ้าหากเป็นไปได้ในการที่จะพิมพ์ the accounted time';
    $Self->{Translation}->{'Defines if it will be possible to print the planned effort.'} = 'กำหนดค่าถ้าหากเป็นไปไมได้ในการที่จะพิมพ์ the planned effort';
    $Self->{Translation}->{'Defines if reachable (as defined by the state machine) change end states should be allowed if a change is in a locked state.'} =
        'กำหนดหากสามารถเข้าถึง (ตามที่กำหนดโดยเครื่องสถานะ) สถานะการเปลี่ยนแปลงที่สิ้นสุดควรได้รับอนุญาตหากมีการเปลี่ยนแปลงที่อยู่ในสถานะที่ถูกล็อก';
    $Self->{Translation}->{'Defines if reachable (as defined by the state machine) workorder end states should be allowed if a workorder is in a locked state.'} =
        'กำหนดหากสามารถเข้าถึง (ตามที่กำหนดโดยเครื่องสถานะ) สถานะใบสั่งงานที่สิ้นสุดควรได้รับอนุญาตหากมีใบสั่งงานอยู่ในสถานะที่ถูกล็อก';
    $Self->{Translation}->{'Defines if the accounted time should be shown.'} = 'กำหนดถ้าหาก the accounted time จะต้องแสดง';
    $Self->{Translation}->{'Defines if the actual start and end times should be set.'} = 'กำหนดถ้าหาก the actual start time และ the end time จะต้องบันทึก';
    $Self->{Translation}->{'Defines if the change search and the workorder search functions could use the mirror DB.'} =
        'กำหนดหากการค้นหาการเปลี่ยนแปลงและฟังก์ชั่นการค้นหา workorder สามารถใช้ฐานข้อมูลสะท้อนกลับ';
    $Self->{Translation}->{'Defines if the change state can be set in the change edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines if the planned effort should be shown.'} = 'กำหนดค่าถ้าหาก the planned effort จะต้องแสดง';
    $Self->{Translation}->{'Defines if the requested date should be print by customer.'} = 'กำหนดค่าถ้าหากลูกค้าต้องการพิมพ์ the requested date ';
    $Self->{Translation}->{'Defines if the requested date should be searched by customer.'} =
        'กำหนดค่าถ้าหากลูกค้าจะต้องค้นหา the requested date';
    $Self->{Translation}->{'Defines if the requested date should be set by customer.'} = 'กำหนดค่าถ้าหากลูกค้าต้องการเซตวันที่ที่เรียกร้อง';
    $Self->{Translation}->{'Defines if the requested date should be shown by customer.'} = 'กำหนดค่าถ้าหากลูกค้าต้องการแสดงวันที่ที่เรียกร้อง';
    $Self->{Translation}->{'Defines if the workorder state should be shown.'} = 'กำหนดค่าถ้าหากจะต้องแสดงสถานภาพของใบสั่งงาน';
    $Self->{Translation}->{'Defines if the workorder title should be shown.'} = 'กำหนดค่าถ้าหากต้องแสดงหัวข้อใบสั่งงาน';
    $Self->{Translation}->{'Defines shown graph attributes.'} = 'กำหนดค่ากราฟแอตทริบิวต์ที่จะแสดง';
    $Self->{Translation}->{'Defines that only changes containing Workorders linked with services, which the customer user has permission to use will be shown. Any other changes will not be displayed.'} =
        'กำหนดว่ามีการเปลี่ยนแปลงเท่านั้นที่ประกอบด้วยการเชื่อมโยงใบสั่งงานด้วยการบริการที่จะแสดงลูกค้าผู้ใช้มีสิทธิ์ในการใช้ การเปลี่ยนแปลงอื่น ๆ จะไม่สามารถแสดงได้';
    $Self->{Translation}->{'Defines the change states that will be allowed to delete.'} = 'กำหนดสถานะการเปลี่ยนแปลงที่จะได้รับอนุญาตให้ลบ';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the Change PSA overview.'} =
        'กำหนดสถานะการเปลี่ยนแปลงที่จะใช้เป็นตัวกรองในภาพรวม Change PSA ';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the Change Schedule overview.'} =
        'กำหนดสถานะการเปลี่ยนแปลงที่จะใช้เป็นตัวกรองในภาพรวม Change Schedule ';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the MyCAB overview.'} =
        'กำหนดสถานะการเปลี่ยนแปลงที่จะใช้เป็นตัวกรองในภาพรวม MyCAB';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the MyChanges overview.'} =
        'กำหนดสถานะการเปลี่ยนแปลงที่จะใช้เป็นตัวกรองในภาพรวม MyChanges';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the change manager overview.'} =
        'กำหนดสถานะการเปลี่ยนแปลงที่จะใช้เป็นตัวกรองในภาพรวมตัวจัดการการเปลี่ยนแปลง';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the change overview.'} =
        'กำหนดสถานะการเปลี่ยนแปลงที่จะใช้เป็นตัวกรองในภาพรวมการเปลี่ยนแปลง';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the customer change schedule overview.'} =
        'กำหนดสถานะการเปลี่ยนแปลงที่จะใช้เป็นตัวกรองในภาพรวมตารางการเปลี่ยนแปลงลูกค้า';
    $Self->{Translation}->{'Defines the default change title for a dummy change which is needed to edit a workorder template.'} =
        'กำหนดชื่อการเปลี่ยนแปลงเริ่มต้นสำหรับการเปลี่ยนแปลงจำลองซึ่งจำเป็นเพื่อแก้ไขแม่แบบใบสั่งงาน';
    $Self->{Translation}->{'Defines the default sort criteria in the change PSA overview.'} =
        'กำหนดเกณฑ์การจัดเรียงเริ่มต้นในภาพรวมการเปลี่ยนแปลง PSA';
    $Self->{Translation}->{'Defines the default sort criteria in the change manager overview.'} =
        'กำหนดเกณฑ์การจัดเรียงเริ่มต้นในภาพรวมตั๋วจัดการการเปลี่ยนแปลง';
    $Self->{Translation}->{'Defines the default sort criteria in the change overview.'} = 'กำหนดเกณฑ์การจัดเรียงเริ่มต้นในภาพรวมการเปลี่ยนแปลง';
    $Self->{Translation}->{'Defines the default sort criteria in the change schedule overview.'} =
        'กำหนดเกณฑ์การจัดเรียงเริ่มต้นในภาพรวมตารางการเปลี่ยนแปลง';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the MyCAB overview.'} =
        'กำหนดเกณฑ์การจัดเรียงเริ่มต้นของการเปลี่ยนแปลงในภาพรวม MyCAB';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the MyChanges overview.'} =
        'กำหนดเกณฑ์การจัดเรียงเริ่มต้นของการเปลี่ยนแปลงในภาพรวม MyChanges ';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the MyWorkorders overview.'} =
        'กำหนดเกณฑ์การจัดเรียงเริ่มต้นของการเปลี่ยนแปลงในภาพรวม MyWorkorders';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the PIR overview.'} =
        'กำหนดเกณฑ์การจัดเรียงเริ่มต้นของการเปลี่ยนแปลงในภาพรวม PIR';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the customer change schedule overview.'} =
        'กำหนดเกณฑ์การจัดเรียงเริ่มต้นของการเปลี่ยนแปลงในภาพรวมตารางการเปลี่ยนแปลงลูกค้า';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the template overview.'} =
        'กำหนดเกณฑ์การจัดเรียงเริ่มต้นของการเปลี่ยนแปลงในภาพรวมรูปแบบ';
    $Self->{Translation}->{'Defines the default sort order in the MyCAB overview.'} = 'กำหนดเกณฑ์การจัดเรียงเริ่มต้นในภาพรวม MyCAB ';
    $Self->{Translation}->{'Defines the default sort order in the MyChanges overview.'} = 'กำหนดเกณฑ์การจัดเรียงเริ่มต้นในภาพรวม MyChanges ';
    $Self->{Translation}->{'Defines the default sort order in the MyWorkorders overview.'} =
        'กำหนดเกณฑ์การจัดเรียงเริ่มต้นในภาพรวม MyWorkorders';
    $Self->{Translation}->{'Defines the default sort order in the PIR overview.'} = 'กำหนดเกณฑ์การจัดเรียงเริ่มต้นในภาพรวม PIR ';
    $Self->{Translation}->{'Defines the default sort order in the change PSA overview.'} = 'กำหนดเกณฑ์การจัดเรียงเริ่มต้นในภาพรวมการเปลี่ยนแปลง PSA ';
    $Self->{Translation}->{'Defines the default sort order in the change manager overview.'} =
        'กำหนดเกณฑ์การจัดเรียงเริ่มต้นในภาพรวมการเปลี่ยนแปลงตัวการจัดการ';
    $Self->{Translation}->{'Defines the default sort order in the change overview.'} = 'กำหนดเกณฑ์การจัดเรียงเริ่มต้นในภาพรวมการเปลี่ยนแปลง';
    $Self->{Translation}->{'Defines the default sort order in the change schedule overview.'} =
        'กำหนดเกณฑ์การจัดเรียงเริ่มต้นในภาพรวมตารางการเปลี่ยนแปลง';
    $Self->{Translation}->{'Defines the default sort order in the customer change schedule overview.'} =
        'กำหนดเกณฑ์การจัดเรียงเริ่มต้นในภาพรวมตารางการเปลี่ยนแปลงลูกค้า';
    $Self->{Translation}->{'Defines the default sort order in the template overview.'} = 'กำหนดเกณฑ์การจัดเรียงเริ่มต้นในภาพรวมรูปแบบ';
    $Self->{Translation}->{'Defines the default value for the category of a change.'} = 'กำหนดประเภทเริ่มต้นสำหรับประเภทของการเปลี่ยนแปลง';
    $Self->{Translation}->{'Defines the default value for the impact of a change.'} = 'กำหนดประเภทเริ่มต้นสำหรับผลกระทบของการเปลี่ยนแปลง';
    $Self->{Translation}->{'Defines the field type of CompareValue fields for change attributes used in the change condition edit screen of the agent interface. Valid values are Selection, Text and Date. If a type is not defined, the field will not be shown.'} =
        '';
    $Self->{Translation}->{'Defines the field type of CompareValue fields for workorder attributes used in the change condition edit screen of the agent interface. Valid values are Selection, Text and Date. If a type is not defined, the field will not be shown.'} =
        '';
    $Self->{Translation}->{'Defines the object attributes that are selectable for change objects in the change condition edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the object attributes that are selectable for workorder objects in the change condition edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute AccountedTime in the change condition edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ActualEndTime in the change condition edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ActualStartTime in the change condition edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute CategoryID in the change condition edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeBuilderID in the change condition edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeManagerID in the change condition edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeStateID in the change condition edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeTitle in the change condition edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute DynamicField in the change condition edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ImpactID in the change condition edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PlannedEffort in the change condition edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PlannedEndTime in the change condition edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PlannedStartTime in the change condition edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PriorityID in the change condition edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute RequestedTime in the change condition edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderAgentID in the change condition edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderNumber in the change condition edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderStateID in the change condition edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderTitle in the change condition edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderTypeID in the change condition edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the period (in years), in which start and end times can be selected.'} =
        'กำหนดระยะเวลา (ในปีที่ผ่านมา) ซึ่งวันเริ่มต้นและวันสิ้นสุดสามารถเลือกได้';
    $Self->{Translation}->{'Defines the shown attributes of a workorder in the tooltip of the workorder graph in the change zoom. To show workorder dynamic fields in the tooltip, they must be specified like DynamicField_WorkOrderFieldName1, DynamicField_WorkOrderFieldName2, etc.'} =
        'กำหนดคุณลักษณะของใบสั่งงานที่จะแสดงในคำแนะนำของกราฟใบสั่งงานในการซูมการเปลี่ยนแปลง เพื่อแสดงฟิลด์แบบไดนามิกของใบสั่งงานในคำแนะนำที่พวกเขาจะต้องระบุเช่น DynamicField_WorkOrderFieldName1, DynamicField_WorkOrderFieldName2 ฯลฯ';
    $Self->{Translation}->{'Defines the shown columns in the Change PSA overview. This option has no effect on the position of the column.'} =
        'กำหนดคอลัมน์ที่จะแสดงในภาพรวมของภาพรวมการเปลี่ยนแปลง PSA ตัวเลือกนี้จะไม่มีผลต่อตำแหน่งของคอลัมน์';
    $Self->{Translation}->{'Defines the shown columns in the Change Schedule overview. This option has no effect on the position of the column.'} =
        'กำหนดคอลัมน์ที่จะแสดงในภาพรวมตารางเวลาการเปลี่ยนแปลง ตัวเลือกนี้จะไม่มีผลต่อตำแหน่งของคอลัมน์';
    $Self->{Translation}->{'Defines the shown columns in the MyCAB overview. This option has no effect on the position of the column.'} =
        'กำหนดคอลัมน์ที่จะแสดงในภาพรวม MyCAB  ตัวเลือกนี้จะไม่มีผลต่อตำแหน่งของคอลัมน์';
    $Self->{Translation}->{'Defines the shown columns in the MyChanges overview. This option has no effect on the position of the column.'} =
        'กำหนดคอลัมน์ที่จะแสดงในภาพรวม MyChanges  ตัวเลือกนี้จะไม่มีผลต่อตำแหน่งของคอลัมน์';
    $Self->{Translation}->{'Defines the shown columns in the MyWorkorders overview. This option has no effect on the position of the column.'} =
        'กำหนดคอลัมน์ที่จะแสดงในภาพรวม MyWorkorders  ตัวเลือกนี้จะไม่มีผลต่อตำแหน่งของคอลัมน์';
    $Self->{Translation}->{'Defines the shown columns in the PIR overview. This option has no effect on the position of the column.'} =
        'กำหนดคอลัมน์ที่จะแสดงในภาพรวม PIR ตัวเลือกนี้จะไม่มีผลต่อตำแหน่งของคอลัมน์';
    $Self->{Translation}->{'Defines the shown columns in the change manager overview. This option has no effect on the position of the column.'} =
        'กำหนดคอลัมน์ที่จะแสดงในภาพรวมตัวจัดการการเปลี่ยนแปลง ตัวเลือกนี้จะไม่มีผลต่อตำแหน่งของคอลัมน์';
    $Self->{Translation}->{'Defines the shown columns in the change overview. This option has no effect on the position of the column.'} =
        'กำหนดคอลัมน์ที่จะแสดงในภาพรวมการเปลี่ยนแปลง ตัวเลือกนี้จะไม่มีผลต่อตำแหน่งของคอลัมน์';
    $Self->{Translation}->{'Defines the shown columns in the change search. This option has no effect on the position of the column.'} =
        'กำหนดคอลัมน์ที่จะแสดงในค้นหาการเปลี่ยนแปลง ตัวเลือกนี้จะไม่มีผลต่อตำแหน่งของคอลัมน์';
    $Self->{Translation}->{'Defines the shown columns in the customer change schedule overview. This option has no effect on the position of the column.'} =
        'กำหนดคอลัมน์ที่จะแสดงในภาพรวมตารางการเปลี่ยนแปลงลูกค้า ตัวเลือกนี้จะไม่มีผลต่อตำแหน่งของคอลัมน์';
    $Self->{Translation}->{'Defines the shown columns in the template overview. This option has no effect on the position of the column.'} =
        'กำหนดคอลัมน์ที่จะแสดงในภาพรวมรูแปบบ ตัวเลือกนี้จะไม่มีผลต่อตำแหน่งของคอลัมน์';
    $Self->{Translation}->{'Defines the signals for each ITSM change state.'} = '';
    $Self->{Translation}->{'Defines the template types that will be used as filters in the template overview.'} =
        'กำหนดประเภทแม่แบบที่จะนำมาใช้เป็นตัวกรองในภาพรวมแม่แบบ';
    $Self->{Translation}->{'Defines the workorder states that will be used as filters in the MyWorkorders overview.'} =
        'กำหนดสถานะของใบสั่งงานที่จะนำมาใช้เป็นตัวกรองในภาพรวม MyWorkorders';
    $Self->{Translation}->{'Defines the workorder states that will be used as filters in the PIR overview.'} =
        'กำหนดสถานะของใบสั่งงานที่จะนำมาใช้เป็นตัวกรองในภาพรวมPIR';
    $Self->{Translation}->{'Defines the workorder types that will be used to show the PIR overview.'} =
        'กำหนดประเภทของใบสั่งงานที่จะนำมาแสดงในภาพรวมPIR';
    $Self->{Translation}->{'Defines whether notifications should be sent.'} = 'กำหนดว่าการแจ้งเตือนควรถูกส่งออกไปหรือไม่';
    $Self->{Translation}->{'Delete a change.'} = '';
    $Self->{Translation}->{'Delete the change.'} = '';
    $Self->{Translation}->{'Delete the workorder.'} = '';
    $Self->{Translation}->{'Details of a change history entry.'} = '';
    $Self->{Translation}->{'Determines if an agent can exchange the X-axis of a stat if he generates one.'} =
        'กำหนดถ้าหากเอเย่นต์สามารถแลกเปลี่ยนแกน X ของสถิติถ้าเขาสร้างแค่หนึ่ง';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes done for config item classes.'} =
        'กำหนดหากโมดูลสถิติที่พบบ่อยอาจสร้างสถิติเกี่ยวกับการเปลี่ยนแปลงสำหรับคลาสรายการการตั้งค่า';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes regarding change state updates within a timeperiod.'} =
        'กำหนดถ้าหากโมดูลสถิติที่พบบ่อยอาจสร้างสถิติเกี่ยวกับการเปลี่ยนแปลงในการอัพเดตสถานะการเปลี่ยนแปลงภายในระยะเวลาที่กำหนด';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes regarding the relation between changes and incident tickets.'} =
        'กำหนดถ้าหากโมดูลสถิติที่พบบ่อยอาจสร้างสถิติเกี่ยวกับการเปลี่ยนแปลงในความสัมพันธ์ระหว่างการเปลี่ยนแปลงและตั๋วที่เกิดขึ้น';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes.'} =
        'กำหนดหากโมดูลสถิติที่พบบ่อยอาจสร้างสถิติเกี่ยวกับการเปลี่ยนแปลง';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about the number of Rfc tickets a requester created.'} =
        'กำหนดหากโมดูลสถิติที่พบบ่อยอาจสร้างสถิติเกี่ยวกับจำนวนของตั๋ว RFC ผู้ร้องขอที่สร้างขึ้น';
    $Self->{Translation}->{'Dynamic fields (for changes and workorders) shown in the change print screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the change add screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the change edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the change search screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the change zoom screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the workorder add screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the workorder edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the workorder report screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the workorder zoom screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'DynamicField event module to handle the update of conditions if dynamic fields are added, updated or deleted.'} =
        'โมดูลจัดกิจกรรม DynamicField เพื่อจัดการกับการอัพเดตเงื่อนไขถ้าฟิลด์แบบไดนามิกที่มีการเพิ่ม การปรับปรุงหรือลบ';
    $Self->{Translation}->{'Edit a change.'} = '';
    $Self->{Translation}->{'Edit the change.'} = '';
    $Self->{Translation}->{'Edit the conditions of the change.'} = '';
    $Self->{Translation}->{'Edit the workorder.'} = '';
    $Self->{Translation}->{'Enables the minimal change counter size (if "Date" was selected as ITSMChange::NumberGenerator).'} =
        '';
    $Self->{Translation}->{'Forward schedule of changes. Overview over approved changes.'} =
        '';
    $Self->{Translation}->{'History Zoom'} = '';
    $Self->{Translation}->{'ITSM Change CAB Templates.'} = '';
    $Self->{Translation}->{'ITSM Change Condition Edit.'} = '';
    $Self->{Translation}->{'ITSM Change Condition Overview.'} = '';
    $Self->{Translation}->{'ITSM Change Manager Overview.'} = '';
    $Self->{Translation}->{'ITSM Change Notifications'} = '';
    $Self->{Translation}->{'ITSM Change PIR Overview.'} = '';
    $Self->{Translation}->{'ITSM Change notification rules'} = '';
    $Self->{Translation}->{'ITSM Changes'} = 'ITSM Changes';
    $Self->{Translation}->{'ITSM MyCAB Overview.'} = '';
    $Self->{Translation}->{'ITSM MyChanges Overview.'} = '';
    $Self->{Translation}->{'ITSM MyWorkorders Overview.'} = '';
    $Self->{Translation}->{'ITSM Template Delete.'} = '';
    $Self->{Translation}->{'ITSM Template Edit CAB.'} = '';
    $Self->{Translation}->{'ITSM Template Edit Content.'} = '';
    $Self->{Translation}->{'ITSM Template Edit.'} = '';
    $Self->{Translation}->{'ITSM Template Overview.'} = '';
    $Self->{Translation}->{'ITSM event module that cleans up conditions.'} = 'โมดูลเหตุการณ์ ITSM ที่จะลบเงื่อนไข';
    $Self->{Translation}->{'ITSM event module that deletes the cache for a toolbar.'} = 'โมดูลเหตุการณ์ ITSM ที่จะลบการแคชสำหรับแถบเครื่องมือ';
    $Self->{Translation}->{'ITSM event module that deletes the history of changes.'} = '';
    $Self->{Translation}->{'ITSM event module that matches conditions and executes actions.'} =
        'โมดูลเหตุการณ์ ITSM ที่จับคู่เงื่อนไขและดำเนินการการกระทำ';
    $Self->{Translation}->{'ITSM event module that sends notifications.'} = 'โมดูลเหตุการณ์ ITSM ที่ส่งการแจ้งเตือน';
    $Self->{Translation}->{'ITSM event module that updates the history of changes.'} = 'โมดูลเหตุการณ์ ITSM ที่อัปเดตประวัติของการเปลี่ยนแปลง';
    $Self->{Translation}->{'ITSM event module that updates the history of conditions.'} = '';
    $Self->{Translation}->{'ITSM event module that updates the history of workorders.'} = '';
    $Self->{Translation}->{'ITSM event module to recalculate the workorder numbers.'} = 'โมดูลเหตุการณ์ ITSM ที่คำนวณจำนวนใบสั่งงานใหม่';
    $Self->{Translation}->{'ITSM event module to set the actual start and end times of workorders.'} =
        'โมดูลเหตุการณ์ ITSM เพื่อตั้งค่าเวลาเริ่มต้นและเวลาสิ้นสุดที่เกิดขึ้นจริงของใบสั่งงาน';
    $Self->{Translation}->{'ITSMChange'} = 'ITSMChange';
    $Self->{Translation}->{'ITSMWorkOrder'} = 'ใบสั่งงานของITSM';
    $Self->{Translation}->{'If frequency is \'regularly\', you can configure how often the notifications are sent (every X hours).'} =
        '';
    $Self->{Translation}->{'Link another object to the change.'} = '';
    $Self->{Translation}->{'Link another object to the workorder.'} = '';
    $Self->{Translation}->{'List of all change events to be displayed in the GUI.'} = '';
    $Self->{Translation}->{'List of all workorder events to be displayed in the GUI.'} = '';
    $Self->{Translation}->{'Lookup of CAB members for autocompletion.'} = '';
    $Self->{Translation}->{'Lookup of agents, used for autocompletion.'} = '';
    $Self->{Translation}->{'Manage ITSM Change Management state machine.'} = '';
    $Self->{Translation}->{'Manage the category ↔ impact ↔ priority matrix.'} = '';
    $Self->{Translation}->{'Module to check if WorkOrderAdd or WorkOrderAddFromTemplate should be permitted.'} =
        'โมดูลเพื่อตรวจสอบว่า WorkOrderAdd หรือ WorkOrderAddFromTemplate ควรได้รับการอนุญาต';
    $Self->{Translation}->{'Module to check the CAB members.'} = 'โมดูลในการตรวจสอบสมาชิก CAB';
    $Self->{Translation}->{'Module to check the agent.'} = 'โมดูลในการตรวจสอบเอเย่นต์';
    $Self->{Translation}->{'Module to check the change builder.'} = 'โมดูลในการตรวจสอบผู้สร้างChange ';
    $Self->{Translation}->{'Module to check the change manager.'} = 'โมดูลการตรวจสอบผู้จัดการChange ';
    $Self->{Translation}->{'Module to check the workorder agent.'} = 'โมดูลในการตรวจสอบเอเย่นต์ใบสั่งงาน';
    $Self->{Translation}->{'Module to check whether no workorder agent is set.'} = 'โมดูลในการตรวจสอบว่าเซตใบสั่งงานหรือไม่';
    $Self->{Translation}->{'Module to check whether the agent is contained in the configured list.'} =
        'โมดูลในการตรวจสอบว่าเอเย่นต์บรรจุอยู่ในรายการของการกำหนดค่าหรือไม่';
    $Self->{Translation}->{'Module to show a link to create a change from this ticket. The ticket will be automatically linked with the new change.'} =
        'โมดูลในการแสดงลิงค์เพื่อสร้างการเปลี่ยนแปลงจากตั๋วนี้ ตั๋วนี้จะลิงค์กับการเปลี่ยนแปลงใหม่โดยอัตโนมัติ';
    $Self->{Translation}->{'Move Time Slot.'} = '';
    $Self->{Translation}->{'Move all workorders in time.'} = '';
    $Self->{Translation}->{'New (from template)'} = 'ใหม่ (จาก แม่แบบ)';
    $Self->{Translation}->{'Only users of these groups have the permission to use the ticket types as defined in "ITSMChange::AddChangeLinkTicketTypes" if the feature "Ticket::Acl::Module###200-Ticket::Acl::Module" is enabled.'} =
        'เฉพาะผู้ใช้ของกลุ่มเหล่านี้เท่านั้นที่ได้รับอนุญาตให้ใช้รูปแบบตั๋วตามที่กำหนดใน "ITSMChange::AddChangeLinkTicketTypes" ถ้าคุณลักษณะแบบดังกล่าว "Tiket::Acl::Modul###200-Tiket::Acl::Modul" เปิดใช้งาน';
    $Self->{Translation}->{'Other Settings'} = 'การตั้งค่าอื่นๆ';
    $Self->{Translation}->{'Overview over all Changes.'} = '';
    $Self->{Translation}->{'PIR'} = '';
    $Self->{Translation}->{'PIR (Post Implementation Review)'} = 'PIR (ความคิดเห็นหลังการดำเนินการ)';
    $Self->{Translation}->{'PSA'} = '';
    $Self->{Translation}->{'Parameters for the UserCreateWorkOrderNextMask object in the preference view of the agent interface.'} =
        'พารามิเตอร์สำหรับออบเจค UserCreateWorkOrderNextMask ในมุมมองของการตั้งค่าของอินเตอร์เฟซเอเย่นต์';
    $Self->{Translation}->{'Parameters for the pages (in which the changes are shown) of the small change overview.'} =
        'พารามิเตอร์สำหรับแต่ละหน้า(ซึ่งการเปลี่ยนแปลงจะแสดง) ของภาพรวมการเปลี่ยนแปลงขนาดเล็ก';
    $Self->{Translation}->{'Performs the configured action for each event (as an Invoker) for each configured Webservice.'} =
        '';
    $Self->{Translation}->{'Planned end time'} = '';
    $Self->{Translation}->{'Planned start time'} = '';
    $Self->{Translation}->{'Print the change.'} = '';
    $Self->{Translation}->{'Print the workorder.'} = '';
    $Self->{Translation}->{'Projected Service Availability'} = '';
    $Self->{Translation}->{'Projected Service Availability (PSA)'} = '';
    $Self->{Translation}->{'Projected Service Availability (PSA) of changes. Overview of approved changes and their services.'} =
        '';
    $Self->{Translation}->{'Requested time'} = '';
    $Self->{Translation}->{'Required privileges in order for an agent to take a workorder.'} =
        'สิทธิพิเศษที่จำเป็นต้องใช้เพื่อให้เอเย่นต์ที่จะรับใบสั่งงาน';
    $Self->{Translation}->{'Required privileges to access the overview of all changes.'} = 'สิทธิพิเศษที่จำเป็นในการเข้าถึงภาพรวมของการเปลี่ยนแปลงทั้งหมด';
    $Self->{Translation}->{'Required privileges to add a workorder.'} = 'สิทธิพิเศษที่จำเป็นในการเพิ่มใบสั่งงาน';
    $Self->{Translation}->{'Required privileges to change the workorder agent.'} = 'สิทธิพิเศษที่จำเป็นในการเปลี่ยนแปลงเอเย่นต์ของใบสั่งงาน';
    $Self->{Translation}->{'Required privileges to create a template from a change.'} = 'สิทธิพิเศษที่จำเป็นในการสร้างแม่แบบจากการเปลี่ยนแปลง';
    $Self->{Translation}->{'Required privileges to create a template from a changes\' CAB.'} =
        'สิทธิพิเศษที่จำเป็นในการสร้างแม่แบบจากเปลี่ยนแปลง CAB';
    $Self->{Translation}->{'Required privileges to create a template from a workorder.'} = 'สิทธิพิเศษที่จำเป็นในการสร้างแม่แบบจากใบสั่งงาน';
    $Self->{Translation}->{'Required privileges to create changes from templates.'} = 'สิทธิพิเศษที่จำเป็นในการสร้างการเปลี่ยนแปลงจากแม่แบบ';
    $Self->{Translation}->{'Required privileges to create changes.'} = 'สิทธิพิเศษที่จำเป็นในการสร้างการเปลี่ยนแปลง';
    $Self->{Translation}->{'Required privileges to delete a template.'} = 'สิทธิพิเศษที่จำเป็นในการลบแม่แบบ';
    $Self->{Translation}->{'Required privileges to delete a workorder.'} = 'สิทธิพิเศษที่จำเป็นในการลบใบสั่งงาน';
    $Self->{Translation}->{'Required privileges to delete changes.'} = 'สิทธิพิเศษที่จำเป็นในการลบการเปลี่ยนแปลง';
    $Self->{Translation}->{'Required privileges to edit a template.'} = 'สิทธิพิเศษที่จำเป็นในการแก้ไขแม่แบบ';
    $Self->{Translation}->{'Required privileges to edit a workorder.'} = 'สิทธิพิเศษที่จำเป็นในการแก้ไขใบสั่งงาน';
    $Self->{Translation}->{'Required privileges to edit changes.'} = 'สิทธิพิเศษที่จำเป็นในการแก้ไขเปลี่ยนแปลง';
    $Self->{Translation}->{'Required privileges to edit the conditions of changes.'} = 'สิทธิพิเศษที่จำเป็นในการแก้ไขเงื่อนไขของการเปลี่ยนแปลง';
    $Self->{Translation}->{'Required privileges to edit the content of a template.'} = 'สิทธิพิเศษที่จำเป็นในการแก้ไขเนื้อหาของแม่แบบ';
    $Self->{Translation}->{'Required privileges to edit the involved persons of a change.'} =
        'สิทธิพิเศษที่จำเป็นในการแก้ไขผู้ที่เกี่ยวข้องของการเปลี่ยนแปลง';
    $Self->{Translation}->{'Required privileges to move changes in time.'} = 'สิทธิพิเศษที่จำเป็นในการย้ายการเปลี่ยนแปลงตามเวลา';
    $Self->{Translation}->{'Required privileges to print a change.'} = 'สิทธิพิเศษที่จำเป็นในการพิมพ์การเปลี่ยนแปลง';
    $Self->{Translation}->{'Required privileges to reset changes.'} = 'สิทธิพิเศษที่จำเป็นในการการรีเซ็ตการเปลี่ยนแปลง';
    $Self->{Translation}->{'Required privileges to view a workorder.'} = 'สิทธิพิเศษที่จำเป็นในการดูใบสั่งงาน';
    $Self->{Translation}->{'Required privileges to view changes.'} = 'สิทธิพิเศษที่จำเป็นในการดูการเปลี่ยนแปลง';
    $Self->{Translation}->{'Required privileges to view list of changes where the user is a CAB member.'} =
        'สิทธิพิเศษที่จำเป็นในการดูรายการของการเปลี่ยนแปลงที่ผู้ใช้ที่เป็นสมาชิก CAB';
    $Self->{Translation}->{'Required privileges to view list of changes where the user is the change manager.'} =
        'สิทธิพิเศษที่จำเป็นในการดูรายการของการเปลี่ยนแปลงที่ผู้ใช้เป็นผู้จัดการการเปลี่ยนแปลง';
    $Self->{Translation}->{'Required privileges to view overview over all templates.'} = 'สิทธิพิเศษที่จำเป็นในการดูภาพรวมแม่แบบทั้งหมด';
    $Self->{Translation}->{'Required privileges to view the conditions of changes.'} = 'สิทธิพิเศษที่จำเป็นในการดูเงื่อนไขของการเปลี่ยนแปลง';
    $Self->{Translation}->{'Required privileges to view the history of a change.'} = 'สิทธิพิเศษที่จำเป็นในการดูประวัติการของการเปลี่ยนแปลง';
    $Self->{Translation}->{'Required privileges to view the history of a workorder.'} = 'สิทธิพิเศษที่จำเป็นในการดูประวัติของใบสั่งงาน';
    $Self->{Translation}->{'Required privileges to view the history zoom of a change.'} = 'สิทธิพิเศษที่จำเป็นในการซูมดูประวัติของการเปลี่ยนแปลง';
    $Self->{Translation}->{'Required privileges to view the history zoom of a workorder.'} =
        'สิทธิพิเศษที่จำเป็นในการซูมดูประวัติของใบสั่งงาน';
    $Self->{Translation}->{'Required privileges to view the list of Change Schedule.'} = 'สิทธิพิเศษที่จำเป็นในการดูรายการของการกำหนดการเปลี่ยนแปลง';
    $Self->{Translation}->{'Required privileges to view the list of change PSA.'} = 'สิทธิพิเศษที่จำเป็นในการดูรายการของการเปลี่ยนแปลง PSA';
    $Self->{Translation}->{'Required privileges to view the list of changes with an upcoming PIR (Post Implementation Review).'} =
        'สิทธิพิเศษที่จำเป็นในการดูรายการของการเปลี่ยนแปลงด้วย PIR ที่จะมาถึง (รีวิวหลังการดำเนินงาน)';
    $Self->{Translation}->{'Required privileges to view the list of own changes.'} = 'สิทธิพิเศษที่จำเป็นในการดูรายการของการเปลี่ยนแปลงของตัวเอง';
    $Self->{Translation}->{'Required privileges to view the list of own workorders.'} = 'สิทธิพิเศษที่จำเป็นในการดูรายการของใบสั่งงานของตัวเอง';
    $Self->{Translation}->{'Required privileges to write a report for the workorder.'} = 'สิทธิพิเศษที่จำเป็นในการเขียนรายงานสำหรับใบสั่งงาน';
    $Self->{Translation}->{'Reset a change and its workorders.'} = '';
    $Self->{Translation}->{'Reset change and its workorders.'} = '';
    $Self->{Translation}->{'Run task to check if specific times have been reached in changes and workorders.'} =
        '';
    $Self->{Translation}->{'Save change as a template.'} = '';
    $Self->{Translation}->{'Save workorder as a template.'} = '';
    $Self->{Translation}->{'Schedule'} = '';
    $Self->{Translation}->{'Screen after creating a workorder'} = 'หน้าจอหลังจากที่สร้างใบสั่งงาน';
    $Self->{Translation}->{'Search Changes'} = 'ค้นหาChange ';
    $Self->{Translation}->{'Search Changes.'} = '';
    $Self->{Translation}->{'Selects the change number generator module. "AutoIncrement" increments the change number, the SystemID and the counter are used with SystemID.counter format (e.g. 100118, 100119). With "Date", the change numbers will be generated by the current date and a counter; this format looks like Year.Month.Day.counter, e.g. 2010062400001, 2010062400002. With "DateChecksum", the counter will be appended as checksum to the string of date plus the SystemID. The checksum will be rotated on a daily basis. This format looks like Year.Month.Day.SystemID.Counter.CheckSum, e.g. 2010062410000017, 2010062410000026.'} =
        'เลือกโมดูลตัวสร้างหมายเลขการเปลี่ยนแปลง "AutoIncrement" เพิ่มจำนวนการเปลี่ยนแปลง SystemID และตัวนับจะใช้กับ SystemID รูปแบบตัวนับ (เช่น 100118, 100119) กับ "วันที่" ซึ่งหมายเลขการเปลี่ยนแปลงจะถูกสร้างขึ้นโดยวันที่ปัจจุบันและตัวนับ; รูปแบบนี้มีลักษณะเช่น Year.Month.Day.counter เช่น 2010062400001, 2010062400002. กับ "DateChecksum" ตัวนับจะถูกผนวกเป็นการตรวจสอบไปยังสตริงวันบวกด้วย SystemID ที่การตรวจสอบจะมีการหมุนในแต่ละวัน รูปแบบนี้มีลักษณะเช่นYear.Month.Day.SystemID.Counter.CheckSum เช่น 2010062410000017, 2010062410000026';
    $Self->{Translation}->{'Set the agent for the workorder.'} = '';
    $Self->{Translation}->{'Set the default height (in pixels) of inline HTML fields in the change zoom screen and workorder zoom screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Set the maximum height (in pixels) of inline HTML fields in the change zoom screen and workorder zoom screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Sets the minimal change counter size (if "AutoIncrement" was selected as ITSMChange::NumberGenerator). Default is 5, this means the counter starts from 10000.'} =
        'ตั้งค่าขนาดตัวนับการเปลี่ยนแปลงน้อยที่สุด (ถ้า "AutoIncrement" ได้รับเลือกเป็น ITSMChange :: NumberGenerator) ค่าเริ่มต้นคือ 5 ซึ่งหมายความว่าตัวนับเริ่มต้นจาก 10000';
    $Self->{Translation}->{'Sets up the state machine for changes.'} = 'ตั้งค่าเครื่องของสถานะสำหรับการเปลี่ยนแปลง';
    $Self->{Translation}->{'Sets up the state machine for workorders.'} = 'ตั้งค่าเครื่องของสถานะสำหรับใบสั่งงาน';
    $Self->{Translation}->{'Shows a checkbox in the workorder edit screen of the agent interface that defines if the the following workorders should also be moved if a workorder is modified and the planned end time has changed.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows changing the workorder agent, in the zoom view of the workorder of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows defining a change as a template in the zoom view of the change, in the agent interface.'} =
        'แสดงการเชื่อมโยงในเมนูที่อนุญาติให้กำหนด
การเปลี่ยนแปลงเป็นแม่แบบในมุมมองการซูมของใบสั่งงานดังกล่าวอินเตอร์เฟซเอเย่นต์';
    $Self->{Translation}->{'Shows a link in the menu that allows defining a workorder as a template in the zoom view of the workorder, in the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows editing the report of a workorder, in the zoom view of the workorder of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows linking a change with another object in the change zoom view of the agent interface.'} =
        'แสดงการเชื่อมโยงในเมนูที่อนุญาติให้เชื่อมโยงการเปลี่ยนแปลงกับออบเจคอื่นในมุมมองการซูมของใบสั่งงานดังกล่าวอินเตอร์เฟซเอเย่นต์';
    $Self->{Translation}->{'Shows a link in the menu that allows linking a workorder with another object in the zoom view of the workorder of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows moving the time slot of a change in its zoom view of the agent interface.'} =
        'แสดงการเชื่อมโยงในเมนูที่อนุญาติให้ย้ายช่วงเวลาของการเปลี่ยนแปลงในมุมมองการซูมของอินเตอร์เฟซเอเย่นต์';
    $Self->{Translation}->{'Shows a link in the menu that allows taking a workorder in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to access the conditions of a change in the its zoom view of the agent interface.'} =
        'แสดงลิงค์ในเมนูเพื่อที่เข้าดูเงื่อนไขการเปลี่ยนแปลงในมุมมองการซูมของอินเตอร์เฟซเอเย่นต์';
    $Self->{Translation}->{'Shows a link in the menu to access the history of a change in the its zoom view of the agent interface.'} =
        'แสดงลิงค์ในเมนูเพื่อที่เข้าชมประวัติการเปลี่ยนแปลงในมุมมองการซูมของอินเตอร์เฟซเอเย่นต์';
    $Self->{Translation}->{'Shows a link in the menu to access the history of a workorder in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to add a workorder in the change zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to delete a change in its zoom view of the agent interface.'} =
        'แสดงลิงค์ในเมนูเพื่อที่จะลบการเปลี่ยนแปลงในมุมมองการซูมของอินเตอร์เฟซเอเย่นต์';
    $Self->{Translation}->{'Shows a link in the menu to delete a workorder in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to edit a change in the its zoom view of the agent interface.'} =
        'แสดงลิงค์ในเมนูเพื่อแก้ไขการเปลี่ยนแปลงในมุมมองการซูมของอินเตอร์เฟซเอเย่นต์';
    $Self->{Translation}->{'Shows a link in the menu to edit a workorder in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to go back in the change zoom view of the agent interface.'} =
        'แสดงลิงค์ในเมนูเพื่อกลับไปยังมุมมองการซูมของการเปลี่ยนแปลงของอินเตอร์เฟซเอเย่นต์';
    $Self->{Translation}->{'Shows a link in the menu to go back in the workorder zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to print a change in the its zoom view of the agent interface.'} =
        'แสดงลิงค์ในเมนูเพื่อพิมพ์การเปลี่ยนแปลงในมุมมองการซูมของอินเตอร์เฟซเอเย่นต์';
    $Self->{Translation}->{'Shows a link in the menu to print a workorder in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to reset a change and its workorders in its zoom view of the agent interface.'} =
        'แสดงการเชื่อมโยงในเมนูเพื่อรีเซ็ตการเปลี่ยนแปลงและใบสั่งงานในมุมมองการซูมของอินเตอร์เฟซเอเย่นต์';
    $Self->{Translation}->{'Shows a link in the menu to show the involved persons in a change, in the zoom view of the change in the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows the change history (reverse ordered) in the agent interface.'} =
        'แสดงประวัติการเปลี่ยนแปลง (ลำดับย้อนกลับ) ในอินเตอร์เฟซเอเย่นต์';
    $Self->{Translation}->{'State Machine'} = 'สถานะกลไก';
    $Self->{Translation}->{'Stores change and workorder ids and their corresponding template id, while a user is editing a template.'} =
        'จัดเก็บการเปลี่ยนแปลงและไอดีใบสั่งงานและไอดีแม่แบบที่สอดคล้องกันของพวกเขาในขณะที่ผู้ใช้แก้ไขแม่แบบ';
    $Self->{Translation}->{'Take Workorder'} = 'รับใบสั่งงาน';
    $Self->{Translation}->{'Take Workorder.'} = '';
    $Self->{Translation}->{'Take the workorder.'} = '';
    $Self->{Translation}->{'Template Overview'} = 'มุมมองแม่แบบ';
    $Self->{Translation}->{'Template type'} = '';
    $Self->{Translation}->{'Template.'} = '';
    $Self->{Translation}->{'The identifier for a change, e.g. Change#, MyChange#. The default is Change#.'} =
        'ตัวบ่งชี้สำหรับการเปลี่ยนแปลง เช่น การเปลี่ยนแปลง#  การเปลี่ยนแปลงของฉัน# ค่าเริ่มต้นคือ การเปลี่ยนแปลง#';
    $Self->{Translation}->{'The identifier for a workorder, e.g. Workorder#, MyWorkorder#. The default is Workorder#.'} =
        'ตัวบ่งชี้สำหรับใบสั่งงาน เช่น ใบสั่งงาน#  ใบสั่งงานของฉัน# ค่าเริ่มต้นคือ ใบสั่งงาน#.\';';
    $Self->{Translation}->{'This ACL module restricts the usuage of the ticket types that are defined in the sysconfig option \'ITSMChange::AddChangeLinkTicketTypes\', to users of the groups as defined in "ITSMChange::RestrictTicketTypes::Groups". As this ACL could collide with other ACLs which are also related to the ticket type, this sysconfig option is disabled by default and should only be activated if needed.'} =
        'โมดูล ACL นี้จำกัดการใช้งานของประเภทตั๋วที่กำหนดไว้ในตัวเลือกที่ sysconfig \'ITSMChange :: AddChangeLinkTicketTypes\' ให้กับผู้ใช้ของกลุ่มนั้นๆตามที่กำหนดใน "ITSMChange :: RestrictTicketTypes :: Groups"
ในฐานะที่เป็น ACL นี้อาจขัดแย้งกับ ACLs อื่น ๆ ที่ยังเกี่ยวข้องกับประเภทตั๋ว ตัวเลือก sysconfig นี้ถูกปิดใช้งานโดยค่าเริ่มต้นและควรจะเปิดใช้งานในกรณีที่จำเป็น';
    $Self->{Translation}->{'Time Slot'} = '';
    $Self->{Translation}->{'Types of tickets, where in the ticket zoom view a link to add a change will be displayed.'} =
        'ประเภทของตั๋วที่ซูมตั๋วดูการลิงค์ที่จะเพิ่มการเปลี่ยนแปลงจะปรากฏ';
    $Self->{Translation}->{'User Search'} = '';
    $Self->{Translation}->{'Workorder Add (from template).'} = '';
    $Self->{Translation}->{'Workorder Add.'} = '';
    $Self->{Translation}->{'Workorder Agent.'} = '';
    $Self->{Translation}->{'Workorder Delete.'} = '';
    $Self->{Translation}->{'Workorder Edit.'} = '';
    $Self->{Translation}->{'Workorder History Zoom.'} = '';
    $Self->{Translation}->{'Workorder History.'} = '';
    $Self->{Translation}->{'Workorder Report.'} = '';
    $Self->{Translation}->{'Workorder Zoom'} = '';
    $Self->{Translation}->{'Workorder Zoom.'} = '';
    $Self->{Translation}->{'once'} = '';
    $Self->{Translation}->{'regularly'} = '';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Do you really want to delete this action?',
    'Do you really want to delete this condition?',
    'Do you really want to delete this expression?',
    'Do you really want to delete this notification language?',
    'Do you really want to delete this notification?',
    'No',
    'Ok',
    'Please enter at least one search value or * to find anything.',
    'Settings',
    'Submit',
    'Yes',
    );

}

1;
