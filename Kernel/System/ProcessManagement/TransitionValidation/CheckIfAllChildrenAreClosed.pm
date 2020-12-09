# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ProcessManagement::TransitionValidation::CheckIfAllChildrenAreClosed;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::ProcessManagement::TransitionValidation::CheckIfAllChildrenAreClosed

=head1 SYNOPSIS

Check if all Children tickets are closed

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $ValidateDemoObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::TransitionValidation::CheckIfAllChildrenAreClosed');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=item Validate()

    Validate Data

    my $ValidateResult = $ValidateModuleObject->Validate(
        Data       => {
            Queue => 'Raw',
            # ...
        },
    );

    Returns:

    $ValidateResult = 1;        # or undef, only returns 1 if ticket has children and if all of them are closed

    );

=cut

sub Validate {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Data)) {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    # Check if we have Data to check against transitions conditions
    if ( !IsHashRefWithData( $Param{Data} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Data has no values!",
        );
        return;
    }

    # linked tickets
    my $Links = $Kernel::OM->Get('Kernel::System::LinkObject')->LinkList(
        Object => 'Ticket',
        Object2 => 'Ticket',
        Key    => $Param{Data}{TicketID},
        State  => 'Valid',
        Type   => 'ParentChild',
        UserID => 1,
    );

    if (    $Links 
         && $Links->{Ticket}
         && $Links->{Ticket}->{ParentChild}
         && $Links->{Ticket}->{ParentChild}->{Target}
       ){
        CHILD:
        for my $ChildID (keys %{$Links->{Ticket}->{ParentChild}->{Target}}){
            my %Child = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
                TicketID      => $ChildID,
                DynamicFields => 0,
                UserID        => 1,
            );
            # Check if any of the children has state values different from what we need
            if (!($Child{StateType} eq 'closed' || $Child{StateType} eq 'merged')) {
                return;
            }
        }
        # Return 1 if all children has the desired state to proceed
        return 1;
    }

    return;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
