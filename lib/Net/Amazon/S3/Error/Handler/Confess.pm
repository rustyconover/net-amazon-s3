package Net::Amazon::S3::Error::Handler::Confess;

# ABSTRACT: An internal class to report errors via Carp::confess

use Moose;
use Carp;
use HTTP::Status;

extends 'Net::Amazon::S3::Error::Handler';

our @CARP_NOT = (__PACKAGE__);

sub handle_error {
    my ($self, $response) = @_;

    return 1 unless $response->is_error;

    Carp::confess ("${\ $response->error_code }: ${\ $response->error_message }");
}

1;

__END__

=head1 DESCRIPTION

Carp::confess on error.

=cut
