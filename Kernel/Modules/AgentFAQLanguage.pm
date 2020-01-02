# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AgentFAQLanguage;

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

    my %GetParam;

    my $MultiLanguage = $Kernel::OM->Get('Kernel::Config')->Get('FAQ::MultiLanguage');

    my $FAQObject   = $Kernel::OM->Get('Kernel::System::FAQ');
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # ------------------------------------------------------------ #
    # Change
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Change' && $MultiLanguage ) {

        # Get the LanguageID
        my $LanguageID = $ParamObject->GetParam( Param => 'LanguageID' ) || '';

        # Check required parameters.
        if ( !$LanguageID ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('No LanguageID is given!'),
                Comment => Translatable('Please contact the administrator.'),
            );
        }

        my %LanguageData = $FAQObject->LanguageGet(
            LanguageID => $LanguageID,
            UserID     => $Self->{UserID},
        );

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        $Self->_Edit(
            Action => 'Change',
            %LanguageData,
            %GetParam,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AgentFAQLanguage',
            Data         => {
                %Param,
            },
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # Change action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeAction' && $MultiLanguage ) {

        # Challenge token check for write action.
        $LayoutObject->ChallengeTokenCheck();

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        my %Error;
        for my $ParamName (qw(LanguageID Name)) {

            # Store needed parameters in %GetParam to make it re-loadable
            $GetParam{$ParamName} = $ParamObject->GetParam( Param => $ParamName );

            if ( !$GetParam{$ParamName} ) {

                # Add validation class and server error error class.
                $Error{ $ParamName . 'ServerError' } = 'ServerError';

                # Add server error string for category name field.
                if ( $ParamName eq 'Name' ) {
                    $Error{NameServerErrorMessage} = Translatable('The name is required!');
                }
            }
        }

        if ( $Param{Name} ) {

            # check for duplicate language name
            my $LanguageExistsAlready = $FAQObject->LanguageDuplicateCheck(
                Name       => $GetParam{Name},
                LanguageID => $GetParam{LanguageID},
                UserID     => $Self->{UserID},
            );
            if ($LanguageExistsAlready) {
                $Error{NameServerError}        = 'ServerError';
                $Error{NameServerErrorMessage} = Translatable('This language already exists!');
            }
        }

        if (%Error) {
            $Self->_Edit(
                Action => 'Change',
                %GetParam,
                %Error,
            );
            $Output .= $LayoutObject->Output(
                TemplateFile => 'AgentFAQLanguage',
                Data         => \%Param,
            );
            $Output .= $LayoutObject->Footer();

            return $Output;
        }

        # Update the language.
        my $LanguageUpdateSuccessful = $FAQObject->LanguageUpdate(
            %GetParam,
            UserID => $Self->{UserID},
        );
        if ( !$LanguageUpdateSuccessful ) {
            return $LayoutObject->ErrorScreen();
        }

        return $LayoutObject->Redirect( OP => "Action=$Self->{Action};Notification=Update" );
    }

    # ------------------------------------------------------------ #
    # Add
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Add' && $MultiLanguage ) {

        # Get the new name.
        $GetParam{Name} = $ParamObject->GetParam( Param => 'Name' );

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        $Self->_Edit(
            Action => 'Add',
            %GetParam,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AgentFAQLanguage',
            Data         => {
                %Param,
            },
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # Add action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AddAction' && $MultiLanguage ) {

        # Challenge token check for write action.
        $LayoutObject->ChallengeTokenCheck();

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        # Get the name.
        $GetParam{Name} = $ParamObject->GetParam( Param => 'Name' );

        my %Error;

        # check for name
        if ( !$GetParam{Name} ) {
            $Error{NameServerError}        = 'ServerError';
            $Error{NameServerErrorMessage} = Translatable('The name is required!');
        }
        else {

            # Check for duplicate language name.
            my $LanguageExistsAlready = $FAQObject->LanguageDuplicateCheck(
                Name       => $GetParam{Name},
                LanguageID => $GetParam{LanguageID},
                UserID     => $Self->{UserID},
            );
            if ($LanguageExistsAlready) {
                $Error{NameServerError}        = 'ServerError';
                $Error{NameServerErrorMessage} = Translatable('This language already exists!');
            }
        }

        if (%Error) {
            $Self->_Edit(
                Action => 'Add',
                %GetParam,
                %Error,
            );
            $Output .= $LayoutObject->Output(
                TemplateFile => 'AgentFAQLanguage',
                Data         => \%Param,
            );
            $Output .= $LayoutObject->Footer();

            return $Output;
        }

        # Add the new language.
        my $LanguageAddSuccessful = $FAQObject->LanguageAdd(
            %GetParam,
            UserID => $Self->{UserID},
        );
        if ( !$LanguageAddSuccessful ) {
            return $LayoutObject->ErrorScreen();
        }

        return $LayoutObject->Redirect( OP => "Action=$Self->{Action};Notification=Add" );
    }

    # ------------------------------------------------------------ #
    # Delete
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Delete' && $MultiLanguage ) {

        # Get the LanguageID.
        my $LanguageID = $ParamObject->GetParam( Param => 'LanguageID' ) || '';

        if ( !$LanguageID ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('No LanguageID is given!'),
                Comment => Translatable('Please contact the administrator.'),
            );
        }

        my %LanguageData = $FAQObject->LanguageGet(
            LanguageID => $LanguageID,
            UserID     => $Self->{UserID},
        );

        if ( !%LanguageData ) {
            return $LayoutObject->ErrorScreen();
        }

        my @AffectedItems = $FAQObject->FAQSearch(
            LanguageIDs => [$LanguageID],
            UserID      => 1,
        );

        $LayoutObject->Block(
            Name => 'Delete',
            Data => {%LanguageData},
        );

        # Set the dialog type. As default, the dialog will have 2 buttons: Yes and No.
        my $DialogType = 'Confirmation';

        # Display list of affected FAQ articles.
        if (@AffectedItems) {

            # Set the dialog type to have only 1 button: OK.
            $DialogType = 'Message';

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
        else {
            $LayoutObject->Block(
                Name => 'NoAffectedItems',
                Data => {%LanguageData},
            );
        }

        my $Output = $LayoutObject->Output(
            TemplateFile => 'AgentFAQLanguage',
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
    # Delete action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'DeleteAction' && $MultiLanguage ) {

        # Get the LanguageID.
        my $LanguageID = $ParamObject->GetParam( Param => 'LanguageID' ) || '';

        if ( !$LanguageID ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('No LanguageID is given!'),
                Comment => Translatable('Please contact the administrator.'),
            );
        }

        my %LanguageData = $FAQObject->LanguageGet(
            LanguageID => $LanguageID,
            UserID     => $Self->{UserID},
        );

        if ( !%LanguageData ) {
            return $LayoutObject->ErrorScreen();
        }

        # Delete the language.
        my $CouldDeleteLanguage = $FAQObject->LanguageDelete(
            LanguageID => $LanguageID,
            UserID     => $Self->{UserID},
        );

        if ($CouldDeleteLanguage) {

            # Redirect to explorer, when the deletion was successful.
            return $LayoutObject->Redirect(
                OP => "Action=AgentFAQLanguage",
            );
        }
        else {

            # Show error message, when delete failed.
            return $LayoutObject->ErrorScreen(
                Message => $LayoutObject->{LanguageObject}->Translate(
                    'Was not able to delete the language %s!',
                    $LanguageID,
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
            Update => Translatable('FAQ language updated!'),
            Add    => Translatable('FAQ language added!'),
        );
        if ( $Notification && $NotificationText{$Notification} ) {
            $Output .= $LayoutObject->Notify( Info => $NotificationText{$Notification} );
        }

        $Self->_Overview();
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AgentFAQLanguage',
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

    $LayoutObject->Block(
        Name => 'OverviewUpdate',
        Data => \%Param,
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

    my $MultiLanguage = $Kernel::OM->Get('Kernel::Config')->Get('FAQ::MultiLanguage');
    if ($MultiLanguage) {
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

        my %Languages = $FAQObject->LanguageList(
            UserID => $Self->{UserID},
        );

        my %JSData;

        # If there are any languages, they are shown.
        if (%Languages) {
            for my $LanguageID ( sort { $Languages{$a} cmp $Languages{$b} } keys %Languages ) {

                # Create structure for JS.
                $JSData{$LanguageID} = {
                    ElementID                  => 'DeleteLanguageID' . $LanguageID,
                    ElementSelector            => '#DeleteLanguageID' . $LanguageID,
                    DialogContentQueryString   => 'Action=AgentFAQLanguage;Subaction=Delete;LanguageID=' . $LanguageID,
                    ConfirmedActionQueryString => 'Action=AgentFAQLanguage;Subaction=DeleteAction;LanguageID='
                        . $LanguageID,
                    DialogTitle => $LayoutObject->{LanguageObject}->Translate(
                        'Delete Language %s',
                        $Languages{$LanguageID},
                    ),
                };

                # Get languages result.
                my %LanguageData = $FAQObject->LanguageGet(
                    LanguageID => $LanguageID,
                    UserID     => $Self->{UserID},
                );

                $LayoutObject->Block(
                    Name => 'OverviewResultRow',
                    Data => {%LanguageData},
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
                Data => {},
            );
        }
    }
    else {
        $LayoutObject->Block(
            Name => 'Disabled',
            Data => {},
        );
    }

    return 1;
}

1;
