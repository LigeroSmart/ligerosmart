# --
# Kernel/Modules/AgentITSMTemplateEditContent.pm - the OTRS ITSM ChangeManagement template edit content module
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMTemplateEditContent;

use strict;
use warnings;

use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::Template;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (
        qw(ParamObject DBObject TimeObject LayoutObject LogObject ConfigObject UserObject GroupObject)
        )
    {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Object!" );
        }
    }

    # create additional objects
    $Self->{ChangeObject}   = Kernel::System::ITSMChange->new(%Param);
    $Self->{TemplateObject} = Kernel::System::ITSMChange::Template->new(%Param);

    # get config for frontend
    $Self->{Config} = $Self->{ConfigObject}->Get("ITSMChange::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check permissions
    my $Access = $Self->{ChangeObject}->Permission(
        Type   => $Self->{Config}->{Permission},
        Action => $Self->{Action},
        UserID => $Self->{UserID},
    );

    # error screen
    if ( !$Access ) {
        return $Self->{LayoutObject}->NoPermission(
            Message    => "You need $Self->{Config}->{Permission} permission!",
            WithHeader => 'yes',
        );
    }

    # get needed TemplateID
    my $TemplateID = $Self->{ParamObject}->GetParam( Param => 'TemplateID' );

    # check needed stuff
    if ( !$TemplateID ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'No TemplateID is given!',
            Comment => 'Please contact the admin.',
        );
    }

    # get template data
    my $Template = $Self->{TemplateObject}->TemplateGet(
        TemplateID => $TemplateID,
        UserID     => $Self->{UserID},
    );

    # check error
    if ( !$Template ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Template '$TemplateID' not found in database!",
            Comment => 'Please contact the admin.',
        );
    }

    # create a new change or workorder so it can be edited
    if ( $Self->{Subaction} eq 'TemplateEditContent' ) {

        # get current system time in epoch seconds
        my $SystemTime = $Self->{TimeObject}->SystemTime();

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
            my ($Object, $Template ) = split m/::/, $String;
            $Object2Template{$Object} = $Template;
        }

        # edit a change template
        if ( $Template->{Type} eq 'ITSMChange' ) {

            # create change based on the template
            my $ChangeID = $Self->{TemplateObject}->TemplateDeSerialize(
                TemplateID      => $TemplateID,
                MoveTimeType    => 'PlannedStartTime',
                NewTimeInEpoche => $SystemTime,
                UserID          => $Self->{UserID},
            );

            # show error message, when adding failed
            if ( !$ChangeID ) {

                return $Self->{LayoutObject}->ErrorScreen(
                    Message => 'Was not able to create change from template!',
                    Comment => 'Please contact the admin.',
                );
            }

            # store the change id to template id reference
            $Object2Template{ 'ChangeID' . $ChangeID } = $TemplateID;

            # convert to string
            $TemplateEditPreferenceString = '';
            for my $Object (sort keys %Object2Template) {
                $TemplateEditPreferenceString .= $Object . '::' . $Object2Template{$Object} . ';';
            }

            # save preferences
            $Self->{UserObject}->SetPreferences(
                Key    => 'UserITSMChangeManagementTemplateEdit',
                Value  => $TemplateEditPreferenceString,
                UserID => $Self->{UserID},
            );

            # redirect to change zoom mask, when adding was successful
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=AgentITSMChangeZoom;ChangeID=$ChangeID",
            );
        }

        # edit a workorder template
        elsif ( $Template->{Type} eq 'ITSMWorkOrder' ) {

            # add a dummy change, needed to contain the workorder
            my $ChangeID = $Self->{ChangeObject}->ChangeAdd(
                ChangeTitle  => $Self->{Config}->{DefaultChangeTitle},
                UserID       => $Self->{UserID},
            );

            # show error message, when adding failed
            if ( !$ChangeID ) {
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => 'Was not able to create change!',
                    Comment => 'Please contact the admin.',
                );
            }

            # create workorder based on the template, and add it to the dummy change
            my $WorkOrderID = $Self->{TemplateObject}->TemplateDeSerialize(
                ChangeID        => $ChangeID,
                TemplateID      => $TemplateID,
                MoveTimeType    => 'PlannedStartTime',
                NewTimeInEpoche => $SystemTime,
                UserID          => $Self->{UserID},
            );

            # show error message, when adding failed
            if ( !$WorkOrderID ) {

                # show error message, when adding failed
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => 'Was not able to create workorder from template!',
                    Comment => 'Please contact the admin.',
                );
            }

            # store the workorder id to template id reference
            $Object2Template{ 'WorkOrderID' . $WorkOrderID } = $TemplateID;

            # convert to string
            $TemplateEditPreferenceString = '';
            for my $Object (sort keys %Object2Template) {
                $TemplateEditPreferenceString .= $Object . '::' . $Object2Template{$Object} . ';';
            }

            # save preferences
            $Self->{UserObject}->SetPreferences(
                Key    => 'UserITSMChangeManagementTemplateEdit',
                Value  => $TemplateEditPreferenceString,
                UserID => $Self->{UserID},
            );

            # redirect to workorder zoom mask, when adding was successful
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=AgentITSMWorkOrderZoom;WorkOrderID=$WorkOrderID",
            );
        }
    }

    # show a dialog before creating a new change or workorder to be edited
    elsif ( $Self->{Subaction} eq 'TemplateEditContentShowDialog' ) {

        # show the edit content dialog
        $Self->{LayoutObject}->Block(
            Name => 'EditContentDialog',
            Data => {
                 %{$Template},
            },
        );

        # show the correct block depending on template type
        if ( $Template->{Type} eq 'ITSMChange' ) {
            $Self->{LayoutObject}->Block(
                Name => 'ChangeTemplate',
                Data => {
                     %{$Template},
                },
            );
        }
        elsif ( $Template->{Type} eq 'ITSMWorkOrder' ) {
            $Self->{LayoutObject}->Block(
                Name => 'WorkOrderTemplate',
                Data => {
                     %{$Template},
                },
            );
        }

        # output content
        my $Output = $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentITSMTemplateEditContent',
            Data         => {
                %{$Template},
            },
        );

        # build the returned data structure
        my %Data = (
            HTML       => $Output,
            DialogType => 'Confirmation',
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
}

1;
