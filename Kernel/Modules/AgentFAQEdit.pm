# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AgentFAQEdit;

use strict;
use warnings;

use Kernel::Language qw(Translatable);
use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {%Param};
    bless( $Self, $Type );

    # Get config of frontend module.
    $Self->{Config} = $Kernel::OM->Get('Kernel::Config')->Get("FAQ::Frontend::$Self->{Action}") || '';

    # Get the dynamic fields for this screen.
    $Self->{DynamicField} = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => 'FAQ',
        FieldFilter => $Self->{Config}->{DynamicField} || {},
    );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # Permission check.
    if ( !$Self->{AccessRw} ) {
        return $LayoutObject->NoPermission(
            Message    => Translatable('You need rw permission!'),
            WithHeader => 'yes',
        );
    }

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # Get parameters from web request.
    my %GetParam;
    for my $ParamName (
        qw(ItemID Title CategoryID StateID LanguageID ValidID Keywords Approved Field1 Field2 Field3 Field4 Field5 Field6)
        )
    {
        $GetParam{$ParamName} = $ParamObject->GetParam( Param => $ParamName );
    }

    # Check needed stuff.
    if ( !$GetParam{ItemID} ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('No ItemID is given!'),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    my $FAQObject = $Kernel::OM->Get('Kernel::System::FAQ');

    my %FAQData = $FAQObject->FAQGet(
        ItemID        => $GetParam{ItemID},
        ItemFields    => 1,
        UserID        => $Self->{UserID},
        DynamicFields => 1,
    );
    if ( !%FAQData ) {
        return $LayoutObject->ErrorScreen();
    }

    # Check user permission.
    my $Permission = $FAQObject->CheckCategoryUserPermission(
        UserID     => $Self->{UserID},
        CategoryID => $FAQData{CategoryID},
        Type       => 'rw',
    );
    if ( !$Permission ) {
        return $LayoutObject->NoPermission(
            Message    => Translatable('You have no permission for this category!'),
            WithHeader => 'yes',
        );
    }

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # Get dynamic field values form web request.
    my %DynamicFieldValues;

    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        # Extract the dynamic field value form the web request.
        $DynamicFieldValues{ $DynamicFieldConfig->{Name} } = $DynamicFieldBackendObject->EditFieldValueGet(
            DynamicFieldConfig => $DynamicFieldConfig,
            ParamObject        => $ParamObject,
            LayoutObject       => $LayoutObject,
        );
    }

    my $UploadCacheObject = $Kernel::OM->Get('Kernel::System::Web::UploadCache');

    my $FormID = $ParamObject->GetParam( Param => 'FormID' );
    if ( !$FormID ) {
        $FormID = $UploadCacheObject->FormIDCreate();
    }

    # Get screen type.
    my $ScreenType = $ParamObject->GetParam( Param => 'ScreenType' ) || '';

    my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');

    # ------------------------------------------------------------ #
    # show the FAQ edit screen
    # ------------------------------------------------------------ #
    if ( !$Self->{Subaction} ) {

        my $Output;

        # Show a pop-up screen.
        if ( $ScreenType eq 'Popup' ) {

            $Output = $LayoutObject->Header(
                Type      => 'Small',
                BodyClass => 'Popup',
            );
            $LayoutObject->Block(
                Name => 'StartSmall',
                Data => {
                    %FAQData,
                },
            );
        }

        # Show a normal window.
        else {

            $Output = $LayoutObject->Header();
            $Output .= $LayoutObject->NavigationBar();

            $LayoutObject->Block(
                Name => 'StartNormal',
                Data => {
                    %FAQData,
                },
            );
        }

        # Get all existing attachments (without inline attachments).
        my @ExistingAttachments = $FAQObject->AttachmentIndex(
            ItemID     => $GetParam{ItemID},
            ShowInline => 0,
            UserID     => $Self->{UserID},
        );

        # Copy all existing attachments to upload cache.
        for my $Attachment (@ExistingAttachments) {

            # Get the existing attachment data.
            my %File = $FAQObject->AttachmentGet(
                ItemID => $GetParam{ItemID},
                FileID => $Attachment->{FileID},
                UserID => $Self->{UserID},
            );

            # Get content disposition (if its an inline attachment).
            my $Disposition = $Attachment->{Inline} ? 'inline' : '';

            # Add attachments to the upload cache.
            $UploadCacheObject->FormIDAddFile(
                FormID      => $FormID,
                Filename    => $File{Filename},
                Content     => $File{Content},
                ContentType => $File{ContentType},
                Disposition => $Disposition,
            );
        }

        # Get all attachments meta data from upload cache.
        my @Attachments = $UploadCacheObject->FormIDGetAllFilesMeta(
            FormID => $FormID,
        );

        # Rewrite old style inline image URLs.
        FIELD:
        for my $Field (qw(Field1 Field2 Field3 Field4 Field5 Field6)) {

            next FIELD if !$FAQData{$Field};

            # Rewrite handle and action, take care of old style before FAQ 2.0.x.
            $FAQData{$Field} =~ s{
                Action=AgentFAQ [&](amp;)? Subaction=Download [&](amp;)?
            }{Action=AgentFAQZoom;Subaction=DownloadAttachment;}gxms;
        }

        # Create HTML strings for all dynamic fields.
        my %DynamicFieldHTML;
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            # To store dynamic field value from database (or undefined).
            my $Value = $FAQData{ 'DynamicField_' . $DynamicFieldConfig->{Name} };

            # Get field HTML.
            $DynamicFieldHTML{ $DynamicFieldConfig->{Name} } =
                $DynamicFieldBackendObject->EditFieldRender(
                DynamicFieldConfig => $DynamicFieldConfig,
                Value              => $Value,
                Mandatory =>
                    $Self->{Config}->{DynamicField}->{ $DynamicFieldConfig->{Name} } == 2,
                LayoutObject => $LayoutObject,
                ParamObject  => $ParamObject,
                );
        }

        if ( $ConfigObject->Get('FAQ::ApprovalRequired') ) {

            my $ApprovalQueue = $ConfigObject->Get('FAQ::ApprovalQueue') || '';

            # Check if Approval queue exists.
            my $ApprovalQueueID = $QueueObject->QueueLookup(
                Queue => $ApprovalQueue,
            );

            # Show notification if Approval queue does not exists.
            if ( !$ApprovalQueueID ) {
                $Output .= $LayoutObject->Notify(
                    Priority => 'Error',
                    Info     => "FAQ Approval is enabled but queue '$ApprovalQueue' does not exists",
                    Link     => $LayoutObject->{Baselink}
                        . 'Action=AdminSystemConfiguration;Subaction=ViewCustomGroup;Names=FAQ::ApprovalQueue',
                );
            }
        }

        $Output .= $Self->_MaskNew(
            %FAQData,
            Attachments      => \@Attachments,
            ScreenType       => $ScreenType,
            FormID           => $FormID,
            DynamicFieldHTML => \%DynamicFieldHTML,
        );

        if ( $ScreenType eq 'Popup' ) {
            $LayoutObject->Block(
                Name => 'EndSmall',
                Data => {},
            );
            $Output .= $LayoutObject->Footer( Type => 'Small' );
        }
        else {
            $LayoutObject->Block(
                Name => 'EndNormal',
                Data => {},
            );
            $Output .= $LayoutObject->Footer();
        }

        return $Output;
    }

    # ------------------------------------------------------------ #
    # Save the FAQ
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Save' ) {

        # Challenge token check for write action.
        $LayoutObject->ChallengeTokenCheck();

        my $Output;

        # Show a pop-up screen.
        if ( $ScreenType eq 'Popup' ) {
            $Output = $LayoutObject->Header(
                Type      => 'Small',
                BodyClass => 'Popup',
            );
            $LayoutObject->Block(
                Name => 'StartSmall',
                Data => {
                    %FAQData,
                },
            );
        }

        # Show a normal window.
        else {
            $Output = $LayoutObject->Header();
            $Output .= $LayoutObject->NavigationBar();
            $LayoutObject->Block(
                Name => 'StartNormal',
                Data => {
                    %FAQData,
                },
            );
        }

        my %Error;
        for my $ParamName (qw(Title CategoryID)) {

            # If required field is not given, add server error class.
            if ( !$GetParam{$ParamName} ) {
                $Error{ $ParamName . 'ServerError' } = 'ServerError';
            }
        }

        # # Check if an attachment must be deleted.
        # my @AttachmentIDs = map {
        #     my ($ID) = $_ =~ m{ \A AttachmentDelete (\d+) \z }xms;
        #     $ID ? $ID : ();
        # } $ParamObject->GetParamNames();

        # COUNT:
        # for my $Count ( reverse sort @AttachmentIDs ) {

        #     # check if the delete button was pressed for this attachment
        #     my $Delete = $ParamObject->GetParam( Param => "AttachmentDelete$Count" );

        #     # check next attachment if it was not pressed
        #     next COUNT if !$Delete;

        #     # remember that we need to show the page again
        #     $Error{Attachment} = 1;

        #     # remove the attachment from the upload cache
        #     $UploadCacheObject->FormIDRemoveFile(
        #         FormID => $FormID,
        #         FileID => $Count,
        #     );
        # }

        # # check if there was an attachment upload
        # if ( $ParamObject->GetParam( Param => 'AttachmentUpload' ) ) {

        #     # remember that we need to show the page again
        #     $Error{Attachment} = 1;

        #     # get the uploaded attachment
        #     my %UploadStuff = $ParamObject->GetUploadAll(
        #         Param  => 'FileUpload',
        #         Source => 'string',
        #     );

        #     # add attachment to the upload cache
        #     $UploadCacheObject->FormIDAddFile(
        #         FormID => $FormID,
        #         %UploadStuff,
        #     );
        # }

        # Create HTML strings for all dynamic fields.
        my %DynamicFieldHTML;
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            my $ValidationResult = $DynamicFieldBackendObject->EditFieldValueValidate(
                DynamicFieldConfig => $DynamicFieldConfig,
                ParamObject        => $ParamObject,
                Mandatory =>
                    $Self->{Config}->{DynamicField}->{ $DynamicFieldConfig->{Name} } == 2,
            );

            if ( !IsHashRefWithData($ValidationResult) ) {
                return $LayoutObject->ErrorScreen(
                    Message => $LayoutObject->{LanguageObject}->Translate(
                        'Could not perform validation on field %s!',
                        $DynamicFieldConfig->{Label},
                    ),
                    Comment => Translatable('Please contact the administrator.'),
                );
            }

            # Propagate validation error to the Error variable to be detected by the frontend.
            if ( $ValidationResult->{ServerError} ) {
                $Error{ $DynamicFieldConfig->{Name} } = ' ServerError';
            }

            # Get field HTML.
            $DynamicFieldHTML{ $DynamicFieldConfig->{Name} } =
                $DynamicFieldBackendObject->EditFieldRender(
                DynamicFieldConfig => $DynamicFieldConfig,
                Mandatory =>
                    $Self->{Config}->{DynamicField}->{ $DynamicFieldConfig->{Name} } == 2,
                ServerError  => $ValidationResult->{ServerError}  || '',
                ErrorMessage => $ValidationResult->{ErrorMessage} || '',
                LayoutObject => $LayoutObject,
                ParamObject  => $ParamObject,
                );
        }

        # Send server error if any required parameter is missing
        if (%Error) {

            # # if there was an attachment delete or upload
            # # we do not want to show validation errors for other fields
            # if ( $Error{Attachment} ) {
            #     %Error = ();
            # }

            # get all attachments meta data
            my @Attachments = $UploadCacheObject->FormIDGetAllFilesMeta(
                FormID           => $FormID,
                DynamicFieldHTML => \%DynamicFieldHTML,
            );

            if ( $ConfigObject->Get('FAQ::ApprovalRequired') ) {

                my $ApprovalQueue = $ConfigObject->Get('FAQ::ApprovalQueue') || '';

                # Check if Approval queue exists.
                my $ApprovalQueueID = $QueueObject->QueueLookup(
                    Queue => $ApprovalQueue,
                );

                # Show notification if Approval queue does not exists.
                if ( !$ApprovalQueueID ) {
                    $Output .= $LayoutObject->Notify(
                        Priority => 'Error',
                        Info =>
                            "FAQ Approval is enabled but queue '$ApprovalQueue' does not exists",
                        Link => $LayoutObject->{Baselink}
                            . 'Action=AdminSystemConfiguration;Subaction=ViewCustomGroup;Names=FAQ::ApprovalQueue',
                    );
                }
            }

            $Output .= $Self->_MaskNew(
                Attachments => \@Attachments,
                %GetParam,
                %Error,
                ScreenType       => $ScreenType,
                FormID           => $FormID,
                DynamicFieldHTML => \%DynamicFieldHTML,
            );

            if ( $ScreenType eq 'Popup' ) {
                $LayoutObject->Block(
                    Name => 'EndSmall',
                    Data => {},
                );

                $Output .= $LayoutObject->Footer( Type => 'Small' );
            }
            else {
                $LayoutObject->Block(
                    Name => 'EndNormal',
                    Data => {},
                );
                $Output .= $LayoutObject->Footer();
            }

            return $Output;
        }

        # Set the content type.
        my $ContentType = 'text/plain';
        if ( $LayoutObject->{BrowserRichText} && $ConfigObject->Get('FAQ::Item::HTML') ) {
            $ContentType = 'text/html';
        }

        # Update the new FAQ item.
        my $UpdateSuccess = $FAQObject->FAQUpdate(
            %GetParam,
            ContentType => $ContentType,
            UserID      => $Self->{UserID},
        );

        # Show error if FAQ item could not be updated.
        if ( !$UpdateSuccess ) {
            return $LayoutObject->ErrorScreen();
        }

        # Get all attachments from upload cache.
        my @Attachments = $UploadCacheObject->FormIDGetAllFilesData(
            FormID => $FormID,
        );

        # Get all existing attachments.
        my @ExistingAttachments = $FAQObject->AttachmentIndex(
            ItemID     => $GetParam{ItemID},
            ShowInline => 1,
            UserID     => $Self->{UserID},
        );

        # Lookup old inline attachments (initially loaded to AgentFAQEdit.pm screen)
        # and push to Attachments array if they still exist in the form.
        ATTACHMENT:
        for my $Attachment (@ExistingAttachments) {

            next ATTACHMENT if !$Attachment->{Inline};

            NUMBER:
            for my $Number ( 1 .. 6 ) {

                if (
                    $FAQData{ 'Field' . $Number }
                    =~ m{ Action=AgentFAQZoom;Subaction=DownloadAttachment;ItemID=$GetParam{ItemID};FileID=$Attachment->{FileID} }msx
                    )
                {

                    # Get the existing inline attachment data.
                    my %File = $FAQObject->AttachmentGet(
                        ItemID => $GetParam{ItemID},
                        FileID => $Attachment->{FileID},
                        UserID => $Self->{UserID},
                    );

                    push @Attachments, {
                        Content     => $File{Content},
                        ContentType => $File{ContentType},
                        Filename    => $File{Filename},
                        Filesize    => $File{Filesize},
                        Disposition => 'inline',
                        FileID      => $Attachment->{FileID},
                    };

                    last NUMBER;
                }
            }
        }

        # Build a lookup hash of the new attachments.
        my %NewAttachment;
        for my $Attachment (@Attachments) {

            # The key is the filename + filesize + content type.
            my $Key = $Attachment->{Filename}
                . $Attachment->{Filesize}
                . $Attachment->{ContentType};

            # Append content id if available (for new inline images).
            if ( $Attachment->{ContentID} ) {
                $Key .= $Attachment->{ContentID};
            }

            # Store all of the new attachment data.
            $NewAttachment{$Key} = $Attachment;
        }

        # Check the existing attachments.
        ATTACHMENT:
        for my $Attachment (@ExistingAttachments) {

          # The key is the filename + filesizeraw + content type (no content id, as existing attachments don't have it).
            my $Key = $Attachment->{Filename}
                . $Attachment->{FilesizeRaw}
                . $Attachment->{ContentType};

            # Attachment is already existing, we can delete it from the new attachment hash.
            if ( $NewAttachment{$Key} ) {
                delete $NewAttachment{$Key};
            }

            # Existing attachment is no longer in new attachments hash.
            else {

                # Delete the existing attachment.
                my $DeleteSuccessful = $FAQObject->AttachmentDelete(
                    ItemID => $GetParam{ItemID},
                    FileID => $Attachment->{FileID},
                    UserID => $Self->{UserID},
                );
                if ( !$DeleteSuccessful ) {
                    return $LayoutObject->FatalError();
                }
            }
        }

        # Write the new attachments.
        ATTACHMENT:
        for my $Attachment ( values %NewAttachment ) {

            # Check if attachment is an inline attachment.
            my $Inline = 0;
            if ( $Attachment->{Disposition} eq 'inline' ) {

                # Remember that it is inline.
                $Inline = 1;

                # Remember if this inline attachment is already used in any FAQ item.
                my $InlineAttachmentFound;

                # Check all fields for the inline attachment.
                NUMBER:
                for my $Number ( 1 .. 6 ) {

                    # Get FAQ field.
                    my $Field = $GetParam{ 'Field' . $Number };

                    # Skip empty fields.
                    next NUMBER if !$Field;

                    # Skip if the field is not new (added) or old (initially loaded) inline attachment.
                    if (
                        $Field !~ m{ $Attachment->{ContentID} }xms
                        && $Field
                        !~ m{ Action=AgentFAQZoom;Subaction=DownloadAttachment;ItemID=$GetParam{ItemID};FileID=$Attachment->{FileID} }xms
                        )
                    {
                        next NUMBER;
                    }

                    # Found the inline attachment.
                    $InlineAttachmentFound = 1;

                    # We do not need to search further.
                    last NUMBER;
                }

                # We do not want to keep this attachment, because it was deleted in the rich-text editor.
                next ATTACHMENT if !$InlineAttachmentFound;
            }

            # Add attachment.
            my $FileID = $FAQObject->AttachmentAdd(
                %{$Attachment},
                ItemID => $GetParam{ItemID},
                Inline => $Inline,
                UserID => $Self->{UserID},
            );
            if ( !$FileID ) {
                return $LayoutObject->FatalError();
            }

            next ATTACHMENT if !$Inline;
            next ATTACHMENT if !$LayoutObject->{BrowserRichText};

            # Rewrite the URLs of the inline images for the uploaded pictures.
            my $OK = $FAQObject->FAQInlineAttachmentURLUpdate(
                Attachment => $Attachment,
                FormID     => $FormID,
                ItemID     => $GetParam{ItemID},
                FileID     => $FileID,
                UserID     => $Self->{UserID},
            );
            if ( !$OK ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Could not update the inline image URLs "
                        . "for FAQ Item# '$GetParam{ItemID}'!",
                );
            }
        }

        # Delete the upload cache.
        $UploadCacheObject->FormIDRemove( FormID => $FormID );

        # Set dynamic fields.
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            # Set the value.
            my $Success = $DynamicFieldBackendObject->ValueSet(
                DynamicFieldConfig => $DynamicFieldConfig,
                ObjectID           => $GetParam{ItemID},
                Value              => $DynamicFieldValues{ $DynamicFieldConfig->{Name} },
                UserID             => $Self->{UserID},
            );
        }

        # Check if there if we need to close a pop-up screen or not.
        if ( $ScreenType eq 'Popup' ) {
            return $LayoutObject->PopupClose(
                URL => "Action=AgentFAQZoom;ItemID=$GetParam{ItemID}",
            );
        }
        else {
            return $LayoutObject->Redirect(
                OP => "Action=AgentFAQZoom;ItemID=$GetParam{ItemID}",
            );
        }
    }
}

