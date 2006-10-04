# --
# Kernel/System/FAQ.pm - all faq funktions
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: FAQ.pm,v 1.3 2006-10-04 09:14:49 rk Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::FAQ;

use strict;
use MIME::Base64;
use Kernel::System::Encode;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.3 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

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
  use Kernel::System::DB;
  use Kernel::System::FAQ;

  my $ConfigObject = Kernel::Config->new();
  my $LogObject    = Kernel::System::Log->new(
      ConfigObject => $ConfigObject,
  );
  my $DBObject = Kernel::System::DB->new(
      ConfigObject => $ConfigObject,
      LogObject => $LogObject,
  );
  my $FAQObject = Kernel::System::FAQ->new(
      ConfigObject => $ConfigObject,
      LogObject => $LogObject,
      DBObject => $DBObject,
  );

=cut

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # check needed objects
    foreach (qw(DBObject ConfigObject LogObject UserID)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    $Self->{EncodeObject} = Kernel::System::Encode->new(%Param);
    return $Self;
}

=item FAQGet()

get an article

  my %Article = $FAQObject->FAQGet(
      ID => 1,
  );

=cut

sub FAQGet {
    my $Self = shift;
    my %Param = @_;

    # Failures rename from ItemID to FAQID
    if($Param{FAQID}) {
        $Param{ItemID} = $Param{FAQID};
    }

    # check needed stuff
    foreach (qw(ItemID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return {};
      }
    }
    # db quote
    foreach (qw(ItemID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    my %Data = ();
    my $SQL = "SELECT i.f_name, i.f_language_id, i.f_subject, ".
            " i.f_field1, i.f_field2, i.f_field3, ".
            " i.f_field4, i.f_field5, i.f_field6, ".
            " i.free_key1, i.free_value1, i.free_key2, i.free_value2, ".
            " i.free_key3, i.free_value3, i.free_key4, i.free_value4, ".
            " i.created, i.created_by, i.changed, i.changed_by, ".
            " i.category_id, i.state_id, c.name, s.name, l.name, i.f_keywords, i.f_number, st.id, st.name ".
            " FROM faq_item i, faq_category c, faq_state s, faq_state_type st, faq_language l ".
            " WHERE ".
            " i.state_id = s.id AND ".
            " s.type_id = st.id AND ".
            " i.category_id = c.id AND ".
            " i.f_language_id = l.id AND ".
            " i.id = $Param{ItemID}";
    #$Self->{LogObject}->Log(Priority => 'error', Message => $SQL);
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while  (my @Row = $Self->{DBObject}->FetchrowArray()) {
        my %VoteData = %{$Self->ItemVoteDataGet(ItemID=>$Param{ItemID})};
        %Data = (
            # var for old versions
            ID => $Param{ItemID},
            FAQID => $Param{ItemID},
            #
            ItemID => $Param{ItemID},
            Name => $Row[0],
            LanguageID => $Row[1],
            Title => $Row[2],
            Field1 => $Row[3],
            Field2 => $Row[4],
            Field3 => $Row[5],
            Field4 => $Row[6],
            Field5 => $Row[7],
            Field6 => $Row[8],
            FreeKey1 => $Row[9],
            FreeKey2 => $Row[10],
            FreeKey3 => $Row[11],
            FreeKey4 => $Row[12],
            FreeKey5 => $Row[13],
            FreeKey6 => $Row[14],
            Created => $Row[17],
            CreatedBy => $Row[18],
            Changed => $Row[19],
            ChangedBy => $Row[20],
            CategoryID => $Row[21],
            StateID => $Row[22],
            CategoryName => $Row[23],
            State => $Row[24],
            Language => $Row[25],
            Keywords => $Row[26],
            Number => $Row[27],
            StateTypeID => $Row[28],
            StateTypeName => $Row[29],
            Result => sprintf("%0.".$Self->{ConfigObject}->Get("FAQ::Explorer::ItemList::VotingResultDecimalPlaces")."f",$VoteData{Result} || 0),
            Votes => $VoteData{Votes},
        );
    }
    if (!%Data) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "No such ItemID $Param{ItemID}!");
        return;
    }
    # update number
    if (!$Data{Number}) {
        my $Number = $Self->{ConfigObject}->Get('SystemID')."00".$Data{ItemID};
        $Self->{DBObject}->Do(
            SQL => "UPDATE faq_item SET f_number = '$Number' WHERE id = $Data{ItemID}",
        );
        $Data{Number} = $Number;
    }
    # get attachment
    $SQL = "SELECT filename, content_type, content_size, content ".
        " FROM faq_attachment WHERE faq_id = $Param{ItemID}";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while  (my @Row = $Self->{DBObject}->FetchrowArray()) {
        # decode attachment if it's a postgresql backend and not BLOB
        if (!$Self->{DBObject}->GetDatabaseFunction('DirectBlob')) {
            $Row[3] = decode_base64($Row[3]);
            $Self->{EncodeObject}->Encode(\$Row[3]);
        }
        $Data{Filename} = $Row[0];
        $Data{ContentType} = $Row[1];
        $Data{ContentSize} = $Row[2];
        $Data{Content} = $Row[3];
    }

    return %Data;
}



=item ItemVoteDataGet()

returns a hash with number and result of a item

  my %Flag = $FAQObject->ItemVoteDataGet(
      ItemID => 1,
  );

