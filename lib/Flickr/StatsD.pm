package Flickr::StatsD;

use IO::Socket;
use IO::Select;

our $VERSION = 0.01;

sub new {
	my $class = shift;
	my $self = bless {}, $class;

	my %opts = (ref $_[0]) ? ((ref $_[0] eq 'HASH') ? %{$_[0]} : () ) : @_;

	$self->{opts} = \%opts;

	$self->{port}		= $opts{port}		|| 8765;
	$self->{rollup_secs}	= $opts{rollup_secs}	|| 5;
	$self->{max_datagram}	= $opts{max_datagram}	|| 1024;
	$self->{debug}		= $opts{debug}		|| 0;

	return $self;
}

sub run_server {
	my ($self) = @_;


	#
	# set up the server
	#

	my $server = IO::Socket::INET->new(
		LocalPort	=> $self->{port},
		Proto		=> "udp"
	) or die "Couldn't be a udp server on port $self->{port} : $@\n";


	#
	# the rollup alarm
	#

	local $SIG{ALRM} = sub {
		$self->rollup_stats(0);
		alarm($self->{rollup_secs});
	};
	alarm($self->{rollup_secs});


	#
	# stop on SIGINT and return control
	#

	$self->{stop_server} = 0;
	local $SIG{INT} = sub {
		$self->{stop_server} = 1;
	};


	#
	# the server loop
	#

	$|++;

	while (!$self->{stop_server}){

		my @ready = IO::Select->new(($server))->can_read(1);
		if (scalar @ready){
			my ($flags, $datagram);
			my $from = $server->recv($datagram, $self->{max_datagram}, $flags);
			chomp $datagram;
			$self->process_message($datagram);
		}else{
			print ".";
		}
	}


	#
	# a final rollup incase we have data in our buffers
	#

	$self->rollup_stats(1);
}

sub rollup_stats {
	my ($self, $last) = @_;

	print "\nrollup!\n";
}

sub process_message {
	my ($self, $message) = @_;

	print "\ngot message: $message\n";
}

1;
