
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
