# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Operation::TicketLigero::QueueSearch;

use strict;
use warnings;

use Kernel::System::VariableCheck qw( :all );

use base qw(
    Kernel::GenericInterface::Operation::Common
);

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::GenericInterface::Operation::TicketLigero::QueueSearch - GenericInterface Queues List

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

usually, you want to create an instance of this
by using Kernel::GenericInterface::Operation->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (qw(DebuggerObject WebserviceID)) {
        if ( !$Param{$Needed} ) {
            return {
                Success      => 0,
                ErrorMessage => "Got no $Needed!",
            };
        }

        $Self->{$Needed} = $Param{$Needed};
    }

    # get config for this screen
    #$Self->{Config} = $Kernel::OM->Get('Kernel::Config')->Get('GenericInterface::Operation::GeneralCatalogGetValues');

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my ( $UserID, $UserType ) = $Self->Auth(
        %Param,
    );

    return $Self->ReturnError(
        ErrorCode    => 'GeneralCatalogGetValues.AuthFail',
        ErrorMessage => "GeneralCatalogGetValues: Authorization failing!",
    ) if !$UserID;

    my %Data;

    if($Param{Data}->{UserID}){
        %Data = $Kernel::OM->Get('Kernel::System::LigeroAPI')->TicketAcceleratorIndex(
            UserID          => $Param{Data}->{UserID},
            QueueID         => '1',
            ShownQueueIDs   => ['1'],
            JustOpenOrdened => $Param{Data}->{JustOpenTickets}
        );
    } else {
        %Data = $Kernel::OM->Get('Kernel::System::LigeroAPI')->TicketAcceleratorIndex(
            UserID        => 1,
            QueueID       => '1',
            ShownQueueIDs => ['1'],
            JustOpenOrdened => $Param{Data}->{JustOpenOrdened}
        );
    }

    my @values = ();

    if(%Data{Queues}){

        while (my ($key, $value) = each (%Data{Queues})){
            if($value->{QueueID}>0){
                push @values,{
                    Key=>$value->{QueueID},
                    Value=>$value->{Queue},
                    Count=>$value->{Count},
                    Total=>$value->{Total},
                };
            }
            
        }

        #while (my ($key, $value) = each (%Queues)){
        #    push @values,{Key=>$key,Value=>$value};
        #}

        return {
            Success => 1,
            Data    => {
                Items => \@values
            },
        };
    }

    return {
        Success => 1,
        Data    => {},
    };
    
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut