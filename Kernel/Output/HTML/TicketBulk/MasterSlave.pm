# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::TicketBulk::MasterSlave;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::MasterSlave',
    'Kernel::System::Ticket',
    'Kernel::System::Web::Request',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get master/slave dynamic field
    $Self->{MasterSlaveDynamicField}    = $ConfigObject->Get('MasterSlave::DynamicField')    || '';
    $Self->{MasterSlaveAdvancedEnabled} = $ConfigObject->Get('MasterSlave::AdvancedEnabled') || 0;

    return $Self;
}

sub Display {
    my ( $Self, %Param ) = @_;

    # if there is no configured dynamic field or if advanced mode is not enable, there is nothing to do
    return if !$Self->{MasterSlaveDynamicField};
    return if !$Self->{MasterSlaveAdvancedEnabled};

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get master slave config
    my $UnsetMasterSlave  = $ConfigObject->Get('MasterSlave::UnsetMasterSlave')  || 0;
    my $UpdateMasterSlave = $ConfigObject->Get('MasterSlave::UpdateMasterSlave') || 0;

    my %Data = (
        Master => 'New Master Ticket',
    );

    if ($UnsetMasterSlave) {
        $Data{UnsetMaster} = 'Unset Master Tickets';
        $Data{UnsetSlave}  = 'Unset Slave Tickets';
    }

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    if ($UpdateMasterSlave) {

        my @TicketIDs = $TicketObject->TicketSearch(
            Result => 'ARRAY',

            # master slave dynamic field
            'DynamicField_' . $Self->{MasterSlaveDynamicField} => {
                Equals => 'Master',
            },

            StateType  => 'Open',
            Limit      => 60,
            UserID     => $Param{UserID},
            Permission => 'ro',
        );

        TICKET:
        for my $TicketID (@TicketIDs) {

            # get each ticket from the search results
            my %Ticket = $TicketObject->TicketGet(
                TicketID => $TicketID
            );
            next TICKET if !%Ticket;

            $Data{"SlaveOf:$Ticket{TicketNumber}"} = "Slave of Ticket#$Ticket{TicketNumber}: $Ticket{Title}";
        }
    }

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $MasterSlaveSelect = $LayoutObject->BuildSelection(
        Data => {
            '' => '-',
            %Data,
        },
        Name        => $Self->{MasterSlaveDynamicField},
        Translation => 0,
        SelectedID  => $Param{ResponsibleID},
    );

    my $MasterTicketStr = $LayoutObject->{LanguageObject}->Translate('MasterTicket');

    # indentation here is on purpose so the HTML will look according to the framework
    my $HTMLString = <<"EOF";
                    <label for=\"$Self->{MasterSlaveDynamicField}\">$MasterTicketStr:</label>
                    <div class="Field">
                        $MasterSlaveSelect
                    </div>
                    <div class="Clear"></div>
EOF

    return $HTMLString;
}

sub Validate {

    return;
}

sub Store {
    my ( $Self, %Param ) = @_;

    # if there is no configured dynamic field or if advanced mode is not enable, there is nothing to do
    return 1 if !$Self->{MasterSlaveDynamicField};
    return 1 if !$Self->{MasterSlaveAdvancedEnabled};

    # get the dynamic field value
    my $MasterSlaveDynamicFieldValue = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam(
        Param => $Self->{MasterSlaveDynamicField}
    ) || '';

    # if there is no value for master slave, there is noting to do
    return 1 if !$MasterSlaveDynamicFieldValue;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get master slave settings
    my $MasterSlaveFollowUpdatedMaster        = $ConfigObject->Get('MasterSlave::FollowUpdatedMaster')        || 0;
    my $MasterSlaveKeepParentChildAfterUnset  = $ConfigObject->Get('MasterSlave::KeepParentChildAfterUnset')  || 0;
    my $MasterSlaveKeepParentChildAfterUpdate = $ConfigObject->Get('MasterSlave::KeepParentChildAfterUpdate') || 0;

    # set master slave field
    $Kernel::OM->Get('Kernel::System::MasterSlave')->MasterSlave(
        MasterSlaveDynamicFieldName           => $Self->{MasterSlaveDynamicField},
        MasterSlaveDynamicFieldValue          => $MasterSlaveDynamicFieldValue,
        TicketID                              => $Param{TicketID},
        UserID                                => $Param{UserID},
        MasterSlaveFollowUpdatedMaster        => $MasterSlaveFollowUpdatedMaster,
        MasterSlaveKeepParentChildAfterUnset  => $MasterSlaveKeepParentChildAfterUnset,
        MasterSlaveKeepParentChildAfterUpdate => $MasterSlaveKeepParentChildAfterUpdate,
    );

    return 1;
}

1;
