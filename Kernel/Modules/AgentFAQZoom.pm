# --
# Kernel/Modules/AgentFAQZoom.pm - to get a closer view
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentFAQZoom;

use strict;
use warnings;

use Kernel::System::LinkObject;
use Kernel::System::FAQ;
use Kernel::System::DynamicField;
use Kernel::System::DynamicField::Backend;
use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (
        qw(ParamObject DBObject LayoutObject LogObject ConfigObject UserObject GroupObject)
        )
    {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Object!" );
        }
    }

    # create needed objects
    $Self->{LinkObject}         = Kernel::System::LinkObject->new(%Param);
    $Self->{FAQObject}          = Kernel::System::FAQ->new(%Param);
    $Self->{DynamicFieldObject} = Kernel::System::DynamicField->new(%Param);
    $Self->{BackendObject}      = Kernel::System::DynamicField::Backend->new(%Param);

    # get config of frontend module
    $Self->{Config} = $Self->{ConfigObject}->Get("FAQ::Frontend::$Self->{Action}");

    # set default interface settings
    $Self->{Interface} = $Self->{FAQObject}->StateTypeGet(
        Name   => 'internal',
        UserID => $Self->{UserID},
    );
    $Self->{InterfaceStates} = $Self->{FAQObject}->StateTypeList(
        Types  => $Self->{ConfigObject}->Get('FAQ::Agent::StateTypes'),
        UserID => $Self->{UserID},
    );

    # get default options
    $Self->{MultiLanguage} = $Self->{ConfigObject}->Get('FAQ::MultiLanguage');
    $Self->{Voting}        = $Self->{ConfigObject}->Get('FAQ::Voting');

    # get the dynamic fields for this screen
    $Self->{DynamicField} = $Self->{DynamicFieldObject}->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => 'FAQ',
        FieldFilter => $Self->{Config}->{DynamicField} || {},
    );

    my %UserPreferences = $Self->{UserObject}->GetPreferences(
        UserID => $Self->{UserID},
    );

    if ( !defined $Self->{DoNotShowBrowserLinkMessage} ) {
        if ( $UserPreferences{UserAgentDoNotShowBrowserLinkMessage} ) {
            $Self->{DoNotShowBrowserLinkMessage} = 1;
        }
        else {
            $Self->{DoNotShowBrowserLinkMessage} = 0;
        }
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # permission check
    if ( !$Self->{AccessRo} ) {
        return $Self->{LayoutObject}->NoPermission(
            Message    => 'You need ro permission!',
            WithHeader => 'yes',
        );
    }

    # get params
    my %GetParam;
    $GetParam{ItemID} = $Self->{ParamObject}->GetParam( Param => 'ItemID' );
    $GetParam{Rate}   = $Self->{ParamObject}->GetParam( Param => 'Rate' );

    # get navigation bar option
    my $Nav = $Self->{ParamObject}->GetParam( Param => 'Nav' ) || '';

    # check needed stuff
    if ( !$GetParam{ItemID} ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'No ItemID is given!',
            Comment => 'Please contact the admin.',
        );
    }

    # get FAQ item data
    my %FAQData = $Self->{FAQObject}->FAQGet(
        ItemID        => $GetParam{ItemID},
        ItemFields    => 1,
        UserID        => $Self->{UserID},
        DynamicFields => 1,
    );
    if ( !%FAQData ) {
        return $Self->{LayoutObject}->ErrorScreen();
    }

    # check user permission
    my $Permission = $Self->{FAQObject}->CheckCategoryUserPermission(
        UserID     => $Self->{UserID},
        CategoryID => $FAQData{CategoryID},
    );

    # show error message
    if ( !$Permission ) {
        return $Self->{LayoutObject}->NoPermission(
            Message    => 'You have no permission for this category!',
            WithHeader => 'yes',
        );
    }

    # ---------------------------------------------------------- #
    # HTMLView Sub-action
    # ---------------------------------------------------------- #
    if ( $Self->{Subaction} eq 'HTMLView' ) {

        # get params
        my $Field = $Self->{ParamObject}->GetParam( Param => "Field" );

        # needed params
        for my $Needed (qw( ItemID Field )) {
            if ( !$Needed ) {
                $Self->{LogObject}->Log(
                    Message  => "Needed Param: $Needed!",
                    Priority => 'error',
                );
                return;
            }
        }

        # get the Field content
        my $FieldContent = $Self->{FAQObject}->ItemFieldGet(
            ItemID => $GetParam{ItemID},
            Field  => $Field,
            UserID => $Self->{UserID},
        );

        # rewrite handle and action, take care of old style before FAQ 2.0.x
        $FieldContent =~ s{
            Action=AgentFAQ [&](amp;)? Subaction=Download [&](amp;)?
        }{Action=AgentFAQZoom;Subaction=DownloadAttachment;}gxms;

        # build base URL for in-line images
        my $SessionID = '';
        if ( $Self->{SessionID} && !$Self->{SessionIDCookie} ) {
            $SessionID = ';' . $Self->{SessionName} . '=' . $Self->{SessionID};
            $FieldContent =~ s{
                (Action=AgentFAQZoom;Subaction=DownloadAttachment;ItemID=\d+;FileID=\d+)
            }{$1$SessionID}gmsx;
        }

        # detect all plain text links and put them into an HTML <a> tag
        $FieldContent = $Self->{LayoutObject}->{HTMLUtilsObject}->LinkQuote(
            String => $FieldContent,
        );

        # set target="_blank" attribute to all HTML <a> tags
        # the LinkQuote function needs to be called again
        $FieldContent = $Self->{LayoutObject}->{HTMLUtilsObject}->LinkQuote(
            String    => $FieldContent,
            TargetAdd => 1,
        );

        # add needed HTML headers
        $FieldContent = $Self->{LayoutObject}->{HTMLUtilsObject}->DocumentComplete(
            String  => $FieldContent,
            Charset => 'utf-8',
        );

        # return complete HTML as an attachment
        return $Self->{LayoutObject}->Attachment(
            Type        => 'inline',
            ContentType => 'text/html',
            Content     => $FieldContent,
        );
    }

    # ---------------------------------------------------------- #
    # DownloadAttachment Sub-action
    # ---------------------------------------------------------- #
    if ( $Self->{Subaction} eq 'DownloadAttachment' ) {

        # manage parameters
        $GetParam{FileID} = $Self->{ParamObject}->GetParam( Param => 'FileID' );

        if ( !defined $GetParam{FileID} ) {
            return $Self->{LayoutObject}->FatalError( Message => 'Need FileID' );
        }

        # get attachments
        my %File = $Self->{FAQObject}->AttachmentGet(
            ItemID => $GetParam{ItemID},
            FileID => $GetParam{FileID},
            UserID => $Self->{UserID},
        );
        if (%File) {
            return $Self->{LayoutObject}->Attachment(%File);
        }
        else {
            $Self->{LogObject}->Log(
                Message  => "No such attachment ($GetParam{FileID})! May be an attack!!!",
                Priority => 'error',
            );
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }

    # ---------------------------------------------------------- #
    # other sub-actions continues here
    # ---------------------------------------------------------- #
    my $Output;
    if ( $Nav eq 'None' ) {

        # output header small and no Navbar
        $Output = $Self->{LayoutObject}->Header( Type => 'Small' );
    }
    else {

        # output header and navigation bar
        $Output = $Self->{LayoutObject}->Header(
            Value => $FAQData{Title},
        );
        $Output .= $Self->{LayoutObject}->NavigationBar();
    }

    # define different notifications
    my %Notifications = (
        Thanks => {
            Priority => 'Info',
            Info     => 'Thanks for your vote!'
        },
        AlreadyVoted => {
            Priority => 'Error',
            Info     => 'You have already voted!',
        },
        NoRate => {
            Priority => 'Error',
            Info     => 'No rate selected!',
        },
    );

    # output notifications if any
    my $Notify = $Self->{ParamObject}->GetParam( Param => 'Notify' ) || '';
    if ( $Notify && IsHashRefWithData( $Notifications{$Notify} ) ) {
        $Output .= $Self->{LayoutObject}->Notify(
            %{ $Notifications{$Notify} },
        );
    }

    # get FAQ vote information
    my $VoteData;
    if ( $Self->{Voting} ) {
        $VoteData = $Self->{FAQObject}->VoteGet(
            CreateBy  => $Self->{UserID},
            ItemID    => $FAQData{ItemID},
            Interface => $Self->{Interface}->{StateID},
            IP        => $ENV{'REMOTE_ADDR'},
            UserID    => $Self->{UserID},
        );
    }

    # check if user already voted this FAQ item
    my $AlreadyVoted;
    if ($VoteData) {

        # item/change_time > voting/create_time
        my $ItemChangedSystemTime = $Self->{TimeObject}->TimeStamp2SystemTime(
            String => $FAQData{Changed} || '',
        );
        my $VoteCreatedSystemTime = $Self->{TimeObject}->TimeStamp2SystemTime(
            String => $VoteData->{Created} || '',
        );

        if ( $ItemChangedSystemTime <= $VoteCreatedSystemTime ) {
            $AlreadyVoted = 1;
        }
    }

    # ---------------------------------------------------------- #
    # Vote Sub-action
    # ---------------------------------------------------------- #
    if ( $Self->{Subaction} eq 'Vote' ) {

        # user can't use this sub-action if is not enabled
        if ( !$Self->{Voting} ) {
            $Self->{LayoutObject}->FatalError( Message => "The voting mechanism is not enabled!" );
        }

        # user can vote only once per FAQ revision
        if ($AlreadyVoted) {

            # redirect to FAQ zoom
            return $Self->{LayoutObject}->Redirect(
                OP => 'Action=AgentFAQZoom;ItemID='
                    . $GetParam{ItemID}
                    . ';Nav=$Nav;Notify=AlreadyVoted'
            );
        }

        # set the vote if any
        elsif ( defined $GetParam{Rate} ) {

            # get rates config
            my $VotingRates = $Self->{ConfigObject}->Get('FAQ::Item::Voting::Rates');
            my $Rate        = $GetParam{Rate};

            # send error if rate is not defined in config
            if ( !$VotingRates->{$Rate} ) {
                $Self->{LayoutObject}->FatalError( Message => "The vote rate is not defined!" );
            }

            # otherwise add the vote
            else {
                $Self->{FAQObject}->VoteAdd(
                    CreatedBy => $Self->{UserID},
                    ItemID    => $GetParam{ItemID},
                    IP        => $ENV{'REMOTE_ADDR'},
                    Interface => $Self->{Interface}->{StateID},
                    Rate      => $GetParam{Rate},
                    UserID    => $Self->{UserID},
                );

                # do not show the voting form
                $AlreadyVoted = 1;

                # refresh FAQ item data
                %FAQData = $Self->{FAQObject}->FAQGet(
                    ItemID        => $GetParam{ItemID},
                    ItemFields    => 1,
                    UserID        => $Self->{UserID},
                    DynamicFields => 1,
                );
                if ( !%FAQData ) {
                    return $Self->{LayoutObject}->ErrorScreen();
                }

                # redirect to FAQ zoom
                return $Self->{LayoutObject}->Redirect(
                    OP => 'Action=AgentFAQZoom;ItemID='
                        . $GetParam{ItemID}
                        . ';Nav=$Nav;Notify=Thanks'
                );
            }
        }

        # user is able to vote but no rate has been selected
        else {
            # redirect to FAQ zoom
            return $Self->{LayoutObject}->Redirect(
                OP => 'Action=AgentFAQZoom;ItemID=' . $GetParam{ItemID} . ';Nav=$Nav;Notify=NoRate'
            );
        }
    }

    # prepare fields data (Still needed for PlainText)
    FIELD:
    for my $Field (qw(Field1 Field2 Field3 Field4 Field5 Field6)) {
        next FIELD if !$FAQData{$Field};

        # rewrite handle and action, take care of old style before FAQ 2.0.x
        $FAQData{$Field} =~ s{
            Action=AgentFAQ [&](amp;)? Subaction=Download [&](amp;)?
        }{Action=AgentFAQZoom;Subaction=DownloadAttachment;}gxms;

        # no quoting if HTML view is enabled
        next FIELD if $Self->{ConfigObject}->Get('FAQ::Item::HTML');

        # HTML quoting
        $FAQData{$Field} = $Self->{LayoutObject}->Ascii2Html(
            NewLine        => 0,
            Text           => $FAQData{$Field},
            VMax           => 5000,
            HTMLResultMode => 1,
            LinkFeature    => 1,
        );
    }

    # get user info (CreatedBy)
    my %UserInfo = $Self->{UserObject}->GetUserData(
        UserID => $FAQData{CreatedBy}
    );
    $Param{CreatedByUser} = "$UserInfo{UserFirstname} $UserInfo{UserLastname}";

    # get user info (ChangedBy)
    %UserInfo = $Self->{UserObject}->GetUserData(
        UserID => $FAQData{ChangedBy}
    );
    $Param{ChangedByUser} = "$UserInfo{UserFirstname} $UserInfo{UserLastname}";

    # set voting results
    $Param{VotingResultColor} = $Self->{LayoutObject}->GetFAQItemVotingRateColor(
        Rate => $FAQData{VoteResult},
    );

    if ( !$Param{VotingResultColor} || $FAQData{Votes} eq '0' ) {
        $Param{VotingResultColor} = 'Gray';
    }

    if ( $Nav ne 'None' ) {

        # run FAQ menu modules
        if ( ref $Self->{ConfigObject}->Get('FAQ::Frontend::MenuModule') eq 'HASH' ) {
            my %Menus   = %{ $Self->{ConfigObject}->Get('FAQ::Frontend::MenuModule') };
            my $Counter = 0;
            for my $Menu ( sort keys %Menus ) {

                # load module
                if ( $Self->{MainObject}->Require( $Menus{$Menu}->{Module} ) ) {
                    my $Object = $Menus{$Menu}->{Module}->new(
                        %{$Self},
                        ItemID => $FAQData{ItemID},
                    );

                    # set classes
                    if ( $Menus{$Menu}->{Target} ) {

                        if ( $Menus{$Menu}->{Target} eq 'PopUp' ) {
                            $Menus{$Menu}->{Class} = 'AsPopup';
                        }
                        elsif ( $Menus{$Menu}->{Target} eq 'Back' ) {
                            $Menus{$Menu}->{Class} = 'HistoryBack';
                        }
                        elsif ( $Menus{$Menu}->{Target} eq 'ConfirmationDialog' ) {
                            $Menus{$Menu}->{Class} = 'AsConfirmationDialog';
                        }

                    }

                    # run module
                    $Counter = $Object->Run(
                        %Param,
                        FAQItem => {%FAQData},
                        Counter => $Counter,
                        Config  => $Menus{$Menu},
                        MenuID  => 'Menu' . $Menu,
                    );
                }
                else {
                    return $Self->{LayoutObject}->FatalError();
                }
            }
        }
    }

    # output approval state
    if ( $Self->{ConfigObject}->Get('FAQ::ApprovalRequired') ) {
        $Param{Approval} = $FAQData{Approved} ? 'Yes' : 'No';
        $Self->{LayoutObject}->Block(
            Name => 'ViewApproval',
            Data => {%Param},
        );
    }

    if ( $Self->{Voting} ) {

        # output votes number if any
        if ( $FAQData{Votes} ) {
            $Self->{LayoutObject}->Block(
                Name => 'ViewVotes',
                Data => {%FAQData},
            );
        }

        # otherwise display a No Votes found message
        else {
            $Self->{LayoutObject}->Block( Name => 'ViewNoVotes' );
        }
    }

    # show FAQ path
    my $ShowFAQPath = $Self->{LayoutObject}->FAQPathShow(
        FAQObject  => $Self->{FAQObject},
        CategoryID => $FAQData{CategoryID},
        UserID     => $Self->{UserID},
        Nav        => $Nav,
    );
    if ($ShowFAQPath) {
        $Self->{LayoutObject}->Block(
            Name => 'FAQPathItemElement',
            Data => {%FAQData},
            Nav  => $Nav,
        );
    }

    # show keywords as search links
    if ( $FAQData{Keywords} ) {

        # replace commas and semicolons
        $FAQData{Keywords} =~ s/,/ /g;
        $FAQData{Keywords} =~ s/;/ /g;

        my @Keywords = split /\s+/, $FAQData{Keywords};
        for my $Keyword (@Keywords) {
            $Self->{LayoutObject}->Block(
                Name => 'Keywords',
                Data => {
                    Keyword => $Keyword,
                },
            );
        }
    }

    # show languages
    if ( $Self->{MultiLanguage} ) {
        $Self->{LayoutObject}->Block(
            Name => 'Language',
            Data => {
                %FAQData,
            },
        );
    }

    # output rating stars
    if ( $Self->{Voting} ) {
        $Self->{LayoutObject}->FAQRatingStarsShow(
            VoteResult => $FAQData{VoteResult},
            Votes      => $FAQData{Votes},
        );
    }
    if ( $Nav ne 'None' ) {

        # output existing attachments
        my @AttachmentIndex = $Self->{FAQObject}->AttachmentIndex(
            ItemID     => $GetParam{ItemID},
            ShowInline => 0,
            UserID     => $Self->{UserID},
        );

        # output header and all attachments
        if (@AttachmentIndex) {
            $Self->{LayoutObject}->Block(
                Name => 'AttachmentHeader',
            );
            for my $Attachment (@AttachmentIndex) {
                $Self->{LayoutObject}->Block(
                    Name => 'AttachmentRow',
                    Data => {
                        %FAQData,
                        %{$Attachment},
                    },
                );
            }
        }
    }

    # show message about links in iframes, if user didn't close it already
    if ( !$Self->{DoNotShowBrowserLinkMessage} ) {
        $Self->{LayoutObject}->Block(
            Name => 'BrowserLinkMessage',
        );
    }

    # show FAQ Content
    my $FAQBody = $Self->{LayoutObject}->FAQContentShow(
        FAQObject       => $Self->{FAQObject},
        InterfaceStates => $Self->{InterfaceStates},
        FAQData         => {%FAQData},
        UserID          => $Self->{UserID},
        ReturnContent   => 1,
    );

    # cycle trough the activated Dynamic Fields for faq object
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        # get print string for this dynamic field
        my $ValueStrg = $Self->{BackendObject}->DisplayValueRender(
            DynamicFieldConfig => $DynamicFieldConfig,
            Value              => $FAQData{ 'DynamicField_' . $DynamicFieldConfig->{Name} },
            ValueMaxChars      => 250,
            LayoutObject       => $Self->{LayoutObject},
        );

        my $Label = $DynamicFieldConfig->{Label};

        $Self->{LayoutObject}->Block(
            Name => 'FAQDynamicField',
            Data => {
                Label => $Label,
            },
        );

        if ( $ValueStrg->{Link} ) {
            $Self->{LayoutObject}->Block(
                Name => 'FAQDynamicFieldLink',
                Data => {
                    Value                       => $ValueStrg->{Value},
                    Title                       => $ValueStrg->{Title},
                    Link                        => $ValueStrg->{Link},
                    $DynamicFieldConfig->{Name} => $ValueStrg->{Title},
                },
            );
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'FAQDynamicFieldPlain',
                Data => {
                    Value => $ValueStrg->{Value},
                    Title => $ValueStrg->{Title},
                },
            );
        }

        # example of dynamic fields order customization
        $Self->{LayoutObject}->Block(
            Name => 'FAQDynamicField_' . $DynamicFieldConfig->{Name},
            Data => {
                Label => $Label,
            },
        );

        $Self->{LayoutObject}->Block(
            Name => 'FAQDynamicField_' . $DynamicFieldConfig->{Name} . '_Plain',
            Data => {
                Value => $ValueStrg->{Value},
                Title => $ValueStrg->{Title},
            },
        );
    }

    if ( $Nav ne 'None' ) {

        # show FAQ Voting
        if ( $Self->{Voting} ) {

            # get voting config
            my $ShowVotingConfig = $Self->{ConfigObject}->Get('FAQ::Item::Voting::Show');
            if ( $ShowVotingConfig->{ $Self->{Interface}->{Name} } ) {

                # check if the user already voted after last change
                if ( !$AlreadyVoted ) {
                    $Self->_FAQVoting( FAQData => {%FAQData} );
                }
            }
        }

        # get linked objects
        my $LinkListWithData = $Self->{LinkObject}->LinkListWithData(
            Object => 'FAQ',
            Key    => $GetParam{ItemID},
            State  => 'Valid',
            UserID => $Self->{UserID},
        );

        # get link table view mode
        my $LinkTableViewMode = $Self->{ConfigObject}->Get('LinkObject::ViewMode');

        # create the link table
        my $LinkTableStrg = $Self->{LayoutObject}->LinkObjectTableCreate(
            LinkListWithData => $LinkListWithData,
            ViewMode         => $LinkTableViewMode,
        );

        # output the link table
        if ($LinkTableStrg) {
            $Self->{LayoutObject}->Block(
                Name => 'LinkTable' . $LinkTableViewMode,
                Data => {
                    LinkTableStrg => $LinkTableStrg,
                },
            );
        }
    }

    # log access to this FAQ item
    $Self->{FAQObject}->FAQLogAdd(
        ItemID    => $Self->{ParamObject}->GetParam( Param => 'ItemID' ),
        Interface => $Self->{Interface}->{Name},
        UserID    => $Self->{UserID},
    );

    # start template output
    if ( $Nav && $Nav eq 'None' ) {

        # only convert HTML to plain text if rich text editor is not used
        if ( $Self->{ConfigObject}->Get('Frontend::RichText') ) {
            $FAQData{FullBody} = $FAQBody;
        }
        else {
            $FAQData{FullBody} = $Self->{LayoutObject}->{HTMLUtilsObject}->ToAscii(
                String => $FAQBody,
            );
        }

        # get the public state type
        my $PublicStateType = $Self->{FAQObject}->StateTypeGet(
            Name   => 'public',
            UserID => $Self->{UserID},
        );

        # remove in-line image links to FAQ images
        $FAQData{FullBody}
            =~ s{ <img [^<>]+ Action=(Agent|Customer|Public)FAQ [^<>]+ > }{}gxms;

        # get configuration options for Ticket Compose
        my $TicketComposeConfig = $Self->{ConfigObject}->Get('FAQ::TicketCompose');

        $Param{UpdateArticleSubject} = $TicketComposeConfig->{UpdateArticleSubject} || 0;
        if ( $Param{UpdateArticleSubject} ) {
            $Self->{LayoutObject}->Block(
                Name => 'UpdateArticleSubject',
                Data => {},
            );
        }

        my $ShowOrBlock;

        # show "Insert Text" button
        if ( $TicketComposeConfig->{ShowInsertTextButton} ) {
            if (
                defined $TicketComposeConfig->{InsertMethod}
                && $TicketComposeConfig->{InsertMethod} eq 'Full'
                )
            {
                $Self->{LayoutObject}->Block(
                    Name => 'InsertFull',
                    Data => {},
                );
            }
            else {
                $Self->{LayoutObject}->Block(
                    Name => 'InsertText',
                    Data => {},
                );
            }

            $ShowOrBlock = 1;
        }

        # check if FAQ article is public
        if ( $FAQData{StateTypeID} == $PublicStateType->{StateID} ) {

            my $HTTPType = $Self->{ConfigObject}->Get('HttpType');
            my $FQDN     = $Self->{ConfigObject}->Get('FQDN');
            my $Baselink = $Self->{LayoutObject}->{Baselink};

            # rewrite handle
            $Baselink
                =~ s{ index[.]pl [?] }{public.pl?}gxms;

            $FAQData{Publiclink} = $HTTPType . '://' . $FQDN . $Baselink
                . "Action=PublicFAQZoom;ItemID=$FAQData{ItemID}";

            # show "Insert Link" button
            if ( $TicketComposeConfig->{ShowInsertLinkButton} ) {
                $Self->{LayoutObject}->Block(
                    Name => 'InsertLink',
                    Data => {},
                );
                $ShowOrBlock = 1;
            }

            # show "Insert Text and Link" button
            if ( $TicketComposeConfig->{ShowInsertTextAndLinkButton} ) {
                if (
                    defined $TicketComposeConfig->{InsertMethod}
                    && $TicketComposeConfig->{InsertMethod} eq 'Full'
                    )
                {
                    $Self->{LayoutObject}->Block(
                        Name => 'InsertFullAndLink',
                        Data => {},
                    );
                }
                else {
                    $Self->{LayoutObject}->Block(
                        Name => 'InsertTextAndLink',
                        Data => {},
                    );
                }
                $ShowOrBlock = 1
            }
        }

        my $CancelButtonClass = 'ZoomSmallButton';

        # show the "Or" block between the buttons and the Cancel & close window label
        if ($ShowOrBlock) {
            $Self->{LayoutObject}->Block(
                Name => 'Or',
                Data => {},
            );

            # set the $CancelButtonClass to '';
            $CancelButtonClass = '';
        }

        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentFAQZoomSmall',
            Data         => {
                %FAQData,
                %GetParam,
                %Param,
                CancelButtonClass => $CancelButtonClass || '',
            },
        );
    }
    else {
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentFAQZoom',
            Data         => {
                %FAQData,
                %GetParam,
                %Param,
            },
        );
    }

    # add footer
    if ( $Nav && $Nav eq 'None' ) {
        $Output .= $Self->{LayoutObject}->Footer( Type => 'Small' );
    }
    else {
        $Output .= $Self->{LayoutObject}->Footer();
    }

    return $Output;
}

sub _FAQVoting {
    my ( $Self, %Param ) = @_;

    my %FAQData = %{ $Param{FAQData} };

    # output voting block
    $Self->{LayoutObject}->Block(
        Name => 'FAQVoting',
        Data => {%FAQData},
    );

    # get Voting rates setting
    my $VotingRates = $Self->{ConfigObject}->Get('FAQ::Item::Voting::Rates');
    for my $RateValue ( sort { $a <=> $b } keys %{$VotingRates} ) {

        # create data structure for output
        my %Data = (
            Value => $RateValue,
            Title => $VotingRates->{$RateValue},
        );

        # output vote rating row block
        $Self->{LayoutObject}->Block(
            Name => 'FAQVotingRateRow',
            Data => {%Data},
        );
    }
}

1;
