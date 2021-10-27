# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ProcessManagement::TransitionValidation::EvalExpression;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Data::Dumper;

our @ObjectDependencies = (
    'Kernel::System::Log',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

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

    # check if we have Data to check against transitions conditions
    if ( !IsHashRefWithData( $Param{Data} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Data has no values!",
        );
        return;
    }

    #
    # prepare data to be evaluated
    #
    
    # ticket data
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my %Ticket = $TicketObject->TicketGet(
        TicketID       => $Param{Data}{TicketID},
        DynamicFields => 1,
        UserID        => 1
    );

    # linked tickets
    my $Links = $Kernel::OM->Get('Kernel::System::LinkObject')->LinkList(
        Object => 'Ticket',
        Object2 => 'Ticket',
        Key    => $Param{Data}{TicketID},
        State  => 'Valid',
        UserID => 1,
    );
    foreach my $LinkType ( keys %{ $Links->{Ticket} } ) {
        foreach my $LinkDirection( keys %{ $Links->{Ticket}->{$LinkType} } ) {
            $Ticket{Links}{$LinkType}{Total}++;
            $Ticket{Links}{$LinkType}{$LinkDirection}++;
        }
    }

    my $Return = eval $Param{FieldName};
    return $Return;
}

1;
