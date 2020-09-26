package Net::Amazon::S3::Error::Handler::Legacy;

# ABSTRACT: An internal class to report errors like legacy API

use Moose;

extends 'Net::Amazon::S3::Error::Handler::Status';

use HTTP::Status;

our @CARP_NOT = __PACKAGE__;

my %croak_on_requests = map +($_ => 1), (
    'Net::Amazon::S3::Request::GetObject',
    'Net::Amazon::S3::Request::GetObjectAccessControl',
    'Net::Amazon::S3::Request::GetBucketAccessControl',
);

override handle_error => sub {
    my ($self, $response, $request) = @_;

    return super unless exists $croak_on_requests{ref $request};

    $self->s3->err (undef);
    $self->s3->errstr (undef);

    return 1 unless $response->is_error;
    return 0 if $response->http_response->code == HTTP::Status::HTTP_NOT_FOUND;

    $self->s3->err ("network_error");
    $self->s3->errstr ($response->http_response->status_line);

    Carp::croak ("Net::Amazon::S3: Amazon responded with ${\ $self->s3->errstr }\n");
};

1;

__END__

=head1 DESCRIPTION

Handle errors like L<Net::Amazon::S3> API does.

Carp::croak in case of I<object fetch>, I<object acl fetch>, and I<bucket acl fetch>.
set C<err> / C<errstr> only otherwise.

=cut
