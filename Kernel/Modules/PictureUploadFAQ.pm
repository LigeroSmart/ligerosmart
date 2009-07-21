# --
# Kernel/Modules/PictureUploadFAQ.pm - get picture uploads for FAQ
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: PictureUploadFAQ.pm,v 1.2 2009-07-21 22:53:02 ub Exp $
# $OldId: PictureUpload.pm,v 1.3 2009/07/19 21:47:15 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

# ---
# FAQ
# ---
#package Kernel::Modules::PictureUpload;
package Kernel::Modules::PictureUploadFAQ;
# ---

use strict;
use warnings;

# ---
# FAQ
# ---
use URI::Escape;
# ---
use Kernel::System::Web::UploadCache;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ParamObject DBObject LayoutObject LogObject ConfigObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    $Self->{UploadCachObject} = Kernel::System::Web::UploadCache->new(%Param);

    $Self->{FormID} = $Self->{ParamObject}->GetParam( Param => 'FormID' );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Output = "Content-Type: text/html; charset="
        . $Self->{ConfigObject}->Get('DefaultCharset') . ";\n\n";
    $Output .= "
<script type=\"text/javascript\">
(function(){var d=document.domain;while (true){try{var A=window.parent.document.domain;break;}catch(e
) {};d=d.replace(/.*?(?:\.|\$)/,'');if (d.length==0) break;try{document.domain=d;}catch (e){break;}}}
)();

";

    if ( !$Self->{FormID} ) {
        $Output .= "window.parent.OnUploadCompleted(404,\"\",\"\",\"\") ;</script>";
        return $Output;
    }

    if ( $Self->{ParamObject}->GetParam( Param => 'ContentID' ) ) {
        my $ContentID = $Self->{ParamObject}->GetParam( Param => 'ContentID' ) || '';

        # return image inline
        my @AttachmentData
            = $Self->{UploadCachObject}->FormIDGetAllFilesData( FormID => $Self->{FormID} );
        ATTACHMENTDATA:
        for my $TmpAttachment (@AttachmentData) {
            next ATTACHMENTDATA if $TmpAttachment->{ContentID} ne $ContentID;
            return $Self->{LayoutObject}->Attachment(
                Type => 'inline',
                %{$TmpAttachment},
            );
        }
    }

    # upload new picture
    my %File = $Self->{ParamObject}->GetUploadAll(
        Param  => 'NewFile',
        Source => 'string',
    );

    if ( !%File ) {
        $Output .= "window.parent.OnUploadCompleted(404,\"-\",\"-\",\"\") ;</script>";
        return $Output;
    }
# ---
# FAQ
# ---
    # uri escape filename
    if ( $Self->{ConfigObject}->Get('DefaultCharset') eq 'utf-8') {
        $File{Filename} = uri_escape_utf8( $File{Filename} )  ;
    }
    else {
        $File{Filename} = uri_escape( $File{Filename} );
    }
# ---

    if ( $File{Filename} !~ /\.(png|gif|jpg|jpeg)$/i ) {
        $Output .= "window.parent.OnUploadCompleted(202,\"-\",\"-\",\"\") ;</script>";
        return $Output;
    }

    my @AttachmentMeta = $Self->{UploadCachObject}->FormIDGetAllFilesMeta(
        FormID => $Self->{FormID}
    );
    my $TmpFilename    = $File{Filename};
    my $TmpSuffix      = 0;
    my $UniqueFilename = '';
    while ( !$UniqueFilename ) {
        $UniqueFilename = $TmpFilename;
        NEWNAME:
        for my $TmpAttachment ( reverse @AttachmentMeta ) {
            next NEWNAME if $TmpFilename ne $TmpAttachment->{Filename};

            # name exists -> change
            ++$TmpSuffix;
            if ( $File{Filename} =~ /^(.*)\.(.+?)$/ ) {
                $TmpFilename = "$1-$TmpSuffix.$2";
            }
            else {
                $TmpFilename = "$File{Filename}-$TmpSuffix";
            }
            $UniqueFilename = '';
            last NEWNAME;
        }
    }
    $Self->{UploadCachObject}->FormIDAddFile(
        FormID      => $Self->{FormID},
        Filename    => $TmpFilename,
        Content     => $File{Content},
        ContentType => $File{ContentType} . '; name="' . $TmpFilename . '"',
        Disposition => 'inline',
    );
    my $ContentID = '';
    @AttachmentMeta = $Self->{UploadCachObject}->FormIDGetAllFilesMeta(
        FormID => $Self->{FormID}
    );
    CONTENTID:
    for my $TmpAttachment (@AttachmentMeta) {
        next CONTENTID if $TmpFilename ne $TmpAttachment->{Filename};
        $ContentID = $TmpAttachment->{ContentID};
        last CONTENTID;
    }

    my $SessionID = '';
    if ( $Self->{SessionID} && !$Self->{SessionIDCookie} ) {
        $SessionID = "&" . $Self->{SessionName} . "=" . $Self->{SessionID};
    }
    my $URL = $Self->{LayoutObject}->{Baselink}
# ---
# FAQ
# ---
#        . "Action=PictureUpload"
        . "Action=PictureUploadFAQ"
# ---
        . "&FormID="
        . $Self->{FormID}
        . "&ContentID="
        . $ContentID
# ---
# FAQ
# ---
        . "&Filename="
        . $TmpFilename
# ---
        . $SessionID;
    $Output .= "window.parent.OnUploadCompleted(0,\"$URL\",\"$URL\",\"\") ;</script>";

    return $Output;
}

1;
