package Net::Amazon::S3::Signature;
# ABSTRACT: S3 Signature implementation base class

use Moose;

has http_request => (
	is => 'ro',
	isa => 'Net::Amazon::S3::HTTPRequest',
);

sub _append_authorization_headers {
	my ($self, $request) = @_;

	my %headers = $self->http_request->s3->authorization_context->authorization_headers;

	while (my ($key, $value) = each %headers) {
		$self->_populate_default_header ($request, $key => $value);
	}

	();
}

sub _append_authorization_query_params {
	my ($self, $request) = @_;

	my %headers = $self->http_request->s3->authorization_context->authorization_headers;

	while (my ($key, $value) = each %headers) {
		$self->_populate_default_query_param ($request, $key => $value);
	}

	();
}

sub _populate_default_header {
	my ($self, $request, $key, $value) = @_;

	return unless defined $value;
	return if defined $request->header ($key);

	$request->header ($key => $value);

	();
}

sub _populate_default_query_param {
	my ($self, $request, $key, $value) = @_;

	return unless defined $value;
	return if defined $request->uri->query_param ($key);

	$request->uri->query_param ($key => $value);

	();
}

sub sign_request {
	my ($self, $request);

	return;
}

sub sign_uri {
	my ($self, $uri, $expires_at);

	return;
}

1;

__END__

=method new

Signature class should accept HTTPRequest instance and determine every
required parameter via this instance

=method sign_request( $request )

Signature class should return authenticated request based on given parameter.
Parameter can be modified.

=method sign_uri( $request, $expires_at? )

Signature class should return authenticated uri based on given request.

$expires_at is expiration time in seconds (epoch).
Default and maximal allowed value may depend on signature version.

Default request date is current time.
Signature class should accept provided C<< X-Amz-Date >> header instead (if signing request)
or query parameter (if signing uri)
