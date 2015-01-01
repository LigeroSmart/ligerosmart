# --
# Kernel/Modules/AgentFAQRichText.pm - to handle AJAX requests for inserting the rich-text of an FAQ
# article into a ticket article
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentFAQRichText;

use strict;
use warnings;

use MIME::Base64 qw();
use Kernel::System::FAQ;
use Kernel::System::CustomerUser;
use Kernel::System::HTMLUtils;
use Kernel::System::JSON;
use Kernel::System::Web::UploadCache;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (qw(ParamObject DBObject LayoutObject LogObject ConfigObject))
    {
        if ( !$Self->{$Needed} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Needed!" );
        }
    }

    $Self->{FAQObject}          = Kernel::System::FAQ->new(%Param);
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);
    $Self->{HTMLUtilsObject}    = Kernel::System::HTMLUtils->new(%Param);
    $Self->{JSONObject}         = Kernel::System::JSON->new(%Param);
    $Self->{UploadCacheObject}  = Kernel::System::Web::UploadCache->new(%Param);

    # get form id
    $Self->{FormID} = $Self->{ParamObject}->GetParam( Param => 'FormID' );

    # create form id
    if ( !$Self->{FormID} ) {
        $Self->{FormID} = $Self->{UploadCacheObject}->FormIDCreate();
    }

    $Self->{Config} = $Self->{ConfigObject}->Get("Ticket::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get params
    my %GetParam;
    for my $Key (qw(ItemID)) {
        $GetParam{$Key} = $Self->{ParamObject}->GetParam( Param => $Key );
        if ( !$GetParam{$Key} ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "No $Key is given!",
                Comment => 'Please contact the admin.',
            );
        }
    }

    # get the requested FAQ item
    my %FAQItem = $Self->{FAQObject}->FAQGet(
        ItemID     => $GetParam{ItemID},
        ItemFields => 1,
        UserID     => $Self->{UserID},
    );

    my $ScriptAlias = $Self->{ConfigObject}->Get('ScriptAlias') || 'otrs/';
    my $URLRegex = '/' . $ScriptAlias . 'index.pl\?Action=AgentFAQZoom;'
        . 'Subaction=DownloadAttachment;ItemID=' . $GetParam{ItemID} . ';FileID=[0-9]+';
    my $ElemRegex = 'src="(' . $URLRegex . ')"';

    my @Fields;

    my $Loaded = $Self->{MainObject}->Require(
        'Kernel::Language',
    );

    if ( !$Loaded ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'Can not load LanguageObject!',
            Comment => 'Please contact the admin.',
        );
    }

    my $FAQLanguageObject = Kernel::Language->new(
        %{$Self},
        UserLanguage => $FAQItem{Language},
    );

    # get configuration options for Ticket Compose
    my $TicketComposeConfig = $Self->{ConfigObject}->Get('FAQ::TicketCompose');

    # get the internal state type
    my $InternalStateType = $Self->{FAQObject}->StateTypeGet(
        Name   => 'internal',
        UserID => $Self->{UserID},
    );

    # get the internal state type ID
    my $InternalStateID = $InternalStateType->{StateID};

    FIELD:
    for my $Field ( 1 .. 6 ) {

        # don't waste any further processing power, if the current field doesn't have any content
        next FIELD if !$FAQItem{ 'Field' . $Field };

        my $FieldContent = $FAQItem{ 'Field' . $Field };

        # get config of current FAQ field from SysConfig
        my $FieldConfig = $Self->{ConfigObject}->Get( 'FAQ::Item::Field' . $Field );

        next FIELD if !$FieldConfig;
        next FIELD if ref $FieldConfig ne 'HASH';
        next FIELD if !$FieldConfig->{Show};

        # get the state type data of this field
        my $StateTypeData = $Self->{FAQObject}->StateTypeGet(
            Name   => $FieldConfig->{Show},
            UserID => $Self->{UserID},
        );

        # check if current field is internal
        my $IsInternal;
        if ( $StateTypeData->{StateID} == $InternalStateID ) {
            $IsInternal = 1;
        }

        # check whether the current field should be visible to the public, thus be inserted into a
        # response to a customer or not
        if ( !$TicketComposeConfig->{IncludeInternal} && $IsInternal ) {
            next FIELD;
        }

        # extract all URLs which point to an embedded image
        my @MatchedURLs = ( $FieldContent =~ m{$ElemRegex}xgms );
        for my $URL (@MatchedURLs) {

            # extract the id of the attachment
            my ($FileID) = $URL =~ m{ FileID=([0-9]+) }msx;

            if ( $Self->{ConfigObject}->{Debug} > 0 ) {
                $Self->{LogObject}->Log(
                    Priority => 'debug',
                    Message  => "FileID: $FileID",
                );
            }

            # get the attachment to which the current URL points
            my %Attachment = $Self->{FAQObject}->AttachmentGet(
                ItemID => $GetParam{ItemID},
                FileID => $FileID,
                UserID => $Self->{UserID},
            );

            my @AttachmentMeta = $Self->{UploadCacheObject}->FormIDGetAllFilesMeta(
                FormID => $Self->{FormID},
            );

            my $FilenameTmp    = $Attachment{Filename};
            my $SuffixTmp      = 0;
            my $UniqueFilename = '';

            # create now an article attachment (inline) based on the data of %Attachment (FAQ)
            if (%Attachment) {

                # check if name already exists
                while ( !$UniqueFilename ) {
                    $UniqueFilename = $FilenameTmp;
                    NEWNAME:
                    for my $Attachment ( reverse @AttachmentMeta ) {
                        next NEWNAME if $FilenameTmp ne $Attachment->{Filename};

                        # name exists -> change
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

                # add the attachment to the upload cache of the current ticket
                $Self->{UploadCacheObject}->FormIDAddFile(
                    FormID      => $Self->{FormID},
                    Disposition => 'inline',
                    %Attachment,
                );
            }
            else {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => 'Couldn\'t get FAQ attachment '
                        . "(ItemID: $GetParam{ItemID}, FileID: $FileID)!",
                );
                return $Self->{LayoutObject}->ErrorScreen();
            }

            # get new content id
            my $ContentIDNew = '';
            @AttachmentMeta = $Self->{UploadCacheObject}->FormIDGetAllFilesMeta(
                FormID => $Self->{FormID},
            );

            ATTACHMENT:
            for my $Attachment (@AttachmentMeta) {
                next ATTACHMENT if $FilenameTmp ne $Attachment->{Filename};
                $ContentIDNew = $Attachment->{ContentID};
                last ATTACHMENT;
            }

            if ( $ContentIDNew eq '' ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "Couldn't determine a new ContentID!",
                );
                return $Self->{LayoutObject}->ErrorScreen();
            }

            # extract the actual MIME type from the content type, which also contains the filename
            my ($MimeType) = $Attachment{ContentType} =~ m{^(.+/.+); [ ] name=.+$}xms;

            my $Session = '';
            if ( $Self->{SessionID} && !$Self->{SessionIDCookie} ) {
                $Session = '&' . $Self->{SessionName} . '=' . $Self->{SessionID};
            }

            # create the new inline image URL
            my $InlineImage = $Self->{LayoutObject}->{Baselink}
                . "Action=PictureUpload;FormID=$Self->{FormID};ContentID=$ContentIDNew$Session";

            # replace the image URL with the inline image
            $FieldContent =~ s{\Q$URL\E}{$InlineImage}xms;
        }

        # add the name of the field as header
        if ( $FieldConfig->{Caption} && $TicketComposeConfig->{ShowFieldNames} ) {

            # translate the caption to the language of the FAQ item
            my $TranslatedCaption = $FAQLanguageObject->Get( $FieldConfig->{Caption} );

            if ($TranslatedCaption) {
                $FieldContent = '<h2>' . $TranslatedCaption . ':</h2>' . $FieldContent;
            }
        }
        push @Fields, $FieldContent;
    }

    my $FAQHTML = join( '<br />', @Fields );

    # get all non-inline attachments of the FAQ item
    my @Attachments = $Self->{FAQObject}->AttachmentIndex(
        ItemID     => $GetParam{ItemID},
        ShowInline => 0,
        UserID     => $Self->{UserID},
    );

    for my $AttachmentData (@Attachments) {

        # get the attachment
        my %Attachment = $Self->{FAQObject}->AttachmentGet(
            ItemID => $GetParam{ItemID},
            FileID => $AttachmentData->{FileID},
            UserID => $Self->{UserID},
        );

        if (%Attachment) {

            # add the attachment to the upload cache of the current ticket
            $Self->{UploadCacheObject}->FormIDAddFile(
                FormID => $Self->{FormID},
                %Attachment,
            );
        }
        else {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Couldn\'t get FAQ attachment '
                    . "(ItemID: $GetParam{ItemID}, FileID: $AttachmentData->{FileID})!",
            );
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }

    # send a list of attachments in the upload cache back to the client side JavaScript which
    # renders then the list of currently uploaded attachments
    my @TicketAttachments = $Self->{UploadCacheObject}->FormIDGetAllFilesMeta(
        FormID => $Self->{FormID},
    );

    my @FilteredTicketAttachments;

    if ( $Self->{ConfigObject}->Get('Frontend::RichText') ) {

        # remove the inline-attachments which shouldn't be shown in the regular attachment list
        ATTACHMENT:
        for my $Attachment (@TicketAttachments) {
            if ( defined $Attachment->{ContentID} && $Attachment->{ContentID} =~ m{\A inline}msx ) {
                next ATTACHMENT;
            }
            push @FilteredTicketAttachments, $Attachment;
        }
    }
    else {

        # if rich-text is not active then set also inline attachments as regular attachments
        @FilteredTicketAttachments = @TicketAttachments;
    }

    # create a JSON string
    my $JSON = $Self->{JSONObject}->Encode(
        Data => {
            FAQTitle          => $FAQItem{Title},
            FAQContent        => $Self->{HTMLUtilsObject}->ToAscii( String => $FAQHTML ) || '',
            FAQHTMLContent    => $FAQHTML,
            TicketAttachments => \@FilteredTicketAttachments,
            Localization      => {
                Delete => $Self->{LayoutObject}->{LanguageObject}->Translate('Delete'),
            },
        },
    );

    return $Self->{LayoutObject}->Attachment(
        ContentType => 'application/json; charset=' . $Self->{LayoutObject}->{Charset},
        Content     => $JSON,
        Type        => 'inline',
        NoCache     => 1,
    );
}

1;
