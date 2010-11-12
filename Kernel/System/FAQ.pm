# --
# Kernel/System/FAQ.pm - all faq funktions
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: FAQ.pm,v 1.115 2010-11-12 18:28:09 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::FAQ;

use strict;
use warnings;

use MIME::Base64;
use Kernel::System::Cache;
use Kernel::System::User;
use Kernel::System::Group;
use Kernel::System::CustomerGroup;
use Kernel::System::LinkObject;
use Kernel::System::Ticket;
use Kernel::System::Web::UploadCache;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.115 $) [1];

=head1 NAME

Kernel::System::FAQ - faq lib

=head1 SYNOPSIS

All faq functions. E. g. to add faqs or to get faqs.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a faq object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::Time;
    use Kernel::System::FAQ;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $FAQObject = Kernel::System::FAQ->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        TimeObject   => $TimeObject,
        MainObject   => $MainObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(DBObject ConfigObject LogObject EncodeObject MainObject TimeObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    # create additional objects
    $Self->{GroupObject}         = Kernel::System::Group->new( %{$Self} );
    $Self->{CacheObject}         = Kernel::System::Cache->new( %{$Self} );
    $Self->{CustomerGroupObject} = Kernel::System::CustomerGroup->new( %{$Self} );
    $Self->{UserObject}          = Kernel::System::User->new( %{$Self} );
    $Self->{TicketObject}        = Kernel::System::Ticket->new( %{$Self} );
    $Self->{LinkObject}          = Kernel::System::LinkObject->new( %{$Self} );
    $Self->{UploadCacheObject}   = Kernel::System::Web::UploadCache->new( %{$Self} );

    return $Self;
}

=item FAQGet()

get an faq

    my %FAQ = $FAQObject->FAQGet(
        ItemID => 123,
        UserID => 1,
    );

=cut

sub FAQGet {
    my ( $Self, %Param ) = @_;

    # Failures rename from ItemID to FAQID
    if ( $Param{FAQID} ) {
        $Param{ItemID} = $Param{FAQID};
    }

    # check needed stuff
    for my $Argument (qw(UserID ItemID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get vote data for this FAQ item
    my $VoteData = $Self->ItemVoteDataGet(
        ItemID => $Param{ItemID},
        UserID => $Param{UserID},
    );

    # get number of decimal places from config
    my $DecimalPlaces
        = $Self->{ConfigObject}->Get('FAQ::Explorer::ItemList::VotingResultDecimalPlaces') || 0;

    # format the vote result
    my $VoteResult = sprintf( "%0." . $DecimalPlaces . "f", $VoteData->{Result} || 0 );

    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT i.f_name, i.f_language_id, i.f_subject, ' .
            ' i.f_field1, i.f_field2, i.f_field3, ' .
            ' i.f_field4, i.f_field5, i.f_field6, ' .
            ' i.free_key1, i.free_value1, i.free_key2, i.free_value2, ' .
            ' i.free_key3, i.free_value3, i.free_key4, i.free_value4, ' .
            ' i.created, i.created_by, i.changed, i.changed_by, ' .
            ' i.category_id, i.state_id, c.name, s.name, l.name, i.f_keywords, i.approved, ' .
            ' i.f_number, st.id, st.name ' .
            ' FROM faq_item i, faq_category c, faq_state s, faq_state_type st, faq_language l ' .
            ' WHERE i.state_id = s.id AND s.type_id = st.id AND i.category_id = c.id AND ' .
            ' i.f_language_id = l.id AND i.id = ?',
        Bind => [ \$Param{ItemID} ],
    );

    my %Data;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {

        %Data = (

            # var for old versions
            ID    => $Param{ItemID},
            FAQID => $Param{ItemID},

            # get data attributes
            ItemID        => $Param{ItemID},
            Name          => $Row[0],
            LanguageID    => $Row[1],
            Title         => $Row[2],
            Field1        => $Row[3],
            Field2        => $Row[4],
            Field3        => $Row[5],
            Field4        => $Row[6],
            Field5        => $Row[7],
            Field6        => $Row[8],
            FreeKey1      => $Row[9],
            FreeText1     => $Row[10],
            FreeKey2      => $Row[11],
            FreeText2     => $Row[12],
            FreeKey3      => $Row[13],
            FreeText3     => $Row[14],
            FreeKey4      => $Row[15],
            FreeText4     => $Row[16],
            Created       => $Row[17],
            CreatedBy     => $Row[18],
            Changed       => $Row[19],
            ChangedBy     => $Row[20],
            CategoryID    => $Row[21],
            StateID       => $Row[22],
            CategoryName  => $Row[23],
            State         => $Row[24],
            Language      => $Row[25],
            Keywords      => $Row[26],
            Approved      => $Row[27],
            Number        => $Row[28],
            StateTypeID   => $Row[29],
            StateTypeName => $Row[30],
            VoteResult    => $VoteResult,
            Votes         => $VoteData->{Votes},
        );
    }

    # check error
    if ( !%Data ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "No such ItemID $Param{ItemID}!",
        );
        return;
    }

    # update number
    if ( !$Data{Number} ) {
        my $Number = $Self->{ConfigObject}->Get('SystemID') . '00' . $Data{ItemID};
        return if !$Self->{DBObject}->Do(
            SQL => 'UPDATE faq_item SET f_number = ? WHERE id = ?',
            Bind => [ \$Number, \$Data{ItemID} ],
        );
        $Data{Number} = $Number;
    }

    # get all category long names
    my $CategoryTree = $Self->CategoryTreeList(
        UserID => $Param{UserID},
    );

    # get the category long name
    $Data{CategoryName} = $CategoryTree->{ $Data{CategoryID} };

    return %Data;
}

=item ItemVoteDataGet()

returns a hash with number and result of a item

    my %Flag = $FAQObject->ItemVoteDataGet(
        ItemID => 123,
        UserID => 1,
    );

=cut

sub ItemVoteDataGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(ItemID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # check cache
    my $CacheKey = 'ItemVoteDataGet::' . $Param{ItemID};
    my $Cache    = $Self->{CacheObject}->Get(
        Type => 'FAQ',
        Key  => $CacheKey,
    );
    return $Cache if $Cache;

    # get vote from db
    return if !$Self->{DBObject}->Prepare(
        SQL   => 'SELECT count(*), avg(rate) FROM faq_voting WHERE item_id = ?',
        Bind  => [ \$Param{ItemID} ],
        Limit => $Param{Limit} || 500,
    );
    my %Data;
    if ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Data{Votes}  = $Row[0];
        $Data{Result} = $Row[1];
    }

    # cache result
    $Self->{CacheObject}->Set(
        Type  => 'FAQ',
        Key   => $CacheKey,
        Value => \%Data,
        TTL   => 60 * 60 * 24 * 2,
    );

    return \%Data;
}

=item FAQAdd()

add an article

    my $ItemID = $FAQObject->FAQAdd(
        Title      => 'Some Text',
        CategoryID => 1,
        StateID    => 1,
        LanguageID => 1,
        Number     => '13402',          # (optional)
        Keywords   => 'some keywords',  # (optional)
        Field1     => 'Symptom...',     # (optional)
        Field2     => 'Problem...',     # (optional)
        Field3     => 'Solution...',    # (optional)
        Field4     => 'Field4...',      # (optional)
        Field5     => 'Field5...',      # (optional)
        Field6     => 'Comment...',     # (optional)
        Approved   => 1,                # (optional)
        UserID     => 1,

        # TODO:
        # Remove freetext fields from everywhere in the system,
        # take care of packageupdate too!
        #
        FreeKey1   => 'Software',
        FreeText1  => 'Apache 3.4.2',
        FreeKey2   => 'OS',
        FreeText2  => 'OpenBSD 4.2.2',
    );

=cut

sub FAQAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(CategoryID StateID LanguageID Title UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # check name
    if ( !$Param{Name} ) {
        $Param{Name} = time() . '-' . rand(100);
    }

    # check number
    if ( !$Param{Number} ) {
        $Param{Number} = $Self->{ConfigObject}->Get('SystemID') . rand(100);
    }

    # set default to not approved
    if ( $Self->{ConfigObject}->Get('FAQ::ApprovalRequired') ) {
        if ( !defined $Param{Approved} ) {
            $Param{Approved} = 0;
        }
    }
    else {
        $Param{Approved} = 1;
    }

    return if !$Self->{DBObject}->Do(
        SQL => 'INSERT INTO faq_item (f_number, f_name, f_language_id, f_subject, ' .
            ' category_id, state_id, f_keywords, approved, ' .
            ' f_field1, f_field2, f_field3, f_field4, f_field5, f_field6, ' .
            ' free_key1, free_value1, free_key2, free_value2, ' .
            ' free_key3, free_value3, free_key4, free_value4, ' .
            ' created, created_by, changed, changed_by)' .
            ' VALUES ' .
            ' (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ' .
            ' ?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{Number},     \$Param{Name},      \$Param{LanguageID}, \$Param{Title},
            \$Param{CategoryID}, \$Param{StateID},   \$Param{Keywords},   \$Param{Approved},
            \$Param{Field1},     \$Param{Field2},    \$Param{Field3},
            \$Param{Field4},     \$Param{Field5},    \$Param{Field6},
            \$Param{FreeKey1},   \$Param{FreeText1}, \$Param{FreeKey2},   \$Param{FreeText2},
            \$Param{FreeKey3},   \$Param{FreeText3}, \$Param{FreeKey4},   \$Param{FreeText4},
            \$Param{UserID},     \$Param{UserID},
        ],
    );

    # get id
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id FROM faq_item '
            . 'WHERE f_name = ? '
            . 'AND f_language_id = ? '
            . 'AND f_subject = ?',
        Bind => [
            \$Param{Name},
            \$Param{LanguageID},
            \$Param{Title},
        ],
    );
    my $ID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $ID = $Row[0];
    }

    # update number
    my $Number = $Self->{ConfigObject}->Get('SystemID') . '00' . $ID;
    return if !$Self->{DBObject}->Do(
        SQL => 'UPDATE faq_item SET f_number = ? WHERE id = ?',
        Bind => [ \$Number, \$ID ],
    );

    # add history
    $Self->FAQHistoryAdd(
        Name   => 'Created',
        ItemID => $ID,
        UserID => $Param{UserID},
    );

    # check if approval feature is enabled
    if ( $Self->{ConfigObject}->Get('FAQ::ApprovalRequired') && !$Param{Approved} ) {

        # create new approval ticket
        my $Ok = $Self->FAQApprovalTicketCreate(
            ItemID     => $ID,
            CategoryID => $Param{CategoryID},
            FAQNumber  => $Number,
            Title      => $Param{Title},
            StateID    => $Param{StateID},
            UserID     => $Param{UserID},
        );

        # check error
        if ( !$Ok ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Could not create approval ticket!',
            );
        }
    }

    return $ID;
}

=item FAQUpdate()

