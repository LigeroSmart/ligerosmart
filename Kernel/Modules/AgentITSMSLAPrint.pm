# --
# Kernel/Modules/AgentITSMSLAPrint.pm - print layout for itsm sla agent interface
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AgentITSMSLAPrint.pm,v 1.2 2008-08-02 13:43:02 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::AgentITSMSLAPrint;

use strict;
use warnings;

use Kernel::System::PDF;
use Kernel::System::SLA;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(ConfigObject ParamObject DBObject LayoutObject LogObject)) {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Object!" );
        }
    }
    $Self->{PDFObject} = Kernel::System::PDF->new(%Param);
    $Self->{SLAObject} = Kernel::System::SLA->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get params
    my $SLAID = $Self->{ParamObject}->GetParam( Param => "SLAID" );

    # check needed stuff
    if ( !$SLAID ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "No SLAID is given!",
            Comment => 'Please contact the admin.',
        );
    }

    # get sla
    my %SLA = $Self->{SLAObject}->SLAGet(
        SLAID  => $SLAID,
        UserID => $Self->{UserID},
    );
    if ( !$SLA{SLAID} ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "SLAID $SLAID not found in database!",
            Comment => 'Please contact the admin.',
        );
    }

    # get calendar name
    if ( $SLA{Calendar} ) {
        $SLA{CalendarName} = "Calendar $SLA{Calendar} - "
            . $Self->{ConfigObject}->Get( "TimeZone::Calendar" . $SLA{Calendar} . "Name" );
    }
    else {
        $SLA{CalendarName} = 'Calendar Default';
    }

    # get user data (create by)
    my %CreateBy = $Self->{UserObject}->GetUserData(
        UserID => $SLA{CreateBy},
        Cached => 1,
    );

    # get user data (change by)
    my %ChangeBy = $Self->{UserObject}->GetUserData(
        UserID => $SLA{ChangeBy},
        Cached => 1,
    );

    # generate pdf output
    if ( $Self->{PDFObject} ) {
        my %Page;
        my $Url = ' ';
        if ( $ENV{REQUEST_URI} ) {
            $Url
                = $Self->{ConfigObject}->Get('HttpType') . '://'
                . $Self->{ConfigObject}->Get('FQDN')
                . $ENV{REQUEST_URI};
        }

        # get maximum number of pages
        $Page{MaxPages} = $Self->{ConfigObject}->Get('PDF::MaxPages');
        if ( !$Page{MaxPages} || $Page{MaxPages} < 1 || $Page{MaxPages} > 1000 ) {
            $Page{MaxPages} = 100;
        }
        $Page{MarginTop}    = 30;
        $Page{MarginRight}  = 40;
        $Page{MarginBottom} = 40;
        $Page{MarginLeft}   = 40;
        $Page{HeaderRight}  = $Self->{LayoutObject}->{LanguageObject}->Get('SLA');
        $Page{HeadlineLeft} = $SLA{Name};
        $Page{HeadlineRight}
            = $Self->{LayoutObject}->{LanguageObject}->Get('printed by') . ' '
            . $Self->{UserFirstname} . ' '
            . $Self->{UserLastname} . ' ('
            . $Self->{UserEmail} . ') '
            . $Self->{LayoutObject}->Output( Template => '$Env{"Time"}' );
        $Page{FooterLeft} = $Url;
        $Page{PageText}   = $Self->{LayoutObject}->{LanguageObject}->Get('Page');
        $Page{PageCount}  = 1;

        # create new pdf document
        $Self->{PDFObject}->DocumentNew(
            Title  => $Self->{ConfigObject}->Get('Product') . ': ' . $SLA{Name},
            Encode => $Self->{LayoutObject}->{UserCharset},
        );

        # create first pdf page
        $Self->{PDFObject}->PageNew(
            %Page,
            FooterRight => $Page{PageText} . ' ' . $Page{PageCount},
        );
        $Page{PageCount}++;

        # output general infos
        $Self->_PDFOutputGeneralInfos(
            Page     => \%Page,
            SLA      => \%SLA,
            CreateBy => \%CreateBy,
            ChangeBy => \%ChangeBy,
        );

        # output detailed infos
        $Self->_PDFOutputDetailedInfos(
            Page => \%Page,
            SLA  => \%SLA,
        );

        # create file name
        my $Filename = $Self->{MainObject}->FilenameCleanUp(
            Filename => $SLA{Name},
            Type     => 'Attachment',
        );
        my ( $s, $m, $h, $D, $M, $Y ) = $Self->{TimeObject}->SystemTime2Date(
            SystemTime => $Self->{TimeObject}->SystemTime(),
        );
        $M = sprintf( "%02d", $M );
        $D = sprintf( "%02d", $D );
        $h = sprintf( "%02d", $h );
        $m = sprintf( "%02d", $m );

        # return the pdf document
        return $Self->{LayoutObject}->Attachment(
            Filename    => 'sla_' . $Filename . "_$Y-$M-$D\_$h-$m.pdf",
            ContentType => 'application/pdf',
            Content     => $Self->{PDFObject}->DocumentOutput(),
            Type        => 'attachment',
        );
    }

    # generate html output
    else {

        # output header
        my $Output = $Self->{LayoutObject}->PrintHeader( Value => $SLA{Name} );

        # generate output
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentITSMSLAPrint',
            Data         => {
                CreateByUserLogin     => $CreateBy{UserLogin},
                CreateByUserFirstname => $CreateBy{UserFirstname},
                CreateByUserLastname  => $CreateBy{UserLastname},
                ChangeByUserLogin     => $ChangeBy{UserLogin},
                ChangeByUserFirstname => $ChangeBy{UserFirstname},
                ChangeByUserLastname  => $ChangeBy{UserLastname},
                %SLA,
            },
        );

        # add footer
        $Output .= $Self->{LayoutObject}->PrintFooter();

        # return output
        return $Output;
    }
}

