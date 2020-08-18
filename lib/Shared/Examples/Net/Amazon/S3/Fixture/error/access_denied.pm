# PODNAME: Shared::Examples::Net::Amazon::S3::Fixture::error::access_denied
# ABSTRACT: Shared::Examples providing error fixture

use strict;
use warnings;

use HTTP::Status;
use Shared::Examples::Net::Amazon::S3::Fixture;

Shared::Examples::Net::Amazon::S3::Fixture::error_fixture
    AccessDenied => HTTP::Status::HTTP_FORBIDDEN;
