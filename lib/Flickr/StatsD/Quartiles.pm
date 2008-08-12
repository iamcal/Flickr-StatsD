package Flickr::StatsD::Quartiles;

use strict;
use warnings;

use base 'Flickr::StatsD::Buckets';


sub rollup_cat {
        my ($self, $time, $cat, $samples) = @_;

	my @all = sort { $a <=> $b } @{$samples};

	my $lo = $all[0];
	my $hi = $all[-1];

	my $num = scalar @all;
	my $lo_c = int $num / 2;
	my $hi_c = $num - $lo_c;

	return if $lo_c == 0;
	return if $hi_c == 0;

	my @lo = splice @all, 0, $lo_c;
	my @hi = @all;

	my $lo_sum = 0;
	my $hi_sum = 0;

	$lo_sum += $_ for @lo;
	$hi_sum += $_ for @hi;

	my $q1 = $lo_sum / $lo_c;
	my $q2 = ($lo_sum + $hi_sum) / ($lo_c + $hi_c);
	my $q3 = $hi_sum / $hi_c;

	my $info = {
		't'  => $time,
		'c'  => $cat,
		'lo' => $lo,
		'q1' => $q1,
		'q2' => $q2,
		'q3' => $q3,
		'hi' => $hi,
		'sm' => $num,
	};

	$self->save_data($info);
}

sub save_data {
	my ($self, $data) = @_;
}

1;
