# --
# Kernel/Output/HTML/ITSMServiceMenuLink.pm
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::ITSMServiceMenuLink;

use strict;
use warnings;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (
        qw(ConfigObject LogObject DBObject LayoutObject ServiceObject LinkObject UserID)
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Service} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Service!' );
        return;
    }

    # get groups
    my $GroupsRw
        = $Self->{ConfigObject}->Get('Frontend::Module')->{ $Param{Config}->{Action} }->{Group}
        || [];

    # set access
    my $Access = 1;

    # check permission
    if ( $Param{Config}->{Action} && @{$GroupsRw} ) {

        # set access
        $Access = 0;

        # find read write groups
        RWGROUP:
        for my $RwGroup ( @{$GroupsRw} ) {

            next RWGROUP if !$Self->{LayoutObject}->{"UserIsGroup[$RwGroup]"};
            next RWGROUP if $Self->{LayoutObject}->{"UserIsGroup[$RwGroup]"} ne 'Yes';

            # set access
            $Access = 1;
            last RWGROUP;
        }
    }

    return $Param{Counter} if !$Access;

    # check if services can be linked with other objects
    my %PossibleObjects = $Self->{LinkObject}->PossibleObjectsList(
        Object => 'Service',
        UserID => $Self->{UserID},
    );

    # don't show link menu item if there are no linkable objects
    return if !%PossibleObjects;

    $Self->{LayoutObject}->Block(
        Name => 'MenuItem',
        Data => {
            %Param,
            %{ $Param{Service} },
            %{ $Param{Config} },
        },
    );

    $Param{Counter}++;

    return $Param{Counter};
}

1;
