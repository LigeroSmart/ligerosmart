# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::GenericInterface::LigeroEasyConnectorCommon;

use Data::Dumper;

use utf8;
use Encode qw( encode_utf8 );

use MIME::Base64 qw(encode_base64 decode_base64);
use strict;
use warnings;
use Mail::Address;

use Kernel::System::VariableCheck qw(:all);

sub _LigeroEasyConnectorCall {
    my ( $Self, %Param ) = @_;

    # LigeroEasyConnectorCall
    my @InvokerList;
    if ( defined $Param{Data}->{LigeroEasyConnectorCall} ) {

        # isolate LigeroEasyConnectorCall parameter
        my $LigeroEasyConnectorCall = $Param{Data}->{LigeroEasyConnectorCall};

        # homogenate input to array
        if ( ref $LigeroEasyConnectorCall eq 'HASH' ) {
            push @InvokerList, $LigeroEasyConnectorCall;
        }
        else {
            @InvokerList = @{$LigeroEasyConnectorCall};
        }

        # check InvokerList internal structure
        for my $InvokerItem (@InvokerList) {
            if ( !IsHashRefWithData($InvokerItem) ) {
                return {
                    ErrorCode => 'LigeroEasyConnectorCall.InvalidParameter',
                    ErrorMessage =>
                        "LigeroEasyConnectorCall: parameter is invalid!",
                };
            }
        }
    }
    foreach my $Invoker (@InvokerList) {
        $Self->{DebuggerObject}->Debug(
            Summary => "Data used to call $Invoker->{WebserviceName} - $Invoker->{Invoker}",
            Data    => $Invoker,
        );
        my $WSData = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceGet(
             Name => $Invoker->{WebserviceName}
        );
        my $Result = $Kernel::OM->Get('Kernel::GenericInterface::Requester')->Run(
            WebserviceID => $WSData->{ID},
            Invoker      => $Invoker->{Invoker},
            # Data         => $Invoker->{Data}
            Data         => { InvokerData => $Invoker }
        );
        $Self->{DebuggerObject}->Debug(
            Summary => "Result from $Invoker->{WebserviceName} - $Invoker->{Invoker}",
            Data    => $Result
        );
    }

}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
