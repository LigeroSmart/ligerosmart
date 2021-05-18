# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package var::packagesetup::SmartClassification;

use strict;
use warnings;

use Kernel::Output::Template::Provider;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::DynamicField',
    'Kernel::System::Log',
    'Kernel::System::State',
    'Kernel::System::Stats',
    'Kernel::System::SysConfig',
    'Kernel::System::Type',
    'Kernel::System::Valid',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}


sub CodeInstall {
    my ( $Self, %Param ) = @_;

    $Self->_CreateACLs();

    return 1;
}

sub CodeUpgrade {
    my ( $Self, %Param ) = @_;

    $Self->_CreateACLs();

    return 1;
}

sub _CreateACLs {
    my $ACLObject = $Kernel::OM->Get('Kernel::System::ACL::DB::ACL');

    my $ID = $ACLObject->ACLAdd(
          Name           => 'A0001 - SmartClassification Check',
          Comment        => 'Checks if Ticket is Classified',
          Description    => '',
          StopAfterMatch => 0,
          ConfigMatch    => {
              Properties => {
                  Ticket => {
                      Type => [
                          '[Not]Unclassified'
                      ]
                  }
              }
          },
          ConfigChange   => {
              PossibleNot => {
                  Action => [
                      'AgentTicketLigeroSmartClassification'
                  ]
              }
          }, # optional
          ValidID        => 2, # disabled by default because need configuration
          UserID         => 1,                  # mandatory
    );
        
    my $Location = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/Kernel/Config/Files/ZZZACL.pm';

    my $ACLDump = $ACLObject->ACLDump(
        ResultType => 'FILE',
        Location   => $Location,
        UserID     => 1,
    );

    if ($ACLDump) {
        my $Success = $ACLObject->ACLsNeedSyncReset();
    }

    return 1;
}

