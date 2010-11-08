# --
# Kernel/Modules/AgentFAQAttachment.pm - to get the attachments
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: AgentFAQAttachment.pm,v 1.2 2010-11-08 22:23:39 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentFAQAttachment;

use strict;
use warnings;

use Kernel::System::FileTemp;
use Kernel::System::FAQ;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ParamObject DBObject LayoutObject LogObject EncodeObject ConfigObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    # create needed objects
    $Self->{FAQObject} = Kernel::System::FAQ->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my %GetParam;

    # get ItemID
    $GetParam{ItemID}            = $Self->{ParamObject}->GetParam( Param => 'ItemID' );
    $GetParam{FileID}            = $Self->{ParamObject}->GetParam( Param => 'FileID' );
    $GetParam{Viewer}            = $Self->{ParamObject}->GetParam( Param => 'Viewer' ) || 0;
    $GetParam{LoadInlineContent} = $Self->{ParamObject}->GetParam( Param => 'LoadInlineContent' )
        || 0;

    # check params
    for my $ParamName (qw(FileID ItemID)) {
        if ( !$GetParam{$ParamName} ) {
            $Self->{LogObject}->Log(
                Message  => "Need $ParamName!",
                Priority => 'error',
            );
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }

    # permission check
    if ( !$Self->{AccessRo} ) {
        return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
    }

    # get FAQ item data
    my %FAQData = $Self->{FAQObject}->FAQGet(
        ItemID => $GetParam{ItemID},
        UserID => $Self->{UserID},
    );

    if ( !%FAQData ) {
        return $Self->{LayoutObject}->ErrorScreen();
    }

    # get attachments
    my %Data = $Self->{FAQObject}->AttachmentGet(
        ItemID => $GetParam{ItemID},
        FileID => $GetParam{FileID},
        UserID => $Self->{UserID},
    );

    # check if attachment exists
    if ( !%Data ) {
        $Self->{LogObject}->Log(
            Message  => "No such attachment ($GetParam{FileID})! May be an attack!!!",
            Priority => 'error',
        );
        return $Self->{LayoutObject}->ErrorScreen();
    }

    # find viewer for ContentType
    my $Viewer = '';
    if ( $Self->{Viewer} && $Self->{ConfigObject}->Get('MIME-Viewer') ) {
        for ( keys %{ $Self->{ConfigObject}->Get('MIME-Viewer') } ) {
            if ( $Data{ContentType} =~ /^$_/i ) {
                $Viewer = $Self->{ConfigObject}->Get('MIME-Viewer')->{$_};
                $Viewer =~ s/\<OTRS_CONFIG_(.+?)\>/$Self->{ConfigObject}->{$1}/g;
            }
        }
    }

    # show with viewer
    if ( $Self->{Viewer} && $Viewer ) {

        # write tmp file
        my $FileTempObject = Kernel::System::FileTemp->new( %{$Self} );
        my ( $FH, $Filename ) = $FileTempObject->TempFile();
        if ( open( my $ViewerDataFH, '>', $Filename ) ) {
            print $ViewerDataFH $Data{Content};
            close $ViewerDataFH;
        }
        else {

            # log error
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Cant write $Filename: $!",
            );
            return $Self->{LayoutObject}->ErrorScreen();
        }

        # use viewer
        my $Content = '';
        if ( open( my $ViewerFH, "$Viewer $Filename |" ) ) {
            while (<$ViewerFH>) {
                $Content .= $_;
            }
            close $ViewerFH;
        }
        else {
            return $Self->{LayoutObject}->FatalError(
                Message => "Can't open: $Viewer $Filename: $!",
            );
        }

        # return new page
        return $Self->{LayoutObject}->Attachment(
            %Data,
            ContentType => 'text/html',
            Content     => $Content,
            Type        => 'inline'
        );
    }

    # view attachment for html email
    if ( $Self->{Subaction} eq 'HTMLView' ) {

        # set download type to inline
        $Self->{ConfigObject}->Set( Key => 'AttachmentDownloadType', Value => 'inline' );

        # just return for non-html attachment (e. g. images)
        if ( $Data{ContentType} !~ /text\/html/i ) {
            return $Self->{LayoutObject}->Attachment(%Data);
        }

        # set filename for inline viewing
        $Data{Filename} = "FAQ-ItemID-$FAQData{ItemID}.html";

        # generate base url
        my $URL = 'Action=AgentFAQAttachment;Subaction=HTMLView'
            . ";itemID=$FAQData{ItemID};FileID=";

        # replace links to inline images in html content
        my %AtmBox = $Self->{FAQObject}->ArticleAttachmentIndex(
            ItemID => $FAQData{ItemID},
            UserID => $Self->{UserID},
        );

        # reformat rich text document to have correct charset and links to
        # inline documents
        %Data = $Self->{LayoutObject}->RichTextDocumentServe(
            Data              => \%Data,
            URL               => $URL,
            Attachments       => \%AtmBox,
            LoadInlineContent => $Self->{LoadInlineContent},
        );

        # return html attachment
        return $Self->{LayoutObject}->Attachment(%Data);
    }

    # download it AttachmentDownloadType is configured
    return $Self->{LayoutObject}->Attachment(%Data);
}

1;
