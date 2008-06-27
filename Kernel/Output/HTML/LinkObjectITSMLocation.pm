# --
# Kernel/Output/HTML/LinkObjectITSMLocation.pm - layout backend module
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: LinkObjectITSMLocation.pm,v 1.4 2008-06-27 08:30:09 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Output::HTML::LinkObjectITSMLocation;

use strict;
use warnings;

use Kernel::Output::HTML::Layout;
use Kernel::System::State;
use Kernel::System::GeneralCatalog;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.4 $) [1];

=head1 NAME

Kernel::Output::HTML::LinkObjectITSMLocation - layout backend module

=head1 SYNOPSIS

All layout functions of link object (ITSMLocation)

=over 4

=cut

=item new()

create an object

    $BackendObject = Kernel::Output::HTML::LinkObjectITSMLocation->new(
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
    $Self->{StateObject}  = Kernel::System::State->new( %{$Self} );
    $Self->{GeneralCatalogObject} = Kernel::System::GeneralCatalog->new( %{$Self} );

    # define needed variables
    $Self->{ObjectData} = {
        Object   => 'ITSMLocation',
        Realname => 'Location',
    };

    return $Self;
}

=item TableCreateComplex()

return a hash with the block data

Return
    %BlockData = (
        Object    => 'ITSMLocation',
        Blockname => 'ITSMLocation',
        Headline  => [
            {
                Content => 'Name',
                Width   => 30,
            },
            {
                Content => 'Type',
            },
            {
                Content => 'Phone 1',
            },
            {
                Content => 'E-Mail',
            },
            {
                Content => 'Last Change',
            },
        ],
        ItemList => [
            [
                {
                    'Type'      => 'Link',
                    'Key'       => '2',
                    'Content'   => 'Headquarter Office',
                    'Title'     => 'Headquarter Office'
                    'Link'      => '$Env{"Baselink"}Action=AgentITSMLocationZoom&LocationID=2',
                    'MaxLength' => 30,
                },
                {
                    'Type'      => 'Text',
                    'Content'   => 'IT Facility',
                    'Translate' => 1,
                },
                {
                    'Type'    => 'Text',
                    'Content' => '+49 (0)1234 5678 9'
                },
                {
                    'Type'    => 'Text',
                    'Content' => 'test@test.com'
                },
                {
                    'Type'    => 'TimeLong',
                    'Content' => '2008-06-17 16:01:36'
                },
            ],
            [
                {
                    'Type'      => 'Link',
                    'Key'       => '3',
                    'Content'   => 'Server Room',
                    'Title'     => 'Server Room'
                    'Link'      => '$Env{"Baselink"}Action=AgentITSMLocationZoom&LocationID=3',
                    'MaxLength' => 30,
                },
                {
                    'Type'      => 'Text',
                    'Content'   => 'Room',
                    'Translate' => 1,
                },
                {
                    'Type'    => 'Text',
                    'Content' => '+49 (0)987 654 32'
                },
                {
                    'Type'    => 'Text',
                    'Content' => 'test@test.com'
                },
                {
                    'Type'    => 'TimeLong',
                    'Content' => '2008-06-12 12:07:45'
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

        for my $Direction ( keys %{ $LinkTypeList } ) {

            # extract direction list
            my $DirectionList = $Param{ObjectLinkListWithData}->{$LinkType}->{$Direction};

            for my $LocationID ( keys %{ $DirectionList } ) {

                $LinkList{$LocationID}->{Data}= $DirectionList->{$LocationID};
            }
        }
    }

    # get location type list
    my $TypeListRef = $Self->{GeneralCatalogObject}->ItemList(
        Class => 'ITSM::Location::Type',
    );

    # create the item list
    my @ItemList;
    for my $LocationID ( sort { lc $LinkList{$a}->{Data}->{Name} cmp lc $LinkList{$b}->{Data}->{Name} } keys %LinkList ) {

        # extract loaction data
        my $Location = $LinkList{$LocationID}{Data};

        my @ItemColumns = (
            {
                Type      => 'Link',
                Key       => $LocationID,
                Content   => $Location->{Name},
                Title     => $Location->{Name},
                Link      => '$Env{"Baselink"}Action=AgentITSMLocationZoom&LocationID=' . $LocationID,
                MaxLength => 30,
            },
            {
                Type      => 'Text',
                Content   => $TypeListRef->{ $Location->{TypeID} },
                Translate => 1,
            },
            {
                Type    => 'Text',
                Content => $Location->{Phone1},
            },
            {
                Type    => 'Text',
                Content => $Location->{Email},
            },
            {
                Type    => 'TimeLong',
                Content => $Location->{ChangeTime},
            },
        );

        push @ItemList, \@ItemColumns;

    }

    return if !@ItemList;

    # block data
    my %BlockData = (
        Object    => $Self->{ObjectData}->{Object},
        Blockname => $Self->{ObjectData}->{Realname},
        Headline  => [
            {
                Content => 'Name',
                Width   => 30,
            },
            {
                Content => 'Type',
            },
            {
                Content => 'Phone 1',
            },
            {
                Content => 'E-Mail',
            },
            {
                Content => 'Last Change',
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
            ITSMLocation => [
                {
                    Type    => 'Link',
                    Content => 'L:Marketing Office',
                },
                {
                    Type    => 'Link',
                    Content => 'L:Headquarter Office',
                },
            ],
        },
        ParentChild::Target => {
            ITSMLocation => [
                {
                    Type    => 'Link',
                    Content => 'L:Server Room',
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
        $Self->{LogObject}->Log( Priority => 'error', Message  => 'Need ObjectLinkListWithData!' );
        return;
    }

    my %LinkOutputData;
    for my $LinkType ( keys %{ $Param{ObjectLinkListWithData} } ) {

        # extract link type List
        my $LinkTypeList = $Param{ObjectLinkListWithData}->{$LinkType};

        for my $Direction ( keys %{ $LinkTypeList } ) {

            # extract direction list
            my $DirectionList = $Param{ObjectLinkListWithData}->{$LinkType}->{$Direction};

            my @ItemList;
            for my $LocationID ( sort { $a <=> $b } keys %{ $DirectionList } ) {

                # extract tickt data
                my $Location = $DirectionList->{$LocationID};

                # define item data
                my %Item = (
                    Type    => 'Link',
                    Content => 'L:' . $Location->{Name},
                    Title   => "Location: $Location->{Name}",
                    Link    => '$Env{"Baselink"}Action=AgentITSMLocationZoom&LocationID=' . $LocationID,
                );

                push @ItemList, \%Item;
            }

            # add item list to link output data
            $LinkOutputData{ $LinkType . '::' . $Direction }->{ITSMLocation} = \@ItemList;
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
        $Self->{LogObject}->Log( Priority => 'error', Message  => 'Need ContentData!' );
        return;
    }

    return;
}

=item SelectableObjectList()

return an array hash with selectable objects

Return
    @SelectableObjectList = (
        {
            Key   => 'ITSMLocation',
            Value => 'Location',
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
            Name      => 'Location',
            InputStrg => $FormString,
            FormData  => 'BlaBla',
        },
        {
            Key       => 'Phone1',
            Name      => 'Phone 1',
            InputStrg => $FormString,
            FormData  => '12345',
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
            Name => 'Location',
            Type => 'Text',
        },
        {
            Key  => 'TypeIDs',
            Name => 'Type',
            Type => 'List',
            Translate => 1,
        },
        {
            Key  => 'Phone1',
            Name => 'Phone 1',
            Type => 'Text',
        },
        {
            Key  => 'Email',
            Name => 'E-Mail',
            Type => 'Text',
        },
        {
            Key  => 'Address',
            Name => 'Address',
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

            my $ListDataRef;
            if ( $Row->{Key} eq 'TypeIDs' ) {

                # get location type list
                $ListDataRef = $Self->{GeneralCatalogObject}->ItemList(
                    Class => 'ITSM::Location::Type',
                );
            }

            # add the input string
            $Row->{InputStrg} = $Self->{LayoutObject}->BuildSelection(
                Data       => $ListDataRef,
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
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.

=cut

=head1 VERSION

$Revision: 1.4 $ $Date: 2008-06-27 08:30:09 $

=cut
