# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::sw_GeneralCatalog;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAGeneralCatalog
    $Self->{Translation}->{'Functionality'} = 'Utendaji';

    # Template: AdminGeneralCatalog
    $Self->{Translation}->{'General Catalog Management'} = 'Usimamizi wa katalogi wa ujumla';
    $Self->{Translation}->{'Items in Class'} = '';
    $Self->{Translation}->{'Edit Item'} = '';
    $Self->{Translation}->{'Add Class'} = '';
    $Self->{Translation}->{'Add Item'} = '';
    $Self->{Translation}->{'Add Catalog Item'} = 'Ongeza kipengele ya katalogi';
    $Self->{Translation}->{'Add Catalog Class'} = 'Ongeza tabaka la katalogi';
    $Self->{Translation}->{'Catalog Class'} = 'Tabaka la katalogi';
    $Self->{Translation}->{'Edit Catalog Item'} = '';

    # JS File: ITSM.GeneralCatalog
    $Self->{Translation}->{'Warning incident state can not be set to invalid.'} = '';

    # SysConfig
    $Self->{Translation}->{'Comment 2'} = '';
    $Self->{Translation}->{'Create and manage the General Catalog.'} = 'Tengeneza na simamia Katalogi ya ujumla.';
    $Self->{Translation}->{'Define the general catalog comment 2.'} = '';
    $Self->{Translation}->{'Defines the URL JS Color Picker path.'} = '';
    $Self->{Translation}->{'Frontend module registration for the AdminGeneralCatalog configuration in the admin area.'} =
        'Usajili wa moduli ya mazingira ya mbele kwa usanidi wa katalogi ya ujumla ya msimamizi katika eneo la usimamizi.';
    $Self->{Translation}->{'General Catalog'} = 'Katalogi ya ujumla';
    $Self->{Translation}->{'Parameters for the example comment 2 of the general catalog attributes.'} =
        'Vigezo kwa mfano Maoni 2 ya sifa za katalogi za ujumla.';
    $Self->{Translation}->{'Parameters for the example permission groups of the general catalog attributes.'} =
        'Vigezo kwa mfano ruhusa za vikundi kwa sifa za katalogi za ujumla.';
    $Self->{Translation}->{'Permission Group'} = '';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Cancel',
    'Warning',
    'Warning incident state can not be set to invalid.',
    );

}

1;
