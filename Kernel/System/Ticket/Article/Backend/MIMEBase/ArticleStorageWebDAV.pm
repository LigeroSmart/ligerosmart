# --
# Copyright (C) 2001-2020 OTRS AG, https://ligerosmart.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

# check
# perl -e 'use Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageWebDAV;'

package Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageWebDAV;

use strict;
use warnings;

use MIME::Base64;
use MIME::Words qw(:all);
use HTTP::DAV;

use parent qw(Kernel::System::Ticket::Article::Backend::MIMEBase::Base);

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::DynamicFieldValue',
    'Kernel::System::Encode',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageFS',
);

=head1 NAME

Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageWebDAV - WebDAV based ticket article storage interface

=head1 DESCRIPTION

This class provides functions to manipulate ticket articles in the database.
The methods are currently documented in L<Kernel::System::Ticket::Article::Backend::MIMEBase>.

Inherits from L<Kernel::System::Ticket::Article::Backend::MIMEBase::Base>.

See also L<Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageFS>.

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # Call new() on Base.pm to execute the common code.
    my $Self = $Type->SUPER::new(%Param);

    my $WebDAVObject = $Self->WebDAVObject();

    my $ArticleContentPath = $Self->BuildArticleContentPath();

    my @arrArticleDir = split /\//, $ArticleContentPath;

    # Check if dir exists
    my $ArticleDir = '';
    if( !$WebDAVObject->cwd( -url=> "/$ArticleContentPath" ) ) {
        for my $dir (@arrArticleDir) {

            $ArticleDir .= "/$dir";

            if( !$WebDAVObject->cwd( -url=> "$ArticleDir" ) ) {
                # Create dir on WebDAV server
                ### if ( !$WebDAVObject->mkcol( -url => "$url/$ArticleDir" ) ) {
                if ( !$WebDAVObject->mkcol( -url => $ArticleDir ) ) {

                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'notice',
                        Message  => "Can't write $ArticleDir! Check WebDAV path $ArticleDir",
                    );
                    die "Can't write $ArticleDir! Check WebDAV path $ArticleDir";
                }
                $WebDAVObject->cwd( $Param{Path} );
            }
        }
    }

    return $Self;
}

sub ArticleDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Item (qw(ArticleID UserID)) {
        if ( !$Param{$Item} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Item!",
            );
            return;
        }
    }

    # delete attachments
    $Self->ArticleDeleteAttachment(
        ArticleID => $Param{ArticleID},
        UserID    => $Param{UserID},
    );

    # delete plain message
    $Self->ArticleDeletePlain(
        ArticleID => $Param{ArticleID},
        UserID    => $Param{UserID},
    );

    # Delete storage directory in case there are leftovers in the FS.
    $Self->_ArticleDeleteDirectory(
        ArticleID => $Param{ArticleID},
        UserID    => $Param{UserID},
    );

    return 1;
}

sub ArticleDeletePlain {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Item (qw(ArticleID UserID)) {
        if ( !$Param{$Item} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Item!",
            );
            return;
        }
    }
    
    my $WebDAVObject = $Self->WebDAVObject();

    # delete attachments from WebDAV
    my $ContentPath = $Self->_ArticleContentPathGet(
        ArticleID => $Param{ArticleID},
    );
    my $File = "/$ContentPath/$Param{ArticleID}/plain.txt";

    my $Success = $WebDAVObject->delete( $File );

    if ( !$Success ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't remove: $File: $!!",
        );
        return;
    }

    return $Success;
}

sub ArticleDeleteAttachment {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Item (qw(ArticleID UserID)) {
        if ( !$Param{$Item} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Item!",
            );
            return;
        }
    }
    
    my $WebDAVObject = $Self->WebDAVObject();

    # delete from fs
    my $ContentPath = $Self->_ArticleContentPathGet(
        ArticleID => $Param{ArticleID},
    );
    my $Path = "/$ContentPath/$Param{ArticleID}";

    if ( $WebDAVObject->cwd( $Path ) ) {

        # my @List = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
        #     Directory => $Path,
        #     Filter    => "*",
        # );

        # for my $File (@List) {

        #     if ( $File !~ /(\/|\\)plain.txt$/ ) {

        #         if ( !unlink "$File" ) {

        #             $Kernel::OM->Get('Kernel::System::Log')->Log(
        #                 Priority => 'error',
        #                 Message  => "Can't remove: $File: $!!",
        #             );
        #         }
        #     }
        # }
    }


    # delete attachments
    return 1;
}

