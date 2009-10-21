# --
# Kernel/Modules/AgentITSMChangeAdd.pm - the OTRS::ITSM::ChangeManagement change add module
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: AgentITSMChangeAdd.pm,v 1.2 2009-10-21 06:57:51 reb Exp $
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
$VERSION = qw($Revision: 1.2 $) [1];

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

    $Self->{ChangeObject} = Kernel::System::ITSMChange->new(%Param);

    # get config of frontend module
    $Self->{Config} = $Self->{ConfigObject}->Get("ITSMChangeManagement::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Title = $Self->{ParamObject}->GetParam( Param => 'Title' );

    # update workorder
    if ( $Self->{Subaction} eq 'Save' && $Title ) {
        my $ChangeID = $Self->{ChangeObject}->ChangeAdd(
            Description   => $Self->{ParamObject}->GetParam( Param => 'Description' ),
            Justification => $Self->{ParamObject}->GetParam( Param => 'Justification' ),
            Title         => $Title,
            UserID        => $Self->{UserID},
        );

        if ( !$ChangeID ) {

            # show error message
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Was not able to add Change!",
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
    elsif ( $Self->{Subaction} eq 'Save' && !$Title ) {

        # show invalid message
        $Self->{LayoutObject}->Block(
            Name => 'InvalidTitle',
        );
    }

    # output header
    my $Output = $Self->{LayoutObject}->Header(
        Title => 'Add',
    );
    $Output .= $Self->{LayoutObject}->NavigationBar();

    $Self->{LayoutObject}->Block(
        Name => 'RichText',
    );

    $Self->{LayoutObject}->Block(
        Name => 'RichText2',
    );

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMChangeAdd',
        Data         => {
            %Param,
        },
    );

    # add footer
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
