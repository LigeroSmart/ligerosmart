# --
# Kernel/System/FAQ.pm - all faq funktions
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: FAQ.pm,v 1.59 2009-01-23 18:04:21 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::FAQ;

use strict;
use warnings;

use MIME::Base64;
use Kernel::System::Encode;
use Kernel::System::User;
use Kernel::System::Group;
use Kernel::System::CustomerGroup;
use Kernel::System::LinkObject;
use Kernel::System::Ticket;
use Kernel::System::Web::UploadCache;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.59 $) [1];

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
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::FAQ;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject    = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    }
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $FAQObject = Kernel::System::FAQ->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(DBObject ConfigObject LogObject MainObject TimeObject UserID)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    $Self->{GroupObject}         = Kernel::System::Group->new( %{$Self} );
    $Self->{CustomerGroupObject} = Kernel::System::CustomerGroup->new( %{$Self} );
    $Self->{UserObject}          = Kernel::System::User->new( %{$Self} );
    $Self->{EncodeObject}        = Kernel::System::Encode->new( %{$Self} );
    $Self->{TicketObject}        = Kernel::System::Ticket->new( %{$Self} );
    $Self->{UploadCacheObject}   = Kernel::System::Web::UploadCache->new( %{$Self} );

    return $Self;
}

=item FAQGet()

get an faq

    my %FAQ = $FAQObject->FAQGet(
        ItemID => 1,
    );

=cut

sub FAQGet {
    my ( $Self, %Param ) = @_;

    # Failures rename from ItemID to FAQID
    if ( $Param{FAQID} ) {
        $Param{ItemID} = $Param{FAQID};
    }

    # check needed stuff
    for (qw(ItemID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return {};
        }
    }

    # db quote
    for (qw(ItemID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }
    my %Data = ();
    my $SQL  = "SELECT i.f_name, i.f_language_id, i.f_subject, " .
        " i.f_field1, i.f_field2, i.f_field3, " .
        " i.f_field4, i.f_field5, i.f_field6, " .
        " i.free_key1, i.free_value1, i.free_key2, i.free_value2, " .
        " i.free_key3, i.free_value3, i.free_key4, i.free_value4, " .
        " i.created, i.created_by, i.changed, i.changed_by, " .
        " i.category_id, i.state_id, c.name, s.name, l.name, i.f_keywords, i.approved, i.f_number, st.id, st.name "
        .
        " FROM faq_item i, faq_category c, faq_state s, faq_state_type st, faq_language l " .
        " WHERE " .
        " i.state_id = s.id AND " .
        " s.type_id = st.id AND " .
        " i.category_id = c.id AND " .
        " i.f_language_id = l.id AND " .
        " i.id = $Param{ItemID}";
    return if !$Self->{DBObject}->Prepare( SQL => $SQL );

    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        my %VoteData = %{ $Self->ItemVoteDataGet( ItemID => $Param{ItemID} ) };
        %Data = (

            # var for old versions
            ID    => $Param{ItemID},
            FAQID => $Param{ItemID},

            #
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
            Result        => sprintf(
                "%0."
                    . $Self->{ConfigObject}->Get(
                    "FAQ::Explorer::ItemList::VotingResultDecimalPlaces"
                    )
                    . "f",
                $VoteData{Result} || 0
            ),
            Votes => $VoteData{Votes},
        );
    }
    if ( !%Data ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "No such ItemID $Param{ItemID}!" );
        return;
    }

    # update number
    if ( !$Data{Number} ) {
        my $Number = $Self->{ConfigObject}->Get('SystemID') . "00" . $Data{ItemID};
        $Self->{DBObject}->Do(
            SQL => "UPDATE faq_item SET f_number = '$Number' WHERE id = $Data{ItemID}",
        );
        $Data{Number} = $Number;
    }
    my $Hash = $Self->GetCategoryTree();
    $Data{CategoryName} = $Hash->{ $Data{CategoryID} };
    return %Data;
}

=item ItemVoteDataGet()

returns a hash with number and result of a item

    my %Flag = $FAQObject->ItemVoteDataGet(
        ItemID => 1,
    );

=cut

sub ItemVoteDataGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ItemID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return 0;
        }
    }

    # db quote
    for (qw(ItemID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    my $SQL = "SELECT count(*), avg(rate) FROM faq_voting WHERE item_id = " . $Param{ItemID};

    my %Hash = ();
    $Self->{DBObject}->Prepare( SQL => $SQL, Limit => $Param{Limit} || 500 );
    if ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        $Hash{Votes}  = $Data[0];
        $Hash{Result} = $Data[1];
    }
    return \%Hash;
}

=item FAQAdd()

add an article

    my $ItemID = $FAQObject->FAQAdd(
        Number     => '13402',
        Title      => 'Some Text',
        CategoryID => 1,
        StateID    => 1,
        LanguageID => 1,
        Keywords   => 'some keywords',
        Field1     => 'Problem...',
        Field2     => 'Solution...',
        FreeKey1   => 'Software',
        FreeText1  => 'Apache 3.4.2',
        FreeKey2   => 'OS',
        FreeText2  => 'OpenBSD 4.2.2',
        Approved   => 1,
    );

=cut

sub FAQAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(CategoryID StateID LanguageID Title)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
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
            \$Self->{UserID},    \$Self->{UserID},
        ]
    );

    # db quote
    for (qw(Name Title)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} );
    }
    for (qw(LanguageID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    # get id
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id FROM faq_item WHERE " .
            "f_name = '$Param{Name}' AND f_language_id = $Param{LanguageID} " .
            " AND f_subject = '$Param{Title}'",
    );
    my $ID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $ID = $Row[0];
    }

    # update number
    my $Number = $Self->{ConfigObject}->Get('SystemID') . "00" . $ID;
    $Self->{DBObject}->Do(
        SQL => "UPDATE faq_item SET f_number = '$Number' WHERE id = $ID",
    );

    # add history
    $Self->FAQHistoryAdd(
        Name   => 'Created',
        ItemID => $ID,
    );

    # create new approval ticket
    if ( $Self->{ConfigObject}->Get('FAQ::ApprovalRequired') && !$Param{Approved} ) {
        my $Ok = $Self->FAQApprovalTicketCreate(
            ItemID     => $ID,
            CategoryID => $Param{CategoryID},
            FAQNumber  => $Number,
            Title      => $Param{Title},
            UserID     => $Self->{UserID},
            StateID    => $Param{StateID},
        );
        if ( !$Ok ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Could not create approval ticket!" );
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
    );

=cut

sub FAQUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ItemID CategoryID StateID LanguageID Title)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # check name
    if ( !$Param{Name} ) {
        my %Article = $Self->FAQGet(%Param);
        $Param{Name} = $Article{Name};
    }

    return if !$Self->{DBObject}->Do(
        SQL => "UPDATE faq_item SET f_name = ?, f_language_id = ?, f_subject = ?, " .
            " category_id = ?, state_id = ?, f_keywords = ?, " .
            " f_field1 = ?, f_field2 = ?, f_field3 = ?, f_field4 = ?, f_field5 = ?, f_field6 = ?, "
            .
            " free_key1 = ?, free_value1 = ?, free_key2 = ?, free_value2 = ?, " .
            " free_key3 = ?, free_value3 = ?, free_key4 = ?, free_value4 = ?, " .
            " changed = current_timestamp, changed_by = ? WHERE id = ?",
        Bind => [
            \$Param{Name},     \$Param{LanguageID}, \$Param{Title},    \$Param{CategoryID},
            \$Param{StateID},  \$Param{Keywords},   \$Param{Field1},   \$Param{Field2},
            \$Param{Field3},   \$Param{Field4},     \$Param{Field5},   \$Param{Field6},
            \$Param{FreeKey1}, \$Param{FreeText1},  \$Param{FreeKey2}, \$Param{FreeText2},
            \$Param{FreeKey3}, \$Param{FreeText3},  \$Param{FreeKey4}, \$Param{FreeText4},
            \$Self->{UserID},  \$Param{ItemID},
        ],
    );

    $Self->FAQHistoryAdd(
        Name   => 'Updated',
        ItemID => $Param{ItemID},
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
    );

=cut

sub AttachmentAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ItemID Content ContentType Filename)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
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
        $Param{Filesize} = length( $Param{Content} );
        no bytes;
    }

    # double check
    my @Index = $Self->AttachmentIndex(
        ItemID => $Param{ItemID},
    );
    for my $File (@Index) {
        if ( $File->{Filename} eq $Param{Filename} && $Param{Filesize} == $File->{FilesizeRaw} ) {
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
        SQL => "INSERT INTO faq_attachment " .
            " (faq_id, filename, content_type, content_size, content, inlineattachment, " .
            " created, created_by, changed, changed_by) VALUES " .
            " (?, ?, ?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)",
        Bind => [
            \$Param{ItemID},  \$Param{Filename}, \$Param{ContentType}, \$Param{Filesize},
            \$Param{Content}, \$Param{Inline},   \$Self->{UserID}, \$Self->{UserID},
        ],
    );
}

