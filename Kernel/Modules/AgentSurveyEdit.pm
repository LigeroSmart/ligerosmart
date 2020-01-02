# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AgentSurveyEdit;

use strict;
use warnings;

use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get common objects
    %{$Self} = %Param;

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get needed objects
    my $SurveyObject = $Kernel::OM->Get('Kernel::System::Survey');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $SurveyID = $ParamObject->GetParam( Param => "SurveyID" );

    # ------------------------------------------------------------ #
    # survey edit
    # ------------------------------------------------------------ #
    if ( !$Self->{Subaction} ) {

        # check if survey exists
        my $SurveyExists = $SurveyObject->ElementExists(
            ElementID => $SurveyID,
            Element   => 'Survey'
        );
        if ( $SurveyExists ne 'Yes' ) {

            return $LayoutObject->NoPermission(
                Message    => Translatable('You have no permission for this survey!'),
                WithHeader => 'yes',
            );
        }

        my %Survey = $SurveyObject->SurveyGet( SurveyID => $SurveyID );

        return $Self->_SurveyEditMask(
            %Survey,
        );

    }

    # ------------------------------------------------------------ #
    # survey save
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'SurveySave' ) {

        if ( !$SurveyID ) {

            return $LayoutObject->ErrorScreen(
                Message => Translatable('No SurveyID is given!'),
                Comment => Translatable('Please contact the administrator.'),
            );
        }

        # get required form elements and errors
        my %ServerError;
        my %FormElements;
        for my $Item (
            qw( Title Introduction Description NotificationSender NotificationSubject NotificationBody )
            )
        {
            $FormElements{$Item} = $ParamObject->GetParam( Param => "$Item" );

            if ( !$FormElements{$Item} ) {
                $ServerError{ "$Item" . 'ServerError' } = 'ServerError';
            }
        }

        # get array params
        for my $Item (qw(Queues TicketTypeIDs ServiceIDs)) {
            @{ $FormElements{$Item} } = $ParamObject->GetArray( Param => $Item );
        }

        if ( $Kernel::OM->Get('Kernel::Config')->Get('Frontend::RichText') ) {
            $FormElements{Introduction} = ( length $FormElements{Introduction} )
                ? "\$html/text\$ $FormElements{Introduction}"
                : '';
            $FormElements{NotificationBody} = ( length $FormElements{NotificationBody} )
                ? "\$html/text\$ $FormElements{NotificationBody}"
                : '';
            $FormElements{Description} = ( length $FormElements{Description} )
                ? "\$html/text\$ $FormElements{Description}"
                : '';
        }

        my $CustomerUserConditionsFieldStrg = $ParamObject->GetParam(
            Param => 'CustomerUserConditionsFields',
        );
        my %CustomerUserConditions;

        if ($CustomerUserConditionsFieldStrg) {

            FIELD:
            for my $Field ( split( /,/, $CustomerUserConditionsFieldStrg ) ) {
                next FIELD if !$Field;

                my %SelectionsData;
                %SelectionsData = $Kernel::OM->Get('Kernel::System::Survey')->_SendConditionGetFieldSelections(
                    FieldName => $Field,
                );

                my @Checkboxes = $ParamObject->GetArray(
                    Param => "${Field}Checkbox",
                );
                my @Conditions = $ParamObject->GetArray(
                    Param => $Field,
                );
                my @ConditionArray;

                for my $Count ( 0 .. ( scalar @Conditions - 1 ) ) {

                    my $Negation;
                    if (%SelectionsData) {
                        $Negation = $Checkboxes[0] + 0;
                    }
                    else {
                        $Negation = $Checkboxes[$Count] + 0;
                    }

                    my $RegExpValue      = $Conditions[$Count];
                    my %ConditionEntries = (
                        Negation    => $Negation,
                        RegExpValue => $RegExpValue,
                    );

                    if ( !eval { my $Regex = qr/$RegExpValue/; 1; } ) {

                        $ServerError{CustomerUserConditionErrors}->{$Field}->{$Count} = 'ServerError';
                    }

                    push @ConditionArray, \%ConditionEntries;
                }

                $CustomerUserConditions{$Field} = \@ConditionArray;
            }

            if (%CustomerUserConditions) {

                $FormElements{CustomerUserConditions} = \%CustomerUserConditions;
            }
        }

        # save if no errors
        if ( !%ServerError ) {
            my $SaveResult = $SurveyObject->SurveyUpdate(
                %FormElements,
                SurveyID => $SurveyID,
                UserID   => $Self->{UserID},
            );

            return $LayoutObject->PopupClose(
                URL => "Action=AgentSurveyZoom;SurveyID=$SurveyID;",
            );

        }

        # reload form if error
        return $Self->_SurveyEditMask(
            FormElements => \%FormElements,
            ServerError  => \%ServerError,
            SurveyID     => $SurveyID,
        );
    }

    # ------------------------------------------------------------ #
    # Survey AJAX request
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AJAXRequest' ) {

        my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');

        my $FieldName = $ParamObject->GetParam(
            Param => 'FieldName',
        );
        my @SelectedValues = $ParamObject->GetArray(
            Param => 'SelectedValues[]',
        );

        my %SelectionsData;
        %SelectionsData = $SurveyObject->_SendConditionGetFieldSelections(
            FieldName => $FieldName,
        );

        my $JSONString = $JSONObject->Encode(
            Data => '',
        );

        if (%SelectionsData) {
            my $CustomerUserConditionsStrg = $LayoutObject->BuildSelection(
                Data          => \%SelectionsData,
                Name          => "${FieldName}[]",
                Multiple      => 1,
                Size          => 6,
                Class         => 'Modernize W50pc',
                SelectedValue => \@SelectedValues,
            );

            my %JSONData = (
                Success     => \1,
                SelectField => $CustomerUserConditionsStrg,
            );

            $JSONString = $JSONObject->Encode(
                Data => \%JSONData,
            );
        }

        return $LayoutObject->Attachment(
            ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
            Content     => $JSONString,
            Type        => 'inline',
            NoCache     => 1,
        );
    }
}

