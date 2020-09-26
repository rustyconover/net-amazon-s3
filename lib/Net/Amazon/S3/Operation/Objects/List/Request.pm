package Net::Amazon::S3::Operation::Objects::List::Request;
# ABSTRACT: An internal class to list a bucket (List Objects Version 1)

use Moose 0.85;
use MooseX::StrictConstructor 0.16;
use URI::Escape qw(uri_escape_utf8);
extends 'Net::Amazon::S3::Request::Bucket';

with 'Net::Amazon::S3::Request::Role::Query::Param::Delimiter';
with 'Net::Amazon::S3::Request::Role::Query::Param::Marker';
with 'Net::Amazon::S3::Request::Role::Query::Param::Max_keys';
with 'Net::Amazon::S3::Request::Role::Query::Param::Prefix';
with 'Net::Amazon::S3::Request::Role::HTTP::Method::GET';

__PACKAGE__->meta->make_immutable;

1;

__END__

=for test_synopsis
no strict 'vars'

=head1 SYNOPSIS

	my $http_request = Net::Amazon::S3::Operation::Objects::List::Request->new(
		s3        => $s3,
		bucket    => $bucket,
		delimiter => $delimiter,
		max_keys  => $max_keys,
		marker    => $marker,
	);

=head1 DESCRIPTION

This module lists a bucket.

Implements operation L<< ListObjects|https://docs.aws.amazon.com/AmazonS3/latest/API/API_ListObjects.html >.

=head1 METHODS

=head2 http_request

This method returns a HTTP::Request object.