sub ArticleWritePlain {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Item (qw(ArticleID Email UserID)) {
        if ( !$Param{$Item} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Item!",
            );
            return;
        }
    }
    
    my $WebDAVObject = $Self->WebDAVObject();
    # prepare/filter ArticleID
    $Param{ArticleID} = quotemeta( $Param{ArticleID} );
    $Param{ArticleID} =~ s/\0//g;

    # define path
    my $ContentPath = $Self->_ArticleContentPathGet(
        ArticleID => $Param{ArticleID},
    );
    my $Path = '/' . $ContentPath . '/' . $Param{ArticleID};

    # debug
    if ( defined $Self->{Debug} && $Self->{Debug} > 1 ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log( Message => "->WriteArticle: $Path" );
    }

    # change to path
    if ( !$WebDAVObject->cwd( $Path ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log( Message => " Error on cwd path $Path" );
    }

    # create temp file to write Email
    my $tmp = File::Temp->new();
    # write article to fs
    my $Success = $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
        Location   => $tmp->filename,
        Mode       => 'binmode',
        Content    => \$Param{Email},
        Permission => '660',
    );

    return if !$Success;

    # if( $WebDAVObject->put( -local=>\$tmp->filename, -url=>"plain.txt" ) ) {
    $Success = $WebDAVObject->put( -local=>\$tmp->filename, -url=>"plain.txt" );

    close $tmp;

    return $Success;
}