sub _MaskNew {
    my ( $Self, %Param ) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # Get list type.
    my $TreeView = 0;
    if ( $ConfigObject->Get('Ticket::Frontend::ListType') eq 'tree' ) {
        $TreeView = 1;
    }

    my %ValidList        = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();
    my %ValidListReverse = reverse %ValidList;

    my %Data;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # Build valid selection.
    $Data{ValidOption} = $LayoutObject->BuildSelection(
        Data       => \%ValidList,
        Name       => 'ValidID',
        SelectedID => $Param{ValidID} || $ValidListReverse{valid},
        Class      => 'Modernize',
    );

    my $FAQObject = $Kernel::OM->Get('Kernel::System::FAQ');

    # Get categories (with category long names) where user has rights.
    my $UserCategoriesLongNames = $FAQObject->GetUserCategoriesLongNames(
        Type   => 'rw',
        UserID => $Self->{UserID},
    );

    # Set no server error class as default.
    $Param{CategoryIDServerError} ||= '';

    # Build category selection.
    $Data{CategoryOption} = $LayoutObject->BuildSelection(
        Data         => $UserCategoriesLongNames,
        Name         => 'CategoryID',
        SelectedID   => $Param{CategoryID},
        PossibleNone => 1,
        Class        => 'Validate_Required Modernize ' . $Param{CategoryIDServerError},
        Translation  => 0,
        TreeView     => $TreeView,
    );

    my %Languages = $FAQObject->LanguageList(
        UserID => $Self->{UserID},
    );

    # Get the selected language.
    my $SelectedLanguage;
    if ( $Param{LanguageID} && $Languages{ $Param{LanguageID} } ) {

        # Get language from given LanguageID
        $SelectedLanguage = $Languages{ $Param{LanguageID} };
    }
    else {

        # Use the user language, or if not found 'en'.
        $SelectedLanguage = $LayoutObject->{UserLanguage} || 'en';

        # Get user LanguageID
        my $SelectedLanguageID = $FAQObject->LanguageLookup(
            Name => $SelectedLanguage,
        );

        # Check if LanguageID does not exists.
        if ( !$SelectedLanguageID ) {

            # Get the lowest LanguageID form the FAQ language list as its the first added and
            #   (we assume) the most frequently used.
            my @LanguageIDs = sort keys %Languages;
            $SelectedLanguageID = $LanguageIDs[0];

            # Set the language with lowest languageID as selected language.
            $SelectedLanguage = $Languages{$SelectedLanguageID};
        }
    }

    # Build the language selection.
    $Data{LanguageOption} = $LayoutObject->BuildSelection(
        Data          => \%Languages,
        Name          => 'LanguageID',
        SelectedValue => $SelectedLanguage,
        Translation   => 0,
        Class         => 'Modernize',
    );

    my @StateTypes = $ConfigObject->Get('FAQ::Agent::StateTypes');
    my %States     = $FAQObject->StateList(
        Types  => @StateTypes,
        UserID => $Self->{UserID},
    );

    # Get the selected state.
    my $SelectedState;
    if ( $Param{StateID} && $States{ $Param{StateID} } ) {

        # Get state from given StateID
        $SelectedState = $States{ $Param{StateID} };
    }
    else {

        # Get default state.
        $SelectedState = $ConfigObject->Get('FAQ::Default::State') || 'internal (agent)';
    }

    # Build the state selection.
    $Data{StateOption} = $LayoutObject->BuildSelection(
        Data          => \%States,
        Name          => 'StateID',
        SelectedValue => $SelectedState,
        Translation   => 1,
        Class         => 'Modernize',
    );

    # Get screen type.
    my $ScreenType = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'ScreenType' ) || '';

    my $FieldsetClass = '';
    if ( $ScreenType eq 'Popup' ) {
        $FieldsetClass = 'FixedLabel';
    }

    # Show attachments.
    ATTACHMENT:
    for my $Attachment ( @{ $Param{Attachments} } ) {

        # Do not show inline images as attachments (they have a content id)
        if ( $Attachment->{ContentID} && $LayoutObject->{BrowserRichText} ) {
            next ATTACHMENT;
        }

        push @{ $Param{AttachmentList} }, $Attachment;
    }

    $LayoutObject->Block(
        Name => 'FAQEdit',
        Data => {
            %Param,
            %Data,
            FieldsetClass => $FieldsetClass,
        },
    );

    # Show languages field.
    my $MultiLanguage = $ConfigObject->Get('FAQ::MultiLanguage');
    if ($MultiLanguage) {
        $LayoutObject->Block(
            Name => 'Language',
            Data => {
                %Param,
                %Data,
            },
        );
    }
    else {
        $LayoutObject->Block(
            Name => 'NoLanguage',
            Data => {
                %Param,
                %Data,
            },
        );
    }

    # Show approval field.
    if ( $ConfigObject->Get('FAQ::ApprovalRequired') ) {

        # Check permission.
        my %Groups = reverse $Kernel::OM->Get('Kernel::System::Group')->GroupMemberList(
            UserID => $Self->{UserID},
            Type   => 'ro',
            Result => 'HASH',
        );

        # Get the FAQ approval group from config.
        my $ApprovalGroup = $ConfigObject->Get('FAQ::ApprovalGroup') || '';

        # Build the approval selection if user is in the approval group.
        if ( $Groups{$ApprovalGroup} ) {

            $Data{ApprovalOption} = $LayoutObject->BuildSelection(
                Name => 'Approved',
                Data => {
                    0 => 'No',
                    1 => 'Yes',
                },
                SelectedID => $Param{Approved} || 0,
                Class      => 'Modernize',
            );
            $LayoutObject->Block(
                Name => 'Approval',
                Data => {%Data},
            );
        }
    }

    # Get config of frontend module.
    my $Config = $ConfigObject->Get("FAQ::Frontend::$Self->{Action}") || '';

    # Add rich text editor JavaScript only if activated and the browser can handle it
    #   otherwise just a text-area is shown
    if ( $LayoutObject->{BrowserRichText} && $ConfigObject->Get('FAQ::Item::HTML') ) {

        # Use height/width defined for this screen.
        $Param{RichTextHeight} = $Config->{RichTextHeight} || 0;
        $Param{RichTextWidth}  = $Config->{RichTextWidth}  || 0;

        # Set up rich text editor.
        $LayoutObject->SetRichTextParameters(
            Data => \%Param,
        );
    }

    # Set default interface settings.
    my $InterfaceStates = $FAQObject->StateTypeList(
        Types  => @StateTypes,
        UserID => $Self->{UserID},
    );

    # Show FAQ Content.
    $LayoutObject->FAQContentShow(
        FAQObject       => $FAQObject,
        InterfaceStates => $InterfaceStates,
        FAQData         => {%Param},
        UserID          => $Self->{UserID},
    );

    # Dynamic fields.
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {

        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        # Skip fields that HTML could not be retrieved.
        next DYNAMICFIELD if !IsHashRefWithData(
            $Param{DynamicFieldHTML}->{ $DynamicFieldConfig->{Name} }
        );

        # Get the HTML strings form $Param
        my $DynamicFieldHTML = $Param{DynamicFieldHTML}->{ $DynamicFieldConfig->{Name} };

        $LayoutObject->Block(
            Name => 'DynamicField',
            Data => {
                Name  => $DynamicFieldConfig->{Name},
                Label => $DynamicFieldHTML->{Label},
                Field => $DynamicFieldHTML->{Field},
            },
        );

        # Example of dynamic fields order customization.
        $LayoutObject->Block(
            Name => 'DynamicField_' . $DynamicFieldConfig->{Name},
            Data => {
                Name  => $DynamicFieldConfig->{Name},
                Label => $DynamicFieldHTML->{Label},
                Field => $DynamicFieldHTML->{Field},
            },
        );
    }

    if ( $ScreenType ne 'Popup' ) {
        $LayoutObject->Block(
            Name => 'EndNormal',
        );
    }

    if ( $ScreenType eq 'Popup' ) {
        $LayoutObject->Block(
            Name => 'EndSmall',
        );
    }

    return $LayoutObject->Output(
        TemplateFile => 'AgentFAQEdit',
        Data         => \%Param,
    );
}

1;
