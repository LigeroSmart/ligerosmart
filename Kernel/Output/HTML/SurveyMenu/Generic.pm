# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::SurveyMenu::Generic;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Group',
    'Kernel::System::Log',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get UserID param
    $Self->{UserID} = $Param{UserID} || die "Got no UserID!";

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Survey} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Survey!',
        );
        return;
    }

    # grant access by default
    my $Access = 1;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get groups
    my $Action   = $Param{Config}->{Action};
    my $GroupsRo = $ConfigObject->Get('Frontend::Module')->{$Action}->{GroupRo} || [];
    my $GroupsRw = $ConfigObject->Get('Frontend::Module')->{$Action}->{Group} || [];

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # check permission
    if ( $Action && ( @{$GroupsRo} || @{$GroupsRw} ) ) {

        # deny access by default, when there are groups to check
        $Access = 0;

        # check read only groups
        ROGROUP:
        for my $GroupRo ( @{$GroupsRo} ) {
            my $HasPermission = $Kernel::OM->Get('Kernel::System::Group')->PermissionCheck(
                UserID    => $Self->{UserID},
                GroupName => $GroupRo,
                Type      => 'ro',
            );

            next ROGROUP if !$HasPermission;

            # set access
            $Access = 1;
            last ROGROUP;
        }

        # check read write groups
        RWGROUP:
        for my $RwGroup ( @{$GroupsRw} ) {

            my $HasPermission = $Kernel::OM->Get('Kernel::System::Group')->PermissionCheck(
                UserID    => $Self->{UserID},
                GroupName => $RwGroup,
                Type      => 'rw',
            );

            next RWGROUP if !$HasPermission;

            # set access
            $Access = 1;
            last RWGROUP;
        }
    }

    return $Param{Counter} if !$Access;

    # output menu item
    $LayoutObject->Block(
        Name => 'MenuItem',
        Data => {
            %Param,
            %{ $Param{Survey} },
            %{ $Param{Config} },
        },
    );

    $Param{Counter}++;

    return $Param{Counter};
}

1;
