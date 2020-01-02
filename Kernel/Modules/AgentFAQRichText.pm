# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AgentFAQRichText;

use strict;
use warnings;

use MIME::Base64 qw();
use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # Get parameters from web request
    my %GetParam;
    for my $Key (qw(ItemID)) {
        $GetParam{$Key} = $ParamObject->GetParam( Param => $Key );
        if ( !$GetParam{$Key} ) {
            return $LayoutObject->ErrorScreen(
                Message => $LayoutObject->{LanguageObject}->Translate( 'No %s is given!', $Key ),
                Comment => Translatable('Please contact the administrator.'),
            );
        }
    }

    my $FAQObject = $Kernel::OM->Get('Kernel::System::FAQ');

    my %FAQItem = $FAQObject->FAQGet(
        ItemID     => $GetParam{ItemID},
        ItemFields => 1,
        UserID     => $Self->{UserID},
    );
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $ScriptAlias = $ConfigObject->Get('ScriptAlias') || 'otrs/';
    my $URLRegex    = '/' . $ScriptAlias . 'index.pl\?Action=AgentFAQZoom;'
        . 'Subaction=DownloadAttachment;ItemID=' . $GetParam{ItemID} . ';FileID=[0-9]+';
    my $ElemRegex = 'src="(' . $URLRegex . ')"';

    my @Fields;

    my $Loaded = $Kernel::OM->Get('Kernel::System::Main')->Require(
        'Kernel::Language',
    );

    if ( !$Loaded ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Can\'t load LanguageObject!'),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    my $FAQLanguageObject = Kernel::Language->new(
        UserLanguage => $FAQItem{Language},
    );

    # Get configuration options for Ticket Compose.
    my $TicketComposeConfig = $ConfigObject->Get('FAQ::TicketCompose');

    my $InternalStateType = $FAQObject->StateTypeGet(
        Name   => 'internal',
        UserID => $Self->{UserID},
    );

    my $InternalStateID = $InternalStateType->{StateID};

    my $UploadCacheObject = $Kernel::OM->Get('Kernel::System::Web::UploadCache');

    my $FormID = $ParamObject->GetParam( Param => 'FormID' );
    if ( !$FormID ) {
        $FormID = $UploadCacheObject->FormIDCreate();
    }

    FIELD:
    for my $Field ( 1 .. 6 ) {

        # Don't waste any further processing power, if the current field doesn't have any content.
        next FIELD if !$FAQItem{ 'Field' . $Field };

        my $FieldContent = $FAQItem{ 'Field' . $Field };

        # Get config of current FAQ field from SysConfig.
        my $FieldConfig = $ConfigObject->Get( 'FAQ::Item::Field' . $Field );

        next FIELD if !$FieldConfig;
        next FIELD if ref $FieldConfig ne 'HASH';
        next FIELD if !$FieldConfig->{Show};

        my $StateTypeData = $FAQObject->StateTypeGet(
            Name   => $FieldConfig->{Show},
            UserID => $Self->{UserID},
        );

        # Check if current field is internal.
        my $IsInternal;
        if ( $StateTypeData->{StateID} == $InternalStateID ) {
            $IsInternal = 1;
        }

        # Check whether the current field should be visible to the public, thus be inserted into a
        #   response to a customer or not.
        if ( !$TicketComposeConfig->{IncludeInternal} && $IsInternal ) {
            next FIELD;
        }

        # Extract all URLs which point to an embedded image.
        my @MatchedURLs = ( $FieldContent =~ m{$ElemRegex}xgms );
        for my $URL (@MatchedURLs) {

            # Extract the ID of the attachment
            my ($FileID) = $URL =~ m{ FileID=([0-9]+) }msx;

            if ( $ConfigObject->{Debug} > 0 ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'debug',
                    Message  => "FileID: $FileID",
                );
            }

            # Get the attachment to which the current URL points.
            my %Attachment = $FAQObject->AttachmentGet(
                ItemID => $GetParam{ItemID},
                FileID => $FileID,
                UserID => $Self->{UserID},
            );

            my @AttachmentMeta = $UploadCacheObject->FormIDGetAllFilesMeta(
                FormID => $FormID,
            );

            my $FilenameTmp    = $Attachment{Filename};
            my $SuffixTmp      = 0;
            my $UniqueFilename = '';

            # Create now an article attachment (inline) based on the data of %Attachment (FAQ).
            if (%Attachment) {

                # Check if name already exists.
                while ( !$UniqueFilename ) {
                    $UniqueFilename = $FilenameTmp;
                    NEWNAME:
                    for my $Attachment ( reverse @AttachmentMeta ) {
                        next NEWNAME if $FilenameTmp ne $Attachment->{Filename};

                        # Name exists -> change.
                        ++$SuffixTmp;
                        if ( $Attachment{Filename} =~ m{\A (.*) \. (.+?) \z}msx ) {
                            $FilenameTmp = "$1-$SuffixTmp.$2";
                        }
                        else {
                            $FilenameTmp = "$Attachment{Filename}-$SuffixTmp";
                        }
                        $UniqueFilename = '';
                        last NEWNAME;
                    }
                }

                $Attachment{Filename} = $FilenameTmp;
                delete $Attachment{ContentID};

                # Add the attachment to the upload cache of the current ticket.
                $UploadCacheObject->FormIDAddFile(
                    FormID      => $FormID,
                    Disposition => 'inline',
                    %Attachment,
                );
            }
            else {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => 'Couldn\'t get FAQ attachment '
                        . "(ItemID: $GetParam{ItemID}, FileID: $FileID)!",
                );
                return $LayoutObject->ErrorScreen();
            }

            # Get new ContentID
            my $ContentIDNew = '';
            @AttachmentMeta = $UploadCacheObject->FormIDGetAllFilesMeta(
                FormID => $FormID,
            );

            ATTACHMENT:
            for my $Attachment (@AttachmentMeta) {
                next ATTACHMENT if $FilenameTmp ne $Attachment->{Filename};
                $ContentIDNew = $Attachment->{ContentID};
                last ATTACHMENT;
            }

            if ( $ContentIDNew eq '' ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Couldn't determine a new ContentID!",
                );
                return $LayoutObject->ErrorScreen();
            }

            # Extract the actual MIME type from the content type, which also contains the filename.
            my ($MimeType) = $Attachment{ContentType} =~ m{^(.+/.+); [ ] name=.+$}xms;

            my $Session = '';
            if ( $Self->{SessionID} && !$Self->{SessionIDCookie} ) {
                $Session = '&' . $Self->{SessionName} . '=' . $Self->{SessionID};
            }

            # Create the new inline image URL.
            my $InlineImage = $LayoutObject->{Baselink}
                . "Action=PictureUpload;FormID=$FormID;ContentID=$ContentIDNew$Session";

            # Replace the image URL with the inline image.
            $FieldContent =~ s{\Q$URL\E}{$InlineImage}xms;
        }

        # Add the name of the field as header.
        if ( $FieldConfig->{Caption} && $TicketComposeConfig->{ShowFieldNames} ) {

            # Translate the caption to the language of the FAQ item.
            my $TranslatedCaption = $FAQLanguageObject->Translate( $FieldConfig->{Caption} );

            if ($TranslatedCaption) {
                $FieldContent = '<h2>' . $TranslatedCaption . ':</h2>' . $FieldContent;
            }
        }
        push @Fields, $FieldContent;
    }

    my $FAQHTML = join( '<br />', @Fields );

    # Get all non-inline attachments of the FAQ item.
    my @Attachments = $FAQObject->AttachmentIndex(
        ItemID     => $GetParam{ItemID},
        ShowInline => 0,
        UserID     => $Self->{UserID},
    );

    my @Data = $UploadCacheObject->FormIDGetAllFilesMeta(
        FormID => $FormID,
    );

    ATTACHMENT:
    for my $AttachmentData (@Attachments) {

        my %Attachment = $FAQObject->AttachmentGet(
            ItemID => $GetParam{ItemID},
            FileID => $AttachmentData->{FileID},
            UserID => $Self->{UserID},
        );

        if (%Attachment) {

            next ATTACHMENT if grep { $Attachment{Filename} eq $_->{Filename} } @Data;

            # Add the attachment to the upload cache of the current ticket.
            $UploadCacheObject->FormIDAddFile(
                FormID => $FormID,
                %Attachment,
            );
        }
        else {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Couldn\'t get FAQ attachment '
                    . "(ItemID: $GetParam{ItemID}, FileID: $AttachmentData->{FileID})!",
            );
            return $LayoutObject->ErrorScreen();
        }
    }

    # Send a list of attachments in the upload cache back to the client side JavaScript which
    #   renders then the list of currently uploaded attachments.
    my @TicketAttachments = $UploadCacheObject->FormIDGetAllFilesMeta(
        FormID => $FormID,
    );

    my @FilteredTicketAttachments;

    if ( $ConfigObject->Get('Frontend::RichText') ) {

        # Remove the inline-attachments which shouldn't be shown in the regular attachment list.
        ATTACHMENT:
        for my $Attachment (@TicketAttachments) {
            if ( defined $Attachment->{ContentID} && $Attachment->{ContentID} =~ m{\A inline}msx ) {
                next ATTACHMENT;
            }
            push @FilteredTicketAttachments, $Attachment;
        }
    }
    else {

        # If rich-text is not active then set also inline attachments as regular attachments.
        @FilteredTicketAttachments = @TicketAttachments;
    }

    for my $Attachment (@FilteredTicketAttachments) {
        $Attachment->{Filesize} = $LayoutObject->HumanReadableDataSize(
            Size => $Attachment->{Filesize},
        );
    }

    my $JSON = $Kernel::OM->Get('Kernel::System::JSON')->Encode(
        Data => {
            FAQTitle          => $FAQItem{Title},
            FAQContent        => $Kernel::OM->Get('Kernel::System::HTMLUtils')->ToAscii( String => $FAQHTML ) || '',
            FAQHTMLContent    => $FAQHTML,
            TicketAttachments => \@FilteredTicketAttachments,
            Localization      => {
                Delete => $LayoutObject->{LanguageObject}->Translate('Delete'),
            },
            FormID => $FormID,
        },
    );

    return $LayoutObject->Attachment(
        ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
        Content     => $JSON,
        Type        => 'inline',
        NoCache     => 1,
    );
}

1;
