package Kernel::System::ProcessManagement::TransitionAction::ForceTransitionCheck;
use strict;
use warnings;
use utf8;
use Kernel::System::VariableCheck qw(:all);
use parent qw(Kernel::System::ProcessManagement::TransitionAction::Base);
use Kernel::System::Ticket::Event::TicketProcessTransitions;
our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::Ticket',
);
sub new {
    my ( $Type, %Param ) = @_;
    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );
    return $Self;
}
sub Run {
    my ( $Self, %Param ) = @_;
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my $CacheKey = '_TicketProcessTransitions::AlreadyProcessed';
    $TicketObject->{$CacheKey}->{ $Param{Ticket}->{TicketID} } = 0;
    my $TransitionEvent = Kernel::System::Ticket::Event::TicketProcessTransitions->new();
    $TransitionEvent->Run(
        Data => {
            TicketID => $Param{Ticket}->{TicketID},
        },
        Event => 'ForceTransition',
        Config => {},
        UserID => 1,
    );
    return 1;
}
1;