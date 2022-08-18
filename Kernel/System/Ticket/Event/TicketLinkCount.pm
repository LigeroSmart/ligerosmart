# --
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::Event::TicketLinkCount;

use strict;
use warnings;

use Data::Dumper;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::Log',
    'Kernel::System::Ticket',
    'Kernel::System::LinkObject',
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

    return if ( !$Param{Data}->{Direction} || $Param{Data}->{Direction} ne 'Target' );

    # check needed stuff
    # for my $Needed (qw(Data UserID)) {
    #     if ( !$Param{$Needed} ) {
    #         $Kernel::OM->Get('Kernel::System::Log')->Log(
    #             Priority => 'error',
    #             Message  => "Need $Needed!",
    #         );
    #         return;
    #     }
    # }

    # From Event or Generic Agent
    my $TicketID = $Param{Data}->{TicketID} || $Param{TicketID};

    if ( !$TicketID ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need TicketID",
        );
        return;
    }


    # for my $Needed (qw(DynamicFieldCount DynamicFieldList DynamicFieldListSeparator)) {
    #     if ( !$Param{Config}->{$Needed} ) {
    #         $Kernel::OM->Get('Kernel::System::Log')->Log(
    #             Priority => 'error',
    #             Message  => "Need $Needed! in Config",
    #         );
    #         return;
    #     }
    # }

    # link tickets
    my $Links = $Kernel::OM->Get('Kernel::System::LinkObject')->LinkList(
        Object => 'Ticket',
        Object2 => 'Ticket',
        Key    => $TicketID,
        State  => 'Valid',
        Direction => 'Target',
        UserID => 1,
    );

    my $Count = 0;
    my $Separator = $Param{Config}->{DynamicFieldListSeparator} || $Param{New}->{ParamValue3};
    my $TicketList;

    if ($Links->{Ticket}) {
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        for my $LinkType (keys %{$Links->{Ticket}}){
            for my $Direction (keys %{$Links->{Ticket}->{$LinkType}}){
                for my $TicketID (keys %{$Links->{Ticket}->{$LinkType}->{$Direction}}){
                    $TicketList .= eval "qq($Separator)" if $Count;

                    $Count++;
                    my $TicketNumber = $TicketObject->TicketNumberLookup(
                        TicketID => $TicketID,
                    );

                    $TicketList .= $TicketNumber;
                }
            }
        }
    }
 
    # get dynamic field objects
    my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    my $DynamicFieldConfigCount = $DynamicFieldObject->DynamicFieldGet(
        Name => $Param{Config}->{DynamicFieldCount} || $Param{New}->{ParamValue1},
    );

    my $DynamicFieldConfigList = $DynamicFieldObject->DynamicFieldGet(
        Name => $Param{Config}->{DynamicFieldList} || $Param{New}->{ParamValue2},
    );

    $DynamicFieldBackendObject->ValueSet(
        DynamicFieldConfig => $DynamicFieldConfigCount,
        ObjectID           => $TicketID,
        Value              => $Count || '',
        UserID             => $Param{UserID} || 1,
    );

    $DynamicFieldBackendObject->ValueSet(
        DynamicFieldConfig => $DynamicFieldConfigList,
        ObjectID           => $TicketID,
        Value              => $TicketList || '',
        UserID             => $Param{UserID} || 1,
    );


    return 1;
}

1;