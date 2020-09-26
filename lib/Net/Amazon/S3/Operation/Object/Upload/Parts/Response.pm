package Net::Amazon::S3::Operation::Object::Upload::Parts::Response;
# ABSTRACT: An internal class to handle multipart upload parts list responses

use Moose;

extends 'Net::Amazon::S3::Response';

1;

__END__

=head1 DESCRIPTION

Implements operation L<< ListParts|https://docs.aws.amazon.com/AmazonS3/latest/API/API_ListParts.html >>
