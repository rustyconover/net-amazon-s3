
use strict;
use warnings;

use FindBin;

BEGIN { require "$FindBin::Bin/test-helper-s3-api.pl" }
BEGIN { require "$FindBin::Bin/test-helper-tags.pl" }

use Shared::Examples::Net::Amazon::S3::API qw[ expect_api_object_tags_add ];

plan tests => 5;

expect_api_object_tags_add 'add tags to an object' => (
	with_bucket             => 'some-bucket',
	with_key                => 'some-key',
	with_tags               => fixture_tags_foo_bar_hashref,
	with_response_fixture ('response::http_ok_empty'),

	expect_request          => { PUT => 'https://some-bucket.s3.amazonaws.com/some-key?tagging' },
	expect_request_content  => fixture_tags_foo_bar_xml,
	expect_request_headers  => {
		content_type => 'application/xml',
	},
	expect_data             => bool (1),
);

expect_api_object_tags_add 'S3 error - Access Denied' => (
	with_bucket             => 'some-bucket',
	with_key                => 'some-key',
	with_tags               => fixture_tags_foo_bar_hashref,
	with_response_fixture ('error::access_denied'),
	expect_request          => { PUT => 'https://some-bucket.s3.amazonaws.com/some-key?tagging' },
	expect_s3_error_access_denied,
);

expect_api_object_tags_add 'S3 error - Bucket Not Found' => (
	with_bucket             => 'some-bucket',
	with_key                => 'some-key',
	with_tags               => fixture_tags_foo_bar_hashref,
	with_response_fixture ('error::no_such_bucket'),
	expect_request          => { PUT => 'https://some-bucket.s3.amazonaws.com/some-key?tagging' },
	expect_s3_error_bucket_not_found,
);

expect_api_object_tags_add 'HTTP error - 400 Bad Request' => (
	with_bucket             => 'some-bucket',
	with_key                => 'some-key',
	with_tags               => fixture_tags_foo_bar_hashref,
	with_response_fixture ('error::http_bad_request'),
	expect_request          => { PUT => 'https://some-bucket.s3.amazonaws.com/some-key?tagging' },
	expect_http_error_bad_request,
);

had_no_warnings;

done_testing;
