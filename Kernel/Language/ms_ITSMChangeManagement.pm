# --
# Kernel/Language/ms_ITSMChangeManagement.pm - translation file
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ms_ITSMChangeManagement;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # Template: AAAITSMChangeManagement
    $Self->{Translation}->{'ITSMChange'} = 'ITSMUbah';
    $Self->{Translation}->{'ITSMChanges'} = 'ITSMPerubahan';
    $Self->{Translation}->{'ITSM Changes'} = 'Perubahan ITSM';
    $Self->{Translation}->{'workorder'} = 'urutankerja';
    $Self->{Translation}->{'A change must have a title!'} = 'Perubahan mesti mempunyai tajuk!';
    $Self->{Translation}->{'A condition must have a name!'} = 'Syarat mesti mempunyai nama!';
    $Self->{Translation}->{'A template must have a name!'} = 'Templat mesti mempunyai nama!';
    $Self->{Translation}->{'A workorder must have a title!'} = 'Urutankerja mesti mempunyai tajuk!';
    $Self->{Translation}->{'ActionExecute::successfully'} = 'berjaya';
    $Self->{Translation}->{'ActionExecute::unsuccessfully'} = 'tidak berjaya';
    $Self->{Translation}->{'Add CAB Template'} = 'Tambah templat CAB';
    $Self->{Translation}->{'Add Workorder'} = 'Tambah Urutankerja';
    $Self->{Translation}->{'Add a workorder to the change'} = 'Tambah urutankerja kepada perubahan';
    $Self->{Translation}->{'Add new condition and action pair'} = 'Tambah syarat baru dan pasangan tindakan';
    $Self->{Translation}->{'Agent interface module to show the ChangeManager overview icon.'} =
        'Modul ejen interface untuk menunjukkan PerubahanPengurusan melihat semula ikon.';
    $Self->{Translation}->{'Agent interface module to show the MyCAB overview icon.'} = 'Modul ejen interface untuk menunjukkan CABSaya melihat semula ikon.';
    $Self->{Translation}->{'Agent interface module to show the MyChanges overview icon.'} = 'Modul ejen interface untuk menunjukkan PerubahanSaya melihat semula ikon.';
    $Self->{Translation}->{'Agent interface module to show the MyWorkOrders overview icon.'} =
        'Modul ejen interface untuk menunjukkan UrutanKerjaSaya melihat semula ikon.';
    $Self->{Translation}->{'CABAgents'} = 'Ejen CAB';
    $Self->{Translation}->{'CABCustomers'} = 'Pelanggan CAB';
    $Self->{Translation}->{'Change Overview'} = 'Ubah Lihat Semula';
    $Self->{Translation}->{'Change Schedule'} = 'Ubah Jadual';
    $Self->{Translation}->{'Change involved persons of the change'} = 'Ubah melibatkan seseorang yang diubah';
    $Self->{Translation}->{'ChangeHistory::ActionAdd'} = '%s: %s';
    $Self->{Translation}->{'ChangeHistory::ActionAddID'} = 'Tambah Tindakan (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ActionDelete'} = 'Padam Tindakan(ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ActionDeleteAll'} = 'Padam Semua Tindakan (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ActionExecute'} = 'Melancarkan(ID=%s) Tindakan: %s';
    $Self->{Translation}->{'ChangeHistory::ActionUpdate'} = '%s (Action ID=%s): Baru: %s <- Lama: %s';
    $Self->{Translation}->{'ChangeHistory::ChangeActualEndTimeReached'} = 'Perubahan (ID = %s) telah siap.';
    $Self->{Translation}->{'ChangeHistory::ChangeActualStartTimeReached'} = 'Perubahan (ID=%s) telah siap.';
    $Self->{Translation}->{'ChangeHistory::ChangeAdd'} = 'Tambah Ubah (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ChangeAttachmentAdd'} = 'Tambah Ubah Lampiran: %s';
    $Self->{Translation}->{'ChangeHistory::ChangeAttachmentDelete'} = 'Lampiran dikeluarkan: %s';
    $Self->{Translation}->{'ChangeHistory::ChangeCABDelete'} = 'CAB dipadam %s';
    $Self->{Translation}->{'ChangeHistory::ChangeCABUpdate'} = '%s: Baru: %s <- Lama: %s';
    $Self->{Translation}->{'ChangeHistory::ChangeLinkAdd'} = 'Link untuk %s (ID=%s) tambah';
    $Self->{Translation}->{'ChangeHistory::ChangeLinkDelete'} = 'Link untuk %s (ID=%s) dipadam';
    $Self->{Translation}->{'ChangeHistory::ChangeNotificationSent'} = 'Pemberitahuan dihantar ke %s (acara: %s)';
    $Self->{Translation}->{'ChangeHistory::ChangePlannedEndTimeReached'} = 'Perubahan (ID=%s) sampai akhir dijadualkan.';
    $Self->{Translation}->{'ChangeHistory::ChangePlannedStartTimeReached'} = 'Perubahan (ID=%s) sampai dijadualkan masa mula.';
    $Self->{Translation}->{'ChangeHistory::ChangeRequestedTimeReached'} = 'Perubahan (ID=%s) sampai akhir diingini.';
    $Self->{Translation}->{'ChangeHistory::ChangeUpdate'} = '%s: Baru: %s <- Lama: %s';
    $Self->{Translation}->{'ChangeHistory::ConditionAdd'} = '%s: %s';
    $Self->{Translation}->{'ChangeHistory::ConditionAddID'} = 'Keadaan baru (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ConditionDelete'} = 'Keadaan (ID=%s) dipadam';
    $Self->{Translation}->{'ChangeHistory::ConditionDeleteAll'} = 'Semua syarat Perubahan (ID=%s) dipadam';
    $Self->{Translation}->{'ChangeHistory::ConditionUpdate'} = '%s (Keadaan ID=%s): Baru: %s <- Lama: %s';
    $Self->{Translation}->{'ChangeHistory::ExpressionAdd'} = '%s: %s';
    $Self->{Translation}->{'ChangeHistory::ExpressionAddID'} = 'Ekspresi baru (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ExpressionDelete'} = 'Ekspresi (ID=%s) dipadam';
    $Self->{Translation}->{'ChangeHistory::ExpressionDeleteAll'} = 'Memadam mana-mana ungkapan logik keadaan (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ExpressionUpdate'} = '%s (Expression ID=%s): Baru: %s <- Lama: %s';
    $Self->{Translation}->{'ChangeNumber'} = 'Ubah Nombor';
    $Self->{Translation}->{'Condition Edit'} = 'Audit Syarat';
    $Self->{Translation}->{'Create Change'} = 'Cipta Ubah';
    $Self->{Translation}->{'Create a change from this ticket!'} = 'Cipta perubahan dari tiket ini!';
    $Self->{Translation}->{'Delete Workorder'} = 'Padam UrutanKerja';
    $Self->{Translation}->{'Edit the change'} = 'Audit Perubahan';
    $Self->{Translation}->{'Edit the conditions of the change'} = 'Audit syarat kepada perubahan';
    $Self->{Translation}->{'Edit the workorder'} = 'Audit urutankerja';
    $Self->{Translation}->{'Expression'} = 'Ekspresi';
    $Self->{Translation}->{'Full-Text Search in Change and Workorder'} = 'Carian Teks-Penuh dalam Perubahan dan UrutanKerja';
    $Self->{Translation}->{'ITSMCondition'} = 'ITSMSyarat';
    $Self->{Translation}->{'ITSMWorkOrder'} = 'ITSMUrutanKerja';
    $Self->{Translation}->{'Link another object to the change'} = 'Pautan objek lain kepada perubahan';
    $Self->{Translation}->{'Link another object to the workorder'} = 'Pautan objek lain kepada urutankerja';
    $Self->{Translation}->{'Move all workorders in time'} = 'Pindah semua urutankerja dalam masa';
    $Self->{Translation}->{'My CABs'} = 'CAB Saya';
    $Self->{Translation}->{'My Changes'} = 'Perubahan Saya';
    $Self->{Translation}->{'My Workorders'} = 'UrutanKerja Saya';
    $Self->{Translation}->{'No XXX settings'} = 'Tiada \'%s\' pemilihan';
    $Self->{Translation}->{'PIR (Post Implementation Review)'} = 'PIR (Post Implementation Review)';
    $Self->{Translation}->{'PSA (Projected Service Availability)'} = 'PSA (Projected Service Availability)';
    $Self->{Translation}->{'Please select first a catalog class!'} = 'Sila mula-mula pilih katalog kelas!';
    $Self->{Translation}->{'Print the change'} = 'Cetak perubahan';
    $Self->{Translation}->{'Print the workorder'} = 'Cetak urutankerja';
    $Self->{Translation}->{'RequestedTime'} = 'MasaYangDiminta';
    $Self->{Translation}->{'Save Change CAB as Template'} = 'Simpan Ubah CAB sebagai Templat';
    $Self->{Translation}->{'Save change as a template'} = 'Simpan ubah sebagai templat';
    $Self->{Translation}->{'Save workorder as a template'} = 'Simpan urutankerja sebagai templat';
    $Self->{Translation}->{'Search Changes'} = 'Cari Perubahan';
    $Self->{Translation}->{'Set the agent for the workorder'} = 'Set ejen untuk urutankerja';
    $Self->{Translation}->{'Take Workorder'} = 'Ambil UrutanKerja';
    $Self->{Translation}->{'Take the workorder'} = 'Ambil UrutanKerja';
    $Self->{Translation}->{'Template Overview'} = 'Lihat Semula Templat';
    $Self->{Translation}->{'The planned end time is invalid!'} = 'Perancangan masa tamat adalah tidak sah!';
    $Self->{Translation}->{'The planned start time is invalid!'} = 'Perancangan masa mula adalah tidak sah!';
    $Self->{Translation}->{'The planned time is invalid!'} = 'Masa dirancang tidak sah!';
    $Self->{Translation}->{'The requested time is invalid!'} = 'Masa yang diminta tidak sah!';
    $Self->{Translation}->{'New (from template)'} = '';
    $Self->{Translation}->{'Add from template'} = '';
    $Self->{Translation}->{'Add Workorder (from template)'} = '';
    $Self->{Translation}->{'Add a workorder (from template) to the change'} = '';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualEndTimeReached'} = 'Perintah Kerja (ID=%s​​) telah siap.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualEndTimeReachedWithWorkOrderID'} =
        'Perintah Kerja (ID=%s) berakhir.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualStartTimeReached'} = 'Perintah kerja (ID=%s) bermula.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualStartTimeReachedWithWorkOrderID'} =
        'Perintah kerja (ID=%s) bermula.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAdd'} = 'Perintah kerja baru (ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAddWithWorkOrderID'} = 'Perintah kerja baru (ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentAdd'} = 'Nota untuk Perintah Kerja baru: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentAddWithWorkOrderID'} = '(ID=%s) Nota untuk Perintah Kerja baru: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentDelete'} = 'Nota dipadam dari Perintah Kerja: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentDeleteWithWorkOrderID'} = '(ID=%s) Nota dari Perintah Kerja dipadam: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentAdd'} = '';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentAddWithWorkOrderID'} =
        '';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentDelete'} = '';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentDeleteWithWorkOrderID'} =
        '';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderDelete'} = 'Perintah Kerja (ID=%s) dipadam';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderDeleteWithWorkOrderID'} = 'Perintah Kerja (ID=%s) dipadam';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkAdd'} = 'Pautan untuk %s (ID=%s) tambah';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkAddWithWorkOrderID'} = '(ID=%s) Pautan untuk %s (ID=%s) tambah';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkDelete'} = 'Pautan kepada %s (ID=%s) dipadam';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkDeleteWithWorkOrderID'} = '(ID=%s) Pautan untuk %s (ID=%s) dipadam';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderNotificationSent'} = 'Pemberitahuan dihantar ke %s (acara:%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderNotificationSentWithWorkOrderID'} = '(ID=%s) Pemberitahuan dihantar ke %s (Acara: %s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedEndTimeReached'} = 'Perintah kerja (ID=%s) sampai akhir dijadualkan.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedEndTimeReachedWithWorkOrderID'} =
        'Perintah kerja (ID=%s) sampai akhir dijadualkan.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedStartTimeReached'} = 'Perintah Kerja (ID=%s) sampai dijadualkan masa mula.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedStartTimeReachedWithWorkOrderID'} =
        'Perintah Kerja (ID=%s) sampai dijadualkan masa mula.';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderUpdate'} = '%s: Baru: %s <- Lama: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderUpdateWithWorkOrderID'} = '(ID=%s) %s: Baru: %s <- Lama: %s';
    $Self->{Translation}->{'WorkOrderNumber'} = 'Nombor UrutanKerja';
    $Self->{Translation}->{'accepted'} = 'Diterima';
    $Self->{Translation}->{'any'} = 'pelbagai';
    $Self->{Translation}->{'approval'} = 'Pengesahan';
    $Self->{Translation}->{'approved'} = 'Disahkan';
    $Self->{Translation}->{'backout'} = '';
    $Self->{Translation}->{'begins with'} = 'bermula dengan';
    $Self->{Translation}->{'canceled'} = 'dibatalkan';
    $Self->{Translation}->{'contains'} = 'mengandungi';
    $Self->{Translation}->{'created'} = 'dicipta';
    $Self->{Translation}->{'decision'} = 'keputusan';
    $Self->{Translation}->{'ends with'} = 'tamat dengan';
    $Self->{Translation}->{'failed'} = 'digagalkan';
    $Self->{Translation}->{'in progress'} = 'dalam proses';
    $Self->{Translation}->{'is'} = 'ialah';
    $Self->{Translation}->{'is after'} = 'ialah selepas';
    $Self->{Translation}->{'is before'} = 'ialah sebelum';
    $Self->{Translation}->{'is empty'} = 'ialah kosong';
    $Self->{Translation}->{'is greater than'} = 'ialah lebih besar daripada';
    $Self->{Translation}->{'is less than'} = 'ialah kurang daripada';
    $Self->{Translation}->{'is not'} = 'ialah tidak';
    $Self->{Translation}->{'is not empty'} = 'ialah tidak kosong';
    $Self->{Translation}->{'not contains'} = 'tidak mengandungi';
    $Self->{Translation}->{'pending approval'} = 'pengesahan tergantung';
    $Self->{Translation}->{'pending pir'} = 'PIR tergantung';
    $Self->{Translation}->{'pir'} = 'PIR (Post Implementation Review)';
    $Self->{Translation}->{'ready'} = 'sedia';
    $Self->{Translation}->{'rejected'} = 'ditolak';
    $Self->{Translation}->{'requested'} = 'diminta';
    $Self->{Translation}->{'retracted'} = 'ditarik balik';
    $Self->{Translation}->{'set'} = 'set';
    $Self->{Translation}->{'successful'} = 'berjaya';

    # Template: AdminITSMChangeCIPAllocate
    $Self->{Translation}->{'Category <-> Impact <-> Priority'} = 'Kategori <-> Kesan <-> keutamaan';
    $Self->{Translation}->{'Manage the priority result of combinating Category <-> Impact.'} =
        'Pentadbiran gabungan kategori keutamaan <-> Impak.';
    $Self->{Translation}->{'Priority allocation'} = 'Berikan keutamaan';

    # Template: AdminITSMChangeNotification
    $Self->{Translation}->{'ITSM ChangeManagement Notification Management'} = 'ITSM Pengurusan Perubahan pengurusan pemberitahuan';
    $Self->{Translation}->{'Add Notification Rule'} = 'Peraturan Pemberitahuan';
    $Self->{Translation}->{'Attribute'} = '';
    $Self->{Translation}->{'Rule'} = 'Peraturan';
    $Self->{Translation}->{'Recipients'} = '';
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
    $Self->{Translation}->{'Delete this state transition'} = '';
    $Self->{Translation}->{'Add a new state transition for'} = 'Menambah peralihan keadaan yang baru untuk';
    $Self->{Translation}->{'Please select a state!'} = 'Sila pilih keadaan!';
    $Self->{Translation}->{'Please select a next state!'} = 'Sila pilih status berikut!';
    $Self->{Translation}->{'Edit a state transition for'} = 'Penyuntingan peralihan keadaan untuk';
    $Self->{Translation}->{'Do you really want to delete the state transition'} = 'Adakah anda mahu memadam status peralihan ini benar-benar?';
    $Self->{Translation}->{'from'} = 'von';

    # Template: AgentITSMCABMemberSearch

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
    $Self->{Translation}->{'This field is required'} = 'Bidang ini diperlukan';
    $Self->{Translation}->{'Invalid Name'} = 'nama tidak sah';

    # Template: AgentITSMChangeCondition
    $Self->{Translation}->{'Conditions and Actions'} = 'Syarat-syarat dan Tindakan';
    $Self->{Translation}->{'Delete Condition'} = 'Padam keadaan';
    $Self->{Translation}->{'Add new condition'} = 'Tambah keadaan';

    # Template: AgentITSMChangeConditionEdit
    $Self->{Translation}->{'Need a valid name.'} = 'Perlu nama yang sah.';
    $Self->{Translation}->{'A a valid name is needed.'} = 'Nama yang sah diperlukan.';
    $Self->{Translation}->{'Matching'} = 'Sepadan';
    $Self->{Translation}->{'Any expression (OR)'} = 'Sebarang ekspresi (ATAU)';
    $Self->{Translation}->{'All expressions (AND)'} = 'Semua ungkapan logik (DAN)';
    $Self->{Translation}->{'Expressions'} = 'Ungkapan logik';
    $Self->{Translation}->{'Selector'} = 'pemilih';
    $Self->{Translation}->{'Operator'} = 'Operator';
    $Self->{Translation}->{'Delete Expression'} = '';
    $Self->{Translation}->{'No Expressions found.'} = 'Tiada ungkapan logik ditemui.';
    $Self->{Translation}->{'Add new expression'} = 'Tambah ungkapan baru';
    $Self->{Translation}->{'Delete Action'} = '';
    $Self->{Translation}->{'No Actions found.'} = 'Tiada Tindakan dijumpai.';
    $Self->{Translation}->{'Add new action'} = 'Tambah tindakan baru';

    # Template: AgentITSMChangeDelete
    $Self->{Translation}->{'Do you really want to delete this change?'} = 'Adakah anda benar-benar mahu untuk memadam perubahan ini?';

    # Template: AgentITSMChangeEdit

    # Template: AgentITSMChangeHistory
    $Self->{Translation}->{'Workorder'} = 'Perintah Kerja';
    $Self->{Translation}->{'Show details'} = 'Keperinchian menunjukkan';
    $Self->{Translation}->{'Show workorder'} = 'Perintah kerja menunjukkan';

    # Template: AgentITSMChangeHistoryZoom
    $Self->{Translation}->{'Detailed history information of'} = 'Sejarah maklumat terperinci';
    $Self->{Translation}->{'Modified'} = '';
    $Self->{Translation}->{'Old Value'} = 'Nilai Lama';
    $Self->{Translation}->{'New Value'} = 'Nilai Baru';

    # Template: AgentITSMChangeInvolvedPersons
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
    $Self->{Translation}->{'WorkOrderTitle'} = 'Tajuk Kerja Perintah';
    $Self->{Translation}->{'ChangeTitle'} = 'Ubah tajuk';
    $Self->{Translation}->{'WorkOrderAgent'} = 'Ejen Perintah kerja';
    $Self->{Translation}->{'Workorders'} = 'Perintah Kerja';
    $Self->{Translation}->{'ChangeState'} = 'Ubah Status';
    $Self->{Translation}->{'WorkOrderState'} = 'Status Perintah Kerja';
    $Self->{Translation}->{'WorkOrderType'} = 'Jenis Perintah Kerja';
    $Self->{Translation}->{'Requested Time'} = 'Masa yang Diminta';
    $Self->{Translation}->{'PlannedStartTime'} = 'Rancang Masa Mula';
    $Self->{Translation}->{'PlannedEndTime'} = 'Rancang Masa Tamat';
    $Self->{Translation}->{'ActualStartTime'} = 'Masa Mula Sebenar';
    $Self->{Translation}->{'ActualEndTime'} = 'Masa Tamat Sebenar';

    # Template: AgentITSMChangePrint
    $Self->{Translation}->{'ITSM Workorder'} = 'Perintah Kerja';

    # Template: AgentITSMChangeReset
    $Self->{Translation}->{'Do you really want to reset this change?'} = 'Adakah anda benar-benar mahu untuk menetapkan semula perubahan ini?';

    # Template: AgentITSMChangeSearch
    $Self->{Translation}->{'(e.g. 10*5155 or 105658*)'} = '(z. B. 10*5155 or 105658*)';
    $Self->{Translation}->{'CABAgent'} = 'CAB Ejen';
    $Self->{Translation}->{'e.g.'} = 'cth.';
    $Self->{Translation}->{'CABCustomer'} = 'CAB Pelanggan';
    $Self->{Translation}->{'Instruction'} = 'Arahan';
    $Self->{Translation}->{'Report'} = 'Laporan';
    $Self->{Translation}->{'Change Category'} = 'Ubah Kategori';
    $Self->{Translation}->{'(before/after)'} = '(sebelum/selepas)';
    $Self->{Translation}->{'(between)'} = '(diantara)';
    $Self->{Translation}->{'Run Search'} = '';

    # Template: AgentITSMChangeSearchResultPrint
    $Self->{Translation}->{'WorkOrders'} = 'Perintah Kerja';

    # Template: AgentITSMChangeTemplate
    $Self->{Translation}->{'Save Change as Template'} = 'Simpan Perubahan sebagai Templat';
    $Self->{Translation}->{'A template should have a name!'} = 'Template harus mempunyai nama!';
    $Self->{Translation}->{'The template name is required.'} = 'Nama template diperlukan.';
    $Self->{Translation}->{'Reset States'} = 'Set Semula Keadaan';

    # Template: AgentITSMChangeTimeSlot
    $Self->{Translation}->{'Move Time Slot'} = 'Gerakkan Slot Masa';

    # Template: AgentITSMChangeZoom
    $Self->{Translation}->{'Change Information'} = 'mengubah Maklumat';
    $Self->{Translation}->{'PlannedEffort'} = 'Usaha yang dirancang';
    $Self->{Translation}->{'Change Initiator(s)'} = 'Penggerak Perubahan(s)';
    $Self->{Translation}->{'Change Manager'} = 'Perubahan Pengurus';
    $Self->{Translation}->{'Change Builder'} = 'Perubahan pembina';
    $Self->{Translation}->{'CAB'} = 'CAB';
    $Self->{Translation}->{'Last changed'} = 'Terkini berubah';
    $Self->{Translation}->{'Last changed by'} = 'Terakhir diubah oleh';
    $Self->{Translation}->{'Ok'} = 'Ok';
    $Self->{Translation}->{'Download Attachment'} = 'memuat turun lampiran';

    # Template: AgentITSMTemplateDelete
    $Self->{Translation}->{'Do you really want to delete this template?'} = 'Adakah anda benar-benar mahu untuk memadam template ini?';

    # Template: AgentITSMTemplateEdit

    # Template: AgentITSMTemplateOverviewNavBar

    # Template: AgentITSMTemplateOverviewSmall
    $Self->{Translation}->{'TemplateID'} = 'Templat-ID';
    $Self->{Translation}->{'CreateBy'} = 'Dibuat Oleh';
    $Self->{Translation}->{'CreateTime'} = 'CiptaMasa';
    $Self->{Translation}->{'ChangeBy'} = 'DiubahOleh';
    $Self->{Translation}->{'ChangeTime'} = 'UbahMasa';
    $Self->{Translation}->{'Delete: '} = 'Padam: ';
    $Self->{Translation}->{'Delete Template'} = 'Padam Templat';

    # Template: AgentITSMUserSearch

    # Template: AgentITSMWorkOrderAdd
    $Self->{Translation}->{'Add Workorder to'} = 'Kerja Perintah untuk Tambah';
    $Self->{Translation}->{'Invalid workorder type.'} = 'Kerja tidak sah mengikut pesanan';
    $Self->{Translation}->{'The planned start time must be before the planned end time!'} = 'Masa mula dirancang mestilah sebelum masa akhir dirancang!';
    $Self->{Translation}->{'Invalid format.'} = 'format tidak sah.';

    # Template: AgentITSMWorkOrderAddFromTemplate
    $Self->{Translation}->{'Select Workorder Template'} = 'Pilih Templat Perintah Kerja';

    # Template: AgentITSMWorkOrderAgent

    # Template: AgentITSMWorkOrderDelete
    $Self->{Translation}->{'Do you really want to delete this workorder?'} = 'Adakah anda benar-benar ingin memadam ini perintah kerja?';
    $Self->{Translation}->{'You can not delete this Workorder. It is used in at least one Condition!'} =
        'Anda tidak boleh memadam ini Tata Kerja. Ia digunakan dalam sekurang-kurangnya satu Keadaan!';
    $Self->{Translation}->{'This Workorder is used in the following Condition(s)'} = 'Perintah Kerja digunakan dalam Syarat-syarat berikut';

    # Template: AgentITSMWorkOrderEdit
    $Self->{Translation}->{'Move following workorders accordingly'} = '';
    $Self->{Translation}->{'If the planned end time of this workorder is changed, the planned start times of all following workorders will be changed accordingly'} =
        '';

    # Template: AgentITSMWorkOrderHistory

    # Template: AgentITSMWorkOrderHistoryZoom

    # Template: AgentITSMWorkOrderReport
    $Self->{Translation}->{'The actual start time must be before the actual end time!'} = 'Masa mula sebenar mesti sebelum masa akhir sebenar!';
    $Self->{Translation}->{'The actual start time must be set, when the actual end time is set!'} =
        'Masa mula sebenar mesti ditetapkan, apabila akhir zaman sebenar ditetapkan!';
    $Self->{Translation}->{'Existing attachments'} = '';

    # Template: AgentITSMWorkOrderTake
    $Self->{Translation}->{'Current Agent'} = 'Agen semasa';
    $Self->{Translation}->{'Do you really want to take this workorder?'} = 'Adakah anda benar-benar mahu mengambil perintah kerja?';

    # Template: AgentITSMWorkOrderTemplate
    $Self->{Translation}->{'Save Workorder as Template'} = 'Simpan Perintah Kerja sebagai Templat';

    # Template: AgentITSMWorkOrderZoom
    $Self->{Translation}->{'Workorder Information'} = 'Informasi Perintah Kerja';

    # Template: CustomerITSMChangeOverview

    # Template: ITSMChange

    # SysConfig
    $Self->{Translation}->{'A list of the agents who have permission to take workorders. Key is a login name. Content is 0 or 1.'} =
        'Satu senarai agen yang mempunyai kebenaran untuk mengambil pesanan kerja. Utama adalah nama log masuk. Kandungan adalah 0 atau 1';
    $Self->{Translation}->{'A list of workorder states, at which the ActualStartTime of a workorder will be set if it was empty at this point.'} =
        'Satu senarai status pesanan kerja, di mana Masa Mula sebenar perintah kerja akan ditetapkan jika ia adalah kosong pada ketika ini.';
    $Self->{Translation}->{'Admin of notification rules.'} = 'Admin peraturan pemberitahuan';
    $Self->{Translation}->{'Admin of the CIP matrix.'} = 'Admin matriks CIP.';
    $Self->{Translation}->{'Admin of the state machine.'} = 'Admin jentera kerajaan.';
    $Self->{Translation}->{'Agent interface notification module to see the number of change advisory boards.'} =
        'Agen antara muka modul pemberitahuan untuk melihat bilangan menukar lembaga penasihat.';
    $Self->{Translation}->{'Agent interface notification module to see the number of changes managed by the user.'} =
        'Agen antara muka modul pemberitahuan untuk melihat beberapa perubahan yang diuruskan oleh pengguna.';
    $Self->{Translation}->{'Agent interface notification module to see the number of changes.'} =
        'Agen antara muka modul pemberitahuan untuk melihat beberapa perubahan.';
    $Self->{Translation}->{'Agent interface notification module to see the number of work orders.'} =
        'Agen antara muka modul pemberitahuan untuk melihat nombor pesanan kerja.';
    $Self->{Translation}->{'Cache time in minutes for the change management toolbars. Default: 3 hours (180 minutes).'} =
        '';
    $Self->{Translation}->{'Cache time in minutes for the change management. Default: 5 days (7200 minutes).'} =
        '';
    $Self->{Translation}->{'Change Overview "Small" Limit'} = '';
    $Self->{Translation}->{'Change free text options shown in the change add of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';
    $Self->{Translation}->{'Change free text options shown in the change edit of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';
    $Self->{Translation}->{'Change free text options shown in the change search of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        '';
    $Self->{Translation}->{'Change limit per page for Change Overview "Small"'} = '';
    $Self->{Translation}->{'Change search backend router of the agent interface.'} = 'Tukar router carian backend antara muka ejen.';
    $Self->{Translation}->{'Configures how often the notifications are sent when planned the start time or other time values have been reached/passed.'} =
        'Dikonfigurasi berapa kerap pemberitahuan akan dihantar apabila merancang masa mula atau nilai masa lain telah mencapai / diluluskan.';
    $Self->{Translation}->{'Default type for a workorder. This entry must exist in general catalog class \'ITSM::ChangeManagement::WorkOrder::Type\'.'} =
        'Jenis lalai untuk perintah kerja. Entri ini mesti wujud di dalam kelas katalog am \'ITSM::Pengurusan Perubahan::Perintah Kerja::Jenis\'.';
    $Self->{Translation}->{'Define the signals for each workorder state.'} = 'Tentukan isyarat untuk setiap keadaan perintah kerja.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a change list.'} =
        'Mentakrifkan modul gambaran untuk menunjukkan pandangan yang kecil senarai perubahan.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a template list.'} =
        'Mentakrifkan modul gambaran untuk menunjukkan pandangan yang kecil senarai templat.';
    $Self->{Translation}->{'Defines if it will be possible to print the accounted time.'} = 'Mentakrifkan jika ia akan menjadi mustahil untuk mencetak masa yang diambilkira';
    $Self->{Translation}->{'Defines if it will be possible to print the planned effort.'} = 'Mentakrifkan jika ia akan menjadi mustahil untuk mencetak usaha yang dirancang.';
    $Self->{Translation}->{'Defines if reachable (as defined by the state machine) change end states should be allowed if a change is in a locked state.'} =
        '';
    $Self->{Translation}->{'Defines if reachable (as defined by the state machine) workorder end states should be allowed if a workorder is in a locked state.'} =
        '';
    $Self->{Translation}->{'Defines if the accounted time should be shown.'} = 'Mentakrifkan jika masa yang diambil kira hendaklah ditunjukkan.';
    $Self->{Translation}->{'Defines if the actual start and end times should be set.'} = 'Mentakrifkan jika permulaan sebenar dan akhir zaman harus ditetapkan.';
    $Self->{Translation}->{'Defines if the change search and the workorder search functions could use the mirror DB.'} =
        '';
    $Self->{Translation}->{'Defines if the change state can be set in AgentITSMChangeEdit.'} =
        'Mentakrifkan jika keadaan perubahan boleh ditetapkan dalam AgentITSMChangeEdit.';
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
    $Self->{Translation}->{'Defines the change states that will be allowed to delete.'} = '';
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
    $Self->{Translation}->{'Defines the default selection of the free key field number 1 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 1 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 10 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 10 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 11 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 11 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 12 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 12 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 13 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 13 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 14 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 14 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 15 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 15 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 16 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 16 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 17 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 17 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 18 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 18 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 19 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 19 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 2 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 2 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 20 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 20 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 21 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 21 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 22 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 22 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 23 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 23 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 24 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 24 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 25 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 25 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 26 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 26 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 27 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 27 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 28 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 28 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 29 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 29 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 3 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 3 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 30 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 30 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 31 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 31 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 32 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 32 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 33 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 33 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 34 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 34 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 35 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 35 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 36 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 36 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 37 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 37 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 38 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 38 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 39 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 39 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 4 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 4 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 40 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 40 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 41 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 41 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 42 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 42 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 43 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 43 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 44 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 44 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 45 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 45 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 46 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 46 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 47 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 47 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 48 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 48 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 49 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 49 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 5 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 5 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 50 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 50 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 6 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 6 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 7 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 7 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 8 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 8 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 9 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 9 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 1 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 1 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 10 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 10 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 11 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 11 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 12 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 12 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 13 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 13 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 14 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 14 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 15 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 15 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 16 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 16 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 17 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 17 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 18 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 18 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 19 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 19 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 2 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 2 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 20 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 20 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 21 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 21 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 22 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 22 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 23 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 23 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 24 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 24 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 25 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 25 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 26 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 26 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 27 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 27 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 28 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 28 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 29 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 29 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 3 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 3 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 30 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 30 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 31 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 31 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 32 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 32 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 33 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 33 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 34 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 34 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 35 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 35 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 36 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 36 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 37 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 37 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 38 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 38 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 39 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 39 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 4 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 4 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 40 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 40 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 41 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 41 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 42 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 42 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 43 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 43 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 44 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 44 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 45 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 45 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 46 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 46 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 47 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 47 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 48 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 48 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 49 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 49 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 5 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 5 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 50 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 50 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 6 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 6 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 7 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 7 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 8 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 8 for workorders (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 9 for changes (if more than one option is provided).'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free text field number 9 for workorders (if more than one option is provided).'} =
        '';
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
    $Self->{Translation}->{'Defines the field type of CompareValue fields for change attributes used in AgentITSMChangeConditionEdit. Valid values are Selection, Text and Date. If a type is not defined, the field will not be shown.'} =
        'Mentakrifkan jenis bidang bidang Banding Nilai untuk sifat-sifat perubahan yang digunakan dalam AgentITSMChangeConditionEdit. Nilai yang sah Pemilihan, Teks dan Tarikh. Jika jenis tidak ditakrifkan, padang tidak akan ditunjukkan.';
    $Self->{Translation}->{'Defines the field type of CompareValue fields for workorder attributes used in AgentITSMChangeConditionEdit. Valid values are Selection, Text and Date. If a type is not defined, the field will not be shown.'} =
        'Mentakrifkan jenis bidang bidang Banding Nilai untuk sifat-sifat perintah kerja yang digunakan dalam AgentITSMChangeConditionEdit. Nilai yang sah Pemilihan, Teks dan Tarikh. Jika jenis tidak ditakrifkan, padang tidak akan ditunjukkan.';
    $Self->{Translation}->{'Defines the free key field number 1 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 1 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 10 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 10 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 11 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 11 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 12 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 12 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 13 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 13 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 14 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 14 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 15 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 15 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 16 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 16 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 17 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 17 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 18 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 18 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 19 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 19 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 2 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 2 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 20 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 20 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 21 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 21 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 22 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 22 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 23 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 23 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 24 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 24 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 25 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 25 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 26 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 26 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 27 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 27 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 28 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 28 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 29 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 29 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 3 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 3 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 30 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 30 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 31 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 31 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 32 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 32 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 33 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 33 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 34 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 34 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 35 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 35 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 36 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 36 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 37 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 37 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 38 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 38 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 39 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 39 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 4 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 4 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 40 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 40 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 41 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 41 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 42 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 42 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 43 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 43 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 44 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 44 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 45 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 45 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 46 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 46 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 47 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 47 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 48 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 48 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 49 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 49 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 5 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 5 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 50 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 50 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 6 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 6 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 7 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 7 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 8 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 8 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 9 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 9 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 1 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 1 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 10 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 10 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 11 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 11 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 12 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 13 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 13 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 14 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 14 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 15 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 15 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 16 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 16 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 17 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 17 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 18 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 18 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 19 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 19 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 2 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 2 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 20 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 20 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 21 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 21 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 22 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 22 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 23 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 23 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 24 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 24 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 25 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 25 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 26 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 26 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 27 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 27 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 28 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 28 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 29 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 29 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 3 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 3 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 30 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 30 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 31 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 31 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 32 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 32 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 33 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 33 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 34 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 34 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 35 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 35 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 36 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 36 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 37 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 37 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 38 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 38 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 39 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 39 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 4 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 4 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 40 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 40 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 41 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 41 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 42 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 42 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 43 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 43 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 44 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 44 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 45 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 45 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 46 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 46 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 47 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 47 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 48 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 48 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 49 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 49 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 5 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 5 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 50 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 50 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 6 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 6 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 7 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 7 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 8 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 8 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 9 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 9 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 1 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 1 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 10 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 10 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 11 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 11 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 12 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 12 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 13 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 13 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 14 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 14 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 15 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 15 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 16 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 16 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 17 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 17 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 18 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 18 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 19 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 19 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 2 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 2 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 20 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 20 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 21 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 21 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 22 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 22 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 23 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 23 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 24 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 24 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 25 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 25 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 26 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 26 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 27 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 27 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 28 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 28 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 29 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 29 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 3 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 3 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 30 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 30 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 31 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 31 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 32 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 32 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 33 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 33 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 34 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 34 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 35 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 35 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 36 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 36 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 37 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 37 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 38 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 38 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 39 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 39 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 4 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 4 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 40 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 40 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 41 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 41 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 42 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 42 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 43 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 43 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 44 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 44 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 45 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 45 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 46 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 46 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 47 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 47 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 48 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 48 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 49 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 49 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 5 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 5 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 50 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 50 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 6 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 6 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 7 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 7 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 8 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 8 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 9 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 9 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the maximum number of change freetext fields.'} = 'Mentakrifkan bilangan maksimum medan perubahan teks percuma.';
    $Self->{Translation}->{'Defines the maximum number of workorder freetext fields.'} = 'Mentakrifkan bilangan maksimum bidang kerja perintah teks percuma.';
    $Self->{Translation}->{'Defines the object attributes that are selectable for change objects in AgentITSMChangeConditionEdit.'} =
        'Mentakrifkan sifat-sifat objek yang dipilih untuk objek perubahan dalam AgentITSMChangeConditionEdit.';
    $Self->{Translation}->{'Defines the object attributes that are selectable for workorder objects in AgentITSMChangeConditionEdit.'} =
        'Mentakrifkan sifat-sifat objek yang dipilih untuk objek perintah kerja dalam AgentITSMChangeConditionEdit.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute AccountedTime in AgentITSMChangeConditionEdit.'} =
        'Mentakrifkan pengendali yang dipilih untuk AccountedTime atribut dalam AgentITSMChangeConditionEdit.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ActualEndTime in AgentITSMChangeConditionEdit.'} =
        'Mentakrifkan pengendali yang dipilih untuk ActualEndTime atribut dalam AgentITSMChangeConditionEdit.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ActualStartTime in AgentITSMChangeConditionEdit.'} =
        'Mentakrifkan pengendali yang dipilih untuk ActualStartTime atribut dalam AgentITSMChangeConditionEdit.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute CategoryID in AgentITSMChangeConditionEdit.'} =
        'Mentakrifkan pengendali yang boleh dipilih untuk ID Kategori atribut dalam AgentITSMChangeConditionEdit.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeBuilderID in AgentITSMChangeConditionEdit.'} =
        'Mentakrifkan pengendali yang boleh dipilih untuk atribut ChangeBuilderID dalam AgentITSMChangeConditionEdit.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeFreeKey in AgentITSMChangeConditionEdit.'} =
        'Mentakrifkan pengendali yang dipilih untuk ChangeFreeKey atribut dalam AgentITSMChangeConditionEdit.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeFreeText in AgentITSMChangeConditionEdit.'} =
        'Mentakrifkan pengendali yang boleh dipilih untuk FreeText Perubahan atribut dalam AgentITSMChangeConditionEdit.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeManagerID in AgentITSMChangeConditionEdit.'} =
        'Mentakrifkan pengendali yang boleh dipilih untuk atribut ChangeManagerID dalam AgentITSMChangeConditionEdit.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeStateID in AgentITSMChangeConditionEdit.'} =
        'Mentakrifkan pengendali yang boleh dipilih untuk atribut ChangeStateID dalam AgentITSMChangeConditionEdit.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeTitle in AgentITSMChangeConditionEdit.'} =
        'Mentakrifkan pengendali yang boleh dipilih untuk Perubahan Tajuk atribut dalam AgentITSMChangeConditionEdit.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ImpactID in AgentITSMChangeConditionEdit.'} =
        'Mentakrifkan pengendali yang boleh dipilih untuk atribut ImpactID dalam AgentITSMChangeConditionEdit.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PlannedEffort in AgentITSMChangeConditionEdit.'} =
        'Mentakrifkan pengendali yang boleh dipilih untuk Usaha sifat yang dirancang dalam AgentITSMChangeConditionEdit.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PlannedEndTime in AgentITSMChangeConditionEdit.'} =
        'Mentakrifkan pengendali yang dipilih untuk atribut Dirancang Masa Tamat dalam AgentITSMChangeConditionEdit.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PlannedStartTime in AgentITSMChangeConditionEdit.'} =
        'Mentakrifkan pengendali yang dipilih untuk atribut Dirancang Mula Masa dalam AgentITSMChangeConditionEdit.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PriorityID in AgentITSMChangeConditionEdit.'} =
        'Mentakrifkan pengendali yang boleh dipilih untuk ID Keutamaan atribut dalam AgentITSMChangeConditionEdit.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute RequestedTime in AgentITSMChangeConditionEdit.'} =
        'Mentakrifkan pengendali yang dipilih untuk atribut Diminta Masa dalam AgentITSMChangeConditionEdit.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderAgentID in AgentITSMChangeConditionEdit.'} =
        'Mentakrifkan pengendali yang boleh dipilih untuk atribut WorkOrderAgentID dalam AgentITSMChangeConditionEdit.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderFreeKey in AgentITSMChangeConditionEdit.'} =
        'Mentakrifkan pengendali yang dipilih untuk WorkOrderFreeKey atribut dalam AgentITSMChangeConditionEdit.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderFreeText in AgentITSMChangeConditionEdit.'} =
        'Mentakrifkan pengendali yang boleh dipilih untuk Teks atribut Perintah Kerja Percuma di AgentITSMChangeConditionEdit.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderNumber in AgentITSMChangeConditionEdit.'} =
        'Mentakrifkan pengendali yang boleh dipilih untuk Nombor atribut Perintah Kerja dalam AgentITSMChangeConditionEdit.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderStateID in AgentITSMChangeConditionEdit.'} =
        'Mentakrifkan pengendali yang boleh dipilih untuk Kerja atribut ID Pesanan Keadaan dalam AgentITSMChangeConditionEdit.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderTitle in AgentITSMChangeConditionEdit.'} =
        'Mentakrifkan pengendali yang boleh dipilih untuk Tajuk atribut Perintah Kerja dalam AgentITSMChangeConditionEdit.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderTypeID in AgentITSMChangeConditionEdit.'} =
        'Mentakrifkan pengendali yang boleh dipilih untuk Kerja atribut Jenis ID Perintah AgentITSMChangeConditionEdit.';
    $Self->{Translation}->{'Defines the period (in years), in which start and end times can be selected.'} =
        'Mentakrifkan tempoh (dalam tahun), di mana mula dan akhir kali boleh dipilih.';
    $Self->{Translation}->{'Defines the shown attributes of a workorder in the tooltip of the workorder graph in the change zoom.'} =
        '';
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
    $Self->{Translation}->{'Defines the signals for each ITSMChange state.'} = 'Mentakrifkan isyarat untuk setiap keadaan Perubahan ITSM.';
    $Self->{Translation}->{'Defines the template types that will be used as filters in the template overview.'} =
        'Mentakrifkan jenis template yang akan digunakan sebagai penapis dalam gambaran template.';
    $Self->{Translation}->{'Defines the workorder states that will be used as filters in the MyWorkorders overview.'} =
        'Mentakrifkan status kerja perintah yang akan digunakan sebagai penapis dalam gambaran keseluruhan Kerja pesanan saya.';
    $Self->{Translation}->{'Defines the workorder states that will be used as filters in the PIR overview.'} =
        'Mentakrifkan status kerja perintah yang akan digunakan sebagai penapis dalam gambaran PIR.';
    $Self->{Translation}->{'Defines the workorder types that will be used to show the PIR overview.'} =
        'Mentakrifkan jenis perintah kerja yang akan digunakan untuk menunjukkan gambaran PIR.';
    $Self->{Translation}->{'Defines whether notifications should be sent.'} = 'Mentakrifkan sama ada pemberitahuan hendaklah dihantar.';
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
    $Self->{Translation}->{'ITSM event module deletes the history of changes.'} = 'ITSM modul acara memadam sejarah perubahan.';
    $Self->{Translation}->{'ITSM event module that cleans up conditions.'} = 'ITSM modul peristiwa yang membersihkan sehingga keadaan.';
    $Self->{Translation}->{'ITSM event module that deletes the cache for a toolbar.'} = '';
    $Self->{Translation}->{'ITSM event module that matches conditions and executes actions.'} =
        'ITSM modul acara yang sepadan dengan keadaan dan melaksanakan tindakan.';
    $Self->{Translation}->{'ITSM event module that sends notifications.'} = 'ITSM modul acara yang menghantar pemberitahuan.';
    $Self->{Translation}->{'ITSM event module that updates the history of changes.'} = 'ITSM modul peristiwa yang mengemaskini sejarah perubahan.';
    $Self->{Translation}->{'ITSM event module to recalculate the workorder numbers.'} = 'ITSM modul acara untuk mengira nombor pesanan kerja.';
    $Self->{Translation}->{'ITSM event module to set the actual start and end times of workorders.'} =
        'ITSM modul acara untuk menetapkan permulaan sebenar dan masa akhir pesanan kerja.';
    $Self->{Translation}->{'ITSM event module updates the history of changes.'} = 'kemaskini modul acara ITSM sejarah perubahan';
    $Self->{Translation}->{'ITSM event module updates the history of conditions.'} = 'kemaskini modul acara ITSM sejarah syarat.';
    $Self->{Translation}->{'ITSM event module updates the history of workorders.'} = 'kemaskini modul acara ITSM sejarah pesanan kerja.';
    $Self->{Translation}->{'If frequency is \'regularly\', you can configure how often the notications are sent (every X hours).'} =
        'Jika frekuensi \'kerap \', anda boleh menatarajah berapa kerap pemberitahuan dihantar (setiap jam X).';
    $Self->{Translation}->{'If this option is enabled, then the decrypted data will be stored in the database if they are displayed in AgentTicketZoom.'} =
        '';
    $Self->{Translation}->{'Logfile for the ITSM change counter. This file is used for creating the change numbers.'} =
        'Fail Log untuk kaunter perubahan ITSM. Fail ini digunakan untuk mewujudkan nombor perubahan.';
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
    $Self->{Translation}->{'Notification (ITSM Change Management)'} = 'Pemberitahuan (Pengurusan Perubahan ITSM)';
    $Self->{Translation}->{'Only users of these groups have the permission to use the ticket types as defined in "ITSMChange::AddChangeLinkTicketTypes" if the feature "Ticket::Acl::Module###200-Ticket::Acl::Module" is enabled.'} =
        'Hanya pengguna kumpulan-kumpulan ini mempunyai kebenaran untuk menggunakan jenis tiket seperti yang ditakrifkan dalam "ITSMChange :: AddChangeLinkTicketTypes" jika ciri "Tiket :: ACL :: Modul # # # 200-Tiket :: ACL :: Modul" diaktifkan.';
    $Self->{Translation}->{'Parameters for the pages (in which the changes are shown) of the small change overview.'} =
        'Parameter untuk halaman (di mana perubahan ditunjukkan) gambaran perubahan kecil.';
    $Self->{Translation}->{'Presents a link in the menu to show the involved persons in a change, in the zoom view of such change in the agent interface.'} =
        'Hadir pautan dalam menu untuk menunjukkan orang-orang yang terlibat dalam perubahan, dalam pandangan zoom perubahan dalam antara muka ejen';
    $Self->{Translation}->{'Required privileges in order for an agent to take a workorder.'} =
        'Keistimewaan Diperlukan dalam usaha untuk ejen untuk mengambil perintah kerja.';
    $Self->{Translation}->{'Required privileges to access the overview of all changes.'} = 'Keistimewaan yang diperlukan untuk mengakses gambaran keseluruhan semua perubahan.';
    $Self->{Translation}->{'Required privileges to add a workorder.'} = 'Keistimewaan yang diperlukan untuk menambah perintah kerja.';
    $Self->{Translation}->{'Required privileges to change the workorder agent.'} = 'Keistimewaan yang diperlukan untuk menukar pesanan kerja ejen.';
    $Self->{Translation}->{'Required privileges to create a template from a change.'} = 'Keistimewaan yang diperlukan untuk mewujudkan template dari perubahan.';
    $Self->{Translation}->{'Required privileges to create a template from a changes\' CAB.'} =
        'Keistimewaan yang diperlukan untuk membuat template dari perubahan CAB.';
    $Self->{Translation}->{'Required privileges to create a template from a workorder.'} = 'Keistimewaan yang diperlukan untuk membuat template dari perintah kerja.';
    $Self->{Translation}->{'Required privileges to create changes from templates.'} = '';
    $Self->{Translation}->{'Required privileges to create changes.'} = 'Keistimewaan yang diperlukan untuk mencipta perubahan.';
    $Self->{Translation}->{'Required privileges to delete a template.'} = 'Keistimewaan yang diperlukan untuk memadam template.';
    $Self->{Translation}->{'Required privileges to delete a workorder.'} = 'Keistimewaan yang diperlukan untuk memadam perintah kerja';
    $Self->{Translation}->{'Required privileges to delete changes.'} = '';
    $Self->{Translation}->{'Required privileges to edit a template.'} = 'Keistimewaan yang diperlukan untuk mengedit template.';
    $Self->{Translation}->{'Required privileges to edit a workorder.'} = 'Keistimewaan yang diperlukan untuk mengedit perintah kerja.';
    $Self->{Translation}->{'Required privileges to edit changes.'} = 'Keistimewaan yang diperlukan untuk mengedit perubahan.';
    $Self->{Translation}->{'Required privileges to edit the conditions of changes.'} = 'Keistimewaan yang diperlukan untuk mengedit syarat perubahan.';
    $Self->{Translation}->{'Required privileges to edit the involved persons of a change.'} =
        'Keistimewaan yang diperlukan untuk mengedit orang yang terlibat perubahan.';
    $Self->{Translation}->{'Required privileges to move changes in time.'} = 'Keistimewaan yang diperlukan untuk menggerakkan perubahan dalam masa..';
    $Self->{Translation}->{'Required privileges to print a change.'} = 'Keistimewaan yang diperlukan untuk mencetak perubahan';
    $Self->{Translation}->{'Required privileges to reset changes.'} = '';
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
    $Self->{Translation}->{'Selects the change number generator module. "AutoIncrement" increments the change number, the SystemID and the counter are used with SystemID.counter format (e.g. 100118, 100119). With "Date", the change numbers will be generated by the current date and a counter; this format looks like Year.Month.Day.counter, e.g. 2010062400001, 2010062400002. With "DateChecksum", the counter will be appended as checksum to the string of date plus the SystemID. The checksum will be rotated on a daily basis. This format looks like Year.Month.Day.SystemID.Counter.CheckSum, e.g. 2010062410000017, 2010062410000026.'} =
        '';
    $Self->{Translation}->{'Sets the minimal change counter size (if "AutoIncrement" was selected as ITSMChange::NumberGenerator). Default is 5, this means the counter starts from 10000.'} =
        '';
    $Self->{Translation}->{'Sets up the state machine for changes.'} = 'Set up jentera kerajaan untuk perubahan.';
    $Self->{Translation}->{'Sets up the state machine for workorders.'} = 'Set up jentera kerajaan untuk pesanan kerja.';
    $Self->{Translation}->{'Shows a checkbox in the AgentITSMWorkOrderEdit screen that defines if the the following workorders should also be moved if a workorder is modified and the planned end time has changed.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows changing the work order agent, in the zoom view of such work order of the agent interface.'} =
        'Menunjukkan pautan dalam menu yang membolehkan menukar ejen kerja perintah, memandangkan zoom perintah kerja itu antara muka ejen';
    $Self->{Translation}->{'Shows a link in the menu that allows defining a change as a template in the zoom view of the change, in the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows defining a work order as a template in the zoom view of the work order, in the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows editing the report of a workd order, in the zoom view of such work order of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows linking a change with another object in the change zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows linking a work order with another object in the zoom view of such work order of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows moving the time slot of a change in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows taking a work order in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to access the conditions of a change in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to access the history of a change in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to access the history of a work order in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to add a work order in the change zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to delete a change in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to delete a work order in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to edit a change in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to edit a work order in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to go back in the change zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to go back in the work order zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to print a change in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to print a work order in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to reset a change and its workorders in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows the change history (reverse ordered) in the agent interface.'} =
        '';
    $Self->{Translation}->{'State Machine'} = '';
    $Self->{Translation}->{'The identifier for a change, e.g. Change#, MyChange#. The default is Change#.'} =
        'Pengecam untuk perubahan, i. Perubahan# Perubahan Saya#. Lalai adalah Perubahan#.';
    $Self->{Translation}->{'The identifier for a workorder, e.g. Workorder#, MyWorkorder#. The default is Workorder#.'} =
        'Pengecam untuk mendapatkan perintah kerja, misalnya Workorder# Workorder#. Lalai adalah Perintah Kerja#.';
    $Self->{Translation}->{'This ACL module restricts the usuage of the ticket types that are defined in the sysconfig option \'ITSMChange::AddChangeLinkTicketTypes\', to users of the groups as defined in "ITSMChange::RestrictTicketTypes::Groups". As this ACL could collide with other ACLs which are also related to the ticket type, this sysconfig option is disabled by default and should only be activated if needed.'} =
        '';
    $Self->{Translation}->{'Types of tickets, where in the ticket zoom view a link to add a change will be displayed.'} =
        'Jenis-jenis tiket, di mana dalam zoom tiket melihat pautan untuk menambah perubahan akan dipaparkan.';
    $Self->{Translation}->{'Workorder free text options shown in the change search of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        '';
    $Self->{Translation}->{'Workorder free text options shown in the workorder add of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';
    $Self->{Translation}->{'Workorder free text options shown in the workorder edit of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';
    $Self->{Translation}->{'Workorder free text options shown in the workorder report of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #
    $Self->{Translation}->{'Adapts the width of the autocomplete drop down to the length of the longest option.'} =
        'Menyesuaikan diri lebar kejatuhan autoselesai ke panjang pilihan terpanjang.';
    $Self->{Translation}->{'CAB Agent'} = 'CAB Ejen';
    $Self->{Translation}->{'CAB Customer'} = 'CAB Pelanggan';
    $Self->{Translation}->{'Cache time in minutes for the change management.'} = 'Cache masa dalam minit untuk pengurusan perubahan.';
    $Self->{Translation}->{'Change Description'} = 'Ubah Penerangan';
    $Self->{Translation}->{'Change Impact'} = 'Ubah Kesan';
    $Self->{Translation}->{'Change Justification'} = 'Perubahan Justifikasi';
    $Self->{Translation}->{'Change Number'} = 'Perubahan Nombor';
    $Self->{Translation}->{'Change Priority'} = 'Perubahan Keutamaan';
    $Self->{Translation}->{'Change State'} = 'Perubahan Status';
    $Self->{Translation}->{'Change Title'} = 'Perubahan Tajuk';
    $Self->{Translation}->{'Change limit per page for Change Overview "Small".'} = 'Perubahan had setiap halaman untuk Perubahan Tinjauan "Kecil".';
    $Self->{Translation}->{'Created By'} = 'Dicipta Oleh';
    $Self->{Translation}->{'Delete Change'} = 'Padam Ubah';
    $Self->{Translation}->{'Enables or disables TypeAhead for the autocomplete feature.'} = 'Mendaya atau menyahdaya Taip kepala A untuk ciri autoselesai.';
    $Self->{Translation}->{'Enables or disables the autocomplete feature for the CAB member search in the ITSM agent interface.'} =
        'Mendaya atau melumpuhkan ciri auto lengkap untuk carian ahli CAB di muka ejen ITSM.';
    $Self->{Translation}->{'Enables or disables the autocomplete feature for the customer search in the ITSM agent interface.'} =
        'Mendaya atau menyahdaya ciri auto lengkap untuk carian pelanggan di muka ejen ITSM.';
    $Self->{Translation}->{'Enables or disables the autocomplete feature for the user search in the ITSM agent interface.'} =
        'Mendaya atau menyahdaya ciri auto lengkap untuk carian pengguna di muka ejen ITSM.';
    $Self->{Translation}->{'Reset change and its workorders'} = 'Reset perubahan dan arahan kerja';
    $Self->{Translation}->{'Search Agent'} = 'Carian Ejen';
    $Self->{Translation}->{'Selects the change number generator module. With "Date", the change numbers will be generated by the current date and a counter; this format looks like Year.Month.Day.counter, e.g. 2010062400001, 2010062400002. With "DateChecksum", the counter will be appended as checksum to the string of date plus the SystemID. The checksum will be rotated on a daily basis. This format looks like Year.Month.Day.SystemID.Counter.CheckSum, e.g. 2010062410000017, 2010062410000026.'} =
        'Memilih bilangan penjana perubahan modul. Dengan "Tarikh", nombor perubahan akan dijana oleh tarikh semasa dan kaunter; format ini kelihatan seperti Year.Month.Day.counter, contohnya 2010062400001, 2010062400002. Di Dengan "DateChecksum", kaunter akan dilampirkan sebagai checksum kepada rentetan tarikh ditambah Undur. Checksum akan diputar pada setiap hari. Format ini kelihatan seperti Year.Month.Day.SystemID.Counter.CheckSum, contohnya 2010062410000017, 2010062410000026.';
    $Self->{Translation}->{'Sets the maximal number of search results for the autocomplete feature.'} =
        'Menetapkan bilangan maksimum hasil carian bagi ciri autoselesai.';
    $Self->{Translation}->{'This ACL module restricts the usuage of the ticket types that are defined in the sysconfig option \'ITSMChange::AddChangeLinkTicketTypes\', to users of the groups as defined in "ITSMChange::RestrictTicketTypes::Groups".'} =
        'Modul ACL menghadkan usuage jenis tiket yang ditakrifkan dalam pilihan sysconfig \'ITSMChange::AddChangeLinkTicketTypes\', kepada pengguna kumpulan sebagaimana yang ditakrifkan dalam "ITSMChange::RestrictTicketTypes::Kumpulan".';
    $Self->{Translation}->{'Work Order Title'} = 'Tajuk Perintah Kerja';
    $Self->{Translation}->{'WorkOrder Agent'} = 'Perintah Kerja Ejen';
    $Self->{Translation}->{'WorkOrder Instruction'} = 'Arahan Perintah Kerja';
    $Self->{Translation}->{'WorkOrder Report'} = 'Laporan Perintah Kerja';
    $Self->{Translation}->{'WorkOrder State'} = 'Perintah Kerja Keadaan';

}

1;
