package Net::Amazon::S3::Client::Object::Range;
# ABSTRACT: Object extension allowing to fetch part of an object

use Moose 0.85;
use MooseX::StrictConstructor 0.16;

has 'object'
	=> is       => 'ro'
	=> isa      => 'Net::Amazon::S3::Client::Object'
	=> required => 1
	;

has 'range'
	=> is       => 'ro'
	=> isa      => 'Str'
	=> required => 1
	;

sub _get {
	my ($self, %args) = shift;

	my $response = $self->object->_perform_operation (
		'Net::Amazon::S3::Operation::Object::Fetch',

		%args,

		method => 'GET',
		range  => $self->range,
	);

	return $response;
}

sub get {
	my $self = shift;
	return $self->_get->content;
}

sub get_decoded {
	my $self = shift;
	return $self->_get->decoded_content(@_);
}

sub get_callback {
	my ($self, $callback) = @_;

	return $self->_get (filename => $callback)->http_response;
}

sub get_filename {
	my ($self, $filename) = @_;

	return $self->_get (filename => $filename)->http_response;
}


1;

=pod

=encoding utf8

=head1 SYNOPSIS

	my $value = $object->range ("bytes=1024-10240")->get;

=head1 DESCRIPTION

Simple implementation dowloads, see L<use-byte-range-fetches|https://docs.aws.amazon.com/whitepapers/latest/s3-optimizing-performance-best-practices/use-byte-range-fetches.html>.

=head1 METHODS

Provides same get methods as L<Net::Amazon::S3::Client::Object>

=over

=item get

=item get_decoded

=item get_callback

=item get_filename

=back

=head1 SEE ALSO

L<Net::Amazon::S3::Client::Object>

=head1 AUTHOR

Branislav Zahradník <barney@cpan.org> - since v0.99

=head1 COPYRIGHT AND LICENSE

This module is a part of L<Net::Amazon::S3> distribution.

=cut
