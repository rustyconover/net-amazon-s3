package Net::Amazon::S3::Request::Role::HTTP::Header::Content_length;
# ABSTRACT: Content-Lenghth header role

use Moose::Role;
use Digest::MD5 qw[];
use MIME::Base64 qw[];

around _request_headers => sub {
	my ($inner, $self) = @_;
	my $content = $self->_http_request_content;

	return ($self->$inner, ('Content-Length' => length $content));
};

1;
