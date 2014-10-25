#!perl

use strict;
use warnings;

use Test::More qw/no_plan/;
use DateTime::Easy;

my $dt;
$dt = DateTime::Easy->new("2007/01/01");
is($dt, "2007-01-01T00:00:00");

$dt = DateTime::Easy->parse("2007/01/01 23:22:01");
is($dt, "2007-01-01T23:22:01");

$dt = DateTime::Easy::parse("2007/01/01 10:22:01 PM");
is($dt, "2007-01-01T22:22:01");

$dt = DateTime::Easy::new("2007/02/01 10:22:01 PM", hour => 9);
is($dt, "2007-02-01T09:22:01");

$dt = DateTime::Easy->new("2007/01/04 10:22:01 PM", truncate => "year");
is($dt, "2007-01-01T00:00:00");

$dt = DateTime::Easy->new(year => 2007, parse => "2007/01/01 23:22:01", timezone => "US/Eastern");
is($dt, "2007-01-01T23:22:01");
$dt->set_time_zone("US/Pacific");
is($dt, "2007-01-01T20:22:01");

$dt = DateTime::Easy->new(parse => "2007/01/01 23:22:01", timezone => "US/Pacific");
is($dt, "2007-01-01T23:22:01");

{
    $dt = DateTime::Easy->new("today");
    ok($dt);

    # Same thing:
    $dt = DateTime::Easy->new("now");
    ok($dt);

    # Uses Date::Manip's coolness:
    $dt = DateTime::Easy->new("last monday");
    ok($dt);

    # ... but in 1969:
    $dt = DateTime::Easy->new("last monday", year => 1969);
    ok($dt);

    # ... at the 100th nanosecond:
    $dt = DateTime::Easy->new("last monday", year => 1969, nanosecond => 100);
    ok($dt);

    # ... in EST: (This will NOT do a timezone conversion)
    $dt = DateTime::Easy->new("last monday", year => 1969, nanosecond => 100, timezone => "US/Eastern");
    ok($dt);

    # This WILL do a proper timezone conversion:
    $dt = DateTime::Easy->new("last monday", year => 1969, nanosecond => 100, timezone => "US/Pacific");
    $dt->set_time_zone("US/Eastern");
    ok($dt);
}
