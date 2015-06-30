# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminITSMChangeNotification;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # hash with feedback to the user
    my %Notification;

    # get needed object
    my $NotificationObject = $Kernel::OM->Get('Kernel::System::ITSMChange::Notification');
    my $ParamObject        = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject       = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # ------------------------------------------------------------ #
    # change
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Change' ) {
        my $ID = $ParamObject->GetParam( Param => 'ID' ) || '';
        my $Data = $NotificationObject->NotificationRuleGet( ID => $ID );

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
        $LayoutObject->ChallengeTokenCheck();

        my $Note = '';
        my %GetParam;
        for my $Param (qw(ID Name EventID Comment ValidID Attribute Rule)) {
            $GetParam{$Param} = $ParamObject->GetParam( Param => $Param ) || '';
        }

        $GetParam{RecipientIDs} = [
            $ParamObject->GetArray( Param => 'RecipientIDs' )
        ];

        # update group
        if ( $NotificationObject->NotificationRuleUpdate(%GetParam) ) {
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
        $LayoutObject->ChallengeTokenCheck();

        my $Note = '';
        my %GetParam;
        my %Error;

        for my $Param (qw(ID EventID Name Comment ValidID Attribute Rule)) {
            $GetParam{$Param} = $ParamObject->GetParam( Param => $Param ) || '';
        }

        if ( !$GetParam{Name} ) {

            $Error{'NameInvalid'} = 'ServerError';
        }

        $GetParam{RecipientIDs} = [
            $ParamObject->GetArray( Param => 'RecipientIDs' )
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
        if ( my $StateID = $NotificationObject->NotificationRuleAdd(%GetParam) ) {
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

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    if (%Notification) {
        $Output .= $LayoutObject->Notify(%Notification) || '';
    }
    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminITSMChangeNotification',
        Data         => \%Param,
    );
    $Output .= $LayoutObject->Footer();

}

# show the edit mask for a notification rule
sub _Edit {
    my ( $Self, %Param ) = @_;

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
    );
    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionOverview' );

    # get valid object
    my $ValidObject = $Kernel::OM->Get('Kernel::System::Valid');

    $Param{ValidOption} = $LayoutObject->BuildSelection(
        Data => {
            $ValidObject->ValidList(),
        },
        Name       => 'ValidID',
        SelectedID => $Param{ValidID} || ( $ValidObject->ValidIDsGet() )[0],
        Sort       => 'NumericKey',
    );
    $Param{EventOption} = $LayoutObject->BuildSelection(
        Data => $Kernel::OM->Get('Kernel::System::ITSMChange::History')->HistoryTypeList( UserID => 1 ) || [],
        Name => 'EventID',
        SelectedID => $Param{EventID},
    );
    $Param{RecipientOption} = $LayoutObject->BuildSelection(
        Data => $Kernel::OM->Get('Kernel::System::ITSMChange::Notification')->RecipientList( UserID => 1 ) || [],
        Name => 'RecipientIDs',
        Multiple   => 1,
        Size       => 13,                     # current number of default recipients, avoid scrolling
        SelectedID => $Param{RecipientIDs},
    );

    $LayoutObject->Block(
        Name => 'OverviewUpdate',
        Data => \%Param,
    );

    return 1;
}

# show a table of notification rules
sub _Overview {
    my ( $Self, %Param ) = @_;

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionAdd' );

    $LayoutObject->Block(
        Name => 'OverviewResult',
        Data => \%Param,
    );

    # get notification object
    my $NotificationObject = $Kernel::OM->Get('Kernel::System::ITSMChange::Notification');

    my $RuleIDs = $NotificationObject->NotificationRuleList() || [];

    # get valid list
    my %ValidList = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();
    for my $RuleID ( @{$RuleIDs} ) {

        my $Data = $NotificationObject->NotificationRuleGet( ID => $RuleID );
        my $Recipients = join ', ', @{ $Data->{Recipients} || [] };

        $LayoutObject->Block(
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
