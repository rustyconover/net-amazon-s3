
use strict;
use warnings;

use FindBin;

BEGIN { require "$FindBin::Bin/test-helper-s3-client.pl" }

use Shared::Examples::Net::Amazon::S3::Client qw[ expect_client_object_delete ];

plan tests => 6;

expect_client_object_delete 'delete object' => (
	with_bucket             => 'some-bucket',
	with_key                => 'some-key',
	expect_request          => { DELETE => 'https://some-bucket.s3.amazonaws.com/some-key' },
	expect_data             => bool (1),
);

expect_client_object_delete 'S3 error - Access Denied' => (
	with_bucket             => 'some-bucket',
	with_key                => 'some-key',
	with_response_fixture ('error::access_denied'),
	expect_request          => { DELETE => 'https://some-bucket.s3.amazonaws.com/some-key' },
	expect_s3_error_access_denied,
);

expect_client_object_delete 'S3 error - No Such Bucket' => (
	with_bucket             => 'some-bucket',
	with_key                => 'some-key',
	with_response_fixture ('error::no_such_bucket'),
	expect_request          => { DELETE => 'https://some-bucket.s3.amazonaws.com/some-key' },
	expect_s3_error_bucket_not_found,
);

expect_client_object_delete 'S3 error - No Such Key' => (
	with_bucket             => 'some-bucket',
	with_key                => 'some-key',
	with_response_fixture ('error::no_such_key'),
	expect_request          => { DELETE => 'https://some-bucket.s3.amazonaws.com/some-key' },
	expect_s3_error_object_not_found,
);

expect_client_object_delete 'HTTP error - 400 Bad Request' => (
	with_bucket             => 'some-bucket',
	with_key                => 'some-key',
	with_response_fixture ('error::http_bad_request'),
	expect_request          => { DELETE => 'https://some-bucket.s3.amazonaws.com/some-key' },
	expect_http_error_bad_request,
);

had_no_warnings;

done_testing;
