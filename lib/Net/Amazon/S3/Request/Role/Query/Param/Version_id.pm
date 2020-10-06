package Net::Amazon::S3::Request::Role::Query::Param::Version_id;
# ABSTRACT: version_id query param role

use Moose::Role;

with 'Net::Amazon::S3::Request::Role::Query::Param' => {
	param => 'version_id',
	query_param => 'versionId',
	constraint => 'Str',
	required => 0,
};

1;

