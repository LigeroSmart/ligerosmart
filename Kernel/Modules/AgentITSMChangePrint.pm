# --
# Kernel/Modules/AgentITSMChangePrint.pm - the OTRS::ITSM::ChangeManagement change print module
# Copyright (C) 2003-2010 OTRS AG, http://otrs.com/
# --
# $Id: AgentITSMChangePrint.pm,v 1.14 2010-01-28 15:29:47 bes Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMChangePrint;

use strict;
use warnings;

use List::Util qw(max);

use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::ITSMWorkOrder;
use Kernel::System::PDF;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.14 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (
        qw(ParamObject DBObject LayoutObject LogObject ConfigObject UserObject)
        )
    {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Object!" );
        }
    }

    # create additional objects
    $Self->{ChangeObject}       = Kernel::System::ITSMChange->new(%Param);
    $Self->{WorkOrderObject}    = Kernel::System::ITSMChange::ITSMWorkOrder->new(%Param);
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);
    $Self->{LinkObject}         = Kernel::System::LinkObject->new(%Param);
    $Self->{PDFObject}          = Kernel::System::PDF->new(%Param);

    # get config of frontend module
    $Self->{Config} = $Self->{ConfigObject}->Get("ITSMChange::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # Find out whether a change or a workorder should be printed.
    # A workorder is to be printed when the WorkOrderID is passed.
    # Otherwise a change should be printed
    my $WorkOrderID = $Self->{ParamObject}->GetParam( Param => 'WorkOrderID' );
    my $PrintWorkOrder = $WorkOrderID ? 1 : 0;
    my $PrintChange    = !$WorkOrderID;
    my $WorkOrder      = {};
    my $ChangeID;

    if ($PrintWorkOrder) {

        # check permission on the workorder
        my $Access = $Self->{WorkOrderObject}->Permission(
            Type        => $Self->{Config}->{Permission},
            WorkOrderID => $WorkOrderID,
            UserID      => $Self->{UserID},
        );

        # error screen
        if ( !$Access ) {
            return $Self->{LayoutObject}->NoPermission(
                Message    => "You need $Self->{Config}->{Permission} permissions!",
                WithHeader => 'yes',
            );
        }

        # get workorder information
        $WorkOrder = $Self->{WorkOrderObject}->WorkOrderGet(
            WorkOrderID => $WorkOrderID,
            UserID      => $Self->{UserID},
        );

        # check error
        if ( !$WorkOrder ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "WorkOrder '$WorkOrderID' not found in database!",
                Comment => 'Please contact the admin.',
            );
        }

        # infer the change id from the workorder
        $ChangeID = $WorkOrder->{ChangeID};

        if ( !$ChangeID ) {

            # error page
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Can't generate PDF, as the workorder is not attached to a change!",
                Comment => 'Please contact the admin.',
            );
        }
    }
    else {

        # the change id is required, as we have no workorder id
        $ChangeID = $Self->{ParamObject}->GetParam( Param => 'ChangeID' );

        if ( !$ChangeID ) {

            # error page
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Can't generate PDF, as no ChangeID is given!",
                Comment => 'Please contact the admin.',
            );
        }

        # check permission on the change
        my $Access = $Self->{ChangeObject}->Permission(
            Type     => $Self->{Config}->{Permission},
            ChangeID => $ChangeID,
            UserID   => $Self->{UserID},
        );

        # error screen
        if ( !$Access ) {
            return $Self->{LayoutObject}->NoPermission(
                Message    => "You need $Self->{Config}->{Permission} permissions!",
                WithHeader => 'yes',
            );
        }
    }

    # get change information
    my $Change = $Self->{ChangeObject}->ChangeGet(
        ChangeID => $ChangeID,
        UserID   => $Self->{UserID},
    );

    my $FullWorkOrderNumber = $PrintWorkOrder
        ?
        join( '-', $Change->{ChangeNumber}, $WorkOrder->{WorkOrderNumber} )
        :
        '';

    # check error
    if ( !$Change ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Change '$ChangeID' not found in database!",
            Comment => 'Please contact the admin.',
        );
    }

    # generate PDF output
    if ( $Self->{PDFObject} ) {
        my $PrintedBy = $Self->{LayoutObject}->{LanguageObject}->Get('printed by');
        my $Time = $Self->{LayoutObject}->Output( Template => '$Env{"Time"}' );
        my $Url
            = $Self->{ConfigObject}->Get('HttpType') . '://'
            . $Self->{ConfigObject}->Get('FQDN')
            . $Self->{LayoutObject}->{Baselink}
            . $Self->{RequestedURL};
        my %Page;

        # get maximum number of pages
        $Page{MaxPages} = $Self->{ConfigObject}->Get('PDF::MaxPages');
        if ( !$Page{MaxPages} || $Page{MaxPages} < 1 || $Page{MaxPages} > 1000 ) {
            $Page{MaxPages} = 100;
        }

        my $HeaderRight = $PrintChange
            ?
            $Self->{LayoutObject}->{LanguageObject}->Get('Change#') . $Change->{ChangeNumber}
            :
            $Self->{LayoutObject}->{LanguageObject}->Get('WorkOrderNumber#') . $FullWorkOrderNumber;
        my $HeadlineLeft = $HeaderRight;
        my $Title        = $HeaderRight;

        if ( $PrintChange && $Change->{ChangeTitle} ) {
            $HeadlineLeft = $Change->{ChangeTitle};
            $Title .= ' / ' . $Change->{ChangeTitle};
        }
        elsif ( $PrintWorkOrder && $WorkOrder->{WorkOrderTitle} ) {
            $HeadlineLeft = $WorkOrder->{WorkOrderTitle};
            $Title .= ' / ' . $WorkOrder->{WorkOrderTitle};
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

        # create new PDF document
        $Self->{PDFObject}->DocumentNew(
            Title  => $Self->{ConfigObject}->Get('Product') . ': ' . $Title,
            Encode => $Self->{LayoutObject}->{UserCharset},
        );

        # create first PDF page
        $Self->{PDFObject}->PageNew(
            %Page,
            FooterRight => $Page{PageText} . ' ' . $Page{PageCount},
        );
        $Page{PageCount}++;

        # output change infos in both cases,
        # %Page will be changed
        $Self->_PDFOutputChangeInfo(
            Page           => \%Page,
            Change         => $Change,
            PrintWorkOrder => $PrintWorkOrder,
        );

        if ($PrintChange) {

            # output change content infos
            $Self->_PDFOutputDescriptionAndJustification(
                Page   => \%Page,
                Change => $Change,
            );

            for my $WorkOrderID ( @{ $Change->{WorkOrderIDs} || [] } ) {

                # get workorder information
                my $WorkOrder = $Self->{WorkOrderObject}->WorkOrderGet(
                    WorkOrderID => $WorkOrderID,
                    UserID      => $Self->{UserID},
                );

                # check error
                if ( !$WorkOrder ) {
                    return $Self->{LayoutObject}->ErrorScreen(
                        Message => "WorkOrder '$WorkOrderID' not found in database!",
                        Comment => 'Please contact the admin.',
                    );
                }

                $Self->_PDFOutputWorkOrderInfo(
                    Page      => \%Page,
                    Change    => $Change,
                    WorkOrder => $WorkOrder,
                );
            }
        }

        if ($PrintWorkOrder) {

            $Self->_PDFOutputWorkOrderInfo(
                Page           => \%Page,
                Change         => $Change,
                WorkOrder      => $WorkOrder,
                PrintWorkOrder => 1,
            );
        }

        # return the PDF document
        my ( $s, $m, $h, $D, $M, $Y ) = $Self->{TimeObject}->SystemTime2Date(
            SystemTime => $Self->{TimeObject}->SystemTime(),
        );
        my $Filename = $PrintChange
            ?
            sprintf(
            'change_%s_%02d-%02d-%02d_%02d-%02d.pdf',
            $Change->{ChangeNumber}, $Y, $M, $D, $h, $m
            )
            :
            sprintf(
            'workorder_%s-%s_%02d-%02d-%02d_%02d-%02d.pdf',
            $Change->{ChangeNumber}, $WorkOrder->{WorkOrderNumber}, $Y, $M, $D, $h, $m
            );
        my $PDFString = $Self->{PDFObject}->DocumentOutput();

        return $Self->{LayoutObject}->Attachment(
            Filename    => $Filename,
            ContentType => 'application/pdf',
            Content     => $PDFString,
            Type        => 'attachment',
        );
    }

    # alternatively generate html output

    # output header
    my $Output = $Self->{LayoutObject}->PrintHeader(
        Value => 'AgentITSMChangePrint',
    );

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMChangePrint',
        Data         => {
            %Param,
            %{$Change},
            %{$WorkOrder},
        },
    );

    # add footer
    $Output .= $Self->{LayoutObject}->PrintFooter();

    # return output
    return $Output;
}

