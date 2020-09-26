package Net::Amazon::S3::Operation::Bucket::Acl::Fetch::Response;
# ABSTRACT: An internal class to handle fetch bucket acl response

use Moose;
extends 'Net::Amazon::S3::Response';

1;

__END__

=head1 DESCRIPTION

Implements operation L<< GetBucketAcl|https://docs.aws.amazon.com/AmazonS3/latest/API/API_GetBucketAcl.html >>
