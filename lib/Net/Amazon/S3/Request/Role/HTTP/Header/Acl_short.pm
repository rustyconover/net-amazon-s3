package Net::Amazon::S3::Request::Role::HTTP::Header::Acl_short;
# ABSTRACT: x-amz-acl header role

use Moose::Role;

use Net::Amazon::S3::Constants;

with 'Net::Amazon::S3::Request::Role::HTTP::Header' => {
    name => 'acl_short',
    header => Net::Amazon::S3::Constants->HEADER_CANNED_ACL,
    isa => 'Maybe[AclShort]',
    required => 0,
};

1;
