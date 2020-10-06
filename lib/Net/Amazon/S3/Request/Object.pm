package Net::Amazon::S3::Request::Object;
# ABSTRACT: Base class for all S3 Object operations

use Moose 0.85;
use MooseX::StrictConstructor 0.16;
extends 'Net::Amazon::S3::Request::Bucket';

has key => (
	is => 'ro',
	isa => 'Str',
	required => 1,
);

override _request_path => sub {
	my ($self) = @_;

	return super . (join '/', map {$self->s3->_urlencode($_)} split /\//, $self->key);
};

__PACKAGE__->meta->make_immutable;

1;

