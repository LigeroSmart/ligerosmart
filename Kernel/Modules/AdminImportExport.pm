# --
# Kernel/Modules/AdminImportExport.pm - admin frontend of import export module
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminImportExport;

use strict;
use warnings;

use Kernel::System::ImportExport;
use Kernel::System::Valid;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(ConfigObject ParamObject LogObject LayoutObject EncodeObject)) {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Object!" );
        }
    }
    $Self->{ImportExportObject} = Kernel::System::ImportExport->new( %{$Self} );
    $Self->{ValidObject}        = Kernel::System::Valid->new( %{$Self} );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # ------------------------------------------------------------ #
    # template edit (common)
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'TemplateEdit1' ) {

        # get object list
        my $ObjectList = $Self->{ImportExportObject}->ObjectList();

        if ( !$ObjectList ) {
            $Self->{LayoutObject}->FatalError( Message => 'No object backend found!' );
            return;
        }

        # get format list
        my $FormatList = $Self->{ImportExportObject}->FormatList();

        if ( !$FormatList ) {
            $Self->{LayoutObject}->FatalError( Message => 'No format backend found!' );
            return;
        }

        # get params
        my $TemplateData;
        my $TemplateID = $Self->{ParamObject}->GetParam( Param => 'TemplateID' );

        my $SaveContinue;
        $SaveContinue = $Self->{ParamObject}->GetParam( Param => 'SubmitNext' );

        if ( !$SaveContinue ) {

            # if needed new form
            if ( !$TemplateID ) {
                return $Self->_MaskTemplateEdit1( New => 1, %Param );
            }

            # if there is template id
            # get template data
            $TemplateData = $Self->{ImportExportObject}->TemplateGet(
                TemplateID => $TemplateID,
                UserID     => $Self->{UserID},
            );

            if ( !$TemplateData->{TemplateID} ) {
                $Self->{LayoutObject}->FatalError( Message => 'Template not found!' );
                return;
            }

            # if edit
            if ( $TemplateData->{TemplateID} ) {
                return $Self->_MaskTemplateEdit1( %Param, %{$TemplateData} );
            }

        }

        # if save & continue
        my %ServerError;

        # get all data for params and check for errors
        for my $Param (qw(Comment Object Format Name ValidID TemplateID)) {
            $TemplateData->{$Param} = $Self->{ParamObject}->GetParam( Param => $Param ) || '';
        }

        # is a new template?
        my $New;
        if ( !$TemplateData->{TemplateID} ) {
            $New = 1;
        }

        # check needed fields
        # for new templates
        if ($New) {

            if ( !$TemplateData->{Object} ) {
                $ServerError{Object} = 1;
            }

            if ( !$TemplateData->{Format} ) {
                $ServerError{Format} = 1;
            }

        }

        # for all templates
        if ( !$TemplateData->{Name} ) {
            $ServerError{Name} = 1;
        }

        # if some error
        if ( $ServerError{Format} || $ServerError{Object} || $ServerError{Name} ) {
            return $Self->_MaskTemplateEdit1(
                ServerError => \%ServerError,
                New         => $New,
                %{$TemplateData},
            );
        }

        # save to database
        my $Success;

        if ($New) {
            $TemplateData->{TemplateID} = $Self->{ImportExportObject}->TemplateAdd(
                %{$TemplateData},
                UserID => $Self->{UserID},
            );
            $Success = $TemplateData->{TemplateID};
        }
        else {
            $Success = $Self->{ImportExportObject}->TemplateUpdate(
                UserID => $Self->{UserID},
                %{$TemplateData},
            );
        }

        if ( !$Success ) {
            $Self->{LayoutObject}->FatalError( Message => "Can't insert/update template!" );
            return;
        }

        return $Self->{LayoutObject}->Redirect(
            OP =>
                "Action=$Self->{Action};Subaction=TemplateEdit2;TemplateID=$TemplateData->{TemplateID}",
        );
    }

    # ------------------------------------------------------------ #
    # template edit (object)
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'TemplateEdit2' ) {

        # get object list
        my $ObjectList = $Self->{ImportExportObject}->ObjectList();

        if ( !$ObjectList ) {
            $Self->{LayoutObject}->FatalError( Message => 'No object backend found!' );
            return;
        }

        # get format list
        my $FormatList = $Self->{ImportExportObject}->FormatList();

        if ( !$FormatList ) {
            $Self->{LayoutObject}->FatalError( Message => 'No format backend found!' );
            return;
        }

        # get template id
        my $TemplateID = $Self->{ParamObject}->GetParam( Param => 'TemplateID' );

        if ( !$TemplateID ) {
            $Self->{LayoutObject}->FatalError( Message => 'Needed TemplateID!' );
            return;
        }

        my $SubmitNext = $Self->{ParamObject}->GetParam( Param => 'SubmitNext' );

        if ( !$SubmitNext ) {
            return $Self->_MaskTemplateEdit2( TemplateID => $TemplateID );
        }

        # save template starts here

        # get object attributes
        my $ObjectAttributeList = $Self->{ImportExportObject}->ObjectAttributesGet(
            TemplateID => $TemplateID,
            UserID     => $Self->{UserID},
        );

        my %AttributeValues;

        my $Error = 0;
        my %ServerError;
        my %DataTypeError;

        # get attribute values from form
        for my $Item ( @{$ObjectAttributeList} ) {

            # get form data
            $AttributeValues{ $Item->{Key} } = $Self->{LayoutObject}->ImportExportFormDataGet(
                Item => $Item,
            );

            # reload form if value is required and is not there
            if ( $Item->{Form}->{Invalid} ) {
                $ServerError{ $Item->{Name} } = 1;
                $Error = 1;
            }

            if ( $AttributeValues{ $Item->{Key} } ) {

                # look for regexp for data type allowed
                if (
                    $Item->{Input}->{Regex}
                    &&
                    !$AttributeValues{ $Item->{Key} } =~ $Item->{Input}->{Regex}
                    )
                {

                    $DataTypeError{ $Item->{Name} } = 1;
                    $Error = 1;
                }
            }

        }

        # reload with server errors
        if ($Error) {
            return $Self->_MaskTemplateEdit2(
                ServerError      => \%ServerError,
                DataTypeError    => \%DataTypeError,
                TemplateDataForm => \%AttributeValues,
                TemplateID       => $TemplateID,
            );
        }

        # save the object data
        $Self->{ImportExportObject}->ObjectDataSave(
            TemplateID => $TemplateID,
            ObjectData => \%AttributeValues,
            UserID     => $Self->{UserID},
        );

        return $Self->{LayoutObject}->Redirect(
            OP => "Action=$Self->{Action};Subaction=TemplateEdit3;TemplateID=$TemplateID",
        );

    }

    # ------------------------------------------------------------ #
    # template edit (format)
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'TemplateEdit3' ) {

        # get object list
        my $ObjectList = $Self->{ImportExportObject}->ObjectList();

        if ( !$ObjectList ) {
            $Self->{LayoutObject}->FatalError( Message => 'No object backend found!' );
            return;
        }

        # get format list
        my $FormatList = $Self->{ImportExportObject}->FormatList();

        if ( !$FormatList ) {
            $Self->{LayoutObject}->FatalError( Message => 'No format backend found!' );
            return;
        }

        # get template id
        my $TemplateID = $Self->{ParamObject}->GetParam( Param => 'TemplateID' );

        if ( !$TemplateID ) {
            $Self->{LayoutObject}->FatalError( Message => 'Needed TemplateID!' );
            return;
        }

        my $SubmitNext = $Self->{ParamObject}->GetParam( Param => 'SubmitNext' );

        if ( !$SubmitNext ) {
            return $Self->_MaskTemplateEdit3( TemplateID => $TemplateID );
        }

        # save starting here

        # get format attributes
        my $FormatAttributeList = $Self->{ImportExportObject}->FormatAttributesGet(
            TemplateID => $TemplateID,
            UserID     => $Self->{UserID},
        );

        # get format data
        my $FormatData = $Self->{ImportExportObject}->FormatDataGet(
            TemplateID => $TemplateID,
            UserID     => $Self->{UserID},
        );

        my $Error = 0;
        my %ServerError;

        # get attribute values from form
        my %AttributeValues;
        for my $Item ( @{$FormatAttributeList} ) {

            # get form data
            $AttributeValues{ $Item->{Key} } = $Self->{LayoutObject}->ImportExportFormDataGet(
                Item => $Item,
            );

            # reload form if value is required
            if ( $Item->{Form}->{Invalid} ) {
                $ServerError{ $Item->{Name} } = 1;
                $Error = 1;
            }
        }

        # reload with server errors
        if ($Error) {
            return $Self->_MaskTemplateEdit3(
                ServerError => \%ServerError,
                TemplateID  => $TemplateID,
            );
        }

        # save the format data
        $Self->{ImportExportObject}->FormatDataSave(
            TemplateID => $TemplateID,
            FormatData => \%AttributeValues,
            UserID     => $Self->{UserID},
        );

        return $Self->{LayoutObject}->Redirect(
            OP => "Action=$Self->{Action};Subaction=TemplateEdit4;TemplateID=$TemplateID",
        );
    }

    # ------------------------------------------------------------ #
    # template edit (mapping)
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'TemplateEdit4' ) {

        # get object list
        my $ObjectList = $Self->{ImportExportObject}->ObjectList();

        if ( !$ObjectList ) {
            $Self->{LayoutObject}->FatalError( Message => 'No object backend found!' );
            return;
        }

        # get format list
        my $FormatList = $Self->{ImportExportObject}->FormatList();

        if ( !$FormatList ) {
            $Self->{LayoutObject}->FatalError( Message => 'No format backend found!' );
            return;
        }

        # get params
        my $TemplateData = {};
        $TemplateData->{TemplateID} = $Self->{ParamObject}->GetParam( Param => 'TemplateID' );

        # get template data
        $TemplateData = $Self->{ImportExportObject}->TemplateGet(
            TemplateID => $TemplateData->{TemplateID},
            UserID     => $Self->{UserID},
        );

        if ( !$TemplateData->{TemplateID} ) {
            $Self->{LayoutObject}->FatalError( Message => 'Template not found!' );
            return;
        }

        # generate ObjectOptionStrg
        my $ObjectOptionStrg = $Self->{LayoutObject}->BuildSelection(
            Data         => $ObjectList,
            Name         => 'Object',
            SelectedID   => $TemplateData->{Object},
            PossibleNone => 1,
            Translation  => 1,
        );

        # generate FormatOptionStrg
        my $FormatOptionStrg = $Self->{LayoutObject}->BuildSelection(
            Data         => $FormatList,
            Name         => 'Format',
            SelectedID   => $TemplateData->{Format},
            PossibleNone => 1,
            Translation  => 1,
        );

        # output overview
        $Self->{LayoutObject}->Block(
            Name => 'Overview',
            Data => {
                %Param,
                ObjectOptionStrg => $ObjectOptionStrg,
                FormatOptionStrg => $FormatOptionStrg,
            },
        );

        $Self->{LayoutObject}->Block( Name => 'ActionList' );
        $Self->{LayoutObject}->Block( Name => 'ActionOverview' );

        # output headline
        $Self->{LayoutObject}->Block(
            Name => 'TemplateEdit4',
            Data => {
                %{$TemplateData},
                ObjectName => $ObjectList->{ $TemplateData->{Object} },
                FormatName => $FormatList->{ $TemplateData->{Format} },
            },
        );

        # get mapping data list
        my $MappingList = $Self->{ImportExportObject}->MappingList(
            TemplateID => $TemplateData->{TemplateID},
            UserID     => $Self->{UserID},
        );

        # get object attributes
        my $MappingObjectAttributes = $Self->{ImportExportObject}->MappingObjectAttributesGet(
            TemplateID => $TemplateData->{TemplateID},
            UserID     => $Self->{UserID},
        );

        # get format attributes
        my $MappingFormatAttributes = $Self->{ImportExportObject}->MappingFormatAttributesGet(
            TemplateID => $TemplateData->{TemplateID},
            UserID     => $Self->{UserID},
        );

        # create headers for object and add common headers
        my @Headers;

        for my $Header ( @{$MappingObjectAttributes} ) {
            push @Headers, $Header->{Name};
        }

        for my $CommonHeader ( 'Column', 'Up', 'Down', 'Delete' ) {
            push @Headers, $CommonHeader;
        }

        for my $Header (@Headers) {

            # output attribute row
            $Self->{LayoutObject}->Block(
                Name => 'TemplateEdit4TableHeader',
                Data => {
                    Header => $Header,
                },
            );
        }

        # to use in colspan for 'no data found' message
        my $HeaderCounter = @Headers;

        my $EmptyMap            = 1;
        my $AtributteRowCounter = 0;
        for my $MappingID ( @{$MappingList} ) {

            $EmptyMap = 0;

            # output attribute row
            $Self->{LayoutObject}->Block(
                Name => 'TemplateEdit4Row',
                Data => {
                    MappingID => $MappingID,
                },
            );

            # get mapping object data
            my $MappingObjectData = $Self->{ImportExportObject}->MappingObjectDataGet(
                MappingID => $MappingID,
                UserID    => $Self->{UserID},
            );

            # get mapping format data
            my $MappingFormatData = $Self->{ImportExportObject}->MappingFormatDataGet(
                MappingID => $MappingID,
                UserID    => $Self->{UserID},
            );

            for my $Item ( @{$MappingObjectAttributes} ) {

                # create form input
                my $InputString = $Self->{LayoutObject}->ImportExportFormInputCreate(
                    Item   => $Item,
                    Prefix => 'Object::' . $AtributteRowCounter . '::',
                    Value  => $MappingObjectData->{ $Item->{Key} },
                    ID     => $Item->{Key} . $AtributteRowCounter,
                );

                # output attribute row
                $Self->{LayoutObject}->Block(
                    Name => 'TemplateEdit4Column',
                    Data => {
                        Name      => $Item->{Name},
                        ID        => 'Object::' . $AtributteRowCounter . '::' . $Item->{Key},
                        InputStrg => $InputString,
                        Counter   => $AtributteRowCounter,
                    },
                );
            }

            for my $Item ( @{$MappingFormatAttributes} ) {

                # create form input
                my $InputString = $Self->{LayoutObject}->ImportExportFormInputCreate(
                    Item   => $Item,
                    Prefix => 'Format::' . $AtributteRowCounter . '::',
                    Value  => $MappingFormatData->{ $Item->{Key} },
                );

                # output attribute row
                $Self->{LayoutObject}->Block(
                    Name => 'TemplateEdit4MapNumberColumn',
                    Data => {
                        Name      => $Item->{Name},
                        InputStrg => $InputString,
                        Counter   => $AtributteRowCounter,
                    },
                );
            }

            # hide the up button for first element and down button for the last element
            my $UpBlock;
            my $DownBlock;
            my $NumberOfElements = @{$MappingList};

            if ( $AtributteRowCounter == 0 ) {
                $UpBlock = 'TemplateEdit4NoUpButton';
            }
            else {
                $UpBlock = 'TemplateEdit4UpButton';
            }

            # check if this is the last element
            if ( $AtributteRowCounter == ( $NumberOfElements - 1 ) ) {
                $DownBlock = 'TemplateEdit4NoDownButton';
            }
            else {
                $DownBlock = 'TemplateEdit4DownButton';
            }

            # up button block
            $Self->{LayoutObject}->Block(
                Name => $UpBlock,
                Data => { MappingID => $MappingID },
            );

            # down button block
            $Self->{LayoutObject}->Block(
                Name => $DownBlock,
                Data => { MappingID => $MappingID },
            );

            $AtributteRowCounter++;
        }

        # output an empty list
        if ($EmptyMap) {

            # output list
            $Self->{LayoutObject}->Block(
                Name => 'TemplateEdit4NoMapFound',
                Data => {
                    Columns => $HeaderCounter,
                },
            );
        }

        # output header and navbar
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # start template output
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminImportExport',
            Data         => \%Param,
        );

        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # template save (mapping)
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'TemplateSave4' ) {

        # get template id
        my $TemplateID = $Self->{ParamObject}->GetParam( Param => 'TemplateID' );

        my %Submit = (
            SubmitNext => 'TemplateEdit5',
            SubmitBack => 'TemplateEdit3',
            Reload     => 'TemplateEdit4',
            MappingAdd => 'TemplateEdit4',
        );

        # get submit action
        my $Subaction    = $Submit{Reload};
        my $SubmitButton = '';

        PARAM:
        for my $SubmitKey ( sort keys %Submit ) {
            next PARAM if !$Self->{ParamObject}->GetParam( Param => $SubmitKey );

            $Subaction    = $Submit{$SubmitKey};
            $SubmitButton = $SubmitKey;
            last PARAM;
        }

        # get mapping data list
        my $MappingList = $Self->{ImportExportObject}->MappingList(
            TemplateID => $TemplateID,
            UserID     => $Self->{UserID},
        );

        # get object attributes
        my $MappingObjectAttributes = $Self->{ImportExportObject}->MappingObjectAttributesGet(
            TemplateID => $TemplateID,
            UserID     => $Self->{UserID},
        );

        # get format attributes
        my $MappingFormatAttributes = $Self->{ImportExportObject}->MappingFormatAttributesGet(
            TemplateID => $TemplateID,
            UserID     => $Self->{UserID},
        );

        my $Counter = 0;
        MAPPINGID:
        for my $MappingID ( @{$MappingList} ) {

            # get object attribute values
            my %ObjectAttributeValues;
            for my $Item ( @{$MappingObjectAttributes} ) {

                # get object form data
                $ObjectAttributeValues{ $Item->{Key} }
                    = $Self->{LayoutObject}->ImportExportFormDataGet(
                    Item   => $Item,
                    Prefix => 'Object::' . $Counter . '::',
                    );
            }

            # save the mapping object data
            $Self->{ImportExportObject}->MappingObjectDataSave(
                MappingID         => $MappingID,
                MappingObjectData => \%ObjectAttributeValues,
                UserID            => $Self->{UserID},
            );

            # get format attribute values
            my %FormatAttributeValues;
            for my $Item ( @{$MappingFormatAttributes} ) {

                # get format form data
                $FormatAttributeValues{ $Item->{Key} }
                    = $Self->{LayoutObject}->ImportExportFormDataGet(
                    Item   => $Item,
                    Prefix => 'Format::' . $Counter . '::',
                    );
            }

            # save the mapping format data
            $Self->{ImportExportObject}->MappingFormatDataSave(
                MappingID         => $MappingID,
                MappingFormatData => \%FormatAttributeValues,
                UserID            => $Self->{UserID},
            );

            $Counter++;
        }

        MAPPINGID:
        for my $MappingID ( @{$MappingList} ) {

            # delete this mapping row
            if ( $Self->{ParamObject}->GetParam( Param => "MappingDelete::$MappingID" ) ) {
                $Self->{ImportExportObject}->MappingDelete(
                    MappingID  => $MappingID,
                    TemplateID => $TemplateID,
                    UserID     => $Self->{UserID},
                );

                next MAPPINGID;
            }

            # move mapping data row up
            if ( $Self->{ParamObject}->GetParam( Param => "MappingUp::$MappingID" ) ) {
                $Self->{ImportExportObject}->MappingUp(
                    MappingID  => $MappingID,
                    TemplateID => $TemplateID,
                    UserID     => $Self->{UserID},
                );

                next MAPPINGID;
            }

            # move mapping data row down
            if ( $Self->{ParamObject}->GetParam( Param => "MappingDown::$MappingID" ) ) {
                $Self->{ImportExportObject}->MappingDown(
                    MappingID  => $MappingID,
                    TemplateID => $TemplateID,
                    UserID     => $Self->{UserID},
                );

                next MAPPINGID;
            }
        }

        # add a new mapping row
        if ( $SubmitButton eq 'MappingAdd' ) {
            $Self->{ImportExportObject}->MappingAdd(
                TemplateID => $TemplateID,
                UserID     => $Self->{UserID},
            );
        }

        return $Self->{LayoutObject}->Redirect(
            OP => "Action=$Self->{Action};Subaction=$Subaction;TemplateID=$TemplateID",
        );
    }

    # ------------------------------------------------------------ #
    # template edit (search)
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'TemplateEdit5' ) {

        # get object list
        my $ObjectList = $Self->{ImportExportObject}->ObjectList();

        if ( !$ObjectList ) {
            $Self->{LayoutObject}->FatalError( Message => 'No object backend found!' );
            return;
        }

        # get format list
        my $FormatList = $Self->{ImportExportObject}->FormatList();

        if ( !$FormatList ) {
            $Self->{LayoutObject}->FatalError( Message => 'No format backend found!' );
            return;
        }

        # get params
        my $TemplateData = {};
        $TemplateData->{TemplateID} = $Self->{ParamObject}->GetParam( Param => 'TemplateID' );

        # get template data
        $TemplateData = $Self->{ImportExportObject}->TemplateGet(
            TemplateID => $TemplateData->{TemplateID},
            UserID     => $Self->{UserID},
        );

        if ( !$TemplateData->{TemplateID} ) {
            $Self->{LayoutObject}->FatalError( Message => 'Template not found!' );
            return;
        }

        # generate ObjectOptionStrg
        my $ObjectOptionStrg = $Self->{LayoutObject}->BuildSelection(
            Data         => $ObjectList,
            Name         => 'Object',
            SelectedID   => $TemplateData->{Object},
            PossibleNone => 1,
            Translation  => 1,
        );

        # generate FormatOptionStrg
        my $FormatOptionStrg = $Self->{LayoutObject}->BuildSelection(
            Data         => $FormatList,
            Name         => 'Format',
            SelectedID   => $TemplateData->{Format},
            PossibleNone => 1,
            Translation  => 1,
        );

        # output overview
        $Self->{LayoutObject}->Block(
            Name => 'Overview',
            Data => {
                %Param,
                ObjectOptionStrg => $ObjectOptionStrg,
                FormatOptionStrg => $FormatOptionStrg,
            },
        );

        $Self->{LayoutObject}->Block( Name => 'ActionList' );
        $Self->{LayoutObject}->Block( Name => 'ActionOverview' );

        # get search data
        my $SearchData = $Self->{ImportExportObject}->SearchDataGet(
            TemplateID => $TemplateData->{TemplateID},
            UserID     => $Self->{UserID},
        );

        # create rescrict export string
        my $RestrictExportStrg = $Self->{LayoutObject}->ImportExportFormInputCreate(
            Item => {
                Key   => 'RestrictExport',
                Input => {
                    Type => 'Checkbox',
                },
            },
            Value => scalar keys %{$SearchData},
        );

        # output list
        $Self->{LayoutObject}->Block(
            Name => 'TemplateEdit5',
            Data => {
                %{$TemplateData},
                RestrictExportStrg => $RestrictExportStrg,
            },
        );

        # get search attributes
        my $SearchAttributeList = $Self->{ImportExportObject}->SearchAttributesGet(
            TemplateID => $TemplateData->{TemplateID},
            UserID     => $Self->{UserID},
        );

        # output object attributes
        for my $Item ( @{$SearchAttributeList} ) {

            # create form input
            my $InputString = $Self->{LayoutObject}->ImportExportFormInputCreate(
                Item  => $Item,
                Value => $SearchData->{ $Item->{Key} },
            );

            # output attribute row
            $Self->{LayoutObject}->Block(
                Name => 'TemplateEdit5Element',
                Data => {
                    Name => $Item->{Name} || '',
                    InputStrg => $InputString,
                    ID        => $Item->{Key},
                },
            );
        }

        # output header and navbar
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # start template output
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminImportExport',
            Data         => \%Param,
        );

        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # template save (search)
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'TemplateSave5' ) {

        # get template id
        my $TemplateID = $Self->{ParamObject}->GetParam( Param => 'TemplateID' );

        my %Submit = (
            SubmitNext => 'Overview',
            SubmitBack => 'TemplateEdit4',
            Reload     => 'TemplateEdit5',
        );

        # get submit action
        my $Subaction = $Submit{Reload};

        PARAM:
        for my $SubmitKey ( sort keys %Submit ) {
            next PARAM if !$Self->{ParamObject}->GetParam( Param => $SubmitKey );

            $Subaction = $Submit{$SubmitKey};
            last PARAM;
        }

        # delete all search restrictions
        if ( !$Self->{ParamObject}->GetParam( Param => 'RestrictExport' ) ) {

            # delete all search data
            $Self->{ImportExportObject}->SearchDataDelete(
                TemplateID => $TemplateID,
                UserID     => $Self->{UserID},
            );

            return $Self->{LayoutObject}->Redirect(
                OP => "Action=$Self->{Action};Subaction=$Subaction;TemplateID=$TemplateID",
            );
        }

        # get search attributes
        my $SearchAttributeList = $Self->{ImportExportObject}->SearchAttributesGet(
            TemplateID => $TemplateID,
            UserID     => $Self->{UserID},
        );

        # get attribute values from form
        my %AttributeValues;
        for my $Item ( @{$SearchAttributeList} ) {

            # get form data
            $AttributeValues{ $Item->{Key} } = $Self->{LayoutObject}->ImportExportFormDataGet(
                Item => $Item,
            );

            # reload form if value is required
            if ( $Item->{Form}->{Invalid} ) {
                $Subaction = $Submit{Reload};
            }
        }

        # save the search data
        $Self->{ImportExportObject}->SearchDataSave(
            TemplateID => $TemplateID,
            SearchData => \%AttributeValues,
            UserID     => $Self->{UserID},
        );

        return $Self->{LayoutObject}->Redirect(
            OP => "Action=$Self->{Action};Subaction=$Subaction;TemplateID=$TemplateID",
        );
    }

    # ------------------------------------------------------------ #
    # template delete
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'TemplateDelete' ) {

        # get template id
        my $TemplateID = $Self->{ParamObject}->GetParam( Param => 'TemplateID' );

        # delete template from database
        $Self->{ImportExportObject}->TemplateDelete(
            TemplateID => $TemplateID,
            UserID     => $Self->{UserID},
        );

        # redirect to overview
        return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
    }

    # ------------------------------------------------------------ #
    # import information
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ImportInformation' ) {

        # get object list
        my $ObjectList = $Self->{ImportExportObject}->ObjectList();

        if ( !$ObjectList ) {
            $Self->{LayoutObject}->FatalError( Message => 'No object backend found!' );
            return;
        }

        # get format list
        my $FormatList = $Self->{ImportExportObject}->FormatList();

        if ( !$FormatList ) {
            $Self->{LayoutObject}->FatalError( Message => 'No format backend found!' );
            return;
        }

        # get params
        my $TemplateData = {};
        $TemplateData->{TemplateID} = $Self->{ParamObject}->GetParam( Param => 'TemplateID' );

        # get template data
        $TemplateData = $Self->{ImportExportObject}->TemplateGet(
            TemplateID => $TemplateData->{TemplateID},
            UserID     => $Self->{UserID},
        );

        if ( !$TemplateData->{TemplateID} ) {
            $Self->{LayoutObject}->FatalError( Message => 'Template not found!' );
            return;
        }

        # generate ObjectOptionStrg
        my $ObjectOptionStrg = $Self->{LayoutObject}->BuildSelection(
            Data         => $ObjectList,
            Name         => 'Object',
            SelectedID   => $TemplateData->{Object},
            PossibleNone => 1,
            Translation  => 1,
        );

        # generate FormatOptionStrg
        my $FormatOptionStrg = $Self->{LayoutObject}->BuildSelection(
            Data         => $FormatList,
            Name         => 'Format',
            SelectedID   => $TemplateData->{Format},
            PossibleNone => 1,
            Translation  => 1,
        );

        # output overview
        $Self->{LayoutObject}->Block(
            Name => 'Overview',
            Data => {
                %Param,
                ObjectOptionStrg => $ObjectOptionStrg,
                FormatOptionStrg => $FormatOptionStrg,
            },
        );

        $Self->{LayoutObject}->Block( Name => 'ActionList' );
        $Self->{LayoutObject}->Block( Name => 'ActionOverview' );

        # output list
        $Self->{LayoutObject}->Block(
            Name => 'ImportInformation',
            Data => {
                %{$TemplateData},
            },
        );

        # output header and navbar
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # start template output
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminImportExport',
            Data         => \%Param,
        );

        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # import
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Import' ) {

        # get params
        my $TemplateData = {};
        $TemplateData->{TemplateID} = $Self->{ParamObject}->GetParam( Param => 'TemplateID' );

        # get template data
        $TemplateData = $Self->{ImportExportObject}->TemplateGet(
            TemplateID => $TemplateData->{TemplateID},
            UserID     => $Self->{UserID},
        );

        if ( !$TemplateData->{TemplateID} ) {
            $Self->{LayoutObject}->FatalError( Message => 'Template not found!' );
            return;
        }

        # get source file
        my %SourceFile = $Self->{ParamObject}->GetUploadAll(
            Param  => 'SourceFile',
            Source => 'String',
        );

        $SourceFile{Content} ||= '';

        # import data
        my $Result = $Self->{ImportExportObject}->Import(
            TemplateID    => $TemplateData->{TemplateID},
            SourceContent => \$SourceFile{Content},
            UserID        => $Self->{UserID},
        );

        if ( !$Result ) {
            $Self->{LayoutObject}->FatalError(
                Message => 'Error occurred. Import impossible! See Syslog for details.',
            );
            return;
        }

        # output header and navbar
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # output import results
        $Self->{LayoutObject}->Block(
            Name => 'ImportResult',
            Data => {
                %{$Result},
            },
        );

        # get all return codes and collect the duplicate names
        my @DuplicateNames;
        RETURNCODE:
        for my $RetCode ( sort keys %{ $Result->{RetCode} } ) {

            # just get the duplicate name
            if ( $RetCode =~ m{ \A DuplicateName \s+ (.+) }xms ) {
                push @DuplicateNames, $1;
            }
            else {
                $Self->{LayoutObject}->Block(
                    Name => 'ImportResultReturnCode',
                    Data => {
                        ReturnCodeName  => $RetCode,
                        ReturnCodeCount => $Result->{RetCode}->{$RetCode},
                    },
                );
            }
        }

        # output duplicate names if neccessary
        if (@DuplicateNames) {

            my $DuplicateNamesString = join ', ', @DuplicateNames;

            $Self->{LayoutObject}->Block(
                Name => 'ImportResultDuplicateNames',
                Data => {
                    DuplicateNames => $DuplicateNamesString,
                },
            );
        }

        # output last processed line mumber of import file
        if ( $Result->{Failed} ) {
            $Self->{LayoutObject}->Block(
                Name => 'ImportResultLastLineNumber',
                Data => {
                    LastLineNumber => $Result->{Counter},
                },
            );
        }

        # start output
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminImportExport',
            Data         => {
                %Param,
            },
        );

        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # export
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Export' ) {

        # get params
        my $TemplateData = {};
        $TemplateData->{TemplateID} = $Self->{ParamObject}->GetParam( Param => 'TemplateID' );

        # get template data
        $TemplateData = $Self->{ImportExportObject}->TemplateGet(
            TemplateID => $TemplateData->{TemplateID},
            UserID     => $Self->{UserID},
        );

        if ( !$TemplateData->{TemplateID} ) {
            $Self->{LayoutObject}->FatalError( Message => 'Template not found!' );
            return;
        }

        # export data
        my $Result = $Self->{ImportExportObject}->Export(
            TemplateID => $TemplateData->{TemplateID},
            UserID     => $Self->{UserID},
        );

        if ( !$Result ) {
            $Self->{LayoutObject}->FatalError(
                Message => 'Error occurred. Export impossible! See Syslog for details.',
            );
            return;
        }

        my $FileContent = join "\n", @{ $Result->{DestinationContent} };

        return $Self->{LayoutObject}->Attachment(
            Type        => 'attachment',
            Filename    => 'Export.csv',
            ContentType => 'text/csv',
            Content     => $FileContent,
        );
    }

    # ------------------------------------------------------------ #
    # overview
    # ------------------------------------------------------------ #
    else {

        # get object list
        my $ObjectList = $Self->{ImportExportObject}->ObjectList();

        if ( !$ObjectList ) {
            $Self->{LayoutObject}->FatalError( Message => 'No object backend found!' );
            return;
        }

        # get format list
        my $FormatList = $Self->{ImportExportObject}->FormatList();

        if ( !$FormatList ) {
            $Self->{LayoutObject}->FatalError( Message => 'No format backend found!' );
            return;
        }

        # output overview
        $Self->{LayoutObject}->Block(
            Name => 'Overview',
            Data => {
                %Param,
            },
        );

        $Self->{LayoutObject}->Block( Name => 'ActionList' );
        $Self->{LayoutObject}->Block( Name => 'ActionAdd' );

        $Self->{LayoutObject}->Block(
            Name => 'OverviewResult',
            Data => \%Param,
        );

        # get valid list
        my %ValidList = $Self->{ValidObject}->ValidList();

        my $EmptyDatabase = 1;

        CLASS:
        for my $Object ( sort { $ObjectList->{$a} cmp $ObjectList->{$b} } keys %{$ObjectList} ) {

            # get template list
            my $TemplateList = $Self->{ImportExportObject}->TemplateList(
                Object => $Object,
                UserID => $Self->{UserID},
            );

            if ( !$TemplateList || ref $TemplateList ne 'ARRAY' || !@{$TemplateList} ) {
                next CLASS;
            }

            $EmptyDatabase = 0;

            # output list
            $Self->{LayoutObject}->Block(
                Name => 'OverviewList',
                Data => {
                    ObjectName => $ObjectList->{$Object},
                },
            );

            for my $TemplateID ( @{$TemplateList} ) {

                # get template data
                my $TemplateData = $Self->{ImportExportObject}->TemplateGet(
                    TemplateID => $TemplateID,
                    UserID     => $Self->{UserID},
                );

                # output row
                $Self->{LayoutObject}->Block(
                    Name => 'OverviewListRow',
                    Data => {
                        %{$TemplateData},
                        FormatName => $FormatList->{ $TemplateData->{Format} },
                        Valid      => $ValidList{ $TemplateData->{ValidID} },
                    },
                );
            }
        }

        # output an empty list
        if ($EmptyDatabase) {

            # output list
            $Self->{LayoutObject}->Block(
                Name => 'OverviewList',
                Data => {
                    ObjectName => 'Template List',
                },
            );
            $Self->{LayoutObject}->Block( Name => 'NoDataFoundMsg' );
        }

        # output header and navbar
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # start template output
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminImportExport',
            Data         => \%Param,
        );

        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}