sub _SurveyEditMask {
    my ( $Self, %Param ) = @_;

    my %JSData;

    my %ServerError;
    if ( $Param{ServerError} ) {
        %ServerError = %{ $Param{ServerError} };
    }

    my %FormElements;
    if ( $Param{FormElements} ) {
        %FormElements = %{ $Param{FormElements} };
    }

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $Output = $LayoutObject->Header(
        Title     => Translatable('Survey Edit'),
        Type      => 'Small',
        BodyClass => 'Popup',
    );

    my %Queues      = $Kernel::OM->Get('Kernel::System::Queue')->GetAllQueues();
    my $QueueString = $LayoutObject->BuildSelection(
        Data         => \%Queues,
        Name         => 'Queues',
        Size         => 6,
        Multiple     => 1,
        PossibleNone => 0,
        Sort         => 'AlphanumericValue',
        Translation  => 0,
        SelectedID   => $FormElements{Queues} || $Param{Queues},
        Class        => 'Modernize',
    );

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # check if the for send condition ticket type check is enabled
    if ( $ConfigObject->Get('Survey::CheckSendConditionTicketType') ) {

        # get the valid ticket type list
        my %TicketTypes = $Kernel::OM->Get('Kernel::System::Type')->TypeList();

        # check if a ticket type is available
        if (%TicketTypes) {

            # build ticket type selection
            my $TicketTypeStrg = $LayoutObject->BuildSelection(
                Data         => \%TicketTypes,
                Name         => 'TicketTypeIDs',
                Size         => 6,
                Multiple     => 1,
                PossibleNone => 0,
                Sort         => 'AlphanumericValue',
                Translation  => 0,
                SelectedID   => $FormElements{TicketTypeIDs} || $Param{TicketTypeIDs},
                Class        => 'Modernize',
            );

            $LayoutObject->Block(
                Name => 'TicketTypes',
                Data => {
                    TicketTypeStrg => $TicketTypeStrg,
                },
            );
        }
    }

    # check if the send condition service check is enabled
    if ( $ConfigObject->Get('Survey::CheckSendConditionService') ) {

        # get the valid service list
        my %Services = $Kernel::OM->Get('Kernel::System::Service')->ServiceList(
            UserID => 1,
        );

        # check if a service is available
        if (%Services) {

            # build service selection
            my $ServiceStrg = $LayoutObject->BuildSelection(
                Data         => \%Services,
                Name         => 'ServiceIDs',
                Size         => 6,
                Multiple     => 1,
                PossibleNone => 0,
                Sort         => 'AlphanumericValue',
                Translation  => 0,
                SelectedID   => $FormElements{ServiceIDs} || $Param{ServiceIDs},
                Class        => 'Modernize',
            );

            $LayoutObject->Block(
                Name => 'TicketServices',
                Data => {
                    ServiceStrg => $ServiceStrg,
                },
            );
        }
    }

    # Check send condition by CustomerUser fields.
    if ( $ConfigObject->Get('Survey::CheckSendConditionCustomerFields') ) {

        my %CustomerFieldsConfig = %{ $ConfigObject->Get('Survey::CheckSendConditionCustomerFields') };
        my @CustomerFields;

        my $SurveyObject = $Kernel::OM->Get('Kernel::System::Survey');

        CUSTOMERFIELD:
        for my $CustomerField ( sort keys %CustomerFieldsConfig ) {
            next CUSTOMERFIELD if !$CustomerFieldsConfig{$CustomerField};
            next CUSTOMERFIELD if !$SurveyObject->_SendConditionCheckCustomerField( FieldName => $CustomerField );

            push @CustomerFields, $CustomerField;
        }

        if (@CustomerFields) {

            my $CustomerUserConditionsFieldsStrg = $LayoutObject->BuildSelection(
                Data         => \@CustomerFields,
                Name         => 'CustomerUserConditions',
                Multiple     => 0,
                PossibleNone => 1,
                Sort         => 'AlphanumericValue',
                Translation  => 0,
                SelectedID   => 1,
                Class        => '',
            );

            $JSData{CustomerUserConditions} = $FormElements{CustomerUserConditions} || $Param{CustomerUserConditions};
            $JSData{CustomerUserConditionErrors} = $ServerError{CustomerUserConditionErrors} || '';

            $LayoutObject->Block(
                Name => 'SendCustomerUserConditions',
                Data => {
                    CustomerUserConditionsFieldsStrg => $CustomerUserConditionsFieldsStrg,
                    CustomerUserConditions           => $FormElements{CustomerUserConditions}
                        || $Param{CustomerUserConditions},
                    CustomerUserConditionErrors => $ServerError{CustomerUserConditionErrors} || '',
                },
            );
        }
    }

    # rich text elements
    my %SurveyElements;

    $SurveyElements{Introduction} = $FormElements{Introduction} || $Param{Introduction};

    $SurveyElements{NotificationBody}
        = $FormElements{NotificationBody} || $Param{NotificationBody} || $ConfigObject->Get('Survey::NotificationBody');

    $SurveyElements{Description} = $FormElements{Description} || $Param{Description} || '';

    # load rich text editor
    my $RichTextEditor = $ConfigObject->Get('Frontend::RichText');
    if ($RichTextEditor) {
        $LayoutObject->SetRichTextParameters(
            Data => {},
        );
    }

    # convert required elements to RTE
    FIELD:
    for my $SurveyField ( sort keys %SurveyElements ) {
        next FIELD if !$SurveyElements{$SurveyField};

        # clean HTML
        my $HTMLContent =
            $SurveyElements{$SurveyField} =~ s{\A\$html\/text\$\s(.*)}{$1}xms;

        if ( !$HTMLContent && $RichTextEditor ) {
            $SurveyElements{$SurveyField} = $LayoutObject->Ascii2Html(
                Text           => $SurveyElements{$SurveyField},
                HTMLResultMode => 1,
            );
        }
        elsif ( $HTMLContent && !$RichTextEditor ) {
            $SurveyElements{$SurveyField} = $Kernel::OM->Get('Kernel::System::HTMLUtils')->ToAscii(
                String => $SurveyElements{$SurveyField},
            );
        }
    }

    $LayoutObject->Block(
        Name => 'Introduction',
        Data => {
            Introduction => $SurveyElements{Introduction},
        },
    );

    $LayoutObject->Block(
        Name => 'NotificationBody',
        Data => {
            NotificationBody => $SurveyElements{NotificationBody},
        },
    );

    $LayoutObject->Block(
        Name => 'InternalDescription',
        Data => {
            Description => $SurveyElements{Description},
        },
    );

    # generates generic errors for JavaScript
    for my $NeededItem (
        qw( Title Introduction Description NotificationSender NotificationSubject NotificationBody )
        )
    {
        $LayoutObject->Block(
            Name => 'GenericError',
            Data => {
                ItemName => $NeededItem . 'Error',
            },
        );
    }

    for my $Item ( sort keys %ServerError ) {
        $LayoutObject->Block(
            Name => 'GenericServerError',
            Data => {
                ItemName => $Item,
            },
        );
    }

    $LayoutObject->AddJSData(
        Key   => 'JSData',
        Value => \%JSData,
    );

    $Output .= $LayoutObject->Output(
        TemplateFile => 'AgentSurveyEdit',
        Data         => {
            %Param,
            QueueString        => $QueueString,
            NotificationSender => $FormElements{NotificationSender}
                || $Param{NotificationSender}
                || $ConfigObject->Get('Survey::NotificationSender'),
            NotificationSubject => $FormElements{NotificationSubject}
                || $Param{NotificationSubject}
                || $ConfigObject->Get('Survey::NotificationSubject'),
            %ServerError,
            %FormElements,
        },
    );
    $Output .= $LayoutObject->Footer(
        Type => 'Small',
    );

    return $Output;
}
1;
