# PODNAME: Shared::Examples::Net::Amazon::S3::Fixture::request::bucket_create_ca_central_1
# ABSTRACT: Shared::Examples providing request fixture

use strict;
use warnings;

use Shared::Examples::Net::Amazon::S3::Fixture;

Shared::Examples::Net::Amazon::S3::Fixture::fixture content => <<'XML';
<CreateBucketConfiguration>
  <LocationConstraint>ca-central-1</LocationConstraint>
</CreateBucketConfiguration>
XML
