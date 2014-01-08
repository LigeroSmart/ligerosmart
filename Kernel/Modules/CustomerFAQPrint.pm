# --
# Kernel/Modules/CustomerFAQPrint.pm - print layout for agent interface
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::CustomerFAQPrint;

use strict;
use warnings;

use Kernel::System::HTMLUtils;
use Kernel::System::PDF;
use Kernel::System::FAQ;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (
        qw(ParamObject DBObject LayoutObject LogObject ConfigObject MainObject)
        )
    {
        if ( !$Self->{$Needed} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Needed!" );
        }
    }

    # create aditional objects
    $Self->{HTMLUtilsObject} = Kernel::System::HTMLUtils->new(%Param);
    $Self->{PDFObject}       = Kernel::System::PDF->new(%Param);
    $Self->{FAQObject}       = Kernel::System::FAQ->new(%Param);

    # set default interface settings
    $Self->{Interface} = $Self->{FAQObject}->StateTypeGet(
        Name   => 'external',
        UserID => $Self->{UserID},
    );
    $Self->{InterfaceStates} = $Self->{FAQObject}->StateTypeList(
        Types  => $Self->{ConfigObject}->Get('FAQ::Customer::StateTypes'),
        UserID => $Self->{UserID},
    );

    # get default options
    $Self->{MultiLanguage} = $Self->{ConfigObject}->Get('FAQ::MultiLanguage');
    $Self->{Voting}        = $Self->{ConfigObject}->Get('FAQ::Voting');

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # permission check
    if ( !$Self->{AccessRo} ) {
        return $Self->{LayoutObject}->NoPermission(
            Message    => 'You need ro permission!',
            WithHeader => 'yes',
        );
    }

    my $Output;

    # get params
    my %GetParam;
    $GetParam{ItemID} = $Self->{ParamObject}->GetParam( Param => 'ItemID' );

    # check needed stuff
    if ( !$GetParam{ItemID} ) {
        return $Self->{LayoutObject}->CustomerFatalError(
            Message => 'No ItemID is given!',
            Comment => 'Please contact the admin.',
        );
    }

    # get FAQ item data
    my %FAQData = $Self->{FAQObject}->FAQGet(
        ItemID     => $GetParam{ItemID},
        ItemFields => 1,
        UserID     => $Self->{UserID},
    );
    if ( !%FAQData ) {
        return $Self->{LayoutObject}->CustomerFatalError();
    }

    # check user permission
    my $Permission = $Self->{FAQObject}->CheckCategoryCustomerPermission(
        CustomerUser => $Self->{UserLogin},
        CategoryID   => $FAQData{CategoryID},
        UserID       => $Self->{UserID},
    );

    # show no permission error
    if (
        !$Permission
        || !$FAQData{Approved}
        || !$Self->{InterfaceStates}->{ $FAQData{StateTypeID} }
        )
    {
        return $Self->{LayoutObject}->CustomerNoPermission( WithHeader => 'yes' );
    }

    # prepare fields data
    FIELD:
    for my $Field (qw(Field1 Field2 Field3 Field4 Field5 Field6)) {
        next FIELD if !$FAQData{$Field};

        # rewrite links to embedded images for customer and public interface
        if ( $Self->{Interface}{Name} eq 'external' ) {
            $FAQData{$Field}
                =~ s{ index[.]pl [?] Action=AgentFAQZoom }{customer.pl?Action=CustomerFAQZoom}gxms;
        }

        # no quoting if html view is enabled
        next FIELD if $Self->{ConfigObject}->Get('FAQ::Item::HTML');

        # html quoting
        $FAQData{$Field} = $Self->{LayoutObject}->Ascii2Html(
            NewLine        => 0,
            Text           => $FAQData{$Field},
            VMax           => 5000,
            HTMLResultMode => 1,
            LinkFeature    => 1,
        );
    }

    # generate pdf output
    if ( $Self->{PDFObject} ) {
        my $PrintedBy = $Self->{LayoutObject}->{LanguageObject}->Get('printed by');
        my $Time      = $Self->{LayoutObject}->Output( Template => '$Env{"Time"}' );
        my $Url       = ' ';
        if ( $ENV{REQUEST_URI} ) {
            $Url = $Self->{ConfigObject}->Get('HttpType') . '://'
                . $Self->{ConfigObject}->Get('FQDN')
                . $ENV{REQUEST_URI};
        }
        my %Page;

        # get maximum number of pages
        $Page{MaxPages} = $Self->{ConfigObject}->Get('PDF::MaxPages');
        if ( !$Page{MaxPages} || $Page{MaxPages} < 1 || $Page{MaxPages} > 1000 ) {
            $Page{MaxPages} = 100;
        }
        my $HeaderRight  = $Self->{ConfigObject}->Get('FAQ::FAQHook') . $FAQData{Number};
        my $HeadlineLeft = $HeaderRight;
        my $Title        = $HeaderRight;
        if ( $FAQData{Title} ) {
            $HeadlineLeft = $FAQData{Title};
            $Title .= ' / ' . $FAQData{Title};
        }

        $Page{MarginTop}    = 30;
        $Page{MarginRight}  = 40;
        $Page{MarginBottom} = 40;
        $Page{MarginLeft}   = 40;
        $Page{HeaderRight}  = $HeaderRight;
        $Page{HeadlineLeft} = $HeadlineLeft;
        $Page{HeadlineRight}
            = $PrintedBy . ' '
            . $Self->{UserFirstname} . ' '
            . $Self->{UserLastname} . ' ('
            . $Self->{UserEmail} . ') '
            . $Time;
        $Page{FooterLeft} = $Url;
        $Page{PageText}   = $Self->{LayoutObject}->{LanguageObject}->Get('Page');
        $Page{PageCount}  = 1;

        # create new pdf document
        $Self->{PDFObject}->DocumentNew(
            Title  => $Self->{ConfigObject}->Get('Product') . ': ' . $Title,
            Encode => $Self->{LayoutObject}->{UserCharset},
        );

        # create first pdf page
        $Self->{PDFObject}->PageNew(
            %Page, FooterRight => $Page{PageText} . ' ' . $Page{PageCount},
        );
        $Page{PageCount}++;

        # type of print tag
        my $PrintTag = $Self->{LayoutObject}->{LanguageObject}->Get('FAQ Article Print');

        # output headline
        $Self->{PDFObject}->Text(
            Text     => $PrintTag,
            Height   => 9,
            Type     => 'Cut',
            Font     => 'ProportionalBold',
            Align    => 'right',
            FontSize => 9,
            Color    => '#666666',
        );

        $Self->{PDFObject}->PositionSet(
            Move => 'relativ',
            Y    => -6,
        );

        # output faq information
        $Self->_PDFOutputFAQHeaderInfo(
            PageData => \%Page,
            FAQData  => \%FAQData,
        );

        if ( $FAQData{Keywords} ) {
            $Self->_PDFOutputKeywords(
                PageData => \%Page,
                FAQData  => \%FAQData,
            );
        }

        $Self->_PDFOuputFAQContent(
            PageData        => \%Page,
            FAQData         => \%FAQData,
            InterfaceStates => $Self->{InterfaceStates},
        );

        # return the pdf document
        my $Filename = 'FAQ_' . $FAQData{Number};
        my ( $s, $m, $h, $D, $M, $Y ) = $Self->{TimeObject}->SystemTime2Date(
            SystemTime => $Self->{TimeObject}->SystemTime(),
        );
        $M = sprintf( "%02d", $M );
        $D = sprintf( "%02d", $D );
        $h = sprintf( "%02d", $h );
        $m = sprintf( "%02d", $m );
        my $PDFString = $Self->{PDFObject}->DocumentOutput();
        return $Self->{LayoutObject}->Attachment(
            Filename    => $Filename . "_" . "$Y-$M-$D" . "_" . "$h-$m.pdf",
            ContentType => "application/pdf",
            Content     => $PDFString,
            Type        => 'attachment',
        );
    }

    # generate html output
    else {

        # output header
        $Output .= $Self->{LayoutObject}->PrintHeader( Value => $FAQData{Number} );

        # show FAQ Content
        $Self->{LayoutObject}->FAQContentShow(
            FAQObject       => $Self->{FAQObject},
            InterfaceStates => $Self->{InterfaceStates},
            FAQData         => {%FAQData},
            UserID          => $Self->{UserID},
        );

        # show faq
        $Output .= $Self->_HTMLMask(
            FAQID => $GetParam{FAQID},
            %Param,
            %FAQData,
        );

        # add footer
        $Output .= $Self->{LayoutObject}->PrintFooter();

        # return output
        return $Output;
    }
}

