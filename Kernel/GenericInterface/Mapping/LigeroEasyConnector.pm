package Kernel::GenericInterface::Mapping::LigeroEasyConnector;

use strict;
use warnings;

use Data::Dumper;


use Kernel::System::VariableCheck qw(IsHashRefWithData IsString IsStringWithData);


our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::GenericInterface::Mapping::Simple - GenericInterface simple data mapping backend

=head1 SYNOPSIS

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

usually, you want to create an instance of this
by using Kernel::GenericInterface::Mapping->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed params
    for my $Needed (qw(DebuggerObject MappingConfig)) {
        if ( !$Param{$Needed} ) {
            return {
                Success      => 0,
                ErrorMessage => "Got no $Needed!"
            };
        }
        $Self->{$Needed} = $Param{$Needed};
    }

    # check mapping config
    if ( !( $Param{MappingConfig} ) ) {
        return $Self->{DebuggerObject}->Error(
            Summary => 'Got no MappingConfig as hash ref with content!',
        );
    }

    # check config - if we have a map config, it has to be a non-empty hash ref
    if (
        defined $Param{MappingConfig}->{Config}
        && !IsHashRefWithData( $Param{MappingConfig}->{Config} )
        )
    {
        return $Self->{DebuggerObject}->Error(
            Summary => 'Got MappingConfig with Data, but Data is no hash ref with content!',
        );
    }

    # check configuration
    my $ConfigCheck = $Self->_ConfigCheck( Config => $Self->{MappingConfig}->{Config} );
    return $ConfigCheck if !$ConfigCheck->{Success};

    return $Self;
}

=item Map()

provides 1:1 and regex mapping for keys and values
also the use of a default for unmapped keys and values is possible

we need the config to be in the following format

    $Self->{MappingConfig}->{Config} = {
        KeyMapExact => {           # optional. key/value pairs for direct replacement
            '{Ticket}->{Queue}'         => '{Ticket}->{QueueID}',
        },
        KeyMapDefault => {         # required. replace keys if the have not been replaced before
            MapType => 'Keep',     # possible values are
                                   # 'Keep' (leave unchanged)
                                   # 'Ignore' (drop key/value pair)
            MapTo => 'new_value',  # only used if 'MapType' is 'MapTo'. then required
        },
        ValueMap => {
            'new_key_name' => {    # optional. Replacement for a specific key
                ValueMapExact => { # optional. key/value pairs for direct replacement
                    'old_value'         => 'new_value',
                    'another_old_value' => 'another_new_value',
                    'maps_to_same_value => 'another_new_value',
                },
                ValueMapRegEx => { # optional. replace keys with value if current key matches regex
                    'Stat(e|us)'  => 'state',
                    '[pP]riority' => 'prio',
                },
            },
        },
        ValueMapDefault => {       # required. replace keys if the have not been replaced before
            MapType => 'Keep',     # possible values are
                                   # 'Keep' (leave unchanged)
                                   # 'Ignore' (drop key/value pair)
                                   # 'MapTo' (use provided value as default)
            MapTo => 'new_value',  # only used if 'MapType' is 'MapTo'. then required
        },
    };

    my $ReturnData = $MappingObject->Map(
        Data => {
            'original_key' => 'original_value',
            'another_key'  => 'next_value',
        },
    );

    my $ReturnData = {
        'changed_key'          => 'changed_value',
        'original_key'         => 'another_changed_value',
        'another_original_key' => 'default_value',
        'default_key'          => 'changed_value',
    };

=cut

