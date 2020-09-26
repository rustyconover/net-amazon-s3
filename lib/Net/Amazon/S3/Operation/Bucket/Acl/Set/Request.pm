package Net::Amazon::S3::Operation::Bucket::Acl::Set::Request;
# ABSTRACT: An internal class to set a bucket's access control

use Moose 0.85;
use MooseX::StrictConstructor 0.16;

use Carp ();

extends 'Net::Amazon::S3::Request::Bucket';

with 'Net::Amazon::S3::Request::Role::HTTP::Header::ACL';

has 'acl_xml'   => (
	is => 'ro',
	isa => 'Maybe[Str]',
	required => 0,
);

with 'Net::Amazon::S3::Request::Role::Query::Action::Acl';
with 'Net::Amazon::S3::Request::Role::HTTP::Method::PUT';

__PACKAGE__->meta->make_immutable;

sub _request_content {
    my ($self) = @_;

    return $self->acl_xml || '';
}

sub BUILD {
    my ($self) = @_;

    unless ($self->acl_xml || $self->acl) {
        Carp::confess "need either acl_xml or acl";
    }

    if ($self->acl_xml && $self->acl) {
        Carp::confess "can not provide both acl_xml and acl";
    }
}

1;

__END__

=for test_synopsis
no strict 'vars'

=head1 SYNOPSIS

	my $request = Net::Amazon::S3::Operation::Bucket::Acl::Set::Request->new (
		s3        => $s3,
		bucket    => $bucket,
		acl_short => $acl_short,
		acl_xml   => $acl_xml,
	);

=head1 DESCRIPTION

Implements operation L<< PutBucketAcl|https://docs.aws.amazon.com/AmazonS3/latest/API/API_PutBucketAcl.html >>

This module sets a bucket's access control.

=head1 METHODS

=head2 http_request

This method returns a HTTP::Request object.

