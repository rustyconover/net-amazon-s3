# PODNAME: Shared::Examples::Net::Amazon::S3::Fixture::error::invalid_bucket_name
# ABSTRACT: Shared::Examples providing error fixture

use strict;
use warnings;

use HTTP::Status;
use Shared::Examples::Net::Amazon::S3::Fixture;

Shared::Examples::Net::Amazon::S3::Fixture::error_fixture
    InvalidBucketName => HTTP::Status::HTTP_BAD_REQUEST;
