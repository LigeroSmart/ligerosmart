# --
# Kernel/Modules/AgentITSMChangeCondition.pm - the OTRS ITSM ChangeManagement condition overview module
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMChangeCondition;

use strict;
use warnings;

use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::ITSMCondition;
use Kernel::System::Valid;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (
        qw(ConfigObject ParamObject DBObject LayoutObject LogObject UserObject GroupObject)
        )
    {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Object!" );
        }
    }

    # create needed objects
    $Self->{ChangeObject}    = Kernel::System::ITSMChange->new(%Param);
    $Self->{ConditionObject} = Kernel::System::ITSMChange::ITSMCondition->new(%Param);
    $Self->{ValidObject}     = Kernel::System::Valid->new(%Param);

    # get config of frontend module
    $Self->{Config} = $Self->{ConfigObject}->Get("ITSMChange::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # store needed parameters in %GetParam to make this page reloadable
    my %GetParam;
    for my $ParamName (qw(ChangeID ConditionID AddCondition)) {
        $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
    }

    # check needed stuff
    if ( !$GetParam{ChangeID} ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'No ChangeID is given!',
            Comment => 'Please contact the admin.',
        );
    }

    # check permissions
    my $Access = $Self->{ChangeObject}->Permission(
        Type     => $Self->{Config}->{Permission},
        Action   => $Self->{Action},
        ChangeID => $GetParam{ChangeID},
        UserID   => $Self->{UserID},
    );

    # error screen
    if ( !$Access ) {
        return $Self->{LayoutObject}->NoPermission(
            Message    => "You need $Self->{Config}->{Permission} permissions!",
            WithHeader => 'yes',
        );
    }

    # get change data
    my $ChangeData = $Self->{ChangeObject}->ChangeGet(
        ChangeID => $GetParam{ChangeID},
        UserID   => $Self->{UserID},
    );

    # check if change is found
    if ( !$ChangeData ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Change '$GetParam{ChangeID}' not found in database!",
            Comment => 'Please contact the admin.',
        );
    }

    # get valid list
    my %ValidList = $Self->{ValidObject}->ValidList();

    # add condition button was pressed
    if ( $GetParam{AddCondition} ) {

        # redirect to condition edit mask
        return $Self->{LayoutObject}->Redirect(
            OP =>
                "Action=AgentITSMChangeConditionEdit;ChangeID=$GetParam{ChangeID};ConditionID=NEW",
        );
    }

    # get all condition ids for the given change id, including invalid conditions
    my $ConditionIDsRef = $Self->{ConditionObject}->ConditionList(
        ChangeID => $GetParam{ChangeID},
        Valid    => 0,
        UserID   => $Self->{UserID},
    );

    # check if a condition should be deleted
    for my $ConditionID ( @{$ConditionIDsRef} ) {
        if ( $Self->{ParamObject}->GetParam( Param => 'DeleteConditionID::' . $ConditionID ) ) {

            # delete the condition
            my $Success = $Self->{ConditionObject}->ConditionDelete(
                ConditionID => $ConditionID,
                UserID      => $Self->{UserID},
            );

            # check error
            if ( !$Success ) {
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "Could not delete ConditionID $ConditionID!",
                    Comment => 'Please contact the admin.',
                );
            }

            # redirect to overview
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=$Self->{Action};ChangeID=$GetParam{ChangeID}",
            );
        }
    }

    # only show the table headline if there conditions to be shown
    if ( @{$ConditionIDsRef} ) {

        # output overview
        $Self->{LayoutObject}->Block(
            Name => 'Overview',
            Data => {
                %Param,
                %{$ChangeData},
            },
        );
    }

    for my $ConditionID ( @{$ConditionIDsRef} ) {

        # get condition data
        my $ConditionData = $Self->{ConditionObject}->ConditionGet(
            ConditionID => $ConditionID,
            UserID      => $Self->{UserID},
        );

        # output overview row
        $Self->{LayoutObject}->Block(
            Name => 'OverviewRow',
            Data => {
                Valid => $ValidList{ $ConditionData->{ValidID} },
                %{$ConditionData},
            },
        );
    }

    # output header
    my $Output = $Self->{LayoutObject}->Header(
        Title => 'Overview',
        Type  => 'Small',
    );

    # generate output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMChangeCondition',
        Data         => {
            %Param,
            %{$ChangeData},
        },
    );
    $Output .= $Self->{LayoutObject}->Footer( Type => 'Small' );

    return $Output;
}

1;