sub Map {
    my ( $Self, %Param ) = @_;

    # check data - only accept undef or hash ref
    if ( defined $Param{Data} && ref $Param{Data} ne 'HASH' ) {
        return $Self->{DebuggerObject}->Error(
            Summary => 'Got Data but it is not a hash ref in Mapping Simple backend!'
        );
    }

    # return if data is empty
    if ( !defined $Param{Data} || !%{ $Param{Data} } ) {
        return {
            Success => 1,
            Data    => {},
        };
    }

    # prepare short config variable
    my $Config = $Self->{MappingConfig}->{Config};

    # no config means we just return input data
    if ( !$Config ) {
        return {
            Success => 1,
            Data    => $Param{Data},
        };
    }

    # go through keys for replacement
    my %ReturnData;
    
    # Só teremos duas opções, ou ignora e só mapeia aquilo que for encontrado, ou copia toda a estrutura e vai renomeando
    if($Config->{KeyMapDefault}->{MapType} ne 'Ignore'){
        %ReturnData = %{ $Param{Data} };
    }

    #Trata coringas

    for my $Map (keys %{$Config->{KeyMapExact}}){
        my %Val;
        my $MapVal = $Config->{KeyMapExact}->{$Map};
        my $arrayMark = index($Map,'[*]');
        if($arrayMark > -1){
            my $MapArray = substr $Map, 0, $arrayMark-2;

            my $evalArray = '$Val{ArrayValue} = $Param{Data}->'.$MapArray;

            eval $evalArray;

            my $arrayCount = scalar @{$Val{ArrayValue}};

            for (my $i = 0; $i < $arrayCount; $i++){

                my $newKey = $Map =~ s/\*/$i/r;
                my $newVal = $MapVal =~ s/\*/$i/r;

                $Config->{KeyMapExact}->{$newKey} = $newVal;
                for my $Map1 (keys %{$Config->{ValueMap}->{$Map}}){
                    %{$Config->{ValueMap}->{$newKey}->{$Map1}} = %{$Config->{ValueMap}->{$Map}->{$Map1}}
                }

            }

            delete $Config->{KeyMapExact}->{$Map};
            delete $Config->{ValueMap}->{$Map};
        }
    }

    # Verifica os mapeamentos indicados na configuração
    for my $Map (keys %{$Config->{KeyMapExact}}){
        my %Val;
        my $eval = '$Val{Value} = $Param{Data}->'.$Map;
        # Armazena o valor original da chave
        eval $eval;

        if ($Val{Value}) {
            # @TODO mapeamento dos valores
            # check if we have a value mapping for the specific key
            my $ValueMap = $Config->{ValueMap}->{$Map};

            if ($ValueMap) {
                # first check in exact (1:1) map
                if ( $ValueMap->{ValueMapExact} && $ValueMap->{ValueMapExact}->{$Val{Value}} ) {
                    $Val{Value} = $ValueMap->{ValueMapExact}->{$Val{Value}};
                }

                # if we have no match from exact map, try regex map
                if ( $ValueMap->{ValueMapRegEx} ) {
                    VALUEMAPREGEX:
                    for my $ConfigKey ( sort keys %{ $ValueMap->{ValueMapRegEx} } ) {
                        next VALUEMAPREGEX if $Val{Value} !~ m{ \A $ConfigKey \z }xms;
                        # @TODO: Possivel bug por fazer replace direto na varialve
                        # talvez seja o caso de clonar e preencher com novos valores..
                        $Val{Value} = $ValueMap->{ValueMapRegEx}->{$ConfigKey};
                        next CONFIGKEY;
                    }
                }
            }
            # Renomeia chave (apaga e cria outra na pratica)
            $eval = 'delete $ReturnData'.$Map;
            eval $eval;
            $eval = '$ReturnData'.$Config->{KeyMapExact}->{$Map}.' = $Val{Value}';
            eval $eval;
        }
    }
    
    #my %Hash = %{ $Param{Data} };
    #CONFIGKEY:
    #for my $OldKey ( sort keys %Hash ) {
   
        ## Verifica se é hash. Caso positivo, executa neste nível
        #if(IsHashRefWithData($Param{Data}->{$OldKey})){
            #$Self->{DebuggerObject}->Notice( Summary => '$OldKey is a hash!' );
            #next CONFIGKEY;
        #}
   
        ## check if key is valid
        #if ( !IsStringWithData($OldKey) ) {
            #$Self->{DebuggerObject}->Notice( Summary => 'Got an original key that is not valid!' );
            #next CONFIGKEY;
        #}

        ## map key
        #my $NewKey;

        ## first check in exact (1:1) map
        #if ( $Config->{KeyMapExact} && $Config->{KeyMapExact}->{$OldKey} ) {
            #$NewKey = $Config->{KeyMapExact}->{$OldKey};
        #}

        ## if we have no match from exact map, try regex map
        #if ( !$NewKey && $Config->{KeyMapRegEx} ) {
            #KEYMAPREGEX:
            #for my $ConfigKey ( sort keys %{ $Config->{KeyMapRegEx} } ) {
                #next KEYMAPREGEX if $OldKey !~ m{ \A $ConfigKey \z }xms;
                #if ( $ReturnData{ $Config->{KeyMapRegEx}->{$ConfigKey} } ) {
                    #$Self->{DebuggerObject}->Notice(
                        #Summary =>
                            #"The data key '$Config->{KeyMapRegEx}->{$ConfigKey}' already exists!",
                    #);
                    #next CONFIGKEY;
                #}
                #$NewKey = $Config->{KeyMapRegEx}->{$ConfigKey};
                #last KEYMAPREGEX;
            #}
        #}

        ## if we still have no match, apply default
        #if ( !$NewKey ) {

            ## check map type options
            #if ( $Config->{KeyMapDefault}->{MapType} eq 'Keep' ) {
                #$NewKey = $OldKey;
            #}
            #elsif ( $Config->{KeyMapDefault}->{MapType} eq 'Ignore' ) {
                #next CONFIGKEY;
            #}
            #elsif ( $Config->{KeyMapDefault}->{MapType} eq 'MapTo' ) {

                ## check if we already have a key with the same name
                #if ( $ReturnData{ $Config->{KeyMapDefault}->{MapTo} } ) {
                    #$Self->{DebuggerObject}->Notice(
                        #Summary => "The data key $Config->{KeyMapDefault}->{MapTo} already exists!",
                    #);
                    #next CONFIGKEY;
                #}

                #$NewKey = $Config->{KeyMapDefault}->{MapTo};
            #}
        #}

        ## sanity check - we should have a translated key now
        #if ( !$NewKey ) {
            #return $Self->{DebuggerObject}->Error( Summary => "Could not map data key $NewKey!" );
        #}

        ## map value
        #my $OldValue = $Param{Data}->{$OldKey};

        ## if value is no string, just pass through
        #if ( !IsString($OldValue) ) {
            #$ReturnData{$NewKey} = $OldValue;
            #next CONFIGKEY;
        #}

        ## check if we have a value mapping for the specific key
        #my $ValueMap = $Config->{ValueMap}->{$NewKey};
        #if ($ValueMap) {

            ## first check in exact (1:1) map
            #if ( $ValueMap->{ValueMapExact} && $ValueMap->{ValueMapExact}->{$OldValue} ) {
                #$ReturnData{$NewKey} = $ValueMap->{ValueMapExact}->{$OldValue};
                #next CONFIGKEY;
            #}

            ## if we have no match from exact map, try regex map
            #if ( $ValueMap->{ValueMapRegEx} ) {
                #VALUEMAPREGEX:
                #for my $ConfigKey ( sort keys %{ $ValueMap->{ValueMapRegEx} } ) {
                    #next VALUEMAPREGEX if $OldValue !~ m{ \A $ConfigKey \z }xms;
                    #$ReturnData{$NewKey} = $ValueMap->{ValueMapRegEx}->{$ConfigKey};
                    #next CONFIGKEY;
                #}
            #}
        #}

        ## if we had no mapping, apply default

        ## keep current value
        #if ( $Config->{ValueMapDefault}->{MapType} eq 'Keep' ) {
            #$ReturnData{$NewKey} = $OldValue;
            #next CONFIGKEY;
        #}

        ## map to default value
        #if ( $Config->{ValueMapDefault}->{MapType} eq 'MapTo' ) {
            #$ReturnData{$NewKey} = $Config->{ValueMapDefault}->{MapTo};
            #next CONFIGKEY;
        #}

        ## implicit ignore
        #next CONFIGKEY;
    #}


    ## COMPLEMENTO
    ## MAPEIA AS SUBCHAVES
    #for my $OldKey ( sort keys %ReturnData ) {
      #if ($OldKey =~ /:/){
          #my $ValueR=$ReturnData{$OldKey};
          
          ##if ($OldKey =~ /custom_field/){
            ###se for um campo customizado, a sintaxe é mais simples
            ##my @Levels = split /:/, $OldKey;
            ##push (@{$ReturnData{issue}->{custom_fields}->{item}}, {'field'=>{'id'=>$Levels[1]},'value'=>$ValueR});
          
          ##} else {
              ## Verifica se é um sub campo do Mantis
              ## Separe as subchaves com ":". Por exemplo issue:category irá virar {issue}->{category}
              #my $stringToEval;
              #my @Levels = split /:/, $OldKey;
              #my $nLevels = scalar @Levels;

              #for my $i (0 .. ($nLevels-1)){
                #if($i == 0){
                    #$stringToEval='$ReturnData{'.$Levels[$i].'}';
                #} else {
                    #$stringToEval.='->{'.$Levels[$i].'}';
                #}
              #}
              #$stringToEval.="='$ValueR';";
              #eval $stringToEval;
          ##}

          #delete $ReturnData{$OldKey};
      #}
    #}
# EO COMPLEMENTO


    return {
        Success => 1,
        Data    => \%ReturnData,
    };
}

