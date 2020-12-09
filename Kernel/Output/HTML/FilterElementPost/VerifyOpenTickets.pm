# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# Copyright (C) 2017-2018 Complemento, http://complemento.net.br/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::FilterElementPost::VerifyOpenTickets;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::FAQ',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $TemplateName = $Param{TemplateFile} || '';

    return 1 if !$TemplateName;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
	my $BackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
    
    my $ServiceID = $ParamObject->GetParam(Param => 'ServiceID') || '';

    my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
        Name   => 'JustOneTicket',             # ID or Name must be provided
    );
    my $JustOneTicket = $BackendObject->ValueGet(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        ObjectID           => $ServiceID,                # ID of the current object that the field
    ) || '';

    $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
        Name   => 'TicketExceededAlert',             # ID or Name must be provided
    );
    my $TicketExceededAlert = $BackendObject->ValueGet(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        ObjectID           => $ServiceID,                # ID of the current object that the field
    ) || 'Não permitida abertura de mais de um chamado do mesmo tipo.';

    $TicketExceededAlert = $LayoutObject->Ascii2RichText(
        String =>$TicketExceededAlert);

    $TicketExceededAlert =~ s/\R//g;

    if($JustOneTicket){
        $LayoutObject->AddJSOnDocumentComplete( Code => <<"END");
            \$('#BottomActionRow').hide();
            \$('#submitRichText').hide();
            var Data = {};
            Data.Action         = 'CustomerServiceCatalog';
            Data.Subaction      = 'VerifyOpenTickets';
            Data.ServiceID      = $ServiceID;
            Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'), Data, function(Result){
                if(Result == 0){
                    \$('#BottomActionRow').show();
                    \$('#submitRichText').show();
                } else {
                    Core.UI.Dialog.ShowDialog({
                        Title: Core.Language.Translate("ALERTA"),
                        HTML:"$TicketExceededAlert",
                        Modal: true,
                        CloseOnClickOutside: false,
                        CloseOnEscape: false,
                        PositionTop: '10px',
                        PositionLeft: 'Center',
                        Buttons: [
                            {
                                Label: Core.Language.Translate('OK'),
                                Function: function () {
                                    window.location = Core.Config.Get('CGIHandle');
                                },
                                Class: 'CallForAction',
                                Type: 'Close',
                            },
                            {
                                Label: Core.Language.Translate('Ver Chamado'),
                                Function: function () {
                                    window.location = Core.Config.Get('CGIHandle')+"?Action=CustomerTicketZoom;TicketID="+Result;
                                },
                                Class: 'CallForAction',
                                Type: 'Submit',
                            }
                        ]
                    });
                }
            });
END
    }
}

1;