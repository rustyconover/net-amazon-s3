#!perl

use strict;
use warnings;

use FindBin;

BEGIN { require "$FindBin::Bin/test-helper-operation.pl" }

expect_operation_object_fetch (
	'API / fetch into variable' => \& api_object_fetch,
	'API / fetch into file'     => \& api_object_fetch_file,
);

expect_operation_object_fetch_content (
	'Client' => \& client_object_fetch_content,
	'Client' => \& client_object_fetch_decoded_content,
);

expect_operation_object_fetch_filename (
	'API' => \& api_object_fetch_filename,
	'Client' => \& client_object_fetch_filename,
);

expect_operation_object_fetch_callback (
	'Client' => \& client_object_fetch_callback,
);

had_no_warnings;

done_testing;

sub api_object_fetch {
	my (%args) = @_;

	build_default_api
		->bucket (delete $args{bucket})
		->get_key (
			$args{key},
			$args{method},
			$args{filename},
		)
		;
}

sub api_object_fetch_file {
	my (%args) = @_;

	build_default_api
		->bucket (delete $args{bucket})
		->get_key (
			$args{key},
			$args{method},
			\ $args{filename},
		)
		;
}

sub api_object_fetch_filename {
	my (%args) = @_;

	build_default_api
		->bucket (delete $args{bucket})
		->get_key_filename (
			$args{key},
			$args{method},
			$args{filename},
		)
		;
}

sub client_object_fetch_content {
	my (%args) = @_;

	build_default_client
		->bucket (name => delete $args{bucket})
		->object (key => delete $args{key})
		->get
		;
}

sub client_object_fetch_decoded_content {
	my (%args) = @_;

	build_default_client
		->bucket (name => delete $args{bucket})
		->object (key => delete $args{key})
		->get_decoded
		;
}

sub client_object_fetch_filename {
	my (%args) = @_;

	build_default_client
		->bucket (name => delete $args{bucket})
		->object (key => delete $args{key})
		->get_filename ($args{filename})
		;
}

sub client_object_fetch_callback {
	my (%args) = @_;

	build_default_client
		->bucket (name => delete $args{bucket})
		->object (key => delete $args{key})
		->get_callback ($args{filename})
		;
}

sub expect_operation_object_fetch {
	expect_operation_plan
		implementations => +{ @_ },
		expect_operation => 'Net::Amazon::S3::Operation::Object::Fetch',
		plan => {
			"fetch object" => {
				act_arguments => [
					bucket => 'bucket-name',
					key    => 'key-name',
					method => 'GET',
					filename => 'foo',
				],
			},
		}
}

sub expect_operation_object_fetch_content {
	expect_operation_plan
		implementations => +{ @_ },
		expect_operation => 'Net::Amazon::S3::Operation::Object::Fetch',
		plan => {
			"fetch object content" => {
				act_arguments => [
					bucket => 'bucket-name',
					key    => 'key-name',
				],
				expect_arguments => {
					bucket => 'bucket-name',
					key    => 'key-name',
					method => 'GET',
				},
			},
		}
}

sub expect_operation_object_fetch_filename {
	expect_operation_plan
		implementations => +{ @_ },
		expect_operation => 'Net::Amazon::S3::Operation::Object::Fetch',
		plan => {
			"fetch object into file" => {
				act_arguments => [
					bucket => 'bucket-name',
					key    => 'key-name',
					method => 'GET',
					filename => 'foo',
				],
			},
		}
}

sub expect_operation_object_fetch_callback {
	expect_operation_plan
		implementations => +{ @_ },
		expect_operation => 'Net::Amazon::S3::Operation::Object::Fetch',
		plan => {
			"fetch object with callback" => {
				act_arguments => [
					bucket => 'bucket-name',
					key    => 'key-name',
					method => 'GET',
					filename => sub { },
				],
				expect_arguments => {
					bucket => 'bucket-name',
					key    => 'key-name',
					method => 'GET',
					filename => expect_coderef,
				},
			},
		}
}