=begin Internal:

=item _ConfigCheck()

does checks to make sure the config is sane

    my $Return = $MappingObject->_ConfigCheck(
        Config => { # config as defined for Map
            ...
        },
    );

in case of an error

    $Return => {
        Success      => 0,
        ErrorMessage => 'An error occurred',
    };

in case of a success

    $Return = {
        Success => 1,
    };

=cut

sub _ConfigCheck {
    my ( $Self, %Param ) = @_;

    # just return success if config is undefined or empty hashref
    my $Config = $Param{Config};
    if ( !defined $Config ) {
        return {
            Success => 1,
        };
    }
    if ( ref $Config ne 'HASH' ) {
        return $Self->{DebuggerObject}->Error(
            Summary => 'Config is defined but not a hash reference!',
        );
    }
    if ( !IsHashRefWithData($Config) ) {
        return {
            Success => 1,
        };
    }

    # parse config options for validity
    my %OnlyStringConfigTypes = (
        KeyMapExact     => 1,
        KeyMapRegEx     => 1,
        KeyMapDefault   => 1,
        ValueMapDefault => 1,
    );
    my %RequiredConfigTypes = (
        KeyMapDefault   => 1,
        ValueMapDefault => 1,
    );
    CONFIGTYPE:
    for my $ConfigType (qw(KeyMapExact KeyMapRegEx KeyMapDefault ValueMap ValueMapDefault)) {

        # require some types
        if ( !defined $Config->{$ConfigType} ) {
            next CONFIGTYPE if !$RequiredConfigTypes{$ConfigType};
            return $Self->{DebuggerObject}->Error(
                Summary => "Got no $ConfigType, but it is required!",
            );
        }

        # check type definition
        if ( !IsHashRefWithData( $Config->{$ConfigType} ) ) {
            return $Self->{DebuggerObject}->Error(
                Summary => "Got $ConfigType with Data, but Data is no hash ref with content!",
            );
        }

        # check keys and values of these config types
        next CONFIGTYPE if !$OnlyStringConfigTypes{$ConfigType};
        for my $ConfigKey ( sort keys %{ $Config->{$ConfigType} } ) {
            if ( !IsString($ConfigKey) ) {
                return $Self->{DebuggerObject}->Error(
                    Summary => "Got key in $ConfigType which is not a string!",
                );
            }
            if ( !IsString( $Config->{$ConfigType}->{$ConfigKey} ) ) {
                return $Self->{DebuggerObject}->Error(
                    Summary => "Got value for $ConfigKey in $ConfigType which is not a string!",
                );
            }
        }
    }

    # check default configuration in KeyMapDefault and ValueMapDefault
    my %ValidMapTypes = (
        Keep   => 1,
        Ignore => 1,
        MapTo  => 1,
    );
    CONFIGTYPE:
    for my $ConfigType (qw(KeyMapDefault ValueMapDefault)) {

        # require MapType as a string with a valid value
        if (
            !IsStringWithData( $Config->{$ConfigType}->{MapType} )
            || !$ValidMapTypes{ $Config->{$ConfigType}->{MapType} }
            )
        {
            return $Self->{DebuggerObject}->Error(
                Summary => "Got no valid MapType in $ConfigType!",
            );
        }

        # check MapTo if MapType is set to 'MapTo'
        if (
            $Config->{$ConfigType}->{MapType} eq 'MapTo'
            && !IsStringWithData( $Config->{$ConfigType}->{MapTo} )
            )
        {
            return $Self->{DebuggerObject}->Error(
                Summary => "Got MapType 'MapTo', but MapTo value is not valid in $ConfigType!",
            );
        }
    }

    # check ValueMap
    for my $KeyName ( sort keys %{ $Config->{ValueMap} } ) {

        # require values to be hash ref
        if ( !IsHashRefWithData( $Config->{ValueMap}->{$KeyName} ) ) {
            return $Self->{DebuggerObject}->Error(
                Summary => "Got $KeyName in ValueMap, but it is no hash ref with content!",
            );
        }

        # possible subvalues are ValueMapExact or ValueMapRegEx and need to be hash ref if defined
        SUBKEY:
        for my $SubKeyName (qw(ValueMapExact ValueMapRegEx)) {
            my $ValueMapType = $Config->{ValueMap}->{$KeyName}->{$SubKeyName};
            next SUBKEY if !defined $ValueMapType;
            if ( !IsHashRefWithData($ValueMapType) ) {
                return $Self->{DebuggerObject}->Error(
                    Summary =>
                        "Got $SubKeyName in $KeyName in ValueMap,"
                        . ' but it is no hash ref with content!',
                );
            }

            # key/value pairs of ValueMapExact and ValueMapRegEx must be strings
            for my $ValueMapTypeKey ( sort keys %{$ValueMapType} ) {
                if ( !IsString($ValueMapTypeKey) ) {
                    return $Self->{DebuggerObject}->Error(
                        Summary =>
                            "Got key in $SubKeyName in $KeyName in ValueMap which is not a string!",
                    );
                }
                if ( !IsString( $ValueMapType->{$ValueMapTypeKey} ) ) {
                    return $Self->{DebuggerObject}->Error(
                        Summary =>
                            "Got value for $ValueMapTypeKey in $SubKeyName in $KeyName in ValueMap"
                            . ' which is not a string!',
                    );
                }
            }
        }
    }

    # if we arrive here, all checks were ok
    return {
        Success => 1,
    };
}

1;

=end Internal:

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=head1 VERSION

$Revision: 1.24 $ $Date: 2012/11/20 14:28:15 $

=cut
