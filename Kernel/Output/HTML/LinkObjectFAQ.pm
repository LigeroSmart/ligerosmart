# --
# Kernel/Output/HTML/LinkObjectFAQ.pm - layout backend module
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: LinkObjectFAQ.pm,v 1.7 2008-08-29 15:40:47 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Output::HTML::LinkObjectFAQ;

use strict;
use warnings;

use Kernel::Output::HTML::Layout;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.7 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (
        qw(ConfigObject LogObject MainObject DBObject UserObject EncodeObject
        QueueObject GroupObject ParamObject TimeObject LanguageObject UserLanguage UserID)
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    $Self->{LayoutObject} = Kernel::Output::HTML::Layout->new( %{$Self} );

    # define needed variables
    $Self->{ObjectData} = {
        Object   => 'FAQ',
        Realname => 'FAQ',
    };

    return $Self;
}

sub TableCreateComplex {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ObjectLinkListWithData} || ref $Param{ObjectLinkListWithData} ne 'HASH' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need ObjectLinkListWithData!',
        );
        return;
    }

    # convert the list
    my %LinkList;
    for my $LinkType ( keys %{ $Param{ObjectLinkListWithData} } ) {

        # extract link type List
        my $LinkTypeList = $Param{ObjectLinkListWithData}->{$LinkType};

        for my $Direction ( keys %{$LinkTypeList} ) {

            # extract direction list
            my $DirectionList = $Param{ObjectLinkListWithData}->{$LinkType}->{$Direction};

            for my $FAQID ( keys %{$DirectionList} ) {

                $LinkList{$FAQID}->{Data} = $DirectionList->{$FAQID};
            }
        }
    }

    # create the item list
    my @ItemList;
    for my $FAQID ( sort { $a <=> $b } keys %LinkList ) {

        # extract faq data
        my $FAQ = $LinkList{$FAQID}->{Data};

        my @ItemColumns = (
            {
                Type    => 'Link',
                Key     => $FAQID,
                Content => $FAQ->{Number},
                Link    => '$Env{"Baselink"}Action=AgentFAQ&ItemID=' . $FAQID,
            },
            {
                Type      => 'Text',
                Content   => $FAQ->{Title},
                MaxLength => 50,
            },
            {
                Type      => 'Text',
                Content   => $FAQ->{State},
                Translate => 1,
            },
            {
                Type    => 'TimeLong',
                Content => $FAQ->{Created},
            },
        );

        push @ItemList, \@ItemColumns;
    }

    return if !@ItemList;

    # define the block data
    my $FAQHook = $Self->{ConfigObject}->Get('FAQ::FAQHook');
    my %Block   = (
        Object    => $Self->{ObjectData}->{Object},
        Blockname => $Self->{ObjectData}->{Realname},
        Headline  => [
            {
                Content => $FAQHook,
                Width   => 130,
            },
            {
                Content => 'Title',
            },
            {
                Content => 'State',
                Width   => 110,
            },
            {
                Content => 'Created',
                Width   => 130,
            },
        ],
        ItemList => \@ItemList,
    );

    return ( \%Block );
}

sub TableCreateSimple {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ObjectLinkListWithData} || ref $Param{ObjectLinkListWithData} ne 'HASH' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need ObjectLinkListWithData!',
        );
        return;
    }

    my $FAQHook = $Self->{ConfigObject}->Get('FAQ::FAQHook');
    my %LinkOutputData;
    for my $LinkType ( keys %{ $Param{ObjectLinkListWithData} } ) {

        # extract link type List
        my $LinkTypeList = $Param{ObjectLinkListWithData}->{$LinkType};

        for my $Direction ( keys %{$LinkTypeList} ) {

            # extract direction list
            my $DirectionList = $Param{ObjectLinkListWithData}->{$LinkType}->{$Direction};

            my @ItemList;
            for my $FAQID ( sort { $a <=> $b } keys %{$DirectionList} ) {

                # extract tickt data
                my $FAQ = $DirectionList->{$FAQID};

                # define item data
                my %Item = (
                    Type    => 'Link',
                    Content => 'F:' . $FAQ->{Number},
                    Title   => "$FAQHook$FAQ->{Number}: $FAQ->{Title}",
                    Link    => '$Env{"Baselink"}Action=AgentFAQ&ItemID=' . $FAQID,
                );
                push @ItemList, \%Item;
            }

            # add item list to link output data
            $LinkOutputData{ $LinkType . '::' . $Direction }->{FAQ} = \@ItemList;
        }
    }

    return %LinkOutputData;
}

sub ContentStringCreate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ContentData} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need ContentData!' );
        return;
    }

    return;
}

sub SelectableObjectList {
    my ( $Self, %Param ) = @_;

    my $Selected;
    if ( $Param{Selected} && $Param{Selected} eq $Self->{ObjectData}->{Object} ) {
        $Selected = 1;
    }

    # object select list
    my @ObjectSelectList = (
        {
            Key      => $Self->{ObjectData}->{Object},
            Value    => $Self->{ObjectData}->{Realname},
            Selected => $Selected,
        },
    );

    return @ObjectSelectList;
}

sub SearchOptionList {
    my ( $Self, %Param ) = @_;

    # search option list
    my $FAQHook          = $Self->{ConfigObject}->Get('FAQ::FAQHook');
    my @SearchOptionList = (
        {
            Key  => 'Number',
            Name => $FAQHook,
            Type => 'Text',
        },
        {
            Key  => 'Title',
            Name => 'Title',
            Type => 'Text',
        },
        {
            Key  => 'What',
            Name => 'Fulltext',
            Type => 'Text',
        },
    );

    # add formkey
    for my $Row (@SearchOptionList) {
        $Row->{FormKey} = 'SEARCH::' . $Row->{Key};
    }

    # add form data and input string
    ROW:
    for my $Row (@SearchOptionList) {

        # prepare text input fields
        if ( $Row->{Type} eq 'Text' ) {

            # get form data
            $Row->{FormData} = $Self->{ParamObject}->GetParam( Param => $Row->{FormKey} );

            # parse the input text block
            $Self->{LayoutObject}->Block(
                Name => 'InputText',
                Data => {
                    Key => $Row->{FormKey},
                    Value => $Row->{FormData} || '',
                },
            );

            # add the input string
            $Row->{InputStrg} = $Self->{LayoutObject}->Output(
                TemplateFile => 'LinkObject',
            );

            next ROW;
        }

        # prepare list boxes
        if ( $Row->{Type} eq 'List' ) {

            # get form data
            my @FormData = $Self->{ParamObject}->GetArray( Param => $Row->{FormKey} );
            $Row->{FormData} = \@FormData;

            my %ListData;
            if ( $Row->{Key} eq 'StateIDs' ) {

                # get state list
                %ListData = $Self->{StateObject}->StateList(
                    UserID => $Self->{UserID},
                );
            }

            # add the input string
            $Row->{InputStrg} = $Self->{LayoutObject}->BuildSelection(
                Data       => \%ListData,
                Name       => $Row->{FormKey},
                SelectedID => $Row->{FormData},
                Size       => 3,
                Multiple   => 1,
            );

            next ROW;
        }
    }

    return @SearchOptionList;
}

1;
