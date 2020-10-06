package Net::Amazon::S3::Request::Role::Query::Param::Marker;
# ABSTRACT: marker query param role

use Moose::Role;

with 'Net::Amazon::S3::Request::Role::Query::Param' => {
	param => 'marker',
	constraint => 'Maybe[Str]',
	required => 0,
};

1;