update an article

    $FAQObject->FAQUpdate(
        ItemID     => 123,
        CategoryID => 1,
        StateID    => 1,
        LanguageID => 1,
        Title      => 'Some Text',
        Field1     => 'Problem...',
        Field2     => 'Solution...',
        FreeKey1   => 'Software',
        FreeText1  => 'Apache 3.4.2',
        FreeKey2   => 'OS',
        FreeText2  => 'OpenBSD 4.2.2',
        UserID     => 1,
    );

=cut

sub FAQUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(ItemID CategoryID StateID LanguageID Title UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # check name
    if ( !$Param{Name} ) {

        # get faq data
        my %FAQData = $Self->FAQGet(
            ItemID => $Param{ItemID},
            UserID => $Param{UserID},
        );

        # get the faq name
        $Param{Name} = $FAQData{Name};
    }

    return if !$Self->{DBObject}->Do(
        SQL => 'UPDATE faq_item '
            . 'SET f_name = ?, f_language_id = ?, f_subject = ?, '
            . 'category_id = ?, state_id = ?, f_keywords = ?, f_field1 = ?, '
            . 'f_field2 = ?, f_field3 = ?, f_field4 = ?, f_field5 = ?, f_field6 = ?, '
            . 'free_key1 = ?, free_value1 = ?, free_key2 = ?, free_value2 = ?, '
            . 'free_key3 = ?, free_value3 = ?, free_key4 = ?, free_value4 = ?, '
            . 'changed = current_timestamp, changed_by = ? '
            . 'WHERE id = ?',
        Bind => [
            \$Param{Name},     \$Param{LanguageID}, \$Param{Title},    \$Param{CategoryID},
            \$Param{StateID},  \$Param{Keywords},   \$Param{Field1},   \$Param{Field2},
            \$Param{Field3},   \$Param{Field4},     \$Param{Field5},   \$Param{Field6},
            \$Param{FreeKey1}, \$Param{FreeText1},  \$Param{FreeKey2}, \$Param{FreeText2},
            \$Param{FreeKey3}, \$Param{FreeText3},  \$Param{FreeKey4}, \$Param{FreeText4},
            \$Param{UserID},   \$Param{ItemID},
        ],
    );

    # check if history entry should be added
    return 1 if $Param{HistoryOff};

    # write history entry
    $Self->FAQHistoryAdd(
        Name   => 'Updated',
        ItemID => $Param{ItemID},
        UserID => $Param{UserID},
    );

    return 1;
}

=item AttachmentAdd()

add article attachments

    my $Ok = $FAQObject->AttachmentAdd(
        ItemID      => 123,
        Content     => $Content,
        ContentType => 'text/xml',
        Filename    => 'somename.xml',
        Inline      => 1,   (0|1, default 0)
        UserID      => 1,
    );

=cut

sub AttachmentAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(ItemID Content ContentType Filename UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # set default
    if ( !$Param{Inline} ) {
        $Param{Inline} = 0;
    }

    # get attachment size
    {
        use bytes;
        $Param{Filesize} = length $Param{Content};
        no bytes;
    }

    # get all existing attachments
    my @Index = $Self->AttachmentIndex(
        ItemID => $Param{ItemID},
        UserID => $Param{UserID},
    );

    # check if an attachment with same filename and size exists already
    for my $File (@Index) {
        if ( $File->{Filename} eq $Param{Filename} && $Param{Filesize} == $File->{FilesizeRaw} ) {

            # show error
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "File '$Param{Filename}' exists already!",
            );
            return;
        }
    }

    # encode attachment if it's a postgresql backend!!!
    if ( !$Self->{DBObject}->GetDatabaseFunction('DirectBlob') ) {
        $Self->{EncodeObject}->EncodeOutput( \$Param{Content} );
        $Param{Content} = encode_base64( $Param{Content} );
    }

    # write attachment to db
    return $Self->{DBObject}->Do(
        SQL => 'INSERT INTO faq_attachment ' .
            ' (faq_id, filename, content_type, content_size, content, inlineattachment, ' .
            ' created, created_by, changed, changed_by) VALUES ' .
            ' (?, ?, ?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{ItemID},  \$Param{Filename}, \$Param{ContentType}, \$Param{Filesize},
            \$Param{Content}, \$Param{Inline},   \$Param{UserID},      \$Param{UserID},
        ],
    );
}

=item AttachmentGet()

get attachment of article

    my %File = $FAQObject->AttachmentGet(
        ItemID => 123,
        FileID => 1,
        UserID => 1,
    );

=cut

sub AttachmentGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(ItemID FileID UserID)) {
        if ( !defined $Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT filename, content_type, content_size, content '
            . 'FROM faq_attachment '
            . 'WHERE id = ? AND faq_id = ? '
            . 'ORDER BY created',
        Bind => [ \$Param{FileID}, \$Param{ItemID} ],
        Encode => [ 1, 1, 1, 0 ],
        Limit => 1,
    );

    my %File;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {

        # decode attachment if it's a postgresql backend and not BLOB
        if ( !$Self->{DBObject}->GetDatabaseFunction('DirectBlob') ) {
            $Row[3] = decode_base64( $Row[3] );
        }

        $File{Filename}    = $Row[0];
        $File{ContentType} = $Row[1];
        $File{Filesize}    = $Row[2];
        $File{Content}     = $Row[3];
    }

    return %File;
}

=item AttachmentDelete()

delete attachment of article

    my $Ok = $FAQObject->AttachmentDelete(
        ItemID => 123,
        FileID => 1,
        UserID => 1,
    );

=cut

sub AttachmentDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(ItemID FileID UserID)) {
        if ( !defined $Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    return $Self->{DBObject}->Do(
        SQL => 'DELETE FROM faq_attachment WHERE id = ? AND faq_id = ? ',
        Bind => [ \$Param{FileID}, \$Param{ItemID} ],
    );
}

=item AttachmentIndex()

return an attachment index of an article

    my @Index = $FAQObject->AttachmentIndex(
        ItemID     => 123,
        ShowInline => 0,   ( 0|1, default 1)
        UserID     => 1,
    );

=cut

sub AttachmentIndex {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(ItemID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id, filename, content_type, content_size, inlineattachment '
            . 'FROM faq_attachment '
            . 'WHERE faq_id = ? '
            . 'ORDER BY created',
        Bind  => [ \$Param{ItemID} ],
        Limit => 100,
    );
    my @Index = ();
    ATTACHMENT:
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {

        my $ID          = $Row[0];
        my $Filename    = $Row[1];
        my $ContentType = $Row[2];
        my $Filesize    = $Row[3];
        my $Inline      = $Row[4];

        # do not show inline attachments
        if ( defined $Param{ShowInline} && !$Param{ShowInline} && $Inline ) {
            next ATTACHMENT;
        }

        # convert to human readable file size
        my $FileSizeRaw = $Filesize;
        if ($Filesize) {
            if ( $Filesize > ( 1024 * 1024 ) ) {
                $Filesize = sprintf "%.1f MBytes", ( $Filesize / ( 1024 * 1024 ) );
            }
            elsif ( $Filesize > 1024 ) {
                $Filesize = sprintf "%.1f KBytes", ( ( $Filesize / 1024 ) );
            }
            else {
                $Filesize = $Filesize . ' Bytes';
            }
        }

        push @Index, {
            FileID      => $ID,
            Filename    => $Filename,
            ContentType => $ContentType,
            Filesize    => $Filesize,
            FilesizeRaw => $FileSizeRaw,
        };
    }
    return @Index;
}

=item FAQCount()

count an article

    $FAQObject->FAQCount(
        CategoryIDs  => [1,2,3,4],
        OnlyApproved = 1,   # optional (default 0)
        UserID       => 1,
    );

=cut

sub FAQCount {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(CategoryIDs ItemStates UserID)) {
        if ( !defined $Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # build category id string
    my $CategoryIDString = join ', ', @{ $Param{CategoryIDs} };

    my $SQL = 'SELECT COUNT(*) '
        . 'FROM faq_item i, faq_state s '
        . "WHERE i.category_id IN ($CategoryIDString) "
        . 'AND i.state_id = s.id';

    # count only approved articles
    if ( $Param{OnlyApproved} ) {
        $SQL .= ' AND i.approved = 1';
    }

    my $Ext = '';
    if ( $Param{ItemStates} && ref $Param{ItemStates} eq 'HASH' && %{ $Param{ItemStates} } ) {
        my $StatesString = join ', ', keys %{ $Param{ItemStates} };
        $Ext .= " AND s.type_id IN ($StatesString )";
    }
    $Ext .= ' GROUP BY category_id';
    $SQL .= $Ext;

    return if !$Self->{DBObject}->Prepare(
        SQL   => $SQL,
        Limit => 200,
    );

    my $Count = 0;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Count = $Row[0];
    }
    return $Count;
}

=item VoteAdd()

add a vote

    my $Ok = $FAQObject->VoteAdd(
        CreatedBy => 'Some Text',
        ItemID    => '123456',
        IP        => '54.43.30.1',
        Interface => 'Some Text',
        Rate      => 100,
        UserID    => 1,
    );

=cut

sub VoteAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(CreatedBy ItemID IP Interface UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    return if !$Self->{DBObject}->Do(
        SQL => 'INSERT INTO faq_voting (created_by, item_id, ip, interface, rate, created )'
            . ' VALUES ( ?, ?, ?, ?, ?, current_timestamp )',
        Bind => [
            \$Param{CreatedBy}, \$Param{ItemID}, \$Param{IP}, \$Param{Interface},
            \$Param{Rate},
        ],
    );

    # delete cache
    my $CacheKey = 'ItemVoteDataGet::' . $Param{ItemID};
    $Self->{CacheObject}->Delete(
        Type => 'FAQ',
        Key  => $CacheKey,
    );

    return 1;
}

=item VoteGet()

get a vote

    my %VoteData = $FAQObject->VoteGet(
        CreateBy  => 'Some Text',
        ItemID    => '123456',
        IP        => '127.0.0.1',
        Interface => 'Some Text',
        UserID    => 1,
    );

=cut

sub VoteGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(CreateBy ItemID Interface IP UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # db quote
    for my $Argument (qw(CreatedBy Interface IP)) {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument} );
    }
    $Param{ItemID} = $Self->{DBObject}->Quote( $Param{ItemID}, 'Integer' );

    my $Ext = "";
    my $SQL = " SELECT created_by, item_id, interface, ip, created, rate FROM faq_voting WHERE";

    # public
    if ( $Param{Interface} eq '3' ) {
        $Ext .= " ip = '$Param{IP}' AND item_id = $Param{ItemID}";
    }

    # customer
    elsif ( $Param{Interface} eq '2' ) {
        $Ext .= " created_by = '$Param{CreateBy}' AND item_id = $Param{ItemID}";
    }

    # internal
    elsif ( $Param{Interface} eq '1' ) {
        $Ext .= " created_by = '$Param{CreateBy}' AND item_id = $Param{ItemID}";
    }
    $SQL .= $Ext;

    return if !$Self->{DBObject}->Prepare( SQL => $SQL );
    my %Data;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        %Data = (
            CreatedBy => $Row[0],
            ItemID    => $Row[1],
            Interface => $Row[2],
            IP        => $Row[3],
            Created   => $Row[4],
            Rate      => $Row[5],
        );
    }

    return if !%Data;

    return \%Data;
}

