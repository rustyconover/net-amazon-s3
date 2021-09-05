package Net::Amazon::S3::Error::Handler;

use Moose;

# ABSTRACT: A base class for S3 response error handler

has s3 => (
	is => 'ro',
	isa => 'Net::Amazon::S3',
	required => 1,
);

sub handle_error;

1;

__END__

=encoding utf8

=head1 CONSTRUCTOR

=over

=item s3

Instance of L<< Net::Amazon::S3 >>

=back

=head1 METHODS

=head2 handle_error ($response)

=head2 handle_error ($response, $request)

Method will receive instance of L<< Net::Amazon::S3::Response >> sub-class.

Method should return false (or throw exception) in case of error, true otherwise.

=cut
