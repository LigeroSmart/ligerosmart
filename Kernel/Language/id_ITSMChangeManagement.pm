# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::id_ITSMChangeManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminITSMChangeCIPAllocate
    $Self->{Translation}->{'Category ↔ Impact ↔ Priority'} = 'Kategori ↔ Dampak ↔ Prioritas';
    $Self->{Translation}->{'Manage the priority result of combinating Category ↔ Impact.'} =
        'Mengelola hasil prioritas kombinasi Kategori ↔ Dampak.';
    $Self->{Translation}->{'Priority allocation'} = 'Alokasi Prioritas';

    # Template: AdminITSMChangeNotification
    $Self->{Translation}->{'ITSM ChangeManagement Notification Management'} = 'Manajemen Pemberitahuan ITSM Manajemen Perubahan';
    $Self->{Translation}->{'Add Notification Rule'} = 'Tambah peraturan notifikasi';
    $Self->{Translation}->{'Edit Notification Rule'} = '';
    $Self->{Translation}->{'A notification should have a name!'} = 'Pemberitahuan harus memiliki nama!';
    $Self->{Translation}->{'Name is required.'} = 'Nama diperlukan.';

    # Template: AdminITSMStateMachine
    $Self->{Translation}->{'Admin State Machine'} = 'Admin State Machine';
    $Self->{Translation}->{'Select a catalog class!'} = 'Pilih kelas katalog!';
    $Self->{Translation}->{'A catalog class is required!'} = 'Sebuah kelas Katalog diperlukan!';
    $Self->{Translation}->{'Add a state transition'} = 'Menambahkan transisi ';
    $Self->{Translation}->{'Catalog Class'} = 'Kelas Katalog';
    $Self->{Translation}->{'Object Name'} = 'Nama obyek';
    $Self->{Translation}->{'Overview over state transitions for'} = 'Keseluruhan state transisi';
    $Self->{Translation}->{'Delete this state transition'} = 'Hapus transisi state berikut';
    $Self->{Translation}->{'Add a new state transition for'} = 'Tambah state transisi baru';
    $Self->{Translation}->{'Please select a state!'} = 'Pilih state';
    $Self->{Translation}->{'Please select a next state!'} = 'Pilih state berikutnya';
    $Self->{Translation}->{'Edit a state transition for'} = 'Edit transisi state';
    $Self->{Translation}->{'Do you really want to delete the state transition'} = 'Apakah Anda benar-benar ingin menghapus transisi?';

    # Template: AgentITSMChangeAdd
    $Self->{Translation}->{'Add Change'} = 'Tambah perubahan';
    $Self->{Translation}->{'ITSM Change'} = 'Ubah ITSM';
    $Self->{Translation}->{'Justification'} = 'Justifikasi';
    $Self->{Translation}->{'Input invalid.'} = 'Pemasukan tidak sah';
    $Self->{Translation}->{'Impact'} = 'Dampak';
    $Self->{Translation}->{'Requested Date'} = 'Tanggal diminta';

    # Template: AgentITSMChangeAddFromTemplate
    $Self->{Translation}->{'Select Change Template'} = 'Pilih perubahan template';
    $Self->{Translation}->{'Time type'} = 'Jenis waktu';
    $Self->{Translation}->{'Invalid time type.'} = 'Jenis waktu tidak sah';
    $Self->{Translation}->{'New time'} = 'Waktu baru';

    # Template: AgentITSMChangeCABTemplate
    $Self->{Translation}->{'Save Change CAB as template'} = 'Simpan perubahan CAB sebagai Template';
    $Self->{Translation}->{'go to involved persons screen'} = 'pergi ke layar orang yang terlibat';
    $Self->{Translation}->{'Invalid Name'} = 'Nama tidak sah';

    # Template: AgentITSMChangeCondition
    $Self->{Translation}->{'Conditions and Actions'} = 'Kondisi dan Tindakan';
    $Self->{Translation}->{'Delete Condition'} = 'Hapus kondisi';
    $Self->{Translation}->{'Add new condition'} = 'Tambah kondisi baru';

    # Template: AgentITSMChangeConditionEdit
    $Self->{Translation}->{'Edit Condition'} = '';
    $Self->{Translation}->{'Need a valid name.'} = 'Perlu nama yang sah';
    $Self->{Translation}->{'A valid name is needed.'} = 'Nama yang sah diperlukan';
    $Self->{Translation}->{'Duplicate name:'} = 'Duplikasi nama';
    $Self->{Translation}->{'This name is already used by another condition.'} = 'Nama tersebut telah digunakan oleh kondisi lainnya';
    $Self->{Translation}->{'Matching'} = 'Sesuai';
    $Self->{Translation}->{'Any expression (OR)'} = 'Ekspresi lainnya (OR)';
    $Self->{Translation}->{'All expressions (AND)'} = 'Semua ekspresi (AND)';
    $Self->{Translation}->{'Expressions'} = 'Ekspresi';
    $Self->{Translation}->{'Selector'} = 'Pemilih';
    $Self->{Translation}->{'Operator'} = 'Pengurus';
    $Self->{Translation}->{'Delete Expression'} = 'Hapus ekspresi';
    $Self->{Translation}->{'No Expressions found.'} = 'Ekspresi tidak ditemukan';
    $Self->{Translation}->{'Add new expression'} = 'Tambah ekspresi baru';
    $Self->{Translation}->{'Delete Action'} = 'Hapus aksi';
    $Self->{Translation}->{'No Actions found.'} = 'Tidak ada aksi ditemukan';
    $Self->{Translation}->{'Add new action'} = 'Tambah aksi baru';

    # Template: AgentITSMChangeDelete
    $Self->{Translation}->{'Do you really want to delete this change?'} = 'Apakah anda ingin menghapus perubahan ini?';

    # Template: AgentITSMChangeEdit
    $Self->{Translation}->{'Edit %s%s'} = '';

    # Template: AgentITSMChangeHistory
    $Self->{Translation}->{'History of %s%s'} = 'Sejarah dari %s%s';
    $Self->{Translation}->{'History Content'} = 'Isi sejarah';
    $Self->{Translation}->{'Workorder'} = 'Tata kerja';
    $Self->{Translation}->{'Createtime'} = 'BuatWaktu';
    $Self->{Translation}->{'Show details'} = 'Tampilkan detail';
    $Self->{Translation}->{'Show workorder'} = 'Tampilkan tata kerja';

    # Template: AgentITSMChangeHistoryZoom
    $Self->{Translation}->{'Detailed history information of %s'} = '';
    $Self->{Translation}->{'Modified'} = 'Diubah';
    $Self->{Translation}->{'Old Value'} = 'Nilai lama';
    $Self->{Translation}->{'New Value'} = 'Nilai baru';

    # Template: AgentITSMChangeInvolvedPersons
    $Self->{Translation}->{'Edit Involved Persons of %s%s'} = '';
    $Self->{Translation}->{'Involved Persons'} = 'Orang yang terlibat';
    $Self->{Translation}->{'ChangeManager'} = 'Ubah manager';
    $Self->{Translation}->{'User invalid.'} = 'Pengguna tidak sah';
    $Self->{Translation}->{'ChangeBuilder'} = 'Ubah pembangun';
    $Self->{Translation}->{'Change Advisory Board'} = 'Dewan Penasehat perubahan';
    $Self->{Translation}->{'CAB Template'} = 'Template CAB';
    $Self->{Translation}->{'Apply Template'} = 'Terapkan Template';
    $Self->{Translation}->{'NewTemplate'} = 'Template baru';
    $Self->{Translation}->{'Save this CAB as template'} = 'Simpan CAB sebagai template';
    $Self->{Translation}->{'Add to CAB'} = 'Tambah CAB';
    $Self->{Translation}->{'Invalid User'} = 'Pengguna tidak sah';
    $Self->{Translation}->{'Current CAB'} = 'CAB saat ini';

    # Template: AgentITSMChangeOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = 'Pengaturan Konteks';
    $Self->{Translation}->{'Changes per page'} = 'Ubah setiap halaman';

    # Template: AgentITSMChangeOverviewSmall
    $Self->{Translation}->{'Workorder Title'} = '';
    $Self->{Translation}->{'Change Title'} = 'Ubah judul';
    $Self->{Translation}->{'Workorder Agent'} = '';
    $Self->{Translation}->{'Change Builder'} = 'Ubah pembangun';
    $Self->{Translation}->{'Change Manager'} = 'Ubah manager';
    $Self->{Translation}->{'Workorders'} = 'Tata kerja';
    $Self->{Translation}->{'Change State'} = 'Ubah state';
    $Self->{Translation}->{'Workorder State'} = '';
    $Self->{Translation}->{'Workorder Type'} = '';
    $Self->{Translation}->{'Requested Time'} = 'Waktu yang diminta';
    $Self->{Translation}->{'Planned Start Time'} = 'Perencanaan waktu';
    $Self->{Translation}->{'Planned End Time'} = 'Perencanaan waktu berakhir';
    $Self->{Translation}->{'Actual Start Time'} = 'Waktu dimulai';
    $Self->{Translation}->{'Actual End Time'} = 'Waktu berakhir';

    # Template: AgentITSMChangeReset
    $Self->{Translation}->{'Do you really want to reset this change?'} = 'Apakah anda ingin mengeset ulang perubahan ini?';

    # Template: AgentITSMChangeSearch
    $Self->{Translation}->{'(e.g. 10*5155 or 105658*)'} = '(Contoh 10*5155 or 105658*)';
    $Self->{Translation}->{'CAB Agent'} = 'Agen CAB';
    $Self->{Translation}->{'e.g.'} = 'Contoh';
    $Self->{Translation}->{'CAB Customer'} = 'Pelanggan CAB';
    $Self->{Translation}->{'ITSM Workorder Instruction'} = '';
    $Self->{Translation}->{'ITSM Workorder Report'} = '';
    $Self->{Translation}->{'ITSM Change Priority'} = '';
    $Self->{Translation}->{'ITSM Change Impact'} = '';
    $Self->{Translation}->{'Change Category'} = 'Ubah kategori';
    $Self->{Translation}->{'(before/after)'} = '(Sebelum/Setelah)';
    $Self->{Translation}->{'(between)'} = '(diantara)';

    # Template: AgentITSMChangeTemplate
    $Self->{Translation}->{'Save Change as Template'} = 'Simpan sebagai template';
    $Self->{Translation}->{'A template should have a name!'} = 'Sebuah template harus memiliki nama!';
    $Self->{Translation}->{'The template name is required.'} = 'Nama Template diperlukan.';
    $Self->{Translation}->{'Reset States'} = 'Atur ulang state';
    $Self->{Translation}->{'Overwrite original template'} = 'Template asli ditimpa';
    $Self->{Translation}->{'Delete original change'} = 'Hapus perubahan asli';

    # Template: AgentITSMChangeTimeSlot
    $Self->{Translation}->{'Move Time Slot'} = 'Pindahkan Waktu Slot';

    # Template: AgentITSMChangeZoom
    $Self->{Translation}->{'Change Information'} = 'Ubah informasi';
    $Self->{Translation}->{'Planned Effort'} = '';
    $Self->{Translation}->{'Accounted Time'} = '';
    $Self->{Translation}->{'Change Initiator(s)'} = 'Perubahan Pemrakarsa (s)';
    $Self->{Translation}->{'CAB'} = 'CAB';
    $Self->{Translation}->{'Last changed'} = 'Terakhir diubah';
    $Self->{Translation}->{'Last changed by'} = 'Terakhir dirubah oleh';
    $Self->{Translation}->{'To open links in the following description blocks, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).'} =
        'Untuk membuka tautan pada bagian deskripsi berikut, Anda harus menekan tombol Ctrl atau Cms atau Shift sambil menekan tautannya (tergantung pada Sistem Operasi dan Peramban)';
    $Self->{Translation}->{'Download Attachment'} = 'Unduh Lampiran';

    # Template: AgentITSMTemplateEditCAB
    $Self->{Translation}->{'Edit CAB Template'} = 'Mengedit CAB Template';

    # Template: AgentITSMTemplateEditContent
    $Self->{Translation}->{'This will create a new change from this template, so you can edit and save it.'} =
        'Ini akan membuat perubahan baru dari template ini, sehingga Anda dapat mengedit dan menyimpannya.';
    $Self->{Translation}->{'The new change will be deleted automatically after it has been saved as template.'} =
        'Perubahan baru akan dihapus secara otomatis setelah telah disimpan sebagai template.';
    $Self->{Translation}->{'This will create a new workorder from this template, so you can edit and save it.'} =
        'Ini akan membuat perintah kerja baru dari template ini, sehingga Anda dapat mengedit dan menyimpannya.';
    $Self->{Translation}->{'A temporary change will be created which contains the workorder.'} =
        'Sebuah perubahan sementara akan dibuat yang berisi perintah kerja.';
    $Self->{Translation}->{'The temporary change and new workorder will be deleted automatically after the workorder has been saved as template.'} =
        'Perubahan sementara dan perintah kerja baru akan dihapus secara otomatis setelah perintah kerja telah disimpan sebagai template.';
    $Self->{Translation}->{'Do you want to proceed?'} = 'Apakah Anda ingin melanjutkan?';

    # Template: AgentITSMTemplateOverviewSmall
    $Self->{Translation}->{'Template ID'} = '';
    $Self->{Translation}->{'Edit Content'} = 'Ubah isi';
    $Self->{Translation}->{'Create by'} = '';
    $Self->{Translation}->{'Change by'} = '';
    $Self->{Translation}->{'Change Time'} = 'Mengubah waktu';

    # Template: AgentITSMWorkOrderAdd
    $Self->{Translation}->{'Add Workorder to %s%s'} = '';
    $Self->{Translation}->{'Instruction'} = 'Instruksi';
    $Self->{Translation}->{'Invalid workorder type.'} = 'Jenis perintah kerja tidak valid';
    $Self->{Translation}->{'The planned start time must be before the planned end time!'} = 'waktu mulai direncanakan harus sebelum waktu akhir yang direncanakan!';
    $Self->{Translation}->{'Invalid format.'} = 'Format tidak sah';

    # Template: AgentITSMWorkOrderAddFromTemplate
    $Self->{Translation}->{'Select Workorder Template'} = 'Pilih Work Order Template';

    # Template: AgentITSMWorkOrderAgent
    $Self->{Translation}->{'Edit Workorder Agent of %s%s'} = '';

    # Template: AgentITSMWorkOrderDelete
    $Self->{Translation}->{'Do you really want to delete this workorder?'} = 'Apakah Anda benar-benar ingin menghapus perintah kerja ini?';
    $Self->{Translation}->{'You can not delete this Workorder. It is used in at least one Condition!'} =
        'Anda tidak dapat menghapus Perintah Kerja ini. Hal ini digunakan dalam setidaknya satu Kondisi!';
    $Self->{Translation}->{'This Workorder is used in the following Condition(s)'} = 'Perintah Kerja ini digunakan dalam Kondisi berikut (s)';

    # Template: AgentITSMWorkOrderEdit
    $Self->{Translation}->{'Edit %s%s-%s'} = '';
    $Self->{Translation}->{'Move following workorders accordingly'} = 'Bergerak mengikuti perintah kerja yang sesuai';
    $Self->{Translation}->{'If the planned end time of this workorder is changed, the planned start times of all following workorders will be changed accordingly'} =
        'Jika waktu akhir yang direncanakan dari perintah kerja ini berubah, kali mulai direncanakan semua perintah kerja berikut akan berubah dengan sesuai';

    # Template: AgentITSMWorkOrderHistory
    $Self->{Translation}->{'History of %s%s-%s'} = '';

    # Template: AgentITSMWorkOrderReport
    $Self->{Translation}->{'Edit Report of %s%s-%s'} = '';
    $Self->{Translation}->{'Report'} = 'Laporan';
    $Self->{Translation}->{'The actual start time must be before the actual end time!'} = 'Waktu mulai yang sebenarnya harus sebelum waktu akhir yang sebenarnya!';
    $Self->{Translation}->{'The actual start time must be set, when the actual end time is set!'} =
        'Waktu mulai yang sebenarnya harus diatur, ketika waktu akhir yang sebenarnya diatur!';

    # Template: AgentITSMWorkOrderTake
    $Self->{Translation}->{'Current Agent'} = 'Agen saat ini';
    $Self->{Translation}->{'Do you really want to take this workorder?'} = 'Apakah Anda benar-benar ingin mengambil pesanan pekerjaan ini?';

    # Template: AgentITSMWorkOrderTemplate
    $Self->{Translation}->{'Save Workorder as Template'} = 'Hemat Work Order sebagai Template';
    $Self->{Translation}->{'Delete original workorder (and surrounding change)'} = 'Hapus perintah kerja asli (dan perubahan sekitarnya)';

    # Template: AgentITSMWorkOrderZoom
    $Self->{Translation}->{'Workorder Information'} = 'Perintah kerja informasi';

    # Perl Module: Kernel/Modules/AdminITSMChangeNotification.pm
    $Self->{Translation}->{'Notification Added!'} = '';
    $Self->{Translation}->{'Unknown notification %s!'} = 'pemberitahuan tidak diketahui %s!';
    $Self->{Translation}->{'There was an error creating the notification.'} = 'Ada kesalahan saat membuat pemberitahuan.';

    # Perl Module: Kernel/Modules/AdminITSMStateMachine.pm
    $Self->{Translation}->{'State Transition Updated!'} = '';
    $Self->{Translation}->{'State Transition Added!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMChange.pm
    $Self->{Translation}->{'Overview: ITSM Changes'} = 'Ikhtisar: ITSM Perubahan';

    # Perl Module: Kernel/Modules/AgentITSMChangeAdd.pm
    $Self->{Translation}->{'Ticket with TicketID %s does not exist!'} = 'Tiket dengan ID tiket %s tidak ada!';
    $Self->{Translation}->{'Missing sysconfig option "ITSMChange::AddChangeLinkTicketTypes"!'} =
        'Opsi sysconfig hllang "ITSMChange::AddChangeLinkTicketTypes"!';
    $Self->{Translation}->{'Was not able to add change!'} = 'Tidak dapat menambahkan perubahan!';

    # Perl Module: Kernel/Modules/AgentITSMChangeAddFromTemplate.pm
    $Self->{Translation}->{'Was not able to create change from template!'} = 'Tidak mampu membuat perubahan dari template!';

    # Perl Module: Kernel/Modules/AgentITSMChangeCABTemplate.pm
    $Self->{Translation}->{'No ChangeID is given!'} = 'Tidak ada Ganti ID diberikan!';
    $Self->{Translation}->{'No change found for changeID %s.'} = 'Tidak ada perubahan yang ditemukan untuk ID perubahan.';
    $Self->{Translation}->{'The CAB of change "%s" could not be serialized.'} = 'CAB perubahan "%s" tidak dapat serial.';
    $Self->{Translation}->{'Could not add the template.'} = 'Tidak dapat menambahkan template.';

    # Perl Module: Kernel/Modules/AgentITSMChangeCondition.pm
    $Self->{Translation}->{'Change "%s" not found in database!'} = 'Ganti "%s" tidak ditemukan dalam database!';
    $Self->{Translation}->{'Could not delete ConditionID %s!'} = 'Tidak dapat menghapus ConditionID %s!';

    # Perl Module: Kernel/Modules/AgentITSMChangeConditionEdit.pm
    $Self->{Translation}->{'No %s is given!'} = 'Tidak ada %s diberikan!';
    $Self->{Translation}->{'Could not create new condition!'} = 'Tidak dapat membuat kondisi baru!';
    $Self->{Translation}->{'Could not update ConditionID %s!'} = 'tidak bisa update ConditionID %s!';
    $Self->{Translation}->{'Could not update ExpressionID %s!'} = 'tidak bisa update Expression %s!';
    $Self->{Translation}->{'Could not add new Expression!'} = 'ak dapat menambahkan Expresi baru!';
    $Self->{Translation}->{'Could not update ActionID %s!'} = 'tidak bisa update ActionID %s!';
    $Self->{Translation}->{'Could not add new Action!'} = 'tidak bisa menambah Action baru!';
    $Self->{Translation}->{'Could not delete ExpressionID %s!'} = 'Tidak dapat menghapus Ekspresi %s!';
    $Self->{Translation}->{'Could not delete ActionID %s!'} = 'Tidak dapat menghapus ActionID %s!';
    $Self->{Translation}->{'Error: Unknown field type "%s"!'} = 'Kesalahan: tidak diketahui jenis field "%s"!';
    $Self->{Translation}->{'ConditionID %s does not belong to the given ChangeID %s!'} = 'Kondisi ID %s tidak memiliki perubahan ID %s!';

    # Perl Module: Kernel/Modules/AgentITSMChangeDelete.pm
    $Self->{Translation}->{'Change "%s" does not have an allowed change state to be deleted!'} =
        'Perubahan "%s" tidak memiliki  perubahan state yang boleh dihapus!';
    $Self->{Translation}->{'Was not able to delete the changeID %s!'} = 'Tidak bisa menghapus perubahan ID';

    # Perl Module: Kernel/Modules/AgentITSMChangeEdit.pm
    $Self->{Translation}->{'Was not able to update Change!'} = 'Tidak dapat memperbarui perubahan';

    # Perl Module: Kernel/Modules/AgentITSMChangeHistory.pm
    $Self->{Translation}->{'Can\'t show history, as no ChangeID is given!'} = 'tidak bisa menunjukkan sejarah, karena tidak ada perubahan ID yang diberikan!';
    $Self->{Translation}->{'Change "%s" not found in the database!'} = 'Perubahan "%s" tidak ditemukan di dalam database!';
    $Self->{Translation}->{'Unknown type "%s" encountered!'} = 'Jenis tidak diketahui "%s" ditemui!';
    $Self->{Translation}->{'Change History'} = 'Ubah sejarah';

    # Perl Module: Kernel/Modules/AgentITSMChangeHistoryZoom.pm
    $Self->{Translation}->{'Can\'t show history zoom, no HistoryEntryID is given!'} = 'tidak bisa menunjukkan sejarah zoom, tidak ada Sejarah EntryID diberikan!';
    $Self->{Translation}->{'HistoryEntry "%s" not found in database!'} = 'Sejarah Entry "%s" tidak ditemukan dalam database!';

    # Perl Module: Kernel/Modules/AgentITSMChangeInvolvedPersons.pm
    $Self->{Translation}->{'Was not able to update Change CAB for Change %s!'} = 'Tidak dapat memperbarui Ganti CAB untuk Perubahan %s!';
    $Self->{Translation}->{'Was not able to update Change %s!'} = 'Tidak dapat memperbarui perubahan %s!';

    # Perl Module: Kernel/Modules/AgentITSMChangeManager.pm
    $Self->{Translation}->{'Overview: ChangeManager'} = 'Ikhtisar: Perubahan manajer';

    # Perl Module: Kernel/Modules/AgentITSMChangeMyCAB.pm
    $Self->{Translation}->{'Overview: My CAB'} = 'Ikhtisar: CAB saya';

    # Perl Module: Kernel/Modules/AgentITSMChangeMyChanges.pm
    $Self->{Translation}->{'Overview: My Changes'} = 'Ikhtisar: Perubahan Saya';

    # Perl Module: Kernel/Modules/AgentITSMChangeMyWorkOrders.pm
    $Self->{Translation}->{'Overview: My Workorders'} = 'Ikhtisar: Perintah Kerja Saya';

    # Perl Module: Kernel/Modules/AgentITSMChangePIR.pm
    $Self->{Translation}->{'Overview: PIR'} = 'Ikhtisar: PIR';

    # Perl Module: Kernel/Modules/AgentITSMChangePSA.pm
    $Self->{Translation}->{'Overview: PSA'} = 'Ikhtisar: PSA';

    # Perl Module: Kernel/Modules/AgentITSMChangePrint.pm
    $Self->{Translation}->{'WorkOrder "%s" not found in database!'} = 'Tatakerja "%s" tidak ditemukan didalam database';
    $Self->{Translation}->{'Can\'t create output, as the workorder is not attached to a change!'} =
        'Tidak dapat membuat output, sebagai perintah kerja tidak terikat pada perubahan!';
    $Self->{Translation}->{'Can\'t create output, as no ChangeID is given!'} = 'Tidak dapat membuat output, karena tidak ada perubahan ID yang diberikan!';
    $Self->{Translation}->{'unknown change title'} = 'Tidak diketahui perubahan judul';
    $Self->{Translation}->{'ITSM Workorder'} = 'Tatakerja ITSM';
    $Self->{Translation}->{'WorkOrderNumber'} = 'Nomor Tata Kerja';
    $Self->{Translation}->{'WorkOrderTitle'} = 'Judul tata kerja';
    $Self->{Translation}->{'unknown workorder title'} = 'Tidak diketahui judul perintah kerja';
    $Self->{Translation}->{'ChangeState'} = 'Ubah state';
    $Self->{Translation}->{'PlannedEffort'} = 'Upaya yang direncanakan';
    $Self->{Translation}->{'CAB Agents'} = '';
    $Self->{Translation}->{'CAB Customers'} = '';
    $Self->{Translation}->{'RequestedTime'} = 'Waktu yang diminta';
    $Self->{Translation}->{'PlannedStartTime'} = 'Waktu mulai direncanakan';
    $Self->{Translation}->{'PlannedEndTime'} = 'Waktu akhir direncanakan';
    $Self->{Translation}->{'ActualStartTime'} = 'Mulai waktu ';
    $Self->{Translation}->{'ActualEndTime'} = 'Waktu berakhir';
    $Self->{Translation}->{'ChangeTime'} = 'Ubah waktu';
    $Self->{Translation}->{'ChangeNumber'} = 'Mengubah Nomor';
    $Self->{Translation}->{'WorkOrderState'} = 'State tata kerja';
    $Self->{Translation}->{'WorkOrderType'} = 'Jenis tata kerja';
    $Self->{Translation}->{'WorkOrderAgent'} = 'Tata kerja agen';
    $Self->{Translation}->{'ITSM Workorder Overview (%s)'} = 'ITSM Keseluruhan perintah kerja (%s)';

    # Perl Module: Kernel/Modules/AgentITSMChangeReset.pm
    $Self->{Translation}->{'Was not able to reset WorkOrder %s of Change %s!'} = 'Tidak bisa me-reset Perintah Kerja %s dari perubahan %s!';
    $Self->{Translation}->{'Was not able to reset Change %s!'} = 'Tidak bisa me-reset Perubahan  %s!';

    # Perl Module: Kernel/Modules/AgentITSMChangeSchedule.pm
    $Self->{Translation}->{'Overview: Change Schedule'} = 'Ikhtisar: Perubahan Jadwal';

    # Perl Module: Kernel/Modules/AgentITSMChangeSearch.pm
    $Self->{Translation}->{'Change Search'} = 'Mengubah pencarian';
    $Self->{Translation}->{'ChangeTitle'} = 'Ubah judul';
    $Self->{Translation}->{'WorkOrders'} = 'Perintah kerja';
    $Self->{Translation}->{'Change Search Result'} = 'Mengubah hasil pencarian';
    $Self->{Translation}->{'Change Number'} = 'Ubah nomor';
    $Self->{Translation}->{'Work Order Title'} = 'Judul perintah kerja';
    $Self->{Translation}->{'Change Description'} = 'Mengubah deskripsi';
    $Self->{Translation}->{'Change Justification'} = 'Mengubah justifikasi';
    $Self->{Translation}->{'WorkOrder Instruction'} = 'Instruksi perintah kerja';
    $Self->{Translation}->{'WorkOrder Report'} = 'Laporan perintah kerja';
    $Self->{Translation}->{'Change Priority'} = 'Ubah prioritas';
    $Self->{Translation}->{'Change Impact'} = 'Ubah dampak';
    $Self->{Translation}->{'Created By'} = 'Diciptakan oleh';
    $Self->{Translation}->{'WorkOrder State'} = 'State perintah kerja';
    $Self->{Translation}->{'WorkOrder Type'} = 'Jenis perintah kerja';
    $Self->{Translation}->{'WorkOrder Agent'} = 'Perintah kerja agen';
    $Self->{Translation}->{'before'} = 'Sebelum';

    # Perl Module: Kernel/Modules/AgentITSMChangeTemplate.pm
    $Self->{Translation}->{'The change "%s" could not be serialized.'} = 'Perubahan "%s"tidak dapat serial. ';
    $Self->{Translation}->{'Could not update the template "%s".'} = 'tidak bisa update template "%s"';
    $Self->{Translation}->{'Could not delete change "%s".'} = 'tidak bisa menghapus perubahan "%s"';

    # Perl Module: Kernel/Modules/AgentITSMChangeTimeSlot.pm
    $Self->{Translation}->{'The change can\'t be moved, as it has no workorders.'} = 'perubahan tidak dapat dipindahkan, karena tidak memiliki perintah kerja.';
    $Self->{Translation}->{'Add a workorder first.'} = 'pertama tambahkan perintah kerja';
    $Self->{Translation}->{'Can\'t move a change which already has started!'} = 'Tidak dapat memindahkan perubahan yang sudah telah dimulai!';
    $Self->{Translation}->{'Please move the individual workorders instead.'} = 'Silakan memindahkan perintah kerja individu sebagai gantinya.';
    $Self->{Translation}->{'The current %s could not be determined.'} = 'Saat ini %s tidak dapat ditentukan.';
    $Self->{Translation}->{'The %s of all workorders has to be defined.'} = '%s dari semua perintah kerja harus didefinisikan.';
    $Self->{Translation}->{'Was not able to move time slot for workorder #%s!'} = 'Tidak bisa bergerak slot waktu untuk perintah kerja #%s!';

    # Perl Module: Kernel/Modules/AgentITSMTemplateDelete.pm
    $Self->{Translation}->{'You need %s permission!'} = 'Anda perlu %s izin!';
    $Self->{Translation}->{'No TemplateID is given!'} = 'Tidak ada ID Template diberikan!';
    $Self->{Translation}->{'Template "%s" not found in database!'} = 'Template "%s" tidak ditemukan dalam database!';
    $Self->{Translation}->{'Was not able to delete the template %s!'} = 'Tidak bisa menghapus template %s!';

    # Perl Module: Kernel/Modules/AgentITSMTemplateEdit.pm
    $Self->{Translation}->{'Was not able to update Template %s!'} = 'Tidak dapat memperbarui Template %s!';

    # Perl Module: Kernel/Modules/AgentITSMTemplateEditCAB.pm
    $Self->{Translation}->{'Was not able to update Template "%s"!'} = 'Tidak dapat memperbarui Template "%s"!';

    # Perl Module: Kernel/Modules/AgentITSMTemplateEditContent.pm
    $Self->{Translation}->{'Was not able to create change!'} = 'Tidak mampu membuat perubahan!';
    $Self->{Translation}->{'Was not able to create workorder from template!'} = 'Tidak mampu menciptakan perintah kerja dari Template!';

    # Perl Module: Kernel/Modules/AgentITSMTemplateOverview.pm
    $Self->{Translation}->{'Overview: Template'} = 'Ikhtisar: Template';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderAdd.pm
    $Self->{Translation}->{'You need %s permissions on the change!'} = 'Anda perlu %s izin pada perubahan!';
    $Self->{Translation}->{'Was not able to add workorder!'} = 'Tidak dapat menambahkan perintah kerja!';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderAgent.pm
    $Self->{Translation}->{'No WorkOrderID is given!'} = 'Tidak ada ID perintah kerja diberikan!';
    $Self->{Translation}->{'Was not able to set the workorder agent of the workorder "%s" to empty!'} =
        'Tidak mampu mengatur agen perintah kerja dari perintah kerja "%s" untuk mengosongkan!';
    $Self->{Translation}->{'Was not able to update the workorder "%s"!'} = 'Tidak dapat memperbarui perintah kerja "%s"!';
    $Self->{Translation}->{'Could not find Change for WorkOrder %s!'} = 'Tidak dapat memperbarui perintah kerja %s!';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderDelete.pm
    $Self->{Translation}->{'Was not able to delete the workorder %s!'} = 'Tidak dapat menghapus perintah kerja %s!';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderEdit.pm
    $Self->{Translation}->{'Was not able to update WorkOrder %s!'} = 'Tidak dapat memperbarui Perintah Kerja %s!';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderHistory.pm
    $Self->{Translation}->{'Can\'t show history, as no WorkOrderID is given!'} = 'tidak bisa menunjukkan sejarah, karena tidak ada ID Tata Kerja diberikan!';
    $Self->{Translation}->{'WorkOrder "%s" not found in the database!'} = 'Work Order "%s" tidak ditemukan dalam database!';
    $Self->{Translation}->{'WorkOrder History'} = 'Riwayat perintah kerja';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderHistoryZoom.pm
    $Self->{Translation}->{'History entry "%s" not found in the database!'} = 'entri sejarah "%s" tidak ditemukan dalam database!';
    $Self->{Translation}->{'WorkOrder History Zoom'} = 'Riwayat Zoom Bekerja';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderTake.pm
    $Self->{Translation}->{'Was not able to take the workorder %s!'} = 'Tidak bisa mengambil perintah kerja!';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderTemplate.pm
    $Self->{Translation}->{'The workorder "%s" could not be serialized.'} = 'Perintah kerja "%s" tidak dapat serial.';

    # Perl Module: Kernel/Output/HTML/Layout/ITSMChange.pm
    $Self->{Translation}->{'Need config option %s!'} = '';
    $Self->{Translation}->{'Config option %s needs to be a HASH ref!'} = '';
    $Self->{Translation}->{'No config option found for the view "%s"!'} = '';
    $Self->{Translation}->{'Title: %s | Type: %s'} = '';

    # Perl Module: Kernel/Output/HTML/ToolBar/MyCAB.pm
    $Self->{Translation}->{'My CABs'} = 'CABs saya';

    # Perl Module: Kernel/Output/HTML/ToolBar/MyChanges.pm
    $Self->{Translation}->{'My Changes'} = 'Perubahan saya';

    # Perl Module: Kernel/Output/HTML/ToolBar/MyWorkOrders.pm
    $Self->{Translation}->{'My Work Orders'} = 'Perintah kerja saya';

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
    $Self->{Translation}->{'any'} = 'Apa saja';

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
    $Self->{Translation}->{'requested'} = 'Diminta';
    $Self->{Translation}->{'pending approval'} = 'approval tertunda';
    $Self->{Translation}->{'rejected'} = 'Ditolak';
    $Self->{Translation}->{'approved'} = 'Disetujui';
    $Self->{Translation}->{'in progress'} = 'Dalam proses';
    $Self->{Translation}->{'pending pir'} = 'PIR Tertunda';
    $Self->{Translation}->{'successful'} = 'Berhasil';
    $Self->{Translation}->{'failed'} = 'Gagal';
    $Self->{Translation}->{'canceled'} = 'Dibatalkan';
    $Self->{Translation}->{'retracted'} = 'Dicabut';
    $Self->{Translation}->{'created'} = 'Diciptakan';
    $Self->{Translation}->{'accepted'} = 'Diterima';
    $Self->{Translation}->{'ready'} = 'Sedia';
    $Self->{Translation}->{'approval'} = 'Persetujuan';
    $Self->{Translation}->{'workorder'} = 'perintah kerja';
    $Self->{Translation}->{'backout'} = 'Mungkir';
    $Self->{Translation}->{'decision'} = 'Keputusan';
    $Self->{Translation}->{'pir'} = 'PIR';
    $Self->{Translation}->{'ChangeStateID'} = '';
    $Self->{Translation}->{'CategoryID'} = '';
    $Self->{Translation}->{'ImpactID'} = '';
    $Self->{Translation}->{'PriorityID'} = '';
    $Self->{Translation}->{'ChangeManagerID'} = '';
    $Self->{Translation}->{'ChangeBuilderID'} = '';
    $Self->{Translation}->{'WorkOrderStateID'} = '';
    $Self->{Translation}->{'WorkOrderTypeID'} = '';
    $Self->{Translation}->{'WorkOrderAgentID'} = '';
    $Self->{Translation}->{'is'} = 'adalah';
    $Self->{Translation}->{'is not'} = 'bukan';
    $Self->{Translation}->{'is empty'} = 'kosong';
    $Self->{Translation}->{'is not empty'} = 'bukan kosong';
    $Self->{Translation}->{'is greater than'} = 'lebih besar dari';
    $Self->{Translation}->{'is less than'} = 'kurang dari';
    $Self->{Translation}->{'is before'} = 'sebelum';
    $Self->{Translation}->{'is after'} = 'setelah';
    $Self->{Translation}->{'contains'} = 'Isi';
    $Self->{Translation}->{'not contains'} = 'bukan isi';
    $Self->{Translation}->{'begins with'} = 'Dimulai dengan';
    $Self->{Translation}->{'ends with'} = 'Berakhir dengan';
    $Self->{Translation}->{'set'} = 'Aturan';

    # JS File: ITSM.Agent.ChangeManagement.Condition
    $Self->{Translation}->{'Do you really want to delete this expression?'} = '';
    $Self->{Translation}->{'Do you really want to delete this action?'} = '';
    $Self->{Translation}->{'Do you really want to delete this condition?'} = '';

    # JS File: ITSM.Agent.ChangeManagement.ConfirmDialog
    $Self->{Translation}->{'Ok'} = 'Ok';

    # SysConfig
    $Self->{Translation}->{'A list of the agents who have permission to take workorders. Key is a login name. Content is 0 or 1.'} =
        'Sebuah daftar agen yang memiliki izin untuk menerima perintah kerja. Key adalah nama login. Konten adalah 0 atau 1.';
    $Self->{Translation}->{'A list of workorder states, at which the ActualStartTime of a workorder will be set if it was empty at this point.'} =
        'Daftar status perintah kerja di mana sebenarnya Start Time dari workorder akan ditetapkan apakah itu kosong pada saat ini.';
    $Self->{Translation}->{'Actual end time'} = '';
    $Self->{Translation}->{'Actual start time'} = '';
    $Self->{Translation}->{'Add Workorder'} = 'Tambahkan Work Order';
    $Self->{Translation}->{'Add Workorder (from Template)'} = '';
    $Self->{Translation}->{'Add a change from template.'} = 'Tambah perubahan dari template';
    $Self->{Translation}->{'Add a change.'} = 'Tambah perubahan';
    $Self->{Translation}->{'Add a workorder (from template) to the change.'} = '';
    $Self->{Translation}->{'Add a workorder to the change.'} = '';
    $Self->{Translation}->{'Add from template'} = 'Tambahkan dari template';
    $Self->{Translation}->{'Admin of the CIP matrix.'} = 'Matriks CIP admin';
    $Self->{Translation}->{'Admin of the state machine.'} = 'Mesin state admin';
    $Self->{Translation}->{'Agent interface notification module to see the number of change advisory boards.'} =
        'module notifikasi agen antar muka untuk melihat nomor dari perubahan';
    $Self->{Translation}->{'Agent interface notification module to see the number of changes managed by the user.'} =
        'Agen modul pemberitahuan antarmuka untuk melihat jumlah perubahan dikelola oleh pengguna.';
    $Self->{Translation}->{'Agent interface notification module to see the number of changes.'} =
        'Agen modul pemberitahuan antarmuka untuk melihat jumlah perubahan.';
    $Self->{Translation}->{'Agent interface notification module to see the number of workorders.'} =
        'Modul pemberitauan di antarmuka agen untuk melihat jumlah perintah kerja';
    $Self->{Translation}->{'CAB Member Search'} = 'Cari anggota CAB';
    $Self->{Translation}->{'Cache time in minutes for the change management toolbars. Default: 3 hours (180 minutes).'} =
        'waktu cache di menit untuk toolbar perubahan manajemen. Default: 3 jam (180 menit).';
    $Self->{Translation}->{'Cache time in minutes for the change management. Default: 5 days (7200 minutes).'} =
        'waktu cache di menit untuk manajemen perubahan. Default: 5 hari (7200 menit).';
    $Self->{Translation}->{'Change CAB Templates'} = 'Mengubah template CAB';
    $Self->{Translation}->{'Change History.'} = 'Mengubah sejarah';
    $Self->{Translation}->{'Change Involved Persons.'} = 'Mengubah orang yang terlibat';
    $Self->{Translation}->{'Change Overview "Small" Limit'} = 'Batas mengubah keseluruhan "Kecil" ';
    $Self->{Translation}->{'Change Overview.'} = 'Mengubah keseluruhan';
    $Self->{Translation}->{'Change Print.'} = 'Mengubah print';
    $Self->{Translation}->{'Change Schedule'} = 'Ubah jadwal';
    $Self->{Translation}->{'Change Schedule.'} = 'Mengubah jadwal';
    $Self->{Translation}->{'Change Settings'} = '';
    $Self->{Translation}->{'Change Zoom'} = '';
    $Self->{Translation}->{'Change Zoom.'} = 'Mengubah zoom';
    $Self->{Translation}->{'Change and Workorder Templates'} = '';
    $Self->{Translation}->{'Change and workorder templates edited by this user.'} = '';
    $Self->{Translation}->{'Change area.'} = 'Mengubah area';
    $Self->{Translation}->{'Change involved persons of the change.'} = '';
    $Self->{Translation}->{'Change limit per page for Change Overview "Small".'} = '';
    $Self->{Translation}->{'Change number'} = '';
    $Self->{Translation}->{'Change search backend router of the agent interface.'} = 'Ubah pencarian backend router dari interface agen.';
    $Self->{Translation}->{'Change state'} = '';
    $Self->{Translation}->{'Change time'} = '';
    $Self->{Translation}->{'Change title'} = '';
    $Self->{Translation}->{'Condition Edit'} = 'Edit kondisi';
    $Self->{Translation}->{'Condition Overview'} = 'Kondisi keseluruhan';
    $Self->{Translation}->{'Configure which screen should be shown after a new workorder has been created.'} =
        '';
    $Self->{Translation}->{'Configures how often the notifications are sent when planned the start time or other time values have been reached/passed.'} =
        'Mengkonfigurasi seberapa sering pemberitahuan dikirim ketika direncanakan waktu mulai atau waktu lainnya yang telah tercapai / berlalu.';
    $Self->{Translation}->{'Create Change'} = 'Membuat perubahan';
    $Self->{Translation}->{'Create Change (from Template)'} = '';
    $Self->{Translation}->{'Create a change (from template) from this ticket.'} = '';
    $Self->{Translation}->{'Create a change from this ticket.'} = '';
    $Self->{Translation}->{'Create and manage ITSM Change Management notifications.'} = 'membuat dan mengelola pemberitahuan ITSM Manajemen Perubahan.';
    $Self->{Translation}->{'Create and manage change notifications.'} = '';
    $Self->{Translation}->{'Default type for a workorder. This entry must exist in general catalog class \'ITSM::ChangeManagement::WorkOrder::Type\'.'} =
        'Jenis default untuk perintah kerja. Catatan ini harus ada dalam kelas katalog umum \'ITSM::ChangeManagement::WorkOrder::Type\'.';
    $Self->{Translation}->{'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js and Core.Agent.LinkObject.js.'} =
        '';
    $Self->{Translation}->{'Define the signals for each workorder state.'} = 'Mendefinisikan sinyal untuk setiap negara perintah kerja.';
    $Self->{Translation}->{'Define which columns are shown in the linked Changes widget (LinkObject::ViewMode = "complex"). Note: Only Change attributes are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.'} =
        '';
    $Self->{Translation}->{'Define which columns are shown in the linked Workorder widget (LinkObject::ViewMode = "complex"). Note: Only Workorder attributes are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.'} =
        '';
    $Self->{Translation}->{'Defines an overview module to show the small view of a change list.'} =
        'Mendefinisikan sebuah modul gambaran untuk menunjukkan pandangan kecil dari daftar perubahan.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a template list.'} =
        'Mendefinisikan sebuah modul gambaran untuk menunjukkan pandangan kecil dari daftar template.';
    $Self->{Translation}->{'Defines if it will be possible to print the accounted time.'} = 'Mendefinisikan jika itu akan mungkin untuk mencetak waktu dipertanggungjawabkan.';
    $Self->{Translation}->{'Defines if it will be possible to print the planned effort.'} = 'Mendefinisikan jika itu akan mungkin untuk mencetak upaya yang direncanakan.';
    $Self->{Translation}->{'Defines if reachable (as defined by the state machine) change end states should be allowed if a change is in a locked state.'} =
        'Mendefinisikan jika dicapai (seperti yang didefinisikan oleh mesin) state perubahan akhir harus diizinkan jika perubahan dalam keadaan terkunci.';
    $Self->{Translation}->{'Defines if reachable (as defined by the state machine) workorder end states should be allowed if a workorder is in a locked state.'} =
        'Mendefinisikan jika dicapai (seperti yang didefinisikan oleh mesin) perintah kerja akhir harus diizinkan jika perintah kerja dalam keadaan terkunci.';
    $Self->{Translation}->{'Defines if the accounted time should be shown.'} = 'Mendifinisikan waktu untuk ditunjukkan';
    $Self->{Translation}->{'Defines if the actual start and end times should be set.'} = 'Mendifinisikan waktu mulai dan waktu berakhir harus bisa diatur';
    $Self->{Translation}->{'Defines if the change search and the workorder search functions could use the mirror DB.'} =
        'Mendifinisikan jika perubahan pencarian dan fungsi pencarian perintah kerja bisa menggunakan DB';
    $Self->{Translation}->{'Defines if the change state can be set in the change edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines if the planned effort should be shown.'} = 'Mendefinisikan jika upaya yang direncanakan harus ditampilkan.';
    $Self->{Translation}->{'Defines if the requested date should be print by customer.'} = 'Mendefinisikan jika tanggal yang diminta harus dicetak oleh pelanggan.';
    $Self->{Translation}->{'Defines if the requested date should be searched by customer.'} =
        'Mendefinisikan jika tanggal yang diminta harus dicari oleh pelanggan.';
    $Self->{Translation}->{'Defines if the requested date should be set by customer.'} = 'Mendefinisikan jika tanggal yang diminta harus ditetapkan oleh pelanggan.';
    $Self->{Translation}->{'Defines if the requested date should be shown by customer.'} = 'Mendefinisikan jika tanggal yang diminta harus ditampilkan oleh pelanggan.';
    $Self->{Translation}->{'Defines if the workorder state should be shown.'} = 'Mendefinisikan jika perintah kerja harus ditampilkan.';
    $Self->{Translation}->{'Defines if the workorder title should be shown.'} = 'Mendefinisikan jika judul perintah kerja harus ditampilkan.';
    $Self->{Translation}->{'Defines shown graph attributes.'} = 'Mendefinisikan atribut grafik ditampilkan.';
    $Self->{Translation}->{'Defines that only changes containing Workorders linked with services, which the customer user has permission to use will be shown. Any other changes will not be displayed.'} =
        'Mendefinisikan bahwa hanya perubahan yang mengandung Pesanan Kerja terkait dengan layanan yang pengguna pelanggan memiliki izin untuk menggunakan akan ditampilkan. Perubahan lain tidak akan ditampilkan.';
    $Self->{Translation}->{'Defines the change states that will be allowed to delete.'} = 'Mendifinisikan perubahan yang akan diijinkan untuk dihapus';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the Change PSA overview.'} =
        'Mendefinisikan perubahan akan digunakan sebagai filter dalam perubahan PSA';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the Change Schedule overview.'} =
        'Mendefinisikan perubahan akan digunakan sebagai filter dalam perubahan jadwal';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the MyCAB overview.'} =
        'Mendefinisikan perubahan yang akan digunakan sebagai filter dalam MyCAB';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the MyChanges overview.'} =
        'Mendefinisikan perubahan yang akan digunakan sebagai filter dalam MyChages ';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the change manager overview.'} =
        'Mendefinisikan perubahan yang akan digunakan sebagai filter dalam perubahan manajer';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the change overview.'} =
        'Mendefinisikan perubahan yang akan digunakan sebagai filter dalam perubahan';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the customer change schedule overview.'} =
        'Mendefinisikan perubahan yang akan digunakan sebagai filter dalam perubahan jadwal pelanggan ';
    $Self->{Translation}->{'Defines the default change title for a dummy change which is needed to edit a workorder template.'} =
        'Mendefinisikan judul perubahan default untuk perubahan boneka yang diperlukan untuk mengedit perintah kerja Template.';
    $Self->{Translation}->{'Defines the default sort criteria in the change PSA overview.'} =
        'Mendefinisikan kriteria standar semacam dalam perubahan PSA ';
    $Self->{Translation}->{'Defines the default sort criteria in the change manager overview.'} =
        'Mendefinisikan kriteria standar semacam dalam perubahan manajer ';
    $Self->{Translation}->{'Defines the default sort criteria in the change overview.'} = 'Mendefinisikan kriteria standar semacam dalam perubahan';
    $Self->{Translation}->{'Defines the default sort criteria in the change schedule overview.'} =
        'Mendefinisikan kriteria standar semacam di jadwal perubahan';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the MyCAB overview.'} =
        'Mendefinisikan kriteria standar semacam perubahan dalam My CAB';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the MyChanges overview.'} =
        'Mendefinisikan kriteria standar semacam perubahan dalam MyChanges';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the MyWorkorders overview.'} =
        'Mendefinisikan kriteria standar semacam perubahan dalam pesanan Kerja';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the PIR overview.'} =
        'Mendefinisikan kriteria standar semacam perubahan dalam PIR';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the customer change schedule overview.'} =
        'Mendefinisikan kriteria standar semacam perubahan jadwal perubahan pelanggan';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the template overview.'} =
        'Mendefinisikan kriteria standar semacam perubahan dalam template';
    $Self->{Translation}->{'Defines the default sort order in the MyCAB overview.'} = 'Mendefinisikan urutan standar semacam di My CAB';
    $Self->{Translation}->{'Defines the default sort order in the MyChanges overview.'} = 'Mendefinisikan urutan standar semacam di MyChanges';
    $Self->{Translation}->{'Defines the default sort order in the MyWorkorders overview.'} =
        'Mendefinisikan urutan standar semacam di pesanan Kerja';
    $Self->{Translation}->{'Defines the default sort order in the PIR overview.'} = 'Mendefinisikan urutan standar semacam di PIR';
    $Self->{Translation}->{'Defines the default sort order in the change PSA overview.'} = 'Mendefinisikan urutan default di PSA perubahan';
    $Self->{Translation}->{'Defines the default sort order in the change manager overview.'} =
        'Mendefinisikan urutan standar semacam di perubahan manajer';
    $Self->{Translation}->{'Defines the default sort order in the change overview.'} = 'Mendefinisikan urutan default dalam perubahan';
    $Self->{Translation}->{'Defines the default sort order in the change schedule overview.'} =
        'Mendefinisikan urutan default dalam jadwal perubahan';
    $Self->{Translation}->{'Defines the default sort order in the customer change schedule overview.'} =
        'Mendefinisikan urutan default dalam jadwal perubahan pelanggan';
    $Self->{Translation}->{'Defines the default sort order in the template overview.'} = 'Mendefinisikan urutan standar semacam di template';
    $Self->{Translation}->{'Defines the default value for the category of a change.'} = 'Mendefinisikan nilai default untuk kategori perubahan.';
    $Self->{Translation}->{'Defines the default value for the impact of a change.'} = 'Mendefinisikan nilai default untuk dampak perubahan.';
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
        'Mendefinisikan periode (tahun), di mana waktu mulai dan bisa dipilih.';
    $Self->{Translation}->{'Defines the shown attributes of a workorder in the tooltip of the workorder graph in the change zoom. To show workorder dynamic fields in the tooltip, they must be specified like DynamicField_WorkOrderFieldName1, DynamicField_WorkOrderFieldName2, etc.'} =
        'Mendefinisikan atribut ditampilkan dari perintah kerja di tooltip dari grafik perintah kerja di zoom perubahan. Untuk menampilkan field workorder dinamis dalam tooltip, mereka harus ditentukan seperti DynamicField_WorkOrderFieldName1, DynamicField_WorkOrderFieldName2, etc.';
    $Self->{Translation}->{'Defines the shown columns in the Change PSA overview. This option has no effect on the position of the column.'} =
        'Mendefinisikan acara kolom di Ganti PSA gambaran. Pilihan ini tidak berpengaruh pada posisi kolom.';
    $Self->{Translation}->{'Defines the shown columns in the Change Schedule overview. This option has no effect on the position of the column.'} =
        'Mendefinisikan acara kolom di Ubah Jadwal. Pilihan ini tidak berpengaruh pada posisi kolom.';
    $Self->{Translation}->{'Defines the shown columns in the MyCAB overview. This option has no effect on the position of the column.'} =
        'Mendefinisikan acara kolom di My CAB. Pilihan ini tidak berpengaruh pada posisi kolom.';
    $Self->{Translation}->{'Defines the shown columns in the MyChanges overview. This option has no effect on the position of the column.'} =
        'Mendefinisikan acara kolom di Perubahan gambaran. Pilihan ini tidak berpengaruh pada posisi kolom.';
    $Self->{Translation}->{'Defines the shown columns in the MyWorkorders overview. This option has no effect on the position of the column.'} =
        'Mendefinisikan acara kolom di perintah kerja. Pilihan ini tidak berpengaruh pada posisi kolom.';
    $Self->{Translation}->{'Defines the shown columns in the PIR overview. This option has no effect on the position of the column.'} =
        'Mendefinisikan acara kolom di PIR. Pilihan ini tidak berpengaruh pada posisi kolom.';
    $Self->{Translation}->{'Defines the shown columns in the change manager overview. This option has no effect on the position of the column.'} =
        'Mendefinisikan acara kolom dalam perubahan manajer. Pilihan ini tidak berpengaruh pada posisi kolom.';
    $Self->{Translation}->{'Defines the shown columns in the change overview. This option has no effect on the position of the column.'} =
        'Mendefinisikan acara kolom dalam perubahan. Pilihan ini tidak berpengaruh pada posisi kolom.';
    $Self->{Translation}->{'Defines the shown columns in the change search. This option has no effect on the position of the column.'} =
        'Mendefinisikan acara kolom dalam pencarian perubahan. Pilihan ini tidak berpengaruh pada posisi kolom.';
    $Self->{Translation}->{'Defines the shown columns in the customer change schedule overview. This option has no effect on the position of the column.'} =
        'Mendefinisikan acara kolom di pelanggan jadwal perubahan. Pilihan ini tidak berpengaruh pada posisi kolom.';
    $Self->{Translation}->{'Defines the shown columns in the template overview. This option has no effect on the position of the column.'} =
        'Mendefinisikan acara kolom di template. Pilihan ini tidak berpengaruh pada posisi kolom.';
    $Self->{Translation}->{'Defines the signals for each ITSM change state.'} = '';
    $Self->{Translation}->{'Defines the template types that will be used as filters in the template overview.'} =
        'Mendefinisikan jenis template yang akan digunakan sebagai filter dalam template';
    $Self->{Translation}->{'Defines the workorder states that will be used as filters in the MyWorkorders overview.'} =
        'Mendefinisikan state perintah kerja yang akan digunakan sebagai filter dalam MyWorkorders ';
    $Self->{Translation}->{'Defines the workorder states that will be used as filters in the PIR overview.'} =
        'Mendefinisikan perintah kerja yang akan digunakan sebagai filter dalam PIR';
    $Self->{Translation}->{'Defines the workorder types that will be used to show the PIR overview.'} =
        'Mendefinisikan jenis perintah kerja yang akan digunakan untuk menunjukkan PIR';
    $Self->{Translation}->{'Defines whether notifications should be sent.'} = 'Mendefinisikan apakah pemberitahuan harus dikirim.';
    $Self->{Translation}->{'Delete a change.'} = 'Menghapus perubahan.';
    $Self->{Translation}->{'Delete the change.'} = '';
    $Self->{Translation}->{'Delete the workorder.'} = '';
    $Self->{Translation}->{'Details of a change history entry.'} = 'Rincian dari entri perubahan sejarah.';
    $Self->{Translation}->{'Determines if an agent can exchange the X-axis of a stat if he generates one.'} =
        'Menentukan apakah agen dapat bertukar X jika ia menghasilkan satu.';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes done for config item classes.'} =
        'Menentukan apakah modul statistik umum dapat menghasilkan statistik tentang perubahan dilakukan untuk kelas config barang.';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes regarding change state updates within a timeperiod.'} =
        'Menentukan apakah modul statistik umum dapat menghasilkan statistik tentang perubahan mengenai update perubahan dalam periode waktu.';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes regarding the relation between changes and incident tickets.'} =
        'Menentukan apakah modul statistik umum dapat menghasilkan statistik tentang perubahan mengenai hubungan antara perubahan dan tiket insiden.';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes.'} =
        'Menentukan apakah modul statistik umum dapat menghasilkan statistik tentang perubahan.';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about the number of Rfc tickets a requester created.'} =
        'Menentukan apakah modul statistik umum dapat menghasilkan statistik tentang jumlah tiket pemohon RFC ';
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
        'Dinamis modul acara Lapangan untuk menangani update kondisi jika bidang yang dinamis ditambahkan, diperbarui atau dihapus.';
    $Self->{Translation}->{'Edit a change.'} = 'Mengedit perubahan';
    $Self->{Translation}->{'Edit the change.'} = '';
    $Self->{Translation}->{'Edit the conditions of the change.'} = '';
    $Self->{Translation}->{'Edit the workorder.'} = '';
    $Self->{Translation}->{'Enables the minimal change counter size (if "Date" was selected as ITSMChange::NumberGenerator).'} =
        '';
    $Self->{Translation}->{'Forward schedule of changes. Overview over approved changes.'} =
        'Perubahan bahwa jadwal dimajukan . Ikhtisar lebih perubahan disetujui.';
    $Self->{Translation}->{'History Zoom'} = 'sejarah Zoom/Dekat';
    $Self->{Translation}->{'ITSM Change CAB Templates.'} = 'ITSM mengubah template CAB';
    $Self->{Translation}->{'ITSM Change Condition Edit.'} = 'ITSM mengubah kondisi';
    $Self->{Translation}->{'ITSM Change Condition Overview.'} = 'Perubahan Kondisi ITSM';
    $Self->{Translation}->{'ITSM Change Manager Overview.'} = 'Mengubah manajer ITSM';
    $Self->{Translation}->{'ITSM Change Notifications'} = '';
    $Self->{Translation}->{'ITSM Change PIR Overview.'} = 'Mengubah PIR ITSM';
    $Self->{Translation}->{'ITSM Change notification rules'} = 'Mengubah peraturan notifikasi ITSM';
    $Self->{Translation}->{'ITSM Changes'} = 'Perubahan ITSM';
    $Self->{Translation}->{'ITSM MyCAB Overview.'} = 'Ikhtisar MyCAB ITSM';
    $Self->{Translation}->{'ITSM MyChanges Overview.'} = 'Ikhtisar MyChanges ITSM';
    $Self->{Translation}->{'ITSM MyWorkorders Overview.'} = 'Ikhtisar MyWorkorders ITSM';
    $Self->{Translation}->{'ITSM Template Delete.'} = 'Menghapus template ITSM';
    $Self->{Translation}->{'ITSM Template Edit CAB.'} = 'ITSM mengedit template CAB';
    $Self->{Translation}->{'ITSM Template Edit Content.'} = 'Mengedit isi template ITSM';
    $Self->{Translation}->{'ITSM Template Edit.'} = 'Mengedit template ITSM';
    $Self->{Translation}->{'ITSM Template Overview.'} = 'Template ITSM';
    $Self->{Translation}->{'ITSM event module that cleans up conditions.'} = 'ITSM acara modul yang membersihkan kondisi.';
    $Self->{Translation}->{'ITSM event module that deletes the cache for a toolbar.'} = 'ITSM acara modul yang menghapus cache untuk toolbar.';
    $Self->{Translation}->{'ITSM event module that deletes the history of changes.'} = 'ITSM acara modul yang menghapus sejarah perubahan.';
    $Self->{Translation}->{'ITSM event module that matches conditions and executes actions.'} =
        'ITSM acara modul yang cocok kondisi dan mengeksekusi tindakan.';
    $Self->{Translation}->{'ITSM event module that sends notifications.'} = 'ITSM acara modul yang mengirimkan pemberitahuan.';
    $Self->{Translation}->{'ITSM event module that updates the history of changes.'} = 'ITSM acara modul yang update sejarah perubahan.';
    $Self->{Translation}->{'ITSM event module that updates the history of conditions.'} = 'ITSM acara modul yang update sejarah kondisi.';
    $Self->{Translation}->{'ITSM event module that updates the history of workorders.'} = 'ITSM acara modul yang update sejarah perintah kerja.';
    $Self->{Translation}->{'ITSM event module to recalculate the workorder numbers.'} = 'ITSM acara modul untuk menghitung angka perintah kerja.';
    $Self->{Translation}->{'ITSM event module to set the actual start and end times of workorders.'} =
        'ITSM acara modul untuk mengatur sebenarnya mulai dan akhir dari perintah kerja.';
    $Self->{Translation}->{'ITSMChange'} = 'Perubahan ITSM';
    $Self->{Translation}->{'ITSMWorkOrder'} = 'Tata Kerja ITSM';
    $Self->{Translation}->{'If frequency is \'regularly\', you can configure how often the notifications are sent (every X hours).'} =
        'Jika frekuensi \'teratur\', Anda dapat mengkonfigurasi seberapa sering pemberitahuan dikirim (setiap X jam).';
    $Self->{Translation}->{'Link another object to the change.'} = '';
    $Self->{Translation}->{'Link another object to the workorder.'} = '';
    $Self->{Translation}->{'List of all change events to be displayed in the GUI.'} = '';
    $Self->{Translation}->{'List of all workorder events to be displayed in the GUI.'} = '';
    $Self->{Translation}->{'Lookup of CAB members for autocompletion.'} = 'Lookup anggota CAB untuk pelengkapan otomatis.';
    $Self->{Translation}->{'Lookup of agents, used for autocompletion.'} = 'Lookup agen, yang digunakan untuk melengkapi.';
    $Self->{Translation}->{'Manage ITSM Change Management state machine.'} = '';
    $Self->{Translation}->{'Manage the category ↔ impact ↔ priority matrix.'} = '';
    $Self->{Translation}->{'Module to check if WorkOrderAdd or WorkOrderAddFromTemplate should be permitted.'} =
        'Modul untuk memeriksa apakah WorkOrderAdd atau Work Order AddFromTemplate harus diijinkan.';
    $Self->{Translation}->{'Module to check the CAB members.'} = 'Modul untuk memeriksa anggota CAB.';
    $Self->{Translation}->{'Module to check the agent.'} = 'Modul untuk memeriksa agen.';
    $Self->{Translation}->{'Module to check the change builder.'} = 'Modul untuk memeriksa perubahan pembangun';
    $Self->{Translation}->{'Module to check the change manager.'} = 'Modul untuk memeriksa perubahan manajer';
    $Self->{Translation}->{'Module to check the workorder agent.'} = 'Modul untuk memeriksa agen perintah kerja.';
    $Self->{Translation}->{'Module to check whether no workorder agent is set.'} = 'Modul untuk memeriksa apakah ada agen perintah kerja diatur.';
    $Self->{Translation}->{'Module to check whether the agent is contained in the configured list.'} =
        'Modul untuk memeriksa apakah agen yang terkandung dalam daftar dikonfigurasi.';
    $Self->{Translation}->{'Module to show a link to create a change from this ticket. The ticket will be automatically linked with the new change.'} =
        'Modul untuk menunjukkan link untuk membuat perubahan dari tiket ini. tiket akan otomatis terhubung dengan perubahan baru.';
    $Self->{Translation}->{'Move Time Slot.'} = 'Pindah Waktu Slot.';
    $Self->{Translation}->{'Move all workorders in time.'} = '';
    $Self->{Translation}->{'New (from template)'} = 'Baru (dari template)';
    $Self->{Translation}->{'Only users of these groups have the permission to use the ticket types as defined in "ITSMChange::AddChangeLinkTicketTypes" if the feature "Ticket::Acl::Module###200-Ticket::Acl::Module" is enabled.'} =
        'Hanya pengguna dari kelompok-kelompok ini memiliki izin untuk menggunakan jenis tiket sebagaimana didefinisikan dalam "ITSM Perubahan :: AddChangeLinkTicketTypes" jika fitur "Ticket :: Acl :: Modul ### 200-Ticket :: Acl :: Modul" diaktifkan.';
    $Self->{Translation}->{'Other Settings'} = 'Pengaturan Lain';
    $Self->{Translation}->{'Overview over all Changes.'} = 'Gambaran atas semua Perubahan.';
    $Self->{Translation}->{'PIR'} = '';
    $Self->{Translation}->{'PIR (Post Implementation Review)'} = 'PIR (Post Implementasi Review)';
    $Self->{Translation}->{'PSA'} = 'PSA';
    $Self->{Translation}->{'Parameters for the UserCreateWorkOrderNextMask object in the preference view of the agent interface.'} =
        'Parameter untuk Pengguna Buat WorkOrderNextMask objek dalam pandangan preferensi antarmuka agen.';
    $Self->{Translation}->{'Parameters for the pages (in which the changes are shown) of the small change overview.'} =
        'Parameter untuk halaman (di mana perubahan akan ditampilkan) dari gambaran perubahan kecil.';
    $Self->{Translation}->{'Performs the configured action for each event (as an Invoker) for each configured Webservice.'} =
        'Melakukan tindakan dikonfigurasi untuk setiap acara (sebagai Invoker) untuk setiap Layanan Web dikonfigurasi.';
    $Self->{Translation}->{'Planned end time'} = '';
    $Self->{Translation}->{'Planned start time'} = '';
    $Self->{Translation}->{'Print the change.'} = '';
    $Self->{Translation}->{'Print the workorder.'} = '';
    $Self->{Translation}->{'Projected Service Availability'} = '';
    $Self->{Translation}->{'Projected Service Availability (PSA)'} = 'Proyeksi Layanan Ketersediaan (PSA)';
    $Self->{Translation}->{'Projected Service Availability (PSA) of changes. Overview of approved changes and their services.'} =
        'Proyeksi Layanan Ketersediaan (PSA) perubahan. Ikhtisar perubahan disetujui dan layanan mereka.';
    $Self->{Translation}->{'Requested time'} = '';
    $Self->{Translation}->{'Required privileges in order for an agent to take a workorder.'} =
        'hak diperlukan agar agen untuk mengambil perintah kerja.';
    $Self->{Translation}->{'Required privileges to access the overview of all changes.'} = 'hak yang diperlukan untuk mengakses gambaran dari semua perubahan.';
    $Self->{Translation}->{'Required privileges to add a workorder.'} = 'hak diperlukan untuk menambahkan perintah kerja.';
    $Self->{Translation}->{'Required privileges to change the workorder agent.'} = 'hak diperlukan untuk mengubah agen perintah kerja.';
    $Self->{Translation}->{'Required privileges to create a template from a change.'} = 'hak yang diperlukan untuk membuat template dari perubahan.';
    $Self->{Translation}->{'Required privileges to create a template from a changes\' CAB.'} =
        'hak yang diperlukan untuk membuat template dari perubahan CAB';
    $Self->{Translation}->{'Required privileges to create a template from a workorder.'} = 'hak yang diperlukan untuk membuat template dari perintah kerja.';
    $Self->{Translation}->{'Required privileges to create changes from templates.'} = 'hak yang diperlukan untuk membuat perubahan dari template.';
    $Self->{Translation}->{'Required privileges to create changes.'} = 'hak yang diperlukan untuk membuat perubahan.';
    $Self->{Translation}->{'Required privileges to delete a template.'} = 'hak diperlukan untuk menghapus template.';
    $Self->{Translation}->{'Required privileges to delete a workorder.'} = 'hak diperlukan untuk menghapus perintah kerja.';
    $Self->{Translation}->{'Required privileges to delete changes.'} = 'hak diperlukan untuk menghapus perubahan.';
    $Self->{Translation}->{'Required privileges to edit a template.'} = 'hak diperlukan untuk mengedit template.';
    $Self->{Translation}->{'Required privileges to edit a workorder.'} = 'hak diperlukan untuk mengedit perintah kerja.';
    $Self->{Translation}->{'Required privileges to edit changes.'} = 'hak diperlukan untuk mengedit perubahan.';
    $Self->{Translation}->{'Required privileges to edit the conditions of changes.'} = 'hak diperlukan untuk mengedit kondisi perubahan.';
    $Self->{Translation}->{'Required privileges to edit the content of a template.'} = 'hak diperlukan untuk mengedit isi dari template.';
    $Self->{Translation}->{'Required privileges to edit the involved persons of a change.'} =
        'hak diperlukan untuk mengedit orang yang terlibat dari perubahan.';
    $Self->{Translation}->{'Required privileges to move changes in time.'} = 'hak yang dibutuhkan untuk memindahkan perubahan waktu.';
    $Self->{Translation}->{'Required privileges to print a change.'} = 'hak yang diperlukan untuk mencetak perubahan.';
    $Self->{Translation}->{'Required privileges to reset changes.'} = 'hak diperlukan untuk me-reset perubahan.';
    $Self->{Translation}->{'Required privileges to view a workorder.'} = 'hak diperlukan untuk melihat perintah kerja.';
    $Self->{Translation}->{'Required privileges to view changes.'} = 'hak diperlukan untuk me-review Melihat hal Perintah kerja.';
    $Self->{Translation}->{'Required privileges to view list of changes where the user is a CAB member.'} =
        'hak diperlukan untuk melihat daftar perubahan di mana pengguna adalah anggota CAB.';
    $Self->{Translation}->{'Required privileges to view list of changes where the user is the change manager.'} =
        'hak diperlukan untuk melihat daftar perubahan di mana pengguna adalah perubahan manajer';
    $Self->{Translation}->{'Required privileges to view overview over all templates.'} = 'hak diperlukan untuk melihat gambaran atas semua template.';
    $Self->{Translation}->{'Required privileges to view the conditions of changes.'} = 'hak diperlukan untuk melihat kondisi perubahan.';
    $Self->{Translation}->{'Required privileges to view the history of a change.'} = 'hak diperlukan untuk melihat sejarah perubahan.';
    $Self->{Translation}->{'Required privileges to view the history of a workorder.'} = 'hak diperlukan untuk melihat sejarah perintah kerja.';
    $Self->{Translation}->{'Required privileges to view the history zoom of a change.'} = 'hak diperlukan untuk melihat zoom sejarah perubahan.';
    $Self->{Translation}->{'Required privileges to view the history zoom of a workorder.'} =
        'hak diperlukan untuk melihat zoom sejarah perintah kerja.';
    $Self->{Translation}->{'Required privileges to view the list of Change Schedule.'} = 'hak diperlukan untuk melihat daftar Perubahan Jadwal.';
    $Self->{Translation}->{'Required privileges to view the list of change PSA.'} = 'hak diperlukan untuk melihat daftar perubahan PSA.';
    $Self->{Translation}->{'Required privileges to view the list of changes with an upcoming PIR (Post Implementation Review).'} =
        'hak diperlukan untuk melihat daftar perubahan dengan PIR mendatang (Post Pelaksanaan Review).';
    $Self->{Translation}->{'Required privileges to view the list of own changes.'} = 'hak diperlukan untuk melihat daftar perubahan sendiri.';
    $Self->{Translation}->{'Required privileges to view the list of own workorders.'} = 'hak diperlukan untuk melihat daftar perintah kerja sendiri.';
    $Self->{Translation}->{'Required privileges to write a report for the workorder.'} = 'hak diperlukan untuk menulis laporan untuk perintah kerja.';
    $Self->{Translation}->{'Reset a change and its workorders.'} = 'Ulang perubahan dan perintah kerja nya.';
    $Self->{Translation}->{'Reset change and its workorders.'} = '';
    $Self->{Translation}->{'Run task to check if specific times have been reached in changes and workorders.'} =
        'tugas dijalankan untuk memeriksa apakah waktu tertentu telah dicapai dalam perubahan dan perintah kerja.';
    $Self->{Translation}->{'Save change as a template.'} = '';
    $Self->{Translation}->{'Save workorder as a template.'} = '';
    $Self->{Translation}->{'Schedule'} = '';
    $Self->{Translation}->{'Screen after creating a workorder'} = 'Layar setelah membuat perintah kerja';
    $Self->{Translation}->{'Search Changes'} = 'Cari perubahan';
    $Self->{Translation}->{'Search Changes.'} = 'Cari Perubahan.';
    $Self->{Translation}->{'Selects the change number generator module. "AutoIncrement" increments the change number, the SystemID and the counter are used with SystemID.counter format (e.g. 100118, 100119). With "Date", the change numbers will be generated by the current date and a counter; this format looks like Year.Month.Day.counter, e.g. 2010062400001, 2010062400002. With "DateChecksum", the counter will be appended as checksum to the string of date plus the SystemID. The checksum will be rotated on a daily basis. This format looks like Year.Month.Day.SystemID.Counter.CheckSum, e.g. 2010062410000017, 2010062410000026.'} =
        'Memilih modul jumlah perubahan pembangkit. "AutoIncrement" increment jumlah perubahan, SystemID dan meja yang digunakan dengan format yang SystemID.counter (Misalnya 100.118, 100.119). Dengan "Tanggal", angka perubahan akan dihasilkan oleh tanggal dan counter; format ini tampak seperti Year.Month.Day.counter, misalnya 2010062400001, 2010062400002. Dengan "DateChecksum", counter akan ditambahkan sebagai checksum untuk string dari tanggal ditambah SystemID. checksum akan diputar setiap hari. Format ini terlihat seperti Year.Month.Day.SystemID.Counter.CheckSum, misalnya 2010062410000017, 2010062410000026.';
    $Self->{Translation}->{'Set the agent for the workorder.'} = '';
    $Self->{Translation}->{'Set the default height (in pixels) of inline HTML fields in the change zoom screen and workorder zoom screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Set the maximum height (in pixels) of inline HTML fields in the change zoom screen and workorder zoom screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Sets the minimal change counter size (if "AutoIncrement" was selected as ITSMChange::NumberGenerator). Default is 5, this means the counter starts from 10000.'} =
        'Menetapkan minimal ukuran perubahan counter (jika "auto_increment" terpilih sebagai Perubahan ITSM :: Number Generator). Default adalah 5, ini berarti konter dimulai dari 10000.';
    $Self->{Translation}->{'Sets up the state machine for changes.'} = 'Set up mesin untuk perubahan.';
    $Self->{Translation}->{'Sets up the state machine for workorders.'} = 'Set up mesin untuk perintah kerja.';
    $Self->{Translation}->{'Shows a checkbox in the workorder edit screen of the agent interface that defines if the the following workorders should also be moved if a workorder is modified and the planned end time has changed.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows changing the workorder agent, in the zoom view of the workorder of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows defining a change as a template in the zoom view of the change, in the agent interface.'} =
        'Menunjukkan link dalam menu yang memungkinkan mendefinisikan perubahan sebagai template dalam tampilan zoom perubahan, dalam antarmuka agen.';
    $Self->{Translation}->{'Shows a link in the menu that allows defining a workorder as a template in the zoom view of the workorder, in the agent interface.'} =
        'Menunjukkan link dalam menu yang memungkinkan mendefinisikan perintah kerja sebagai template dalam tampilan zoom dari perintah kerja, di antarmuka agen.';
    $Self->{Translation}->{'Shows a link in the menu that allows editing the report of a workorder, in the zoom view of the workorder of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows linking a change with another object in the change zoom view of the agent interface.'} =
        'Menunjukkan link dalam menu yang memungkinkan menghubungkan perubahan dengan objek lain pada tampilan perubahan zoom dari antarmuka agen.';
    $Self->{Translation}->{'Shows a link in the menu that allows linking a workorder with another object in the zoom view of the workorder of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows moving the time slot of a change in its zoom view of the agent interface.'} =
        'Menunjukkan link dalam menu yang memungkinkan bergerak slot waktu perubahan dalam tampilan zoom-nya dari antarmuka agen.';
    $Self->{Translation}->{'Shows a link in the menu that allows taking a workorder in the its zoom view of the agent interface.'} =
        'Menunjukkan link dalam menu yang memungkinkan mengambil perintah kerja dalam tampilan zoom-nya dari antarmuka agen.';
    $Self->{Translation}->{'Shows a link in the menu to access the conditions of a change in the its zoom view of the agent interface.'} =
        'Menunjukkan link dalam menu untuk mengakses kondisi perubahan yang zoom pandangan agen antarmuka.';
    $Self->{Translation}->{'Shows a link in the menu to access the history of a change in the its zoom view of the agent interface.'} =
        'Menunjukkan link dalam menu untuk mengakses sejarah dari perubahan dalam tampilan zoom-nya dari antarmuka agen.';
    $Self->{Translation}->{'Shows a link in the menu to access the history of a workorder in the its zoom view of the agent interface.'} =
        'Menunjukkan link dalam menu untuk mengakses sejarah perintah kerja dalam tampilan zoom-nya dari antarmuka agen.';
    $Self->{Translation}->{'Shows a link in the menu to add a workorder in the change zoom view of the agent interface.'} =
        'Menunjukkan link dalam menu untuk menambahkan perintah kerja dalam tampilan perubahan zoom dari antarmuka agen.';
    $Self->{Translation}->{'Shows a link in the menu to delete a change in its zoom view of the agent interface.'} =
        'Menunjukkan link dalam menu untuk menghapus perubahan dalam pandangan zoom-nya dari antarmuka agen.';
    $Self->{Translation}->{'Shows a link in the menu to delete a workorder in its zoom view of the agent interface.'} =
        'Menunjukkan link dalam menu untuk menghapus perintah kerja dalam pandangan zoom-nya dari antarmuka agen.';
    $Self->{Translation}->{'Shows a link in the menu to edit a change in the its zoom view of the agent interface.'} =
        'Menunjukkan link dalam menu untuk mengedit perubahan dalam tampilan zoom-nya dari antarmuka agen.';
    $Self->{Translation}->{'Shows a link in the menu to edit a workorder in the its zoom view of the agent interface.'} =
        'Menunjukkan link dalam menu untuk mengedit perintah kerja dalam tampilan zoom-nya dari antarmuka agen.';
    $Self->{Translation}->{'Shows a link in the menu to go back in the change zoom view of the agent interface.'} =
        'Menunjukkan link dalam menu untuk kembali dalam tampilan perubahan zoom dari antarmuka agen.';
    $Self->{Translation}->{'Shows a link in the menu to go back in the workorder zoom view of the agent interface.'} =
        'Menunjukkan link dalam menu untuk kembali dalam urutan kerja tampilan zoom dari antarmuka agen.';
    $Self->{Translation}->{'Shows a link in the menu to print a change in the its zoom view of the agent interface.'} =
        'Menunjukkan link dalam menu untuk mencetak perubahan dalam tampilan zoom-nya dari antarmuka agen.';
    $Self->{Translation}->{'Shows a link in the menu to print a workorder in the its zoom view of the agent interface.'} =
        'Menunjukkan link dalam menu untuk mencetak perintah kerja dalam tampilan zoom-nya dari antarmuka agen.';
    $Self->{Translation}->{'Shows a link in the menu to reset a change and its workorders in its zoom view of the agent interface.'} =
        'Menunjukkan link dalam menu untuk mengatur ulang perubahan dan perintah kerja dalam tampilan zoom-nya dari antarmuka agen.';
    $Self->{Translation}->{'Shows a link in the menu to show the involved persons in a change, in the zoom view of the change in the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows the change history (reverse ordered) in the agent interface.'} =
        'Menunjukkan sejarah perubahan (urutan terbalik) di antarmuka agen.';
    $Self->{Translation}->{'State Machine'} = 'State mesin';
    $Self->{Translation}->{'Stores change and workorder ids and their corresponding template id, while a user is editing a template.'} =
        'Simpan perubahan dan perintah kerja id dan Template id yang sesuai mereka, sementara pengguna mengedit template.';
    $Self->{Translation}->{'Take Workorder'} = 'Ambil Work Order';
    $Self->{Translation}->{'Take Workorder.'} = 'Mengambil perintah kerja';
    $Self->{Translation}->{'Take the workorder.'} = '';
    $Self->{Translation}->{'Template Overview'} = 'Ikhtisar Template';
    $Self->{Translation}->{'Template type'} = '';
    $Self->{Translation}->{'Template.'} = 'Template';
    $Self->{Translation}->{'The identifier for a change, e.g. Change#, MyChange#. The default is Change#.'} =
        'Pengenal untuk perubahan, misalnya. Ganti #,  perubahan saya#. default Berubah #.';
    $Self->{Translation}->{'The identifier for a workorder, e.g. Workorder#, MyWorkorder#. The default is Workorder#.'} =
        'Pengenal untuk perintah kerja, misalnya Workorder #, Workorder #. Standarnya adalah Work Order #.';
    $Self->{Translation}->{'This ACL module restricts the usuage of the ticket types that are defined in the sysconfig option \'ITSMChange::AddChangeLinkTicketTypes\', to users of the groups as defined in "ITSMChange::RestrictTicketTypes::Groups". As this ACL could collide with other ACLs which are also related to the ticket type, this sysconfig option is disabled by default and should only be activated if needed.'} =
        'Modul ACL ini membatasi penggunaan jenis tiket yang didefinisikan dalam pilihan sysconfig \'ITSMChange :: AddChangeLinkTicketTypes\', untuk pengguna kelompok sebagaimana didefinisikan dalam "ITSMChange :: RestrictTicketTypes :: Grup". Sebagai ACL ini bisa berbenturan dengan ACL lain yang juga terkait dengan jenis tiket, opsi sysconfig ini dinonaktifkan secara default dan hanya harus diaktifkan jika diperlukan.';
    $Self->{Translation}->{'Time Slot'} = 'waktu Slot';
    $Self->{Translation}->{'Types of tickets, where in the ticket zoom view a link to add a change will be displayed.'} =
        'Jenis tiket, di mana dalam zoom tiket melihat link untuk menambahkan perubahan akan ditampilkan.';
    $Self->{Translation}->{'User Search'} = 'Cari pengguna';
    $Self->{Translation}->{'Workorder Add (from template).'} = 'Tambahan Perintah Kerja (dari template).';
    $Self->{Translation}->{'Workorder Add.'} = 'Perintah kerja ditambah';
    $Self->{Translation}->{'Workorder Agent.'} = 'Agen perintah kerja';
    $Self->{Translation}->{'Workorder Delete.'} = 'Perintah kerja dihapus';
    $Self->{Translation}->{'Workorder Edit.'} = 'Perintah kerja di edit';
    $Self->{Translation}->{'Workorder History Zoom.'} = 'Sejarah perintah kerja';
    $Self->{Translation}->{'Workorder History.'} = 'Sejarah perintah kerja';
    $Self->{Translation}->{'Workorder Report.'} = 'Laporan perintah kerja';
    $Self->{Translation}->{'Workorder Zoom'} = '';
    $Self->{Translation}->{'Workorder Zoom.'} = 'Perintah kerja zoom';
    $Self->{Translation}->{'once'} = 'Sekali';
    $Self->{Translation}->{'regularly'} = 'secara teratur';


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
