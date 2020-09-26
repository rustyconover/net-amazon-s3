package Net::Amazon::S3::Operation::Object::Tags::Delete::Request;
# ABSTRACT: Internal class to build PutObjectTagging requests

use Moose 0.85;

extends 'Net::Amazon::S3::Request::Object';

with 'Net::Amazon::S3::Request::Role::HTTP::Method::DELETE';
with 'Net::Amazon::S3::Request::Role::Query::Action::Tagging';
with 'Net::Amazon::S3::Request::Role::Query::Param::Version_id';

__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=encoding utf8

=head1 SYNOPSIS

	my $request = Net::Amazon::S3::Operation::Bucket::Tags::Delete::Request->new (
		s3      => $s3,
		bucket  => $bucket,
	);

=head1 DESCRIPTION

Implements a request part of an operation L<DeleteBucketTagging|https://docs.aws.amazon.com/AmazonS3/latest/API/API_DeleteBucketTagging.html>

=head1 PROPERIES

=head2 version_id

Optional.

=head1 AUTHOR

Branislav Zahradník <barney@cpan.org>

=head1 COPYRIGHT AND LICENSE

This module is a part of L<Net::Amazon::S3> distribution.

=cut
