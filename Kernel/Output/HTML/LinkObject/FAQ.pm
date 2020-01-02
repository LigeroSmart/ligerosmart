# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::LinkObject::FAQ;

use strict;
use warnings;

use Kernel::Language qw(Translatable);
use Kernel::Output::HTML::Layout;
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Language',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::JSON',
    'Kernel::System::Log',
    'Kernel::System::User',
    'Kernel::System::Web::Request',
);

=head1 NAME

Kernel::Output::HTML::LinkObject::FAQ - link object backend module

=head1 DESCRIPTION

All link object functions of link object (FAQ)

=head2 new()

create an object

    $BackendObject = Kernel::Output::HTML::LinkObject::FAQ->new(
        %Param,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {};
    bless( $Self, $Type );

    for my $Needed (qw(UserLanguage UserID)) {
        $Self->{$Needed} = $Param{$Needed} || die "Got no $Needed!";
    }

    # TODO: check if the new instance is still needed with the OM!

    # We need our own LayoutObject instance to avoid block data collisions with the main page.
    $Self->{LayoutObject} = Kernel::Output::HTML::Layout->new( %{$Self} );

    $Self->{ObjectData} = {
        Object     => 'FAQ',
        Realname   => 'FAQ',
        ObjectName => 'SourceObjectID',
    };

    $Self->{DynamicField} = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid      => 0,
        ObjectType => ['FAQ'],
    );

    return $Self;
}

=head2 TableCreateComplex()

return an array with the block data

    my @BlockData = $LinkObject->TableCreateComplex(
        ObjectLinkListWithData => $ObjectLinkListRef,
    );

