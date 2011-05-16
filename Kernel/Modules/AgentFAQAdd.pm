# --
# Kernel/Modules/AgentFAQAdd.pm - agent frontend to add faq articles
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: AgentFAQAdd.pm,v 1.20 2011-05-16 15:57:53 ub Exp $
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
$VERSION = qw($Revision: 1.20 $) [1];

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

    # set default interface settings
    $Self->{Interface} = $Self->{FAQObject}->StateTypeGet(
        Name   => 'internal',
        UserID => $Self->{UserID},
    );
    $Self->{InterfaceStates} = $Self->{FAQObject}->StateTypeList(
        Types  => $Self->{ConfigObject}->Get('FAQ::Agent::StateTypes'),
        UserID => $Self->{UserID},
    );

    $Self->{MultiLanguage} = $Self->{ConfigObject}->Get('FAQ::MultiLanguage');

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

    # get categories (with category long names) where user has rights
    my $UserCategoriesLongNames = $Self->{FAQObject}->GetUserCategoriesLongNames(
        Type   => 'rw',
        UserID => $Self->{UserID},
    );

    # check that there are categories available for this user
    if (
        !$UserCategoriesLongNames
        || ref $UserCategoriesLongNames ne 'HASH'
        || !%{$UserCategoriesLongNames}
        )
    {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'No categories found where user has read/write permissions!',
            Comment => 'Please contact the admin.',
        );
    }

    # ------------------------------------------------------------ #
    # show the faq add screen
    # ------------------------------------------------------------ #
    if ( !$Self->{Subaction} ) {

        # header
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # html output
        $Output .= $Self->_MaskNew(
            FormID                  => $Self->{FormID},
            UserCategoriesLongNames => $UserCategoriesLongNames,

            # last viewed category from session (written by faq explorer)
            CategoryID => $Self->{LastViewedCategory},
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
        for my $Number ( 1 .. 32 ) {

            # check if the delete button was pressed for this attachment
            my $Delete = $Self->{ParamObject}->GetParam( Param => "AttachmentDelete$Number" );

            # check next attachment if it was not pressed
            next ATTACHMENT if !$Delete;

            # remember that we need to show the page again
            $Error{Attachment} = 1;

            # remove the attachment from the upload cache
            $Self->{UploadCacheObject}->FormIDRemoveFile(
                FormID => $Self->{FormID},
                FileID => $Number,
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

            # html output
            $Output .= $Self->_MaskNew(
                UserCategoriesLongNames => $UserCategoriesLongNames,
                Attachments             => \@Attachments,
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
        ATTACHMENT:
        for my $Attachment (@Attachments) {

            # check if attachment is an inline attachment
            my $Inline = 0;
            if ( $Attachment->{ContentID} ) {

                # remember that it is inline
                $Inline = 1;

                # remember if this inline attachment is used in any faq article
                my $ContentIDFound;

                # check all fields for content id
                FIELD:
                for my $Number ( 1 .. 6 ) {

                    # get faq field
                    my $Field = $GetParam{ 'Field' . $Number };

                    # skip empty fields
                    next FIELD if !$Field;

                    # skip fields that do not contain the content id
                    next FIELD if $Field !~ m{ $Attachment->{ContentID} }xms;

                    # found the content id
                    $ContentIDFound = 1;

                    # we do not need to search further
                    last FIELD;
                }

                # we do not want to keep this attachment,
                # because it was deleted in the richt text editor
                next ATTACHMENT if !$ContentIDFound;
            }

            # add attachment
            my $FileID = $Self->{FAQObject}->AttachmentAdd(
                %{$Attachment},
                ItemID => $FAQID,
                Inline => $Inline,
                UserID => $Self->{UserID},
            );

            # check error
            if ( !$FileID ) {
                return $Self->{LayoutObject}->FatalError();
            }

            next ATTACHMENT if !$Inline;
            next ATTACHMENT if !$Self->{LayoutObject}->{BrowserRichText};

            # rewrite the URLs of the inline images for the uploaded pictures
            my $Ok = $Self->{FAQObject}->FAQInlineAttachmentURLUpdate(
                Attachment => $Attachment,
                FormID     => $Self->{FormID},
                ItemID     => $FAQID,
                FileID     => $FileID,
                UserID     => $Self->{UserID},
            );

            # check error
            if ( !$Ok ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "Could not update the inline image URLs "
                        . "for FAQ Item# '$FAQID'!",
                );
            }
        }

        # delete the upload cache
        $Self->{UploadCacheObject}->FormIDRemove( FormID => $Self->{FormID} );

        # redirect to FAQ zoom
        return $Self->{LayoutObject}->Redirect( OP => 'Action=AgentFAQZoom;ItemID=' . $FAQID );
    }
}

sub _MaskNew {
    my ( $Self, %Param ) = @_;

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

    # set no server error class as default
    $Param{CategoryIDServerError} ||= '';

    # build category selection
    $Data{CategoryOption} = $Self->{LayoutObject}->BuildSelection(
        Data         => $Param{UserCategoriesLongNames},
        Name         => 'CategoryID',
        SelectedID   => $Param{CategoryID},
        PossibleNone => 1,
        Class        => 'Validate_Required ' . $Param{CategoryIDServerError},
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

        # get user language ID
        my $SelectedLanguageID = $Self->{FAQObject}->LanguageLookup( Name => $SelectedLanguage );

        # check if LanduageID does not exsits
        if ( !$SelectedLanguageID ) {

            # get the lowest language ID
            my @LanguageIDs = sort keys %Languages;
            $SelectedLanguageID = $LanguageIDs[0];

            # set the language with lowest language ID as selected language
            $SelectedLanguage = $Languages{$SelectedLanguageID};
        }
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

    # show languages field
    if ( $Self->{MultiLanguage} ) {
        $Self->{LayoutObject}->Block(
            Name => 'Language',
            Data => {
                %Param,
                %Data,
            },
        );
    }
    else {

        # get default language
        my $DefaultLanguage
            = $Self->{ConfigObject}->Get('FAQ::Default::Language') || 'en';

        # get default language ID
        my $LanguageID = $Self->{FAQObject}->LanguageLookup(
            Name => $DefaultLanguage,
        );

        # create default language if it was deleted or does not exists
        if ( !$LanguageID ) {
            my $InsertLanguage = $Self->{FAQObject}->LanguageAdd(
                Name   => $DefaultLanguage,
                UserID => 1,
            );

            if ( !$InsertLanguage ) {

                # return with error screen
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "No default language found and can't create a new one.",
                    Comment => 'Please contact the admin.',
                );
            }

            # get default language ID
            $LanguageID = $Self->{FAQObject}->LanguageLookup(
                Name => $DefaultLanguage,
            );
        }

        $Param{LanguageID} = $LanguageID;

        $Self->{LayoutObject}->Block(
            Name => 'NoLanguage',
            Data => {
                %Param,
                %Data,
            },
        );
    }

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

        # build the approval selection if user is in the approval group
        if ( $Groups{$ApprovalGroup} ) {

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

    # add rich text editor javascript
    # only if activated and the browser can handle it
    # otherwise just a textarea is shown
    if ( $Self->{LayoutObject}->{BrowserRichText} ) {
        $Self->{LayoutObject}->Block(
            Name => 'RichText',
            Data => {%Param},
        );
    }

    # show FAQ Content
    $Self->{LayoutObject}->FAQContentShow(
        FAQObject       => $Self->{FAQObject},
        InterfaceStates => $Self->{InterfaceStates},
        FAQData         => {%Param},
        UserID          => $Self->{UserID},
    );

    # generate output
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentFAQAdd',
        Data         => \%Param,
    );
}

1;
