# --
# Kernel/Modules/AdminITSMChangeNotification.pm - to add/update/delete
# notification rules for ITSM change management
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminITSMChangeNotification;

use strict;
use warnings;

use Kernel::System::ITSMChange::History;
use Kernel::System::ITSMChange::Notification;
use Kernel::System::Valid;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for my $NeededObject (
        qw(ParamObject DBObject LayoutObject UserObject GroupObject ConfigObject LogObject)
        )
    {
        if ( !$Self->{$NeededObject} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $NeededObject!" );
        }
    }

    # create needed objects
    $Self->{HistoryObject}      = Kernel::System::ITSMChange::History->new(%Param);
    $Self->{NotificationObject} = Kernel::System::ITSMChange::Notification->new(%Param);
    $Self->{ValidObject}        = Kernel::System::Valid->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # hash with feedback to the user
    my %Notification;

    # ------------------------------------------------------------ #
    # change
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Change' ) {
        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' ) || '';
        my $Data = $Self->{NotificationObject}->NotificationRuleGet( ID => $ID );

        $Self->_Edit(
            Action      => 'Change',
            ActionLabel => 'Edit',
            %{$Data},
        );
    }

    # ------------------------------------------------------------ #
    # change action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $Note = '';
        my %GetParam;
        for my $Param (qw(ID Name EventID Comment ValidID Attribute Rule)) {
            $GetParam{$Param} = $Self->{ParamObject}->GetParam( Param => $Param ) || '';
        }

        $GetParam{RecipientIDs} = [
            $Self->{ParamObject}->GetArray( Param => 'RecipientIDs' )
        ];

        # update group
        if ( $Self->{NotificationObject}->NotificationRuleUpdate(%GetParam) ) {
            $Self->_Overview();

            # notification was updated
            %Notification = ( Info => 'Notification updated!' );
        }
        else {

            # an error occured -> show notification
            %Notification = ( Priority => 'Error' );

            $Self->_Edit(
                Action      => 'Change',
                ActionLabel => 'Edit',
                %GetParam,
            );
        }
    }

    # ------------------------------------------------------------ #
    # add
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Add' ) {
        $Self->_Edit(
            Action      => 'Add',
            ActionLabel => 'Add',
        );
    }

    # ------------------------------------------------------------ #
    # add action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AddAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $Note = '';
        my %GetParam;
        my %Error;

        for my $Param (qw(ID EventID Name Comment ValidID Attribute Rule)) {
            $GetParam{$Param} = $Self->{ParamObject}->GetParam( Param => $Param ) || '';
        }

        if ( !$GetParam{Name} ) {

            $Error{'NameInvalid'} = 'ServerError';
        }

        $GetParam{RecipientIDs} = [
            $Self->{ParamObject}->GetArray( Param => 'RecipientIDs' )
        ];

        if (%Error) {
            $Self->_Edit(
                Action      => 'Add',
                ActionLabel => 'Add',
                %GetParam,
                %Error,
            );
        }

        # add notification rule
        if ( my $StateID = $Self->{NotificationObject}->NotificationRuleAdd(%GetParam) ) {
            $Self->_Overview();

            # notification was added
            %Notification = ( Info => 'Notification added!' );
        }

    }

    # ------------------------------------------------------------
    # overview
    # ------------------------------------------------------------
    else {
        $Self->_Overview();
    }

    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();

    if (%Notification) {
        $Output .= $Self->{LayoutObject}->Notify(%Notification) || '';
    }
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminITSMChangeNotification',
        Data         => \%Param,
    );
    $Output .= $Self->{LayoutObject}->Footer();

}

# show the edit mask for a notification rule
sub _Edit {
    my ( $Self, %Param ) = @_;

    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => \%Param,
    );
    $Self->{LayoutObject}->Block( Name => 'ActionList' );
    $Self->{LayoutObject}->Block( Name => 'ActionOverview' );

    $Param{ValidOption} = $Self->{LayoutObject}->BuildSelection(
        Data => {
            $Self->{ValidObject}->ValidList(),
        },
        Name       => 'ValidID',
        SelectedID => $Param{ValidID} || ( $Self->{ValidObject}->ValidIDsGet() )[0],
        Sort       => 'NumericKey',
    );
    $Param{EventOption} = $Self->{LayoutObject}->BuildSelection(
        Data => $Self->{HistoryObject}->HistoryTypeList( UserID => 1 ) || [],
        Name => 'EventID',
        SelectedID => $Param{EventID},
    );
    $Param{RecipientOption} = $Self->{LayoutObject}->BuildSelection(
        Data => $Self->{NotificationObject}->RecipientList( UserID => 1 ) || [],
        Name => 'RecipientIDs',
        Multiple   => 1,
        Size       => 13,                    # current number of default recipients, avoid scrolling
        SelectedID => $Param{RecipientIDs},
    );

    $Self->{LayoutObject}->Block(
        Name => 'OverviewUpdate',
        Data => \%Param,
    );

    return 1;
}

# show a table of notification rules
sub _Overview {
    my ( $Self, %Param ) = @_;

    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $Self->{LayoutObject}->Block( Name => 'ActionList' );
    $Self->{LayoutObject}->Block( Name => 'ActionAdd' );

    $Self->{LayoutObject}->Block(
        Name => 'OverviewResult',
        Data => \%Param,
    );
    my $RuleIDs = $Self->{NotificationObject}->NotificationRuleList() || [];

    # get valid list
    my %ValidList = $Self->{ValidObject}->ValidList();
    for my $RuleID ( @{$RuleIDs} ) {

        my $Data = $Self->{NotificationObject}->NotificationRuleGet( ID => $RuleID );
        my $Recipients = join ', ', @{ $Data->{Recipients} || [] };

        $Self->{LayoutObject}->Block(
            Name => 'OverviewResultRow',
            Data => {
                Valid => $ValidList{ $Data->{ValidID} },
                %{$Data},
                Recipients => $Recipients,
            },
        );
    }
    return 1;
}

1;
