package Net::Amazon::S3::Authorization::Basic;

use Moose 0.85;
use MooseX::StrictConstructor 0.16;

extends 'Net::Amazon::S3::Authorization';

# ABSTRACT: Basic authorization information

has aws_access_key_id => (
	is => 'ro',
);

has aws_secret_access_key => (
	is => 'ro',
);

1;

__END__

=head1 SYNOPSIS

	use Net::Amazon::S3;

	my $s3 = Net::Amazon::S3->new (
		authorization_context => Net::Amazon::S3::Authorization::Basic->new (
			aws_access_key_id     => ...,
			aws_secret_access_key => ...,
		),
		...
	);

=head1 DESCRIPTION

Basic authorization context for access_key / secret_key authorization.

