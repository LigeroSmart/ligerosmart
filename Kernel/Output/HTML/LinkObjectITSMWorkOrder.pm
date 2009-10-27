# --
# Kernel/Output/HTML/LinkObjectITSMWorkOrder.pm - layout backend module
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: LinkObjectITSMWorkOrder.pm,v 1.12 2009-10-27 20:19:49 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::LinkObjectITSMWorkOrder;

use strict;
use warnings;

use Kernel::Output::HTML::Layout;
use Kernel::System::GeneralCatalog;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.12 $) [1];

=head1 NAME

Kernel::Output::HTML::LinkObjectITSMWorkOrder - layout backend module

=head1 SYNOPSIS

All layout functions of link object (workorder)

=over 4

=cut

=item new()

create an object

    $BackendObject = Kernel::Output::HTML::LinkObjectITSMWorkOrder->new(
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
        qw(ConfigObject LogObject MainObject DBObject UserObject EncodeObject
        QueueObject GroupObject ParamObject TimeObject LanguageObject UserLanguage UserID)
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    # create additional objects
    $Self->{LayoutObject}         = Kernel::Output::HTML::Layout->new( %{$Self} );
    $Self->{GeneralCatalogObject} = Kernel::System::GeneralCatalog->new( %{$Self} );

    # define needed variables
    $Self->{ObjectData} = {
        Object   => 'ITSMWorkOrder',
        Realname => 'WorkOrder',
    };

    return $Self;
}

#
# TODO: Update POD when table layout is final
#

=item TableCreateComplex()

return an array with the block data

Return

    @BlockData = (
        Object    => 'ITSMWorkOrder',
        Blockname => 'WorkOrder',
        Headline  => [
            {
                Content => '',
                Width   => 20,
            },
            {
                Content => 'Change#',
            },
            {
                Content => 'Change Title',
            },
            {
                Content => 'WorkOrder#',
                Width   => 5,
            },
            {
                Content => 'WorkOrder Title',
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
                    Type    => 'WorkOrderStateSignal',
                    Key     => 2,
                    Content => 'in progress',
                },
                {
                    Type    => 'Text',
                    Content => '2009100112345778',
                },
                {
                    Type      => 'Text',
                    Content   => 'Change Title',
                    MaxLength => 70,
                },
                {
                    Type    => 'Text',
                    Content => '5',
                },
                {
                    Type      => 'Link',
                    Content   => 'WorkOrder Title',
                    Link      => 'Action=AgentITSMWorkOrderZoom&WorkOrderID=123',
                    MaxLength => 70,
                },
                {
                    Type    => 'TimeLong',
                    Content => '2008-01-01 12:12:00',
                },
            ],
            [
                {
                    Type    => 'WorkOrderStateSignal',
                    Key     => 3,
                    Content => 'ready',
                },
                {
                    Type    => 'Text',
                    Content => '2009100112354321',
                },
                {
                    Type      => 'Text',
                    Content   => 'Change Title',
                    MaxLength => 70,
                },
                {
                    Type    => 'Text',
                    Content => '6',
                },
                {
                    Type      => 'Link',
                    Content   => 'WorkOrder Title',
                    Link      => 'Action=AgentITSMWorkOrderZoom&WorkOrderID=321',
                    MaxLength => 70,
                },
                {
                    Type    => 'TimeLong',
                    Content => '2008-03-03 13:13:00',
                },
            ],
        ],
    );

    @BlockData = $LinkObject->TableCreateComplex(
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

            for my $WorkOrderID ( keys %{$DirectionList} ) {

                $LinkList{$WorkOrderID}->{Data} = $DirectionList->{$WorkOrderID};
            }
        }
    }

    # create the item list, sort by ChangeID Down, then by WorkOrderID Up
    my @ItemList;
    for my $WorkOrderID (
        sort {
            $LinkList{$b}{Data}->{ChangeID} <=> $LinkList{$a}{Data}->{ChangeID}
                || $a <=> $b
        } keys %LinkList
        )
    {

        # extract workorder data
        my $WorkOrder = $LinkList{$WorkOrderID}{Data};

        my @ItemColumns = (
            {
                Type           => 'WorkOrderStateSignal',
                Key            => $WorkOrderID,
                Content        => $WorkOrder->{WorkOrderStateSignal},
                WorkOrderState => $WorkOrder->{WorkOrderState},
            },
            {
                Type    => 'Link',
                Content => $WorkOrder->{ChangeData}->{ChangeNumber}
                    . '-' . $WorkOrder->{WorkOrderNumber},
                Link => '$Env{"Baselink"}Action=AgentITSMWorkOrderZoom&WorkOrderID=' . $WorkOrderID,
            },
            {
                Type      => 'Text',
                Content   => $WorkOrder->{WorkOrderTitle},
                MaxLength => 70,
            },
            {
                Type      => 'Text',
                Content   => $WorkOrder->{ChangeData}->{ChangeTitle},
                MaxLength => 70,
            },
            {
                Type    => 'Text',
                Content => $WorkOrder->{WorkOrderState},
            },

            #            {
            #                Type    => 'TimeLong',
            #                Content => $WorkOrder->{ChangeTime},
            #            },
        );

        push @ItemList, \@ItemColumns;
    }

    return if !@ItemList;

    # define the block data
    my %Block = (
        Object    => $Self->{ObjectData}->{Object},
        Blockname => $Self->{ObjectData}->{Realname},
        Headline  => [
            {
                Content => '',
                Width   => 20,
            },
            {
                Content => 'WorkOrder#',
                Width   => 200,
            },
            {
                Content => 'WorkOrder Title',
                Width   => 200,
            },
            {
                Content => 'Change Title',
                Width   => 200,
            },
            {
                Content => 'WorkOrderState',
                Width   => 200,
            },

            #            {
            #                Content => 'Changed',
            #                Width   => 150,
            #            },
        ],
        ItemList => \@ItemList,
    );

    return ( \%Block );
}

