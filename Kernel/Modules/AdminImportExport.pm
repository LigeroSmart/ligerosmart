# --
# Kernel/Modules/AdminImportExport.pm - admin frontend of import export module
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: AdminImportExport.pm,v 1.22 2010-10-01 21:59:55 dz Exp $
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

use vars qw($VERSION);
$VERSION = qw($Revision: 1.22 $) [1];

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

        return $Self->{LayoutObject}->FatalError( Message => 'No object backend found!' )
            if !$ObjectList;

        # get format list
        my $FormatList = $Self->{ImportExportObject}->FormatList();

        return $Self->{LayoutObject}->FatalError( Message => 'No format backend found!' )
            if !$FormatList;

        # get params
        my $TemplateData = {};
        my $TemplateID;
        $TemplateID = $Self->{ParamObject}->GetParam( Param => 'TemplateID' );

        my $SaveContinue;
        $SaveContinue = $Self->{ParamObject}->GetParam( Param => 'SubmitNext' );

        if ( !$SaveContinue ) {

            # if needed new form
            return $Self->_MaskTemplateEdit1( New => 1, %Param )
                if ( !$TemplateID );

            # if there is template id
            # get template data
            $TemplateData = $Self->{ImportExportObject}->TemplateGet(
                TemplateID => $TemplateID,
                UserID     => $Self->{UserID},
            );

            return $Self->{LayoutObject}->FatalError( Message => 'Template not found!' )
                if !$TemplateData->{TemplateID};

            # if edit
            return $Self->_MaskTemplateEdit1( %Param, %{$TemplateData} )
                if $TemplateData->{TemplateID};
        }

        # if save & continue
        my %ServerError;

        # get all data for params and check for errors
        for my $Param (qw(Comment Object Format Name ValidID TemplateID)) {
            $TemplateData->{$Param} = $Self->{ParamObject}->GetParam( Param => $Param ) || '';
        }

        # is a new template?
        my $New;
        $New = 1 if ( !$TemplateData->{TemplateID} );

        # check needed fields
        # for new templates
        if ($New) {
            $ServerError{Object} = 1 if ( !$TemplateData->{Object} );
            $ServerError{Format} = 1 if ( !$TemplateData->{Format} );
        }

        #for all templates
        $ServerError{Name} = 1 if ( !$TemplateData->{Name} );

        # if some error
        if ( $ServerError{Format} || $ServerError{Object} || $ServerError{Name} ) {
            return
                $Self->_MaskTemplateEdit1(
                ServerError => \%ServerError,
                New         => $New,
                %{$TemplateData},
                );
        }

        # save to database
        my $Success;

        if ($New) {
            $TemplateData->{TemplateID} =
                $Self->{ImportExportObject}->TemplateAdd(
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

        return $Self->{LayoutObject}->FatalError( Message => "Can't insert/update template!" )
            if !$Success;

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

        return $Self->{LayoutObject}->FatalError( Message => 'No object backend found!' )
            if !$ObjectList;

        # get format list
        my $FormatList = $Self->{ImportExportObject}->FormatList();

        return $Self->{LayoutObject}->FatalError( Message => 'No format backend found!' )
            if !$FormatList;

        # get template id
        my $TemplateID = $Self->{ParamObject}->GetParam( Param => 'TemplateID' );

        return $Self->{LayoutObject}->FatalError( Message => 'Needed TemplateID!' )
            if !$TemplateID;

        my $SubmitNext = $Self->{ParamObject}->GetParam( Param => 'SubmitNext' );

        return $Self->_MaskTemplateEdit2( TemplateID => $TemplateID )
            if ( !$SubmitNext );

        # save starting here

        # get object attributes
        my $ObjectAttributeList = $Self->{ImportExportObject}->ObjectAttributesGet(
            TemplateID => $TemplateID,
            UserID     => $Self->{UserID},
        );

        my %AttributeValues;

        my $Error = 0;
        my %ServerError;

        # get attribute values from form
        for my $Item ( @{$ObjectAttributeList} ) {

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
        return $Self->_MaskTemplateEdit2(
            ServerError => \%ServerError,
            TemplateID  => $TemplateID
        ) if ($Error);

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

        return $Self->{LayoutObject}->FatalError( Message => 'No object backend found!' )
            if !$ObjectList;

        # get format list
        my $FormatList = $Self->{ImportExportObject}->FormatList();

        return $Self->{LayoutObject}->FatalError( Message => 'No format backend found!' )
            if !$FormatList;

        # get template id
        my $TemplateID = $Self->{ParamObject}->GetParam( Param => 'TemplateID' );

        return $Self->{LayoutObject}->FatalError( Message => 'Needed TemplateID!' )
            if !$TemplateID;

        my $SubmitNext = $Self->{ParamObject}->GetParam( Param => 'SubmitNext' );

        return $Self->_MaskTemplateEdit3( TemplateID => $TemplateID )
            if ( !$SubmitNext );

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
        return $Self->_MaskTemplateEdit3(
            ServerError => \%ServerError,
            TemplateID  => $TemplateID
        ) if ($Error);

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

        return $Self->{LayoutObject}->FatalError( Message => 'No object backend found!' )
            if !$ObjectList;

        # get format list
        my $FormatList = $Self->{ImportExportObject}->FormatList();

        return $Self->{LayoutObject}->FatalError( Message => 'No format backend found!' )
            if !$FormatList;

        # get params
        my $TemplateData = {};
        $TemplateData->{TemplateID} = $Self->{ParamObject}->GetParam( Param => 'TemplateID' );

        # get template data
        $TemplateData = $Self->{ImportExportObject}->TemplateGet(
            TemplateID => $TemplateData->{TemplateID},
            UserID     => $Self->{UserID},
        );

        return $Self->{LayoutObject}->FatalError( Message => 'Template not found!' )
            if !$TemplateData->{TemplateID};

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

        $Self->{LayoutObject}->Block( Name => 'ActionList', );
        $Self->{LayoutObject}->Block( Name => 'ActionOverview', );

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

        my $EmptyMap = 1;
        my $Counter  = 0;

        for my $MappingID ( @{$MappingList} ) {

            $EmptyMap = 0;

            # output attribute row
            $Self->{LayoutObject}->Block(
                Name => 'TemplateEdit4Element',
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
                    Prefix => 'Object::' . $Counter . '::',
                    Value  => $MappingObjectData->{ $Item->{Key} },
                    ID     => $Item->{Key} . $Counter,
                );

                # output attribute row
                $Self->{LayoutObject}->Block(
                    Name => 'TemplateEdit4ElementObject',
                    Data => {
                        Name      => $Item->{Name},
                        ID        => 'Object::' . $Counter . '::' . $Item->{Key},
                        InputStrg => $InputString,
                        Counter   => $Counter,
                    },
                );
            }

            for my $Item ( @{$MappingFormatAttributes} ) {

                # create form input
                my $InputString = $Self->{LayoutObject}->ImportExportFormInputCreate(
                    Item   => $Item,
                    Prefix => 'Format::' . $Counter . '::',
                    Value  => $MappingFormatData->{ $Item->{Key} },
                );

                # output attribute row
                $Self->{LayoutObject}->Block(
                    Name => 'TemplateEdit4ElementObjectColumn',
                    Data => {
                        Name      => $Item->{Name},
                        InputStrg => $InputString,
                        Counter   => $Counter,
                    },
                );
            }

            $Counter++;
        }

        # output an empty list
        if ($EmptyMap) {

            # output list
            $Self->{LayoutObject}->Block( Name => 'TemplateEdit4NoMapFound', );
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
        for my $SubmitKey ( keys %Submit ) {
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
            OP => "Action=$Self->{Action}&Subaction=$Subaction&TemplateID=$TemplateID",
        );
    }

    # ------------------------------------------------------------ #
    # template edit (search)
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'TemplateEdit5' ) {

        # get object list
        my $ObjectList = $Self->{ImportExportObject}->ObjectList();

        return $Self->{LayoutObject}->FatalError( Message => 'No object backend found!' )
            if !$ObjectList;

        # get format list
        my $FormatList = $Self->{ImportExportObject}->FormatList();

        return $Self->{LayoutObject}->FatalError( Message => 'No format backend found!' )
            if !$FormatList;

        # get params
        my $TemplateData = {};
        $TemplateData->{TemplateID} = $Self->{ParamObject}->GetParam( Param => 'TemplateID' );

        # get template data
        $TemplateData = $Self->{ImportExportObject}->TemplateGet(
            TemplateID => $TemplateData->{TemplateID},
            UserID     => $Self->{UserID},
        );

        return $Self->{LayoutObject}->FatalError( Message => 'Template not found!' )
            if !$TemplateData->{TemplateID};

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

        $Self->{LayoutObject}->Block( Name => 'ActionList', );
        $Self->{LayoutObject}->Block( Name => 'ActionOverview', );

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
        for my $SubmitKey ( keys %Submit ) {
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
                OP => "Action=$Self->{Action}&Subaction=$Subaction&TemplateID=$TemplateID",
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
            OP => "Action=$Self->{Action}&Subaction=$Subaction&TemplateID=$TemplateID",
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

        return $Self->{LayoutObject}->FatalError( Message => 'No object backend found!' )
            if !$ObjectList;

        # get format list
        my $FormatList = $Self->{ImportExportObject}->FormatList();

        return $Self->{LayoutObject}->FatalError( Message => 'No format backend found!' )
            if !$FormatList;

        # get params
        my $TemplateData = {};
        $TemplateData->{TemplateID} = $Self->{ParamObject}->GetParam( Param => 'TemplateID' );

        # get template data
        $TemplateData = $Self->{ImportExportObject}->TemplateGet(
            TemplateID => $TemplateData->{TemplateID},
            UserID     => $Self->{UserID},
        );

        return $Self->{LayoutObject}->FatalError( Message => 'Template not found!' )
            if !$TemplateData->{TemplateID};

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

        $Self->{LayoutObject}->Block( Name => 'ActionList', );
        $Self->{LayoutObject}->Block( Name => 'ActionOverview', );

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

        return $Self->{LayoutObject}->FatalError( Message => 'Template not found!' )
            if !$TemplateData->{TemplateID};

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

        return $Self->{LayoutObject}->FatalError(
            Message => 'Error occurred. Import impossible! See Syslog for details.',
        ) if !$Result;

        return $Self->{LayoutObject}->Redirect(
            OP =>
                "Action=$Self->{Action}&Subaction=Overview&TemplateID=$TemplateData->{TemplateID}",
        );
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

        return $Self->{LayoutObject}->FatalError( Message => 'Template not found!' )
            if !$TemplateData->{TemplateID};

        # export data
        my $Result = $Self->{ImportExportObject}->Export(
            TemplateID => $TemplateData->{TemplateID},
            UserID     => $Self->{UserID},
        );

        return $Self->{LayoutObject}->FatalError(
            Message => 'Error occurred. Export impossible! See Syslog for details.',
        ) if !$Result;

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

        return $Self->{LayoutObject}->FatalError( Message => 'No object backend found!' )
            if !$ObjectList;

        # get format list
        my $FormatList = $Self->{ImportExportObject}->FormatList();

        return $Self->{LayoutObject}->FatalError( Message => 'No format backend found!' )
            if !$FormatList;

        # output overview
        $Self->{LayoutObject}->Block(
            Name => 'Overview',
            Data => {
                %Param,
                }
        );

        $Self->{LayoutObject}->Block( Name => 'ActionList', );
        $Self->{LayoutObject}->Block( Name => 'ActionAdd', );

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
    my %ServerError = %{ $Param{ServerError} } if ( $Param{ServerError} );

    # output overview
    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $Self->{LayoutObject}->Block( Name => 'ActionList', );
    $Self->{LayoutObject}->Block( Name => 'ActionOverview', );

    # generate ValidOptionStrg
    my %ValidList        = $Self->{ValidObject}->ValidList();
    my %ValidListReverse = reverse %ValidList;
    my $ValidOptionStrg  = $Self->{LayoutObject}->BuildSelection(
        Name       => 'ValidID',
        Data       => \%ValidList,
        SelectedID => $Param{ValidID} || $ValidListReverse{valid},
    );

    my $Class = ' Validate_Required ';
    $Class .= 'ServerError' if ( $ServerError{Name} );
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

        return $Self->{LayoutObject}->FatalError( Message => 'No object backend found!' )
            if !$ObjectList;

        # get format list
        my $FormatList = $Self->{ImportExportObject}->FormatList();

        return $Self->{LayoutObject}->FatalError( Message => 'No format backend found!' )
            if !$FormatList;

        $Class = ' Validate_Required ';
        $Class .= 'ServerError' if ( $ServerError{Object} );

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
        $Class .= 'ServerError' if ( $ServerError{Format} );

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
                }
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
    my %ServerError = %{ $Param{ServerError} } if ( $Param{ServerError} );

    # get object list
    my $ObjectList = $Self->{ImportExportObject}->ObjectList();

    return $Self->{LayoutObject}->FatalError( Message => 'No object backend found!' )
        if !$ObjectList;

    # get format list
    my $FormatList = $Self->{ImportExportObject}->FormatList();

    return $Self->{LayoutObject}->FatalError( Message => 'No format backend found!' )
        if !$FormatList;

    my $TemplateID;
    $TemplateID = $Param{TemplateID} if ( $Param{TemplateID} );

    return $Self->{LayoutObject}->FatalError( Message => 'Template not found!' )
        if !$TemplateID;

    # get template data
    my $TemplateData;
    $TemplateData = $Self->{ImportExportObject}->TemplateGet(
        TemplateID => $TemplateID,
        UserID     => $Self->{UserID},
    );

    return $Self->{LayoutObject}->FatalError( Message => 'Template not found!' )
        if !$TemplateData->{TemplateID};

    # output overview
    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => {
            %Param,
        },
    );

    $Self->{LayoutObject}->Block( Name => 'ActionList', );
    $Self->{LayoutObject}->Block( Name => 'ActionOverview', );

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

    # output object attributes
    for my $Item ( @{$ObjectAttributeList} ) {

        my $Class = '';
        $Class = 'Validate_Required ' if ( $Item->{Input}->{Required} );
        $Class .= 'ServerError' if ( $ServerError{ $Item->{Name} } );

        # create form input
        my $InputString = $Self->{LayoutObject}->ImportExportFormInputCreate(
            Item  => $Item,
            Class => $Class,
            Value => $ObjectData->{ $Item->{Key} },
        );

        # build id
        my $Id;
        $Id = ( $Item->{Prefix} ) ? "$Item->{Prefix}$Item->{Key}" : $Item->{Key};

        # output attribute row
        $Self->{LayoutObject}->Block(
            Name => 'TemplateEdit2Element',
            Data => {
                Name => $Item->{Name} || '',
                InputStrg => $InputString,
                ID        => $Id,
            },
        );

        # output required notice
        if ( $Item->{Input}->{Required} ) {
            $Self->{LayoutObject}->Block(
                Name => 'TemplateEdit2ElementRequired',
                Data => {
                    Name => $Item->{Name} || '',
                    ID => $Id,
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

sub _MaskTemplateEdit3 {
    my ( $Self, %Param ) = @_;
    my %ServerError = %{ $Param{ServerError} } if ( $Param{ServerError} );

    # get object list
    my $ObjectList = $Self->{ImportExportObject}->ObjectList();

    return $Self->{LayoutObject}->FatalError( Message => 'No object backend found!' )
        if !$ObjectList;

    # get format list
    my $FormatList = $Self->{ImportExportObject}->FormatList();

    return $Self->{LayoutObject}->FatalError( Message => 'No format backend found!' )
        if !$FormatList;

    my $TemplateID;
    $TemplateID = $Param{TemplateID} if ( $Param{TemplateID} );

    return $Self->{LayoutObject}->FatalError( Message => 'Template not found!' )
        if !$TemplateID;

    # get template data
    my $TemplateData;
    $TemplateData = $Self->{ImportExportObject}->TemplateGet(
        TemplateID => $TemplateID,
        UserID     => $Self->{UserID},
    );

    return $Self->{LayoutObject}->FatalError( Message => 'Template not found!' )
        if !$TemplateData->{TemplateID};

    # output overview
    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => {
            %Param,
        },
    );

    $Self->{LayoutObject}->Block( Name => 'ActionList', );
    $Self->{LayoutObject}->Block( Name => 'ActionOverview', );

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

    # output format attributes
    for my $Item ( @{$FormatAttributeList} ) {

        # build id
        my $Id;
        $Id = ( $Item->{Prefix} ) ? "$Item->{Prefix}$Item->{Key}" : $Item->{Key};

        my $Class = ' ';
        $Class = 'Validate_Required ' if ( $Item->{Input}->{Required} );
        $Class = 'ServerError'        if ( $ServerError{ $Item->{Name} } );

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
                ID        => $Id,
            },
        );

        # output required notice
        if ( $Item->{Input}->{Required} ) {
            $Self->{LayoutObject}->Block(
                Name => 'TemplateEdit3ElementRequired',
                Data => {
                    Name => $Item->{Name} || '',
                    ID => $Id,
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
