# --
# Kernel/Modules/AgentITSMChangeTemplate.pm - the OTRS ITSM ChangeManagement add template module
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMChangeTemplate;

use strict;
use warnings;

use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::Template;
use Kernel::System::Valid;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (
        qw(ParamObject DBObject LayoutObject LogObject ConfigObject UserObject GroupObject)
        )
    {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Object!" );
        }
    }

    # create additional objects
    $Self->{ChangeObject}   = Kernel::System::ITSMChange->new(%Param);
    $Self->{TemplateObject} = Kernel::System::ITSMChange::Template->new(%Param);
    $Self->{ValidObject}    = Kernel::System::Valid->new(%Param);

    # get config of frontend module
    $Self->{Config} = $Self->{ConfigObject}->Get("ITSMChange::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get needed ChangeID
    my $ChangeID = $Self->{ParamObject}->GetParam( Param => 'ChangeID' );

    # check needed stuff
    if ( !$ChangeID ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'No ChangeID is given!',
            Comment => 'Please contact the administrator.',
        );
    }

    # check permissions
    my $Access = $Self->{ChangeObject}->Permission(
        Type     => $Self->{Config}->{Permission},
        Action   => $Self->{Action},
        ChangeID => $ChangeID,
        UserID   => $Self->{UserID},
    );

    # error screen
    if ( !$Access ) {
        return $Self->{LayoutObject}->NoPermission(
            Message    => "You need $Self->{Config}->{Permission} permissions!",
            WithHeader => 'yes',
        );
    }

    # get change
    my $Change = $Self->{ChangeObject}->ChangeGet(
        ChangeID => $ChangeID,
        UserID   => $Self->{UserID},
    );

    # error screen
    if ( !$Change ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "No change found for change ID $ChangeID.",
            Comment => 'Please contact the administrator.',
        );
    }

    # store needed parameters in %GetParam to make it reloadable
    my %GetParam;
    for my $ParamName (qw(TemplateName Comment ValidID StateReset OverwriteTemplate DeleteChange ))
    {
        $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
    }

    # get existing user preferences
    my %UserPreferences = $Self->{UserObject}->GetPreferences(
        UserID => $Self->{UserID},
    );

    # get preference to see which templates are in edit by the user
    my $TemplateEditPreferenceString = $UserPreferences{UserITSMChangeManagementTemplateEdit} || '';

    # convert to lookup hash
    my @EditedTemplates = split m/;/, $TemplateEditPreferenceString;
    my %Object2Template;
    for my $String (@EditedTemplates) {
        my ( $Object, $Template ) = split m/::/, $String;
        $Object2Template{$Object} = $Template;
    }

    # get template id from user preferences
    my $TemplateID = $Object2Template{ 'ChangeID' . $ChangeID };

    # check if this change was created by this user using a template
    if ($TemplateID) {

        # get template data
        my $TemplateData = $Self->{TemplateObject}->TemplateGet(
            TemplateID => $TemplateID,
            UserID     => 1,
        );

        if ($TemplateData) {

            # overwrite empty values with template data
            $GetParam{TemplateName} ||= $TemplateData->{Name};
            $GetParam{Comment}      ||= $TemplateData->{Comment};
            $GetParam{ValidID}      ||= $TemplateData->{ValidID};
        }
        else {
            $TemplateID = '';
        }
    }

    # Check required fields to look for errors.
    my %Error;

    # add a template
    if ( $Self->{Subaction} eq 'AddTemplate' ) {

        # check validity of the template name
        if ( !$GetParam{TemplateName} ) {
            $Error{'TemplateNameInvalid'} = 'ServerError';
        }

        if ( !%Error ) {

            # serialize the change
            my $TemplateContent = $Self->{TemplateObject}->TemplateSerialize(
                TemplateType => 'ITSMChange',
                StateReset   => $GetParam{StateReset} || 0,
                ChangeID     => $ChangeID,
                UserID       => $Self->{UserID},
            );

            # show error message
            if ( !$TemplateContent ) {
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "The change '$ChangeID' could not be serialized.",
                    Comment => 'Please contact the administrator.',
                );
            }

            # if this change was created from a template and should be saved back
            if ( $TemplateID && $GetParam{OverwriteTemplate} ) {

                my $UpdateSuccess = $Self->{TemplateObject}->TemplateUpdate(
                    TemplateID => $TemplateID,
                    Name       => $GetParam{TemplateName},
                    Comment    => $GetParam{Comment},
                    ValidID    => $GetParam{ValidID},
                    Content    => $TemplateContent,
                    UserID     => $Self->{UserID},
                );

                # show error message
                if ( !$UpdateSuccess ) {
                    return $Self->{LayoutObject}->ErrorScreen(
                        Message => "Could not update the template '$TemplateID'.",
                        Comment => 'Please contact the administrator.',
                    );
                }
            }
            else {
                # store the serialized change as a new template
                $TemplateID = $Self->{TemplateObject}->TemplateAdd(
                    Name         => $GetParam{TemplateName},
                    Comment      => $GetParam{Comment},
                    ValidID      => $GetParam{ValidID},
                    TemplateType => 'ITSMChange',
                    Content      => $TemplateContent,
                    UserID       => $Self->{UserID},
                );

                # show error message
                if ( !$TemplateID ) {
                    return $Self->{LayoutObject}->ErrorScreen(
                        Message => "Could not add the template.",
                        Comment => 'Please contact the administrator.',
                    );
                }
            }

            # define redirect URL
            my $RedirectURL = "Action=AgentITSMChangeZoom;ChangeID=$ChangeID";

            # if the original change should be deleted
            if ( $GetParam{DeleteChange} ) {

                # delete the change
                my $DeleteSuccess = $Self->{ChangeObject}->ChangeDelete(
                    ChangeID => $ChangeID,
                    UserID   => $Self->{UserID},
                );

                # show error message
                if ( !$DeleteSuccess ) {
                    return $Self->{LayoutObject}->ErrorScreen(
                        Message => "Could not delete change '$ChangeID'.",
                        Comment => 'Please contact the administrator.',
                    );
                }

                # delete the user preference entry
                delete $Object2Template{ 'ChangeID' . $ChangeID };

                # redirect to template overview
                $RedirectURL = 'Action=AgentITSMTemplateOverview';
            }

            # update the user preference with the new template id
            elsif ( $Object2Template{ 'ChangeID' . $ChangeID } ) {
                $Object2Template{ 'ChangeID' . $ChangeID } = $TemplateID;
            }

            # convert to string
            $TemplateEditPreferenceString = '';
            for my $Object ( sort keys %Object2Template ) {
                $TemplateEditPreferenceString .= $Object . '::' . $Object2Template{$Object} . ';';
            }

            # save preferences
            $Self->{UserObject}->SetPreferences(
                Key    => 'UserITSMChangeManagementTemplateEdit',
                Value  => $TemplateEditPreferenceString,
                UserID => $Self->{UserID},
            );

            # load new URL in parent window and close popup
            return $Self->{LayoutObject}->PopupClose(
                URL => $RedirectURL,
            );
        }
    }

    # output header
    my $Output = $Self->{LayoutObject}->Header(
        Type  => 'Small',
        Title => 'Template',
    );

    # build valid selection
    my $ValidSelectionString = $Self->{LayoutObject}->BuildSelection(
        Data => {
            $Self->{ValidObject}->ValidList(),
        },
        Name       => 'ValidID',
        SelectedID => $GetParam{ValidID} || ( $Self->{ValidObject}->ValidIDsGet() )[0],
        Sort       => 'NumericKey',
    );

    # build selection string for state reset
    my $StateResetSelectionString = $Self->{LayoutObject}->BuildSelection(
        Data => {
            0 => 'No',
            1 => 'Yes',
        },
        Name       => 'StateReset',
        SelectedID => $GetParam{StateReset} // 1,
    );

    # show dropdowns only if this change was created from a template
    if ($TemplateID) {

        # build selection string for template overwrite, default is yes
        my $OverwriteTemplateSelectionString = $Self->{LayoutObject}->BuildSelection(
            Data => {
                0 => 'No',
                1 => 'Yes',
            },
            Name       => 'OverwriteTemplate',
            SelectedID => $GetParam{OverwriteTemplate} // 1,
        );

        # show overwrite original template dropdown
        $Self->{LayoutObject}->Block(
            Name => 'OverwriteTemplate',
            Data => {
                %GetParam,
                OverwriteTemplateSelectionString => $OverwriteTemplateSelectionString,
            },
        );

        # build selection string for delete change
        my $DeleteChangeSelectionString = $Self->{LayoutObject}->BuildSelection(
            Data => {
                0 => 'No',
                1 => 'Yes',
            },
            Name       => 'DeleteChange',
            SelectedID => $GetParam{DeleteChange} // 1,
        );

        # show delete change dropdown
        $Self->{LayoutObject}->Block(
            Name => 'DeleteChange',
            Data => {
                %GetParam,
                DeleteChangeSelectionString => $DeleteChangeSelectionString,
            },
        );
    }

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMChangeTemplate',
        Data         => {
            %GetParam,
            ChangeID                  => $ChangeID,
            ValidSelectionString      => $ValidSelectionString,
            StateResetSelectionString => $StateResetSelectionString,
            ChangeNumber              => $Change->{ChangeNumber},
            ChangeTitle               => $Change->{ChangeTitle},
            %Error,
        },
    );

    # add footer
    $Output .= $Self->{LayoutObject}->Footer( Type => 'Small' );

    return $Output;
}

1;
