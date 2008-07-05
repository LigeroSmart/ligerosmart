# --
# Kernel/Output/HTML/LinkObjectService.pm - layout backend module
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: LinkObjectService.pm,v 1.3 2008-07-05 15:52:31 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Output::HTML::LinkObjectService;

use strict;
use warnings;

use Kernel::Output::HTML::Layout;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

=head1 NAME

Kernel::Output::HTML::LinkObjectService - layout backend module

=head1 SYNOPSIS

All layout functions of link object (service)

=over 4

=cut

=item new()

create an object

    $BackendObject = Kernel::Output::HTML::LinkObjectService->new(
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
        Object   => 'Service',
        Realname => 'Service',
    };

    return $Self;
}

=item TableCreateComplex()

return an array with the block data

Return

    @BlockData = (
        Object    => 'Service',
        Blockname => 'Service',
        Headline  => [
            {
                Content => '',
                Width   => 20,
            },
            {
                Content => 'Service',
            },
            {
                Content => 'Type',
                Width   => 100,
            },
            {
                Content => 'Criticality',
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
                    Type             => 'InciSignal',
                    Key              => 123,
                    Content          => 'Operational',
                    CurInciStateType => 'Operational',
                },
                {
                    Type      => 'Link',
                    Content   => 'Service Bla',
                    Link      => 'Action=AgentITSMServiceZoom&ServiceID=123',
                    MaxLength => 70,
                },
                {
                    Type    => 'Text',
                    Content => 'Other',
                    Translate => 1,
                },
                {
                    Type    => 'Text',
                    Content => 'High',
                    Translate => 1,
                },
                {
                    Type    => 'TimeLong',
                    Content => '2008-01-01 12:12:00',
                },
            ],
            [
                {
                    Type             => 'InciSignal',
                    Key              => 321,
                    Content          => 'Operational',
                    CurInciStateType => 'Operational',
                },
                {
                    Type      => 'Link',
                    Content   => 'Service Bla',
                    Link      => 'Action=AgentITSMServiceZoom&ServiceID=321',
                    MaxLength => 70,
                },
                {
                    Type    => 'Text',
                    Content => 'Other',
                    Translate => 1,
                },
                {
                    Type    => 'Text',
                    Content => 'Low',
                    Translate => 1,
                },
                {
                    Type    => 'TimeLong',
                    Content => '2007-02-02 22:12:00',
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

            for my $ServiceID ( keys %{$DirectionList} ) {

                $LinkList{$ServiceID}->{Data} = $DirectionList->{$ServiceID};
            }
        }
    }

    # create the item list
    my @ItemList;
    for my $ServiceID (
        sort { lc $LinkList{$a}{Data}->{Name} cmp lc $LinkList{$b}{Data}->{Name} }
        keys %LinkList
        )
    {

        # extract service data
        my $Service = $LinkList{$ServiceID}{Data};

        my @ItemColumns = (
            {
                Type             => 'CurInciSignal',
                Key              => $ServiceID,
                Content          => $Service->{CurInciState},
                CurInciStateType => $Service->{CurInciStateType},
            },
            {
                Type      => 'Link',
                Content   => $Service->{NameShort},
                Link      => '$Env{"Baselink"}Action=AgentITSMServiceZoom&ServiceID=' . $ServiceID,
                MaxLength => 70,
            },
            {
                Type    => 'Text',
                Content => $Service->{Type},
                Translate => 1,
            },
            {
                Type    => 'Text',
                Content => $Service->{Criticality},
                Translate => 1,
            },
            {
                Type    => 'TimeLong',
                Content => $Service->{ChangeTime},
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
                Content => 'Service',
            },
            {
                Content => 'Type',
                Width   => 100,
            },
            {
                Content => 'Criticality',
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
            Service => [
                {
                    Type    => 'Link',
                    Content => 'S:The servic[..]',
                    Title   => 'Service: The service name',
                    Css     => 'style="text-decoration: line-through"',
                },
                {
                    Type    => 'Link',
                    Content => 'S:Name of servic[..]',
                    Title   => 'Service: Name of service 2',
                },
            ],
        },
        ParentChild::Target => {
            Service => [
                {
                    Type    => 'Link',
                    Content => 'S:Service nam[..]',
                    Title   => 'Service: Service name',
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
            for my $ServiceID ( sort { lc $DirectionList->{$a}->{NameShort} cmp lc $DirectionList->{$b}->{NameShort} } keys %{$DirectionList} ) {

                # extract service data
                my $Service = $DirectionList->{$ServiceID};

                # define item data
                my %Item = (
                    Type      => 'Link',
                    Content   => "S:$Service->{NameShort}",
                    Title     => "Service: $Service->{Name}",
                    Link      => '$Env{"Baselink"}Action=AgentITSMServiceZoom&ServiceID=' . $ServiceID,
                    MaxLength => 20,
                );

                push @ItemList, \%Item;
            }

            # add item list to link output data
            $LinkOutputData{ $LinkType . '::' . $Direction }->{Service} = \@ItemList;
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

    return if $Content->{Type} ne 'CurInciSignal';

    # set incident signal
    my %InciSignals = (
        incident    => 'redled',
        operational => 'greenled',
        unknown     => 'grayled',
        warning     => 'yellowled',
    );

    # investigate current incident signal
    $Content->{CurInciStateType} ||= 'unknown';
    my $CurInciSignal = $InciSignals{ $Content->{CurInciStateType} };
    $CurInciSignal ||= $InciSignals{unknown};

    my $String = $Self->{LayoutObject}->Output(
        Template => '<img border="0" src="$Env{"Images"}$QData{"CurInciSignal"}.png" '
            . 'title="$Text{"$QData{"CurInciState"}"}" alt="$Text{"$QData{"CurInciState"}"}">',
        Data => {
            CurInciSignal => $CurInciSignal,
            CurInciState  => $Content->{Content} || '',
        },
    );

    return $String;
}

=item SelectableObjectList()

return an array hash with selectable objects

Return

    @SelectableObjectList = (
        {
            Key   => 'Service',
            Value => 'Service',
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
            Name      => 'Service',
            InputStrg => $FormString,
            FormData  => 'Service Name',
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
            Name => 'Service',
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

$Revision: 1.3 $ $Date: 2008-07-05 15:52:31 $

=cut