sub _MaskTemplateEdit1 {
    my ( $Self, %Param ) = @_;

    my %ServerError;
    if ( $Param{ServerError} ) {
        %ServerError = %{ $Param{ServerError} };
    }

    # output overview
    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $Self->{LayoutObject}->Block( Name => 'ActionList' );
    $Self->{LayoutObject}->Block( Name => 'ActionOverview' );

    # generate ValidOptionStrg
    my %ValidList        = $Self->{ValidObject}->ValidList();
    my %ValidListReverse = reverse %ValidList;
    my $ValidOptionStrg  = $Self->{LayoutObject}->BuildSelection(
        Name       => 'ValidID',
        Data       => \%ValidList,
        SelectedID => $Param{ValidID} || $ValidListReverse{valid},
    );

    my $Class = ' Validate_Required ';

    if ( $ServerError{Name} ) {
        $Class .= 'ServerError';
    }

    $Self->{LayoutObject}->Block(
        Name => 'TemplateEdit1',
        Data => {
            %Param,
            ValidOptionStrg => $ValidOptionStrg,
            NameClass       => $Class,
        },
    );

    if ( $Param{TemplateID} ) {
        $Self->{LayoutObject}->Block(
            Name => 'EditObjectFormat',
            Data => {
                %Param,
                ObjectName => $Param{Object},
                FormatName => $Param{Format},
                }
        );
    }

    if ( $Param{New} ) {

        # get object list
        my $ObjectList = $Self->{ImportExportObject}->ObjectList();

        if ( !$ObjectList ) {
            $Self->{LayoutObject}->FatalError( Message => 'No object backend found!' );
            return;
        }

        # get format list
        my $FormatList = $Self->{ImportExportObject}->FormatList();

        if ( !$FormatList ) {
            $Self->{LayoutObject}->FatalError( Message => 'No format backend found!' );
            return;
        }

        $Class = ' Validate_Required ';

        if ( $ServerError{Object} ) {
            $Class .= 'ServerError';
        }

        # generate ObjectOptionStrg
        my $ObjectOptionStrg = $Self->{LayoutObject}->BuildSelection(
            Data         => $ObjectList,
            Name         => 'Object',
            SelectedID   => $Param{Object} || '',
            PossibleNone => 1,
            Translation  => 1,
            Class        => $Class,
        );

        $Class = ' Validate_Required ';
        if ( $ServerError{Format} ) {
            $Class .= 'ServerError';
        }

        # generate FormatOptionStrg
        my $FormatOptionStrg = $Self->{LayoutObject}->BuildSelection(
            Data         => $FormatList,
            Name         => 'Format',
            SelectedID   => $Param{Format} || '',
            PossibleNone => 1,
            Translation  => 1,
            Class        => $Class,
        );

        $Self->{LayoutObject}->Block(
            Name => 'NewObjectFormat',
            Data => {
                ObjectOption => $ObjectOptionStrg,
                FormatOption => $FormatOptionStrg,
            },
        );
    }

    # output header and navbar
    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminImportExport',
        Data         => \%Param,
    );

    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