sub _PDFOutputGeneralInfos {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Page SLA CreateBy ChangeBy)) {
        if ( !defined $Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!"
            );
            return;
        }
    }

    # create left table
    my $TableLeft = [
        {
            Key   => $Self->{LayoutObject}->{LanguageObject}->Get('SLA') . ':',
            Value => $Param{SLA}->{Name},
        },
    ];

    # create right table
    my $TableRight = [
        {
            Key   => $Self->{LayoutObject}->{LanguageObject}->Get('Created') . ':',
            Value => $Self->{LayoutObject}->Output(
                Template => '$TimeLong{"$Data{"CreateTime"}"}',
                Data     => \%{ $Param{SLA} },
            ),
        },
        {
            Key   => $Self->{LayoutObject}->{LanguageObject}->Get('Created by') . ':',
            Value => $Param{CreateBy}->{UserLogin} . ' ('
                . $Param{CreateBy}->{UserFirstname} . ' '
                . $Param{CreateBy}->{UserLastname} . ')',
        },
        {
            Key   => $Self->{LayoutObject}->{LanguageObject}->Get('Last changed') . ':',
            Value => $Self->{LayoutObject}->Output(
                Template => '$TimeLong{"$Data{"ChangeTime"}"}',
                Data     => \%{ $Param{SLA} },
            ),
        },
        {
            Key   => $Self->{LayoutObject}->{LanguageObject}->Get('Last changed by') . ':',
            Value => $Param{ChangeBy}->{UserLogin} . ' ('
                . $Param{ChangeBy}->{UserFirstname} . ' '
                . $Param{ChangeBy}->{UserLastname} . ')',
        },
    ];

    my $Rows = @{$TableLeft};
    if ( @{$TableRight} > $Rows ) {
        $Rows = @{$TableRight};
    }

    my %TableParam;
    for my $Row ( 1 .. $Rows ) {
        $Row--;
        $TableParam{CellData}[$Row][0]{Content}         = $TableLeft->[$Row]->{Key};
        $TableParam{CellData}[$Row][0]{Font}            = 'ProportionalBold';
        $TableParam{CellData}[$Row][1]{Content}         = $TableLeft->[$Row]->{Value};
        $TableParam{CellData}[$Row][2]{Content}         = ' ';
        $TableParam{CellData}[$Row][2]{BackgroundColor} = '#FFFFFF';
        $TableParam{CellData}[$Row][3]{Content}         = $TableRight->[$Row]->{Key};
        $TableParam{CellData}[$Row][3]{Font}            = 'ProportionalBold';
        $TableParam{CellData}[$Row][4]{Content}         = $TableRight->[$Row]->{Value};
    }
    $TableParam{ColumnData}[0]{Width} = 50;
    $TableParam{ColumnData}[1]{Width} = 200.5;
    $TableParam{ColumnData}[2]{Width} = 4;
    $TableParam{ColumnData}[3]{Width} = 80;
    $TableParam{ColumnData}[4]{Width} = 170.5;
    $TableParam{Type}                 = 'Cut';
    $TableParam{Border}               = 0;
    $TableParam{FontSize}             = 6;
    $TableParam{BackgroundColorEven}  = '#AAAAAA';
    $TableParam{BackgroundColorOdd}   = '#DDDDDD';
    $TableParam{Padding}              = 1;
    $TableParam{PaddingTop}           = 3;
    $TableParam{PaddingBottom}        = 3;

    # output table
    PAGE:
    for ( $Param{Page}->{PageCount} .. $Param{Page}->{MaxPages} ) {

        # output table (or a fragment of it)
        %TableParam = $Self->{PDFObject}->Table(%TableParam);

        # stop output or output next page
        last PAGE if $TableParam{State};

        $Self->{PDFObject}->PageNew(
            %{ $Param{Page} },
            FooterRight => $Param{Page}->{PageText} . ' ' . $Param{Page}->{PageCount}
        );
        $Param{Page}->{PageCount}++;
    }
    return 1;
}

