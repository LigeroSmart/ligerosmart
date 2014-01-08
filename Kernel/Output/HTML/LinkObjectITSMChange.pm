# --
# Kernel/Output/HTML/LinkObjectITSMChange.pm - layout backend module
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::LinkObjectITSMChange;

use strict;
use warnings;

use Kernel::Output::HTML::Layout;
use Kernel::System::GeneralCatalog;

=head1 NAME

Kernel::Output::HTML::LinkObjectITSMChange - layout backend module

=head1 SYNOPSIS

All layout functions of link object (change)

=over 4

=cut

=item new()

create an object

    $BackendObject = Kernel::Output::HTML::LinkObjectITSMChange->new(
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
        Object   => 'ITSMChange',
        Realname => 'Change',
    };

    # get config
    $Self->{ChangeHook} = $Self->{ConfigObject}->Get('ITSMChange::Hook');

    return $Self;
}

=item TableCreateComplex()

return an array with the block data

Return

    @BlockData = (
        Object    => 'ITSMChange',
        Blockname => 'Change',
        Headline  => [
            {
                Content => '',
                Width   => 20,
            },
            {
                Content => 'Change#',
                Width   => 200,
            },
            {
                Content => 'Change Title',
                Width   => 200,
            },
            {
                Content => 'Change State',
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
                    Type        => 'ChangeStateSignal',
                    Key         => 123,
                    Content     => 'grayled',
                    ChangeState => 'requested',
                },
                {
                    Type    => 'Link',
                    Content => '2009100112345778',
                    Link    => 'Action=AgentITSMChangeZoom;ChangeID=123',
                },
                {
                    Type      => 'Text',
                    Content   => 'Change Title',
                    MaxLength => 70,
                },
                {
                    Type      => 'Text',
                    Content   => 'requested',
                },
                {
                    Type    => 'TimeLong',
                    Content => '2008-01-01 12:12:00',
                },
            ],
            [
                {
                    Type        => 'ChangeStateSignal',
                    Key         => 456,
                    Content     => 'greenled',
                    ChangeState => 'closed',
                },
                {
                    Type    => 'Link',
                    Content => '2009100112345774',
                    Link    => 'Action=AgentITSMChangeZoom;ChangeID=456',
                },
                {
                    Type      => 'Text',
                    Content   => 'Change Title',
                    MaxLength => 70,
                },
                {
                    Type      => 'Text',
                    Content   => 'closed',
                },
                {
                    Type    => 'TimeLong',
                    Content => '2008-01-01 12:12:00',
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

            for my $ChangeID ( sort keys %{$DirectionList} ) {

                $LinkList{$ChangeID}->{Data} = $DirectionList->{$ChangeID};
            }
        }
    }

    # create the item list, sort by ChangeID Down
    my @ItemList;
    for my $ChangeID (
        sort {
            $LinkList{$b}{Data}->{ChangeID} <=> $LinkList{$a}{Data}->{ChangeID}
        } keys %LinkList
        )
    {

        # extract change data
        my $Change = $LinkList{$ChangeID}{Data};

        my @ItemColumns = (
            {
                Type        => 'ChangeStateSignal',
                Key         => $ChangeID,
                Content     => $Change->{ChangeStateSignal},
                ChangeState => $Change->{ChangeState},
            },
            {
                Type    => 'Link',
                Content => $Change->{ChangeNumber},
                Link    => '$Env{"Baselink"}Action=AgentITSMChangeZoom;ChangeID=' . $ChangeID,
            },
            {
                Type      => 'Text',
                Content   => $Change->{ChangeTitle},
                MaxLength => 70,
            },
            {
                Type      => 'Text',
                Content   => $Change->{ChangeState},
                Translate => 1,
            },
            {
                Type    => 'TimeLong',
                Content => $Change->{ChangeTime},
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
                Content => $Self->{ChangeHook},
                Width   => 200,
            },
            {
                Content => 'ChangeTitle',
                Width   => 200,
            },
            {
                Content => 'ChangeState',
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
            ITSMChange => [
                {
                    Type    => 'Link',
                    Content => 'CH:2009100112354321-1',
                    Title   => 'Change# 2009101610005402: The Change Title',
                    Css     => 'style="text-decoration: line-through"',
                },
                {
                    Type    => 'Link',
                    Content => 'CH:2009100112354321-6',
                    Title   => 'Change# 2009101610007634: The Change Title',
                },
            ],
        },
        ParentChild::Target => {
            ITSMChange => [
                {
                    Type    => 'Link',
                    Content => 'CH:2009100112354321-3',
                    Title   => 'Change# 20091016100044331: The Change Title',
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

            # create the item list, sort by ChangeID Down
            my @ItemList;
            for my $ChangeID (
                sort {
                    $DirectionList->{$b}->{ChangeID} <=> $DirectionList->{$a}->{ChangeID}
                } keys %{$DirectionList}
                )
            {

                # extract change data
                my $Change = $DirectionList->{$ChangeID};

                # define item data
                my %Item = (
                    Type    => 'Link',
                    Content => 'CH:' . $Change->{ChangeNumber},
                    Title =>
                        "$Self->{ChangeHook} $Change->{ChangeNumber}: $Change->{ChangeTitle}",
                    Link =>
                        '$Env{"Baselink"}Action=AgentITSMChangeZoom;ChangeID=' . $ChangeID,
                    MaxLength => 20,
                );

                push @ItemList, \%Item;
            }

            # add item list to link output data
            $LinkOutputData{ $LinkType . '::' . $Direction }->{ITSMChange} = \@ItemList;
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

    return if $Content->{Type} ne 'ChangeStateSignal';

    # build html for signal LED
    my $String = $Self->{LayoutObject}->Output(
        Template => '<div class="Flag Small" title="$QData{"ChangeState"}"> '
            . '<span class="$QData{"ChangeStateSignal"}"></span> </div>',
        Data => {
            ChangeStateSignal => $Content->{Content},
            ChangeState => $Content->{ChangeState} || '',
        },
    );

    return $String;
}

=item SelectableObjectList()

return an array hash with selectable objects

Return

    @SelectableObjectList = (
        {
            Key   => 'ITSMChange',
            Value => 'Change',
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
            Key => $Self->{ObjectData}->{Object},

            # also use the object here and not the real name, for translation issues
            Value => $Self->{ObjectData}->{Object},

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
            FormData  => '12',
        },
        {
            Key       => 'ChangeTitle',
            Name      => 'Change Title',
            InputStrg => $FormString,
            FormData  => 'MailServer needs update',
        },
        {
            Key       => 'WorkOrderTitle',
            Name      => 'Workorder Title',
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
