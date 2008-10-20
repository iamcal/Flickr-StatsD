package Flickr::StatsD::TimingGraphs;

use strict;
use warnings;

use Flickr::StatsD::Quartiles;
use Flickr::StatsD::YesNo;

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

	if ($data->{c} =~ m/^ok_/){

		Flickr::StatsD::YesNo::save_data(@_);
	}else{
		Flickr::StatsD::Quartiles::save_data(@_);
	}
}

1;
