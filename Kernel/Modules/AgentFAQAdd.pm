# --
# Kernel/Modules/AgentFAQAdd.pm - agent frontend to add faq articles
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: AgentFAQAdd.pm,v 1.4 2010-11-12 19:04:33 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentFAQAdd;

use strict;
use warnings;

use Kernel::System::FAQ;
use Kernel::System::Web::UploadCache;
use Kernel::System::Valid;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.4 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for my $Object (qw(ParamObject DBObject LayoutObject ConfigObject LogObject)) {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Object!" );
        }
    }

    # create needed objects
    $Self->{FAQObject}         = Kernel::System::FAQ->new(%Param);
    $Self->{UploadCacheObject} = Kernel::System::Web::UploadCache->new(%Param);
    $Self->{ValidObject}       = Kernel::System::Valid->new(%Param);

    # get config of frontend module
    $Self->{Config} = $Self->{ConfigObject}->Get("FAQ::Frontend::$Self->{Action}") || '';

    # get form id
    $Self->{FormID} = $Self->{ParamObject}->GetParam( Param => 'FormID' );

    # create form id
    if ( !$Self->{FormID} ) {
        $Self->{FormID} = $Self->{UploadCacheObject}->FormIDCreate();
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # permission check
    if ( !$Self->{AccessRw} ) {
        return $Self->{LayoutObject}->NoPermission(
            Message    => 'You need rw permission!',
            WithHeader => 'yes',
        );
    }

    # get parameters
    my %GetParam;
    for my $ParamName (
        qw(Title CategoryID StateID LanguageID ValidID Keywords Approved Field1 Field2 Field3 Field4 Field5 Field6 )
        )
    {
        $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
    }

    # ------------------------------------------------------------ #
    # show the faq add screen
    # ------------------------------------------------------------ #
    if ( !$Self->{Subaction} ) {

        # header
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # TODO
        # find out the category id of the last viewed category
        # get it from the session, the Exlorer must write it there
        # and give it to the _MaskNew function

        # html output
        $Output .= $Self->_MaskNew(
            %Param,
            FormID => $Self->{FormID},
        );

        # footer
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # save the faq
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Save' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # header
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # check required parameters
        my %Error;
        for my $ParamName (qw(Title CategoryID)) {

            # if required field is not given, add server error class
            if ( !$GetParam{$ParamName} ) {
                $Error{ $ParamName . 'ServerError' } = 'ServerError';
            }
        }

        # check if an attachment must be deleted
        ATTACHMENT:
        for my $Count ( 1 .. 32 ) {

            # check if the delete button was pressed for this attachment
            my $Delete = $Self->{ParamObject}->GetParam( Param => "AttachmentDelete$Count" );

            # check next attachment if it was not pressed
            next ATTACHMENT if !$Delete;

            # remember that we need to show the page again
            $Error{Attachment} = 1;

            # remove the attachment from the upload cache
            $Self->{UploadCacheObject}->FormIDRemoveFile(
                FormID => $Self->{FormID},
                FileID => $Count,
            );
        }

        # check if there was an attachment upload
        if ( $Self->{ParamObject}->GetParam( Param => 'AttachmentUpload' ) ) {

            # remember that we need to show the page again
            $Error{Attachment} = 1;

            # get the uploaded attachment
            my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
                Param  => 'FileUpload',
                Source => 'string',
            );

            # add attachment to the upload cache
            $Self->{UploadCacheObject}->FormIDAddFile(
                FormID => $Self->{FormID},
                %UploadStuff,
            );
        }

        # send server error if any required parameter is missing
        # or an attachment was deleted or uploaded
        if (%Error) {

            # if there was an attachment delete or upload
            # we do not want to show validation errors for other fields
            if ( $Error{Attachment} ) {
                %Error = ();
            }

            # get all attachments meta data
            my @Attachments = $Self->{UploadCacheObject}->FormIDGetAllFilesMeta(
                FormID => $Self->{FormID},
            );

            # TODO: remove debug code!
            # $Self->{LogObject}->Dum_per( '', '@Attachments', \@Attachments );

            # html output
            $Output .= $Self->_MaskNew(
                Attachments => \@Attachments,
                %GetParam,
                %Error,
                FormID => $Self->{FormID},
            );

            # footer
            $Output .= $Self->{LayoutObject}->Footer();

            return $Output;
        }

        # add the new faq article
        my $FAQID = $Self->{FAQObject}->FAQAdd(
            %GetParam,
            UserID => $Self->{UserID},
        );

        # show error if faq could not be added
        if ( !$FAQID ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        # get all attachments from upload cache
        my @Attachments = $Self->{UploadCacheObject}->FormIDGetAllFilesData(
            FormID => $Self->{FormID},
        );

        # write attachments
        for my $Attachment (@Attachments) {

            # TODO: rewrite this for FAQ

            #            # skip, deleted not used inline images
            #            my $ContentID = $Attachment->{ContentID};
            #            if ($ContentID) {
            #                my $ContentIDHTMLQuote = $Self->{LayoutObject}->Ascii2Html(
            #                    Text => $ContentID,
            #                );
            #                next if $GetParam{Body} !~ /(\Q$ContentIDHTMLQuote\E|\Q$ContentID\E)/i;
            #            }

            # check if attachment is an inline attachment
            my $Inline = 0;
            if ( $Attachment->{ContentID} ) {
                $Inline = 1;
            }

            # add attachment
            my $Success = $Self->{FAQObject}->AttachmentAdd(
                %{$Attachment},
                ItemID => $FAQID,
                Inline => $Inline,
                UserID => $Self->{UserID},
            );

            # check error
            if ( !$Success ) {
                return $Self->{LayoutObject}->FatalError();
            }
        }

        # remove pre submited attachments
        $Self->{UploadCacheObject}->FormIDRemove( FormID => $Self->{FormID} );

        # TODO: Replace with AgentFAQExplorer
        # redirect to FAQ explorer
        return $Self->{LayoutObject}->Redirect( OP => 'Action=AgentFAQZoom;ItemID=' . $FAQID );
    }
}

