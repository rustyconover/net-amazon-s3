package Net::Amazon::S3::Operation::Bucket::Location::Request;
# ABSTRACT: An internal class to get a bucket's location constraint

use Moose 0.85;
use MooseX::StrictConstructor 0.16;
extends 'Net::Amazon::S3::Request::Bucket';

with 'Net::Amazon::S3::Request::Role::Query::Action::Location';
with 'Net::Amazon::S3::Request::Role::HTTP::Method::GET';

__PACKAGE__->meta->make_immutable;

1;

__END__

=for test_synopsis
no strict 'vars'

=head1 SYNOPSIS

	my $request = Net::Amazon::S3::Operation::Bucket::Location::Request->new (
		s3     => $s3,
		bucket => $bucket,
	);

=head1 DESCRIPTION

This module gets a bucket's location constraint.

Implements operation L<< GetBucketLocation|https://docs.aws.amazon.com/AmazonS3/latest/API/API_GetBucketLocation.html >>

=head1 METHODS

=head2 http_request

This method returns a HTTP::Request object.