=item VoteSearch()

returns an array with VoteIDs

    my $VoteIDArrayref = $FAQObject->VoteSearch(
        ItemID => 1,
        UserID => 1,
    );

=cut

sub VoteSearch {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(ItemID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    return if !$Self->{DBObject}->Prepare(
        SQL   => 'SELECT id FROM faq_voting WHERE item_id = ?',
        Bind  => [ \$Param{ItemID} ],
        Limit => $Param{Limit} || 500,
    );
    my @VoteIDs;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @VoteIDs, $Row[0];
    }
    return \@VoteIDs;
}

=item VoteDelete()

delete a vote

    my $Ok = $FAQObject->VoteDelete(
        VoteID => 1,
        UserID => 1,
    );

=cut

sub VoteDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(VoteID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM faq_voting WHERE id = ?',
        Bind => [ \$Param{VoteID} ],
    );

    return 1;
}

=item FAQDelete()

delete an article

    $Flag = $FAQObject->FAQDelete(
        ItemID => 1,
        UserID => 123,
    );

=cut

sub FAQDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(ItemID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # delete attachments
    my @Index = $Self->AttachmentIndex(
        ItemID => $Param{ItemID},
        UserID => $Param{UserID},
    );
    for my $FileID (@Index) {
        my $DeleteSuccess = $Self->AttachmentDelete(
            %Param,
            FileID => $FileID->{FileID},
            UserID => $Param{UserID},
        );
        return if !$DeleteSuccess;
    }

    # delete votes
    my $VoteIDsRef = $Self->VoteSearch(
        ItemID => $Param{ItemID},
        UserID => $Param{UserID},
    );
    for my $VoteID ( @{$VoteIDsRef} ) {
        my $DeleteSuccess = $Self->VoteDelete(
            VoteID => $VoteID,
            UserID => $Param{UserID},
        );
        return if $DeleteSuccess;
    }

    # delete all faq links of this faq article
    $Self->{LinkObject}->LinkDeleteAll(
        Object => 'FAQ',
        Key    => $Param{ItemID},
        UserID => $Param{UserID},
    );

    # delete history
    return if !$Self->FAQHistoryDelete(
        ItemID => $Param{ItemID},
        UserID => $Param{UserID},
    );

    # delete article
    return $Self->{DBObject}->Do(
        SQL  => 'DELETE FROM faq_item WHERE id = ?',
        Bind => [ \$Param{ItemID} ],
    );
}

=item FAQHistoryAdd()

add an history to an article

    $Flag = $FAQObject->FAQHistoryAdd(
        ItemID => 1,
        Name   => 'Updated Article.',
        UserID => 1,
    );

=cut

sub FAQHistoryAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(ItemID Name UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    return $Self->{DBObject}->Do(
        SQL => 'INSERT INTO faq_history (name, item_id, ' .
            ' created, created_by, changed, changed_by)' .
            ' VALUES ( ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{Name}, \$Param{ItemID}, \$Param{UserID}, \$Param{UserID},
        ],
    );
}

=item FAQHistoryGet()

get an array with hashref (Name, Created) with history of an article back

    my $HistoryDataArrayRef = $FAQObject->FAQHistoryGet(
        ItemID => 1,
        UserID => 1,
    );

=cut

sub FAQHistoryGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(ItemID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    return if !$Self->{DBObject}->Prepare(
        SQL  => 'SELECT name, created, created_by FROM faq_history WHERE item_id = ?',
        Bind => [ \$Param{ItemID} ],
    );
    my @Data;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        my %Record = (
            Name      => $Row[0],
            Created   => $Row[1],
            CreatedBy => $Row[2],
        );
        push @Data, \%Record;
    }
    return \@Data;
}

=item FAQHistoryDelete()

delete an history of an article

    $FAQObject->FAQHistoryDelete(
        ItemID => 1,
        UserID => 1,
    );

=cut

sub FAQHistoryDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(ItemID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM faq_history WHERE item_id = ?',
        Bind => [ \$Param{ItemID} ],
    );

    return 1;
}

=item HistoryGet()

get the system history

    my $HistoryDataArrayRef = $FAQObject->HistoryGet(
        UserID => 1,
    );

=cut

sub HistoryGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need UserID!",
        );
        return;
    }

    # build SQL query
    my $SQL = 'SELECT i.id, h.name, h.created, h.created_by, c.name, i.f_subject, i.f_number '
        . 'FROM faq_item i, faq_state s, faq_history h, faq_category c '
        . 'WHERE s.id = i.state_id '
        . 'AND h.item_id = i.id '
        . 'AND i.category_id = c.id ';

    # add states condition
    if ( $Param{States} && ref $Param{States} eq 'ARRAY' && @{ $Param{States} } ) {
        my $StatesString = join ', ', @{ $Param{States} };
        $SQL .= "AND s.name IN ($StatesString) ";
    }

    # add order by clause
    $SQL .= 'ORDER BY created DESC';

    # get the data from db
    return if !$Self->{DBObject}->Prepare(
        SQL   => $SQL,
        Limit => 200,
    );
    my @Data;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        my %Record = (
            ItemID    => $Row[0],
            Action    => $Row[1],
            Created   => $Row[2],
            CreatedBy => $Row[3],
            Category  => $Row[4],
            Subject   => $Row[5],
            Number    => $Row[6],
        );
        push @Data, \%Record;
    }
    return \@Data;
}

=item CategoryList()

get the category list as hash

    my $CategoryHashRef = $FAQObject->CategoryList(
        Valid  => 1,   # (optional)
        UserID => 1,
    );

=cut

sub CategoryList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need UserID!",
        );
        return;
    }

    # set default
    my $Valid = 0;
    if ( defined $Param{Valid} ) {
        $Valid = $Param{Valid};
    }

    # check cache
    if ( $Self->{Cache}->{CategoryList}->{$Valid} ) {
        return $Self->{Cache}->{CategoryList}->{$Valid};
    }

    # build sql
    my $SQL = 'SELECT id, parent_id, name FROM faq_category ';
    if ($Valid) {
        $SQL .= 'WHERE valid_id = 1';
    }

    # prepare sql statement
    return if !$Self->{DBObject}->Prepare( SQL => $SQL );

    # fetch the result
    my %Data;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Data{ $Row[1] }->{ $Row[0] } = $Row[2];
    }

    # cache
    $Self->{Cache}->{CategoryList}->{$Valid} = \%Data;

    return \%Data;
}

=item CategorySearch()

get the category search as hash

    my $CategoryIDArrayRef = $FAQObject->CategorySearch(
        Name        => 'Test',
        ParentID    => 3,
        ParentIDs   => [ 1, 3, 8 ],
        CategoryIDs => [ 2, 5, 7 ],
        OrderBy     => 'Name',
        SortBy      => 'down',
        UserID      => 1,
    );

=cut

sub CategorySearch {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need UserID!",
        );
        return;
    }

    # sql
    my $SQL = "SELECT id FROM faq_category WHERE valid_id = 1 ";
    my $Ext = '';

    # WHERE
    if ( defined $Param{Name} ) {
        $Ext .= " AND name LIKE '%" . $Self->{DBObject}->Quote( $Param{Name} ) . "%'";
    }
    elsif ( defined $Param{ParentID} ) {
        $Ext .= ' AND parent_id = '
            . $Self->{DBObject}->Quote( $Param{ParentID}, 'Integer' );
    }
    elsif (
        defined $Param{ParentIDs}
        && ref $Param{ParentIDs} eq 'ARRAY'
        && @{ $Param{ParentIDs} }
        )
    {
        $Ext = " AND parent_id IN (";
        for my $ParentID ( @{ $Param{ParentIDs} } ) {
            $Ext .= $Self->{DBObject}->Quote( $ParentID, 'Integer' ) . ",";
        }
        $Ext = substr( $Ext, 0, -1 );
        $Ext .= ")";
    }
    elsif (
        defined $Param{CategoryIDs}
        && ref $Param{CategoryIDs} eq 'ARRAY'
        && @{ $Param{CategoryIDs} }
        )
    {
        $Ext = " AND id IN (";
        for my $CategoryID ( @{ $Param{CategoryIDs} } ) {
            $Ext .= $Self->{DBObject}->Quote( $CategoryID, 'Integer' ) . ",";
        }
        $Ext = substr( $Ext, 0, -1 );
        $Ext .= ")";
    }

    # ORDER BY
    if ( $Param{OrderBy} ) {
        $Ext .= " ORDER BY ";
        if ( $Param{OrderBy} eq 'Name' ) {
            $Ext .= "name";
        }

        # default
        else {
            $Ext .= "name";
        }

        # set the default sort order
        $Param{SortBy} ||= 'up';

        # SORT
        if ( $Param{SortBy} ) {
            if ( $Param{SortBy} eq 'up' ) {
                $Ext .= " ASC";
            }
            elsif ( $Param{SortBy} eq 'down' ) {
                $Ext .= " DESC";
            }
        }
    }

    # SQL STATEMENT
    $SQL .= $Ext;

    return if !$Self->{DBObject}->Prepare(
        SQL   => $SQL,
        Limit => 500,
    );

    my @List;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @List, $Row[0];
    }

    return \@List;
}

=item CategoryGet()

get a category as hash

    my %Category = $FAQObject->CategoryGet(
        CategoryID => 1,
        UserID     => 1,
    );

=cut

sub CategoryGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need UserID!",
        );
        return;
    }

    # check needed stuff
    if ( !defined $Param{CategoryID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need CategoryID!',
        );
        return;
    }

    # check cache
    my $CacheKey = 'CategoryGet::' . $Param{CategoryID};
    my $Cache    = $Self->{CacheObject}->Get(
        Type => 'FAQ',
        Key  => $CacheKey,
    );
    return %{$Cache} if $Cache;

    # sql
    return if !$Self->{DBObject}->Prepare(
        SQL  => 'SELECT id, parent_id, name, comments, valid_id FROM faq_category WHERE id = ?',
        Bind => [ \$Param{CategoryID} ],
    );
    my %Data;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        %Data = (
            CategoryID => $Row[0],
            ParentID   => $Row[1],
            Name       => $Row[2],
            Comment    => $Row[3],
            ValidID    => $Row[4],
        );
    }

    # cache result
    $Self->{CacheObject}->Set(
        Type  => 'FAQ',
        Key   => $CacheKey,
        Value => \%Data,
        TTL   => 60 * 60 * 24 * 2,
    );

    return %Data;
}

=item CategorySubCategoryIDList()

get all subcategory ids of of a category

    my $SubCategoryIDArrayRef = $FAQObject->CategorySubCategoryIDList(
        ParentID     => 1,
        Mode         => 'Public', # (Agent, Customer, Public)
        CustomerUser => 'tt',
        UserID       => 1,
    );

=cut

