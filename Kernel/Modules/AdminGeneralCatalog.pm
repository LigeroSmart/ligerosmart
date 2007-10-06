# --
# Kernel/Modules/AdminGeneralCatalog.pm - admin frontend of general catalog management
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: AdminGeneralCatalog.pm,v 1.13 2007-10-06 10:31:44 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminGeneralCatalog;

use strict;
use warnings;

use Kernel::System::GeneralCatalog;
use Kernel::System::Valid;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.13 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get common objects
    %{$Self} = %Param;

    # check needed objects
    for my $Object (qw(ConfigObject ParamObject LogObject LayoutObject)) {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Object!" );
        }
    }
    $Self->{GeneralCatalogObject} = Kernel::System::GeneralCatalog->new(%Param);
    $Self->{ValidObject}          = Kernel::System::Valid->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # ------------------------------------------------------------ #
    # catalog item list
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'ItemList' ) {
        my $Class = $Self->{ParamObject}->GetParam( Param => "Class" ) || '';

        # check needed Class
        if ( !$Class ) {
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
        }

        # get catalog class list
        my $ClassList       = $Self->{GeneralCatalogObject}->ClassList();
        my $ClassOptionStrg = $Self->{LayoutObject}->BuildSelection(
            Name         => 'Class',
            Data         => $ClassList,
            SelectedID   => $Class,
            PossibleNone => 1,
            Translation  => 0,
        );

        # output overview
        $Self->{LayoutObject}->Block(
            Name => 'Overview',
            Data => { %Param, ClassOptionStrg => $ClassOptionStrg },
        );
        $Self->{LayoutObject}->Block(
            Name => 'OverviewItem',
            Data => { %Param, Class => $Class },
        );

        # get availability list
        my %ValidList = $Self->{ValidObject}->ValidList();

        # get catalog item list
        my $ItemIDList = $Self->{GeneralCatalogObject}->ItemList(
            Class => $Class,
            Valid => 0,
        );
        my $CssClass;
        for my $ItemID ( sort { $ItemIDList->{$a} cmp $ItemIDList->{$b} } keys %{$ItemIDList} ) {

            # get item data
            my $ItemData = $Self->{GeneralCatalogObject}->ItemGet( ItemID => $ItemID );

            # set output class
            if ( $CssClass && $CssClass eq 'searchactive' ) {
                $CssClass = 'searchpassive';
            }
            else {
                $CssClass = 'searchactive';
            }
            $Self->{LayoutObject}->Block(
                Name => 'OverviewItemList',
                Data => {
                    %{$ItemData},
                    CssClass      => $CssClass,
                    Functionality => $ItemData->{Functionality} || '-',
                    Valid         => $ValidList{ $ItemData->{ValidID} },
                },
            );
        }

        # output header and navbar
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # create output string
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminGeneralCatalog',
            Data         => \%Param,
        );

        # add footer
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # catalog item edit
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ItemEdit' ) {
        my %ItemData;

        # get params
        $ItemData{ItemID} = $Self->{ParamObject}->GetParam( Param => "ItemID" );
        if ( $ItemData{ItemID} eq 'NEW' ) {
            $ItemData{Class} = $Self->{ParamObject}->GetParam( Param => "Class" );

            # redirect to overview
            if ( !$ItemData{Class} ) {
                return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
            }
        }
        else {
            my $ItemDataRef = $Self->{GeneralCatalogObject}->ItemGet( ItemID => $ItemData{ItemID} );
            %ItemData = %{$ItemDataRef};
        }

        # get catalog class list
        my $ClassList       = $Self->{GeneralCatalogObject}->ClassList();
        my $ClassOptionStrg = $Self->{LayoutObject}->BuildSelection(
            Name         => 'Class',
            Data         => $ClassList,
            SelectedID   => $ItemData{Class},
            PossibleNone => 1,
            Translation  => 0,
        );

        # output overview
        $Self->{LayoutObject}->Block(
            Name => 'Overview',
            Data => { %Param, ClassOptionStrg => $ClassOptionStrg },
        );

        # generate FunctionalityOptionStrg
        my $FunctionalityRef
            = $Self->{GeneralCatalogObject}->FunctionalityList( Class => $ItemData{Class} );
        my $FunctionalityOptionStrg = $Self->{LayoutObject}->BuildSelection(
            Name         => 'Functionality',
            Data         => $FunctionalityRef,
            PossibleNone => 1,
            SelectedID   => $ItemData{Functionality} || '',
            Translation  => 0,
        );

        # generate ValidOptionStrg
        my %ValidList        = $Self->{ValidObject}->ValidList();
        my %ValidListReverse = reverse %ValidList;
        my $ValidOptionStrg  = $Self->{LayoutObject}->BuildSelection(
            Name       => 'ValidID',
            Data       => \%ValidList,
            SelectedID => $ItemData{ValidID} || $ValidListReverse{valid},
        );

        # output ItemEdit
        $Self->{LayoutObject}->Block(
            Name => 'ItemEdit',
            Data => {
                %ItemData,
                FunctionalityOptionStrg => $FunctionalityOptionStrg,
                ValidOptionStrg         => $ValidOptionStrg,
            },
        );
        if ( $ItemData{Class} eq 'NEW' ) {

            # output ItemEditClassAdd
            $Self->{LayoutObject}->Block(
                Name => 'ItemEditClassAdd',
                Data => { Class => $ItemData{Class} },
            );
        }
        else {

            # output ItemEditClassExist
            $Self->{LayoutObject}->Block(
                Name => 'ItemEditClassExist',
                Data => { Class => $ItemData{Class} },
            );
        }

        # output header
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # create output string
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminGeneralCatalog',
            Data         => \%Param,
        );

        # add footer
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # catalog item save
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ItemSave' ) {
        my %ItemData;

        # get params
        for my $Param (qw(Class ItemID Name Functionality ValidID Comment)) {
            $ItemData{$Param} = $Self->{ParamObject}->GetParam( Param => $Param ) || '';
        }

        # check class
        if ( !$ItemData{Class}
            || ( $ItemData{Class} && $ItemData{Class} eq 'NEW' ) )
        {

            # redirect to overview class list
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
        }

        # save to database
        if ( $ItemData{ItemID} eq 'NEW' ) {
            my $Success
                = $Self->{GeneralCatalogObject}->ItemAdd( %ItemData, UserID => $Self->{UserID} );
            if ( !$Success ) {
                return $Self->{LayoutObject}->ErrorScreen();
            }
        }
        else {
            my $Success
                = $Self->{GeneralCatalogObject}->ItemUpdate( %ItemData, UserID => $Self->{UserID} );
            if ( !$Success ) {
                return $Self->{LayoutObject}->ErrorScreen();
            }
        }

        # redirect to overview class list
        return $Self->{LayoutObject}
            ->Redirect( OP => "Action=$Self->{Action}&Subaction=ItemList&Class=$ItemData{Class}" );
    }

    # ------------------------------------------------------------ #
    # overview
    # ------------------------------------------------------------ #
    else {

        # get catalog class list
        my $ClassList       = $Self->{GeneralCatalogObject}->ClassList();
        my $ClassOptionStrg = $Self->{LayoutObject}->BuildSelection(
            Name         => 'Class',
            Data         => $ClassList,
            PossibleNone => 1,
            Translation  => 0,
        );

        # output overview
        $Self->{LayoutObject}->Block(
            Name => 'Overview',
            Data => { %Param, ClassOptionStrg => $ClassOptionStrg },
        );
        $Self->{LayoutObject}->Block(
            Name => 'OverviewClass',
            Data => {%Param},
        );
        my $CssClass;
        for my $Class ( @{$ClassList} ) {

            # set output class
            if ( $CssClass && $CssClass eq 'searchactive' ) {
                $CssClass = 'searchpassive';
            }
            else {
                $CssClass = 'searchactive';
            }

            # output overview class list
            $Self->{LayoutObject}->Block(
                Name => 'OverviewClassList',
                Data => {
                    Class    => $Class,
                    CssClass => $CssClass,
                },
            );
        }

        # output header and navbar
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # create output string
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminGeneralCatalog',
            Data         => \%Param,
        );

        # add footer
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }
}

1;
