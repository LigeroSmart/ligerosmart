# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Ticket::CustomerPermission::TicketDynamicFieldCheck;

use strict;
use warnings;

use Data::Dumper;

our @ObjectDependencies = (
    'Kernel::System::CustomerGroup',
    'Kernel::System::Log',
    'Kernel::System::Queue',
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

    # check if CustomerTicket::EnableDynamicFieldCheck is enabled
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $EnableDynamicFieldCheck = $ConfigObject->Get('CustomerTicket::EnableDynamicFieldCheck');
    return 1 if (!$EnableDynamicFieldCheck);

   # check needed stuff
    for (qw(TicketID UserID Type)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }

    # get ticket data
    my %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
        TicketID      => $Param{TicketID},
        DynamicFields => 1,
    );
    return if !%Ticket;

    # check dynamic field value
    my $DynamicFieldName  = $ConfigObject->Get('CustomerTicket::DynamicFieldNameToCheck');
    my $DynamicFieldValue = $ConfigObject->Get('CustomerTicket::DynamicFieldValueToDenyAccess');
    return 1 if ( $Ticket{"DynamicField_$DynamicFieldName"} !~ m/$DynamicFieldValue/ig );
 
    return;

}

sub GetTicketSearchFilter {

    my ( $Self, %Param ) = @_;

    # check if CustomerTicket::EnableDynamicFieldCheck is enabled
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $EnableDynamicFieldCheck = $ConfigObject->Get('CustomerTicket::EnableDynamicFieldCheck');
    return undef if (!$EnableDynamicFieldCheck);

    my $DynamicFieldName  = $ConfigObject->Get('CustomerTicket::DynamicFieldNameToCheck');
    my $DynamicFieldValue = $ConfigObject->Get('CustomerTicket::DynamicFieldValueToDenyAccess');
    my %DynamicFieldFilter = (
        "DynamicField_$DynamicFieldName" => {
            RawSQL => "%%FIELD%% IS NULL OR %%FIELD%% != '$DynamicFieldValue'"
        }
    );

    return %DynamicFieldFilter;

}

1;
