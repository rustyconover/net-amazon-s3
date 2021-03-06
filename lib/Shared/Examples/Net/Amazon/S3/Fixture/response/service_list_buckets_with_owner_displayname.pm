# PODNAME: Shared::Examples::Net::Amazon::S3::Fixture::response::service_list_buckets_with_owner_displayname
# ABSTRACT: Shared::Examples providing response fixture

use strict;
use warnings;

use Shared::Examples::Net::Amazon::S3::Fixture;

Shared::Examples::Net::Amazon::S3::Fixture::fixture content => <<'XML';
<?xml version="1.0" encoding="UTF-8"?>
<ListAllMyBucketsResult xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
	<Owner>
		<ID>bcaf1ffd86f461ca5fb16fd081034f</ID>
		<DisplayName>webfile</DisplayName>
	</Owner>
	<Buckets>
		<Bucket>
			<Name>quotes</Name>
			<CreationDate>2006-02-03T16:45:09.000Z</CreationDate>
		</Bucket>
		<Bucket>
			<Name>samples</Name>
			<CreationDate>2006-02-03T16:41:58.000Z</CreationDate>
		</Bucket>
	</Buckets>
</ListAllMyBucketsResult>
XML
