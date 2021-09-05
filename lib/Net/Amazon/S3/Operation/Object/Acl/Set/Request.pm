package Net::Amazon::S3::Operation::Object::Acl::Set::Request;
# ABSTRACT: An internal class to set an object's access control

use Moose 0.85;
use MooseX::StrictConstructor 0.16;

extends 'Net::Amazon::S3::Request::Object';

has 'acl_xml'   => ( is => 'ro', isa => 'Maybe[Str]',      required => 0 );

with 'Net::Amazon::S3::Request::Role::Query::Action::Acl';
with 'Net::Amazon::S3::Request::Role::HTTP::Header::ACL';
with 'Net::Amazon::S3::Request::Role::HTTP::Method::PUT';

__PACKAGE__->meta->make_immutable;

sub _request_content {
	my ($self) = @_;

	return $self->acl_xml || '';
}

sub BUILD {
	my ($self) = @_;

	unless ( $self->acl_xml || $self->acl ) {
		confess "need either acl_xml or acl";
	}

	if ( $self->acl_xml && $self->acl ) {
		confess "can not provide both acl_xml and acl";
	}
}

1;

__END__

=for test_synopsis
no strict 'vars'

=head1 SYNOPSIS

	my $request = Net::Amazon::S3::Operation::Object::Acl::Set::Request->new (
		s3        => $s3,
		bucket    => $bucket,
		key       => $key,
		acl_short => $acl_short,
		acl_xml   => $acl_xml,
	);

=head1 DESCRIPTION

Implements operation L<< PutObjectAcl|https://docs.aws.amazon.com/AmazonS3/latest/API/API_PutObjectAcl.html >>.

This module sets an object's access control.

=head1 METHODS

=head2 http_request

This method returns a HTTP::Request object.

