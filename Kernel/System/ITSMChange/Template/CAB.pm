# --
# Kernel/System/ITSMChange/Template/CAB.pm - all template functions for CABs
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange::Template::CAB;

use strict;
use warnings;

use Kernel::System::ITSMChange;
use Kernel::System::Valid;

## nofilter(TidyAll::Plugin::OTRS::Perl::Dumper)
use Data::Dumper;

=head1 NAME

Kernel::System::ITSMChange::Template::CAB - all template functions for CAB

=head1 SYNOPSIS

All functions for CAB templates in ITSMChangeManagement.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::Main;
    use Kernel::System::Time;
    use Kernel::System::ITSMChange::Template::CAB;

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
    my $TemplateObject = Kernel::System::ITSMChange::Template::CAB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        TimeObject   => $TimeObject,
        MainObject   => $MainObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (
        qw(DBObject ConfigObject EncodeObject LogObject UserObject GroupObject MainObject TimeObject)
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    # set the debug flag
    $Self->{Debug} = $Param{Debug} || 0;

    # create additional objects
    $Self->{ValidObject}  = Kernel::System::Valid->new( %{$Self} );
    $Self->{ChangeObject} = Kernel::System::ITSMChange->new( %{$Self} );

    return $Self;
}

=item Serialize()

Serialize the CAB of a change. This is done with Data::Dumper. It returns
a serialized string of the datastructure. The CAB actions
are "wrapped" within a hashreference...

    my $TemplateString = $TemplateObject->Serialize(
        ChangeID => 1,
        UserID   => 1,
        Return   => 'HASH', # (optional) HASH|STRING default 'STRING'
    );

returns

    '{CABAdd => { CABCustomers => [ 'mm@localhost' ], ... }}'

If parameter C<Return> is set to C<HASH>, the Perl datastructure
is returned

    {
        CABAdd   => { ... },
        Children => [ ... ],
    }

=cut

sub Serialize {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(UserID ChangeID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # set default value for 'Return'
    $Param{Return} ||= 'STRING';

    # get CAB of the change
    my $Change = $Self->{ChangeObject}->ChangeGet(
        ChangeID => $Param{ChangeID},
        UserID   => $Param{UserID},
    );

    return if !$Change;

    # templates have to be an array reference;
    my $OriginalData = {
        CABAdd => {
            CABCustomers => $Change->{CABCustomers},
            CABAgents    => $Change->{CABAgents},
        },
    };

    if ( $Param{Return} eq 'HASH' ) {
        return $OriginalData;
    }

    # no indentation (saves space)
    local $Data::Dumper::Indent = 0;

    # do not use cross-referencing
    local $Data::Dumper::Deepcopy = 1;

    # serialize the data (do not use $VAR1, but $TemplateData for Dumper output)
    my $SerializedData = $Self->{MainObject}->Dump( $OriginalData, 'binary' );

    return $SerializedData;
}

=item DeSerialize()

Updates the CAB of a change based on the given CAB template. It
returns the change id the cab is for.

    my $ChangeID = $TemplateObject->DeSerialize(
        Data => {
            CABCustomers => [ 'mm@localhost' ],
            CABAgents    => [ 1, 2 ],
        },
        ChangeID => 1,
        UserID   => 1,
    );

=cut

sub DeSerialize {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(UserID ChangeID Data)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get current CAB of change
    my $Change = $Self->{ChangeObject}->ChangeGet(
        ChangeID => $Param{ChangeID},
        UserID   => $Param{UserID},
    );

    # a CAB add is actually a CAB update on a change
    return if !$Self->{ChangeObject}->ChangeCABUpdate(
        ChangeID     => $Param{ChangeID},
        CABCustomers => [ @{ $Param{Data}->{CABCustomers} }, @{ $Change->{CABCustomers} } ],
        CABAgents    => [ @{ $Param{Data}->{CABAgents} }, @{ $Change->{CABAgents} } ],
        UserID       => $Param{UserID},
    );

    my %Info = (
        ID       => $Param{ChangeID},
        ChangeID => $Param{ChangeID},
    );

    return %Info;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
