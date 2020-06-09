
use strict;
use warnings;

use Shared::Examples::Net::Amazon::S3::Fixture;

Shared::Examples::Net::Amazon::S3::Fixture::fixture content => <<'XML';
<CreateBucketConfiguration>
  <LocationConstraint>ca-central-1</LocationConstraint>
</CreateBucketConfiguration>
XML