sub ArticleWriteAttachment {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Item (qw(Filename ContentType ArticleID UserID)) {
        if ( !IsStringWithData( $Param{$Item} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Item!",
            );
            return;
        }
    }
    
    my $WebDAVObject = $Self->WebDAVObject();
    # prepare/filter ArticleID
    $Param{ArticleID} = quotemeta( $Param{ArticleID} );
    $Param{ArticleID} =~ s/\0//g;
    my $ContentPath = $Self->_ArticleContentPathGet(
        ArticleID => $Param{ArticleID},
    );

    # define path
    $Param{Path} = '/' . $ContentPath . '/' . $Param{ArticleID};

    if( !$WebDAVObject->cwd( $Param{Path} ) ) {
        if ( !$WebDAVObject->mkcol( $Param{Path} ) ) {    ## no critic
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Can't create $Param{Path}: $!",
            );
            return;
        }
        $WebDAVObject->cwd( $Param{Path} );
    }

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    $Param{Filename} = $MainObject->FilenameCleanUp(
        Filename => $Param{Filename},
        Type     => 'Local',
    );

    my $NewFileName = $Param{Filename};
    my %UsedFile;
    my %Index = $Self->ArticleAttachmentIndex(
        ArticleID => $Param{ArticleID},
    );

    for my $IndexFile ( sort keys %Index ) {
        $UsedFile{ $Index{$IndexFile}->{Filename} } = 1;
    }
    for ( my $i = 1; $i <= 50; $i++ ) {
        if ( exists $UsedFile{$NewFileName} ) {
            if ( $Param{Filename} =~ /^(.*)\.(.+?)$/ ) {
                $NewFileName = "$1-$i.$2";
            }
            else {
                $NewFileName = "$Param{Filename}-$i";
            }
        }
    }

    $Param{Filename} = $NewFileName;

    # write attachment to backend
    if ( !$WebDAVObject->cwd( $Param{Path} ) ) {
        if ( !$WebDAVObject->mkcol( $Param{Path} ) ) {    ## no critic
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Can't create $Param{Path}: $!",
            );
            return;
        }
        $WebDAVObject->cwd( $Param{Path} );
    }

    # create temp file 
    my $tmpContentType = File::Temp->new();

    # write article to fs
    my $SuccessTmp = $MainObject->FileWrite(
        Filename   => $tmpContentType->filename,
        Mode       => 'binmode',
        Content    => \$Param{ContentType},
    );
    return if !$SuccessTmp;

    # write attachment content type to WebDAV
    my $SuccessContentType = $WebDAVObject->put( 
        -local => $tmpContentType->filename, 
        -url => "$Param{Filename}.content_type"
    );

    return if !$SuccessContentType;
    
    close $tmpContentType;

    # set content id in angle brackets
    if ( $Param{ContentID} ) {
        $Param{ContentID} =~ s/^([^<].*[^>])$/<$1>/;
    }

    # write attachment content id to fs
    if ( $Param{ContentID} ) {
        my $tmpContentId = File::Temp->new();
        $MainObject->FileWrite(
            Filename        => $tmpContentId->filename,
            Mode            => 'binmode',
            Content         => \$Param{ContentID},
        );
        $WebDAVObject->put( 
            -local => $tmpContentId->filename, 
            -url => "$Param{Filename}.content_id"
        );
        close $tmpContentId;
    }

    # write attachment content alternative to WebDAV
    if ( $Param{ContentAlternative} ) {
        my $tmpContentAlternative = File::Temp->new();
        $MainObject->FileWrite(
            Filename        => $tmpContentAlternative->filename,
            Mode            => 'binmode',
            Content         => \$Param{ContentAlternative},
        );
        $WebDAVObject->put( 
            -local => $tmpContentAlternative->filename, 
            -url => "$Param{Filename}.content_alternative"
        );
        close $tmpContentAlternative;
    }
    # write attachment disposition to fs
    if ( $Param{Disposition} ) {

        my ( $Disposition, $FileName ) = split ';', $Param{Disposition};

        my $tmpDisposition = File::Temp->new();

        $MainObject->FileWrite(
            Filename        => $tmpDisposition->filename,
            Mode            => 'binmode',
            Content         => \$Disposition || '',
        );
        $WebDAVObject->put( 
            -local => $tmpDisposition->filename, 
            -url => "$Param{Filename}.disposition"
        );
        close $tmpDisposition;
    }

    # write attachment content to WebDAV
    my $tmpContent = File::Temp->new();
    $MainObject->FileWrite(
        Filename   => $tmpContent->filename,
        Mode       => 'binmode',
        Content    => \$Param{Content},
    );
    my $SuccessContent = $WebDAVObject->put( 
        -local => $tmpContent->filename, 
        -url => $Param{Filename}
    );
    close $tmpContent;

    return if !$SuccessContent;

    return 1;
}

sub ArticlePlain {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ArticleID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need ArticleID!"
        );
        return;
    }
    
    my $WebDAVObject = $Self->WebDAVObject();

    # prepare/filter ArticleID
    $Param{ArticleID} = quotemeta( $Param{ArticleID} );
    $Param{ArticleID} =~ s/\0//g;
    # get content path
    my $ContentPath = $Self->_ArticleContentPathGet(
        ArticleID => $Param{ArticleID},
    );
    # open plain article
    my $PlainArticle = "/$ContentPath/$Param{ArticleID}/plain.txt";
    my $tmpContent = File::Temp->new();

    if ( $WebDAVObject->get( $PlainArticle, $tmpContent->filename ) ) {
        my $Data = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
            Filename  => $tmpContent->filename,
            Mode      => 'binmode',
        );

        return if !$Data;
    }

    close $tmpContent;
}

