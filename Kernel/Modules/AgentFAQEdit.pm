# --
# Kernel/Modules/AgentFAQEdit.pm - agent frontend to edit FAQ articles
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentFAQEdit;

use strict;
use warnings;

use Kernel::System::FAQ;
use Kernel::System::Queue;
use Kernel::System::Web::UploadCache;
use Kernel::System::Valid;
use Kernel::System::DynamicField;
use Kernel::System::DynamicField::Backend;
use Kernel::System::VariableCheck qw(:all);

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
    $Self->{FAQObject}          = Kernel::System::FAQ->new(%Param);
    $Self->{UploadCacheObject}  = Kernel::System::Web::UploadCache->new(%Param);
    $Self->{ValidObject}        = Kernel::System::Valid->new(%Param);
    $Self->{QueueObject}        = Kernel::System::Queue->new(%Param);
    $Self->{DynamicFieldObject} = Kernel::System::DynamicField->new(%Param);
    $Self->{BackendObject}      = Kernel::System::DynamicField::Backend->new(%Param);

    # get config of frontend module
    $Self->{Config} = $Self->{ConfigObject}->Get("FAQ::Frontend::$Self->{Action}") || '';

    # get form id
    $Self->{FormID} = $Self->{ParamObject}->GetParam( Param => 'FormID' );

    # create form id
    if ( !$Self->{FormID} ) {
        $Self->{FormID} = $Self->{UploadCacheObject}->FormIDCreate();
    }

    # get screen type
    $Self->{ScreenType} = $Self->{ParamObject}->GetParam( Param => 'ScreenType' ) || '';

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

    # get the dynamic fields for this screen
    $Self->{DynamicField} = $Self->{DynamicFieldObject}->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => 'FAQ',
        FieldFilter => $Self->{Config}->{DynamicField} || {},
    );

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
        qw(ItemID Title CategoryID StateID LanguageID ValidID Keywords Approved Field1 Field2 Field3 Field4 Field5 Field6)
        )
    {
        $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
    }

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

    # check error
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

    # get dynamic field values form http request
    my %DynamicFieldValues;

    # cycle trough the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        # extract the dynamic field value form the web request
        $DynamicFieldValues{ $DynamicFieldConfig->{Name} } = $Self->{BackendObject}->EditFieldValueGet(
            DynamicFieldConfig => $DynamicFieldConfig,
            ParamObject        => $Self->{ParamObject},
            LayoutObject       => $Self->{LayoutObject},
        );
    }

    # ------------------------------------------------------------ #
    # show the FAQ edit screen
    # ------------------------------------------------------------ #
    if ( !$Self->{Subaction} ) {

        my $Output;

        # show a pop-up screen
        if ( $Self->{ScreenType} eq 'Popup' ) {

            # show the small pop-up screen header
            $Output = $Self->{LayoutObject}->Header(
                Type      => 'Small',
                BodyClass => 'Popup',
            );

            $Self->{LayoutObject}->Block(
                Name => 'StartSmall',
                Data => {
                    %FAQData,
                },
            );
        }

        # show a normal window
        else {

            # show the normal screen header with navigation bar
            $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();

            $Self->{LayoutObject}->Block(
                Name => 'StartNormal',
                Data => {
                    %FAQData,
                },
            );
        }

        # get all existing attachments (without inline attachments)
        my @ExistingAttachments = $Self->{FAQObject}->AttachmentIndex(
            ItemID     => $GetParam{ItemID},
            ShowInline => 0,
            UserID     => $Self->{UserID},
        );

        # copy all existing attachments to upload cache
        for my $Attachment (@ExistingAttachments) {

            # get the existing attachment data
            my %File = $Self->{FAQObject}->AttachmentGet(
                ItemID => $GetParam{ItemID},
                FileID => $Attachment->{FileID},
                UserID => $Self->{UserID},
            );

            # get content disposition (if its an inline attachment)
            my $Disposition = $Attachment->{Inline} ? 'inline' : '';

            # add attachment to the upload cache
            $Self->{UploadCacheObject}->FormIDAddFile(
                FormID      => $Self->{FormID},
                Filename    => $File{Filename},
                Content     => $File{Content},
                ContentType => $File{ContentType},
                Disposition => $Disposition,
            );
        }

        # get all attachments meta data from upload cache
        my @Attachments = $Self->{UploadCacheObject}->FormIDGetAllFilesMeta(
            FormID => $Self->{FormID},
        );

        # rewrite old style inline image URLs
        FIELD:
        for my $Field (qw(Field1 Field2 Field3 Field4 Field5 Field6)) {

            next FIELD if !$FAQData{$Field};

            # rewrite handle and action, take care of old style before FAQ 2.0.x
            $FAQData{$Field} =~ s{
                Action=AgentFAQ [&](amp;)? Subaction=Download [&](amp;)?
            }{Action=AgentFAQZoom;Subaction=DownloadAttachment;}gxms;
        }

        # create HTML strings for all dynamic fields
        my %DynamicFieldHTML;

        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            # to store dynamic field value from database (or undefined)
            my $Value = $FAQData{ 'DynamicField_' . $DynamicFieldConfig->{Name} };

            # get field HTML
            $DynamicFieldHTML{ $DynamicFieldConfig->{Name} } =
                $Self->{BackendObject}->EditFieldRender(
                DynamicFieldConfig => $DynamicFieldConfig,
                Value              => $Value,
                Mandatory =>
                    $Self->{Config}->{DynamicField}->{ $DynamicFieldConfig->{Name} } == 2,
                LayoutObject => $Self->{LayoutObject},
                ParamObject  => $Self->{ParamObject},
                );
        }

        if ( $Self->{ConfigObject}->Get('FAQ::ApprovalRequired') ) {

            # get Approval queue name
            my $ApprovalQueue = $Self->{ConfigObject}->Get('FAQ::ApprovalQueue') || '';

            # check if Approval queue exists
            my $ApprovalQueueID = $Self->{QueueObject}->QueueLookup( Queue => $ApprovalQueue );

            # show notification if Approval queue does not exists
            if ( !$ApprovalQueueID ) {
                $Output .= $Self->{LayoutObject}->Notify(
                    Priority => 'Error',
                    Info     => "FAQ Approval is enabled but queue '$ApprovalQueue' does not exists",
                    Link     => $Self->{LayoutObject}->{Baselink}
                        . 'Action=AdminSysConfig;Subaction=Edit;'
                        . 'SysConfigSubGroup=Core%3A%3AApproval;SysConfigGroup=FAQ',
                );
            }
        }

        # HTML output
        $Output .= $Self->_MaskNew(
            %FAQData,
            Attachments      => \@Attachments,
            ScreenType       => $Self->{ScreenType},
            FormID           => $Self->{FormID},
            DynamicFieldHTML => \%DynamicFieldHTML,
        );

        # show a pop-up screen footer
        if ( $Self->{ScreenType} eq 'Popup' ) {

            $Self->{LayoutObject}->Block(
                Name => 'EndSmall',
                Data => {},
            );

            $Output .= $Self->{LayoutObject}->Footer( Type => 'Small' );

        }

        # show a normal footer
        else {

            $Self->{LayoutObject}->Block(
                Name => 'EndNormal',
                Data => {},
            );

            $Output .= $Self->{LayoutObject}->Footer();
        }

        return $Output;
    }

    # ------------------------------------------------------------ #
    # save the FAQ
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Save' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $Output;

        # show a pop-up screen
        if ( $Self->{ScreenType} eq 'Popup' ) {

            # show the small pop-up screen header
            $Output = $Self->{LayoutObject}->Header(
                Type      => 'Small',
                BodyClass => 'Popup',
            );

            $Self->{LayoutObject}->Block(
                Name => 'StartSmall',
                Data => {
                    %FAQData,
                },
            );
        }

        # show a normal window
        else {

            # show the normal screen header with navigation bar
            $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();

            $Self->{LayoutObject}->Block(
                Name => 'StartNormal',
                Data => {
                    %FAQData,
                },
            );
        }

        # check required parameters
        my %Error;
        for my $ParamName (qw(Title CategoryID)) {

            # if required field is not given, add server error class
            if ( !$GetParam{$ParamName} ) {
                $Error{ $ParamName . 'ServerError' } = 'ServerError';
            }
        }

        # check if an attachment must be deleted
        my @AttachmentIDs = map {
            my ($ID) = $_ =~ m{ \A AttachmentDelete (\d+) \z }xms;
            $ID ? $ID : ();
        } $Self->{ParamObject}->GetParamNames();

        COUNT:
        for my $Count ( reverse sort @AttachmentIDs ) {

            # check if the delete button was pressed for this attachment
            my $Delete = $Self->{ParamObject}->GetParam( Param => "AttachmentDelete$Count" );

            # check next attachment if it was not pressed
            next COUNT if !$Delete;

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

        # create HTML strings for all dynamic fields
        my %DynamicFieldHTML;

        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            my $ValidationResult;

            # do not validate on attachment upload
            if ( !$Error{Attachment} ) {

                $ValidationResult = $Self->{BackendObject}->EditFieldValueValidate(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    ParamObject        => $Self->{ParamObject},
                    Mandatory =>
                        $Self->{Config}->{DynamicField}->{ $DynamicFieldConfig->{Name} } == 2,
                );

                if ( !IsHashRefWithData($ValidationResult) ) {
                    return $Self->{LayoutObject}->ErrorScreen(
                        Message =>
                            "Could not perform validation on field $DynamicFieldConfig->{Label}!",
                        Comment => 'Please contact the admin.',
                    );
                }

                # propagate validation error to the Error variable to be detected by the frontend
                if ( $ValidationResult->{ServerError} ) {
                    $Error{ $DynamicFieldConfig->{Name} } = ' ServerError';
                }
            }

            # get field HTML
            $DynamicFieldHTML{ $DynamicFieldConfig->{Name} } =
                $Self->{BackendObject}->EditFieldRender(
                DynamicFieldConfig => $DynamicFieldConfig,
                Mandatory =>
                    $Self->{Config}->{DynamicField}->{ $DynamicFieldConfig->{Name} } == 2,
                ServerError  => $ValidationResult->{ServerError}  || '',
                ErrorMessage => $ValidationResult->{ErrorMessage} || '',
                LayoutObject => $Self->{LayoutObject},
                ParamObject  => $Self->{ParamObject},
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
                FormID           => $Self->{FormID},
                DynamicFieldHTML => \%DynamicFieldHTML,
            );

            if ( $Self->{ConfigObject}->Get('FAQ::ApprovalRequired') ) {

                # get Approval queue name
                my $ApprovalQueue = $Self->{ConfigObject}->Get('FAQ::ApprovalQueue') || '';

                # check if Approval queue exists
                my $ApprovalQueueID = $Self->{QueueObject}->QueueLookup( Queue => $ApprovalQueue );

                # show notification if Approval queue does not exists
                if ( !$ApprovalQueueID ) {
                    $Output .= $Self->{LayoutObject}->Notify(
                        Priority => 'Error',
                        Info =>
                            "FAQ Approval is enabled but queue '$ApprovalQueue' does not exists",
                        Link => $Self->{LayoutObject}->{Baselink}
                            . 'Action=AdminSysConfig;Subaction=Edit;'
                            . 'SysConfigSubGroup=Core%3A%3AApproval;SysConfigGroup=FAQ',
                    );
                }
            }

            # HTML output
            $Output .= $Self->_MaskNew(
                Attachments => \@Attachments,
                %GetParam,
                %Error,
                ScreenType       => $Self->{ScreenType},
                FormID           => $Self->{FormID},
                DynamicFieldHTML => \%DynamicFieldHTML,
            );

            # show a pop-up screen footer
            if ( $Self->{ScreenType} eq 'Popup' ) {

                $Self->{LayoutObject}->Block(
                    Name => 'EndSmall',
                    Data => {},
                );

                $Output .= $Self->{LayoutObject}->Footer( Type => 'Small' );

            }

            # show a normal footer
            else {

                $Self->{LayoutObject}->Block(
                    Name => 'EndNormal',
                    Data => {},
                );

                $Output .= $Self->{LayoutObject}->Footer();
            }

            return $Output;
        }

        # update the new FAQ article
        my $UpdateSuccess = $Self->{FAQObject}->FAQUpdate(
            %GetParam,
            UserID => $Self->{UserID},
        );

        # show error if FAQ could not be updated
        if ( !$UpdateSuccess ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        # get all attachments from upload cache
        my @Attachments = $Self->{UploadCacheObject}->FormIDGetAllFilesData(
            FormID => $Self->{FormID},
        );

        # build a lookup lookup hash of the new attachments
        my %NewAttachment;
        for my $Attachment (@Attachments) {

            # the key is the filename + filesize + content type
            my $Key = $Attachment->{Filename}
                . $Attachment->{Filesize}
                . $Attachment->{ContentType};

            # append content id if available (for new inline images)
            if ( $Attachment->{ContentID} ) {
                $Key .= $Attachment->{ContentID};
            }

            # store all of the new attachment data
            $NewAttachment{$Key} = $Attachment;
        }

        # get all existing attachments, without inline attachments
        my @ExistingAttachments = $Self->{FAQObject}->AttachmentIndex(
            ItemID     => $GetParam{ItemID},
            ShowInline => 0,
            UserID     => $Self->{UserID},
        );

        # check the existing attachments
        ATTACHMENT:
        for my $Attachment (@ExistingAttachments) {

            # the key is the filename + filesize + content type
            # (no content id, as existing attachments don't have it)
            my $Key = $Attachment->{Filename}
                . $Attachment->{Filesize}
                . $Attachment->{ContentType};

            # attachment is already existing, we can delete it from the new attachment hash
            if ( $NewAttachment{$Key} ) {
                delete $NewAttachment{$Key};
            }

            # existing attachment is no longer in new attachments hash
            else {

                # delete the existing attachment
                my $DeleteSuccessful = $Self->{FAQObject}->AttachmentDelete(
                    ItemID => $GetParam{ItemID},
                    FileID => $Attachment->{FileID},
                    UserID => $Self->{UserID},
                );

                # check error
                if ( !$DeleteSuccessful ) {
                    return $Self->{LayoutObject}->FatalError();
                }
            }
        }

        # write the new attachments
        ATTACHMENT:
        for my $Attachment ( values %NewAttachment ) {

            # check if attachment is an inline attachment
            my $Inline = 0;
            if ( $Attachment->{ContentID} ) {

                # remember that it is inline
                $Inline = 1;

                # remember if this inline attachment is used in any FAQ article
                my $ContentIDFound;

                # check all fields for content id
                FIELD:
                for my $Number ( 1 .. 6 ) {

                    # get FAQ field
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
                # because it was deleted in the rich-text editor
                next ATTACHMENT if !$ContentIDFound;
            }

            # add attachment
            my $FileID = $Self->{FAQObject}->AttachmentAdd(
                %{$Attachment},
                ItemID => $GetParam{ItemID},
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
                ItemID     => $GetParam{ItemID},
                FileID     => $FileID,
                UserID     => $Self->{UserID},
            );

            # check error
            if ( !$Ok ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "Could not update the inline image URLs "
                        . "for FAQ Item# '$GetParam{ItemID}'!",
                );
            }
        }

        # delete the upload cache
        $Self->{UploadCacheObject}->FormIDRemove( FormID => $Self->{FormID} );

        # set dynamic fields
        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            # set the object ID depending on the field configuration
            my $ObjectID = $GetParam{ItemID};

            # set the value
            my $Success = $Self->{BackendObject}->ValueSet(
                DynamicFieldConfig => $DynamicFieldConfig,
                ObjectID           => $ObjectID,
                Value              => $DynamicFieldValues{ $DynamicFieldConfig->{Name} },
                UserID             => $Self->{UserID},
            );
        }

        # check if there if we need to close a pop-up screen or not
        if ( $Self->{ScreenType} eq 'Popup' ) {
            return $Self->{LayoutObject}->PopupClose(
                URL => "Action=AgentFAQZoom;ItemID=$GetParam{ItemID}",
            );
        }
        else {
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=AgentFAQZoom;ItemID=$GetParam{ItemID}",
            );
        }
    }
}