# a helper for preparing a table row for PDF generation
sub _PrepareAndAddInfoRow {

    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(RowSpec Data TranslationPrefix)) {
        if ( !defined( $Param{$Argument} ) ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }

    my ( $RowSpec, $Data, $TranslationPrefix ) = @Param{qw(RowSpec Data TranslationPrefix)};

    # short name, just for convenience
    my $Attribute = $RowSpec->{Attribute};

    # skip if row is switched off in SysConfig
    return if $RowSpec->{IsOptional} && !$Self->{Config}->{$Attribute};

    # keys are always translatable
    my $Key = $RowSpec->{Key} || "$TranslationPrefix$Attribute";
    $Key = $Self->{LayoutObject}->{LanguageObject}->Get($Key);

    # determine the value
    my $Value;
    if ( $RowSpec->{ValueIsTime} ) {

        # format the time value
        $Value = $Self->{LayoutObject}->Output(
            Template => qq(\$TimeLong{"\$Data{"$Attribute"}"}),
            Data     => $Data,
        );
    }
    elsif ( $RowSpec->{ValueIsUser} ) {

        # format the user id
        if ( $Data->{ $Attribute . 'ID' } ) {
            my %UserData = $Self->{UserObject}->GetUserData(
                UserID => $Data->{ $Attribute . 'ID' },
            );
            if (%UserData) {
                $Value = sprintf '%s (%s %s)',
                    $UserData{UserLogin},
                    $UserData{UserFirstname},
                    $UserData{UserLastname};
            }
            else {
                $Value = "ID=$Data->{$Attribute}";
            }
        }
    }
    else {

        # take value from the passed in data
        $Value = $Data->{$Attribute};
    }

    # translate the value
    if ( $Value && $RowSpec->{ValueIsTranslatable} ) {
        $Value = $Self->{LayoutObject}->{LanguageObject}->Get($Value),
    }

    # add separator between key and value
    $Key .= ':';

    # show row
    push @{ $RowSpec->{Table} },
        { Key => $Key, Value => $Value, };

    return;
}

