package Net::Amazon::S3::Operation::Object::Upload::Complete::Request;
# ABSTRACT: An internal class to complete a multipart upload

use Moose 0.85;
use Carp qw/croak/;

extends 'Net::Amazon::S3::Request::Object';

with 'Net::Amazon::S3::Request::Role::HTTP::Method::POST';
with 'Net::Amazon::S3::Request::Role::Query::Param::Upload_id';
with 'Net::Amazon::S3::Request::Role::XML::Content';

has 'etags'         => ( is => 'ro', isa => 'ArrayRef',   required => 1 );
has 'part_numbers'  => ( is => 'ro', isa => 'ArrayRef',   required => 1 );

__PACKAGE__->meta->make_immutable;

sub _request_content {
	my ($self) = @_;

	return $self->_build_xml (CompleteMultipartUpload => [
		map +{ Part => [
			{ PartNumber => $self->part_numbers->[$_] },
			{ ETag       => $self->etags->[$_] },
		]}, 0 ..  (@{$self->part_numbers} - 1)
	]);
}

sub BUILD {
	my ($self) = @_;

	croak "must have an equally sized list of etags and part numbers"
		unless scalar(@{$self->part_numbers}) == scalar(@{$self->etags});
}

1;

__END__

=for test_synopsis
no strict 'vars'

=head1 SYNOPSIS

	my $request = Net::Amazon::S3::Operation::Object::Upload::Complete::Request->new (
		s3           => $s3,
		bucket       => $bucket,
		etags        => \@etags,
		part_numbers => \@part_numbers,
	);

=head1 DESCRIPTION

This module completes a multipart upload.

Implements operation L<< CompleteMultipartUpload|https://docs.aws.amazon.com/AmazonS3/latest/API/API_CompleteMultipartUpload.html >>

=head1 METHODS

=head2 http_request

This method returns a HTTP::Request object.
