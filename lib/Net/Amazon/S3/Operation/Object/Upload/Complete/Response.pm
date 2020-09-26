package Net::Amazon::S3::Operation::Object::Upload::Complete::Response;
# ABSTRACT: An internal class to handle complete a multipart upload response

use Moose;

extends 'Net::Amazon::S3::Response';

1;

=pod

=head1 DESCRIPTION

Implements operation L<< CompleteMultipartUpload|https://docs.aws.amazon.com/AmazonS3/latest/API/API_CompleteMultipartUpload.html >>