=item TableCreateSimple()

return a hash with the link output data

Return

    %LinkOutputData = (
        Normal::Source => {
            ITSMWorkOrder => [
                {
                    Type    => 'Link',
                    Content => 'WO:2009100112354321-1',
                    Title   => 'Change# 2009101610005402 - WorkOrder# 1: The WorkOrder Title',
                    Css     => 'style="text-decoration: line-through"',
                },
                {
                    Type    => 'Link',
                    Content => 'WO:2009100112354321-6',
                    Title   => 'Change# 2009101610007634 - WorkOrder# 6: The WorkOrder Title',
                },
            ],
        },
        ParentChild::Target => {
            ITSMWorkOrder => [
                {
                    Type    => 'Link',
                    Content => 'WO:2009100112354321-3',
                    Title   => 'Change# 20091016100044331 - WorkOrder# 3: The WorkOrder Title',
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

            # create the item list, sort by ChangeID Down, then by WorkOrderNumber Up
            my @ItemList;
            for my $WorkOrderID (
                sort {
                    $DirectionList->{$b}->{ChangeID} <=> $DirectionList->{$a}->{ChangeID}
                        || $a <=> $b
                } keys %{$DirectionList}
                )
            {

                # extract workorder data
                my $WorkOrder = $DirectionList->{$WorkOrderID};

                # define item data
                my %Item = (
                    Type    => 'Link',
                    Content => 'WO:' . $WorkOrder->{ChangeData}->{ChangeNumber} . '-'
                        . $WorkOrder->{WorkOrderNumber},
                    Title => 'Change# ' . $WorkOrder->{ChangeData}->{ChangeNumber} . '-'
                        . 'WorkOrder# '
                        . $WorkOrder->{WorkOrderNumber} . ': '
                        . $WorkOrder->{WorkOrderTitle},
                    Link => '$Env{"Baselink"}Action=AgentITSMWorkOrderZoom&WorkOrderID='
                        . $WorkOrderID,
                    MaxLength => 20,
                );

                push @ItemList, \%Item;
            }

            # add item list to link output data
            $LinkOutputData{ $LinkType . '::' . $Direction }->{ITSMWorkOrder} = \@ItemList;
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

    # extract content
    my $Content = $Param{ContentData};

    return if $Content->{Type} ne 'WorkOrderStateSignal';

    # build html for signal LED
    my $String = $Self->{LayoutObject}->Output(
        Template => '<img border="0" src="$Env{"Images"}$QData{"WorkOrderStateSignal"}.png" '
            . 'title="$Text{"$QData{"WorkOrderState"}"}" alt="$Text{"$QData{"WorkOrderState"}"}">',
        Data => {
            WorkOrderStateSignal => $Content->{Content},
            WorkOrderState => $Content->{WorkOrderState} || '',
        },
    );

    return $String;
}

=item SelectableObjectList()

return an array hash with selectable objects

Return

    @SelectableObjectList = (
        {
            Key   => 'ITSMWorkOrder',
            Value => 'WorkOrder',
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
            Key       => 'WorkOrderNumber',
            Name      => 'WorkOrder#',
            InputStrg => $FormString,
            FormData  => '12',
        },
        {
            Key       => 'WorkOrderTitle',
            Name      => 'WorkOrder Title',
            InputStrg => $FormString,
            FormData  => 'MailServer needs update',
        },
    );

    @SearchOptionList = $LinkObject->SearchOptionList();

=cut

sub SearchOptionList {
    my ( $Self, %Param ) = @_;

    # search option list
    my @SearchOptionList = (
        {
            Key  => 'ChangeNumber',
            Name => 'Change#',
            Type => 'Text',
        },
        {
            Key  => 'ChangeTitle',
            Name => 'Change Title',
            Type => 'Text',
        },
        {
            Key  => 'WorkOrderNumber',
            Name => 'WorkOrder#',
            Type => 'Text',
        },
        {
            Key  => 'WorkOrderTitle',
            Name => 'WorkOrder Title',
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
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see http://www.gnu.org/licenses/agpl.txt.

=cut

=head1 VERSION

$Revision: 1.12 $ $Date: 2009-10-27 20:19:49 $

=cut
