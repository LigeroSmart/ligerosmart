# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Operation::SessionLigero::SessionCreate;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(IsStringWithData IsHashRefWithData);

use base qw(
    Kernel::GenericInterface::Operation::Common
    Kernel::GenericInterface::Operation::SessionLigero::Common
);

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::GenericInterface::Operation::Ticket::SessionCreate - GenericInterface Session Create Operation backend

=head1 SYNOPSIS

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
    for my $Needed (
        qw(DebuggerObject WebserviceID)
        )
    {
        if ( !$Param{$Needed} ) {

            return {
                Success      => 0,
                ErrorMessage => "Got no $Needed!"
            };
        }

        $Self->{$Needed} = $Param{$Needed};
    }

    return $Self;
}

=item Run()

Retrieve a new session id value.

    my $Result = $OperationObject->Run(
        Data => {
            UserLogin         => 'Agent1',
            CustomerUserLogin => 'Customer1',       # optional, provide UserLogin or CustomerUserLogin
            Password          => 'some password',   # plain text password
        },
    );

    $Result = {
        Success      => 1,                                # 0 or 1
        ErrorMessage => '',                               # In case of an error
        Data         => {
            SessionID => $SessionID,
        },
    };

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !IsHashRefWithData( $Param{Data} ) ) {

        return $Self->ReturnError(
            ErrorCode    => 'SessionCreate.MissingParameter',
            ErrorMessage => "SessionCreate: The request is empty!",
        );
    }

    

    my $SessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');

    if($Param{Data}->{SessionID}){
        my $Ok = $SessionObject->CheckSessionID(
            SessionID => $Param{Data}->{SessionID},
        );
        if($Ok){
            my %Data = $SessionObject->GetSessionIDData(
                SessionID => $Param{Data}->{SessionID},
            );
            return {
                Success => 1,
                Data    => {
                    SessionID => $Param{Data}->{SessionID},
                    Valid => '1',
                    %Data
                },
            };
        }
        elsif(!$Ok && !$Param{Data}->{UserLogin} && !$Param{Data}->{CustomerUserLogin}){
            return {
                Success => 1,
                Data    => {
                    SessionID => $Param{Data}->{SessionID},
                    Valid => '0'
                },
            };
        }
    }

    for my $Needed (qw( Password )) {
        if ( !$Param{Data}->{$Needed} ) {

            return $Self->ReturnError(
                ErrorCode    => 'SessionCreate.MissingParameter',
                ErrorMessage => "SessionCreate: $Needed parameter is missing!",
            );
        }
    }
    
    my %SessionData = $Self->CreateSessionID(
        %Param,
    );

    if ( !$SessionData{"SessionID"} ) {

        return $Self->ReturnError(
            ErrorCode    => 'SessionCreate.AuthFail',
            ErrorMessage => "SessionCreate: Authorization failing!",
        );
    }

    if(!$Param{Data}->{UserLogin} && $Param{Data}->{CustomerUserLogin}){
        return {
            Success => 1,
            Data    => {
                SessionID => $SessionData{"SessionID"},
                UserID => $SessionData{"UserID"},
                CustomerID => $SessionData{"CustomerID"},
            },
        };
    }
    else{
        return {
            Success => 1,
            Data    => {
                SessionID => $SessionData{"SessionID"},
                UserID => $SessionData{"UserID"},
            },
        };
    }
    
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