=cut
sub ItemVoteDataGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ItemID)) {
       if (!$Param{$_}) {
         $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
         return 0;
       }
    }

    # db quote
    foreach (qw(ItemID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }

    my $SQL = " SELECT count(*), avg(rate) FROM faq_voting WHERE item_id = " . $Param{ItemID};

    my %Hash = ();
    $Self->{DBObject}->Prepare(SQL => $SQL, Limit => $Param{Limit} || 500);
    if(my @Data = $Self->{DBObject}->FetchrowArray()) {
        $Hash{Votes}  = $Data[0];
        $Hash{Result} = $Data[1];
    }
    return \%Hash;
}

=item FAQAdd()

add an article

  my $ItemID = $FAQObject->FAQAdd(
      Number => '13402',
      Title => 'Some Text',
      CategoryID => 1,
      StateID => 1,
      LanguageID => 1,
      Field1 => 'Problem...',
      Field2 => 'Solution...',
      FreeKey1 => 'Software',
      FreeText1 => 'Apache 3.4.2',
      FreeKey2 => 'OS',
      FreeText2 => 'OpenBSD 4.2.2',
      # attachment options (not required)
      Filename => $Filename,
      Content => $Content,
      ContentType => $ContentType,
  );

=cut

sub FAQAdd {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(CategoryID StateID LanguageID Title)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return 0;
      }
    }
    # check name
    if (!$Param{Name}) {
        $Param{Name} = time().'-'.rand(100);
    }
    # check number
    if (!$Param{Number}) {
        $Param{Number} = $Self->{ConfigObject}->Get('SystemID').rand(100);
    }
    # db quote (just not Content, use db Bind values)
    foreach (qw(Number Name Title Keywords Field1 Field2 Field3 Field4 Field5 Field6 FreeKey1 FreeText1 FreeKey2 FreeText2 FreeKey3 FreeText3 FreeKey4 FreeText4 Filename ContentType Filesize)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach (qw(CategoryID StateID LanguageID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }

    foreach my $Type (qw(Field FreeKey FreeText)) {
        foreach (1..6) {
            if (!defined($Param{$Type.$_})) {
                $Param{$Type.$_} = '';
            }
        }
    }
    my $SQL = "INSERT INTO faq_item (f_number, f_name, f_language_id, f_subject, ".
            " category_id, state_id, f_keywords, ".
            " f_field1, f_field2, f_field3, f_field4, f_field5, f_field6, ".
            " free_key1, free_value1, free_key2, free_value2, ".
            " free_key3, free_value3, free_key4, free_value4, ".
            " created, created_by, changed, changed_by)".
            " VALUES ".
            " ('$Param{Number}', '$Param{Name}', $Param{LanguageID}, '$Param{Title}', ".
            " $Param{CategoryID}, $Param{StateID}, '$Param{Keywords}', ".
            " '$Param{Field1}', '$Param{Field2}', '$Param{Field3}', ".
            " '$Param{Field4}', '$Param{Field5}', '$Param{Field6}', ".
            " '$Param{FreeKey1}', '$Param{FreeText1}', ".
            " '$Param{FreeKey2}', '$Param{FreeText2}', ".
            " '$Param{FreeKey3}', '$Param{FreeText3}', ".
            " '$Param{FreeKey4}', '$Param{FreeText4}', ".
            " current_timestamp, $Self->{UserID}, ".
            " current_timestamp, $Self->{UserID})";

    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        # get id
        $Self->{DBObject}->Prepare(
            SQL => "SELECT id FROM faq_item WHERE ".
              "f_name = '$Param{Name}' AND f_language_id = $Param{LanguageID} ".
              " AND f_subject = '$Param{Title}'",
        );
        my $ID = 0;
        while  (my @Row = $Self->{DBObject}->FetchrowArray()) {
            $ID = $Row[0];
        }
        # update number
        my $Number = $Self->{ConfigObject}->Get('SystemID')."00".$ID;
        $Self->{DBObject}->Do(
            SQL => "UPDATE faq_item SET f_number = '$Number' WHERE id = $ID",
        );
        # add attachment
        if($Param{Content} && $Param{ContentType} && $Param{Filename}) {
            $Self->AttachmentAdd(
                ItemID => $ID,
                Content => $Param{Content},
                ContentType => $Param{ContentType},
                Filename => $Param{Filename}
            );
        }

        $Self->FAQHistoryAdd(
            Name => 'Created',
            ItemID => $ID,
        );
        return $ID;
    }
    else {
        return;
    }

}

=item AttachmentAdd()

=cut


sub AttachmentAdd {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ItemID Content ContentType Filename)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }

    # get attachment size
    {
        use bytes;
        $Param{Filesize} = length($Param{Content});
        no bytes;
    }
    # encode attachemnt if it's a postgresql backend!!!
    if (!$Self->{DBObject}->GetDatabaseFunction('DirectBlob')) {
        $Self->{EncodeObject}->EncodeOutput(\$Param{Content});
        $Param{Content} = encode_base64($Param{Content});
    }

    my $SQL = "INSERT INTO faq_attachment ".
        " (faq_id, filename, content_type, content_size, content, ".
        " created, created_by, changed, changed_by) " .
        " VALUES ".
        " ($Param{ItemID}, '$Param{Filename}', '$Param{ContentType}', '$Param{Filesize}', ?, ".
        " current_timestamp, $Self->{UserID}, current_timestamp, $Self->{UserID})";
    # write attachment to db
    if ($Self->{DBObject}->Do(SQL => $SQL, Bind => [\$Param{Content}])) {
        return 1;
    }
    return 0;
}


