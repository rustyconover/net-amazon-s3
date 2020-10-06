#!perl

use strict;
use warnings;

use FindBin;

BEGIN { require "$FindBin::Bin/test-helper-operation.pl" }

expect_operation_bucket_location (
	'API'    => \& api_bucket_location,
	'Client' => \& client_bucket_location,
);

had_no_warnings;

done_testing;

sub api_bucket_location {
	my (%args) = @_;

	build_default_api
		->bucket (delete $args{bucket})
		->get_location_constraint (\ %args)
		;
}

sub client_bucket_location {
	my (%args) = @_;

	build_default_client
		->bucket (name => delete $args{bucket})
		->location_constraint (%args)
		;
}

sub expect_operation_bucket_location {
	expect_operation_plan
		implementations => +{ @_ },
		expect_operation => 'Net::Amazon::S3::Operation::Bucket::Location',
		plan => {
			"location bucket with name" => {
				act_arguments => [
					bucket => 'bucket-name',
				],
			},
		}
}