# emit information about a change
sub _PDFOutputChangeInfo {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Page Change PrintWorkOrder)) {
        if ( !defined( $Param{$Argument} ) ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }

    my ( $Page, $Change ) = @Param{qw(Page Change)};

    # fill the two tables on top,
    # both tables have two colums: Key and Value
    my ( @TableLeft, @TableRight );

    # determine values that can't be determined in _PrepareAndAddInfoRow()
    my %ComplicatedValue;

    # Values for CAB
    for my $Attribute (qw(CABAgents CABCustomers)) {
        my @LongNames;
        if ( $Attribute eq 'CABAgents' && $Change->{$Attribute} ) {
            for my $CABAgent ( @{ $Change->{$Attribute} } ) {
                my %UserData = $Self->{UserObject}->GetUserData(
                    UserID => $CABAgent,
                    Cache  => 1,
                );
                if (%UserData) {
                    push @LongNames, sprintf '%s (%s %s)',
                        @UserData{qw(UserLogin UserFirstname UserLastname)};
                }
                else {
                    push @LongNames, "ID=$Change->{$Attribute}";
                }
            }
        }
        elsif ( $Attribute eq 'CABCustomers' && $Change->{$Attribute} ) {
            for my $CABCustomer ( @{ $Change->{$Attribute} } ) {
                my %UserData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                    UserID => $CABCustomer,
                    Cache  => 1,
                );
                if (%UserData) {
                    push @LongNames, sprintf '%s (%s %s)',
                        @UserData{qw(UserLogin UserFirstname UserLastname)};
                }
                else {
                    push @LongNames, "ID=$Change->{$Attribute}";
                }
            }
        }

        # remember the value
        $ComplicatedValue{ $Attribute . 'Long' } = join( "\n", @LongNames ) || '-';
    }

    # value for attachments
    {
        my %Attachments = $Self->{ChangeObject}->ChangeAttachmentList(
            ChangeID => $Change->{ChangeID},
        );

        my @Values;

        ATTACHMENT_ID:
        for my $AttachmentID ( keys %Attachments ) {

            # get info about file
            my $AttachmentData = $Self->{ChangeObject}->ChangeAttachmentGet(
                FileID => $AttachmentID,
            );

            # check for attachment information
            next ATTACHMENTID if !$AttachmentData;

            push @Values, sprintf '%s %s',
                $AttachmentData->{Filename},
                $AttachmentData->{Filesize};
        }

        # show row
        $ComplicatedValue{Attachments} = join( "\n", @Values ) || '-';
    }

    my @RowSpec = (
        {
            Attribute           => 'ChangeState',
            Table               => \@TableLeft,
            ValueIsTranslatable => 1,
        },
        {
            Attribute  => 'PlannedEffort',
            IsOptional => 1,
            Table      => \@TableLeft,
        },
        {
            Attribute  => 'AccountedTime',
            IsOptional => 1,
            Table      => \@TableLeft,
        },
        {
            Attribute           => 'Category',
            Key                 => 'Category',
            Table               => \@TableLeft,
            ValueIsTranslatable => 1,
        },
        {
            Attribute           => 'Impact',
            Key                 => 'Impact',
            Table               => \@TableLeft,
            ValueIsTranslatable => 1,
        },
        {
            Attribute           => 'Priority',
            Key                 => 'Priority',
            Table               => \@TableLeft,
            ValueIsTranslatable => 1,
        },
        {
            Attribute   => 'ChangeManager',
            Table       => \@TableLeft,
            ValueIsUser => 1,
        },
        {
            Attribute   => 'ChangeBuilder',
            Table       => \@TableLeft,
            ValueIsUser => 1,
        },
        {
            Attribute => 'CABAgentsLong',
            Key       => 'CAB Agents',
            Table     => \@TableLeft,
        },
        {
            Attribute => 'CABCustomersLong',
            Key       => 'CAB Customers',
            Table     => \@TableLeft,
        },
        {
            Attribute => 'Attachments',
            Key       => 'Attachments',
            Table     => \@TableLeft,
        },
        {
            Attribute   => 'RequestedTime',
            IsOptional  => 1,
            Table       => \@TableRight,
            ValueIsTime => 1,
        },
        {
            Attribute   => 'PlannedStartTime',
            Table       => \@TableRight,
            ValueIsTime => 1,
        },
        {
            Attribute   => 'PlannedEndTime',
            Table       => \@TableRight,
            ValueIsTime => 1,
        },
        {
            Attribute   => 'ActualStartTime',
            Table       => \@TableRight,
            ValueIsTime => 1,
        },
        {
            Attribute   => 'ActualEndTime',
            Table       => \@TableRight,
            ValueIsTime => 1,
        },
        {
            Attribute   => 'CreateTime',
            Key         => 'Created',
            Table       => \@TableRight,
            ValueIsTime => 1,
        },
        {
            Attribute   => 'ChangeTime',
            Key         => 'Changed',
            Table       => \@TableRight,
            ValueIsTime => 1,
        },
    );

    for my $RowSpec (@RowSpec) {

        # fill @TableLeft and @TableRight
        $Self->_PrepareAndAddInfoRow(
            RowSpec           => $RowSpec,
            Data              => { %{$Change}, %ComplicatedValue },
            TranslationPrefix => 'ChangeAttribute::',
        );
    }

    my %Table;
    my $Rows = max( scalar(@TableLeft), scalar(@TableRight) );
    for my $Row ( 0 .. $Rows - 1 ) {
        $Table{CellData}[$Row][0]{Content}         = $TableLeft[$Row]->{Key};
        $Table{CellData}[$Row][0]{Font}            = 'ProportionalBold';
        $Table{CellData}[$Row][1]{Content}         = $TableLeft[$Row]->{Value};
        $Table{CellData}[$Row][2]{Content}         = ' ';
        $Table{CellData}[$Row][2]{BackgroundColor} = '#FFFFFF';
        $Table{CellData}[$Row][3]{Content}         = $TableRight[$Row]->{Key};
        $Table{CellData}[$Row][3]{Font}            = 'ProportionalBold';
        $Table{CellData}[$Row][4]{Content}         = $TableRight[$Row]->{Value};
    }

    $Table{ColumnData}[0]{Width} = 80;
    $Table{ColumnData}[1]{Width} = 170.5;
    $Table{ColumnData}[2]{Width} = 4;
    $Table{ColumnData}[3]{Width} = 80;
    $Table{ColumnData}[4]{Width} = 170.5;

    $Table{Type}                = 'Cut';
    $Table{Border}              = 0;
    $Table{FontSize}            = 6;
    $Table{BackgroundColorEven} = '#AAAAAA';
    $Table{BackgroundColorOdd}  = '#DDDDDD';
    $Table{Padding}             = 1;
    $Table{PaddingTop}          = 3;
    $Table{PaddingBottom}       = 3;

    # output table
    $Self->_PDFOutputTable( Page => $Page, Table => \%Table );

    return 1;
}