sub CategorySubCategoryIDList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need UserID!",
        );
        return;
    }

    # check needed stuff
    if ( !defined $Param{ParentID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need ParentID!',
        );
        return;
    }

    my $Categories = {};

    if ( $Param{Mode} && $Param{Mode} eq 'Agent' ) {

        # get agents categories
        $Categories = $Self->GetUserCategories(
            Type   => 'ro',
            UserID => $Param{UserID},
        );
    }
    elsif ( $Param{Mode} && $Param{Mode} eq 'Customer' ) {

        # get customer categories
        $Categories = $Self->GetCustomerCategories(
            Type         => 'ro',
            CustomerUser => $Param{CustomerUser},
            UserID       => $Param{UserID},
        );
    }
    else {

        # get all categories
        $Categories = $Self->CategoryList(
            Valid  => 1,
            UserID => $Param{UserID},
        );
    }

    my @SubCategoryIDs     = ();
    my @TempSubCategoryIDs = keys %{ $Categories->{ $Param{ParentID} } };
    SUBCATEGORYID:
    while (@TempSubCategoryIDs) {

        # get next subcategory id
        my $SubCategoryID = shift @TempSubCategoryIDs;

        # add to result
        push @SubCategoryIDs, $SubCategoryID;

        # check if subcategory has own subcategories
        next SUBCATEGORYID if !$Categories->{$SubCategoryID};

        # add new subcategories
        push @TempSubCategoryIDs, keys %{ $Categories->{$SubCategoryID} };
    }

    # sort subcategories numerically
    @SubCategoryIDs = sort { $a <=> $b } @SubCategoryIDs;

    return \@SubCategoryIDs;
}

=item CategoryAdd()

add a category

    my $CategoryID = $FAQObject->CategoryAdd(
        Name     => 'CategoryA',
        Comment  => 'Some comment',
        ParentID => 2,
        ValidID  => 1,
        UserID   => 1,
    );

=cut

sub CategoryAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Name UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # check needed stuff
    if ( !defined $Param{ParentID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need ParentID!",
        );
        return;
    }

    # insert record
    return if !$Self->{DBObject}->Do(
        SQL => 'INSERT INTO faq_category '
            . '(name, parent_id, comments, valid_id, created, created_by, changed, changed_by) '
            . 'VALUES ( ?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{Name}, \$Param{ParentID}, \$Param{Comment}, \$Param{ValidID},
            \$Param{UserID}, \$Param{UserID},
        ],
    );

    # get new category id
    return if !$Self->{DBObject}->Prepare(
        SQL  => 'SELECT id FROM faq_category WHERE name = ?',
        Bind => [ \$Param{Name} ],
    );
    my $CategoryID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $CategoryID = $Row[0];
    }

    # log notice
    $Self->{LogObject}->Log(
        Priority => 'notice',
        Message  => "FAQCategory: '$Param{Name}' CategoryID: '$CategoryID' "
            . "created successfully ($Param{UserID})!",
    );

    return $CategoryID;
}

=item CategoryUpdate()

update a category

    my $Success = $FAQObject->CategoryUpdate(
        CategoryID => 2,
        ParentID   => 1,
        Name       => 'Some Category',
        Comment    => 'some comment',
        UserID     => 1,
    );

=cut

sub CategoryUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Name UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # check needed stuff
    for my $Argument (qw(CategoryID ParentID)) {
        if ( !defined $Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # sql
    return if !$Self->{DBObject}->Do(
        SQL => 'UPDATE faq_category SET '
            . 'parent_id = ?, name = ?, '
            . 'comments = ?, valid_id = ?, changed = current_timestamp, '
            . 'changed_by = ? WHERE id = ?',
        Bind => [
            \$Param{ParentID}, \$Param{Name},
            \$Param{Comment},  \$Param{ValidID},
            \$Param{UserID},   \$Param{CategoryID},
        ],
    );

    # log notice
    $Self->{LogObject}->Log(
        Priority => 'notice',
        Message  => "FAQCategory: '$Param{Name}' "
            . "ID: '$Param{CategoryID}' updated successfully ($Param{UserID})!",
    );

    # delete cache
    my $CacheKey = 'CategoryGet::' . $Param{CategoryID};
    $Self->{CacheObject}->Delete(
        Type => 'FAQ',
        Key  => $CacheKey,
    );

    return 1;
}

=item CategoryDuplicateCheck()

check a category

    my $Exists = $FAQObject->CategoryDuplicateCheck(
        CategoryID => 1,
        Name       => 'Some Name',
        ParentID   => 1,
        UserID     => 1,
    );

=cut

sub CategoryDuplicateCheck {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need UserID!",
        );
        return;
    }

    # set defaults
    $Param{CategoryID} ||= 0;
    $Param{ParentID}   ||= 0;

    # db quote
    $Param{Name} = $Self->{DBObject}->Quote( $Param{Name} ) || '';
    $Param{CategoryID} = $Self->{DBObject}->Quote( $Param{CategoryID}, 'Integer' );
    $Param{ParentID}   = $Self->{DBObject}->Quote( $Param{ParentID},   'Integer' );

    # build sql
    my $SQL = 'SELECT id FROM faq_category WHERE ';
    if ( defined $Param{Name} ) {
        $SQL .= "name = '$Param{Name}' AND parent_id = $Param{ParentID} ";
        if ( defined $Param{CategoryID} ) {
            $SQL .= "AND id != $Param{CategoryID}";
        }
    }

    # prepare sql statement
    return if !$Self->{DBObject}->Prepare( SQL => $SQL );

    # fetct the result
    my $Exists;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Exists = 1;
    }

    return $Exists;
}

=item CategoryCount()

Count the number of categories.

    $FAQObject->CategoryCount(
        ParentIDs => [ 1,2,3,4 ],
        UserID    => 1,
    );

=cut

sub CategoryCount {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );
        return;
    }

    # check needed stuff
    if ( !defined $Param{ParentIDs} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need ParentIDs!',
        );
        return;
    }

    my $SQL = 'SELECT COUNT(*) FROM faq_category WHERE valid_id = 1';

    my $Ext = '';
    if ( defined $Param{ParentIDs} ) {
        $Ext = ' AND parent_id IN (';
        for my $ParentID ( @{ $Param{ParentIDs} } ) {
            $Ext .= $Self->{DBObject}->Quote( $ParentID, 'Integer' ) . ",";
        }
        $Ext = substr( $Ext, 0, -1 );
        $Ext .= ')';
    }
    $Ext .= ' GROUP BY parent_id';

    $SQL .= $Ext;
    return if !$Self->{DBObject}->Prepare(
        SQL   => $SQL,
        Limit => 200,
    );

    my $Count = 0;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Count = $Row[0];
    }
    return $Count;
}

=item CategoryTreeList()

get all categories as tree (with their long names)

    my $CategoryTree = $FAQObject->CategoryTreeList(
        Valid  => 0,  # (0|1, optional)
        UserID => 1,
    );

=cut

sub CategoryTreeList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need UserID!",
        );
        return;
    }

    # set default
    my $Valid = 0;
    if ( $Param{Valid} ) {
        $Valid = $Param{Valid};
    }

    # check cache
    if ( $Self->{Cache}->{GetCategoryTree}->{$Valid} ) {
        return $Self->{Cache}->{GetCategoryTree}->{$Valid};
    }

    # build sql
    my $SQL = 'SELECT id, parent_id, name FROM faq_category';

    # add where clause for valid categories
    if ($Valid) {
        $SQL .= ' WHERE valid_id = 1';
    }

    # prepare sql
    return if !$Self->{DBObject}->Prepare(
        SQL => $SQL,
    );

    # fetch result
    my %CategoryMap;
    my %CategoryNameLookup;
    my %ParentIDLookup;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $CategoryMap{ $Row[1] }->{ $Row[0] } = $Row[2];
        $CategoryNameLookup{ $Row[0] }       = $Row[2];
        $ParentIDLookup{ $Row[0] }           = $Row[1];
    }

    # to store the category tree
    my %CategoryTree;

    # check all parent ids
    for my $ParentID ( sort { $a <=> $b } keys %CategoryMap ) {

        # get subcategories and names for this parent id
        while ( my ( $CategoryID, $CategoryName ) = each %{ $CategoryMap{$ParentID} } ) {

            # lookup the parents name
            my $NewParentID = $ParentID;
            while ($NewParentID) {

                # prepend parents category name
                if ( $CategoryNameLookup{$NewParentID} ) {
                    $CategoryName = $CategoryNameLookup{$NewParentID} . '::' . $CategoryName;
                }

                # get up one parent level
                $NewParentID = $ParentIDLookup{$NewParentID} || 0;
            }

            # add category to tree
            $CategoryTree{$CategoryID} = $CategoryName;
        }
    }

    # cache
    $Self->{Cache}->{GetCategoryTree}->{$Valid} = \%CategoryTree;

    return \%CategoryTree;
}

=item CategoryGroupGet()

get groups of a category

    my $GroupArrayRef = $FAQObject->CategoryGroupGet(
        CategoryID => 3,
        UserID     => 1,
    );

=cut

sub CategoryGroupGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(CategoryID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get groups
    return if !$Self->{DBObject}->Prepare(
        SQL  => 'SELECT group_id FROM faq_category_group WHERE category_id = ?',
        Bind => [ \$Param{CategoryID} ],
    );
    my @Groups;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @Groups, $Row[0];
    }
    return \@Groups;
}

=item CategoryGroupGetAll()

get all category-groups

    my $AllCategoryGroupHashRef = $FAQObject->CategoryGroupGetAll(
        UserID => 1,
    );

=cut

sub CategoryGroupGetAll {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need UserID!",
        );
        return;
    }

    # check cache
    if ( $Self->{Cache}->{CategoryGroupGetAll} ) {
        return $Self->{Cache}->{CategoryGroupGetAll};
    }

    # get groups
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT group_id, category_id FROM faq_category_group',
    );
    my %Groups;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Groups{ $Row[1] }->{ $Row[0] } = 1;
    }

    # cache
    $Self->{Cache}->{CategoryGroupGetAll} = \%Groups;

    return \%Groups;
}

=item KeywordList()

get a list of keywords as a hash, with their count as the value:

    my %Keywords = $FAQObject->KeywordList(
        Valid  => 1,
        UserID => 1,
    );

Returns:

    %Keywords = (
          'macosx'   => 8,
          'ubuntu'   => 1,
          'outlook'  => 2,
          'windows'  => 3,
          'exchange' => 1,
    );

=cut

sub KeywordList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );
        return;
    }

    # set default
    my $Valid = 0;
    if ( defined $Param{Valid} ) {
        $Valid = $Param{Valid};
    }

    # get keywords from db
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT f_keywords FROM faq_item',
    );
    my %Data;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {

        my $KeywordList = lc $Row[0];

        for my $Keyword ( split /,/, $KeywordList ) {

            # remove leading/tailing spaces
            $Keyword =~ s{ \A \s+ }{}xmsg;
            $Keyword =~ s{ \s+ \z }{}xmsg;

            # increase keyword counter
            $Data{$Keyword}++;
        }
    }

    return %Data;
}

