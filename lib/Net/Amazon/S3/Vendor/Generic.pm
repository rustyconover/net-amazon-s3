package Net::Amazon::S3::Vendor::Generic;

use Moose 0.85;

# ABSTRACT: Generic S3 vendor

extends 'Net::Amazon::S3::Vendor';

1;

__END__

=pod

=head1 SYNOPSIS

	my $s3 = Net::Amazon::S3->new (
		vendor => Net::Amazon::S3::Vendor::Generic->new (
			host => ...,
			use_https => ...',
			use_virtual_host => ...,
			authorization_method => ...,
			default_region => ...,
		),
		...
	);

=head1 DESCRIPTION

