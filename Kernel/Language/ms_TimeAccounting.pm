# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ms_TimeAccounting;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentTimeAccountingDelete
    $Self->{Translation}->{'Do you really want to delete the Time Accounting of this day?'} =
        'Adakah anda pasti ingin menghapuskan Perakaunan Masa hari ini?';

    # Template: AgentTimeAccountingEdit
    $Self->{Translation}->{'Edit Time Record'} = 'Sunting Rekod Masa';
    $Self->{Translation}->{'Go to settings'} = 'Pergi ke tetapan';
    $Self->{Translation}->{'Date Navigation'} = 'Navigasi Tarikh';
    $Self->{Translation}->{'Days without entries'} = 'Hari tanpa penyertaan';
    $Self->{Translation}->{'Select all days'} = 'Pilih kesemua hari';
    $Self->{Translation}->{'Mass entry'} = 'Kemasukan besar-besaran';
    $Self->{Translation}->{'Please choose the reason for your absence for the selected days'} =
        'Pilih sebab ketidakhadiran anda untuk hari-hari yang dipilih';
    $Self->{Translation}->{'On vacation'} = 'Bercuti';
    $Self->{Translation}->{'On sick leave'} = 'Cuti sakit';
    $Self->{Translation}->{'On overtime leave'} = 'Bercuti lebih masa';
    $Self->{Translation}->{'Required fields are marked with a "*".'} = 'Medan yang diperlukan ditandai dengan "*".';
    $Self->{Translation}->{'You have to fill in start and end time or a time period.'} = 'Anda perlu mengisi permulaan dan akhir masa atau tempoh masa.';
    $Self->{Translation}->{'Project'} = 'Projek';
    $Self->{Translation}->{'Task'} = 'Tugas';
    $Self->{Translation}->{'Remark'} = 'Komen';
    $Self->{Translation}->{'Please add a remark with more than 8 characters!'} = 'Sila tambah komen dengan lebih daripada 8 karakter!';
    $Self->{Translation}->{'Negative times are not allowed.'} = 'Waktu negatif tidak dibenarkan.';
    $Self->{Translation}->{'Repeated hours are not allowed. Start time matches another interval.'} =
        'Pengulangan jam adalah tidak dibenarkan. Masa mula padan dengan selang lain.';
    $Self->{Translation}->{'Invalid format! Please enter a time with the format HH:MM.'} = 'Format tidak sah! Sila masukkan masa dengan format HH:MM.';
    $Self->{Translation}->{'24:00 is only permitted as end time.'} = '24:00 hanya dibenarkan sebagai masa akhir.';
    $Self->{Translation}->{'Invalid time! A day has only 24 hours.'} = 'Masa tidak sah! Sehari hanya mempunyai 24 jam.';
    $Self->{Translation}->{'End time must be after start time.'} = 'Masa tamat mesti selepas masa mula.';
    $Self->{Translation}->{'Repeated hours are not allowed. End time matches another interval.'} =
        'Pengulangan jam adalah tidak dibenarkan. Masa akhir padan dengan selang lain.';
    $Self->{Translation}->{'Invalid period! A day has only 24 hours.'} = 'Tempoh tidak sah! Sehari hanya mempunyai 24 jam.';
    $Self->{Translation}->{'A valid period must be greater than zero.'} = 'Tempoh sah mesti lebih besar daripada sifar.';
    $Self->{Translation}->{'Invalid period! Negative periods are not allowed.'} = 'Tempoh tidak sah! Tempoh negatif adalah tidak dibenarkan.';
    $Self->{Translation}->{'Add one row'} = 'Tambah satu baris';
    $Self->{Translation}->{'You can only select one checkbox element!'} = 'Anda hanya boleh pilih satu elemen kotak semak!';
    $Self->{Translation}->{'Are you sure that you worked while you were on sick leave?'} = 'Adakah anda pasti bahawa anda bekerja semasa anda bercuti sakit?';
    $Self->{Translation}->{'Are you sure that you worked while you were on vacation?'} = 'Adakah anda pasti bahawa anda bekerja semasa anda bercuti?';
    $Self->{Translation}->{'Are you sure that you worked while you were on overtime leave?'} =
        'Adakah anda pasti bahawa anda bekerja semasa anda bercuti lebih masa?';
    $Self->{Translation}->{'Are you sure that you worked more than 16 hours?'} = 'Adakah anda pasti bahawa anda bekerja lebih daripada 16 jam?';

    # Template: AgentTimeAccountingOverview
    $Self->{Translation}->{'Time reporting monthly overview'} = 'Gambaran bulanan masa melaporkan';
    $Self->{Translation}->{'Overtime (Hours)'} = 'Lebih masa (Jam)';
    $Self->{Translation}->{'Overtime (this month)'} = 'Kerja lebih masa (bulan ini)';
    $Self->{Translation}->{'Overtime (total)'} = 'Kerja lebih masa (jumlah)';
    $Self->{Translation}->{'Remaining overtime leave'} = 'Baki cuti lebih masa';
    $Self->{Translation}->{'Vacation (Days)'} = 'Bercuti (Hari)';
    $Self->{Translation}->{'Vacation taken (this month)'} = 'Cuti diambil (bulan ini)';
    $Self->{Translation}->{'Vacation taken (total)'} = 'Cuti diambil (jumlah)';
    $Self->{Translation}->{'Remaining vacation'} = 'Baki cuti';
    $Self->{Translation}->{'Sick Leave (Days)'} = 'Cuti Sakit (Hari)';
    $Self->{Translation}->{'Sick leave taken (this month)'} = 'Cuti sakit diambil (bulan ini)';
    $Self->{Translation}->{'Sick leave taken (total)'} = 'Cuti sakit diambil (jumlah)';
    $Self->{Translation}->{'Previous month'} = 'Bulan sebelum';
    $Self->{Translation}->{'Next month'} = 'Bulan berikutnya';
    $Self->{Translation}->{'Weekday'} = 'Hari minggu';
    $Self->{Translation}->{'Working Hours'} = 'Jam bekerja';
    $Self->{Translation}->{'Total worked hours'} = 'Jumlah jam bekerja';
    $Self->{Translation}->{'User\'s project overview'} = 'Gambaran projek pengguna';
    $Self->{Translation}->{'Hours (monthly)'} = 'Jam (bulanan)';
    $Self->{Translation}->{'Hours (Lifetime)'} = 'Jam (Hayat)';
    $Self->{Translation}->{'Grand total'} = 'Jumlah keseluruhan';

    # Template: AgentTimeAccountingReporting
    $Self->{Translation}->{'Time reporting'} = 'Masa melaporkan';
    $Self->{Translation}->{'Month Navigation'} = 'Navigasi bulan';
    $Self->{Translation}->{'Go to date'} = 'Pergi ke tarikh';
    $Self->{Translation}->{'User reports'} = 'Laporan pengguna';
    $Self->{Translation}->{'Monthly total'} = 'Jumlah bulanan';
    $Self->{Translation}->{'Lifetime total'} = 'Jumlah hayat';
    $Self->{Translation}->{'Overtime leave'} = 'Cuti lebih masa';
    $Self->{Translation}->{'Vacation'} = 'Bercuti';
    $Self->{Translation}->{'Sick leave'} = 'Cuti sakit';
    $Self->{Translation}->{'Vacation remaining'} = 'Baki cuti';
    $Self->{Translation}->{'Project reports'} = 'Laporan projek';

    # Template: AgentTimeAccountingReportingProject
    $Self->{Translation}->{'Project report'} = 'Laporan projek';
    $Self->{Translation}->{'Go to reporting overview'} = 'Pergi ke tinjauan melaporkan';
    $Self->{Translation}->{'Currently only active users in this project are shown. To change this behavior, please update setting:'} =
        'Pada masa ini hanya pengguna aktif dalam projek ini akan ditunjukkan. Untuk mengubah sifat ini, sila kemas kini tetapan:';
    $Self->{Translation}->{'Currently all time accounting users are shown. To change this behavior, please update setting:'} =
        'Pada masa ini kesemua pengguna perakaunan masa ditunjukkan. Untuk mengubah tingkah laku ini, sila kemas kini tetapan:';

    # Template: AgentTimeAccountingSetting
    $Self->{Translation}->{'Edit Time Accounting Project Settings'} = 'Sunting Tetapan Projek Perakaunan Masa ';
    $Self->{Translation}->{'Add project'} = 'Tambah projek';
    $Self->{Translation}->{'Go to settings overview'} = 'Pergi ke gambaran keseluruhan tetapan';
    $Self->{Translation}->{'Add Project'} = 'Tambah projek';
    $Self->{Translation}->{'Edit Project Settings'} = 'Sunting tetapan projek';
    $Self->{Translation}->{'There is already a project with this name. Please, choose a different one.'} =
        'Sudah ada projek dengan nama ini. Sila pilih yang lain.';
    $Self->{Translation}->{'Edit Time Accounting Settings'} = 'Sunting Tetapan Perakaunan Masa';
    $Self->{Translation}->{'Add task'} = 'Tambah tugas';
    $Self->{Translation}->{'Filter for projects, tasks or users'} = '';
    $Self->{Translation}->{'Time periods can not be deleted.'} = 'Tempoh masa tidak boleh dihapuskan.';
    $Self->{Translation}->{'Project List'} = 'Senarai projek';
    $Self->{Translation}->{'Task List'} = 'Senarai tugas';
    $Self->{Translation}->{'Add Task'} = 'Tambah tugas';
    $Self->{Translation}->{'Edit Task Settings'} = 'Sunting tetapan tugas';
    $Self->{Translation}->{'There is already a task with this name. Please, choose a different one.'} =
        'Sudah ada tugas dengan nama ini. Sila pilih yang lain.';
    $Self->{Translation}->{'User List'} = 'Senarai Pengguna';
    $Self->{Translation}->{'User Settings'} = '';
    $Self->{Translation}->{'User is allowed to see overtimes'} = '';
    $Self->{Translation}->{'Show Overtime'} = 'Tunjuk lebihan masa';
    $Self->{Translation}->{'User is allowed to create projects'} = '';
    $Self->{Translation}->{'Allow project creation'} = 'Benarkan ciptaan projek';
    $Self->{Translation}->{'Time Spans'} = '';
    $Self->{Translation}->{'Period Begin'} = 'Tempoh Mula';
    $Self->{Translation}->{'Period End'} = 'Tempoh tamat';
    $Self->{Translation}->{'Days of Vacation'} = 'Hari Bercuti';
    $Self->{Translation}->{'Hours per Week'} = 'Jam Seminggu';
    $Self->{Translation}->{'Authorized Overtime'} = 'Lebihan masa dibenarkan';
    $Self->{Translation}->{'Start Date'} = 'Tarikh Mula';
    $Self->{Translation}->{'Please insert a valid date.'} = 'Sila masukkan tarikh yang sah.';
    $Self->{Translation}->{'End Date'} = 'Tarikh Tamat';
    $Self->{Translation}->{'Period end must be after period begin.'} = 'Tempoh tamat mestilah selepas tempoh mula.';
    $Self->{Translation}->{'Leave Days'} = 'Hari cuti';
    $Self->{Translation}->{'Weekly Hours'} = 'Jam mingguan';
    $Self->{Translation}->{'Overtime'} = 'Lebih masa';
    $Self->{Translation}->{'No time periods found.'} = 'Tiada tempoh masa dijumpai.';
    $Self->{Translation}->{'Add time period'} = 'Tambah tempoh masa';

    # Template: AgentTimeAccountingView
    $Self->{Translation}->{'View Time Record'} = 'Lihat Rekod Masa';
    $Self->{Translation}->{'View of '} = 'Pandangan';
    $Self->{Translation}->{'Previous day'} = 'Hari sebelum';
    $Self->{Translation}->{'Next day'} = 'Hari seterusnya';
    $Self->{Translation}->{'No data found for this day.'} = 'Tiada data dijumpai pada hari ini.';

    # Perl Module: Kernel/Modules/AgentTimeAccountingEdit.pm
    $Self->{Translation}->{'Can\'t insert Working Units!'} = 'Tidak boleh memasukkan Unit Kerja!';
    $Self->{Translation}->{'Last Projects'} = 'Projek Lepas';
    $Self->{Translation}->{'Can\'t save settings, because a day has only 24 hours!'} = 'Tidak boleh menyimpan tetapan-tetapan, kerana sehari hanya ada 24 jam!';
    $Self->{Translation}->{'Can\'t delete Working Units!'} = 'Tidak boleh membuang Unit Kerja!';
    $Self->{Translation}->{'This Date is out of limit, but you haven\'t insert this day yet, so you get one(!) chance to insert'} =
        'Tarikh ini telah terlebih had, tetapi anda masih belum memasukkan hari ini lagi, jadi anda mendapat satu(!) peluang untuk masukkan';
    $Self->{Translation}->{'Incomplete Working Days'} = 'Hari Bekerja Tidak Lengkap';
    $Self->{Translation}->{'Please insert your working hours!'} = 'Sila masukkan waktu kerja anda! ';
    $Self->{Translation}->{'Successful insert!'} = 'Berjaya dimasukkan!';
    $Self->{Translation}->{'Error while inserting multiple dates!'} = 'Ralat semasa memasukkan beberapa tarikh!';
    $Self->{Translation}->{'Successfully inserted entries for several dates!'} = 'Berjaya dimasukkan penyertaan untuk beberapa tarikh!';
    $Self->{Translation}->{'Entered date was invalid! Date was changed to today.'} = 'Tarikh yang dimasukkan tidak sah! Tarikh telah ditukar kepada hari ini.';
    $Self->{Translation}->{'No time period configured, or the specified date is outside of the defined time periods.'} =
        '';
    $Self->{Translation}->{'Please contact the time accounting administrator to update your time periods!'} =
        '';
    $Self->{Translation}->{'Last Selected Projects'} = 'Projek Dipilih Lepas';
    $Self->{Translation}->{'All Projects'} = 'Semua Projek';

    # Perl Module: Kernel/Modules/AgentTimeAccountingReporting.pm
    $Self->{Translation}->{'ReportingProject: Need ProjectID'} = 'MelaporkanProjek: Perlukan ProjectID';
    $Self->{Translation}->{'Reporting Project'} = 'Melaporkan Projek';
    $Self->{Translation}->{'Reporting'} = 'Melaporkan';

    # Perl Module: Kernel/Modules/AgentTimeAccountingSetting.pm
    $Self->{Translation}->{'Unable to update user settings!'} = 'Tidak boleh untuk kemaskini tetapan-tetapan pengguna!';
    $Self->{Translation}->{'Project added!'} = 'Projek telah ditambah!';
    $Self->{Translation}->{'Project updated!'} = 'Projek telah dikemaskini!';
    $Self->{Translation}->{'Task added!'} = 'Tugasan telah ditambah!';
    $Self->{Translation}->{'Task updated!'} = 'Tugasan telah dikemaskini!';
    $Self->{Translation}->{'The UserID is not valid!'} = 'ID Pengguna tidak sah!';
    $Self->{Translation}->{'Can\'t insert user data!'} = 'Tidak boleh memasukkan data pengguna!';
    $Self->{Translation}->{'Unable to add time period!'} = 'Tidak boleh menambah tempoh masa!';
    $Self->{Translation}->{'Setting'} = 'Tetapan';
    $Self->{Translation}->{'User updated!'} = 'Pengguna telah dikemaskini!';
    $Self->{Translation}->{'User added!'} = 'Pengguna telah ditambah!';
    $Self->{Translation}->{'Add a user to time accounting...'} = '';
    $Self->{Translation}->{'New User'} = 'Pengguna Baharu';
    $Self->{Translation}->{'Period Status'} = 'Status Tempoh';

    # Perl Module: Kernel/Modules/AgentTimeAccountingView.pm
    $Self->{Translation}->{'View: Need %s!'} = 'Pandangan: Perlu %s!';

    # Perl Module: Kernel/Output/HTML/ToolBar/IncompleteWorkingDays.pm
    $Self->{Translation}->{'Incomplete working days'} = 'Hari bekerja tidak lengkap';

    # JS File: TimeAccounting.Agent.EditTimeRecords
    $Self->{Translation}->{'Please choose at least one day!'} = 'Sila pilih sekurang-kurangnya sehari!';
    $Self->{Translation}->{'Mass Entry'} = 'Kemasukan besar-besaran';
    $Self->{Translation}->{'Please choose a reason for absence!'} = 'Sila pilih sebab ketidakhadiran!';

    # JS File: TimeAccounting.Agent
    $Self->{Translation}->{'Delete Time Accounting Entry'} = 'Padam Kemasukan Masa Perakaunan ';
    $Self->{Translation}->{'Confirm insert'} = 'Sahkan kemasukan';

    # SysConfig
    $Self->{Translation}->{'Agent interface notification module to see the number of incomplete working days for the user.'} =
        'Modul pemberitahuan antara muka ejen untuk melihat bilangan hari bekerja yang tidak lengkap untuk pengguna.';
    $Self->{Translation}->{'Default name for new actions.'} = 'Nama lalai untuk tindakan baru.';
    $Self->{Translation}->{'Default name for new projects.'} = 'Nama lalai untuk projek baru.';
    $Self->{Translation}->{'Default setting for date end.'} = 'Tetapan lalai untuk tarikh akhir.';
    $Self->{Translation}->{'Default setting for date start.'} = 'Tetapan lalai untuk tarikh mula.';
    $Self->{Translation}->{'Default setting for description.'} = 'Tetapan lalai untuk gambaran.';
    $Self->{Translation}->{'Default setting for leave days.'} = 'Tetapan lalai untuk hari cuti.';
    $Self->{Translation}->{'Default setting for overtime.'} = 'Tetapan lalai untuk lebih masa.';
    $Self->{Translation}->{'Default setting for the standard weekly hours.'} = 'Tetapan lalai untuk jam mingguan piawai.';
    $Self->{Translation}->{'Default status for new actions.'} = 'Tetapan lalai untuk tindakan baharu.';
    $Self->{Translation}->{'Default status for new projects.'} = 'Tetapan lalai untuk projek baharu.';
    $Self->{Translation}->{'Default status for new users.'} = 'Tetapan lalai untuk pengguna baharu.';
    $Self->{Translation}->{'Defines the projects for which a remark is required. If the RegExp matches on the project, you have to insert a remark too. The RegExp use the smx parameter.'} =
        'Mentakrifkan projek-projek yang mana komen diperlukan. Jika UngkapanBiasa padan dalam projek ini, anda perlu memasukkan komen juga. UngkapanBiasa menggunakan parameter smx.';
    $Self->{Translation}->{'Determines if the statistics module may generate time accounting information.'} =
        'Menentukan jika modul statistik boleh menjana masa maklumat perakaunan.';
    $Self->{Translation}->{'Edit time accounting settings.'} = 'Sunting tetapan-tetapan perakaunan masa.';
    $Self->{Translation}->{'Edit time record.'} = 'Sunting rekod masa.';
    $Self->{Translation}->{'For how many days ago you can insert working units.'} = 'Untuk berapa hari yang lalu, anda boleh memasukkan unit kerja.';
    $Self->{Translation}->{'If enabled, only users that has added working time to the selected project are shown.'} =
        'Jika dibolehkan, hanya pengguna yang telah ditambah masa kerja untuk projek yang dipilih akan ditunjukkan.';
    $Self->{Translation}->{'If enabled, the dropdown elements in the edit screen are changed to modernized autocompletion fields.'} =
        'Jika dibolehkan, unsur-unsur kotak pilihan dalam skrin sunting ditukar kepada bidang penyiapan secara automatik moden.';
    $Self->{Translation}->{'If enabled, the filter for the previous projects can be used instead two list of projects (last and all ones). It could be used only if TimeAccounting::EnableAutoCompletion is enabled.'} =
        'Jika diaktifkan, penapis bagi projek-projek sebelum boleh digunakan selain dua senarai projek-projek (terakhir dan semuanya). Ia boleh digunakan hanya jika TimeAccounting::EnableAutoCompletion didayakan.';
    $Self->{Translation}->{'If enabled, the filter for the previous projects is active by default if there are the previous projects. It could be used only if EnableAutoCompletion and TimeAccounting::UseFilter are enabled.'} =
        'Jika diaktifkan, penapis bagi projek-projek sebelum adalah aktif secara lalai sekiranya terdapat projek lepas. Ia boleh digunakan hanya jika EnableAutoCompletion dan TimeAccounting::UseFilter didayakan.';
    $Self->{Translation}->{'If enabled, the user is allowed to enter "on vacation leave", "on sick leave" and "on overtime leave" to multiple dates at once.'} =
        'Jika dibolehkan, pengguna dibenarkan untuk memasuki "sedang cuti rehat ", "sedang cuti sakit " dan "sedang cuti lebih masa" pada beberapa tarikh sekaligus.';
    $Self->{Translation}->{'Maximum number of working days after which the working units have to be inserted.'} =
        'Bilangan maksimum hari bekerja selepas unit kerja perlu dimasukkan.';
    $Self->{Translation}->{'Maximum number of working days without working units entry after which a warning will be shown.'} =
        'Bilangan maksimum hari bekerja tanpa kemasukan unit bekerja selepas di mana amaran akan ditunjukkan.';
    $Self->{Translation}->{'Overview.'} = 'Pandangan keseluruhan.';
    $Self->{Translation}->{'Project time reporting.'} = 'melaporkan masa projek';
    $Self->{Translation}->{'Regular expressions for constraining action list according to selected project. Key contains regular expression for project(s), content contains regular expressions for action(s).'} =
        'Ungkapan biasa untuk mengekang senarai tindakan mengikut projek yang dipilih. Kunci mengandungi ungkapan biasa untuk projek (projek-projek), kandungan mengandungi ungkapan biasa untuk tindakan (tindakan-tindakan).';
    $Self->{Translation}->{'Regular expressions for constraining project list according to user groups. Key contains regular expression for project(s), content contains comma separated list of groups.'} =
        'Ungkapan biasa untuk mengekang senarai projek mengikut kumpulan pengguna. Kunci mengandungi ungkapan biasa untuk projek (projek-projek), kandungan mengandungi koma senarai kumpulan dipisahkan.';
    $Self->{Translation}->{'Specifies if working hours can be inserted without start and end times.'} =
        'Menentukan jika waktu bekerja boleh dimasukkan tanpa permulaan dan akhir masa.';
    $Self->{Translation}->{'This module forces inserts in TimeAccounting.'} = 'Modul ini memaksa kemasukan dalam PerakaunanSemasa.';
    $Self->{Translation}->{'This notification module gives a warning if there are too many incomplete working days.'} =
        'Modul pemberitahuan ini memberi amaran jika terdapat terlalu banyak hari bekerja tidak lengkap.';
    $Self->{Translation}->{'Time Accounting'} = 'Masa Perakaunan';
    $Self->{Translation}->{'Time accounting edit.'} = 'Sunting perakaunan semasa.';
    $Self->{Translation}->{'Time accounting overview.'} = 'Gambaran keseluruhan perakaunan semasa.';
    $Self->{Translation}->{'Time accounting reporting.'} = 'Melapor perakaunan semasa.';
    $Self->{Translation}->{'Time accounting settings.'} = 'Tetapan perakaunan semasa.';
    $Self->{Translation}->{'Time accounting view.'} = 'Paparan perakaunan semasa.';
    $Self->{Translation}->{'Time accounting.'} = 'Perakaunan semasa.';
    $Self->{Translation}->{'To use if some actions reduced the working hours (for example, if only half of the traveling time is paid Key => traveling; Content => 50).'} =
        'Untuk digunakan jika beberapa tindakan mengurangkan waktu kerja (contohnya, jika hanya separuh daripada masa perjalanan dibayar Kunci => perjalanan; Kandungan = > 50).';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Cancel',
    'Confirm insert',
    'Delete Time Accounting Entry',
    'Mass Entry',
    'No',
    'Please choose a reason for absence!',
    'Please choose at least one day!',
    'Submit',
    'Yes',
    );

}

1;
