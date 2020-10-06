#!perl

use strict;
use warnings;

use FindBin;

BEGIN { require "$FindBin::Bin/test-helper-operation.pl" }

plan tests => 5;

expect_operation_object_tags_set (
	'API'     => \& api_object_tags_set,
	'Client'  => \& client_object_tags_set,
);

had_no_warnings;

done_testing;

sub api_object_tags_set {
	my (%args) = @_;

	build_default_api
		->bucket (delete $args{bucket})
		->add_tags (\ %args)
		;
}

sub client_object_tags_set {
	my (%args) = @_;
	build_default_client
		->bucket (name => delete $args{bucket})
		->object (key => delete $args{key})
		->add_tags (%args)
		;
}

sub expect_operation_object_tags_set {
	expect_operation_plan
		implementations => +{ @_ },
		expect_operation => 'Net::Amazon::S3::Operation::Object::Tags::Add',
		plan => {
			"set tags on object" => {
				act_arguments => [
					bucket      => 'bucket-name',
					key         => 'some-key',
					tags        => { foo => 'bar' },
				],
			},
			"set tags on object version" => {
				act_arguments => [
					bucket      => 'bucket-name',
					key         => 'some-key',
					version_id  => 'foo',
					tags        => { foo => 'bar' },
				],
			},
		}
}
