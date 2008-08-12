use ExtUtils::MakeMaker;

WriteMakefile(
	'NAME'		=> 'Flickr::StatsD',
	'VERSION_FROM'	=> 'lib/Flickr/StatsD.pm',
	'PREREQ_PM'	=> {
		'IO::Socket'	=> 0,
		'IO::Select'	=> 0,
		#'Test::More'   => 0,
	},
);
