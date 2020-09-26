package Net::Amazon::S3::Operation::Object::Upload::Abort::Response;
# ABSTRACT: An internal class to handle abort multipart upload response

use Moose;

extends 'Net::Amazon::S3::Response';

1;

__END__

=head1 DESCRIPTION

Implements operation L<< AbortMultipartUpload|https://docs.aws.amazon.com/AmazonS3/latest/API/API_AbortMultipartUpload.html >>.
