# --
# Kernel/Modules/CustomerFAQZoom.pm - to get a closer view
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: CustomerFAQZoom.pm,v 1.5 2010-11-16 00:25:14 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::CustomerFAQZoom;

use strict;
use warnings;

use Kernel::System::LinkObject;
use Kernel::System::FAQ;
use Kernel::System::User;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.5 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (
        qw(ParamObject DBObject LayoutObject LogObject ConfigObject UserObject GroupObject)
        )
    {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Object!" );
        }
    }

    # create needed objects
    $Self->{LinkObject} = Kernel::System::LinkObject->new(%Param);
    $Self->{FAQObject}  = Kernel::System::FAQ->new(%Param);
    $Self->{UserObject} = Kernel::System::User->new(%Param);

    # get config of frontend module
    $Self->{Config} = $Self->{ConfigObject}->Get("FAQ::Frontend::$Self->{Action}");

    # set default interface parameters
    $Self->{Interface} = $Self->{FAQObject}->StateTypeGet(
        Name   => 'external',
        UserID => $Self->{UserID},
    );
    $Self->{InterfaceStates} = $Self->{FAQObject}->StateTypeList(
        Types => [ 'external', 'public' ],
        UserID => $Self->{UserID},
    );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get params
    my %GetParam;
    $GetParam{ItemID} = $Self->{ParamObject}->GetParam( Param => 'ItemID' );
    $GetParam{Rate}   = $Self->{ParamObject}->GetParam( Param => 'Rate' );

    # check needed stuff
    if ( !$GetParam{ItemID} ) {
        return $Self->{LayoutObject}->CustomerFatalError( Message => 'Need ItemID!' );
    }

    # get FAQ item data
    my %FAQData = $Self->{FAQObject}->FAQGet(
        ItemID => $GetParam{ItemID},
        UserID => $Self->{UserID},
    );
    if ( !%FAQData ) {
        return $Self->{LayoutObject}->CustomerFatalError();
    }

    # store the last screen in session
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenView',
        Value     => $Self->{RequestedURL},
    );

    # check user permission
    my $Permission = $Self->{FAQObject}->CheckCategoryCustomerPermission(
        CustomerUser => $Self->{UserLogin},
        CategoryID   => $FAQData{CategoryID},
        UserID       => $Self->{UserID},
    );

    # show no permission error
    if ( !$Permission || !$FAQData{Approved} ) {
        return $Self->{LayoutObject}->CustomerNoPermission( WithHeader => 'yes' );
    }

    # ---------------------------------------------------------- #
    # DownloadAttachment Subaction
    # ---------------------------------------------------------- #
    if ( $Self->{Subaction} eq 'DownloadAttachment' ) {

        # manage parameters
        $GetParam{FileID} = $Self->{ParamObject}->GetParam( Param => 'FileID' );
        if ( !defined $GetParam{FileID} ) {
            return $Self->{LayoutObject}->CustomerFatalError( Message => 'Need FileID' );
        }

        # get attachments
        my %File = $Self->{FAQObject}->AttachmentGet(
            ItemID => $GetParam{ItemID},
            FileID => $GetParam{FileID},
            UserID => $Self->{UserID},
        );
        if (%File) {
            return $Self->{LayoutObject}->Attachment(%File);
        }
        else {
            $Self->{LogObject}->Log(
                Message  => "No such attachment ($GetParam{FileID})! May be an attack!!!",
                Priority => 'error',
            );
            return $Self->{LayoutObject}->CustomerFatalError();
        }
    }

    # output header
    my $Output = $Self->{LayoutObject}->CustomerHeader(
        Value => $FAQData{Title},
    );
    $Output .= $Self->{LayoutObject}->CustomerNavigationBar();

    # get FAQ vote information
    my $VoteData = $Self->{FAQObject}->VoteGet(
        CreateBy  => $Self->{UserID},
        ItemID    => $FAQData{ItemID},
        Interface => $Self->{Interface}->{StateID},
        IP        => $ENV{'REMOTE_ADDR'},
        UserID    => $Self->{UserID},
    );

    # check if user already voted this FAQ item
    my $AlreadyVoted;
    if ($VoteData) {

        # item/change_time > voting/create_time
        my $ItemChangedSystemTime = $Self->{TimeObject}->TimeStamp2SystemTime(
            String => $FAQData{Changed} || '',
        );
        my $VoteCreatedSystemTime = $Self->{TimeObject}->TimeStamp2SystemTime(
            String => $VoteData->{Created} || '',
        );
        if ( $ItemChangedSystemTime <= $VoteCreatedSystemTime ) {
            $AlreadyVoted = 1;
        }
    }

    # ---------------------------------------------------------- #
    # Vote Subaction
    # ---------------------------------------------------------- #
    if ( $Self->{Subaction} eq 'Vote' ) {

        # user can vote only once per FAQ revision
        if ($AlreadyVoted) {
            $Output .= $Self->{LayoutObject}->Notify(
                Priority => 'Error',
                Info     => 'You have already voted!',
            );
        }

        # set the vote if any
        elsif ( defined $GetParam{Rate} ) {

            # get rates config
            my $VotingRates = $Self->{ConfigObject}->Get('FAQ::Item::Voting::Rates');
            my $Rate        = $GetParam{Rate};

            # send error if rate is not defined in config
            if ( !$VotingRates->{$Rate} ) {
                $Self->{LayoutObject}->CustomerFatalError(
                    Message => "The vote rate is not defined!"
                );
            }

            # otherwise add the vote
            else {
                $Self->{FAQObject}->VoteAdd(
                    CreatedBy => $Self->{UserID},
                    ItemID    => $GetParam{ItemID},
                    IP        => $ENV{'REMOTE_ADDR'},
                    Interface => $Self->{Interface}->{StateID},
                    Rate      => $GetParam{Rate},
                    UserID    => $Self->{UserID},
                );

                # do not show the voting form
                $AlreadyVoted = 1;

                # refresh FAQ item data
                %FAQData = $Self->{FAQObject}->FAQGet(
                    ItemID => $GetParam{ItemID},
                    UserID => $Self->{UserID},
                );
                if ( !%FAQData ) {
                    return $Self->{LayoutObject}->CustomerFatalError();
                }

                $Output .= $Self->{LayoutObject}->Notify( Info => 'Thanks for your vote!' );
            }
        }

        # user is able to vote but no rate has been selected
        else {
            $Output .= $Self->{LayoutObject}->Notify(
                Priority => 'Error',
                Info     => 'No rate selected!',
            );
        }
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

    # permission check
    if ( !exists( $Self->{InterfaceStates}{ $FAQData{StateTypeID} } ) ) {
        return $Self->{LayoutObject}->CustomerNoPermission( WithHeader => 'yes' );
    }
    if (
        ( $Self->{Interface}->{Name} eq 'public' )
        || ( $Self->{Interface}->{Name} eq 'external' )
        )
    {
        if ( !$FAQData{Approved} ) {
            return $Self->{LayoutObject}->CustomerNoPermission( WithHeader => 'yes' );
        }
    }

    # get user info (CreatedBy)
    my %UserInfo = $Self->{UserObject}->GetUserData(
        UserID => $FAQData{CreatedBy}
    );
    $Param{CreatedByLogin} = $UserInfo{UserLogin};

    # get user info (ChangedBy)
    %UserInfo = $Self->{UserObject}->GetUserData(
        UserID => $FAQData{ChangedBy}
    );
    $Param{ChangedByLogin} = $UserInfo{UserLogin};

    # set voting results
    $Param{VotingResultColor} = $Self->{LayoutObject}->GetFAQItemVotingRateColor(
        Rate => $FAQData{VoteResult},
    );

    if ( !$Param{VotingResultColor} || $FAQData{Votes} eq '0' ) {
        $Param{VotingResultColor} = 'Gray';
    }

    #output main (Header) block
    $Self->{LayoutObject}->Block(
        Name => 'Header',
        Data => {
            %FAQData,
            %GetParam,
            %Param,
        },
    );

    # show back link
    $Self->{LayoutObject}->Block(
        Name => 'Back',
        Data => \%Param,
    );

    #output Flaq title block
    $Self->{ShowFlag} = 0;
    if ( $Self->{ShowFlag} ) {
        $Self->{LayoutObject}->Block(
            Name => 'Flag',
            Data => {
                %FAQData,
                %Param,
            },
        );
    }

    # output approval state
    if ( $Self->{ConfigObject}->Get('FAQ::ApprovalRequired') ) {
        $Param{Approval} = $FAQData{Approved} ? 'Yes' : 'No';
        $Self->{LayoutObject}->Block(
            Name => 'ViewApproval',
            Data => {%Param},
        );
    }

    # always diplays Votes result even if its 0
    $Self->{LayoutObject}->Block(
        Name => 'ViewVotes',
        Data => {%FAQData},
    );

    # show FAQ path
    my $ShowFAQPath = $Self->{LayoutObject}->FAQPathShow(
        FAQObject  => $Self->{FAQObject},
        CategoryID => $FAQData{CategoryID},
    );
    if ($ShowFAQPath) {
        $Self->{LayoutObject}->Block(
            Name => 'FAQPathItemElement',
            Data => {%FAQData},
        );
    }

    # show keywords as search links
    if ( $FAQData{Keywords} ) {

        # replace commas and semicolons
        $FAQData{Keywords} =~ s/,/ /g;
        $FAQData{Keywords} =~ s/;/ /g;

        my @Keywords = split /\s+/, $FAQData{Keywords};
        for my $Keyword (@Keywords) {
            $Self->{LayoutObject}->Block(
                Name => 'Keywords',
                Data => {
                    Keyword => $Keyword,
                },
            );
        }
    }

    # output rating stars
    $Self->{LayoutObject}->FAQRatingStarsShow(
        VoteResult => $FAQData{VoteResult},
        Votes      => $FAQData{Votes},
    );

    # output attachments if any
    my @AttachmentIndex = $Self->{FAQObject}->AttachmentIndex(
        ItemID     => $GetParam{ItemID},
        ShowInline => 0,
        UserID     => $Self->{UserID},
    );

    # output attachments
    if (@AttachmentIndex) {
        $Self->{LayoutObject}->Block(
            Name => 'AttachmentHeader',
        );
        for my $Attachment (@AttachmentIndex) {
            $Self->{LayoutObject}->Block(
                Name => 'AttachmentRow',
                Data => {
                    %FAQData,
                    %{$Attachment},
                },
            );
        }
    }

    # show FAQ Content
    $Self->{LayoutObject}->FAQContentShow(
        FAQObject       => $Self->{FAQObject},
        InterfaceStates => $Self->{InterfaceStates},
        FAQData         => {%FAQData},
    );

    # show FAQ Voting
    # check config
    my $ShowVotingConfig = $Self->{ConfigObject}->Get('FAQ::Item::Voting::Show');
    if ( $ShowVotingConfig->{ $Self->{Interface}->{Name} } ) {

        # check if the user already voted after last change
        if ( !$AlreadyVoted ) {
            $Self->_FAQVoting( FAQData => {%FAQData} );
        }
    }

    # log access to this FAQ item
    $Self->{FAQObject}->FAQLogAdd(
        ItemID => $Self->{ParamObject}->GetParam( Param => 'ItemID' ),
        Interface => $Self->{Interface}->{Name},
        UserID    => $Self->{UserID},
    );

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'CustomerFAQZoom',
        Data         => {},
    );

    # add footer
    $Output .= $Self->{LayoutObject}->CustomerFooter();

    return $Output;
}

