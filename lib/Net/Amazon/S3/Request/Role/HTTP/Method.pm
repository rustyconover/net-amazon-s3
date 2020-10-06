package Net::Amazon::S3::Request::Role::HTTP::Method;
# ABSTRACT: HTTP method role

use MooseX::Role::Parameterized;

use Net::Amazon::S3::HTTPRequest;

parameter method => (
	is => 'ro',
	isa => 'HTTPMethod',
	required => 0,
);

role {
	my ($params) = @_;

	has _http_request_method => (
		is => 'ro',
		isa => 'HTTPMethod',
		$params->method
			? (
				init_arg => undef,
				default => $params->method,
			)
			: (
				init_arg => 'method',
				required => 1
			),
	);
};

1;
