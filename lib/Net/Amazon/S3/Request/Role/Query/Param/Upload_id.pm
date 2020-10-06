package Net::Amazon::S3::Request::Role::Query::Param::Upload_id;
# ABSTRACT: upload_id query param role

use Moose::Role;

with 'Net::Amazon::S3::Request::Role::Query::Param' => {
	param => 'upload_id',
	query_param => 'uploadId',
	constraint => 'Str',
	required => 1,
};

1;