=item StateTypeList()

get the state type list as hashref

    my $StateTypeHashRef = $FAQObject->StateTypeList(
        UserID => 1,
    );

=cut

sub StateTypeList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );
        return;
    }

    my $Ext = '';
    my $SQL = 'SELECT id, name FROM faq_state_type';

    if ( $Param{Types} ) {
        my @States = @{ $Param{Types} };
        $Ext = ' WHERE';
        for my $State (@States) {
            $Ext .= " name = '" . $Self->{DBObject}->Quote($State) . "' OR";
        }
        $Ext = substr( $Ext, 0, -3 );
    }
    $SQL .= $Ext;

    # sql
    my %List = ();
    return if !$Self->{DBObject}->Prepare( SQL => $SQL );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $List{ $Row[0] } = $Row[1];
    }
    return \%List;
}

=item StateList()

get the state list as hash

    my %States = $FAQObject->StateList(
        UserID => 1,
    );

=cut

sub StateList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );
        return;
    }

    # sql
    return if !$Self->{DBObject}->Prepare( SQL => 'SELECT id, name FROM faq_state' );
    my %List;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $List{ $Row[0] } = $Row[1];
    }
    return %List;
}

=item StateUpdate()

update a state

    $FAQObject->StateUpdate(
        StateID => 1,
        Name    => 'public',
        TypeID  => 1,
        UserID  => 1,
    );

=cut

sub StateUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(StateID Name TypeID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # sql
    return if !$Self->{DBObject}->Do(
        SQL => 'UPDATE faq_state SET name = ?, type_id = ?, WHERE id = ?',
        Bind => [ \$Param{Name}, \$Param{TypeID}, \$Param{StateID} ],
    );

    return 1;
}

=item StateAdd()

add a state

    my $ID = $FAQObject->StateAdd(
        Name   => 'public',
        TypeID => 1,
        UserID => 1,
    );

=cut

sub StateAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Name TypeID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    return if !$Self->{DBObject}->Do(
        SQL => 'INSERT INTO faq_state (name, type_id) VALUES ( ?, ? )',
        Bind => [ \$Param{Name}, \$Param{TypeID} ],
    );

    return 1;
}

=item StateGet()

get a state as hash

    my %State = $FAQObject->StateGet(
        StateID => 1,
        UserID  => 1,
    );

=cut

sub StateGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(StateID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # sql
    return if !$Self->{DBObject}->Prepare(
        SQL  => 'SELECT id, name FROM faq_state WHERE id = ?',
        Bind => [ \$Param{StateID} ],
    );
    my %Data;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        %Data = (
            StateID => $Row[0],
            Name    => $Row[1],
            Comment => $Row[2],
        );
    }
    return %Data;
}

=item StateTypeGet()

get a state as hashref

    my $StateTypeHashRef = $FAQObject->StateTypeGet(
        StateID => 1, # or
        Name    => 'internal',
        UserID  => 1,
    );

=cut

sub StateTypeGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need UserID!",
        );
        return;
    }

    my $SQL = 'SELECT id, name FROM faq_state_type WHERE ';
    my @Bind;
    my $CacheKey = 'StateTypeGet::';
    if ( defined $Param{StateID} ) {
        $SQL .= 'id = ?';
        push @Bind, \$Param{StateID};
        $CacheKey .= 'ID::' . $Param{StateID};
    }
    elsif ( defined $Param{Name} ) {
        $SQL .= 'name = ?';
        push @Bind, \$Param{Name};
        $CacheKey .= 'Name::' . $Param{Name};
    }

    # check cache
    my $Cache = $Self->{CacheObject}->Get(
        Type => 'FAQ',
        Key  => $CacheKey,
    );
    return $Cache if $Cache;

    # sql
    return if !$Self->{DBObject}->Prepare(
        SQL  => $SQL,
        Bind => \@Bind,
    );
    my %Data;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        %Data = (
            StateID => $Row[0],
            Name    => $Row[1],
        );
    }

    # cache result
    $Self->{CacheObject}->Set(
        Type  => 'FAQ',
        Key   => $CacheKey,
        Value => \%Data,
        TTL   => 60 * 60 * 24 * 2,
    );

    return \%Data;
}

=item LanguageList()

get the language list as hash

    my %Languages = $FAQObject->LanguageList(
        UserID => 1,
    );

=cut

sub LanguageList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need UserID!",
        );
        return;
    }

    # build sql
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id, name FROM faq_language',
    );

    # fetch the result
    my %List;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $List{ $Row[0] } = $Row[1];
    }

    return %List;
}

=item LanguageUpdate()

update a language

    my $Success = $FAQObject->LanguageUpdate(
        LanguageID => 1,
        Name       => 'de',
        UserID     => 1,
    );

=cut

sub LanguageUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(LanguageID Name UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # build sql
    return if !$Self->{DBObject}->Do(
        SQL => 'UPDATE faq_language SET name = ? WHERE id = ?',
        Bind => [ \$Param{Name}, \$Param{LanguageID} ],
    );

    return 1;
}

=item LanguageDuplicateCheck()

check a language

    my $Exists = $FAQObject->LanguageDuplicateCheck(
        Name       => 'Some Name',
        LanguageID => 1, # for update
        UserID     => 1,
    );

=cut

sub LanguageDuplicateCheck {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need UserID!",
        );
        return;
    }

    # db quote
    $Param{Name} = $Self->{DBObject}->Quote( $Param{Name} ) || '';
    $Param{LanguageID} = $Self->{DBObject}->Quote( $Param{LanguageID}, 'Integer' );

    # build sql
    my $SQL = 'SELECT id FROM faq_language WHERE ';
    if ( defined $Param{Name} ) {
        $SQL .= "name = '$Param{Name}' ";
    }
    if ( defined $Param{LanguageID} ) {
        $SQL .= "AND id != '$Param{LanguageID}' ";
    }

    # prepare sql statement
    return if !$Self->{DBObject}->Prepare( SQL => $SQL );

    # fetch the result
    my $Exists;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Exists = 1;
    }

    return $Exists;
}

=item LanguageAdd()

add a language

    my $Success = $FAQObject->LanguageAdd(
        Name   => 'Some Category',
        UserID => 1,
    );

=cut

sub LanguageAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Name UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    return if !$Self->{DBObject}->Do(
        SQL  => 'INSERT INTO faq_language (name) VALUES (?)',
        Bind => [ \$Param{Name} ],
    );

    return 1;
}

=item LanguageGet()

get a language as hash

    my %Language = $FAQObject->LanguageGet(
        LanguageID => 1,
        UserID     => 1,
    );

=cut

sub LanguageGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(LanguageID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # sql
    return if !$Self->{DBObject}->Prepare(
        SQL  => 'SELECT id, name FROM faq_language WHERE id = ?',
        Bind => [ \$Param{LanguageID} ],
    );
    my %Data;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        %Data = (
            LanguageID => $Row[0],
            Name       => $Row[1],
        );
    }
    return %Data;
}

=item LanguageLookup()

This method does a lookup for a faq language.
If a language id is given, it returns the name of the language.
If the name of the language is given, the language id is returned.

    my $LanguageName = $FAQObject->LanguageLookup(
        LanguageID => 1,
    );

    my $LanguageID = $FAQObject->LanguageLookup(
        Name => 'en',
    );

=cut

sub LanguageLookup {
    my ( $Self, %Param ) = @_;

    # check if both parameters are given
    if ( $Param{LanguageID} && $Param{Name} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need LanguageID or Name - not both!',
        );
        return;
    }

    # check if both parameters are not given
    if ( !$Param{LanguageID} && !$Param{Name} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need LanguageID or Name - none is given!',
        );
        return;
    }

    # check if LanguageID is a number
    if ( $Param{LanguageID} && $Param{LanguageID} !~ m{ \A \d+ \z }xms ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "LanguageID must be a number! (LanguageID: $Param{LanguageID})",
        );
        return;
    }

    # prepare SQL statements
    if ( $Param{LanguageID} ) {
        return if !$Self->{DBObject}->Prepare(
            SQL   => 'SELECT name FROM faq_language WHERE id = ?',
            Bind  => [ \$Param{LanguageID} ],
            Limit => 1,
        );
    }
    elsif ( $Param{Name} ) {
        return if !$Self->{DBObject}->Prepare(
            SQL   => 'SELECT id FROM faq_language WHERE name = ?',
            Bind  => [ \$Param{Name} ],
            Limit => 1,
        );
    }

    # fetch the result
    my $Lookup;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Lookup = $Row[0];
    }

    return $Lookup;
}

=item FAQSearch()

search in articles

    my @IDs = $FAQObject->FAQSearch(
        Number    => '*134*',
        Title     => '*some title*',
        What      => '*some text*', # is searching in Number, Title, Keyword and Field1-6
        Keyword   => '*webserver*',
        States    => ['public', 'internal'],

        OrderBy => [ 'FAQID', 'Title' ],                             # (optional)
        # default: [ 'FAQID' ],
        # (FAQID, FAQNumber, Title, Language, Category, Created,
        # Changed, State, Votes, Result)

        # Additional information for OrderBy:
        # The OrderByDirection can be specified for each OrderBy attribute.
        # The pairing is made by the array indices.

        OrderByDirection => [ 'Down', 'Up' ],                          # (optional)
        # ignored when the result type is 'COUNT'
        # default: [ 'Down' ]
        # (Down | Up)

        Limit     => 150,
        Interface => 'public',      # public|external|internal (default internal)
        UserID    => 1,
    );

=cut

