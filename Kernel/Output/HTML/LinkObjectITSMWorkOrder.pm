# --
# Kernel/Output/HTML/LinkObjectITSMWorkOrder.pm - layout backend module
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
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
        Realname => 'Workorder',
    };

    # get config
    $Self->{ChangeHook}    = $Self->{ConfigObject}->Get('ITSMChange::Hook');
    $Self->{WorkOrderHook} = $Self->{ConfigObject}->Get('ITSMWorkOrder::Hook');

    return $Self;
}

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
                Content => 'Workorder#',
                Width   => 200,
            },
            {
                Content => 'Workorder Title',
                Width   => 200,
            },
            {
                Content => 'Change Title',
                Width   => 200,
            },
            {
                Content => 'Workorder State',
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
                    Type           => 'WorkOrderStateSignal',
                    Key            => 2,
                    Content        => 'greenled',
                    WorkOrderState => 'ready',
                },
                {
                    Type    => 'Link',
                    Content => '2009100112345778-3',
                    Link    => 'Action=AgentITSMWorkOrderZoom;WorkOrderID=2',
                },
                {
                    Type      => 'Text',
                    Content   => 'Workorder Title',
                    MaxLength => 70,
                },
                {
                    Type      => 'Text',
                    Content   => 'Change Title',
                    MaxLength => 70,
                },
                {
                    Type    => 'Text',
                    Content => 'ready',
                },
                {
                    Type    => 'TimeLong',
                    Content => '2009-01-01 12:12:00',
                },
            ],
            [
                {
                    Type           => 'WorkOrderStateSignal',
                    Key            => 4,
                    Content        => 'redled',
                    WorkOrderState => 'canceld',
                },
                {
                    Type    => 'Link',
                    Content => '2009100112345778-4',
                    Link    => 'Action=AgentITSMWorkOrderZoom;WorkOrderID=4',
                },
                {
                    Type      => 'Text',
                    Content   => 'Workorder Title',
                    MaxLength => 70,
                },
                {
                    Type      => 'Text',
                    Content   => 'Change Title',
                    MaxLength => 70,
                },
                {
                    Type    => 'Text',
                    Content => 'accepted',
                },
                {
                    Type    => 'TimeLong',
                    Content => '2009-02-02 13:13:00',
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
    for my $LinkType ( sort keys %{ $Param{ObjectLinkListWithData} } ) {

        # extract link type List
        my $LinkTypeList = $Param{ObjectLinkListWithData}->{$LinkType};

        for my $Direction ( sort keys %{$LinkTypeList} ) {

            # extract direction list
            my $DirectionList = $Param{ObjectLinkListWithData}->{$LinkType}->{$Direction};

            for my $WorkOrderID ( sort keys %{$DirectionList} ) {

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
                Link => '$Env{"Baselink"}Action=AgentITSMWorkOrderZoom;WorkOrderID=' . $WorkOrderID,
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
            {
                Type    => 'TimeLong',
                Content => $WorkOrder->{ChangeTime},
            },
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
                Content => $Self->{WorkOrderHook},
                Width   => 200,
            },
            {
                Content => 'WorkOrderTitle',
                Width   => 200,
            },
            {
                Content => 'ChangeTitle',
                Width   => 200,
            },
            {
                Content => 'WorkOrderState',
                Width   => 100,
            },
            {
                Content => 'Changed',
                Width   => 150,
            },
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
                    Title   => 'Change# 2009101610005402 - Workorder# 1: The WorkOrder Title',
                    Css     => 'style="text-decoration: line-through"',
                },
                {
                    Type    => 'Link',
                    Content => 'WO:2009100112354321-6',
                    Title   => 'Change# 2009101610007634 - Workorder# 6: The WorkOrder Title',
                },
            ],
        },
        ParentChild::Target => {
            ITSMWorkOrder => [
                {
                    Type    => 'Link',
                    Content => 'WO:2009100112354321-3',
                    Title   => 'Change# 20091016100044331 - Workorder# 3: The WorkOrder Title',
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
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need ObjectLinkListWithData!',
        );
        return;
    }

    my %LinkOutputData;
    for my $LinkType ( sort keys %{ $Param{ObjectLinkListWithData} } ) {

        # extract link type List
        my $LinkTypeList = $Param{ObjectLinkListWithData}->{$LinkType};

        for my $Direction ( sort keys %{$LinkTypeList} ) {

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
                    Title => $Self->{ChangeHook} . $WorkOrder->{ChangeData}->{ChangeNumber} . '-'
                        . $Self->{WorkOrderHook}
                        . $WorkOrder->{WorkOrderNumber} . ': '
                        . $WorkOrder->{WorkOrderTitle},
                    Link => '$Env{"Baselink"}Action=AgentITSMWorkOrderZoom;WorkOrderID='
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
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need ContentData!',
        );
        return;
    }

    # extract content
    my $Content = $Param{ContentData};

    return if $Content->{Type} ne 'WorkOrderStateSignal';

    # build html for signal LED
    my $String = $Self->{LayoutObject}->Output(
        Template => '<div class="Flag Small" title="$QData{"WorkOrderState"}"> '
            . '<span class="$QData{"WorkOrderStateSignal"}"></span> </div>',
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
            Key       => 'ChangeNumber',
            Name      => 'Change#',
            InputStrg => $FormString,
            FormData  => '2009100112354321',
        },
        {
            Key       => 'ChangeTitle',
            Name      => 'Change Title',
            InputStrg => $FormString,
            FormData  => 'Mail server needs update',
        },
        {
            Key       => 'WorkOrderNumber',
            Name      => 'Workorder#',
            InputStrg => $FormString,
            FormData  => '12',
        },
        {
            Key       => 'WorkOrderTitle',
            Name      => 'WorkOrder Title',
            InputStrg => $FormString,
            FormData  => 'Shutdown old mail server',
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
            Name => $Self->{ChangeHook},
            Type => 'Text',
        },
        {
            Key  => 'ChangeTitle',
            Name => 'ChangeTitle',
            Type => 'Text',
        },
        {
            Key  => 'WorkOrderNumber',
            Name => $Self->{WorkOrderHook},
            Type => 'Text',
        },
        {
            Key  => 'WorkOrderTitle',
            Name => 'WorkOrderTitle',
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
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
