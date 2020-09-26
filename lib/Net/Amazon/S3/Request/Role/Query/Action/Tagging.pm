package Net::Amazon::S3::Request::Role::Query::Action::Tagging;
# ABSTRACT: tagging query action role

use Moose::Role;

with 'Net::Amazon::S3::Request::Role::Query::Action' => { action => 'tagging' };

1;

