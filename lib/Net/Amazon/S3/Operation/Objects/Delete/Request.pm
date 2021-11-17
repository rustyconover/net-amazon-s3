package Net::Amazon::S3::Operation::Objects::Delete::Request;
# ABSTRACT: An internal class to delete multiple objects from a bucket

use Moose 0.85;
use Carp qw/croak/;

extends 'Net::Amazon::S3::Request::Bucket';

has 'keys'      => ( is => 'ro', isa => 'ArrayRef',   required => 1 );

with 'Net::Amazon::S3::Request::Role::HTTP::Header::Content_md5';
with 'Net::Amazon::S3::Request::Role::HTTP::Method::POST';
with 'Net::Amazon::S3::Request::Role::Query::Action::Delete';
with 'Net::Amazon::S3::Request::Role::XML::Content';

__PACKAGE__->meta->make_immutable;

sub _request_content {
	my ($self) = @_;

	return $self->_build_xml (Delete => [
		{ Quiet => 'true' },
		map +{ Object => [ { Key => $_ } ] }, @{ $self->keys }
	]);
}

sub BUILD {
	my ($self) = @_;

	croak "The maximum number of keys is 1000"
		if (scalar(@{$self->keys}) > 1000);
}

1;

__END__

=for test_synopsis
no strict 'vars'

=head1 SYNOPSIS

	my $http_request = Net::Amazon::S3::Operation::Objects::Delete::Request->new (
		s3      => $s3,
		bucket  => $bucket,
		keys    => [$key1, $key2],
	);

=head1 DESCRIPTION

This module deletes multiple objects from a bucket.

Implements operation L<< DeleteObjects|https://docs.aws.amazon.com/AmazonS3/latest/API/API_DeleteObjects.html >>

=head1 METHODS

=head2 http_request

This method returns a HTTP::Request object.
