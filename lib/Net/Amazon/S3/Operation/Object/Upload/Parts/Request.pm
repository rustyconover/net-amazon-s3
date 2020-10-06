package Net::Amazon::S3::Operation::Object::Upload::Parts::Request;
# ABSTRACT: List the parts in a multipart upload.

use Moose 0.85;
use MooseX::StrictConstructor 0.16;
extends 'Net::Amazon::S3::Request::Object';

with 'Net::Amazon::S3::Request::Role::Query::Param::Upload_id';
with 'Net::Amazon::S3::Request::Role::HTTP::Method::GET';

has 'headers' =>
	( is => 'ro', isa => 'HashRef', required => 0, default => sub { {} } );

__PACKAGE__->meta->make_immutable;

sub _request_headers {
	my ($self) = @_;

	return %{ $self->headers };
}

1;

__END__

=head1 DESCRIPTION

Implements an operation L<< ListParts|https://docs.aws.amazon.com/AmazonS3/latest/API/API_ListParts.html >>