=item AttachmentGet()

=cut


sub AttachmentGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ItemID Content ContentType Filename)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
}


=item AttachmentDelete()

=cut


sub AttachmentDelete {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ItemID Content ContentType Filename)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
}


=item AttachmentSearch()

=cut


sub AttachmentSearch {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ItemID Content ContentType Filename)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
}

=item FAQUpdate()

update an article

  $FAQObject->FAQUpdate(
      CategoryID => 1,
      StateID => 1,
      LanguageID => 1,
      Title => 'Some Text',
      Field1 => 'Problem...',
      Field2 => 'Solution...',
      FreeKey1 => 'Software',
      FreeText1 => 'Apache 3.4.2',
      FreeKey2 => 'OS',
      FreeText2 => 'OpenBSD 4.2.2',
      # attachment options (not required)
      Filename => $Filename,
      Content => $Content,
      ContentType => $ContentType,
  );

=cut

sub FAQUpdate {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ItemID CategoryID StateID LanguageID Title)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # check name
    if (!$Param{Name}) {
        my %Article = $Self->FAQGet(%Param);
        $Param{Name} = $Article{Name};
    }
    # db quote (just not Content, use db Bind values)
    foreach (qw(Number Name Title Keywords Field1 Field2 Field3 Field4 Field5 Field6 FreeKey1 FreeText1 FreeKey2 FreeText2 FreeKey3 FreeText3 FreeKey4 FreeText4 Filename ContentType Filesize)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach (qw(ItemID CategoryID StateID LanguageID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # fill up empty stuff
    foreach my $Type (qw(Field FreeKey FreeText)) {
        foreach (1..6) {
            if (!$Param{$Type.$_}) {
                $Param{$Type.$_} = '';
            }
        }
    }

    my $SQL = "UPDATE faq_item SET f_name = '$Param{Name}', ".
            " f_language_id = $Param{LanguageID}, f_subject = '$Param{Title}', ".
            " category_id = $Param{CategoryID}, state_id = $Param{StateID}, ".
            " f_keywords = '$Param{Keywords}', ".
            " f_field1 = '$Param{Field1}', f_field2 = '$Param{Field2}', ".
            " f_field3 = '$Param{Field3}', f_field4 = '$Param{Field4}', ".
            " f_field5 = '$Param{Field5}', f_field6 = '$Param{Field6}', ".
            " free_key1 = '$Param{FreeKey1}', free_value1 = '$Param{FreeText1}', ".
            " free_key2 = '$Param{FreeKey2}', free_value2 = '$Param{FreeText2}', ".
            " free_key3 = '$Param{FreeKey3}', free_value3 = '$Param{FreeText3}', ".
            " free_key4 = '$Param{FreeKey4}', free_value4 = '$Param{FreeText4}', ".
            " changed = current_timestamp, changed_by = $Self->{UserID} ".
            " WHERE id = $Param{ItemID} ";

    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        # add attachment
        if ($Param{Content} && $Param{ContentType} && $Param{Filename}) {
            # get attachment size
            {
                use bytes;
                $Param{Filesize} = length($Param{Content});
                no bytes;
            }
            # encode attachemnt if it's a postgresql backend!!!
            if (!$Self->{DBObject}->GetDatabaseFunction('DirectBlob')) {
                $Self->{EncodeObject}->EncodeOutput(\$Param{Content});
                $Param{Content} = encode_base64($Param{Content});
            }
            # delete old attachment
            $Self->{DBObject}->Do(
                SQL => "DELETE FROM faq_attachment WHERE faq_id = $Param{ItemID}",
            );
            my $SQL = "INSERT INTO faq_attachment ".
                " (faq_id, filename, content_type, content_size, content, ".
                " created, created_by, changed, changed_by) " .
                " VALUES ".
                " ($Param{ItemID}, '$Param{Filename}', '$Param{ContentType}', '$Param{Filesize}', ?, ".
                " current_timestamp, $Self->{UserID}, current_timestamp, $Self->{UserID})";
            # write attachment to db
            if ($Self->{DBObject}->Do(SQL => $SQL, Bind => [\$Param{Content}])) {

            }
        }
        $Self->FAQHistoryAdd(
            Name => 'Updated',
            ItemID => $Param{ItemID},
        );
        return 1;
    }
    else {
        return;
    }
}


=item FAQCount()

count an article

  $FAQObject->FAQCount(
      CategoryIDs => [1,2,3,4],
  );

=cut

sub FAQCount {
    my $Self = shift;
    my %Param = @_;

    # check needed stuff
    foreach (qw(CategoryIDs ItemStates)) {
        if (!defined($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }

    my $SQL = "";
    my $Ext = "";
    $SQL = "SELECT COUNT(*)" .
           " FROM faq_item i, faq_state s".
           " WHERE i.category_id IN ('${\(join '\', \'', @{$Param{CategoryIDs}})}')".
           " AND i.state_id = s.id";
    if ($Param{ItemStates} && ref($Param{ItemStates}) eq 'HASH' && %{$Param{ItemStates}}) {
        $Ext .= " AND s.type_id IN ('${\(join '\', \'', keys(%{$Param{ItemStates}}))}')";
    }
    $Ext .= " GROUP BY category_id";
    $SQL .= $Ext;

    $Self->{DBObject}->Prepare(SQL => $SQL, Limit => 200);

    if(my @Row = $Self->{DBObject}->FetchrowArray()) {
        return $Row[0];
    } else {
        return 0;
    }
}



=item VoteAdd()

add an article

  my $ItemID = $FAQObject->FAQVote(
      CreateBy => 'Some Text',
      ItemID => '123456',
      IP => 54.43.30.1',
      Interface => 'Some Text',
      Rate => 100,
  );

=cut

sub VoteAdd {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(CreatedBy ItemID IP Interface)) {
       if (!$Param{$_}) {
         $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
         return 0;
       }
    }

    # db quote
    foreach (qw(CreatedBy Interface IP)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach (qw(ItemID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }

    my $SQL = "INSERT INTO faq_voting ( ".
              " created_by, item_id, ip, interface, rate, created".
              " ) VALUES (".
              " '$Param{CreatedBy}', ".
              " $Param{ItemID}, ".
              " '$Param{IP}', ".
              " '$Param{Interface}', ".
              " '$Param{Rate}', ".
              " current_timestamp ".
              " )";
    #$Self->{LogObject}->Log(Priority => 'error', Message => $SQL);
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        return 1;
    }
    else {
        return 0;
    }

}

=item VoteGet()

add an article

  my %VoteData = %{$FAQObject->VoteGet(
      CreateBy => 'Some Text',
      ItemID => '123456',
      Interface => 'Some Text',
  )};

=cut
sub VoteGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(CreateBy ItemID Interface IP)) {
       if (!$Param{$_}) {
         $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
         return {};
       }
    }


    # db quote
    foreach (qw(CreatedBy Interface IP)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach (qw(ItemID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }

    my $Ext = "";
    my $SQL = " SELECT created_by, item_id, interface, ip, created, rate FROM faq_voting WHERE";

    # public
    if($Param{Interface} eq '3') {
        $Ext .= " ip LIKE '$Param{IP}' AND".
                " item_id = $Param{ItemID}";

    # customer
    } elsif($Param{Interface} eq '2') {
        $Ext .= " created_by LIKE '$Param{CreateBy}' AND".
                " item_id = $Param{ItemID}";

    # internal
    } elsif($Param{Interface} eq '1') {
        $Ext .= " created_by LIKE '$Param{CreateBy}' AND".
                " item_id = $Param{ItemID}";
    }
    $SQL .= $Ext;
    #$Self->{LogObject}->Log(Priority => 'error', Message => $SQL);

    $Self->{DBObject}->Prepare(SQL => $SQL);
    my %Data = ();
    while  (my @Row = $Self->{DBObject}->FetchrowArray()) {
        %Data = (
            CreatedBy => $Row[0],
            ItemID => $Row[1],
            Interface => $Row[2],
            IP => $Row[3],
            Created => $Row[4],
            Rate => $Row[5],
        );
    }
    if (!%Data) {
        #$Self->{LogObject}->Log(Priority => 'error', Message => "No voting for this faq article! Kernel::System::FAQ::VoteGet()");
        return {};
    }
    return \%Data;
}

=item VoteSearch()

returns a array with VoteIDs

  my @FAQIDs = @{$FAQObject->VoteSearch(
      ItemID => 1,
  )};

=cut
sub VoteSearch {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ItemID)) {
       if (!$Param{$_}) {
         $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
         return [];
       }
    }

    # db quote
    foreach (qw()) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach (qw(ItemID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }

    my $Ext = "";
    my $SQL = " SELECT id FROM faq_voting WHERE";

    if(defined($Param{ItemID})) {
        $Ext .= " item_id = " . $Param{ItemID};
    }

    $SQL .= $Ext;

    my @List = ();
    $Self->{DBObject}->Prepare(SQL => $SQL, Limit => $Param{Limit} || 500);
    while  (my @Row = $Self->{DBObject}->FetchrowArray()) {
        push (@List, $Row[0]);
    }
    return \@List;
}

=item VoteDelete()

add an article

  my $Flag = $FAQObject->VoteDelete(
      VoteID => 1,
  );

=cut
sub VoteDelete {
    my $Self = shift;
    my %Param = @_;

    # check needed stuff
    foreach (qw(VoteID)) {
       if (!$Param{$_}) {
         $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
         return 0;
       }
    }

    # db quote
    foreach (qw(VoteID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }

    my $SQL = "DELETE FROM faq_voting WHERE id = ".$Param{VoteID};

    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        return 1;
    }
    else {
        return 0;
    }

}

=item FAQDelete()

delete an article

  $Flag = $FAQObject->FAQDelete(ItemID => 1);

=cut

sub FAQDelete {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ItemID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return 0;
      }
    }
    # db quote
    foreach (qw(ItemID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    #if ($Self->AttachmentDelete(%Param)) {
        my @VoteIDs = @{$Self->VoteSearch(ItemID => $Param{ItemID})};
        foreach my $TmpVoteID (@VoteIDs) {
            if(!$Self->VoteDelete(VoteID => $TmpVoteID)) {
                return;
            }
        }
        if ($Self->FAQHistoryDelete(%Param)) {
            if ($Self->{DBObject}->Prepare(SQL => "DELETE FROM faq_item WHERE id = $Param{ItemID}")) {
                return 1;
            }
        }
    #}
    return 0;
}

=item FAQHistoryAdd()

add an history to an article

  $Flag = $FAQObject->FAQHistoryAdd(
      ItemID => 1,
      Name => 'Updated Article.',
  );

=cut

sub FAQHistoryAdd {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ItemID Name)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return 0;
      }
    }
    # db quote
    foreach (qw(Name)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }
    foreach (qw(ItemID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    my $SQL = "INSERT INTO faq_history (name, item_id, ".
            " created, created_by, changed, changed_by)".
            " VALUES ".
            " ('$Param{Name}', $Param{ItemID}, ".
            " current_timestamp, $Self->{UserID}, ".
            " current_timestamp, $Self->{UserID})";

    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        return 1;
    }
    else {
        return 0;
    }
}

