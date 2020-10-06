package Net::Amazon::S3::Request::Role::Query::Param::Part_number;
# ABSTRACT: partNumber query param role

use Moose::Role;

with 'Net::Amazon::S3::Request::Role::Query::Param' => {
	param => 'part_number',
	query_param => 'partNumber',
	constraint => 'Int',
	required => 1,
};

1;

