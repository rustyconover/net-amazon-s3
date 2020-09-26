# PODNAME: Shared::Examples::Net::Amazon::S3::Fixture::response::http_ok_empty
# ABSTRACT: Shared::Examples providing response fixture

use strict;
use warnings;

use HTTP::Status;
use Shared::Examples::Net::Amazon::S3::Fixture;

Shared::Examples::Net::Amazon::S3::Fixture::fixture (
	content_type => undef,
);

