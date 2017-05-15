=pod

=encoding utf-8

=head1 PURPOSE

Benchmark::Featureset::ParamCheck benchmarking.

=head1 SAMPLE RESULTS

=head2 Simple Input Data

 PVC-TT -  7 wallclock secs ( 7.40 usr +  0.00 sys =  7.40 CPU) @  2.70/s (n=20)
 TP-TT -  8 wallclock secs ( 7.86 usr +  0.00 sys =  7.86 CPU) @  2.54/s (n=20)
 PurePerl -  9 wallclock secs ( 9.03 usr +  0.00 sys =  9.03 CPU) @  2.21/s (n=20)
 RefUtilXS - 11 wallclock secs (11.11 usr +  0.00 sys = 11.11 CPU) @  1.80/s (n=20)
 DV-TT - 16 wallclock secs (15.58 usr +  0.00 sys = 15.58 CPU) @  1.28/s (n=20)
 DV-Mouse - 21 wallclock secs (20.50 usr +  0.00 sys = 20.50 CPU) @  0.98/s (n=20)
 PVC-Specio - 22 wallclock secs (21.46 usr +  0.02 sys = 21.48 CPU) @  0.93/s (n=20)
 PVC-Moose - 21 wallclock secs (21.57 usr +  0.02 sys = 21.59 CPU) @  0.93/s (n=20)
 PC-PurePerl - 32 wallclock secs (32.28 usr +  0.01 sys = 32.29 CPU) @  0.62/s (n=20)
 DV-Moose - 35 wallclock secs (34.98 usr +  0.02 sys = 35.00 CPU) @  0.57/s (n=20)
 PC-TT - 42 wallclock secs (41.79 usr +  0.02 sys = 41.81 CPU) @  0.48/s (n=20)
 MXPV-Moose - 80 wallclock secs (80.11 usr +  0.03 sys = 80.14 CPU) @  0.25/s (n=20)
 MXPV-TT - 87 wallclock secs (87.04 usr +  0.04 sys = 87.08 CPU) @  0.23/s (n=20)

=head2 Complex Input Data

 TP-TT - 10 wallclock secs (10.19 usr +  0.01 sys = 10.20 CPU) @  1.96/s (n=20)
 PVC-TT - 13 wallclock secs (13.02 usr +  0.01 sys = 13.03 CPU) @  1.53/s (n=20)
 RefUtilXS - 15 wallclock secs (15.26 usr +  0.00 sys = 15.26 CPU) @  1.31/s (n=20)
 PurePerl - 17 wallclock secs (16.81 usr +  0.00 sys = 16.81 CPU) @  1.19/s (n=20)
 DV-Mouse - 21 wallclock secs (21.08 usr +  0.01 sys = 21.09 CPU) @  0.95/s (n=20)
 PVC-Specio - 23 wallclock secs (22.82 usr +  0.00 sys = 22.82 CPU) @  0.88/s (n=20)
 PVC-Moose - 24 wallclock secs (23.77 usr +  0.01 sys = 23.78 CPU) @  0.84/s (n=20)
 DV-TT - 24 wallclock secs (23.86 usr +  0.00 sys = 23.86 CPU) @  0.84/s (n=20)
 PC-TT - 41 wallclock secs (41.50 usr +  0.02 sys = 41.52 CPU) @  0.48/s (n=20)
 DV-Moose - 46 wallclock secs (45.39 usr +  0.03 sys = 45.42 CPU) @  0.44/s (n=20)
 PC-PurePerl - 56 wallclock secs (56.54 usr +  0.04 sys = 56.58 CPU) @  0.35/s (n=20)
 MXPV-Moose - 102 wallclock secs (101.73 usr +  0.04 sys = 101.77 CPU) @  0.20/s (n=20)
 MXPV-TT - 102 wallclock secs (101.83 usr +  0.05 sys = 101.88 CPU) @  0.20/s (n=20)

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
my %trivial = %{ 'Benchmark::Featureset::ParamCheck'->trivial_test_data };
my %complex = %{ 'Benchmark::Featureset::ParamCheck'->complex_test_data };

{
	my $benchmark_runs = 10_000;
	my %benchmark_data;

	my %benchmark = map {
		my $pkg = $_;
		$pkg->short_name => sub {
			$pkg->run_named_check($benchmark_runs, \%benchmark_data);
		};
	} @cases;

	local $TODO = "this shouldn't prevent the test script from passing";
	local $Test::Modern::VERBOSE = 1;

	%benchmark_data = %trivial;
	is_fastest(
		Benchmark::Featureset::ParamCheck::Implementation::TypeParams->short_name,
		20,
		\%benchmark,
		"trivial data benchmark"
	);

	%benchmark_data = %complex;
	is_fastest(
		Benchmark::Featureset::ParamCheck::Implementation::TypeParams->short_name,
		20,
		\%benchmark,
		"complex data benchmark"
	);
}

done_testing;
