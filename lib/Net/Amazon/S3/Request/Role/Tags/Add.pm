package Net::Amazon::S3::Request::Role::Tags::Add;
# ABSTRACT: Add tags request parts common to Bucket and Object

use Moose::Role;

with 'Net::Amazon::S3::Request::Role::HTTP::Method::PUT';
with 'Net::Amazon::S3::Request::Role::Query::Action::Tagging';
with 'Net::Amazon::S3::Request::Role::XML::Content';

has 'tags' => (
	is => 'ro',
	isa => 'HashRef',
	required => 1,
);

sub _request_content {
	my ($self) = @_;

	$self->_build_xml (Tagging => [
		{ TagSet => [
			map +{ Tag => [
				{ Key => $_ },
				{ Value => $self->tags->{$_} },
			]}, sort keys %{ $self->tags }
		]},
	]);
}


1;
