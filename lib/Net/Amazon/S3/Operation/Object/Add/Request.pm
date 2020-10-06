package Net::Amazon::S3::Operation::Object::Add::Request;
# ABSTRACT: An internal class to add an object to a bucket.

use Moose 0.85;
use MooseX::StrictConstructor 0.16;

extends 'Net::Amazon::S3::Request::Object';

with 'Net::Amazon::S3::Request::Role::HTTP::Header::ACL';
with 'Net::Amazon::S3::Request::Role::HTTP::Header::Encryption';
with 'Net::Amazon::S3::Request::Role::HTTP::Method::PUT';

has 'value'     => ( is => 'ro', isa => 'Str|CodeRef|ScalarRef',     required => 1 );
has 'headers' =>
	( is => 'ro', isa => 'HashRef', required => 0, default => sub { {} } );

__PACKAGE__->meta->make_immutable;

sub _request_headers {
	my ($self) = @_;

	return %{ $self->headers };
}

sub http_request {
	my $self    = shift;

	return $self->_build_http_request(
		content => $self->value,
	);
}

1;

__END__

=for test_synopsis
no strict 'vars'

=head1 SYNOPSIS

	my $http_request = Net::Amazon::S3::Operation::Object::Add::Request->new (
		s3        => $s3,
		bucket    => $bucket,
		key       => $key,
		value     => $value,
		acl_short => $acl_short,
		headers   => $conf,
	);

=head1 DESCRIPTION

Implements operation L<< PutObject|https://docs.aws.amazon.com/AmazonS3/latest/API/API_PutObject.html >>.

This module puts an object.

=head1 METHODS

=head2 http_request

This method returns a HTTP::Request object.

