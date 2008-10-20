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

	my $insert_data = "$data->{t}:$data->{ok}:$data->{fl}";


	#
	# create rrd if needed?
	#

	my $rrd_file = "$self->{opts}->{rrd_root}/$data->{c}.rrd";

	unless (-f $rrd_file){

		my $command = "$self->{opts}->{rrdtool} create $rrd_file ";
		$command .= " --step 10 ";
		$command .= " --start 1211478990 ";
		$command .= " DS:ok:GAUGE:600:0:U ";
		$command .= " DS:fail:GAUGE:600:0:U ";
		$command .= " RRA:AVERAGE:0.5:1:8640 ";		# 24 hours at 1 sample per 10 secs
		$command .= " RRA:AVERAGE:0.5:90:2880 ";	# 1 month at 1 sample per 15 mins
		$command .= " RRA:AVERAGE:0.5:2880:5475 ";	# 5 years at 1 sample per 8 hours

		print "creating $rrd_file...";
		print `$command`;
		print "done\n";
	}


	#
	# feed data into rrd
	#

	print "inserting data for $data->{c} :: $insert_data ...";

	my $command = "$self->{opts}->{rrdtool} update $rrd_file $insert_data";
	print `$command`;

	print "done\n";
}

1;