=item AttachmentGet()

get attachment of article

    my %File = $FAQObject->AttachmentGet(
        ItemID => 123,
        FileID => 1,
    );

=cut

sub AttachmentGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ItemID FileID)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    $Self->{DBObject}->Prepare(
        SQL => 'SELECT filename, content_type, content_size, content '
            . 'FROM faq_attachment '
            . 'WHERE id = ? '
            . 'AND faq_id = ? '
            . 'ORDER BY created',
        Bind => [ \$Param{FileID},  \$Param{ItemID} ],
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
    );

=cut

sub AttachmentDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ItemID FileID)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    return $Self->{DBObject}->Do(
        SQL => 'DELETE FROM faq_attachment '
            . 'WHERE id = ? AND faq_id = ? ',
        Bind => [ \$Param{FileID}, \$Param{ItemID} ],
    );
}

=item AttachmentIndex()

return an attachment index of an article

    my @Index = $FAQObject->AttachmentIndex(
        ItemID => 123,
        ShowInline => 0,   ( 0|1, default 1)
    );

=cut

sub AttachmentIndex {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ItemID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    $Self->{DBObject}->Prepare(
        SQL => 'SELECT id, filename, content_type, content_size, inlineattachment FROM '
            . 'faq_attachment WHERE faq_id = ? '
            . 'ORDER BY created',
        Bind => [ \$Param{ItemID} ],
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

        # human readable file size
        my $FileSizeRaw = $Filesize;
        if ( $Filesize ) {
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
        CategoryIDs => [1,2,3,4],
    );

=cut

sub FAQCount {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(CategoryIDs ItemStates)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my $SQL = 'SELECT COUNT(*) FROM faq_item i, faq_state s' .
        " WHERE i.category_id IN (${\(join ', ', @{$Param{CategoryIDs}})})" .
        ' AND i.state_id = s.id';
    my $Ext = '';
    if ( $Param{ItemStates} && ref( $Param{ItemStates} ) eq 'HASH' && %{ $Param{ItemStates} } ) {
        $Ext .= " AND s.type_id IN (${\(join ', ', keys(%{$Param{ItemStates}}))})";
    }
    $Ext .= ' GROUP BY category_id';
    $SQL .= $Ext;

    $Self->{DBObject}->Prepare( SQL => $SQL, Limit => 200 );

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
    );

=cut

sub VoteAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(CreatedBy ItemID IP Interface)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return 0;
        }
    }

    # db quote
    for (qw(CreatedBy Interface IP)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} );
    }
    for (qw(ItemID Rate)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    my $SQL = "INSERT INTO faq_voting ( " .
        " created_by, item_id, ip, interface, rate, created" .
        " ) VALUES (" .
        " '$Param{CreatedBy}', " .
        " $Param{ItemID}, " .
        " '$Param{IP}', " .
        " '$Param{Interface}', " .
        " $Param{Rate}, " .
        " current_timestamp " .
        " )";

    if ( $Self->{DBObject}->Do( SQL => $SQL ) ) {
        return 1;
    }
    else {
        return 0;
    }

}

=item VoteGet()

get a vote

    my %VoteData = %{$FAQObject->VoteGet(
        CreateBy  => 'Some Text',
        ItemID    => '123456',
        IP        => '127.0.0.1',
        Interface => 'Some Text',
    )};

=cut

sub VoteGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(CreateBy ItemID Interface IP)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return {};
        }
    }

    # db quote
    for (qw(CreatedBy Interface IP)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} );
    }
    for (qw(ItemID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    my $Ext = "";
    my $SQL = " SELECT created_by, item_id, interface, ip, created, rate FROM faq_voting WHERE";

    # public
    if ( $Param{Interface} eq '3' ) {
        $Ext .= " ip LIKE '$Param{IP}' AND" .
            " item_id = $Param{ItemID}";

        # customer
    }
    elsif ( $Param{Interface} eq '2' ) {
        $Ext .= " created_by LIKE '$Param{CreateBy}' AND" .
            " item_id = $Param{ItemID}";

        # internal
    }
    elsif ( $Param{Interface} eq '1' ) {
        $Ext .= " created_by LIKE '$Param{CreateBy}' AND" .
            " item_id = $Param{ItemID}";
    }
    $SQL .= $Ext;

    $Self->{DBObject}->Prepare( SQL => $SQL );
    my %Data = ();
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
    if ( !%Data ) {

#$Self->{LogObject}->Log(Priority => 'error', Message => "No voting for this faq article! Kernel::System::FAQ::VoteGet()");
        return {};
    }
    return \%Data;
}

=item VoteSearch()

returns a array with VoteIDs

    my @VoteIDs = @{$FAQObject->VoteSearch(
        ItemID => 1,
    )};

=cut

sub VoteSearch {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ItemID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return [];
        }
    }

    # db quote
    for (qw()) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} );
    }
    for (qw(ItemID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    my $Ext = "";
    my $SQL = " SELECT id FROM faq_voting WHERE";

    if ( defined( $Param{ItemID} ) ) {
        $Ext .= " item_id = " . $Param{ItemID};
    }

    $SQL .= $Ext;

    my @List = ();
    $Self->{DBObject}->Prepare( SQL => $SQL, Limit => $Param{Limit} || 500 );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push( @List, $Row[0] );
    }
    return \@List;
}

=item VoteDelete()

delete a vote

    my $Ok = $FAQObject->VoteDelete(
        VoteID => 1,
    );

=cut

sub VoteDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(VoteID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return 0;
        }
    }

    # db quote
    for (qw(VoteID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    my $SQL = "DELETE FROM faq_voting WHERE id = " . $Param{VoteID};

    if ( $Self->{DBObject}->Do( SQL => $SQL ) ) {
        return 1;
    }
    else {
        return 0;
    }

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
    for (qw(ItemID UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # delete attachments
    my @Index = $Self->AttachmentIndex(
        ItemID => $Param{ItemID},
    );
    for my $FileID (@Index) {
        return if !$Self->AttachmentDelete( %Param, FileID => $FileID->{FileID} );
    }

    # delete votes
    my @VoteIDs = @{ $Self->VoteSearch( ItemID => $Param{ItemID} ) };
    for my $TmpVoteID (@VoteIDs) {
        if ( !$Self->VoteDelete( VoteID => $TmpVoteID ) ) {
            return;
        }
    }

    # delete faq links
    my $LinkObject = Kernel::System::LinkObject->new(
        %Param,
        %{$Self},
        TicketObject => $Self,
    );

    $LinkObject->LinkDeleteAll(
        Object => 'FAQ',
        Key    => $Param{ItemID},
        UserID => $Param{UserID},
    );

    # delete history
    return if !$Self->FAQHistoryDelete(%Param);

    # delete article
    return $Self->{DBObject}->Do(
        SQL  => "DELETE FROM faq_item WHERE id = ?",
        Bind => [ \$Param{ItemID} ],
    );
}

=item FAQHistoryAdd()

add an history to an article

    $Flag = $FAQObject->FAQHistoryAdd(
        ItemID => 1,
        Name   => 'Updated Article.',
    );

=cut

sub FAQHistoryAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ItemID Name)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # db quote
    for (qw(Name)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} ) || '';
    }
    for (qw(ItemID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }
    my $SQL = "INSERT INTO faq_history (name, item_id, " .
        " created, created_by, changed, changed_by)" .
        " VALUES " .
        " ('$Param{Name}', $Param{ItemID}, " .
        " current_timestamp, $Self->{UserID}, " .
        " current_timestamp, $Self->{UserID})";

    return $Self->{DBObject}->Do( SQL => $SQL );
}

=item FAQHistoryGet()

get an array with hashref (Name, Created) with history of an article back

    my @Data = @{$FAQObject->FAQHistoryGet(
        ItemID => 1,
    )};

=cut

sub FAQHistoryGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ItemID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return [];
        }
    }

    # db quote
    for (qw(ItemID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }
    my @Data = ();
    $Self->{DBObject}->Prepare(
        SQL => "SELECT name, created, created_by FROM faq_history WHERE item_id = $Param{ItemID}",
    );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        my %Record = (
            Name      => $Row[0],
            Created   => $Row[1],
            CreatedBy => $Row[2],
        );
        push( @Data, \%Record );
    }
    return \@Data;
}

=item FAQHistoryDelete()

delete an history of an article

    $FAQObject->FAQHistoryDelete(
        ItemID => 1,
    );

=cut

