# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ms_OTRSMasterSlave;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminDynamicFieldMasterSlave
    $Self->{Translation}->{'Field'} = 'Bidang';

    # Template: AgentTicketMasterSlave
    $Self->{Translation}->{'Manage Master/Slave status for %s%s%s'} = '';

    # Perl Module: Kernel/Modules/AgentTicketMasterSlave.pm
    $Self->{Translation}->{'New Master Ticket'} = 'Tiket Master Baharu';
    $Self->{Translation}->{'Unset Master Ticket'} = 'Tiket Master Tidak Ditetapkan';
    $Self->{Translation}->{'Unset Slave Ticket'} = 'Tiket Slave Tidak Ditetapkan';
    $Self->{Translation}->{'Slave of %s%s%s: %s'} = '';

    # Perl Module: Kernel/Output/HTML/TicketBulk/MasterSlave.pm
    $Self->{Translation}->{'Unset Master Tickets'} = '';
    $Self->{Translation}->{'Unset Slave Tickets'} = '';

    # Perl Module: Kernel/System/DynamicField/Driver/MasterSlave.pm
    $Self->{Translation}->{'Master'} = 'Induk';
    $Self->{Translation}->{'Slave of %s%s%s'} = '';
    $Self->{Translation}->{'Master Ticket'} = '';

    # SysConfig
    $Self->{Translation}->{'All master tickets'} = '';
    $Self->{Translation}->{'All slave tickets'} = '';
    $Self->{Translation}->{'Allows adding notes in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Membenarkan menambah nota dalam skrin MasterSlave tiket bagi tiket dizum dalam antara muka ejen.';
    $Self->{Translation}->{'Change the MasterSlave state of the ticket.'} = 'Ubah keadaan tiket MasterSlave.';
    $Self->{Translation}->{'Defines dynamic field name for master ticket feature.'} = '';
    $Self->{Translation}->{'Defines if a ticket lock is required in the ticket MasterSlave screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        'Mentakrifkan jika kunci tiket diperlukan dalam skrin MasterSlave tiket tiket dizum dalam antara muka ejen (jika tiket itu tidak dikunci lagi, tiket yang akan dikunci dan ejen semasa akan ditetapkan secara automatik sebagai pemiliknya).';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Mentakrifkan keadaan default seterusnya bagi tiket selepas menambah nota, dalam skrin MasterSlave tiket tiket dizum dalam antara muka ejen.';
    $Self->{Translation}->{'Defines the default ticket priority in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Mentakrifkan keutamaan tiket default dalam skrin MasterSlave tiket tiket dizum dalam antara muka ejen.';
    $Self->{Translation}->{'Defines the default type of the note in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Mentakrifkan jenis default nota dalam skrin MasterSlave tiket tiket dizum dalam antara muka ejen.';
    $Self->{Translation}->{'Defines the history comment for the ticket MasterSlave screen action, which gets used for ticket history in the agent interface.'} =
        'Mentakrifkan komen sejarah bagi kesan skrin MasterSlave tiket, yang akan digunakan untuk sejarah tiket dalam antara muka ejen.';
    $Self->{Translation}->{'Defines the history type for the ticket MasterSlave screen action, which gets used for ticket history in the agent interface.'} =
        'Mentakrifkan jenis sejarah bagi tindakan skrin tiket MasterSlave, yang akan digunakan untuk sejarah tiket dalam antara muka ejen.';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Mentakrifkan keadaan seterusnya bagi tiket selepas menambah nota, dalam skrin MasterSlave tiket tiket dizum dalam antara muka ejen.';
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
        'Jika nota ditambah oleh ejen, tetapkan keadaan tiket dalam skrin MasterSlave tiket tiket dizum dalam antara muka ejen.';
    $Self->{Translation}->{'Master / Slave'} = 'Master / Slave';
    $Self->{Translation}->{'Master Tickets'} = '';
    $Self->{Translation}->{'MasterSlave'} = '';
    $Self->{Translation}->{'MasterSlave module for Ticket Bulk feature.'} = 'Modul MasterSlave untuk ciri Bulk Tiket.';
    $Self->{Translation}->{'Parameters for the dashboard backend of the master tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.'} =
        'Parameter untuk bahagian belakang papan pemuka daripada gambaran keseluruhan tiket master antara muka ejen. "Had" adalah bilangan penyertaan ditunjukkan secara default. "Kumpulan" digunakan untuk menyekat akses kepada masuk (contoh: Kumpulan: admin; kumpulan1; kumpulan2;). "Default" menentukan jika plugin ini diaktifkan secara default atau jika pengguna perlu untuk membolehkan secara manual. "CacheTTLLocal" adalah masa cache dalam minit untuk plugin.';
    $Self->{Translation}->{'Parameters for the dashboard backend of the slave tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.'} =
        'Parameter untuk bahagian belakang papan pemuka daripada gambaran keseluruhan tiket slave antara muka ejen. "Had" adalah bilangan penyertaan ditunjukkan secara default. "Kumpulan" digunakan untuk menyekat akses kepada masuk (contoh: Kumpulan: admin; kumpulan1; kumpulan2;). "Default" menentukan jika plugin ini diaktifkan secara default atau jika pengguna perlu untuk membolehkan secara manual. "CacheTTLLocal" adalah masa cache dalam minit untuk plugin.';
    $Self->{Translation}->{'Registration of the ticket event module.'} = 'Pendaftaran tiket modul acara.';
    $Self->{Translation}->{'Required permissions to use the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Kebenaran yang diperlukan untuk menggunakan skrin MasterSlave tiket tiket dizum dalam antara muka ejen.';
    $Self->{Translation}->{'Sets if Master / Slave field must be selected by the agent.'} = '';
    $Self->{Translation}->{'Sets the default body text for notes added in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Menetapkan teks badan default untuk nota ditambah dalam skrin MasterSlave tiket tiket dizum dalam antara muka ejen.';
    $Self->{Translation}->{'Sets the default subject for notes added in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Set subjek default untuk nota ditambah dalam skrin MasterSlave tiket tiket dizum dalam antara muka ejen.';
    $Self->{Translation}->{'Sets the responsible agent of the ticket in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Set ejen yang bertanggungjawab bagi tiket dalam skrin MasterSlave tiket tiket dizum dalam antara muka ejen.';
    $Self->{Translation}->{'Sets the service in the ticket MasterSlave screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).'} =
        'Set perkhidmatan di skrin MasterSlave tiket tiket dizum dalam antara muka ejen (Tiket::Perkhidmatan perlu diaktifkan).';
    $Self->{Translation}->{'Sets the ticket owner in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Set pemilik tiket dalam skrin MasterSlave tiket tiket dizum dalam antara muka ejen.';
    $Self->{Translation}->{'Sets the ticket type in the ticket MasterSlave screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).'} =
        'Menetapkan jenis tiket yang dalam skrin MasterSlave tiket tiket dizum dalam antara muka ejen (Tiket::Jenis perlu diaktifkan).';
    $Self->{Translation}->{'Shows a link in the menu to change the MasterSlave status of a ticket in the ticket zoom view of the agent interface.'} =
        'Menunjukkan pautan dalam menu untuk menukar status MasterSlave bagi tiket dalam pandangan zum tiket bagi antara muka ejen.';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Memaparkan senarai semua ejen yang terlibat dalam tiket ini, dalam skrin MasterSlave tiket tiket dizum dalam antara muka ejen.';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Memaparkan senarai semua kemungkinan ejen (semua ejen dengan kebenaran nota mengenai barisan/tiket) untuk menentukan siapa yang perlu diberitahu tentang nota ini, dalam skrin MasterSlave tiket tiket dizum dalam antara muka ejen.';
    $Self->{Translation}->{'Shows the ticket priority options in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Menunjukkan pilihan keutamaan tiket dalam skrin MasterSlave tiket tiket dizum dalam antara muka ejen.';
    $Self->{Translation}->{'Shows the title field in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '';
    $Self->{Translation}->{'Slave Tickets'} = '';
    $Self->{Translation}->{'Specifies the different article types where the real name from Master ticket will be replaced with the one in the Slave ticket.'} =
        'Menentukan jenis artikel yang berbeza di mana nama sebenar dari tiket Master akan digantikan dengan yang dalam tiket Slave.';
    $Self->{Translation}->{'Specifies the different note types that will be used in the system.'} =
        'Tentukan jenis nota berbeza yang akan digunakan dalam sistem.';
    $Self->{Translation}->{'This module activates Master/Slave field in new email and phone ticket screens.'} =
        'Modul ini mengaktifkan medan Master/Slave di skrin emel dan tiket telefon baru.';
    $Self->{Translation}->{'Ticket MasterSlave.'} = '';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
