# OTRS config file (automatically generated)
# VERSION:1.1
package Kernel::Config::Files::ZZZACL;
use strict;
use warnings;
no warnings 'redefine'; ## no critic
use utf8;
sub Load {
    my ($File, $Self) = @_;

# Created: 2020-12-04 19:32:51 (root@localhost)
# Changed: 2020-12-04 19:32:51 (root@localhost)
# Comment: Checks if Ticket is Classified
$Self->{TicketAcl}->{'A0001 - SmartClassification Check'} = {
  'Possible' => {},
  'PossibleAdd' => {},
  'PossibleNot' => {
    'Action' => [
      'AgentTicketLigeroSmartClassification'
    ]
  },
  'Properties' => {
    'Ticket' => {
      'Type' => [
        '[Not]Unclassified'
      ]
    }
  },
  'PropertiesDatabase' => {},
  'StopAfterMatch' => 0
};

    return;
}
1;
