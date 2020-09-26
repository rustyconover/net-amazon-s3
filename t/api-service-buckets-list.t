
use strict;
use warnings;

use FindBin;

BEGIN { require "$FindBin::Bin/test-helper-s3-api.pl" }

plan tests => 5;

use Shared::Examples::Net::Amazon::S3::API qw[ expect_api_list_all_my_buckets ];

expect_api_list_all_my_buckets 'list all my buckets with displayname' => (
    with_response_fixture ('response::service_list_buckets_with_owner_displayname'),
    expect_request      => { GET => 'https://s3.amazonaws.com/' },
    expect_data         => {
        owner_id => 'bcaf1ffd86f461ca5fb16fd081034f',
        owner_displayname => 'webfile',
        buckets => [
            all (
                obj_isa ('Net::Amazon::S3::Bucket'),
                methods (bucket => 'quotes'),
            ),
            all (
                obj_isa ('Net::Amazon::S3::Bucket'),
                methods (bucket => 'samples'),
            ),
        ],
    },
);

expect_api_list_all_my_buckets 'list all my buckets without displayname' => (
    with_response_fixture ('response::service_list_buckets_without_owner_displayname'),
    expect_request      => { GET => 'https://s3.amazonaws.com/' },
    expect_data         => {
        owner_id => 'bcaf1ffd86f461ca5fb16fd081034f',
        owner_displayname => '',
        buckets => [
            all (
                obj_isa ('Net::Amazon::S3::Bucket'),
                methods (bucket => 'quotes'),
            ),
            all (
                obj_isa ('Net::Amazon::S3::Bucket'),
                methods (bucket => 'samples'),
            ),
        ],
    },
);

expect_api_list_all_my_buckets 'S3 error - Access Denied' => (
    with_response_fixture ('error::access_denied'),
    expect_request      => { GET => 'https://s3.amazonaws.com/' },
    expect_data         => bool (0),
    expect_s3_err       => 'AccessDenied',
    expect_s3_errstr    => 'Access denied error message',
);

expect_api_list_all_my_buckets 'HTTP error - 400 Bad Request' => (
    with_response_fixture ('error::http_bad_request'),
    expect_request          => { GET => 'https://s3.amazonaws.com/' },
    expect_data             => bool (0),
    expect_s3_err           => undef,
    expect_s3_errstr        => undef,
);

had_no_warnings;

done_testing;
