# --
# Kernel/Modules/AgentFAQCategory.pm - the faq language management module
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: AgentFAQCategory.pm,v 1.8 2010-11-03 14:00:51 ub Exp $
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
$VERSION = qw($Revision: 1.8 $) [1];

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

    # create additional objects
    $Self->{FAQObject} = Kernel::System::FAQ->new(%Param);
    $Self->{ValidObject} = Kernel::System::Valid->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my %GetParam;

    # set the user id
    $GetParam{UserID} = $Self->{UserID};

    for my $ParamName (qw(CategoryID Name ParentID Comment ValidID)) {
        $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
    }

    # set default
    $GetParam{CategoryID} ||= '';

    @{ $GetParam{PermissionGroups} }
        = $Self->{ParamObject}->GetArray( Param => "PermissionGroups" );

    # permission check
    if ( !$Self->{AccessRw} ) {
        return $Self->{LayoutObject}->NoPermission(
            Message    => "You need rw permission!",
            WithHeader => 'yes',
        );
    }

    # ------------------------------------------------------------ #
    # change
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Change' ) {

        # check required parameters
        if ( !$GetParam{CategoryID} ) {
            $Self->{LayoutObject}->FatalError( Message => "Need CategoryID!" );
        }

        # get category data
        my %CategoryData = $Self->{FAQObject}->CategoryGet( CategoryID => $GetParam{CategoryID} );

        $CategoryData{PermissionGroups} = $Self->{FAQObject}->GetCategoryGroup(
            CategoryID => $GetParam{CategoryID},
        );

        # set validation class
        for my $ValidationObject ( qw(Name Comment PermissionGroups) ){
            if ( !$GetParam{ "$ValidationObject" . 'RequiredClass' } ) {
                $GetParam{ "$ValidationObject" . 'RequiredClass' } = "Validate_Required ";
            }
        }

        # set default "No Error" to field Name as server error string
        if ( !$GetParam{NameServerError} ) {
            $GetParam{NameServerError} = 'No Error';
        }

        # output change screen
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->_Edit(
            Action => 'Change',
            %CategoryData,
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

                # add server error string for category name field
                if ( $ParamName eq 'Name' ) {
                    $GetParam{NameServerError} = 'A category should have a name!';
                }

                # set ServerError Flag
                $ServerError = 1;
            }
        }

        # send server error if any required parameter is missing
        if ($ServerError){
            $Self->_Edit(
                Action => 'Change',
                %GetParam,
            );
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AgentFAQCategory',
                Data         => \%Param,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }

        for my $ParamName (qw(ParentID ValidID)) {
            if ( !defined $GetParam{$ParamName} ) {
                return $Self->{LayoutObject}->FatalError( Message => "Need $ParamName" );
            }
        }

        # check for duplicate category name with the same parent category
        my $CategoryExistsAlready = $Self->{FAQObject}->CategoryDuplicateCheck(
            CategoryID => $GetParam{CategoryID},
            Name       => $GetParam{Name},
            ParentID   => $GetParam{ParentID},
        );

        # show the edit screen again
        if ( $CategoryExistsAlready ) {

            # set server errors
            $GetParam{NameRequiredClass} = 'Validate_Required ServerError';
            $GetParam{NameServerError} = "Category '$GetParam{Name}' already exists!";

            # output add category screen
            $Self->_Edit(
                Action => 'Change',
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
        my $CategoryUpdateSuccessful = $Self->{FAQObject}->CategoryUpdate(%GetParam);

        # check error
        if ( !$CategoryUpdateSuccessful ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        # set category group
        $Self->{FAQObject}->SetCategoryGroup(
            CategoryID => $GetParam{CategoryID},
            GroupIDs   => $GetParam{PermissionGroups},
        );

        # show overview
        $Output .= $Self->{LayoutObject}->Notify( Info => 'FAQ category updated!' );
        $Self->_Overview();
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
        for my $ValidationObject (qw(Name Comment PermissionGroups)) {
            if ( !$GetParam{ "$ValidationObject" . 'RequiredClass' } ) {
                $GetParam{ "$ValidationObject" . 'RequiredClass' } = "Validate_Required ";
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

                # add server error string for category name field
                if ( $ParamName eq 'Name' ) {
                    $GetParam{NameServerError} = 'A category should have a name!';
                }

                # set ServerError Flag
                $ServerError = 1;
            }
        }

        # send server error if any required parameters is missing
        if ($ServerError){
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

        for my $ParamName (qw(ParentID ValidID)) {
            if ( !defined $GetParam{$ParamName} ) {
                return $Self->{LayoutObject}->FatalError( Message => "Need $ParamName" );
            }
        }

        # check for duplicate category name with the same parent category
        my $CategoryExistsAlready = $Self->{FAQObject}->CategoryDuplicateCheck(
            CategoryID => $GetParam{CategoryID},
            Name       => $GetParam{Name},
            ParentID   => $GetParam{ParentID},
        );

        # show the edit screen again
        if ( $CategoryExistsAlready ) {

            # set server errors
            $GetParam{NameRequiredClass} = 'Validate_Required ServerError';
            $GetParam{NameServerError} = "Category '$GetParam{Name}' already exists!";

            # output add category screen
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

        # add new category
        my $CategoryID = $Self->{FAQObject}->CategoryAdd(%GetParam);

        # check error
        if ( !$CategoryID ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        # set category group
        $Self->{FAQObject}->SetCategoryGroup(
            CategoryID => $CategoryID,
            GroupIDs   => $GetParam{PermissionGroups},
        );

        # show overview
        $Output .= $Self->{LayoutObject}->Notify( Info => 'FAQ category added!' );
        $Self->_Overview();
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
            Data => {
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

    # get the valid list
    my %ValidList        = $Self->{ValidObject}->ValidList();
    my %ValidListReverse = reverse %ValidList;

    # build the valid selection
    $Param{ValidOption} = $Self->{LayoutObject}->BuildSelection(
        Data       => \%ValidList,
        Name       => 'ValidID',
        SelectedID => $Param{ValidID} || $ValidListReverse{valid},
    );

    # get all valid groups
    my %Groups = $Self->{GroupObject}->GroupList ( Valid => 1 );

    # build the group selection
    $Param{GroupOption} = $Self->{LayoutObject}->BuildSelection(
        Data       => \%Groups,
        Name       => 'PermissionGroups',
        Multiple   => 1,
        Class      => $Param{PermissionGroupsRequiredClass},
        SelectedID => $Param{PermissionGroups},
    );

    # get category list
    my $CategoryListRef = $Self->{FAQObject}->CategoryList( UserID => $Self->{UserID} );

    # check if this is te category edit screen
    if ( $Param{Action} eq 'Change' && $Param{CategoryID} ) {

        # delete own category from parent list
        delete $CategoryListRef->{ $Param{ParentID} }->{ $Param{CategoryID} };
    }

    # TODO : Replace this with build selection if possible,
    # and remove AgentFAQCategoryListOption() from LayoutFAQ.pm
    # hint: GetCategoryTree() gives us what we want
    #
    #
    # build the catogory selection
    $Param{CategoryOption} = $Self->{LayoutObject}->AgentFAQCategoryListOption(
        CategoryList        => $CategoryListRef,
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

    # show header
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

    # output overview blocks
    $Self->{LayoutObject}->Block( Name => 'Overview' );
    $Self->{LayoutObject}->Block( Name => 'ActionList' );
    $Self->{LayoutObject}->Block( Name => 'ActionAdd' );
    $Self->{LayoutObject}->Block( Name => 'OverviewResult' );

    # get categories list
    my $CategoryListRef = $Self->{FAQObject}->CategoryList( UserID => $Self->{UserID} );

    # if there are any categories, they are shown
    if ( $CategoryListRef && ref $CategoryListRef eq 'HASH' && %{$CategoryListRef} ){
        $Self->_FAQCategoryTableOutput(
            CategoryList => $CategoryListRef,
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

    my %ParentNames;

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
        my %CategoryData = $Self->{FAQObject}->CategoryGet( CategoryID => $SubCategoryID );

        # append parent name to child category name
        if ( $ParentNames{$ParentID} ) {
            $CategoryData{Name} = $ParentNames{$ParentID} . '::' . $CategoryData{Name};
        }

        # set current child complete name to ParentNames hash for further use
        $ParentNames{$SubCategoryID} = $CategoryData{Name};

        # get valid string based on ValidID
        $CategoryData{Valid}
            = $Self->{ValidObject}->ValidLookup( ValidID => $CategoryData{ValidID} );

        #output results
        $Self->{LayoutObject}->Block(
            Name => 'OverviewResultRow',
            Data => { %CategoryData },
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