a result could be

    %BlockData = (
        {
            ObjectName  => 'FAQID',
            ObjectID    => '14785',

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
                        Key     => $ItemID,
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
                        Key     => $ItemID,
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

    if ( !$Param{ObjectLinkListWithData} || ref $Param{ObjectLinkListWithData} ne 'HASH' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ObjectLinkListWithData!',
        );
        return;
    }

    # Convert the list.
    my %LinkList;
    for my $LinkType ( sort keys %{ $Param{ObjectLinkListWithData} } ) {

        # extract link type List
        my $LinkTypeList = $Param{ObjectLinkListWithData}->{$LinkType};

        for my $Direction ( sort keys %{$LinkTypeList} ) {

            # extract direction list
            my $DirectionList = $Param{ObjectLinkListWithData}->{$LinkType}->{$Direction};

            for my $ItemID ( sort keys %{$DirectionList} ) {

                $LinkList{$ItemID}->{Data} = $DirectionList->{$ItemID};
            }
        }
    }

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $ComplexTableData = $ConfigObject->Get("LinkObject::ComplexTable");
    my $DefaultColumns;
    if (
        $ComplexTableData
        && IsHashRefWithData($ComplexTableData)
        && $ComplexTableData->{FAQ}
        && IsHashRefWithData( $ComplexTableData->{FAQ} )
        )
    {
        $DefaultColumns = $ComplexTableData->{"FAQ"}->{"DefaultColumns"};
    }

    my @TimeLongTypes = (
        "Created",
        "Changed",
    );

    # Define the block data.
    my $FAQHook = $ConfigObject->Get('FAQ::FAQHook');

    my @Headline = (
        {
            Content => $FAQHook,
        },
    );

    my $UserObject = $Kernel::OM->Get('Kernel::System::User');

    # Load user preferences.
    my %Preferences = $UserObject->GetPreferences(
        UserID => $Self->{UserID},
    );

    if ( !$DefaultColumns || !IsHashRefWithData($DefaultColumns) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Missing configuration for LinkObject::ComplexTable###FAQ!',
        );
        return;
    }

    # Get default column priority from SysConfig.
    # Each column in table (Title, State,...) has defined Priority in SysConfig. System use this
    #   priority to sort columns, if user doesn't have own settings.
    my %SortOrder;
    if (
        $ComplexTableData->{"FAQ"}->{"Priority"}
        && IsHashRefWithData( $ComplexTableData->{"FAQ"}->{"Priority"} )
        )
    {
        %SortOrder = %{ $ComplexTableData->{"FAQ"}->{"Priority"} };
    }

    my %UserColumns = %{$DefaultColumns};

    if ( $Preferences{'LinkObject::ComplexTable-FAQ'} ) {

        my $ColumnsEnabled = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
            Data => $Preferences{'LinkObject::ComplexTable-FAQ'},
        );

        if (
            $ColumnsEnabled
            && IsHashRefWithData($ColumnsEnabled)
            && $ColumnsEnabled->{Order}
            && IsArrayRefWithData( $ColumnsEnabled->{Order} )
            )
        {
            # Clear sort order.
            %SortOrder = ();

            DEFAULTCOLUMN:
            for my $DefaultColumn ( sort keys %UserColumns ) {
                my $Index = 0;

                for my $UserSetting ( @{ $ColumnsEnabled->{Order} } ) {
                    $Index++;
                    if ( $DefaultColumn eq $UserSetting ) {
                        $UserColumns{$DefaultColumn} = 2;
                        $SortOrder{$DefaultColumn}   = $Index;

                        next DEFAULTCOLUMN;
                    }
                }

                # Not found, means user chose to hide this item.
                if ( $UserColumns{$DefaultColumn} == 2 ) {
                    $UserColumns{$DefaultColumn} = 1;
                }

                if ( !$SortOrder{$DefaultColumn} ) {
                    $SortOrder{$DefaultColumn} = 0;    # Set 0, it system will hide this item anyways
                }
            }
        }
    }
    else {

        # User has no own settings.
        for my $Column ( sort keys %UserColumns ) {
            if ( !$SortOrder{$Column} ) {
                $SortOrder{$Column} = 0;               # Set 0, it system will hide this item anyways
            }
        }
    }

    # Define Headline columns.
    my @AllColumns;
    COLUMN:
    for my $Column ( sort { $SortOrder{$a} <=> $SortOrder{$b} } keys %UserColumns ) {

        my $ColumnTranslate = $Column;
        if ( $Column eq 'CategoryName' ) {
            $ColumnTranslate = Translatable('Category');
        }
        elsif ( $Column eq 'ContentType' ) {
            $ColumnTranslate = Translatable('Content Type');
        }

        push @AllColumns, {
            ColumnName      => $Column,
            ColumnTranslate => $ColumnTranslate,
        };

        # Always present, already added.
        next COLUMN if $Column eq 'FAQNumber';

        # if enabled by default.
        if ( $UserColumns{$Column} == 2 ) {
            my $ColumnName = '';

            # Other FAQ fields.
            if ( $Column !~ m{\A DynamicField_}xms ) {
                $ColumnName = $ColumnTranslate;
            }

            # Dynamic fields.
            else {
                my $DynamicFieldConfig;
                my $DFColumn = $Column;
                $DFColumn =~ s{DynamicField_}{}g;

                DYNAMICFIELD:
                for my $DFConfig ( @{ $Self->{DynamicField} } ) {
                    next DYNAMICFIELD if !IsHashRefWithData($DFConfig);
                    next DYNAMICFIELD if $DFConfig->{Name} ne $DFColumn;

                    $DynamicFieldConfig = $DFConfig;
                    last DYNAMICFIELD;
                }
                next COLUMN if !IsHashRefWithData($DynamicFieldConfig);

                $ColumnName = $DynamicFieldConfig->{Label};
            }
            push @Headline, {
                Content => $ColumnName,
            };
        }
    }

    # Create the item list (table content).
    my @ItemList;
    for my $ItemID ( sort { $a <=> $b } keys %LinkList ) {

        # Extract FAQ data.
        my $FAQ = $LinkList{$ItemID}->{Data};

        # FAQ Number must be present (since it contains master link to the FAQ).
        my @ItemColumns = (
            {
                Type    => 'Link',
                Key     => $ItemID,
                Content => $FAQ->{Number},
                Link    => $Self->{LayoutObject}->{Baselink} . 'Action=AgentFAQZoom;ItemID=' . $ItemID,
            },
        );

        COLUMN:
        for my $Column ( sort { $SortOrder{$a} <=> $SortOrder{$b} } keys %UserColumns ) {
            next COLUMN if $Column eq 'FAQNumber';    # Always present, already added.

            # if enabled by default
            if ( $UserColumns{$Column} == 2 ) {

                my %Hash;
                if ( grep { $_ eq $Column } @TimeLongTypes ) {
                    $Hash{'Type'} = 'TimeLong';
                }
                else {
                    $Hash{'Type'} = 'Text';
                }

                if ( $Column eq 'Title' ) {
                    $Hash{MaxLength} = 50;
                }

                # FAQ fields.
                if ( $Column !~ m{\A DynamicField_}xms ) {
                    if ( $Column eq 'Approved' ) {
                        my $Value = $FAQ->{$Column} ? 'Yes' : 'No';
                        $Hash{'Content'} = $Kernel::OM->Get('Kernel::Language')->Translate($Value);
                    }
                    else {
                        $Hash{'Content'} = $FAQ->{$Column};
                    }
                }

                # Dynamic fields.
                else {
                    my $DynamicFieldConfig;
                    my $DFColumn = $Column;
                    $DFColumn =~ s{DynamicField_}{}g;

                    DYNAMICFIELD:
                    for my $DFConfig ( @{ $Self->{DynamicField} } ) {
                        next DYNAMICFIELD if !IsHashRefWithData($DFConfig);
                        next DYNAMICFIELD if $DFConfig->{Name} ne $DFColumn;

                        $DynamicFieldConfig = $DFConfig;
                        last DYNAMICFIELD;
                    }
                    next COLUMN if !IsHashRefWithData($DynamicFieldConfig);

                    # Get field value.
                    my $Value = $Kernel::OM->Get('Kernel::System::DynamicField::Backend')->ValueGet(
                        DynamicFieldConfig => $DynamicFieldConfig,
                        ObjectID           => $ItemID,
                    );

                    my $ValueStrg = $Kernel::OM->Get('Kernel::System::DynamicField::Backend')->DisplayValueRender(
                        DynamicFieldConfig => $DynamicFieldConfig,
                        Value              => $Value,
                        ValueMaxChars      => 20,
                        LayoutObject       => $Self->{LayoutObject},
                    );

                    $Hash{'Content'} = $ValueStrg->{Title};
                }

                push @ItemColumns, \%Hash;
            }
        }

        push @ItemList, \@ItemColumns;
    }

    return if !@ItemList;

    # Define the block data.
    my %Block = (
        Object     => $Self->{ObjectData}->{Object},
        Blockname  => $Self->{ObjectData}->{Realname},
        ObjectName => $Self->{ObjectData}->{ObjectName},
        ObjectID   => $Param{ObjectID},
        Headline   => \@Headline,
        ItemList   => \@ItemList,
        AllColumns => \@AllColumns,
    );

    return ( \%Block );
}

