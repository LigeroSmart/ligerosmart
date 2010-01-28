# --
# Kernel/Modules/AgentITSMChangePrint.pm - the OTRS::ITSM::ChangeManagement change print module
# Copyright (C) 2003-2010 OTRS AG, http://otrs.com/
# --
# $Id: AgentITSMChangePrint.pm,v 1.6 2010-01-28 10:00:53 bes Exp $
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
$VERSION = qw($Revision: 1.6 $) [1];

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
                Message => "WorkOrder $WorkOrderID not found in database!",
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
            Message => "Change $ChangeID not found in database!",
            Comment => 'Please contact the admin.',
        );
    }

    # generate PDF output
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

        if ($PrintChange) {

            # output change infos
            $Self->_PDFOutputChangeInfos(
                PageData   => \%Page,
                ChangeData => $Change,
            );

            # output change content infos
            $Self->_PDFOutputDescriptionAndJustification(
                PageData   => \%Page,
                ChangeData => $Change,
            );

            # TODO: output workorders
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

sub _PDFOutputChangeInfos {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(PageData ChangeData)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    my %Change = %{ $Param{ChangeData} };
    my %Page   = %{ $Param{PageData} };

    # create left table
    my @TableLeft = (
        {
            Key   => $Self->{LayoutObject}->{LanguageObject}->Get('Change State') . ':',
            Value => $Self->{LayoutObject}->{LanguageObject}->Get( $Change{ChangeState} ),
        },
    );

    # show optional rows
    ATTRIBUTE:
    for my $Attribute (qw(PlannedEffort AccountedTime)) {

        # skip if row is switched off in SysConfig
        next ATTRIBUTE if !$Self->{Config}->{$Attribute};

        # show row
        push @TableLeft,
            {
            Key => $Self->{LayoutObject}->{LanguageObject}->Get("ChangeAttribute::$Attribute")
                . ':',
            Value => $Self->{LayoutObject}->{LanguageObject}->Get( $Change{$Attribute} ),
            };
    }

    # show CIP
    for my $Attribute (qw(Category Impact Priority)) {

        # show row
        # TODO: think about translation
        push @TableLeft,
            {
            Key => $Self->{LayoutObject}->{LanguageObject}->Get($Attribute) . ':',
            Value => $Change{$Attribute} || '-',
            };
    }

    # show ChangeManager and ChangeBuilder
    for my $Attribute (qw(ChangeManager ChangeBuilder)) {

        my $LongName = '-';
        if ( $Change{ $Attribute . 'ID' } ) {
            my %UserData = $Self->{UserObject}->GetUserData(
                UserID => $Change{ $Attribute . 'ID' },
            );
            if (%UserData) {
                $LongName = sprintf '%s (%s %s)',
                    @UserData{qw(UserLogin UserFirstname UserLastname)};
            }
            else {
                $LongName = "ID=$Change{$Attribute}";
            }
        }

        # show row
        push @TableLeft,
            {
            Key => $Self->{LayoutObject}->{LanguageObject}->Get("ChangeAttribute::$Attribute")
                . ':',
            Value => $LongName,
            };
    }

    # show CAB
    for my $Attribute (qw(CABAgents CABCustomers)) {
        my @LongNames;
        if ( $Attribute eq 'CABAgents' && $Change{$Attribute} ) {
            for my $CABAgent ( @{ $Change{$Attribute} } ) {
                my %UserData = $Self->{UserObject}->GetUserData(
                    UserID => $CABAgent,
                    Cache  => 1,
                );
                if (%UserData) {
                    push @LongNames, sprintf '%s (%s %s)',
                        @UserData{qw(UserLogin UserFirstname UserLastname)};
                }
                else {
                    push @LongNames, "ID=$Change{$Attribute}";
                }
            }
        }
        elsif ( $Attribute eq 'CABCustomers' && $Change{$Attribute} ) {
            for my $CABCustomer ( @{ $Change{$Attribute} } ) {
                my %UserData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                    UserID => $CABCustomer,
                    Cache  => 1,
                );
                if (%UserData) {
                    push @LongNames, sprintf '%s (%s %s)',
                        @UserData{qw(UserLogin UserFirstname UserLastname)};
                }
                else {
                    push @LongNames, "ID=$Change{$Attribute}";
                }
            }
        }

        # show row
        my $Value = join( "\n", @LongNames ) || '-';
        push @TableLeft,
            {
            Key => $Self->{LayoutObject}->{LanguageObject}->Get("ChangeAttribute::$Attribute")
                . ':',
            Value => $Value,
            };
    }

    # show attachments
    {
        my %Attachments = $Self->{ChangeObject}->ChangeAttachmentList(
            ChangeID => $Change{ChangeID},
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
        my $Value = join( "\n", @Values ) || '-';
        push @TableLeft,
            {
            Key   => $Self->{LayoutObject}->{LanguageObject}->Get('Attachments') . ':',
            Value => $Value,
            };
    }

    # create right table
    my @TableRight;
    my @AdditionalAttributes;
    if ( $Self->{Config}->{RequestedTime} ) {
        push @AdditionalAttributes, 'RequestedTime';
    }
    for my $Attribute (
        @AdditionalAttributes, qw(PlannedStartTime PlannedEndTime ActualStartTime ActualEndTime)
        )
    {

        # show row
        push @TableRight,
            {
            Key => $Self->{LayoutObject}->{LanguageObject}->Get("ChangeAttribute::$Attribute")
                . ':',
            Value => $Change{$Attribute} || '-',
            };
    }

    # create and change time
    {
        push @TableRight,
            {
            Key   => $Self->{LayoutObject}->{LanguageObject}->Get('Created') . ':',
            Value => $Self->{LayoutObject}->Output(
                Template => '$TimeLong{"$Data{"CreateTime"}"}',
                Data     => \%Change,
            ),
            },
            {
            Key   => $Self->{LayoutObject}->{LanguageObject}->Get('Changed') . ':',
            Value => $Self->{LayoutObject}->Output(
                Template => '$TimeLong{"$Data{"ChangeTime"}"}',
                Data     => \%Change,
            ),
            };
    }

    my %TableParam;
    my $Rows = max( scalar(@TableLeft), scalar(@TableRight) );
    for my $Row ( 0 .. $Rows - 1 ) {
        $TableParam{CellData}[$Row][0]{Content}         = $TableLeft[$Row]->{Key};
        $TableParam{CellData}[$Row][0]{Font}            = 'ProportionalBold';
        $TableParam{CellData}[$Row][1]{Content}         = $TableLeft[$Row]->{Value};
        $TableParam{CellData}[$Row][2]{Content}         = ' ';
        $TableParam{CellData}[$Row][2]{BackgroundColor} = '#FFFFFF';
        $TableParam{CellData}[$Row][3]{Content}         = $TableRight[$Row]->{Key};
        $TableParam{CellData}[$Row][3]{Font}            = 'ProportionalBold';
        $TableParam{CellData}[$Row][4]{Content}         = $TableRight[$Row]->{Value};
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
                %Page,
                FooterRight => $Page{PageText} . ' ' . $Page{PageCount},
            );
            $Page{PageCount}++;
        }
    }

    return 1;
}

sub _PDFOutputDescriptionAndJustification {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(PageData ChangeData)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my %Page   = %{ $Param{PageData} };
    my %Change = %{ $Param{ChangeData} };

    # table params common to description and justification
    my %TableParam = (
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
        $TableParam{CellData}[ $Row++ ][0]{Content} = $Attribute;
        $TableParam{CellData}[ $Row++ ][0]{Content} = $Change{ $Attribute . 'Plain' } || ' ';
    }
    $TableParam{CellData}[ $Row++ ][0]{Content} = 'TODO: workorders';
    for ( $Page{PageCount} .. $Page{MaxPages} ) {

        # output table (or a fragment of it)
        %TableParam = $Self->{PDFObject}->Table( %TableParam, );

        # stop output or output next page
        if ( $TableParam{State} ) {
            last;
        }
        else {
            $Self->{PDFObject}->PageNew(
                %Page,
                FooterRight => $Page{PageText} . ' ' . $Page{PageCount},
            );
            $Page{PageCount}++;
        }
    }

    return 1;
}

1;
