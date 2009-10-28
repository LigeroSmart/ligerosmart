# --
# Kernel/Modules/AgentITSMChangeAdd.pm - the OTRS::ITSM::ChangeManagement change add module
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: AgentITSMChangeAdd.pm,v 1.7 2009-10-28 09:42:42 reb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMChangeAdd;

use strict;
use warnings;

use Kernel::System::ITSMChange;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.7 $) [1];

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

    # create needed objects
    $Self->{ChangeObject} = Kernel::System::ITSMChange->new(%Param);

    # get config of frontend module
    $Self->{Config} = $Self->{ConfigObject}->Get("ITSMChangeManagement::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # store all needed parameters in %GetParam to make it reloadable
    my %GetParam;
    for my $ParamName (qw(ChangeTitle Description Justification)) {
        $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
    }

    # update change
    if ( $Self->{Subaction} eq 'Save' ) {

        # add only if ChangeTitle is given
        if ( $GetParam{ChangeTitle} ) {
            my $ChangeID = $Self->{ChangeObject}->ChangeAdd(
                Description   => $GetParam{Description},
                Justification => $GetParam{Justification},
                ChangeTitle   => $GetParam{ChangeTitle},
                UserID        => $Self->{UserID},
            );

            if ( !$ChangeID ) {

                # show error message
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => 'Was not able to add Change!',
                    Comment => 'Please contact the admin.',
                );
            }
            else {

                # redirect to zoom mask
                return $Self->{LayoutObject}->Redirect(
                    OP => "Action=AgentITSMChangeZoom&ChangeID=$ChangeID",
                );
            }
        }
        else {

            # show invalid message
            $Self->{LayoutObject}->Block(
                Name => 'InvalidTitle',
            );
        }
    }

    # build template dropdown
    # TODO: fill dropdown with data
    my $TemplateDropDown = $Self->{LayoutObject}->BuildSelection(
        Name => 'ChangeTemplate',
        Data => {},
    );

    # show block with template dropdown
    $Self->{LayoutObject}->Block(
        Name => 'ChangeTemplate',
        Data => {
            TemplatesStrg => $TemplateDropDown,
        },
    );

    # output header
    my $Output = $Self->{LayoutObject}->Header(
        Title => 'Add',
    );
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # add rich text editor
    if ( $Self->{ConfigObject}->Get('Frontend::RichText') ) {
        $Self->{LayoutObject}->Block(
            Name => 'RichText',
        );
    }

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMChangeAdd',
        Data         => {
            %Param,
            %GetParam,
        },
    );

    # add footer
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
