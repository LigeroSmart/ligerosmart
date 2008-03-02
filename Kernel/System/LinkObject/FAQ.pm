# --
# Kernel/System/LinkObject/FAQ.pm - to link faq objects
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: FAQ.pm,v 1.4 2008-03-02 23:00:44 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::LinkObject::FAQ;

use strict;
use Kernel::System::FAQ;

use vars qw($VERSION);
$VERSION = '$Revision: 1.4 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub Init {
    my $Self = shift;
    my %Param = @_;

    $Self->{FAQObject} = Kernel::System::FAQ->new(%{$Self});

    return 1;
}

sub FillDataMap {
    my $Self = shift;
    my %Param = @_;
    foreach (qw(ID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    my %Article = $Self->{FAQObject}->FAQGet(
        FAQID => $Param{ID},
    );
    return (
        Text => 'F:'.$Article{Number},
        Number => $Article{Number},
        Title  => $Article{Title},
        ID => $Param{ID},
        Object => 'FAQ',
        FrontendDest => "Action=AgentFAQ&ItemID=",
    );
}

sub BackendLinkObject {
    my $Self = shift;
    my %Param = @_;
    return 1;
}

sub BackendUnlinkObject {
    my $Self = shift;
    my %Param = @_;
    return 1;
}

sub LinkSearchParams {
    my $Self = shift;
    my %Param = @_;
    return (
        { Name => 'FAQNumber', Text => 'FAQ#'},
        { Name => 'FAQTitle', Text => 'Title'},
        { Name => 'FAQFulltext', Text => 'Fulltext'},
    );
}

sub LinkSearch {
    my $Self = shift;
    my %Param = @_;
    my @ResultWithData = ();
    my @Result = $Self->{FAQObject}->FAQSearch(
        Number => $Param{FAQNumber},
        Title => $Param{FAQTitle},
        What => $Param{FAQFulltext},
    );
    foreach (@Result) {
        my %Article = $Self->{FAQObject}->FAQGet(FAQID => $_);
        push (@ResultWithData,
            {
                %Article,
                ID => $Article{ItemID},
            },
        );
    }
    return @ResultWithData;
}

sub LinkItemData {
    my $Self = shift;
    my %Param = @_;
    my %Article = $Self->{FAQObject}->FAQGet(
        ItemID => $Param{ID},
    );

    my $Body = '';
    foreach (1..10) {
        if ($Article{"Field$_"}) {
            $Body .= $Article{"Field$_"};
        }
    }

    return (
        %Article,
        ID => $Article{ItemID},
        Body => $Body,
        DetailLink => "Action=AgentFAQ&ItemID=$Param{ID}",
    );
}

1;
