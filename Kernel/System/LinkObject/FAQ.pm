# --
# Kernel/System/LinkObject/FAQ.pm - to link faq objects
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: FAQ.pm,v 1.6 2008-06-25 19:56:38 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::LinkObject::FAQ;

use strict;
use warnings;

use Kernel::System::FAQ;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.6 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(DBObject ConfigObject LogObject MainObject TimeObject LinkObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    $Self->{UserID} = 1;
    $Self->{FAQObject} = Kernel::System::FAQ->new( %{$Self} );

    return $Self;
}

sub LinkListWithData {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(LinkList UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # check link list
    if ( ref $Param{LinkList} ne 'HASH' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'LinkList must be a hash reference!',
        );
        return;
    }

    for my $LinkType ( keys %{ $Param{LinkList} } ) {

        for my $Direction ( keys %{ $Param{LinkList}->{$LinkType} } ) {

            for my $FAQID ( keys %{ $Param{LinkList}->{$LinkType}->{$Direction} } ) {

                # get faq data
                my %Data = $Self->{FAQObject}->FAQGet(
                    FAQID  => $FAQID,
                    UserID => $Param{UserID},
                );

                # remove id from hash if faq can not get
                if ( !%Data ) {
                    delete $Param{LinkList}->{$LinkType}->{$Direction}->{$FAQID};
                    next;
                }

                # add faq data
                $Param{LinkList}->{$LinkType}->{$Direction}->{$FAQID} = \%Data;
            }
        }
    }

    return 1;
}

sub ObjectDescriptionGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Object Key UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get faq
    my %FAQ = $Self->{FAQObject}->FAQGet(
        FAQID  => $Param{Key},
        UserID => 1,
    );

    return if !%FAQ;

    # create description
    my %Description = (
        Normal => "FAQ# $FAQ{Number}",
        Long   => "FAQ# $FAQ{Number}: $FAQ{Name}",
    );

    return %Description;
}

sub ObjectSearch {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );
        return;
    }

    # set default params
    $Param{SearchParams} ||= {};

    # set focus
    if ( $Param{SearchParams}->{Title} ) {
        $Param{SearchParams}->{Title} = '*' . $Param{SearchParams}->{Title} . '*';
    }
    if ( $Param{SearchParams}->{Number} ) {
        $Param{SearchParams}->{Number} = '*' . $Param{SearchParams}->{Number} . '*';
    }

    if ( $Param{SearchParams}->{What} ) {
        $Param{SearchParams}->{What} = '*' . $Param{SearchParams}->{What} . '*';
    }

    # search the faqs
    my @FAQIDs = $Self->{FAQObject}->FAQSearch(
        %{ $Param{SearchParams} },
        Order => 'Created',
        Sort  => 'down',
        Limit => 60,
    );

    my %SearchList;
    for my $FAQID (@FAQIDs) {

        # get ticket data
        my %Data = $Self->{FAQObject}->FAQGet(
            FAQID  => $FAQID,
            UserID => $Param{UserID},
        );

        next if !%Data;

        # add ticket data
        $SearchList{NOTLINKED}->{Source}->{$FAQID} = \%Data;
    }

    return \%SearchList;
}

sub LinkAddPre {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Key Type UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    return 1;
}

sub LinkAddPost {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Key Type UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    return 1;
}

sub LinkDeletePre {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Key Type UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    return 1;
}

sub LinkDeletePost {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Key Type UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    return 1;
}

1;
