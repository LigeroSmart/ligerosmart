# --
# Kernel/Output/HTML/ITSMChangeOverviewSmall.pm.pm
# Copyright (C) 2003-2010 OTRS AG, http://otrs.com/
# --
# $Id: ITSMChangeOverviewSmall.pm,v 1.8 2010-01-22 11:35:16 bes Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::ITSMChangeOverviewSmall;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.8 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed objects
    for my $Object (
        qw(ConfigObject LogObject DBObject LayoutObject UserID UserObject MainObject)
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(PageShown StartHit)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # need ChangeIDs or WorkOrderIDs
    if ( !$Param{ChangeIDs} && !$Param{WorkOrderIDs} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need the ChangeIDs or the WorkOrderIDs!',
        );
        return;
    }

    # only one of ChangeIDs or WorkOrderIDs can be used
    if ( $Param{ChangeIDs} && $Param{WorkOrderIDs} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need either the ChangeIDs or the WorkOrderIDs, not both!',
        );
        return;
    }

    # store either the ChangeIDs or the WorkOrderIDs
    my @IDs;
    if ( $Param{ChangeIDs} && ref $Param{ChangeIDs} eq 'ARRAY' ) {
        @IDs = @{ $Param{ChangeIDs} };
    }
    elsif ( $Param{WorkOrderIDs} && ref $Param{WorkOrderIDs} eq 'ARRAY' ) {
        @IDs = @{ $Param{WorkOrderIDs} };
    }

    # check ShowColumns parameter
    my @ShowColumns;
    if ( $Param{ShowColumns} && ref $Param{ShowColumns} eq 'ARRAY' ) {
        @ShowColumns = @{ $Param{ShowColumns} };
    }

    # build column header blocks
    if (@ShowColumns) {
        for my $Column (@ShowColumns) {
            $Self->{LayoutObject}->Block(
                Name => 'Record' . $Column . 'Header',
                Data => \%Param,
            );
        }
    }

    my $Output   = '';
    my $Counter  = 0;
    my $CssClass = '';
    ID:
    for my $ID (@IDs) {
        $Counter++;
        if ( $Counter >= $Param{StartHit} && $Counter < ( $Param{PageShown} + $Param{StartHit} ) ) {

            # to store all data
            my %Data;

            my $ChangeID;
            if ( $Param{ChangeIDs} ) {

                # set change id
                $ChangeID = $ID;
            }
            elsif ( $Param{WorkOrderIDs} ) {

                # get workorder data
                my $WorkOrder = $Self->{WorkOrderObject}->WorkOrderGet(
                    WorkOrderID => $ID,
                    UserID      => $Self->{UserID},
                );

                next ID if !$WorkOrder;

                # add workorder data
                %Data = ( %Data, %{$WorkOrder} );

                # set change id from workorder data
                $ChangeID = $WorkOrder->{ChangeID};
            }

            # get change data
            my $Change = $Self->{ChangeObject}->ChangeGet(
                UserID   => $Self->{UserID},
                ChangeID => $ChangeID,
            );

            next ID if !$Change;

            # add change data,
            # ( let workorder data overwrite
            # some change attributes, i.e. PlannedStartTime, etc... )
            %Data = ( %{$Change}, %Data );

            # get user data for needed user types
            USER_TYPE:
            for my $UserType (qw(ChangeBuilder ChangeManager WorkOrderAgent)) {

                # check if UserType attribute exists either in change or workorder
                if ( !$Change->{ $UserType . 'ID' } && !$Data{ $UserType . 'ID' } ) {
                    next USER_TYPE;
                }

                # get user data
                my %User = $Self->{UserObject}->GetUserData(
                    UserID => $Change->{ $UserType . 'ID' } || $Data{ $UserType . 'ID' },
                    Cached => 1,
                );

                # set user data
                $Data{ $UserType . 'UserLogin' }        = $User{UserLogin};
                $Data{ $UserType . 'UserFirstname' }    = $User{UserFirstname};
                $Data{ $UserType . 'UserLastname' }     = $User{UserLastname};
                $Data{ $UserType . 'LeftParenthesis' }  = '(';
                $Data{ $UserType . 'RightParenthesis' } = ')';
            }

            # set css class of the row
            $CssClass = $CssClass eq 'searchpassive' ? 'searchactive' : 'searchpassive';

            # build record block
            $Self->{LayoutObject}->Block(
                Name => 'Record',
                Data => {
                    %Param,
                    %Data,
                    CssClass => $CssClass,
                },
            );

            # build column record blocks
            if (@ShowColumns) {
                for my $Column (@ShowColumns) {
                    $Self->{LayoutObject}->Block(
                        Name => 'Record' . $Column,
                        Data => {
                            %Param,
                            %Data,
                            CssClass => $CssClass,
                        },
                    );
                }
            }
        }
    }

    # use template
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMChangeOverviewSmall',
        Data         => {
            %Param,
            Type        => $Self->{ViewType},
            ColumnCount => scalar @ShowColumns,
        },
    );

    return $Output;
}

1;
