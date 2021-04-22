# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Operation::MiscLigero::LinkObject;

use strict;
use warnings;

use Kernel::System::VariableCheck qw( :all );

use base qw(
    Kernel::GenericInterface::Operation::Common
);

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::GenericInterface::Operation::TicketLigero::TypeSearch - GenericInterface Queues List

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

    my $LinkObject = $Kernel::OM->Get('Kernel::System::LinkObject');

    return $Self->ReturnError(
        ErrorCode    => 'LinkObject.AuthFail',
        ErrorMessage => "LinkObject: Authorization failing!",
    ) if !$UserID;

    # check needed stuff
    if ( !IsHashRefWithData( $Param{Data} ) ) {

        return $Self->ReturnError(
            ErrorCode    => 'LinkObject.MissingParameter',
            ErrorMessage => "LinkObject: The request is empty!",
        );
    }

    for my $Needed (qw( SourceObject SourceKey TargetObject TargetKey Type )) {
        if ( !$Param{Data}->{$Needed} ) {

            return $Self->ReturnError(
                ErrorCode    => 'LinkObject.MissingParameter',
                ErrorMessage => "LinkObject: $Needed parameter is missing!",
            );
        }
    }

    my $True = $LinkObject->LinkAdd(
        SourceObject => $Param{Data}->{SourceObject},
        SourceKey    => $Param{Data}->{SourceKey},
        TargetObject => $Param{Data}->{TargetObject},
        TargetKey    => $Param{Data}->{TargetKey},
        Type         => $Param{Data}->{Type},
        State        => 'Valid',
        UserID       => $UserID,
    );

    return {
        Success => 1,
        Data => {
            Result => $True
        }
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