sub ArticleAttachmentIndexRaw {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ArticleID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ArticleID!'
        );
        return;
    }
    
    my $WebDAVObject = $Self->WebDAVObject();
    my $ContentPath = $Self->_ArticleContentPathGet(
        ArticleID => $Param{ArticleID},
    );
    my %Index;
    my $Counter = 0;

    my $Path = "/$ContentPath/$Param{ArticleID}";
    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    my $WebDAVResource = $WebDAVObject->propfind( $Path );

    my @List = ();

    # my $d = $WebDAVObject->lock( $Path );

    # my $rl_obj = $d->get_lockedresourcelist();

    my %hash = $WebDAVResource->get_resourcelist();

    die($hash);


    
    # foreach my $resource ( $rl_obj->get_resources() ) {
    #     my @locks = $resource->get_locks(-owned=>1);
    #     foreach my $lock ( @locks ) { 
    #     use Data::Dumper;
    #     die($Path, Dumper($resource));
    #     print $resource->get_uri . "\n";
    #     print $lock->as_string . "\n";
    #     }
    #     ## Unlock them?
    #     $resource->unlock;
    # }
    # use Data::Dumper;
    # die(Dumper($WebDAVResource->get_resourcelist()));
    # foreach my $resource ( $WebDAVResource->get_resources() ) {
    #     # push( @List, $resource->get_property('test') );
    #     use Data::Dumper;
    #     die($Path, Dumper($resource{uri}));
    # }
 
    FILENAME:
    for my $Filename ( sort @List ) {
        my $FileSizeRaw = -s $Filename;

        # do not use control file
        next FILENAME if $Filename =~ /\.content_alternative$/;
        next FILENAME if $Filename =~ /\.content_id$/;
        next FILENAME if $Filename =~ /\.content_type$/;
        next FILENAME if $Filename =~ /\.disposition$/;
        next FILENAME if $Filename =~ /\/plain.txt$/;

        # read content type
        my $ContentType = '';
        my $ContentID   = '';
        my $Alternative = '';
        my $Disposition = '';
        if ( -e "$Filename.content_type" ) {
            my $Content = $MainObject->FileRead(
                Location => "$Filename.content_type",
            );
            return if !$Content;
            $ContentType = ${$Content};

            # content id (optional)
            if ( -e "$Filename.content_id" ) {
                my $Content = $MainObject->FileRead(
                    Location => "$Filename.content_id",
                );
                if ($Content) {
                    $ContentID = ${$Content};
                }
            }

            # alternative (optional)
            if ( -e "$Filename.content_alternative" ) {
                my $Content = $MainObject->FileRead(
                    Location => "$Filename.content_alternative",
                );
                if ($Content) {
                    $Alternative = ${$Content};
                }
            }

            # disposition
            if ( -e "$Filename.disposition" ) {
                my $Content = $MainObject->FileRead(
                    Location => "$Filename.disposition",
                );
                if ($Content) {
                    $Disposition = ${$Content};
                }
            }

            # if no content disposition is set images with content id should be inline
            elsif ( $ContentID && $ContentType =~ m{image}i ) {
                $Disposition = 'inline';
            }

            # converted article body should be inline
            elsif ( $Filename =~ m{file-[12]} ) {
                $Disposition = 'inline';
            }

            # all others including attachments with content id that are not images
            #   should NOT be inline
            else {
                $Disposition = 'attachment';
            }
        }

        # read content type (old style)
        else {
            my $Content = $MainObject->FileRead(
                Location => $Filename,
                Result   => 'ARRAY',
            );
            if ( !$Content ) {
                return;
            }
            $ContentType = $Content->[0];
        }

        # strip filename
        $Filename =~ s!^.*/!!;

        # add the info the the hash
        $Counter++;
        $Index{$Counter} = {
            Filename           => $Filename,
            FilesizeRaw        => $FileSizeRaw,
            ContentType        => $ContentType,
            ContentID          => $ContentID,
            ContentAlternative => $Alternative,
            Disposition        => $Disposition,
        };
    }

    return %Index;
}

