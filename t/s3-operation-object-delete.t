#!perl

use strict;
use warnings;

use FindBin;

BEGIN { require "$FindBin::Bin/test-helper-operation.pl" }

plan tests => 4;

expect_operation_object_delete (
	'API / Bucket->delete_key' => \& api_delete_object_via_bucket,
	'API / S3->delete_key'     => \& api_delete_object_via_s3,
	'Client'                   => \& client_delete_object,
);

had_no_warnings;

done_testing;

sub api_delete_object_via_bucket {
	my (%args) = @_;

	build_default_api
		->bucket (delete $args{bucket})
		->delete_key ($args{key})
		;
}

sub api_delete_object_via_s3 {
	my (%args) = @_;

	build_default_api
		->delete_key (\ %args)
		;
}

sub client_delete_object {
	my (%args) = @_;

	build_default_client
		->bucket (name => delete $args{bucket})
		->object (key => delete $args{key})
		->delete
		;
}

sub expect_operation_object_delete {
	expect_operation_plan
		implementations => +{ @_ },
		expect_operation => 'Net::Amazon::S3::Operation::Object::Delete',
		plan => {
			"delete object" => {
				act_arguments => [
					bucket => 'bucket-name',
					key    => 'key-name',
				],
			},
		}
}
