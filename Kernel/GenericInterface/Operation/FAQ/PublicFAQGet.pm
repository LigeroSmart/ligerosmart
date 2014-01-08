# --
# Kernel/GenericInterface/Operation/FAQ/PublicFAQGet.pm - GenericInterface FAQ PublicFAQGet operation backend
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Operation::FAQ::PublicFAQGet;

use strict;
use warnings;

use MIME::Base64;
use Kernel::System::FAQ;
use Kernel::GenericInterface::Operation::Common;
use Kernel::System::VariableCheck qw(IsArrayRefWithData IsHashRefWithData IsStringWithData);

=head1 NAME

Kernel::GenericInterface::Operation::FAQ::PublicFAQGet - GenericInterface FAQ PublicFAQGet Operation backend

=head1 SYNOPSIS

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

usually, you want to create an instance of this
by using Kernel::GenericInterface::Operation->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (
        qw(DebuggerObject ConfigObject MainObject LogObject TimeObject DBObject EncodeObject WebserviceID)
        )
    {
        if ( !$Param{$Needed} ) {
            return {
                Success      => 0,
                ErrorMessage => "Got no $Needed!"
            };
        }

        $Self->{$Needed} = $Param{$Needed};
    }

    # create additional objects
    $Self->{FAQObject}    = Kernel::System::FAQ->new(%Param);
    $Self->{CommonObject} = Kernel::GenericInterface::Operation::Common->new( %{$Self} );

    # set UserID to root because in public interface there is no user
    $Self->{UserID} = 1;

    # get public state types
    $Self->{InterfaceStates} = $Self->{FAQObject}->StateTypeList(
        Types  => $Self->{ConfigObject}->Get('FAQ::Public::StateTypes'),
        UserID => $Self->{UserID},
    );

    return $Self;
}

=item Run()

perform PublicFAQGet Operation. This will return a Public FAQ entry.

    my $Result = $OperationObject->Run(
        Data => {
            ItemID = '32,33';
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
                    Changed          => '2011-01-05 21:53:50',
                    ChangedBy         => '1',
                    Created           => '2011-01-05 21:53:50',
                    Name              => '1294286030-31.1697297104732',  # FAQ Article name or
                                                                         # systemtime + '-' + random number
                    Attachment => {
                        {
                            Filesize    => '540286',                # file size in bytes
                            ContentType => 'image/jpeg',
                            Filename    => 'Error.jpg',
                            Content     => '...'                    # base64 content
                        },
                        {
                            Filesize    => '540286',                # file size in bytes
                            ContentType => 'image/jpeg',
                            Filename    => 'Pencil.jpg',
                            Content     => '...'                    # base64 content
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

        return $Self->{CommonObject}->ReturnError(
            ErrorCode    => 'PublicFAQGet.MissingParameter',
            ErrorMessage => "PublicFAQGet: Got no ItemID!",
        );
    }

    my $ErrorMessage = '';

    my $ReturnData = {
        Success => 1,
    };
    my @ItemIDs = split( /,/, $Param{Data}->{ItemID} );
    my @Item;

    # start main loop
    for my $ItemID (@ItemIDs) {

        # get the FAQ entry
        my %FAQEntry = $Self->{FAQObject}->FAQGet(
            ItemID     => $ItemID,
            ItemFields => 1,
            UserID     => $Self->{UserID},
        );

        if ( !IsHashRefWithData( \%FAQEntry ) ) {

            $ErrorMessage = 'Could not get FAQ data'
                . ' in Kernel::GenericInterface::Operation::FAQ::PublicFAQGet::Run()';

            return $Self->{CommonObject}->ReturnError(
                ErrorCode    => 'PublicFAQGet.NotValidFAQID',
                ErrorMessage => "PublicFAQGet: $ErrorMessage",
            );
        }

        # check permissions
        my $ApprovalSuccess = 1;
        if ( $Self->{ConfigObject}->Get('FAQ::ApprovalRequired') ) {
            $ApprovalSuccess = $FAQEntry{Approved};
        }
        if ( !$ApprovalSuccess || !$Self->{InterfaceStates}->{ $FAQEntry{StateTypeID} } ) {

            $ErrorMessage = 'Could not get FAQ data'
                . ' in Kernel::GenericInterface::Operation::FAQ::PublicFAQGet::Run()';

            return $Self->{CommonObject}->ReturnError(
                ErrorCode    => 'PublicFAQGet.AccessDenied',
                ErrorMessage => "PublicFAQGet: $ErrorMessage",
            );
        }

        # set FAQ entry data
        my $Article = {
            Article => \%FAQEntry,
        };

        my @Index = $Self->{FAQObject}->AttachmentIndex(
            ItemID     => $ItemID,
            ShowInline => 1,                 #   ( 0|1, default 1)
            UserID     => $Self->{UserID},
        );

        if ( IsArrayRefWithData( \@Index ) ) {
            my @Attachments;
            for my $Attachment (@Index) {
                my %File = $Self->{FAQObject}->AttachmentGet(
                    ItemID => $ItemID,
                    FileID => $Attachment->{FileID},
                    UserID => $Self->{UserID},
                );

                # convert content to base64
                $File{Content} = encode_base64( $File{Content} );
                push @Attachments, {%File};
            }

            # set FAQ entry data
            $FAQEntry{Attachment} = \@Attachments;
        }

        # add
        push @Item, \%FAQEntry;
    }    # finish main loop

    if ( !scalar @Item ) {
        $ErrorMessage = 'Could not get FAQ data'
            . ' in Kernel::GenericInterface::Operation::FAQ::PublicFAQGet::Run()';

        return $Self->{CommonObject}->ReturnError(
            ErrorCode    => 'PublicFAQGet.NoFAQData',
            ErrorMessage => "PublicFAQGet: $ErrorMessage",
        );

    }

    $ReturnData->{Data}->{FAQItem} = \@Item;

    # return result
    return $ReturnData;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
