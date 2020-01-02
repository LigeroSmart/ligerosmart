# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::ms_ITSMChangeManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminITSMChangeCIPAllocate
    $Self->{Translation}->{'Category ↔ Impact ↔ Priority'} = 'Kategori ↔ Kesan ↔ keutamaan';
    $Self->{Translation}->{'Manage the priority result of combinating Category ↔ Impact.'} =
        'Pentadbiran gabungan kategori keutamaan ↔ Impak.';
    $Self->{Translation}->{'Priority allocation'} = 'Berikan keutamaan';

    # Template: AdminITSMChangeNotification
    $Self->{Translation}->{'ITSM ChangeManagement Notification Management'} = 'ITSM Pengurusan Perubahan pengurusan pemberitahuan';
    $Self->{Translation}->{'Add Notification Rule'} = 'Peraturan Pemberitahuan';
    $Self->{Translation}->{'Edit Notification Rule'} = '';
    $Self->{Translation}->{'A notification should have a name!'} = 'Pemberitahuan memerlukan nama!';
    $Self->{Translation}->{'Name is required.'} = 'Namanya dikehendaki.';

    # Template: AdminITSMStateMachine
    $Self->{Translation}->{'Admin State Machine'} = 'Keadaan Mesin Admin';
    $Self->{Translation}->{'Select a catalog class!'} = 'Pilih kelas katalog!';
    $Self->{Translation}->{'A catalog class is required!'} = 'Satu kelas katalog diperlukan!';
    $Self->{Translation}->{'Add a state transition'} = 'Tambah peralihan status';
    $Self->{Translation}->{'Catalog Class'} = 'Kelas katalog';
    $Self->{Translation}->{'Object Name'} = 'Nama Objek';
    $Self->{Translation}->{'Overview over state transitions for'} = 'Tinjauan bagi keadaan peralihan';
    $Self->{Translation}->{'Delete this state transition'} = 'Memadam peralihan keadaan ini';
    $Self->{Translation}->{'Add a new state transition for'} = 'Menambah peralihan keadaan yang baru untuk';
    $Self->{Translation}->{'Please select a state!'} = 'Sila pilih keadaan!';
    $Self->{Translation}->{'Please select a next state!'} = 'Sila pilih status berikut!';
    $Self->{Translation}->{'Edit a state transition for'} = 'Penyuntingan peralihan keadaan untuk';
    $Self->{Translation}->{'Do you really want to delete the state transition'} = 'Adakah anda mahu memadam status peralihan ini benar-benar?';

    # Template: AgentITSMChangeAdd
    $Self->{Translation}->{'Add Change'} = 'Tukar Tambah';
    $Self->{Translation}->{'ITSM Change'} = 'Ubah ITSM';
    $Self->{Translation}->{'Justification'} = 'justifikasi';
    $Self->{Translation}->{'Input invalid.'} = 'input tidak sah.';
    $Self->{Translation}->{'Impact'} = 'Kesan';
    $Self->{Translation}->{'Requested Date'} = 'Tarikh yang diminta';

    # Template: AgentITSMChangeAddFromTemplate
    $Self->{Translation}->{'Select Change Template'} = 'Tukar Pilih Templat';
    $Self->{Translation}->{'Time type'} = 'Masa-jenis';
    $Self->{Translation}->{'Invalid time type.'} = 'Masa Taip tidak sah.';
    $Self->{Translation}->{'New time'} = 'Masa baru';

    # Template: AgentITSMChangeCABTemplate
    $Self->{Translation}->{'Save Change CAB as template'} = 'Ini perubahan sebagai templat';
    $Self->{Translation}->{'go to involved persons screen'} = 'pergi kepada orang-orang skrin terlibat';
    $Self->{Translation}->{'Invalid Name'} = 'nama tidak sah';

    # Template: AgentITSMChangeCondition
    $Self->{Translation}->{'Conditions and Actions'} = 'Syarat-syarat dan Tindakan';
    $Self->{Translation}->{'Delete Condition'} = 'Padam keadaan';
    $Self->{Translation}->{'Add new condition'} = 'Tambah keadaan';

    # Template: AgentITSMChangeConditionEdit
    $Self->{Translation}->{'Edit Condition'} = '';
    $Self->{Translation}->{'Need a valid name.'} = 'Perlu nama yang sah.';
    $Self->{Translation}->{'A valid name is needed.'} = '';
    $Self->{Translation}->{'Duplicate name:'} = 'Menyalin nama:';
    $Self->{Translation}->{'This name is already used by another condition.'} = 'Nama jni sudah digunakan oleh keadaan lain.';
    $Self->{Translation}->{'Matching'} = 'Sepadan';
    $Self->{Translation}->{'Any expression (OR)'} = 'Sebarang ekspresi (ATAU)';
    $Self->{Translation}->{'All expressions (AND)'} = 'Semua ungkapan logik (DAN)';
    $Self->{Translation}->{'Expressions'} = 'Ungkapan logik';
    $Self->{Translation}->{'Selector'} = 'pemilih';
    $Self->{Translation}->{'Operator'} = 'Operator';
    $Self->{Translation}->{'Delete Expression'} = 'Memadam ungkapan';
    $Self->{Translation}->{'No Expressions found.'} = 'Tiada ungkapan logik ditemui.';
    $Self->{Translation}->{'Add new expression'} = 'Tambah ungkapan baru';
    $Self->{Translation}->{'Delete Action'} = 'Memadam tindakan';
    $Self->{Translation}->{'No Actions found.'} = 'Tiada Tindakan dijumpai.';
    $Self->{Translation}->{'Add new action'} = 'Tambah tindakan baru';

    # Template: AgentITSMChangeDelete
    $Self->{Translation}->{'Do you really want to delete this change?'} = 'Adakah anda benar-benar mahu untuk memadam perubahan ini?';

    # Template: AgentITSMChangeEdit
    $Self->{Translation}->{'Edit %s%s'} = '';

    # Template: AgentITSMChangeHistory
    $Self->{Translation}->{'History of %s%s'} = 'Sejarah %s%s';
    $Self->{Translation}->{'History Content'} = 'Kandungan sejarah';
    $Self->{Translation}->{'Workorder'} = 'Perintah Kerja';
    $Self->{Translation}->{'Createtime'} = 'Cipta masa';
    $Self->{Translation}->{'Show details'} = 'Keperinchian menunjukkan';
    $Self->{Translation}->{'Show workorder'} = 'Perintah kerja menunjukkan';

    # Template: AgentITSMChangeHistoryZoom
    $Self->{Translation}->{'Detailed history information of %s'} = '';
    $Self->{Translation}->{'Modified'} = 'Diubahsuai';
    $Self->{Translation}->{'Old Value'} = 'Nilai Lama';
    $Self->{Translation}->{'New Value'} = 'Nilai Baru';

    # Template: AgentITSMChangeInvolvedPersons
    $Self->{Translation}->{'Edit Involved Persons of %s%s'} = '';
    $Self->{Translation}->{'Involved Persons'} = 'Orang terlibat';
    $Self->{Translation}->{'ChangeManager'} = 'Perubahan Pengurus';
    $Self->{Translation}->{'User invalid.'} = 'Pengguna tidak sah';
    $Self->{Translation}->{'ChangeBuilder'} = 'Perubahan Membina';
    $Self->{Translation}->{'Change Advisory Board'} = 'Perubahan-Penasihat-Lembaga';
    $Self->{Translation}->{'CAB Template'} = 'CAB-Templat';
    $Self->{Translation}->{'Apply Template'} = 'memohon templat';
    $Self->{Translation}->{'NewTemplate'} = 'Templat baru';
    $Self->{Translation}->{'Save this CAB as template'} = 'Simpan CAB ini sebagai templat';
    $Self->{Translation}->{'Add to CAB'} = 'Tambah kepada CAB';
    $Self->{Translation}->{'Invalid User'} = 'Pengguna Tidak Sah';
    $Self->{Translation}->{'Current CAB'} = 'CAB semasa';

    # Template: AgentITSMChangeOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = 'Tetapan konteks';
    $Self->{Translation}->{'Changes per page'} = 'Perubahan setiap halaman';

    # Template: AgentITSMChangeOverviewSmall
    $Self->{Translation}->{'Workorder Title'} = '';
    $Self->{Translation}->{'Change Title'} = '';
    $Self->{Translation}->{'Workorder Agent'} = '';
    $Self->{Translation}->{'Change Builder'} = 'Perubahan pembina';
    $Self->{Translation}->{'Change Manager'} = 'Perubahan Pengurus';
    $Self->{Translation}->{'Workorders'} = 'Perintah Kerja';
    $Self->{Translation}->{'Change State'} = '';
    $Self->{Translation}->{'Workorder State'} = '';
    $Self->{Translation}->{'Workorder Type'} = '';
    $Self->{Translation}->{'Requested Time'} = 'Masa yang Diminta';
    $Self->{Translation}->{'Planned Start Time'} = '';
    $Self->{Translation}->{'Planned End Time'} = '';
    $Self->{Translation}->{'Actual Start Time'} = '';
    $Self->{Translation}->{'Actual End Time'} = '';

    # Template: AgentITSMChangeReset
    $Self->{Translation}->{'Do you really want to reset this change?'} = 'Adakah anda benar-benar mahu untuk menetapkan semula perubahan ini?';

    # Template: AgentITSMChangeSearch
    $Self->{Translation}->{'(e.g. 10*5155 or 105658*)'} = '(z. B. 10*5155 or 105658*)';
    $Self->{Translation}->{'CAB Agent'} = '';
    $Self->{Translation}->{'e.g.'} = 'cth.';
    $Self->{Translation}->{'CAB Customer'} = '';
    $Self->{Translation}->{'ITSM Workorder Instruction'} = '';
    $Self->{Translation}->{'ITSM Workorder Report'} = '';
    $Self->{Translation}->{'ITSM Change Priority'} = '';
    $Self->{Translation}->{'ITSM Change Impact'} = '';
    $Self->{Translation}->{'Change Category'} = 'Ubah Kategori';
    $Self->{Translation}->{'(before/after)'} = '(sebelum/selepas)';
    $Self->{Translation}->{'(between)'} = '(diantara)';

    # Template: AgentITSMChangeTemplate
    $Self->{Translation}->{'Save Change as Template'} = 'Simpan Perubahan sebagai Templat';
    $Self->{Translation}->{'A template should have a name!'} = 'Template harus mempunyai nama!';
    $Self->{Translation}->{'The template name is required.'} = 'Nama template diperlukan.';
    $Self->{Translation}->{'Reset States'} = 'Set Semula Keadaan';
    $Self->{Translation}->{'Overwrite original template'} = 'Menulis ganti templat asal';
    $Self->{Translation}->{'Delete original change'} = 'Memadam perubahan asal';

    # Template: AgentITSMChangeTimeSlot
    $Self->{Translation}->{'Move Time Slot'} = 'Gerakkan Slot Masa';

    # Template: AgentITSMChangeZoom
    $Self->{Translation}->{'Change Information'} = 'mengubah Maklumat';
    $Self->{Translation}->{'Planned Effort'} = '';
    $Self->{Translation}->{'Accounted Time'} = '';
    $Self->{Translation}->{'Change Initiator(s)'} = 'Penggerak Perubahan(s)';
    $Self->{Translation}->{'CAB'} = 'CAB';
    $Self->{Translation}->{'Last changed'} = 'Terkini berubah';
    $Self->{Translation}->{'Last changed by'} = 'Terakhir diubah oleh';
    $Self->{Translation}->{'To open links in the following description blocks, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).'} =
        'Untuk membuka pautan dalam keterangan blok berikut, anda mungkin perlu menekan kekunci Ctrl atau Cmd atau Shift semasa menekan pautan (bergantung kepada pelayar dan sistem operasi anda).';
    $Self->{Translation}->{'Download Attachment'} = 'memuat turun lampiran';

    # Template: AgentITSMTemplateEditCAB
    $Self->{Translation}->{'Edit CAB Template'} = 'Menyunting templat CAB';

    # Template: AgentITSMTemplateEditContent
    $Self->{Translation}->{'This will create a new change from this template, so you can edit and save it.'} =
        'Ini akan menghasilkan perubahan baru pada templat, jadi anda boleh mengubah dan menyimpannya.';
    $Self->{Translation}->{'The new change will be deleted automatically after it has been saved as template.'} =
        'Perubahan baru akan dipadam secara automatik selepas ia telah disimpan sebagai templat.';
    $Self->{Translation}->{'This will create a new workorder from this template, so you can edit and save it.'} =
        'Ini akan mencipta aturan kerja baru dari templat, jadi anda boleh mengubah dan menyimpannya.';
    $Self->{Translation}->{'A temporary change will be created which contains the workorder.'} =
        'Perubahan sementara akan diwujudkan yang mengandungi aturan kerja itu.';
    $Self->{Translation}->{'The temporary change and new workorder will be deleted automatically after the workorder has been saved as template.'} =
        'Perubahan sementara dan aturan kerja baharu akan dipadam secara automatik selepas aturan kerja telah disimpan sebagai templat.';
    $Self->{Translation}->{'Do you want to proceed?'} = 'Adakah anda ingin meneruskan?';

    # Template: AgentITSMTemplateOverviewSmall
    $Self->{Translation}->{'Template ID'} = '';
    $Self->{Translation}->{'Edit Content'} = 'Mengubah kandungan';
    $Self->{Translation}->{'Create by'} = '';
    $Self->{Translation}->{'Change by'} = '';
    $Self->{Translation}->{'Change Time'} = '';

    # Template: AgentITSMWorkOrderAdd
    $Self->{Translation}->{'Add Workorder to %s%s'} = '';
    $Self->{Translation}->{'Instruction'} = 'Arahan';
    $Self->{Translation}->{'Invalid workorder type.'} = 'Kerja tidak sah mengikut pesanan';
    $Self->{Translation}->{'The planned start time must be before the planned end time!'} = 'Masa mula dirancang mestilah sebelum masa akhir dirancang!';
    $Self->{Translation}->{'Invalid format.'} = 'format tidak sah.';

    # Template: AgentITSMWorkOrderAddFromTemplate
    $Self->{Translation}->{'Select Workorder Template'} = 'Pilih Templat Perintah Kerja';

    # Template: AgentITSMWorkOrderAgent
    $Self->{Translation}->{'Edit Workorder Agent of %s%s'} = '';

    # Template: AgentITSMWorkOrderDelete
    $Self->{Translation}->{'Do you really want to delete this workorder?'} = 'Adakah anda benar-benar ingin memadam ini perintah kerja?';
    $Self->{Translation}->{'You can not delete this Workorder. It is used in at least one Condition!'} =
        'Anda tidak boleh memadam ini Tata Kerja. Ia digunakan dalam sekurang-kurangnya satu Keadaan!';
    $Self->{Translation}->{'This Workorder is used in the following Condition(s)'} = 'Perintah Kerja digunakan dalam Syarat-syarat berikut';

    # Template: AgentITSMWorkOrderEdit
    $Self->{Translation}->{'Edit %s%s-%s'} = '';
    $Self->{Translation}->{'Move following workorders accordingly'} = 'Gerakkan aturan-aturan kerja sewajarnya';
    $Self->{Translation}->{'If the planned end time of this workorder is changed, the planned start times of all following workorders will be changed accordingly'} =
        'Jika masa akhir yang dirancang untuk aturan kerja ini berubah, zaman permulaan yang dirancang semua aturan kerja berikutnya akan berubah sewajarnya';

    # Template: AgentITSMWorkOrderHistory
    $Self->{Translation}->{'History of %s%s-%s'} = '';

    # Template: AgentITSMWorkOrderReport
    $Self->{Translation}->{'Edit Report of %s%s-%s'} = '';
    $Self->{Translation}->{'Report'} = 'Laporan';
    $Self->{Translation}->{'The actual start time must be before the actual end time!'} = 'Masa mula sebenar mesti sebelum masa akhir sebenar!';
    $Self->{Translation}->{'The actual start time must be set, when the actual end time is set!'} =
        'Masa mula sebenar mesti ditetapkan, apabila akhir zaman sebenar ditetapkan!';

    # Template: AgentITSMWorkOrderTake
    $Self->{Translation}->{'Current Agent'} = 'Agen semasa';
    $Self->{Translation}->{'Do you really want to take this workorder?'} = 'Adakah anda benar-benar mahu mengambil perintah kerja?';

    # Template: AgentITSMWorkOrderTemplate
    $Self->{Translation}->{'Save Workorder as Template'} = 'Simpan Perintah Kerja sebagai Templat';
    $Self->{Translation}->{'Delete original workorder (and surrounding change)'} = 'Padam aturan kerja asal (dan perubahan sekeliling)';

    # Template: AgentITSMWorkOrderZoom
    $Self->{Translation}->{'Workorder Information'} = 'Informasi Perintah Kerja';

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
    $Self->{Translation}->{'No %s is given!'} = 'Tiada %s diberikan!';
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
    $Self->{Translation}->{'ITSM Workorder'} = 'Perintah Kerja';
    $Self->{Translation}->{'WorkOrderNumber'} = 'Nombor UrutanKerja';
    $Self->{Translation}->{'WorkOrderTitle'} = 'Tajuk Kerja Perintah';
    $Self->{Translation}->{'unknown workorder title'} = '';
    $Self->{Translation}->{'ChangeState'} = 'Ubah Status';
    $Self->{Translation}->{'PlannedEffort'} = 'Usaha yang dirancang';
    $Self->{Translation}->{'CAB Agents'} = '';
    $Self->{Translation}->{'CAB Customers'} = '';
    $Self->{Translation}->{'RequestedTime'} = 'MasaYangDiminta';
    $Self->{Translation}->{'PlannedStartTime'} = 'Rancang Masa Mula';
    $Self->{Translation}->{'PlannedEndTime'} = 'Rancang Masa Tamat';
    $Self->{Translation}->{'ActualStartTime'} = 'Masa Mula Sebenar';
    $Self->{Translation}->{'ActualEndTime'} = 'Masa Tamat Sebenar';
    $Self->{Translation}->{'ChangeTime'} = 'UbahMasa';
    $Self->{Translation}->{'ChangeNumber'} = 'Ubah Nombor';
    $Self->{Translation}->{'WorkOrderState'} = 'Status Perintah Kerja';
    $Self->{Translation}->{'WorkOrderType'} = 'Jenis Perintah Kerja';
    $Self->{Translation}->{'WorkOrderAgent'} = 'Ejen Perintah kerja';
    $Self->{Translation}->{'ITSM Workorder Overview (%s)'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeReset.pm
    $Self->{Translation}->{'Was not able to reset WorkOrder %s of Change %s!'} = '';
    $Self->{Translation}->{'Was not able to reset Change %s!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeSchedule.pm
    $Self->{Translation}->{'Overview: Change Schedule'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChangeSearch.pm
    $Self->{Translation}->{'Change Search'} = '';
    $Self->{Translation}->{'ChangeTitle'} = 'Ubah tajuk';
    $Self->{Translation}->{'WorkOrders'} = 'Perintah Kerja';
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
    $Self->{Translation}->{'No config option found for the view "%s"!'} = 'Tiada pilihan config dijumpai untuk pandangan "%s"!';
    $Self->{Translation}->{'Title: %s | Type: %s'} = '';

    # Perl Module: Kernel/Output/HTML/ToolBar/MyCAB.pm
    $Self->{Translation}->{'My CABs'} = 'CAB Saya';

    # Perl Module: Kernel/Output/HTML/ToolBar/MyChanges.pm
    $Self->{Translation}->{'My Changes'} = 'Perubahan Saya';

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
    $Self->{Translation}->{'all'} = 'semua';
    $Self->{Translation}->{'any'} = 'pelbagai';

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
    $Self->{Translation}->{'requested'} = 'diminta';
    $Self->{Translation}->{'pending approval'} = 'pengesahan tergantung';
    $Self->{Translation}->{'rejected'} = 'ditolak';
    $Self->{Translation}->{'approved'} = 'Disahkan';
    $Self->{Translation}->{'in progress'} = 'dalam proses';
    $Self->{Translation}->{'pending pir'} = 'PIR tergantung';
    $Self->{Translation}->{'successful'} = 'berjaya';
    $Self->{Translation}->{'failed'} = 'digagalkan';
    $Self->{Translation}->{'canceled'} = 'dibatalkan';
    $Self->{Translation}->{'retracted'} = 'ditarik balik';
    $Self->{Translation}->{'created'} = 'dicipta';
    $Self->{Translation}->{'accepted'} = 'Diterima';
    $Self->{Translation}->{'ready'} = 'sedia';
    $Self->{Translation}->{'approval'} = 'Pengesahan';
    $Self->{Translation}->{'workorder'} = 'urutankerja';
    $Self->{Translation}->{'backout'} = 'menarikdiri';
    $Self->{Translation}->{'decision'} = 'keputusan';
    $Self->{Translation}->{'pir'} = 'PIR (Post Implementation Review)';
    $Self->{Translation}->{'ChangeStateID'} = '';
    $Self->{Translation}->{'CategoryID'} = '';
    $Self->{Translation}->{'ImpactID'} = '';
    $Self->{Translation}->{'PriorityID'} = '';
    $Self->{Translation}->{'ChangeManagerID'} = '';
    $Self->{Translation}->{'ChangeBuilderID'} = '';
    $Self->{Translation}->{'WorkOrderStateID'} = '';
    $Self->{Translation}->{'WorkOrderTypeID'} = '';
    $Self->{Translation}->{'WorkOrderAgentID'} = '';
    $Self->{Translation}->{'is'} = 'ialah';
    $Self->{Translation}->{'is not'} = 'ialah tidak';
    $Self->{Translation}->{'is empty'} = 'ialah kosong';
    $Self->{Translation}->{'is not empty'} = 'ialah tidak kosong';
    $Self->{Translation}->{'is greater than'} = 'ialah lebih besar daripada';
    $Self->{Translation}->{'is less than'} = 'ialah kurang daripada';
    $Self->{Translation}->{'is before'} = 'ialah sebelum';
    $Self->{Translation}->{'is after'} = 'ialah selepas';
    $Self->{Translation}->{'contains'} = 'mengandungi';
    $Self->{Translation}->{'not contains'} = 'tidak mengandungi';
    $Self->{Translation}->{'begins with'} = 'bermula dengan';
    $Self->{Translation}->{'ends with'} = 'tamat dengan';
    $Self->{Translation}->{'set'} = 'set';

    # JS File: ITSM.Agent.ChangeManagement.Condition
    $Self->{Translation}->{'Do you really want to delete this expression?'} = '';
    $Self->{Translation}->{'Do you really want to delete this action?'} = '';
    $Self->{Translation}->{'Do you really want to delete this condition?'} = '';

    # JS File: ITSM.Agent.ChangeManagement.ConfirmDialog
    $Self->{Translation}->{'Ok'} = 'Ok';

    # SysConfig
    $Self->{Translation}->{'A list of the agents who have permission to take workorders. Key is a login name. Content is 0 or 1.'} =
        'Satu senarai agen yang mempunyai kebenaran untuk mengambil pesanan kerja. Utama adalah nama log masuk. Kandungan adalah 0 atau 1';
    $Self->{Translation}->{'A list of workorder states, at which the ActualStartTime of a workorder will be set if it was empty at this point.'} =
        'Satu senarai status pesanan kerja, di mana Masa Mula sebenar perintah kerja akan ditetapkan jika ia adalah kosong pada ketika ini.';
    $Self->{Translation}->{'Actual end time'} = '';
    $Self->{Translation}->{'Actual start time'} = '';
    $Self->{Translation}->{'Add Workorder'} = 'Tambah Urutankerja';
    $Self->{Translation}->{'Add Workorder (from Template)'} = '';
    $Self->{Translation}->{'Add a change from template.'} = '';
    $Self->{Translation}->{'Add a change.'} = '';
    $Self->{Translation}->{'Add a workorder (from template) to the change.'} = '';
    $Self->{Translation}->{'Add a workorder to the change.'} = '';
    $Self->{Translation}->{'Add from template'} = 'Tambah daripada templat';
    $Self->{Translation}->{'Admin of the CIP matrix.'} = 'Admin matriks CIP.';
    $Self->{Translation}->{'Admin of the state machine.'} = 'Admin jentera kerajaan.';
    $Self->{Translation}->{'Agent interface notification module to see the number of change advisory boards.'} =
        'Agen antara muka modul pemberitahuan untuk melihat bilangan menukar lembaga penasihat.';
    $Self->{Translation}->{'Agent interface notification module to see the number of changes managed by the user.'} =
        'Agen antara muka modul pemberitahuan untuk melihat beberapa perubahan yang diuruskan oleh pengguna.';
    $Self->{Translation}->{'Agent interface notification module to see the number of changes.'} =
        'Agen antara muka modul pemberitahuan untuk melihat beberapa perubahan.';
    $Self->{Translation}->{'Agent interface notification module to see the number of workorders.'} =
        '';
    $Self->{Translation}->{'CAB Member Search'} = '';
    $Self->{Translation}->{'Cache time in minutes for the change management toolbars. Default: 3 hours (180 minutes).'} =
        'Waktu cache dalam minit untuk bar alat pengurusan change. Lalai: 3 jam (180 minit).';
    $Self->{Translation}->{'Cache time in minutes for the change management. Default: 5 days (7200 minutes).'} =
        'Waktu cache dalam minit untuk pengurusan change. Lalai: 5 hari (7200 minit).';
    $Self->{Translation}->{'Change CAB Templates'} = '';
    $Self->{Translation}->{'Change History.'} = '';
    $Self->{Translation}->{'Change Involved Persons.'} = '';
    $Self->{Translation}->{'Change Overview "Small" Limit'} = 'Tinjauan Change Had "Kecil"';
    $Self->{Translation}->{'Change Overview.'} = '';
    $Self->{Translation}->{'Change Print.'} = '';
    $Self->{Translation}->{'Change Schedule'} = 'Ubah Jadual';
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
    $Self->{Translation}->{'Change search backend router of the agent interface.'} = 'Tukar router carian backend antara muka ejen.';
    $Self->{Translation}->{'Change state'} = '';
    $Self->{Translation}->{'Change time'} = '';
    $Self->{Translation}->{'Change title'} = '';
    $Self->{Translation}->{'Condition Edit'} = 'Audit Syarat';
    $Self->{Translation}->{'Condition Overview'} = '';
    $Self->{Translation}->{'Configure which screen should be shown after a new workorder has been created.'} =
        '';
    $Self->{Translation}->{'Configures how often the notifications are sent when planned the start time or other time values have been reached/passed.'} =
        'Dikonfigurasi berapa kerap pemberitahuan akan dihantar apabila merancang masa mula atau nilai masa lain telah mencapai / diluluskan.';
    $Self->{Translation}->{'Create Change'} = 'Cipta Ubah';
    $Self->{Translation}->{'Create Change (from Template)'} = '';
    $Self->{Translation}->{'Create a change (from template) from this ticket.'} = '';
    $Self->{Translation}->{'Create a change from this ticket.'} = '';
    $Self->{Translation}->{'Create and manage ITSM Change Management notifications.'} = '';
    $Self->{Translation}->{'Create and manage change notifications.'} = '';
    $Self->{Translation}->{'Default type for a workorder. This entry must exist in general catalog class \'ITSM::ChangeManagement::WorkOrder::Type\'.'} =
        'Jenis lalai untuk perintah kerja. Entri ini mesti wujud di dalam kelas katalog am \'ITSM::Pengurusan Perubahan::Perintah Kerja::Jenis\'.';
    $Self->{Translation}->{'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js and Core.Agent.LinkObject.js.'} =
        'Takrifkan Tindakan dimana butang tetapan itu ada dalam widget objek bersambung (LinkObject::ViewMode = "complex"). Sila pastikan yang Tindakan ini perlu didaftarkan yang berikut fail-fail JS dan CSS: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js and Core.Agent.LinkObject.js.';
    $Self->{Translation}->{'Define the signals for each workorder state.'} = 'Tentukan isyarat untuk setiap keadaan perintah kerja.';
    $Self->{Translation}->{'Define which columns are shown in the linked Changes widget (LinkObject::ViewMode = "complex"). Note: Only Change attributes are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.'} =
        '';
    $Self->{Translation}->{'Define which columns are shown in the linked Workorder widget (LinkObject::ViewMode = "complex"). Note: Only Workorder attributes are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.'} =
        '';
    $Self->{Translation}->{'Defines an overview module to show the small view of a change list.'} =
        'Mentakrifkan modul gambaran untuk menunjukkan pandangan yang kecil senarai perubahan.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a template list.'} =
        'Mentakrifkan modul gambaran untuk menunjukkan pandangan yang kecil senarai templat.';
    $Self->{Translation}->{'Defines if it will be possible to print the accounted time.'} = 'Mentakrifkan jika ia akan menjadi mustahil untuk mencetak masa yang diambilkira';
    $Self->{Translation}->{'Defines if it will be possible to print the planned effort.'} = 'Mentakrifkan jika ia akan menjadi mustahil untuk mencetak usaha yang dirancang.';
    $Self->{Translation}->{'Defines if reachable (as defined by the state machine) change end states should be allowed if a change is in a locked state.'} =
        'Mentakrifkan jika dapat dihubungi (seperti yang ditakrifkan oleh keadaan mesin) keadaan change akhir harus dibenarkan jika change berada dalam keadaan yang berkunci.';
    $Self->{Translation}->{'Defines if reachable (as defined by the state machine) workorder end states should be allowed if a workorder is in a locked state.'} =
        'Mentakrifkan jika dapat dihubungi (seperti yang ditakrifkan oleh keadaan mesin) urutankerja keadaan change akhir harus dibenarkan jika urutankerja berada dalam keadaan yang berkunci.';
    $Self->{Translation}->{'Defines if the accounted time should be shown.'} = 'Mentakrifkan jika masa yang diambil kira hendaklah ditunjukkan.';
    $Self->{Translation}->{'Defines if the actual start and end times should be set.'} = 'Mentakrifkan jika permulaan sebenar dan akhir zaman harus ditetapkan.';
    $Self->{Translation}->{'Defines if the change search and the workorder search functions could use the mirror DB.'} =
        'Mentakrifkan jika carian change dan urutankerja carian fungsi boleh menggunakan cermin DB.';
    $Self->{Translation}->{'Defines if the change state can be set in the change edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines if the planned effort should be shown.'} = 'Mentakrifkan jika usaha yang dirancang hendaklah ditunjukkan.';
    $Self->{Translation}->{'Defines if the requested date should be print by customer.'} = 'Mentakrifkan jika tarikh yang diminta harus cetak oleh pelanggan';
    $Self->{Translation}->{'Defines if the requested date should be searched by customer.'} =
        'Mentakrifkan jika tarikh yang diminta perlu dicari oleh pelanggan.';
    $Self->{Translation}->{'Defines if the requested date should be set by customer.'} = 'Mentakrifkan jika tarikh yang diminta hendaklah ditetapkan oleh pelanggan';
    $Self->{Translation}->{'Defines if the requested date should be shown by customer.'} = 'Mentakrifkan jika tarikh yang diminta hendaklah ditunjukkan oleh pelanggan.';
    $Self->{Translation}->{'Defines if the workorder state should be shown.'} = 'Mentakrifkan jika keadaan perintah kerja hendaklah ditunjukkan.';
    $Self->{Translation}->{'Defines if the workorder title should be shown.'} = 'Mentakrifkan jika tajuk perintah kerja hendaklah ditunjukkan.';
    $Self->{Translation}->{'Defines shown graph attributes.'} = 'Mentakrifkan ciri-ciri graf ditunjukkan.';
    $Self->{Translation}->{'Defines that only changes containing Workorders linked with services, which the customer user has permission to use will be shown. Any other changes will not be displayed.'} =
        'Mentakrifkan bahawa perubahan hanya mengandungi Workorders dikaitkan dengan perkhidmatan, pengguna pelanggan yang mempunyai kebenaran untuk menggunakan akan ditunjukkan. Sebarang perubahan lain tidak akan dipaparkan.';
    $Self->{Translation}->{'Defines the change states that will be allowed to delete.'} = 'Mentakrifkan keadaan change yang akan dibenarkan untuk memadam.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the Change PSA overview.'} =
        'Mentakrifkan keadaan perubahan yang akan digunakan sebagai penapis dalam gambaran PSA Perubahan.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the Change Schedule overview.'} =
        'Mentakrifkan keadaan perubahan yang akan digunakan sebagai penapis dalam gambaran Jadual Perubahan.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the MyCAB overview.'} =
        'Mentakrifkan keadaan perubahan yang akan digunakan sebagai penapis dalam gambaran MyCAB.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the MyChanges overview.'} =
        'Mentakrifkan keadaan perubahan yang akan digunakan sebagai penapis dalam gambaran MyChanges.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the change manager overview.'} =
        'Mentakrifkan keadaan perubahan yang akan digunakan sebagai penapis dalam gambaran pengurus perubahan.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the change overview.'} =
        'Mentakrifkan keadaan perubahan yang akan digunakan sebagai penapis dalam gambaran perubahan.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the customer change schedule overview.'} =
        'Mentakrifkan negeri perubahan yang akan digunakan sebagai penapis dalam perubahan jadual gambaran keseluruhan pelanggan.';
    $Self->{Translation}->{'Defines the default change title for a dummy change which is needed to edit a workorder template.'} =
        'Mentakrifkan tajuk perubahan lalai untuk perubahan dummy yang diperlukan untuk mengedit templat UrutanKerja.';
    $Self->{Translation}->{'Defines the default sort criteria in the change PSA overview.'} =
        'Mentakrifkan kriteria jenis lalai dalam gambaran keseluruhan PSA perubahan.';
    $Self->{Translation}->{'Defines the default sort criteria in the change manager overview.'} =
        'Mentakrifkan kriteria jenis lalai dalam gambaran pengurus perubahan.';
    $Self->{Translation}->{'Defines the default sort criteria in the change overview.'} = 'Mentakrifkan kriteria apapun lalai dalam gambaran perubahan.';
    $Self->{Translation}->{'Defines the default sort criteria in the change schedule overview.'} =
        'SMentakrifkan kriteria jenis lalai dalam gambaran keseluruhan jadual perubahan.';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the MyCAB overview.'} =
        'Mentakrifkan kriteria jenis lalai perubahan dalam gambaran MyCAB.';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the MyChanges overview.'} =
        'Mentakrifkan kriteria jenis lalai perubahan dalam gambaran MyChanges.';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the MyWorkorders overview.'} =
        'Mentakrifkan kriteria jenis lalai perubahan dalam gambaran keseluruhan pesanan Kerja.';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the PIR overview.'} =
        'Mentakrifkan kriteria jenis lalai perubahan dalam gambaran PIR.';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the customer change schedule overview.'} =
        'Mentakrifkan kriteria apapun lalai perubahan dalam perubahan jadual gambaran keseluruhan pelanggan.';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the template overview.'} =
        'Mentakrifkan kriteria jenis lalai perubahan dalam gambaran templat.';
    $Self->{Translation}->{'Defines the default sort order in the MyCAB overview.'} = 'Mentakrifkan perintah lalai apapun dalam gambaran MyCAB.';
    $Self->{Translation}->{'Defines the default sort order in the MyChanges overview.'} = 'Mentakrifkan perintah lalai apapun dalam gambaran MyChanges.';
    $Self->{Translation}->{'Defines the default sort order in the MyWorkorders overview.'} =
        'Mentakrifkan perintah lalai apapun dalam gambaran keseluruhan pesanan Kerja.';
    $Self->{Translation}->{'Defines the default sort order in the PIR overview.'} = 'Mentakrifkan perintah lalai apapun dalam gambaran PIR.';
    $Self->{Translation}->{'Defines the default sort order in the change PSA overview.'} = 'Mentakrifkan perintah lalai jenis gambaran perubahan PSA.';
    $Self->{Translation}->{'Defines the default sort order in the change manager overview.'} =
        'Mentakrifkan perintah lalai jenis dalam gambaran pengurus perubahan.';
    $Self->{Translation}->{'Defines the default sort order in the change overview.'} = 'Mentakrifkan perintah lalai apapun dalam gambaran perubahan.';
    $Self->{Translation}->{'Defines the default sort order in the change schedule overview.'} =
        'Mentakrifkan perintah lalai jenis dalam gambaran keseluruhan jadual perubahan.';
    $Self->{Translation}->{'Defines the default sort order in the customer change schedule overview.'} =
        'Mentakrifkan perintah lalai apapun dalam perubahan jadual gambaran keseluruhan pelanggan.';
    $Self->{Translation}->{'Defines the default sort order in the template overview.'} = 'Mentakrifkan perintah lalai apapun dalam gambaran template.';
    $Self->{Translation}->{'Defines the default value for the category of a change.'} = 'Mentakrifkan nilai lalai bagi kategori perubahan.';
    $Self->{Translation}->{'Defines the default value for the impact of a change.'} = 'Mentakrifkan nilai lalai bagi kesan perubahan.';
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
        'Mentakrifkan tempoh (dalam tahun), di mana mula dan akhir kali boleh dipilih.';
    $Self->{Translation}->{'Defines the shown attributes of a workorder in the tooltip of the workorder graph in the change zoom. To show workorder dynamic fields in the tooltip, they must be specified like DynamicField_WorkOrderFieldName1, DynamicField_WorkOrderFieldName2, etc.'} =
        'Mentakrifkan sifat-sifat yang ditunjukkan daripada UrutanKerja dalam tooltip graf UrutanKerja di zum perubahan. Untuk menunjukkan medan dinamik UrutanKerja dalam tooltip , mereka mesti dinyatakan seperti MedanDinamik_UrutanKerjaNama1, MedanDinamik_UrutanKerjaNama2, dan lain-lain.';
    $Self->{Translation}->{'Defines the shown columns in the Change PSA overview. This option has no effect on the position of the column.'} =
        'Mentakrifkan lajur menunjukkan gambaran PSA Perubahan. Pilihan ini tidak mempunyai kesan ke atas kedudukan tiang.';
    $Self->{Translation}->{'Defines the shown columns in the Change Schedule overview. This option has no effect on the position of the column.'} =
        'Mentakrifkan lajur menunjukkan dalam gambaran Jadual Perubahan. Pilihan ini tidak mempunyai kesan ke atas kedudukan tiang.';
    $Self->{Translation}->{'Defines the shown columns in the MyCAB overview. This option has no effect on the position of the column.'} =
        'Mentakrifkan ruangan menunjukkan dalam gambaran MyCAB. Pilihan ini tidak mempunyai kesan ke atas kedudukan tiang.';
    $Self->{Translation}->{'Defines the shown columns in the MyChanges overview. This option has no effect on the position of the column.'} =
        'Mentakrifkan ruangan yang ditunjukkan dalam gambaran MyChanges. Pilihan ini tidak mempunyai kesan ke atas kedudukan tiang.';
    $Self->{Translation}->{'Defines the shown columns in the MyWorkorders overview. This option has no effect on the position of the column.'} =
        'Mentakrifkan lajur menunjukkan gambaran keseluruhan Pesanan Kerja Saya. Pilihan ini tidak mempunyai kesan ke atas kedudukan tiang.';
    $Self->{Translation}->{'Defines the shown columns in the PIR overview. This option has no effect on the position of the column.'} =
        'Mentakrifkan ruangan yang ditunjukkan dalam gambaran PIR. Pilihan ini tidak mempunyai kesan ke atas kedudukan tiang.';
    $Self->{Translation}->{'Defines the shown columns in the change manager overview. This option has no effect on the position of the column.'} =
        'Mentakrifkan ruangan yang ditunjukkan dalam gambaran keseluruhan pengurus perubahan. Pilihan ini tidak mempunyai kesan ke atas kedudukan tiang.';
    $Self->{Translation}->{'Defines the shown columns in the change overview. This option has no effect on the position of the column.'} =
        'Mentakrifkan ruangan yang ditunjukkan dalam gambaran perubahan. Pilihan ini tidak mempunyai kesan ke atas kedudukan tiang.';
    $Self->{Translation}->{'Defines the shown columns in the change search. This option has no effect on the position of the column.'} =
        'Mentakrifkan ruangan yang ditunjukkan dalam carian perubahan. Pilihan ini tidak mempunyai kesan ke atas kedudukan tiang.';
    $Self->{Translation}->{'Defines the shown columns in the customer change schedule overview. This option has no effect on the position of the column.'} =
        'Mentakrifkan ruangan yang ditunjukkan dalam perubahan jadual gambaran keseluruhan pelanggan. Pilihan ini tidak mempunyai kesan ke atas kedudukan tiang.';
    $Self->{Translation}->{'Defines the shown columns in the template overview. This option has no effect on the position of the column.'} =
        'Mentakrifkan ruangan yang ditunjukkan dalam gambaran template. Pilihan ini tidak mempunyai kesan ke atas kedudukan tiang.';
    $Self->{Translation}->{'Defines the signals for each ITSM change state.'} = '';
    $Self->{Translation}->{'Defines the template types that will be used as filters in the template overview.'} =
        'Mentakrifkan jenis template yang akan digunakan sebagai penapis dalam gambaran template.';
    $Self->{Translation}->{'Defines the workorder states that will be used as filters in the MyWorkorders overview.'} =
        'Mentakrifkan status kerja perintah yang akan digunakan sebagai penapis dalam gambaran keseluruhan Kerja pesanan saya.';
    $Self->{Translation}->{'Defines the workorder states that will be used as filters in the PIR overview.'} =
        'Mentakrifkan status kerja perintah yang akan digunakan sebagai penapis dalam gambaran PIR.';
    $Self->{Translation}->{'Defines the workorder types that will be used to show the PIR overview.'} =
        'Mentakrifkan jenis perintah kerja yang akan digunakan untuk menunjukkan gambaran PIR.';
    $Self->{Translation}->{'Defines whether notifications should be sent.'} = 'Mentakrifkan sama ada pemberitahuan hendaklah dihantar.';
    $Self->{Translation}->{'Delete a change.'} = '';
    $Self->{Translation}->{'Delete the change.'} = '';
    $Self->{Translation}->{'Delete the workorder.'} = '';
    $Self->{Translation}->{'Details of a change history entry.'} = '';
    $Self->{Translation}->{'Determines if an agent can exchange the X-axis of a stat if he generates one.'} =
        'Menentukan jika ejen boleh bertukar-tukar X-paksi bintang jika dia menjana.';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes done for config item classes.'} =
        'Menentukan jika modul statistik biasa boleh menjana statistik tentang perubahan yang dilakukan bagi kelas item config.';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes regarding change state updates within a timeperiod.'} =
        'Menentukan jika modul statistik biasa boleh menjana statistik tentang perubahan mengenai kemaskini negeri perubahan dalam tempoh masa yang.';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes regarding the relation between changes and incident tickets.'} =
        'Menentukan jika modul statistik biasa boleh menjana statistik mengenai perubahan mengenai hubungan antara perubahan dan tiket kejadian.';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes.'} =
        'Menentukan jika modul statistik biasa boleh menjana statistik mengenai perubahan.';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about the number of Rfc tickets a requester created.'} =
        'Menentukan jika modul statistik biasa boleh menjana statistik mengenai bilangan tiket RFC peminta dicipta.';
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
        'Modul acara MedanDinamik untuk mengendalikan maklumat keadaan jika medan dinamik ditambah, dikemaskini atau dihapuskan.';
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
    $Self->{Translation}->{'ITSM event module that cleans up conditions.'} = 'ITSM modul peristiwa yang membersihkan sehingga keadaan.';
    $Self->{Translation}->{'ITSM event module that deletes the cache for a toolbar.'} = 'ITSM modul peristiwa yang memadam cache untuk toolbar.';
    $Self->{Translation}->{'ITSM event module that deletes the history of changes.'} = '';
    $Self->{Translation}->{'ITSM event module that matches conditions and executes actions.'} =
        'ITSM modul acara yang sepadan dengan keadaan dan melaksanakan tindakan.';
    $Self->{Translation}->{'ITSM event module that sends notifications.'} = 'ITSM modul acara yang menghantar pemberitahuan.';
    $Self->{Translation}->{'ITSM event module that updates the history of changes.'} = 'ITSM modul peristiwa yang mengemaskini sejarah perubahan.';
    $Self->{Translation}->{'ITSM event module that updates the history of conditions.'} = '';
    $Self->{Translation}->{'ITSM event module that updates the history of workorders.'} = '';
    $Self->{Translation}->{'ITSM event module to recalculate the workorder numbers.'} = 'ITSM modul acara untuk mengira nombor pesanan kerja.';
    $Self->{Translation}->{'ITSM event module to set the actual start and end times of workorders.'} =
        'ITSM modul acara untuk menetapkan permulaan sebenar dan masa akhir pesanan kerja.';
    $Self->{Translation}->{'ITSMChange'} = 'ITSMUChange';
    $Self->{Translation}->{'ITSMWorkOrder'} = 'ITSMUrutanKerja';
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
        'Modul untuk memeriksa jika WorkOrderAdd atau WorkOrderAddFromTemplate harus dibenarkan .';
    $Self->{Translation}->{'Module to check the CAB members.'} = 'Modul untuk memeriksa ahli CAB.';
    $Self->{Translation}->{'Module to check the agent.'} = 'Modul untuk memeriksa ejen.';
    $Self->{Translation}->{'Module to check the change builder.'} = 'Modul untuk memeriksa pembina perubahan.';
    $Self->{Translation}->{'Module to check the change manager.'} = 'Modul untuk memeriksa pengurus perubahan.';
    $Self->{Translation}->{'Module to check the workorder agent.'} = 'Modul untuk memeriksa pesanan kerja ejen.';
    $Self->{Translation}->{'Module to check whether no workorder agent is set.'} = 'Modul untuk memeriksa sama ada tiada ejen kerja perintah ditetapkan.';
    $Self->{Translation}->{'Module to check whether the agent is contained in the configured list.'} =
        'Modul untuk memeriksa sama ada ejen itu terkandung dalam senarai dikonfigurasikan.';
    $Self->{Translation}->{'Module to show a link to create a change from this ticket. The ticket will be automatically linked with the new change.'} =
        'Modul untuk menunjukkan pautan untuk membuat perubahan dari tiket ini. Tiket akan secara automatik dikaitkan dengan perubahan baru.';
    $Self->{Translation}->{'Move Time Slot.'} = '';
    $Self->{Translation}->{'Move all workorders in time.'} = '';
    $Self->{Translation}->{'New (from template)'} = 'Baru (daripada templat)';
    $Self->{Translation}->{'Only users of these groups have the permission to use the ticket types as defined in "ITSMChange::AddChangeLinkTicketTypes" if the feature "Ticket::Acl::Module###200-Ticket::Acl::Module" is enabled.'} =
        'Hanya pengguna kumpulan-kumpulan ini mempunyai kebenaran untuk menggunakan jenis tiket seperti yang ditakrifkan dalam "ITSMChange :: AddChangeLinkTicketTypes" jika ciri "Tiket :: ACL :: Modul # # # 200-Tiket :: ACL :: Modul" diaktifkan.';
    $Self->{Translation}->{'Other Settings'} = 'Aturan Lain';
    $Self->{Translation}->{'Overview over all Changes.'} = '';
    $Self->{Translation}->{'PIR'} = '';
    $Self->{Translation}->{'PIR (Post Implementation Review)'} = 'PIR (Post Implementation Review)';
    $Self->{Translation}->{'PSA'} = '';
    $Self->{Translation}->{'Parameters for the UserCreateWorkOrderNextMask object in the preference view of the agent interface.'} =
        'Parameter untuk objek UserCreateWorkOrderNextMask dalam pandangan keutamaan bagi antara muka ejen.';
    $Self->{Translation}->{'Parameters for the pages (in which the changes are shown) of the small change overview.'} =
        'Parameter untuk halaman (di mana perubahan ditunjukkan) gambaran perubahan kecil.';
    $Self->{Translation}->{'Performs the configured action for each event (as an Invoker) for each configured Webservice.'} =
        'Melakukan tindakan yang telah dikonfigurasi untuk setiap acara (sebagai pencetus) untuk setiap Webservice yang telah dikonfigurasi.';
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
        'Keistimewaan Diperlukan dalam usaha untuk ejen untuk mengambil perintah kerja.';
    $Self->{Translation}->{'Required privileges to access the overview of all changes.'} = 'Keistimewaan yang diperlukan untuk mengakses gambaran keseluruhan semua perubahan.';
    $Self->{Translation}->{'Required privileges to add a workorder.'} = 'Keistimewaan yang diperlukan untuk menambah perintah kerja.';
    $Self->{Translation}->{'Required privileges to change the workorder agent.'} = 'Keistimewaan yang diperlukan untuk menukar pesanan kerja ejen.';
    $Self->{Translation}->{'Required privileges to create a template from a change.'} = 'Keistimewaan yang diperlukan untuk mewujudkan template dari perubahan.';
    $Self->{Translation}->{'Required privileges to create a template from a changes\' CAB.'} =
        'Keistimewaan yang diperlukan untuk membuat template dari perubahan CAB.';
    $Self->{Translation}->{'Required privileges to create a template from a workorder.'} = 'Keistimewaan yang diperlukan untuk membuat template dari perintah kerja.';
    $Self->{Translation}->{'Required privileges to create changes from templates.'} = 'Keistimewaan yang diperlukan untuk membuat perubahan dari templat.';
    $Self->{Translation}->{'Required privileges to create changes.'} = 'Keistimewaan yang diperlukan untuk mencipta perubahan.';
    $Self->{Translation}->{'Required privileges to delete a template.'} = 'Keistimewaan yang diperlukan untuk memadam template.';
    $Self->{Translation}->{'Required privileges to delete a workorder.'} = 'Keistimewaan yang diperlukan untuk memadam perintah kerja';
    $Self->{Translation}->{'Required privileges to delete changes.'} = 'Keistimewaan yang diperlukan untuk memadam perubahan.';
    $Self->{Translation}->{'Required privileges to edit a template.'} = 'Keistimewaan yang diperlukan untuk mengedit template.';
    $Self->{Translation}->{'Required privileges to edit a workorder.'} = 'Keistimewaan yang diperlukan untuk mengedit perintah kerja.';
    $Self->{Translation}->{'Required privileges to edit changes.'} = 'Keistimewaan yang diperlukan untuk mengedit perubahan.';
    $Self->{Translation}->{'Required privileges to edit the conditions of changes.'} = 'Keistimewaan yang diperlukan untuk mengedit syarat perubahan.';
    $Self->{Translation}->{'Required privileges to edit the content of a template.'} = 'Keistimewaan yang diperlukan untuk mengedit kandungan templat.';
    $Self->{Translation}->{'Required privileges to edit the involved persons of a change.'} =
        'Keistimewaan yang diperlukan untuk mengedit orang yang terlibat perubahan.';
    $Self->{Translation}->{'Required privileges to move changes in time.'} = 'Keistimewaan yang diperlukan untuk menggerakkan perubahan dalam masa..';
    $Self->{Translation}->{'Required privileges to print a change.'} = 'Keistimewaan yang diperlukan untuk mencetak perubahan';
    $Self->{Translation}->{'Required privileges to reset changes.'} = 'Keistimewaan yang diperlukan untuk menetapkan semula perubahan.';
    $Self->{Translation}->{'Required privileges to view a workorder.'} = 'Keistimewaan yang diperlukan untuk melihat perintah kerja.';
    $Self->{Translation}->{'Required privileges to view changes.'} = 'Keistimewaan yang diperlukan untuk melihat perubahan.';
    $Self->{Translation}->{'Required privileges to view list of changes where the user is a CAB member.'} =
        'Keistimewaan Diperlukan untuk melihat senarai perubahan di mana pengguna adalah ahli CAB.';
    $Self->{Translation}->{'Required privileges to view list of changes where the user is the change manager.'} =
        'Keistimewaan Diperlukan untuk melihat senarai perubahan di mana pengguna adalah pengurus perubahan.';
    $Self->{Translation}->{'Required privileges to view overview over all templates.'} = 'Keistimewaan yang diperlukan untuk melihat gambaran atas semua template.';
    $Self->{Translation}->{'Required privileges to view the conditions of changes.'} = 'Keistimewaan yang diperlukan untuk melihat keadaan perubahan.';
    $Self->{Translation}->{'Required privileges to view the history of a change.'} = 'Keistimewaan yang diperlukan untuk melihat sejarah perubahan.';
    $Self->{Translation}->{'Required privileges to view the history of a workorder.'} = 'Keistimewaan yang diperlukan untuk melihat sejarah perintah kerja.';
    $Self->{Translation}->{'Required privileges to view the history zoom of a change.'} = 'Keistimewaan yang diperlukan untuk melihat zum sejarah perubahan.';
    $Self->{Translation}->{'Required privileges to view the history zoom of a workorder.'} =
        'Keistimewaan yang diperlukan untuk melihat sejarah zoom perintah kerja.';
    $Self->{Translation}->{'Required privileges to view the list of Change Schedule.'} = 'Keistimewaan yang diperlukan untuk melihat senarai Jadual Perubahan.';
    $Self->{Translation}->{'Required privileges to view the list of change PSA.'} = 'Keistimewaan yang diperlukan untuk melihat senarai perubahan PSA.';
    $Self->{Translation}->{'Required privileges to view the list of changes with an upcoming PIR (Post Implementation Review).'} =
        'Keistimewaan yang diperlukan untuk melihat senarai perubahan dengan PIR akan datang (Post Implementation Review).';
    $Self->{Translation}->{'Required privileges to view the list of own changes.'} = 'Keistimewaan yang diperlukan untuk melihat senarai perubahan sendiri.';
    $Self->{Translation}->{'Required privileges to view the list of own workorders.'} = 'Keistimewaan yang diperlukan untuk melihat senarai pesanan kerja sendiri.';
    $Self->{Translation}->{'Required privileges to write a report for the workorder.'} = 'Keistimewaan yang diperlukan untuk menulis laporan untuk mendapatkan perintah kerja.';
    $Self->{Translation}->{'Reset a change and its workorders.'} = '';
    $Self->{Translation}->{'Reset change and its workorders.'} = '';
    $Self->{Translation}->{'Run task to check if specific times have been reached in changes and workorders.'} =
        '';
    $Self->{Translation}->{'Save change as a template.'} = '';
    $Self->{Translation}->{'Save workorder as a template.'} = '';
    $Self->{Translation}->{'Schedule'} = '';
    $Self->{Translation}->{'Screen after creating a workorder'} = 'Skrin selepas mencipta urutankerja.';
    $Self->{Translation}->{'Search Changes'} = 'Cari Perubahan';
    $Self->{Translation}->{'Search Changes.'} = '';
    $Self->{Translation}->{'Selects the change number generator module. "AutoIncrement" increments the change number, the SystemID and the counter are used with SystemID.counter format (e.g. 100118, 100119). With "Date", the change numbers will be generated by the current date and a counter; this format looks like Year.Month.Day.counter, e.g. 2010062400001, 2010062400002. With "DateChecksum", the counter will be appended as checksum to the string of date plus the SystemID. The checksum will be rotated on a daily basis. This format looks like Year.Month.Day.SystemID.Counter.CheckSum, e.g. 2010062410000017, 2010062410000026.'} =
        'Memilih modul beberapa perubahan penjana. "AutoIncrement" menambah nombor perubahan, SistemID dan kaunter digunakan dengan format SystemID.counter (contoh: 100118 , 100119 ). Dengan "Tarikh", nombor perubahan akan dijana oleh tarikh dan kaunter; format ini kelihatan seperti Year.Month.Day.counter; contohnya 2010062400001 , 2010062400002. Dengan "DateChecksum", kaunter itu akan ditambah sebagai checksum kepada rentetan Tarikh ditambah ID Sistem. Checksum ini akan berputar setiap hari. Format ini kelihatan seperti Year.Month.Day.SystemID.Counter.CheckSum, contohnya 2010062410000017 , 2010062410000026 .';
    $Self->{Translation}->{'Set the agent for the workorder.'} = '';
    $Self->{Translation}->{'Set the default height (in pixels) of inline HTML fields in the change zoom screen and workorder zoom screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Set the maximum height (in pixels) of inline HTML fields in the change zoom screen and workorder zoom screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Sets the minimal change counter size (if "AutoIncrement" was selected as ITSMChange::NumberGenerator). Default is 5, this means the counter starts from 10000.'} =
        'Set minimum saiz kaunter perubahan (jika "AutoIncrement" telah dipilih sebagai ITSMChange::NumberGenerator). Lalai adalah 5, ini bermakna kaunter bermula dari 10000.';
    $Self->{Translation}->{'Sets up the state machine for changes.'} = 'Set up jentera kerajaan untuk perubahan.';
    $Self->{Translation}->{'Sets up the state machine for workorders.'} = 'Set up jentera kerajaan untuk pesanan kerja.';
    $Self->{Translation}->{'Shows a checkbox in the workorder edit screen of the agent interface that defines if the the following workorders should also be moved if a workorder is modified and the planned end time has changed.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows changing the workorder agent, in the zoom view of the workorder of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows defining a change as a template in the zoom view of the change, in the agent interface.'} =
        'Menunjukkan pautan dalam menu yang membolehkan menentukan perubahan sebagai templat dalam paparan zum change, dalam antara muka ejen.';
    $Self->{Translation}->{'Shows a link in the menu that allows defining a workorder as a template in the zoom view of the workorder, in the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows editing the report of a workorder, in the zoom view of the workorder of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows linking a change with another object in the change zoom view of the agent interface.'} =
        'Menunjukkan pautan dalam menu yang membolehkan menghubungkan perubahan dengan objek lain dalam pandangan perubahan zum bagi antara muka ejen.';
    $Self->{Translation}->{'Shows a link in the menu that allows linking a workorder with another object in the zoom view of the workorder of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows moving the time slot of a change in its zoom view of the agent interface.'} =
        'Menunjukkan pautan dalam menu yang membolehkan pergerakan slot masa change dalam paparan zum antara muka ejen.';
    $Self->{Translation}->{'Shows a link in the menu that allows taking a workorder in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to access the conditions of a change in the its zoom view of the agent interface.'} =
        'Menunjukkan pautan dalam menu untuk masuk ke syarat-syarat perubahan dalam pandangan zum antara muka ejen.';
    $Self->{Translation}->{'Shows a link in the menu to access the history of a change in the its zoom view of the agent interface.'} =
        'Menunjukkan pautan dalam menu untuk masuk ke sejarah perubahan dalam pandangan zum antara muka ejen.';
    $Self->{Translation}->{'Shows a link in the menu to access the history of a workorder in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to add a workorder in the change zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to delete a change in its zoom view of the agent interface.'} =
        'Menunjukkan pautan dalam menu untuk memadam perubahan dalam pandangan zum antara muka ejen.';
    $Self->{Translation}->{'Shows a link in the menu to delete a workorder in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to edit a change in the its zoom view of the agent interface.'} =
        'Menunjukkan pautan dalam menu untuk mengedit perubahan dalam pandangan zum antara muka ejen.';
    $Self->{Translation}->{'Shows a link in the menu to edit a workorder in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to go back in the change zoom view of the agent interface.'} =
        'Menunjukkan pautan dalam menu untuk kembali dalam pandangan zum change bagi antara muka ejen.';
    $Self->{Translation}->{'Shows a link in the menu to go back in the workorder zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to print a change in the its zoom view of the agent interface.'} =
        'Menunjukkan pautan dalam menu untuk mencetak perubahan dalam pandangan zum antara muka ejen.';
    $Self->{Translation}->{'Shows a link in the menu to print a workorder in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to reset a change and its workorders in its zoom view of the agent interface.'} =
        'Menunjukkan pautan dalam menu untuk menetapkan semula perubahan dan urutankerja dalam pandangan zum antara muka ejen';
    $Self->{Translation}->{'Shows a link in the menu to show the involved persons in a change, in the zoom view of the change in the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows the change history (reverse ordered) in the agent interface.'} =
        'Tunjukkan sejarah change (perintah berbalik) dalam antara muka ejen.';
    $Self->{Translation}->{'State Machine'} = 'Keadaan Mesin';
    $Self->{Translation}->{'Stores change and workorder ids and their corresponding template id, while a user is editing a template.'} =
        'Simpan change dan urutankerja ids dan id templat sepadan, sementara pengguna mengedit templat.';
    $Self->{Translation}->{'Take Workorder'} = 'Ambil UrutanKerja';
    $Self->{Translation}->{'Take Workorder.'} = '';
    $Self->{Translation}->{'Take the workorder.'} = '';
    $Self->{Translation}->{'Template Overview'} = 'Lihat Semula Templat';
    $Self->{Translation}->{'Template type'} = '';
    $Self->{Translation}->{'Template.'} = '';
    $Self->{Translation}->{'The identifier for a change, e.g. Change#, MyChange#. The default is Change#.'} =
        'Pengecam untuk perubahan, i. Perubahan# Perubahan Saya#. Lalai adalah Perubahan#.';
    $Self->{Translation}->{'The identifier for a workorder, e.g. Workorder#, MyWorkorder#. The default is Workorder#.'} =
        'Pengecam untuk mendapatkan perintah kerja, misalnya Workorder# Workorder#. Lalai adalah Perintah Kerja#.';
    $Self->{Translation}->{'This ACL module restricts the usuage of the ticket types that are defined in the sysconfig option \'ITSMChange::AddChangeLinkTicketTypes\', to users of the groups as defined in "ITSMChange::RestrictTicketTypes::Groups". As this ACL could collide with other ACLs which are also related to the ticket type, this sysconfig option is disabled by default and should only be activated if needed.'} =
        'Modul ACL menghadkan penggunaan jenis tiket yang ditakrifkan dalam pilihan sysconfig \'ITSMChange::AddChangeLinkTicketTypes\', kepada pengguna daripada kumpulan seperti yang ditakrifkan dalam "ITSMChange::RestrictTicketTypes::Kumpulan". ACL ini boleh bertembung dengan Acls lain yang juga berkaitan dengan jenis tiket, pilihan sysconfig ini dilumpuhkan secara lalai dan hanya boleh diaktifkan jika diperlukan.';
    $Self->{Translation}->{'Time Slot'} = '';
    $Self->{Translation}->{'Types of tickets, where in the ticket zoom view a link to add a change will be displayed.'} =
        'Jenis-jenis tiket, di mana dalam zoom tiket melihat pautan untuk menambah perubahan akan dipaparkan.';
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
