# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::CustomerAuth::RESTAPIAuth;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::DateTime',
    'Kernel::System::JSON',
    'Kernel::System::Main',
    'Kernel::System::WebUserAgent',    
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # Debug 0=off 1=on
    $Self->{Debug} = 0;

    $Self->{Count} = $Param{Count} || '';

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');    

    if ( $ConfigObject->Get( 'Customer::AuthModule::RESTAPIAuth::URLRequest' . $Param{Count} ) ) {
        $Self->{URLRequest} = $ConfigObject->Get( 'Customer::AuthModule::RESTAPIAuth::URLRequest' . $Param{Count} );
    }
    else {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Customer::AuthModule::RESTAPIAuth::URLRequest$Param{Count} in Kernel/Config.pm",
        );
        return;
    }
    if ( $ConfigObject->Get( 'Customer::AuthModule::RESTAPIAuth::TokenRequest' . $Param{Count} ) ) {
        $Self->{TokenRequest} = $ConfigObject->Get( 'Customer::AuthModule::RESTAPIAuth::TokenRequest' . $Param{Count} );
    }
    else {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Customer::AuthModule::RESTAPIAuth::TokenRequest$Param{Count} in Kernel/Config.pm",
        );
        return;
    }
    if ( $ConfigObject->Get( 'Customer::AuthModule::RESTAPIAuth::HeaderContentTypeRequest' . $Param{Count} ) ) {
        $Self->{HeaderContentTypeRequest} = $ConfigObject->Get( 'Customer::AuthModule::RESTAPIAuth::HeaderContentTypeRequest' . $Param{Count} );
    }
    else {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Customer::AuthModule::RESTAPIAuth::HeaderContentTypeRequest$Param{Count} in Kernel/Config.pm",
        );
        return;
    }
    if ( $ConfigObject->Get( 'Customer::AuthModule::RESTAPIAuth::TypeRequest' . $Param{Count} ) ) {
        $Self->{TypeRequest} = $ConfigObject->Get( 'Customer::AuthModule::RESTAPIAuth::TypeRequest' . $Param{Count} );
    }
    else {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Customer::AuthModule::RESTAPIAuth::TypeRequest$Param{Count} in Kernel/Config.pm",
        );
        return;
    }
    if (
        defined(
            $ConfigObject->Get( 'Customer::AuthModule::RESTAPIAuth::UserTypes' . $Param{Count} )
        )
        )
    {
        $Self->{UserTypes} = $ConfigObject->Get( 'Customer::AuthModule::RESTAPIAuth::UserTypes' . $Param{Count} );
    }
    else {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need CCustomer::AuthModule::RESTAPIAuth::UserTypes$Param{Count} in Kernel/Config.pm",
        );
        return;
    }  

    return $Self;
}

sub GetOption {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{What} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need What!"
        );
        return;
    }

    # module options
    my %Option = (
        PreAuth => 1,
    );

    # return option
    return $Option{ $Param{What} };
}

sub Auth {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(User Pw UserType)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }
    $Param{User}       = $Self->_ConvertTo( $Param{User},       'utf-8' );
    $Param{Pw}         = $Self->_ConvertTo( $Param{Pw},         'utf-8' );
    $Param{UserType}   = $Self->_ConvertTo( $Param{UserType},   'utf-8' );   

    # set trace level
    $Net::SSLeay::trace = 3;

    # print WebUserAgent settings if any
    my $ConfigObject           = $Kernel::OM->Get('Kernel::Config');
    my $Timeout                = $ConfigObject->Get('WebUserAgent::Timeout') || '';
    my $Proxy                  = $ConfigObject->Get('WebUserAgent::Proxy') || '';
    my $DisableSSLVerification = $ConfigObject->Get('WebUserAgent::DisableSSLVerification') || '';

    # remove credentials if any
    if ($Proxy) {
        $Proxy =~ s{\A.+?(http)}{$1};
    }

    # remember the time when the request is sent
    my $TimeStartObject = $Kernel::OM->Create('Kernel::System::DateTime');

    # send request
    my %Response = $Kernel::OM->Get('Kernel::System::WebUserAgent')->Request(
        Type => $Self->{TypeRequest},
        URL  => $Self->{URLRequest},
        Data => {
            token => $Self->{TokenRequest},
            username => $Param{User},
            password => $Param{Pw},
            type => $Param{UserType},
            uf => ""           
        },
        Header => {
            Content_Type  => $Self->{HeaderContentTypeRequest},
        },
    );

    # calculate and print the time spent in the request
    my $TimeEndObject = $Kernel::OM->Create('Kernel::System::DateTime');
    my $TimeDelta     = $TimeEndObject->Delta( DateTimeObject => $TimeStartObject );
    my $TimeDiff      = $TimeDelta->{AbsoluteSeconds};



    # dump the request response
    my $DumpContent = $Kernel::OM->Get('Kernel::System::Main')->Dump(
        $Response{Content},
        'ascii',
    );

    # remove heading and tailing dump output
    $DumpContent =~ s{\$VAR1 [ ] = [ ] (.*)}{$1}msx;
    $DumpContent =~ s{\\'}{}msx;
    $DumpContent =~ s{\';\n\z}{}msx;
    $DumpContent =~ s{(.*)}{[$1]}msx;

    # prepare request data
    my $ResponseData = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
        Data => $DumpContent,
    );

    my $AuthReturn = $ResponseData->[0]->{auth};

    return $Param{User} if $AuthReturn == 1;

    return;
}

sub _ConvertTo {
    my ( $Self, $Text, $Charset ) = @_;

    return if !defined $Text;

    # get encode object
    my $EncodeObject = $Kernel::OM->Get('Kernel::System::Encode');

    if ( !$Charset || !$Self->{DestCharset} ) {
        $EncodeObject->EncodeInput( \$Text );
        return $Text;
    }

    # convert from input charset ($Charset) to directory charset ($Self->{DestCharset})
    return $EncodeObject->Convert(
        Text => $Text,
        From => $Charset,
        To   => $Self->{DestCharset},
    );
}

1;