=item FAQHistoryGet()

get a array with hachref (Name, Created) with history of an article back

  my @Data = @{$FAQObject->FAQHistoryGet(
      ItemID => 1,
  )};

=cut

sub FAQHistoryGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ItemID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return [];
      }
    }
    # db quote
    foreach (qw(ItemID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    my @Data = ();
    $Self->{DBObject}->Prepare(
        SQL => "SELECT name, created FROM faq_history WHERE item_id = $Param{ItemID}",
    );
    while  (my @Row = $Self->{DBObject}->FetchrowArray()) {
        my %Record = (
            Name => $Row[0],
            Created => $Row[1],
        );
        push (@Data, \%Record);
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
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ItemID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return 0;
      }
    }
    # db quote
    foreach (qw(ItemID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    $Self->{DBObject}->Prepare(
        SQL => "DELETE FROM faq_history WHERE item_id = $Param{ItemID}",
    );
    return 1;
}

=item HistoryGet()

get the system history

  my @Data = @{$FAQObject->HistoryGet()};

=cut

sub HistoryGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw()) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # query
    my $SQL = "SELECT i.id, h.name, h.created, h.created_by, c.name, i.f_subject, i.f_number FROM".
        " faq_item i, faq_state s, faq_history h, faq_category c WHERE".
        " s.id = i.state_id AND h.item_id = i.id AND i.category_id = c.id";
    if ($Param{States} && ref($Param{States}) eq 'ARRAY' && @{$Param{States}}) {
        $SQL .= " AND s.name IN ('${\(join '\', \'', @{$Param{States}})}') ";
    }
    $SQL .= ' ORDER BY created DESC';
    my @Data = ();
    $Self->{DBObject}->Prepare(SQL => $SQL, Limit => 200);
    while  (my @Row = $Self->{DBObject}->FetchrowArray()) {
        my %Record = (
            ItemID => $Row[0],
            Action => $Row[1],
            Created => $Row[2],
            CreatedBy => $Row[3],
            Category => $Row[4],
            Subject => $Row[5],
            Number => $Row[6],
        );
        push (@Data, \%Record);
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
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw()) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return {};
      }
    }
    # sql
    my $SQL = 'SELECT id, parent_id, name FROM faq_category ';
    if(defined($Param{Valid})) {
        $SQL .= 'WHERE valid_id = 1';
    }
    my %Data = ();
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while  (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Data{$Row[1]}{$Row[0]} = $Row[2];
    }

    return \%Data;
}

