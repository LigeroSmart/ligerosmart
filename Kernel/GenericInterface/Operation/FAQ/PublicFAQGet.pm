# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::GenericInterface::Operation::FAQ::PublicFAQGet;

use strict;
use warnings;

use MIME::Base64;
use Kernel::System::VariableCheck qw(IsArrayRefWithData IsHashRefWithData IsStringWithData);

use parent qw(
    Kernel::GenericInterface::Operation::Common
);

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::GenericInterface::Operation::FAQ::PublicFAQGet - GenericInterface FAQ PublicFAQGet Operation backend

=head1 PUBLIC INTERFACE

=head2 new()

usually, you want to create an instance of this
by using Kernel::GenericInterface::Operation->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    for my $Needed (qw( DebuggerObject WebserviceID )) {
        if ( !$Param{$Needed} ) {

            return {
                Success      => 0,
                ErrorMessage => "Got no $Needed!"
            };
        }

        $Self->{$Needed} = $Param{$Needed};
    }

    return $Self;
}

=head2 Run()

perform PublicFAQGet Operation. This will return a Public FAQ entry.

    my $Result = $OperationObject->Run(
        Data => {
            ItemID = '32,33',
            GetAttachmentContents = 1,                    # 0|1, defaults to 1
        },
    );

    $Result = {
        Success      => 1,                                # 0 or 1
        ErrorMessage => '',                               # In case of an error
        Data         => {                                 # result data payload after Operation
            ItemID => [
                {
                    ID                => 32,
                    ItemID            => 32,
                    FAQID             => 32,
                    Number            => 100032,
                    CategoryID        => '2',
                    CategoryName     => 'CategoryA::CategoryB',
                    CategoryShortName => 'CategoryB',
                    LanguageID        => 1,
                    Language          => 'en',
                    Title             => 'Article Title',
                    Field1            => 'The Symptoms',
                    Field2            => 'The Problem',
                    Field3            => 'The Solution',
                    Field4            => undef,                          # Not active by default
                    Field5            => undef,                          # Not active by default
                    Field6            => 'Comments',
                    Approved          => 1,                              # or 0
                    Keywords          => 'KeyWord1 KeyWord2',
                    Votes             => 0,                              # number of votes
                    VoteResult        => '0.00',                         # a number between 0.00 and 100.00
                    StateID           => 1,
                    State             => 'internal (agent)',             # or 'external (customer)' or
                                                                         # 'public (all)'
                    StateTypeID       => 1,
                    StateTypeName     => 'internal',                     # or 'external' or 'public'
                    CreatedBy         => 1,
                    Changed           => '2011-01-05 21:53:50',
                    ChangedBy         => '1',
                    Created           => '2011-01-05 21:53:50',
                    Name              => '1294286030-31.1697297104732',  # FAQ Article name or
                                                                         # systemtime + '-' + random number
                    ContentType       => 'text/html',
                    Attachment => {
                        {
                            Filesize    => '540286',                # file size in bytes
                            ContentType => 'image/jpeg',
                            Filename    => 'Error.jpg',
                            Content     => '...',                   # base64 content
                            Inline      => 0,                       # specify if is an inline attachment
                            FileID      => 34                       # FileID for relation with rich text content
                        },
                        {
                            Filesize    => '540286',                # file size in bytes
                            ContentType => 'image/jpeg',
                            Filename    => 'Pencil.jpg',
                            Content     => '...',                   # base64 content
                            Inline      => 1,                       # specify if is an inline attachment
                            FileID      => 35                       # FileID for relation with rich text content
                        },
                    },
                },
                {
                    ID                => 33,
                    ItemID            => 33,
                    FAQID             => 33,
                    Number            => 100033,
                    CategoryID        => '3',
                    CategoryName     => 'CategoryD::CategoryE',
                    CategoryShortName => 'CategoryE',
                    LanguageID        => 1,
                    Language          => 'en',
                    Title             => 'Article Title',
                    Field1            => 'The Symptoms',
                    Field2            => 'The Problem',
                    Field3            => 'The Solution',
                    Field4            => undef,                          # Not active by default
                    Field5            => undef,                          # Not active by default
                    Field6            => 'Comments',
                    Approved          => 1,                              # or 0
                    Keywords          => 'KeyWord1 KeyWord2',
                    Votes             => 0,                              # number of votes
                    VoteResult        => '0.00',                         # a number between 0.00 and 100.00
                    StateID           => 1,
                    State             => 'internal (agent)',             # or 'external (customer)' or
                                                                         # 'public (all)'
                    StateTypeID       => 1,
                    StateTypeName     => 'internal',                     # or 'external' or 'public'
                    CreatedBy         => 1,
                    Changed          => '2011-01-05 21:53:50',
                    ChangedBy         => '1',
                    Created           => '2011-01-05 21:53:50',
                    Name              => '1294286030-31.1697297104732',  # FAQ Article name or
                                                                         # systemtime + '-' + random number
                },
                # ...
            ],
        },
    };

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    if ( !$Param{Data}->{ItemID} ) {

        return $Self->ReturnError(
            ErrorCode    => 'PublicFAQGet.MissingParameter',
            ErrorMessage => "PublicFAQGet: Got no ItemID!",
        );
    }
    if ( !defined( $Param{Data}->{GetAttachmentContents} ) ) {
        $Param{Data}->{GetAttachmentContents} = 1;
    }

    my $ErrorMessage = '';

    my $ReturnData = {
        Success => 1,
    };

    my @ItemIDs = split( /,/, $Param{Data}->{ItemID} );
    my @Item;

    # Set UserID to root because in public interface there is no user.
    my $UserID = 1;

    my $FAQObject    = $Kernel::OM->Get('Kernel::System::FAQ');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # Get public state types.
    my $InterfaceStates = $FAQObject->StateTypeList(
        Types  => $ConfigObject->Get('FAQ::Public::StateTypes'),
        UserID => $UserID,
    );

    for my $ItemID (@ItemIDs) {

        my %FAQEntry = $FAQObject->FAQGet(
            ItemID     => $ItemID,
            ItemFields => 1,
            UserID     => $UserID,
        );

        if ( !IsHashRefWithData( \%FAQEntry ) ) {

            $ErrorMessage = 'Could not get FAQ data'
                . ' in Kernel::GenericInterface::Operation::FAQ::PublicFAQGet::Run()';

            return $Self->ReturnError(
                ErrorCode    => 'PublicFAQGet.NotValidFAQID',
                ErrorMessage => "PublicFAQGet: $ErrorMessage",
            );
        }

        # Check permissions.
        my $ApprovalSuccess = 1;
        if ( $ConfigObject->Get('FAQ::ApprovalRequired') ) {
            $ApprovalSuccess = $FAQEntry{Approved};
        }
        if ( !$ApprovalSuccess || !$InterfaceStates->{ $FAQEntry{StateTypeID} } ) {

            $ErrorMessage = 'Could not get FAQ data'
                . ' in Kernel::GenericInterface::Operation::FAQ::PublicFAQGet::Run()';

            return $Self->ReturnError(
                ErrorCode    => 'PublicFAQGet.AccessDenied',
                ErrorMessage => "PublicFAQGet: $ErrorMessage",
            );
        }

        my @Index = $FAQObject->AttachmentIndex(
            ItemID     => $ItemID,
            ShowInline => 1,         #   ( 0|1, default 1)
            UserID     => $UserID,
        );

        my %File;
        if ( IsArrayRefWithData( \@Index ) ) {

            my @Attachments;
            for my $Attachment (@Index) {

                if ( $Param{Data}->{GetAttachmentContents} ) {
                    %File = $FAQObject->AttachmentGet(
                        ItemID => $ItemID,
                        FileID => $Attachment->{FileID},
                        UserID => $UserID,
                    );

                    # Convert content to base64.
                    $File{Content} = encode_base64( $File{Content} );
                    $File{Inline}  = $Attachment->{Inline};
                    $File{FileID}  = $Attachment->{FileID};
                }
                else {
                    %File = (
                        Filename    => $Attachment->{Filename},
                        ContentType => $Attachment->{ContentType},
                        Filesize    => $Attachment->{Filesize},
                        Content     => '',
                        Inline      => $Attachment->{Inline},
                        FileID      => $Attachment->{FileID}
                    );
                }
                push @Attachments, {%File};
            }

            # Set FAQ entry data.
            $FAQEntry{Attachment} = \@Attachments;
        }

        push @Item, \%FAQEntry;
    }

    if ( !scalar @Item ) {
        $ErrorMessage = 'Could not get FAQ data'
            . ' in Kernel::GenericInterface::Operation::FAQ::PublicFAQGet::Run()';

        return $Self->ReturnError(
            ErrorCode    => 'PublicFAQGet.NoFAQData',
            ErrorMessage => "PublicFAQGet: $ErrorMessage",
        );

    }

    $ReturnData->{Data}->{FAQItem} = \@Item;

    return $ReturnData;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
