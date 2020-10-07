package Net::Amazon::S3::Operation::Object::Restore::Request;
# ABSTRACT: An internal class implementing RestoreObject operation

use strict;
use warnings;

use Moose;
use Moose::Util::TypeConstraints;
use MooseX::StrictConstructor 0.16;

extends 'Net::Amazon::S3::Request::Object';
with 'Net::Amazon::S3::Request::Role::HTTP::Method::POST';
with 'Net::Amazon::S3::Request::Role::Query::Action::Restore';
with 'Net::Amazon::S3::Request::Role::XML::Content';

enum 'Tier' => [ qw(Standard Expedited Bulk) ];
has 'days' => (is => 'ro', isa => 'Int', required => 1);
has 'tier' => (is => 'ro', isa => 'Tier', required => 1);

__PACKAGE__->meta->make_immutable;

sub _request_content {
	my ($self) = @_;

	return $self->_build_xml (RestoreRequest => [
		{ Days => $self->days },
		{ GlacierJobParameters => [
			{ Tier => $self->tier },
		]},
	]);
}

1;

__END__

=head1 DESCRIPTION

Implements an operation L<< RestoreObject|https://docs.aws.amazon.com/AmazonS3/latest/API/API_RestoreObject.html >>
