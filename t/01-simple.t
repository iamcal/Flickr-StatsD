use Test::More;

BEGIN {
	@::modules = (
		'Flickr::StatsD',
		'Flickr::StatsD::Buckets',
		'Flickr::StatsD::Quartiles',
		'Flickr::StatsD::TimingGraphs',
		'Flickr::StatsD::YesNo',
	);

	plan tests => 3 * scalar @::modules;

	use_ok( $_ ) for @::modules;
}

require_ok( $_ ) for @::modules;

isa_ok(eval "$_->new();", $_) for @::modules;
