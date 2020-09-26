package Net::Amazon::S3::Operation::Bucket::Create::Request;
# ABSTRACT: An internal class to create a bucket

use Moose 0.85;
extends 'Net::Amazon::S3::Request::Bucket';

with 'Net::Amazon::S3::Request::Role::HTTP::Header::Acl_short';
with 'Net::Amazon::S3::Request::Role::HTTP::Method::PUT';

has location_constraint => (
    is => 'ro',
    isa => 'MaybeLocationConstraint',
    coerce => 1,
    required => 0,
);

__PACKAGE__->meta->make_immutable;

sub _request_content {
    my ($self) = @_;

    my $content = '';
    if (defined $self->location_constraint &&
         $self->location_constraint ne 'us-east-1') {
        $content
            = "<CreateBucketConfiguration><LocationConstraint>"
            . $self->location_constraint
            . "</LocationConstraint></CreateBucketConfiguration>";
    }

    return $content;
}

sub http_request {
    my $self = shift;

    return $self->_build_http_request (
        region  => 'us-east-1',
    );
}

1;

__END__

=for test_synopsis
no strict 'vars'

=head1 SYNOPSIS

  my $http_request = Net::Amazon::S3::Operation::Bucket::Create::Request->new(
    s3                  => $s3,
    bucket              => $bucket,
    acl_short           => $acl_short,
    location_constraint => $location_constraint,
  )->http_request;

=head1 DESCRIPTION

This module creates a bucket.

Implements operation L<< CreateBucket|https://docs.aws.amazon.com/AmazonS3/latest/API/API_CreateBucket.html >>

=head1 METHODS

=head2 http_request

This method returns a HTTP::Request object.

