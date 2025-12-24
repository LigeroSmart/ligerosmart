
package Kernel::System::Audit;

use strict;
use warnings;

use Kernel::System::DateTime;
use Kernel::System::VariableCheck qw( IsArrayRefWithData IsHashRefWithData );
use Scalar::Util qw(blessed);

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::JSON'
);

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub _SanitizeForJSON {
    my ( $Self, $Data ) = @_;
    
    return $Data if !ref $Data;
    
    # Se for objeto blessed, converte para string
    if ( blessed($Data) ) {
        # Para filehandles de upload, tenta extrair o nome do arquivo
        if ( $Data->isa('CGI::File::Temp') || ref($Data) =~ /File::Temp/ ) {
            return "$Data";  # Retorna o nome do arquivo como string
        }
        return "$Data";  # Força stringificação
    }
    
    # Se for HASH, sanitiza recursivamente
    if ( ref $Data eq 'HASH' ) {
        my %Sanitized;
        for my $Key ( keys %{$Data} ) {
            $Sanitized{$Key} = $Self->_SanitizeForJSON( $Data->{$Key} );
        }
        return \%Sanitized;
    }
    
    # Se for ARRAY, sanitiza recursivamente
    if ( ref $Data eq 'ARRAY' ) {
        my @Sanitized;
        for my $Item ( @{$Data} ) {
            push @Sanitized, $Self->_SanitizeForJSON($Item);
        }
        return \@Sanitized;
    }
    
    # Para referências escalares, dereferencia
    if ( ref $Data eq 'SCALAR' || ref $Data eq 'REF' ) {
        return $Self->_SanitizeForJSON($$Data);
    }
    
    return $Data;
}

sub Store {
    my ( $Self, %Param ) = @_;

    # debug
    #$Kernel::OM->Get('Kernel::System::Log')->Dumper( \%Param );
    #return;

    # sanitize data
    my $SessionID = $Param{SessionID}; delete $Param{SessionID};
    my $Data;
    foreach (sort keys %Param) {
        if ( ref $Param{$_} eq 'ARRAY' ) {
            $Data->{ $_ } = $Param{$_}[0];
        } else {
            $Data->{ $_ } = $Param{$_};
        }
    }

    # ignore incomplete requests
    return if not defined($Data->{Action});
    return if not defined($Data->{Subaction});

    # ignore non admin requests
    return if ($Data->{Action} !~ m/^Admin/g);

    # ignore some modules
    return if ($Data->{Action} =~ m/SelectBox/g);

    # get user data
    my %UserData = $Kernel::OM->Get('Kernel::System::AuthSession')->GetSessionIDData( SessionID => $SessionID );
    return if (!%UserData);

    # json data
    my $Action     = $Data->{Action}; delete $Data->{Action};
    my $SubAction  = $Data->{Subaction}; delete $Data->{Subaction};
    
    # Sanitize data to remove blessed objects before JSON encoding
    $Data = $Self->_SanitizeForJSON($Data);
    
    my $Payload    = $Kernel::OM->Get('Kernel::System::JSON')->Encode(
        Data => $Data,
        SortKeys => 1,
        Pretty => 1
    );

    # create db record
    $Action =~ s/Admin//g;
    $Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => '
            INSERT INTO audit_log (user_id, module, action, payload, create_time)
            VALUES (?, ?, ?, ?, current_timestamp)',
        Bind => [
            \$UserData{UserID},
            \$Action,
            \$SubAction,
            \$Payload
        ]
    );

    return;
}

1;
