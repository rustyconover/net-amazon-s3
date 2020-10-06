#!perl

use strict;
use warnings;

use FindBin;

BEGIN { require "$FindBin::Bin/test-helper-operation.pl" }

plan tests => 3;

expect_operation_bucket_tags_set (
	'API'     => \& api_bucket_tags_set,
	'Client'  => \& client_bucket_tags_set,
);

had_no_warnings;

done_testing;

sub api_bucket_tags_set {
	my (%args) = @_;

	build_default_api
		->bucket (delete $args{bucket})
		->add_tags (\ %args)
		;
}

sub client_bucket_tags_set {
	my (%args) = @_;
	build_default_client
		->bucket (name => delete $args{bucket})
		->add_tags (%args)
		;
}

sub expect_operation_bucket_tags_set {
	expect_operation_plan
		implementations => +{ @_ },
		expect_operation => 'Net::Amazon::S3::Operation::Bucket::Tags::Add',
		plan => {
			"set tags on bucket" => {
				act_arguments => [
					bucket      => 'bucket-name',
					tags        => { foo => 'bar' },
				],
			},
		}
}
