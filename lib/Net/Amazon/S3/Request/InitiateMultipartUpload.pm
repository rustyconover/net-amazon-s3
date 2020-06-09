package Net::Amazon::S3::Request::InitiateMultipartUpload;

use Moose 0.85;
use MooseX::StrictConstructor 0.16;
extends 'Net::Amazon::S3::Request::Object';

has 'headers' =>
    ( is => 'ro', isa => 'HashRef', required => 0, default => sub { {} } );

with 'Net::Amazon::S3::Request::Role::Query::Action::Uploads';
with 'Net::Amazon::S3::Request::Role::HTTP::Header::Acl_short';
with 'Net::Amazon::S3::Request::Role::HTTP::Header::Encryption';
with 'Net::Amazon::S3::Request::Role::HTTP::Method::POST';

__PACKAGE__->meta->make_immutable;

sub _request_headers {
    my ($self) = @_;

    return %{ $self->headers };
}

1;

__END__

#ABSTRACT: An internal class to begin a multipart upload

=for test_synopsis
no strict 'vars'

=head1 SYNOPSIS

  my $http_request = Net::Amazon::S3::Request::InitiateMultipartUpload->new(
    s3                  => $s3,
    bucket              => $bucket,
    keys                => $key,
  )->http_request;

=head1 DESCRIPTION

This module begins a multipart upload

=head1 METHODS

=head2 http_request

This method returns a HTTP::Request object.
