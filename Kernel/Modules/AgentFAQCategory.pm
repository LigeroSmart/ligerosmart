# --
# Kernel/Modules/AgentFAQCategory.pm - the faq language management module
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: AgentFAQCategory.pm,v 1.2 2010-10-27 22:21:31 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::AgentFAQCategory;

use strict;
use warnings;

use Kernel::System::FAQ;
use Kernel::System::Valid;
use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(ParamObject DBObject LayoutObject LogObject ConfigObject)) {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Object!" );
        }
    }

    # create needed objects
    $Self->{FAQObject} = Kernel::System::FAQ->new(%Param);
    $Self->{ValidObject} = Kernel::System::Valid->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my %GetParam = ();

    for my $ParamName (qw(ID Name ParentID Comment ValidID)) {
        $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
    }

    $GetParam{CategoryID} = $GetParam{ID} || '';

    @{ $GetParam{PermissionGroups} }
        = $Self->{ParamObject}->GetArray( Param => "PermissionGroups" );

    $GetParam{UserID} = $Self->{UserID};

    # permission check
    if ( !$Self->{AccessRw} ) {
        return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
    }

    # ------------------------------------------------------------ #
    # change
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Change' ) {

        # check required parameters
        for my $ParamName (qw(ID)) {
            if ( !$GetParam{$ParamName} ) {
                $Self->{LayoutObject}->FatalError( Message => "Need $ParamName !" );
            }
        }

        # get category data
        my %Data = $Self->{FAQObject}->CategoryGet( CategoryID => $GetParam{ID} );

        $Data{ID} = $Data{CategoryID};

        $Data{PermissionGroups} = $Self->{FAQObject}->GetCategoryGroup(
            CategoryID => $GetParam{ID},
        );

        # set validation class
        for my $ValidationObject ( qw(Name Comment PermissionGroups) ){
            if ( !$GetParam{ "$ValidationObject" . 'RequiredClass' } ) {
                $GetParam{ "$ValidationObject" . 'RequiredClass' }  = "!Validate_Required ";
            }
        }

        # set default "No Error"" to field Name as server error string
        if (! $GetParam{NameServerError} ) {
            $GetParam{NameServerError} = 'No Error';
        }

        # output change screen
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->_Edit(
            Action => 'Change',
            %Data,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentFAQCategory',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # change action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # check for name
        my $ServerError;
        for my $ParamName (qw(Name Comment PermissionGroups)) {
            if ( !$GetParam{$ParamName} ){
                $GetParam{ "$ParamName" . 'RequiredClass'} = 'Validate_Required ServerError';
                $GetParam{NameServerError}
                    = 'A category should have a name!' if $ParamName eq 'Name';

                # set ServerError Flag
                $ServerError = 1;
            }
        }

        # send server error if any required parameters is missing
        if ($ServerError){
            $Self->_Edit(
                Action      => 'Add',
                %GetParam,
            );
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AgentFAQCategory',
                Data         => \%Param,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }

        for my $ParamName ( qw(ParentID ValidID)) {
            if ( !defined( $GetParam{$ParamName} ) ) {
                return $Self->{LayoutObject}->FatalError( Message => "Need $ParamName" );
            }
        }

        # check for duplicate name
        if (
            $Self->{FAQObject}->CategoryDuplicateCheck(
                ID => $GetParam{ID},
                Name => $GetParam{Name},
                ParentID => $GetParam{ParentID}
                )
           )
           {

                # set server errors
                $GetParam{NameRequiredClass} = 'Validate_Required ServerError';
                $GetParam{NameServerError} = "Category '$GetParam{Name}' already exists!";

                # output add category screen
                $Self->_Edit(
                    Action      => 'Change',
                    %GetParam,
                );
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'AgentFAQCategory',
                    Data         => \%Param,
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
        }

        # update category
        my $Success
                = $Self->{FAQObject}->CategoryUpdate( %GetParam, UserID => $Self->{UserID} );

        if ($Success) {

            # set category group
            $Self->{FAQObject}->SetCategoryGroup(
                CategoryID => $GetParam{ID},
                GroupIDs   => $GetParam{PermissionGroups},
            );

            # retrun to overview
            $Output .= $Self->{LayoutObject}->Notify( Info => 'FAQ category updated!' );
            $Self->_Overview();
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentFAQCategory',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Add' ) {

        # set validation class
        for my $ValidationObject ( qw(Name Comment PermissionGroups) ){
            if ( !$GetParam{ "$ValidationObject" . 'RequiredClass' } ) {
                $GetParam{ "$ValidationObject" . 'RequiredClass' }  = "!Validate_Required ";
            }
        }

        # set default "No Error"" to field Name as server error string
        if ( !$GetParam{NameServerError} ) {
            $GetParam{NameServerError} = 'No Error';
        }

        # output Add screen
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->_Edit(
            Action => 'Add',
            %GetParam,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentFAQCategory',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AddAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # check for name
        my $ServerError;
        for my $ParamName (qw(Name Comment PermissionGroups)) {
            if ( !$GetParam{$ParamName} ){
                $GetParam{ "$ParamName" . 'RequiredClass'} = 'Validate_Required ServerError';
                $GetParam{NameServerError}
                    = 'A category should have a name!' if $ParamName eq 'Name';

                # set ServerError Flag
                $ServerError = 1;
            }
        }

        # send server error if any required parameters is missing
        if ($ServerError){
            $Self->_Edit(
                Action      => 'Add',
                %GetParam,
            );
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AgentFAQCategory',
                Data         => \%Param,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }

        for my $ParamName ( qw(ParentID ValidID)) {
            if ( !defined( $GetParam{$ParamName} ) ) {
                return $Self->{LayoutObject}->FatalError( Message => "Need $ParamName" );
            }
        }

        # check for duplicate name
        if (
            $Self->{FAQObject}->CategoryDuplicateCheck(
                Name => $GetParam{Name},
                ParentID => $GetParam{ParentID}
                )
            )
            {

                # set server errors
                $GetParam{NameRequiredClass} = 'Validate_Required ServerError';
                $GetParam{NameServerError} = "Category '$GetParam{Name}' already exists!";

                #output add category screen
                $Self->_Edit(
                    Action      => 'Add',
                    %GetParam,
                );
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'AgentFAQCategory',
                    Data         => \%Param,
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
        }

        # add new category
        my $CategoryID
                = $Self->{FAQObject}->CategoryAdd( %GetParam, UserID => $Self->{UserID} );

        if ($CategoryID) {

            # set category group
            $Self->{FAQObject}->SetCategoryGroup(
                CategoryID => $CategoryID,
                GroupIDs   => $GetParam{PermissionGroups},
            );

            # retrun to overview
            $Output .= $Self->{LayoutObject}->Notify( Info => 'FAQ category added!' );
            $Self->_Overview();
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentFAQCategory',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ---------------------------------------------------------- #
    # overview
    # ---------------------------------------------------------- #
    else {
        $Self->_Overview();
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentFAQCategory',
            Data         => {
                %Param,
                %GetParam,
            },
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}

sub _Edit {
    my ( $Self, %Param ) = @_;

    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    # set default "No Error"" to field Name as server error string
    if ( !$Param{NameServerError} ) {
        $Param{NameServerError} = 'No Error';
    }

    my %ValidList        = $Self->{ValidObject}->ValidList();
    my %ValidListReverse = reverse %ValidList;

    $Param{ValidOption} = $Self->{LayoutObject}->BuildSelection(
        Data       => \%ValidList,
        Name       => 'ValidID',
        SelectedID => $Param{ValidID} || $ValidListReverse{valid},
    );

    my %Groups = $Self->{GroupObject}->GroupList ( Valid => 1 );

    $Param{GroupOption} = $Self->{LayoutObject}->BuildSelection(
        Data       => \%Groups,
        Name       => 'PermissionGroups',
        Multiple   => 1,
        Class      => $Param{PermissionGroupsRequiredClass},
        SelectedID => $Param{PermissionGroups},
    );

    $Param{CategoryOption} = $Self->{LayoutObject}->AgentFAQCategoryListOption(
        CategoryList        => {
                %{ $Self->{FAQObject}->CategoryList( UserID => $Self->{UserID} ) }
        },
        Size                => 1,
        Name                => 'ParentID',
        HTMLQuote           => 1,
        LanguageTranslation => 0,
        RootElement         => 1,
        SelectedID          => $Param{ParentID},
    );

    $Self->{LayoutObject}->Block( Name => 'ActionList' );
    $Self->{LayoutObject}->Block( Name => 'ActionOverview' );

    $Self->{LayoutObject}->Block(
        Name => 'OverviewUpdate',
        Data => \%Param,
    );

    # shows header
    if ( $Param{Action} eq 'Change' ) {
        $Self->{LayoutObject}->Block( Name => 'HeaderEdit' );
    }
    else {
        $Self->{LayoutObject}->Block( Name => 'HeaderAdd' );
    }

    return 1;
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    my $Output = '';

    #output overview blocks
    $Self->{LayoutObject}->Block( Name => 'Overview' );
    $Self->{LayoutObject}->Block( Name => 'ActionList' );
    $Self->{LayoutObject}->Block( Name => 'ActionAdd' );
    $Self->{LayoutObject}->Block( Name => 'OverviewResult' );

    # get categories list
    my %CategoryList = %{$Self->{FAQObject}->CategoryList( UserID => $Self->{UserID} )};

    # if there are any categories, they are shown
    if (%CategoryList){
        $Self->_FAQCategoryTableOutput(
            CategoryList => \%CategoryList,
            LevelCounter => 0,
            ParentID     => 0,
        );
    }

    # otherwise a no data found msg is displayed
    else {
        $Self->{LayoutObject}->Block( Name => 'NoDataFoundMsg' );
    }
}

sub _FAQCategoryTableOutput {
    my ( $Self, %Param ) = @_;

    # based on Kernel::Output::HTML::LayoutFAQ::AgentFAQCategoryListOptionElement()
    my $LevelCounter = $Param{LevelCounter} || 0;
    my $ParentID     = $Param{ParentID};

    my %CategoryList       = %{ $Param{CategoryList} };
    my %CategoryLevelList  = %{ $CategoryList{ $ParentID } };

    my @TempSubCategoryIDs = map  { "Level:$LevelCounter" . "ParentID:$ParentID", $_ }
                             sort { $CategoryLevelList{$a} cmp $CategoryLevelList{$b} }
                             keys %CategoryLevelList;

    SUBCATEGORYID:
    while ( @TempSubCategoryIDs ) {

        # add level counter id to subcategory array
        if ( $TempSubCategoryIDs[0] =~ m{ Level : ( \d+ ) ParentID : ( \d+ ) }xms ) {
            $LevelCounter = $1;
            $ParentID     = $2;
            shift @TempSubCategoryIDs;
        }

        # get next subcategory id
        my $SubCategoryID = shift @TempSubCategoryIDs;

        # get new category level list
        %CategoryLevelList = %{ $CategoryList{ $ParentID } };

        # get category details
        my %Data = $Self->{FAQObject}->CategoryGet( CategoryID => $SubCategoryID );

        # set indentation to display in the cell style based on 10 px and 15 px for each level
        $Data{Indentation} = 10 + ($LevelCounter * 15);

        # get valis string based on ValidID
        $Data{Valid} = $Self->{ValidObject}->ValidLookup( ValidID => $Data{ValidID} );

        #output results
        $Self->{LayoutObject}->Block(
            Name => 'OverviewResultRow',
            Data => { %Data },
        );

        # check if subcategory has own subcategories
        next SUBCATEGORYID if !$CategoryList{ $SubCategoryID };

        # increase level
        my $NextLevel = $LevelCounter + 1;

        # get new subcategory ids
        my %NewCategoryLevelList = %{ $CategoryList{ $SubCategoryID } };
        my @NewSubcategoryIDs = map  { "Level:$NextLevel" . "ParentID:$SubCategoryID", $_ }
                                sort { $NewCategoryLevelList{$a} cmp $NewCategoryLevelList{$b} }
                                keys %NewCategoryLevelList;

        # add new subcategory ids at beginning of temp array
        unshift @TempSubCategoryIDs, @NewSubcategoryIDs;
    }
}

1;
