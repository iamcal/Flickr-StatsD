package Flickr::StatsD::Buckets;

use strict;
use warnings;

use base 'Flickr::StatsD';

sub new {
	my ($class) = @_;

	my $self = $class->SUPER::new(@_);

	$self->{buckets} = {};
	$self->{bucket_seconds} = $self->{opts}->{bucket_seconds} || 10;

	bless $self, $class;
	return $self;
}

sub get_bucket {
	my ($self) = @_;

	return int(time / $self->{bucket_seconds});
}

sub bucket_to_time {
	my ($self, $bucket) = @_;

	return $bucket * $self->{bucket_seconds};
}

sub process_message {
	my ($self, $message) = @_;

	my $bucket = $self->get_bucket();
	my ($cat, $time) = split /:/, $message;

	print "got message: $message\n" if $self->{debug};

	push @{$self->{buckets}->{$bucket}->{$cat}}, int $time;
}

sub rollup_stats {
	my ($self, $last) = @_;

	my $current_bucket = $self->get_bucket();

	#
	# go through the list of buckets and process any that
	# are older than the current bucket, unless this is
	# the last rollup (when we're hsutting down), in which
	# case we rollup all remaining buckets.
	#

	for my $bucket(keys %{$self->{buckets}}){

		if ($bucket < $current_bucket || $last){

			$self->rollup_bucket($bucket);
			delete $self->{buckets}->{$bucket};
		}
	}
}

sub rollup_bucket {
	my ($self, $bucket) = @_;

	#
	# rollup all cats in this bucket
	#

	my $bucket_time = $self->bucket_to_time($bucket);

	for my $cat(keys %{$self->{buckets}->{$bucket}}){

		$self->rollup_cat($bucket_time, $cat, $self->{buckets}->{$bucket}->{$cat});
	}
}

sub rollup_cat {
	my ($self, $time, $cat, $samples) = @_;

	#
	# this is the function to override
	#

	print "rolling up time $time in $cat\n";
}

1;
