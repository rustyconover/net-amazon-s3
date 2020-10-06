package Net::Amazon::S3::Request::Role::Query::Action;
# ABSTRACT: query action role

use MooseX::Role::Parameterized;

parameter action => (
	is => 'ro',
	isa => 'Str',
);

role {
	my ($params) = @_;
	my $action = $params->action;

	method '_request_query_action' => sub { $action };
};

1;

