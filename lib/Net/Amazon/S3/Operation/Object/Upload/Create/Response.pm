package Net::Amazon::S3::Operation::Object::Upload::Create::Response;
# ABSTRACT: An internal class to handle create multipart upload response

use Moose;

extends 'Net::Amazon::S3::Response';

sub upload_id {
    $_[0]->_data->{upload_id};
}

sub _parse_data {
    my ($self) = @_;

    my $xpc = $self->xpath_context;

    my $data = {
        upload_id => scalar $xpc->findvalue ("//s3:UploadId"),
    };

    return $data;
}

1;

__END__

=head1 DESCRIPTION

Implement operation L<< CreateMultipartUpload|https://docs.aws.amazon.com/AmazonS3/latest/API/API_CreateMultipartUpload.html >>.
