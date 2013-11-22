# --
# Kernel/Modules/AgentSurveyEdit.pm - survey edit module
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentSurveyEdit;

use strict;
use warnings;

use Kernel::System::Survey;
use Kernel::System::HTMLUtils;
use Kernel::System::Type;
use Kernel::System::Service;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get common objects
    %{$Self} = %Param;

    # check needed objects
    for my $Object (qw(ParamObject DBObject LayoutObject LogObject ConfigObject)) {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Object!" );
        }
    }
    $Self->{SurveyObject}    = Kernel::System::Survey->new(%Param);
    $Self->{HTMLUtilsObject} = Kernel::System::HTMLUtils->new(%Param);
    $Self->{TypeObject}      = Kernel::System::Type->new( %{$Self} );
    $Self->{ServiceObject}   = Kernel::System::Service->new( %{$Self} );

    # get config of frontend module
    $Self->{Config} = $Self->{ConfigObject}->Get("Survey::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # ------------------------------------------------------------ #
    # survey edit
    # ------------------------------------------------------------ #
    if ( !$Self->{Subaction} ) {
        my $SurveyID = $Self->{ParamObject}->GetParam( Param => "SurveyID" );

        # check if survey exists
        if (
            $Self->{SurveyObject}->ElementExists( ElementID => $SurveyID, Element => 'Survey' ) ne
            'Yes'
            )
        {
            return $Self->{LayoutObject}->NoPermission(
                Message    => 'You have no permission for this survey!',
                WithHeader => 'yes',
            );
        }

        my %Survey = $Self->{SurveyObject}->SurveyGet( SurveyID => $SurveyID );

        return $Self->_SurveyEditMask(
            %Survey,
        );

    }

    # ------------------------------------------------------------ #
    # survey save
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'SurveySave' ) {

        # get params
        my $SurveyID = $Self->{ParamObject}->GetParam( Param => "SurveyID" );

        if ( !$SurveyID ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => 'No SurveyID is given!',
                Comment => 'Please contact the admin.',
            );
        }

        # get requiered form elements and errors
        my %ServerError;
        my %FormElements;
        for my $Item (
            qw( Title Introduction Description NotificationSender NotificationSubject NotificationBody )
            )
        {
            $FormElements{$Item} = $Self->{ParamObject}->GetParam( Param => "$Item" );

            if ( !$FormElements{$Item} ) {
                $ServerError{ "$Item" . 'ServerError' } = 'ServerError';
            }
        }

        # get array params
        for my $Item (qw(Queues TicketTypeIDs ServiceIDs)) {
            @{ $FormElements{$Item} } = $Self->{ParamObject}->GetArray( Param => $Item );
        }

        if ( $Self->{ConfigObject}->Get('Frontend::RichText') ) {
            $FormElements{Introduction}
                = ( length $FormElements{Introduction} )
                ? "\$html/text\$ $FormElements{Introduction}"
                : '';
            $FormElements{NotificationBody}
                = ( length $FormElements{NotificationBody} )
                ? "\$html/text\$ $FormElements{NotificationBody}"
                : '';
            $FormElements{Description}
                = ( length $FormElements{Description} )
                ? "\$html/text\$ $FormElements{Description}"
                : '';
        }

        # save if no errors
        if ( !%ServerError ) {
            my $SaveResult = $Self->{SurveyObject}->SurveyUpdate(
                %FormElements,
                SurveyID => $SurveyID,
                UserID   => $Self->{UserID},
            );

            return $Self->{LayoutObject}->PopupClose(
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
}

sub _SurveyEditMask {
    my ( $Self, %Param ) = @_;

    my %ServerError;
    if ( $Param{ServerError} ) {
        %ServerError = %{ $Param{ServerError} };
    }

    my %FormElements;
    if ( $Param{FormElements} ) {
        %FormElements = %{ $Param{FormElements} };
    }

    my $Output = $Self->{LayoutObject}->Header(
        Title     => 'Survey Edit',
        Type      => 'Small',
        BodyClass => 'Popup',
    );

    my %Queues      = $Self->{QueueObject}->GetAllQueues();
    my $QueueString = $Self->{LayoutObject}->BuildSelection(
        Data         => \%Queues,
        Name         => 'Queues',
        Size         => 6,
        Multiple     => 1,
        PossibleNone => 0,
        Sort         => 'AlphanumericValue',
        Translation  => 0,
        SelectedID   => $FormElements{Queues} || $Param{Queues},
    );

    # check if the for send condition ticket type check is enabled
    if ( $Self->{ConfigObject}->Get('Survey::CheckSendConditionTicketType') )
    {

        # get the valid ticket type list
        my %TicketTypes = $Self->{TypeObject}->TypeList();

        # check if a ticket type is available
        if (%TicketTypes) {

            # build ticket type selection
            my $TicketTypeStrg = $Self->{LayoutObject}->BuildSelection(
                Data         => \%TicketTypes,
                Name         => 'TicketTypeIDs',
                Size         => 6,
                Multiple     => 1,
                PossibleNone => 0,
                Sort         => 'AlphanumericValue',
                Translation  => 0,
                SelectedID   => $FormElements{TicketTypeIDs} || $Param{TicketTypeIDs},
            );

            $Self->{LayoutObject}->Block(
                Name => 'TicketTypes',
                Data => {
                    TicketTypeStrg => $TicketTypeStrg,
                },
            );
        }
    }

    # check if the send condition service check is enabled
    if ( $Self->{ConfigObject}->Get('Survey::CheckSendConditionService') ) {

        # get the valid service list
        my %Services = $Self->{ServiceObject}->ServiceList( UserID => 1 );

        # check if a service is available
        if (%Services) {

            # build service selection
            my $ServiceStrg = $Self->{LayoutObject}->BuildSelection(
                Data         => \%Services,
                Name         => 'ServiceIDs',
                Size         => 6,
                Multiple     => 1,
                PossibleNone => 0,
                Sort         => 'AlphanumericValue',
                Translation  => 0,
                SelectedID   => $FormElements{ServiceIDs} || $Param{ServiceIDs},
            );

            $Self->{LayoutObject}->Block(
                Name => 'TicketServices',
                Data => {
                    ServiceStrg => $ServiceStrg,
                },
            );
        }
    }

    # rich text elements
    my %SurveyElements;

    $SurveyElements{Introduction} = $FormElements{Introduction} ||
        $Param{Introduction};

    $SurveyElements{NotificationBody} = $FormElements{NotificationBody} ||
        $Param{NotificationBody} ||
        $Self->{ConfigObject}->Get('Survey::NotificationBody');

    $SurveyElements{Description} = $FormElements{Description} ||
        $Param{Description} ||
        '';

    # load rich text editor
    my $RichTextEditor = $Self->{ConfigObject}->Get('Frontend::RichText');
    if ($RichTextEditor) {
        $Self->{LayoutObject}->Block( Name => 'RichText' );
    }

    # convert required elements to RTE
    for my $SurveyField ( sort keys %SurveyElements ) {
        next if !$SurveyElements{$SurveyField};

        # clean html
        my $HTMLContent =
            $SurveyElements{$SurveyField} =~ s{\A\$html\/text\$\s(.*)}{$1}xms;

        if ( !$HTMLContent && $RichTextEditor ) {
            $SurveyElements{$SurveyField} =
                $Self->{LayoutObject}->Ascii2Html(
                Text           => $SurveyElements{$SurveyField},
                HTMLResultMode => 1,
                );
        }
        elsif ( $HTMLContent && !$RichTextEditor ) {
            $SurveyElements{$SurveyField} =
                $Self->{HTMLUtilsObject}->ToAscii( String => $SurveyElements{$SurveyField} );
        }
    }

    $Self->{LayoutObject}->Block(
        Name => 'Introduction',
        Data => { Introduction => $SurveyElements{Introduction}, },
    );

    $Self->{LayoutObject}->Block(
        Name => 'NotificationBody',
        Data => { NotificationBody => $SurveyElements{NotificationBody}, },
    );

    $Self->{LayoutObject}->Block(
        Name => 'InternalDescription',
        Data => { Description => $SurveyElements{Description}, },
    );

    # generates generic errors for javascript
    for my $NeededItem (
        qw( Title Introduction Description NotificationSender NotificationSubject NotificationBody )
        )
    {
        $Self->{LayoutObject}->Block(
            Name => 'GenericError',
            Data => {
                ItemName => $NeededItem . 'Error',
            },
        );
    }

    for my $Item ( sort keys %ServerError ) {
        $Self->{LayoutObject}->Block(
            Name => 'GenericServerError',
            Data => {
                ItemName => $Item,
            },
        );
    }

    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentSurveyEdit',
        Data         => {
            %Param,
            QueueString        => $QueueString,
            NotificationSender => $FormElements{NotificationSender}
                || $Param{NotificationSender}
                || $Self->{ConfigObject}->Get('Survey::NotificationSender'),
            NotificationSubject => $FormElements{NotificationSubject}
                || $Param{NotificationSubject}
                || $Self->{ConfigObject}->Get('Survey::NotificationSubject'),
            %ServerError,
            %FormElements,
        },
    );
    $Output .= $Self->{LayoutObject}->Footer( Type => 'Small' );

    return $Output;
}
1;