# emit information about a workorder
sub _PDFOutputWorkOrderInfo {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Page Change WorkOrder)) {
        if ( !defined( $Param{$Argument} ) ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }

    my ( $Page, $WorkOrder, $Change ) = @Param{qw(Page WorkOrder Change)};
    my $PrintWorkOrder = $Param{PrintWorkOrder} || 0;

    # fill the two tables on top,
    # both tables have two colums: Key and Value
    my ( @TableLeft, @TableRight );

    # determine values that can't be determined in _PrepareAndAddInfoRow()
    my %ComplicatedValue;

    # value for attachments
    {
        my %Attachments = $Self->{WorkOrderObject}->WorkOrderAttachmentList(
            WorkOrderID => $WorkOrder->{WorkOrderID},
        );

        my @Values;

        ATTACHMENT_ID:
        for my $AttachmentID ( keys %Attachments ) {

            # get info about file
            my $AttachmentData = $Self->{WorkOrderObject}->WorkOrderAttachmentGet(
                FileID => $AttachmentID,
            );

            # check for attachment information
            next ATTACHMENTID if !$AttachmentData;

            push @Values, sprintf '%s %s',
                $AttachmentData->{Filename},
                $AttachmentData->{Filesize};
        }

        # show row
        $ComplicatedValue{Attachments} = join( "\n", @Values ) || '-';
    }

    my @RowSpec = (
        {
            Attribute => 'ChangeTitle',
            Table     => \@TableLeft,
            Key       => 'ChangeAttribute::ChangeTitle',
        },
        {
            Attribute => 'ChangeNumber',
            Table     => \@TableLeft,
            Key       => 'ChangeAttribute::ChangeNumber',
        },
        {
            Attribute           => 'WorkOrderState',
            Table               => \@TableLeft,
            ValueIsTranslatable => 1,
        },
        {
            Attribute           => 'WorkOrderType',
            Table               => \@TableLeft,
            ValueIsTranslatable => 1,
        },
        {
            Attribute   => 'WorkOrderAgent',
            Table       => \@TableLeft,
            ValueIsUser => 1,
        },
        {
            Attribute  => 'PlannedEffort',
            IsOptional => 1,
            Table      => \@TableLeft,
            Key        => 'ChangeAttribute::PlannedEffort',
        },
        {
            Attribute  => 'AccountedTime',
            IsOptional => 1,
            Table      => \@TableLeft,
            Key        => 'ChangeAttribute::AccountedTime',
        },
        {
            Attribute => 'Attachments',
            Key       => 'Attachments',
            Table     => \@TableLeft,
        },
        {
            Attribute   => 'PlannedStartTime',
            Table       => \@TableRight,
            ValueIsTime => 1,
            Key         => 'ChangeAttribute::PlannedStartTime',
        },
        {
            Attribute   => 'PlannedEndTime',
            Table       => \@TableRight,
            ValueIsTime => 1,
            Key         => 'ChangeAttribute::PlannedEndTime',
        },
        {
            Attribute   => 'ActualStartTime',
            Table       => \@TableRight,
            ValueIsTime => 1,
            Key         => 'ChangeAttribute::ActualStartTime',
        },
        {
            Attribute   => 'ActualEndTime',
            Table       => \@TableRight,
            ValueIsTime => 1,
            Key         => 'ChangeAttribute::ActualEndTime',
        },
        {
            Attribute   => 'CreateTime',
            Key         => 'Created',
            Table       => \@TableRight,
            ValueIsTime => 1,
        },
        {
            Attribute   => 'ChangeTime',
            Key         => 'Changed',
            Table       => \@TableRight,
            ValueIsTime => 1,
        },
    );

    for my $RowSpec (@RowSpec) {

        # fill @TableLeft and @TableRight
        # the workorder data overrides the change data
        $Self->_PrepareAndAddInfoRow(
            RowSpec           => $RowSpec,
            Data              => { %{$Change}, %{$WorkOrder}, %ComplicatedValue },
            TranslationPrefix => 'WorkOrderAttribute::',
        );
    }

    my %Table;
    my $Rows = max( scalar(@TableLeft), scalar(@TableRight) );
    for my $Row ( 0 .. $Rows - 1 ) {
        $Table{CellData}[$Row][0]{Content}         = $TableLeft[$Row]->{Key};
        $Table{CellData}[$Row][0]{Font}            = 'ProportionalBold';
        $Table{CellData}[$Row][1]{Content}         = $TableLeft[$Row]->{Value};
        $Table{CellData}[$Row][2]{Content}         = ' ';
        $Table{CellData}[$Row][2]{BackgroundColor} = '#FFFFFF';
        $Table{CellData}[$Row][3]{Content}         = $TableRight[$Row]->{Key};
        $Table{CellData}[$Row][3]{Font}            = 'ProportionalBold';
        $Table{CellData}[$Row][4]{Content}         = $TableRight[$Row]->{Value};
    }

    $Table{ColumnData}[0]{Width} = 80;
    $Table{ColumnData}[1]{Width} = 170.5;
    $Table{ColumnData}[2]{Width} = 4;
    $Table{ColumnData}[3]{Width} = 80;
    $Table{ColumnData}[4]{Width} = 170.5;

    $Table{Type}                = 'Cut';
    $Table{Border}              = 0;
    $Table{FontSize}            = 6;
    $Table{BackgroundColorEven} = '#AAAAAA';
    $Table{BackgroundColorOdd}  = '#DDDDDD';
    $Table{Padding}             = 1;
    $Table{PaddingTop}          = 3;
    $Table{PaddingBottom}       = 3;

    # output table
    $Self->_PDFOutputTable( Page => $Page, Table => \%Table );

    return 1;
}

