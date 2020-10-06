#!perl

use strict;
use warnings;

use FindBin;

BEGIN { require "$FindBin::Bin/test-helper-operation.pl" }

expect_operation_bucket_acl_set (
	'API'     => \& api_bucket_acl_set,
	'Client'  => \& client_bucket_acl_set,
);

had_no_warnings;

done_testing;

sub api_bucket_acl_set {
	my (%args) = @_;

	build_default_api
		->bucket (delete $args{bucket})
		->set_acl (\ %args)
		;
}

sub client_bucket_acl_set {
	my (%args) = @_;
	build_default_client
		->bucket (name => delete $args{bucket})
		->set_acl (%args)
		;
}

sub expect_operation_bucket_acl_set {
	expect_operation_plan
		implementations => +{ @_ },
		expect_operation => 'Net::Amazon::S3::Operation::Bucket::Acl::Set',
		plan => {
			"set bucket acl" => {
				act_arguments => [
					bucket      => 'bucket-name',
					acl         => 'private',
					acl_short   => 'public',
					acl_xml     => 'some xml placeholder',
				],
			},
		}
}
