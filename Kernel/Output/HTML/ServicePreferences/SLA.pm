# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::ServicePreferences::SLA;

use strict;
use warnings;

use Data::Dumper;

our @ObjectDependencies = (
    'Kernel::System::Web::Request',
    'Kernel::System::Service',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get env
    for ( sort keys %Param ) {
        $Self->{$_} = $Param{$_};
    }

    return $Self;
}

sub Param {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    
    my @Params = ();

    my %SLAs = $Kernel::OM->Get('Kernel::System::SLA')->SLAList(UserID=>1);    

    my @SelectedIDs;
    if( $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam(
            Param => 'ServiceID'
        ) eq 'NEW'){
        # New service screen
            @SelectedIDs = split(',', $Self->{ConfigItem}->{DefaultSLAIDs}) if $Self->{ConfigItem}->{DefaultSLAIDs};
    } else {
        # editing existing service
        for my $ID (keys %SLAs){
            my %SLA = $Kernel::OM->Get('Kernel::System::SLA')->SLAGet(
                SLAID  => $ID,
                UserID => 1,
            );
            # if service is part of this SLA, push into the selected ids
            if ($SLA{ServiceIDs} && grep { $_ eq $Param{ServiceData}->{ServiceID} } @{$SLA{ServiceIDs}}) {
                push @SelectedIDs, $ID;
            }
        }
    }


    
    my $OptionHtml   = $LayoutObject->BuildSelection(
        Data         => \%SLAs,
        SelectedID   => \@SelectedIDs,
        Name         => $Self->{ConfigItem}->{PrefKey},
        Class        => 'Modernize',
        Multiple     => 1,
        PossibleNone => 1,
    );
    
    my $Baselink=$ENV{"Baselink"}||'';
    
    push(
        @Params,
        {
            %Param,
            Name   => $Self->{ConfigItem}->{PrefKey},
            Option => $OptionHtml,
        },
    );

    # For visualization
    return @Params;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my %SLAs = $Kernel::OM->Get('Kernel::System::SLA')->SLAList(UserID=>1);
    my @SelectedIDs;


    for my $Key ( sort keys %{ $Param{GetParam} } ) {
        my @NewSLAs = @{ $Param{GetParam}->{$Key} };

        # Iterate through all SLA's in the system
        for my $ID (keys %SLAs){
            my @ServiceIDs;
            my $Update;
            my %SLA = $Kernel::OM->Get('Kernel::System::SLA')->SLAGet(
                SLAID  => $ID,
                UserID => 1,
            );

            # Check if the sla should have this service in it
            if (grep { $_ eq $ID } @NewSLAs) {
                # If yes, check if it's already there
                # If it's not there, then put it
                if (!$SLA{ServiceIDs} || !grep { $_ == $Param{ServiceData}->{ServiceID} } @{$SLA{ServiceIDs}}) {
                    @ServiceIDs = @{$SLA{ServiceIDs}} if $SLA{ServiceIDs};
                    push @ServiceIDs, $Param{ServiceData}->{ServiceID};
                    $Update=1;
                }
            } else {
                #It shouldn't be there, so check if it is
                # If yes, remove it
                if ($SLA{ServiceIDs} && grep { $_ eq $Param{ServiceData}->{ServiceID} } @{$SLA{ServiceIDs}}) {
                    # Creates an array without the id
                    @ServiceIDs = grep { $_ != $Param{ServiceData}->{ServiceID} } @{$SLA{ServiceIDs}};
                    $Update=1;
                }
            }
            
            if($Update){
                $Kernel::OM->Get('Kernel::System::SLA')->SLAUpdate(
                    %SLA,
                    ServiceIDs => \@ServiceIDs,
                    UserID => $Self->{UserID}
                )
            }



        }
    }
    $Self->{Message} = 'Preferences updated successfully!';
    return 1;
}

sub Error {
    my ( $Self, %Param ) = @_;

    return $Self->{Error} || '';
}

sub Message {
    my ( $Self, %Param ) = @_;

    return $Self->{Message} || '';
}

1;
