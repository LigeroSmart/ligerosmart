# --
# Kernel/Language/de_AgentTimeAccounting.pm - the de language for AgentTimeAccounting
# Copyright (C) 2003-2006 OTRS GmbH, http://otrs.com/
# --
# $Id: de_AgentTimeAccounting.pm,v 1.3 2006-12-08 15:07:23 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Language::de_AgentTimeAccounting;

use strict;

sub Data {
    my $Self = shift;

    $Self->{Translation} = { %{$Self->{Translation}},

        # Template: AgentTimeAccounting
        'Setting'        => 'Konfiguration',
        'ProjectSetting' => 'Projektkonfiguration',
    };
}

1;
