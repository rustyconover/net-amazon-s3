package Net::Amazon::S3::Error::Handler::Confess;

# ABSTRACT: An internal class to report errors via Carp::confess

use Moose;
use Carp;
use HTTP::Status;

extends 'Net::Amazon::S3::Error::Handler';

our @CARP_NOT = (__PACKAGE__);

my %return_false = (
	NoSuchKey => {
		'Net::Amazon::S3::Operation::Object::Head::Response' => 1,
	},
	NoSuchBucket => {
		'Net::Amazon::S3::Operation::Object::Head::Response' => 1,
	},
);

sub handle_error {
	my ($self, $response) = @_;

	return 1 unless $response->is_error;

	return 0
		if exists $return_false{ $response->error_code }
		&& exists $return_false{ $response->error_code }{ ref $response }
		;

	Carp::confess ("${\ $response->error_code }: ${\ $response->error_message }");
}

1;

__END__

=head1 DESCRIPTION

Carp::confess on error.

=cut
