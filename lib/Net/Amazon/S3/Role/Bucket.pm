package Net::Amazon::S3::Role::Bucket;
# ABSTRACT: Bucket role

use Moose::Role;
use Safe::Isa ();

around BUILDARGS => sub {
    my ($orig, $class, %params) = @_;

	# bucket can be optional in HTTPRequest
	if ($params{bucket}) {
		my $region = $params{region};
		$region = $params{bucket}->region
			if $params{bucket}
			and Scalar::Util::blessed( $params{bucket} )
			and ! $params{region}
			and $params{bucket}->has_region
			;

		$params{bucket} = $params{bucket}->name
			if $params{bucket}->$Safe::Isa::_isa ('Net::Amazon::S3::Client::Bucket');

		$params{bucket} = Net::Amazon::S3::Bucket->new(
			bucket => $params{bucket},
			account => $params{s3},
			(region => $region) x!! $region,
		) if $params{bucket} and ! ref $params{bucket};

		delete $params{region};
	}

    $class->$orig( %params );
};

has bucket => (
    is => 'ro',
    isa => 'Net::Amazon::S3::Bucket',
    required => 1,
);

1;