sub FAQHistoryDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ItemID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return 0;
        }
    }
    return $Self->{DBObject}->Do(
        SQL  => "DELETE FROM faq_history WHERE item_id = ?",
        Bind => [ \$Param{ItemID} ],
    );
}

=item HistoryGet()

get the system history

    my @Data = @{$FAQObject->HistoryGet()};

=cut

sub HistoryGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw()) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # query
    my $SQL = "SELECT i.id, h.name, h.created, h.created_by, c.name, i.f_subject, i.f_number FROM" .
        " faq_item i, faq_state s, faq_history h, faq_category c WHERE" .
        " s.id = i.state_id AND h.item_id = i.id AND i.category_id = c.id";
    if ( $Param{States} && ref( $Param{States} ) eq 'ARRAY' && @{ $Param{States} } ) {
        $SQL .= " AND s.name IN ('${\(join '\', \'', @{$Param{States}})}') ";
    }
    $SQL .= ' ORDER BY created DESC';
    my @Data = ();
    $Self->{DBObject}->Prepare( SQL => $SQL, Limit => 200 );
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
        push( @Data, \%Record );
    }
    return \@Data;
}

=item CategoryList()

get the category list as hash

    my %Categories = %{$FAQObject->CategoryList(
        Valid => 1,
    )};

=cut

sub CategoryList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw()) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return {};
        }
    }

    my $Valid = 0;
    if ( defined $Param{Valid} ) {
        $Valid = $Param{Valid};
    }

    # check cache
    if ( $Self->{Cache}->{CategoryList}->{$Valid} ) {
        return $Self->{Cache}->{CategoryList}->{$Valid};
    }

    # sql
    my $SQL = 'SELECT id, parent_id, name FROM faq_category ';
    if ( $Valid ) {
        $SQL .= 'WHERE valid_id = 1';
    }
    $Self->{DBObject}->Prepare( SQL => $SQL );
    my %Data = ();
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Data{ $Row[1] }->{ $Row[0] } = $Row[2];
    }

    # cache
    $Self->{Cache}->{CategoryList}->{$Valid} = \%Data;

    return \%Data;
}

=item CategorySearch()

get the category search as hash

    my @CategorieIDs = @{$FAQObject->CategorySearch(
        Name => "Name"
    )};

=cut

sub CategorySearch {
    my ( $Self, %Param ) = @_;

    # sql
    my $SQL = "SELECT id FROM faq_category WHERE valid_id = 1 ";
    my $Ext = '';

    # WHERE
    if ( defined( $Param{Name} ) ) {
        $Ext .= " AND name LIKE '%" . $Self->{DBObject}->Quote( $Param{Name} ) . "%'";
    }
    elsif ( defined( $Param{ParentID} ) ) {
        $Ext
            .= " AND parent_id = '" . $Self->{DBObject}->Quote( $Param{ParentID}, 'Integer' ) . "'";
    }
    elsif (
        defined( $Param{ParentIDs} )
        && ref( $Param{ParentIDs} ) eq 'ARRAY'
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
        defined( $Param{CategoryIDs} )
        && ref( $Param{CategoryIDs} ) eq 'ARRAY'
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

    #if (defined($Param{ValidID})) {
    #    $Ext .= " AND valid_id = '".$Self->{DBObject}->Quote($Param{ValidID}, 'Integer')."' ";
    #}

    # ORDER BY
    if ( $Param{Order} ) {
        $Ext .= " ORDER BY ";
        if ( $Param{Order} eq 'Name' ) {
            $Ext .= "name";
        }

        #default
        else {
            $Ext .= "name";
        }

        # SORT
        if ( $Param{Sort} ) {
            if ( $Param{Sort} eq 'up' ) {
                $Ext .= " ASC";
            }
            elsif ( $Param{Sort} eq 'down' ) {
                $Ext .= " DESC";
            }
        }
    }

    # SQL STATEMENT
    $SQL .= $Ext;

    my @List = ();
    $Self->{DBObject}->Prepare( SQL => $SQL, Limit => 500 );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push( @List, $Row[0] );
    }
    return \@List;
}

=item CategoryGet()

get a category as hash

    my %Category = $FAQObject->CategoryGet(
        ID => 1,
    );

=cut

sub CategoryGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(CategoryID)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # db quote
    for (qw(CategoryID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    # sql
    my %Data = ();
    $Self->{DBObject}->Prepare(
        SQL =>
            "SELECT id, parent_id, name, comments, valid_id FROM faq_category WHERE id = $Param{CategoryID} ",
    );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        %Data = (
            CategoryID => $Row[0],
            ParentID   => $Row[1],
            Name       => $Row[2],
            Comment    => $Row[3],
            ValidID    => $Row[4],
        );
    }
    return %Data;
}

=item CategorySubCategoryIDList()

get all subcategory ids of of a category

    my %Category = $FAQObject->CategorySubCategorieIDList(
        ParentID   => 1,
        ItemStates => [1,2,3]
    );

=cut

sub CategorySubCategoryIDList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ParentID ItemStates)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return [];
        }
    }
    my @SubCategoryIDs = ();
    if ( $Param{Mode} && $Param{Mode} eq 'Agent' ) {

        # add subcategoryids
        @SubCategoryIDs = @{
            $Self->AgentCategorySearch(
                ParentID => $Param{ParentID},
                States   => $Param{ItemStates},
                Order    => 'Created',
                Sort     => 'down',
                UserID   => $Param{UserID},
                )
            };
    }
    elsif ( $Param{Mode} && $Param{Mode} eq 'Customer' ) {

        # add subcategoryids
        @SubCategoryIDs = @{
            $Self->CustomerCategorySearch(
                ParentID     => $Param{ParentID},
                States       => $Param{ItemStates},
                Order        => 'Created',
                Sort         => 'down',
                CustomerUser => $Param{CustomerUser},
                )
            };
    }
    else {

        # add subcategoryids
        @SubCategoryIDs = @{
            $Self->CategorySearch(
                ParentID => $Param{ParentID},
                States   => $Param{ItemStates},
                Order    => 'Created',
                Sort     => 'down',
                )
            };
    }
    my @Result = @SubCategoryIDs;
    for my $SubCategoryID (@SubCategoryIDs) {
        my @Temp = @{
            $Self->CategorySubCategoryIDList(
                ParentID     => $SubCategoryID,
                ItemStates   => $Param{ItemStates},
                Mode         => $Param{Mode},
                CustomerUser => $Param{CustomerUser},
                UserID       => $Param{UserID},
                )
            };
        if (@Temp) {
            push( @Result, @Temp );
        }
    }
    return \@Result;
}

=item CategoryAdd()

add a category

    my $ID = $FAQObject->CategoryAdd(
        Name     => 'Some Category',
        Comment  => 'some comment ...',
        ParentID => 2,
        ValidID  => 1,
        UserID   => 1,
    );

=cut

sub CategoryAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ParentID Name)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # db quote
    for (qw(Name Comment)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} ) || '';
    }
    for (qw(ParentID UserID ValidID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }
    my $SQL = "INSERT INTO faq_category (name, parent_id, comments, valid_id, " .
        " created, created_by, changed, changed_by)" .
        " VALUES " .
        " ('$Param{Name}', $Param{ParentID}, '$Param{Comment}', $Param{ValidID}, " .
        " current_timestamp, $Self->{UserID}, " .
        " current_timestamp, $Self->{UserID})";
    if ( $Self->{DBObject}->Do( SQL => $SQL ) ) {

        # get new category id
        $SQL = "SELECT id FROM faq_category WHERE name = '$Param{Name}'";
        my $ID = '';
        $Self->{DBObject}->Prepare( SQL => $SQL );
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            $ID = $Row[0];
        }

        # log notice
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message =>
                "FAQCategory: '$Param{Name}' ID: '$ID' created successfully ($Self->{UserID})!",
        );
        return $ID;
    }
    else {
        return;
    }
}

=item CategoryUpdate()

update a category

    $FAQObject->CategoryUpdate(
        ID      => 1,
        Name    => 'Some Category',
        Comment => 'some comment ...',
    );

=cut

sub CategoryUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(CategoryID ParentID Name)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # db quote
    for (qw(Name Comment)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} ) || '';
    }
    for (qw(CategoryID ParentID ValidID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    # sql
    my $SQL = "UPDATE faq_category SET " .
        " parent_id = $Param{ParentID}, " .
        " name = '$Param{Name}', " .
        " comments = '$Param{Comment}', " .
        " valid_id = '$Param{ValidID}', " .
        " changed = current_timestamp, changed_by = $Self->{UserID} " .
        " WHERE id = $Param{CategoryID}";

    if ( $Self->{DBObject}->Do( SQL => $SQL ) ) {

        # log notice
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message =>
                "FAQCategory: '$Param{Name}' ID: '$Param{CategoryID}' updated successfully ($Self->{UserID})!",
        );
        return 1;
    }
    else {
        return;
    }
}

