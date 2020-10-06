package Net::Amazon::S3::Request::Role::HTTP::Header::Encryption;
# ABSTRACT: x-amz-server-side-encryption header role

use Moose::Role;

use Net::Amazon::S3::Constants;

with 'Net::Amazon::S3::Request::Role::HTTP::Header' => {
	name => 'encryption',
	header => Net::Amazon::S3::Constants->HEADER_SERVER_ENCRYPTION,
	isa => 'Maybe[Str]',
	required => 0,
};

1;
