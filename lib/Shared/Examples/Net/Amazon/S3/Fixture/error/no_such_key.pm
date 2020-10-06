# PODNAME: Shared::Examples::Net::Amazon::S3::Fixture::error::no_such_key
# ABSTRACT: Shared::Examples providing error fixture

use strict;
use warnings;

use HTTP::Status;
use Shared::Examples::Net::Amazon::S3::Fixture;

Shared::Examples::Net::Amazon::S3::Fixture::error_fixture
	NoSuchKey => HTTP::Status::HTTP_NOT_FOUND,
	;
