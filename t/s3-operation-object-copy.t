#!perl

use strict;
use warnings;

use FindBin;

BEGIN { require "$FindBin::Bin/test-helper-operation.pl" }

plan tests => 2;

expect_operation_object_copy (
	'API'   => \& api_object_copy,
);

had_no_warnings;

done_testing;

sub api_object_copy {
	my (%args) = @_;

	%args = (
		%args,
		%{ $args{headers} },
		map +( "x_amz_meta_$_" => $args{metadata}{$_} ), keys %{ $args{metadata} }
	);

	delete $args{headers};
	delete $args{metadata};

	build_default_api
		->bucket (delete $args{bucket})
		->copy_key (
			delete $args{key},
			delete $args{source},
			\ %args
		);
}

sub expect_operation_object_copy {
	expect_operation_plan
		implementations => +{ @_ },
		expect_operation => 'Net::Amazon::S3::Operation::Object::Add',
		plan => {
			"copy key" => {
				act_arguments => [
					bucket      => 'bucket-name',
					key         => 'some-key',
					source      => 'source-key',
					acl_short   => 'object-acl',
					encryption  => 'object-encryption',
					headers     => {
						expires     => 2_345_567_890,
						content_encoding => 'content-encoding',
						x_amz_storage_class => 'storage-class',
						x_amz_website_redirect_location => 'location-value',
					},
					metadata => {
						foo => 'foo-value',
					},
				],
				expect_arguments => {
					bucket      => 'bucket-name',
					key         => 'some-key',
					value       => '',
					acl_short   => 'object-acl',
					encryption  => 'object-encryption',
					headers     => {
						expires     => 2_345_567_890,
						content_encoding => 'content-encoding',
						x_amz_storage_class => 'storage-class',
						x_amz_website_redirect_location => 'location-value',
						x_amz_meta_foo => 'foo-value',
						'x-amz-metadata-directive' => 'REPLACE',
						'x-amz-copy-source'        => 'source-key',
					}
				},
			},
		}
}

