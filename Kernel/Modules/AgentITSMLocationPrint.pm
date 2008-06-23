# --
# Kernel/Modules/AgentITSMLocationPrint.pm - print layout for itsm location agent interface
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AgentITSMLocationPrint.pm,v 1.2 2008-06-23 21:55:55 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::AgentITSMLocationPrint;

use strict;
use warnings;

use Kernel::System::GeneralCatalog;
use Kernel::System::ITSMLocation;
use Kernel::System::LinkObject;
use Kernel::System::PDF;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(ParamObject DBObject LayoutObject LogObject ConfigObject)) {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Object!" );
        }
    }
    $Self->{GeneralCatalogObject} = Kernel::System::GeneralCatalog->new(%Param);
    $Self->{LocationObject}       = Kernel::System::ITSMLocation->new(%Param);
    $Self->{LinkObject}           = Kernel::System::LinkObject->new(%Param);
    $Self->{PDFObject}            = Kernel::System::PDF->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get params
    my $LocationID = $Self->{ParamObject}->GetParam( Param => 'LocationID' );

    # check needed stuff
    if ( !$LocationID ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'No LocationID is given!',
            Comment => 'Please contact the admin.',
        );
    }

    # get location
    my %Location = $Self->{LocationObject}->LocationGet(
        LocationID => $LocationID,
        UserID     => $Self->{UserID},
    );
    if ( !$Location{LocationID} ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "LocationID $LocationID not found in database!",
            Comment => 'Please contact the admin.',
        );
    }

    # get location type list
    my $LocationTypeList = $Self->{GeneralCatalogObject}->ItemList(
        Class => 'ITSM::Location::Type',
    );
    $Location{Type} = $LocationTypeList->{ $Location{TypeID} };

    # get user data (create by)
    my %CreateBy = $Self->{UserObject}->GetUserData(
        UserID => $Location{CreateBy},
        Cached => 1,
    );

    # get user data (change by)
    my %ChangeBy = $Self->{UserObject}->GetUserData(
        UserID => $Location{ChangeBy},
        Cached => 1,
    );

    # get linked objects
    my $LinkListWithData = $Self->{LinkObject}->LinkListWithData(
        Object => 'ITSMLocation',
        Key    => $LocationID,
        State  => 'Valid',
        UserID => $Self->{UserID},
    );

    # get link type list
    my %LinkTypeList = $Self->{LinkObject}->TypeList(
        UserID => $Self->{UserID},
    );

    # get the link data
    my %LinkData;
    if ( $LinkListWithData && ref $LinkListWithData eq 'HASH' && %{$LinkListWithData} ) {
        %LinkData = $Self->{LayoutObject}->LinkObjectTableCreate(
            LinkListWithData => $LinkListWithData,
            ViewMode         => 'SimpleRaw',
        );
    }

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
        $Page{MarginTop}     = 30;
        $Page{MarginRight}   = 40;
        $Page{MarginBottom}  = 40;
        $Page{MarginLeft}    = 40;
        $Page{HeaderRight}   = $Self->{LayoutObject}->{LanguageObject}->Get('Location');
        $Page{HeadlineLeft}  = $Location{NameShort};
        $Page{HeadlineRight} = $Self->{LayoutObject}->{LanguageObject}->Get('printed by') . ' '
            . $Self->{UserFirstname} . ' '
            . $Self->{UserLastname} . ' ('
            . $Self->{UserEmail} . ') '
            . $Self->{LayoutObject}->Output( Template => '$Env{"Time"}' );
        $Page{FooterLeft} = $Url;
        $Page{PageText}   = $Self->{LayoutObject}->{LanguageObject}->Get('Page');
        $Page{PageCount}  = 1;

        # create new pdf document
        $Self->{PDFObject}->DocumentNew(
            Title  => $Self->{ConfigObject}->Get('Product') . ': ' . $Location{NameShort},
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
            Location => \%Location,
            CreateBy => \%CreateBy,
            ChangeBy => \%ChangeBy,
        );

        # output detailed infos
        $Self->_PDFOutputDetailedInfos(
            Page     => \%Page,
            Location => \%Location,
        );

        # output linked objects
        if (%LinkData) {
            $Self->_PDFOutputLinkedObjects(
                PageData     => \%Page,
                LinkData     => \%LinkData,
                LinkTypeList => \%LinkTypeList,
            );
        }

        # create file name
        my $Filename = $Self->{MainObject}->FilenameCleanUp(
            Filename => $Location{NameShort},
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
            Filename    => 'location_' . $Filename . "_$Y-$M-$D\_$h-$m.pdf",
            ContentType => 'application/pdf',
            Content     => $Self->{PDFObject}->DocumentOutput(),
            Type        => 'attachment',
        );
    }

    # generate html output
    else {

        # output header
        my $Output = $Self->{LayoutObject}->PrintHeader( Value => $Location{NameShort} );

        if (%LinkData) {

            # output link data
            $Self->{LayoutObject}->Block(
                Name => 'Link',
            );

            for my $LinkTypeLinkDirection ( sort { lc $a cmp lc $b } keys %LinkData ) {

                # investigate link type name
                my @LinkData = split q{::}, $LinkTypeLinkDirection;

                # output link type data
                $Self->{LayoutObject}->Block(
                    Name => 'LinkType',
                    Data => {
                        LinkTypeName => $LinkTypeList{ $LinkData[0] }->{ $LinkData[1] . 'Name' },
                    },
                );

                # extract object list
                my $ObjectList = $LinkData{$LinkTypeLinkDirection};

                for my $Object ( sort { lc $a cmp lc $b } keys %{$ObjectList} ) {

                    for my $Item ( @{ $ObjectList->{$Object} } ) {

                        # output link type data
                        $Self->{LayoutObject}->Block(
                            Name => 'LinkTypeRow',
                            Data => {
                                LinkStrg => $Item->{Title},
                            },
                        );
                    }
                }
            }
        }

        # transform location from ascii to html
        $Location{Address} = $Self->{LayoutObject}->Ascii2Html(
            Text           => $Location{Address},
            HTMLResultMode => 1,
            LinkFeature    => 1,
        );

        # generate output
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentITSMLocationPrint',
            Data         => {
                CreateByUserLogin     => $CreateBy{UserLogin},
                CreateByUserFirstname => $CreateBy{UserFirstname},
                CreateByUserLastname  => $CreateBy{UserLastname},
                ChangeByUserLogin     => $ChangeBy{UserLogin},
                ChangeByUserFirstname => $ChangeBy{UserFirstname},
                ChangeByUserLastname  => $ChangeBy{UserLastname},
                %Location,
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
    for my $Argument (qw(Page Location CreateBy ChangeBy)) {
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
            Key   => $Self->{LayoutObject}->{LanguageObject}->Get('Location') . ':',
            Value => $Param{Location}->{NameShort},
        },
    ];

    # create right table
    my $TableRight = [
        {
            Key   => $Self->{LayoutObject}->{LanguageObject}->Get('Created') . ':',
            Value => $Self->{LayoutObject}->Output(
                Template => '$TimeLong{"$Data{"CreateTime"}"}',
                Data     => \%{ $Param{Location} },
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
                Data     => \%{ $Param{Location} },
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
            FooterRight => $Param{Page}->{PageText} . ' ' . $Param{Page}->{PageCount},
        );
        $Param{Page}->{PageCount}++;
    }
    return 1;
}

sub _PDFOutputDetailedInfos {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Page Location)) {
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
        Text     => $Self->{LayoutObject}->{LanguageObject}->Get('Location'),
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
            Key   => $Self->{LayoutObject}->{LanguageObject}->Get('Location') . ':',
            Value => $Param{Location}->{Name},
        },
        {
            Key   => $Self->{LayoutObject}->{LanguageObject}->Get('Type') . ':',
            Value => $Self->{LayoutObject}->{LanguageObject}->Get( $Param{Location}->{Type} ),
        },
        {
            Key   => $Self->{LayoutObject}->{LanguageObject}->Get('Phone 1') . ':',
            Value => $Param{Location}->{Phone1},
        },
        {
            Key   => $Self->{LayoutObject}->{LanguageObject}->Get('Phone 2') . ':',
            Value => $Param{Location}->{Phone2},
        },
        {
            Key   => $Self->{LayoutObject}->{LanguageObject}->Get('Fax') . ':',
            Value => $Param{Location}->{Fax},
        },
        {
            Key   => $Self->{LayoutObject}->{LanguageObject}->Get('Email') . ':',
            Value => $Param{Location}->{Email},
        },
        {
            Key   => $Self->{LayoutObject}->{LanguageObject}->Get('Address') . ':',
            Value => $Param{Location}->{Address},
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
    $TableParam{ColumnData}[0]{Width} = 80;
    $TableParam{ColumnData}[1]{Width} = 431;
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

sub _PDFOutputLinkedObjects {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(PageData LinkData LinkTypeList)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my %Page     = %{ $Param{PageData} };
    my %TypeList = %{ $Param{LinkTypeList} };
    my %TableParam;
    my $Row = 0;

    for my $LinkTypeLinkDirection ( sort { lc $a cmp lc $b } keys %{ $Param{LinkData} } ) {

        # investigate link type name
        my @LinkData = split q{::}, $LinkTypeLinkDirection;
        my $LinkTypeName = $TypeList{ $LinkData[0] }->{ $LinkData[1] . 'Name' };
        $LinkTypeName = $Self->{LayoutObject}->{LanguageObject}->Get($LinkTypeName);

        # define headline
        $TableParam{CellData}[$Row][0]{Content} = $LinkTypeName . ':';
        $TableParam{CellData}[$Row][0]{Font}    = 'ProportionalBold';
        $TableParam{CellData}[$Row][1]{Content} = '';

        # extract object list
        my $ObjectList = $Param{LinkData}->{$LinkTypeLinkDirection};

        for my $Object ( sort { lc $a cmp lc $b } keys %{$ObjectList} ) {

            for my $Item ( @{ $ObjectList->{$Object} } ) {

                $TableParam{CellData}[$Row][0]{Content} ||= '';
                $TableParam{CellData}[$Row][1]{Content} = $Item->{Title} || '';
            }
            continue {
                $Row++;
            }
        }
    }

    $TableParam{ColumnData}[0]{Width} = 80;
    $TableParam{ColumnData}[1]{Width} = 431;

    # set new position
    $Self->{PDFObject}->PositionSet(
        Move => 'relativ',
        Y    => -15,
    );

    # output headline
    $Self->{PDFObject}->Text(
        Text     => $Self->{LayoutObject}->{LanguageObject}->Get('Linked Objects'),
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

    # table params
    $TableParam{Type}            = 'Cut';
    $TableParam{Border}          = 0;
    $TableParam{FontSize}        = 6;
    $TableParam{BackgroundColor} = '#DDDDDD';
    $TableParam{Padding}         = 1;
    $TableParam{PaddingTop}      = 3;
    $TableParam{PaddingBottom}   = 3;

    # output table
    for ( $Page{PageCount} .. $Page{MaxPages} ) {

        # output table (or a fragment of it)
        %TableParam = $Self->{PDFObject}->Table( %TableParam, );

        # stop output or output next page
        if ( $TableParam{State} ) {
            last;
        }
        else {
            $Self->{PDFObject}->PageNew(
                %Page, FooterRight => $Page{PageText} . ' ' . $Page{PageCount},
            );
            $Page{PageCount}++;
        }
    }

    return 1;
}

1;