=item CategorySearch()

get the category search as hash

  my @CategorieIDs = @{$FAQObject->CategorySearch(
    Name => "Name"
  )};

=cut

sub CategorySearch {
    my $Self = shift;
    my %Param = @_;


    # sql
    my $SQL = "SELECT id FROM faq_category";
    my $Ext = '';

    # WHERE
    if (defined($Param{Name})) {
        $Ext .= " WHERE name LIKE '%".$Self->{DBObject}->Quote($Param{Name})."%'";
    }
    elsif (defined($Param{ParentID})) {
        $Ext .= " WHERE parent_id = '".$Self->{DBObject}->Quote($Param{ParentID}, 'Integer')."'";
    }
    elsif (defined($Param{ParentIDs}) && ref($Param{ParentIDs}) eq 'ARRAY' && @{$Param{ParentIDs}}) {
        $Ext = " WHERE parent_id IN (";
        foreach my $ParentID (@{$Param{ParentIDs}}) {
            $Ext .= $Self->{DBObject}->Quote($ParentID, 'Integer').",";
        }
        $Ext = substr($Ext,0,-1);
        $Ext .= ")";
    }
    elsif (defined($Param{CategoryIDs}) && ref($Param{CategoryIDs}) eq 'ARRAY' && @{$Param{CategoryIDs}}) {
        $Ext = " WHERE id IN (";
        foreach my $CategoryID (@{$Param{CategoryIDs}}) {
            $Ext .= $Self->{DBObject}->Quote($CategoryID, 'Integer').",";
        }
        $Ext = substr($Ext,0,-1);
        $Ext .= ")";
    }
    #if (defined($Param{ValidID})) {
    #    $Ext .= " AND valid_id = '".$Self->{DBObject}->Quote($Param{ValidID}, 'Integer')."' ";
    #}



    # ORDER BY
    if ($Param{Order}) {
        $Ext .= " ORDER BY ";
        if($Param{Order} eq 'Name') {
            $Ext .= "name";
        }
        #default
        else {
            $Ext .= "name";
        }
        # SORT
        if ($Param{Sort}) {
            if ($Param{Sort} eq 'up') {
                $Ext .= " ASC";
            }
            elsif ($Param{Sort} eq 'down') {
                $Ext .= " DESC";
            }
        }
    }

    # SQL STATEMENT
    $SQL .= $Ext;

    my @List = ();
    $Self->{DBObject}->Prepare(SQL => $SQL, Limit => 500);
    while  (my @Row = $Self->{DBObject}->FetchrowArray()) {
        push (@List, $Row[0]);
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
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(CategoryID)) {
      if (!defined($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(CategoryID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql
    my %Data = ();
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id, parent_id, name, comments FROM faq_category WHERE id = $Param{CategoryID} ",
    );
    while  (my @Row = $Self->{DBObject}->FetchrowArray()) {
        %Data = (
            CategoryID => $Row[0],
            ParentID => $Row[1],
            Name => $Row[2],
            Comment => $Row[3],
        );
    }
    return %Data;
}


=item CategorySubCategoryIDList()

get all subcategory ids of of a category

  my %Category = $FAQObject->CategorySubCategorieIDList(
      ParentID => 1,
      ItemStates => [1,2,3]
  );

=cut

sub CategorySubCategoryIDList {

    my $Self = shift;
    my %Param = @_;

    # check needed stuff
    foreach (qw(ParentID ItemStates)) {
        if (!defined($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return [];
        }
    }

    # add subcategoryids
    my @SubCategoryIDs = @{$Self->CategorySearch(
        ParentID => $Param{ParentID},
        States => $Param{ItemStates},
        Order => 'Created',
        Sort => 'down',
    )};
    foreach my $SubCategoryID (@SubCategoryIDs) {
        my @Temp = @{$Self->CategorySubCategoryIDList(
            ParentID => $SubCategoryID,
            ItemStates => $Param{ItemStates}
        )};
        if(@Temp) {
            push(@SubCategoryIDs, @Temp);
        }
    }
    return \@SubCategoryIDs;
}


=item CategoryAdd()

add a category

  my $ID = $FAQObject->CategoryAdd(
      Name => 'Some Category',
      Comment => 'some comment ...',
  );

=cut

sub CategoryAdd {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ParentID Name)) {
      if (!defined($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(Name Comment)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }
    foreach (qw(ParentID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer') || '';
    }
    my $SQL = "INSERT INTO faq_category (name, parent_id, comments, ".
            " created, created_by, changed, changed_by)".
            " VALUES ".
            " ('$Param{Name}', '$Param{ParentID}', '$Param{Comment}', ".
            " current_timestamp, $Self->{UserID}, ".
            " current_timestamp, $Self->{UserID})";

    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        # get new category id
        $SQL = "SELECT id ".
          " FROM " .
          " faq_category " .
          " WHERE " .
          " name = '$Param{Name}'";
        my $ID = '';
        $Self->{DBObject}->Prepare(SQL => $SQL);
        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
          $ID = $Row[0];
        }
        # log notice
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "FAQCategory: '$Param{Name}' ID: '$ID' created successfully ($Self->{UserID})!",
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
      ID => 1,
      Name => 'Some Category',
      Comment => 'some comment ...',
  );

=cut

sub CategoryUpdate {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(CategoryID ParentID Name)) {
      if (!defined($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(Name Comment)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }
    foreach (qw(CategoryID ParentID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }

    # sql
    my $SQL = "UPDATE faq_category SET ".
          " parent_id = '$Param{ParentID}', ".
          " name = '$Param{Name}', ".
          " comments = '$Param{Comment}', ".
          " changed = current_timestamp, changed_by = $Self->{UserID} ".
          " WHERE id = $Param{CategoryID}";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        # log notice
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "FAQCategory: '$Param{Name}' ID: '$Param{CategoryID}' updated successfully ($Self->{UserID})!",
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
      ID => 1, # or
      Name => 'Some Name',
      ParentID => 1,
  );

=cut

sub CategoryDuplicateCheck {
    my $Self = shift;
    my %Param = @_;

    # db quote
    foreach (qw(Name)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }
    foreach (qw(ID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }

    # sql
    my $SQL = "SELECT id FROM faq_category WHERE ";
    if(defined($Param{Name})) {
        $SQL .= "name = '$Param{Name}' AND parent_id = $Param{ParentID} ";
        if(defined($Param{ID})) {
            $SQL .= "AND id != '$Param{ID}' ";
        }
    }
    $Self->{DBObject}->Prepare(SQL => $SQL);
    if (my @Row = $Self->{DBObject}->FetchrowArray()) {
        return 1;
    }
    return 0;
}


=item CategoryCount()

count an article

  $FAQObject->CategoryCount(
      ParentIDs => [1,2,3,4],
  );

=cut

sub CategoryCount {
    my $Self = shift;
    my %Param = @_;

    # check needed stuff
    foreach (qw(ParentIDs)) {
        if (!defined($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }

    my $SQL = "";
    my $Ext = "";

    $SQL = "SELECT COUNT(*)" .
           " FROM faq_category ";

    if(defined($Param{ParentIDs})) {
        $Ext = " WHERE parent_id IN (";
        foreach my $ParentID (@{$Param{ParentIDs}}) {
            $Ext .= $Self->{DBObject}->Quote($ParentID,'Integer').",";
        }
        $Ext = substr($Ext,0,-1);
        $Ext .= ")";
    }
    $Ext .= " GROUP BY parent_id";

    $SQL .= $Ext;
    $Self->{DBObject}->Prepare(SQL => $SQL, Limit => 200);

    my %Data = ();
    if(my @Row = $Self->{DBObject}->FetchrowArray()) {
        return $Row[0];
    } else {
        return 0;
    }

}


=item StateTypeList()

get the state type list as hash

  my %StateTypes = $FAQObject->StateTypeList();

=cut

sub StateTypeList {
    my $Self = shift;
    my %Param = @_;

    my $SQL = '';
    my $Ext = '';
    $SQL = "SELECT id, name FROM faq_state_type";

    if($Param{Types}) {
        my @States = @{$Param{Types}};
        $Ext = " WHERE";
        foreach my $State (@States) {
            $Ext .= " name LIKE '".$Self->{DBObject}->Quote($State)."' OR";
        }
        $Ext = substr($Ext,0,-3);
    }
    $SQL .= $Ext;

    # sql
    my %List = ();
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while  (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $List{$Row[0]} = $Row[1];
    }
    return \%List;
}

=item StateList()

get the state list as hash

  my %States = $FAQObject->StateList();

=cut

sub StateList {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw()) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # sql
    my %List = ();
    $Self->{DBObject}->Prepare(SQL => 'SELECT id, name FROM faq_state');
    while  (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $List{$Row[0]} = $Row[1];
    }
    return %List;
}

=item StateUpdate()

update a state

  $FAQObject->StateUpdate(
      ID => 1,
      Name => 'public',
      TypeID => 1,
  );

=cut

sub StateUpdate {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ID Name TypeID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(Name)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }
    foreach (qw(ID TypeID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql
    my $SQL = "UPDATE faq_state SET name = '$Param{Name}', type_id = $Param{TypeID}, ".
          " WHERE id = $Param{ID}";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        return 1;
    }
    else {
        return;
    }
}

=item StateAdd()

add a state

  my $ID = $FAQObject->StateAdd(
      ID => 1,
      Name => 'public',
      TypeID => 1,
  );

=cut

sub StateAdd {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Name TypeID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(Name)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }
    foreach (qw(TypeID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    my $SQL = "INSERT INTO faq_state (name, type_id) ".
            " VALUES ".
            " ('$Param{Name}', $Param{TypeID}) ";

    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        return 1;
    }
    else {
        return;
    }
}

=item StateGet()

get a state as hash

  my %State = $FAQObject->StateGet(
      ID => 1,
  );

=cut

sub StateGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(ID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql
    my %Data = ();
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id, name FROM faq_state WHERE id = $Param{ID}",
    );
    while  (my @Row = $Self->{DBObject}->FetchrowArray()) {
        %Data = (
            ID => $Row[0],
            Name => $Row[1],
            Comment => $Row[2],
        );
    }
    return %Data;
}


=item StateTypeGet()

get a state as hash

  my %State = $FAQObject->StateGet(
      ID => 1, # or
      Name => 'internal',
  );

=cut

sub StateTypeGet {
    my $Self = shift;
    my %Param = @_;

    my $SQL = "";
    my $Ext = "";

    $SQL = "SELECT id, name ".
           " FROM faq_state_type WHERE";

    if(defined($Param{ID})) {
        $Ext .= " id = ".$Self->{DBObject}->Quote($Param{ID}, 'Integer')
    }
    elsif(defined($Param{Name})) {
        $Ext .= " name LIKE '".$Self->{DBObject}->Quote($Param{Name})."'"
    }
    $SQL .= $Ext;
    # sql
    my %Data = ();
    $Self->{DBObject}->Prepare(
        SQL => $SQL,
    );
    while  (my @Row = $Self->{DBObject}->FetchrowArray()) {
        %Data = (
            ID => $Row[0],
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
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw()) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # sql
    my %List = ();
    $Self->{DBObject}->Prepare(SQL => 'SELECT id, name FROM faq_language');
    while  (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $List{$Row[0]} = $Row[1];
    }
    return %List;
}

=item LanguageUpdate()

update a language

  $FAQObject->LanguageUpdate(
      ID => 1,
      Name => 'Some Category',
  );

=cut

sub LanguageUpdate {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ID Name)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(Name)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }
    foreach (qw(ID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql
    my $SQL = "UPDATE faq_language SET name = '$Param{Name}' ".
          " WHERE id = $Param{ID}";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        return 1;
    }
    else {
        return;
    }
}


=item LanguageDuplicateCheck()

check a language

  $FAQObject->LanguageDuplicateCheck(
      Name => 'Some Name',
      ID => 1, # for update
  );

=cut

sub LanguageDuplicateCheck {
    my $Self = shift;
    my %Param = @_;

    # db quote
    foreach (qw(Name)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }
    foreach (qw(ID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }

    # sql
    my $SQL = "SELECT id FROM faq_language WHERE ";
    if(defined($Param{Name})) {
        $SQL .= "name = '$Param{Name}' ";
    }
    if(defined($Param{ID})) {
        $SQL .= "AND id != '$Param{ID}' ";
    }
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        return 1;
    }
    return 0;
}

=item LanguageAdd()

add a language

  my $ID = $FAQObject->LanguageAdd(
      Name => 'Some Category',
  );

=cut

sub LanguageAdd {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Name)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(Name)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }
    my $SQL = "INSERT INTO faq_language (name) ".
            " VALUES ".
            " ('$Param{Name}') ";

    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        return 1;
    }
    else {
        return;
    }
}

=item LanguageGet()

get a language as hash

  my %Language = $FAQObject->LanguageGet(
      ID => 1,
  );

=cut

sub LanguageGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(ID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql
    my %Data = ();
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id, name FROM faq_language WHERE id = $Param{ID}",
    );
    while  (my @Row = $Self->{DBObject}->FetchrowArray()) {
        %Data = (
            ID => $Row[0],
            Name => $Row[1],
        );
    }
    return %Data;
}

=item FAQSearch()

search in articles

  my @IDs = $FAQObject->FAQSearch(
      Number => '*134*',
      What => '*some text*',
      Keywords => '*webserver*',
      States = ['public', 'internal'],
      Order => 'changed'
      Sort => 'ASC'
      Limit => 150,
  );

=cut

sub FAQSearch {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw()) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }

    # sql
    my $SQL = "SELECT i.id, count( v.item_id ) votes, avg( v.rate ) result".
        " FROM faq_item i ".
        " LEFT JOIN faq_voting v ON v.item_id = i.id".
        " LEFT JOIN faq_state s ON s.id = i.state_id".
        " WHERE";
    my $Ext = '';
    foreach (qw(f_subject f_field1 f_field2 f_field3 f_field4 f_field5 f_field6)) {
        if ($Ext) {
            $Ext .= ' OR ';
        }
        else {
            $Ext .= ' (';
        }
        if ($Param{What}) {
            my @List = split(/;/, $Param{What});
            my $What = '';
            foreach my $Value (@List) {
                if ($What) {
                    $What .= ' OR ';
                }
                $What .= " LOWER(i.$_) LIKE LOWER('%".$Self->{DBObject}->Quote($Value)."%')";
            }
            $Ext .= $What;
        }
        else {
            $Ext .= " LOWER(i.$_) LIKE LOWER('%')";
        }
    }
    $Ext .= ' )';
    if ($Param{Number}) {
        $Param{Number} =~ s/\*/%/g;
        $Ext .= " AND LOWER(i.f_number) LIKE LOWER('".$Self->{DBObject}->Quote($Param{Number})."')";
    }
    if ($Param{Title}) {
        $Ext .= " AND LOWER(i.f_subject) LIKE LOWER('%".$Self->{DBObject}->Quote($Param{Title})."%')";
    }
    if ($Param{LanguageIDs} && ref($Param{LanguageIDs}) eq 'ARRAY' && @{$Param{LanguageIDs}}) {
        $Ext .= " AND i.f_language_id IN (";
        foreach my $LanguageID (@{$Param{LanguageIDs}}) {
            $Ext .= $Self->{DBObject}->Quote($LanguageID, 'Integer').",";
        }
        $Ext = substr($Ext,0,-1);
        $Ext .= ")";
    }
    if ($Param{CategoryIDs} && ref($Param{CategoryIDs}) eq 'ARRAY' && @{$Param{CategoryIDs}}) {
        $Ext .= " AND (i.category_id IN  (";
        my $Counter=0;
        foreach my $CategoryID (@{$Param{CategoryIDs}}) {
            $Ext .= $Self->{DBObject}->Quote($CategoryID, 'Integer').",";
            $Counter++;
            if(!($Counter%500)) {
                $Ext = substr($Ext,0,-1);
                $Ext .= ")";
                $Ext .= " OR i.category_id IN  (";
            }
        }
        $Ext = substr($Ext,0,-1);
        $Ext .= "))";
    }
    if ($Param{States} && ref($Param{States}) eq 'HASH' && %{$Param{States}}) {
        $Ext .= " AND s.type_id IN (";
        foreach my $StateID (keys(%{$Param{States}})) {
            $Ext .= $Self->{DBObject}->Quote($StateID, 'Integer').",";
        }
        $Ext = substr($Ext,0,-1);
        $Ext .= ")";
    }
    if ($Param{Keyword}) {
        $Ext .= " AND LOWER(i.f_keywords) LIKE LOWER('%".$Self->{DBObject}->Quote($Param{Keyword})."%')";
    }
    $Ext .= " GROUP BY i.id, i.f_subject, i.f_language_id, i.created, i.changed, s.name, v.item_id";
    if ($Param{Order}) {
        $Ext .= " ORDER BY ";

        # title
        if ($Param{Order} eq 'Title') {
            $Ext .= "i.f_subject";
        }
        # language
        elsif ($Param{Order} eq 'Language') {
            $Ext .= "i.f_language_id";
        }
        # state
        elsif ($Param{Order} eq 'State') {
            $Ext .= "s.name";
        }
        # votes
        elsif ($Param{Order} eq 'Votes') {
            $Ext .= "votes";
        }
        # rates
        elsif ($Param{Order} eq 'Result') {
            $Ext .= "result";
        }
        # changed
        elsif ($Param{Order} eq 'Created') {
            $Ext .= "i.changed";
        }
        # created
        elsif ($Param{Order} eq 'Changed') {
            $Ext .= "i.created";
        }


        if ($Param{Sort}) {
            if ($Param{Sort} eq 'up') {
                $Ext .= " ASC";
            }
            elsif ($Param{Sort} eq 'down') {
                $Ext .= " DESC";
            }
        }
    }
    $SQL .= $Ext;
    #$Self->{LogObject}->Log(Priority => 'error', Message => $SQL);
    my @List = ();
    $Self->{DBObject}->Prepare(SQL => $SQL, Limit => $Param{Limit} || 500);
    while  (my @Row = $Self->{DBObject}->FetchrowArray()) {
        push (@List, $Row[0]);
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
    my $Self = shift;
    my %Param = @_;

    my @CategoryList = ();
    my $TempCategoryID = $Param{CategoryID};
    while($TempCategoryID) {
        my %Data = $Self->CategoryGet(CategoryID => $TempCategoryID);
        if(%Data) {
            $CategoryList[$#CategoryList+1] = \%Data;
        }
        $TempCategoryID = $Data{ParentID};
    }
    @CategoryList = reverse(@CategoryList);

    return \@CategoryList;

}


1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=cut

=head1 VERSION

$Revision: 1.3 $ $Date: 2006-10-04 09:14:49 $

=cut