sub _PDFOutputDescriptionAndJustification {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Page Change)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my ( $Page, $Change ) = @Param{qw(Page Change)};

    # table params common to description and justification
    my %Table = (
        Type            => 'Cut',
        Border          => 0,
        Font            => 'Monospaced',
        FontSize        => 7,
        BackgroundColor => '#DDDDDD',
        Padding         => 4,
        PaddingTop      => 8,
        PaddingBottom   => 8,
    );

    # output tables
    my $Row = 0;
    for my $Attribute (qw(Description Justification)) {

        # The plain content will be displayed
        $Table{CellData}[ $Row++ ][0]{Content} = $Attribute;
        $Table{CellData}[ $Row++ ][0]{Content} = $Change->{ $Attribute . 'Plain' } || ' ';
    }
    $Table{CellData}[ $Row++ ][0]{Content} = 'TODO: workorders';

    # output table
    $Self->_PDFOutputTable( Page => $Page, Table => \%Table );

    return 1;
}

sub _PDFOutputTable {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Page Table)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my ( $Page, $Table ) = @Param{qw(Page Table)};

    for ( $Page->{PageCount} .. $Page->{MaxPages} ) {

        # output table (or a fragment of it)
        %{$Table} = $Self->{PDFObject}->Table( %{$Table} );

        # stop output or output next page
        if ( $Table->{State} ) {
            last;
        }
        else {
            $Self->{PDFObject}->PageNew(
                %{$Page},
                FooterRight => join( ' ', $Page->{PageText}, $Page->{PageCount} ),
            );
            $Page->{PageCount}++;
        }
    }

    return 1;
}

1;
