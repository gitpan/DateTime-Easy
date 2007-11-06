package DateTime::Easy;

use warnings;
use strict;

=head1 NAME

DateTime::Easy - Quickly and easily create a DateTime object (by parsing almost anything)

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

    # Make DateTime object for "now":
    my $dt = DateTime::Easy->new("today");

    # Same thing:
    my $dt = DateTime::Easy->new("now");

    # Uses Date::Manip's coolness:
    my $dt = DateTime::Easy->new("this month");

    # ... but in 1969:
    my $dt = DateTime::Easy->new("this month", year => 1969);

    # ... at the 100th nanosecond:
    my $dt = DateTime::Easy->new("this month", year => 1969, nanosecond => 100);

    # ... in EST: (This will NOT do a timezone conversion)
    my $dt = DateTime::Easy->new("last monday", year => 1969, nanosecond => 100, timezone => "US/Eastern");
    ok($dt);

    # This WILL do a proper timezone conversion:
    my $dt = DateTime::Easy->new("last monday", year => 1969, nanosecond => 100, timezone => "US/Pacific");
    $dt->set_time_zone("US/Eastern");

=head1 DESCRIPTION

DateTime::Easy makes DateTime object creation quick and easy. It uses Date::Manip::ParseDate to parse almost anything you can throw at it.

=head1 METHODS

=head2 DateTime::Easy->new( ... )

=head2 DateTime::Easy->parse( ... )

Parse the given date/time specification using Date::Manip::ParseDate and use the result to create a DateTime object. Returns a L<DateTime> object.
Any timezone information from Date::Manip is ignored. To specify an explicit timezone, pass a timezone parameter through.

You can pass the following in:

    parse       # The string for DateManip to parse via ParseDate
    year        # A year to override the result of parsing
    month       # A month to override the result of parsing
    day         # A day to override the result of parsing
    hour        # A hour to override the result of parsing
    minute      # A minute to override the result of parsing
    second      # A second to override the result of parsing
    truncate    # A truncation parameter (e.g. year, day, month, week, etc.)

    ... and anything else that you want to pass to the DateTime->new constructor

If C<truncate> is specificied, then DateTime->truncate will be run after object creation.

Furthermore, you can simply pass the value for "parse" as the first positional argument of the DateTime::Easy call, e.g.:

    # This:
    DateTime::Easy->new("today", year => 2008, truncate => "hour");

    # ...is the same as this:
    DateTime::Easy->new(parse => "today", year => 2008, truncate => "hour");

=head1 EXPORT

=head2 parse( ... )

Same syntax as above. See above for more information.

=head1 MOTIVATION

Although I really like using DateTime for date/time handling, I was often frustrated by its inability to parse even the simplest of date/time strings.
There does exist a wide variety of DateTime::Format::* modules, but they all have different interfaces and different capabilities.
Coming from a Date::Manip background, I wanted something that gave me the power of ParseDate while still retaining control over DateTime's new constructor.
Most importantly, I wanted explicit control of the timezone setting at every step of the way. DateTime::Easy is the result.

=head1 SEE ALSO

L<DateTime>, L<Date::Manip>

=head1 AUTHOR

Robert Krimen, C<< <rkrimen at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-datetime-easy at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=DateTime-Easy>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc DateTime::Easy


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=DateTime-Easy>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/DateTime-Easy>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/DateTime-Easy>

=item * Search CPAN

L<http://search.cpan.org/dist/DateTime-Easy>

=back

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2007 Robert Krimen, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

use base qw/Exporter/;
our @EXPORT_OK = qw/parse/;

use Date::Manip qw/ParseDate UnixDate/;
use DateTime;

sub parse {
    shift if $_[0] && $_[0] eq __PACKAGE__;

    my $parse;
    $parse = shift if @_ % 2;

    my %in = @_;
    $parse = delete $in{parse} if exists $in{parse};
    my $truncate = delete $in{truncate};

    my %DateTime;
    if ($parse) {
        return unless $parse = UnixDate($parse, '%Y %m %d %H %M %S');
        @DateTime{qw/year month day hour minute second/} = split m/\s+/, $parse; 
    }
    $DateTime{time_zone} = delete $in{timezone} if exists $in{timezone};
    @DateTime{keys %in} = values %in;
    return unless my $dt = DateTime->new(%DateTime);
    if ($truncate) {
        $truncate = $truncate->[1] if ref $truncate eq "ARRAY";
        $truncate = (values %$truncate)[0] if ref $truncate eq "HASH";
        $dt->truncate(to => $truncate);
    }

    return $dt;
}
*new = \&parse;

1; # End of DateTime::Easy
