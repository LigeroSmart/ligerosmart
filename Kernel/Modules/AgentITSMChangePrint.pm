# --
# Kernel/Modules/AgentITSMChangePrint.pm - the OTRS::ITSM::ChangeManagement change print module
# Copyright (C) 2003-2010 OTRS AG, http://otrs.com/
# --
# $Id: AgentITSMChangePrint.pm,v 1.23 2010-01-29 13:04:09 bes Exp $
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
use Kernel::System::LinkObject;
use Kernel::System::PDF;
use Kernel::System::CustomerUser;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.23 $) [1];

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

    # when there is no PDF-Support, $Self->{PDFObject} will be undefined
    $Self->{PDFObject} = Kernel::System::PDF->new(%Param);

    #$Self->{PDFObject}          = undef;  # TODO: remove line when devel is finished

    # get config of frontend module
    $Self->{Config} = $Self->{ConfigObject}->Get("ITSMChange::Frontend::$Self->{Action}");

    # Page controls the PDF-generation
    # it won't be used when there is no PDF-Support
    $Self->{Page} = {};

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # Find out whether a change or a workorder should be printed.
    # A workorder is to be printed when the WorkOrderID is passed.
    # Otherwise a change should be printed.
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
                Message => "Can't create output, as the workorder is not attached to a change!",
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
                Message => "Can't create output, as no ChangeID is given!",
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

    # check error
    if ( !$Change ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Change '$ChangeID' not found in database!",
            Comment => 'Please contact the admin.',
        );
    }

    # some init for PDF-Output
    if ( $Self->{PDFObject} ) {

        my $Page = $Self->{Page};

        # get maximum number of pages
        $Page->{MaxPages} = $Self->{ConfigObject}->Get('PDF::MaxPages');
        if ( !$Page->{MaxPages} || $Page->{MaxPages} < 1 || $Page->{MaxPages} > 1000 ) {
            $Page->{MaxPages} = 100;
        }

        # page layout settings
        $Page->{MarginTop}    = 30;
        $Page->{MarginRight}  = 40;
        $Page->{MarginBottom} = 40;
        $Page->{MarginLeft}   = 40;
    }

    # output the header
    # $Output receives generated HTML in the non-PDF case
    my $Output = $Self->_OutputHeader(
        PrintChange    => $PrintChange,
        PrintWorkOrder => $PrintWorkOrder,
        Change         => $Change,
        WorkOrder      => $WorkOrder,
    );

    # output change info, even when a workorder is printed
    $Output .= $Self->_OutputChangeInfo(
        Change         => $Change,
        PrintWorkOrder => $PrintWorkOrder,
    );

    # output change description and justification
    # the plain content will be displayed
    if ($PrintChange) {
        for my $Attribute (qw(Description Justification)) {
            $Self->_OutputLongText(
                PrintChange    => $PrintChange,
                PrintWorkOrder => $PrintWorkOrder,
                Title          => $Attribute,
                LongText       => $Change->{ $Attribute . 'Plain' },
            );
        }
    }

    # generate PDF output
    if ( $Self->{PDFObject} ) {
        my $Page = $Self->{Page};

        # the link types are needed for showing the linked objects
        my %LinkTypeList = $Self->{LinkObject}->TypeList(
            UserID => $Self->{UserID},
        );

        if ($PrintChange) {

            # get linked objects which are directly linked with this change object
            my $LinkListWithData = $Self->{LinkObject}->LinkListWithData(
                Object => 'ITSMChange',
                Key    => $ChangeID,
                State  => 'Valid',
                UserID => $Self->{UserID},
            );

            # get the combined linked objects from all workorders of this change
            my $LinkListWithDataCombinedWorkOrders = {};
            for my $WorkOrderID ( @{ $Change->{WorkOrderIDs} } ) {

                # get linked objects of this workorder
                my $LinkListWithDataWorkOrder = $Self->{LinkObject}->LinkListWithData(
                    Object => 'ITSMWorkOrder',
                    Key    => $WorkOrderID,
                    State  => 'Valid',
                    UserID => $Self->{UserID},
                );

                OBJECT:
                for my $Object ( keys %{$LinkListWithDataWorkOrder} ) {

                    # only show linked services and config items of workorder
                    if ( $Object ne 'Service' && $Object ne 'ITSMConfigItem' ) {
                        next OBJECT;
                    }

                    LINKTYPE:
                    for my $LinkType ( keys %{ $LinkListWithDataWorkOrder->{$Object} } ) {

                        DIRECTION:
                        for my $Direction (
                            keys %{ $LinkListWithDataWorkOrder->{$Object}->{$LinkType} }
                            )
                        {
                            ID:
                            for my $ID (
                                keys %{
                                    $LinkListWithDataWorkOrder->{$Object}->{$LinkType}->{$Direction}
                                }
                                )
                            {

                                # combine the linked object data from all workorders
                                $LinkListWithDataCombinedWorkOrders->{$Object}->{$LinkType}
                                    ->{$Direction}->{$ID}
                                    = $LinkListWithDataWorkOrder->{$Object}->{$LinkType}
                                    ->{$Direction}->{$ID};
                            }
                        }
                    }
                }
            }

            # add combined linked objects from workorder to linked objects from change object
            $LinkListWithData = {
                %{$LinkListWithData},
                %{$LinkListWithDataCombinedWorkOrders},
            };

            # get the link data
            if ( $LinkListWithData && ref $LinkListWithData eq 'HASH' && %{$LinkListWithData} ) {
                my %LinkData = $Self->{LayoutObject}->LinkObjectTableCreate(
                    LinkListWithData => $LinkListWithData,
                    ViewMode         => 'SimpleRaw',
                );

                $Self->_PDFOutputLinkedObjects(
                    LinkData     => \%LinkData,
                    LinkTypeList => \%LinkTypeList,
                );
            }

            # output an overview over workorders
            my @WorkOrderOverview;
            for my $WorkOrderID ( @{ $Change->{WorkOrderIDs} } ) {

                # get workorder info
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

                push @WorkOrderOverview,
                    [
                    $WorkOrder->{WorkOrderNumber},
                    $WorkOrder->{WorkOrderTitle},
                    $WorkOrder->{WorkOrderState},
                    $WorkOrder->{PlannedStartTime},
                    $WorkOrder->{PlannedEndTime},
                    $WorkOrder->{ActualStartTime},
                    $WorkOrder->{ActualEndTime},
                    ];
            }

            $Self->_PDFOutputWorkOrderOverview(
                WorkOrderOverview => \@WorkOrderOverview,
            );
        }

        # output either a single workorder or all workorders of a change
        my @WorkOrderIDs = $PrintChange
            ?
            @{ $Change->{WorkOrderIDs} || [] }
            :
            ($WorkOrderID);
        for my $WorkOrderID (@WorkOrderIDs) {

            # get workorder info
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
                Change    => $Change,
                WorkOrder => $WorkOrder,
            );

            # output workorder instruction and report
            # The plain content will be displayed
            for my $Attribute (qw(Instruction Report)) {
                $Self->_OutputLongText(
                    PrintChange    => $PrintChange,
                    PrintWorkOrder => $PrintWorkOrder,
                    Title          => $Attribute,
                    LongText       => $WorkOrder->{ $Attribute . 'Plain' },
                );
            }

            # get linked objects
            my $LinkListWithData = $Self->{LinkObject}->LinkListWithData(
                Object => 'ITSMWorkOrder',
                Key    => $WorkOrderID,
                State  => 'Valid',
                UserID => $Self->{UserID},
            );

            # get the link data
            if ( $LinkListWithData && ref $LinkListWithData eq 'HASH' && %{$LinkListWithData} ) {
                my %LinkData = $Self->{LayoutObject}->LinkObjectTableCreate(
                    LinkListWithData => $LinkListWithData,
                    ViewMode         => 'SimpleRaw',
                );

                $Self->_PDFOutputLinkedObjects(
                    LinkData     => \%LinkData,
                    LinkTypeList => \%LinkTypeList,
                );
            }
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

    # generate html output when there is no PDF-support

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

# output the header
sub _OutputHeader {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(PrintChange PrintWorkOrder Change WorkOrder)) {
        if ( !defined( $Param{$Argument} ) ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }

    my ( $Change, $WorkOrder ) = @Param{qw(Change WorkOrder)};

    # the second item in the page title is the area in the product 'ITSM Change Management'
    my $HeaderArea = $Param{PrintChange} ? 'ITSM Change' : 'ITSM Workorder';
    $HeaderArea = $Self->{LayoutObject}->{LanguageObject}->Get($HeaderArea);

    # the last item in the page title is either the change number of the full workorder number
    my $HeaderValue = '';
    if ( $Param{PrintChange} ) {
        $HeaderValue = $Change->{ChangeNumber};
    }
    else {
        $HeaderValue = join '-', $Change->{ChangeNumber}, $WorkOrder->{WorkOrderNumber};
    }

    if ( $Self->{PDFObject} ) {
        my $PrintedBy = $Self->{LayoutObject}->{LanguageObject}->Get('printed by');
        my $Time = $Self->{LayoutObject}->Output( Template => '$Env{"Time"}' );
        my $Url
            = $Self->{ConfigObject}->Get('HttpType') . '://'
            . $Self->{ConfigObject}->Get('FQDN')
            . $Self->{LayoutObject}->{Baselink}
            . $Self->{RequestedURL};

        # assemble the headers
        my $HeaderRight = $HeaderArea;
        $HeaderRight .= '#' . $HeaderValue;    # add change number or full workorder number
        my $HeadlineLeft = $HeaderRight;
        my $Title        = $HeaderRight;

        if ( $Param{PrintChange} && $Change->{ChangeTitle} ) {
            $HeadlineLeft = $Change->{ChangeTitle};
            $Title .= ' / ' . $Change->{ChangeTitle};
        }
        elsif ( $Param{PrintWorkOrder} && $WorkOrder->{WorkOrderTitle} ) {
            $HeadlineLeft = $WorkOrder->{WorkOrderTitle};
            $Title .= ' / ' . $WorkOrder->{WorkOrderTitle};
        }

        # page headers and footer
        my $Page = $Self->{Page};
        $Page->{HeaderRight}  = $HeaderRight;
        $Page->{HeadlineLeft} = $HeadlineLeft;
        $Page->{HeadlineRight}
            = $PrintedBy . ' '
            . $Self->{UserFirstname} . ' '
            . $Self->{UserLastname} . ' ('
            . $Self->{UserEmail} . ') '
            . $Time;
        $Page->{FooterLeft} = $Url;
        $Page->{PageText}   = $Self->{LayoutObject}->{LanguageObject}->Get('Page');
        $Page->{PageCount}  = 1;

        # create new PDF document
        $Self->{PDFObject}->DocumentNew(
            Title  => $Self->{ConfigObject}->Get('Product') . ': ' . $Title,
            Encode => $Self->{LayoutObject}->{UserCharset},
        );

        # create first PDF page
        $Self->{PDFObject}->PageNew(
            %{$Page},
            FooterRight => $Page->{PageText} . ' ' . $Page->{PageCount},
        );
        $Page->{PageCount}++;

        return '';
    }
    else {

        # output header
        my $Output = $Self->{LayoutObject}->PrintHeader(
            Area  => $HeaderArea,
            Value => $HeaderValue,
        );

        my $Title = '';
        if ( $Param{PrintChange} && $Change->{ChangeTitle} ) {
            $Title = $Change->{ChangeTitle};
        }
        elsif ( $Param{PrintWorkOrder} && $WorkOrder->{WorkOrderTitle} ) {
            $Title = $WorkOrder->{WorkOrderTitle};
        }

        # headline in the user visible HTML output
        $Self->{LayoutObject}->Block(
            Name => 'Headline',
            Data => {
                HeaderArea  => $HeaderArea,
                HeaderValue => $HeaderValue,
                Title       => $Title,
            },
        );

        return $Output;
    }
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
sub _OutputChangeInfo {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Change PrintWorkOrder)) {
        if ( !defined( $Param{$Argument} ) ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }

    # just for having shorter names
    my $Change = $Param{Change};

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

    # number of rows in the change info table
    my $Rows = max( scalar(@TableLeft), scalar(@TableRight) );

    if ( $Self->{PDFObject} ) {

        my %Table;
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
        $Self->_PDFOutputTable(
            Table => \%Table,
        );

        return '';
    }
    else {

        # show left table
        for my $Row (@TableLeft) {
            $Self->{LayoutObject}->Block(
                Name => 'ChangeInfoLeft',
                Data => $Row,
            );
        }

        # show right table
        for my $Row (@TableRight) {
            $Self->{LayoutObject}->Block(
                Name => 'ChangeInfoRight',
                Data => $Row,
            );
        }

        return '';
    }
}

# emit information about a workorder
sub _PDFOutputWorkOrderInfo {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Change WorkOrder)) {
        if ( !defined( $Param{$Argument} ) ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }

    my ( $WorkOrder, $Change ) = @Param{qw(WorkOrder Change)};
    my $Page = $Self->{Page};
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
    $Self->_PDFOutputTable(
        Table => \%Table,
    );

    return 1;
}

