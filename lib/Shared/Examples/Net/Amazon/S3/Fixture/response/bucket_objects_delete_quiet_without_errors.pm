# PODNAME: Shared::Examples::Net::Amazon::S3::Fixture::response::bucket_objects_delete_quiet_without_errors
# ABSTRACT: Shared::Examples providing response fixture

use strict;
use warnings;

package
	Shared::Examples::Net::Amazon::S3::Fixture::bucket::objects::delete::quiet_without_errors;

use HTTP::Status;
use Shared::Examples::Net::Amazon::S3::Fixture qw[ fixture ];

fixture content => <<'XML';
<?xml version="1.0" encoding="UTF-8"?>
<DeleteResult xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
</DeleteResult>
XML
