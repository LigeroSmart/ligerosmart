package Kernel::GenericInterface::Invoker::Ligero::ArticleSend;

use strict;
use warnings;

use Data::Dumper;

use utf8;
use Encode qw( encode_utf8 );

use MIME::Base64 qw(encode_base64 decode_base64);

use Kernel::System::VariableCheck qw(IsString IsStringWithData);

# prevent 'Used once' warning for Kernel::OM
use Kernel::System::ObjectManager;

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

    # we need a TicketNumber
    if ( !IsStringWithData( $Param{Data}->{ArticleID} ) ) {
        return $Self->{DebuggerObject}->Error( Summary => 'Got no ArticleID' );
    } 

    # Caso seja necessario filtrar por webservice ID
    #my %DebuggerInfo = %{$Self->{DebuggerObject}};
    
    my %ReturnData;
    
    # check Action
    if ( IsStringWithData( $Param{Data}->{Action} ) ) {
        $ReturnData{Action} = $Param{Data}->{Action};
    }


    # check request for system time
    if ( IsStringWithData( $Param{Data}->{GetSystemTime} ) && $Param{Data}->{GetSystemTime} ) {
        $ReturnData{SystemTime} = $Kernel::OM->Get('Kernel::System::Time')->SystemTime();
    }

    ## Pegar usuário e senha de um arquivo de configuração   
    $ReturnData{UserLogin} = $Kernel::OM->Get('Kernel::Config')->Get('OTRSIntegration::UserLogin');
    $ReturnData{Password} = $Kernel::OM->Get('Kernel::Config')->Get('OTRSIntegration::Password');

    my %Article = $Kernel::OM->Get('Kernel::System::Ticket')->ArticleGet(
            ArticleID => $Param{Data}->{ArticleID}, 
            DynamicFields => 1,
            Extended => 1,
            UserID => 1
        );

    # Verificar isso é necessário no ambiente de produção - encode_utf8
    for (keys %Article){
        $Article{$_} = encode_utf8($Article{$_});
    }

    if(!$Article{DynamicField_CustomerTicketID}){
        return $Self->{DebuggerObject}->Error( Summary => 'Not a Integration Ticket' );
    }
        
    # Verificar se este ticket é integrado (se ele possui o campo dinamico )
    $ReturnData{TicketID} = $Article{"DynamicField_CustomerTicketID"};
    $ReturnData{Article} = \%Article;
    
    ## Pegar anexos
    my @Ats;

    my %Attachments = $Kernel::OM->Get('Kernel::System::Ticket')->ArticleAttachmentIndex(ArticleID => $Param{Data}->{ArticleID}, UserID => 1);
    
    for (keys %Attachments){
        my %Attachment = $Kernel::OM->Get('Kernel::System::Ticket')->ArticleAttachment(
            ArticleID => $Param{Data}->{ArticleID},
            FileID    => $_,   # as returned by ArticleAttachmentIndex
            UserID    => 1,
        );
        my %At;
        $At{Content} = encode_base64($Attachment{Content});
        $At{ContentType} = $Attachments{$_}->{ContentType};
        $At{Filename} = $Attachments{$_}->{Filename};
        
        push @Ats, \%At;
    }
    
    $ReturnData{Attachment} = \@Ats;
    
    #$Kernel::OM->Get('Kernel::System::Log')->Log( Priority => 'error', Message => "aaaaaaaaaaaa ".Dumper(%Attachments));
    
    ## para os anexos validos (verificar se devemos retirar os anexos do html do texto do artigo)
        ## montar array de hash com os anexos

    my $EncodeObject = $Kernel::OM->Get("Kernel::System::Encode");

    $EncodeObject->EncodeInput( \%ReturnData );
    
    return {
        Success => 1,
        Data    => \%ReturnData,
    };
}

=item HandleResponse()

handle response data of the configured remote webservice.

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
    if ( !$Param{ResponseSuccess} ) {
        if ( !IsStringWithData( $Param{ResponseErrorMessage} ) ) {

            return $Self->{DebuggerObject}->Error(
                Summary => 'Got response error, but no response error message!',
            );
        }

        return {
            Success      => 0,
            ErrorMessage => $Param{ResponseErrorMessage},
        };
    }

    # we need a TicketNumber
    if ( !IsStringWithData( $Param{Data}->{TicketNumber} ) ) {

        return $Self->{DebuggerObject}->Error( Summary => 'Got no TicketNumber!' );
    }

    # prepare TicketNumber
    my %ReturnData = (
        TicketNumber => $Param{Data}->{TicketNumber},
    );

    # check Action
    if ( IsStringWithData( $Param{Data}->{Action} ) ) {
        if ( $Param{Data}->{Action} !~ m{ \A ( .*? ) Test \z }xms ) {

            return $Self->{DebuggerObject}->Error(
                Summary => 'Got Action but it is not in required format!',
            );
        }
        $ReturnData{Action} = $1;
    }

    return {
        Success => 1,
        Data    => \%ReturnData,
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
