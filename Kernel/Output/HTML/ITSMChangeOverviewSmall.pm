# --
# Kernel/Output/HTML/ITSMChangeOverviewSmall.pm.pm
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: ITSMChangeOverviewSmall.pm,v 1.5 2009-11-25 17:51:47 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::ITSMChangeOverviewSmall;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.5 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed objects
    for my $Object (
        qw(ConfigObject LogObject DBObject LayoutObject UserID UserObject GroupObject TicketObject MainObject QueueObject)
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(ChangeIDs PageShown StartHit)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # check ShowColumns parameter
    my @ShowColumns;
    if ( $Param{ShowColumns} && ref $Param{ShowColumns} eq 'ARRAY' && @{ $Param{ShowColumns} } ) {
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
    CHANGEID:
    for my $ChangeID ( @{ $Param{ChangeIDs} } ) {
        $Counter++;
        if ( $Counter >= $Param{StartHit} && $Counter < ( $Param{PageShown} + $Param{StartHit} ) ) {

            # get current change
            my $Change = $Self->{ChangeObject}->ChangeGet(
                UserID   => $Self->{UserID},
                ChangeID => $ChangeID,
            );

            next CHANGEID if !$Change;

            # set css class of the row
            $CssClass = $CssClass eq 'searchpassive' ? 'searchactive' : 'searchpassive';

            # to store data which does not come from change
            my %Data;

            # get user data for change builder and change manager
            USERTYPE:
            for my $UserType (qw(ChangeBuilder ChangeManager)) {

                next USERTYPE if !$Change->{ $UserType . 'ID' };

                # get user data
                my %User = $Self->{UserObject}->GetUserData(
                    UserID => $Change->{ $UserType . 'ID' },
                    Cached => 1,
                );

                # set user data
                $Data{ $UserType . 'UserLogin' }        = $User{UserLogin};
                $Data{ $UserType . 'UserFirstname' }    = $User{UserFirstname};
                $Data{ $UserType . 'UserLastname' }     = $User{UserLastname};
                $Data{ $UserType . 'LeftParenthesis' }  = '(';
                $Data{ $UserType . 'RightParenthesis' } = ')';
            }

            # build record block
            $Self->{LayoutObject}->Block(
                Name => 'Record',
                Data => {
                    %Param,
                    %{$Change},
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
                            %{$Change},
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
