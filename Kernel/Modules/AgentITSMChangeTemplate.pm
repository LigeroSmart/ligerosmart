# --
# Kernel/Modules/AgentITSMChangeTemplate.pm - the OTRS::ITSM::ChangeManagement add template module
# Copyright (C) 2003-2010 OTRS AG, http://otrs.com/
# --
# $Id: AgentITSMChangeTemplate.pm,v 1.1 2010-01-18 12:19:36 bes Exp $
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

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

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
    $Self->{ChangeObject}   = Kernel::System::ITSMChange->new(%Param);
    $Self->{TemplateObject} = Kernel::System::ITSMChange::Template->new(%Param);

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
            Comment => 'Please contact the admin.',
        );
    }

    # check permissions
    my $Access = $Self->{ChangeObject}->Permission(
        Type     => $Self->{Config}->{Permission},
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

    # store needed parameters in %GetParam to make it reloadable
    my %GetParam;
    for my $ParamName (qw(TemplateName TemplateComment)) {
        $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
    }

    # Remember the reason why saving was not attempted.
    # The items are the names of the dtl validation error blocks.
    my @ValidationErrors;

    # move time slot of change
    if ( $Self->{Subaction} eq 'AddTemplate' ) {

        # check validity of the template name
        my $TemplateName = $GetParam{TemplateName};
        if ( !$TemplateName ) {
            push @ValidationErrors, 'InvalidTemplateName';
        }

        if ( !@ValidationErrors ) {

            # serialize the change
            my $TemplateContent = $Self->{TemplateObject}->TemplateSerialize(
                TemplateType => 'ITSMChange',
                ChangeID     => $ChangeID,
                UserID       => $Self->{UserID},
            );

            # show error message
            if ( !$TemplateContent ) {
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "The change '$ChangeID' could not be serialized.",
                    Comment => 'Please contact the admin.',
                );
            }

            my $TemplateTypeID = $Self->{TemplateObject}->TemplateTypeLookup(
                TemplateType => 'ITSMChange',
                UserID       => $Self->{UserID},
            );

            # show error message
            if ( !$TemplateTypeID ) {
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "The template type 'ITSMChange' is not known.",
                    Comment => 'Please contact the admin.',
                );
            }

            # store the serialized change
            my $TemplateID = $Self->{TemplateObject}->TemplateAdd(
                Name    => $GetParam{TemplateName},
                Content => $TemplateContent,
                Comment => $GetParam{TemplateComment},
                TypeID  => $TemplateTypeID,
                ValidID => 1,
                UserID  => $Self->{UserID},
            );

            # show error message
            if ( !$TemplateID ) {
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "Could not add the template.",
                    Comment => 'Please contact the admin.',
                );
            }

            # everything went well, redirect to zoom mask
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=AgentITSMChangeZoom&ChangeID=$ChangeID",
            );
        }
    }
    else {

        # no subaction,
    }

    # output header
    my $Output = $Self->{LayoutObject}->Header(
        Title => 'Template',
    );
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # Add the validation error messages.
    for my $BlockName (@ValidationErrors) {

        # show validation error message
        $Self->{LayoutObject}->Block( Name => $BlockName );
    }

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMChangeTemplate',
        Data         => {
            %GetParam,
            ChangeID => $ChangeID,
        },
    );

    # add footer
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
