#!perl

use strict;
use warnings;

use FindBin;
use lib $FindBin::Bin;

BEGIN { require 'test-helper-s3-request.pl' }

plan tests => 4;

behaves_like_net_amazon_s3_request 'put object' => (
    request_class   => 'Net::Amazon::S3::Operation::Object::Add::Request',
    with_bucket     => 'some-bucket',
    with_key        => 'some/key',
    with_value      => 'foo',

    expect_request_method   => 'PUT',
    expect_request_uri      => 'https://some-bucket.s3.amazonaws.com/some/key',
    expect_request_headers  => { },
);

behaves_like_net_amazon_s3_request 'put object with acl' => (
    request_class   => 'Net::Amazon::S3::Operation::Object::Add::Request',
    with_bucket     => 'some-bucket',
    with_key        => 'some/key',
    with_acl_short  => 'private',
    with_value      => 'foo',

    expect_request_method   => 'PUT',
    expect_request_uri      => 'https://some-bucket.s3.amazonaws.com/some/key',
    expect_request_headers  => { 'x-amz-acl' => 'private' },
);

behaves_like_net_amazon_s3_request 'put object with service side encryption' => (
    request_class   => 'Net::Amazon::S3::Operation::Object::Add::Request',
    with_bucket     => 'some-bucket',
    with_key        => 'some/key',
    with_encryption => 'AES256',
    with_value      => 'foo',

    expect_request_method   => 'PUT',
    expect_request_uri      => 'https://some-bucket.s3.amazonaws.com/some/key',
    expect_request_headers  => { 'x-amz-server-side-encryption' => 'AES256' },
);

had_no_warnings;

done_testing;

