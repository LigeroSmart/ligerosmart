# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Invoker::LigeroSmart::ArticleAndAccountedTimeIndexer;

use strict;
use warnings;

use Encode;
use MIME::Base64;
use Kernel::System::VariableCheck qw(IsArrayRefWithData IsHashRefWithData IsStringWithData);

use JSON;		

use Data::Dumper;

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::GenericInterface::Invoker::Test::Test - GenericInterface test Invoker backend

=head1 SYNOPSIS

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

usually, you want to create an instance of this
by using Kernel::GenericInterface::Invoker->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed params
    if ( !$Param{DebuggerObject} ) {
        return {
            Success      => 0,
            ErrorMessage => "Got no DebuggerObject!"
        };
    }

    $Self->{DebuggerObject} = $Param{DebuggerObject};

    return $Self;
}

=item PrepareRequest()

prepare the invocation of the configured remote webservice.
This will just return the data that was passed to the function.

    my $Result = $InvokerObject->PrepareRequest(
        Data => {                               # data payload
            ...
        },
    );

    $Result = {
        Success         => 1,                   # 0 or 1
        ErrorMessage    => '',                  # in case of error
        Data            => {                    # data payload after Invoker
            ...
        },
    };

=cut

sub PrepareRequest {
    my ( $Self, %Param ) = @_;

    if ( $Param{Data}->{ArticleID} ) {
        return {
            Success      => 0,
            ErrorMessage => "This web service should be called only with ArticleID!"
        };
    }
    # Delete some unecessary information
    delete $Param{Data}->{OldTicketData};

    my $ArticleID = $Param{Data}->{ArticleID};
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # get all articles
    my %Article = $TicketObject->ArticleGet(
        ArticleID          => $ArticleID,
        DynamicFields     => 1,
        Extended          => 1,
        UserID            => 1,
    );

    # encode everything and remove undefined stuff
    ATTRIBUTE:
    for my $Attribute ( sort keys %Article ) {
        # $Article{$Attribute} = encode("utf-8", $Article{$Attribute});
        delete $Article{$Attribute} unless defined($Article{$Attribute});
    }
    
    # Get Accounted time
    # $Article{TimeInMinutes} = $TicketObject->ArticleAccountedTimeGet(
    #     ArticleID => $ArticleID,
    # );
    delete $Article{TimeInMinutes} if $Article{TimeInMinutes}==0;
    $Article{TimeInHours} = ($Article{TimeInMinutes}/60) if $Article{TimeInMinutes};

    # Get executor information
    my %CreatedBy = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
        UserID => $Article{CreateBy},
    );

    $Article{Agent} = \%CreatedBy;

    # Force UTF-8
    ## @TODO: Check if it is working right...
    my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');
    my $JSONString = $JSONObject->Encode(
       Data     => \%Article,
    );
    # $JSONString = encode("utf-8", $JSONString);
    my $ArticleUtf8 = $JSONObject->Decode(
       Data => $JSONString,
    );

    $Param{Data}->{Article} = $ArticleUtf8;

    return {
        Success => 1,
        Data    => $Param{Data},
    };
}

=item HandleResponse()

handle response data of the configured remote webservice.
This will just return the data that was passed to the function.

    my $Result = $InvokerObject->HandleResponse(
        ResponseSuccess      => 1,              # success status of the remote webservice
        ResponseErrorMessage => '',             # in case of webservice error
        Data => {                               # data payload
            ...
        },
    );

    $Result = {
        Success         => 1,                   # 0 or 1
        ErrorMessage    => '',                  # in case of error
        Data            => {                    # data payload after Invoker
            ...
        },
    };

=cut

sub HandleResponse {
    my ( $Self, %Param ) = @_;

    # if there was an error in the response, forward it
#    if ( !$Param{ResponseSuccess} ) {
#        return {
#            Success      => 0,
#            ErrorMessage => $Param{ResponseErrorMessage},
#        };
#    }

#    if ( $Param{Data}->{ResponseContent} =~ m{ReSchedule=1} ) {

#        # ResponseContent has URI like params, convert them into a hash
#        my %QueryParams = split /[&=]/, $Param{Data}->{ResponseContent};

#        # unscape URI strings in query parameters
#        for my $Param ( sort keys %QueryParams ) {
#            $QueryParams{$Param} = URI::Escape::uri_unescape( $QueryParams{$Param} );
#        }

#        # fix ExecutrionTime param
#        if ( $QueryParams{ExecutionTime} ) {
#            $QueryParams{ExecutionTime} =~ s{(\d+)\+(\d+)}{$1 $2};
#        }

#        return {
#            Success      => 0,
#            ErrorMessage => 'Re-Scheduling...',
#            Data         => \%QueryParams,
#        };
#    }

    return {
        Success => 1,
        Data    => $Param{Data},
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