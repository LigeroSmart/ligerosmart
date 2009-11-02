# --
# Kernel/Modules/AgentITSMChange.pm - the OTRS::ITSM::ChangeManagement change overview module
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: AgentITSMChange.pm,v 1.9 2009-11-02 17:34:01 bes Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMChange;

use strict;
use warnings;

use Kernel::System::ITSMChange;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.9 $) [1];

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

    # create needed objects
    $Self->{ChangeObject} = Kernel::System::ITSMChange->new(%Param);

    # get config of frontend module
    $Self->{Config} = $Self->{ConfigObject}->Get("ITSMChange::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # TODO: implement paging
    # get page
    my $Page = $Self->{ParamObject}->GetParam( Param => 'Page' ) || 1;

    # store last screen, used for backlinks
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenChanges',
        Value     => $Self->{RequestedURL},
    );

    my %SearchResult = (
        Result       => 0,
        ChangesAvail => 0,
    );

    # get list of change ids
    my $Changes = $Self->{ChangeObject}->ChangeSearch(
        UserID => $Self->{UserID},
    ) || [];

    $SearchResult{ChangesAvail} = scalar @{$Changes};

    if ( $SearchResult{ChangesAvail} ) {
        $Self->{LayoutObject}->Block(
            Name => 'Change',
            Data => {
                %Param,
                %SearchResult,
            },
        );
    }

    my $CssClass = '';
    for my $ChangeID ( @{$Changes} ) {

        # get current change
        my $Change = $Self->{ChangeObject}->ChangeGet(
            UserID   => $Self->{UserID},
            ChangeID => $ChangeID,
        ) || {};

        # set CSS-class of the row
        $CssClass = $CssClass eq 'searchpassive' ? 'searchactive' : 'searchpassive';

        # set work order count
        $Change->{WorkOrderIDs} ||= [];
        $Change->{WorkOrderCount} = scalar @{ $Change->{WorkOrderIDs} } || 0;

        # set change builder
        # user Postfixes
        my @Postfixes = qw(UserLogin UserFirstname UserLastname);

        if ( $Change->{ChangeBuilderID} ) {

            # get change builder data
            my %ChangeBuilderUser = $Self->{UserObject}->GetUserData(
                UserID => $Change->{ChangeBuilderID},
                Cached => 1,
            );
            for my $Postfix (@Postfixes) {
                $Change->{ 'ChangeBuilder' . $Postfix } = $ChangeBuilderUser{$Postfix};
            }

            # parenthesis are shown only when there is a change builder
            $Change->{'ChangeBuilderOpenParen'}  = '(';
            $Change->{'ChangeBuilderCloseParen'} = ')';
        }
        else {

            # show a placeholder, when there is no change builder
            $Change->{ChangeBuilderUserLogin} = '-';
        }

        $Self->{LayoutObject}->Block(
            Name => 'ChangeRow',
            Data => {
                %Param,
                %SearchResult,
                %{$Change},
                CssClass => $CssClass,
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