sub FAQSearch {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need UserID!",
        );
        return;
    }

    # set default
    if ( !$Param{Interface} ) {
        $Param{Interface} = 'internal';
    }

    # verify that all passed array parameters contain an arrayref
    ARGUMENT:
    for my $Argument (qw(OrderBy OrderByDirection)) {

        if ( !defined $Param{$Argument} ) {
            $Param{$Argument} ||= [];

            next ARGUMENT;
        }

        if ( ref $Param{$Argument} ne 'ARRAY' ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "$Argument must be an array reference!",
            );
            return;
        }
    }

    # define order table
    my %OrderByTable = (

        # FAQ item attributes
        FAQID     => 'i.id',
        FAQNumber => 'i.f_number',
        Title     => 'i.f_subject',
        Language  => 'i.f_language_id',
        Category  => 'i.category_id',
        Created   => 'i.created',
        Changed   => 'i.changed',

        # State attributes
        State => 's.name',

        # Vote attributes
        Votes  => 'votes',
        Result => 'vrate',
    );

    # check if OrderBy contains only unique valid values
    my %OrderBySeen;
    for my $OrderBy ( @{ $Param{OrderBy} } ) {

        if ( !$OrderBy || !$OrderByTable{$OrderBy} || $OrderBySeen{$OrderBy} ) {

            # found an error
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "OrderBy contains invalid value '$OrderBy' "
                    . 'or the value is used more than once!',
            );
            return;
        }

        # remember the value to check if it appears more than once
        $OrderBySeen{$OrderBy} = 1;

    }

    # check if OrderByDirection array contains only 'Up' or 'Down'
    DIRECTION:
    for my $Direction ( @{ $Param{OrderByDirection} } ) {

        # only 'Up' or 'Down' allowed
        next DIRECTION if $Direction eq 'Up';
        next DIRECTION if $Direction eq 'Down';

        # found an error
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "OrderByDirection can only contain 'Up' or 'Down'!",
        );
        return;
    }

    # assemble the ORDER BY clause
    my @SQLOrderBy;
    my $Count = 0;
    for my $OrderBy ( @{ $Param{OrderBy} } ) {

        # set the default order direction
        my $Direction = 'DESC';

        # add the given order direction
        if ( $Param{OrderByDirection}->[$Count] ) {
            if ( $Param{OrderByDirection}->[$Count] eq 'Up' ) {
                $Direction = 'ASC';
            }
            elsif ( $Param{OrderByDirection}->[$Count] eq 'Down' ) {
                $Direction = 'DESC';
            }
        }

        # add SQL
        push @SQLOrderBy, "$OrderByTable{$OrderBy} $Direction";
    }
    continue {
        $Count++;
    }

    # if there is a possibility that the ordering is not determined
    # we add an descending ordering by id
    if ( !grep { $_ eq 'FAQID' } ( @{ $Param{OrderBy} } ) ) {
        push @SQLOrderBy, "$OrderByTable{FAQID} DESC";
    }

    # sql
    my $SQL = 'SELECT i.id, count( v.item_id ) as votes, avg( v.rate ) as vrate '
        . 'FROM faq_item i '
        . 'LEFT JOIN faq_voting v ON v.item_id = i.id '
        . 'LEFT JOIN faq_state s ON s.id = i.state_id';
    my $Ext = '';

    if ( $Param{What} && $Param{What} ne '*' ) {
        my @SearchFields = ( 'i.f_number', 'i.f_subject', 'i.f_keywords' );
        if ( $Param{Interface} eq 'internal' ) {
            for my $Number ( 1 .. 6 ) {
                if (
                    $Self->{ConfigObject}->Get("FAQ::Item::Field$Number")->{Show} eq 'public' ||
                    $Self->{ConfigObject}->Get("FAQ::Item::Field$Number")->{Show} eq 'internal' ||
                    $Self->{ConfigObject}->Get("FAQ::Item::Field$Number")->{Show} eq 'external'
                    )
                {
                    push @SearchFields, "i.f_field$Number";
                }
            }
        }
        elsif ( $Param{Interface} eq 'external' ) {
            for my $Number ( 1 .. 6 ) {
                if (
                    $Self->{ConfigObject}->Get("FAQ::Item::Field$Number")->{Show} eq 'public' ||
                    $Self->{ConfigObject}->Get("FAQ::Item::Field$Number")->{Show} eq 'external'
                    )
                {
                    push @SearchFields, "i.f_field$Number";
                }
            }
        }
        else {
            for my $Number ( 1 .. 6 ) {
                if ( $Self->{ConfigObject}->Get("FAQ::Item::Field$Number")->{Show} eq 'public' ) {
                    push @SearchFields, "i.f_field$Number";
                }
            }
        }

        $Ext .= $Self->{DBObject}->QueryCondition(
            Key          => \@SearchFields,
            Value        => $Param{What},
            SearchPrefix => '*',
            SearchSuffix => '*',
        ) . ' ';
    }
    if ( $Param{Number} ) {
        $Param{Number} =~ s/\*/%/g;
        $Param{Number} =~ s/%%/%/g;
        $Param{Number} = $Self->{DBObject}->Quote( $Param{Number} );
        if ($Ext) {
            $Ext .= ' AND';
        }
        $Ext .= " LOWER(i.f_number) LIKE LOWER('$Param{Number}')";
    }
    if ( $Param{Title} ) {
        $Param{Title} = "\%$Param{Title}\%";
        $Param{Title} =~ s/\*/%/g;
        $Param{Title} =~ s/%%/%/g;
        $Param{Title} = $Self->{DBObject}->Quote( $Param{Title} );
        if ($Ext) {
            $Ext .= ' AND';
        }
        $Ext .= " LOWER(i.f_subject) LIKE LOWER('" . $Param{Title} . "')";
    }
    if ( $Param{LanguageIDs} && ref $Param{LanguageIDs} eq 'ARRAY' && @{ $Param{LanguageIDs} } ) {
        if ($Ext) {
            $Ext .= ' AND';
        }
        $Ext .= ' i.f_language_id IN (';
        for my $LanguageID ( @{ $Param{LanguageIDs} } ) {
            $Ext .= $Self->{DBObject}->Quote( $LanguageID, 'Integer' ) . ',';
        }
        $Ext = substr( $Ext, 0, -1 );
        $Ext .= ')';
    }
    if ( $Param{CategoryIDs} && ref $Param{CategoryIDs} eq 'ARRAY' && @{ $Param{CategoryIDs} } )
    {
        if ($Ext) {
            $Ext .= ' AND';
        }
        $Ext .= ' (i.category_id IN  (';
        my $Counter = 0;
        for my $CategoryID ( @{ $Param{CategoryIDs} } ) {
            $Ext .= $Self->{DBObject}->Quote( $CategoryID, 'Integer' ) . ',';
            $Counter++;
            if ( !( $Counter % 500 ) ) {
                $Ext = substr( $Ext, 0, -1 );
                $Ext .= ')';
                $Ext .= ' OR i.category_id IN  (';
            }
        }
        $Ext = substr( $Ext, 0, -1 );
        $Ext .= '))';
    }
    if ( $Param{States} && ref $Param{States} eq 'HASH' && %{ $Param{States} } ) {
        if ($Ext) {
            $Ext .= ' AND';
        }
        $Ext .= ' s.type_id IN (';
        for my $StateID ( keys( %{ $Param{States} } ) ) {
            $Ext .= $Self->{DBObject}->Quote( $StateID, 'Integer' ) . ',';
        }
        $Ext = substr( $Ext, 0, -1 );
        $Ext .= ')';
    }
    if ( $Param{Keyword} ) {
        if ($Ext) {
            $Ext .= ' AND';
        }
        $Param{Keyword} = "\%$Param{Keyword}\%";
        $Param{Keyword} =~ s/\*/%/g;
        $Param{Keyword} =~ s/%%/%/g;
        $Param{Keyword} = $Self->{DBObject}->Quote( $Param{Keyword}, 'Like' );

        if ( $Self->{DBObject}->GetDatabaseFunction('NoLowerInLargeText') ) {
            $Ext .= " i.f_keywords LIKE '" . $Param{Keyword} . "'";
        }
        elsif ( $Self->{DBObject}->GetDatabaseFunction('LcaseLikeInLargeText') ) {
            $Ext .= " LCASE(i.f_keywords) LIKE LCASE('" . $Param{Keyword} . "')";
        }
        else {
            $Ext .= " LOWER(i.f_keywords) LIKE LOWER('" . $Param{Keyword} . "')";
        }
    }

    # show only approved faq articles for public and customer interface
    if ( ( $Param{Interface} eq 'public' ) || ( $Param{Interface} eq 'external' ) ) {
        if ($Ext) {
            $Ext .= ' AND';
        }
        $Ext .= ' i.approved = 1';
    }

    if ($Ext) {
        $Ext = ' WHERE' . $Ext;
    }

    $Ext
        .= ' GROUP BY i.id, i.f_subject, i.f_language_id, i.created, i.changed, s.name, v.item_id ';

    # add the ORDER BY clause
    if (@SQLOrderBy) {
        $Ext .= 'ORDER BY ';
        $Ext .= join ', ', @SQLOrderBy;
        $Ext .= ' ';
    }

    $SQL .= $Ext;

    # ask database
    return if !$Self->{DBObject}->Prepare(
        SQL => $SQL,
        Limit => $Param{Limit} || 500
    );

    # fetch the result
    my @List;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @List, $Row[0];
    }
    return @List;
}

=item FAQPathListGet()

returns a category array reference

    my $CategoryIDArrayRef = $FAQObject->FAQPathListGet(
        CategoryID => 150,
        UserID     => 1,
    );

=cut

sub FAQPathListGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need UserID!",
        );
        return;
    }

    my @CategoryList   = ();
    my $TempCategoryID = $Param{CategoryID};
    while ($TempCategoryID) {
        my %Data = $Self->CategoryGet(
            CategoryID => $TempCategoryID,
            UserID     => $Param{UserID},
        );
        if (%Data) {
            push @CategoryList, \%Data;
        }
        $TempCategoryID = $Data{ParentID};
    }
    @CategoryList = reverse(@CategoryList);

    return \@CategoryList;

}

=item SetCategoryGroup()

set groups to a category

    my $Success = $FAQObject->SetCategoryGroup(
        CategoryID => 3,
        GroupIDs   => [ 2,4,1,5,77 ],
        UserID     => 1,
    );

=cut

sub SetCategoryGroup {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(CategoryID GroupIDs UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # delete old groups
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM faq_category_group WHERE category_id = ?',
        Bind => [ \$Param{CategoryID} ],
    );

    # insert groups
    $Param{CategoryID} = $Self->{DBObject}->Quote( $Param{CategoryID}, 'Integer' );
    for my $GroupID ( @{ $Param{GroupIDs} } ) {

        # db quote
        $GroupID = $Self->{DBObject}->Quote( $GroupID, 'Integer' );

        my $SQL = "INSERT INTO faq_category_group " .
            " (category_id, group_id, changed, changed_by, created, created_by) VALUES" .
            " ($Param{CategoryID}, $GroupID, current_timestamp, $Param{UserID}, " .
            " current_timestamp, $Param{UserID})";

        # write attachment to db
        return if !$Self->{DBObject}->Do( SQL => $SQL );
    }

    return 1;
}

=item GetUserCategories()

get user category-groups

    my $UserCategoryGroupHashRef = $FAQObject->GetUserCategories(
        Type   => 'rw',
        UserID => 1,
    );

=cut

sub GetUserCategories {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Type UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    my $Categories = $Self->CategoryList(
        Valid  => 1,
        UserID => $Param{UserID},
    );

    my $CategoryGroups = $Self->CategoryGroupGetAll(
        UserID => $Param{UserID},
    );
    my %UserGroups = ();
    if ( !$Self->{Cache}->{GetUserCategories}->{GroupMemberList} ) {
        %UserGroups = $Self->{GroupObject}->GroupMemberList(
            UserID => $Param{UserID},
            Type   => $Param{Type},
            Result => 'HASH',
        );
        $Self->{Cache}->{GetUserCategories}->{GroupMemberList} = \%UserGroups;
    }
    else {
        %UserGroups = %{ $Self->{Cache}->{GetUserCategories}->{GroupMemberList} };
    }

    my $UserCategories = $Self->_UserCategories(
        Categories     => $Categories,
        CategoryGroups => $CategoryGroups,
        UserGroups     => \%UserGroups,
        UserID         => $Param{UserID},
    );

    return $UserCategories;
}

