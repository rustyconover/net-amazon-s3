package Net::Amazon::S3::Request::Role::HTTP::Header::Content_md5;
# ABSTRACT: Content-MD5 header role

use Moose::Role;
use Digest::MD5 qw[];
use MIME::Base64 qw[];

around _request_headers => sub {
	my ($inner, $self) = @_;
	my $content = $self->_http_request_content;

	my $value = MIME::Base64::encode_base64( Digest::MD5::md5( $content ) );
	chomp $value;

	return ($self->$inner, ('Content-MD5' => $value));
};

1;
