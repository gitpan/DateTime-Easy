#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'DateTime::Easy' );
}

diag( "Testing DateTime::Easy $DateTime::Easy::VERSION, Perl $], $^X" );
