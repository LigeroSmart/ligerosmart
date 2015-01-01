# --
# Kernel/Modules/AgentFAQCategory.pm - the FAQ category management module
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentFAQCategory;

use strict;
use warnings;

use Kernel::System::FAQ;
use Kernel::System::Valid;

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
    $Self->{FAQObject}   = Kernel::System::FAQ->new(%Param);
    $Self->{ValidObject} = Kernel::System::Valid->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # permission check
    if ( !$Self->{AccessRw} ) {
        return $Self->{LayoutObject}->NoPermission(
            Message    => 'You need rw permission!',
            WithHeader => 'yes',
        );
    }

    # get parameters
    my %GetParam;
    for my $ParamName (qw(CategoryID Name ParentID Comment ValidID)) {
        $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
    }

    # set default category id
    $GetParam{CategoryID} ||= 0;

    # set default parent id
    $GetParam{ParentID} ||= 0;

    # get array parameters
    @{ $GetParam{PermissionGroups} } = $Self->{ParamObject}->GetArray( Param => 'PermissionGroups' );

    # ------------------------------------------------------------ #
    # change
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Change' ) {

        # check required parameters
        if ( !$GetParam{CategoryID} ) {
            $Self->{LayoutObject}->FatalError( Message => 'Need CategoryID!' );
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

        # header
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # HTML output
        $Self->_Edit(
            Action => 'Change',
            %CategoryData,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentFAQCategory',
            Data         => \%Param,
        );

        # footer
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # change action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # header
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # check required parameters
        for my $ParamName (qw(ParentID ValidID)) {
            if ( !defined $GetParam{$ParamName} ) {
                return $Self->{LayoutObject}->FatalError( Message => "Need $ParamName!" );
            }
        }

        # check required parameters
        my %Error;
        for my $ParamName (qw(Name Comment PermissionGroups)) {

            # if required field is not given
            if ( !$GetParam{$ParamName} ) {

                # add server error error class
                $Error{ $ParamName . 'ServerError' } = 'ServerError';

                # add server error string for category name field
                if ( $ParamName eq 'Name' ) {
                    $Error{NameServerErrorMessage} = 'A category should have a name!';
                }
            }
        }

        # send server error if any required parameter is missing
        if (%Error) {

            # HTML output
            $Self->_Edit(
                Action => 'Change',
                %GetParam,
                %Error,
            );
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AgentFAQCategory',
                Data         => \%Param,
            );

            # footer
            $Output .= $Self->{LayoutObject}->Footer();

            return $Output;
        }

        # check for duplicate category name with the same parent category
        my $CategoryExistsAlready = $Self->{FAQObject}->CategoryDuplicateCheck(
            CategoryID => $GetParam{CategoryID},
            Name       => $GetParam{Name},
            ParentID   => $GetParam{ParentID},
            UserID     => $Self->{UserID},
        );

        # show the edit screen again
        if ($CategoryExistsAlready) {

            # set server errors
            $GetParam{NameServerError}        = 'ServerError';
            $GetParam{NameServerErrorMessage} = 'This category already exists';

            # HTML output
            $Self->_Edit(
                Action => 'Change',
                %GetParam,
            );
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AgentFAQCategory',
                Data         => \%Param,
            );

            # footer
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

        # show notification
        $Output .= $Self->{LayoutObject}->Notify( Info => 'FAQ category updated!' );

        # show overview
        $Self->_Overview();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentFAQCategory',
            Data         => \%Param,
        );

        # footer
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # add
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Add' ) {

        # header
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # HTML output
        $Self->_Edit(
            Action => 'Add',
            %GetParam,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentFAQCategory',
            Data         => \%Param,
        );

        # footer
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # add action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AddAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # header
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # check required parameters
        for my $ParamName (qw(ParentID ValidID)) {
            if ( !defined $GetParam{$ParamName} ) {
                return $Self->{LayoutObject}->FatalError( Message => "Need $ParamName!" );
            }
        }

        # check required parameters
        my %Error;
        for my $ParamName (qw(Name Comment PermissionGroups)) {

            # if required field is not given
            if ( !$GetParam{$ParamName} ) {

                # add validation class and server error error class
                if ( $ParamName eq 'PermissionGroups' ) {
                    $Error{ $ParamName . 'ServerError' } = 'ServerError';
                }

                # add server error string for category name field
                if ( $ParamName eq 'Name' ) {
                    $Error{NameServerErrorMessage} = 'A category should have a name!';
                }
            }
        }

        # send server error if any required parameters are missing
        if (%Error) {

            # HTML output
            $Self->_Edit(
                Action => 'Add',
                %GetParam,
                %Error,
            );
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AgentFAQCategory',
                Data         => \%Param,
            );

            # footer
            $Output .= $Self->{LayoutObject}->Footer();

            return $Output;
        }

        # check for duplicate category name with the same parent category
        my $CategoryExistsAlready = $Self->{FAQObject}->CategoryDuplicateCheck(
            CategoryID => $GetParam{CategoryID},
            Name       => $GetParam{Name},
            ParentID   => $GetParam{ParentID},
            UserID     => $Self->{UserID},
        );

        # show the edit screen again
        if ($CategoryExistsAlready) {

            # set server errors
            $GetParam{NameServerError}        = 'ServerError';
            $GetParam{NameServerErrorMessage} = 'This category already exists!';

            # HTML output
            $Self->_Edit(
                Action => 'Add',
                %GetParam,
            );
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AgentFAQCategory',
                Data         => \%Param,
            );

            # footer
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

        # show notification
        $Output .= $Self->{LayoutObject}->Notify( Info => 'FAQ category added!' );

        # show overview
        $Self->_Overview();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentFAQCategory',
            Data         => \%Param,
        );

        # footer
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # delete
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Delete' ) {

        # get the CategoryID
        my $CategoryID = $Self->{ParamObject}->GetParam( Param => 'CategoryID' ) || '';

        # check required parameters
        if ( !$CategoryID ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => 'No CategoryID is given!',
                Comment => 'Please contact the administrator.',
            );
        }

        # get category data
        my %CategoryData = $Self->{FAQObject}->CategoryGet(
            CategoryID => $CategoryID,
            UserID     => $Self->{UserID},
        );

        if ( !%CategoryData ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        # get all affected FAQ articles
        my @AffectedItems = $Self->{FAQObject}->FAQSearch(
            CategoryIDs => [$CategoryID],
            UserID      => 1,
        );

        # get all affected SubCcategories
        my $AffectedSubCategories = $Self->{FAQObject}->CategorySubCategoryIDList(
            ParentID => $CategoryID,
            Mode     => 'Agent',
            UserID   => 1,
        );

        # call Delete block
        $Self->{LayoutObject}->Block(
            Name => 'Delete',
            Data => {%CategoryData},
        );

        # set the dialog type. As default, the dialog will have 2 buttons: Yes and No
        my $DialogType = 'Confirmation';

        # display list of affected FAQ articles or SubCategories
        if ( @AffectedItems || @{$AffectedSubCategories} ) {

            # set the dialog type to have only 1 button: OK
            $DialogType = 'Message';

            $Self->{LayoutObject}->Block(
                Name => 'Affected',
                Data => {},
            );

            # display Affected FAQ articles
            if (@AffectedItems) {

                $Self->{LayoutObject}->Block(
                    Name => 'AffectedItems',
                    Data => {},
                );

                ITEMID:
                for my $ItemID (@AffectedItems) {

                    # get FAQ article
                    my %FAQData = $Self->{FAQObject}->FAQGet(
                        ItemID     => $ItemID,
                        ItemFields => 0,
                        UserID     => $Self->{UserID},
                    );

                    # check FAQ article
                    next ITEMID if !%FAQData;

                    $Self->{LayoutObject}->Block(
                        Name => 'AffectedItemsRow',
                        Data => {
                            %FAQData,
                            %Param,
                        },
                    );
                }
            }

            # display Affected Subcategories
            if ( @{$AffectedSubCategories} ) {

                # get categories long names
                my $CategoryLongNames = $Self->{FAQObject}->GetUserCategoriesLongNames(
                    Type   => 'ro',
                    UserID => 1,
                );
                $Self->{LayoutObject}->Block(
                    Name => 'AffectedSubCategories',
                    Data => {},
                );
                CATEGORYID:
                for my $CategoryID ( @{$AffectedSubCategories} ) {

                    # get category
                    my %CategoryData = $Self->{FAQObject}->CategoryGet(
                        CategoryID => $CategoryID,
                        UserID     => $Self->{UserID},
                    );

                    # set category long name
                    $CategoryData{LongName} = $CategoryLongNames->{$CategoryID};

                    # check category
                    next CATEGORYID if !%CategoryData;

                    $Self->{LayoutObject}->Block(
                        Name => 'AffectedSubCategoriesRow',
                        Data => {
                            %CategoryData,
                            %Param,
                        },
                    );
                }
            }

        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'NoAffected',
                Data => {%CategoryData},
            );
        }

        # output content
        my $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentFAQCategory',
            Data         => {},
        );

        # build the returned data structure
        my %Data = (
            HTML       => $Output,
            DialogType => $DialogType,
        );

        # return JSON-String because of AJAX-Mode
        my $OutputJSON = $Self->{LayoutObject}->JSONEncode( Data => \%Data );

        return $Self->{LayoutObject}->Attachment(
            ContentType => 'application/json; charset=' . $Self->{LayoutObject}->{Charset},
            Content     => $OutputJSON,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # ------------------------------------------------------------ #
    # delete action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'DeleteAction' ) {

        # get the CategoryID
        my $CategoryID = $Self->{ParamObject}->GetParam( Param => 'CategoryID' ) || '';

        # check required parameters
        if ( !$CategoryID ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => 'No CategoryID is given!',
                Comment => 'Please contact the administrator.',
            );
        }

        # get category data
        my %CategoryData = $Self->{FAQObject}->CategoryGet(
            CategoryID => $CategoryID,
            UserID     => $Self->{UserID},
        );

        if ( !%CategoryData ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        # delete the category
        my $CouldDeleteCategory = $Self->{FAQObject}->CategoryDelete(
            CategoryID => $CategoryID,
            UserID     => $Self->{UserID},
        );

        if ($CouldDeleteCategory) {

            # redirect to explorer, when the deletion was successful
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=AgentFAQCategory",
            );
        }
        else {

            # show error message, when delete failed
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Was not able to delete the category $CategoryID!",
                Comment => 'Please contact the administrator.',
            );
        }
    }

    # ---------------------------------------------------------- #
    # overview
    # ---------------------------------------------------------- #
    else {

        # header
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # HTML output
        $Self->_Overview();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentFAQCategory',
            Data         => {
                %Param,
                %GetParam,
            },
        );

        # footer
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }
}

