# --
# Copyright (C) 2001-2017 Complemento - Liberdade e Tecnologia, http://www.complemento.net.br
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Invoker::LigeroSmart::LigeroSmartArticleIndexer;

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

    # Check if article index is enabled
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $IndexEnabled = $ConfigObject->Get("LigeroSmart::ArticleIndex::Enabled");
    if ($IndexEnabled == 0) {
        return {
            Success      => 1,
            ErrorMessage => "This web service will run only if LigeroSmart::ArticleIndex::Enabled = 1",
	    DisableLog   => 1
        };
    }

	# Get article data
    my $ArticleID = $Param{Data}->{ArticleID};
    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');
    my $ArticleBackendObject = $ArticleObject->BackendForArticle(
        TicketID  => $Param{Data}->{TicketID},
        ArticleID => $Param{Data}->{ArticleID}
    );
	my %Article = $ArticleBackendObject->ArticleGet(
        TicketID  => $Param{Data}->{TicketID},
        ArticleID => $Param{Data}->{ArticleID},
        DynamicFields => 1
    );

    # remove undefined stuff
    for my $Attribute ( sort keys %Article ) {
        delete $Article{$Attribute} unless defined($Article{$Attribute});
    }

	# Get ticket data
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
	my %Ticket = $TicketObject->TicketGet(
        TicketID => $Param{Data}->{TicketID},
        DynamicFields => 1,
        UserID        => 1
    );
    
    # move AccountedTime to article
    $Article{"AccountedTimeInMinutes"} = $Ticket{"DynamicField_AccountedTimeInMin"};
    $Article{"AccountedTimeInHours"}   = ($Article{"AccountedTimeInMinutes"}/60) if $Article{"AccountedTimeInMinutes"};
    delete $Ticket{"DynamicField_AccountedTimeInMin"};
    delete $Ticket{"DynamicField_AccountedTime"};
    
    # move Service to article
    $Article{"ServiceID"} = $Ticket{"ServiceID"};
    delete $Ticket{"ServiceID"};
    
    # move State to article
    $Article{"State"} = $Ticket{"State"};
    $Article{"StateID"} = $Ticket{"StateID"};
    delete $Ticket{"State"};
    delete $Ticket{"StateID"};
    
    # move Customer to article
    $Article{"CustomerID"} = $Ticket{"CustomerID"};
    $Article{"CustomerUserID"} = $Ticket{"CustomerUserID"};
    delete $Ticket{"CustomerID"};
    delete $Ticket{"CustomerUserID"};
    
    # merge remaining ticket attrs into article
    for my $Attribute ( sort keys %Ticket ) {
    	$Article{"Ticket_$Attribute"} = $Ticket{$Attribute};
    }
    
    $Param{Data}->{Article} = \%Article;

    # Delete some unecessary information
    delete $Param{Data}->{OldTicketData};
    delete $Param{Data}->{TicketID};

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
