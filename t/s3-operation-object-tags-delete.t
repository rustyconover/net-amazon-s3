#!perl

use strict;
use warnings;

use FindBin;

BEGIN { require "$FindBin::Bin/test-helper-operation.pl" }

plan tests => 5;

expect_operation_object_tags_delete (
	'API'     => \& api_object_tags_delete,
	'Client'  => \& client_object_tags_delete,
);

had_no_warnings;

done_testing;

sub api_object_tags_delete {
	my (%args) = @_;

	build_default_api
		->bucket (delete $args{bucket})
		->delete_tags (\ %args)
		;
}

sub client_object_tags_delete {
	my (%args) = @_;
	build_default_client
		->bucket (name => delete $args{bucket})
		->object (key => delete $args{key})
		->delete_tags (%args)
		;
}

sub expect_operation_object_tags_delete {
	expect_operation_plan
		implementations => +{ @_ },
		expect_operation => 'Net::Amazon::S3::Operation::Object::Tags::Delete',
		plan => {
			"delete tags from object" => {
				act_arguments => [
					bucket      => 'bucket-name',
					key         => 'some-key',
				],
			},
			"delete tags from object version" => {
				act_arguments => [
					bucket      => 'bucket-name',
					key         => 'some-key',
					version_id  => 'foo',
				],
			},
		}
}
