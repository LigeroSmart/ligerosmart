# --
# Kernel/Language/ms_Survey.pm - translation file
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ms_Survey;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # Template: AAASurvey
    $Self->{Translation}->{'- Change Status -'} = '- Ubah Status -';
    $Self->{Translation}->{'Add New Survey'} = 'Tambah Ukur Baru';
    $Self->{Translation}->{'Survey Edit'} = 'Ukur Edit';
    $Self->{Translation}->{'Survey Edit Questions'} = 'Penyiasatan Edit Soalan';
    $Self->{Translation}->{'Question Edit'} = 'Edit soalan';
    $Self->{Translation}->{'Answer Edit'} = 'Edit Jawapan';
    $Self->{Translation}->{'Can\'t set new status! No questions defined.'} = 'Tidak boleh menetapkan status baru! Tiada soalan yang ditakrifkan.';
    $Self->{Translation}->{'Status changed.'} = 'status berubah.';
    $Self->{Translation}->{'Thank you for your feedback.'} = 'Terima kasih atas maklum balas anda.';
    $Self->{Translation}->{'The survey is finished.'} = 'Kaji selidik itu selesai.';
    $Self->{Translation}->{'Complete'} = 'lengkap';
    $Self->{Translation}->{'Incomplete'} = 'tidak lengkap';
    $Self->{Translation}->{'Checkbox (List)'} = 'Checkbox (Senarai)';
    $Self->{Translation}->{'Radio'} = 'Radio';
    $Self->{Translation}->{'Radio (List)'} = 'Radio (Senarai)';
    $Self->{Translation}->{'Stats Overview'} = 'Statistik Tinjauan';
    $Self->{Translation}->{'Survey Description'} = 'Huraian penyiasatan';
    $Self->{Translation}->{'Survey Introduction'} = 'Penyiasatan Pengenalan';
    $Self->{Translation}->{'Yes/No'} = 'Ya/Tidak';
    $Self->{Translation}->{'YesNo'} = 'YaTidak';
    $Self->{Translation}->{'answered'} = 'Dijawab';
    $Self->{Translation}->{'not answered'} = 'Tidak dijawab';
    $Self->{Translation}->{'Stats Detail'} = 'Statistik Terperinchi';
    $Self->{Translation}->{'You have already answered the survey.'} = 'Anda telah menjawab kaji selidik.';

    # Template: AgentSurveyAdd
    $Self->{Translation}->{'Create New Survey'} = 'Buat Survey Baru';
    $Self->{Translation}->{'Introduction'} = 'Pengenalan';
    $Self->{Translation}->{'Internal Description'} = 'Description dalaman';

    # Template: AgentSurveyEdit
    $Self->{Translation}->{'Edit General Info'} = 'Edit Maklumat Umum';
    $Self->{Translation}->{'Survey#'} = 'Penyiasatan#';

    # Template: AgentSurveyEditQuestions
    $Self->{Translation}->{'Edit Questions'} = 'Edit Soalan';
    $Self->{Translation}->{'Add Question'} = 'Tambah Soalan';
    $Self->{Translation}->{'Type the question'} = 'Taip soalan';
    $Self->{Translation}->{'Answer required'} = 'Jawapan diperlukan';
    $Self->{Translation}->{'Survey Questions'} = 'Penyiasatan Soalan';
    $Self->{Translation}->{'Question'} = 'Soalan';
    $Self->{Translation}->{'Answer Required'} = '';
    $Self->{Translation}->{'No questions saved for this survey.'} = 'Tiada soalan yang disimpan untuk kajian ini.';
    $Self->{Translation}->{'Edit Question'} = 'Edit Soalan';
    $Self->{Translation}->{'go back to questions'} = 'kembali kepada soalan-soalan';
    $Self->{Translation}->{'Possible Answers For'} = 'Jawapan Kemungkinan Untuk';
    $Self->{Translation}->{'Add Answer'} = 'Tambah Jawab';
    $Self->{Translation}->{'This doesn\'t have several answers, a textarea will be displayed.'} =
        'Ini tidak mempunyai beberapa jawapan, textarea akan dipaparkan.';
    $Self->{Translation}->{'Go back'} = 'Kembali';
    $Self->{Translation}->{'Edit Answer'} = 'Edit Jawapan';
    $Self->{Translation}->{'go back to edit question'} = 'kembali untuk mengedit soalan';

    # Template: AgentSurveyOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = 'konteks Tetapan';
    $Self->{Translation}->{'Max. shown Surveys per page'} = 'Max. Ukur ditunjukkan setiap halaman';

    # Template: AgentSurveyOverviewSmall
    $Self->{Translation}->{'Notification Sender'} = 'Pemberitahuan Pengirim';
    $Self->{Translation}->{'Notification Subject'} = 'Tertakluk Pemberitahuan';
    $Self->{Translation}->{'Notification Body'} = 'Badan Pemberitahuan';
    $Self->{Translation}->{'Changed By'} = 'Ditukar dengan';

    # Template: AgentSurveyStats
    $Self->{Translation}->{'Stats Overview of'} = 'Gambaran Keseluruhan Statistik daripada';
    $Self->{Translation}->{'Requests Table'} = 'Jadual permintaan';
    $Self->{Translation}->{'Send Time'} = 'Masa Hantar';
    $Self->{Translation}->{'Vote Time'} = 'Masa Undi';
    $Self->{Translation}->{'Survey Stat Details'} = 'Penyiasatan Details Stat';
    $Self->{Translation}->{'go back to stats overview'} = 'kembali ke Statistik gambaran keseluruhan';

    # Template: AgentSurveyZoom
    $Self->{Translation}->{'Survey Information'} = 'Maklumat Ukur';
    $Self->{Translation}->{'Sent requests'} = 'menghantar permintaan';
    $Self->{Translation}->{'Received surveys'} = 'diterima kaji selidik';
    $Self->{Translation}->{'Survey Details'} = 'Penyiasatan terperinchi';
    $Self->{Translation}->{'Survey Results Graph'} = 'Ukur Keputusan Graf';
    $Self->{Translation}->{'No stat results.'} = 'Tiada stat keputusan.';

    # Template: PublicSurvey
    $Self->{Translation}->{'Survey'} = 'Penyiasatan';
    $Self->{Translation}->{'Please answer these questions'} = 'Sila jawab soalan-soalan';
    $Self->{Translation}->{'Show my answers'} = 'Tunjukkan jawapan saya';
    $Self->{Translation}->{'These are your answers'} = 'Ini adalah jawapan anda';
    $Self->{Translation}->{'Survey Title'} = 'Tajuk Ukur';

    # SysConfig
    $Self->{Translation}->{'A Survey Module.'} = 'Satu Modul Penyiasatan';
    $Self->{Translation}->{'A module to edit survey questions.'} = 'Satu modul untuk mengedit soalan tinjauan';
    $Self->{Translation}->{'All parameters for the Survey object in the agent interface.'} =
        'Semua parameter bagi objek Ukur dalam antara muka ejen.';
    $Self->{Translation}->{'Amount of days after sending a survey mail in which no new survey requests are sent to the same customer. Selecting 0 will always send the survey mail.'} =
        'Jumlah hari selepas menghantar mel kaji selidik di mana tiada permintaan kaji selidik baru dihantar kepada pelanggan yang sama. Memilih 0 akan sentiasa menghantar mel kaji selidik.';
    $Self->{Translation}->{'Default body for the notification email to customers about new survey.'} =
        'Default badan untuk pemberitahuan e-mel kepada pelanggan tentang kaji selidik baru.';
    $Self->{Translation}->{'Default sender for the notification email to customers about new survey.'} =
        'Penghantar lalai untuk pemberitahuan e-mel kepada pelanggan tentang kaji selidik baru.';
    $Self->{Translation}->{'Default subject for the notification email to customers about new survey.'} =
        'Tertakluk lalai untuk pemberitahuan e-mel kepada pelanggan tentang kaji selidik baru.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a survey list.'} =
        'Mentakrifkan modul gambaran untuk menunjukkan pandangan yang kecil senarai kaji selidik.';
    $Self->{Translation}->{'Defines maximum amount of surveys that get sent to a customer per 30 days. ( 0 means no maximum, all survey requests will be sent).'} =
        'Mentakrifkan jumlah maksimum kaji selidik yang mendapat dihantar kepada pelanggan setiap 30 hari. (0 bermakna tidak maksimum, semua permintaan kaji selidik akan dihantar).';
    $Self->{Translation}->{'Defines the amount in hours a ticket has to be closed to trigger the sending of a survey, ( 0 means send immediately after close ).'} =
        'Mentakrifkan jumlah jam tiket akan ditutup untuk mencetuskan penghantaran kaji selidik, (0 cara menghantar segera selepas penutupan).';
    $Self->{Translation}->{'Defines the default height for Richtext views for SurveyZoom elements.'} =
        'Mentakrifkan ketinggian lalai untuk penonton Teks Kaya untuk elemen Zoom Ukur.';
    $Self->{Translation}->{'Defines the shown columns in the survey overview. This option has no effect on the position of the columns.'} =
        'Mentakrifkan ruangan menunjukkan dalam gambaran kajian.Pilihan ini tidak mempunyai kesan ke atas kedudukan tiang.';
    $Self->{Translation}->{'Edit Survey General Information'} = '';
    $Self->{Translation}->{'Edit Survey Questions'} = '';
    $Self->{Translation}->{'Enable or disable the ShowVoteData screen in the public interface to show data of a specific survey result when the customer tries to answer a survey the second time.'} =
        'Dayakan atau nyahdayakan Undi Papar Data skrin dalam antara muka awam untuk menunjukkan data hasil kajian tertentu apabila pelanggan cuba untuk menjawab kaji selidik kali kedua.';
    $Self->{Translation}->{'Frontend module registration for survey add in the agent interface.'} =
        '';
    $Self->{Translation}->{'Frontend module registration for survey edit in the agent interface.'} =
        '';
    $Self->{Translation}->{'Frontend module registration for survey stats in the agent interface.'} =
        '';
    $Self->{Translation}->{'Frontend module registration for survey zoom in the agent interface.'} =
        'Frontend pendaftaran modul untuk zoom kaji selidik dalam antara muka ejen.';
    $Self->{Translation}->{'Frontend module registration for the PublicSurvey object in the public Survey area.'} =
        'Frontend pendaftaran modul bagi objek Ukur Awam di kawasan Ukur awam.';
    $Self->{Translation}->{'If this regex matches, no customer survey will be sent.'} = 'Jika perlawanan regex ini, tiada kajian pelanggan akan dihantar.';
    $Self->{Translation}->{'Parameters for the pages (in which the surveys are shown) of the small survey overview.'} =
        'Parameter untuk halaman (di mana kaji selidik ditunjukkan) gambaran kajian kecil.';
    $Self->{Translation}->{'Public Survey.'} = 'Penyiasatan awam.';
    $Self->{Translation}->{'Shows a link in the menu to edit a survey in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to edit survey questions in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to go back in the survey zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to zoom into the survey statistics details in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Survey Edit Module.'} = '';
    $Self->{Translation}->{'Survey Overview "Small" Limit'} = 'Ukur Tinjauan Had "Kecil"';
    $Self->{Translation}->{'Survey Stats Module.'} = '';
    $Self->{Translation}->{'Survey Zoom Module.'} = 'Penyiasatan Zoom Modul';
    $Self->{Translation}->{'Survey limit per page for Survey Overview "Small"'} = 'Had Penyiasatan setiap halaman untuk Tinjauan Survey "Kecil"';
    $Self->{Translation}->{'Surveys will not be sent to the configured email addresses.'} = 'Ukur tidak akan dihantar ke alamat e-mel yang dikonfigurasi.';
    $Self->{Translation}->{'The identifier for a survey, e.g. Survey#, MySurvey#. The default is Survey#.'} =
        'Pengecam untuk kaji selidik, misalnya Penyiasatan # MySurvey #. Lalai adalah Penyiasatan#.';
    $Self->{Translation}->{'Ticket event module to send automatically survey email requests to customers if a ticket is closed.'} =
        'Tiket modul acara untuk menghantar permintaan e-mel secara automatik kaji selidik kepada pelanggan jika tiket ditutup.';
    $Self->{Translation}->{'Zoom Into Statistics Details'} = '';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #
    $Self->{Translation}->{'Changed Time'} = 'Waktu berubah';
    $Self->{Translation}->{'Created By'} = 'Dibuat Oleh';
    $Self->{Translation}->{'Created Time'} = 'Waktu Diciptakan';
    $Self->{Translation}->{'Days starting from the latest customer survey email between no customer survey email is sent, ( 0 means Always send it ) .'} =
        'Hari bermula dari pelanggan terbaru kaji selidik e-mel antara tiada kajian pelanggan e-mel dihantar, (0 bermakna Sentiasa hantar).';
    $Self->{Translation}->{'Defines maximum amount of surveys that get sent to a customer per 30 days, ( 0 means send immediately after close ).'} =
        'Mentakrifkan jumlah maksimum kaji selidik yang mendapat dihantar kepada pelanggan setiap 30 hari, (0 cara menghantar segera selepas penutupan)';
    $Self->{Translation}->{'Defines the shown columns in the survey overview. This option has no effect on the position of the column.'} =
        'Mentakrifkan ruangan menunjukkan dalam gambaran kajian. Pilihan ini tidak mempunyai kesan ke atas kedudukan tiang.';
    $Self->{Translation}->{'Enable or disable the ShowVoteData screen on public interface to show data of an specific votation when customer tries to answer a survey by second time.'} =
        'Dayakan atau nyahdayakan Undi Papar Data skrin pada antara muka awam untuk menunjukkan data putaran tertentu apabila pelanggan cuba untuk menjawab kaji selidik oleh kali kedua.';
    $Self->{Translation}->{'General Info'} = 'Maklumat Umum';
    $Self->{Translation}->{'Please answer the next questions'} = 'Sila jawab soalan seterusnya';
    $Self->{Translation}->{'Stats Details'} = 'Statistik terperinchi';
    $Self->{Translation}->{'This field is required'} = 'Bidang ini diperlukan';
    $Self->{Translation}->{'Ticket event module to send automatically survey email requests to customers if a ticket gets closed.'} =
        'Tiket modul acara untuk menghantar permintaan e-mel secara automatik kaji selidik kepada pelanggan jika tiket mendapat ditutup.';

}

1;
