# PODNAME: Shared::Examples::Net::Amazon::S3::Fixture::error::bucket_not_empty
# ABSTRACT: Shared::Examples providing error fixture

use strict;
use warnings;

use HTTP::Status;
use Shared::Examples::Net::Amazon::S3::Fixture;

Shared::Examples::Net::Amazon::S3::Fixture::error_fixture
    BucketNotEmpty => HTTP::Status::HTTP_CONFLICT;
