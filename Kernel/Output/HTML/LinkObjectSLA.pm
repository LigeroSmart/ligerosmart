# --
# Kernel/Output/HTML/LinkObjectSLA.pm - layout backend module
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: LinkObjectSLA.pm,v 1.1 2008-07-02 12:35:24 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Output::HTML::LinkObjectSLA;

use strict;
use warnings;

use Kernel::Output::HTML::Layout;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

=head1 NAME

Kernel::Output::HTML::LinkObjectSLA - layout backend module

=head1 SYNOPSIS

All layout functions of link object (sla)

=over 4

=cut

=item new()

create an object

    $BackendObject = Kernel::Output::HTML::LinkObjectSLA->new(
        %Param,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (
        qw(ConfigObject LogObject MainObject DBObject UserObject EncodeObject QueueObject GroupObject ParamObject TimeObject UserID)
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    $Self->{LayoutObject} = Kernel::Output::HTML::Layout->new( %{$Self} );

    # define needed variables
    $Self->{ObjectData} = {
        Object   => 'SLA',
        Realname => 'SLA',
    };

    return $Self;
}

=item TableCreateComplex()

return a hash with the block data

Return

    %BlockData = (
        Object    => 'SLA',
        Blockname => 'SLA',
        Headline  => [
            {
                Content => 'SLA',
            },
            {
                Content => 'Type',
                Width   => 100,
            },
            {
                Content => 'Changed',
                Width   => 150,
            },
        ],
        ItemList => [
            [
                {
                    Type      => 'Link',
                    Content   => 'SLA Bla',
                    Link      => 'Action=AgentSLAZoom&SLAID=123',
                    MaxLength => 70,
                },
                {
                    Type    => 'Text',
                    Content => 'Other',
                    Translate => 1,
                },
                {
                    Type    => 'TimeLong',
                    Content => '2008-01-01 12:12:00',
                },
            ],
            [
                {
                    Type      => 'Link',
                    Content   => 'SLA Bla',
                    Link      => 'Action=AgentSLAZoom&SLAID=321',
                    MaxLength => 70,
                },
                {
                    Type    => 'Text',
                    Content => 'Other',
                    Translate => 1,
                },
                {
                    Type    => 'TimeLong',
                    Content => '2007-02-02 22:12:00',
                },
            ],
        ],
    );

    %BlockData = $LinkObject->TableCreateComplex(
        ObjectLinkListWithData => $ObjectLinkListRef,
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
    for my $LinkType ( keys %{ $Param{ObjectLinkListWithData} } ) {

        # extract link type List
        my $LinkTypeList = $Param{ObjectLinkListWithData}->{$LinkType};

        for my $Direction ( keys %{$LinkTypeList} ) {

            # extract direction list
            my $DirectionList = $Param{ObjectLinkListWithData}->{$LinkType}->{$Direction};

            for my $SLAID ( keys %{$DirectionList} ) {

                $LinkList{$SLAID}->{Data} = $DirectionList->{$SLAID};
            }
        }
    }

    # create the item list
    my @ItemList;
    for my $SLAID (
        sort { lc $LinkList{$a}{Data}->{Name} cmp lc $LinkList{$b}{Data}->{Name} }
        keys %LinkList
        )
    {

        # extract sla data
        my $SLA = $LinkList{$SLAID}{Data};

        my @ItemColumns = (
            {
                Type      => 'Link',
                Key       => $SLAID,
                Content   => $SLA->{Name},
                Link      => '$Env{"Baselink"}Action=AgentSLAZoom&SLAID=' . $SLAID,
                MaxLength => 70,
            },
            {
                Type    => 'Text',
                Content => $SLA->{Type},
                Translate => 1,
            },
            {
                Type    => 'TimeLong',
                Content => $SLA->{ChangeTime},
            },
        );

        push @ItemList, \@ItemColumns;
    }

    return if !@ItemList;

    # block data
    my %BlockData  = (
        Object    => $Self->{ObjectData}->{Object},
        Blockname => $Self->{ObjectData}->{Realname},
        Headline  => [
            {
                Content => 'SLA',
            },
            {
                Content => 'Type',
                Width   => 100,
            },
            {
                Content => 'Changed',
                Width   => 150,
            },
        ],
        ItemList => \@ItemList,
    );

    return %BlockData;
}

=item TableCreateSimple()

return a hash with the link output data

Return

    %LinkOutputData = (
        Normal::Source => {
            SLA => [
                {
                    Type    => 'Link',
                    Content => 'S:The servic[..]',
                    Title   => 'SLA: The sla name',
                    Css     => 'style="text-decoration: line-through"',
                },
                {
                    Type    => 'Link',
                    Content => 'S:Name of servic[..]',
                    Title   => 'SLA: Name of sla 2',
                },
            ],
        },
        ParentChild::Target => {
            SLA => [
                {
                    Type    => 'Link',
                    Content => 'S:SLA nam[..]',
                    Title   => 'SLA: SLA name',
                },
            ],
        },
    );

    %LinkOutputData = $LinkObject->TableCreateSimple(
        ObjectLinkListWithData => $ObjectLinkListRef,
    );

=cut

sub TableCreateSimple {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ObjectLinkListWithData} || ref $Param{ObjectLinkListWithData} ne 'HASH' ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need ObjectLinkListWithData!' );
        return;
    }

    my %LinkOutputData;
    for my $LinkType ( keys %{ $Param{ObjectLinkListWithData} } ) {

        # extract link type List
        my $LinkTypeList = $Param{ObjectLinkListWithData}->{$LinkType};

        for my $Direction ( keys %{$LinkTypeList} ) {

            # extract direction list
            my $DirectionList = $Param{ObjectLinkListWithData}->{$LinkType}->{$Direction};

            my @ItemList;
            for my $SLAID ( sort { lc $DirectionList->{$a}->{Name} cmp lc $DirectionList->{$b}->{Name} } keys %{$DirectionList} ) {

                # extract sla data
                my $SLA = $DirectionList->{$SLAID};

                # define item data
                my %Item = (
                    Type      => 'Link',
                    Content   => "SLA:$SLA->{Name}",
                    Title     => "SLA: $SLA->{Name}",
                    Link      => '$Env{"Baselink"}Action=AgentSLAZoom&SLAID=' . $SLAID,
                    MaxLength => 20,
                );

                push @ItemList, \%Item;
            }

            # add item list to link output data
            $LinkOutputData{ $LinkType . '::' . $Direction }->{SLA} = \@ItemList;
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
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need ContentData!' );
        return;
    }

    return;
}

=item SelectableObjectList()

return an array hash with selectable objects

Return

    @SelectableObjectList = (
        {
            Key   => 'SLA',
            Value => 'SLA',
        },
    );

    @SelectableObjectList = $LinkObject->SelectableObjectList(
        Selected => $Identifier,  # (optional)
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

Return

    @SearchOptionList = (
        {
            Key       => 'Name',
            Name      => 'SLA',
            InputStrg => $FormString,
            FormData  => 'SLA Name',
        },
    );

    @SearchOptionList = $LinkObject->SearchOptionList();

=cut

sub SearchOptionList {
    my ( $Self, %Param ) = @_;

    # search option list
    my @SearchOptionList = (
        {
            Key  => 'Name',
            Name => 'SLA',
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

    return @SearchOptionList;
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

$Revision: 1.1 $ $Date: 2008-07-02 12:35:24 $

=cut
