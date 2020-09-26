
use strict;
use warnings;

use FindBin;

BEGIN { require "$FindBin::Bin/test-helper-s3-api.pl" }

use Shared::Examples::Net::Amazon::S3::API qw[ expect_api_bucket_acl_set ];

plan tests => 6;

expect_api_bucket_acl_set 'set bucket acl using canned acl header' => (
    with_bucket             => 'some-bucket',
    with_acl_short          => 'private',
    with_response_fixture ('response::acl'),
    expect_request          => { PUT => 'https://some-bucket.s3.amazonaws.com/?acl' },
    expect_request_content  => '',
    expect_request_headers  => {
        x_amz_acl => 'private',
    },
    expect_data             => bool (1),
);

expect_api_bucket_acl_set 'set bucket acl using ACL content' => (
    with_bucket             => 'some-bucket',
    with_acl_xml            => 'PASSTHROUGH',
    expect_request          => { PUT => 'https://some-bucket.s3.amazonaws.com/?acl' },
    expect_request_content  => 'PASSTHROUGH',
    expect_request_headers  => {
        x_amz_acl => undef,
    },
    expect_data             => bool (1),
);

expect_api_bucket_acl_set 'S3 error - Access Denied' => (
    with_bucket             => 'some-bucket',
    with_acl_short          => 'private',
    with_response_fixture ('error::access_denied'),
    expect_request          => { PUT => 'https://some-bucket.s3.amazonaws.com/?acl' },
    expect_data             => bool (0),
    expect_s3_err           => 'AccessDenied',
    expect_s3_errstr        => 'Access denied error message',
);

expect_api_bucket_acl_set 'S3 error - Bucket Not Found' => (
    with_bucket             => 'some-bucket',
    with_acl_short          => 'private',
    with_response_fixture ('error::no_such_bucket'),
    expect_request          => { PUT => 'https://some-bucket.s3.amazonaws.com/?acl' },
    expect_data             => bool (0),
    expect_s3_err           => 'NoSuchBucket',
    expect_s3_errstr        => 'No such bucket error message',
);

expect_api_bucket_acl_set 'HTTP error - 400 Bad Request' => (
    with_bucket             => 'some-bucket',
    with_acl_short          => 'private',
    with_response_fixture ('error::http_bad_request'),
    expect_request          => { PUT => 'https://some-bucket.s3.amazonaws.com/?acl' },
    expect_data             => bool (0),
    expect_s3_err           => '',
    expect_s3_errstr        => '',
);

had_no_warnings;

done_testing;