sub _PDFOutputDetailedInfos {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Page SLA)) {
        if ( !defined $Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!"
            );
            return;
        }
    }

    # set new position
    $Self->{PDFObject}->PositionSet(
        Move => 'relativ',
        Y    => -15,
    );

    # output headline
    $Self->{PDFObject}->Text(
        Text     => $Self->{LayoutObject}->{LanguageObject}->Get('SLA'),
        Height   => 7,
        Type     => 'Cut',
        Font     => 'ProportionalBoldItalic',
        FontSize => 7,
        Color    => '#666666',
    );

    # set new position
    $Self->{PDFObject}->PositionSet(
        Move => 'relativ',
        Y    => -4,
    );

    # create table
    my $Table = [
        {
            Key   => $Self->{LayoutObject}->{LanguageObject}->Get('SLA') . ':',
            Value => $Param{SLA}->{Name},
        },
        {
            Key   => $Self->{LayoutObject}->{LanguageObject}->Get('Type') . ':',
            Value => $Self->{LayoutObject}->{LanguageObject}->Get( $Param{SLA}->{Type} ),
        },
        {
            Key   => $Self->{LayoutObject}->{LanguageObject}->Get('Calendar') . ':',
            Value => $Self->{LayoutObject}->{LanguageObject}->Get( $Param{SLA}->{CalendarName} ),
        },
        {
            Key => $Self->{LayoutObject}->{LanguageObject}->Get('First Response Time') . ':',
            Value =>
                $Self->{LayoutObject}->{LanguageObject}->Get( $Param{SLA}->{FirstResponseTime} )
                . ' '
                . $Self->{LayoutObject}->{LanguageObject}->Get('minutes'),
        },
        {
            Key   => $Self->{LayoutObject}->{LanguageObject}->Get('Update Time') . ':',
            Value => $Self->{LayoutObject}->{LanguageObject}->Get( $Param{SLA}->{UpdateTime} ) . ' '
                . $Self->{LayoutObject}->{LanguageObject}->Get('minutes'),
        },
        {
            Key   => $Self->{LayoutObject}->{LanguageObject}->Get('Solution Time') . ':',
            Value => $Self->{LayoutObject}->{LanguageObject}->Get( $Param{SLA}->{SolutionTime} )
                . ' '
                . $Self->{LayoutObject}->{LanguageObject}->Get('minutes'),
        },
        {
            Key => $Self->{LayoutObject}->{LanguageObject}->Get('Minimum Time Between Incidents')
                . ':',
            Value => $Self->{LayoutObject}->{LanguageObject}->Get(
                $Param{SLA}->{MinTimeBetweenIncidents},
                )
                . ' '
                . $Self->{LayoutObject}->{LanguageObject}->Get('minutes'),
        },
    ];
    my %TableParam;
    my $Rows = @{$Table};
    for my $Row ( 1 .. $Rows ) {
        $Row--;
        $TableParam{CellData}[$Row][0]{Content} = $Table->[$Row]->{Key};
        $TableParam{CellData}[$Row][0]{Font}    = 'ProportionalBold';
        $TableParam{CellData}[$Row][1]{Content} = $Table->[$Row]->{Value};
    }
    $TableParam{ColumnData}[0]{Width} = 120;
    $TableParam{ColumnData}[1]{Width} = 391;
    $TableParam{Type}                 = 'Cut';
    $TableParam{Border}               = 0;
    $TableParam{FontSize}             = 6;
    $TableParam{BackgroundColor}      = '#DDDDDD';
    $TableParam{Padding}              = 1;
    $TableParam{PaddingTop}           = 3;
    $TableParam{PaddingBottom}        = 3;

    # output table
    PAGE:
    for ( $Param{Page}->{PageCount} .. $Param{Page}->{MaxPages} ) {

        # output table (or a fragment of it)
        %TableParam = $Self->{PDFObject}->Table(%TableParam);

        # stop output or output next page
        last PAGE if $TableParam{State};

        $Self->{PDFObject}->PageNew(
            %{ $Param{Page} },
            FooterRight => $Param{Page}->{PageText} . ' ' . $Param{Page}->{PageCount}
        );
        $Param{Page}->{PageCount}++;
    }
    return 1;
}

1;
