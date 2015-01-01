# --
# Kernel/Output/HTML/LinkObjectFAQ.pm - layout backend module
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::LinkObjectFAQ;

use strict;
use warnings;

use Kernel::Output::HTML::Layout;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::Web::Request',
);

=head1 NAME

Kernel::Output::HTML::LinkObjectFAQ - layout backend module

=head1 SYNOPSIS

All layout functions of link object (FAQ)

=over 4

=cut

=item new()

create an object

    $BackendObject = Kernel::Output::HTML::LinkObjectFAQ->new(
        %Param,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (qw(UserLanguage UserID)) {
        $Self->{$Needed} = $Param{$Needed} || die "Got no $Needed!";
    }

    # get needed objects
    $Self->{ConfigObject} = $Kernel::OM->Get('Kernel::Config');
    $Self->{LogObject}    = $Kernel::OM->Get('Kernel::System::Log');
    $Self->{ParamObject}  = $Kernel::OM->Get('Kernel::System::Web::Request');

    # We need our own LayoutObject instance to avoid blockdata collisions
    #   with the main page.
    $Self->{LayoutObject} = Kernel::Output::HTML::Layout->new( %{$Self} );

    # define needed variables
    $Self->{ObjectData} = {
        Object   => 'FAQ',
        Realname => 'FAQ',
    };

    return $Self;
}

=item TableCreateComplex()

return an array with the block data

    my @BlockData = $LinkObject->TableCreateComplex(
        ObjectLinkListWithData => $ObjectLinkListRef,
    );

a result could be

    %BlockData = (
        {
            Object    => 'FAQ',
            Blockname => 'FAQ',
            Headline  => [
                {
                    Content => 'FAQ#',
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
                    Width   => 110,
                },
            ],
            ItemList => [
                [
                    {
                        Type    => 'Link',
                        Key     => $FAQID,
                        Content => '123123123',
                        Css     => 'style="text-decoration: line-through"',
                    },
                    {
                        Type      => 'Text',
                        Content   => 'The title',
                        MaxLength => 50,
                    },
                    {
                        Type      => 'Text',
                        Content   => 'internal (agent)',
                        Translate => 1,
                    },
                    {
                        Type    => 'TimeLong',
                        Content => '2008-01-01 12:12:00',
                    },
                ],
                [
                    {
                        Type    => 'Link',
                        Key     => $FAQID,
                        Content => '434234',
                    },
                    {
                        Type      => 'Text',
                        Content   => 'The title of FAQ 2',
                        MaxLength => 50,
                    },
                    {
                        Type      => 'Text',
                        Content   => 'public (all)',
                        Translate => 1,
                    },
                    {
                        Type    => 'TimeLong',
                        Content => '2008-01-01 12:12:00',
                    },
                ],
            ],
        },
    );

=cut

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
    for my $LinkType ( sort keys %{ $Param{ObjectLinkListWithData} } ) {

        # extract link type List
        my $LinkTypeList = $Param{ObjectLinkListWithData}->{$LinkType};

        for my $Direction ( sort keys %{$LinkTypeList} ) {

            # extract direction list
            my $DirectionList = $Param{ObjectLinkListWithData}->{$LinkType}->{$Direction};

            for my $FAQID ( sort keys %{$DirectionList} ) {

                $LinkList{$FAQID}->{Data} = $DirectionList->{$FAQID};
            }
        }
    }

    # create the item list
    my @ItemList;
    for my $FAQID ( sort { $a <=> $b } keys %LinkList ) {

        # extract FAQ data
        my $FAQ = $LinkList{$FAQID}->{Data};

        my @ItemColumns = (
            {
                Type    => 'Link',
                Key     => $FAQID,
                Content => $FAQ->{Number},
                Link    => $Self->{LayoutObject}->{Baselink} . 'Action=AgentFAQZoom;ItemID=' . $FAQID,
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

=item TableCreateSimple()

return a hash with the link output data

    my %LinkOutputData = $LinkObject->TableCreateSimple(
        ObjectLinkListWithData => $ObjectLinkListRef,
    );

a result could be Return

    %LinkOutputData = (
        Normal::Source => {
            Ticket => [
                {
                    Type    => 'Link',
                    Content => 'F:55555',
                    Title   => 'FAQ#555555: The FAQ title',
                },
                {
                    Type    => 'Link',
                    Content => 'F:22222',
                    Title   => 'FAQ#22222: Title of FAQ 22222',
                },
            ],
        },
        ParentChild::Target => {
            Ticket => [
                {
                    Type    => 'Link',
                    Content => 'F:77777',
                    Title   => 'FAQ#77777: FAQ title',
                },
            ],
        },
    );

=cut

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
    for my $LinkType ( sort keys %{ $Param{ObjectLinkListWithData} } ) {

        # extract link type List
        my $LinkTypeList = $Param{ObjectLinkListWithData}->{$LinkType};

        for my $Direction ( sort keys %{$LinkTypeList} ) {

            # extract direction list
            my $DirectionList = $Param{ObjectLinkListWithData}->{$LinkType}->{$Direction};

            my @ItemList;
            for my $FAQID ( sort { $a <=> $b } keys %{$DirectionList} ) {

                # extract FAQ data
                my $FAQ = $DirectionList->{$FAQID};

                # define item data
                my %Item = (
                    Type    => 'Link',
                    Content => 'F:' . $FAQ->{Number},
                    Title   => "$FAQHook$FAQ->{Number}: $FAQ->{Title}",
                    Link    => $Self->{LayoutObject}->{Baselink}
                        . 'Action=AgentFAQZoom;ItemID='
                        . $FAQID,
                );
                push @ItemList, \%Item;
            }

            # add item list to link output data
            $LinkOutputData{ $LinkType . '::' . $Direction }->{FAQ} = \@ItemList;
        }
    }

    return %LinkOutputData;
}

=item ContentStringCreate()

return a output string

    my $String = $LayoutObject->ContentStringCreate(
        ContentData => $HashRef,
    );

=cut

sub ContentStringCreate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ContentData} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need ContentData!',
        );
        return;
    }

    return;
}

=item SelectableObjectList()

return an array hash with selectable objects

    my @SelectableObjectList = $LinkObject->SelectableObjectList(
        Selected => $Identifier,  # (optional)
    );

a result could be

    @SelectableObjectList = (
        {
            Key   => 'FAQ',
            Value => 'FAQ',
        },
    );

=cut

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

=item SearchOptionList()

return an array hash with search options

    my @SearchOptionList = $LinkObject->SearchOptionList(
        SubObject => 'Bla',  # (optional)
    );

a result could be

    @SearchOptionList = (
        {
            Key       => 'Number',
            Name      => 'FAQ#',
            InputStrg => $FormString,
            FormData  => '1234',
        },
        {
            Key       => 'Title',
            Name      => 'Title',
            InputStrg => $FormString,
            FormData  => 'BlaBla',
        },
    );

=cut

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

    # add form key
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
                    Key   => $Row->{FormKey},
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

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
