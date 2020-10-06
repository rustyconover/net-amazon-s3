#!perl

use strict;
use warnings;

use FindBin;

BEGIN { require "$FindBin::Bin/test-helper-operation.pl" }

plan tests => 3;

expect_operation_bucket_tags_delete (
	'API'     => \& api_bucket_tags_delete,
	'Client'  => \& client_bucket_tags_delete,
);

had_no_warnings;

done_testing;

sub api_bucket_tags_delete {
	my (%args) = @_;

	build_default_api
		->bucket (delete $args{bucket})
		->delete_tags (\ %args)
		;
}

sub client_bucket_tags_delete {
	my (%args) = @_;
	build_default_client
		->bucket (name => delete $args{bucket})
		->delete_tags (%args)
		;
}

sub expect_operation_bucket_tags_delete {
	expect_operation_plan
		implementations => +{ @_ },
		expect_operation => 'Net::Amazon::S3::Operation::Bucket::Tags::Delete',
		plan => {
			"delete tags from bucket" => {
				act_arguments => [
					bucket      => 'bucket-name',
				],
			},
		}
}
