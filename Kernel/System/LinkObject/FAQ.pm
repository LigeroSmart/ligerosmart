# --
# Kernel/System/LinkObject/FAQ.pm - to link faq objects
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: FAQ.pm,v 1.5 2008-06-13 12:24:53 rk Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::LinkObject::FAQ;

use strict;
use warnings;

use Kernel::System::FAQ;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.5 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(DBObject ConfigObject LogObject MainObject TimeObject LinkObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    $Self->{UserID} = 1;
    $Self->{FAQObject} = Kernel::System::FAQ->new( %{$Self} );

    return $Self;
}

=item PossibleObjectsSelectList()

return an array hash with selectable objects

Return
    @ObjectSelectList = (
        {
            Key   => 'FAQ',
            Value => 'FAQ',
        },
    );

    @ObjectSelectList = $LinkObject->PossibleObjectsSelectList();

=cut

sub PossibleObjectsSelectList {
    my $Self = shift;

    # get object description
    my %ObjectDescription = $Self->ObjectDescriptionGet(
        UserID => 1,
    );

    # object select list
    my @ObjectSelectList = (
        {
            Key   => $ObjectDescription{Object},
            Value => $ObjectDescription{Realname},
        },
    );

    return @ObjectSelectList;
}

=item ObjectDescriptionGet()

return a hash of object description data

    %ObjectDescription = $LinkObject->ObjectDescriptionGet(
        UserID => 1,
    );

=cut

sub ObjectDescriptionGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );
        return;
    }

    # define object description
    my %ObjectDescription = (
        Object   => 'FAQ',
        Realname => 'FAQ',
        Overview => {
            Normal => {
                Key     => 'Number',
                Value   => 'FAQ#',
                Type    => 'Link',
                Subtype => 'Compact',
            },
            Complex => [
                {
                    Key   => 'Number',
                    Value => 'FAQ#',
                    Type  => 'Link',
                },
                {
                    Key   => 'Title',
                    Value => 'Title',
                    Type  => 'Text',
                },
                {
                    Key   => 'LinkType',
                    Value => 'Already linked as',
                    Type  => 'LinkType',
                },
            ],
        },
    );

    return %ObjectDescription;
}

=item ObjectSearchOptionsGet()

return an array hash list with search options

    @SearchOptions = $LinkObject->ObjectSearchOptionsGet();

=cut

sub ObjectSearchOptionsGet {
    my ( $Self, %Param ) = @_;

    # define search params
    my @SearchOptions = (
        {
            Key   => 'Number',
            Value => 'FAQ#',
        },
        {
            Key   => 'Title',
            Value => 'Title',
        },
        {
            Key   => 'What',
            Value => 'Fulltext',
        },
    );

    return @SearchOptions;
}

=item ItemDescriptionGet()

return a hash of item description data

    %ItemDescription = $BackendObject->ItemDescriptionGet(
        Key    => '123',
        UserID => 1,
    );

=cut

sub ItemDescriptionGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Key UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get faq
    my %FAQ = $Self->{FAQObject}->FAQGet(
        ItemID => $Param{Key},
    );

    return if !%FAQ;

    # lookup the valid state id
    my $ValidStateID = $Self->{LinkObject}->StateLookup(
        Name   => 'Valid',
        UserID => 1,
    );

    # get link data
    my $ExistingLinks = $Self->{LinkObject}->LinksGet(
        Object  => 'FAQ',
        Key     => $Param{Key},
        StateID => $Param{StateID} || $ValidStateID,
        UserID  => 1,
    ) || {};

    $FAQ{Number} ||= '';
    $FAQ{Title} ||= '';

    # define item description
    my %ItemDescription = (
        Identifier  => 'FAQ',
        Description => {
            Short  => "F:$FAQ{Number}",
            Normal => "FAQ# $FAQ{Number}",
            Long   => "FAQ# $FAQ{Number}: $FAQ{Title}",
        },
        ItemData => {
            %FAQ,
        },
        LinkData => {
            %{$ExistingLinks},
        },
    );

    return %ItemDescription;
}

=item ItemSearch()

return an array list of the search results

    @ItemKeys = $LinkObject->ItemSearch(
        SearchParams => $HashRef,  # (optional)
    );

=cut

sub ItemSearch {
    my ( $Self, %Param ) = @_;

    # set default params
    $Param{SearchParams} ||= {};

    # set focus
    if ( $Param{SearchParams}->{Title} ) {
        $Param{SearchParams}->{Title} = '*' . $Param{SearchParams}->{Title} . '*';
    }
    if ( $Param{SearchParams}->{Number} ) {
        $Param{SearchParams}->{Number} = '*' . $Param{SearchParams}->{Number} . '*';
    }

    if ( $Param{SearchParams}->{Fulltext} ) {
        $Param{SearchParams}->{Fulltext} = '*' . $Param{SearchParams}->{Fulltext} . '*';
    }

    # search the faqs
    my @ItemKeys = $Self->{FAQObject}->FAQSearch(
        %{ $Param{SearchParams} },
        States  => ['public', 'internal'],
        Order   => 'Created',
        Sort    => 'down',
        Limit   => 1000,
    );
    return @ItemKeys;
}

1;
