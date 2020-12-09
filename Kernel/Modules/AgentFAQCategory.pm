# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AgentFAQCategory;

use strict;
use warnings;

use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # Permission check.
    if ( !$Self->{AccessRw} ) {
        return $LayoutObject->NoPermission(
            Message    => Translatable('You need rw permission!'),
            WithHeader => 'yes',
        );
    }

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # Get parameters from web request.
    my %GetParam;
    for my $ParamName (qw(CategoryID Name ParentID Comment ValidID)) {
        $GetParam{$ParamName} = $ParamObject->GetParam( Param => $ParamName );
    }

    # Set defaults
    $GetParam{CategoryID} ||= 0;
    $GetParam{ParentID}   ||= 0;

    # Get array parameters from web request.
    @{ $GetParam{PermissionGroups} } = $ParamObject->GetArray( Param => 'PermissionGroups' );

    my $FAQObject = $Kernel::OM->Get('Kernel::System::FAQ');

    # ------------------------------------------------------------ #
    # Change
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Change' ) {

        if ( !$GetParam{CategoryID} ) {
            $LayoutObject->FatalError(
                Message => Translatable('Need CategoryID!'),
            );
        }

        my %CategoryData = $FAQObject->CategoryGet(
            CategoryID => $GetParam{CategoryID},
            UserID     => $Self->{UserID},
        );

        # Get permission groups.
        $CategoryData{PermissionGroups} = $FAQObject->CategoryGroupGet(
            CategoryID => $GetParam{CategoryID},
            UserID     => $Self->{UserID},
        );

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        $Self->_Edit(
            Action => 'Change',
            %CategoryData,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AgentFAQCategory',
            Data         => \%Param,
        );

        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # Change action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {

        # Challenge token check for write action.
        $LayoutObject->ChallengeTokenCheck();

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        for my $ParamName (qw(ParentID ValidID)) {
            if ( !defined $GetParam{$ParamName} ) {

                return $LayoutObject->FatalError(
                    Message => $LayoutObject->{LanguageObject}->Translate( 'Need %s!', $ParamName ),
                );
            }
        }

        my %Error;
        for my $ParamName (qw(Name Comment PermissionGroups)) {

            if ( !$GetParam{$ParamName} ) {

                # Add server error error class.
                $Error{ $ParamName . 'ServerError' } = 'ServerError';

                # Add server error string for category name field.
                if ( $ParamName eq 'Name' ) {
                    $Error{NameServerErrorMessage} = Translatable('A category should have a name!');
                }
            }
        }

        if ( $GetParam{Name} ) {

            # Check for duplicate category name with the same parent category.
            my $CategoryExistsAlready = $FAQObject->CategoryDuplicateCheck(
                CategoryID => $GetParam{CategoryID},
                Name       => $GetParam{Name},
                ParentID   => $GetParam{ParentID},
                UserID     => $Self->{UserID},
            );
            if ($CategoryExistsAlready) {
                $Error{NameServerError}        = 'ServerError';
                $Error{NameServerErrorMessage} = Translatable('This category already exists');
            }
        }

        # Send server error if any required parameter is missing or wrong.
        if (%Error) {

            $Self->_Edit(
                Action => 'Change',
                %GetParam,
                %Error,
            );
            $Output .= $LayoutObject->Output(
                TemplateFile => 'AgentFAQCategory',
                Data         => \%Param,
            );
            $Output .= $LayoutObject->Footer();

            return $Output;
        }

        my $CategoryUpdateSuccessful = $FAQObject->CategoryUpdate(
            %GetParam,
            UserID => $Self->{UserID},
        );
        if ( !$CategoryUpdateSuccessful ) {
            return $LayoutObject->ErrorScreen();
        }

        $FAQObject->SetCategoryGroup(
            CategoryID => $GetParam{CategoryID},
            GroupIDs   => $GetParam{PermissionGroups},
            UserID     => $Self->{UserID},
        );

        return $LayoutObject->Redirect( OP => "Action=$Self->{Action};Notification=Update" );
    }

    # ------------------------------------------------------------ #
    # Add
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Add' ) {

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        $Self->_Edit(
            Action => 'Add',
            %GetParam,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AgentFAQCategory',
            Data         => \%Param,
        );

        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # add action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AddAction' ) {

        # Challenge token check for write action.
        $LayoutObject->ChallengeTokenCheck();

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        # Check required parameters.
        for my $ParamName (qw(ParentID ValidID)) {
            if ( !defined $GetParam{$ParamName} ) {
                return $LayoutObject->FatalError(
                    Message => $LayoutObject->{LanguageObject}->Translate( 'Need %s!', $ParamName ),
                );
            }
        }

        # Check required parameters
        my %Error;
        for my $ParamName (qw(Name Comment PermissionGroups)) {

            # If required field is not given.
            if ( !$GetParam{$ParamName} ) {

                # Add validation class and server error error class.
                $Error{ $ParamName . 'ServerError' } = 'ServerError';

                # Add server error string for category name field.
                if ( $ParamName eq 'Name' ) {
                    $Error{NameServerErrorMessage} = Translatable('A category should have a name!');
                }
            }
        }

        if ( $GetParam{Name} ) {

            # Check for duplicate category name with the same parent category
            my $CategoryExistsAlready = $FAQObject->CategoryDuplicateCheck(
                CategoryID => $GetParam{CategoryID},
                Name       => $GetParam{Name},
                ParentID   => $GetParam{ParentID},
                UserID     => $Self->{UserID},
            );
            if ($CategoryExistsAlready) {
                $Error{NameServerError}        = 'ServerError';
                $Error{NameServerErrorMessage} = Translatable('This category already exists!');
            }
        }

        # Send server error if any required parameters are missing or wrong
        if (%Error) {

            # HTML output
            $Self->_Edit(
                Action => 'Add',
                %GetParam,
                %Error,
            );
            $Output .= $LayoutObject->Output(
                TemplateFile => 'AgentFAQCategory',
                Data         => \%Param,
            );

            # footer
            $Output .= $LayoutObject->Footer();

            return $Output;
        }

        # Add new category.
        my $CategoryID = $FAQObject->CategoryAdd(
            %GetParam,
            UserID => $Self->{UserID},
        );
        if ( !$CategoryID ) {
            return $LayoutObject->ErrorScreen();
        }

        $FAQObject->SetCategoryGroup(
            CategoryID => $CategoryID,
            GroupIDs   => $GetParam{PermissionGroups},
            UserID     => $Self->{UserID},
        );

        return $LayoutObject->Redirect( OP => "Action=$Self->{Action};Notification=Add" );
    }

    # ------------------------------------------------------------ #
    # Delete
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Delete' ) {

        my $CategoryID = $ParamObject->GetParam( Param => 'CategoryID' ) || '';
        if ( !$CategoryID ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('No CategoryID is given!'),
                Comment => Translatable('Please contact the administrator.'),
            );
        }

        my %CategoryData = $FAQObject->CategoryGet(
            CategoryID => $CategoryID,
            UserID     => $Self->{UserID},
        );
        if ( !%CategoryData ) {
            return $LayoutObject->ErrorScreen();
        }

        # Get all affected FAQ articles
        my @AffectedItems = $FAQObject->FAQSearch(
            CategoryIDs => [$CategoryID],
            UserID      => 1,
        );

        # Get all affected SubCcategories.
        my $AffectedSubCategories = $FAQObject->CategorySubCategoryIDList(
            ParentID => $CategoryID,
            Mode     => 'Agent',
            UserID   => 1,
        );

        $LayoutObject->Block(
            Name => 'Delete',
            Data => {%CategoryData},
        );

        # Set the dialog type. As default, the dialog will have 2 buttons: Yes and No.
        my $DialogType = 'Confirmation';

        # Display list of affected FAQ articles or SubCategories.
        if ( @AffectedItems || @{$AffectedSubCategories} ) {

            # Set the dialog type to have only 1 button: OK.
            $DialogType = 'Message';

            $LayoutObject->Block(
                Name => 'Affected',
                Data => {},
            );

            # Display Affected FAQ articles.
            if (@AffectedItems) {

                $LayoutObject->Block(
                    Name => 'AffectedItems',
                    Data => {},
                );

                ITEMID:
                for my $ItemID (@AffectedItems) {

                    my %FAQData = $FAQObject->FAQGet(
                        ItemID     => $ItemID,
                        ItemFields => 0,
                        UserID     => $Self->{UserID},
                    );
                    next ITEMID if !%FAQData;

                    $LayoutObject->Block(
                        Name => 'AffectedItemsRow',
                        Data => {
                            %FAQData,
                            %Param,
                        },
                    );
                }
            }

            # Display Affected Subcategories.
            if ( @{$AffectedSubCategories} ) {

                # Get categories long names.
                my $CategoryLongNames = $FAQObject->GetUserCategoriesLongNames(
                    Type   => 'ro',
                    UserID => 1,
                );
                $LayoutObject->Block(
                    Name => 'AffectedSubCategories',
                    Data => {},
                );
                CATEGORYID:
                for my $CategoryID ( @{$AffectedSubCategories} ) {

                    my %CategoryData = $FAQObject->CategoryGet(
                        CategoryID => $CategoryID,
                        UserID     => $Self->{UserID},
                    );

                    # Set category long name.
                    $CategoryData{LongName} = $CategoryLongNames->{$CategoryID};

                    next CATEGORYID if !%CategoryData;

                    $LayoutObject->Block(
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
            $LayoutObject->Block(
                Name => 'NoAffected',
                Data => {%CategoryData},
            );
        }

        my $Output = $LayoutObject->Output(
            TemplateFile => 'AgentFAQCategory',
            Data         => {},
        );

        # Build the returned data structure.
        my %Data = (
            HTML       => $Output,
            DialogType => $DialogType,
        );

        # Return JSON-String because of AJAX-Mode.
        my $OutputJSON = $LayoutObject->JSONEncode( Data => \%Data );

        return $LayoutObject->Attachment(
            ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
            Content     => $OutputJSON,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # ------------------------------------------------------------ #
    # delete action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'DeleteAction' ) {

        my $CategoryID = $ParamObject->GetParam( Param => 'CategoryID' ) || '';

        if ( !$CategoryID ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('No CategoryID is given!'),
                Comment => Translatable('Please contact the administrator.'),
            );
        }

        my %CategoryData = $FAQObject->CategoryGet(
            CategoryID => $CategoryID,
            UserID     => $Self->{UserID},
        );

        if ( !%CategoryData ) {
            return $LayoutObject->ErrorScreen();
        }

        # Delete the category.
        my $CouldDeleteCategory = $FAQObject->CategoryDelete(
            CategoryID => $CategoryID,
            UserID     => $Self->{UserID},
        );

        if ($CouldDeleteCategory) {

            # Redirect to explorer, when the deletion was successful.
            return $LayoutObject->Redirect(
                OP => "Action=AgentFAQCategory",
            );
        }
        else {

            # Show error message, when delete failed.
            return $LayoutObject->ErrorScreen(
                Message => $LayoutObject->{LanguageObject}->Translate(
                    'Was not able to delete the category %s!',
                    $CategoryID,
                ),
                Comment => Translatable('Please contact the administrator.'),
            );
        }
    }

    # ---------------------------------------------------------- #
    # Overview
    # ---------------------------------------------------------- #
    else {

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        my $Notification     = $ParamObject->GetParam( Param => 'Notification' ) || '';
        my %NotificationText = (
            Update => Translatable('FAQ category updated!'),
            Add    => Translatable('FAQ category added!'),
        );
        if ( $Notification && $NotificationText{$Notification} ) {
            $Output .= $LayoutObject->Notify( Info => $NotificationText{$Notification} );
        }

        $Self->_Overview();
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AgentFAQCategory',
            Data         => {
                %Param,
                %GetParam,
            },
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }
}

sub _Edit {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
    );
    $LayoutObject->Block(
        Name => 'ActionList',
        Data => {},
    );
    $LayoutObject->Block(
        Name => 'ActionOverview',
        Data => {},
    );

    my %ValidList        = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();
    my %ValidListReverse = reverse %ValidList;

    my %Data;

    # Build the valid selection.
    $Data{ValidOption} = $LayoutObject->BuildSelection(
        Data       => \%ValidList,
        Name       => 'ValidID',
        SelectedID => $Param{ValidID} || $ValidListReverse{valid},
        Class      => 'Modernize',
    );

    # Get all valid groups.
    my %Groups = $Kernel::OM->Get('Kernel::System::Group')->GroupList(
        Valid => 1,
    );

    # Set no server error class as default.
    $Param{PermissionGroupsServerError} ||= '';

    # Build the group selection.
    $Data{GroupOption} = $LayoutObject->BuildSelection(
        Data        => \%Groups,
        Name        => 'PermissionGroups',
        Multiple    => 1,
        Translation => 0,
        Class       => 'Validate_Required Modernize ' . $Param{PermissionGroupsServerError},
        SelectedID  => $Param{PermissionGroups},
    );

    # Get all categories with their long names.
    my $CategoryTree = $Kernel::OM->Get('Kernel::System::FAQ')->CategoryTreeList(
        Valid  => 0,
        UserID => $Self->{UserID},
    );

    # Build the category selection.
    $Data{CategoryOption} = $LayoutObject->BuildSelection(
        Data           => $CategoryTree,
        Name           => 'ParentID',
        SelectedID     => $Param{ParentID},
        PossibleNone   => 1,
        DisabledBranch => $CategoryTree->{ $Param{CategoryID} } || '',
        Translation    => 0,
        Class          => 'Modernize',
    );

    $LayoutObject->Block(
        Name => 'OverviewUpdate',
        Data => {
            %Param,
            %Data,
        },
    );

    if ( $Param{Action} eq 'Change' ) {
        $LayoutObject->Block(
            Name => 'HeaderEdit',
            Data => {},
        );
    }
    else {
        $LayoutObject->Block(
            Name => 'HeaderAdd',
            Data => {},
        );
    }

    return 1;
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    my $Output = '';

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $LayoutObject->Block(
        Name => 'Overview',
        Data => {},
    );
    $LayoutObject->Block(
        Name => 'ActionList',
        Data => {},
    );
    $LayoutObject->Block(
        Name => 'ActionAdd',
        Data => {},
    );
    $LayoutObject->Block(
        Name => 'OverviewResult',
        Data => {},
    );

    my $FAQObject = $Kernel::OM->Get('Kernel::System::FAQ');

    # Get all categories with their long names.
    my $CategoryTree = $FAQObject->CategoryTreeList(
        Valid  => 0,
        UserID => $Self->{UserID},
    );

    # If there are any categories, they are shown.
    if ( $CategoryTree && ref $CategoryTree eq 'HASH' && %{$CategoryTree} ) {

        my %ValidList = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();

        # Sort the category ids by the long category name.
        my @CategoryIDsSorted = sort { $CategoryTree->{$a} cmp $CategoryTree->{$b} } keys %{$CategoryTree};

        my %JSData;

        # Show all categories.
        for my $CategoryID (@CategoryIDsSorted) {

            # Create structure for JS.
            $JSData{$CategoryID} = {
                ElementID                  => 'DeleteCategoryID' . $CategoryID,
                ElementSelector            => '#DeleteCategoryID' . $CategoryID,
                DialogContentQueryString   => 'Action=AgentFAQCategory;Subaction=Delete;CategoryID=' . $CategoryID,
                ConfirmedActionQueryString => 'Action=AgentFAQCategory;Subaction=DeleteAction;CategoryID='
                    . $CategoryID,
                DialogTitle => $LayoutObject->{LanguageObject}->Translate('Delete Category'),
            };

            # Get category data.
            my %CategoryData = $FAQObject->CategoryGet(
                CategoryID => $CategoryID,
                UserID     => $Self->{UserID},
            );

            # Get valid string based on ValidID.
            $CategoryData{Valid} = $ValidList{ $CategoryData{ValidID} };

            # Overwrite the name with the long name.
            $CategoryData{Name} = $CategoryTree->{$CategoryID};

            # Output the category data.
            $LayoutObject->Block(
                Name => 'OverviewResultRow',
                Data => {%CategoryData},
            );
        }

        $LayoutObject->AddJSData(
            Key   => 'FAQData',
            Value => \%JSData,
        );
    }

    # Otherwise a no data found message is displayed.
    else {
        $LayoutObject->Block(
            Name => 'NoDataFoundMsg',
        );
    }

    return 1;
}

1;