=item GetUserCategoriesLongNames()

get user category-groups (show category long names)

    my $UserCategoryGroupHashRef = $FAQObject->GetUserCategoriesLongNames(
        Type   => 'rw',
        UserID => 1,
    );

=cut

sub GetUserCategoriesLongNames {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Type UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get categories where user has rights
    my $UserCategories = $Self->GetUserCategories(
        Type   => $Param{Type},
        UserID => $Param{UserID},
    );

    # get all categories with their long names
    my $CategoryTree = $Self->CategoryTreeList(
        Valid  => 1,
        UserID => $Param{UserID},
    );

    # to store the user categories with their long names
    my %UserCategoriesLongNames;

    # get the long names of the categories where user has rights
    PARENTID:
    for my $ParentID ( keys %{$UserCategories} ) {

        next PARENTID if !$UserCategories->{$ParentID};
        next PARENTID if ref $UserCategories->{$ParentID} ne 'HASH';
        next PARENTID if !%{ $UserCategories->{$ParentID} };

        for my $CategoryID ( keys %{ $UserCategories->{$ParentID} } ) {
            $UserCategoriesLongNames{$CategoryID} = $CategoryTree->{$CategoryID};
        }
    }

    return \%UserCategoriesLongNames;
}

=item GetCustomerCategories()

get customer user categories

    my $CustomerUserCategoryHashRef = $FAQObject->GetCustomerCategories(
        CustomerUser => 'hans',
        Type         => 'rw',
        UserID       => 1,
    );

=cut

sub GetCustomerCategories {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(CustomerUser Type UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # check cache
    my $CacheKey = 'GetCustomerCategories::CustomerUser::' . $Param{CustomerUser};
    if ( defined $Self->{Cache}->{$CacheKey} ) {
        return $Self->{Cache}->{$CacheKey};
    }

    # get all calid categories
    my $Categories = $Self->CategoryList(
        Valid  => 1,
        UserID => $Param{UserID},
    );

    my $CategoryGroups = $Self->CategoryGroupGetAll(
        UserID => $Param{UserID},
    );

    my %UserGroups = $Self->{CustomerGroupObject}->GroupMemberList(
        UserID => $Param{CustomerUser},
        Type   => 'ro',
        Result => 'HASH',
    );

    my $CustomerCategories = $Self->_UserCategories(
        Categories     => $Categories,
        CategoryGroups => $CategoryGroups,
        UserGroups     => \%UserGroups,
        UserID         => $Param{UserID},
    );

    # cache
    $Self->{Cache}->{$CacheKey} = $CustomerCategories;

    return $CustomerCategories;
}

=item CheckCategoryUserPermission()

get user permission for a category

    my $PermissionString = $FAQObject->CheckCategoryUserPermission(
        CategoryID => '123',
        UserID     => 1,
    );

=cut

sub CheckCategoryUserPermission {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(CategoryID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    my $UserCategories = $Self->GetUserCategories(
        Type   => 'ro',
        UserID => $Param{UserID},
    );
    for my $Permission (qw(rw ro)) {
        for my $ParentID ( keys %{$UserCategories} ) {
            my $Categories = $UserCategories->{$ParentID};
            for my $CategoryID ( keys %{$Categories} ) {
                if ( $CategoryID == $Param{CategoryID} ) {
                    return $Permission;
                }
            }
        }
    }
    return '';
}

=item CheckCategoryCustomerPermission()

get customer user permission for a category

    my $PermissionString $FAQObject->CheckCategoryCustomerPermission(
        CustomerUser => 'mm',
        CategoryID   => '123',
        UserID       => 1,
    );

=cut

sub CheckCategoryCustomerPermission {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(CustomerUser CategoryID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    for my $Permission (qw(rw ro)) {
        my $CustomerCategories = $Self->GetCustomerCategories(
            CustomerUser => $Param{CustomerUser},
            Type         => 'ro',
            UserID       => $Param{UserID},
        );
        for my $ParentID ( keys %{$CustomerCategories} ) {
            my $Categories = $CustomerCategories->{$ParentID};
            for my $CategoryID ( keys %{$Categories} ) {
                if ( $CategoryID == $Param{CategoryID} ) {
                    return $Permission;
                }
            }
        }
    }
    return '';
}

=item AgentCategorySearch()

get the category search as hash

    my $CategoryIDArrayRef = $FAQObject->AgentCategorySearch(
        ParentID => 3,   # (optional, default 0)
        UserID   => 1,
    );

=cut

sub AgentCategorySearch {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );
        return;
    }

    # set default parent id
    if ( !defined $Param{ParentID} ) {
        $Param{ParentID} = 0;
    }
    my $Categories = $Self->GetUserCategories(
        Type   => 'ro',
        UserID => $Param{UserID},
    );

    my %Category = %{ $Categories->{ $Param{ParentID} } };
    my @CategoryIDs = sort { $Category{$a} cmp $Category{$b} } ( keys %Category );

    return \@CategoryIDs;
}

=item CustomerCategorySearch()

get the category search as hash

    my $CategoryIDArrayRef = @{$FAQObject->CustomerCategorySearch(
        CustomerUser  => 'tt',
        ParentID      => 3,   # (optional, default 0)
        Mode          => 'Customer',
        UserID        => 1,
    )};

=cut

sub CustomerCategorySearch {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(CustomerUser Mode UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # set default parent id
    if ( !defined $Param{ParentID} ) {
        $Param{ParentID} = 0;
    }

    my $Categories = $Self->GetCustomerCategories(
        CustomerUser => $Param{CustomerUser},
        Type         => 'ro',
        UserID       => $Param{UserID},
    );

    my %Category           = %{ $Categories->{ $Param{ParentID} } };
    my @CategoryIDs        = sort { $Category{$a} cmp $Category{$b} } ( keys %Category );
    my @AllowedCategoryIDs = ();

    my %Articles = ();

    # check cache
    my $CacheKey = 'CustomerCategorySearch::Articles';
    if ( $Self->{Cache}->{$CacheKey} ) {
        %Articles = %{ $Self->{Cache}->{$CacheKey} };
    }
    else {

        my $SQL = 'SELECT faq_item.id, faq_item.category_id '
            . 'FROM faq_item, faq_state_type '
            . 'WHERE faq_state_type.id = faq_item.state_id '
            . "AND faq_state_type.name != 'internal' "
            . 'AND approved = 1';

        return if !$Self->{DBObject}->Prepare(
            SQL => $SQL,
        );
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            $Articles{ $Row[1] }++;
        }

        # cache
        $Self->{Cache}->{$CacheKey} = \%Articles;
    }

    for my $CategoryID (@CategoryIDs) {

        # get all subcategory ids for this category
        my $SubCategoryIDs = $Self->CategorySubCategoryIDList(
            ParentID     => $CategoryID,
            Mode         => $Param{Mode},
            CustomerUser => $Param{CustomerUser},
            UserID       => $Param{UserID},
        );

        # add this category id
        my @IDs = ( $CategoryID, @{$SubCategoryIDs} );

        # check if category contains articles with state external or public
        ID:
        for my $ID (@IDs) {
            next ID if !$Articles{$ID};
            push @AllowedCategoryIDs, $CategoryID;
            last ID;
        }
    }

    return \@AllowedCategoryIDs;
}

=item PublicCategorySearch()

get the category search as hash

    my $CategoryIDArrayRef = $FAQObject->PublicCategorySearch(
        ParentID      => 3,   # (optional, default 0)
        Mode          => 'Public',
        UserID        => 1,
    );

=cut

sub PublicCategorySearch {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Mode UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    if ( !defined $Param{ParentID} ) {
        $Param{ParentID} = 0;
    }

    my $CategoryListCategories = $Self->CategoryList(
        Valid  => 1,
        UserID => $Param{UserID},
    );

    return [] if !$CategoryListCategories->{ $Param{ParentID} };

    my %Category           = %{ $CategoryListCategories->{ $Param{ParentID} } };
    my @CategoryIDs        = sort { $Category{$a} cmp $Category{$b} } ( keys %Category );
    my @AllowedCategoryIDs = ();

    for my $CategoryID (@CategoryIDs) {

        # get all subcategory ids for this category
        my $SubCategoryIDs = $Self->CategorySubCategoryIDList(
            ParentID     => $CategoryID,
            Mode         => $Param{Mode},
            CustomerUser => $Param{CustomerUser},
            UserID       => $Param{UserID},
        );

        # add this category id
        my @IDs = ( $CategoryID, @{$SubCategoryIDs} );

        # check if category contains articles with state public
        my $FoundArticle = 0;
        my $SQL          = 'SELECT faq_item.id FROM faq_item, faq_state_type '
            . 'WHERE faq_item.category_id = ? '
            . 'AND faq_state_type.id = faq_item.state_id '
            . "AND faq_state_type.name = 'public' "
            . 'AND approved = 1';

        ID:
        for my $ID (@IDs) {
            return if !$Self->{DBObject}->Prepare(
                SQL   => $SQL,
                Bind  => [ \$ID ],
                Limit => 1,
            );
            while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
                $FoundArticle = $Row[0];
            }
            last ID if $FoundArticle;
        }

        # an article was found
        if ($FoundArticle) {
            push @AllowedCategoryIDs, $CategoryID;
        }
    }

    return \@AllowedCategoryIDs;

}

=item FAQLogAdd()

adds accessed FAQ article to the access log table

    my $Success = $FAQObject->FAQLogAdd(
        ItemID    => '123456',
        Interface => 'internal',
        UserID    => 1,
    );

=cut

sub FAQLogAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(ItemID Interface UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get environment variables
    my $IP        = $ENV{'REMOTE_ADDR'}     || 'NONE';
    my $UserAgent = $ENV{'HTTP_USER_AGENT'} || 'NONE';

    # get current system time
    my $SystemTime = $Self->{TimeObject}->SystemTime();

    # define time period where reloads will not be logged (10 minutes)
    my $ReloadBlockTime = 10 * 60;

    # subtract ReloadBlockTime
    $SystemTime = $SystemTime - $ReloadBlockTime;

    # convert to timesstamp
    my $TimeStamp = $Self->{TimeObject}->SystemTime2TimeStamp(
        SystemTime => $SystemTime,
    );

    # check if a log entry exists newer than the ReloadBlockTime
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id FROM faq_log '
            . 'WHERE item_id = ? AND ip = ? '
            . 'AND user_agent = ? AND created >= ? ',
        Bind => [ \$Param{ItemID}, \$IP, \$UserAgent, \$TimeStamp ],
        Limit => 1,
    );

    # fetch the result
    my $AlreadyExists = 0;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $AlreadyExists = 1;
    }

    return if $AlreadyExists;

    # insert new log entry
    return if !$Self->{DBObject}->Do(
        SQL => 'INSERT INTO faq_log '
            . '(item_id, interface, ip, user_agent, created) VALUES '
            . '(?, ?, ?, ?, current_timestamp)',
        Bind => [
            \$Param{ItemID}, \$Param{Interface}, \$IP, \$UserAgent,
        ],
    );

    return 1;
}

