# --
# Kernel/System/LinkObject/FAQ.pm - to link faq objects
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::LinkObject::FAQ;

use strict;
use warnings;

use Kernel::System::Group;
use Kernel::System::FAQ;

=head1 NAME

Kernel::System::LinkObject::FAQ

=head1 SYNOPSIS

FAQ backend for the link object.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Time;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::LinkObject::FAQ;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $FAQObjectBackend = Kernel::System::LinkObject::FAQ->new(
        ConfigObject       => $ConfigObject,
        LogObject          => $LogObject,
        DBObject           => $DBObject,
        MainObject         => $MainObject,
        TimeObject         => $TimeObject,
        EncodeObject       => $EncodeObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(DBObject ConfigObject LogObject MainObject EncodeObject TimeObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    # create additional objects
    $Self->{GroupObject} = Kernel::System::Group->new( %{$Self} );
    $Self->{FAQObject}   = Kernel::System::FAQ->new( %{$Self} );

    return $Self;
}

=item LinkListWithData()

fill up the link list with data

    $Success = $FAQLinkObject->LinkListWithData(
        LinkList => $HashRef,
        UserID   => 1,
    );

=cut

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

    for my $LinkType ( sort keys %{ $Param{LinkList} } ) {

        for my $Direction ( sort keys %{ $Param{LinkList}->{$LinkType} } ) {

            FAQID:
            for my $FAQID ( sort keys %{ $Param{LinkList}->{$LinkType}->{$Direction} } ) {

                # get faq data
                my %FAQData = $Self->{FAQObject}->FAQGet(
                    ItemID     => $FAQID,
                    ItemFields => 1,
                    UserID     => $Param{UserID},
                );

                # remove id from hash if no faq data was found
                if ( !%FAQData ) {
                    delete $Param{LinkList}->{$LinkType}->{$Direction}->{$FAQID};
                    next FAQID;
                }

                # add faq data
                $Param{LinkList}->{$LinkType}->{$Direction}->{$FAQID} = \%FAQData;
            }
        }
    }

    return 1;
}

=item ObjectPermission()

checks read permission for a given object and UserID.

    $Permission = $FAQLinkObject->ObjectPermission(
        Object  => 'FAQ',
        Key     => 123,
        UserID  => 1,
    );

=cut

sub ObjectPermission {
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

    # check module registry of AgentFAQZoom
    my $ModuleReg = $Self->{ConfigObject}->Get('Frontend::Module')->{AgentFAQZoom};

    # do not grant access if frontend module is not registered
    return if !$ModuleReg;

    # grant access if module permisson has no Group or GroupRo defined
    if ( !$ModuleReg->{GroupRo} && !$ModuleReg->{Group} ) {
        return 1;
    }

    PERMISSION:
    for my $Permission (qw(GroupRo Group)) {

        next PERMISSION if !$ModuleReg->{$Permission};
        next PERMISSION if ref $ModuleReg->{$Permission} ne 'ARRAY';

        for my $Group ( @{ $ModuleReg->{$Permission} } ) {

            # get the group id
            my $GroupID = $Self->{GroupObject}->GroupLookup( Group => $Group );

            my $Type;
            if ( $Permission eq 'GroupRo' ) {
                $Type = 'ro';
            }
            elsif ( $Permission eq 'Group' ) {
                $Type = 'rw';
            }

            # get user groups, where the user has the appropriate privilege
            my %Groups = $Self->{GroupObject}->GroupMemberList(
                UserID => $Param{UserID},
                Type   => $Type,
                Result => 'HASH',
            );

            # grant access if agent is a member in the group
            return 1 if $Groups{$GroupID};
        }
    }

    return;
}

=item ObjectDescriptionGet()

return a hash of object descriptions

Return
    %Description = (
        Normal => "FAQ# 1234",
        Long   => "FAQ# 1234: FAQTitle",
    );

    %Description = $LinkObject->ObjectDescriptionGet(
        Key     => 123,
        UserID  => 1,
    );

=cut

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

    # create description
    my %Description = (
        Normal => 'FAQ',
        Long   => 'FAQ',
    );

    return %Description if $Param{Mode} && $Param{Mode} eq 'Temporary';

    # get faq
    my %FAQ = $Self->{FAQObject}->FAQGet(
        ItemID     => $Param{Key},
        ItemFields => 1,
        UserID     => $Param{UserID},
    );

    return if !%FAQ;

    # define description text
    my $FAQHook         = $Self->{ConfigObject}->Get('FAQ::FAQHook');
    my $DescriptionText = "$FAQHook $FAQ{Number}";

    # create description
    %Description = (
        Normal => $DescriptionText,
        Long   => "$DescriptionText: $FAQ{Title}",
    );

    return %Description;
}