# output a body of text, such as a change description
sub _OutputLongText {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(PrintChange PrintWorkOrder Title LongText)) {
        if ( !defined( $Param{$Argument} ) ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }

    if ( $Self->{PDFObject} ) {

        my $Page = $Self->{Page};

        # table params common to printing a body of text, like a description
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
        $Table{CellData}[ $Row++ ][0]{Content} = $Param{Title}    || '';
        $Table{CellData}[ $Row++ ][0]{Content} = $Param{LongText} || '';

        # output table
        $Self->_PDFOutputTable(
            Table => \%Table,
        );

        return '';
    }
    else {

        my $TemplateName = $Param{PrintChange} ? 'ChangeLongText' : 'WorkOrderLongText';
        $Self->{LayoutObject}->Block(
            Name => $TemplateName,
            Data => \%Param,
        );

        return '';
    }
}

# output overview over workorders
sub _PDFOutputWorkOrderOverview {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(WorkOrderOverview)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my %Page = %{ $Self->{Page} };
    my %Table;
    my $Row = 0;

    for my $WorkOrder ( @{ $Param{WorkOrderOverview} } ) {
        $Table{CellData}[ $Row++ ] = [ map { { Content => $_ } } @{$WorkOrder} ];
    }

    $Table{ColumnData}[0]{Width} = 10;
    $Table{ColumnData}[1]{Width} = 40;
    $Table{ColumnData}[2]{Width} = 40;
    $Table{ColumnData}[3]{Width} = 40;
    $Table{ColumnData}[4]{Width} = 40;
    $Table{ColumnData}[5]{Width} = 40;
    $Table{ColumnData}[6]{Width} = 40;

    # set new position
    $Self->{PDFObject}->PositionSet(
        Move => 'relativ',
        Y    => -15,
    );

    # output headline
    $Self->{PDFObject}->Text(
        Text     => $Self->{LayoutObject}->{LanguageObject}->Get('Workorders'),
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
    $Table{Type}            = 'Cut';
    $Table{Border}          = 0;
    $Table{FontSize}        = 6;
    $Table{BackgroundColor} = '#DDDDDD';
    $Table{Padding}         = 1;
    $Table{PaddingTop}      = 3;
    $Table{PaddingBottom}   = 3;

    # output table
    $Self->_PDFOutputTable(
        Table => \%Table,
    );

    return 1;
}

# output info about a linked object
sub _PDFOutputLinkedObjects {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(LinkData LinkTypeList)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my %Page     = %{ $Self->{Page} };
    my %TypeList = %{ $Param{LinkTypeList} };
    my %Table;
    my $Row = 0;

    for my $LinkTypeLinkDirection ( sort { lc $a cmp lc $b } keys %{ $Param{LinkData} } ) {

        # investigate link type name
        my @LinkData = split q{::}, $LinkTypeLinkDirection;
        my $LinkTypeName = $TypeList{ $LinkData[0] }->{ $LinkData[1] . 'Name' };
        $LinkTypeName = $Self->{LayoutObject}->{LanguageObject}->Get($LinkTypeName);

        # define headline
        $Table{CellData}[$Row][0]{Content} = $LinkTypeName . ':';
        $Table{CellData}[$Row][0]{Font}    = 'ProportionalBold';
        $Table{CellData}[$Row][1]{Content} = '';

        # extract object list
        my $ObjectList = $Param{LinkData}->{$LinkTypeLinkDirection};

        for my $Object ( sort { lc $a cmp lc $b } keys %{$ObjectList} ) {

            for my $Item ( @{ $ObjectList->{$Object} } ) {

                $Table{CellData}[$Row][0]{Content} ||= '';
                $Table{CellData}[$Row][1]{Content} = $Item->{Title} || '';
            }
            continue {
                $Row++;
            }
        }
    }

    $Table{ColumnData}[0]{Width} = 80;
    $Table{ColumnData}[1]{Width} = 431;

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
    $Table{Type}            = 'Cut';
    $Table{Border}          = 0;
    $Table{FontSize}        = 6;
    $Table{BackgroundColor} = '#DDDDDD';
    $Table{Padding}         = 1;
    $Table{PaddingTop}      = 3;
    $Table{PaddingBottom}   = 3;

    # output table
    $Self->_PDFOutputTable(
        Table => \%Table,
    );

    return 1;
}

# output a table, accross several pages if neccessary
sub _PDFOutputTable {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Table)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # just for having shorter names
    my $Table = $Param{Table};
    my $Page  = $Self->{Page};

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
