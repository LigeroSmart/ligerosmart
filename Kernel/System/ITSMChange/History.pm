# --
# Kernel/System/ITSMChange/History.pm - all change and workorder history functions
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: History.pm,v 1.2 2009-10-22 16:14:50 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange::History;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

=head1 NAME

Kernel::System::ITSMChange::History - all change and workorder history functions

=head1 SYNOPSIS

All history functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

# NOTE: Look at ITSMConfigurationManagement, but use new EventHandling Module
# (currently in ITSMCore, will be in OTRS 2.5 framework later)

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(DBObject ConfigObject EncodeObject LogObject MainObject TimeObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    # set default debug flag
    $Self->{Debug} ||= 0;

    # create additional objects
    # ...

    return $Self;
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

$Revision: 1.2 $ $Date: 2009-10-22 16:14:50 $

=cut
