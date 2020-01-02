# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::id_ITSMIncidentProblemManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentTicketOverviewMedium
    $Self->{Translation}->{'Criticality'} = 'Kritikalitas';
    $Self->{Translation}->{'Impact'} = 'Dampak';

    # JS Template: ServiceIncidentState
    $Self->{Translation}->{'Service Incident State'} = 'Status layanan insiden';

    # Perl Module: Kernel/Output/HTML/FilterElementPost/ITSMIncidentProblemManagement.pm
    $Self->{Translation}->{'Link ticket'} = 'tiket tautan';
    $Self->{Translation}->{'Change Decision of %s%s%s'} = '';
    $Self->{Translation}->{'Change ITSM fields of %s%s%s'} = '';

    # Perl Module: var/packagesetup/ITSMIncidentProblemManagement.pm
    $Self->{Translation}->{'Review Required'} = 'Memerlukan peninjauan';
    $Self->{Translation}->{'Decision Result'} = 'Hasil keputusan';
    $Self->{Translation}->{'Approved'} = 'Disetujui';
    $Self->{Translation}->{'Postponed'} = '';
    $Self->{Translation}->{'Pre-approved'} = '';
    $Self->{Translation}->{'Rejected'} = '';
    $Self->{Translation}->{'Repair Start Time'} = 'Waktu mulai perbaikan';
    $Self->{Translation}->{'Recovery Start Time'} = 'Waktu awal pemulihan';
    $Self->{Translation}->{'Decision Date'} = 'Tanggal keputusan';
    $Self->{Translation}->{'Due Date'} = 'tanggal jatuh tempo';

    # Database XML Definition: ITSMIncidentProblemManagement.sopm
    $Self->{Translation}->{'closed with workaround'} = 'Ditutup dengan solusi';

    # SysConfig
    $Self->{Translation}->{'Add a decision!'} = 'Berikan sebuah keputusan!';
    $Self->{Translation}->{'Additional ITSM Fields'} = 'Bidang ITSM tambahan';
    $Self->{Translation}->{'Additional ITSM ticket fields.'} = 'bidang tiket ITSM tambahan.';
    $Self->{Translation}->{'Allows adding notes in the additional ITSM field screen of the agent interface.'} =
        'Izinkan menambahkan catatan di dalam layar bidang ITS tambahan pada antarmuka agen.';
    $Self->{Translation}->{'Allows adding notes in the decision screen of the agent interface.'} =
        'izinkan menambahkan catatan di dalam layar keputusan pada antarmuka agen';
    $Self->{Translation}->{'Allows defining new types for ticket (if ticket type feature is enabled).'} =
        'Memungkinkan mendefinisikan jenis baru untuk tiket (jika fitur jenis tiket diaktifkan).';
    $Self->{Translation}->{'Change the ITSM fields!'} = 'Ubah bidang ITSM!';
    $Self->{Translation}->{'Decision'} = 'Keputusan';
    $Self->{Translation}->{'Defines if a ticket lock is required in the additional ITSM field screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        'Definisikan jika kunci tiket diperlukan pada layar bidang ITSM tambahan pada antarmuka agen (jika tiket belum terkunci, tiket akan terkunci dan agen saat itu secara otomatis akan menjadi pemiliknya).';
    $Self->{Translation}->{'Defines if a ticket lock is required in the decision screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        'Definisikan jika kunci tiket diperlukan di layar keputusan pada antarmuka agen (jika tiket belum terkunci, tiket akan terkunci dan agen saat itu akan menjadi pemiliknya secara otomatis).';
    $Self->{Translation}->{'Defines if the service incident state should be shown during service selection in the agent interface.'} =
        'Definisikan jika status layanan insiden harus di tampilkan ketika pemilihan layanan pada antarmuka agen.';
    $Self->{Translation}->{'Defines the default body of a note in the additional ITSM field screen of the agent interface.'} =
        'Definisikan isi default catatan dalam layar bidang ITSM tambahan pada antarmuka agen.';
    $Self->{Translation}->{'Defines the default body of a note in the decision screen of the agent interface.'} =
        'Definisikan isi default catatan di layar keputusan pada antarmuka agen.';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the additional ITSM field screen of the agent interface.'} =
        'Definisikan status default berikutnya dari sebuah tiket setelah menambahkan catatan, dalam layar bidang ITSM tambahan pada antarmuka agen.';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the decision screen of the agent interface.'} =
        'Definisikan status default berikutnya dari sebuah tiket setelah menambahkan catatan, dalam Layar keputusan pada antarmuka agen.';
    $Self->{Translation}->{'Defines the default subject of a note in the additional ITSM field screen of the agent interface.'} =
        'Definisikan subjek default dari sebuah cacatan dalam layar bidang ITSM tambahan pada antarmuka agen.';
    $Self->{Translation}->{'Defines the default subject of a note in the decision screen of the agent interface.'} =
        'Definisikan subjek default dari sebuah cacatan dalam layar Keputusan pada antarmuka agen.';
    $Self->{Translation}->{'Defines the default ticket priority in the additional ITSM field screen of the agent interface.'} =
        'Definisikan prioritas default tiket dalam layar bidang ITSM tambahan pada antarmuka agen.';
    $Self->{Translation}->{'Defines the default ticket priority in the decision screen of the agent interface.'} =
        'Definisikan prioritas default tiket dalam layar keputusan pada antarmuka agen.';
    $Self->{Translation}->{'Defines the history comment for the additional ITSM field screen action, which gets used for ticket history.'} =
        'Definisikan riwayat komentar untuk tindakan layar bidang ITSM tambahan, yang digunakan pada riwayat tiket.';
    $Self->{Translation}->{'Defines the history comment for the decision screen action, which gets used for ticket history.'} =
        'Definisikan riwayat komentar untuk tindakan layar keputusan, yang digunakan pada riwayat tiket.';
    $Self->{Translation}->{'Defines the history type for the additional ITSM field screen action, which gets used for ticket history.'} =
        'Definisikan tipe riwayat untuk tindakan layar bidang ITSM tambahan, yang digunakan pada riwayat tiket.';
    $Self->{Translation}->{'Defines the history type for the decision screen action, which gets used for ticket history.'} =
        'Definisikan tipe riwayat untuk tindakan layar keputusan, yang digunakan pada riwayat tiket.';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the additional ITSM field screen of the agent interface.'} =
        'Definisikan status tiket berikutnya setelah menambahkan catatan, didalam layar bidang ITSM tambahan pada antarmuka agen.';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the decision screen of the agent interface.'} =
        'Definisikan status tiket berikutnyasetalah menambahkan catatan, di dalam layar keputusan pada antarmuka agen.';
    $Self->{Translation}->{'Dynamic fields shown in the additional ITSM field screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the decision screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the ticket zoom screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Enables the stats module to generate statistics about the average of ITSM ticket first level solution rate.'} =
        'aktifkan modul stats untuk menghasilkan statistik tentang rata-rata tingkat penyelesaian level pertama tiket ITSM.';
    $Self->{Translation}->{'Enables the stats module to generate statistics about the average of ITSM ticket solution.'} =
        'aktifkan modul stats untuk menghasilkan statistik tentang rata-rata penyelesaian tiket ITSM';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of a ticket in the additional ITSM field screen of the agent interface.'} =
        'Jika sebuah catatan yang di tambahkan oleh agen, tentukan status tiket didalam layar bidang ITSM tambahan pada antarmuka agen.';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of a ticket in the decision screen of the agent interface.'} =
        'Jika sebuah catatan ditambahkan oleh agen, tentukan status tiket didalam layar keputusan pada antarmuka agen.';
    $Self->{Translation}->{'Modifies the display order of the dynamic field ITSMImpact and other things.'} =
        '';
    $Self->{Translation}->{'Module to dynamically show the service incident state and to calculate the priority.'} =
        '';
    $Self->{Translation}->{'Required permissions to use the additional ITSM field screen in the agent interface.'} =
        'Memerlukan izin untuk menggunakan layar bidang ITSM tambahan pada antarmuka agen.';
    $Self->{Translation}->{'Required permissions to use the decision screen in the agent interface.'} =
        'Memerlukan izin untuk menggunakan layar keputusan pada antarmuka agen.';
    $Self->{Translation}->{'Service Incident State and Priority Calculation'} = '';
    $Self->{Translation}->{'Sets the service in the additional ITSM field screen of the agent interface (Ticket::Service needs to be activated).'} =
        'Tentukan layanan di layar bidang ITSM tambahan pada antarmuka agen (Ticket::Service perlu di aktifkan).';
    $Self->{Translation}->{'Sets the service in the decision screen of the agent interface (Ticket::Service needs to be activated).'} =
        'Tentukan layanan di layar keputusan pada antarmuka agen (Ticket::Service perlu di aktifkan).';
    $Self->{Translation}->{'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).'} =
        'Set layanan di layar prioritas tiket dari tiket yang diperbesar di antarmuka agen (Ticket :: Layanan harus diaktifkan).';
    $Self->{Translation}->{'Sets the ticket owner in the additional ITSM field screen of the agent interface.'} =
        'Tentukan pemilik tiket di layar bidang ITSM tambahan pada antarmuka agen.';
    $Self->{Translation}->{'Sets the ticket owner in the decision screen of the agent interface.'} =
        'Tentukan pemilik tiket di layar keputusan pada antarmuka agen.';
    $Self->{Translation}->{'Sets the ticket responsible in the additional ITSM field screen of the agent interface.'} =
        'Tentukan penanggung jawab tiket di layar bidang ITSM tambahan pada antarmuka agen.';
    $Self->{Translation}->{'Sets the ticket responsible in the decision screen of the agent interface.'} =
        'Tentukan penanggung jawab tiket di layar keputusan pada antarmuka agen.';
    $Self->{Translation}->{'Sets the ticket type in the additional ITSM field screen of the agent interface (Ticket::Type needs to be activated).'} =
        'Tentukan tipe tiket di layar bidang ITSM tambahan pada antarmuka agen (Ticket::Type perlu di aktifkan).';
    $Self->{Translation}->{'Sets the ticket type in the decision screen of the agent interface (Ticket::Type needs to be activated).'} =
        'Tentukan tipe tiket di layar keputusan pada antarmuka agen (Ticket::Type perlu di aktifkan).';
    $Self->{Translation}->{'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).'} =
        'Menetapkan jenis tiket di layar prioritas tiket dari tiket yang diperbesar di antarmuka agen (Ticket :: Type harus diaktifkan).';
    $Self->{Translation}->{'Shows a link in the menu to change the decision of a ticket in its zoom view of the agent interface.'} =
        'Tunjukan tautan di menu untukmengubah keputusan sebuah tiket pada tampilan pembesaran pada antarmuka agen.';
    $Self->{Translation}->{'Shows a link in the menu to modify additional ITSM fields in the ticket zoom view of the agent interface.'} =
        'Tunjukan tautan di menu untuk memodifikasi bidang ITSM tambahan di tampilan pembesaran tiket pada antarmuka agen.';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the additional ITSM field screen of the agent interface.'} =
        'Tunjukan daftar dari semua agen yang terlibat pada tiket ini, didalam layar bidang ITSM tambahan pada antarmuka agen.';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the decision screen of the agent interface.'} =
        'Tunjukan daftar dari semua agen yang terlibat pada tiket ini, didalam layar keputusan pada antarmuka agen.';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the additional ITSM field screen of the agent interface.'} =
        'Tunjukan daftar semua agen yang memungkinkan (semua agen dengan izin catatan pada antrian/tiket) untuk menentukan siapa yang harus di informasikan tentang catatan ini, di dalam layar bidang ITSM tambahan pada antar muka agen.';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the decision screen of the agent interface.'} =
        'Tunjukan daftar semua agen yang memungkinkan (semua agen dengan izin catatan pada antrian/tiket) untuk menentukan siapa yang harus di informasikan tentang catatan ini, di dalam layar keputusan pada antarmuka agen.';
    $Self->{Translation}->{'Shows the ticket priority options in the additional ITSM field screen of the agent interface.'} =
        'Tunjukan pilihan prioritas tiket didalam layar bidang ITSM tambahan pada antarmuka agen.';
    $Self->{Translation}->{'Shows the ticket priority options in the decision screen of the agent interface.'} =
        'Tunjukan pilihan prioritas tiket didalam layar keputusan pada antarmuka agen.';
    $Self->{Translation}->{'Shows the title fields in the additional ITSM field screen of the agent interface.'} =
        'Tunjukan bidang judul di layar bidang ITSM tambahan pada antarmuka agen.';
    $Self->{Translation}->{'Shows the title fields in the decision screen of the agent interface.'} =
        'Tunjukan bidang judul di layar keputusan pada antarmuka agen';
    $Self->{Translation}->{'Ticket decision.'} = 'Keputusan tiket.';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Service Incident State',
    );

}

1;
