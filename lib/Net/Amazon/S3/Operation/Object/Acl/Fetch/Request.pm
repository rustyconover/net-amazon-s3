package Net::Amazon::S3::Operation::Object::Acl::Fetch::Request;
# ABSTRACT: An internal class to get an object's access control

use Moose 0.85;
use MooseX::StrictConstructor 0.16;
extends 'Net::Amazon::S3::Request::Object';

with 'Net::Amazon::S3::Request::Role::Query::Action::Acl';
with 'Net::Amazon::S3::Request::Role::HTTP::Method::GET';

__PACKAGE__->meta->make_immutable;

1;

__END__

=for test_synopsis
no strict 'vars'

=head1 SYNOPSIS

	my $request = Net::Amazon::S3::Operation::Object::Acl::Fetch::Request->new (
		s3     => $s3,
		bucket => $bucket,
		key    => $key,
	);

=head1 DESCRIPTION

Implements operation L<< GetObjectAcl|https://docs.aws.amazon.com/AmazonS3/latest/API/API_GetObjectAcl.html >>.

This module gets an object's access control.

=head1 METHODS

=head2 http_request

This method returns a HTTP::Request object.

