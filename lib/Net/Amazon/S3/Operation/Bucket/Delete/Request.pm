package Net::Amazon::S3::Operation::Bucket::Delete::Request;
# ABSTRACT: An internal class to delete a bucket

use Moose 0.85;
extends 'Net::Amazon::S3::Request::Bucket';

with 'Net::Amazon::S3::Request::Role::HTTP::Method::DELETE';

__PACKAGE__->meta->make_immutable;

1;

__END__

=for test_synopsis
no strict 'vars'

=head1 SYNOPSIS

	my $request = Net::Amazon::S3::Operation::Bucket::Delete::Request->new (
		s3     => $s3,
		bucket => $bucket,
	);

=head1 DESCRIPTION

This module deletes a bucket.

Implements operation L<< DeleteBucket|https://docs.aws.amazon.com/AmazonS3/latest/API/API_DeleteBucket.html >>

=head1 METHODS

=head2 http_request

This method returns a HTTP::Request object.

