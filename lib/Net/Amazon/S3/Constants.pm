package Net::Amazon::S3::Constants;
# Abstract: Misc constants used by S3

use constant {
	HEADER_BUCKET_REGION        => 'x-amz-bucket-region',
	HEADER_CANNED_ACL           => 'x-amz-acl',
	HEADER_DATE                 => 'x-amz-date',
	HEADER_DELETE_MARKER        => 'x-amz-delete-marker',
	HEADER_ID_2                 => 'x-amz-id-2',
	HEADER_METADATA_DIRECTIVE   => 'x-amz-metadata-directive',
	HEADER_REQUEST_ID           => 'x-amz-request-id',
	HEADER_VERSION_ID           => 'x-amz-version-id',
    HEADER_COPY_SOURCE          => 'x-amz-copy-source',
    HEADER_SERVER_ENCRYPTION    => 'x-amz-server-side-encryption',
	S3_NAMESPACE_URI            => 'http://s3.amazonaws.com/doc/2006-03-01/',
};

1;

__END__

=encoding utf8

=head1 DESCRIPTION

Module provides misc Amazon S3 string constants as symbols.

=head1 AUTHOR

Branislav Zahradník <barney@cpan.org>

=head1 COPYRIGHT AND LICENSE

This module is part of L<Net::Amazon::S3> distribution.

=cut

