# --
# Kernel/Modules/AgentFAQ.pm - faq module
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AgentFAQ.pm,v 1.15 2008-07-07 11:00:30 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::AgentFAQ;

use strict;
use warnings;

use Kernel::System::FAQ;
use Kernel::System::LinkObject;
use Kernel::Modules::FAQ;
use Kernel::System::User;
use Kernel::System::Group;
use Kernel::System::Valid;

use vars qw($VERSION @ISA);
$VERSION = qw($Revision: 1.15 $) [1];

@ISA = qw(Kernel::Modules::FAQ);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    # ********************************************************** #
    my $Self = new Kernel::Modules::FAQ(%Param);
    bless( $Self, $Type );

    # interface settings
    # ********************************************************** #
    $Self->{Interface} = $Self->{FAQObject}->StateTypeGet(
        Name => 'internal'
    );
    $Self->{InterfaceStates} = $Self->{FAQObject}->StateTypeList(
        Types => [ 'internal', 'external', 'public' ]
    );

    # check needed Objects
    # ********************************************************** #
    for (qw(SessionObject)) {
        $Self->{LayoutObject}->FatalError( Message => "Got no $_!" ) if ( !$Self->{$_} );
    }
    $Self->{ValidObject} = Kernel::System::Valid->new(%Param);
    $Self->{UserObject}  = Kernel::System::User->new(%Param);
    $Self->{GroupObject} = Kernel::System::Group->new(%Param);
    return $Self;
}

