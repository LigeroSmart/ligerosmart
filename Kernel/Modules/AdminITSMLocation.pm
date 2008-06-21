# --
# Kernel/Modules/AdminITSMLocation.pm - admin frontend to manage locations
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AdminITSMLocation.pm,v 1.1 2008-06-21 16:50:14 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::AdminITSMLocation;

use strict;
use warnings;

use Kernel::System::GeneralCatalog;
use Kernel::System::ITSMLocation;
use Kernel::System::Valid;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(ParamObject DBObject LayoutObject ConfigObject LogObject)) {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Object!" );
        }
    }
    $Self->{GeneralCatalogObject} = Kernel::System::GeneralCatalog->new(%Param);
    $Self->{LocationObject}       = Kernel::System::ITSMLocation->new(%Param);
    $Self->{ValidObject}          = Kernel::System::Valid->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # ------------------------------------------------------------ #
    # location edit
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'LocationEdit' ) {
        my %LocationData;

        # get params
        $LocationData{LocationID} = $Self->{ParamObject}->GetParam( Param => 'LocationID' );
        if ( $LocationData{LocationID} ne 'NEW' ) {
            %LocationData = $Self->{LocationObject}->LocationGet(
                LocationID => $LocationData{LocationID},
                UserID     => $Self->{UserID},
            );
        }

        # output overview
        $Self->{LayoutObject}->Block(
            Name => 'Overview',
            Data => {%Param},
        );

        # generate ParentOptionStrg
        my $TreeView = 0;
        if ( $Self->{ConfigObject}->Get('Ticket::Frontend::ListType') eq 'tree' ) {
            $TreeView = 1;
        }
        my %LocationList = $Self->{LocationObject}->LocationList(
            Valid  => 0,
            UserID => $Self->{UserID},
        );
        $LocationData{ParentOptionStrg} = $Self->{LayoutObject}->BuildSelection(
            Data           => \%LocationList,
            Name           => 'ParentID',
            SelectedID     => $LocationData{ParentID},
            PossibleNone   => 1,
            TreeView       => $TreeView,
            Sort           => 'TreeView',
            DisabledBranch => $LocationData{Name},
            Translation    => 0,
        );

        # generate TypeOptionStrg
        my $TypeList = $Self->{GeneralCatalogObject}->ItemList( Class => 'ITSM::Location::Type' );
        $LocationData{TypeOptionStrg} = $Self->{LayoutObject}->BuildSelection(
            Data       => $TypeList,
            Name       => 'TypeID',
            SelectedID => $LocationData{TypeID},
        );

        # generate ValidOptionStrg
        my %ValidList = $Self->{ValidObject}->ValidList();
        $LocationData{ValidOptionStrg} = $Self->{LayoutObject}->BuildSelection(
            Data       => \%ValidList,
            Name       => 'ValidID',
            SelectedID => $LocationData{ValidID},
        );

        # output location edit
        $Self->{LayoutObject}->Block(
            Name => 'LocationEdit',
            Data => {
                %Param,
                %LocationData,
            },
        );

        # output header
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # generate output
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminITSMLocation',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # location save
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'LocationSave' ) {
        my %LocationData;

        # get params
        for my $FormParam (
            qw(LocationID ParentID Name TypeID Phone1 Phone2 Fax Email Address ValidID Comment)
            )
        {
            $LocationData{$FormParam} = $Self->{ParamObject}->GetParam( Param => $FormParam ) || '';
        }

        # save to database
        my $Success;
        if ( $LocationData{LocationID} eq 'NEW' ) {
            $Success = $Self->{LocationObject}->LocationAdd(
                %LocationData,
                UserID => $Self->{UserID},
            );
        }
        else {
            $Success = $Self->{LocationObject}->LocationUpdate(
                %LocationData,
                UserID => $Self->{UserID},
            );
        }

        return $Self->{LayoutObject}->ErrorScreen() if !$Success;
        return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
    }

    # ------------------------------------------------------------ #
    # location overview
    # ------------------------------------------------------------ #
    else {

        # output overview
        $Self->{LayoutObject}->Block(
            Name => 'Overview',
            Data => {%Param},
        );

        # output overview result
        $Self->{LayoutObject}->Block(
            Name => 'OverviewList',
            Data => {%Param},
        );

        # get location types
        my $TypeList = $Self->{GeneralCatalogObject}->ItemList(
            Class => 'ITSM::Location::Type',
        );

        # get location list
        my %LocationList = $Self->{LocationObject}->LocationList(
            Valid  => 0,
            UserID => $Self->{UserID},
        );

        # get valid list
        my %ValidList = $Self->{ValidObject}->ValidList();

        # add suffix for correct sorting
        for my $Location ( values %LocationList ) {
            $Location .= '::';
        }

        my $CssClass = '';
        for my $LocationID ( sort { $LocationList{$a} cmp $LocationList{$b} } keys %LocationList ) {

            # set output object
            $CssClass = $CssClass eq 'searchactive' ? 'searchpassive' : 'searchactive';

            # get location data
            my %LocationData = $Self->{LocationObject}->LocationGet(
                LocationID => $LocationID,
                UserID     => $Self->{UserID},
            );

            # output row
            if ( $Self->{ConfigObject}->Get('Ticket::Frontend::ListType') eq 'tree' ) {
                $Self->{LayoutObject}->Block(
                    Name => 'OverviewListRow',
                    Data => {
                        %LocationData,
                        Name     => $LocationData{NameShort},
                        Type     => $TypeList->{ $LocationData{TypeID} },
                        CssClass => $CssClass,
                        Valid    => $ValidList{ $LocationData{ValidID} },
                    },
                );

                my @Fragment = split '::', $LocationData{Name};
                pop @Fragment;

                for (@Fragment) {
                    $Self->{LayoutObject}->Block(
                        Name => 'OverviewListRowSpace',
                    );
                }
            }
            else {
                $Self->{LayoutObject}->Block(
                    Name => 'OverviewListRow',
                    Data => {
                        %LocationData,
                        Type     => $TypeList->{ $LocationData{TypeID} },
                        CssClass => $CssClass,
                        Valid    => $ValidList{ $LocationData{ValidID} },
                    },
                );
            }
        }

        # output header
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # generate output
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminITSMLocation',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }
}

1;
