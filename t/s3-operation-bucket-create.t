#!perl

use strict;
use warnings;

use FindBin;

BEGIN { require "$FindBin::Bin/test-helper-operation.pl" }

expect_operation_bucket_create (
	'API'    => \& api_bucket_create,
	'Client' => \& client_bucket_create,
);

had_no_warnings;

done_testing;

sub api_bucket_create {
	my (%args) = @_;

	build_default_api->add_bucket (\ %args);
}

sub client_bucket_create {
	my (%args) = @_;

	build_default_client->create_bucket (name => delete $args{bucket}, %args);
}

sub expect_operation_bucket_create {
	expect_operation_plan
		implementations => +{ @_ },
		expect_operation => 'Net::Amazon::S3::Operation::Bucket::Create',
		plan => {
			"create bucket with name" => {
				act_arguments => [
					bucket => 'bucket-name',
				],
			},
			"create bucket with location constraint" => {
				act_arguments => [
					bucket => 'bucket-name',
					location_constraint => 'eu-west-1',
				],
			},
			"create bucket with acl" => {
				act_arguments => [
					bucket    => 'bucket-name',
					acl_short => 'private',
					acl       => 'public',
				],
			},
		}
}
