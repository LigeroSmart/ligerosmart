# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::ServicePreferences::DefaultService;

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

    my $Checked='';
    if( $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam(
            Param => 'ServiceID'
        ) eq 'NEW'){
        # New service screen
            $Checked = 'checked' if $Self->{ConfigItem}->{DefaultSelected};
    } else {
        # editing existing service
        
        my @ServiceIDs = $Kernel::OM->Get('Kernel::System::Service')->CustomerUserServiceMemberList(
            CustomerUserLogin => '<DEFAULT>',
            Result            => 'ARRAY',
            DefaultServices   => 1,
        );

        if (@ServiceIDs && grep { $_ eq $Param{ServiceData}->{ServiceID} } @ServiceIDs) {
            $Checked = 'checked';
        }
    }
   
    my $Baselink=$ENV{"Baselink"}||'';
    
    push(
        @Params,
        {
            %Param,
            Name   => $Self->{ConfigItem}->{PrefKey},
            Option =>   '<input name='.$Self->{ConfigItem}->{PrefKey}.
                        ' type="checkbox" '.$Checked.'/>',
        },
    );

    # For visualization
    return @Params;
}

sub Run {
    my ( $Self, %Param ) = @_;

    for my $Key ( sort keys %{ $Param{GetParam} } ) {
        my $Active = 0;
        $Active = 1 if $Param{GetParam}->{$Key}[0];
        $Kernel::OM->Get('Kernel::System::Service')->CustomerUserServiceMemberAdd(
            CustomerUserLogin => '<DEFAULT>',
            ServiceID => $Param{ServiceData}->{ServiceID},
            Active => $Active,
            UserID => $Self->{UserID}
        )
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