sub _FAQVoting {
    my ( $Self, %Param ) = @_;

    my %FAQData = %{ $Param{FAQData} };

    my $SelectedRate = $Self->{ParamObject}->GetParam( Param => "SelectedRate" );

    my $RateClass = 'RateUnChecked';

    # ouput voting block
    $Self->{LayoutObject}->Block(
        Name => 'FAQVoting',
        Data => {%FAQData},
    );

    # get Voting rates setting
    my $VotingRates = $Self->{ConfigObject}->Get('FAQ::Item::Voting::Rates');
    for my $RateValue ( sort { $a <=> $b } keys %{$VotingRates} ) {

        # set css rate class Checked or UnChecked
        if ( defined $SelectedRate && int($SelectedRate) >= $RateValue ) {
            $RateClass = 'RateChecked';
        }
        else {
            $RateClass = 'RateUnChecked';
        }

        # create data strucure for output
        my %Data = (
            Value => $RateValue,
            Title => $VotingRates->{$RateValue},
        );

        # output vote rating row block
        $Self->{LayoutObject}->Block(
            Name => 'FAQVotingRateRow',
            Data => {
                %Data,
                ItemID    => $FAQData{ItemID},
                RateClass => $RateClass,
            },
        );
    }

    # output the submit button
    if ( defined $SelectedRate ) {
        $Self->{LayoutObject}->Block(
            Name => "FAQVotingSubmit",
            Data => { SelectedRate => $SelectedRate },
        );
    }
}

1;
