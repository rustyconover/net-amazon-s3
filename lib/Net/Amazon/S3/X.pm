package Net::Amazon::S3::X;

# ABSTRACT: Net::Amazon::S3 exceptions

use Moose;
use Moose::Meta::Class;

has request => (
	is => 'ro',
);

has response => (
	is => 'ro',
	handles => [
		'error_code',
		'error_message',
		'http_response',
	],
);

my %exception_map;
sub import {
	my ($class, @exceptions) = @_;

	for my $exception (@exceptions) {
		next if exists $exception_map{$exception};
		Moose::Meta::Class->create (
			$exception_map{$exception} = __PACKAGE__ . "::$exception",
			superclasses => [ __PACKAGE__ ],
		);
	}
}

sub build {
	my ($self, $exception, @params) = @_;

	$self->import ($exception);

	$exception_map{$exception}->new (@params);
}

1;

