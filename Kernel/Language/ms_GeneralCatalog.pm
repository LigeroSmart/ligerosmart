# --
# Kernel/Language/ms_GeneralCatalog.pm - translation file
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ms_GeneralCatalog;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # Template: AAAGeneralCatalog
    $Self->{Translation}->{'Functionality'} = 'Fungsi';

    # Template: AdminGeneralCatalog
    $Self->{Translation}->{'General Catalog Management'} = 'Katalog Pengurusan General';
    $Self->{Translation}->{'Add Catalog Item'} = 'Tambahan Item Katalog';
    $Self->{Translation}->{'Add Catalog Class'} = 'Tambah Kelas Katalog';
    $Self->{Translation}->{'Catalog Class'} = 'Kelas Katalog';

    # SysConfig
    $Self->{Translation}->{'Create and manage the General Catalog.'} = 'Cipta dan urus Katalog General.';
    $Self->{Translation}->{'Frontend module registration for the AdminGeneralCatalog configuration in the admin area.'} =
        '';
    $Self->{Translation}->{'General Catalog'} = 'Katalog General';
    $Self->{Translation}->{'Parameters for the example comment 2 of the general catalog attributes.'} =
        '';
    $Self->{Translation}->{'Parameters for the example permission groups of the general catalog attributes.'} =
        '';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #
    $Self->{Translation}->{'A Catalog Class should have a Name!'} = 'Kelas katalog perlu mempunyai nama!';
    $Self->{Translation}->{'A Catalog Class should have a description!'} = 'Kelas katalog perlu mempunyai penjelasan!';
    $Self->{Translation}->{'Catalog Class is required.'} = 'Kelas katalog adalah diperlukan.';
    $Self->{Translation}->{'Name is required.'} = 'Nama diperlukan.';

}

1;
