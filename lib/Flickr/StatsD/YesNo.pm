package Flickr::StatsD::YesNo;

use strict;
use warnings;

use base 'Flickr::StatsD::Buckets';


sub rollup_cat {
        my ($self, $time, $cat, $samples) = @_;

	my $counts = {};

	for (@{$samples}){

		$counts->{ $_ ? 1 : 0 }++;
	}

	my $info = {
		't'  => $time,
		'c'  => $cat,
		'ok' => $counts->{1},
		'fl' => $counts->{0},
	};

	$self->save_data($info);
}

sub save_data {
	my ($self, $data) = @_;
}

1;
