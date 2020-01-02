# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::id_ITSMCore;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminITSMCIPAllocate
    $Self->{Translation}->{'Criticality ↔ Impact ↔ Priority'} = 'Kritikalitas↔Dampak↔Prioritas';
    $Self->{Translation}->{'Manage the priority result of combinating Criticality ↔ Impact.'} =
        'Mengelola hasil memprioritaskan kombinasi Kritikalitas ↔ Dampak';
    $Self->{Translation}->{'Priority allocation'} = 'Alokasi Prioritas';

    # Template: AdminSLA
    $Self->{Translation}->{'Minimum Time Between Incidents'} = 'Waktu minimal antara insiden';

    # Template: AdminService
    $Self->{Translation}->{'Criticality'} = 'Kritikalitas';

    # Template: AgentITSMSLAZoom
    $Self->{Translation}->{'SLA Information'} = 'Informasi SLA';
    $Self->{Translation}->{'Last changed'} = 'Terakhir diubah';
    $Self->{Translation}->{'Last changed by'} = 'Terakhir dirubah oleh';
    $Self->{Translation}->{'Associated Services'} = 'Layanan yang terkait';

    # Template: AgentITSMServiceZoom
    $Self->{Translation}->{'Service Information'} = 'Informasi Layanan';
    $Self->{Translation}->{'Current incident state'} = 'Status insiden saat ini';
    $Self->{Translation}->{'Associated SLAs'} = 'SLA yang terkait';

    # Perl Module: Kernel/Modules/AdminITSMCIPAllocate.pm
    $Self->{Translation}->{'Impact'} = 'Dampak';

    # Perl Module: Kernel/Modules/AgentITSMSLAPrint.pm
    $Self->{Translation}->{'No SLAID is given!'} = '';
    $Self->{Translation}->{'SLAID %s not found in database!'} = '';
    $Self->{Translation}->{'Calendar Default'} = '';

    # Perl Module: Kernel/Modules/AgentITSMSLAZoom.pm
    $Self->{Translation}->{'operational'} = '';
    $Self->{Translation}->{'warning'} = '';
    $Self->{Translation}->{'incident'} = '';

    # Perl Module: Kernel/Modules/AgentITSMServicePrint.pm
    $Self->{Translation}->{'No ServiceID is given!'} = '';
    $Self->{Translation}->{'ServiceID %s not found in database!'} = '';
    $Self->{Translation}->{'Current Incident State'} = 'Status insiden saat ini';

    # Perl Module: Kernel/Output/HTML/LinkObject/Service.pm
    $Self->{Translation}->{'Incident State'} = 'Status insiden';

    # Database XML Definition: ITSMCore.sopm
    $Self->{Translation}->{'Operational'} = 'operasional';
    $Self->{Translation}->{'Incident'} = 'insiden';
    $Self->{Translation}->{'End User Service'} = 'Layanan pengguna akhir';
    $Self->{Translation}->{'Front End'} = 'Front end';
    $Self->{Translation}->{'Back End'} = 'Back end';
    $Self->{Translation}->{'IT Management'} = 'Pengelola IT';
    $Self->{Translation}->{'Reporting'} = 'Melaporkan';
    $Self->{Translation}->{'IT Operational'} = 'Operasional IT';
    $Self->{Translation}->{'Demonstration'} = 'Demonstrasi';
    $Self->{Translation}->{'Project'} = 'Proyek';
    $Self->{Translation}->{'Underpinning Contract'} = 'Mendasari kontrak';
    $Self->{Translation}->{'Other'} = 'Lain-lain';
    $Self->{Translation}->{'Availability'} = 'Ketersediaan';
    $Self->{Translation}->{'Response Time'} = 'Waktu Merespon';
    $Self->{Translation}->{'Recovery Time'} = 'Waktu Pemulihan';
    $Self->{Translation}->{'Resolution Rate'} = 'Tingkat Resolusi';
    $Self->{Translation}->{'Transactions'} = 'Transaksi';
    $Self->{Translation}->{'Errors'} = 'Kesalahan';

    # SysConfig
    $Self->{Translation}->{'Alternative to'} = 'Alternatif untuk';
    $Self->{Translation}->{'Both'} = 'Kedua-duanya';
    $Self->{Translation}->{'Connected to'} = 'Terhubung ke';
    $Self->{Translation}->{'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js and Core.Agent.LinkObject.js.'} =
        '';
    $Self->{Translation}->{'Define which columns are shown in the linked Services widget (LinkObject::ViewMode = "complex"). Note: Only Service attributes are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.'} =
        '';
    $Self->{Translation}->{'Depends on'} = 'Tergantung kepada';
    $Self->{Translation}->{'Frontend module registration for the AdminITSMCIPAllocate configuration in the admin area.'} =
        'Pendaftaran modul Frontend untuk konfigurasi AdminITSMCIPAllocate pada daerah admin.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLA object in the agent interface.'} =
        'Pendaftaran modul Frontend untuk objek AgentITSMSLA pada antarmuka agen.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLAPrint object in the agent interface.'} =
        'Pendaftaran modul Frontend untuk objek AgentITSMSLAPrint pada antarmuka agen.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLAZoom object in the agent interface.'} =
        'Pendaftaran modul Frontend untuk objek AgentITSMSLAZoom pada antarmuka agen.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMService object in the agent interface.'} =
        'Pendaftaran modul Frontend untuk objek AgentITSMService pada antarmuka agen.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMServicePrint object in the agent interface.'} =
        'Pendaftaran modul Frontend untuk objek AgentITSMServicePrint pada antarmuka agen.';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMServiceZoom object in the agent interface.'} =
        'Pendaftaran modul Frontend untuk objek AgentITSMServiceZoom pada antarmuka agen.';
    $Self->{Translation}->{'ITSM SLA Overview.'} = 'Keseluruhan ITSM SLA';
    $Self->{Translation}->{'ITSM Service Overview.'} = 'Layanan keseluruhan ITSM';
    $Self->{Translation}->{'Incident State Type'} = 'Insiden jenis state';
    $Self->{Translation}->{'Includes'} = 'Termasuk';
    $Self->{Translation}->{'Manage priority matrix.'} = 'Kelola matriks prioritas';
    $Self->{Translation}->{'Manage the criticality - impact - priority matrix.'} = '';
    $Self->{Translation}->{'Module to show the Back menu item in SLA menu.'} = 'Modul untuk menampilkan tautan kembali di menu SLA.';
    $Self->{Translation}->{'Module to show the Back menu item in service menu.'} = 'Modul untuk menampilkan tautan kembali di menu layanan.';
    $Self->{Translation}->{'Module to show the Link menu item in service menu.'} = 'Modul untuk menampilkan tautan link di menu layanan.';
    $Self->{Translation}->{'Module to show the Print menu item in SLA menu.'} = 'Modul untuk menampilkan tautan cetak di menu SLA.';
    $Self->{Translation}->{'Module to show the Print menu item in service menu.'} = 'Modul untuk menampilkan tautan cetak di menu layanan.';
    $Self->{Translation}->{'Parameters for the incident states in the preference view.'} = 'Parameter untuk status insiden di tampilan pilihan.';
    $Self->{Translation}->{'Part of'} = 'Bagian dari';
    $Self->{Translation}->{'Relevant to'} = 'Berhubungan dengan';
    $Self->{Translation}->{'Required for'} = 'Diperlukan untuk';
    $Self->{Translation}->{'SLA Overview'} = 'Gambaran SLA';
    $Self->{Translation}->{'SLA Print.'} = 'SLA Print';
    $Self->{Translation}->{'SLA Zoom.'} = 'Zoom SLA';
    $Self->{Translation}->{'Service Overview'} = 'Gambaran Layanan';
    $Self->{Translation}->{'Service Print.'} = 'Layanan print';
    $Self->{Translation}->{'Service Zoom.'} = 'Layanan Zoom';
    $Self->{Translation}->{'Service-Area'} = 'Daerah-Layanan';
    $Self->{Translation}->{'Set the type and direction of links to be used to calculate the incident state. The key is the name of the link type (as defined in LinkObject::Type), and the value is the direction of the IncidentLinkType that should be followed to calculate the incident state. For example if the IncidentLinkType is set to \'DependsOn\', and the Direction is \'Source\', only \'Depends on\' links will be followed (and not the opposite link \'Required for\') to calculate the incident state. You can add more link types ad directions as you like, e.g. \'Includes\' with the direction \'Target\'. All link types defined in the sysconfig options LinkObject::Type are possible and the direction can be \'Source\', \'Target\', or \'Both\'. IMPORTANT: AFTER YOU MAKE CHANGES TO THIS SYSCONFIG OPTION YOU NEED TO RUN THE CONSOLE COMMAND bin/otrs.Console.pl Admin::ITSM::IncidentState::Recalculate SO THAT ALL INCIDENT STATES WILL BE RECALCULATED BASED ON THE NEW SETTINGS!'} =
        '';
    $Self->{Translation}->{'Source'} = '';
    $Self->{Translation}->{'This setting defines that a \'ITSMChange\' object can be linked with \'Ticket\' objects using the \'Normal\' link type.'} =
        'Pengaturan ini menentukan bahwa objek \'ITSMChange\' dapat di hubungkan dengan objek \'Tiket\' dengan menggunakan tipe tautan \'Normal\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'Normal\' link type.'} =
        'Pengaturan ini menentukan bahwa objek \'ITSMConfigItem\' dapat di hubungkan dengan objek \'FAQ\' dengan menggunakan tipe tautan \'Normal\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'ParentChild\' link type.'} =
        'Pengaturan ini menentukan bahwa objek \'ITSMChange\' dapat di hubungkan dengan objek \'FAQ\' dengan menggunakan tipe tautan \'ParentChild\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'RelevantTo\' link type.'} =
        'Pengaturan ini menentukan bahwa objek \'ITSMConfigItem\' dapat di hubungkan dengan objek \'FAQ\' dengan menggunakan tipe tautan \'RelevantTo\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'AlternativeTo\' link type.'} =
        'Pengaturan ini menentukan bahwa objek \'ITSMConfigItem\' dapat di hubungkan dengan objek \'Service\' dengan menggunakan tipe tautan \'AlternativeTo\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'DependsOn\' link type.'} =
        'Pengaturan ini menentukan bahwa objek \'ITSMConfigItem\' dapat di hubungkan dengan objek \'Service\' dengan menggunakan tipe tautan \'DependsOn\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'RelevantTo\' link type.'} =
        'Pengaturan ini menentukan bahwa objek \'ITSMConfigItem\' dapat di hubungkan dengan objek \'Service\' dengan menggunakan tipe tautan \'RelevantTo\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'AlternativeTo\' link type.'} =
        'Pengaturan ini menentukan bahwa objek \'ITSMConfigItem\' dapat di hubungkan dengan objek \'Ticket\' dengan menggunakan tipe tautan \'AlternativeTo\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'DependsOn\' link type.'} =
        'Pengaturan ini menentukan bahwa objek \'ITSMConfigItem\' dapat di hubungkan dengan objek \'Ticket\' dengan menggunakan tipe tautan \'DependsOn\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'RelevantTo\' link type.'} =
        'Pengaturan ini menentukan bahwa objek \'ITSMConfigItem\' dapat di hubungkan dengan objek \'Ticket\' dengan menggunakan tipe tautan \'RelevantTo\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'AlternativeTo\' link type.'} =
        'Pengaturan ini menentukan bahwa objek \'ITSMConfigItem\' dapat di hubungkan dengan objek \'Ticket\' dengan menggunakan tipe tautan \'AlternativeTo\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'ConnectedTo\' link type.'} =
        'Pengaturan ini menentukan bahwa objek \'ITSMConfigItem\' dapat di hubungkan dengan objek \'ITSMConfigItem\' dengan menggunakan tipe tautan \'ConnectedTo\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'DependsOn\' link type.'} =
        'Pengaturan ini menentukan bahwa objek \'ITSMConfigItem\' dapat di hubungkan dengan objek \'ITSMConfigItem\' dengan menggunakan tipe tautan \'DependOn\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'Includes\' link type.'} =
        'Pengaturan ini menentukan bahwa objek \'ITSMConfigItem\' dapat di hubungkan dengan objek \'ITSMConfigItem\' dengan menggunakan tipe tautan \'Includes\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'RelevantTo\' link type.'} =
        'Pengaturan ini menentukan bahwa objek \'ITSMConfigItem\' dapat di hubungkan dengan objek \'ITSMConfigItem\' dengan menggunakan tipe tautan \'RelevantTo\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'ITSMConfigItem\' objects using the \'DependsOn\' link type.'} =
        'Pengaturan ini menentukan bahwa objek \'ITSMWorkOrder\' dapat di hubungkan dengan objek \'ITSMConfigItem\' dengan menggunakan tipe tautan \'DependsOn\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'ITSMConfigItem\' objects using the \'Normal\' link type.'} =
        'Pengaturan ini menentukan bahwa objek \'ITSMWorkOrder\' dapat di hubungkan dengan objek \'ITSMConfigItem\' dengan menggunakan tipe tautan \'Normal\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Service\' objects using the \'DependsOn\' link type.'} =
        'Pengaturan ini menentukan bahwa objek \'ITSMWorkOrder\' dapat di hubungkan dengan objek \'Service\' dengan menggunakan tipe tautan \'DependsOn\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Service\' objects using the \'Normal\' link type.'} =
        'Pengaturan ini menentukan bahwa objek \'ITSMWorkOrder\' dapat di hubungkan dengan objek \'Service\' dengan menggunakan tipe tautan \'Normal\'.';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Ticket\' objects using the \'Normal\' link type.'} =
        'Pengaturan ini menentukan bahwa objek \'ITSMWorkOrder\' dapat di hubungkan dengan objek \'Ticket\' dengan menggunakan tipe tautan \'Normal\'.';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'Normal\' link type.'} =
        'Pengaturan ini menentukan bahwa objek \'Service\' dapat di hubungkan dengan objek \'FAQ\' dengan menggunakan tipe tautan \'Normal\'.';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'ParentChild\' link type.'} =
        'Pengaturan ini menentukan bahwa objek \'Service\' dapat di hubungkan dengan objek \'FAQ\' dengan menggunakan tipe tautan \'ParentChild\'.';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'RelevantTo\' link type.'} =
        'Pengaturan ini menentukan bahwa objek \'Service\' dapat di hubungkan dengan objek \'FAQ\' dengan menggunakan tipe tautan \'RelevantTo\'.';
    $Self->{Translation}->{'This setting defines the link type \'AlternativeTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Pengaturan ini menentukan tipe tautan \'AlternativeTo\'. Jika nama sumber dan nama target memiliki nilai yang sama, maka hasilnya adalah Tautan Tak berarah. Jika nilainya berbeda, maka hasilnya adalah tautan berarah.';
    $Self->{Translation}->{'This setting defines the link type \'ConnectedTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Pengaturan ini menentukan tipe tautan \'ConnectedTo\'. Jika nama sumber dan nama target memiliki nilai yang sama, maka hasilnya adalah Tautan Tak berarah. Jika nilainya berbeda, maka hasilnya adalah tautan berarah.';
    $Self->{Translation}->{'This setting defines the link type \'DependsOn\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Pengaturan ini menentukan tipe tautan \'DependsOn\'. Jika nama sumber dan nama target memiliki nilai yang sama, maka hasilnya adalah Tautan Tak berarah. Jika nilainya berbeda, maka hasilnya adalah tautan berarah.';
    $Self->{Translation}->{'This setting defines the link type \'Includes\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Pengaturan ini menentukan tipe tautan \'Includes\'. Jika nama sumber dan nama target memiliki nilai yang sama, maka hasilnya adalah Tautan Tak berarah. Jika nilainya berbeda, maka hasilnya adalah tautan berarah.';
    $Self->{Translation}->{'This setting defines the link type \'RelevantTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        'Pengaturan ini menentukan tipe tautan \'RelevantTo\'. Jika nama sumber dan nama target memiliki nilai yang sama, maka hasilnya adalah Tautan Tak berarah. Jika nilainya berbeda, maka hasilnya adalah tautan berarah.';
    $Self->{Translation}->{'Width of ITSM textareas.'} = 'Lebar dari textareas ITSM.';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    );

}

1;
