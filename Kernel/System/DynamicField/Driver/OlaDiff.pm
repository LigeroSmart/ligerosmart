# --
# Kernel/System/DynamicField/Driver/OlaDiff.pm - Delegate for DynamicField Ola Driver
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::DynamicField::Driver::OlaDiff;

use strict;
use warnings;
use Kernel::System::VariableCheck qw(:all);

use base qw(Kernel::System::DynamicField::Driver::BaseText);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DynamicFieldValue',
    'Kernel::System::Main',
);

=head1 NAME

Kernel::System::DynamicField::Driver::OlaDiff

=head1 SYNOPSIS

DynamicFields OlaDiff Driver delegate

=head1 PUBLIC INTERFACE

This module implements the public interface of L<Kernel::System::DynamicField::Backend>.
Please look there for a detailed reference of the functions.

=over 4

=item new()

usually, you want to create an instance of this
by using Kernel::System::DynamicField::Backend->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # set field behaviors
    $Self->{Behaviors} = {
        'IsACLReducible'               => 0,
        'IsNotificationEventCondition' => 1,
        'IsSortable'                   => 1,
        'IsFiltrable'                  => 0,
        'IsStatsCondition'             => 1,
        'IsCustomerInterfaceCapable'   => 1,
    };

    # get the Dynamic Field Backend custom extensions
    my $DynamicFieldDriverExtensions
        = $Kernel::OM->Get('Kernel::Config')->Get('DynamicFields::Extension::Driver::OlaDiff');

    EXTENSION:
    for my $ExtensionKey ( sort keys %{$DynamicFieldDriverExtensions} ) {

        # skip invalid extensions
        next EXTENSION if !IsHashRefWithData( $DynamicFieldDriverExtensions->{$ExtensionKey} );

        # create a extension config shortcut
        my $Extension = $DynamicFieldDriverExtensions->{$ExtensionKey};

        # check if extension has a new module
        if ( $Extension->{Module} ) {

            # check if module can be loaded
            if (
                !$Kernel::OM->Get('Kernel::System::Main')->RequireBaseClass( $Extension->{Module} )
                )
            {
                die "Can't load dynamic fields backend module"
                    . " $Extension->{Module}! $@";
            }
        }

        # check if extension contains more behaviors
        if ( IsHashRefWithData( $Extension->{Behaviors} ) ) {

            %{ $Self->{Behaviors} } = (
                %{ $Self->{Behaviors} },
                %{ $Extension->{Behaviors} }
            );
        }
    }

    return $Self;
}

sub ValueGet {
    my ( $Self, %Param ) = @_;

    my ($QueueID) = $Param{DynamicFieldConfig}->{Name} =~ /OlaQueue(.*)Diff/sgm;

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

    my $StateFieldName = "OlaQueue".$QueueID."State";
    my $DestinationFieldName = "OlaQueue".$QueueID."Destination";

    my $StateField = $DynamicFieldObject->DynamicFieldGet(
        Name => $StateFieldName,
    );

    my $CurrentOlaState = $Kernel::OM->Get('Kernel::System::DynamicFieldValue')->ValueGet(
        FieldID  => $StateField->{ID},
        ObjectID => $Param{ObjectID},
    );

    return if !$CurrentOlaState->[0]->{ValueText};

    my @RunningStates = ("In Progress","In Progress - Alert","In Progress - Expired");

    my $DFValue = $Kernel::OM->Get('Kernel::System::DynamicFieldValue')->ValueGet(
        FieldID  => $Param{DynamicFieldConfig}->{ID},
        ObjectID => $Param{ObjectID},
    );

    return if !$DFValue;
    return if !IsArrayRefWithData($DFValue);
    return if !IsHashRefWithData( $DFValue->[0] );


    if (
        # If it's not AgentTicketZoom
        ( $ENV{'HTTP_REFERER'} && $ENV{'HTTP_REFERER'} !~ /AgentTicketZoom/ )
        # Or if Env does not contains HTTP_REFERER
        || !$ENV{'HTTP_REFERER'}
        # Or if it'stopped
        || (defined $CurrentOlaState->[0]->{ValueText} && scalar(grep $_ eq $CurrentOlaState->[0]->{ValueText}, @RunningStates) == '0')
        )
    {
        return (sprintf "%.3f", $DFValue->[0]->{ValueText});
    }
    # if it's a running OLA state and it's TicketZoom
    # Recalculate Diff time passing the destination, Queue and TicketID (Used to check SLA Calendar)
    my $DestinationField = $DynamicFieldObject->DynamicFieldGet(
        Name => $DestinationFieldName,
    );

    my $Destination = $Kernel::OM->Get('Kernel::System::DynamicFieldValue')->ValueGet(
        FieldID  => $DestinationField->{ID},
        ObjectID => $Param{ObjectID},
    );

    my $NewDiff = $Kernel::OM->Get('Kernel::System::OLA')->FastDiffAndState(
                                                            TicketID        => $Param{ObjectID},
                                                            Destination     => $Destination->[0]->{ValueDateTime},
                                                            CurrentOlaState => $CurrentOlaState->[0]->{ValueText},
                                                            # PreviousOlaDiff => $DFValue->[0]->{ValueText},
                                                            OlaStateFieldId => $StateField->{ID},
                                                            OlaDiffFieldId  => $Param{DynamicFieldConfig}->{ID},
                                                           );

    return (sprintf "%.3f", $NewDiff);
}

1;

=back

=head1 TERMS AND CONDITIONS

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
