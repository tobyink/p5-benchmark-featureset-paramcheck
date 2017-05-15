use v5.12;
use strict;
use warnings;

package Benchmark::Featureset::ParamCheck::Implementation::RefUtilXS;

our $AUTHORITY = 'cpan:TOBYINK';
our $VERSION   = '0.001';

use parent qw(Benchmark::Featureset::ParamCheck::Base);
use Ref::Util::XS 0.116 qw(is_blessed_ref is_plain_hashref is_plain_arrayref is_ref);
use namespace::autoclean;

use constant long_name  => 'Pure Perl Implementation with Ref::Util::XS';
use constant short_name => 'RefUtilXS';

sub get_named_check {
	state $check = sub {
		my %args = (@_==1 && ref($_[0]) eq 'HASH') ? %{$_[0]} : @_;
		die 'invalid key' if grep !/\A(integer|object|hashes)\z/, keys %args;
		
		die 'bad integer' unless
			defined($args{integer})
			&& !is_ref($args{integer})
			&& $args{integer} =~ /\A-?[0-9]+\z/;
		
		die 'bad object' unless
			is_blessed_ref($args{object})
			&& $args{object}->can('print')
			&& $args{object}->can('close');
		
		die 'bad hashes' unless
			is_plain_arrayref($args{hashes});
		for my $arr (@{ $args{hashes} }) {
			die 'bad hashes' unless is_plain_hashref($arr);
		}
		
		\%args;
	};
}

1;
