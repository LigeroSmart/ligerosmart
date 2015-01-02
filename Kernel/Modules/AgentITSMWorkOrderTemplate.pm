# --
# Kernel/Modules/AgentITSMWorkOrderTemplate.pm - the OTRS ITSM ChangeManagement add template module
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMWorkOrderTemplate;

use strict;
use warnings;

use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::ITSMWorkOrder;
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
    $Self->{ChangeObject}    = Kernel::System::ITSMChange->new(%Param);
    $Self->{WorkOrderObject} = Kernel::System::ITSMChange::ITSMWorkOrder->new(%Param);
    $Self->{TemplateObject}  = Kernel::System::ITSMChange::Template->new(%Param);
    $Self->{ValidObject}     = Kernel::System::Valid->new(%Param);

    # get config of frontend module
    $Self->{Config} = $Self->{ConfigObject}->Get("ITSMWorkOrder::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get needed WorkOrderID
    my $WorkOrderID = $Self->{ParamObject}->GetParam( Param => 'WorkOrderID' );

    # check needed stuff
    if ( !$WorkOrderID ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'No WorkOrderID is given!',
            Comment => 'Please contact the administrator.',
        );
    }

    # get workorder data
    my $WorkOrder = $Self->{WorkOrderObject}->WorkOrderGet(
        WorkOrderID => $WorkOrderID,
        UserID      => $Self->{UserID},
    );

    # check if LayoutObject has TranslationObject
    if ( $Self->{LayoutObject}->{LanguageObject} ) {

        # translate workorder type
        $WorkOrder->{WorkOrderType} = $Self->{LayoutObject}->{LanguageObject}->Translate(
            $WorkOrder->{WorkOrderType}
        );
    }

    # check error
    if ( !$WorkOrder ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "WorkOrder '$WorkOrderID' not found in database!",
            Comment => 'Please contact the administrator.',
        );
    }

    # check permissions
    my $Access = $Self->{ChangeObject}->Permission(
        Type        => $Self->{Config}->{Permission},
        Action      => $Self->{Action},
        ChangeID    => $WorkOrder->{ChangeID},
        WorkOrderID => $WorkOrderID,
        UserID      => $Self->{UserID},
    );

    # error screen
    if ( !$Access ) {
        return $Self->{LayoutObject}->NoPermission(
            Message    => "You need $Self->{Config}->{Permission} permissions!",
            WithHeader => 'yes',
        );
    }

    # store needed parameters in %GetParam to make it reloadable
    my %GetParam;
    for my $ParamName (
        qw(TemplateName Comment ValidID StateReset OverwriteTemplate DeleteWorkOrder)
        )
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
    my $TemplateID = $Object2Template{ 'WorkOrderID' . $WorkOrderID };

    # check if this workorder was created by this user using a template
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

            # serialize the workorder
            my $TemplateContent = $Self->{TemplateObject}->TemplateSerialize(
                TemplateType => 'ITSMWorkOrder',
                StateReset   => $GetParam{StateReset} || 0,
                WorkOrderID  => $WorkOrderID,
                UserID       => $Self->{UserID},
            );

            # show error message
            if ( !$TemplateContent ) {
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "The workorder '$WorkOrderID' could not be serialized.",
                    Comment => 'Please contact the administrator.',
                );
            }

            # if this workorder was created from a template and should be saved back
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
                # store the serialized workorder as a new template
                $TemplateID = $Self->{TemplateObject}->TemplateAdd(
                    Name         => $GetParam{TemplateName},
                    Comment      => $GetParam{Comment},
                    ValidID      => $GetParam{ValidID},
                    TemplateType => 'ITSMWorkOrder',
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
            my $RedirectURL = "Action=AgentITSMWorkOrderZoom;WorkOrderID=$WorkOrderID";

            # if the original change and all workorders should be deleted
            if ( $GetParam{DeleteWorkOrder} ) {

                # delete the change and all workorders (including this one)
                my $DeleteSuccess = $Self->{ChangeObject}->ChangeDelete(
                    ChangeID => $WorkOrder->{ChangeID},
                    UserID   => $Self->{UserID},
                );

                # show error message
                if ( !$DeleteSuccess ) {
                    return $Self->{LayoutObject}->ErrorScreen(
                        Message => "Could not delete change '$WorkOrder->{ChangeID}'.",
                        Comment => 'Please contact the administrator.',
                    );
                }

                # delete the user preference entry
                delete $Object2Template{ 'WorkOrderID' . $WorkOrderID };

                # redirect to template overview
                $RedirectURL = 'Action=AgentITSMTemplateOverview';
            }

            # update the user preference with the new template id
            elsif ( $Object2Template{ 'WorkOrderID' . $WorkOrderID } ) {
                $Object2Template{ 'WorkOrderID' . $WorkOrderID } = $TemplateID;
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

    # get change that the workorder belongs to
    my $Change = $Self->{ChangeObject}->ChangeGet(
        ChangeID => $WorkOrder->{ChangeID},
        UserID   => $Self->{UserID},
    );

    # no change found
    if ( !$Change ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Could not find Change for WorkOrder $WorkOrderID!",
            Comment => 'Please contact the administrator.',
        );
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

    # show dropdowns only if this workorder was created from a template
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

        # build selection string for delete workorder
        my $DeleteWorkOrderSelectionString = $Self->{LayoutObject}->BuildSelection(
            Data => {
                0 => 'No',
                1 => 'Yes',
            },
            Name       => 'DeleteWorkOrder',
            SelectedID => $GetParam{DeleteWorkOrder} // 1,
        );

        # show delete WorkOrder dropdown
        $Self->{LayoutObject}->Block(
            Name => 'DeleteWorkOrder',
            Data => {
                %GetParam,
                DeleteWorkOrderSelectionString => $DeleteWorkOrderSelectionString,
            },
        );
    }

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMWorkOrderTemplate',
        Data         => {
            %GetParam,
            %{$Change},
            %{$WorkOrder},
            ValidSelectionString      => $ValidSelectionString,
            StateResetSelectionString => $StateResetSelectionString,
            %Error,
        },
    );

    # add footer
    $Output .= $Self->{LayoutObject}->Footer( Type => 'Small' );

    return $Output;
}

1;