sub _MaskTemplateEdit2 {
    my ( $Self, %Param ) = @_;

    my %ServerError;
    if ( $Param{ServerError} ) {
        %ServerError = %{ $Param{ServerError} };
    }

    my %DataTypeError;
    if ( $Param{DataTypeError} ) {
        %DataTypeError = %{ $Param{DataTypeError} };
    }

    my $TemplateID;
    if ( $Param{TemplateID} ) {
        $TemplateID = $Param{TemplateID};
    }
    else {
        $Self->{LayoutObject}->FatalError( Message => 'Needed TemplateID!' );
        return;
    }

    # get template data
    my $TemplateData;
    $TemplateData = $Self->{ImportExportObject}->TemplateGet(
        TemplateID => $TemplateID,
        UserID     => $Self->{UserID},
    );

    if ( !$TemplateData->{TemplateID} ) {
        $Self->{LayoutObject}->FatalError( Message => 'Template not found!' );
        return;
    }

    $Param{BackURL} = "Action=$Self->{Action};Subaction=TemplateEdit1;TemplateID=$TemplateID";

    # output overview
    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $Self->{LayoutObject}->Block( Name => 'ActionList' );
    $Self->{LayoutObject}->Block( Name => 'ActionOverview' );

    # output list
    $Self->{LayoutObject}->Block(
        Name => 'TemplateEdit2',
        Data => $TemplateData,
    );

    # get object attributes
    my $ObjectAttributeList = $Self->{ImportExportObject}->ObjectAttributesGet(
        TemplateID => $TemplateData->{TemplateID},
        UserID     => $Self->{UserID},
    );

    # get object data
    my $ObjectData = $Self->{ImportExportObject}->ObjectDataGet(
        TemplateID => $TemplateData->{TemplateID},
        UserID     => $Self->{UserID},
    );

    # javascript validation class per datatype
    my %JSClass;
    my %PredefinedErrorMessages;

    $JSClass{Number}                = 'Validate_Number';
    $JSClass{NumberBiggerThanZero}  = 'Validate_NumberBiggerThanZero';
    $JSClass{Integer}               = 'Validate_NumberInteger';
    $JSClass{IntegerBiggerThanZero} = 'Validate_NumberIntegerBiggerThanZero';

    $PredefinedErrorMessages{Number}                = 'number';
    $PredefinedErrorMessages{NumberBiggerThanZero}  = 'number bigger than zero';
    $PredefinedErrorMessages{Integer}               = 'integer';
    $PredefinedErrorMessages{IntegerBiggerThanZero} = 'integer bigger than zero';

    # output object attributes
    for my $Item ( @{$ObjectAttributeList} ) {

        my $Class = ' ';
        my $Value;

        my $DataTypeError;
        my $ErrorMessage;

        if ( $Item->{Input}->{Required} ) {
            $Class        = 'Validate_Required';
            $ErrorMessage = 'Element required, please insert data';
        }

        if ( $Item->{Input}->{DataType} ) {
            $Class .= " $JSClass{ $Item->{Input}->{DataType} }";
            $ErrorMessage = 'Invalid data, please insert a valid ';
            $ErrorMessage .= "$PredefinedErrorMessages{$Item->{Input}->{DataType}}";
        }

        # get data from form or from database
        # ServerError = show the wrong data in form
        # !ServerError = show database data or new fields

        if ( $Param{ServerError} || $Param{DataTypeError} ) {
            $Value = $Param{TemplateDataForm}->{ $Item->{Key} };
        }
        else {
            $Value = $ObjectData->{ $Item->{Key} };
        }

        # error area

        # prepare different data & message per error
        if ( $ServerError{ $Item->{Name} } || $DataTypeError{ $Item->{Name} } ) {
            $Class .= ' ServerError';
        }

        # create form input
        my $InputString = $Self->{LayoutObject}->ImportExportFormInputCreate(
            Item  => $Item,
            Class => $Class,
            Value => $Value,
        );

        # build id
        my $ID;
        if ( $Item->{Prefix} ) {
            $ID = "$Item->{Prefix}$Item->{Key}";
        }
        else {
            $ID = $Item->{Key};
        }

        # output attribute row
        $Self->{LayoutObject}->Block(
            Name => 'TemplateEdit2Element',
            Data => {
                Name => $Item->{Name} || '',
                InputStrg    => $InputString,
                ID           => $ID,
                ErrorMessage => $ErrorMessage,
            },
        );
    }

    # output header and navbar
    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminImportExport',
        Data         => \%Param,
    );

    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;

}

