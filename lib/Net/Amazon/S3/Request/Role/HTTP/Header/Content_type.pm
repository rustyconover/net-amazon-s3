package Net::Amazon::S3::Request::Role::HTTP::Header::Content_type;
# ABSTRACT: Content-Type header role

use MooseX::Role::Parameterized;

parameter content_type => (
	is => 'ro',
	isa => 'Str',
	required => 1,
);

role {
	my ($params) = @_;
	my $content_type = $params->content_type;

	around _request_headers => sub {
		my ($inner, $self) = @_;

		return ($self->$inner, ('Content-Type' => $content_type));
	};
};

1;

