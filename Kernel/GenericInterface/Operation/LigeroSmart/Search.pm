# --
# Copyright (C) 2019 Complemento https://complemento.net.br
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::GenericInterface::Operation::LigeroSmart::Search;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(IsStringWithData IsHashRefWithData);

use parent qw(
    Kernel::GenericInterface::Operation::Common
    Kernel::System::LigeroSmart
);

our $ObjectManagerDisabled = 1;

=head1 NAME
Kernel::GenericInterface::Operation::LigeroSmart::Search - GenericInterface Ligero Smart Search
=head1 PUBLIC INTERFACE
=head2 new()
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

=head2 Run()
Search under Elastic Search Portal Links.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    if ( !IsHashRefWithData( $Param{Data} ) ) {

        return $Self->ReturnError(
            ErrorCode    => 'LigeroSmartSearch.MissingParameter',
            ErrorMessage => "LigeroSmartSearch: The request is empty!",
        );
    }

    if ( !$Param{Data}->{params}->{Query} ) {
        return $Self->ReturnError(
            ErrorCode    => 'LigeroSmartSearch.MissingParameter',
            ErrorMessage => "LigeroSmartSearch: Query parameter is missing!",
        );
    }
    if ( !$Param{Data}->{params}->{KBs} ) {
        return $Self->ReturnError(
            ErrorCode    => 'LigeroSmartSearch.MissingParameter',
            ErrorMessage => "LigeroSmartSearch: Knowledge Base (KBs) parameter are missing!",
        );
    }

    my ( $UserID, $UserType ) = $Self->Auth(
        %Param,
    );

    return $Self->ReturnError(
        ErrorCode    => 'LigeroSmartSearch.AuthFail',
        ErrorMessage => "LigeroSmartSearch: Authorization failing!",
    ) if !$UserID;

    delete $Param{Data}->{SessionID};
    delete $Param{Data}->{UserLogin};
    delete $Param{Data}->{Password};

	my $LigeroSmartObject = $Kernel::OM->Get('Kernel::System::LigeroSmart');

    my $Index = $Kernel::OM->Get('Kernel::Config')->Get('LigeroSmart::Index');

    my $Lang = $Param{Data}->{params}->{Language} || '*';
    $Index .= "_".$Lang."_search";

    $Index = lc($Index);

    my %SearchResultsHash = $LigeroSmartObject->SearchTemplate(
        Indexes => $Index,
        Types   => 'portallinks',
        Data    => $Param{Data},
    );

    return {
        Success => 1,
        Data    => \%SearchResultsHash,
    };

}

1;