=head2 TableCreateSimple()

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

    if ( !$Param{ObjectLinkListWithData} || ref $Param{ObjectLinkListWithData} ne 'HASH' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ObjectLinkListWithData!',
        );
        return;
    }

    my $FAQHook = $Kernel::OM->Get('Kernel::Config')->Get('FAQ::FAQHook');
    my %LinkOutputData;
    for my $LinkType ( sort keys %{ $Param{ObjectLinkListWithData} } ) {

        # extract link type List
        my $LinkTypeList = $Param{ObjectLinkListWithData}->{$LinkType};

        for my $Direction ( sort keys %{$LinkTypeList} ) {

            # extract direction list
            my $DirectionList = $Param{ObjectLinkListWithData}->{$LinkType}->{$Direction};

            my @ItemList;
            for my $ItemID ( sort { $a <=> $b } keys %{$DirectionList} ) {

                # extract FAQ data
                my $FAQ = $DirectionList->{$ItemID};

                # define item data
                my %Item = (
                    Type    => 'Link',
                    Content => 'F:' . $FAQ->{Number},
                    Title   => "$FAQHook$FAQ->{Number}: $FAQ->{Title}",
                    Link    => $Self->{LayoutObject}->{Baselink}
                        . 'Action=AgentFAQZoom;ItemID='
                        . $ItemID,
                );
                push @ItemList, \%Item;
            }

            # add item list to link output data
            $LinkOutputData{ $LinkType . '::' . $Direction }->{FAQ} = \@ItemList;
        }
    }

    return %LinkOutputData;
}

=head2 ContentStringCreate()

return a output string

    my $String = $LinkObject->ContentStringCreate(
        ContentData => $HashRef,
    );

=cut

sub ContentStringCreate {
    my ( $Self, %Param ) = @_;

    if ( !$Param{ContentData} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ContentData!',
        );
        return;
    }

    # TODO: Check why no return is needed!
    return;
}

=head2 SelectableObjectList()

return an array hash with select-able objects

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

=head2 SearchOptionList()

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
    my $FAQHook          = $Kernel::OM->Get('Kernel::Config')->Get('FAQ::FAQHook');
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

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # add form data and input string
    ROW:
    for my $Row (@SearchOptionList) {

        # get form data
        $Row->{FormData} = $ParamObject->GetParam( Param => $Row->{FormKey} );

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
    }

    return @SearchOptionList;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
