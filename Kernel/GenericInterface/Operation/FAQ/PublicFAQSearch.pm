# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::GenericInterface::Operation::FAQ::PublicFAQSearch;

use strict;
use warnings;

use MIME::Base64;
use Kernel::System::VariableCheck qw(IsArrayRefWithData IsHashRefWithData IsStringWithData);

use parent qw(
    Kernel::GenericInterface::Operation::Common
);

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::GenericInterface::Operation::FAQ::PublicFAQSearch - GenericInterface FAQ PublicFAQSearch Operation backend

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

perform PublicFAQSearch Operation. This will return a list of public FAQ entries.

    my @IDs = $OperationObject->Run(
        Data => {

            Number    => '*134*',                                         # (optional)
            Title     => '*some title*',                                  # (optional)

            # is searching in Number, Title, Keyword and Field1-6
            What      => '*some text*',                                   # (optional)

            Keyword   => '*webserver*',                                   # (optional)
            LanguageIDs => [ 4, 5, 6 ],                                   # (optional)
            CategoryIDs => [ 7, 8, 9 ],                                   # (optional)

            OrderBy => [ 'FAQID', 'Title' ],                              # (optional)

            # Additional information for OrderBy:
            # The OrderByDirection can be specified for each OrderBy attribute.
            # The pairing is made by the array indexes.

            OrderByDirection => 'Down', # (Down | Up)                         # (optional)
            # default: 'Down'
        },
    );

    $Result = {
        Success      => 1,                                # 0 or 1
        ErrorMessage => '',                               # In case of an error
        Data         => {                                 # result data payload after Operation
            ID => [
                32,
                13,
                12,
                9,
                6,
                5,
                4,
                1,
            ],
        },
    };

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # Set SearchLimit on 0 because we need to get all entries.
    my $SearchLimit = 0;

    my $Config = $Kernel::OM->Get('Kernel::Config')->Get("FAQ::Frontend::PublicFAQSearch");

    my $SortBy = $Param{Data}->{OrderBy}
        || $Config->{'SortBy::Default'}
        || 'FAQID';

    # The SortBy param could be an ARRAY an SCALAR or an empty value.
    if ( !IsArrayRefWithData($SortBy) && $SortBy ne '' ) {
        $SortBy = [$SortBy];
    }

    my $OrderBy = $Param{Data}->{OrderByDirection}
        || $Config->{'Order::Default'}
        || 'Down';

    my $CategoryIDs;

    # The CategoryID param could be an ARRAY an SCALAR or an empty value.
    $Param{Data}->{CategoryIDs} = $Param{Data}->{CategoryIDs} || '';
    if ( !IsArrayRefWithData( $Param{Data}->{CategoryIDs} ) && $Param{Data}->{CategoryIDs} ne '' ) {
        $CategoryIDs = [ $Param{Data}->{CategoryIDs} ];
    }
    elsif ( $Param{Data}->{CategoryIDs} ne '' ) {
        $CategoryIDs = $Param{Data}->{CategoryIDs};
    }

    my $LanguageIDs;

    # The LanguageID param could be an ARRAY an SCALAR or an empty value.
    $Param{Data}->{LanguageIDs} = $Param{Data}->{LanguageIDs} || '';
    if ( !IsArrayRefWithData( $Param{Data}->{LanguageIDs} ) && $Param{Data}->{LanguageIDs} ne '' ) {
        $LanguageIDs = [ $Param{Data}->{LanguageIDs} ];
    }
    elsif ( $Param{Data}->{LanguageIDs} ne '' ) {
        $LanguageIDs = $Param{Data}->{LanguageIDs};
    }

    my $FAQObject = $Kernel::OM->Get('Kernel::System::FAQ');

    # Set UserID to root because in public interface there is no user.
    my $UserID = 1;

    # Set default interface settings.
    my $Interface = $FAQObject->StateTypeGet(
        Name   => 'public',
        UserID => $UserID,
    );
    my $InterfaceStates = $FAQObject->StateTypeList(
        Types  => $Kernel::OM->Get('Kernel::Config')->Get('FAQ::Public::StateTypes'),
        UserID => $UserID,
    );

    # Perform FAQ search.
    my @ViewableItemIDs = $FAQObject->FAQSearch(
        Number  => $Param{Data}->{Number}  || '',
        Title   => $Param{Data}->{Title}   || '',
        What    => $Param{Data}->{What}    || '',
        Keyword => $Param{Data}->{Keyword} || '',
        LanguageIDs      => $LanguageIDs,
        CategoryIDs      => $CategoryIDs,
        OrderBy          => $SortBy,
        OrderByDirection => [$OrderBy],
        Limit            => $SearchLimit,
        UserID           => $UserID,
        States           => $InterfaceStates,
        Interface        => $Interface,
    );
    if ( !IsArrayRefWithData( \@ViewableItemIDs ) ) {

        my $ErrorMessage = 'Could not get FAQ data'
            . ' in Kernel::GenericInterface::Operation::FAQ::PublicFAQSearch::Run()';

        return $Self->ReturnError(
            ErrorCode    => 'PublicFAQSearch.NotFAQData',
            ErrorMessage => "PublicFAQSearch: $ErrorMessage",
        );

    }

    # Prepare return data.
    my $ReturnData = {
        Data    => {},
        Success => 1,
    };

    # Set FAQ entry data.
    if ( scalar @ViewableItemIDs > 1 ) {
        $ReturnData->{Data}->{ID} = \@ViewableItemIDs;
    }
    else {
        $ReturnData->{Data}->{ID} = $ViewableItemIDs[0];
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
