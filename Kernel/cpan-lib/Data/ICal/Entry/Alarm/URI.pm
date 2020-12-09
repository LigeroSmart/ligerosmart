use warnings;
use strict;

package Data::ICal::Entry::Alarm::URI;

use base qw/Data::ICal::Entry::Alarm/;

=head1 NAME

Data::ICal::Entry::Alarm::URI - Represents notification via a custom URI

=head1 SYNOPSIS

    my $valarm = Data::ICal::Entry::Alarm::URI->new();
    $valarm->add_properties(
        uri => "sms:+15105550101?body=hello%20there",
        # Dat*e*::ICal is not a typo here
        trigger   => [ Date::ICal->new( epoch => ... )->ical, { value => 'DATE-TIME' } ],
    );

    $vevent->add_entry($valarm);

=head1 DESCRIPTION

A L<Data::ICal::Entry::Alarm::URI> object represents an alarm that
notifies via arbitrary URI which is attached to a todo item or event in
an iCalendar file.  (Note that the iCalendar RFC refers to entries as
"components".)  It is a subclass of L<Data::ICal::Entry::Alarm> and
accepts all of its methods.

This element is not included in the official iCal RFC, but is rather an
unaccepted draft standard; see
L<https://tools.ietf.org/html/draft-daboo-valarm-extensions-04#section-6>
B<Its interoperability and support is thus limited.> This is alarm type
is primarily used by Apple.

=head1 METHODS

=cut

=head2 new

Creates a new L<Data::ICal::Entry::Alarm::Alarm> object; sets its
C<ACTION> property to C<NONE>.

=cut

sub new {
    my $class = shift;
    my $self  = $class->SUPER::new(@_);
    $self->add_property( action => "URI" );
    return $self;
}

=head2 mandatory_unique_properties

In addition to C<action> and C<trigger> (see
L<Data::ICal::Entry::Alarm/mandatory_unique_properties>), uri alarms
must also specify a value for C<uri>.

=cut

sub mandatory_unique_properties {
    return (
        shift->SUPER::mandatory_unique_properties,
        "uri",
    );
}

=head1 AUTHOR

Best Practical Solutions, LLC E<lt>modules@bestpractical.comE<gt>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2005 - 2015, Best Practical Solutions, LLC.  All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=cut

1;
