# PODNAME: Shared::Examples::Net::Amazon::S3::Fixture::error::invalid_object_state
# ABSTRACT: Shared::Examples providing error fixture

use strict;
use warnings;

use HTTP::Status;
use Shared::Examples::Net::Amazon::S3::Fixture;

Shared::Examples::Net::Amazon::S3::Fixture::error_fixture
	InvalidObjectState => HTTP::Status::HTTP_FORBIDDEN,
	q<The operation is not valid for the object's storage class>,
	;
