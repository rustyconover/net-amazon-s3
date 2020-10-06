#!perl

use strict;
use warnings;

use FindBin;

BEGIN { require "$FindBin::Bin/test-helper-operation.pl" }

expect_operation_bucket_acl_fetch (
	'API'     => \& api_bucket_acl_fetch,
	'Client'  => \& client_bucket_acl_fetch,
);

had_no_warnings;

done_testing;

sub api_bucket_acl_fetch {
	my (%args) = @_;
	build_default_api
		->bucket (delete $args{bucket})
		->get_acl
		;
}

sub client_bucket_acl_fetch {
	my (%args) = @_;
	build_default_client
		->bucket (name => delete $args{bucket})
		->acl
		;
}

sub expect_operation_bucket_acl_fetch {
	expect_operation_plan
		implementations => +{ @_ },
		expect_operation => 'Net::Amazon::S3::Operation::Bucket::Acl::Fetch',
		plan => {
			"fetch bucket acl" => {
				act_arguments => [
					bucket => 'bucket-name',
				],
			},
		}
}
