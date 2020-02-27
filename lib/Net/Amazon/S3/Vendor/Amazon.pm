package Net::Amazon::S3::Vendor::Amazon;

use Moose 0.85;

# ABSTRACT: Amazon AWS specific behaviour

extends 'Net::Amazon::S3::Vendor';

use Net::Amazon::S3::Signature::V4;

has '+host' => (
	default => 's3.amazonaws.com',
);

has '+authorization_method' => (
	default => sub { 'Net::Amazon::S3::Signature::V4' },
);

sub guess_bucket_region {
	my ($self, $bucket) = @_;

	$bucket->_head_region;
}

1;

__END__

=pod

=head1 SYNOPSIS

	my $s3 = Net::Amazon::S3->new (
		vendor => Net::Amazon::S3::Vendor::Amazon->new,
		...
	);

=head1 DESCRIPTION

Amazon AWS vendor specification.

Supports all L<< Net::Amazon::S3::Vendor >> constructor parameters although
usually there is no reason to change it :-)

Guess bucket region implementation uses bucket's HEAD region request.