=item CategoryDuplicateCheck()

check a category

    $FAQObject->CategoryDuplicateCheck(
        ID       => 1, # or
        Name     => 'Some Name',
        ParentID => 1,
    );

=cut

sub CategoryDuplicateCheck {
    my ( $Self, %Param ) = @_;

    # db quote
    for (qw(Name)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} ) || '';
    }
    for (qw(ID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    # sql
    my $SQL = "SELECT id FROM faq_category WHERE ";
    if ( defined( $Param{Name} ) ) {
        $SQL .= "name = '$Param{Name}' AND parent_id = $Param{ParentID} ";
        if ( defined( $Param{ID} ) ) {
            $SQL .= "AND id != '$Param{ID}' ";
        }
    }
    $Self->{DBObject}->Prepare( SQL => $SQL );
    my $Exists = 0;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Exists = 1;
    }
    return $Exists;
}

=item CategoryCount()

count an article

    $FAQObject->CategoryCount(
        ParentIDs => [1,2,3,4],
    );

=cut

sub CategoryCount {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ParentIDs)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my $SQL = "SELECT COUNT(*) FROM faq_category WHERE valid_id = 1";

    my $Ext = '';
    if ( defined( $Param{ParentIDs} ) ) {
        $Ext = " AND parent_id IN (";
        for my $ParentID ( @{ $Param{ParentIDs} } ) {
            $Ext .= $Self->{DBObject}->Quote( $ParentID, 'Integer' ) . ",";
        }
        $Ext = substr( $Ext, 0, -1 );
        $Ext .= ")";
    }
    $Ext .= ' GROUP BY parent_id';

    $SQL .= $Ext;
    $Self->{DBObject}->Prepare( SQL => $SQL, Limit => 200 );

    my $Count = 0;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Count = $Row[0];
    }
    return $Count;
}

=item StateTypeList()

get the state type list as hash

    my %StateTypes = $FAQObject->StateTypeList();

=cut

sub StateTypeList {
    my ( $Self, %Param ) = @_;

    my $SQL = '';
    my $Ext = '';
    $SQL = "SELECT id, name FROM faq_state_type";

    if ( $Param{Types} ) {
        my @States = @{ $Param{Types} };
        $Ext = " WHERE";
        for my $State (@States) {
            $Ext .= " name LIKE '" . $Self->{DBObject}->Quote($State) . "' OR";
        }
        $Ext = substr( $Ext, 0, -3 );
    }
    $SQL .= $Ext;

    # sql
    my %List = ();
    $Self->{DBObject}->Prepare( SQL => $SQL );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $List{ $Row[0] } = $Row[1];
    }
    return \%List;
}

=item StateList()

get the state list as hash

    my %States = $FAQObject->StateList();

=cut

sub StateList {
    my ( $Self, %Param ) = @_;

    # sql
    my %List = ();
    $Self->{DBObject}->Prepare( SQL => 'SELECT id, name FROM faq_state' );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $List{ $Row[0] } = $Row[1];
    }
    return %List;
}

=item StateUpdate()

update a state

    $FAQObject->StateUpdate(
        ID     => 1,
        Name   => 'public',
        TypeID => 1,
    );

=cut

sub StateUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ID Name TypeID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # db quote
    for (qw(Name)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} ) || '';
    }
    for (qw(ID TypeID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    # sql
    my $SQL = "UPDATE faq_state SET name = '$Param{Name}', type_id = $Param{TypeID}, " .
        " WHERE id = $Param{ID}";
    return $Self->{DBObject}->Do( SQL => $SQL );
}

=item StateAdd()

add a state

    my $ID = $FAQObject->StateAdd(
        ID     => 1,
        Name   => 'public',
        TypeID => 1,
    );

=cut

sub StateAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Name TypeID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # db quote
    for (qw(Name)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} ) || '';
    }
    for (qw(TypeID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }
    my $SQL = "INSERT INTO faq_state (name, type_id) " .
        " VALUES " .
        " ('$Param{Name}', $Param{TypeID}) ";

    return $Self->{DBObject}->Do( SQL => $SQL );
}

=item StateGet()

get a state as hash

    my %State = $FAQObject->StateGet(
        ID => 1,
    );

=cut

sub StateGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # db quote
    for (qw(ID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    # sql
    my %Data = ();
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id, name FROM faq_state WHERE id = $Param{ID}",
    );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        %Data = (
            ID      => $Row[0],
            Name    => $Row[1],
            Comment => $Row[2],
        );
    }
    return %Data;
}

=item StateTypeGet()

get a state as hash

    my %State = $FAQObject->StateTypeGet(
        ID   => 1, # or
        Name => 'internal',
    );

=cut

sub StateTypeGet {
    my ( $Self, %Param ) = @_;

    my $SQL = "";
    my $Ext = "";

    $SQL = "SELECT id, name FROM faq_state_type WHERE";

    if ( defined( $Param{ID} ) ) {
        $Ext .= " id = " . $Self->{DBObject}->Quote( $Param{ID}, 'Integer' )
    }
    elsif ( defined( $Param{Name} ) ) {
        $Ext .= " name LIKE '" . $Self->{DBObject}->Quote( $Param{Name} ) . "'"
    }
    $SQL .= $Ext;

    # sql
    my %Data = ();
    $Self->{DBObject}->Prepare(
        SQL => $SQL,
    );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        %Data = (
            ID   => $Row[0],
            Name => $Row[1],
        );
    }
    return \%Data;
}

=item LanguageList()

get the language list as hash

    my %Languages = $FAQObject->LanguageList();

=cut

sub LanguageList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw()) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # sql
    my %List = ();
    $Self->{DBObject}->Prepare( SQL => 'SELECT id, name FROM faq_language' );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $List{ $Row[0] } = $Row[1];
    }
    return %List;
}

=item LanguageUpdate()

update a language

    $FAQObject->LanguageUpdate(
        ID   => 1,
        Name => 'Some Category',
    );

=cut

sub LanguageUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ID Name)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # db quote
    for (qw(Name)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} ) || '';
    }
    for (qw(ID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    # sql
    my $SQL = "UPDATE faq_language SET name = '$Param{Name}' " .
        " WHERE id = $Param{ID}";
    return $Self->{DBObject}->Do( SQL => $SQL );
}

=item LanguageDuplicateCheck()

check a language

    $FAQObject->LanguageDuplicateCheck(
        Name => 'Some Name',
        ID   => 1, # for update
    );

=cut

sub LanguageDuplicateCheck {
    my ( $Self, %Param ) = @_;

    # db quote
    for (qw(Name)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} ) || '';
    }
    for (qw(ID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    # sql
    my $SQL = "SELECT id FROM faq_language WHERE ";
    if ( defined( $Param{Name} ) ) {
        $SQL .= "name = '$Param{Name}' ";
    }
    if ( defined( $Param{ID} ) ) {
        $SQL .= "AND id != '$Param{ID}' ";
    }
    $Self->{DBObject}->Prepare( SQL => $SQL );
    my $Exists = 0;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Exists = 1;
    }
    return $Exists;
}

=item LanguageAdd()

add a language

    my $ID = $FAQObject->LanguageAdd(
        Name => 'Some Category',
    );

=cut

sub LanguageAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Name)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # db quote
    for (qw(Name)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} ) || '';
    }
    my $SQL = "INSERT INTO faq_language (name) " .
        " VALUES " .
        " ('$Param{Name}') ";

    return $Self->{DBObject}->Do( SQL => $SQL );
}

=item LanguageGet()

get a language as hash

    my %Language = $FAQObject->LanguageGet(
        ID => 1,
    );

=cut

sub LanguageGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # db quote
    for (qw(ID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    # sql
    my %Data = ();
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id, name FROM faq_language WHERE id = $Param{ID}",
    );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        %Data = (
            ID   => $Row[0],
            Name => $Row[1],
        );
    }
    return %Data;
}

=item FAQSearch()

search in articles

    my @IDs = $FAQObject->FAQSearch(
        Number    => '*134*',
        Title     => '*some title*',
        What      => '*some text*', # is searching in Number, Title, Keyword and Field1-6
        Keyword   => '*webserver*',
        States    => ['public', 'internal'],
        Order     => 'Changed',     # Title|Language|State|Votes|Result|Created|Changed
        Sort      => 'up',          # up|down
        Limit     => 150,
        Interface => 'public',      # public|external|internal (default internal)
    );

=cut

