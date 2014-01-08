# --
# Kernel/Output/HTML/ITSMServiceMenuGeneric.pm
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::ITSMServiceMenuGeneric;

use strict;
use warnings;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(ConfigObject LogObject DBObject LayoutObject ServiceObject UserID)) {
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
    my $GroupsRo
        = $Self->{ConfigObject}->Get('Frontend::Module')->{ $Param{Config}->{Action} }->{GroupRo}
        || [];
    my $GroupsRw
        = $Self->{ConfigObject}->Get('Frontend::Module')->{ $Param{Config}->{Action} }->{Group}
        || [];

    # set access
    my $Access = 1;

    # check permission
    if ( $Param{Config}->{Action} && ( @{$GroupsRo} || @{$GroupsRw} ) ) {

        # set access
        $Access = 0;

        # find read only groups
        ROGROUP:
        for my $RoGroup ( @{$GroupsRo} ) {

            next ROGROUP if !$Self->{LayoutObject}->{"UserIsGroupRo[$RoGroup]"};
            next ROGROUP if $Self->{LayoutObject}->{"UserIsGroupRo[$RoGroup]"} ne 'Yes';

            # set access
            $Access = 1;
            last ROGROUP;
        }

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

    # output menu item
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
