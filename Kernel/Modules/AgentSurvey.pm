# --
# Kernel/Modules/AgentSurvey.pm - a survey module
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: AgentSurvey.pm,v 1.47 2011-01-19 23:28:11 dz Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentSurvey;

use strict;
use warnings;

use Kernel::System::Survey;
use Kernel::System::HTMLUtils;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.47 $) [1];

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

    # get default parameters
    $Self->{Filter} = $Self->{ParamObject}->GetParam( Param => 'Filter' ) || '';
    $Self->{View}   = $Self->{ParamObject}->GetParam( Param => 'View' )   || '';

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Output;

    # ------------------------------------------------------------ #
    # survey edit
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'SurveyEdit' ) {
        my $SurveyID = $Self->{ParamObject}->GetParam( Param => "SurveyID" );

        # check if survey exists
        if (
            $Self->{SurveyObject}->ElementExists( ElementID => $SurveyID, Element => 'Survey' ) ne
            'Yes'
            )
        {
            return $Self->{LayoutObject}
                ->Redirect( OP => "Action=AgentSurvey" );
        }

        my %Survey = $Self->{SurveyObject}->SurveyGet( SurveyID => $SurveyID );

        return $Self->_SurveyAddMask(
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
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
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

        @{ $FormElements{Queues} } = $Self->{ParamObject}->GetArray( Param => "Queues" );

        if ( $Self->{ConfigObject}->Get('Frontend::RichText') ) {
            $FormElements{Introduction}     = "\$html/text\$ $FormElements{Introduction}";
            $FormElements{NotificationBody} = "\$html/text\$ $FormElements{NotificationBody}";
            $FormElements{Description}      = "\$html/text\$ $FormElements{Description}";
        }

        # save if no errors
        if ( !%ServerError ) {
            my $SaveResult = $Self->{SurveyObject}->SurveySave(
                %FormElements,
                SurveyID => $SurveyID,
                UserID   => $Self->{UserID},
            );

            return $Self->{LayoutObject}->PopupClose(
                URL => "Action=AgentSurveyZoom;SurveyID=$SurveyID;",
            );

        }

        # reload form if error
        return $Self->_SurveyAddMask(
            FormElements => \%FormElements,
            ServerError  => \%ServerError,
            SurveyID     => $SurveyID,
        );

    }

    # ------------------------------------------------------------ #
    # survey add
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'SurveyAdd' ) {
        return $Self->_SurveyAddMask;
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
            my $SurveyID = $Self->{SurveyObject}->SurveyNew(
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

    # ------------------------------------------------------------ #
    # survey status
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'SurveyStatus' ) {
        my $SurveyID  = $Self->{ParamObject}->GetParam( Param => "SurveyID" );
        my $NewStatus = $Self->{ParamObject}->GetParam( Param => "NewStatus" );

        # check if survey exists
        if (
            $Self->{SurveyObject}->ElementExists( ElementID => $SurveyID, Element => 'Survey' ) ne
            'Yes'
            )
        {
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
        }

        # set a new status
        my $StatusSet = $Self->{SurveyObject}->SurveyStatusSet(
            SurveyID  => $SurveyID,
            NewStatus => $NewStatus,
        );
        my $Message = '';
        if ( defined($StatusSet) && $StatusSet eq 'NoQuestion' ) {
            $Message = ';Message=NoQuestion';
        }
        elsif ( defined($StatusSet) && $StatusSet eq 'IncompleteQuestion' ) {
            $Message = ';Message=IncompleteQuestion';
        }
        elsif ( defined($StatusSet) && $StatusSet eq 'StatusSet' ) {
            $Message = ';Message=StatusSet';
        }
        return $Self->{LayoutObject}->Redirect(
            OP => "Action=AgentSurveyZoom;SurveyID=$SurveyID$Message",
        );
    }

    # ------------------------------------------------------------ #
    # stats
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Stats' ) {
        my $SurveyID = $Self->{ParamObject}->GetParam( Param => "SurveyID" );

        # check if survey exists
        if (
            $Self->{SurveyObject}->ElementExists( ElementID => $SurveyID, Element => 'Survey' ) ne
            'Yes'
            )
        {
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
        }
        $Output = $Self->{LayoutObject}->Header(
            Title => 'Stats Overview',
            Type  => 'Small',
        );

        my %Survey = $Self->{SurveyObject}->SurveyGet( SurveyID => $SurveyID );

        # print the main table.
        $Self->{LayoutObject}->Block(
            Name => 'Stats',
            Data => {%Survey},
        );
        my @List = $Self->{SurveyObject}->VoteList( SurveyID => $SurveyID );
        for my $Vote (@List) {
            $Vote->{SurveyID} = $SurveyID;
            my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Vote->{TicketID} );
            $Vote->{TicketNumber} = $Ticket{TicketNumber};
            $Self->{LayoutObject}->Block(
                Name => 'StatsVote',
                Data => $Vote,
            );
        }
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentSurvey',
            Data         => {%Param},
        );

        $Output .= $Self->{LayoutObject}->Footer( Type => 'Small' );
        return $Output;
    }

    # ------------------------------------------------------------ #
    # stats detail
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'StatsDetail' ) {
        my $SurveyID     = $Self->{ParamObject}->GetParam( Param => "SurveyID" );
        my $RequestID    = $Self->{ParamObject}->GetParam( Param => "RequestID" );
        my $TicketNumber = $Self->{ParamObject}->GetParam( Param => "TicketNumber" );

        # check if survey exists
        if (
            $Self->{SurveyObject}->ElementExists( ElementID => $SurveyID, Element => 'Survey' ) ne
            'Yes'
            || $Self->{SurveyObject}->ElementExists( ElementID => $RequestID, Element => 'Request' )
            ne 'Yes'
            )
        {
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
        }
        $Output = $Self->{LayoutObject}->Header(
            Title => 'Stats Detail',
            Type  => 'Small',
        );

        my %Survey = $Self->{SurveyObject}->SurveyGet( SurveyID => $SurveyID );

        # print the main table.
        $Self->{LayoutObject}->Block(
            Name => 'StatsDetail',
            Data => {
                %Survey,
                TicketNumber => $TicketNumber,
            },
        );
        my @QuestionList = $Self->{SurveyObject}->QuestionList( SurveyID => $SurveyID );
        for my $Question (@QuestionList) {

            my $Class = '';
            if ( $Question->{Type} eq 'Textarea' ) {
                $Class = 'Textarea';
            }

            $Self->{LayoutObject}->Block(
                Name => 'StatsDetailQuestion',
                Data => {
                    %{$Question},
                    Class => $Class,
                },
            );
            my @Answers;
            if ( $Question->{Type} eq 'Radio' || $Question->{Type} eq 'Checkbox' ) {
                my @AnswerList;
                @AnswerList = $Self->{SurveyObject}->VoteGet(
                    RequestID  => $RequestID,
                    QuestionID => $Question->{QuestionID},
                );
                for my $Row (@AnswerList) {
                    my %Answer = $Self->{SurveyObject}->AnswerGet( AnswerID => $Row->{VoteValue} );
                    my %Data;
                    $Data{Answer} = $Answer{Answer};
                    push( @Answers, \%Data );
                }
            }
            elsif ( $Question->{Type} eq 'YesNo' || $Question->{Type} eq 'Textarea' ) {
                my @List = $Self->{SurveyObject}->VoteGet(
                    RequestID  => $RequestID,
                    QuestionID => $Question->{QuestionID},
                );

                my %Data;
                $Data{Answer} = $List[0]->{VoteValue};

                # clean html
                if ( $Question->{Type} eq 'Textarea' && $Data{Answer} ) {
                    $Data{Answer} =~ s{\A\$html\/text\$\s(.*)}{$1}xms;
                    $Data{Answer} = $Self->{LayoutObject}->Ascii2Html(
                        Text           => $Data{Answer},
                        HTMLResultMode => 1,
                    );
                    $Data{Answer} =
                        $Self->{HTMLUtilsObject}->ToAscii( String => $Data{Answer} );
                }
                push( @Answers, \%Data );
            }
            for my $Row (@Answers) {
                $Self->{LayoutObject}->Block(
                    Name => 'StatsDetailAnswer',
                    Data => {
                        %{$Row},
                        Class => $Class,
                        }
                );
            }
        }
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentSurvey',
            Data         => {%Param},
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # show overview
    # ------------------------------------------------------------ #

    # store last screen, used for backlinks
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenView',
        Value     => $Self->{RequestedURL},
    );

    # get sorting parameters
    my $SortBy = $Self->{ParamObject}->GetParam( Param => 'SortBy' )
        || $Self->{Config}->{'SortBy::Default'}
        || 'Number';

    # get ordering parameters
    my $OrderBy = $Self->{ParamObject}->GetParam( Param => 'OrderBy' )
        || $Self->{Config}->{'Order::Default'}
        || 'Down';

    # investigate refresh
    my $Refresh = $Self->{UserRefreshTime} ? 60 * $Self->{UserRefreshTime} : undef;

    # output header
    $Output = $Self->{LayoutObject}->Header(
        Title   => 'Overview',
        Refresh => $Refresh,
    );
    $Output .= $Self->{LayoutObject}->NavigationBar();
    $Self->{LayoutObject}->Print( Output => \$Output );
    $Output = '';

    # get survey list
    my @SurveyIDs = $Self->{SurveyObject}->SurveySearch(
        OrderBy          => [$SortBy],
        OrderByDirection => [$OrderBy],
        UserID           => $Self->{UserID},
    );

    # find out which columns should be shown
    my @ShowColumns;
    if ( $Self->{Config}->{ShowColumns} ) {

        # get all possible columns from config
        my %PossibleColumn = %{ $Self->{Config}->{ShowColumns} };

        # get the column names that should be shown
        COLUMNNAME:
        for my $Name ( keys %PossibleColumn ) {
            next COLUMNNAME if !$PossibleColumn{$Name};
            push @ShowColumns, $Name;
        }
    }

    # show the list
    my $LinkPage =
        'Filter=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{Filter} )
        . ';View=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{View} )
        . ';SortBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $SortBy )
        . ';OrderBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $OrderBy )
        . ';';
    my $LinkSort =
        'Filter=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{Filter} )
        . ';View=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{View} )
        . ';';
    my $LinkFilter =
        'SortBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $SortBy )
        . ';OrderBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $OrderBy )
        . ';View=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{View} )
        . ';';

    # show config item list
    $Output .= $Self->{LayoutObject}->SurveyListShow(
        SurveyIDs   => [@SurveyIDs],
        Total       => scalar @SurveyIDs,
        View        => $Self->{View},
        FilterLink  => $LinkFilter,
        TitleName   => $Self->{LayoutObject}->{LanguageObject}->Get('Overview'),
        TitleValue  => $Self->{LayoutObject}->{LanguageObject}->Get('Survey'),
        Env         => $Self,
        LinkPage    => $LinkPage,
        LinkSort    => $LinkSort,
        ShowColumns => \@ShowColumns,
        SortBy      => $Self->{LayoutObject}->Ascii2Html( Text => $SortBy ),
        OrderBy     => $Self->{LayoutObject}->Ascii2Html( Text => $OrderBy ),
    );

    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
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

    my $Output;

    # if SurveyID the SurveyEdit should be loaded (popup)
    my $Title;
    my $Type;
    if ( $Param{SurveyID} ) {
        $Title = 'Survey Edit';

        # for header and footer
        $Type = 'Small';
    }
    else {
        $Title = 'Add New Survey';
    }

    $Output .= $Self->{LayoutObject}->Header(
        Title => $Title,
        Type  => $Type,
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

    my $Block;
    if ( !$Param{SurveyID} ) {
        $Block = 'SurveyAdd';
    }
    else {
        $Block = 'SurveyEdit';
    }

    # print the form
    $Self->{LayoutObject}->Block(
        Name => $Block,
        Data => {
            %Param,
            QueueString        => $QueueString,
            NotificationSender => $FormElements{NotificationSender}
                || $Self->{ConfigObject}->Get('Survey::NotificationSender'),
            NotificationSubject => $FormElements{NotificationSubject}
                || $Self->{ConfigObject}->Get('Survey::NotificationSubject'),
            %ServerError,
            %FormElements,
        },
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
        $Self->{LayoutObject}->Block( Name => "$Block" . 'RichText' );
    }

    # convert required elements to RTE
    for my $SurveyField ( keys %SurveyElements ) {
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
        Name => "$Block" . 'Introduction',
        Data => { Introduction => $SurveyElements{Introduction}, },
    );

    $Self->{LayoutObject}->Block(
        Name => "$Block" . 'NotificationBody',
        Data => { NotificationBody => $SurveyElements{NotificationBody}, },
    );

    $Self->{LayoutObject}->Block(
        Name => "$Block" . 'InternalDescription',
        Data => { Description => $SurveyElements{Description}, },
    );

    # generates generic errors for javascript
    for my $NeededItem (
        qw( Title Introduction Description NotificationSender NotificationSubject NotificationBody )
        )
    {
        $Self->{LayoutObject}->Block(
            Name => $Block . 'GenericError',
            Data => {
                ItemName => $NeededItem . 'Error',
            },
        );
    }

    for my $Item ( keys %ServerError ) {
        $Self->{LayoutObject}->Block(
            Name => $Block . 'GenericServerError',
            Data => {
                ItemName => $Item,
            },
        );
    }

    $Output .= $Self->{LayoutObject}->Output( TemplateFile => 'AgentSurvey' );
    $Output .= $Self->{LayoutObject}->Footer( Type => $Type );

    return $Output;
}
1;