sub _MaskNew {
    my ( $Self, %Param ) = @_;

    # show action list
    $Self->{LayoutObject}->Block( Name => 'ActionList' );
    $Self->{LayoutObject}->Block( Name => 'ActionOverview' );

    # get valid list
    my %ValidList        = $Self->{ValidObject}->ValidList();
    my %ValidListReverse = reverse %ValidList;

    my %Data;

    # build valid selection
    $Data{ValidOption} = $Self->{LayoutObject}->BuildSelection(
        Data       => \%ValidList,
        Name       => 'ValidID',
        SelectedID => $Param{ValidID} || $ValidListReverse{valid},
    );

    # get categories (with category long names) where user has rights
    my $UserCategoriesLongNames = $Self->{FAQObject}->GetUserCategoriesLongNames(
        Type   => 'rw',
        UserID => $Self->{UserID},
    );

    # set no server error class as default
    $Param{CategoryIDServerError} ||= '';

    # build category selection
    $Data{CategoryOption} = $Self->{LayoutObject}->BuildSelection(
        Data         => $UserCategoriesLongNames,
        Name         => 'CategoryID',
        SelectedID   => $Param{CategoryID},
        PossibleNone => 1,
        Class        => 'Validate_RequiredDropdown ' . $Param{CategoryIDServerError},
        Translation  => 0,
    );

    # get the language list
    my %Languages = $Self->{FAQObject}->LanguageList(
        UserID => $Self->{UserID},
    );

    # get the selected language
    my $SelectedLanguage;
    if ( $Param{LanguageID} && $Languages{ $Param{LanguageID} } ) {

        # get language from given language id
        $SelectedLanguage = $Languages{ $Param{LanguageID} };
    }
    else {

        # use the user language, or if not found 'en'
        $SelectedLanguage = $Self->{LayoutObject}->{UserLanguage} || 'en';
    }

    # build the language selection
    $Data{LanguageOption} = $Self->{LayoutObject}->BuildSelection(
        Data          => \%Languages,
        Name          => 'LanguageID',
        SelectedValue => $SelectedLanguage,
        Translation   => 0,
    );

    # get the states list
    my %States = $Self->{FAQObject}->StateList(
        UserID => $Self->{UserID},
    );

    # get the selected state
    my $SelectedState;
    if ( $Param{StateID} && $States{ $Param{StateID} } ) {

        # get state from given state id
        $SelectedState = $States{ $Param{StateID} };
    }
    else {

        # get default state
        $SelectedState = $Self->{ConfigObject}->Get('FAQ::Default::State') || 'internal (agent)';
    }

    # build the state selection
    $Data{StateOption} = $Self->{LayoutObject}->BuildSelection(
        Data          => \%States,
        Name          => 'StateID',
        SelectedValue => $SelectedState,
        Translation   => 1,
    );

    # show faq add screen
    $Self->{LayoutObject}->Block(
        Name => 'FAQAdd',
        Data => {
            %Param,
            %Data,
        },
    );

    # show approval field
    if ( $Self->{ConfigObject}->Get('FAQ::ApprovalRequired') ) {

        # check permission
        my %Groups = reverse $Self->{GroupObject}->GroupMemberList(
            UserID => $Self->{UserID},
            Type   => 'ro',
            Result => 'HASH',
        );

        # get the faq approval group from config
        my $ApprovalGroup = $Self->{ConfigObject}->Get('FAQ::ApprovalGroup') || '';

        # build the approval selection if there is an approval group
        if ( exists $Groups{$ApprovalGroup} ) {

            $Data{ApprovalOption} = $Self->{LayoutObject}->BuildSelection(
                Name => 'Approved',
                Data => {
                    0 => 'No',
                    1 => 'Yes',
                },
                SelectedID => $Param{Approved} || 0,
            );
            $Self->{LayoutObject}->Block(
                Name => 'Approval',
                Data => {%Data},
            );
        }
    }

    # show the attachment upload button
    $Self->{LayoutObject}->Block(
        Name => 'AttachmentUpload',
        Data => {%Param},
    );

    # show attachments
    ATTACHMENT:
    for my $Attachment ( @{ $Param{Attachments} } ) {

        # do not show inline images as attachments
        # (they have a content id)
        if ( $Attachment->{ContentID} && $Self->{LayoutObject}->{BrowserRichText} ) {
            next ATTACHMENT;
        }

        $Self->{LayoutObject}->Block(
            Name => 'Attachment',
            Data => $Attachment,
        );
    }

    # add rich text editor javascript (in general)
    # only if activated and the browser can handle it
    # otherwise just a textarea is shown
    if ( $Self->{LayoutObject}->{BrowserRichText} ) {
        $Self->{LayoutObject}->Block(
            Name => 'RichText',
            Data => {%Param},
        );
    }

    # get the config of faq fields that should be shown
    my %ItemFields;
    FIELD:
    for my $Count ( 1 .. 6 ) {

        # get config of FAQ field
        my $ItemConfig = $Self->{ConfigObject}->Get( 'FAQ::Item::Field' . $Count );

        # skip over not shown fields
        next FIELD if !$ItemConfig->{Show};

        # store only the config of fields that should be shown
        $ItemFields{ "Field" . $Count } = $ItemConfig;
    }

    # sort shown fields by priority
    for my $Field ( sort { $ItemFields{$a}->{Prio} <=> $ItemFields{$b}->{Prio} } keys %ItemFields )
    {

        # get the state type data of this field
        my $StateTypeData = $Self->{FAQObject}->StateTypeGet(
            Name   => $ItemFields{$Field}->{Show},
            UserID => $Self->{UserID},
        );

        # show the field
        $Self->{LayoutObject}->Block(
            Name => 'FAQItemField',
            Data => {
                Field     => $Field,
                Caption   => $ItemFields{$Field}->{'Caption'},
                StateName => $StateTypeData->{Name},
                Content   => $Param{$Field} || '',
            },
        );
    }

    # generate output
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentFAQAdd',
        Data         => \%Param,
    );
}

1;
