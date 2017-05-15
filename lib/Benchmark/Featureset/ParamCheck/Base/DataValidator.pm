use v5.12;
use strict;
use warnings;

package Benchmark::Featureset::ParamCheck::Base::DataValidator;

our $AUTHORITY = 'cpan:TOBYINK';
our $VERSION   = '0.001';

use parent qw(Benchmark::Featureset::ParamCheck::Base);
use Data::Validator 1.07;

sub run_named_check {
	my ($class, $times, @args) = @_;
	my $check = $class->get_named_check;
	$check->validate(@args) for 1 .. $times;
	return;
}

1;
