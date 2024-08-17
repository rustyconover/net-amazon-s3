package Net::Amazon::S3::Request::Role::HTTP::Header;
# ABSTRACT: HTTP Header Role

use MooseX::Role::Parameterized;

parameter name => (
	is => 'ro',
	isa => 'Str',
	required => 1,
);

parameter header => (
	is => 'ro',
	isa => 'Str',
);

parameter constraint => (
	is => 'ro',
	isa => 'Str',
	init_arg => 'isa',
	required => 1,
);

parameter required => (
	is => 'ro',
	isa => 'Bool',
	default => 0,
);

parameter default => (
	is => 'ro',
	isa => 'Str|CodeRef',
	required => 0,
);

role {
	my ($params) = @_;

	my $name = $params->name;
	my $header = $params->header;

	has $name => (
		is => 'ro',
		isa => $params->constraint,
		(init_arg => undef) x!! ($name =~ m/^_/),
		required => $params->required,
		(default => $params->default) x!! defined $params->default,
	);

	around _request_headers => eval <<"INLINE";
	sub {
		my (\$inner, \$self) = \@_;
		my \$value = \$self->$name;

		return (\$self->\$inner, (q[$header] => \$value) x!! defined \$value);
	};
INLINE
};

1;