sub FAQSearch {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw()) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # set default
    if ( !$Param{Interface} ) {
        $Param{Interface} = 'internal';
    }

    # sql
    my $SQL = 'SELECT i.id, count( v.item_id ) as votes, avg( v.rate ) as vrate' .
        ' FROM faq_item i ' .
        ' LEFT JOIN faq_voting v ON v.item_id = i.id' .
        ' LEFT JOIN faq_state s ON s.id = i.state_id';
    my $Ext = '';
    if ( $Param{What} && $Param{What} ne '*' ) {
        my @SearchFields = ( 'i.f_number', 'i.f_subject', 'i.f_keywords' );
        if ( $Param{Interface} eq 'internal' ) {
            push @SearchFields, (
                'i.f_field1', 'i.f_field2', 'i.f_field3',
                'i.f_field4', 'i.f_field5', 'i.f_field6',
            );
        }
        else {
            NUMBER:
            for my $Number ( 1 .. 6 ) {
                next NUMBER if !$Self->{ConfigObject}->Get("FAQ::Item::Field$Number");
                next NUMBER if $Self->{ConfigObject}->Get("FAQ::Item::Field$Number")->{Show} eq 'internal';
                push @SearchFields, "i.f_field$Number";
            }
        }
        $Ext .= $Self->{DBObject}->QueryCondition(
            Key => \@SearchFields,
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
    if ( $Param{LanguageIDs} && ref( $Param{LanguageIDs} ) eq 'ARRAY' && @{ $Param{LanguageIDs} } )
    {
        $Ext .= ' AND i.f_language_id IN (';
        for my $LanguageID ( @{ $Param{LanguageIDs} } ) {
            $Ext .= $Self->{DBObject}->Quote( $LanguageID, 'Integer' ) . ',';
        }
        $Ext = substr( $Ext, 0, -1 );
        $Ext .= ')';
    }
    if ( $Param{CategoryIDs} && ref( $Param{CategoryIDs} ) eq 'ARRAY' && @{ $Param{CategoryIDs} } )
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
    if ( $Param{States} && ref( $Param{States} ) eq 'HASH' && %{ $Param{States} } ) {
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
        $Param{Keyword} = $Self->{DBObject}->Quote($Param{Keyword}, 'Like');

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
    $Ext .= ' GROUP BY i.id, i.f_subject, i.f_language_id, i.created, i.changed, s.name, v.item_id';
    if ( $Param{Order} ) {
        $Ext .= ' ORDER BY ';

        # title
        if ( $Param{Order} eq 'Title' ) {
            $Ext .= 'i.f_subject';
        }

        # language
        elsif ( $Param{Order} eq 'Language' ) {
            $Ext .= 'i.f_language_id';
        }

        # state
        elsif ( $Param{Order} eq 'State' ) {
            $Ext .= 's.name';
        }

        # votes
        elsif ( $Param{Order} eq 'Votes' ) {
            $Ext .= 'votes';
        }

        # rates
        elsif ( $Param{Order} eq 'Result' ) {
            $Ext .= 'vrate';
        }

        # changed
        elsif ( $Param{Order} eq 'Created' ) {
            $Ext .= 'i.created';
        }

        # created
        elsif ( $Param{Order} eq 'Changed' ) {
            $Ext .= 'i.changed';
        }

        if ( $Param{Sort} ) {
            if ( $Param{Sort} eq 'up' ) {
                $Ext .= ' ASC';
            }
            elsif ( $Param{Sort} eq 'down' ) {
                $Ext .= ' DESC';
            }
        }
    }
    $SQL .= $Ext;
    my @List = ();
    $Self->{DBObject}->Prepare( SQL => $SQL, Limit => $Param{Limit} || 500 );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push( @List, $Row[0] );
    }
    return @List;
}

=item FAQPathListGet()

returns a category array

    my @IDs = $FAQObject->FAQPathListGet(
        CategoryID => 150,
    );

=cut

sub FAQPathListGet {
    my ( $Self, %Param ) = @_;

    my @CategoryList   = ();
    my $TempCategoryID = $Param{CategoryID};
    while ($TempCategoryID) {
        my %Data = $Self->CategoryGet( CategoryID => $TempCategoryID );
        if (%Data) {
            $CategoryList[ $#CategoryList + 1 ] = \%Data;
        }
        $TempCategoryID = $Data{ParentID};
    }
    @CategoryList = reverse(@CategoryList);

    return \@CategoryList;

}

=item GetCategoryTree()

get all categories as tree

    my $Hash = $FAQObject->GetCategoryTree(
        Valid => 0, # if 1 then check valid category
    );

=cut

sub GetCategoryTree {
    my ( $Self, %Param ) = @_;

    my $Valid = 0;
    if ( $Param{Valid} ) {
        $Valid = $Param{Valid};
    }

    # check cache
    if ( $Self->{Cache}->{GetCategoryTree}->{$Valid} ) {
        return $Self->{Cache}->{GetCategoryTree}->{$Valid};
    }

    # sql
    my $SQL = 'SELECT id, parent_id, name FROM faq_category';
    if ( $Valid ) {
        $SQL .= ' WHERE valid_id = 1';
    }
    $Self->{DBObject}->Prepare(
        SQL => $SQL,
    );

    my %CategoryMap = ();
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $CategoryMap{ $Row[1] }->{ $Row[0] } = $Row[2];
    }

    my $CategoryTree = {};

    # check all parent ids
    for my $ParentID ( sort { $a <=> $b } keys %CategoryMap ) {

        # get subcategories and names for this parent id
        while( my ($CategoryID, $CategoryName) = each( %{ $CategoryMap{$ParentID} } ) ) {

            # prepend parents category name
            if ( $CategoryTree->{$ParentID} ) {
                $CategoryName = $CategoryTree->{$ParentID} . '::' . $CategoryName;
            }

            # add category to tree
            $CategoryTree->{$CategoryID} = $CategoryName;
        }
    }

    # cache
    $Self->{Cache}->{GetCategoryTree}->{$Valid} = $CategoryTree;

    return $CategoryTree;
}

=item SetCategoryGroup()

set groups to a category

    $FAQObject->SetCategoryGroup(
        CategoryID => 3,
        GroupIDs   => [2,4,1,5,77],
    );

=cut

sub SetCategoryGroup {
    my ( $Self, %Param ) = @_;

    my $SQL = '';

    # check needed stuff
    for (qw(CategoryID GroupIDs)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    $Param{CategoryID} = $Self->{DBObject}->Quote( $Param{CategoryID}, 'Integer' );

    # delete old groups
    $Self->{DBObject}->Do(
        SQL => "DELETE FROM faq_category_group WHERE category_id = $Param{CategoryID}",
    );

    # insert groups
    for my $Key ( @{ $Param{GroupIDs} } ) {
        my $GroupID = $Self->{DBObject}->Quote( $Key, 'Integer' );
        $SQL = "INSERT INTO faq_category_group " .
            " (category_id, group_id, changed, changed_by, created, created_by) VALUES" .
            " ($Param{CategoryID}, $GroupID, current_timestamp, $Self->{UserID}, " .
            " current_timestamp, $Self->{UserID})";

        # write attachment to db
        if ( !$Self->{DBObject}->Do( SQL => $SQL ) ) {
            return 0;
        }
    }
    return 1;
}

=item GetCategoryGroup()

get groups from a category

    $FAQObject->GetCategoryGroup(
        CategoryID => 3,
    );

=cut

sub GetCategoryGroup {
    my ( $Self, %Param ) = @_;

    my $SQL    = '';
    my @Groups = ();

    # check needed stuff
    for (qw(CategoryID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    $Param{CategoryID} = $Self->{DBObject}->Quote( $Param{CategoryID}, 'Integer' );

    # get groups
    $SQL = "SELECT group_id FROM faq_category_group WHERE category_id = $Param{CategoryID}";
    $Self->{DBObject}->Prepare( SQL => $SQL );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push( @Groups, $Row[0] );
    }
    return \@Groups;
}

=item GetAllCategoryGroup()

get all category-groups

    $FAQObject->GetAllCategoryGroup();

=cut

sub GetAllCategoryGroup {
    my ( $Self, %Param ) = @_;

    # check cache
    if ( $Self->{Cache}->{GetAllCategoryGroup} ) {
        return $Self->{Cache}->{GetAllCategoryGroup};
    }

    # get groups
    my $SQL = "SELECT group_id, category_id FROM faq_category_group";
    $Self->{DBObject}->Prepare( SQL => $SQL );
    my %Groups = ();
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Groups{ $Row[1] }->{ $Row[0] } = 1;
    }

    # cache
    $Self->{Cache}->{GetAllCategoryGroup} = \%Groups;

    return \%Groups;
}

=item GetUserCategories()

get all category-groups

    my $Hashref = $FAQObject->GetUserCategories(
        UserID => '123456',
        Type   => 'rw'
    );

=cut

sub GetUserCategories {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(UserID Type)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my $Categories     = $Self->CategoryList( Valid => 1 );
    my $CategoryGroups = $Self->GetAllCategoryGroup();
    my %UserGroups     = ();
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

    my %Hash = ();
    $Self->_UserCategories(
        Categories     => $Categories,
        CategoryGroups => $CategoryGroups,
        UserGroups     => \%UserGroups,
        ParentID       => 0,
        NewHash        => \%Hash,
    );
    return \%Hash;
}

sub _UserCategories {
    my ( $Self, %Param ) = @_;

    my %Hash = ();
    for my $CategoryID ( keys %{ $Param{Categories}->{ $Param{ParentID} } } ) {

        # check category groups
        if ( defined( $Param{CategoryGroups}->{$CategoryID} ) ) {

            # check user groups
            for my $GroupID ( keys %{ $Param{CategoryGroups}->{$CategoryID} } ) {
                if ( defined( $Param{UserGroups}->{$GroupID} ) ) {

                    # add category to new hash
                    $Hash{$CategoryID} = $Param{Categories}->{ $Param{ParentID} }{$CategoryID};
                    last;
                }
            }
        }
        else {
            next;
        }

        # recursion
        $Self->_UserCategories(
            Categories     => $Param{Categories},
            CategoryGroups => $Param{CategoryGroups},
            UserGroups     => $Param{UserGroups},
            ParentID       => $CategoryID,
            NewHash        => $Param{NewHash},
        );
    }
    $Param{NewHash}->{ $Param{ParentID} } = \%Hash;
    return;
}

=item GetCustomerCategories()

get all category-groups

    my $Hashref = $FAQObject->GetCustomerCategories(
        CustomerUser => 'hans',
        Type => 'rw'
    );

=cut

sub GetCustomerCategories {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(CustomerUser Type)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my $Categories = $Self->CategoryList( Valid => 1 );
    my $CategoryGroups = $Self->GetAllCategoryGroup();

    #    my %UserGroups = $Self->{GroupObject}->GroupMemberList(
    #        UserID => $Param{UserID},
    #        Type => $Param{Type},
    #        Result => 'HASH',
    #    );

    my %UserGroups = $Self->{CustomerGroupObject}->GroupMemberList(
        UserID => $Param{CustomerUser},
        Type   => 'ro',
        Result => 'HASH',
    );
    my %Hash = ();
    $Self->_UserCategories(
        Categories     => $Categories,
        CategoryGroups => $CategoryGroups,
        UserGroups     => \%UserGroups,
        ParentID       => 0,
        NewHash        => \%Hash,
    );
    return \%Hash;
}

=item CheckCategoryUserPermission()

get userpermission from a category

    $FAQObject->CheckCategoryUserPermission(
        UserID => '123456',
        CategoryID => '123',
    );

=cut

sub CheckCategoryUserPermission {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(UserID CategoryID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    for my $Permission (qw(rw ro)) {
        my $Hash = $Self->GetUserCategories(
            UserID => $Param{UserID},
            Type   => 'ro'
        );
        for my $ParentID ( keys %{$Hash} ) {
            my $CategoryHash = $Hash->{$ParentID};
            for my $CategoryID ( keys %{$CategoryHash} ) {
                if ( $CategoryID == $Param{CategoryID} ) {
                    return $Permission;
                }
            }
        }
    }
    return '';
}

=item CheckCategoryCustomerPermission()

get userpermission from a category

    $FAQObject->CheckCategoryCustomerPermission(
        UserID => '123456',
        CategoryID => '123',
    );

=cut

sub CheckCategoryCustomerPermission {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(CustomerUser CategoryID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    for my $Permission (qw(rw ro)) {
        my $Hash = $Self->GetCustomerCategories(
            CustomerUser => $Param{CustomerUser},
            Type         => 'ro'
        );
        for my $ParentID ( keys %{$Hash} ) {
            my $CategoryHash = $Hash->{$ParentID};
            for my $CategoryID ( keys %{$CategoryHash} ) {
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

    my @CategorieIDs = @{$FAQObject->AgentCategorySearch(
        Name => "Name"
    )};

=cut

sub AgentCategorySearch {
    my ( $Self, %Param ) = @_;

    my @List = ();

    # check needed stuff
    for (qw(UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    if ( !defined( $Param{ParentID} ) ) {
        $Param{ParentID} = 0;
    }
    my $Hashref = $Self->GetUserCategories(
        UserID => $Param{UserID},
        Type   => 'ro'
    );
    my %CategoryHash = %{ $Hashref->{ $Param{ParentID} } };
    @List = sort { $CategoryHash{$a} cmp $CategoryHash{$b} } ( keys %CategoryHash );
    return \@List;
}

=item CustomerCategorySearch()

get the category search as hash

    my @CategorieIDs = @{$FAQObject->CustomerCategorySearch(
        Name => "Name"
    )};

=cut

sub CustomerCategorySearch {
    my ( $Self, %Param ) = @_;

    my @List = ();

    # check needed stuff
    for (qw(CustomerUser)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return ();
        }
    }
    if ( !defined( $Param{ParentID} ) ) {
        $Param{ParentID} = 0;
    }
    my $Hashref = $Self->GetCustomerCategories(
        CustomerUser => $Param{CustomerUser},
        Type         => 'ro',
    );
    my %CategoryHash = %{ $Hashref->{ $Param{ParentID} } };
    @List = sort { $CategoryHash{$a} cmp $CategoryHash{$b} } ( keys %CategoryHash );
    return \@List;
}

=item PublicCategorySearch()

get the category search as hash

    my @CategorieIDs = @{$FAQObject->PublicCategorySearch(
        Name => "Name"
    )};

=cut

sub PublicCategorySearch {
    my ( $Self, %Param ) = @_;

    my $SQL   = '';
    my $State = 0;

    # get 'public' state id
    $SQL = "SELECT id from faq_state_type WHERE name = 'public'";
    $Self->{DBObject}->Prepare( SQL => $SQL, Limit => 500 );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $State = $Row[0];
    }

    # get category ids
    $SQL = "SELECT distinct(faq_item.category_id) FROM faq_item " .
        "LEFT JOIN faq_category ON faq_item.category_id = faq_category.id " .
        "WHERE faq_category.valid_id = 1 AND faq_item.state_id = $State";
    if ( defined( $Param{ParentID} ) ) {
        $SQL .= " AND faq_category.parent_id = "
            . $Self->{DBObject}->Quote( $Param{ParentID}, 'Integer' );
    }

    my @List = ();
    $Self->{DBObject}->Prepare( SQL => $SQL, Limit => 500 );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push( @List, $Row[0] );
    }
    return \@List;
}

=item FAQLogAdd()

adds accessed FAQ article to the access log table

    my $Success = $FAQObject->FAQLogAdd(
        ItemID    => '123456',
        Interface => 'internal',
    );

=cut

sub FAQLogAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ItemID Interface)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # get environment variables
    my $IP        = $ENV{'REMOTE_ADDR'}     || '';
    my $UserAgent = $ENV{'HTTP_USER_AGENT'} || '';

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
    $Self->{DBObject}->Prepare(
        SQL => 'SELECT id FROM faq_log '
            . 'WHERE item_id = ? AND ip = ? '
            . 'AND user_agent = ? AND created > ? ',
        Bind  => [ \$Param{ItemID}, \$IP, \$UserAgent, \$TimeStamp ],
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
        Interface => 'public',
        Limit     => 10,
    );

=cut

sub FAQTop10Get {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Interface)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # prepare SQL
    my @Bind;
    my $SQL = 'SELECT item_id, count(item_id), faq_state_type.name, approved '
        . 'FROM faq_log, faq_item, faq_state, faq_state_type '
        . 'WHERE faq_log.item_id = faq_item.id '
        . 'AND faq_item.state_id = faq_state.id '
        . 'AND faq_state.type_id = faq_state_type.id ';

    # filter results for public and customer interface
    if ( ( $Param{Interface} eq 'public' ) || ( $Param{Interface} eq 'external' ) ) {

        $SQL .= "AND ( ( faq_state_type.name = 'public' ) ";

        if ( $Param{Interface} eq 'external' ) {
            $SQL .= "OR ( faq_state_type.name = 'external' ) ";
        }
        $SQL .= ') ';

        $SQL .= 'AND approved = 1 ';
    }

    # filter results for defined time period
    if ( $Param{StartDate} && $Param{EndDate} ) {
        $SQL .= 'AND faq_log.created >= ? AND faq_log.created <= ? ';
        push @Bind, ( \$Param{StartDate}, \$Param{EndDate} );
    }

    # complete SQL statement
    $SQL .= 'GROUP BY item_id, faq_state_type.name, approved  '
        . 'ORDER BY 2 DESC ';

    # get the top 10 article ids from database
    $Self->{DBObject}->Prepare(
        SQL   => $SQL,
        Bind  => \@Bind,
        Limit => $Param{Limit},
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

    $FAQObject->FAQApprovalUpdate(
        ItemID     => 123,
        Approved   => 1,    # 0|1 (default 0)
    );

=cut

sub FAQApprovalUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ItemID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    if ( !defined $Param{Approved} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need Approved param!" );
        return;
    }

    # update database
    return if !$Self->{DBObject}->Do(
        SQL => 'UPDATE faq_item '
            . 'SET approved = ?, '
            . 'changed = current_timestamp, '
            . 'changed_by = ? '
            . 'WHERE id = ?',
        Bind => [
            \$Param{Approved}, \$Self->{UserID}, \$Param{ItemID},
        ],
    );

    # create new approval ticket
    if ( $Self->{ConfigObject}->Get('FAQ::ApprovalRequired') && !$Param{Approved} ) {

        my %Data = $Self->FAQGet(
            ItemID => $Param{ItemID},
        );

        my $Ok = $Self->FAQApprovalTicketCreate(
            ItemID     => $Param{ItemID},
            CategoryID => $Data{CategoryID},
            FAQNumber  => $Data{Number},
            Title      => $Data{Title},
            UserID     => $Self->{UserID},
            StateID    => $Data{StateID},
        );
        if ( !$Ok ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Could not create approval ticket!" );
        }
    }

    return 1;
}

=item FAQApprovalTicketCreate()

creates an approval ticket

    $FAQObject->FAQApprovalTicketCreate(
        ItemID     => 123,
        CategoryID => 2,
        FAQNumber  => 10211,
        Title      => 'Some Title',
        UserID     => 1,
        StateID    => 1,
    );

=cut

sub FAQApprovalTicketCreate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ItemID CategoryID FAQNumber Title UserID StateID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
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
        State    => 'new',
        OwnerID  => 1,
        UserID   => 1,
    );

    if ( $TicketID ) {

        # get UserName
        my $UserName = $Self->{UserObject}->UserName(
            UserID => $Param{UserID},
        );

        # get faq state
        my %State = $Self->StateGet(
            ID => $Param{StateID},
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
            TicketID       => $TicketID,
            ArticleType    => 'note-internal',
            SenderType     => 'system',
            Subject        => $Subject,
            Body           => $Body,
            ContentType    => "text/plain; charset=$Self->{ConfigObject}->Get('DefaultCharset')",
            UserID         => 1,
            HistoryType    => 'AddNote',
            HistoryComment => $Self->{ConfigObject}->Get('Ticket::Frontend::AgentTicketNote')->{HistoryComment},
        );
        return 1;
    }

    return;
}

=item FAQPictureUploadAdd()

stores uploaded pictures as faq attachments

    $FAQObject->FAQPictureUploadAdd(
        ItemID => 12,
        FormID => 12345,
        Field1 => 'some text',
        Field2 => 'some text',
        Field3 => 'some text',
        Field4 => 'some text',
        Field5 => 'some text',
        Field6 => 'some text',
    );

=cut

sub FAQPictureUploadAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ItemID FormID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # get uploaded pictures from upload cache
    my @AttachmentData = $Self->{UploadCacheObject}->FormIDGetAllFilesData(
        FormID => $Param{FormID},
    );

    my %Filenames;
    ATTACHMENT:
    for my $Attachment ( @AttachmentData ) {

        # store picture as attachment of faq article
        my $Ok = $Self->AttachmentAdd(
            ItemID      => $Param{ItemID},
            Content     => $Attachment->{Content},
            ContentType => $Attachment->{ContentType},
            Filename    => $Attachment->{Filename},
            Inline      => 1,
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
    );

    # rewrite url to picture if it was successfully stored
    ATTACHMENT:
    for my $Attachment ( @AttachmentIndex ) {

        # picture url in upload cache
        my $Search = "Action=PictureUpload .+ FormID=$Param{FormID} .+ "
            . "Filename=$Attachment->{Filename}";

        # picture url in faq atttachment
        my $Replace = "Action=AgentFAQ&Subaction=Download&"
            . "ItemID=$Param{ItemID}&FileID=$Attachment->{FileID}";

        # rewrite picture urls
        FIELD:
        for my $Number ( 1..6 ) {
            next FIELD if !$Param{"Field$Number"};

            # remove newlines
            $Param{"Field$Number"} =~ s{ [\n\r]+ }{}gxms;

            # replace url
            $Param{"Field$Number"} =~ s{$Search}{$Replace}xms;
        }
    }

    # update FAQ article
    my $Ok = $Self->FAQUpdate(
        %Param,
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

=item HTML2Text()

converts html to plain text

    $FAQObject->HTML2Text(
        HTMLString => 'Some HTML content...',
    );

=cut

sub HTML2Text {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw( HTMLString )) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # get params
    my $HTMLString = $Param{HTMLString};

    # html2text filter for message body
    my $LinkList = '';
    my $Counter  = 0;

    # find <a href=....> and replace it with [x]
    $HTMLString =~ s{
        <a\Whref=("|')(.+?)("|')(|.+?)>
    }
    {
        my $Link = $2;
        $Counter++;
        $LinkList .= "[$Counter] $Link\n";
        "[$Counter]";
    }egxi;

    # remove empty lines
    $HTMLString =~ s/^\s*//mg;
    $HTMLString =~ s/\n//gs;

    # remove style tags
    $HTMLString =~ s/\<style.+?\>.*\<\/style\>//gsi;

    # remove br tags and replace it with \n
    $HTMLString =~ s/\<br(\/|)\>/\n/gsi;

    # remove hr tags and replace it with \n
    $HTMLString =~ s/\<(hr|hr.+?)\>/\n\n/gsi;

    # remove pre, p, table, code tags and replace it with \n
    $HTMLString =~ s/\<(\/|)(pre|pre.+?|p|p.+?|table|table.+?|code|code.+?)\>/\n\n/gsi;

    # remove tr, th tags and replace it with \n
    $HTMLString =~ s/\<(tr|tr.+?|th|th.+?)\>/\n\n/gsi;

    # remove td tags and replace it with \n
    $HTMLString =~ s/\.+?<\/(td|td.+?)\>/ /gsi;

    # strip all other tags
    $HTMLString =~ s/\<.+?\>//gs;

    # replace "  " with " " space
    $HTMLString =~ s/  / /mg;

    # html encode based from cpan's HTML::Entities v1.35
    my %Entity = (

        # Some normal chars that have special meaning in SGML context
        amp  => '&',    # ampersand
        'gt' => '>',    # greater than
        'lt' => '<',    # less than
        quot => '"',    # double quote
        apos => "'",    # single quote

        # PUBLIC ISO 8879-1986//ENTITIES Added Latin 1//EN//HTML
        AElig  => chr(198),    # capital AE diphthong (ligature)
        Aacute => chr(193),    # capital A, acute accent
        Acirc  => chr(194),    # capital A, circumflex accent
        Agrave => chr(192),    # capital A, grave accent
        Aring  => chr(197),    # capital A, ring
        Atilde => chr(195),    # capital A, tilde
        Auml   => chr(196),    # capital A, dieresis or umlaut mark
        Ccedil => chr(199),    # capital C, cedilla
        ETH    => chr(208),    # capital Eth, Icelandic
        Eacute => chr(201),    # capital E, acute accent
        Ecirc  => chr(202),    # capital E, circumflex accent
        Egrave => chr(200),    # capital E, grave accent
        Euml   => chr(203),    # capital E, dieresis or umlaut mark
        Iacute => chr(205),    # capital I, acute accent
        Icirc  => chr(206),    # capital I, circumflex accent
        Igrave => chr(204),    # capital I, grave accent
        Iuml   => chr(207),    # capital I, dieresis or umlaut mark
        Ntilde => chr(209),    # capital N, tilde
        Oacute => chr(211),    # capital O, acute accent
        Ocirc  => chr(212),    # capital O, circumflex accent
        Ograve => chr(210),    # capital O, grave accent
        Oslash => chr(216),    # capital O, slash
        Otilde => chr(213),    # capital O, tilde
        Ouml   => chr(214),    # capital O, dieresis or umlaut mark
        THORN  => chr(222),    # capital THORN, Icelandic
        Uacute => chr(218),    # capital U, acute accent
        Ucirc  => chr(219),    # capital U, circumflex accent
        Ugrave => chr(217),    # capital U, grave accent
        Uuml   => chr(220),    # capital U, dieresis or umlaut mark
        Yacute => chr(221),    # capital Y, acute accent
        aacute => chr(225),    # small a, acute accent
        acirc  => chr(226),    # small a, circumflex accent
        aelig  => chr(230),    # small ae diphthong (ligature)
        agrave => chr(224),    # small a, grave accent
        aring  => chr(229),    # small a, ring
        atilde => chr(227),    # small a, tilde
        auml   => chr(228),    # small a, dieresis or umlaut mark
        ccedil => chr(231),    # small c, cedilla
        eacute => chr(233),    # small e, acute accent
        ecirc  => chr(234),    # small e, circumflex accent
        egrave => chr(232),    # small e, grave accent
        eth    => chr(240),    # small eth, Icelandic
        euml   => chr(235),    # small e, dieresis or umlaut mark
        iacute => chr(237),    # small i, acute accent
        icirc  => chr(238),    # small i, circumflex accent
        igrave => chr(236),    # small i, grave accent
        iuml   => chr(239),    # small i, dieresis or umlaut mark
        ntilde => chr(241),    # small n, tilde
        oacute => chr(243),    # small o, acute accent
        ocirc  => chr(244),    # small o, circumflex accent
        ograve => chr(242),    # small o, grave accent
        oslash => chr(248),    # small o, slash
        otilde => chr(245),    # small o, tilde
        ouml   => chr(246),    # small o, dieresis or umlaut mark
        szlig  => chr(223),    # small sharp s, German (sz ligature)
        thorn  => chr(254),    # small thorn, Icelandic
        uacute => chr(250),    # small u, acute accent
        ucirc  => chr(251),    # small u, circumflex accent
        ugrave => chr(249),    # small u, grave accent
        uuml   => chr(252),    # small u, dieresis or umlaut mark
        yacute => chr(253),    # small y, acute accent
        yuml   => chr(255),    # small y, dieresis or umlaut mark

        # Some extra Latin 1 chars that are listed in the HTML3.2 draft (21-May-96)
        copy => chr(169),      # copyright sign
        reg  => chr(174),      # registered sign
        nbsp => chr(160),      # non breaking space

        # Additional ISO-8859/1 entities listed in rfc1866 (section 14)
        iexcl   => chr(161),
        cent    => chr(162),
        pound   => chr(163),
        curren  => chr(164),
        yen     => chr(165),
        brvbar  => chr(166),
        sect    => chr(167),
        uml     => chr(168),
        ordf    => chr(170),
        laquo   => chr(171),
        'not'   => chr(172),    # not is a keyword in perl
        shy     => chr(173),
        macr    => chr(175),
        deg     => chr(176),
        plusmn  => chr(177),
        sup1    => chr(185),
        sup2    => chr(178),
        sup3    => chr(179),
        acute   => chr(180),
        micro   => chr(181),
        para    => chr(182),
        middot  => chr(183),
        cedil   => chr(184),
        ordm    => chr(186),
        raquo   => chr(187),
        frac14  => chr(188),
        frac12  => chr(189),
        frac34  => chr(190),
        iquest  => chr(191),
        'times' => chr(215),    # times is a keyword in perl
        divide  => chr(247),

        (
            $] > 5.007
            ? (
                OElig    => chr(338),
                oelig    => chr(339),
                Scaron   => chr(352),
                scaron   => chr(353),
                Yuml     => chr(376),
                fnof     => chr(402),
                circ     => chr(710),
                tilde    => chr(732),
                Alpha    => chr(913),
                Beta     => chr(914),
                Gamma    => chr(915),
                Delta    => chr(916),
                Epsilon  => chr(917),
                Zeta     => chr(918),
                Eta      => chr(919),
                Theta    => chr(920),
                Iota     => chr(921),
                Kappa    => chr(922),
                Lambda   => chr(923),
                Mu       => chr(924),
                Nu       => chr(925),
                Xi       => chr(926),
                Omicron  => chr(927),
                Pi       => chr(928),
                Rho      => chr(929),
                Sigma    => chr(931),
                Tau      => chr(932),
                Upsilon  => chr(933),
                Phi      => chr(934),
                Chi      => chr(935),
                Psi      => chr(936),
                Omega    => chr(937),
                alpha    => chr(945),
                beta     => chr(946),
                gamma    => chr(947),
                delta    => chr(948),
                epsilon  => chr(949),
                zeta     => chr(950),
                eta      => chr(951),
                theta    => chr(952),
                iota     => chr(953),
                kappa    => chr(954),
                lambda   => chr(955),
                mu       => chr(956),
                nu       => chr(957),
                xi       => chr(958),
                omicron  => chr(959),
                pi       => chr(960),
                rho      => chr(961),
                sigmaf   => chr(962),
                sigma    => chr(963),
                tau      => chr(964),
                upsilon  => chr(965),
                phi      => chr(966),
                chi      => chr(967),
                psi      => chr(968),
                omega    => chr(969),
                thetasym => chr(977),
                upsih    => chr(978),
                piv      => chr(982),
                ensp     => chr(8194),
                emsp     => chr(8195),
                thinsp   => chr(8201),
                zwnj     => chr(8204),
                zwj      => chr(8205),
                lrm      => chr(8206),
                rlm      => chr(8207),
                ndash    => chr(8211),
                mdash    => chr(8212),
                lsquo    => chr(8216),
                rsquo    => chr(8217),
                sbquo    => chr(8218),
                ldquo    => chr(8220),
                rdquo    => chr(8221),
                bdquo    => chr(8222),
                dagger   => chr(8224),
                Dagger   => chr(8225),
                bull     => chr(8226),
                hellip   => chr(8230),
                permil   => chr(8240),
                prime    => chr(8242),
                Prime    => chr(8243),
                lsaquo   => chr(8249),
                rsaquo   => chr(8250),
                oline    => chr(8254),
                frasl    => chr(8260),
                euro     => chr(8364),
                image    => chr(8465),
                weierp   => chr(8472),
                real     => chr(8476),
                trade    => chr(8482),
                alefsym  => chr(8501),
                larr     => chr(8592),
                uarr     => chr(8593),
                rarr     => chr(8594),
                darr     => chr(8595),
                harr     => chr(8596),
                crarr    => chr(8629),
                lArr     => chr(8656),
                uArr     => chr(8657),
                rArr     => chr(8658),
                dArr     => chr(8659),
                hArr     => chr(8660),
                forall   => chr(8704),
                part     => chr(8706),
                exist    => chr(8707),
                empty    => chr(8709),
                nabla    => chr(8711),
                isin     => chr(8712),
                notin    => chr(8713),
                ni       => chr(8715),
                prod     => chr(8719),
                sum      => chr(8721),
                minus    => chr(8722),
                lowast   => chr(8727),
                radic    => chr(8730),
                prop     => chr(8733),
                infin    => chr(8734),
                ang      => chr(8736),
                'and'    => chr(8743),
                'or'     => chr(8744),
                cap      => chr(8745),
                cup      => chr(8746),
                'int'    => chr(8747),
                there4   => chr(8756),
                sim      => chr(8764),
                cong     => chr(8773),
                asymp    => chr(8776),
                'ne'     => chr(8800),
                equiv    => chr(8801),
                'le'     => chr(8804),
                'ge'     => chr(8805),
                'sub'    => chr(8834),
                sup      => chr(8835),
                nsub     => chr(8836),
                sube     => chr(8838),
                supe     => chr(8839),
                oplus    => chr(8853),
                otimes   => chr(8855),
                perp     => chr(8869),
                sdot     => chr(8901),
                lceil    => chr(8968),
                rceil    => chr(8969),
                lfloor   => chr(8970),
                rfloor   => chr(8971),
                lang     => chr(9001),
                rang     => chr(9002),
                loz      => chr(9674),
                spades   => chr(9824),
                clubs    => chr(9827),
                hearts   => chr(9829),
                diams    => chr(9830),
                )
            : ()
            )
    );

    # encode html entities like "&#8211;"
    $HTMLString =~ s{
        (&\#(\d+);?)
    }
    {
        my $Chr = chr( $2 );
        if ( $Chr ) {
            $Chr;
        }
        else {
            $1;
        };
    }egx;

    # encode html entities like "&#3d;"
    $HTMLString =~ s{
        (&\#[xX]([0-9a-fA-F]+);?)
    }
    {
        my $ChrOrig = $1;
        my $Hex = hex( $2 );
        if ( $Hex ) {
            my $Chr = chr( $Hex );
            if ( $Chr ) {
                $Chr;
            }
            else {
                $ChrOrig;
            }
        }
        else {
            $ChrOrig;
        }
    }egx;

    # encode html entities like "&amp;"
    $HTMLString =~ s{
        (&(\w+);?)
    }
    {
        if ( $Entity{$2} ) {
            $Entity{$2};
        }
        else {
            $1;
        }
    }egx;

    # remove empty lines
    $HTMLString =~ s/^\s*\n\s*\n/\n/mg;

    # force line bracking
    $HTMLString =~ s/(.{4,78})(?:\s|\z)/$1\n/gm;

    # add extracted links
    $HTMLString .= "\n\n" . $LinkList;

    return $HTMLString;
}

1;

=back
=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.

=cut

=head1 VERSION

$Revision: 1.59 $ $Date: 2009-01-23 18:04:21 $

=cut
