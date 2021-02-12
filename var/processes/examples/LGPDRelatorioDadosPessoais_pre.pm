package var::processes::examples::LGPDRelatorioDadosPessoais_pre;
## nofilter(TidyAll::Plugin::OTRS::Perl::PerlCritic)

use strict;
use warnings;
use utf8;

use base qw(var::processes::examples::Base);

our @ObjectDependencies = ();

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my %Response = (
        Success => 1,
    );

    my @Types = (
    );

    for (@Types){
        $Kernel::OM->Get("Kernel::System::Type")->TypeAdd(
            Name    => $_,
            ValidID => 1,
            UserID  => 1,
        );
    }
    
    my @Queues = (
        "DPO",
    );

    for (@Queues){
        $Kernel::OM->Get("Kernel::System::Queue")->QueueAdd(
        Name                => $_,
        ValidID             => 1,
        GroupID             => 1,
        SystemAddressID     => 1,
        SalutationID        => 1,
        SignatureID         => 1,
        Comment             => $_,
        UserID              => 1,
    	);
    }
        
    my @States = (
    );

    for (@States){
        $Kernel::OM->Get("Kernel::System::State")->StateAdd(
        Name    => $_,
        Comment => $_,
        ValidID => 1,
        TypeID  => 2,
        UserID  => 1,
    	);
    }
    
    my @DynamicFields = (
	{
		Name => 'LGPDStatusEnvioDadosPessoais',
		Label => 'Status do Envio dos Dados Pessoais',
		FieldType => 'Dropdown',
		ObjectType => 'Ticket',
		FieldOrder => '97',
		Config => {
			PossibleValues => {
				'Titularidade Confirmada' => 'Titularidade Confirmada',
				'Titularidade Não Reconhecida' => 'Titularidade Não Reconhecida',
				'Em confirmação de titularidade' => 'Em confirmação de titularidade',
			},
	TranslatableValues => '0',
	DefaultValue => 'Em confirmação de titularidade',
	PossibleNone => '0',
		}
	},
    );	
    %Response = $Self->DynamicFieldsAdd(
        DynamicFieldList => \@DynamicFields,
    );

    return %Response;
}

1;
