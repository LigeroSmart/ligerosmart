# --
# Kernel/GenericInterface/Operation/FAQ/PublicFAQSearch.pm - GenericInterface FAQ PublicFAQSearch operation backend
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Operation::FAQ::PublicFAQSearch;

use strict;
use warnings;

use MIME::Base64;
use Kernel::System::FAQ;
use Kernel::GenericInterface::Operation::Common;
use Kernel::System::VariableCheck qw(IsArrayRefWithData IsHashRefWithData IsStringWithData);

=head1 NAME

Kernel::GenericInterface::Operation::FAQ::PublicFAQSearch - GenericInterface FAQ PublicFAQSearch Operation backend

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

    # get config for frontend
    $Self->{Config} = $Self->{ConfigObject}->Get("FAQ::Frontend::PublicFAQSearch");

    # set default interface settings
    $Self->{Interface} = $Self->{FAQObject}->StateTypeGet(
        Name   => 'public',
        UserID => $Self->{UserID},
    );
    $Self->{InterfaceStates} = $Self->{FAQObject}->StateTypeList(
        Types  => $Self->{ConfigObject}->Get('FAQ::Public::StateTypes'),
        UserID => $Self->{UserID},
    );

    return $Self;
}

=item Run()

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

    # get config data
    # set SearchLimit on 0 because we need to get all entries
    $Self->{SearchLimit} = 0;

    $Self->{SortBy} = $Param{Data}->{OrderBy}
        || $Self->{Config}->{'SortBy::Default'}
        || 'FAQID';

    # the CategoryID param could be an ARRAY an SCALAR or an empty value
    if ( !IsArrayRefWithData( $Self->{SortBy} ) && $Self->{SortBy} ne '' ) {
        $Self->{SortBy} = [ $Self->{SortBy} ];
    }

    $Self->{OrderBy} = $Param{Data}->{OrderByDirection}
        || $Self->{Config}->{'Order::Default'}
        || 'Down';

    # the CategoryID param could be an ARRAY an SCALAR or an empty value
    $Param{Data}->{CategoryIDs} = $Param{Data}->{CategoryIDs} || '';
    if ( !IsArrayRefWithData( $Param{Data}->{CategoryIDs} ) && $Param{Data}->{CategoryIDs} ne '' ) {
        $Self->{CategoryIDs} = [ $Param{Data}->{CategoryIDs} ];
    }
    elsif ( $Param{Data}->{CategoryIDs} ne '' ) {
        $Self->{CategoryIDs} = $Param{Data}->{CategoryIDs};
    }

    # the LanguageID param could be an ARRAY an SCALAR or an empty value
    $Param{Data}->{LanguageIDs} = $Param{Data}->{LanguageIDs} || '';
    if ( !IsArrayRefWithData( $Param{Data}->{LanguageIDs} ) && $Param{Data}->{LanguageIDs} ne '' ) {
        $Self->{LanguageIDs} = [ $Param{Data}->{LanguageIDs} ];
    }
    elsif ( $Param{Data}->{LanguageIDs} ne '' ) {
        $Self->{LanguageIDs} = $Param{Data}->{LanguageIDs};
    }

    # perform FAQ search
    my @ViewableFAQIDs = $Self->{FAQObject}->FAQSearch(
        Number  => $Param{Data}->{Number}  || '',
        Title   => $Param{Data}->{Title}   || '',
        What    => $Param{Data}->{What}    || '',
        Keyword => $Param{Data}->{Keyword} || '',
        LanguageIDs      => $Self->{LanguageIDs},
        CategoryIDs      => $Self->{CategoryIDs},
        OrderBy          => $Self->{SortBy},
        OrderByDirection => [ $Self->{OrderBy} ],
        Limit            => $Self->{SearchLimit},
        UserID           => $Self->{UserID},
        States           => $Self->{InterfaceStates},
        Interface        => $Self->{Interface},
    );
    if ( !IsArrayRefWithData( \@ViewableFAQIDs ) ) {

        my $ErrorMessage = 'Could not get FAQ data'
            . ' in Kernel::GenericInterface::Operation::FAQ::PublicFAQSearch::Run()';

        return $Self->{CommonObject}->ReturnError(
            ErrorCode    => 'PublicFAQSearch.NotFAQData',
            ErrorMessage => "PublicFAQSearch: $ErrorMessage",
        );

    }

    # prepare return data
    my $ReturnData = {
        Data    => {},
        Success => 1,
    };

    # set FAQ entry data
    if ( scalar @ViewableFAQIDs > 1 ) {
        $ReturnData->{Data}->{ID} = \@ViewableFAQIDs;
    }
    else {
        $ReturnData->{Data}->{ID} = $ViewableFAQIDs[0];
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
