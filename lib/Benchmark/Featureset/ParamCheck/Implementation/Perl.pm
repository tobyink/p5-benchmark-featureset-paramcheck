use v5.12;
use strict;
use warnings;

package Benchmark::Featureset::ParamCheck::Implementation::Perl;

our $AUTHORITY = 'cpan:TOBYINK';
our $VERSION   = '0.001';

use parent qw(Benchmark::Featureset::ParamCheck::Base);
use Scalar::Util qw(blessed);
use namespace::autoclean;

use constant long_name  => 'Naive Pure Perl Implementation';
use constant short_name => 'PurePerl';

sub get_named_check {
	state $check = sub {
		my %args = (@_==1 && ref($_[0]) eq 'HASH') ? %{$_[0]} : @_;
		die 'invalid key' if grep !/\A(integer|object|hashes)\z/, keys %args;
		
		die 'bad integer' unless
			defined($args{integer})
			&& !ref($args{integer})
			&& $args{integer} =~ /\A-?[0-9]+\z/;
		
		die 'bad object' unless
			blessed($args{object})
			&& $args{object}->can('print')
			&& $args{object}->can('close');
		
		die 'bad hashes' unless 
			ref($args{hashes}) eq 'ARRAY';
		for my $arr (@{ $args{hashes} }) {
			die 'bad hashes' unless ref($arr) eq 'HASH';
		}
		
		\%args;
	};
}

1;