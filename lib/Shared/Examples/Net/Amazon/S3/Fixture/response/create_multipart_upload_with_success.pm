# PODNAME: Shared::Examples::Net::Amazon::S3::Fixture::response::create-multipart-upload-with-success
# ABSTRACT: Shared::Examples providing response fixture

use strict;
use warnings;

use Shared::Examples::Net::Amazon::S3::Fixture;

Shared::Examples::Net::Amazon::S3::Fixture::fixture content => <<'XML';
<?xml version="1.0" encoding="UTF-8"?>
<InitiateMultipartUploadResult xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
  <Bucket>bucket-name</Bucket>
  <Key>key-name</Key>
  <UploadId>new-upload-id</UploadId>
</InitiateMultipartUploadResult>
XML
