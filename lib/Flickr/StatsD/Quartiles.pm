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

	my $insert_data = "$data->{t}:$data->{q1}:$data->{q2}:$data->{q3}:$data->{lo}:$data->{hi}:$data->{sm}";


	#
	# create rrd if needed?
	#

	my $rrd_file = "$self->{opts}->{rrd_root}/$data->{c}.rrd";

	unless (-f $rrd_file){

		my $command = "$self->{opts}->{rrdtool} create $rrd_file ";
		$command .= " --step 10 ";
		$command .= " --start 1211478990 ";
		$command .= " DS:q1:GAUGE:600:0:U ";
		$command .= " DS:q2:GAUGE:600:0:U ";
		$command .= " DS:q3:GAUGE:600:0:U ";
		$command .= " DS:lo:GAUGE:600:0:U ";
		$command .= " DS:hi:GAUGE:600:0:U ";
		$command .= " DS:total:GAUGE:600:0:U ";
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
