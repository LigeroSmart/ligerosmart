# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::id_OTRSMasterSlave;

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
    $Self->{Translation}->{'New Master Ticket'} = 'Tiket master baru';
    $Self->{Translation}->{'Unset Master Ticket'} = 'Tidak perlu set tiket master';
    $Self->{Translation}->{'Unset Slave Ticket'} = 'Lepaskan set tiket slave';
    $Self->{Translation}->{'Slave of %s%s%s: %s'} = '';

    # Perl Module: Kernel/Output/HTML/TicketBulk/MasterSlave.pm
    $Self->{Translation}->{'Unset Master Tickets'} = 'Melepas tiket master';
    $Self->{Translation}->{'Unset Slave Tickets'} = 'Melepaskan tiket slave';

    # Perl Module: Kernel/System/DynamicField/Driver/MasterSlave.pm
    $Self->{Translation}->{'Master'} = 'Induk';
    $Self->{Translation}->{'Slave of %s%s%s'} = '';
    $Self->{Translation}->{'Master Ticket'} = '';

    # SysConfig
    $Self->{Translation}->{'All master tickets'} = 'Semua tiket master';
    $Self->{Translation}->{'All slave tickets'} = 'Semua tiket slave';
    $Self->{Translation}->{'Allows adding notes in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Memungkinkan menambahkan catatan dalam layar tiket master slave dari tiket yang diperbesar di antarmuka agen.';
    $Self->{Translation}->{'Change the MasterSlave state of the ticket.'} = 'Mengubah keadaan Master slave tiket.';
    $Self->{Translation}->{'Defines dynamic field name for master ticket feature.'} = 'Mendefinisikan nama field yang dinamis untuk fitur utama tiket.';
    $Self->{Translation}->{'Defines if a ticket lock is required in the ticket MasterSlave screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).'} =
        'Mendefinisikan jika kunci tiket diperlukan di layar MasterSlave tiket dari tiket yang diperbesar di antarmuka agen (jika tiket tidak terkunci lagi, tiket akan terkunci dan agen saat ini akan diatur secara otomatis sebagai pemiliknya).';
    $Self->{Translation}->{'Defines if the MasterSlave note is visible for the customer by default.'} =
        '';
    $Self->{Translation}->{'Defines the default next state of a ticket after adding a note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Mendefinisikan default state berikutnya tiket setelah menambahkan catatan, dalam tiket Guru layar Slave dari tiket yang diperbesar di antarmuka agen.';
    $Self->{Translation}->{'Defines the default ticket priority in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Mendefinisikan prioritas tiket default di layar tiket Master Slave dari tiket yang diperbesar di antarmuka agen.';
    $Self->{Translation}->{'Defines the history comment for the ticket MasterSlave screen action, which gets used for ticket history in the agent interface.'} =
        'Mendefinisikan komentar sejarah untuk tindakan tiket masterslave pada layar, yang akan digunakan untuk sejarah tiket di antarmuka agen.';
    $Self->{Translation}->{'Defines the history type for the ticket MasterSlave screen action, which gets used for ticket history in the agent interface.'} =
        'Mendefinisikan jenis sejarah untuk tindakan tiket master slave di layar, yang akan digunakan untuk sejarah tiket di antarmuka agen.';
    $Self->{Translation}->{'Defines the next state of a ticket after adding a note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Mendefinisikan state berikutnya tiket setelah menambahkan catatan, dalam layar tiket Master Slave dari tiket yang diperbesar di antarmuka agen.';
    $Self->{Translation}->{'Enables the advanced MasterSlave part of the feature.'} = 'Memungkinkan Master slave bagian dari fitur tersebut.';
    $Self->{Translation}->{'Enables the feature that slave tickets follow the master ticket to a new master in the advanced MasterSlave mode.'} =
        'Mengaktifkan fitur tiket slave untuk mengikuti tiket master baru dalam modus Master Slave canggih.';
    $Self->{Translation}->{'Enables the feature to change the MasterSlave state of a ticket in the advanced MasterSlave mode.'} =
        'Memungkinkan fitur untuk mengubah keadaan Master slave dari tiket dalam modus Master Slave canggih.';
    $Self->{Translation}->{'Enables the feature to forward articles from type \'forward\' of a master ticket to the customers of the slave tickets. By default (disabled) it will not forward articles from type \'forward\' to the slave tickets.'} =
        'Memungkinkan fitur untuk meneruskan artikel dari jenis \'maju\' dari tiket master untuk pelanggan dari tiket slave. Secara default (cacat) itu tidak akan meneruskan artikel dari jenis \'maju\' untuk tiket slave.';
    $Self->{Translation}->{'Enables the feature to keep parent-child link after change of the MasterSlave state in the advanced MasterSlave mode.'} =
        'Memungkinkan fitur untuk menjaga link orangtua-anak setelah perubahan dari state Master slave dalam modus Master Slave canggih.';
    $Self->{Translation}->{'Enables the feature to keep parent-child link after unset of the MasterSlave state in the advanced MasterSlave mode.'} =
        'Memungkinkan fitur untuk menjaga link orangtua-anak setelah diset dari negara Master slave dalam modus Master Slave canggih.';
    $Self->{Translation}->{'Enables the feature to unset the MasterSlave state of a ticket in the advanced MasterSlave mode.'} =
        'Memungkinkan fitur yang tidak di set Master slave dari tiket dalam modus Master Slave canggih.';
    $Self->{Translation}->{'If a note is added by an agent, sets the state of the ticket in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Jika catatan ditambahkan oleh agen, menetapkan keadaan tiket di tiket layar MasterSlave dari tiket yang diperbesar di antarmuka agen.';
    $Self->{Translation}->{'Master / Slave'} = 'Master/Slave';
    $Self->{Translation}->{'Master Tickets'} = 'Tiket Master';
    $Self->{Translation}->{'MasterSlave'} = 'MasterSlave';
    $Self->{Translation}->{'MasterSlave module for Ticket Bulk feature.'} = 'Modul MasterSlave untuk fitur tiket';
    $Self->{Translation}->{'Parameters for the dashboard backend of the master tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.'} =
        'Parameter untuk backend dashboard tiket menguasai gambaran dari antarmuka agen. "Batas" adalah jumlah entri yang ditampilkan secara default. "Grup" digunakan untuk membatasi akses ke plugin (e g Grup: Admin;group1,group2;). "Default" menentukan apakah plugin diaktifkan secara default atau jika pengguna perlu mengaktifkannya secara manual. "CacheTTLLocal" adalah waktu cache di menit untuk plugin.';
    $Self->{Translation}->{'Parameters for the dashboard backend of the slave tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.'} =
        'Parameter untuk backend dashboard tiket budak gambaran dari antarmuka agen. "Batas" adalah jumlah entri yang ditampilkan secara default. "Grup" digunakan untuk membatasi akses ke plugin (e g Grup: Admin;group1,group2;). "Default" menentukan apakah plugin diaktifkan secara default atau jika pengguna perlu mengaktifkannya secara manual. "CacheTTLLocal" adalah waktu cache di menit untuk plugin.';
    $Self->{Translation}->{'Registration of the ticket event module.'} = 'Pendaftaran modul acara tiket.';
    $Self->{Translation}->{'Required permissions to use the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'izin yang diperlukan untuk menggunakan laya tiket MasterSlave dari tiket yang diperbesar di antarmuka agen.';
    $Self->{Translation}->{'Sets if Master / Slave field must be selected by the agent.'} = '';
    $Self->{Translation}->{'Sets the default body text for notes added in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Mengatur teks tubuh default untuk catatan ditambahkan dalam layar tiket Master Slave dari tiket yang diperbesar di antarmuka agen.';
    $Self->{Translation}->{'Sets the default subject for notes added in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Mengatur Teks Tubuh bawaan untuk review Catatan ditambahkan hearts Tiket Layar Slave Dari Tiket Yang diperbesar di Antarmuka agen.';
    $Self->{Translation}->{'Sets the responsible agent of the ticket in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Set agen yang bertanggung jawab dari tiket di layar tiket Master Slave dari tiket yang diperbesar di antarmuka agen.';
    $Self->{Translation}->{'Sets the service in the ticket MasterSlave screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).'} =
        'Set layanan dalam tiket Guru layar Slave dari tiket yang diperbesar di antarmuka agen (Ticket::Service needs to be activated). ';
    $Self->{Translation}->{'Sets the ticket owner in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Menetapkan pemilik tiket di layar tiket Master Slave dari tiket yang diperbesar di antarmuka agen.';
    $Self->{Translation}->{'Sets the ticket type in the ticket MasterSlave screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).'} =
        'Menetapkan jenis tiket di layar tiket Master Slave dari tiket yang diperbesar di antarmuka agen  (Ticket::Type needs to be activated).';
    $Self->{Translation}->{'Shows a link in the menu to change the MasterSlave status of a ticket in the ticket zoom view of the agent interface.'} =
        'Menunjukkan link dalam menu untuk mengubah status Master slave dari tiket dalam tampilan zoom tiket dari antarmuka agen.';
    $Self->{Translation}->{'Shows a list of all the involved agents on this ticket, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Menunjukkan daftar semua agen yang terlibat pada tiket ini, dalam layar tiket Master Slave dari tiket yang diperbesar di antarmuka agen.';
    $Self->{Translation}->{'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Menunjukkan daftar semua agen yang mungkin (semua agen dengan izin catatan di antrian / tiket) untuk menentukan siapa yang harus diberitahu tentang catatan ini, di layar MasterSlave tiket dari tiket yang diperbesar di antarmuka agen.';
    $Self->{Translation}->{'Shows the ticket priority options in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        'Menunjukkan pilihan prioritas tiket di tiket Guru layar Slave dari tiket yang diperbesar di antarmuka agen.';
    $Self->{Translation}->{'Shows the title field in the ticket MasterSlave screen of a zoomed ticket in the agent interface.'} =
        '';
    $Self->{Translation}->{'Slave Tickets'} = 'Tiket slave';
    $Self->{Translation}->{'Specifies the different article communication channels where the real name from Master ticket will be replaced with the one in the Slave ticket.'} =
        '';
    $Self->{Translation}->{'This module activates Master/Slave field in new email and phone ticket screens.'} =
        'Modul ini mengaktifkan bidang Master / Slave di baru layar email dan tiket telepon.';
    $Self->{Translation}->{'This setting is deprecated and will be removed in further versions of OTRSMasterSlave.'} =
        '';
    $Self->{Translation}->{'Ticket MasterSlave.'} = 'Tiket MasterSlave.';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
