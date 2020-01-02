# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AgentFAQPrint;

use strict;
use warnings;

use Kernel::Language qw(Translatable);
use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # Permission check.
    if ( !$Self->{AccessRo} ) {
        return $LayoutObject->NoPermission(
            Message    => Translatable('You need ro permission!'),
            WithHeader => 'yes',
        );
    }

    my $Output;

    # Get parameters from web request.
    my %GetParam;
    $GetParam{ItemID} = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'ItemID' );

    if ( !$GetParam{ItemID} ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('No ItemID is given!'),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    my $FAQObject = $Kernel::OM->Get('Kernel::System::FAQ');

    my %FAQData = $FAQObject->FAQGet(
        ItemID     => $GetParam{ItemID},
        ItemFields => 1,
        UserID     => $Self->{UserID},
    );
    if ( !%FAQData ) {
        return $LayoutObject->ErrorScreen();
    }

    # Check user permission.
    my $Permission = $FAQObject->CheckCategoryUserPermission(
        UserID     => $Self->{UserID},
        CategoryID => $FAQData{CategoryID},
        Type       => 'ro',
    );
    if ( !$Permission ) {
        return $LayoutObject->NoPermission(
            Message    => Translatable('You have no permission for this category!'),
            WithHeader => 'yes',
        );
    }

    my $LinkObject = $Kernel::OM->Get('Kernel::System::LinkObject');

    # Get linked objects.
    my $LinkListWithData = $LinkObject->LinkListWithData(
        Object => 'FAQ',
        Key    => $GetParam{ItemID},
        State  => 'Valid',
        UserID => $Self->{UserID},
    );

    # Get link type list.
    my %LinkTypeList = $LinkObject->TypeList(
        UserID => $Self->{UserID},
    );

    # Get the link data.
    my %LinkData;
    if ( $LinkListWithData && ref $LinkListWithData eq 'HASH' && %{$LinkListWithData} ) {
        %LinkData = $LayoutObject->LinkObjectTableCreate(
            LinkListWithData => $LinkListWithData,
            ViewMode         => 'SimpleRaw',
        );
    }

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # Prepare fields data.
    FIELD:
    for my $Field (qw(Field1 Field2 Field3 Field4 Field5 Field6)) {
        next FIELD if !$FAQData{$Field};

        # No quoting if HTML view is enabled.
        next FIELD if $ConfigObject->Get('FAQ::Item::HTML');

        # HTML quoting.
        $FAQData{$Field} = $LayoutObject->Ascii2Html(
            NewLine        => 0,
            Text           => $FAQData{$Field},
            VMax           => 5000,
            HTMLResultMode => 1,
            LinkFeature    => 1,
        );
    }

    my $UserObject = $Kernel::OM->Get('Kernel::System::User');

    # Get user info (CreatedBy).
    my %UserInfo = $UserObject->GetUserData(
        UserID => $FAQData{CreatedBy}
    );
    $Param{CreatedByLogin} = $UserInfo{UserLogin};

    # Get user info (ChangedBy).
    %UserInfo = $UserObject->GetUserData(
        UserID => $FAQData{ChangedBy}
    );
    $Param{ChangedByLogin} = $UserInfo{UserLogin};

    my $PDFObject = $Kernel::OM->Get('Kernel::System::PDF');

    # Generate PDF output.
    my $PrintedBy = $LayoutObject->{LanguageObject}->Translate('printed by');
    my $Time      = $LayoutObject->{Time};
    my %Page;

    # Get maximum number of pages.
    $Page{MaxPages} = $ConfigObject->Get('PDF::MaxPages');
    if ( !$Page{MaxPages} || $Page{MaxPages} < 1 || $Page{MaxPages} > 1000 ) {
        $Page{MaxPages} = 100;
    }
    my $HeaderRight  = $ConfigObject->Get('FAQ::FAQHook') . $FAQData{Number};
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
    $Page{FooterLeft}   = '';
    $Page{PageText}     = $LayoutObject->{LanguageObject}->Translate('Page');
    $Page{PageCount}    = 1;

    # Create new PDF document.
    $PDFObject->DocumentNew(
        Title  => $ConfigObject->Get('Product') . ': ' . $Title,
        Encode => $LayoutObject->{UserCharset},
    );

    # Create first PDF page.
    $PDFObject->PageNew(
        %Page,
        FooterRight => $Page{PageText} . ' ' . $Page{PageCount},
    );
    $Page{PageCount}++;

    $PDFObject->PositionSet(
        Move => 'relativ',
        Y    => -6,
    );

    # Output title.
    $PDFObject->Text(
        Text     => $FAQData{Title},
        FontSize => 13,
    );

    $PDFObject->PositionSet(
        Move => 'relativ',
        Y    => -6,
    );

    # Output "printed by".
    $PDFObject->Text(
        Text => $PrintedBy . ' '
            . $Self->{UserFullname} . ' ('
            . $Self->{UserEmail} . ')'
            . ', ' . $Time,
        FontSize => 9,
    );

    $PDFObject->PositionSet(
        Move => 'relativ',
        Y    => -14,
    );

    # Output FAQ information.
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

    # Output FAQ dynamic fields.
    $Self->_PDFOutputFAQDynamicFields(
        PageData => \%Page,
        FAQData  => \%FAQData,
    );

    $Self->_PDFOuputFAQContent(
        PageData => \%Page,
        FAQData  => \%FAQData,
    );

    # Output linked objects.
    if (%LinkData) {
        $Self->_PDFOutputLinkedObjects(
            PageData     => \%Page,
            LinkData     => \%LinkData,
            LinkTypeList => \%LinkTypeList,
        );
    }

    # Return the PDF document.
    my $Filename = 'FAQ_' . $FAQData{Number};

    my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
    my $DateTime       = $DateTimeObject->Get();
    my $Y              = $DateTime->{Year};
    my $M              = sprintf( "%02d", $DateTime->{Month} );
    my $D              = sprintf( "%02d", $DateTime->{Day} );
    my $h              = sprintf( "%02d", $DateTime->{Hour} );
    my $m              = sprintf( "%02d", $DateTime->{Minute} );

    my $PDFString = $PDFObject->DocumentOutput();
    return $LayoutObject->Attachment(
        Filename    => $Filename . "_" . "$Y-$M-$D" . "_" . "$h-$m.pdf",
        ContentType => "application/pdf",
        Content     => $PDFString,
        Type        => 'inline',
    );

}

