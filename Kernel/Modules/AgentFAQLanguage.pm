# --
# Kernel/Modules/AgentFAQLanguage.pm - the FAQ language management module
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentFAQLanguage;

use strict;
use warnings;

use Kernel::System::FAQ;

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

    $Self->{MultiLanguage} = $Self->{ConfigObject}->Get('FAQ::MultiLanguage');

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

    my %GetParam;

    # ------------------------------------------------------------ #
    # change
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Change' && $Self->{MultiLanguage} ) {

        # get the LanguageID
        my $LanguageID = $Self->{ParamObject}->GetParam( Param => 'LanguageID' ) || '';

        # check required parameters
        if ( !$LanguageID ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => 'No LanguageID is given!',
                Comment => 'Please contact the administrator.',
            );
        }

        # get language data
        my %LanguageData = $Self->{FAQObject}->LanguageGet(
            LanguageID => $LanguageID,
            UserID     => $Self->{UserID},
        );

        # header
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # output change language screen
        $Self->_Edit(
            Action => 'Change',
            %LanguageData,
            %GetParam,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentFAQLanguage',
            Data         => {
                %Param,
            },
        );

        # footer
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # change action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeAction' && $Self->{MultiLanguage} ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # header
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # check for name and language id
        for my $ParamName (qw(LanguageID Name)) {

            # store needed parameters in %GetParam to make it re-loadable
            $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );

            if ( !$GetParam{$ParamName} ) {

                # HTML output
                $Self->_Edit(
                    Action                 => 'Change',
                    NameServerError        => 'ServerError',
                    NameServerErrorMessage => 'The name is required!',
                    %GetParam,
                );
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'AgentFAQLanguage',
                    Data         => \%Param,
                );

                # footer
                $Output .= $Self->{LayoutObject}->Footer();

                return $Output;
            }
        }

        # check for duplicate language name
        my $LanguageExistsAlready = $Self->{FAQObject}->LanguageDuplicateCheck(
            Name       => $GetParam{Name},
            LanguageID => $GetParam{LanguageID},
            UserID     => $Self->{UserID},
        );

        # show the edit screen again
        if ($LanguageExistsAlready) {

            # HTML output
            $Self->_Edit(
                Action                 => 'Change',
                NameServerError        => 'ServerError',
                NameServerErrorMessage => 'This language already exists!',
                %GetParam,
            );
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AgentFAQLanguage',
                Data         => \%Param,
            );

            # footer
            $Output .= $Self->{LayoutObject}->Footer();

            return $Output;
        }

        # update the language
        my $LanguageUpdateSuccessful = $Self->{FAQObject}->LanguageUpdate(
            %GetParam,
            UserID => $Self->{UserID},
        );

        # check error
        if ( !$LanguageUpdateSuccessful ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        # show overview
        $Self->_Overview();
        $Output .= $Self->{LayoutObject}->Notify(
            Info => 'FAQ language updated!',
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentFAQLanguage',
            Data         => \%Param,
        );

        # footer
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # add
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Add' && $Self->{MultiLanguage} ) {

        # get the new name
        $GetParam{Name} = $Self->{ParamObject}->GetParam( Param => 'Name' );

        # header
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # HTML output
        $Self->_Edit(
            Action => 'Add',
            %GetParam,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentFAQLanguage',
            Data         => {
                %Param,
            },
        );

        # footer
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # add action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AddAction' && $Self->{MultiLanguage} ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # header
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # get the name
        $GetParam{Name} = $Self->{ParamObject}->GetParam( Param => 'Name' );

        # check for name
        if ( !$GetParam{Name} ) {

            # HTML output
            $Self->_Edit(
                Action                 => 'Add',
                NameServerError        => 'ServerError',
                NameServerErrorMessage => 'The name is required!',
                %GetParam,
            );
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AgentFAQLanguage',
                Data         => \%Param,
            );

            # footer
            $Output .= $Self->{LayoutObject}->Footer();

            return $Output;
        }

        # check for duplicate language name
        my $LanguageExistsAlready = $Self->{FAQObject}->LanguageDuplicateCheck(
            Name   => $GetParam{Name},
            UserID => $Self->{UserID},
        );

        # show the edit screen again
        if ($LanguageExistsAlready) {
            $Self->_Edit(
                Action                 => 'Add',
                NameServerError        => 'ServerError',
                NameServerErrorMessage => "This language already exists!",
                %GetParam,
            );
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AgentFAQLanguage',
                Data         => \%Param,
            );

            # footer
            $Output .= $Self->{LayoutObject}->Footer();

            return $Output;
        }

        # add the new language
        my $LanguageAddSuccessful = $Self->{FAQObject}->LanguageAdd(
            %GetParam,
            UserID => $Self->{UserID},
        );

        # check error
        if ( !$LanguageAddSuccessful ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        # show overview
        $Output .= $Self->{LayoutObject}->Notify(
            Info => 'FAQ language added!',
        );
        $Self->_Overview();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentFAQLanguage',
            Data         => {
                %Param,
            },
        );

        # footer
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # delete
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Delete' && $Self->{MultiLanguage} ) {

        # get the LanguageID
        my $LanguageID = $Self->{ParamObject}->GetParam( Param => 'LanguageID' ) || '';

        # check required parameters
        if ( !$LanguageID ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => 'No LanguageID is given!',
                Comment => 'Please contact the administrator.',
            );
        }

        # get language data
        my %LanguageData = $Self->{FAQObject}->LanguageGet(
            LanguageID => $LanguageID,
            UserID     => $Self->{UserID},
        );

        if ( !%LanguageData ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        my @AffectedItems = $Self->{FAQObject}->FAQSearch(
            LanguageIDs => [$LanguageID],
            UserID      => 1,
        );

        # call Delete block
        $Self->{LayoutObject}->Block(
            Name => 'Delete',
            Data => {%LanguageData},
        );

        # set the dialog type. As default, the dialog will have 2 buttons: Yes and No
        my $DialogType = 'Confirmation';

        # display list of affected FAQ articles
        if (@AffectedItems) {

            # set the dialog type to have only 1 button: OK
            $DialogType = 'Message';

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
        else {
            $Self->{LayoutObject}->Block(
                Name => 'NoAffectedItems',
                Data => {%LanguageData},
            );
        }

        # output content
        my $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentFAQLanguage',
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
    elsif ( $Self->{Subaction} eq 'DeleteAction' && $Self->{MultiLanguage} ) {

        # get the LanguageID
        my $LanguageID = $Self->{ParamObject}->GetParam( Param => 'LanguageID' ) || '';

        # check required parameters
        if ( !$LanguageID ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => 'No LanguageID is given!',
                Comment => 'Please contact the administrator.',
            );
        }

        # get language data
        my %LanguageData = $Self->{FAQObject}->LanguageGet(
            LanguageID => $LanguageID,
            UserID     => $Self->{UserID},
        );

        if ( !%LanguageData ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        # delete the language
        my $CouldDeleteLanguage = $Self->{FAQObject}->LanguageDelete(
            LanguageID => $LanguageID,
            UserID     => $Self->{UserID},
        );

        if ($CouldDeleteLanguage) {

            # redirect to explorer, when the deletion was successful
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=AgentFAQLanguage",
            );
        }
        else {

            # show error message, when delete failed
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Was not able to delete the language $LanguageID!",
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
            TemplateFile => 'AgentFAQLanguage',
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

    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => \%Param,
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

    # output overview blocks
    $Self->{LayoutObject}->Block( Name => 'Overview' );

    if ( $Self->{MultiLanguage} ) {
        $Self->{LayoutObject}->Block( Name => 'ActionList' );
        $Self->{LayoutObject}->Block( Name => 'ActionAdd' );
        $Self->{LayoutObject}->Block( Name => 'OverviewResult' );

        # get languages list
        my %Languages = $Self->{FAQObject}->LanguageList(
            UserID => $Self->{UserID},
        );

        # if there are any languages, they are shown
        if (%Languages) {
            for my $LanguageID ( sort { $Languages{$a} cmp $Languages{$b} } keys %Languages ) {

                # get languages result
                my %LanguageData = $Self->{FAQObject}->LanguageGet(
                    LanguageID => $LanguageID,
                    UserID     => $Self->{UserID},
                );

                #output results
                $Self->{LayoutObject}->Block(
                    Name => 'OverviewResultRow',
                    Data => {%LanguageData},
                );
            }
        }

        # otherwise a no data found message is displayed
        else {
            $Self->{LayoutObject}->Block( Name => 'NoDataFoundMsg' );
        }
    }
    else {
        $Self->{LayoutObject}->Block( Name => 'Disabled' );
    }
}

1;