sub _MaskNew {
    my ( $Self, %Param ) = @_;

    # get list type
    my $TreeView = 0;
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::ListType') eq 'tree' ) {
        $TreeView = 1;
    }

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
        Class        => 'Validate_Required ' . $Param{CategoryIDServerError},
        Translation  => 0,
        TreeView     => $TreeView,
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

        # check if LanduageID does not exists
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

    my $FieldsetClass = '';
    if ( $Self->{ScreenType} eq 'Popup' ) {
        $FieldsetClass = 'FixedLabel';
    }

    # show FAQ edit screen
    $Self->{LayoutObject}->Block(
        Name => 'FAQEdit',
        Data => {
            %Param,
            %Data,
            FieldsetClass => $FieldsetClass,
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

        # get the FAQ approval group from config
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
    # otherwise just a text-area is shown
    if ( $Self->{LayoutObject}->{BrowserRichText} ) {

        # use height/width defined for this screen
        $Param{RichTextHeight} = $Self->{Config}->{RichTextHeight} || 0;
        $Param{RichTextWidth}  = $Self->{Config}->{RichTextWidth}  || 0;

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

    # Dynamic fields
    # cycle trough the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {

        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        # skip fields that HTML could not be retrieved
        next DYNAMICFIELD if !IsHashRefWithData(
            $Param{DynamicFieldHTML}->{ $DynamicFieldConfig->{Name} }
        );

        # get the HTML strings form $Param
        my $DynamicFieldHTML = $Param{DynamicFieldHTML}->{ $DynamicFieldConfig->{Name} };

        $Self->{LayoutObject}->Block(
            Name => 'DynamicField',
            Data => {
                Name  => $DynamicFieldConfig->{Name},
                Label => $DynamicFieldHTML->{Label},
                Field => $DynamicFieldHTML->{Field},
            },
        );

        # example of dynamic fields order customization
        $Self->{LayoutObject}->Block(
            Name => 'DynamicField_' . $DynamicFieldConfig->{Name},
            Data => {
                Name  => $DynamicFieldConfig->{Name},
                Label => $DynamicFieldHTML->{Label},
                Field => $DynamicFieldHTML->{Field},
            },
        );
    }

    if ( $Self->{ScreenType} ne 'Popup' ) {
        $Self->{LayoutObject}->Block(
            Name => 'EndNormal',
        );
    }

    if ( $Self->{ScreenType} eq 'Popup' ) {
        $Self->{LayoutObject}->Block(
            Name => 'EndSmall',
        );
    }

    # generate output
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentFAQEdit',
        Data         => \%Param,
    );
}

1;
