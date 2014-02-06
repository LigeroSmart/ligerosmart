# --
# Kernel/System/DynamicField/ObjectType/FAQ.pm - FAQ object handler for DynamicField
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::DynamicField::ObjectType::FAQ;

use strict;
use warnings;

use Scalar::Util;

use Kernel::System::VariableCheck qw(:all);
use Kernel::System::FAQ;

=head1 NAME

Kernel::System::DynamicField::ObjectType::FAQ

=head1 SYNOPSIS

FAQ object handler for DynamicFields

=head1 PUBLIC INTERFACE

=over 4

=item new()

usually, you want to create an instance of this
by using Kernel::System::DynamicField::ObjectType::FAQ->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for my $Needed (
        qw(ConfigObject EncodeObject LogObject MainObject DBObject TimeObject)
        )
    {
        die "Got no $Needed!" if !$Param{$Needed};

        $Self->{$Needed} = $Param{$Needed};
    }

    # check for FAQObject
    if ( $Param{FAQObject} ) {

        $Self->{FAQObject} = $Param{FAQObject};

        # Make faq object reference weak so it will not count as a reference on objects destroy.
        #   This is because the FAQObject has a Kernel::DynamicField::Backend object, which has this
        #   object, which has a FAQObject again. Without weaken() we'd have a cyclic reference.
        Scalar::Util::weaken( $Self->{FAQObject} );
    }

    return $Self;
}

=item PostValueSet()

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

    # check needed stuff
    for my $Needed (qw(DynamicFieldConfig ObjectID UserID)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # check DynamicFieldConfig (general)
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );
        return;
    }

    # check DynamicFieldConfig (internally)
    for my $Needed (qw(ID FieldType ObjectType)) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!"
            );
            return;
        }
    }

    # check for FAQObject
    if ( !$Self->{FAQObject} ) {

        # create it on demand
        $Self->{FAQObject} = Kernel::System::FAQ->new( %{$Self} );
    }

    # history insert
    $Self->{FAQObject}->FAQHistoryAdd(
        Name   => "DynamicField $Param{DynamicFieldConfig}->{Name} Updated",
        ItemID => $Param{ObjectID},
        UserID => $Param{UserID},
    );

    # clear faq cache
    $Self->{FAQObject}->_DeleteFromFAQCache( ItemID => $Param{ObjectID} );

    # Trigger event.
    $Self->{FAQObject}->EventHandler(
        Event => 'FAQDynamicFieldUpdate_' . $Param{DynamicFieldConfig}->{Name},
        Data  => {
            FieldName => $Param{DynamicFieldConfig}->{Name},
            Value     => $Param{Value},
            ItemID    => $Param{ObjectID},
            UserID    => $Param{UserID},
        },
        UserID => $Param{UserID},
    );

    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
