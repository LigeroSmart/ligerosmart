# --
# Kernel/GenericInterface/Operation/FAQ/PublicCategoryList.pm - GenericInterface FAQ PublicCategoryList operation backend
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Operation::FAQ::PublicCategoryList;

use strict;
use warnings;

use Kernel::System::FAQ;
use Kernel::GenericInterface::Operation::Common;
use Kernel::System::VariableCheck qw(IsArrayRefWithData IsHashRefWithData IsStringWithData);

=head1 NAME

Kernel::GenericInterface::Operation::FAQ::PublicCategoryList - GenericInterface FAQ PublicCategoryList Operation backend

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
        qw(DebuggerObject ConfigObject MainObject LogObject TimeObject DBObject EncodeObject WebserviceID)
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

    # create additional objects
    $Self->{FAQObject}    = Kernel::System::FAQ->new(%Param);
    $Self->{CommonObject} = Kernel::GenericInterface::Operation::Common->new( %{$Self} );

    # set UserID to root because in public interface there is no user
    $Self->{UserID} = 1;

    return $Self;
}

=item Run()

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

    # get all categories with their long names
    my $CategoryTree = $Self->{FAQObject}->GetPublicCategoriesLongNames(
        Valid  => 1,
        Type   => 'rw',
        UserID => $Self->{UserID},
    );

    if ( !IsHashRefWithData($CategoryTree) ) {

        my $ErrorMessage = 'Could not get category data'
            . ' in Kernel::GenericInterface::Operation::FAQ::PublicCategoryList::Run()';

        return $Self->{CommonObject}->ReturnError(
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

    # prepare return data
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

    # return result
    return $ReturnData;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
