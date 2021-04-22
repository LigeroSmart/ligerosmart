# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package var::packagesetup::OLA;

use strict;
use warnings;

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

    $Self->_SetNewLoaders();
    
    return 1;
}

sub CodeUpgrade {
    my ( $Self, %Param ) = @_;

    $Self->_SetNewLoaders();
	
    return 1;
}

sub CodeUninstall {
    my ( $Self, %Param ) = @_;

    $Self->_RemoveLoaders();
	
    return 1;
}

# Defines the Loaders of this AddOn
sub _GetLoaders {
    my ( $Self, %Param ) = @_;
    
    my %Loaders;
    
    $Loaders{AdminSLA}->{JavaScript} = ['Complemento.OLA.js'];
    $Loaders{AdminSLA}->{CSS}        = ['Complemento.OLA.css'];
    $Loaders{AgentTicketZoom}->{CSS} = ['Complemento.OLAZoom.css'];
    
    return \%Loaders;
}

sub _SetNewLoaders {
    my ( $Self, %Param ) = @_;

    return 1;
}


sub _RemoveLoaders {
    my ( $Self, %Param ) = @_;

    return 1;
}

