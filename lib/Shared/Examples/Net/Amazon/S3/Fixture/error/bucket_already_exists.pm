
use strict;
use warnings;

use HTTP::Status;
use Shared::Examples::Net::Amazon::S3::Fixture;

Shared::Examples::Net::Amazon::S3::Fixture::error_fixture
    BucketAlreadyExists => HTTP::Status::HTTP_CONFLICT;
