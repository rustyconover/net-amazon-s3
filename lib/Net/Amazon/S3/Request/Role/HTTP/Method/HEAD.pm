package Net::Amazon::S3::Request::Role::HTTP::Method::HEAD;
# ABSTRACT: HTTP HEAD method role

use Moose::Role;

with 'Net::Amazon::S3::Request::Role::HTTP::Method' => { method => 'HEAD' };

1;

