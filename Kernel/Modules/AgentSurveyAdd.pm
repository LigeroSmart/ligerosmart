# --
# Kernel/Modules/AgentSurveyAdd.pm - survey add module
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentSurveyAdd;

use strict;
use warnings;

use Kernel::System::Survey;
use Kernel::System::HTMLUtils;

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

    # get config of frontend module
    $Self->{Config} = $Self->{ConfigObject}->Get("Survey::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # ------------------------------------------------------------ #
    # survey add
    # ------------------------------------------------------------ #
    if ( !$Self->{Subaction} ) {
        return $Self->_SurveyAddMask();
    }

    # ------------------------------------------------------------ #
    # survey new
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'SurveyNew' ) {

        # get params
        my $SurveyID = $Self->{ParamObject}->GetParam( Param => "SurveyID" );

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

        @{ $FormElements{Queues} } = $Self->{ParamObject}->GetArray( Param => "Queues" );

        if ( $Self->{ConfigObject}->Get('Frontend::RichText') ) {
            $FormElements{Introduction}     = "\$html/text\$ $FormElements{Introduction}";
            $FormElements{NotificationBody} = "\$html/text\$ $FormElements{NotificationBody}";
            $FormElements{Description}      = "\$html/text\$ $FormElements{Description}";
        }

        # save if no errors
        if ( !%ServerError ) {
            my $SurveyID = $Self->{SurveyObject}->SurveyAdd(
                %FormElements,
                UserID => $Self->{UserID},
            );

            return $Self->{LayoutObject}->Redirect(
                OP => "Action=AgentSurveyZoom;SurveyID=$SurveyID",
            );
        }

        # reload form if error
        return $Self->_SurveyAddMask(
            FormElements => \%FormElements,
            ServerError  => \%ServerError,
        );
    }
}

sub _SurveyAddMask {
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
        Title => 'Add New Survey',
    );

    my $SelectedQueues;
    if ( !$Param{SurveyID} ) {
        $Output .= $Self->{LayoutObject}->NavigationBar();

    }
    else {
        my %Survey = $Self->{SurveyObject}->SurveyGet( SurveyID => $Param{SurveyID} );

        # get selected queues
        $SelectedQueues = $Survey{Queues};
    }

    my %Queues      = $Self->{QueueObject}->GetAllQueues();
    my $QueueString = $Self->{LayoutObject}->BuildSelection(
        Data         => \%Queues,
        Name         => 'Queues',
        Size         => 6,
        Multiple     => 1,
        PossibleNone => 0,
        Sort         => 'AlphanumericValue',
        Translation  => 0,
        SelectedID   => $FormElements{Queues} || $SelectedQueues,
    );

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
        TemplateFile => 'AgentSurveyAdd',
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
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