sub ArticleAttachment {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Item (qw(ArticleID FileID)) {
        if ( !$Param{$Item} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Item!",
            );
            return;
        }
    }
    
    my $WebDAVObject = $Self->WebDAVObject();

    # prepare/filter ArticleID
    $Param{ArticleID} = quotemeta( $Param{ArticleID} );
    $Param{ArticleID} =~ s/\0//g;

    # get attachment index
    my %Index = $Self->ArticleAttachmentIndex(
        ArticleID => $Param{ArticleID},
    );

    # get content path
    my $ContentPath = $Self->_ArticleContentPathGet(
        ArticleID => $Param{ArticleID},
    );
    my %Data    = %{ $Index{ $Param{FileID} } // {} };
    my $Counter = 0;

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    my $Path = "/$ContentPath/$Param{ArticleID}";

    my $WebDAVResource = $WebDAVObject->propfind( $Path );

    my @List = (); # TODO: use WebDAV resource 
    if (@List) {

        # get encode object
        my $EncodeObject = $Kernel::OM->Get('Kernel::System::Encode');

        FILENAME:
        for my $Filename (@List) {
            next FILENAME if $Filename =~ /\.content_alternative$/;
            next FILENAME if $Filename =~ /\.content_id$/;
            next FILENAME if $Filename =~ /\.content_type$/;
            next FILENAME if $Filename =~ /\/plain.txt$/;
            next FILENAME if $Filename =~ /\.disposition$/;

            # add the info the the hash
            $Counter++;
            if ( $Counter == $Param{FileID} ) {

                if ( -e "$Filename.content_type" ) {

                    # read content type
                    my $Content = $MainObject->FileRead(
                        Location => "$Filename.content_type",
                    );
                    return if !$Content;
                    $Data{ContentType} = ${$Content};

                    # read content
                    $Content = $MainObject->FileRead(
                        Location => $Filename,
                        Mode     => 'binmode',
                    );
                    return if !$Content;
                    $Data{Content} = ${$Content};

                    # content id (optional)
                    if ( -e "$Filename.content_id" ) {
                        my $Content = $MainObject->FileRead(
                            Location => "$Filename.content_id",
                        );
                        if ($Content) {
                            $Data{ContentID} = ${$Content};
                        }
                    }

                    # alternative (optional)
                    if ( -e "$Filename.content_alternative" ) {
                        my $Content = $MainObject->FileRead(
                            Location => "$Filename.content_alternative",
                        );
                        if ($Content) {
                            $Data{Alternative} = ${$Content};
                        }
                    }

                    # disposition
                    if ( -e "$Filename.disposition" ) {
                        my $Content = $MainObject->FileRead(
                            Location => "$Filename.disposition",
                        );
                        if ($Content) {
                            $Data{Disposition} = ${$Content};
                        }
                    }

                    # if no content disposition is set images with content id should be inline
                    elsif ( $Data{ContentID} && $Data{ContentType} =~ m{image}i ) {
                        $Data{Disposition} = 'inline';
                    }

                    # converted article body should be inline
                    elsif ( $Filename =~ m{file-[12]} ) {
                        $Data{Disposition} = 'inline';
                    }

                    # all others including attachments with content id that are not images
                    #   should NOT be inline
                    else {
                        $Data{Disposition} = 'attachment';
                    }
                }
                else {

                    # read content
                    my $Content = $MainObject->FileRead(
                        Location => $Filename,
                        Mode     => 'binmode',
                        Result   => 'ARRAY',
                    );
                    return if !$Content;
                    $Data{ContentType} = $Content->[0];
                    my $Counter = 0;
                    for my $Line ( @{$Content} ) {
                        if ($Counter) {
                            $Data{Content} .= $Line;
                        }
                        $Counter++;
                    }
                }
                if (
                    $Data{ContentType} =~ /plain\/text/i
                    && $Data{ContentType} =~ /(utf\-8|utf8)/i
                    )
                {
                    $EncodeObject->EncodeInput( \$Data{Content} );
                }

                chomp $Data{ContentType};

                return %Data;
            }
        }
    }

    return 1;

}

#WebDAV Object
sub WebDAVObject {
    my ( $Self, %Param ) = @_;

    my $WebDAVObject = HTTP::DAV->new();
    
    $WebDAVObject->DebugLevel( 0 );

    $WebDAVObject->credentials(
        -user  => "alice",
        -pass  => "secret1234", 
        -url   => "http://webdav/",
        -realm => "WebDAV"
    );

    $WebDAVObject->open("http://webdav/");

    return $WebDAVObject;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the LigeroSmart (L<https://ligerosmart.com/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