sub _MaskTemplateEdit3 {
    my ( $Self, %Param ) = @_;

    my %ServerError;
    if ( $Param{ServerError} ) {
        %ServerError = %{ $Param{ServerError} };
    }

    my $TemplateID;
    if ( $Param{TemplateID} ) {
        $TemplateID = $Param{TemplateID};
    }

    if ( !$TemplateID ) {
        $Self->{LayoutObject}->FatalError( Message => 'Template not found!' );
        return;
    }

    # get template data
    my $TemplateData;
    $TemplateData = $Self->{ImportExportObject}->TemplateGet(
        TemplateID => $TemplateID,
        UserID     => $Self->{UserID},
    );

    if ( !$TemplateData->{TemplateID} ) {
        $Self->{LayoutObject}->FatalError( Message => 'Template not found!' );
        return;
    }

    $Param{BackURL} = "Action=$Self->{Action};Subaction=TemplateEdit2;TemplateID=$TemplateID";

    # output overview
    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $Self->{LayoutObject}->Block( Name => 'ActionList' );
    $Self->{LayoutObject}->Block( Name => 'ActionOverview' );

    # output list
    $Self->{LayoutObject}->Block(
        Name => 'TemplateEdit3',
        Data => $TemplateData,
    );

    # get format attributes
    my $FormatAttributeList = $Self->{ImportExportObject}->FormatAttributesGet(
        TemplateID => $TemplateData->{TemplateID},
        UserID     => $Self->{UserID},
    );

    # get format data
    my $FormatData = $Self->{ImportExportObject}->FormatDataGet(
        TemplateID => $TemplateData->{TemplateID},
        UserID     => $Self->{UserID},
    );

    if ( !$FormatData ) {
        $Self->{LayoutObject}->FatalError( Message => 'Format not found!' );
        return;
    }

    # output format attributes
    for my $Item ( @{$FormatAttributeList} ) {

        # build id
        my $ID;
        if ( $Item->{Prefix} ) {
            $ID = "$Item->{Prefix}$Item->{Key}";
        }
        else {
            $ID = "$Item->{Key}";
        }

        my $Class = ' ';
        if ( $Item->{Input}->{Required} ) {
            $Class = 'Validate_Required ';
        }

        if ( $ServerError{ $Item->{Name} } ) {
            $Class .= ' ServerError';
        }

        # create form input
        my $InputString = $Self->{LayoutObject}->ImportExportFormInputCreate(
            Item  => $Item,
            Class => $Class,
            Value => $FormatData->{ $Item->{Key} },
        );

        # output attribute row
        $Self->{LayoutObject}->Block(
            Name => 'TemplateEdit3Element',
            Data => {
                Name => $Item->{Name} || '',
                InputStrg => $InputString,
                ID        => $ID,
            },
        );

        # output required notice
        if ( $Item->{Input}->{Required} ) {
            $Self->{LayoutObject}->Block(
                Name => 'TemplateEdit3ElementRequired',
                Data => {
                    Name => $Item->{Name} || '',
                    ID => $ID,
                },
            );
        }
    }

    # output header and navbar
    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminImportExport',
        Data         => \%Param,
    );

    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;

}

1;
