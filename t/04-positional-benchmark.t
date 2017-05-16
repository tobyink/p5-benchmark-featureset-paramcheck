=pod

=encoding utf-8

=head1 PURPOSE

Benchmark::Featureset::ParamCheck benchmarking positional parameters.

=head1 SAMPLE RESULTS

=head2 Simple Input Data


=head2 Complex Input Data


=head1 AUTHOR

Toby Inkster E<lt>tobyink@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENCE

This software is copyright (c) 2017 by Toby Inkster.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

use strict;
use warnings;
use Test::Modern qw( -benchmark );
use Module::Runtime qw(use_module);
use Benchmark::Featureset::ParamCheck;

my @cases = map use_module($_),
	'Benchmark::Featureset::ParamCheck'->implementations;
my @trivial = @{ 'Benchmark::Featureset::ParamCheck'->trivial_positional_data };
my @complex = @{ 'Benchmark::Featureset::ParamCheck'->complex_positional_data };

{
	my $benchmark_runs = 10_000;
	my @benchmark_data;

	my %benchmark = map {
			my $pkg = $_;
			$pkg->short_name => sub {
				$pkg->run_positional_check($benchmark_runs, @benchmark_data);
			};
		}
		grep $_->accept_array, @cases;

	local $TODO = "this shouldn't prevent the test script from passing";
	local $Test::Modern::VERBOSE = 1;

	@benchmark_data = @trivial;
	is_fastest(
		Benchmark::Featureset::ParamCheck::Implementation::TypeParams->short_name,
		20,
		\%benchmark,
		"trivial data benchmark"
	);

	@benchmark_data = @complex;
	is_fastest(
		Benchmark::Featureset::ParamCheck::Implementation::TypeParams->short_name,
		20,
		\%benchmark,
		"complex data benchmark"
	);
}

done_testing;
