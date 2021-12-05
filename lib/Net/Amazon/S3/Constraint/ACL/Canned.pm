package Net::Amazon::S3::Constraint::ACL::Canned;
# ABSTRACT: Moose constraint - valid Canned ACL constants

use Moose::Util::TypeConstraints;

# Current list at https://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html#canned-acl
enum __PACKAGE__, [
	'private',
	'public-read',
	'public-read-write',
	'aws-exec-read',
	'authenticated-read',
	'bucket-owner-read',
	'bucket-owner-full-control',
	'log-delivery-write',
];

# Backward compatibility - create alias
subtype 'AclShort', as __PACKAGE__;

1;

