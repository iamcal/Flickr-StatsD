package Flickr::StatsD::TimingGraphs;

use strict;
use warnings;

use Flickr::StatsD::Quartiles;
use Flickr::StatsD::YesNo;
use Data::Dumper;

use base 'Flickr::StatsD::Buckets';


sub rollup_cat {
        my ($self, $time, $cat, $samples) = @_;

	if ($cat =~ m/^ok_/){

		Flickr::StatsD::YesNo::rollup_cat(@_);
	}else{
		Flickr::StatsD::Quartiles::rollup_cat(@_);
	}
}

sub save_data {
	my ($self, $data) = @_;

	print "data has been rolled up for $data->{c}\n";
	print Dumper $data;

	# TODO: save to the actual graphs here
}

1;
