
use strict;
use warnings;

use FindBin;
use lib $FindBin::Bin;

BEGIN { require 'test-helper-s3-request.pl' }

plan tests => 5;

behaves_like_net_amazon_s3_request 'create bucket' => (
    request_class   => 'Net::Amazon::S3::Operation::Bucket::Create::Request',
    with_bucket     => 'some-bucket',

    expect_request_method   => 'PUT',
    expect_request_uri      => 'https://some-bucket.s3.amazonaws.com/',
    expect_request_headers  => { },
    expect_request_content  => '',
);

behaves_like_net_amazon_s3_request 'create bucket with acl' => (
    request_class   => 'Net::Amazon::S3::Operation::Bucket::Create::Request',
    with_bucket     => 'some-bucket',
    with_acl_short  => 'private',

    expect_request_method   => 'PUT',
    expect_request_uri      => 'https://some-bucket.s3.amazonaws.com/',
    expect_request_headers  => { 'x-amz-acl' => 'private' },
    expect_request_content  => '',
);

behaves_like_net_amazon_s3_request 'create bucket in region' => (
    request_class   => 'Net::Amazon::S3::Operation::Bucket::Create::Request',
    with_bucket     => 'some-bucket',
    with_location_constraint => 'ca-central-1',

    expect_request_method   => 'PUT',
    expect_request_uri      => 'https://some-bucket.s3.amazonaws.com/',
    expect_request_headers  => { },
    expect_request_content  => fixture ('request::bucket_create_ca_central_1')->{content},
);

behaves_like_net_amazon_s3_request 'create bucket in region with acl' => (
    request_class   => 'Net::Amazon::S3::Operation::Bucket::Create::Request',
    with_bucket     => 'some-bucket',
    with_acl_short  => 'private',
    with_location_constraint => 'ca-central-1',

    expect_request_method   => 'PUT',
    expect_request_uri      => 'https://some-bucket.s3.amazonaws.com/',
    expect_request_headers  => { 'x-amz-acl' => 'private' },
    expect_request_content  => fixture ('request::bucket_create_ca_central_1')->{content},
);

had_no_warnings;

done_testing;