sub Run {

    my ( $Self, %Param ) = @_;

    # Paramter
    my @Params   = ();
    my %GetParam = ();
    my %Frontend = ();
    my %Data     = ();

    # Output
    my $Output      = '';
    my $Header      = '';
    my $HeaderTitle = '';
    my $HeaderType  = '';
    my $Navigation  = '';
    my $Notify      = '';
    my $Content     = '';
    my $Footer      = '';
    my $FooterType  = '';

    my $DefaultHeader     = '';
    my $DefaultNavigation = '';
    my $DefaultNotify     = '';
    my $DefaultContent    = '';
    my $DefaultFooter     = '';

    # manage parameters
    # ********************************************************** #
    @Params = qw(ItemID ID Number Name Comment CategoryID ParentID StateID LanguageID Title UserID
        Field1 Field2 Field3 Field4 Field5 Field6 FreeKey1 FreeKey2 FreeKey3 Keywords Order Sort Nav);
    for (@Params) {
        $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ ) || '';
    }

    # navigation ON/OFF
    # ********************************************************** #
    $HeaderType = $Self->{LastFAQNav};
    if ( $GetParam{Nav} eq 'Normal' ) {
        $HeaderType = '';
    }
    elsif ( $GetParam{Nav} eq 'None' || $Self->{LastFAQNav} ) {
        $HeaderType = 'Small';
        $Navigation = ' ';
        $Notify     = ' ';
    }
    else {
        $HeaderType = '';
    }

    # store nav param
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastFAQNav',
        Value     => $HeaderType,
    );

    # view small
    #$HeaderType = $Self->{LastFAQNav} || '';
    #my $Nav = $Self->{ParamObject}->GetParam(Param => 'Nav') || '';

    # output
    $Output = '';

    # store search params
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastFAQWhat',
        Value     => $Param{What},
    );
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastFAQKeyword',
        Value     => $Param{Keyword},
    );

    # ---------------------------------------------------------- #
    # deliver OpenSearchDescription
    # ---------------------------------------------------------- #
    if ( $Self->{Subaction} eq 'OpenSearchDescription' ) {
        my $Output = $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentFAQOpenSearchDescription',
            Data         => {%Param},
        );
        return $Self->{LayoutObject}->Attachment(
            Filename    => 'OpenSearchDescription.xml',
            ContentType => "text/xml",
            Content     => $Output,
            Type        => 'inline',
        );
    }

    # ---------------------------------------------------------- #
    # language add
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'Language' ) {

        # permission check
        if ( !$Self->{AccessRw} ) {
            return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
        }

        # dtl
        $Frontend{Headline}       = 'Add';
        $Frontend{AddLink}        = '(Click here to add)';
        $Frontend{Subaction}      = 'LanguageAdd';
        $Frontend{LanguageOption} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => { $Self->{FAQObject}->LanguageList( UserID => $Self->{UserID} ) },
            Size => 10,
            Name => 'ID',
            HTMLQuote           => 1,
            LanguageTranslation => 0,
        );

        $Self->{LayoutObject}->Block(
            Name => 'Language',
            Data => { %Param, %Frontend },
        );

    }

    # ---------------------------------------------------------- #
    # language add action
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'LanguageAction' ) {

        # permission check
        if ( !$Self->{AccessRw} ) {
            return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
        }

        #get Data
        my %ParamData = ();
        $ParamData{UserID} = $Self->{UserID};
        for (qw(Name)) {
            if ( !( $ParamData{$_} = $Self->{ParamObject}->GetParam( Param => $_ ) ) ) {
                $Self->{LayoutObject}->FatalError( Message => "Need $_ !" );
            }
        }

        # db action
        if ( !$Self->{FAQObject}->LanguageDuplicateCheck( Name => $ParamData{Name} ) ) {
            if ( $Self->{FAQObject}->LanguageAdd( %ParamData, UserID => $Self->{UserID} ) ) {
                return $Self->{LayoutObject}
                    ->Redirect( OP => "Action=AgentFAQ&Subaction=Language" );
            }
            else {
                return $Self->{LayoutObject}->ErrorScreen();
            }
        }
        else {
            $Self->{LayoutObject}
                ->FatalError( Message => "Language '$ParamData{Name}' already exists!" );
        }

    }

    # ---------------------------------------------------------- #
    # language update
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'LanguageChange' ) {

        # permission check
        if ( !$Self->{AccessRw} ) {
            return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
        }

        #get Data
        my %ParamData = ();
        for (qw(ID)) {
            if ( !( $ParamData{$_} = $Self->{ParamObject}->GetParam( Param => $_ ) ) ) {
                $Self->{LayoutObject}->FatalError( Message => "Need $_ !" );
            }
        }

        # db action
        my %LanguageData
            = $Self->{FAQObject}->LanguageGet( ID => $ParamData{ID}, UserID => $Self->{UserID} );
        if ( !%LanguageData ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        # dtl
        $Frontend{Headline}       = 'Change';
        $Frontend{AddLink}        = '';
        $Frontend{Subaction}      = 'LanguageChange';
        $Frontend{LanguageOption} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => { $Self->{FAQObject}->LanguageList( UserID => $Self->{UserID} ) },
            Size => 10,
            Name => 'ID',
            SelectedID          => $LanguageData{LanguageID},
            HTMLQuote           => 1,
            LanguageTranslation => 0,
        );

        $Self->{LayoutObject}->Block(
            Name => 'Language',
            Data => { %Param, %Frontend, %LanguageData },
        );

        $Content = $Self->{LayoutObject}->Output(
            Data => { %Param, %Frontend, %LanguageData },
            TemplateFile => 'AgentFAQ',
        );

    }

    # ---------------------------------------------------------- #
    # language update action
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'LanguageChangeAction' ) {

        # permission check
        if ( !$Self->{AccessRw} ) {
            return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
        }

        # get Data
        my %ParamData = ();
        $ParamData{UserID} = $Self->{UserID};
        for (qw(ID Name)) {
            if ( !( $ParamData{$_} = $Self->{ParamObject}->GetParam( Param => $_ ) ) ) {
                $Self->{LayoutObject}->FatalError( Message => "Need $_ !" );
            }
        }

        # duplicate check
        if (
            !$Self->{FAQObject}
            ->LanguageDuplicateCheck( Name => $ParamData{Name}, ID => $ParamData{ID} )
            )
        {

            # db action
            if ( !$Self->{FAQObject}->LanguageUpdate( %ParamData, UserID => $Self->{UserID} ) ) {
                return $Self->{LayoutObject}
                    ->Redirect( OP => "Action=AgentFAQ&Subaction=Language" );
            }
            else {
                return $Self->{LayoutObject}->ErrorScreen();
            }
        }
        else {
            $Self->{LayoutObject}
                ->FatalError( Message => "Language '$ParamData{Name}' already exists!" );
        }

    }

    # ---------------------------------------------------------- #
    # category update
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'CategoryChange' ) {

        @Params = qw(CategoryID);

        # permission check
        if ( !$Self->{AccessRw} ) {
            return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
        }

        # ceck parameters
        my %ParamData = ();
        for (qw(CategoryID)) {
            if ( !( $ParamData{$_} = $Self->{ParamObject}->GetParam( Param => $_ ) ) ) {
                $Self->{LayoutObject}->FatalError( Message => "Need $_ !" );
            }
        }

        # db action
        my %CategoryData = $Self->{FAQObject}->CategoryGet(
            CategoryID => $ParamData{CategoryID},
            UserID     => $Self->{UserID},
        );
        if ( !%CategoryData ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        # dtl
        $Frontend{CategoryLongOption} = $Self->{LayoutObject}->AgentFAQCategoryListOption(
            CategoryList => { %{ $Self->{FAQObject}->CategoryList( UserID => $Self->{UserID} ) } },
            Size         => 10,
            Name         => 'CategoryID',
            SelectedID   => $CategoryData{CategoryID},
            HTMLQuote    => 1,
            LanguageTranslation => 0,
        );
        $Frontend{CategoryOption} = $Self->{LayoutObject}->AgentFAQCategoryListOption(
            CategoryList => { %{ $Self->{FAQObject}->CategoryList( UserID => $Self->{UserID} ) } },
            Size         => 1,
            Name         => 'ParentID',
            SelectedID   => $CategoryData{ParentID},
            HTMLQuote    => 1,
            LanguageTranslation => 0,
            RootElement         => 1,
        );

        # build ValidID string
        $Frontend{ValidOption} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data       => { $Self->{ValidObject}->ValidList() },
            Name       => 'ValidID',
            SelectedID => $CategoryData{ValidID},
        );
        my $SelectedGroups = $Self->{FAQObject}->GetCategoryGroup(
            CategoryID => $ParamData{CategoryID},
        );
        my %Groups = $Self->{GroupObject}->GroupList( Valid => 1 );
        $Frontend{GroupOption} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data               => \%Groups,
            Name               => 'PermissionGroups',
            Size               => 12,
            Multiple           => 1,
            SelectedIDRefArray => $SelectedGroups,
        );
        $Param{Headline}      = 'Update';
        $Param{FormSubaction} = 'CategoryChangeAction';
        $Self->{LayoutObject}->Block(
            Name => 'Category',
            Data => { %Param, %Frontend, %CategoryData },
        );
        $Self->{LayoutObject}->Block(
            Name => 'CategoryAddLink',
            Data => {%Param},
        );

    }

    # ---------------------------------------------------------- #
    # category update action
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'CategoryChangeAction' ) {

        # permission check
        if ( !$Self->{AccessRw} ) {
            return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
        }

        # check parameters
        my %ParamData      = ();
        my @RequiredParams = qw(CategoryID Name Comment);
        my @Params         = qw(ParentID ValidID);
        for (@RequiredParams) {
            $ParamData{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
            if ( !$ParamData{$_} ) {
                return $Self->{LayoutObject}->FatalError( Message => "Need $_!" );
            }
        }
        for (@Params) {
            $ParamData{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
            if ( !defined( $ParamData{$_} ) ) {
                return $Self->{LayoutObject}->FatalError( Message => "Need $_!" );
            }
        }

        # duplicate check
        if (
            !$Self->{FAQObject}->CategoryDuplicateCheck(
                Name     => $ParamData{Name},
                ID       => $ParamData{CategoryID},
                ParentID => $ParamData{ParentID}
            )
            )
        {

            # db action
            if ( $Self->{FAQObject}->CategoryUpdate( %ParamData, UserID => $Self->{UserID} ) ) {

                # set categorygroups
                my @PermissionGroups
                    = $Self->{ParamObject}->GetArray( Param => "PermissionGroups" );
                $Self->{FAQObject}->SetCategoryGroup(
                    CategoryID => $ParamData{CategoryID},
                    GroupIDs   => \@PermissionGroups,
                );
                return $Self->{LayoutObject}
                    ->Redirect( OP => "Action=AgentFAQ&Subaction=Category" );
            }
            else {
                return $Self->{LayoutObject}->ErrorScreen();
            }
        }
        else {
            $Self->{LayoutObject}
                ->FatalError( Message => "Category '$ParamData{Name}' already exists!" );
        }
    }

    # ---------------------------------------------------------- #
    # category add
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'Category' ) {

        # permission check

        if ( !$Self->{AccessRw} ) {
            return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
        }

        # dtl

        $Frontend{CategoryLongOption} = $Self->{LayoutObject}->AgentFAQCategoryListOption(
            CategoryList => { %{ $Self->{FAQObject}->CategoryList( UserID => $Self->{UserID} ) } },
            Size         => 10,
            Name         => 'CategoryID',
            HTMLQuote    => 1,
            LanguageTranslation => 0,
        );
        $Frontend{CategoryOption} = $Self->{LayoutObject}->AgentFAQCategoryListOption(
            CategoryList => { %{ $Self->{FAQObject}->CategoryList( UserID => $Self->{UserID} ) } },
            Size         => 1,
            Name         => 'ParentID',
            HTMLQuote    => 1,
            LanguageTranslation => 0,
            RootElement         => 1,
        );

        # build ValidID string
        $Frontend{ValidOption} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => { $Self->{ValidObject}->ValidList() },
            Name => 'ValidID',
        );
        $Param{Headline}      = 'Add';
        $Param{FormSubaction} = 'CategoryAddAction';

        # group permission
        my %Groups = $Self->{GroupObject}->GroupList( Valid => 1 );
        $Frontend{GroupOption} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data     => \%Groups,
            Name     => 'PermissionGroups',
            Size     => 12,
            Multiple => 1,
        );
        $Self->{LayoutObject}->Block(
            Name => 'Category',
            Data => { %Param, %Frontend },
        );

    }

    # ---------------------------------------------------------- #
    # category add action
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'CategoryAddAction' ) {

        # permission check
        if ( !$Self->{AccessRw} ) {
            return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
        }

        # check parameters
        my %ParamData      = ();
        my @RequiredParams = qw(Name Comment);
        my @Params         = qw(ParentID ValidID);
        for (@RequiredParams) {
            $ParamData{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
            if ( !$ParamData{$_} ) {
                return $Self->{LayoutObject}->FatalError( Message => "Need $_" );
            }
        }
        for (@Params) {
            $ParamData{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
            if ( !defined( $ParamData{$_} ) ) {
                return $Self->{LayoutObject}->FatalError( Message => "Need $_" );
            }
        }

        # duplicate check
        if (
            !$Self->{FAQObject}
            ->CategoryDuplicateCheck( Name => $ParamData{Name}, ParentID => $ParamData{ParentID} )
            )
        {
            my $CategoryID
                = $Self->{FAQObject}->CategoryAdd( %ParamData, UserID => $Self->{UserID} );
            if ($CategoryID) {

                # set categorygroups
                my @PermissionGroups
                    = $Self->{ParamObject}->GetArray( Param => "PermissionGroups" );
                $Self->{FAQObject}->SetCategoryGroup(
                    CategoryID => $CategoryID,
                    GroupIDs   => \@PermissionGroups,
                );
                return $Self->{LayoutObject}
                    ->Redirect( OP => "Action=AgentFAQ&Subaction=Category" );
            }
            else {
                return $Self->{LayoutObject}->ErrorScreen();
            }
        }
        else {
            $Self->{LayoutObject}
                ->FatalError( Message => "Category '$ParamData{Name}' already exists!" );
        }
    }

    # ---------------------------------------------------------- #
    # item add
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'Add' ) {

        # permission check
        if ( !$Self->{AccessRw} ) {
            return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
        }

        # check parameters

        # dtl
        $Frontend{LanguageOption} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data                => { $Self->{FAQObject}->LanguageList() },
            Name                => 'LanguageID',
            LanguageTranslation => 0,
            Selected            => $Self->{UserLanguage},
        );

        my $Categories = $Self->{FAQObject}->GetUserCategories(
            UserID => $Self->{UserID},
            Type   => 'rw'
        );
        $Frontend{CategoryOption} = $Self->{LayoutObject}->AgentFAQCategoryListOption(
            CategoryList        => $Categories,
            Name                => 'CategoryID',
            LanguageTranslation => 0,
        );

        $Frontend{StateOption} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data     => { $Self->{FAQObject}->StateList() },
            Name     => 'StateID',
            Selected => 'internal (agent)',
        );

        $Self->{LayoutObject}->Block(
            Name => 'Add',
            Data => { %Param, %Frontend },
        );

        # fields
        $Self->_GetItemFields(
            ItemData => {}
        );

    }

    # ---------------------------------------------------------- #
    # item add action
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'AddAction' ) {

        @Params = qw(Title);

        # permission check
        if ( !$Self->{AccessRw} ) {
            return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
        }

        # check parameters
        my %ParamData      = ();
        my @RequiredParams = qw(CategoryID Title);
        my @Params
            = qw(StateID LanguageID Field1 Field2 Field3 Field4 Field5 Field6 Keywords Title);
        for (@RequiredParams) {
            $ParamData{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
            if ( !$ParamData{$_} ) {
                return $Self->{LayoutObject}->FatalError( Message => "Need $_!" );
            }
        }
        for (@Params) {
            $ParamData{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
        }

        # insert item
        my $ItemID = $Self->{FAQObject}->FAQAdd(
            %ParamData,
            UserID => $Self->{UserID}
        );

        if ( !$ItemID ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        # get submit attachment
        my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
            Param  => 'file_upload',
            Source => 'String',
        );
        if (%UploadStuff) {
            $Self->{FAQObject}->AttachmentAdd(
                ItemID => $ItemID,
                %UploadStuff,
            );
        }

        return $Self->{LayoutObject}->Redirect(
            OP => "Action=$Self->{Action}&Subaction=View&ItemID=$ItemID",
        );
    }

    # ---------------------------------------------------------- #
    # item update
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'Update' ) {

        @Params = qw(ItemID);

        # permission check
        if ( !$Self->{AccessRw} ) {
            return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
        }

        # check parameters
        my %ParamData      = ();
        my @RequiredParams = qw(CategoryID ItemID);
        for (@RequiredParams) {
            $ParamData{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
            if ( !$ParamData{$_} ) {
                return $Self->{LayoutObject}->FatalError( Message => "Need $_!" );
            }
        }

        # db action
        my %ItemData = $Self->{FAQObject}->FAQGet(
            ItemID => $ParamData{ItemID},
            UserID => $Self->{UserID},
        );
        if ( !%ItemData ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        # dtl
        $Frontend{LanguageOption} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data                => { $Self->{FAQObject}->LanguageList() },
            Name                => 'LanguageID',
            LanguageTranslation => 0,
            SelectedID          => $ItemData{LanguageID},
        );
        my $Categories = $Self->{FAQObject}->GetUserCategories(
            UserID => $Self->{UserID},
            Type   => 'rw'
        );
        $Frontend{CategoryOption} = $Self->{LayoutObject}->AgentFAQCategoryListOption(
            CategoryList        => $Categories,
            Name                => 'CategoryID',
            LanguageTranslation => 0,
            SelectedID          => $ItemData{CategoryID},
        );
        $Frontend{StateOption} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data       => { $Self->{FAQObject}->StateList() },
            Name       => 'StateID',
            SelectedID => $ItemData{StateID},
        );
        $Self->{LayoutObject}->Block(
            Name => 'Update',
            Data => { %ItemData, %Frontend },
        );

        # add attachments
        my @AttachmentIndex = $Self->{FAQObject}->AttachmentIndex(
            ItemID => $ParamData{ItemID},
        );
        for my $Attachment (@AttachmentIndex) {
            $Self->{LayoutObject}->Block(
                Name => 'UpdateAttachment',
                Data => { %ItemData, %{$Attachment} },
            );
        }

        # fields
        $Self->_GetItemFields(
            ItemData => \%ItemData
        );

        # output
        $HeaderTitle = 'Edit';
        $Header = $Self->{LayoutObject}->Header( Type => $HeaderType, Title => $HeaderTitle );

    }

    # ---------------------------------------------------------- #
    # item update action
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'UpdateAction' ) {

        @Params = qw(ItemID Title CategoryID StateID LanguageID);

        # permission check

        if ( !$Self->{AccessRw} ) {
            return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
        }

        # check parameters
        my %ParamData      = ();
        my @RequiredParams = qw(Title CategoryID);
        my @Params = qw(ItemID StateID LanguageID Field1 Field2 Field3 Field4 Field5 Field6 Keywords
            AttachmentUpload AttachmentDelete0 AttachmentDelete1 AttachmentDelete2 AttachmentDelete3 AttachmentDelete4
            AttachmentDelete5 AttachmentDelete6 AttachmentDelete7 AttachmentDelete8
            AttachmentDelete9 AttachmentDelete10 AttachmentDelete11 AttachmentDelete12
            AttachmentDelete13 AttachmentDelete14 AttachmentDelete15 AttachmentDelete16);

        for (@RequiredParams) {
            $ParamData{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
            if ( !$ParamData{$_} ) {
                return $Self->{LayoutObject}->FatalError( Message => "Need $_!" );
            }
        }
        for (@Params) {
            $ParamData{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
        }

        my $Redirect = 1;

        # attachment delete
        for ( 0 .. 16 ) {
            if ( $ParamData{"AttachmentDelete$_"} ) {
                $Redirect = 0;
                $Self->{FAQObject}->AttachmentDelete(
                    ItemID => $ParamData{ItemID},
                    FileID => $_,
                );
            }
        }

        # attachment upload
        if ( $ParamData{AttachmentUpload} ) {
            $Redirect = 0;
            my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
                Param  => "file_upload",
                Source => 'string',
            );
            $Self->{FAQObject}->AttachmentAdd(
                ItemID => $ParamData{ItemID},
                %UploadStuff,
            );
        }

        # update item
        my $Update = $Self->{FAQObject}->FAQUpdate(
            %ParamData,
            UserID => $Self->{UserID},
        );

        if ( !$Update ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        if ($Redirect) {
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=$Self->{Action}&Subaction=View&ItemID=$GetParam{ItemID}",
            );
        }
        else {
            return $Self->{LayoutObject}->Redirect(
                OP =>
                    "Action=$Self->{Action}&Subaction=Update&ItemID=$GetParam{ItemID}&CategoryID=$GetParam{CategoryID}",
            );
        }
    }

    # ---------------------------------------------------------- #
    # delete item screen
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'Delete' ) {

        @Params = qw(ItemID);

        # permission check

        if ( !$Self->{AccessRw} ) {
            return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
        }

        # check parameters
        my %ParamData      = ();
        my @RequiredParams = qw(CategoryID ItemID);
        for (@RequiredParams) {
            $ParamData{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
            if ( !$ParamData{$_} ) {
                return $Self->{LayoutObject}->FatalError( Message => "Need $_!" );
            }
        }
        for (@Params) {
            $ParamData{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
        }

        # db action

        my %ItemData
            = $Self->{FAQObject}->FAQGet( ItemID => $ParamData{ItemID}, UserID => $Self->{UserID} );
        if ( !%ItemData ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        # dtl

        $Self->{LayoutObject}->Block(
            Name => 'Delete',
            Data => {%ItemData},
        );

        # output
        $HeaderTitle = 'Delete';
        $Header = $Self->{LayoutObject}->Header( Type => $HeaderType, Title => $HeaderTitle );
    }

    # ---------------------------------------------------------- #
    # item delete action
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'DeleteAction' ) {

        @Params = qw(ItemID);

        # permission check
        if ( !$Self->{AccessRw} ) {
            return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
        }

        # check parameters
        my %ParamData      = ();
        my @RequiredParams = qw(CategoryID ItemID);
        for (@RequiredParams) {
            $ParamData{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
            if ( !$ParamData{$_} ) {
                return $Self->{LayoutObject}->FatalError( Message => "Need $_!" );
            }
        }

        # db action
        my %ItemData = $Self->{FAQObject}->FAQGet(
            ItemID => $ParamData{ItemID},
            UserID => $Self->{UserID},
        );
        if ( !%ItemData ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        my $Delete = $Self->{FAQObject}->FAQDelete(
            %ItemData,
            UserID => $Self->{UserID},
        );

        if ( !$Delete ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        return $Self->{LayoutObject}->Redirect(
            OP => "Action=$Self->{Action}&Subaction=Explorer&CategoryID=$ParamData{CategoryID}",
        );
    }

    # ---------------------------------------------------------- #
    # download item
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'Download' ) {
        @Params = qw(ItemID FileID);

        # permission check
        if ( !$Self->{AccessRo} ) {
            return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
        }

        # manage parameters
        for (@Params) {
            if ( !defined( $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ ) ) ) {
                return $Self->{LayoutObject}->FatalError( Message => "Need $_" );
            }
        }

        # db action
        my %ItemData = $Self->{FAQObject}->FAQGet(
            ItemID => $GetParam{ItemID},
            UserID => $Self->{UserID},
        );

        if ( !%ItemData ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        # get attachments
        my %File = $Self->{FAQObject}->AttachmentGet(
            ItemID => $GetParam{ItemID},
            FileID => $GetParam{FileID},
        );
        if (%File) {
            return $Self->{LayoutObject}->Attachment(%File);
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }

    # ---------------------------------------------------------- #
    # search a item
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'Search' ) {
        $Self->GetItemSearch(
            Mode => 'Agent',
            User => $Self->{UserID},
        );
        $HeaderTitle = 'Search';
        $Header      = $Self->{LayoutObject}->Header(
            Title => $HeaderTitle,
            Type  => $HeaderType,
        );
        $Content = $Self->{LayoutObject}->Output(
            TemplateFile => 'FAQ',
            Data => { %Frontend, %GetParam }
        );
    }

    # ---------------------------------------------------------- #
    # item history
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'History' ) {

        # check parameters
        my %ParamData      = ();
        my @RequiredParams = qw(CategoryID ItemID);
        for (@RequiredParams) {
            $ParamData{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
            if ( !$ParamData{$_} ) {
                return $Self->{LayoutObject}->FatalError( Message => "Need $_!" );
            }
        }

        # db action
        # ********************************************************** #
        my %ItemData
            = $Self->{FAQObject}->FAQGet( ItemID => $ParamData{ItemID}, UserID => $Self->{UserID} );
        if ( !%ItemData ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        # dtl
        # ********************************************************** #
        $Self->{LayoutObject}->Block(
            Name => 'History',
            Data => { %Param, %ItemData },
        );

        $HeaderTitle = 'History';
        $Frontend{CssRow} = 'searchactive';
        my @History = @{ $Self->{FAQObject}->FAQHistoryGet( ItemID => $ItemData{ItemID} ) };
        for my $Row (@History) {

            # css configuration
            if ( $Frontend{CssRow} eq 'searchpassive' ) {
                $Frontend{CssRow} = 'searchactive';
            }
            else {
                $Frontend{CssRow} = 'searchpassive';
            }

            $Frontend{Name}    = $Row->{Name};
            $Frontend{Created} = $Row->{Created};
            my %User = $Self->{UserObject}->GetUserData(
                UserID => $Row->{CreatedBy},
                Cached => 1,
            );
            $Frontend{CreatedBy} = "$User{UserLogin} ($User{UserFirstname} $User{UserLastname})";

            $Self->{LayoutObject}->Block(
                Name => 'HistoryRow',
                Data => {%Frontend}
            );

        }

    }

    # ---------------------------------------------------------- #
    # system history
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'SystemHistory' ) {
        $Self->GetSystemHistory();
        $HeaderTitle = 'History';
    }

    # ---------------------------------------------------------- #
    # item print
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'Print' && $Self->{ParamObject}->GetParam( Param => 'ItemID' ) ) {
        $Self->GetItemPrint( Links => 1 );
        $Header = $Self->{LayoutObject}->PrintHeader(
            Title => $Self->{ItemData}{Subject}
        );
        $Navigation = ' ';
        $Content    = $Self->{LayoutObject}->Output(
            TemplateFile => 'FAQ',
            Data => { %Frontend, %GetParam }
        );
        $Footer = $Self->{LayoutObject}->PrintFooter();
    }

    # ---------------------------------------------------------- #
    # explorer
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'Explorer' ) {
        $Self->GetExplorer( Mode => 'Agent' );
        $HeaderTitle = 'Explorer';
        $Header      = $Self->{LayoutObject}->Header(
            Type  => $HeaderType,
            Title => $HeaderTitle
        );
        $Content = $Self->{LayoutObject}->Output(
            TemplateFile => 'FAQ',
            Data => { %Frontend, %GetParam }
        );

    }

    # ---------------------------------------------------------- #
    # item view
    # ---------------------------------------------------------- #
    elsif ( $Self->{ParamObject}->GetParam( Param => 'ItemID' ) ) {
        if ( $Self->{LastFAQNav} ) {
            $Self->GetItemSmallView();
        }
        else {

            # store last screen (to get back from linkin object mask)
            $Self->{SessionObject}->UpdateSessionID(
                SessionID => $Self->{SessionID},
                Key       => 'LastScreenView',
                Value     => $Self->{RequestedURL},
            );
            my %FAQArticle = $Self->{FAQObject}->FAQGet(
                FAQID => $Self->{ParamObject}->GetParam( Param => 'ItemID' ),
            );
            my $Permission = $Self->{FAQObject}->CheckCategoryUserPermission(
                UserID     => $Self->{UserID},
                CategoryID => $FAQArticle{CategoryID},
            );
            if ( $Permission eq '' ) {
                $Self->{LayoutObject}->FatalError( Message => "Permission denied!" );
            }
            $Self->GetItemView(
                Links      => 1,
                Permission => $Permission,
            );
        }
        $HeaderTitle = $Self->{ItemData}{Number};
        $Header      = $Self->{LayoutObject}->Header(
            Type  => $HeaderType,
            Title => $HeaderTitle
        );
    }

    # ---------------------------------------------------------- #
    # redirect to explorer
    # ---------------------------------------------------------- #
    else {
        if ( !defined( $Param{Nav} ) ) {
            $Param{Nav} = '';
        }
        return $Self->{LayoutObject}
            ->Redirect( OP => "Action=$Self->{Action}&Subaction=Explorer&Nav=" . $Param{Nav} );
    }

    # DEFAULT OUTPUT
    $DefaultHeader = $Self->{LayoutObject}->Header(
        Type  => $HeaderType,
        Title => $HeaderTitle
    );
    $DefaultNavigation = $Self->{LayoutObject}->NavigationBar();
    $DefaultContent    = $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentFAQ',
        Data => { %Frontend, %GetParam }
    );
    $DefaultFooter = $Self->{LayoutObject}->Footer( Type => $FooterType );

    # OUTPUT
    $Output .= $Header     || $DefaultHeader;
    $Output .= $Navigation || $DefaultNavigation;
    if ( !$Notify ) {
        for my $Notify ( @{ $Self->{Notify} } ) {
            $Output .= $Self->{LayoutObject}->Notify(
                Priority => $Notify->[0],
                Info     => $Notify->[1],
            );
        }
    }
    $Output .= $Content || $DefaultContent;
    $Output .= $Footer  || $DefaultFooter;

    return $Output;
}

1;
