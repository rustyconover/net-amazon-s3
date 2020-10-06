#!perl

use strict;
use warnings;

use FindBin;

BEGIN { require "$FindBin::Bin/test-helper-operation.pl" }

plan tests => 6;

expect_operation_objects_list_api (
	"API / S3->list_bucket"     => \& api_objects_list,
	"API / S3->list_bucket_all" => \& api_objects_list_all,
	"API / Bucket->list"        => \& api_objects_bucket_list,
	"API / Bucket->list_all"    => \& api_objects_bucket_list_all,
);

expect_operation_objects_list_client (
	"Client" => \& client_objects_list,
);

had_no_warnings;

done_testing;

sub api_objects_list {
	my (%args) = @_;

	build_default_api->list_bucket (\ %args);
}

sub api_objects_list_all {
	my (%args) = @_;

	build_default_api->list_bucket_all (\ %args);
}

sub api_objects_bucket_list {
	my (%args) = @_;

	build_default_api
		->bucket (delete $args{bucket})
		->list (\ %args)
		;
}

sub api_objects_bucket_list_all {
	my (%args) = @_;

	build_default_api
		->bucket (delete $args{bucket})
		->list_all (\ %args)
		;
}

sub client_objects_list {
	my (%args) = @_;

	build_default_client
		->bucket (name => delete $args{bucket})
		->list (\ %args)
		->next
		;
}

sub expect_operation_objects_list_api {
	expect_operation_plan
		implementations => +{ @_ },
		expect_operation => 'Net::Amazon::S3::Operation::Objects::List',
		plan => {
			"list buckets" => {
				act_arguments => [
					bucket      => 'bucket-name',
					delimiter   => 'd',
					max_keys    => 1_000,
					marker      => 'm',
					prefix      => 'p'
				],
			},
		}
}

sub expect_operation_objects_list_client {
	expect_operation_plan
		implementations => +{ @_ },
		expect_operation => 'Net::Amazon::S3::Operation::Objects::List',
		plan => {
			"list buckets" => {
				act_arguments => [
					bucket      => 'bucket-name',
					delimiter   => 'd',
					marker      => 'm',
					prefix      => 'p'
				],
				expect_arguments => {
					bucket      => 'bucket-name',
					delimiter   => 'd',
					marker      => undef,
					prefix      => 'p'
				},
			},
		}
}
