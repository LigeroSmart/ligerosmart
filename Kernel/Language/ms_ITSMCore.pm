# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ms_ITSMCore;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAITSMCore
    $Self->{Translation}->{'Alternative to'} = 'Alternatif kepada';
    $Self->{Translation}->{'Availability'} = 'Verfügbarkeit';
    $Self->{Translation}->{'Back End'} = 'Backend';
    $Self->{Translation}->{'Connected to'} = 'Dihungkan kepada';
    $Self->{Translation}->{'Current State'} = 'Status sedia ada';
    $Self->{Translation}->{'Demonstration'} = 'Demostrasi';
    $Self->{Translation}->{'Depends on'} = 'Bergantung kepada';
    $Self->{Translation}->{'End User Service'} = 'Pengguna Akhir Servis';
    $Self->{Translation}->{'Errors'} = 'Kesilapan';
    $Self->{Translation}->{'Front End'} = 'Frontend';
    $Self->{Translation}->{'IT Management'} = 'Pengurusan IT';
    $Self->{Translation}->{'IT Operational'} = 'Operasi IT';
    $Self->{Translation}->{'Impact'} = 'Kesan';
    $Self->{Translation}->{'Incident State'} = 'insiden keadaan';
    $Self->{Translation}->{'Includes'} = 'Termasuk';
    $Self->{Translation}->{'Other'} = 'Selain';
    $Self->{Translation}->{'Part of'} = 'Sebahagian daripada';
    $Self->{Translation}->{'Project'} = 'Projek';
    $Self->{Translation}->{'Recovery Time'} = 'Masa Sembuhan';
    $Self->{Translation}->{'Relevant to'} = 'Berkaitan kepada';
    $Self->{Translation}->{'Reporting'} = 'Melaporkan';
    $Self->{Translation}->{'Required for'} = 'Diperlukan untuk';
    $Self->{Translation}->{'Resolution Rate'} = 'kadar Resolusi';
    $Self->{Translation}->{'Response Time'} = 'Masa Tindak balas';
    $Self->{Translation}->{'SLA Overview'} = 'Lihat semula SLA';
    $Self->{Translation}->{'Service Overview'} = 'Lihat semula servis';
    $Self->{Translation}->{'Service-Area'} = 'Kawasan-Servis';
    $Self->{Translation}->{'Training'} = 'Latihan';
    $Self->{Translation}->{'Transactions'} = 'Transaksi';
    $Self->{Translation}->{'Underpinning Contract'} = 'Underpinning Contract';
    $Self->{Translation}->{'allocation'} = 'Menempatkan semula';

    # Template: AdminITSMCIPAllocate
    $Self->{Translation}->{'Criticality <-> Impact <-> Priority'} = 'Kritikal <-> Kesan <-> Keutamaan';
    $Self->{Translation}->{'Manage the priority result of combinating Criticality <-> Impact.'} =
        'Menguruskan hasil keutamaan kritikal gabungan <-> Kesan.';
    $Self->{Translation}->{'Priority allocation'} = 'Berikan keutamaan';

    # Template: AdminSLA
    $Self->{Translation}->{'Minimum Time Between Incidents'} = 'Masa minima antara incident';

    # Template: AdminService
    $Self->{Translation}->{'Criticality'} = 'Kritikal';

    # Template: AgentITSMSLAZoom
    $Self->{Translation}->{'SLA Information'} = 'SLA-Informasi';
    $Self->{Translation}->{'Last changed'} = 'Kali terakhir diubah';
    $Self->{Translation}->{'Last changed by'} = 'Kali terakhir diubah semasa';
    $Self->{Translation}->{'Associated Services'} = 'Perkhidmatan Bersekutu';

    # Template: AgentITSMServiceZoom
    $Self->{Translation}->{'Service Information'} = 'Informasi Servis';
    $Self->{Translation}->{'Current incident state'} = 'Kejadian keadaan semasa';
    $Self->{Translation}->{'Associated SLAs'} = 'SLA Bersekutu';

    # Perl Module: Kernel/Modules/AgentITSMServicePrint.pm
    $Self->{Translation}->{'Current Incident State'} = 'Insiden status semasa';

}

1;
