# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::ITSMChange::ITSMWorkOrder::Permission::ChangeBuilderCheck;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Group',
    'Kernel::System::ITSMChange',
    'Kernel::System::ITSMChange::ITSMWorkOrder',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::ITSMChange::ITSMWorkOrder::Permission::ChangeBuilderCheck - change builder based permission check

=head1 PUBLIC INTERFACE

=head2 new()

Create an object.

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $CheckObject = $Kernel::OM->Get('Kernel::System::ITSMChange::ITSMWorkOrder::Permission::ChangeBuilderCheck');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 Run()

This method does the check. C<ro> and C<rw> access is granted
when the agent has the C<priv> in the 'itsm-change-builder' group and
when the agent is the change builder of the change.

    my $HasAccess = $CheckObject->Run(
        UserID      => 123,
        Type        => 'rw',     # 'ro' or 'rw'
        WorkOrderID => 4444,
    );

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(UserID Type WorkOrderID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    # the check is based upon the change builder
    my $GroupID = $Kernel::OM->Get('Kernel::System::Group')->GroupLookup(
        Group => 'itsm-change-builder',
    );

    # do not grant access, when the group is not found
    return if !$GroupID;

    # get user groups, where the user has the appropriate privilege
    my %Groups = $Kernel::OM->Get('Kernel::System::Group')->GroupMemberList(
        UserID => $Param{UserID},
        Type   => $Param{Type},
        Result => 'HASH',
    );

    # do not grant access if the agent doesn't have the appropriate type in the appropriate group
    return if !$Groups{$GroupID};

    # there already is a workorder. e.g. AgentITSMWorkOrderEdit
    my $WorkOrder = $Kernel::OM->Get('Kernel::System::ITSMChange::ITSMWorkOrder')->WorkOrderGet(
        UserID      => $Param{UserID},
        WorkOrderID => $Param{WorkOrderID},
    );

    # do not grant access, when no workorder was found
    return if !$WorkOrder || !%{$WorkOrder} || !$WorkOrder->{ChangeID};

    # for checking the change builder, we need information on the change
    my $Change = $Kernel::OM->Get('Kernel::System::ITSMChange')->ChangeGet(
        UserID   => $Param{UserID},
        ChangeID => $WorkOrder->{ChangeID},
    );

    # do not grant access, when no change was found
    return if !$Change || !%{$Change} || !$Change->{ChangeBuilderID};

    # allow access, when the agent is the change builder of the change
    return 1 if $Change->{ChangeBuilderID} == $Param{UserID};

    # do not grant access otherwise
    return;
}

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut

1;
