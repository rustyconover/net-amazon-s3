package Net::Amazon::S3::Operation::Bucket::Tags::Add::Request;
# ABSTRACT: Internal class to build PutObjectTagging requests

use Moose 0.85;

extends 'Net::Amazon::S3::Request::Bucket';

with 'Net::Amazon::S3::Request::Role::Tags::Add';

__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=encoding utf8

=head1 SYNOPSIS

	my $request = Net::Amazon::S3::Operation::Bucket::Tags::Add::Request->new (
		s3      => $s3,
		bucket  => $bucket,
		tags    => { tag1 => 'val1', ... },
	);

=head1 DESCRIPTION

Implements a request part of an operation L<PutBucketTagging|https://docs.aws.amazon.com/AmazonS3/latest/API/API_PutBucketTagging.html>

=head1 PROPERIES

=head2 tags

Key/value tag pairs

=head1 AUTHOR

Branislav Zahradník <barney@cpan.org>

=head1 COPYRIGHT AND LICENSE

This module is a part of L<Net::Amazon::S3> distribution.

=cut