sub _Edit {
    my ( $Self, %Param ) = @_;

    # show overview
    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    # output overview blocks
    $Self->{LayoutObject}->Block( Name => 'ActionList' );
    $Self->{LayoutObject}->Block( Name => 'ActionOverview' );

    # get the valid list
    my %ValidList        = $Self->{ValidObject}->ValidList();
    my %ValidListReverse = reverse %ValidList;

    my %Data;

    # build the valid selection
    $Data{ValidOption} = $Self->{LayoutObject}->BuildSelection(
        Data       => \%ValidList,
        Name       => 'ValidID',
        SelectedID => $Param{ValidID} || $ValidListReverse{valid},
    );

    # get all valid groups
    my %Groups = $Self->{GroupObject}->GroupList( Valid => 1 );

    # set no server error class as default
    $Param{PermissionGroupsServerError} ||= '';

    # build the group selection
    $Data{GroupOption} = $Self->{LayoutObject}->BuildSelection(
        Data       => \%Groups,
        Name       => 'PermissionGroups',
        Multiple   => 1,
        Class      => 'Validate_Required ' . $Param{PermissionGroupsServerError},
        SelectedID => $Param{PermissionGroups},
    );

    # get all categories with their long names
    my $CategoryTree = $Self->{FAQObject}->CategoryTreeList(
        Valid  => 0,
        UserID => $Self->{UserID},
    );

    # build the category selection
    $Data{CategoryOption} = $Self->{LayoutObject}->BuildSelection(
        Data           => $CategoryTree,
        Name           => 'ParentID',
        SelectedID     => $Param{ParentID},
        PossibleNone   => 1,
        DisabledBranch => $CategoryTree->{ $Param{CategoryID} } || '',
        Translation    => 0,
    );

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
                Data => {%CategoryData},
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
