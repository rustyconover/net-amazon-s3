package Net::Amazon::S3::Operation::Buckets::List::Response;
# ABSTRACT: An internal class to process list all buckets response

use Moose;

extends 'Net::Amazon::S3::Response';

sub owner_id {
    $_[0]->_data->{owner_id};
}

sub owner_displayname {
    $_[0]->_data->{owner_displayname};
}

sub buckets {
    @{ $_[0]->_data->{buckets} };
}

sub _parse_data {
    my ($self) = @_;

    my $xpc = $self->xpath_context;

    my $data = {
        owner_id          => $xpc->findvalue ("/s3:ListAllMyBucketsResult/s3:Owner/s3:ID"),
        owner_displayname => $xpc->findvalue ("/s3:ListAllMyBucketsResult/s3:Owner/s3:DisplayName"),
        buckets           => [],
    };

    foreach my $node ($xpc->findnodes ("/s3:ListAllMyBucketsResult/s3:Buckets/s3:Bucket")) {
        push @{ $data->{buckets} }, {
            name          => $xpc->findvalue ("./s3:Name", $node),
            creation_date => $xpc->findvalue ("./s3:CreationDate", $node),
        };
    }

    return $data;
}

1;

__END__

=head1 DESCRIPTION

Implements S3 operation L<< ListBuckets|https://docs.aws.amazon.com/AmazonS3/latest/API/API_ListBuckets.html >>

