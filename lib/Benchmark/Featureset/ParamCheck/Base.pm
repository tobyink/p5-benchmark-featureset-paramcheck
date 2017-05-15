use v5.12;
use strict;
use warnings;

package Benchmark::Featureset::ParamCheck::Base;

our $AUTHORITY = 'cpan:TOBYINK';
our $VERSION   = '0.001';

sub long_name       { ...; }
sub short_name      { ...; }
sub get_named_check { ...; }

use constant allow_extra_key => !!0;
use constant accept_hash     => !!1;
use constant accept_hashref  => !!1;

sub run_named_check {
	my ($class, $times, @args) = @_;
	my $check = $class->get_named_check;
	$check->(@args) for 1 .. $times;
	return;
}

1;