=item FAQTop10Get()

returns an array with the top 10 faq article ids

    my $Top10IDsRef = $FAQObject->FAQTop10Get(
        Interface   => 'public',
        CategoryIDs => [ 1, 2, 3 ],  # (optional) Only show the Top10 articles from these categories
        Limit       => 10,           # (optional, default 10)
        UserID      => 1,
    );

=cut

sub FAQTop10Get {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Interface UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # prepare SQL
    my @Bind;
    my $SQL = 'SELECT item_id, count(item_id) as itemcount, faq_state_type.name, approved '
        . 'FROM faq_log, faq_item, faq_state, faq_state_type '
        . 'WHERE faq_log.item_id = faq_item.id '
        . 'AND faq_item.state_id = faq_state.id '
        . 'AND faq_state.type_id = faq_state_type.id ';

    # filter just categories with at least ro permission
    if ( $Param{CategoryIDs} && ref $Param{CategoryIDs} eq 'ARRAY' && @{ $Param{CategoryIDs} } ) {

        # build category id string
        my $CategoryIDString = join ', ', @{ $Param{CategoryIDs} };
        $SQL .= "AND faq_item.category_id IN ($CategoryIDString)";
    }

    # filter results for public and customer interface
    if ( ( $Param{Interface} eq 'public' ) || ( $Param{Interface} eq 'external' ) ) {

        # only show approved articles
        $SQL .= 'AND approved = 1 ';

        # only show the public articles
        $SQL .= "AND ( ( faq_state_type.name = 'public' ) ";

        # customers can additionally see the external articles
        if ( $Param{Interface} eq 'external' ) {
            $SQL .= "OR ( faq_state_type.name = 'external' ) ";
        }

        $SQL .= ') ';
    }

    # filter results for defined time period
    if ( $Param{StartDate} && $Param{EndDate} ) {
        $SQL .= 'AND faq_log.created >= ? AND faq_log.created <= ? ';
        push @Bind, ( \$Param{StartDate}, \$Param{EndDate} );
    }

    # complete SQL statement
    $SQL .= 'GROUP BY item_id, faq_state_type.name, approved '
        . 'ORDER BY itemcount DESC';

    # get the top 10 article ids from database
    return if !$Self->{DBObject}->Prepare(
        SQL   => $SQL,
        Bind  => \@Bind,
        Limit => $Param{Limit} || 10,
    );

    my @Result;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @Result, {
            ItemID    => $Row[0],
            Count     => $Row[1],
            Interface => $Row[2],
        };
    }

    return \@Result;
}

=item FAQApprovalUpdate()

update the approval state of an article

    my $Success = $FAQObject->FAQApprovalUpdate(
        ItemID     => 123,
        Approved   => 1,    # 0|1 (default 0)
        UserID     => 1,
    );

=cut

sub FAQApprovalUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(ItemID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    if ( !defined $Param{Approved} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Approved parameter!',
        );
        return;
    }

    # update database
    return if !$Self->{DBObject}->Do(
        SQL => 'UPDATE faq_item '
            . 'SET approved = ?, changed = current_timestamp, changed_by = ? '
            . 'WHERE id = ?',
        Bind => [
            \$Param{Approved}, \$Param{UserID}, \$Param{ItemID},
        ],
    );

    # approval feature is activated and faq article is not appproved yet
    if ( $Self->{ConfigObject}->Get('FAQ::ApprovalRequired') && !$Param{Approved} ) {

        # get faq data
        my %FAQData = $Self->FAQGet(
            ItemID => $Param{ItemID},
            UserID => $Param{UserID},
        );

        # create new approval ticket
        my $Ok = $Self->FAQApprovalTicketCreate(
            ItemID     => $Param{ItemID},
            CategoryID => $FAQData{CategoryID},
            FAQNumber  => $FAQData{Number},
            Title      => $FAQData{Title},
            StateID    => $FAQData{StateID},
            UserID     => $Param{UserID},
        );

        # check error
        if ( !$Ok ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Could not create approval ticket!',
            );
        }
    }

    return 1;
}

=item FAQApprovalTicketCreate()

creates an approval ticket

    my $Success = $FAQObject->FAQApprovalTicketCreate(
        ItemID     => 123,
        CategoryID => 2,
        FAQNumber  => 10211,
        Title      => 'Some Title',
        StateID    => 1,
        UserID     => 1,
    );

=cut

sub FAQApprovalTicketCreate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(ItemID CategoryID FAQNumber Title StateID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get subject
    my $Subject = $Self->{ConfigObject}->Get('FAQ::ApprovalTicketSubject');
    $Subject =~ s{ <OTRS_FAQ_NUMBER> }{$Param{FAQNumber}}xms;

    # create ticket
    my $TicketID = $Self->{TicketObject}->TicketCreate(
        Title    => $Subject,
        Queue    => $Self->{ConfigObject}->Get('FAQ::ApprovalQueue') || 'Raw',
        Lock     => 'unlock',
        Priority => $Self->{ConfigObject}->Get('FAQ::ApprovalTicketPriority') || '3 normal',
        State    => $Self->{ConfigObject}->Get('FAQ::ApprovalTicketDefaultState') || 'new',
        OwnerID  => 1,
        UserID   => 1,
    );

    if ($TicketID) {

        # get UserName
        my $UserName = $Self->{UserObject}->UserName(
            UserID => $Param{UserID},
        );

        # get faq state
        my %State = $Self->StateGet(
            StateID => $Param{StateID},
            UserID  => $Param{UserID},
        );

        # get body from config
        my $Body = $Self->{ConfigObject}->Get('FAQ::ApprovalTicketBody');
        $Body =~ s{ <OTRS_FAQ_CATEGORYID> }{$Param{CategoryID}}xms;
        $Body =~ s{ <OTRS_FAQ_ITEMID>     }{$Param{ItemID}}xms;
        $Body =~ s{ <OTRS_FAQ_NUMBER>     }{$Param{FAQNumber}}xms;
        $Body =~ s{ <OTRS_FAQ_TITLE>      }{$Param{Title}}xms;
        $Body =~ s{ <OTRS_FAQ_AUTHOR>     }{$UserName}xms;
        $Body =~ s{ <OTRS_FAQ_STATE>      }{$State{Name}}xms;

        # create article
        my $ArticleID = $Self->{TicketObject}->ArticleCreate(
            TicketID    => $TicketID,
            ArticleType => 'note-internal',
            SenderType  => 'system',
            Subject     => $Subject,
            Body        => $Body,
            ContentType => "text/plain; charset=$Self->{ConfigObject}->Get('DefaultCharset')",
            UserID      => 1,
            HistoryType => 'SystemRequest',
            HistoryComment =>
                $Self->{ConfigObject}->Get('Ticket::Frontend::AgentTicketNote')->{HistoryComment}
                || '',
        );

        return $ArticleID;
    }

    return;
}

=item FAQPictureUploadAdd()

stores uploaded pictures as faq attachments

    my %Success = $FAQObject->FAQPictureUploadAdd(
        ItemID => 12,
        FormID => 12345,
        Field1 => 'some text',
        Field2 => 'some text',
        Field3 => 'some text',
        Field4 => 'some text',
        Field5 => 'some text',
        Field6 => 'some text',
        UserID => 1,
    );

=cut

sub FAQPictureUploadAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(ItemID FormID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get uploaded pictures from upload cache
    my @AttachmentData = $Self->{UploadCacheObject}->FormIDGetAllFilesData(
        FormID => $Param{FormID},
    );

    # if no new pictures were uploaded
    return 1 if !@AttachmentData;

    ATTACHMENT:
    for my $Attachment (@AttachmentData) {

        # store picture as attachment of faq article
        my $Ok = $Self->AttachmentAdd(
            ItemID      => $Param{ItemID},
            Content     => $Attachment->{Content},
            ContentType => $Attachment->{ContentType},
            Filename    => $Attachment->{Filename},
            Inline      => 1,
            UserID      => $Param{UserID},
        );
        if ( !$Ok ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Could not store attachment '$Attachment->{Filename}'"
                    . " with FAQ Item# '$Param{ItemID}'!",
            );
        }
    }

    # get all attachments for this faq article
    my @AttachmentIndex = $Self->AttachmentIndex(
        ItemID => $Param{ItemID},
        UserID => $Param{UserID},
    );

    # rewrite url to picture if it was successfully stored
    ATTACHMENT:
    for my $Attachment (@AttachmentIndex) {

        # picture url in upload cache
        my $Search = "Action=PictureUploadFAQ .+ FormID=$Param{FormID} .+ "
            . "Filename=$Attachment->{Filename}";

        # picture url in faq atttachment
        my $Replace = "Action=AgentFAQ&Subaction=Download&"
            . "ItemID=$Param{ItemID}&FileID=$Attachment->{FileID}";

        # rewrite picture urls
        FIELD:
        for my $Number ( 1 .. 6 ) {
            next FIELD if !$Param{"Field$Number"};

            # remove newlines
            $Param{"Field$Number"} =~ s{ [\n\r]+ }{}gxms;

            # replace url
            $Param{"Field$Number"} =~ s{$Search}{$Replace}xms;
        }
    }

    # update FAQ article without writing a history entry
    my $Ok = $Self->FAQUpdate(
        %Param,
        HistoryOff => 1,
        UserID     => $Param{UserID},
    );
    if ( !$Ok ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Could not update FAQ Item# '$Param{ItemID}'!",
        );
    }

    # delete all attachments from upload cache for this FormID
    $Self->{UploadCacheObject}->FormIDRemove(
        FormID => $Param{FormID},
    );

    return $Ok;
}

=begin Internal:

=item _UserCategories()

....
....

=cut

sub _UserCategories {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Categories UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    my %UserCategories = ();

    PARENTID:
    for my $ParentID ( sort { $a <=> $b } keys %{ $Param{Categories} } ) {

        my %SubCategories = ();

        CATEGORYID:
        for my $CategoryID ( keys %{ $Param{Categories}->{$ParentID} } ) {

            # check category groups
            next CATEGORYID if !defined $Param{CategoryGroups}->{$CategoryID};

            # check user groups
            GROUPID:
            for my $GroupID ( keys %{ $Param{CategoryGroups}->{$CategoryID} } ) {

                next GROUPID if !defined $Param{UserGroups}->{$GroupID};

                # add category
                $SubCategories{$CategoryID} = $Param{Categories}->{$ParentID}{$CategoryID};

                # add empty hash if category has no subcategories
                if ( !$UserCategories{$CategoryID} ) {
                    $UserCategories{$CategoryID} = {};
                }

                last GROUPID;
            }
        }
        $UserCategories{$ParentID} = \%SubCategories;
    }
    return \%UserCategories;
}

1;

=end Internal:

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=head1 VERSION

$Revision: 1.115 $ $Date: 2010-11-12 18:28:09 $

=cut
