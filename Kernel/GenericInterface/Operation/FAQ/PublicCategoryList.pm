# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::GenericInterface::Operation::FAQ::PublicCategoryList;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(IsArrayRefWithData IsHashRefWithData IsStringWithData);

use parent qw(
    Kernel::GenericInterface::Operation::Common
);

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::GenericInterface::Operation::FAQ::PublicCategoryList - GenericInterface FAQ PublicCategoryList Operation backend

=head1 PUBLIC INTERFACE

=head2 new()

usually, you want to create an instance of this
by using Kernel::GenericInterface::Operation->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    for my $Needed (qw( DebuggerObject WebserviceID )) {
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

perform PublicCategoryList Operation. This will return the current FAQ Categories.

    my $Result = $OperationObject->Run(
        Data => {},
    );

    $Result = {
        Success      => 1,                                # 0 or 1
        ErrorMessage => '',                               # In case of an error
        Data         => {                                 # result data payload after Operation
            Category => [
                {
                    ID => 1,
                    Name> 'Misc',
                },
                {
                    ID => 2,
                    Name> 'OneMoreCategory',
                },
                # ...
            ],
        },
    };

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # Set UserID to root because in public interface there is no user.
    my $CategoryTree = $Kernel::OM->Get('Kernel::System::FAQ')->GetPublicCategoriesLongNames(
        Valid  => 1,
        Type   => 'rw',
        UserID => 1,
    );

    if ( !IsHashRefWithData($CategoryTree) ) {

        my $ErrorMessage = 'Could not get category data'
            . ' in Kernel::GenericInterface::Operation::FAQ::PublicCategoryList::Run()';

        return $Self->ReturnError(
            ErrorCode    => 'PublicCategoryList.NotCategoryData',
            ErrorMessage => "PublicCategoryList: $ErrorMessage",
        );

    }

    my @PublicCategoryList;
    for my $Key ( sort( keys %{$CategoryTree} ) ) {
        my %Category = (
            ID   => $Key,
            Name => $CategoryTree->{$Key},
        );
        push @PublicCategoryList, {%Category};
    }

    # Prepare return data.
    my $ReturnData = {
        Success => 1,
        Data    => {},
    };
    if ( scalar @PublicCategoryList > 1 ) {
        $ReturnData->{Data}->{Category} = \@PublicCategoryList;
    }
    else {
        $ReturnData->{Data}->{Category} = $PublicCategoryList[0];
    }

    return $ReturnData;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
