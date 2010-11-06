# --
# Kernel/Modules/AgentFAQCategory.pm - the faq language management module
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: AgentFAQCategory.pm,v 1.14 2010-11-06 15:58:31 ub Exp $
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
$VERSION = qw($Revision: 1.14 $) [1];

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
        my %CategoryData = $Self->{FAQObject}->CategoryGet(
            CategoryID => $GetParam{CategoryID},
            UserID     => $Self->{UserID},
        );

        # get permission groups
        $CategoryData{PermissionGroups} = $Self->{FAQObject}->CategoryGroupGet(
            CategoryID => $GetParam{CategoryID},
            UserID     => $Self->{UserID},
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
            UserID     => $Self->{UserID},
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
        my $CategoryUpdateSuccessful = $Self->{FAQObject}->CategoryUpdate(
            %GetParam,
            UserID => $Self->{UserID},
        );

        # check error
        if ( !$CategoryUpdateSuccessful ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        # set category group
        $Self->{FAQObject}->SetCategoryGroup(
            CategoryID => $GetParam{CategoryID},
            GroupIDs   => $GetParam{PermissionGroups},
            UserID     => $Self->{UserID},
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
            UserID     => $Self->{UserID},
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
        my $CategoryID = $Self->{FAQObject}->CategoryAdd(
            %GetParam,
            UserID => $Self->{UserID},
        );

        # check error
        if ( !$CategoryID ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        # set category group
        $Self->{FAQObject}->SetCategoryGroup(
            CategoryID => $CategoryID,
            GroupIDs   => $GetParam{PermissionGroups},
            UserID     => $Self->{UserID},
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

    my %Data;

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
    $Data{ValidOption} = $Self->{LayoutObject}->BuildSelection(
        Data       => \%ValidList,
        Name       => 'ValidID',
        SelectedID => $Param{ValidID} || $ValidListReverse{valid},
    );

    # get all valid groups
    my %Groups = $Self->{GroupObject}->GroupList( Valid => 1 );

    # build the group selection
    $Data{GroupOption} = $Self->{LayoutObject}->BuildSelection(
        Data       => \%Groups,
        Name       => 'PermissionGroups',
        Multiple   => 1,
        Class      => $Param{PermissionGroupsRequiredClass},
        SelectedID => $Param{PermissionGroups},
    );

    # get all categories with their long names
    my $CategoryTree = $Self->{FAQObject}->CategoryTreeList(
        Valid  => 0,
        UserID => $Self->{UserID},
    );

    # build the catogory selection
    $Data{CategoryOption} = $Self->{LayoutObject}->BuildSelection(
        Data           => $CategoryTree,
        Name           => 'ParentID',
        SelectedID     => $Param{ParentID},
        PossibleNone   => 1,
        DisabledBranch => $CategoryTree->{ $Param{CategoryID} } || '',
        Translation    => 0,
        TreeView       => 1,
    );

    $Self->{LayoutObject}->Block( Name => 'ActionList' );
    $Self->{LayoutObject}->Block( Name => 'ActionOverview' );

    $Self->{LayoutObject}->Block(
        Name => 'OverviewUpdate',
        Data => {
            %Param,
            %Data,
        },
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

    # get all categories with their long names
    my $CategoryTree = $Self->{FAQObject}->CategoryTreeList(
        Valid  => 0,
        UserID => $Self->{UserID},
    );

    # if there are any categories, they are shown
    if ( $CategoryTree && ref $CategoryTree eq 'HASH' && %{$CategoryTree} ) {

        # get the valid list
        my %ValidList = $Self->{ValidObject}->ValidList();

        # sort the category ids by the long category name
        my @CategoryIDsSorted = sort { $CategoryTree->{$a} cmp $CategoryTree->{$b} } keys %{$CategoryTree};

        # show all categories
        for my $CategoryID (@CategoryIDsSorted) {

            # get category data
            my %CategoryData = $Self->{FAQObject}->CategoryGet(
                CategoryID => $CategoryID,
                UserID     => $Self->{UserID},
            );

            # get valid string based on ValidID
            $CategoryData{Valid} = $ValidList{ $CategoryData{ValidID} };

            # overwrite the name with the long name
            $CategoryData{Name} = $CategoryTree->{$CategoryID};

            # output the category data
            $Self->{LayoutObject}->Block(
                Name => 'OverviewResultRow',
                Data => { %CategoryData },
            );
        }
    }

    # otherwise a no data found message is displayed
    else {
        $Self->{LayoutObject}->Block(
            Name => 'NoDataFoundMsg',
        );
    }
}

1;
