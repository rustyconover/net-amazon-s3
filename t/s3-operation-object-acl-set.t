#!perl

use strict;
use warnings;

use FindBin;

BEGIN { require "$FindBin::Bin/test-helper-operation.pl" }

plan tests => 3;

expect_operation_object_acl_set (
	'API'     => \& api_object_acl_set,
	'Client'  => \& client_object_acl_set,
);

had_no_warnings;

done_testing;

sub api_object_acl_set {
	my (%args) = @_;

	build_default_api
		->bucket (delete $args{bucket})
		->set_acl (\ %args)
		;
}

sub client_object_acl_set {
	my (%args) = @_;
	build_default_client
		->bucket (name => delete $args{bucket})
		->object (key => delete $args{key})
		->set_acl (%args)
		;
}

sub expect_operation_object_acl_set {
	expect_operation_plan
		implementations => +{ @_ },
		expect_operation => 'Net::Amazon::S3::Operation::Object::Acl::Set',
		plan => {
			"set object acl" => {
				act_arguments => [
					bucket      => 'bucket-name',
					key         => 'some-key',
					acl         => 'private',
					acl_short   => 'public',
					acl_xml     => 'some xml placeholder',
				],
			},
		}
}
