# PODNAME: Shared::Examples::Net::Amazon::S3::Fixture::response::bucket_objects_list_v1_with_prefix_and_delimiter
# ABSTRACT: Shared::Examples providing response fixture

use strict;
use warnings;

use Shared::Examples::Net::Amazon::S3::Fixture;

Shared::Examples::Net::Amazon::S3::Fixture::fixture content => <<'XML';
<?xml version="1.0" encoding="UTF-8"?>
<ListBucketResult xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
	<Name>some-bucket</Name>
	<Prefix>photos/2006/</Prefix>
	<Marker></Marker>
	<MaxKeys>1000</MaxKeys>
	<Delimiter>/</Delimiter>
	<IsTruncated>false</IsTruncated>

	<CommonPrefixes>
		<Prefix>photos/2006/February/</Prefix>
	</CommonPrefixes>
	<CommonPrefixes>
		<Prefix>photos/2006/January/</Prefix>
	</CommonPrefixes>
</ListBucketResult>
XML
