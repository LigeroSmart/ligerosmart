# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pt_BR_SmsNotify;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # $$START$$

        $Self->{Translation} = {
            %{$Self->{Translation}},
            'Please visit' => 'Por favor, visite',
            "Choose Sms Notify Gateway. If don't see your prefered gateway here, please contact us for a quote. We will be happy to assist you." 
				=> "Escolha um Gateway SMS. Se você não encontrar o seu preferido aqui, entre em contato conosco para uma cotação. Teremos prazer em ajudá-lo.",
        };

    # $$STOP$$
}

1;
