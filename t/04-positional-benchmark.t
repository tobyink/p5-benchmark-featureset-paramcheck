=pod

=encoding utf-8

=head1 PURPOSE

Benchmark::Featureset::ParamCheck benchmarking positional parameters.

=head1 SAMPLE RESULTS

=head2 Simple Input Data

 # TP-TT -  0 wallclock secs ( 0.42 usr +  0.00 sys =  0.42 CPU) @ 47.62/s (n=20)
 # PVC-TT -  0 wallclock secs ( 0.49 usr +  0.01 sys =  0.50 CPU) @ 40.00/s (n=20)
 # RefUtilXS -  1 wallclock secs ( 0.58 usr +  0.00 sys =  0.58 CPU) @ 34.48/s (n=20)
 # PurePerl -  1 wallclock secs ( 0.96 usr +  0.00 sys =  0.96 CPU) @ 20.83/s (n=20)
 # PVC-Specio -  2 wallclock secs ( 1.88 usr +  0.01 sys =  1.89 CPU) @ 10.58/s (n=20)
 # PVC-Moose -  2 wallclock secs ( 1.93 usr +  0.00 sys =  1.93 CPU) @ 10.36/s (n=20)
 # DV-TT -  5 wallclock secs ( 5.16 usr +  0.00 sys =  5.16 CPU) @  3.88/s (n=20)
 # DV-Moose -  6 wallclock secs ( 5.43 usr +  0.00 sys =  5.43 CPU) @  3.68/s (n=20)
 # DV-Mouse -  7 wallclock secs ( 7.08 usr +  0.00 sys =  7.08 CPU) @  2.82/s (n=20)
 # MXPV-TT - 10 wallclock secs ( 9.75 usr +  0.00 sys =  9.75 CPU) @  2.05/s (n=20)
 # MXPV-Moose - 10 wallclock secs ( 9.92 usr +  0.01 sys =  9.93 CPU) @  2.01/s (n=20)

=head2 Complex Input Data

 # PVC-TT -  1 wallclock secs ( 0.56 usr +  0.00 sys =  0.56 CPU) @ 35.71/s (n=20)
 # TP-TT -  0 wallclock secs ( 0.59 usr +  0.00 sys =  0.59 CPU) @ 33.90/s (n=20)
 # RefUtilXS -  1 wallclock secs ( 0.82 usr +  0.00 sys =  0.82 CPU) @ 24.39/s (n=20)
 # PurePerl -  1 wallclock secs ( 1.14 usr +  0.00 sys =  1.14 CPU) @ 17.54/s (n=20)
 # PVC-Specio -  2 wallclock secs ( 2.14 usr +  0.00 sys =  2.14 CPU) @  9.35/s (n=20)
 # PVC-Moose -  2 wallclock secs ( 2.25 usr +  0.01 sys =  2.26 CPU) @  8.85/s (n=20)
 # DV-TT -  5 wallclock secs ( 5.14 usr +  0.00 sys =  5.14 CPU) @  3.89/s (n=20)
 # DV-Moose -  5 wallclock secs ( 5.16 usr +  0.00 sys =  5.16 CPU) @  3.88/s (n=20)
 # DV-Mouse -  6 wallclock secs ( 6.13 usr +  0.00 sys =  6.13 CPU) @  3.26/s (n=20)
 # MXPV-TT - 10 wallclock secs ( 9.56 usr +  0.00 sys =  9.56 CPU) @  2.09/s (n=20)
 # MXPV-Moose - 12 wallclock secs (11.65 usr +  0.01 sys = 11.66 CPU) @  1.72/s (n=20)

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
