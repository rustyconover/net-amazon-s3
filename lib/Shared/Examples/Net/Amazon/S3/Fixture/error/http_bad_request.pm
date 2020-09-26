# PODNAME: Shared::Examples::Net::Amazon::S3::Fixture::error::http_bad_request
# ABSTRACT: Shared::Examples providing error fixture

use strict;
use warnings;

use HTTP::Status;
use Shared::Examples::Net::Amazon::S3::Fixture;

+{
	response_code  => HTTP::Status::HTTP_BAD_REQUEST,
};
