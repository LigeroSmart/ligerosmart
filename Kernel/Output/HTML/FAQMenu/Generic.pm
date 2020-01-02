# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::FAQMenu::Generic;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Log',
    'Kernel::System::Group',
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

    if ( !$Param{FAQItem} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need FAQItem!',
        );
        return;
    }

    # grant access by default
    my $Access = 1;

    # get groups
    my $Action = $Param{Config}->{Action};
    if ( $Action eq 'AgentLinkObject' ) {

        # The Link-link is a special case, as it is not specific to FAQ.
        # As a workaround we hardcore that AgentLinkObject is treated like AgentFAQEdit
        $Action = 'AgentFAQEdit';
    }

    # get configuration settings for the specified action
    my $Config = $Kernel::OM->Get('Kernel::Config')->Get('Frontend::Module')->{$Action};

    my $GroupsRo = $Config->{GroupRo} || [];
    my $GroupsRw = $Config->{Group}   || [];

    # check permission
    if ( $Action && ( @{$GroupsRo} || @{$GroupsRw} ) ) {

        # deny access by default, when there are groups to check
        $Access = 0;
        my $HasPermission;

        # check read only groups
        ROGROUP:
        for my $RoGroup ( @{$GroupsRo} ) {

            $HasPermission = $Kernel::OM->Get('Kernel::System::Group')->PermissionCheck(
                UserID    => $Self->{UserID},
                GroupName => $RoGroup,
                Type      => 'ro',
            );

            next ROGROUP if !$HasPermission;
            next ROGROUP if $HasPermission != 1;

            # set access
            $Access = 1;
            last ROGROUP;
        }

        # check read write groups
        RWGROUP:
        for my $RwGroup ( @{$GroupsRw} ) {

            $HasPermission = $Kernel::OM->Get('Kernel::System::Group')->PermissionCheck(
                UserID    => $Self->{UserID},
                GroupName => $RwGroup,
                Type      => 'rw',
            );

            next RWGROUP if !$HasPermission;
            next RWGROUP if $HasPermission != 1;

            # set access
            $Access = 1;
            last RWGROUP;
        }
    }

    return $Param{Counter} if !$Access;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # output menu item
    $LayoutObject->Block(
        Name => 'MenuItem',
        Data => {
            %Param,
            %{ $Param{FAQItem} },
            %{ $Param{Config} },
        },
    );

    $Param{Counter}++;

    return $Param{Counter};
}

1;
