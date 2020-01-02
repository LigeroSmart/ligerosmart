# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::DynamicField::ObjectType::FAQ;

use strict;
use warnings;

use Scalar::Util;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::FAQ',
    'Kernel::System::Log',
    'Kernel::System::Web::Request',
);

=head1 NAME

Kernel::System::DynamicField::ObjectType::FAQ

=head1 DESCRIPTION

FAQ object handler for DynamicFields

=head1 PUBLIC INTERFACE

=head2 new()

usually, you want to create an instance of this
by using Kernel::System::DynamicField::ObjectType::FAQ->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 PostValueSet()

perform specific functions after the Value set for this object type.

    my $Success = $DynamicFieldFAQHandlerObject->PostValueSet(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        ObjectID           => $ObjectID,                # ID of the current object that the field
                                                        # must be linked to, e. g. FAQID
        Value              => $Value,                   # Value to store, depends on backend type
        UserID             => 123,
    );

=cut

sub PostValueSet {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(DynamicFieldConfig ObjectID UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );

            return;
        }
    }

    # check DynamicFieldConfig (general)
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );

        return;
    }

    # check DynamicFieldConfig (internally)
    for my $Needed (qw(ID FieldType ObjectType)) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!"
            );

            return;
        }
    }

    my $FAQObject = $Kernel::OM->Get('Kernel::System::FAQ');

    # history insert
    $FAQObject->FAQHistoryAdd(
        Name   => "DynamicField $Param{DynamicFieldConfig}->{Name} Updated",
        ItemID => $Param{ObjectID},
        UserID => $Param{UserID},
    );

    $FAQObject->_DeleteFromFAQCache( ItemID => $Param{ObjectID} );

    # Trigger event.
    $FAQObject->EventHandler(
        Event => 'FAQDynamicFieldUpdate_' . $Param{DynamicFieldConfig}->{Name},
        Data  => {
            FieldName => $Param{DynamicFieldConfig}->{Name},
            Value     => $Param{Value},
            OldValue  => $Param{OldValue},
            ItemID    => $Param{ObjectID},
            UserID    => $Param{UserID},
        },
        UserID => $Param{UserID},
    );

    return 1;
}

=head2 ObjectDataGet()

retrieves the data of the current object.

    my %ObjectData = $DynamicFieldFAQHandlerObject->ObjectDataGet(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        UserID             => 123,
    );

returns:

    %ObjectData = (
        ObjectID => 123,
        Data     => {
            FAQID             => 32,
            Number            => 100032,
            CategoryID        => '2',
            # ...
        }
    );

=cut

sub ObjectDataGet {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(DynamicFieldConfig UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # Check DynamicFieldConfig (general).
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );
        return;
    }

    # Check DynamicFieldConfig (internally).
    for my $Needed (qw(ID FieldType ObjectType)) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!",
            );
            return;
        }
    }

    my $ItemID = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam(
        Param => 'ItemID',
    );

    return if !$ItemID;

    my %FAQ = $Kernel::OM->Get('Kernel::System::FAQ')->FAQGet(
        ItemID     => $ItemID,
        ItemFields => 1,
        UserID     => $Param{UserID},
    );

    if ( !%FAQ ) {

        return (
            ObjectID => $ItemID,
            Data     => {}
        );
    }

    my %Result = (
        ObjectID => $ItemID,
    );

    ATTRIBUTE:
    for my $Attribute ( sort keys %FAQ ) {

        $Result{Data}->{$Attribute} = $FAQ{$Attribute};
    }

    return %Result;

}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
