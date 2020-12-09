# --
# Copyright (C) 2001-2017 Complemento - Liberdade e Tecnologia, http://www.complemento.net.br
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Invoker::LigeroSmart::LigeroSmartIndexer;

use strict;
use warnings;

use Encode;
use MIME::Base64;
use Kernel::System::VariableCheck qw(IsArrayRefWithData IsHashRefWithData IsStringWithData);

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

    # Delete some unecessary information
    delete $Param{Data}->{ArticleID};
    delete $Param{Data}->{OldTicketData};

    my $TicketID = $Param{Data}->{TicketID};
    my $LigeroElasticsearch = $Kernel::OM->Get('Kernel::System::LigeroSmart');

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $Config = $ConfigObject->Get("LigeroSmart::LigeroSearch::Indexer");

    $Param{Data}->{Ticket} = $LigeroElasticsearch->FullTicketGet(
                                                                    TicketID    => $TicketID,
                                                                    Attachments =>  $Config->{SendAttachmentsToES}||'Yes'
                                                                );

	my $Index = 'ticket_'.$Kernel::OM->Get('Kernel::Config')->Get('LigeroSmart::Index');
	$Index .= "_";

	my %QueuePreferences = $Kernel::OM->Get('Kernel::System::Queue')->QueuePreferencesGet(
                QueueID => $Param{Data}->{Ticket}->{QueueID},
                UserID       => '1',
	);
	delete $QueuePreferences{Language} if $QueuePreferences{Language} eq '_Default_';
	$Index .= $QueuePreferences{Language} || $Kernel::OM->Get('Kernel::Config')->Get('DefaultLanguage') || 'en';


	$Index .= "_index";
	$Index = lc($Index);
	
    # WORKAROUND: this way we can set the end of URI with pipeline=attachment without modifying OTRS REST
    $Param{Data}->{pipeline} = 'attachment' ;
    $Param{Data}->{Index} = $Index;

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
