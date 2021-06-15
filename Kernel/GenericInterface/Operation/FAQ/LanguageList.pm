# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::GenericInterface::Operation::FAQ::LanguageList;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(IsArrayRefWithData IsHashRefWithData IsStringWithData);

use parent qw(
    Kernel::GenericInterface::Operation::Common
);

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::GenericInterface::Operation::FAQ::LanguageList - GenericInterface FAQ LanguageList Operation backend

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

perform LanguageList Operation. This will return the current FAQ Languages.

    my $Result = $OperationObject->Run(
        Data => {},
    );

    $Result = {
        Success      => 1,                                # 0 or 1
        ErrorMessage => '',                               # In case of an error
        Data         => {                                 # result data payload after Operation
            Language => [
                {
                    ID => 1,
                    Name> 'en',
                },
                {
                    ID => 2,
                    Name> 'OneMoreLanguage',
                },
                # ...
            ],
        },
    };

=cut
=pod
@api {post} /faq/languages Return the list of languages enabled for FAQs.
@apiName Languages
@apiGroup FAQ
@apiVersion 1.0.0

@apiExample Example usge:
  {
  }

@apiErrorExample {json} Error example:
  HTTP/1.1 200 Success
  {
    "Error": {
      "ErrorCode": "LanguageList.AuthFail",
      "ErrorMessage": "LanguageList: Authorization failing!"
    }
  }
@apiSuccessExample {json} Success example:
  HTTP/1.1 200 Success
  {
    "Language": [
      {
        "Name": "en",
        "ID": "1"
      },
      {
        "Name": "de",
        "ID": "2"
      },
      {
        "ID": "3",
        "Name": "pt_BR"
      }
    ]
  }

@apiSuccess {Array} Language Language list array.
=cut
sub Run {
    my ( $Self, %Param ) = @_;

    # Set UserID to root because in public interface there is no user.
    my %Languages = $Kernel::OM->Get('Kernel::System::FAQ')->LanguageList(
        UserID => 1,
    );

    if ( !IsHashRefWithData( \%Languages ) ) {

        my $ErrorMessage = 'Could not get language data'
            . ' in Kernel::GenericInterface::Operation::FAQ::LanguageList::Run()';

        return $Self->ReturnError(
            ErrorCode    => 'TicketList.NotLanguageData',
            ErrorMessage => "TicketList: $ErrorMessage",
        );
    }

    my @LanguageList;
    for my $Key ( sort keys %Languages ) {
        my %Language = (
            ID   => $Key,
            Name => $Languages{$Key},
        );
        push @LanguageList, {%Language};
    }

    return {
        Success => 1,
        Data    => {
            Language => \@LanguageList,
        },
    };
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
