# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::ProcessManagement::TransitionAction::CalculateDf;

use strict;
use warnings;
use utf8;
use Safe;

use Kernel::System::VariableCheck qw(:all);

use parent qw(Kernel::System::ProcessManagement::TransitionAction::Base);

our @ObjectDependencies = (
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::ProcessManagement::TransitionAction::DynamicFieldSet - A module to set a new ticket owner

=head1 DESCRIPTION

All DynamicFieldSet functions.

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $DynamicFieldSetObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::TransitionAction::DynamicFieldSet');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 Run()

    Run Data

    my $DynamicFieldSetResult = $DynamicFieldSetActionObject->Run(
        UserID                   => 123,
        Ticket                   => \%Ticket,   # required
        ProcessEntityID          => 'P123',
        ActivityEntityID         => 'A123',
        TransitionEntityID       => 'T123',
        TransitionActionEntityID => 'TA123',
        Config                   => {
            MasterSlave => 'Master',
            Approved    => '1',
            UserID      => 123,                 # optional, to override the UserID from the logged user
        }
    );
    Ticket contains the result of TicketGet including DynamicFields
    Config is the Config Hash stored in a Process::TransitionAction's  Config key

    If a Dynamic Field is named UserID (to avoid conflicts) it must be set in the config as:
    DynamicField_UserID => $Value,

    Returns:

    $DynamicFieldSetResult = 1; # 0

    );

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    

    # define a common message to output in case of any error
    my $CommonMessage = "Process: $Param{ProcessEntityID} Activity: $Param{ActivityEntityID}"
        . " Transition: $Param{TransitionEntityID}"
        . " TransitionAction: $Param{TransitionActionEntityID} - ";

    # check for missing or wrong params
    my $Success = $Self->_CheckParams(
        %Param,
        CommonMessage => $CommonMessage,
    );
    return if !$Success;

    # override UserID if specified as a parameter in the TA config
    $Param{UserID} = $Self->_OverrideUserID(%Param);

    # special case for DyanmicField UserID, convert form DynamicField_UserID to UserID
    if ( defined $Param{Config}->{DynamicField_UserID} ) {
        $Param{Config}->{UserID} = $Param{Config}->{DynamicField_UserID};
        delete $Param{Config}->{DynamicField_UserID};
    }

    # use ticket attributes if needed
    $Self->_ReplaceTicketAttributes(%Param);

    
    
    if(!$Param{Config}->{Calc}){
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $CommonMessage
                . 'Got no Calc',
        );
        return;
    }

    if(!$Param{Config}->{DfResult}){
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $CommonMessage
                . 'Got no DfResult',
        );
        return;
    }

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    my $compartment = new Safe;
    $compartment->share('%Ticket');
    $compartment->share('%Service');

    our %Ticket = $TicketObject->TicketGet(
        TicketID      => $Param{Ticket}->{TicketID},
        DynamicFields => 1,         # Optional, default 0. To include the dynamic field values for this ticket on the return structure.
        UserID        => 1,         # Optional, default 0. To suppress the warning if the ticket does not exist.
    );

    if(!$Ticket{ServiceID}){
        return;
    }

    my $List = $DynamicFieldObject->DynamicFieldListGet(
        ObjectType => 'Service',

    );

    our %Service;

    for my $DfService ( @{$List} ) {

        my $DFConfig = $DynamicFieldObject->DynamicFieldGet(
            ID   => $DfService->{ID},             # ID or Name must be provided
        );

         my $Value = $DynamicFieldBackendObject->ValueGet(
            DynamicFieldConfig => $DFConfig,      # complete config of the DynamicField
            ObjectID           => $Ticket{ServiceID},
        );

        $Service{'DynamicField_'.$DfService->{Name}} = $Value;
    }

    my $DFConfigResult = $DynamicFieldObject->DynamicFieldGet(
        Name   => $Param{Config}->{DfResult},             # ID or Name must be provided
    );

    my $Success = $DynamicFieldBackendObject->ValueSet(
        DynamicFieldConfig	=> $DFConfigResult,
        ObjectID			=> $Param{Ticket}->{TicketID}, 
        Value				=> $compartment->reval($Param{Config}->{Calc}),
        UserID				=> 1,
    );

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut