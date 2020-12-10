# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::ms_ITSMIncidentProblemManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentTicketOverviewMedium
    $Self->{Translation}->{'Criticality'} = 'Kritikal';
    $Self->{Translation}->{'Impact'} = 'Kesan';

    # JS Template: ServiceIncidentState
    $Self->{Translation}->{'Service Incident State'} = 'Keadaan Insiden Perkhidmatan';

    # Perl Module: Kernel/Output/HTML/FilterElementPost/ITSMIncidentProblemManagement.pm
    $Self->{Translation}->{'Link ticket'} = 'Pautan tiket';
    $Self->{Translation}->{'Change Decision of %s%s%s'} = '';
    $Self->{Translation}->{'Change ITSM fields of %s%s%s'} = '';

    # Perl Module: var/packagesetup/ITSMIncidentProblemManagement.pm
    $Self->{Translation}->{'Review Required'} = 'kerja semula diperlukan';
    $Self->{Translation}->{'Decision Result'} = 'Keputusan';
    $Self->{Translation}->{'Approved'} = 'Diluluskan';
    $Self->{Translation}->{'Postponed'} = '';
    $Self->{Translation}->{'Pre-approved'} = '';
    $Self->{Translation}->{'Rejected'} = '';
    $Self->{Translation}->{'Repair Start Time'} = 'Perbaiki Masa Mula';
    $Self->{Translation}->{'Recovery Start Time'} = 'Pemulihan Masa Mula';
    $Self->{Translation}->{'Decision Date'} = 'Tarikh Keputusan';
    $Self->{Translation}->{'Due Date'} = 'Tarikh disebabkan';

    # Database XML Definition: ITSMIncidentProblemManagement.sopm
    $Self->{Translation}->{'closed with workaround'} = 'ditutup dengan kerja di sekitar';

    # SysConfig
    $Self->{Translation}->{'Add a decision!'} = 'Tambah keputusan!';
    $Self->{Translation}->{'Additional ITSM Fields'} = 'Tambahan ITSM Medan';
    $Self->{Translation}->{'Additional ITSM ticket fields.'} = 'tambahan kawasan-kawasan tiket ITSM';
    $Self->{Translation}->{'Allows adding notes in the additional ITSM field screen of the agent interface.'} =
        'Membenarkan penambahan catatan dalam skrin medan ITSM tambahan antara muka ejen.';
    $Self->{Translation}->{'Allows adding notes in the decision screen of the agent interface.'} =
        'Membenarkan penambahan nota dalam skrin keputusan bagi ruang antara muka ejen.';
    $Self->{Translation}->{'Allows defining new types for ticket (if ticket type feature is enabled).'} =
        'Membolehkan jenis tiket yang baru didefinasikan (jika fungsi jenis tiket diaktifkan).';
    $Self->{Translation}->{'Change the ITSM fields!'} = 'Ändern der ITSM-Felder!';
    $Self->{Translation}->{'Decision'} = 'Entscheidung';
    $Self->{Translation}->{'Defines if a ticket lock is required in the additional ITSM field screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        'Menentukan jika kunci tiket diperlukan di skrin medan ITSM tambahan antara muka ejen (jika tiket tidak dikunci lagi, tiket menjadi berkunci dan ejen semasa akan disetkan secara automatik sebagai pemiliknya).';
    $Self->{Translation}->{'Defines if a ticket lock is required in the decision screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        'Menentukan jika kunci tiket diperlukan di skrin keputusan antara muka ejen (jika tiket tidak dikunci lagi, tiket menjadi berkunci dan ejen semasa akan disetkan secara automatik sebagai pemiliknya).';
    $Self->{Translation}->{'Defines if the service incident state should be shown during service selection in the agent interface.'} =
        'Mentakrifkan jika keadaan insiden perkhidmatan hendaklah ditunjukkan semasa pemilihan perkhidmatan dalam ruang antara muka ejen.';
    $Self->{Translation}->{'Defines the default body of a note in the additional ITSM field screen of the agent interface.'} =
        'Menentukan badan lalai nota di skrin medan ITSM tambahan antara muka ejen.';
    $Self->{Translation}->{'Defines the default body of a note in the decision screen of the agent interface.'} =
        'Menentukan badan lalai nota di skrin keputusan antara muka ejen.';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the additional ITSM field screen of the agent interface.'} =
        'Mentakrifkan keadaan lalai seterusnya dari tiket selepas menambah nota, dalam skrin bidang ITSM tambahan dari paparan ejen.';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the decision screen of the agent interface.'} =
        'Mentakrifkan asal keadaan seterusnya dari tiket selepas menambah nota, dalam skrin keputusan dari paparan ejen.';
    $Self->{Translation}->{'Defines the default subject of a note in the additional ITSM field screen of the agent interface.'} =
        'Menentukan subjek lalai nota di skrin medan ITSM tambahan antara muka ejen.';
    $Self->{Translation}->{'Defines the default subject of a note in the decision screen of the agent interface.'} =
        'Menentukan subjek lalai nota di skrin keputusan antara muka ejen.';
    $Self->{Translation}->{'Defines the default ticket priority in the additional ITSM field screen of the agent interface.'} =
        'Mentakrifkan keutamaan tiket default di skrin medan ITSM tambahan antara muka ejen.';
    $Self->{Translation}->{'Defines the default ticket priority in the decision screen of the agent interface.'} =
        'Mentakrifkan keutamaan tiket default di skrin keputusan antara muka agen.';
    $Self->{Translation}->{'Defines the history comment for the additional ITSM field screen action, which gets used for ticket history.'} =
        'Menentukan komen sejarah untuk medan skrin tindakan ITSM tambahan,  yang dapat digunakan untuk sejarah tiket.';
    $Self->{Translation}->{'Defines the history comment for the decision screen action, which gets used for ticket history.'} =
        'Mentakrifkan komen sejarah bagi tindakan skrin keputusan, yang akan digunakan untuk sejarah tiket.';
    $Self->{Translation}->{'Defines the history type for the additional ITSM field screen action, which gets used for ticket history.'} =
        'Mentakrifkan jenis sejarah bagi tindakan skrin bidang ITSM tambahan, yang akan digunakan untuk sejarah tiket.';
    $Self->{Translation}->{'Defines the history type for the decision screen action, which gets used for ticket history.'} =
        'Mentakrifkan jenis sejarah bagi tindakan skrin keputusan, yang akan digunakan untuk sejarah tiket.';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the additional ITSM field screen of the agent interface.'} =
        'Mentakrifkan keadaan seterusnya tiket selepas menambah nota, dalam skrin bidang ITSM tambahan bagi antara muka ejen.';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the decision screen of the agent interface.'} =
        'Mentakrifkan keadaan seterusnya tiket selepas menambah nota, dalam skrin keputusan bagi antara muka ejen.';
    $Self->{Translation}->{'Dynamic fields shown in the additional ITSM field screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the decision screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the ticket zoom screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Enables the stats module to generate statistics about the average of ITSM ticket first level solution rate.'} =
        'Membolehkan modul statistik untuk menjana statistik tentang purata tiket ITSM peringkat pertama kadar penyelesaian.';
    $Self->{Translation}->{'Enables the stats module to generate statistics about the average of ITSM ticket solution.'} =
        'Membolehkan modul statistik untuk menjana statistik tentang purata penyelesaian tiket ITSM.';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of a ticket in the additional ITSM field screen of the agent interface.'} =
        'Jika nota ditambah oleh ejen, tetapkan keadaan tiket dalam skrin bidang ITSM tambahan bagi antara muka ejen.';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of a ticket in the decision screen of the agent interface.'} =
        'Jika nota ditambah oleh ejen, tetapkan keadaan tiket dalam skrin keputusan bagi antara muka ejen.';
    $Self->{Translation}->{'Modifies the display order of the dynamic field ITSMImpact and other things.'} =
        '';
    $Self->{Translation}->{'Module to dynamically show the service incident state and to calculate the priority.'} =
        '';
    $Self->{Translation}->{'Required permissions to use the additional ITSM field screen in the agent interface.'} =
        'Kebenaran yang diperlukan untuk menggunakan skrin bidang ITSM tambahan dalam antara muka ejen.';
    $Self->{Translation}->{'Required permissions to use the decision screen in the agent interface.'} =
        'Kebenaran yang diperlukan untuk menggunakan skrin keputusan dalam antara muka ejen.';
    $Self->{Translation}->{'Service Incident State and Priority Calculation'} = '';
    $Self->{Translation}->{'Sets the service in the additional ITSM field screen of the agent interface (Ticket::Service needs to be activated).'} =
        'Set perkhidmatan dalam skrin bidang ITSM tambahan bagi antara muka ejen (Tiket::Perkhidmatan perlu diaktifkan).';
    $Self->{Translation}->{'Sets the service in the decision screen of the agent interface (Ticket::Service needs to be activated).'} =
        'Set perkhidmatan dalam skrin keputusan bagi antara muka ejen (Tiket::Perkhidmatan perlu diaktifkan).';
    $Self->{Translation}->{'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).'} =
        'Tetapkan perkhidmatan dalam skrin keutamaan tiket dari tiket dizum dalam paparan ejen (Ticket::Service perlu diaktifkan).';
    $Self->{Translation}->{'Sets the ticket owner in the additional ITSM field screen of the agent interface.'} =
        'Set pemilik tiket dalam skrin bidang ITSM tambahan bagi antara muka ejen.';
    $Self->{Translation}->{'Sets the ticket owner in the decision screen of the agent interface.'} =
        'Set pemilik tiket dalam skrin keputusan bagi antara muka ejen.';
    $Self->{Translation}->{'Sets the ticket responsible in the additional ITSM field screen of the agent interface.'} =
        'Set tiket yang bertanggungjawab dalam skrin bidang ITSM tambahan bagi antara muka ejen.';
    $Self->{Translation}->{'Sets the ticket responsible in the decision screen of the agent interface.'} =
        'Set tiket yang bertanggungjawab dalam skrin keputusan bagi antara muka ejen.';
    $Self->{Translation}->{'Sets the ticket type in the additional ITSM field screen of the agent interface (Ticket::Type needs to be activated).'} =
        'Menetapkan jenis tiket dalam skrin bidang ITSM tambahan bagi antara muka ejen (Tiket::Jenis perlu diaktifkan).';
    $Self->{Translation}->{'Sets the ticket type in the decision screen of the agent interface (Ticket::Type needs to be activated).'} =
        'Menetapkan jenis tiket dalam skrin keputusan bagi antara muka ejen (Tiket::Jenis perlu diaktifkan).';
    $Self->{Translation}->{'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).'} =
        'Tetapkan jenis tiket dalam skrin keutamaan tiket dari tiket dizum dalam paparan ejen (Ticket::Type perlu diaktifkan).';
    $Self->{Translation}->{'Shows a link in the menu to change the decision of a ticket in its zoom view of the agent interface.'} =
        'Menunjukkan pautan dalam menu untuk mengubah keputusan tiket dalam pandangan zum antara muka ejen.';
    $Self->{Translation}->{'Shows a link in the menu to modify additional ITSM fields in the ticket zoom view of the agent interface.'} =
        'Menunjukkan pautan dalam menu untuk mengubah suai bidang ITSM tambahan dalam pandangan zum tiket bagi antara muka ejen.';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the additional ITSM field screen of the agent interface.'} =
        'Memaparkan senarai semua ejen yang terlibat dalam tiket ini, dalam skrin bidang ITSM tambahan bagi antara muka ejen.';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the decision screen of the agent interface.'} =
        'Memaparkan senarai semua ejen yang terlibat dalam tiket ini, dalam skrin keputusan bagi antara muka ejen.';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the additional ITSM field screen of the agent interface.'} =
        'Memaparkan senarai semua kemungkinan ejen ( semua ejen dengan kebenaran nota mengenai barisan / tiket) untuk menentukan siapa yang perlu diberitahu tentang nota ini , dalam skrin bidang ITSM tambahan bagi antara muka ejen.';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the decision screen of the agent interface.'} =
        'Memaparkan senarai semua kemungkinan ejen (semua ejen dengan kebenaran nota mengenai barisan/tiket) untuk menentukan siapa yang perlu diberitahu tentang nota ini, dalam skrin keputusan bagi antara muka ejen.';
    $Self->{Translation}->{'Shows the ticket priority options in the additional ITSM field screen of the agent interface.'} =
        'Menunjukkan pilihan keutamaan tiket dalam skrin bidang ITSM tambahan bagi antara muka ejen.';
    $Self->{Translation}->{'Shows the ticket priority options in the decision screen of the agent interface.'} =
        'Menunjukkan pilihan keutamaan tiket dalam skrin keputusan bagi antara muka ejen.';
    $Self->{Translation}->{'Shows the title fields in the additional ITSM field screen of the agent interface.'} =
        'Menunjukkan bidang tajuk dalam skrin bidang ITSM tambahan bagi antara muka ejen.';
    $Self->{Translation}->{'Shows the title fields in the decision screen of the agent interface.'} =
        'Menunjukkan bidang tajuk dalam skrin keputusan bagi antara muka ejen.';
    $Self->{Translation}->{'Ticket decision.'} = 'keputusan tiket';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Service Incident State',
    );

}

1;