sub _PDFOutputFAQHeaderInfo {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(PageData FAQData)) {
        if ( !defined( $Param{$Needed} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }
    my %FAQData = %{ $Param{FAQData} };
    my %Page    = %{ $Param{PageData} };

    # create left table
    my $TableLeft = [
        {
            Key   => $Self->{LayoutObject}->{LanguageObject}->Get('Category') . ':',
            Value => $Self->{LayoutObject}->{LanguageObject}->Get( $FAQData{CategoryName} ),
        },
        {
            Key   => $Self->{LayoutObject}->{LanguageObject}->Get('State') . ':',
            Value => $Self->{LayoutObject}->{LanguageObject}->Get( $FAQData{State} ),
        },
    ];

    # language row, feature is enabled
    if ( $Self->{MultiLanguage} ) {
        my $Row = {
            Key   => $Self->{LayoutObject}->{LanguageObject}->Get('Language') . ':',
            Value => $Self->{LayoutObject}->{LanguageObject}->Get( $FAQData{Language} ),
        };
        push @{$TableLeft}, $Row;
    }

    # create right table
    my $TableRight;

    # voting rows, featre is enabled
    if ( $Self->{Voting} ) {
        $TableRight = [
            {
                Key   => $Self->{LayoutObject}->{LanguageObject}->Get('Votes') . ':',
                Value => $FAQData{Votes},
            },
            {
                Key   => $Self->{LayoutObject}->{LanguageObject}->Get('Result') . ':',
                Value => $FAQData{VoteResult} . " %",
            },
        ];
    }

    # last update row
    push @{$TableRight}, {
        Key   => $Self->{LayoutObject}->{LanguageObject}->Get('Last update') . ':',
        Value => $Self->{LayoutObject}->Output(
            Template => '$TimeLong{"$Data{"Changed"}"}',
            Data     => \%FAQData,
        ),
    };

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

    $TableParam{ColumnData}[0]{Width} = 80;
    $TableParam{ColumnData}[1]{Width} = 170.5;
    $TableParam{ColumnData}[2]{Width} = 4;
    $TableParam{ColumnData}[3]{Width} = 80;
    $TableParam{ColumnData}[4]{Width} = 170.5;

    $TableParam{Type}                = 'Cut';
    $TableParam{Border}              = 0;
    $TableParam{FontSize}            = 6;
    $TableParam{BackgroundColorEven} = '#AAAAAA';
    $TableParam{BackgroundColorOdd}  = '#DDDDDD';
    $TableParam{Padding}             = 1;
    $TableParam{PaddingTop}          = 3;
    $TableParam{PaddingBottom}       = 3;

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

sub _PDFOutputKeywords {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(PageData FAQData)) {
        if ( !defined( $Param{$Needed} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }
    my %FAQData = %{ $Param{FAQData} };
    my %Page    = %{ $Param{PageData} };
    my %TableParam;

    $TableParam{CellData}[0][0]{Content} = $FAQData{Keywords} || '';
    $TableParam{ColumnData}[0]{Width} = 511;

    # set new position
    $Self->{PDFObject}->PositionSet(
        Move => 'relativ',
        Y    => -15,
    );

    # output headline
    $Self->{PDFObject}->Text(
        Text     => $Self->{LayoutObject}->{LanguageObject}->Get('Keywords'),
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

sub _PDFOuputFAQContent {
    my ( $Self, %Param ) = @_;

    # check parameters
    for my $ParamName (qw(PageData FAQData)) {
        if ( !$Param{$ParamName} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $ParamName!",
            );
            return;
        }
    }

    my %FAQData = %{ $Param{FAQData} };
    my %Page    = %{ $Param{PageData} };

    # get the config of FAQ fields that should be shown
    my %Fields;
    FIELD:
    for my $Number ( 1 .. 6 ) {

        # get config of FAQ field
        my $Config = $Self->{ConfigObject}->Get( 'FAQ::Item::Field' . $Number );

        # skip over not shown fields
        next FIELD if !$Config->{Show};

        # store only the config of fields that should be shown
        $Fields{ "Field" . $Number } = $Config;
    }

    # sort shown fields by priority
    FIELD:
    for my $Field ( sort { $Fields{$a}->{Prio} <=> $Fields{$b}->{Prio} } keys %Fields ) {

        # get the state type data of this field
        my $StateTypeData = $Self->{FAQObject}->StateTypeGet(
            Name   => $Fields{$Field}->{Show},
            UserID => $Self->{UserID},
        );

        # do not show fields that are not allowed in the given interface
        next FIELD if !$Param{InterfaceStates}->{ $StateTypeData->{StateID} };

        my %TableParam;

        # convert HTML to ascii
        my $AsciiField = $Self->{HTMLUtilsObject}->ToAscii( String => $FAQData{$Field} );

        $TableParam{CellData}[0][0]{Content} = $AsciiField || '';
        $TableParam{ColumnData}[0]{Width} = 511;

        # set new position
        $Self->{PDFObject}->PositionSet(
            Move => 'relativ',
            Y    => -15,
        );

        # translate the field name and state
        my $FieldName = $Self->{LayoutObject}->{LanguageObject}->Get( $Fields{$Field}->{'Caption'} )
            . ' ('
            . $Self->{LayoutObject}->{LanguageObject}->Get( $StateTypeData->{Name} )
            . ')';

        # output headline
        $Self->{PDFObject}->Text(
            Text     => $FieldName,
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
    }
    return 1;
}

sub _HTMLMask {
    my ( $Self, %Param ) = @_;

    # show Language
    if ( $Self->{MultiLanguage} ) {
        $Self->{LayoutObject}->Block(
            Name => 'Language',
            Data => \%Param,
        );
    }

    # show rating
    if ( $Self->{Voting} ) {
        $Self->{LayoutObject}->Block(
            Name => 'Rating',
            Data => \%Param,
        );
    }

    return $Self->{LayoutObject}->Output(
        TemplateFile => 'CustomerFAQPrint',
        Data         => \%Param,
    );
}

1;
