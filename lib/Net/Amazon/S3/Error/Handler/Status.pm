package Net::Amazon::S3::Error::Handler::Status;

# ABSTRACT: An internal class to report response errors via err properties

use Moose;

extends 'Net::Amazon::S3::Error::Handler';

sub handle_error {
    my ($self, $response) = @_;

    $self->s3->err (undef);
    $self->s3->errstr (undef);

    return 1 unless $response->is_error;

    $self->s3->err ($response->error_code);
    $self->s3->errstr ($response->error_message);

    return 0;
}

1;

__END__

=head1 DESCRIPTION

Propagate error code and error message via connection's C<err> / C<errstr>
methods.

=cut
