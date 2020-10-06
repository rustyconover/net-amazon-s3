package Net::Amazon::S3::Request::Bucket;
# ABSTRACT: Base class for all S3 Bucket operations

use Moose 0.85;
use MooseX::StrictConstructor 0.16;
extends 'Net::Amazon::S3::Request::Service';

with 'Net::Amazon::S3::Role::Bucket';

override _request_path => sub {
	my ($self) = @_;

	return super . $self->bucket->bucket . "/";
};

__PACKAGE__->meta->make_immutable;

1;

