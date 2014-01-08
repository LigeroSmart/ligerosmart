# --
# Kernel/Output/HTML/ITSMTemplateOverviewSmall.pm.pm
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::ITSMTemplateOverviewSmall;

use strict;
use warnings;

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

    # create additional objects
    $Self->{ValidObject} = Kernel::System::Valid->new(%Param);

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

    # need TemplateIDs
    if ( !$Param{TemplateIDs} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need the TemplateIDs!',
        );
        return;
    }

    # store the template IDs
    my @IDs = @{ $Param{TemplateIDs} };

    # check ShowColumns parameter
    my @ShowColumns;
    if ( $Param{ShowColumns} && ref $Param{ShowColumns} eq 'ARRAY' ) {
        @ShowColumns = @{ $Param{ShowColumns} };
    }

    my @Col = (qw(Name TemplateTypeID ValidID CreateTime ChangeTime));
    my %Order;
    my %CSS;

    for my $Key (@Col) {
        if ( $Param{SortBy} && ( $Param{SortBy} eq $Key ) ) {
            if ( $Param{OrderBy} && ( $Param{OrderBy} eq 'Up' ) ) {
                $Order{ 'OrderBy' . $Key } = 'Down';
                $CSS{ 'Sort' . $Key }      = ' SortDescending';
            }
            else {
                $Order{ 'OrderBy' . $Key } = 'Up';
                $CSS{ 'Sort' . $Key }      = ' SortAscending';
            }
            next;
        }
    }

    # build column header blocks
    if (@ShowColumns) {
        for my $Column (@ShowColumns) {

            $Self->{LayoutObject}->Block(
                Name => 'Record' . $Column . 'Header',
                Data => {
                    %Param,
                    %Order,
                    %CSS,
                },
            );
        }
    }

    my $Output  = '';
    my $Counter = 0;

    # show templates if there are some
    if (@IDs) {

        ID:
        for my $ID (@IDs) {
            $Counter++;
            if (
                $Counter >= $Param{StartHit}
                && $Counter < ( $Param{PageShown} + $Param{StartHit} )
                )
            {

                # display the template data
                my $Template = $Self->{TemplateObject}->TemplateGet(
                    TemplateID => $ID,
                    UserID     => $Self->{UserID},
                );
                my %Data = %{$Template};

                # human readable validity
                $Data{Valid} = $Self->{ValidObject}->ValidLookup( ValidID => $Data{ValidID} );

                # get user data for needed user types
                USERTYPE:
                for my $UserType (qw(CreateBy ChangeBy)) {

                    # check if UserType attribute exists in the template
                    next USERTYPE if !$Data{$UserType};

                    # get user data
                    my %User = $Self->{UserObject}->GetUserData(
                        UserID => $Data{$UserType},
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
                        %Data,
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
                            },
                        );
                    }
                }
            }
        }
    }

    # if there are no templates to show, a no data found message is displayed in the table
    else {
        $Self->{LayoutObject}->Block(
            Name => 'NoDataFoundMsg',
            Data => {
                TotalColumns => scalar @ShowColumns,
            },
        );
    }

    # use template
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMTemplateOverviewSmall',
        Data         => {
            %Param,
            Type        => $Self->{ViewType},
            ColumnCount => scalar @ShowColumns,
        },
    );

    return $Output;
}

1;
