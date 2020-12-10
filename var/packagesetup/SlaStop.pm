# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package var::packagesetup::SlaStop;

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
    
    $Loaders{AgentTicketZoom}->{JavaScript} = ['Complemento.TicketEscalation.js'];

    return \%Loaders;
}

sub _SetNewLoaders {
    my ( $Self, %Param ) = @_;

	my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    
    my %Loaders = %{$Self->_GetLoaders()};
    
	my $FrontEndValue = $ConfigObject->Get('Frontend::Module'); 
    for my $Module (keys %Loaders){

        for my $LoaderType (keys $Loaders{$Module}){
            if(!exists $FrontEndValue->{$Module}->{Loader}->{$LoaderType}  ){
                # If there is no loader yet
                $FrontEndValue->{$Module}->{"Loader"}->{$LoaderType} = $Loaders{$Module}->{$LoaderType};
            } else {
                # If it's already defined, check if this AddOn Loaders are already loaded
                for my $File (@{$Loaders{$Module}->{$LoaderType}}){
                    if (! grep $_ eq $File, @{$FrontEndValue->{$Module}->{"Loader"}->{$LoaderType}} ) {
                        push($FrontEndValue->{$Module}->{"Loader"}->{$LoaderType},$File);
                    }                    
                }

            }

            my $Success = $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemUpdate(
                Valid => 1,
                Key   => 'Frontend::Module###' . $Module ,
                Value => $FrontEndValue->{$Module},
            ); 
        }
    }

    return 1;
}


sub _RemoveLoaders {
    my ( $Self, %Param ) = @_;

	my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    
    my %Loaders = %{$Self->_GetLoaders()};
    
	my $FrontEndValue = $ConfigObject->Get('Frontend::Module'); 
    for my $Module (keys %Loaders){
        for my $LoaderType (keys $Loaders{$Module}){
            if(exists $FrontEndValue->{$Module}->{Loader}->{$LoaderType}  ){
                # Remove this AddOn loader
                for my $File (@{$Loaders{$Module}->{$LoaderType}}){
                    my $i=0;
                    while ($i <= scalar @{$FrontEndValue->{$Module}->{"Loader"}->{$LoaderType}}){
                        if ($File eq $FrontEndValue->{$Module}->{"Loader"}->{$LoaderType}->[$i] ) {
                            splice $FrontEndValue->{$Module}->{"Loader"}->{$LoaderType}, $i,1;
                        }
                        $i++;
                    }
                }
            }

            my $Success = $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemUpdate(
                Valid => 1,
                Key   => 'Frontend::Module###' . $Module ,
                Value => $FrontEndValue->{$Module},
        
            ); 
        }
    }

    return 1;
}

