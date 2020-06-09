package Net::Amazon::S3::Request::Role::Query::Action::Restore;
# ABSTRACT: uploads query action role

use Moose::Role;

with 'Net::Amazon::S3::Request::Role::Query::Action' => { action => 'restore' };

1;
