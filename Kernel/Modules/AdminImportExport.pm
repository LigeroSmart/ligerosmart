# --
# Kernel/Modules/AdminImportExport.pm - admin frontend of import export module
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AdminImportExport.pm,v 1.2 2008-01-23 17:15:32 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::AdminImportExport;

use strict;
use warnings;

use Kernel::System::ImportExport;
use Kernel::System::Valid;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get common objects
    %{$Self} = %Param;

    # check needed objects
    OBJECT:
    for my $Object (qw(ConfigObject ParamObject LogObject LayoutObject)) {
        next OBJECT if $Self->{$Object};
        $Self->{LayoutObject}->FatalError( Message => "Got no $Object!" );
    }
    $Self->{ImportExportObject} = Kernel::System::ImportExport->new( %{$Self} );
    $Self->{ValidObject}        = Kernel::System::Valid->new( %{$Self} );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # ------------------------------------------------------------ #
    # template edit
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'TemplateEdit1' ) {
        my $TemplateData = {};

        # get params
        $TemplateData->{TemplateID} = $Self->{ParamObject}->GetParam( Param => "TemplateID" );
        if ( $TemplateData->{TemplateID} eq 'NEW' ) {

            # get class
            $TemplateData->{Class} = $Self->{ParamObject}->GetParam( Param => "Class" );

            # redirect to overview
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" )
                if !$TemplateData->{Class};
        }
        else {

            # get template data
            $TemplateData = $Self->{ImportExportObject}->TemplateGet(
                TemplateID => $TemplateData->{TemplateID},
                UserID     => $Self->{UserID},
            );
        }

        # get class list
        my $ClassList = $Self->{ImportExportObject}->ClassList();

        # generate ClassOptionStrg
        my $ClassOptionStrg = $Self->{LayoutObject}->BuildSelection(
            Data         => $ClassList,
            Name         => 'Class',
            SelectedID   => $TemplateData->{Class},
            PossibleNone => 1,
            Translation  => 1,
        );

        # output overview
        $Self->{LayoutObject}->Block(
            Name => 'Overview',
            Data => {
                %Param,
                ClassOptionStrg => $ClassOptionStrg,
            },
        );

        # generate ValidOptionStrg
        my %ValidList        = $Self->{ValidObject}->ValidList();
        my %ValidListReverse = reverse %ValidList;
        my $ValidOptionStrg  = $Self->{LayoutObject}->BuildSelection(
            Name       => 'ValidID',
            Data       => \%ValidList,
            SelectedID => $TemplateData->{ValidID} || $ValidListReverse{valid},
        );

        # output list
        $Self->{LayoutObject}->Block(
            Name => 'TemplateEdit1',
            Data => {
                %{$TemplateData},
                ValidOptionStrg => $ValidOptionStrg,
            },
        );

        # output header and navbar
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # start template output
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminImportExport',
            Data         => \%Param,
        );

        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # template save
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'TemplateSave1' ) {
        my $TemplateData = {};

        # get params
        for my $Param (qw(TemplateID Class Name ValidID Comment)) {
            $TemplateData->{$Param} = $Self->{ParamObject}->GetParam( Param => $Param ) || '';
        }

        # save to database
        my $Success;
        if ( $TemplateData->{TemplateID} eq 'NEW' ) {
            $Success
                = $TemplateData->{TemplateID}
                = $Self->{ImportExportObject}
                ->TemplateAdd( %{$TemplateData}, UserID => $Self->{UserID} );
        }
        else {
            $Success
                = $Self->{ImportExportObject}
                ->TemplateUpdate( %{$TemplateData}, UserID => $Self->{UserID} );
        }

        return $Self->{LayoutObject}->ErrorScreen() if !$Success;

        # redirect to overview class list
        return $Self->{LayoutObject}
            ->Redirect(
            OP =>
                "Action=$Self->{Action}&Subaction=TemplateTemplateID&TemplateID=$TemplateData->{TemplateID}"
            );
    }

    # ------------------------------------------------------------ #
    # overview
    # ------------------------------------------------------------ #
    else {

        # get valid list
        my %ValidList = $Self->{ValidObject}->ValidList();

        # get class list
        my $ClassList = $Self->{ImportExportObject}->ClassList();

        # generate ClassOptionStrg
        my $ClassOptionStrg = $Self->{LayoutObject}->BuildSelection(
            Data         => $ClassList,
            Name         => 'Class',
            PossibleNone => 1,
            Translation  => 1,
        );

        # output overview
        $Self->{LayoutObject}->Block(
            Name => 'Overview',
            Data => {
                %Param,
                ClassOptionStrg => $ClassOptionStrg,
            },
        );
        $Self->{LayoutObject}->Block(
            Name => 'OverviewList',
        );

        CLASS:
        for my $Class ( sort { $ClassList->{$a} cmp $ClassList->{$b} } keys %{$ClassList} ) {

            # get template list
            my $TemplateList = $Self->{ImportExportObject}->TemplateList(
                Class  => $Class,
                UserID => $Self->{UserID},
            );

            next CLASS if !$TemplateList;
            next CLASS if ref $TemplateList ne 'ARRAY';
            next CLASS if !@{$TemplateList};

            # output list
            $Self->{LayoutObject}->Block(
                Name => 'OverviewListClass',
                Data => {
                    ClassName => $ClassList->{$Class},
                },
            );

            my $CssClass = 'searchpassive';
            for my $TemplateID ( @{$TemplateList} ) {

                # set output class
                $CssClass = $CssClass eq 'searchactive' ? 'searchpassive' : 'searchactive';

                # get template data
                my $TemplateData = $Self->{ImportExportObject}->TemplateGet(
                    TemplateID => $TemplateID,
                    UserID     => $Self->{UserID},
                );

                # output row
                $Self->{LayoutObject}->Block(
                    Name => 'OverviewListClassRow',
                    Data => {
                        %{$TemplateData},
                        CssClass => $CssClass,
                        Valid    => $ValidList{ $TemplateData->{ValidID} },
                    },
                );
            }
        }

        # output header and navbar
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # start template output
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminImportExport',
            Data         => \%Param,
        );

        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}

1;