sub _PDFOutputFAQHeaderInfo {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(PageData FAQData)) {
        if ( !defined( $Param{$Needed} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }
    my %FAQData = %{ $Param{FAQData} };
    my %Page    = %{ $Param{PageData} };

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # Create left table.
    my $TableLeft = [
        {
            Key   => $LayoutObject->{LanguageObject}->Translate('Category') . ':',
            Value => $LayoutObject->{LanguageObject}->Translate( $FAQData{CategoryName} ),
        },
        {
            Key   => $LayoutObject->{LanguageObject}->Translate('State') . ':',
            Value => $LayoutObject->{LanguageObject}->Translate( $FAQData{State} ),
        },
    ];

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # Language row, feature is enabled.
    my $MultiLanguage = $ConfigObject->Get('FAQ::MultiLanguage');
    if ($MultiLanguage) {
        my $Row = {
            Key   => $LayoutObject->{LanguageObject}->Translate('Language') . ':',
            Value => $LayoutObject->{LanguageObject}->Translate( $FAQData{Language} ),
        };
        push @{$TableLeft}, $Row;
    }

    # Approval state row, feature is enabled.
    if ( $ConfigObject->Get('FAQ::ApprovalRequired') ) {
        $FAQData{Approval} = $FAQData{Approved} ? 'Yes' : 'No';
        my $Row = {
            Key   => $LayoutObject->{LanguageObject}->Translate('Approval') . ':',
            Value => $LayoutObject->{LanguageObject}->Translate( $FAQData{Approval} ),
        };
        push @{$TableLeft}, $Row;
    }

    # Create right table.
    my $TableRight;

    my $Voting = $ConfigObject->Get('FAQ::Voting');

    # Voting rows, feature is enabled.
    if ($Voting) {
        $TableRight = [
            {
                Key   => $LayoutObject->{LanguageObject}->Translate('Votes') . ':',
                Value => $FAQData{Votes},
            },
            {
                Key   => $LayoutObject->{LanguageObject}->Translate('Result') . ':',
                Value => $FAQData{VoteResult} . " %",
            },
        ];
    }

    # Last update row.
    push @{$TableRight}, {
        Key   => $LayoutObject->{LanguageObject}->Translate('Last update') . ':',
        Value => $LayoutObject->{LanguageObject}->FormatTimeString(
            $FAQData{Changed},
            'DateFormatLong',
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
    $TableParam{BackgroundColorEven} = '#DDDDDD';
    $TableParam{Padding}             = 1;
    $TableParam{PaddingTop}          = 3;
    $TableParam{PaddingBottom}       = 3;

    # Output table.
    PAGE:
    for ( $Page{PageCount} .. $Page{MaxPages} ) {

        my $PDFObject = $Kernel::OM->Get('Kernel::System::PDF');

        # Output table (or a fragment of it).
        %TableParam = $PDFObject->Table( %TableParam, );

        # Stop output or output next page.
        if ( $TableParam{State} ) {
            last PAGE;
        }
        else {
            $PDFObject->PageNew(
                %Page,
                FooterRight => $Page{PageText} . ' ' . $Page{PageCount},
            );
            $Page{PageCount}++;
        }
    }
    return 1;
}

sub _PDFOutputLinkedObjects {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(PageData LinkData LinkTypeList)) {
        if ( !defined( $Param{$Needed} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my %Page     = %{ $Param{PageData} };
    my %TypeList = %{ $Param{LinkTypeList} };
    my %TableParam;
    my $Row = 0;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    for my $LinkTypeLinkDirection ( sort { lc $a cmp lc $b } keys %{ $Param{LinkData} } ) {

        # Investigate link type name.
        my @LinkData     = split q{::}, $LinkTypeLinkDirection;
        my $LinkTypeName = $TypeList{ $LinkData[0] }->{ $LinkData[1] . 'Name' };
        $LinkTypeName = $LayoutObject->{LanguageObject}->Translate($LinkTypeName);

        # Define headline.
        $TableParam{CellData}[$Row][0]{Content} = $LinkTypeName . ':';
        $TableParam{CellData}[$Row][0]{Font}    = 'ProportionalBold';
        $TableParam{CellData}[$Row][1]{Content} = '';

        # Extract object list.
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

    my $PDFObject = $Kernel::OM->Get('Kernel::System::PDF');

    # Set new position.
    $PDFObject->PositionSet(
        Move => 'relativ',
        Y    => -15,
    );

    # Output headline.
    $PDFObject->Text(
        Text     => $LayoutObject->{LanguageObject}->Translate('Linked Objects'),
        Height   => 7,
        Type     => 'Cut',
        Font     => 'ProportionalBoldItalic',
        FontSize => 7,
        Color    => '#666666',
    );

    # Set new position.
    $PDFObject->PositionSet(
        Move => 'relativ',
        Y    => -4,
    );

    # Table params.
    $TableParam{Type}            = 'Cut';
    $TableParam{Border}          = 0;
    $TableParam{FontSize}        = 6;
    $TableParam{BackgroundColor} = '#DDDDDD';
    $TableParam{Padding}         = 1;
    $TableParam{PaddingTop}      = 3;
    $TableParam{PaddingBottom}   = 3;

    # Output table.
    PAGE:
    for ( $Page{PageCount} .. $Page{MaxPages} ) {

        # Output table (or a fragment of it).
        %TableParam = $PDFObject->Table( %TableParam, );

        # Stop output or output next page.
        if ( $TableParam{State} ) {
            last PAGE;
        }
        else {
            $PDFObject->PageNew(
                %Page,
                FooterRight => $Page{PageText} . ' ' . $Page{PageCount},
            );
            $Page{PageCount}++;
        }
    }
    return 1;
}

sub _PDFOutputKeywords {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(PageData FAQData)) {
        if ( !defined( $Param{$Needed} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }
    my %FAQData = %{ $Param{FAQData} };
    my %Page    = %{ $Param{PageData} };
    my %TableParam;

    $TableParam{CellData}[0][0]{Content} = $FAQData{Keywords} || '';
    $TableParam{ColumnData}[0]{Width} = 511;

    my $PDFObject = $Kernel::OM->Get('Kernel::System::PDF');

    # Set new position.
    $PDFObject->PositionSet(
        Move => 'relativ',
        Y    => -15,
    );

    # Output headline.
    $PDFObject->Text(
        Text     => $Kernel::OM->Get('Kernel::Output::HTML::Layout')->{LanguageObject}->Translate('Keywords'),
        Height   => 7,
        Type     => 'Cut',
        Font     => 'ProportionalBoldItalic',
        FontSize => 7,
        Color    => '#666666',
    );

    # Set new position.
    $PDFObject->PositionSet(
        Move => 'relativ',
        Y    => -4,
    );

    # Table params.
    $TableParam{Type}            = 'Cut';
    $TableParam{Border}          = 0;
    $TableParam{FontSize}        = 6;
    $TableParam{BackgroundColor} = '#DDDDDD';
    $TableParam{Padding}         = 1;
    $TableParam{PaddingTop}      = 3;
    $TableParam{PaddingBottom}   = 3;

    # Output table.
    PAGE:
    for ( $Page{PageCount} .. $Page{MaxPages} ) {

        # Output table (or a fragment of it).
        %TableParam = $PDFObject->Table( %TableParam, );

        # Stop output or output next page.
        if ( $TableParam{State} ) {
            last PAGE;
        }
        else {
            $PDFObject->PageNew(
                %Page,
                FooterRight => $Page{PageText} . ' ' . $Page{PageCount},
            );
            $Page{PageCount}++;
        }
    }
    return 1;
}

sub _PDFOutputFAQDynamicFields {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(PageData FAQData)) {
        if ( !defined( $Param{$Needed} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }
    my $Output = 0;
    my %FAQ    = %{ $Param{FAQData} };
    my %Page   = %{ $Param{PageData} };

    my %TableParam;
    my $Row = 0;

    # Get dynamic field config for frontend module.
    my $DynamicFieldFilter = $Kernel::OM->Get('Kernel::Config')->Get("FAQ::Frontend::AgentFAQPrint")->{DynamicField};

    # Get the dynamic fields for FAQ object.
    my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => ['FAQ'],
        FieldFilter => $DynamicFieldFilter || {},
    );

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # Generate table.
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{$DynamicField} ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

        my $Value = $DynamicFieldBackendObject->ValueGet(
            DynamicFieldConfig => $DynamicFieldConfig,
            ObjectID           => $FAQ{FAQID},
        );

        next DYNAMICFIELD if !$Value;
        next DYNAMICFIELD if $Value eq "";

        # Get print string for this dynamic field.
        my $ValueStrg = $DynamicFieldBackendObject->DisplayValueRender(
            DynamicFieldConfig => $DynamicFieldConfig,
            Value              => $Value,
            HTMLOutput         => 0,
            LayoutObject       => $LayoutObject,
        );

        $TableParam{CellData}[$Row][0]{Content}
            = $LayoutObject->{LanguageObject}->Translate( $DynamicFieldConfig->{Label} )
            . ':';
        $TableParam{CellData}[$Row][0]{Font}    = 'ProportionalBold';
        $TableParam{CellData}[$Row][1]{Content} = $ValueStrg->{Value};

        $Row++;
        $Output = 1;
    }

    $TableParam{ColumnData}[0]{Width} = 80;
    $TableParam{ColumnData}[1]{Width} = 431;

    my $PDFObject = $Kernel::OM->Get('Kernel::System::PDF');

    # Output FAQ dynamic fields.
    if ($Output) {

        # Set new position.
        $PDFObject->PositionSet(
            Move => 'relativ',
            Y    => -15,
        );

        # Output headline,
        $PDFObject->Text(
            Text     => $LayoutObject->{LanguageObject}->Translate('FAQ Dynamic Fields'),
            Height   => 7,
            Type     => 'Cut',
            Font     => 'ProportionalBoldItalic',
            FontSize => 7,
            Color    => '#666666',
        );

        # Set new position.
        $PDFObject->PositionSet(
            Move => 'relativ',
            Y    => -4,
        );

        # Table params.
        $TableParam{Type}            = 'Cut';
        $TableParam{Border}          = 0;
        $TableParam{FontSize}        = 6;
        $TableParam{BackgroundColor} = '#DDDDDD';
        $TableParam{Padding}         = 1;
        $TableParam{PaddingTop}      = 3;
        $TableParam{PaddingBottom}   = 3;

        # Output table.
        PAGE:
        for ( $Page{PageCount} .. $Page{MaxPages} ) {

            # Output table (or a fragment of it).
            %TableParam = $PDFObject->Table( %TableParam, );

            # Stop output or output next page.
            if ( $TableParam{State} ) {
                last PAGE;
            }
            else {
                $PDFObject->PageNew(
                    %Page,
                    FooterRight => $Page{PageText} . ' ' . $Page{PageCount},
                );
                $Page{PageCount}++;
            }
        }
    }
    return 1;
}

sub _PDFOuputFAQContent {
    my ( $Self, %Param ) = @_;

    for my $ParamName (qw(PageData FAQData)) {
        if ( !$Param{$ParamName} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $ParamName!",
            );
            return;
        }
    }

    my %FAQData = %{ $Param{FAQData} };
    my %Page    = %{ $Param{PageData} };

    # Get the config of FAQ fields that should be shown.
    my %Fields;
    FIELD:
    for my $Number ( 1 .. 6 ) {

        # Get config of FAQ field.
        my $Config = $Kernel::OM->Get('Kernel::Config')->Get( 'FAQ::Item::Field' . $Number );

        # Skip over not shown fields.
        next FIELD if !$Config->{Show};

        # Store only the config of fields that should be shown.
        $Fields{ "Field" . $Number } = $Config;
    }

    # Sort shown fields by priority.
    FIELD:
    for my $Field ( sort { $Fields{$a}->{Prio} <=> $Fields{$b}->{Prio} } keys %Fields ) {

        # Get the state type data of this field.
        my $StateTypeData = $Kernel::OM->Get('Kernel::System::FAQ')->StateTypeGet(
            Name   => $Fields{$Field}->{Show},
            UserID => $Self->{UserID},
        );

        my %TableParam;

        # Convert HTML to ASCII.
        my $AsciiField = $Kernel::OM->Get('Kernel::System::HTMLUtils')->ToAscii(
            String => $FAQData{$Field},
        );

        $TableParam{CellData}[0][0]{Content} = $AsciiField || '';
        $TableParam{ColumnData}[0]{Width} = 511;

        my $PDFObject = $Kernel::OM->Get('Kernel::System::PDF');

        # Set new position.
        $PDFObject->PositionSet(
            Move => 'relativ',
            Y    => -15,
        );

        my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

        # Translate the field name and state.
        my $FieldName = $LayoutObject->{LanguageObject}->Translate( $Fields{$Field}->{'Caption'} )
            . ' ('
            . $LayoutObject->{LanguageObject}->Translate( $StateTypeData->{Name} )
            . ')';

        # Output headline.
        $PDFObject->Text(
            Text     => $FieldName,
            Height   => 7,
            Type     => 'Cut',
            Font     => 'ProportionalBoldItalic',
            FontSize => 7,
            Color    => '#666666',
        );

        # Set new position.
        $PDFObject->PositionSet(
            Move => 'relativ',
            Y    => -4,
        );

        # Table params.
        $TableParam{Type}            = 'Cut';
        $TableParam{Border}          = 0;
        $TableParam{FontSize}        = 6;
        $TableParam{BackgroundColor} = '#DDDDDD';
        $TableParam{Padding}         = 1;
        $TableParam{PaddingTop}      = 3;
        $TableParam{PaddingBottom}   = 3;

        # Output table.
        PAGE:
        for ( $Page{PageCount} .. $Page{MaxPages} ) {

            # Output table (or a fragment of it).
            %TableParam = $PDFObject->Table( %TableParam, );

            # Stop output or output next page.
            if ( $TableParam{State} ) {
                last PAGE;
            }
            else {
                $PDFObject->PageNew(
                    %Page,
                    FooterRight => $Page{PageText} . ' ' . $Page{PageCount},
                );
                $Page{PageCount}++;
            }
        }
    }
    return 1;
}

1;
