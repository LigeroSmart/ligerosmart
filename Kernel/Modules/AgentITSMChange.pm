# --
# Kernel/Modules/AgentITSMChange.pm - the OTRS::ITSM::ChangeManagement change overview module
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: AgentITSMChange.pm,v 1.2 2009-10-21 07:59:31 mae Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMChange;

use strict;
use warnings;

use Kernel::System::GeneralCatalog;
use Kernel::System::ITSMChange;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(ParamObject DBObject LayoutObject LogObject ConfigObject UserObject)) {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Object!" );
        }
    }

    $Self->{GeneralCatalogObject} = Kernel::System::GeneralCatalog->new(%Param);
    $Self->{ChangeObject}         = Kernel::System::ITSMChange->new(%Param);

    # get config of frontend module
    $Self->{Config} = $Self->{ConfigObject}->Get("ITSMChangeManagement::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get page
    my $Page = $Self->{ParamObject}->GetParam( Param => 'Page' ) || 1;

    my %SearchResult = (
        Result       => 0,
        ChangesAvail => 0,
    );

    # get change object
    my $Changes = $Self->{ChangeObject}->ChangeSearch(
        UserID => $Self->{UserID},
    );

    $Changes ||= [];

    $SearchResult{ChangesAvail} = scalar @{$Changes} || 0;

    if ($Changes) {
        $Self->{LayoutObject}->Block(
            Name => 'Change',
            Data => {
                %Param,
                %SearchResult,
            },
        );
    }

    # TODO: GeneralCatalog-Preferences definition of LED color
    #  CurInciSignal => $InciSignals{ $LastVersion->{CurInciStateType} },
    # temp color for changes
    my %CurChangeSignal = (
        requested          => 'yellowled',
        accepted           => 'greenled',
        'pending approval' => 'yellowled',
        rejected           => 'grayled',
        approved           => 'greenled',
        'in progress'      => 'yellowled',
        successful         => 'greenled',
        failed             => 'redled',
        canceled           => 'grayled',
    );

    my $CssClass = '';
    for my $ChangeID ( @{$Changes} ) {

        # get current change
        my $Change = $Self->{ChangeObject}->ChangeGet(
            UserID   => $Self->{UserID},
            ChangeID => $ChangeID,
        ) || {};

        # get change state from general catalog
        my $CurChangeState = $Self->{GeneralCatalogObject}->ItemGet(
            ItemID => $Change->{ChangeStateID},
        ) || {};

        # set output object
        $CssClass = $CssClass eq 'searchpassive' ? 'searchactive' : 'searchpassive';

        # set work order count
        $Change->{WorkOrderIDs} ||= [];
        $Change->{WorkOrderCount} = scalar @{ $Change->{WorkOrderIDs} } || 0;

        # set change builder
        # user Postfixes
        my @Postfixes = qw(UserLogin UserFirstname UserLastname);

        if ( $Change->{ChangeBuilderID} ) {

            # get change manager data
            my %ChangeBuilderUser = $Self->{UserObject}->GetUserData(
                UserID => $Change->{ChangeBuilderID},
                Cached => 1,
            );
            for my $Postfix (@Postfixes) {
                if ( $Postfix eq 'UserFirstname' ) {
                    $Change->{ 'ChangeBuilder' . $Postfix } = '(' . $ChangeBuilderUser{$Postfix};
                }
                elsif ( $Postfix eq 'UserLastname' ) {
                    $Change->{ 'ChangeBuilder' . $Postfix } = $ChangeBuilderUser{$Postfix} . ')';
                }
                else {
                    $Change->{ 'ChangeBuilder' . $Postfix } = $ChangeBuilderUser{$Postfix};
                }
            }
        }
        else {
            $Change->{ChangeBuilderUserLogin} = '-';
        }

        $Self->{LayoutObject}->Block(
            Name => 'ChangeRow',
            Data => {
                %Param,
                %SearchResult,
                %{$Change},
                CssClass        => $CssClass,
                CurChangeState  => $CurChangeState->{Name},
                CurChangeSignal => $CurChangeSignal{ $CurChangeState->{Name} },
            },
        );
    }

    # investigate refresh
    my $Refresh = $Self->{UserRefreshTime} ? 60 * $Self->{UserRefreshTime} : undef;

    # output header
    my $Output = $Self->{LayoutObject}->Header(
        Title   => 'Overview',
        Refresh => $Refresh,
    );
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMChange',
        Data         => {
            %Param,
            %SearchResult,
        },
    );

    # add footer
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
