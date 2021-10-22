# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package var::packagesetup::SysconfigForceRebuild;

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

	$Self->_UpdateConfig();

    return 1;
}

sub CodeUpgrade {
    my ( $Self, %Param ) = @_;

	$Self->_UpdateConfig();

    return 1;
}

sub _UpdateConfig {
    my ( $Self, %Param ) = @_;

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # Enable in-memory cache to improve SysConfig performance, which is normally disabled for commands.
    $CacheObject->Configure(
        CacheInMemory => 1,
    );

    # Get SysConfig object.
    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    if (
        !$SysConfigObject->ConfigurationXML2DB(
            UserID  => 1,
            Force   => 1,
            CleanUp => 1,
        )
        )
    {

        # Disable in memory cache.
        $CacheObject->Configure(
            CacheInMemory => 0,
        );
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Error while rebuilding system configuration.",
        );
    }

    my %DeploymentResult = $SysConfigObject->ConfigurationDeploy(
        Comments    => "Configuration Rebuild",
        AllSettings => 1,
        UserID      => 1,
        Force       => 1,
    );
    if ( !$DeploymentResult{Success} ) {

        # Disable in memory cache.
        $CacheObject->Configure(
            CacheInMemory => 0,
        );

    }

    # Disable in memory cache.
    $CacheObject->Configure(
        CacheInMemory => 0,
    );

    return 1;
}

