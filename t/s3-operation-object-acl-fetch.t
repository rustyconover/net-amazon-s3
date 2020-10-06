#!perl

use strict;
use warnings;

use FindBin;

BEGIN { require "$FindBin::Bin/test-helper-operation.pl" }

expect_operation_object_acl_fetch (
	'API'     => \& api_object_acl_fetch,
);

had_no_warnings;

done_testing;

sub api_object_acl_fetch {
	my (%args) = @_;
	build_default_api
		->bucket (delete $args{bucket})
		->get_acl ($args{key})
		;
}

sub expect_operation_object_acl_fetch {
	expect_operation_plan
		implementations => +{ @_ },
		expect_operation => 'Net::Amazon::S3::Operation::Object::Acl::Fetch',
		plan => {
			"fetch object acl" => {
				act_arguments => [
					bucket => 'bucket-name',
					key    => 'key-name',
				],
			},
		}
}
