# --
# Kernel/Modules/AdminImportExport.pm - admin frontend of import export module
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AdminImportExport.pm,v 1.5 2008-01-24 16:57:56 mh Exp $
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
$VERSION = qw($Revision: 1.5 $) [1];

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

        # get object list
        my $ObjectList = $Self->{ImportExportObject}->ObjectList();

        return $Self->{LayoutObject}->FatalError( Message => 'No object backend found!' )
            if !$ObjectList;

        # get format list
        my $FormatList = $Self->{ImportExportObject}->FormatList();

        return $Self->{LayoutObject}->FatalError( Message => 'No format backend found!' )
            if !$FormatList;

        # get params
        my $TemplateData = {};
        $TemplateData->{TemplateID} = $Self->{ParamObject}->GetParam( Param => 'TemplateID' );
        if ( $TemplateData->{TemplateID} eq 'NEW' ) {

            # get object and format
            $TemplateData->{Object} = $Self->{ParamObject}->GetParam( Param => 'Object' );
            $TemplateData->{Format} = $Self->{ParamObject}->GetParam( Param => 'Format' );

            # redirect to overview
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" )
                if !$TemplateData->{Object} || !$TemplateData->{Format};
        }
        else {

            # get template data
            $TemplateData = $Self->{ImportExportObject}->TemplateGet(
                TemplateID => $TemplateData->{TemplateID},
                UserID     => $Self->{UserID},
            );
        }

        # generate ObjectOptionStrg
        my $ObjectOptionStrg = $Self->{LayoutObject}->BuildSelection(
            Data         => $ObjectList,
            Name         => 'Object',
            SelectedID   => $TemplateData->{Object},
            PossibleNone => 1,
            Translation  => 1,
        );

        # generate FormatOptionStrg
        my $FormatOptionStrg = $Self->{LayoutObject}->BuildSelection(
            Data         => $FormatList,
            Name         => 'Format',
            SelectedID   => $TemplateData->{Format},
            PossibleNone => 1,
            Translation  => 1,
        );

        # output overview
        $Self->{LayoutObject}->Block(
            Name => 'Overview',
            Data => {
                %Param,
                ObjectOptionStrg => $ObjectOptionStrg,
                FormatOptionStrg => $FormatOptionStrg,
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
                ObjectName      => $ObjectList->{ $TemplateData->{Object} },
                FormatName      => $FormatList->{ $TemplateData->{Format} },
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
        for my $Param (qw(TemplateID Object Format Name ValidID Comment)) {
            $TemplateData->{$Param} = $Self->{ParamObject}->GetParam( Param => $Param ) || '';
        }

        # save to database
        my $Success;
        if ( $TemplateData->{TemplateID} eq 'NEW' ) {
            $Success = $Self->{ImportExportObject}->TemplateAdd(
                %{$TemplateData},
                UserID => $Self->{UserID},
            );
        }
        else {
            $Success = $Self->{ImportExportObject}->TemplateUpdate(
                %{$TemplateData},
                UserID => $Self->{UserID},
            );
        }

        return $Self->{LayoutObject}->FatalError( Message => "Can't insert/update template!" )
            if !$Success;

        # redirect to overview object list
        return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
    }

    # ------------------------------------------------------------ #
    # template delete
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'TemplateDelete' ) {

        # get template id
        my $TemplateID = $Self->{ParamObject}->GetParam( Param => 'TemplateID' );

        # save to database
        $Self->{ImportExportObject}->TemplateDelete(
            TemplateID => $TemplateID,
            UserID     => $Self->{UserID},
        );

        # redirect to overview
        return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
    }

    # ------------------------------------------------------------ #
    # overview
    # ------------------------------------------------------------ #
    else {

        # get object list
        my $ObjectList = $Self->{ImportExportObject}->ObjectList();

        return $Self->{LayoutObject}->FatalError( Message => 'No object backend found!' )
            if !$ObjectList;

        # get format list
        my $FormatList = $Self->{ImportExportObject}->FormatList();

        return $Self->{LayoutObject}->FatalError( Message => 'No format backend found!' )
            if !$FormatList;

        # generate ObjectOptionStrg
        my $ObjectOptionStrg = $Self->{LayoutObject}->BuildSelection(
            Data         => $ObjectList,
            Name         => 'Object',
            PossibleNone => 1,
            Translation  => 1,
        );

        # generate FormatOptionStrg
        my $FormatOptionStrg = $Self->{LayoutObject}->BuildSelection(
            Data         => $FormatList,
            Name         => 'Format',
            PossibleNone => 1,
            Translation  => 1,
        );

        # output overview
        $Self->{LayoutObject}->Block(
            Name => 'Overview',
            Data => {
                %Param,
                ObjectOptionStrg => $ObjectOptionStrg,
                FormatOptionStrg => $FormatOptionStrg,
            },
        );

        # get valid list
        my %ValidList = $Self->{ValidObject}->ValidList();

        CLASS:
        for my $Object ( sort { $ObjectList->{$a} cmp $ObjectList->{$b} } keys %{$ObjectList} ) {

            # get template list
            my $TemplateList = $Self->{ImportExportObject}->TemplateList(
                Object => $Object,
                UserID => $Self->{UserID},
            );

            next CLASS if !$TemplateList;
            next CLASS if ref $TemplateList ne 'ARRAY';
            next CLASS if !@{$TemplateList};

            # output list
            $Self->{LayoutObject}->Block(
                Name => 'OverviewList',
                Data => {
                    ObjectName => $ObjectList->{$Object},
                },
            );

            my $CssClass = 'searchpassive';
            for my $TemplateID ( @{$TemplateList} ) {

                # set output object
                $CssClass = $CssClass eq 'searchactive' ? 'searchpassive' : 'searchactive';

                # get template data
                my $TemplateData = $Self->{ImportExportObject}->TemplateGet(
                    TemplateID => $TemplateID,
                    UserID     => $Self->{UserID},
                );

                # output row
                $Self->{LayoutObject}->Block(
                    Name => 'OverviewListRow',
                    Data => {
                        %{$TemplateData},
                        FormatName => $FormatList->{ $TemplateData->{Format} },
                        CssClass   => $CssClass,
                        Valid      => $ValidList{ $TemplateData->{ValidID} },
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
