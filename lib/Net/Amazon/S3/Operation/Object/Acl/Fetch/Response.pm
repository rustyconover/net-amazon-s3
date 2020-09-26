package Net::Amazon::S3::Operation::Object::Acl::Fetch::Response;
# ABSTRACT: An internal class to handle fetch object acl response

use Moose;
extends 'Net::Amazon::S3::Response';

1;

=head1 DESCRIPTION

Implements operation L<< GetObjectAcl|https://docs.aws.amazon.com/AmazonS3/latest/API/API_GetObjectAcl.html >>.
