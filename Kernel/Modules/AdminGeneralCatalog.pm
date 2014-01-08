# --
# Kernel/Modules/AdminGeneralCatalog.pm - admin frontend of general catalog management
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminGeneralCatalog;

use strict;
use warnings;

use Kernel::System::GeneralCatalog;
use Kernel::System::Valid;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

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

        # check needed class
        if ( !$Class ) {
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
        }

        # output overview
        $Self->{LayoutObject}->Block(
            Name => 'Overview',
            Data => {
                %Param,
            },
        );
        $Self->{LayoutObject}->Block(
            Name => 'OverviewItem',
            Data => {
                %Param,
                Class => $Class,
            },
        );

        # get availability list
        my %ValidList = $Self->{ValidObject}->ValidList();

        # get catalog item list
        my $ItemIDList = $Self->{GeneralCatalogObject}->ItemList(
            Class => $Class,
            Valid => 0,
        );

        # check item list
        if ( !$ItemIDList || !%{$ItemIDList} ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        for my $ItemID ( sort { $ItemIDList->{$a} cmp $ItemIDList->{$b} } keys %{$ItemIDList} ) {

            # get item data
            my $ItemData = $Self->{GeneralCatalogObject}->ItemGet(
                ItemID => $ItemID,
            );

            # output overview item list
            $Self->{LayoutObject}->Block(
                Name => 'OverviewItemList',
                Data => {
                    %{$ItemData},
                    Valid => $ValidList{ $ItemData->{ValidID} },
                },
            );
        }

        # ActionOverview
        $Self->{LayoutObject}->Block(
            Name => 'ActionAddItem',
            Data => {
                %Param,
                Class => $Class,
            },
        );

        # ActionOverview
        $Self->{LayoutObject}->Block(
            Name => 'ActionOverview',
        );

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

        # add a new catalog item
        if ( $ItemData{ItemID} eq 'NEW' ) {

            # get class
            $ItemData{Class} = $Self->{ParamObject}->GetParam( Param => "Class" );

            # redirect to overview
            if ( !$ItemData{Class} ) {
                return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
            }
        }

        # edit an existing catalog item
        else {

            # get item data
            my $ItemDataRef = $Self->{GeneralCatalogObject}->ItemGet(
                ItemID => $ItemData{ItemID},
            );

            # check item data
            if ( !$ItemDataRef ) {
                return $Self->{LayoutObject}->ErrorScreen();
            }

            %ItemData = %{$ItemDataRef};
        }

        # output overview
        $Self->{LayoutObject}->Block(
            Name => 'Overview',
            Data => {
                %Param,
                Class => $ItemData{Class},
            },
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
                ValidOptionStrg => $ValidOptionStrg,
            },
        );

        # show each preferences setting
        my %Preferences = ();
        if ( $Self->{ConfigObject}->Get('GeneralCatalogPreferences') ) {
            %Preferences = %{ $Self->{ConfigObject}->Get('GeneralCatalogPreferences') };
        }

        ITEM:
        for my $Item ( sort keys %Preferences ) {

            # skip items that don't belong to the class
            if ( $Preferences{$Item}->{Class} && $Preferences{$Item}->{Class} ne $ItemData{Class} )
            {
                next ITEM;
            }

            # find output module
            my $Module = $Preferences{$Item}->{Module}
                || 'Kernel::Output::HTML::GeneralCatalogPreferencesGeneric';

            # load module
            if ( !$Self->{MainObject}->Require($Module) ) {
                return $Self->{LayoutObject}->FatalError();
            }

            # create object for this preferences item
            my $Object = $Module->new(
                %{$Self},
                ConfigItem => $Preferences{$Item},
                Debug      => $Self->{Debug},
            );

            # show all parameters
            my @Params = $Object->Param( GeneralCatalogData => { %ItemData, %Param } );
            for my $ParamItem (@Params) {

                if (
                    ref( $ParamItem->{Data} ) eq 'HASH'
                    || ref( $Preferences{$Item}->{Data} ) eq 'HASH'
                    )
                {
                    $ParamItem->{'Option'} = $Self->{LayoutObject}->BuildSelection(
                        %{ $Preferences{$Item} },
                        %{$ParamItem},
                    );
                }

                $Self->{LayoutObject}->Block(
                    Name => $ParamItem->{Block} || $Preferences{$Item}->{Block} || 'Option',
                    Data => {
                        %{ $Preferences{$Item} },
                        %{$ParamItem},
                    },
                );
            }
        }

        if ( $ItemData{Class} eq 'NEW' ) {

            # output ItemEditClassAdd
            $Self->{LayoutObject}->Block(
                Name => 'ItemEditClassAdd',
                Data => {
                    Class => $ItemData{Class},
                },
            );
        }
        else {

            # output ItemEditClassExist
            $Self->{LayoutObject}->Block(
                Name => 'ItemEditClassExist',
                Data => {
                    Class => $ItemData{Class},
                },
            );
        }

        # ActionOverview
        $Self->{LayoutObject}->Block(
            Name => 'ActionOverview',
        );

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
        for my $Param (qw(Class ItemID ValidID Comment)) {
            $ItemData{$Param} = $Self->{ParamObject}->GetParam( Param => $Param ) || '';
        }

        # get name param, name must be not empty, but number zero (0) is allowed
        $ItemData{Name} = $Self->{ParamObject}->GetParam( Param => 'Name' );

        # check class
        if ( $ItemData{Class} eq 'NEW' ) {
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
        }

        # save to database
        my $Success;
        my $ItemID = $ItemData{ItemID};
        if ( $ItemData{ItemID} eq 'NEW' ) {
            $Success = $Self->{GeneralCatalogObject}->ItemAdd(
                %ItemData,
                UserID => $Self->{UserID},
            );
            $ItemID = $Success;
        }
        else {
            $Success = $Self->{GeneralCatalogObject}->ItemUpdate(
                %ItemData,
                UserID => $Self->{UserID},
            );
        }

        # update preferences
        my $GCData      = $Self->{GeneralCatalogObject}->ItemGet( ItemID => $ItemID );
        my %Preferences = ();
        my $Note        = '';

        if ( $Self->{ConfigObject}->Get('GeneralCatalogPreferences') ) {
            %Preferences = %{ $Self->{ConfigObject}->Get('GeneralCatalogPreferences') };
        }

        for my $Item ( sort keys %Preferences ) {
            my $Module = $Preferences{$Item}->{Module}
                || 'Kernel::Output::HTML::GeneralCatalogPreferencesGeneric';

            # load module
            if ( !$Self->{MainObject}->Require($Module) ) {
                return $Self->{LayoutObject}->FatalError();
            }

            my $Object = $Module->new(
                %{$Self},
                ConfigItem => $Preferences{$Item},
                Debug      => $Self->{Debug},
            );
            my @Params = $Object->Param( GeneralCatalogData => $GCData );
            if (@Params) {
                my %GetParam = ();
                for my $ParamItem (@Params) {
                    my @Array = $Self->{ParamObject}->GetArray( Param => $ParamItem->{Name} );
                    $GetParam{ $ParamItem->{Name} } = \@Array;
                }
                if (
                    !$Object->Run(
                        GetParam => \%GetParam,
                        ItemID   => $GCData->{ItemID},
                    )
                    )
                {
                    $Note .= $Self->{LayoutObject}->Notify( Info => $Object->Error() );
                }
            }
        }

        if ( !$Success ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        # redirect to overview class list
        return $Self->{LayoutObject}->Redirect(
            OP => "Action=$Self->{Action};Subaction=ItemList;Class=$ItemData{Class}"
        );
    }

    # ------------------------------------------------------------ #
    # overview
    # ------------------------------------------------------------ #
    else {

        # output overview
        $Self->{LayoutObject}->Block(
            Name => 'Overview',
            Data => {
                %Param,
            },
        );
        $Self->{LayoutObject}->Block(
            Name => 'OverviewClass',
            Data => {
                %Param,
            },
        );

        # get catalog class list
        my $ClassList = $Self->{GeneralCatalogObject}->ClassList();

        for my $Class ( @{$ClassList} ) {

            # output overview class list
            $Self->{LayoutObject}->Block(
                Name => 'OverviewClassList',
                Data => {
                    Class => $Class,
                },
            );
        }

        # ActionAddClass
        $Self->{LayoutObject}->Block(
            Name => 'ActionAddClass',
        );

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
