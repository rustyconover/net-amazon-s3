package Net::Amazon::S3::Request::Role::HTTP::Header::ACL;
# ABSTRACT: Headers builders for ACL

use Moose::Role;
use Moose::Util::TypeConstraints;

use Carp ();

with 'Net::Amazon::S3::Role::ACL';

around _request_headers => sub {
	my ($inner, $self) = @_;

	return +(
		$self->$inner,
		$self->acl ? $self->acl->build_headers : (),
	);
};

1;
