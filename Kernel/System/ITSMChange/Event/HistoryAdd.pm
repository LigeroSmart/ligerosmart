# --
# Kernel/System/ITSMChange/Event/HistoryAdd.pm - HistoryAdd event module for ITSMChange
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: HistoryAdd.pm,v 1.6 2009-11-03 13:28:06 reb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange::Event::HistoryAdd;

use strict;
use warnings;

use Kernel::System::ITSMChange::History;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.6 $) [1];

=head1 NAME

Kernel::System::ITSMChange::Event::HistoryAdd - ITSMChange history add lib

=head1 SYNOPSIS

Event handler module for history add in ITSMChange.

=head1 PUBLIC INTERFACE

=over 4

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::Main;
    use Kernel::System::Time;
    use Kernel::System::ITSMChange;
    use Kernel::System::ITSMChange::Event::HistoryAdd;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $ChangeObject = Kernel::System::ITSMChange->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        TimeObject   => $TimeObject,
        MainObject   => $MainObject,
    );
    my $HistoryObject = Kernel::System::ITSMChange::Event::HistoryAdd->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        TimeObject   => $TimeObject,
        MainObject   => $MainObject,
        ChangeObject => $ChangeObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(DBObject ConfigObject EncodeObject LogObject MainObject TimeObject ChangeObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # create additional objects
    $Self->{HistoryObject} = Kernel::System::ITSMChange::History->new( %{$Self} );

    return $Self;
}

=item Run()

The C<Run()> method handles the events and adds/deletes the history entries for
the given change object.

It returns 1 on success, C<undef> otherwise.

    my $Success = $HistoryObject->Run(
        ChangeID => 123,
        Data     => {
            ChangeID => 123,
            ChangeTitle => 'test',
        },
        Config => ...
    );

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(ChangeID Event Config)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # in history we use Event name without 'Post'
    $Param{Event} =~ s/Post$//;

    # do history stuff
    if ( $Param{Event} eq 'ChangeAdd' ) {

        # tell history that a change was added
        $Self->{HistoryObject}->HistoryAdd(
            HistoryType => $Param{Event},
            ChangeID    => $Param{Data}->{ChangeID},
            UserID      => $Param{Data}->{UserID},
            ContentNew  => $Param{Data}->{ChangeID},
        );
    }
    if ( $Param{Event} eq 'ChangeUpdate' ) {

        # get old data
        my $OldData = delete $Param{Data}->{OldChangeData};

        FIELD:
        for my $Field ( keys %{ $Param{Data} } ) {

            # we do not track the user id
            next FIELD if $Field eq 'UserID';

            # check if field has changed
            my $FieldHasChanged = $Self->HasFieldChanged(
                New => $Param{Data}->{$Field},
                Old => $OldData->{$Field},
            );

            # save history if field changed
            if ($FieldHasChanged) {
                $Self->{HistoryObject}->HistoryAdd(
                    ChangeID    => $Param{Data}->{ChangeID},
                    Field       => $Field,
                    ContentNew  => $Param{Data}->{$Field},
                    ContentOld  => $OldData->{$Field},
                    UserID      => $Param{Data}->{UserID},
                    HistoryType => $Param{Event},
                );
            }
        }
    }
    elsif ( $Param{Event} eq 'ChangeDelete' ) {

        # delete history of change
        $Self->{HistoryObject}->ChangeHistoryDelete(
            ChangeID => $Param{Data}->{ChangeID},
            UserID   => $Param{Data}->{UserID},
        );
    }

    # handle ChangeCAB events
    elsif ( $Param{Event} eq 'ChangeCABUpdate' || $Param{Event} eq 'ChangeCABDelete' ) {

        # get old data
        my $OldData = delete $Param{Data}->{OldChangeCABData};

        FIELD:
        for my $Field (qw(CABAgents CABCustomers)) {

            # we do not track the user id
            next FIELD if !$Param{$Field};

            # check if field has changed
            my $FieldHasChanged = $Self->HasFieldChanged(
                New => $Param{Data}->{$Field},
                Old => $OldData->{$Field},
            );

            # save history if field changed
            if ($FieldHasChanged) {
                $Self->{HistoryObject}->HistoryAdd(
                    ChangeID    => $Param{Data}->{ChangeID},
                    Field       => $Field,
                    ContentNew  => join( '::', @{ $Param{Data}->{$Field} } ),
                    ContentOld  => join( '::', @{ $OldData->{$Field} } ),
                    UserID      => $Param{Data}->{UserID},
                    HistoryType => $Param{Event},
                );
            }
        }
    }

    # error
    else {

        # a non-known event
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "$Param{Event} is a non-known event!",
        );
    }

    return 1;
}

=item HasFieldChanged()

This method checks whether a field was changed or not. It returns 1 when field
was changed, 0 otherwise

    my $FieldHasChanged = $HistoryObject->HasFieldChanged(
        Old => 'old value', # can be array reference or hash reference as well
        New => 'new value', # can be array reference or hash reference as well
    );

=cut

sub HasFieldChanged {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(New Old)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # return result of 'eq' when both params are scalars
    return $Param{New} ne $Param{Old} if !ref( $Param{New} ) && !ref( $Param{Old} );

    # a field has changed when 'ref' is different
    return 1 if ref( $Param{New} ) ne ref( $Param{Old} );

    # check hashes
    if ( 'HASH' eq ref $Param{New} ) {

        #field has changed when number of keys are different
        return 1 if scalar keys %{ $Param{New} } != scalar keys %{ $Param{Old} };

        # check the values for each key
        for my $Key ( keys %{ $Param{New} } ) {
            return 1 if $Param{New}->{$Key} ne $Param{Old}->{$Key};
        }
    }

    # check arrays
    if ( 'ARRAY' eq ref $Param{New} ) {

        # changed when number of elements differ
        return 1 if scalar @{ $Param{New} } != scalar @{ $Param{Old} };

        # check each element
        for my $Index ( 0 .. $#{ $Param{New} } ) {
            return 1 if $Param{New}->[$Index] ne $Param{Old}->[$Index];
        }
    }

    # field has not been changed
    return 0;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see http://www.gnu.org/licenses/agpl.txt.

=cut

=head1 VERSION

$Revision: 1.6 $ $Date: 2009-11-03 13:28:06 $

=cut