=item ObjectSearch()

return a hash list of the search results

Return
    $SearchList = {
        NOTLINKED => {
            Source => {
                12  => $DataOfItem12,
                212 => $DataOfItem212,
                332 => $DataOfItem332,
            },
        },
    };

    $SearchList = $LinkObjectBackend->ObjectSearch(
        SearchParams => $HashRef,  # (optional)
        UserID       => 1,
    );

=cut

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

    # add wildcards
    my %Search;
    if ( $Param{SearchParams}->{Title} ) {
        $Search{Title} = '*' . $Param{SearchParams}->{Title} . '*';
    }
    if ( $Param{SearchParams}->{Number} ) {
        $Search{Number} = '*' . $Param{SearchParams}->{Number} . '*';
    }
    if ( $Param{SearchParams}->{What} ) {
        $Search{What} = '*' . $Param{SearchParams}->{What} . '*';
    }

    # search the faqs
    my @FAQIDs = $Self->{FAQObject}->FAQSearch(
        %{ $Param{SearchParams} },
        %Search,
        Order  => 'Created',
        Sort   => 'down',
        Limit  => 50,
        UserID => $Param{UserID},
    );

    my %SearchList;
    FAQID:
    for my $FAQID (@FAQIDs) {

        # get FAQ data
        my %FAQData = $Self->{FAQObject}->FAQGet(
            ItemID     => $FAQID,
            ItemFields => 1,
            UserID     => $Param{UserID},
        );

        next FAQID if !%FAQData;

        # add FAQ data
        $SearchList{NOTLINKED}->{Source}->{$FAQID} = \%FAQData;
    }

    return \%SearchList;
}

=item LinkAddPre()

link add pre event module

    $True = $FAQLinkObject->LinkAddPre(
        Key          => 123,
        SourceObject => 'FAQ',
        SourceKey    => 321,
        Type         => 'Normal',
        State        => 'Valid',
        UserID       => 1,
    );

    or

    $True = $FAQLinkObject->LinkAddPre(
        Key          => 123,
        TargetObject => 'FAQ',
        TargetKey    => 321,
        Type         => 'Normal',
        State        => 'Valid',
        UserID       => 1,
    );

=cut

sub LinkAddPre {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Key Type State UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    return 1 if $Param{State} eq 'Temporary';

    return 1;
}

=item LinkAddPost()

link add pre event module

    $True = $FAQLinkObject->LinkAddPost(
        Key          => 123,
        SourceObject => 'FAQ',
        SourceKey    => 321,
        Type         => 'Normal',
        State        => 'Valid',
        UserID       => 1,
    );

    or

    $True = $FAQLinkObject->LinkAddPost(
        Key          => 123,
        TargetObject => 'FAQ',
        TargetKey    => 321,
        Type         => 'Normal',
        State        => 'Valid',
        UserID       => 1,
    );

=cut

sub LinkAddPost {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Key Type State UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    return 1 if $Param{State} eq 'Temporary';

    return 1;
}

=item LinkDeletePre()

link delete pre event module

    $True = $FAQLinkObject->LinkDeletePre(
        Key          => 123,
        SourceObject => 'FAQ',
        SourceKey    => 321,
        Type         => 'Normal',
        State        => 'Valid',
        UserID       => 1,
    );

    or

    $True = $FAQLinkObject->LinkDeletePre(
        Key          => 123,
        TargetObject => 'FAQ',
        TargetKey    => 321,
        Type         => 'Normal',
        State        => 'Valid',
        UserID       => 1,
    );

=cut

sub LinkDeletePre {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Key Type State UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    return 1 if $Param{State} eq 'Temporary';

    return 1;
}

=item LinkDeletePost()

link delete post event module

    $True = $FAQLinkObject->LinkDeletePost(
        Key          => 123,
        SourceObject => 'FAQ',
        SourceKey    => 321,
        Type         => 'Normal',
        State        => 'Valid',
        UserID       => 1,
    );

    or

    $True = $FAQLinkObject->LinkDeletePost(
        Key          => 123,
        TargetObject => 'FAQ',
        TargetKey    => 321,
        Type         => 'Normal',
        State        => 'Valid',
        UserID       => 1,
    );

=cut

sub LinkDeletePost {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Key Type State UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    return 1 if $Param{State} eq 'Temporary';

    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
